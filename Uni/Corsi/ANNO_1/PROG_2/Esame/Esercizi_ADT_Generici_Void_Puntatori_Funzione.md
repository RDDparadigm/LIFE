# Programmazione 2 — Esercizi su ADT generici, `void *` e puntatori a funzione

> Raccolta progressiva in stile esame: consegna, struttura di partenza, soluzione semplice, eventuale soluzione elegante o ottimizzata, complessità, ownership, casi limite ed errori tipici.
>
> Focus:
>
> - dichiarazione e uso dei puntatori a funzione;
> - callback;
> - funzioni generiche su array;
> - `void *` e perdita del type checking;
> - ADT opachi separati in `.h` e `.c`;
> - shallow copy e deep copy;
> - ownership borrowed, owned e transferred;
> - comparatori, predicati, clone e distruttori;
> - vettori, liste, pile, code, set e priority queue generici;
> - strutture eterogenee con tag;
> - esercizi misti in stile esame;
> - problemi finali “infernali”.

Compilazione consigliata:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    -g -fsanitize=address,undefined file.c -o file
```

---

# 0. Convenzioni e tipi di callback

## 0.1 Tipi fondamentali

```c
#include <stddef.h>
#include <stdio.h>

typedef int (*CompareFn)(
    const void *a,
    const void *b
);

typedef _Bool (*EqualFn)(
    const void *a,
    const void *b
);

typedef _Bool (*PredicateFn)(
    const void *element
);

typedef void (*VisitFn)(
    void *element
);

typedef void (*ConstVisitFn)(
    const void *element
);

typedef void *(*CloneFn)(
    const void *element
);

typedef void (*DestroyFn)(
    void *element
);

typedef void *(*MapFn)(
    const void *element
);

typedef void (*ReduceFn)(
    void *accumulator,
    const void *element
);
```

## 0.2 Contratto di un comparatore

Una funzione `CompareFn` deve restituire:

```text
< 0  se a precede b
  0  se a e b sono equivalenti secondo l'ordinamento
> 0  se a segue b
```

Non è necessario restituire esattamente `-1`, `0`, `1`.

### Comparatore corretto per interi

```c
int compareInt(
    const void *a,
    const void *b
) {
    int x = *(const int *)a;
    int y = *(const int *)b;

    return (x > y) - (x < y);
}
```

### Versione rischiosa

```c
return x - y;
```

Può causare overflow.

## 0.3 Contratto di clone e destroy

Se un ADT **possiede** gli elementi:

```text
clone(element)  → crea una copia indipendente
destroy(element) → libera quella copia
```

Le due callback devono essere coerenti.

Esempio per `int` allocato dinamicamente:

```c
#include <stdlib.h>

void *cloneInt(const void *element) {
    if (element == NULL) {
        return NULL;
    }

    int *copy = malloc(sizeof(*copy));

    if (copy == NULL) {
        return NULL;
    }

    *copy = *(const int *)element;
    return copy;
}

void destroyHeapObject(void *element) {
    free(element);
}
```

## 0.4 Tre modelli di ownership

### Borrowed

L'ADT conserva il puntatore, ma non possiede l'oggetto.

```text
insert(pointer)
destroy ADT → non libera gli elementi
```

### Owned by copy

L'ADT clona l'oggetto.

```text
insert(pointer)
→ clone
→ ADT possiede la copia
```

### Ownership transferred

Il chiamante cede direttamente il puntatore.

```text
insertOwned(pointer)
→ dopo il successo il chiamante non deve più liberarlo
```

Il contratto deve sempre chiarire cosa accade in caso di fallimento.

## 0.5 Regola su `void *`

Un `void *`:

- può contenere l'indirizzo di qualunque tipo di oggetto;
- non può essere dereferenziato direttamente;
- deve essere convertito al tipo corretto prima dell'accesso;
- non conserva automaticamente informazione sul tipo reale;
- non protegge da cast semanticamente sbagliati.

Questo codice compila, ma può essere errato:

```c
double d = 3.5;
void *p = &d;

int value = *(int *)p;   /* interpretazione sbagliata */
```

---

# Livello 1 — Puntatori a funzione fondamentali

---

## Esercizio 1 — Applicare un'operazione binaria

### Consegna

Scrivere una funzione che riceva due interi e una callback binaria, restituendo il risultato della callback.

### Struttura di partenza

```c
typedef int (*IntBinaryOp)(int a, int b);

int applyBinary(
    int a,
    int b,
    IntBinaryOp operation
);
```

### Soluzione semplice

```c
int applyBinary(
    int a,
    int b,
    IntBinaryOp operation
) {
    if (operation == NULL) {
        return 0;
    }

    return operation(a, b);
}
```

### Esempi di callback

```c
int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

int maximum(int a, int b) {
    return a > b ? a : b;
}
```

### Uso

```c
int x = applyBinary(3, 5, add);
int y = applyBinary(3, 5, multiply);
```

### Nota sintattica

Sono equivalenti:

```c
operation(a, b);
(*operation)(a, b);
```

---

## Esercizio 2 — Scegliere una funzione

### Consegna

Restituire una callback in base a un carattere:

```text
'+' → add
'*' → multiply
'm' → maximum
altro → NULL
```

### Struttura

```c
IntBinaryOp selectOperation(char code);
```

### Soluzione

```c
IntBinaryOp selectOperation(char code) {
    switch (code) {
        case '+':
            return add;

        case '*':
            return multiply;

        case 'm':
            return maximum;

        default:
            return NULL;
    }
}
```

### Punto d'esame

Una funzione può restituire un puntatore a funzione se il tipo di ritorno è dichiarato correttamente tramite `typedef`.

---

## Esercizio 3 — Tabella di funzioni

### Consegna

Implementare una piccola calcolatrice usando un array di puntatori a funzione.

### Struttura

```c
typedef struct {
    char symbol;
    IntBinaryOp operation;
} OperationEntry;
```

### Soluzione

```c
static const OperationEntry OPERATIONS[] = {
    {'+', add},
    {'*', multiply},
    {'m', maximum}
};

IntBinaryOp findOperation(char symbol) {
    size_t count =
        sizeof(OPERATIONS) / sizeof(OPERATIONS[0]);

    for (size_t i = 0; i < count; i++) {
        if (OPERATIONS[i].symbol == symbol) {
            return OPERATIONS[i].operation;
        }
    }

    return NULL;
}
```

### Complessità

- Tempo: `O(numero di operazioni)`
- Spazio: costante

---

## Esercizio 4 — `countIf` su array di interi

### Consegna

Contare quanti elementi di un array soddisfano un predicato.

### Struttura

```c
typedef _Bool (*IntPredicate)(int value);

size_t countIfInt(
    const int a[],
    size_t n,
    IntPredicate predicate
);
```

### Soluzione

```c
size_t countIfInt(
    const int a[],
    size_t n,
    IntPredicate predicate
) {
    if (predicate == NULL) {
        return 0;
    }

    size_t count = 0;

    for (size_t i = 0; i < n; i++) {
        if (predicate(a[i])) {
            count++;
        }
    }

    return count;
}
```

### Esempi

```c
_Bool isEven(int value) {
    return value % 2 == 0;
}

_Bool isPositive(int value) {
    return value > 0;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

---

## Esercizio 5 — Trasformazione in place

### Consegna

Applicare una funzione unaria a ogni elemento dell'array, modificandolo in place.

### Struttura

```c
typedef int (*IntTransform)(int value);

void transformIntArray(
    int a[],
    size_t n,
    IntTransform transform
);
```

### Soluzione

```c
void transformIntArray(
    int a[],
    size_t n,
    IntTransform transform
) {
    if (transform == NULL) {
        return;
    }

    for (size_t i = 0; i < n; i++) {
        a[i] = transform(a[i]);
    }
}
```

---

## Esercizio 6 — Fold su array

### Consegna

Combinare gli elementi di un array usando una callback binaria e un valore iniziale.

Esempio:

```text
fold([1,2,3], initial=0, add) → 6
fold([1,2,3], initial=1, multiply) → 6
```

### Struttura

```c
int foldInt(
    const int a[],
    size_t n,
    int initial,
    IntBinaryOp operation
);
```

### Soluzione

```c
int foldInt(
    const int a[],
    size_t n,
    int initial,
    IntBinaryOp operation
) {
    if (operation == NULL) {
        return initial;
    }

    int accumulator = initial;

    for (size_t i = 0; i < n; i++) {
        accumulator =
            operation(accumulator, a[i]);
    }

    return accumulator;
}
```

### Attenzione

Per operazioni non associative, l'ordine conta:

```text
(((initial op a[0]) op a[1]) op a[2])
```

---

# Livello 2 — Funzioni generiche su blocchi di memoria

---

## Esercizio 7 — Swap generico

### Consegna

Scambiare due oggetti di dimensione arbitraria.

### Struttura

```c
int genericSwap(
    void *a,
    void *b,
    size_t elementSize
);
```

### Soluzione semplice

```c
#include <stdlib.h>
#include <string.h>

int genericSwap(
    void *a,
    void *b,
    size_t elementSize
) {
    if (
        a == NULL ||
        b == NULL ||
        elementSize == 0
    ) {
        return 0;
    }

    unsigned char *tmp = malloc(elementSize);

    if (tmp == NULL) {
        return 0;
    }

    memcpy(tmp, a, elementSize);
    memcpy(a, b, elementSize);
    memcpy(b, tmp, elementSize);

    free(tmp);
    return 1;
}
```

### Soluzione senza heap, byte per byte

```c
void genericSwapBytes(
    void *a,
    void *b,
    size_t elementSize
) {
    unsigned char *pa = a;
    unsigned char *pb = b;

    for (size_t i = 0; i < elementSize; i++) {
        unsigned char tmp = pa[i];
        pa[i] = pb[i];
        pb[i] = tmp;
    }
}
```

### Complessità

- Tempo: `O(elementSize)`
- Spazio:
  - prima soluzione `O(elementSize)`;
  - seconda `O(1)`.

---

## Esercizio 8 — Ricerca lineare generica

### Consegna

Restituire un puntatore alla prima cella uguale a `key`, oppure `NULL`.

### Struttura

```c
void *genericFind(
    void *base,
    size_t count,
    size_t elementSize,
    const void *key,
    EqualFn equal
);
```

### Soluzione

```c
void *genericFind(
    void *base,
    size_t count,
    size_t elementSize,
    const void *key,
    EqualFn equal
) {
    if (
        base == NULL ||
        key == NULL ||
        equal == NULL ||
        elementSize == 0
    ) {
        return NULL;
    }

    unsigned char *bytes = base;

    for (size_t i = 0; i < count; i++) {
        void *element =
            bytes + i * elementSize;

        if (equal(element, key)) {
            return element;
        }
    }

    return NULL;
}
```

### Versione const-correct

```c
const void *genericFindConst(
    const void *base,
    size_t count,
    size_t elementSize,
    const void *key,
    EqualFn equal
);
```

### Punto d'esame

L'aritmetica non può essere eseguita direttamente su `void *` nello standard C. Si converte a:

```c
unsigned char *
```

per avanzare in byte.

---

## Esercizio 9 — Indice generico

### Consegna

Restituire l'indice del primo elemento uguale a `key`, oppure `count` se assente.

### Soluzione

```c
size_t genericIndexOf(
    const void *base,
    size_t count,
    size_t elementSize,
    const void *key,
    EqualFn equal
) {
    if (
        base == NULL ||
        key == NULL ||
        equal == NULL ||
        elementSize == 0
    ) {
        return count;
    }

    const unsigned char *bytes = base;

    for (size_t i = 0; i < count; i++) {
        const void *element =
            bytes + i * elementSize;

        if (equal(element, key)) {
            return i;
        }
    }

    return count;
}
```

---

## Esercizio 10 — Massimo elemento generico

### Consegna

Restituire un puntatore all'elemento massimo secondo un comparatore.

Si assume `count > 0`.

### Struttura

```c
const void *genericMax(
    const void *base,
    size_t count,
    size_t elementSize,
    CompareFn compare
);
```

### Soluzione

```c
const void *genericMax(
    const void *base,
    size_t count,
    size_t elementSize,
    CompareFn compare
) {
    if (
        base == NULL ||
        count == 0 ||
        elementSize == 0 ||
        compare == NULL
    ) {
        return NULL;
    }

    const unsigned char *bytes = base;
    const void *best = bytes;

    for (size_t i = 1; i < count; i++) {
        const void *current =
            bytes + i * elementSize;

        if (compare(current, best) > 0) {
            best = current;
        }
    }

    return best;
}
```

### Ownership

Il puntatore restituito punta dentro l'array originale:

```text
non deve essere liberato
diventa invalido se l'array viene liberato o riallocato
```

---

## Esercizio 11 — `forEach` generico

### Consegna

Applicare una callback mutabile a ogni elemento.

### Struttura

```c
void genericForEach(
    void *base,
    size_t count,
    size_t elementSize,
    VisitFn visit
);
```

### Soluzione

```c
void genericForEach(
    void *base,
    size_t count,
    size_t elementSize,
    VisitFn visit
) {
    if (
        base == NULL ||
        elementSize == 0 ||
        visit == NULL
    ) {
        return;
    }

    unsigned char *bytes = base;

    for (size_t i = 0; i < count; i++) {
        visit(bytes + i * elementSize);
    }
}
```

### Esempio

```c
void doubleInt(void *element) {
    int *value = element;
    *value *= 2;
}
```

---

## Esercizio 12 — Conteggio generico

### Consegna

Contare gli elementi che soddisfano un predicato generico.

### Soluzione

```c
size_t genericCountIf(
    const void *base,
    size_t count,
    size_t elementSize,
    PredicateFn predicate
) {
    if (
        base == NULL ||
        elementSize == 0 ||
        predicate == NULL
    ) {
        return 0;
    }

    const unsigned char *bytes = base;
    size_t matches = 0;

    for (size_t i = 0; i < count; i++) {
        if (predicate(
                bytes + i * elementSize
            )) {
            matches++;
        }
    }

    return matches;
}
```

---

## Esercizio 13 — Reverse generico in place

### Consegna

Invertire un array generico in place.

### Struttura

```c
int genericReverse(
    void *base,
    size_t count,
    size_t elementSize
);
```

### Soluzione semplice

```c
int genericReverse(
    void *base,
    size_t count,
    size_t elementSize
) {
    if (
        base == NULL ||
        elementSize == 0
    ) {
        return count == 0;
    }

    unsigned char *bytes = base;

    for (size_t left = 0, right = count;
         left < right && left < --right;
         left++) {
        if (!genericSwap(
                bytes + left * elementSize,
                bytes + right * elementSize,
                elementSize
            )) {
            return 0;
        }
    }

    return 1;
}
```

### Complessità

- Tempo: `O(count * elementSize)`
- Spazio: dipende dallo swap.

---

## Esercizio 14 — Copia filtrata generica

### Consegna

Restituire un nuovo blocco contenente gli elementi che soddisfano un predicato, preservando l'ordine.

### Struttura

```c
typedef struct {
    void *data;
    size_t count;
} GenericArray;

GenericArray genericFilterCopy(
    const void *base,
    size_t count,
    size_t elementSize,
    PredicateFn predicate
);
```

### Soluzione semplice in due passaggi

```c
#include <stdlib.h>
#include <string.h>

GenericArray genericFilterCopy(
    const void *base,
    size_t count,
    size_t elementSize,
    PredicateFn predicate
) {
    GenericArray result = {NULL, 0};

    if (
        base == NULL ||
        elementSize == 0 ||
        predicate == NULL
    ) {
        return result;
    }

    const unsigned char *source = base;
    size_t selected = 0;

    for (size_t i = 0; i < count; i++) {
        if (predicate(
                source + i * elementSize
            )) {
            selected++;
        }
    }

    if (selected == 0) {
        return result;
    }

    unsigned char *output =
        malloc(selected * elementSize);

    if (output == NULL) {
        return result;
    }

    size_t write = 0;

    for (size_t i = 0; i < count; i++) {
        const void *element =
            source + i * elementSize;

        if (predicate(element)) {
            memcpy(
                output + write * elementSize,
                element,
                elementSize
            );

            write++;
        }
    }

    result.data = output;
    result.count = selected;

    return result;
}
```

### Limite importante

Questa funzione esegue una **copia byte-per-byte** degli elementi.

È corretta per:

- interi;
- double;
- struct senza ownership interna;
- struct con puntatori soltanto se si vuole una shallow copy.

Non è una deep copy generica.

---

# Livello 3 — Comparazione, ordinamento e ricerca

---

## Esercizio 15 — Ordinare interi con `qsort`

### Consegna

Ordinare un array di interi in ordine crescente usando `qsort`.

### Soluzione

```c
#include <stdlib.h>

void sortInts(int a[], size_t n) {
    qsort(
        a,
        n,
        sizeof(*a),
        compareInt
    );
}
```

### Trappole

- passare `sizeof(a)` dentro una funzione, dove `a` è un puntatore;
- usare un comparatore con firma incompatibile;
- dereferenziare come tipo sbagliato.

---

## Esercizio 16 — Ordinare in ordine configurabile

### Consegna

Ordinare interi crescenti o decrescenti scegliendo il comparatore.

### Comparatore decrescente

```c
int compareIntDescending(
    const void *a,
    const void *b
) {
    return -compareInt(a, b);
}
```

### Nota

Negare un comparatore può essere rischioso se il comparatore può restituire `INT_MIN`. La versione mostrata è sicura perché `compareInt` restituisce soltanto `-1`, `0`, `1`.

---

## Esercizio 17 — Ordinare struct `Person`

### Consegna

Ordinare per cognome, poi nome, poi età.

### Struttura

```c
typedef struct {
    char surname[32];
    char name[32];
    unsigned int age;
} Person;
```

### Soluzione

```c
#include <string.h>

int comparePerson(
    const void *a,
    const void *b
) {
    const Person *pa = a;
    const Person *pb = b;

    int surnameComparison =
        strcmp(pa->surname, pb->surname);

    if (surnameComparison != 0) {
        return surnameComparison;
    }

    int nameComparison =
        strcmp(pa->name, pb->name);

    if (nameComparison != 0) {
        return nameComparison;
    }

    return
        (pa->age > pb->age) -
        (pa->age < pb->age);
}
```

---

## Esercizio 18 — `bsearch` generico

### Consegna

Cercare un intero in un array ordinato usando `bsearch`.

### Soluzione

```c
const int *findSortedInt(
    const int a[],
    size_t n,
    int key
) {
    return bsearch(
        &key,
        a,
        n,
        sizeof(*a),
        compareInt
    );
}
```

### Ownership

Il puntatore restituito punta nell'array originale.

---

## Esercizio 19 — Ricerca binaria generica manuale

### Struttura

```c
const void *genericBinarySearch(
    const void *base,
    size_t count,
    size_t elementSize,
    const void *key,
    CompareFn compare
);
```

### Soluzione

```c
const void *genericBinarySearch(
    const void *base,
    size_t count,
    size_t elementSize,
    const void *key,
    CompareFn compare
) {
    if (
        base == NULL ||
        key == NULL ||
        compare == NULL ||
        elementSize == 0
    ) {
        return NULL;
    }

    const unsigned char *bytes = base;
    size_t left = 0;
    size_t right = count;

    while (left < right) {
        size_t middle =
            left + (right - left) / 2;

        const void *element =
            bytes + middle * elementSize;

        int comparison =
            compare(key, element);

        if (comparison == 0) {
            return element;
        }

        if (comparison < 0) {
            right = middle;
        } else {
            left = middle + 1;
        }
    }

    return NULL;
}
```

### Punto delicato

Il contratto del comparatore deve essere usato sempre nello stesso verso:

```c
compare(key, element)
```

oppure:

```c
compare(element, key)
```

ma non alternato senza adattare i confronti.

---

# Livello 4 — ADT opaco: vettore generico owned

---

## Esercizio 20 — Interfaccia del vettore generico

### Consegna

Progettare un ADT opaco `GenericVector` che:

- conservi puntatori a copie degli elementi;
- usi `CloneFn` per copiare;
- usi `DestroyFn` per distruggere;
- supporti inserimento in coda, accesso e rimozione.

### File `genericVector.h`

```c
#ifndef GENERIC_VECTOR_H
#define GENERIC_VECTOR_H

#include <stddef.h>

typedef void *(*GVCloneFn)(const void *);
typedef void (*GVDestroyFn)(void *);

typedef struct genericVector *GenericVector;

typedef enum {
    GV_OK,
    GV_INVALID_ARGUMENT,
    GV_OUT_OF_MEMORY,
    GV_INDEX_OUT_OF_RANGE
} GVResult;

GenericVector gvCreate(
    GVCloneFn clone,
    GVDestroyFn destroy
);

void gvDestroy(GenericVector *vectorPtr);

size_t gvSize(GenericVector vector);

const void *gvGet(
    GenericVector vector,
    size_t index
);

GVResult gvPushBack(
    GenericVector vector,
    const void *element
);

GVResult gvRemoveAt(
    GenericVector vector,
    size_t index
);

#endif
```

### Rappresentazione privata nel `.c`

```c
struct genericVector {
    void **data;
    size_t size;
    size_t capacity;
    GVCloneFn clone;
    GVDestroyFn destroy;
};
```

### Costruttore

```c
GenericVector gvCreate(
    GVCloneFn clone,
    GVDestroyFn destroy
) {
    if (clone == NULL || destroy == NULL) {
        return NULL;
    }

    GenericVector vector =
        malloc(sizeof(*vector));

    if (vector == NULL) {
        return NULL;
    }

    vector->data = NULL;
    vector->size = 0;
    vector->capacity = 0;
    vector->clone = clone;
    vector->destroy = destroy;

    return vector;
}
```

### Perché il tipo è opaco

Il client vede soltanto:

```c
typedef struct genericVector *GenericVector;
```

Non può accedere a:

```c
vector->size
vector->data
```

Deve usare l'interfaccia pubblica.

---

## Esercizio 21 — Push back con deep copy

### Soluzione

```c
static GVResult gvReserve(
    GenericVector vector,
    size_t newCapacity
) {
    if (newCapacity <= vector->capacity) {
        return GV_OK;
    }

    void **tmp = realloc(
        vector->data,
        newCapacity * sizeof(*tmp)
    );

    if (tmp == NULL) {
        return GV_OUT_OF_MEMORY;
    }

    vector->data = tmp;
    vector->capacity = newCapacity;

    return GV_OK;
}

GVResult gvPushBack(
    GenericVector vector,
    const void *element
) {
    if (vector == NULL || element == NULL) {
        return GV_INVALID_ARGUMENT;
    }

    void *copy = vector->clone(element);

    if (copy == NULL) {
        return GV_OUT_OF_MEMORY;
    }

    if (vector->size == vector->capacity) {
        size_t newCapacity =
            vector->capacity == 0
            ? 4
            : vector->capacity * 2;

        GVResult reserveResult =
            gvReserve(vector, newCapacity);

        if (reserveResult != GV_OK) {
            vector->destroy(copy);
            return reserveResult;
        }
    }

    vector->data[vector->size++] = copy;
    return GV_OK;
}
```

### Ordine delle operazioni

Si potrebbe prima riallocare e poi clonare. Entrambe le strategie sono possibili.

Quella mostrata richiede:

```text
se reserve fallisce → distruggere la copia già creata
```

---

## Esercizio 22 — Accesso const

### Soluzione

```c
const void *gvGet(
    GenericVector vector,
    size_t index
) {
    if (
        vector == NULL ||
        index >= vector->size
    ) {
        return NULL;
    }

    return vector->data[index];
}
```

### Perché `const void *`

Il client può leggere l'elemento ma non dovrebbe modificarlo violando gli invarianti dell'ADT.

---

## Esercizio 23 — Remove at

### Soluzione

```c
GVResult gvRemoveAt(
    GenericVector vector,
    size_t index
) {
    if (vector == NULL) {
        return GV_INVALID_ARGUMENT;
    }

    if (index >= vector->size) {
        return GV_INDEX_OUT_OF_RANGE;
    }

    vector->destroy(vector->data[index]);

    for (
        size_t i = index + 1;
        i < vector->size;
        i++
    ) {
        vector->data[i - 1] =
            vector->data[i];
    }

    vector->size--;
    return GV_OK;
}
```

### Complessità

- Tempo: `O(n-index)`
- Spazio: `O(1)`

---

## Esercizio 24 — Distruzione

### Soluzione

```c
void gvDestroy(GenericVector *vectorPtr) {
    if (
        vectorPtr == NULL ||
        *vectorPtr == NULL
    ) {
        return;
    }

    GenericVector vector = *vectorPtr;

    for (size_t i = 0; i < vector->size; i++) {
        vector->destroy(vector->data[i]);
    }

    free(vector->data);
    free(vector);

    *vectorPtr = NULL;
}
```

### Ordine corretto

```text
1. distruggi elementi
2. libera array di puntatori
3. libera struttura
4. azzera puntatore client
```

---

## Esercizio 25 — Clone del vettore

### Consegna

Creare una copia profonda del vettore.

### Soluzione semplice

```c
GenericVector gvClone(
    GenericVector source
) {
    if (source == NULL) {
        return NULL;
    }

    GenericVector copy =
        gvCreate(
            source->clone,
            source->destroy
        );

    if (copy == NULL) {
        return NULL;
    }

    for (size_t i = 0; i < source->size; i++) {
        GVResult result =
            gvPushBack(copy, source->data[i]);

        if (result != GV_OK) {
            gvDestroy(&copy);
            return NULL;
        }
    }

    return copy;
}
```

### Complessità

Dipende dal costo del clone:

```text
O(n + costo totale delle copie)
```

---

# Livello 5 — Generic vector borrowed e ownership transferred

---

## Esercizio 26 — Vettore borrowed

### Consegna

Progettare una variante che memorizzi puntatori senza copiarli e senza distruggerli.

### Struttura privata

```c
struct borrowedVector {
    const void **data;
    size_t size;
    size_t capacity;
};
```

### Contratto

```text
gli elementi devono restare vivi finché il vettore li usa
destroy del vettore non libera gli elementi
```

### Errore tipico

Inserire l'indirizzo di una variabile locale e usare il vettore dopo il ritorno della funzione:

```c
void bad(BorrowedVector v) {
    int x = 42;
    bvPush(v, &x);
}   /* &x diventa dangling */
```

---

## Esercizio 27 — Push con trasferimento di ownership

### Consegna

Il vettore riceve un puntatore già allocato e ne acquisisce la proprietà.

### Firma

```c
GVResult gvPushOwned(
    GenericVector vector,
    void *ownedElement
);
```

### Contratto consigliato

```text
successo:
    ownership trasferita al vettore

fallimento:
    ownership resta al chiamante
```

### Soluzione

```c
GVResult gvPushOwned(
    GenericVector vector,
    void *ownedElement
) {
    if (
        vector == NULL ||
        ownedElement == NULL
    ) {
        return GV_INVALID_ARGUMENT;
    }

    if (vector->size == vector->capacity) {
        size_t newCapacity =
            vector->capacity == 0
            ? 4
            : vector->capacity * 2;

        GVResult result =
            gvReserve(vector, newCapacity);

        if (result != GV_OK) {
            return result;
        }
    }

    vector->data[vector->size++] =
        ownedElement;

    return GV_OK;
}
```

### Punto importante

In caso di fallimento, la funzione non libera `ownedElement`, perché il contratto dice che la proprietà resta al chiamante.

---

## Esercizio 28 — Estrazione con trasferimento di ownership

### Consegna

Rimuovere un elemento senza distruggerlo, trasferendone la proprietà al chiamante.

### Firma

```c
void *gvTakeAt(
    GenericVector vector,
    size_t index
);
```

### Soluzione

```c
void *gvTakeAt(
    GenericVector vector,
    size_t index
) {
    if (
        vector == NULL ||
        index >= vector->size
    ) {
        return NULL;
    }

    void *element = vector->data[index];

    for (
        size_t i = index + 1;
        i < vector->size;
        i++
    ) {
        vector->data[i - 1] =
            vector->data[i];
    }

    vector->size--;
    return element;
}
```

### Ownership

Dopo il ritorno:

```text
il vettore non possiede più l'elemento
il chiamante deve distruggerlo
```

---

# Livello 6 — Lista, pila e coda generiche

---

## Esercizio 29 — Lista generica owned

### Struttura

```c
typedef struct genericNode GenericNode;

struct genericNode {
    void *data;
    GenericNode *next;
};

typedef struct {
    GenericNode *head;
    size_t size;
    CloneFn clone;
    DestroyFn destroy;
    EqualFn equal;
} GenericList;
```

### Consegna

Implementare:

```c
int glInsertFront(
    GenericList *list,
    const void *element
);

const void *glFind(
    const GenericList *list,
    const void *key
);

int glRemoveFirst(
    GenericList *list,
    const void *key
);

void glDestroy(GenericList *list);
```

### Inserimento

```c
int glInsertFront(
    GenericList *list,
    const void *element
) {
    if (
        list == NULL ||
        element == NULL
    ) {
        return 0;
    }

    void *copy = list->clone(element);

    if (copy == NULL) {
        return 0;
    }

    GenericNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        list->destroy(copy);
        return 0;
    }

    node->data = copy;
    node->next = list->head;
    list->head = node;
    list->size++;

    return 1;
}
```

---

## Esercizio 30 — Rimozione generica

### Soluzione

```c
int glRemoveFirst(
    GenericList *list,
    const void *key
) {
    if (
        list == NULL ||
        key == NULL
    ) {
        return 0;
    }

    GenericNode **cursor = &list->head;

    while (
        *cursor != NULL &&
        !list->equal((*cursor)->data, key)
    ) {
        cursor = &(*cursor)->next;
    }

    if (*cursor == NULL) {
        return 0;
    }

    GenericNode *victim = *cursor;
    *cursor = victim->next;

    list->destroy(victim->data);
    free(victim);

    list->size--;
    return 1;
}
```

### Pattern importante

Il puntatore a puntatore elimina il caso speciale della testa.

---

## Esercizio 31 — Pila generica

### Consegna

Implementare una pila generica owned sopra `GenericList`.

### Operazioni

```c
int gsPush(
    GenericStack *stack,
    const void *element
);

const void *gsTop(
    const GenericStack *stack
);

void *gsPopOwned(
    GenericStack *stack
);
```

### Scelta progettuale

`gsPopOwned` trasferisce l'ownership al chiamante.

La funzione:

- rimuove il nodo;
- non distrugge il dato;
- restituisce il puntatore al dato.

---

## Esercizio 32 — Coda generica

### Struttura

```c
typedef struct {
    GenericNode *front;
    GenericNode *rear;
    size_t size;
    CloneFn clone;
    DestroyFn destroy;
} GenericQueue;
```

### Enqueue

```c
int gqEnqueue(
    GenericQueue *queue,
    const void *element
) {
    void *copy = queue->clone(element);

    if (copy == NULL) {
        return 0;
    }

    GenericNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        queue->destroy(copy);
        return 0;
    }

    node->data = copy;
    node->next = NULL;

    if (queue->rear == NULL) {
        queue->front = node;
        queue->rear = node;
    } else {
        queue->rear->next = node;
        queue->rear = node;
    }

    queue->size++;
    return 1;
}
```

### Dequeue owned

```c
void *gqDequeueOwned(
    GenericQueue *queue
) {
    if (
        queue == NULL ||
        queue->front == NULL
    ) {
        return NULL;
    }

    GenericNode *victim = queue->front;
    void *element = victim->data;

    queue->front = victim->next;

    if (queue->front == NULL) {
        queue->rear = NULL;
    }

    free(victim);
    queue->size--;

    return element;
}
```

---

# Livello 7 — Set ordinato e priority queue generici

---

## Esercizio 33 — Set generico non ordinato

### Consegna

Implementare un set generico owned con `EqualFn`.

### Operazioni

```c
int genericSetContains(
    const GenericSet *set,
    const void *key
);

int genericSetInsert(
    GenericSet *set,
    const void *element
);

int genericSetRemove(
    GenericSet *set,
    const void *key
);
```

### Invariante

```text
non esistono due nodi a e b tali che equal(a,b) sia vero
```

### Inserimento

1. Cerca duplicato.
2. Clona.
3. Alloca nodo.
4. Collega.
5. Incrementa size.

### Complessità

- `contains`: `O(n * costoEqual)`
- `insert`: stessa complessità + clone
- `remove`: `O(n * costoEqual)`

---

## Esercizio 34 — Set ordinato generico

### Consegna

Implementare un set generico con lista ordinata e `CompareFn`.

### Inserimento

```c
int orderedSetInsert(
    OrderedSet *set,
    const void *element
) {
    GenericNode **cursor = &set->head;

    while (
        *cursor != NULL &&
        set->compare(
            (*cursor)->data,
            element
        ) < 0
    ) {
        cursor = &(*cursor)->next;
    }

    if (
        *cursor != NULL &&
        set->compare(
            (*cursor)->data,
            element
        ) == 0
    ) {
        return 0;
    }

    void *copy = set->clone(element);

    if (copy == NULL) {
        return 0;
    }

    GenericNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        set->destroy(copy);
        return 0;
    }

    node->data = copy;
    node->next = *cursor;
    *cursor = node;
    set->size++;

    return 1;
}
```

### Punto d'esame

Il comparatore definisce contemporaneamente:

- ordine;
- equivalenza quando restituisce zero.

---

## Esercizio 35 — Unione lineare di set ordinati

### Consegna

Unire due set ordinati compatibili in un nuovo set.

### Idea

Usare due cursori:

```text
cmp < 0 → copia elemento A
cmp > 0 → copia elemento B
cmp = 0 → copia una sola volta e avanza entrambi
```

### Complessità

- Tempo: `O(n+m)` confronti
- Spazio: `O(n+m)` nel caso peggiore

### Compatibilità

I due set devono avere politiche coerenti:

```text
compare
clone
destroy
```

---

## Esercizio 36 — Priority queue generica con heap

### Consegna

Implementare una priority queue generica owned con heap binario.

### Struttura privata

```c
struct genericPriorityQueue {
    void **data;
    size_t size;
    size_t capacity;
    CompareFn compare;
    CloneFn clone;
    DestroyFn destroy;
};
```

Convenzione:

```text
compare(a,b) > 0 → a ha priorità maggiore di b
```

### Push

1. Clona elemento.
2. Inserisce in fondo.
3. Risale finché il padre ha priorità minore.

### Sift up

```c
static void gpqSiftUp(
    GenericPriorityQueue queue,
    size_t index
) {
    while (index > 0) {
        size_t parent = (index - 1) / 2;

        if (
            queue->compare(
                queue->data[index],
                queue->data[parent]
            ) <= 0
        ) {
            break;
        }

        void *tmp = queue->data[index];
        queue->data[index] =
            queue->data[parent];
        queue->data[parent] = tmp;

        index = parent;
    }
}
```

### Complessità

- push: `O(log n)`
- top: `O(1)`
- pop: `O(log n)`

---

## Esercizio 37 — Pop della priority queue

### Soluzione

```c
void *gpqPopOwned(
    GenericPriorityQueue queue
) {
    if (
        queue == NULL ||
        queue->size == 0
    ) {
        return NULL;
    }

    void *result = queue->data[0];

    queue->size--;

    if (queue->size > 0) {
        queue->data[0] =
            queue->data[queue->size];

        size_t index = 0;

        while (1) {
            size_t left = 2 * index + 1;
            size_t right = left + 1;
            size_t best = index;

            if (
                left < queue->size &&
                queue->compare(
                    queue->data[left],
                    queue->data[best]
                ) > 0
            ) {
                best = left;
            }

            if (
                right < queue->size &&
                queue->compare(
                    queue->data[right],
                    queue->data[best]
                ) > 0
            ) {
                best = right;
            }

            if (best == index) {
                break;
            }

            void *tmp = queue->data[index];
            queue->data[index] =
                queue->data[best];
            queue->data[best] = tmp;

            index = best;
        }
    }

    return result;
}
```

### Ownership

Il chiamante riceve il puntatore e deve distruggerlo.

---

# Livello 8 — Algoritmi funzionali generici

---

## Esercizio 38 — `map` owned

### Consegna

Applicare `MapFn` a ogni elemento di un vettore e costruire un nuovo vettore.

La callback restituisce un nuovo oggetto owned.

### Contratto

```c
void *map(const void *source);
```

Il risultato:

- è nuovo;
- diventa proprietà del vettore risultato;
- va distrutto se un passaggio successivo fallisce.

### Strategia

1. Crea vettore risultato.
2. Per ogni elemento:
   - chiama `map`;
   - inserisci con trasferimento ownership;
   - se fallisce, distruggi oggetto e vettore parziale.

---

## Esercizio 39 — `filter` su vettore owned

### Consegna

Creare un nuovo vettore contenente copie degli elementi che soddisfano un predicato.

### Soluzione concettuale

```c
GenericVector gvFilter(
    GenericVector source,
    PredicateFn predicate
) {
    GenericVector result =
        gvCreate(
            source->clone,
            source->destroy
        );

    if (result == NULL) {
        return NULL;
    }

    for (size_t i = 0; i < source->size; i++) {
        if (predicate(source->data[i])) {
            if (
                gvPushBack(
                    result,
                    source->data[i]
                ) != GV_OK
            ) {
                gvDestroy(&result);
                return NULL;
            }
        }
    }

    return result;
}
```

### Input invariato

Il risultato contiene copie indipendenti.

---

## Esercizio 40 — `reduce`

### Consegna

Ridurre un vettore in un accumulatore di tipo arbitrario.

### Firma

```c
void gvReduce(
    GenericVector vector,
    void *accumulator,
    ReduceFn reduce
);
```

### Soluzione

```c
void gvReduce(
    GenericVector vector,
    void *accumulator,
    ReduceFn reduce
) {
    if (
        vector == NULL ||
        accumulator == NULL ||
        reduce == NULL
    ) {
        return;
    }

    for (size_t i = 0; i < vector->size; i++) {
        reduce(
            accumulator,
            vector->data[i]
        );
    }
}
```

### Esempio: somma di interi heap

```c
void addToLongLong(
    void *accumulator,
    const void *element
) {
    long long *sum = accumulator;
    const int *value = element;

    *sum += *value;
}
```

---

## Esercizio 41 — `any` e `all`

### Soluzione

```c
_Bool gvAny(
    GenericVector vector,
    PredicateFn predicate
) {
    if (vector == NULL || predicate == NULL) {
        return 0;
    }

    for (size_t i = 0; i < vector->size; i++) {
        if (predicate(vector->data[i])) {
            return 1;
        }
    }

    return 0;
}

_Bool gvAll(
    GenericVector vector,
    PredicateFn predicate
) {
    if (vector == NULL || predicate == NULL) {
        return 0;
    }

    for (size_t i = 0; i < vector->size; i++) {
        if (!predicate(vector->data[i])) {
            return 0;
        }
    }

    return 1;
}
```

### Caso vuoto

Dal punto di vista logico:

```text
any(vuoto) = falso
all(vuoto) = vero
```

La specifica deve stabilire il comportamento su `vector == NULL`, distinto da vettore valido ma vuoto.

---

# Livello 9 — Tipi eterogenei, tag e union

---

## Esercizio 42 — Valore eterogeneo tagged

### Consegna

Rappresentare valori di tipo:

- intero;
- double;
- stringa owned.

### Struttura

```c
typedef enum {
    VALUE_INT,
    VALUE_DOUBLE,
    VALUE_STRING
} ValueTag;

typedef struct {
    ValueTag tag;

    union {
        int intValue;
        double doubleValue;
        char *stringValue;
    } as;
} Value;
```

### Distruzione

```c
void valueDestroy(Value *value) {
    if (value == NULL) {
        return;
    }

    if (value->tag == VALUE_STRING) {
        free(value->as.stringValue);
        value->as.stringValue = NULL;
    }
}
```

### Clone

```c
#include <string.h>

int valueClone(
    Value *destination,
    const Value *source
) {
    if (
        destination == NULL ||
        source == NULL
    ) {
        return 0;
    }

    destination->tag = source->tag;

    switch (source->tag) {
        case VALUE_INT:
            destination->as.intValue =
                source->as.intValue;
            return 1;

        case VALUE_DOUBLE:
            destination->as.doubleValue =
                source->as.doubleValue;
            return 1;

        case VALUE_STRING: {
            size_t length =
                strlen(source->as.stringValue);

            destination->as.stringValue =
                malloc(length + 1);

            if (
                destination->as.stringValue ==
                NULL
            ) {
                return 0;
            }

            memcpy(
                destination->as.stringValue,
                source->as.stringValue,
                length + 1
            );

            return 1;
        }
    }

    return 0;
}
```

### Perché serve il tag

Senza tag non è possibile sapere quale campo della `union` sia attivo.

---

## Esercizio 43 — Stampa polimorfica

### Consegna

Stampare un `Value` in base al tag.

### Soluzione

```c
void valuePrint(
    const Value *value,
    FILE *out
) {
    switch (value->tag) {
        case VALUE_INT:
            fprintf(
                out,
                "%d",
                value->as.intValue
            );
            break;

        case VALUE_DOUBLE:
            fprintf(
                out,
                "%g",
                value->as.doubleValue
            );
            break;

        case VALUE_STRING:
            fprintf(
                out,
                "\"%s\"",
                value->as.stringValue
            );
            break;
    }
}
```

---

## Esercizio 44 — Array eterogeneo

### Consegna

Costruire un vettore dinamico di `Value`.

### Scelta progettuale consigliata

In questo caso non serve `void *` per ogni elemento:

```c
Value *data;
```

è più sicuro, perché il tipo tagged è già uniforme.

### Punto didattico

`void *` non è sempre la soluzione migliore. Una `union` tagged mantiene il controllo esplicito sui tipi ammessi.

---

# Livello 10 — Callback con contesto

Una callback semplice spesso non basta.

Esempio:

```c
_Bool greaterThan(const void *element);
```

Come si passa la soglia?

Soluzione: aggiungere un puntatore `context`.

```c
typedef _Bool (*PredicateWithContextFn)(
    const void *element,
    const void *context
);
```

---

## Esercizio 45 — `countIf` con contesto

### Struttura

```c
size_t genericCountIfContext(
    const void *base,
    size_t count,
    size_t elementSize,
    PredicateWithContextFn predicate,
    const void *context
);
```

### Soluzione

```c
size_t genericCountIfContext(
    const void *base,
    size_t count,
    size_t elementSize,
    PredicateWithContextFn predicate,
    const void *context
) {
    if (
        base == NULL ||
        elementSize == 0 ||
        predicate == NULL
    ) {
        return 0;
    }

    const unsigned char *bytes = base;
    size_t matches = 0;

    for (size_t i = 0; i < count; i++) {
        if (predicate(
                bytes + i * elementSize,
                context
            )) {
            matches++;
        }
    }

    return matches;
}
```

### Esempio

```c
_Bool intGreaterThan(
    const void *element,
    const void *context
) {
    int value = *(const int *)element;
    int threshold = *(const int *)context;

    return value > threshold;
}
```

---

## Esercizio 46 — Comparatore configurabile

### Consegna

Ordinare persone secondo un campo scelto a runtime.

### Strategia

Definire un contesto:

```c
typedef enum {
    PERSON_BY_NAME,
    PERSON_BY_AGE
} PersonOrder;
```

Poiché `qsort` standard non accetta contesto in modo portabile, alternative:

- comparatori distinti;
- stato globale, sconsigliato;
- implementare un proprio sort che accetta `CompareWithContextFn`;
- usare estensioni non portabili come `qsort_r`, con firme diverse tra sistemi.

### Punto d'esame

Non inventare un parametro aggiuntivo nel comparatore di `qsort`: la firma deve essere esattamente quella prevista.

---

# Livello 11 — Dispatcher, registry e “polimorfismo” in C

---

## Esercizio 47 — Event dispatcher

### Consegna

Gestire callback registrate per diversi tipi di evento.

### Struttura

```c
typedef enum {
    EVENT_START,
    EVENT_DATA,
    EVENT_STOP,
    EVENT_COUNT
} EventType;

typedef void (*EventHandler)(
    const void *payload,
    void *context
);

typedef struct {
    EventHandler handler;
    void *context;
} HandlerEntry;

typedef struct {
    HandlerEntry handlers[EVENT_COUNT];
} EventDispatcher;
```

### Registrazione

```c
int dispatcherRegister(
    EventDispatcher *dispatcher,
    EventType type,
    EventHandler handler,
    void *context
) {
    if (
        dispatcher == NULL ||
        type < 0 ||
        type >= EVENT_COUNT
    ) {
        return 0;
    }

    dispatcher->handlers[type].handler =
        handler;

    dispatcher->handlers[type].context =
        context;

    return 1;
}
```

### Dispatch

```c
void dispatcherEmit(
    EventDispatcher *dispatcher,
    EventType type,
    const void *payload
) {
    HandlerEntry entry =
        dispatcher->handlers[type];

    if (entry.handler != NULL) {
        entry.handler(
            payload,
            entry.context
        );
    }
}
```

---

## Esercizio 48 — Plugin registry

### Consegna

Registrare algoritmi identificati da nome.

Ogni plugin contiene:

```c
typedef int (*AlgorithmFn)(
    const void *input,
    void *output
);

typedef struct {
    char *name;
    AlgorithmFn run;
} Plugin;
```

Operazioni:

- register;
- find by name;
- execute;
- destroy.

### Punti delicati

- deep copy del nome;
- nomi unici;
- callback non `NULL`;
- ownership del contesto;
- comportamento se il plugin viene sostituito.

---

## Esercizio 49 — Vtable manuale

### Consegna

Rappresentare forme geometriche diverse con una “vtable”.

### Struttura

```c
typedef struct Shape Shape;

typedef struct {
    double (*area)(const Shape *);
    void (*destroy)(Shape *);
    void (*print)(const Shape *, FILE *);
} ShapeVTable;

struct Shape {
    const ShapeVTable *vtable;
};
```

Una `Circle`:

```c
typedef struct {
    Shape base;
    double radius;
} Circle;
```

### Uso

```c
double shapeArea(const Shape *shape) {
    return shape->vtable->area(shape);
}

void shapeDestroy(Shape *shape) {
    shape->vtable->destroy(shape);
}
```

### Punto didattico

È una forma manuale di polimorfismo:

```text
dato + tabella di operazioni
```

Il cast è sicuro soltanto se la vtable corrisponde realmente al tipo concreto.

---

# Livello 12 — Esercizi finali “infernali”

---

## Esercizio 50 — Generic stable merge

### Consegna

Fondere due array ordinati generici in un nuovo array, preservando la stabilità.

### Firma

```c
GenericArray genericMergeSorted(
    const void *a,
    size_t countA,
    const void *b,
    size_t countB,
    size_t elementSize,
    CompareFn compare
);
```

### Soluzione concettuale

- alloca `(countA + countB) * elementSize`;
- usa due indici;
- a parità, copia prima da `a`;
- usa `memcpy` per singolo elemento.

### Complessità

- Tempo: `O(countA + countB)`
- Spazio: `O(countA + countB)`

### Limite

Copia byte-per-byte: shallow per elementi con puntatori.

---

## Esercizio 51 — Generic stable partition con deep clone

### Consegna

Partizionare una sequenza in:

1. elementi che soddisfano il predicato;
2. elementi che non lo soddisfano;

preservando l'ordine e creando copie profonde.

### Strategia

Costruire un nuovo vettore owned:

- primo passaggio: selezionati;
- secondo passaggio: non selezionati.

### Complessità

- Tempo: `O(n + costo clone)`
- Spazio: `O(n)`

---

## Esercizio 52 — Generic group by equivalence

### Consegna

Raggruppare elementi equivalenti secondo `EqualFn`.

Output concettuale:

```text
array di gruppi
ogni gruppo è un GenericVector
```

### Soluzione semplice

Per ogni elemento:

1. cerca un gruppo il cui rappresentante sia equivalente;
2. se esiste, inserisci;
3. altrimenti crea un nuovo gruppo.

### Complessità

Peggiore:

```text
O(n² * costoEqual)
```

### Possibile ottimizzazione

- ordinare per chiave e raggruppare consecutivi;
- hash map con hash coerente con equality.

---

## Esercizio 53 — Generic memoization cache

### Consegna

Memorizzare risultati di una funzione generica:

```c
void *compute(const void *key);
```

Servono callback:

```text
keyEqual
keyClone
keyDestroy
valueClone oppure ownership transfer
valueDestroy
```

### Punti difficili

- ownership di chiavi e valori;
- aggiornamento di una chiave esistente;
- fallimento a metà dell'inserimento;
- coerenza tra equality e hashing;
- restituzione borrowed o cloned del valore.

---

## Esercizio 54 — Sort configurabile con contesto

### Consegna

Implementare merge sort generico stabile con comparatore dotato di contesto.

### Tipi

```c
typedef int (*CompareContextFn)(
    const void *a,
    const void *b,
    const void *context
);
```

### Firma

```c
int genericMergeSortContext(
    void *base,
    size_t count,
    size_t elementSize,
    CompareContextFn compare,
    const void *context
);
```

### Complessità

- Tempo: `O(n log n)`
- Spazio: `O(n * elementSize)`
- Stack: `O(log n)`

### Perché è utile

Permette ordinamenti configurabili senza variabili globali.

---

## Esercizio 55 — Generic BST owned

### Consegna

Implementare un BST generico owned.

Callback:

```text
compare
clone
destroy
```

### Operazioni

```text
insert
contains
remove
inorder
destroy
```

### Rimozione con due figli

Per un tipo generico non si può semplicemente assegnare:

```c
node->data = successor->data;
```

senza ragionare sull'ownership.

Soluzioni:

1. scambiare i puntatori ai dati;
2. staccare fisicamente il nodo successore;
3. clonare il successore e distruggere il vecchio dato.

La soluzione 2 evita clone aggiuntivi ed è spesso la più robusta.

---

## Esercizio 56 — ADT compatibili ma non identici

### Consegna

Due set generici usano comparatori diversi ma semanticamente equivalenti.

È sicuro unirli?

### Risposta ragionata

Non si può dedurre automaticamente la compatibilità semantica confrontando soltanto i puntatori a funzione.

Due funzioni diverse possono implementare lo stesso ordine; la stessa funzione può dipendere da contesti differenti.

Una progettazione robusta dovrebbe:

- richiedere esplicitamente il comparatore del risultato;
- documentare la precondizione di compatibilità;
- oppure conservare un identificatore di policy;
- oppure ricostruire il risultato inserendo ogni elemento con la policy scelta.

---

## Esercizio 57 — Failure atomicity

### Consegna

Implementare:

```c
int gvReplaceAt(
    GenericVector vector,
    size_t index,
    const void *newElement
);
```

Vincolo:

```text
se clone fallisce, il vettore resta completamente invariato
```

### Soluzione corretta

```c
GVResult gvReplaceAt(
    GenericVector vector,
    size_t index,
    const void *newElement
) {
    if (
        vector == NULL ||
        newElement == NULL
    ) {
        return GV_INVALID_ARGUMENT;
    }

    if (index >= vector->size) {
        return GV_INDEX_OUT_OF_RANGE;
    }

    void *copy =
        vector->clone(newElement);

    if (copy == NULL) {
        return GV_OUT_OF_MEMORY;
    }

    void *old = vector->data[index];
    vector->data[index] = copy;
    vector->destroy(old);

    return GV_OK;
}
```

### Perché prima clonare

Se si distruggesse prima il vecchio elemento e poi il clone fallisse, il vettore sarebbe stato modificato nonostante il fallimento.

---

# 13. Tracce aggiuntive senza soluzione completa

## Puntatori a funzione

1. Implementare `minBy`.
2. Implementare `maxBy`.
3. Scegliere dinamicamente una funzione di conversione.
4. Costruire una tabella di comandi testuali.
5. Implementare un menu con callback.
6. Applicare una pipeline di funzioni unarie.
7. Comporre due trasformazioni.
8. Contare quante callback restituiscono vero.
9. Selezionare un comparatore da riga di comando.
10. Implementare una macchina a stati con tabella di transizioni.
11. Implementare un parser con handler per token.
12. Implementare un sistema di log con callback.
13. Memorizzare callback in una struct configurabile.
14. Aggiungere callback di errore a un ADT.
15. Ordinare lo stesso array secondo tre criteri.

## Funzioni generiche su array

16. `genericCopy`.
17. `genericMove`.
18. `genericRotate`.
19. `genericRemoveAt`.
20. `genericInsertAt`.
21. `genericUnique`.
22. `genericLowerBound`.
23. `genericUpperBound`.
24. `genericEqualRange`.
25. `genericIsSorted`.
26. `genericLexicographicCompare`.
27. `genericAdjacentFind`.
28. `genericPartition`.
29. `genericStablePartition`.
30. `genericShuffle`.

## ADT generici

31. Generic deque borrowed.
32. Generic deque owned.
33. Generic circular queue.
34. Generic doubly linked list.
35. Generic ordered list.
36. Generic multiset.
37. Generic map key-value.
38. Generic hash set.
39. Generic hash map.
40. Generic trie.
41. Generic binary heap.
42. Generic min-max heap.
43. Generic disjoint set.
44. Generic graph adjacency list.
45. Generic LRU cache.

## Ownership e memoria

46. Vettore con shallow ownership.
47. Vettore con deep ownership.
48. Conversione borrowed → owned.
49. Conversione owned → borrowed view.
50. Slice non owning.
51. Iterator invalidation dopo realloc.
52. Clone parziale con rollback.
53. Inserimento atomico di più elementi.
54. Replace con strong failure guarantee.
55. Move semantics manuale.
56. Reference counting.
57. Copy-on-write.
58. Pool allocator.
59. Arena allocator.
60. Distruttori nidificati.

## Eterogeneità e polimorfismo

61. Tagged union per token.
62. Tagged union per espressioni.
63. Array eterogeneo stampabile.
64. Vtable per animali.
65. Vtable per file virtuali.
66. Plugin registry con context.
67. Event bus con più subscriber.
68. Command pattern con undo.
69. Visitor manuale su tagged union.
70. Serializer configurabile.

## Problemi stile esame

71. Generic filter-map.
72. Generic zip di due array.
73. Generic merge di k sequenze.
74. Generic top-k con heap.
75. Generic frequency table.
76. Group-by con chiave estratta da callback.
77. Distinct-by con key extractor.
78. Stable sort di record con criterio runtime.
79. Priority queue di processi.
80. Scheduler con callback.
81. Set generico di stringhe.
82. BST generico di persone.
83. Lista generica di struct con stringhe dinamiche.
84. Clonazione profonda di contenitori annidati.
85. Serializzazione di un ADT opaco.

---

# 14. Errori tipici da riconoscere

## Dereferenziare `void *`

Sbagliato:

```c
int x = *p;
```

Corretto:

```c
int x = *(int *)p;
```

## Cast al tipo errato

Il compilatore non può proteggere da:

```c
double *d = p;
```

se `p` punta in realtà a un `int`.

## Comparatore con sottrazione

```c
return x - y;
```

può overfloware.

## Firma callback incompatibile

Una funzione:

```c
int compareIntValues(int a, int b);
```

non può essere passata a `qsort`, che richiede:

```c
int compare(const void *, const void *);
```

## Confondere `sizeof(pointer)` e `sizeof(element)`

Sbagliato:

```c
qsort(a, n, sizeof(a), compareInt);
```

dentro una funzione.

Corretto:

```c
sizeof(*a)
```

## Shallow copy involontaria

```c
memcpy` di una struct con `char *`
```

copia il puntatore, non la stringa.

## Distruttore mancante

Un contenitore owned deve distruggere ogni elemento prima di liberare i nodi o l'array.

## Distruttore usato su dati borrowed

Provoca free di memoria non posseduta.

## Doppio trasferimento di ownership

Lo stesso puntatore non può essere consegnato a due contenitori owned indipendenti.

## Restituire puntatore interno senza documentarlo

Il client potrebbe:

- liberarlo;
- conservarlo dopo una realloc;
- modificarlo violando invarianti.

## Callback `NULL`

Ogni operazione che dipende dalla callback deve verificarla o garantire per contratto che sia valida.

## Context dangling

Una callback registrata può conservare un `context` che diventa invalido prima dell'invocazione.

## Modificare una collezione durante l'iterazione

Può invalidare:

- indici;
- puntatori;
- iteratori;
- dimensioni.

---

# 15. Checklist di progettazione di un ADT generico

## Interfaccia

- [ ] tipo opaco nel `.h`;
- [ ] rappresentazione completa soltanto nel `.c`;
- [ ] prefisso coerente per i nomi;
- [ ] precondizioni documentate;
- [ ] errori distinguibili;
- [ ] funzioni `const` dove possibile;
- [ ] ownership documentata.

## Callback

- [ ] firme esatte;
- [ ] significato del ritorno documentato;
- [ ] `compare` coerente;
- [ ] `equal` riflessiva, simmetrica e transitiva;
- [ ] `clone` e `destroy` compatibili;
- [ ] context valido per tutta la durata richiesta.

## Memoria

- [ ] ogni clone distrutto esattamente una volta;
- [ ] cleanup parziale;
- [ ] `realloc` con temporaneo;
- [ ] nessun use-after-free;
- [ ] nessun double free;
- [ ] nessun puntatore borrowed distrutto;
- [ ] trasferimento di ownership non ambiguo.

## Invarianti

- [ ] `size <= capacity`;
- [ ] dati validi nelle posizioni usate;
- [ ] ordinamento preservato;
- [ ] duplicati vietati se set;
- [ ] front/rear coerenti se coda;
- [ ] heap property se priority queue.

---

# 16. Ordine consigliato di allenamento

## Fase 1 — Sintassi delle callback

```text
1–6
```

Obiettivo:

- dichiarare;
- passare;
- restituire;
- memorizzare puntatori a funzione.

## Fase 2 — `void *` e memoria grezza

```text
7–14
```

Obiettivo:

- cast corretti;
- aritmetica con byte;
- `memcpy`;
- shallow copy consapevole.

## Fase 3 — Ordinamento e ricerca generici

```text
15–19
```

Obiettivo:

- comparator contract;
- `qsort`;
- `bsearch`;
- ordine dei parametri.

## Fase 4 — ADT opaco owned

```text
20–28
```

Obiettivo:

- `.h` contro `.c`;
- clone/destroy;
- failure atomicity;
- ownership.

## Fase 5 — Strutture generiche

```text
29–37
```

Obiettivo:

- lista;
- pila;
- coda;
- set;
- priority queue.

## Fase 6 — Algoritmi e tipi eterogenei

```text
38–49
```

Obiettivo:

- map/filter/reduce;
- tagged union;
- context;
- dispatcher;
- vtable.

## Fase 7 — Appelli infernali

```text
50–57
```

Obiettivo:

- compatibilità delle policy;
- generic BST;
- merge sort configurabile;
- rollback su errore;
- ownership complessa.

---

# 17. Scheda universale

```text
TIPO DELL'ADT:
____________________________________

TIPO OPACO?
____________________________________

RAPPRESENTAZIONE PRIVATA:
____________________________________

ELEMENTI:
by value / void* borrowed / owned copy / transferred

CLONE:
____________________________________

DESTROY:
____________________________________

EQUALITY:
____________________________________

COMPARE:
____________________________________

CONTEXT:
____________________________________

CHI POSSIEDE L'INPUT DOPO INSERT?
____________________________________

CHI POSSIEDE IL RISULTATO DOPO REMOVE?
____________________________________

COSA SUCCEDE SE MALLOC FALLISCE?
____________________________________

L'OPERAZIONE È ATOMICA SU FALLIMENTO?
____________________________________

PUNTATORI INTERNI RESTITUITI?
____________________________________

QUANDO DIVENTANO INVALIDI?
____________________________________

INVARIANTI:
____________________________________

TEMPO:
____________________________________

SPAZIO:
____________________________________
```

Le domande decisive sono:

> “Chi possiede l'oggetto puntato?”

e:

> “Quale operazione dipende dal tipo concreto?”

Quando il comportamento dipende dal tipo, serve una callback:

```text
confrontare
clonare
distruggere
stampare
filtrare
trasformare
```

Quando il contenitore non deve conoscere il tipo concreto, può memorizzare:

```c
void *
```

Ma la genericità non elimina la responsabilità sui tipi: la sposta dal compilatore al contratto tra ADT e client.

La soluzione robusta nasce dall'unione di quattro elementi:

```text
tipo opaco
+ callback coerenti
+ ownership esplicita
+ cleanup corretto su ogni errore
```
