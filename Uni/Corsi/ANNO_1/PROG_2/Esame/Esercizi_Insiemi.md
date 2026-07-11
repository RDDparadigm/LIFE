# Programmazione 2 — Esercizi sugli insiemi

> Raccolta progressiva in stile esame: consegna, struttura di partenza, soluzione semplice, eventuale soluzione ottimizzata, complessità, casi limite, invarianti, ownership ed errori tipici.
>
> Focus:
>
> - insiemi di interi;
> - rappresentazione con array, array ordinati e liste linkate;
> - insiemi come ADT opachi;
> - assenza di duplicati;
> - appartenenza, inserimento, rimozione;
> - unione, intersezione, differenza e differenza simmetrica;
> - confronti tra soluzioni `O(nm)`, `O(n log n)` e `O(n+m)`;
> - insiemi generici con `void *` e funzioni di confronto;
> - esercizi misti in stile LeetCode;
> - hidden test e gestione corretta della memoria.

Compilazione consigliata:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    -g -fsanitize=address,undefined file.c -o file
```

---

# 0. Idee fondamentali

## 0.1 Definizione

Un insieme è una collezione di elementi:

```text
senza duplicati
```

L'ordine, dal punto di vista astratto, non è significativo.

Esempio valido:

```text
{1, 4, 7}
```

Esempio non valido:

```text
{1, 4, 4, 7}
```

## 0.2 Operazioni fondamentali

```text
create
destroy
contains
insert
remove
size
isEmpty
clear
```

Operazioni tra insiemi:

```text
union
intersection
difference
symmetric difference
subset
proper subset
equality
disjointness
```

## 0.3 Rappresentazioni

### Array non ordinato

Vantaggi:

- semplice;
- inserimento in fondo `O(1)` se c'è capacità;
- rimozione rapida se l'ordine interno non conta.

Svantaggi:

- `contains`: `O(n)`;
- inserimento: `O(n)` perché bisogna evitare duplicati.

### Array ordinato

Vantaggi:

- ricerca binaria `O(log n)`;
- merge tra insiemi ordinati `O(n+m)`.

Svantaggi:

- inserimento e rimozione richiedono spostamenti `O(n)`.

### Lista linkata non ordinata

Vantaggi:

- crescita dinamica;
- rimozione senza spostamenti.

Svantaggi:

- ricerca `O(n)`;
- unione e intersezione ingenue possono costare `O(nm)`.

### Lista linkata ordinata

Vantaggi:

- operazioni tra due insiemi in `O(n+m)`;
- inserimento ordinato senza spostare blocchi di memoria.

Svantaggi:

- ricerca ancora `O(n)`;
- località di memoria peggiore di un array.

### Tabella hash

Vantaggi:

- ricerca, inserimento e rimozione attesi `O(1)`.

Svantaggi:

- implementazione più complessa;
- gestione collisioni;
- peggior caso `O(n)`.

In questa raccolta si parte da array e liste, perché sono le rappresentazioni tipiche del corso.

---

# 1. ADT di base: insieme di interi con array dinamico non ordinato

---

## Esercizio 1 — Implementazione fondamentale

### Consegna

Implementare un ADT insieme di interi con array dinamico non ordinato.

Operazioni:

```c
IntSet *setCreate(void);
void setDestroy(IntSet **setPtr);
int setContains(const IntSet *set, int value);
int setInsert(IntSet *set, int value);
int setRemove(IntSet *set, int value);
size_t setSize(const IntSet *set);
```

Vincoli:

- nessun duplicato;
- `insert` restituisce:
  - `1` se inserisce;
  - `0` se il valore era già presente o l'allocazione fallisce;
- `remove` restituisce:
  - `1` se rimuove;
  - `0` se assente.

### Struttura di partenza

```c
#include <stddef.h>

typedef struct intSet IntSet;
```

### Soluzione semplice

```c
#include <stdlib.h>

struct intSet {
    int *data;
    size_t size;
    size_t capacity;
};

IntSet *setCreate(void) {
    IntSet *set = malloc(sizeof(*set));

    if (set == NULL) {
        return NULL;
    }

    set->data = NULL;
    set->size = 0;
    set->capacity = 0;

    return set;
}

size_t setSize(const IntSet *set) {
    return set == NULL ? 0 : set->size;
}

int setContains(const IntSet *set, int value) {
    if (set == NULL) {
        return 0;
    }

    for (size_t i = 0; i < set->size; i++) {
        if (set->data[i] == value) {
            return 1;
        }
    }

    return 0;
}

static int setReserve(IntSet *set, size_t newCapacity) {
    if (newCapacity <= set->capacity) {
        return 1;
    }

    int *tmp = realloc(
        set->data,
        newCapacity * sizeof(*tmp)
    );

    if (tmp == NULL) {
        return 0;
    }

    set->data = tmp;
    set->capacity = newCapacity;
    return 1;
}

int setInsert(IntSet *set, int value) {
    if (set == NULL || setContains(set, value)) {
        return 0;
    }

    if (set->size == set->capacity) {
        size_t newCapacity =
            set->capacity == 0 ? 4 : set->capacity * 2;

        if (!setReserve(set, newCapacity)) {
            return 0;
        }
    }

    set->data[set->size++] = value;
    return 1;
}

int setRemove(IntSet *set, int value) {
    if (set == NULL) {
        return 0;
    }

    for (size_t i = 0; i < set->size; i++) {
        if (set->data[i] == value) {
            set->data[i] = set->data[set->size - 1];
            set->size--;
            return 1;
        }
    }

    return 0;
}

void setDestroy(IntSet **setPtr) {
    if (setPtr == NULL || *setPtr == NULL) {
        return;
    }

    IntSet *set = *setPtr;

    free(set->data);
    free(set);

    *setPtr = NULL;
}
```

### Complessità

| Operazione | Tempo |
|---|---:|
| contains | `O(n)` |
| insert | `O(n)` |
| remove | `O(n)` |
| size | `O(1)` |
| destroy | `O(1)` per il buffer |

### Osservazione

La rimozione sostituisce l'elemento con l'ultimo:

```text
ordine interno non preservato
```

Per un insieme astratto va bene, salvo diversa specifica.

---

## Esercizio 2 — Clear senza distruggere l'ADT

### Consegna

Svuotare un insieme mantenendo allocato il buffer interno.

### Struttura

```c
void setClear(IntSet *set);
```

### Soluzione

```c
void setClear(IntSet *set) {
    if (set == NULL) {
        return;
    }

    set->size = 0;
}
```

### Complessità

- Tempo: `O(1)`
- Il contenuto logico sparisce.
- La capacità resta invariata.

### Variante

Per liberare anche il buffer:

```c
void setClearAndRelease(IntSet *set) {
    if (set == NULL) {
        return;
    }

    free(set->data);
    set->data = NULL;
    set->size = 0;
    set->capacity = 0;
}
```

---

## Esercizio 3 — Copia profonda

### Consegna

Creare una copia indipendente di un insieme.

### Struttura

```c
IntSet *setClone(const IntSet *source);
```

### Soluzione

```c
#include <string.h>

IntSet *setClone(const IntSet *source) {
    if (source == NULL) {
        return NULL;
    }

    IntSet *copy = setCreate();

    if (copy == NULL) {
        return NULL;
    }

    if (source->size == 0) {
        return copy;
    }

    copy->data = malloc(
        source->size * sizeof(*copy->data)
    );

    if (copy->data == NULL) {
        setDestroy(&copy);
        return NULL;
    }

    memcpy(
        copy->data,
        source->data,
        source->size * sizeof(*copy->data)
    );

    copy->size = source->size;
    copy->capacity = source->size;

    return copy;
}
```

### Punto d'esame

Questa copia:

```c
copy->data = source->data;
```

è shallow copy ed è sbagliata: entrambi gli ADT condividerebbero lo stesso buffer e il doppio `free` sarebbe inevitabile.

---

# 2. Proprietà tra insiemi

---

## Esercizio 4 — Uguaglianza

### Consegna

Verificare se due insiemi contengono esattamente gli stessi elementi.

### Struttura

```c
int setEquals(const IntSet *a, const IntSet *b);
```

### Soluzione semplice

```c
int setEquals(const IntSet *a, const IntSet *b) {
    if (a == NULL || b == NULL) {
        return a == b;
    }

    if (a->size != b->size) {
        return 0;
    }

    for (size_t i = 0; i < a->size; i++) {
        if (!setContains(b, a->data[i])) {
            return 0;
        }
    }

    return 1;
}
```

### Complessità

- Tempo: `O(nm)`
- Se `n == m`, `O(n²)`

### Perché basta controllare una direzione

Se:

```text
|A| = |B|
```

e ogni elemento di `A` appartiene a `B`, allora gli insiemi sono uguali.

---

## Esercizio 5 — Sottoinsieme

### Consegna

Restituire vero se `a` è sottoinsieme di `b`.

### Struttura

```c
int setIsSubset(const IntSet *a, const IntSet *b);
```

### Soluzione semplice

```c
int setIsSubset(const IntSet *a, const IntSet *b) {
    if (a == NULL || b == NULL) {
        return 0;
    }

    if (a->size > b->size) {
        return 0;
    }

    for (size_t i = 0; i < a->size; i++) {
        if (!setContains(b, a->data[i])) {
            return 0;
        }
    }

    return 1;
}
```

### Sottoinsieme proprio

```c
int setIsProperSubset(
    const IntSet *a,
    const IntSet *b
) {
    return
        a != NULL &&
        b != NULL &&
        a->size < b->size &&
        setIsSubset(a, b);
}
```

---

## Esercizio 6 — Disgiunzione

### Consegna

Verificare se due insiemi non hanno elementi in comune.

### Soluzione semplice

```c
int setAreDisjoint(
    const IntSet *a,
    const IntSet *b
) {
    if (a == NULL || b == NULL) {
        return 0;
    }

    const IntSet *small =
        a->size <= b->size ? a : b;

    const IntSet *large =
        a->size <= b->size ? b : a;

    for (size_t i = 0; i < small->size; i++) {
        if (setContains(large, small->data[i])) {
            return 0;
        }
    }

    return 1;
}
```

### Ottimizzazione semplice

Scorrere l'insieme più piccolo riduce il numero di ricerche.

---

# 3. Operazioni tra insiemi non ordinati

---

## Esercizio 7 — Unione

### Consegna

Restituire un nuovo insieme contenente tutti gli elementi di `a` o di `b`.

Gli input non devono essere modificati.

### Struttura

```c
IntSet *setUnion(const IntSet *a, const IntSet *b);
```

### Soluzione semplice

```c
IntSet *setUnion(const IntSet *a, const IntSet *b) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    IntSet *result = setClone(a);

    if (result == NULL) {
        return NULL;
    }

    for (size_t i = 0; i < b->size; i++) {
        if (!setContains(result, b->data[i])) {
            if (!setInsert(result, b->data[i])) {
                setDestroy(&result);
                return NULL;
            }
        }
    }

    return result;
}
```

### Complessità

- Peggiore: `O((n+m)²)` circa, perché ogni inserimento cerca duplicati.
- Spazio: `O(n+m)`.

### Nota

La doppia verifica:

```c
if (!contains) insert
```

fa due ricerche.

Più semplice:

```c
setInsert(result, b->data[i]);
```

ignorando il ritorno `0` per duplicato, ma così non si distingue duplicato da errore di memoria. Un ADT robusto dovrebbe usare un enum di esito.

---

## Esercizio 8 — Intersezione

### Consegna

Restituire un nuovo insieme contenente gli elementi presenti in entrambi.

### Soluzione semplice

```c
IntSet *setIntersection(
    const IntSet *a,
    const IntSet *b
) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    IntSet *result = setCreate();

    if (result == NULL) {
        return NULL;
    }

    const IntSet *small =
        a->size <= b->size ? a : b;

    const IntSet *large =
        a->size <= b->size ? b : a;

    for (size_t i = 0; i < small->size; i++) {
        if (setContains(large, small->data[i])) {
            if (!setInsert(result, small->data[i])) {
                setDestroy(&result);
                return NULL;
            }
        }
    }

    return result;
}
```

### Complessità

- Tempo: `O(min(n,m) * max(n,m))`
- Spazio: `O(min(n,m))`

---

## Esercizio 9 — Differenza

### Consegna

Restituire:

```text
A \ B
```

cioè gli elementi presenti in `a` ma non in `b`.

### Soluzione

```c
IntSet *setDifference(
    const IntSet *a,
    const IntSet *b
) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    IntSet *result = setCreate();

    if (result == NULL) {
        return NULL;
    }

    for (size_t i = 0; i < a->size; i++) {
        if (!setContains(b, a->data[i])) {
            if (!setInsert(result, a->data[i])) {
                setDestroy(&result);
                return NULL;
            }
        }
    }

    return result;
}
```

---

## Esercizio 10 — Differenza simmetrica

### Consegna

Restituire gli elementi presenti in esattamente uno dei due insiemi.

```text
(A \ B) ∪ (B \ A)
```

### Soluzione semplice

```c
IntSet *setSymmetricDifference(
    const IntSet *a,
    const IntSet *b
) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    IntSet *result = setCreate();

    if (result == NULL) {
        return NULL;
    }

    for (size_t i = 0; i < a->size; i++) {
        if (!setContains(b, a->data[i])) {
            if (!setInsert(result, a->data[i])) {
                setDestroy(&result);
                return NULL;
            }
        }
    }

    for (size_t i = 0; i < b->size; i++) {
        if (!setContains(a, b->data[i])) {
            if (!setInsert(result, b->data[i])) {
                setDestroy(&result);
                return NULL;
            }
        }
    }

    return result;
}
```

---

# 4. Array ordinati come insiemi

---

## Esercizio 11 — Ricerca binaria

### Consegna

Implementare `contains` su un insieme rappresentato da array ordinato.

### Struttura

```c
typedef struct {
    int *data;
    size_t size;
    size_t capacity;
} SortedIntSet;

int sortedSetContains(
    const SortedIntSet *set,
    int value
);
```

### Soluzione

```c
int sortedSetContains(
    const SortedIntSet *set,
    int value
) {
    size_t left = 0;
    size_t right = set->size;

    while (left < right) {
        size_t middle =
            left + (right - left) / 2;

        if (set->data[middle] == value) {
            return 1;
        }

        if (set->data[middle] < value) {
            left = middle + 1;
        } else {
            right = middle;
        }
    }

    return 0;
}
```

### Complessità

- Tempo: `O(log n)`
- Spazio: `O(1)`

---

## Esercizio 12 — Inserimento ordinato senza duplicati

### Consegna

Inserire un valore mantenendo l'array ordinato.

### Soluzione

```c
static size_t lowerBound(
    const int a[],
    size_t n,
    int value
) {
    size_t left = 0;
    size_t right = n;

    while (left < right) {
        size_t middle =
            left + (right - left) / 2;

        if (a[middle] < value) {
            left = middle + 1;
        } else {
            right = middle;
        }
    }

    return left;
}

int sortedSetInsert(
    SortedIntSet *set,
    int value
) {
    if (set == NULL) {
        return 0;
    }

    size_t index =
        lowerBound(set->data, set->size, value);

    if (
        index < set->size &&
        set->data[index] == value
    ) {
        return 0;
    }

    if (set->size == set->capacity) {
        size_t newCapacity =
            set->capacity == 0 ? 4 :
            set->capacity * 2;

        int *tmp = realloc(
            set->data,
            newCapacity * sizeof(*tmp)
        );

        if (tmp == NULL) {
            return 0;
        }

        set->data = tmp;
        set->capacity = newCapacity;
    }

    for (size_t i = set->size; i > index; i--) {
        set->data[i] = set->data[i - 1];
    }

    set->data[index] = value;
    set->size++;

    return 1;
}
```

### Complessità

- ricerca posizione: `O(log n)`
- spostamento: `O(n)`
- totale: `O(n)`

---

## Esercizio 13 — Rimozione ordinata

### Soluzione

```c
int sortedSetRemove(
    SortedIntSet *set,
    int value
) {
    if (set == NULL) {
        return 0;
    }

    size_t index =
        lowerBound(set->data, set->size, value);

    if (
        index == set->size ||
        set->data[index] != value
    ) {
        return 0;
    }

    for (size_t i = index + 1; i < set->size; i++) {
        set->data[i - 1] = set->data[i];
    }

    set->size--;
    return 1;
}
```

---

## Esercizio 14 — Unione lineare di due insiemi ordinati

### Consegna

Dati due array ordinati senza duplicati, restituire l'unione ordinata.

### Struttura

```c
typedef struct {
    int *data;
    size_t size;
} IntArray;

IntArray unionSorted(
    const int a[],
    size_t n,
    const int b[],
    size_t m
);
```

### Soluzione

```c
#include <stdlib.h>

IntArray unionSorted(
    const int a[],
    size_t n,
    const int b[],
    size_t m
) {
    IntArray result = {NULL, 0};

    if (n + m == 0) {
        return result;
    }

    result.data = malloc(
        (n + m) * sizeof(*result.data)
    );

    if (result.data == NULL) {
        return result;
    }

    size_t i = 0;
    size_t j = 0;
    size_t k = 0;

    while (i < n && j < m) {
        if (a[i] < b[j]) {
            result.data[k++] = a[i++];
        } else if (b[j] < a[i]) {
            result.data[k++] = b[j++];
        } else {
            result.data[k++] = a[i];
            i++;
            j++;
        }
    }

    while (i < n) {
        result.data[k++] = a[i++];
    }

    while (j < m) {
        result.data[k++] = b[j++];
    }

    int *tmp = realloc(
        result.data,
        k * sizeof(*tmp)
    );

    if (tmp != NULL) {
        result.data = tmp;
    }

    result.size = k;
    return result;
}
```

### Complessità

- Tempo: `O(n+m)`
- Spazio: `O(n+m)`

---

## Esercizio 15 — Intersezione lineare ordinata

### Soluzione

```c
IntArray intersectionSortedUnique(
    const int a[],
    size_t n,
    const int b[],
    size_t m
) {
    IntArray result = {NULL, 0};

    size_t maxSize = n < m ? n : m;

    if (maxSize == 0) {
        return result;
    }

    result.data = malloc(
        maxSize * sizeof(*result.data)
    );

    if (result.data == NULL) {
        return result;
    }

    size_t i = 0;
    size_t j = 0;
    size_t k = 0;

    while (i < n && j < m) {
        if (a[i] < b[j]) {
            i++;
        } else if (b[j] < a[i]) {
            j++;
        } else {
            result.data[k++] = a[i];
            i++;
            j++;
        }
    }

    if (k == 0) {
        free(result.data);
        result.data = NULL;
    } else {
        int *tmp = realloc(
            result.data,
            k * sizeof(*tmp)
        );

        if (tmp != NULL) {
            result.data = tmp;
        }
    }

    result.size = k;
    return result;
}
```

---

## Esercizio 16 — Differenza lineare ordinata

### Consegna

Restituire `A \ B` con array ordinati senza duplicati.

### Soluzione

```c
IntArray differenceSorted(
    const int a[],
    size_t n,
    const int b[],
    size_t m
) {
    IntArray result = {NULL, 0};

    if (n == 0) {
        return result;
    }

    result.data = malloc(
        n * sizeof(*result.data)
    );

    if (result.data == NULL) {
        return result;
    }

    size_t i = 0;
    size_t j = 0;
    size_t k = 0;

    while (i < n && j < m) {
        if (a[i] < b[j]) {
            result.data[k++] = a[i++];
        } else if (b[j] < a[i]) {
            j++;
        } else {
            i++;
            j++;
        }
    }

    while (i < n) {
        result.data[k++] = a[i++];
    }

    result.size = k;
    return result;
}
```

---

## Esercizio 17 — Verifica sottoinsieme in tempo lineare

### Consegna

Dati due insiemi ordinati, verificare se `a` è sottoinsieme di `b`.

### Soluzione

```c
int isSubsetSorted(
    const int a[],
    size_t n,
    const int b[],
    size_t m
) {
    size_t i = 0;
    size_t j = 0;

    while (i < n && j < m) {
        if (a[i] == b[j]) {
            i++;
            j++;
        } else if (a[i] > b[j]) {
            j++;
        } else {
            return 0;
        }
    }

    return i == n;
}
```

### Complessità

- Tempo: `O(n+m)`
- Spazio: `O(1)`

---

# 5. Insiemi con lista linkata ordinata

---

## Esercizio 18 — Struttura e inserimento ordinato

### Struttura di partenza

```c
typedef struct setNode SetNode;

struct setNode {
    int data;
    SetNode *next;
};

typedef struct {
    SetNode *head;
    size_t size;
} LinkedIntSet;
```

### Inserimento

```c
int linkedSetInsert(
    LinkedIntSet *set,
    int value
) {
    if (set == NULL) {
        return 0;
    }

    SetNode **cursor = &set->head;

    while (
        *cursor != NULL &&
        (*cursor)->data < value
    ) {
        cursor = &(*cursor)->next;
    }

    if (
        *cursor != NULL &&
        (*cursor)->data == value
    ) {
        return 0;
    }

    SetNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        return 0;
    }

    node->data = value;
    node->next = *cursor;
    *cursor = node;
    set->size++;

    return 1;
}
```

### Perché `SetNode **cursor`

`cursor` punta al collegamento che deve essere modificato:

- `&set->head`;
- oppure `&previous->next`.

Così l'inserimento in testa e in mezzo usa lo stesso codice.

---

## Esercizio 19 — Rimozione con puntatore a puntatore

### Soluzione

```c
int linkedSetRemove(
    LinkedIntSet *set,
    int value
) {
    if (set == NULL) {
        return 0;
    }

    SetNode **cursor = &set->head;

    while (
        *cursor != NULL &&
        (*cursor)->data < value
    ) {
        cursor = &(*cursor)->next;
    }

    if (
        *cursor == NULL ||
        (*cursor)->data != value
    ) {
        return 0;
    }

    SetNode *victim = *cursor;
    *cursor = victim->next;

    free(victim);
    set->size--;

    return 1;
}
```

---

## Esercizio 20 — Intersezione di liste ordinate

### Consegna

Restituire un nuovo insieme linkato ordinato.

### Soluzione semplice

```c
LinkedIntSet *linkedSetIntersection(
    const LinkedIntSet *a,
    const LinkedIntSet *b
) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    LinkedIntSet *result =
        calloc(1, sizeof(*result));

    if (result == NULL) {
        return NULL;
    }

    SetNode *tail = NULL;
    const SetNode *pa = a->head;
    const SetNode *pb = b->head;

    while (pa != NULL && pb != NULL) {
        if (pa->data < pb->data) {
            pa = pa->next;
        } else if (pb->data < pa->data) {
            pb = pb->next;
        } else {
            SetNode *node = malloc(sizeof(*node));

            if (node == NULL) {
                /* distruzione result omessa qui per brevità */
                return NULL;
            }

            node->data = pa->data;
            node->next = NULL;

            if (tail == NULL) {
                result->head = node;
            } else {
                tail->next = node;
            }

            tail = node;
            result->size++;

            pa = pa->next;
            pb = pb->next;
        }
    }

    return result;
}
```

### Complessità

- Tempo: `O(n+m)`
- Spazio: `O(k)` per l'output

---

## Esercizio 21 — Unione in place riutilizzando i nodi

### Consegna

Date due liste ordinate senza duplicati, fondere i nodi in una sola lista ordinata senza allocare nuovi nodi.

I duplicati devono essere eliminati liberando uno dei due nodi uguali.

Dopo l'operazione, la seconda lista deve risultare vuota.

### Struttura

```c
void linkedSetUnionMove(
    LinkedIntSet *a,
    LinkedIntSet *b
);
```

### Idea

È un merge in place:

- confrontare i nodi correnti;
- collegare il minore;
- se uguali, conservare un nodo e liberare l'altro;
- aggiornare `size`;
- azzerare `b`.

### Punto difficile

Qui la specifica non chiede una nuova struttura:

```text
riuso dei nodi
ownership trasferita
nessuna nuova malloc
```

---

# 6. Costruire insiemi da sequenze

---

## Esercizio 22 — Array con duplicati → insieme

### Consegna

Dato un array non ordinato, costruire un nuovo array contenente ogni valore una sola volta, nell'ordine della prima occorrenza.

Esempio:

```text
[4,2,4,1,2,9] → [4,2,1,9]
```

### Soluzione semplice `O(n²)`

```c
IntArray uniqueStable(
    const int a[],
    size_t n
) {
    IntArray result = {NULL, 0};

    result.data = malloc(
        n * sizeof(*result.data)
    );

    if (result.data == NULL && n > 0) {
        return result;
    }

    for (size_t i = 0; i < n; i++) {
        int found = 0;

        for (size_t j = 0; j < result.size; j++) {
            if (result.data[j] == a[i]) {
                found = 1;
                break;
            }
        }

        if (!found) {
            result.data[result.size++] = a[i];
        }
    }

    return result;
}
```

### Complessità

- Tempo: `O(n²)`
- Spazio: `O(n)`

### Soluzioni alternative

- ordinare una copia: `O(n log n)`, ma perde l'ordine della prima occorrenza;
- hash set: tempo atteso `O(n)`.

---

## Esercizio 23 — Stringa → insieme di caratteri alfabetici

### Consegna

Restituire una nuova stringa contenente tutte le lettere ASCII distinte presenti nell'input, convertite in minuscolo e ordinate alfabeticamente.

Esempio:

```text
"Programmazione 2!" → "agimnorpz"
```

### Soluzione con tabella booleana

```c
#include <stdlib.h>

char *alphabeticSet(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    _Bool present[26] = {0};
    size_t count = 0;

    for (size_t i = 0; s[i] != '\0'; i++) {
        char c = s[i];

        if (c >= 'A' && c <= 'Z') {
            c = (char)(c - 'A' + 'a');
        }

        if (c >= 'a' && c <= 'z') {
            size_t index = (size_t)(c - 'a');

            if (!present[index]) {
                present[index] = 1;
                count++;
            }
        }
    }

    char *result = malloc(count + 1);

    if (result == NULL) {
        return NULL;
    }

    size_t write = 0;

    for (size_t i = 0; i < 26; i++) {
        if (present[i]) {
            result[write++] = (char)('a' + i);
        }
    }

    result[write] = '\0';
    return result;
}
```

### Complessità

- Tempo: `O(n + 26)` → `O(n)`
- Spazio ausiliario: `O(1)`

---

## Esercizio 24 — Due array: elementi esclusivi

### Consegna

Dati due array, restituire un insieme con i valori presenti in uno solo dei due.

Gli input possono contenere duplicati.

### Strategia semplice

1. Costruire `setA`.
2. Costruire `setB`.
3. Calcolare la differenza simmetrica.

### Punto d'esame

Bisogna distinguere:

```text
sequenza con duplicati
insieme senza duplicati
```

---

# 7. Problemi classici in stile LeetCode

---

## Esercizio 25 — Contains duplicate

### Consegna

Verificare se un array contiene almeno un duplicato.

### Soluzione semplice

```c
int containsDuplicateQuadratic(
    const int a[],
    size_t n
) {
    for (size_t i = 0; i < n; i++) {
        for (size_t j = i + 1; j < n; j++) {
            if (a[i] == a[j]) {
                return 1;
            }
        }
    }

    return 0;
}
```

### Complessità

- Tempo: `O(n²)`
- Spazio: `O(1)`

### Soluzione ordinando una copia

- Copia array.
- `qsort`.
- Controlla elementi consecutivi.

Complessità:

```text
tempo O(n log n)
spazio O(n)
```

---

## Esercizio 26 — Happy number

### Consegna

Dato un intero positivo, ripetere:

```text
somma dei quadrati delle cifre
```

Restituire vero se si raggiunge `1`, falso se si entra in un ciclo.

### Soluzione semplice con insieme dei valori già visti

```c
static unsigned int squareDigitSum(
    unsigned int n
) {
    unsigned int sum = 0;

    while (n > 0) {
        unsigned int digit = n % 10;
        sum += digit * digit;
        n /= 10;
    }

    return sum;
}

int isHappy(unsigned int n) {
    IntSet *seen = setCreate();

    if (seen == NULL) {
        return 0;
    }

    while (n != 1) {
        if (setContains(seen, (int)n)) {
            setDestroy(&seen);
            return 0;
        }

        if (!setInsert(seen, (int)n)) {
            setDestroy(&seen);
            return 0;
        }

        n = squareDigitSum(n);
    }

    setDestroy(&seen);
    return 1;
}
```

### Soluzione ottimizzata

Usare Floyd cycle detection:

```text
slow = f(slow)
fast = f(f(fast))
```

Spazio `O(1)`.

---

## Esercizio 27 — Longest consecutive sequence

### Consegna

Dato un array non ordinato, trovare la lunghezza della più lunga sequenza di interi consecutivi.

Esempio:

```text
[100,4,200,1,3,2] → 4
```

La sequenza è:

```text
1,2,3,4
```

### Soluzione semplice

Ordinare una copia:

- `O(n log n)`.

### Soluzione con hash set

Per ogni valore `x`, iniziare una sequenza solo se:

```text
x - 1 non appartiene all'insieme
```

Poi avanzare finché:

```text
x + 1, x + 2, ...
```

appartengono.

Tempo atteso `O(n)`.

### Perché non partire da ogni elemento

Si ripeterebbe più volte lo stesso lavoro.

---

## Esercizio 28 — Intersezione di due array senza duplicati

### Consegna

Restituire ogni valore comune una sola volta.

### Soluzione semplice

1. Inserire tutti gli elementi del primo array in un set.
2. Scorrere il secondo.
3. Se il valore appartiene:
   - aggiungerlo al risultato;
   - rimuoverlo dal set per evitare duplicati.

### Complessità

Con hash set:

- tempo atteso `O(n+m)`;
- spazio `O(n)`.

---

## Esercizio 29 — Anagrammi

### Consegna

Verificare se due stringhe ASCII sono anagrammi.

### Soluzione con frequenze

```c
#include <limits.h>

int areAnagrams(
    const char *a,
    const char *b
) {
    if (a == NULL || b == NULL) {
        return 0;
    }

    int frequency[UCHAR_MAX + 1] = {0};

    size_t i = 0;

    while (a[i] != '\0') {
        frequency[(unsigned char)a[i]]++;
        i++;
    }

    i = 0;

    while (b[i] != '\0') {
        frequency[(unsigned char)b[i]]--;
        i++;
    }

    for (size_t c = 0; c <= UCHAR_MAX; c++) {
        if (frequency[c] != 0) {
            return 0;
        }
    }

    return 1;
}
```

### Osservazione

Tecnicamente una tabella di frequenza non è un set, perché memorizza molteplicità. Ma il pattern deriva dalla stessa idea di appartenenza e unicità.

---

## Esercizio 30 — Isomorphic strings

### Consegna

Verificare se esiste una corrispondenza biunivoca tra i caratteri di due stringhe.

Esempi:

```text
"egg", "add" → vero
"foo", "bar" → falso
```

### Idea

Servono due mappe:

```text
a → b
b → a
```

Una sola direzione non basta.

---

## Esercizio 31 — Word pattern

### Consegna

Verificare se una sequenza di parole segue un pattern di caratteri con corrispondenza biunivoca.

Esempio:

```text
pattern = "abba"
words = "dog cat cat dog"
→ vero
```

### Strutture utili

- mappa carattere → parola;
- insieme delle parole già associate.

---

## Esercizio 32 — Sudoku valido

### Consegna

Verificare che una griglia `9×9` parzialmente compilata non contenga duplicati:

- in ogni riga;
- in ogni colonna;
- in ogni blocco `3×3`.

### Soluzione con insiemi booleani

Per ogni cella con cifra `d`:

```text
rowSeen[row][d]
colSeen[col][d]
boxSeen[box][d]
```

Indice del blocco:

```c
box = (row / 3) * 3 + col / 3;
```

### Complessità

- Tempo: `O(81)` → costante
- Spazio: costante

---

# 8. Insiemi generici con void*

---

## Esercizio 33 — ADT generico

### Consegna

Implementare un insieme generico con lista linkata.

Il confronto di uguaglianza è fornito dal chiamante.

### Struttura di partenza

```c
typedef int (*EqualFn)(
    const void *a,
    const void *b
);

typedef void *(*CloneFn)(
    const void *value
);

typedef void (*DestroyFn)(
    void *value
);

typedef struct genericSet GenericSet;

GenericSet *genericSetCreate(
    EqualFn equal,
    CloneFn clone,
    DestroyFn destroy
);
```

### Struttura interna

```c
typedef struct genericNode GenericNode;

struct genericNode {
    void *data;
    GenericNode *next;
};

struct genericSet {
    GenericNode *head;
    size_t size;
    EqualFn equal;
    CloneFn clone;
    DestroyFn destroy;
};
```

### Inserimento con deep copy

```c
int genericSetInsert(
    GenericSet *set,
    const void *value
) {
    if (set == NULL || value == NULL) {
        return 0;
    }

    for (
        GenericNode *p = set->head;
        p != NULL;
        p = p->next
    ) {
        if (set->equal(p->data, value)) {
            return 0;
        }
    }

    void *copy = set->clone(value);

    if (copy == NULL) {
        return 0;
    }

    GenericNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        set->destroy(copy);
        return 0;
    }

    node->data = copy;
    node->next = set->head;
    set->head = node;
    set->size++;

    return 1;
}
```

### Distruzione

```c
void genericSetDestroy(
    GenericSet **setPtr
) {
    if (setPtr == NULL || *setPtr == NULL) {
        return;
    }

    GenericSet *set = *setPtr;

    while (set->head != NULL) {
        GenericNode *victim = set->head;
        set->head = victim->next;

        set->destroy(victim->data);
        free(victim);
    }

    free(set);
    *setPtr = NULL;
}
```

### Ownership

Questa versione:

```text
copia ogni valore in ingresso
possiede la copia
la distrugge con destroy
```

---

## Esercizio 34 — Insieme di struct Persona

### Struttura

```c
typedef struct {
    char *name;
    char *taxCode;
} Person;
```

L'identità è determinata da:

```text
taxCode
```

non dal nome.

### Funzione di uguaglianza

```c
int personEqual(
    const void *a,
    const void *b
) {
    const Person *pa = a;
    const Person *pb = b;

    return strcmp(pa->taxCode, pb->taxCode) == 0;
}
```

### Punto d'esame

Due persone omonime possono essere diverse.

La funzione di uguaglianza deve riflettere la nozione di identità richiesta dalla specifica.

---

## Esercizio 35 — Unione generica

### Consegna

Creare un nuovo insieme generico unendo due insiemi compatibili.

### Problema

Gli insiemi sono compatibili solo se usano le stesse politiche:

```text
equal
clone
destroy
```

In C confrontare puntatori a funzione per uguaglianza è possibile.

### Strategia

1. Verificare compatibilità.
2. Creare risultato.
3. Inserire tutti gli elementi di `a`.
4. Inserire tutti gli elementi di `b`.
5. Ogni inserimento crea la propria copia.

---

# 9. Problemi misti e difficili

---

## Esercizio 36 — Copertura minima di insiemi piccoli

### Consegna

Dato un insieme universo `U` e una collezione di sottoinsiemi, trovare il numero minimo di sottoinsiemi la cui unione copre `U`.

### Soluzione semplice

Backtracking:

- scegli/non scegli ogni sottoinsieme;
- mantieni l'unione corrente;
- quando copre `U`, aggiorna il minimo.

### Complessità

- Tempo esponenziale `O(2^m)`, dove `m` è il numero di sottoinsiemi.

### Pruning

Interrompere se il numero di sottoinsiemi già scelti è almeno il miglior risultato noto.

---

## Esercizio 37 — Jaccard similarity

### Consegna

Calcolare:

```text
J(A,B) = |A ∩ B| / |A ∪ B|
```

Per due insiemi vuoti, definire il risultato come `1.0`.

### Soluzione semplice

```c
double jaccard(
    const IntSet *a,
    const IntSet *b
) {
    if (a == NULL || b == NULL) {
        return 0.0;
    }

    if (a->size == 0 && b->size == 0) {
        return 1.0;
    }

    size_t intersection = 0;

    for (size_t i = 0; i < a->size; i++) {
        if (setContains(b, a->data[i])) {
            intersection++;
        }
    }

    size_t unionSize =
        a->size + b->size - intersection;

    return (double)intersection /
           (double)unionSize;
}
```

---

## Esercizio 38 — Massimo sottoinsieme senza coppie incompatibili

### Consegna

Dato un insieme di valori e un insieme di coppie incompatibili, trovare la cardinalità massima di un sottoinsieme che non contenga entrambe le estremità di nessuna coppia.

### Natura del problema

È una variante di maximum independent set.

### Soluzione semplice

Backtracking esponenziale.

### Punto didattico

Non tutti i problemi sugli insiemi hanno una soluzione polinomiale semplice.

---

## Esercizio 39 — Subset sum con insieme degli stati raggiungibili

### Consegna

Dato un array di interi non negativi, verificare se esiste un sottoinsieme con somma `target`.

### Soluzione iterativa con insieme delle somme

Partire da:

```text
reachable = {0}
```

Per ogni valore `x`:

```text
newSums = {s + x | s ∈ reachable}
reachable = reachable ∪ newSums
```

### Trappola

Non bisogna inserire direttamente nel set che si sta iterando, altrimenti lo stesso elemento potrebbe essere usato più volte nello stesso passaggio.

---

## Esercizio 40 — Longest substring without repeating characters

### Consegna

Trovare la lunghezza della più lunga sottostringa senza caratteri ripetuti.

### Soluzione con sliding window e set

- espandere `right`;
- se il carattere è già nel set:
  - rimuovere da sinistra finché sparisce;
- inserire il carattere;
- aggiornare il massimo.

### Complessità

- Tempo atteso: `O(n)`
- Ogni carattere entra ed esce dal set al massimo una volta.

---

## Esercizio 41 — Minimum window containing a set of required symbols

### Consegna

Data una stringa e un insieme di caratteri distinti richiesti, trovare la lunghezza della finestra minima che li contiene tutti.

### Idea

Sliding window:

```text
required set
current frequency
numero di caratteri richiesti soddisfatti
```

### Nota

Se sono richieste molteplicità, un semplice set non basta: serve una mappa di frequenze.

---

## Esercizio 42 — Dynamic set snapshots

### Consegna

Gestire una sequenza di operazioni:

```text
ADD x
REMOVE x
SNAPSHOT
ROLLBACK
```

Ogni snapshot salva lo stato corrente dell'insieme.

### Soluzione semplice

Pila di copie profonde dell'insieme.

### Complessità

- snapshot: `O(n)`
- rollback: `O(n)` se si copia nuovamente, oppure `O(1)` trasferendo ownership.

### Variante avanzata

Persistent data structure o log delle modifiche.

---

# 10. Tracce aggiuntive senza soluzione completa

## Operazioni fondamentali

1. Implementare `setPopAny`.
2. Restituire un elemento arbitrario senza rimuoverlo.
3. Ridurre la capacità del buffer al minimo.
4. Verificare l'invariante “nessun duplicato”.
5. Rimuovere tutti i valori minori di una soglia.
6. Applicare una funzione a ogni elemento.
7. Convertire un set in array ordinato.
8. Convertire un array ordinato in set.
9. Fondere tre insiemi.
10. Calcolare l'intersezione di `k` insiemi.

## Array e liste

11. Rimuovere duplicati da un array in place.
12. Rimuovere duplicati da una lista non ordinata.
13. Rimuovere duplicati da una lista ordinata.
14. Costruire una lista ordinata senza duplicati da un array.
15. Unire due liste ordinate riutilizzando nodi.
16. Calcolare differenza simmetrica in place.
17. Verificare uguaglianza tra lista ordinata e array ordinato.
18. Convertire set non ordinato in set ordinato.
19. Partizionare un set secondo un predicato.
20. Copiare solo gli elementi pari.

## Stringhe

21. Restituire le lettere comuni a due stringhe.
22. Restituire le lettere presenti in una sola stringa.
23. Verificare se una stringa contiene tutte le vocali.
24. Trovare la prima parola con tutte lettere distinte.
25. Raggruppare parole per insieme di lettere.
26. Verificare pangramma.
27. Calcolare similarità Jaccard tra due testi.
28. Trovare caratteri mancanti dall'alfabeto.
29. Verificare se due frasi usano lo stesso vocabolario.
30. Eliminare parole duplicate preservando la prima occorrenza.

## Problemi algoritmici

31. Contains nearby duplicate.
32. Contains duplicate within distance `k`.
33. Two sum con set.
34. Three sum unique triplets.
35. Four sum unique quadruplets.
36. Longest consecutive sequence.
37. Missing number.
38. First missing positive.
39. Find all duplicates in array.
40. Find disappeared numbers.
41. Intersection of multiple arrays.
42. Unique email addresses.
43. Distinct islands in a grid.
44. Number of distinct substrings.
45. Repeated DNA sequences.
46. Set matrix zeroes con insiemi di righe e colonne.
47. Determine if two arrays are disjoint.
48. Minimum number of removals to make two arrays disjoint.
49. Maximum unique split of a string.
50. Partition labels.

## Generici e avanzati

51. Generic set con shallow ownership.
52. Generic set con ownership trasferita.
53. Generic ordered set con comparatore.
54. Generic union con politiche compatibili.
55. Set di stringhe con deep copy.
56. Set di struct con chiave composta.
57. Hash set con chaining.
58. Hash set con open addressing.
59. Rehashing dinamico.
60. Bloom filter semplificato.

---

# 11. Errori tipici

## Inserire senza controllare i duplicati

```c
set->data[set->size++] = value;
```

Viola immediatamente l'invariante dell'insieme.

## Confondere insieme e multinsieme

```text
set:        una sola copia
multiset:   più copie con molteplicità
```

## Uguaglianza dipendente dall'ordine

Sbagliato:

```c
for (i = 0; i < n; i++) {
    if (a[i] != b[i]) return 0;
}
```

Questo confronta sequenze, non insiemi.

## Differenza non simmetrica

```text
A \ B ≠ B \ A
```

## Modificare l'input quando la consegna chiede un nuovo insieme

L'algoritmo può produrre il risultato corretto ma fallire gli hidden test che verificano gli argomenti.

## Double free nel generic set

Se due insiemi condividono lo stesso puntatore senza clone, entrambi non possono considerarsene proprietari.

## Confronto sbagliato

Per struct complesse:

```text
uguaglianza logica
```

non significa necessariamente confronto byte-per-byte con `memcmp`.

## Realloc non sicuro

```c
set->data = realloc(set->data, ...);
```

può perdere il vecchio buffer.

---

# 12. Checklist di test

## Insieme vuoto

- [ ] size `0`;
- [ ] contains falso;
- [ ] remove falso;
- [ ] union con vuoto;
- [ ] intersection con vuoto;
- [ ] empty subset of every set.

## Inserimento

- [ ] primo elemento;
- [ ] duplicato;
- [ ] crescita capacità;
- [ ] valori negativi;
- [ ] valore `0`;
- [ ] `INT_MIN`, `INT_MAX`.

## Rimozione

- [ ] assente;
- [ ] unico elemento;
- [ ] primo;
- [ ] ultimo;
- [ ] elemento centrale;
- [ ] nuova insert dopo svuotamento.

## Operazioni tra insiemi

- [ ] entrambi vuoti;
- [ ] uno vuoto;
- [ ] uguali;
- [ ] disgiunti;
- [ ] uno sottoinsieme dell'altro;
- [ ] intersezione parziale;
- [ ] differenza non simmetrica;
- [ ] input invariati.

## Generic set

- [ ] clone profondo;
- [ ] destroy chiamata esattamente una volta;
- [ ] due valori distinti ma logicamente uguali;
- [ ] fallimento clone;
- [ ] fallimento malloc nodo;
- [ ] cleanup parziale.

---

# 13. Ordine consigliato di allenamento

## Fase 1 — Invarianti e ADT

```text
1, 2, 3, 4, 5, 6
```

Obiettivo:

- nessun duplicato;
- ownership;
- differenza tra insieme e sequenza.

## Fase 2 — Operazioni classiche

```text
7, 8, 9, 10
```

Obiettivo:

- derivare unione, intersezione e differenza dalla membership.

## Fase 3 — Ordinamento e due cursori

```text
11–17
```

Obiettivo:

- sfruttare input ordinati;
- passare da `O(nm)` a `O(n+m)`.

## Fase 4 — Liste e trasformazioni

```text
18–24
```

Obiettivo:

- inserimento ordinato;
- puntatore a puntatore;
- costruzione di output senza duplicati.

## Fase 5 — Stile LeetCode

```text
25–32
```

Obiettivo:

- riconoscere quando serve set, mappa o frequenza.

## Fase 6 — Generici e appelli difficili

```text
33–42
```

Obiettivo:

- `void *`;
- callback;
- deep copy;
- backtracking;
- snapshot;
- sliding window.

---

# 14. Schema universale

```text
UNIVERSO DEI VALORI:
____________________________________

NOZIONE DI UGUAGLIANZA:
____________________________________

RAPPRESENTAZIONE:
array / array ordinato / lista / hash

INVARIANTE:
nessun duplicato
____________________________________

OWNERSHIP:
____________________________________

CONTA L'ORDINE?
____________________________________

CONTA LA MOLTEPLICITÀ?
____________________________________

COSTO CONTAINS:
____________________________________

COSTO INSERT:
____________________________________

COSTO REMOVE:
____________________________________

INPUT ORDINATI?
____________________________________

SI PUÒ USARE DUE CURSORI?
____________________________________

SI DEVE PRESERVARE L'INPUT?
____________________________________

OUTPUT NUOVO O IN PLACE?
____________________________________

CASI LIMITE:
____________________________________
```

La domanda decisiva è:

> “Sto lavorando con una sequenza o con una collezione senza duplicati?”

Subito dopo:

> “Posso sfruttare ordinamento, dominio limitato o hashing per evitare confronti ripetuti?”

Molti esercizi sugli insiemi cambiano completamente complessità quando si passa da:

```text
per ogni elemento di A, cerca in B
```

a:

```text
scorri A e B una sola volta
```

oppure:

```text
memorizza appartenenza in una struttura ad accesso rapido
```
