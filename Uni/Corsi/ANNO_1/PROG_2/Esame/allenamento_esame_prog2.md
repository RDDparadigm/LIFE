# Programmazione 2 — Allenamento da esame: codice da riscrivere fino alla nausea

> Obiettivo: arrivare agli esercizi di programmazione sapendo scrivere **a memoria**, senza panico, le funzioni tipiche su puntatori, `malloc/free`, stringhe, struct, liste, stack, code, set, alberi, file e TDD.
>
> Metodo consigliato: per ogni blocco fai così:
>
> 1. leggi solo la consegna;
> 2. chiudi la soluzione;
> 3. riscrivi la funzione da zero;
> 4. compila con warning severi;
> 5. testa casi base, casi limite e casi “cattivi”.

---

## 0. Comando di compilazione da usare sempre

Allenati sempre con warning forti. Molti errori d’esame si scoprono già qui.

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -g main.c -o main
```

Quando devi debuggare memoria:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -g -fsanitize=address,undefined main.c -o main
./main
```

---

## 1. Checklist mentale prima di scrivere qualsiasi funzione C

Prima di toccare la tastiera chiediti:

- La funzione deve **modificare** la struttura ricevuta?
  - no → passo puntatore normale, per esempio `List list`;
  - sì, e può cambiare la testa/root → passo puntatore a puntatore, per esempio `List *listPtr` oppure `Node **rootPtr`.
- Devo allocare memoria?
  - controllo sempre `malloc`;
  - uso `sizeof *ptr`, non `sizeof(tipo)` quando possibile;
  - se qualcosa fallisce, libero ciò che ho già allocato.
- Chi possiede la memoria?
  - chi fa `malloc` deve sapere chi farà `free`.
- Caso base/caso limite?
  - puntatore `NULL`;
  - lista/albero vuoto;
  - un solo elemento;
  - elemento in testa/root;
  - elemento non presente;
  - duplicati;
  - fallimento `malloc`.
- Complessità?
  - lista: accesso sequenziale `O(n)`;
  - queue con `rear`: enqueue `O(1)`;
  - BST bilanciato: ricerca/inserimento mediamente `O(log n)`, pessimo `O(n)`.

---

## 2. Tipi base da usare negli esercizi di allenamento

Queste definizioni servono per molti esercizi sotto. Riscrivile spesso.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

/* Lista linkata semplice di int */
typedef struct listNode ListNode, *List;
struct listNode {
    int data;
    List next;
};

/* Coda di int con front/rear/size */
typedef struct queueNode QueueNode, *QueueNodePtr;
struct queueNode {
    int data;
    QueueNodePtr next;
};

typedef struct queue *Queue;
struct queue {
    QueueNodePtr front;
    QueueNodePtr rear;
    int size;
};

/* Albero binario di ricerca di int */
typedef struct treeNode TreeNode, *Tree;
struct treeNode {
    int data;
    Tree left;
    Tree right;
};
```

---

# PARTE A — Puntatori, malloc, stringhe, struct

---

## A1. Riscrivi questa funzione: scambia due interi tramite puntatori

### Consegna

Scrivi `swapInt` che scambia il contenuto di due variabili intere.

```c
void swapInt(int *a, int *b);
```

### Soluzione

```c
void swapInt(int *a, int *b) {
    if (a == NULL || b == NULL) {
        return;
    }

    int temp = *a;
    *a = *b;
    *b = temp;
}
```

### Da capire bene

`a` e `b` sono indirizzi. `*a` e `*b` sono i valori nelle celle puntate. Se modifichi `*a`, modifichi la variabile originale del chiamante.

---

## A2. Riscrivi questa funzione: alloca un intero dinamico

### Consegna

Scrivi una funzione che crea dinamicamente un `int`, lo inizializza con `value` e restituisce il puntatore. Se `malloc` fallisce, restituisce `NULL`.

```c
int *newInt(int value);
```

### Soluzione

```c
int *newInt(int value) {
    int *ptr = malloc(sizeof *ptr);

    if (ptr == NULL) {
        return NULL;
    }

    *ptr = value;
    return ptr;
}
```

### Da riscrivere fino alla nausea

```c
int *p = malloc(sizeof *p);
if (p == NULL) return NULL;
*p = value;
return p;
```

---

## A3. Riscrivi questa funzione: duplica una stringa con malloc

### Consegna

Scrivi `strDuplicate`, equivalente concettuale di `strdup`, ma fatta da te. Deve restituire una nuova stringa allocata dinamicamente.

```c
char *strDuplicate(const char *source);
```

### Soluzione

```c
char *strDuplicate(const char *source) {
    if (source == NULL) {
        return NULL;
    }

    size_t length = strlen(source);
    char *copy = malloc((length + 1) * sizeof *copy);

    if (copy == NULL) {
        return NULL;
    }

    strcpy(copy, source);
    return copy;
}
```

### Variante senza `strcpy`

```c
char *strDuplicateManual(const char *source) {
    if (source == NULL) {
        return NULL;
    }

    size_t length = 0;
    while (source[length] != '\0') {
        length++;
    }

    char *copy = malloc((length + 1) * sizeof *copy);
    if (copy == NULL) {
        return NULL;
    }

    for (size_t i = 0; i <= length; i++) {
        copy[i] = source[i];
    }

    return copy;
}
```

### Errore classico

Dimenticare `+ 1` per il terminatore `\0`.

---

## A4. Riscrivi questa funzione: concatena due stringhe in nuova memoria

### Consegna

Scrivi `strConcatNew`: date due stringhe, restituisce una nuova stringa contenente `s1` seguita da `s2`.

```c
char *strConcatNew(const char *s1, const char *s2);
```

### Soluzione

```c
char *strConcatNew(const char *s1, const char *s2) {
    if (s1 == NULL || s2 == NULL) {
        return NULL;
    }

    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);

    char *result = malloc((len1 + len2 + 1) * sizeof *result);
    if (result == NULL) {
        return NULL;
    }

    memcpy(result, s1, len1);
    memcpy(result + len1, s2, len2 + 1); /* include anche '\0' */

    return result;
}
```

---

## A5. Riscrivi questa funzione: rimuovi un carattere da una stringa in-place

### Consegna

Data una stringa modificabile, rimuovi tutte le occorrenze di `target` senza allocare altra memoria.

```c
void removeChar(char *str, char target);
```

### Soluzione

```c
void removeChar(char *str, char target) {
    if (str == NULL) {
        return;
    }

    size_t writeIndex = 0;

    for (size_t readIndex = 0; str[readIndex] != '\0'; readIndex++) {
        if (str[readIndex] != target) {
            str[writeIndex] = str[readIndex];
            writeIndex++;
        }
    }

    str[writeIndex] = '\0';
}
```

### Da capire bene

È il pattern **read/write index**. Lo userai anche per filtrare array.

---

## A6. Riscrivi questa funzione: struct con stringa dinamica

### Consegna

Gestisci una persona con nome allocato dinamicamente.

```c
typedef struct person {
    char *name;
    int age;
} Person;

Person *personCreate(const char *name, int age);
void personDestroy(Person **personPtr);
```

### Soluzione

```c
typedef struct person {
    char *name;
    int age;
} Person;

Person *personCreate(const char *name, int age) {
    if (name == NULL || age < 0) {
        return NULL;
    }

    Person *person = malloc(sizeof *person);
    if (person == NULL) {
        return NULL;
    }

    person->name = strDuplicate(name);
    if (person->name == NULL) {
        free(person);
        return NULL;
    }

    person->age = age;
    return person;
}

void personDestroy(Person **personPtr) {
    if (personPtr == NULL || *personPtr == NULL) {
        return;
    }

    free((*personPtr)->name);
    free(*personPtr);
    *personPtr = NULL;
}
```

### Da capire bene

Uso `Person **personPtr` perché voglio anche mettere a `NULL` il puntatore nel chiamante, evitando dangling pointer.

---

# PARTE B — Array e cicli

---

## B1. Riscrivi questa funzione: indice dell’ultima occorrenza del massimo

### Consegna

Dato un array non vuoto, restituisci l’indice dell’ultima occorrenza del massimo.

```c
size_t findLastMax(const int array[], size_t size);
```

### Soluzione

```c
size_t findLastMax(const int array[], size_t size) {
    assert(array != NULL);
    assert(size > 0);

    size_t maxIndex = 0;

    for (size_t i = 1; i < size; i++) {
        if (array[i] >= array[maxIndex]) {
            maxIndex = i;
        }
    }

    return maxIndex;
}
```

### Variante: prima occorrenza

Per la prima occorrenza basta usare `>` invece di `>=`.

---

## B2. Riscrivi questa funzione: reverse in-place di array

### Consegna

Inverti un array di `int` senza allocare memoria.

```c
void reverseArray(int array[], size_t size);
```

### Soluzione

```c
void reverseArray(int array[], size_t size) {
    if (array == NULL) {
        return;
    }

    for (size_t left = 0, right = size; left < right / 2; left++) {
        size_t mirror = size - 1 - left;
        int temp = array[left];
        array[left] = array[mirror];
        array[mirror] = temp;
    }
}
```

### Variante più leggibile

```c
void reverseArray2(int array[], size_t size) {
    if (array == NULL) {
        return;
    }

    size_t left = 0;
    size_t right = size;

    while (left < right) {
        right--;

        if (left >= right) {
            break;
        }

        int temp = array[left];
        array[left] = array[right];
        array[right] = temp;

        left++;
    }
}
```

---

## B3. Riscrivi questa funzione: filtra pari in un nuovo array

### Consegna

Dato un array di int, crea dinamicamente un nuovo array contenente solo i numeri pari. La funzione restituisce il puntatore e scrive la nuova dimensione in `outSize`.

```c
int *filterEven(const int array[], size_t size, size_t *outSize);
```

### Soluzione

```c
int *filterEven(const int array[], size_t size, size_t *outSize) {
    if (outSize == NULL) {
        return NULL;
    }

    *outSize = 0;

    if (array == NULL && size > 0) {
        return NULL;
    }

    size_t count = 0;
    for (size_t i = 0; i < size; i++) {
        if (array[i] % 2 == 0) {
            count++;
        }
    }

    if (count == 0) {
        return NULL;
    }

    int *result = malloc(count * sizeof *result);
    if (result == NULL) {
        return NULL;
    }

    size_t writeIndex = 0;
    for (size_t i = 0; i < size; i++) {
        if (array[i] % 2 == 0) {
            result[writeIndex] = array[i];
            writeIndex++;
        }
    }

    *outSize = count;
    return result;
}
```

---

# PARTE C — Liste linkate

La lista è l’argomento da martellare più di tutti. Devi saper scrivere queste funzioni anche mezzo addormentato.

---

## C1. Riscrivi questa funzione: crea un nodo

### Consegna

Crea dinamicamente un nodo con campo `data = value` e `next = NULL`.

```c
List newNode(int value);
```

### Soluzione

```c
List newNode(int value) {
    List node = malloc(sizeof *node);

    if (node == NULL) {
        return NULL;
    }

    node->data = value;
    node->next = NULL;

    return node;
}
```

---

## C2. Riscrivi questa funzione: lunghezza iterativa

### Consegna

Restituisci la lunghezza della lista.

```c
size_t listLength(List list);
```

### Soluzione

```c
size_t listLength(List list) {
    size_t length = 0;

    for (List current = list; current != NULL; current = current->next) {
        length++;
    }

    return length;
}
```

---

## C3. Riscrivi questa funzione: contains iterativa

### Consegna

Restituisci `true` se `value` è presente nella lista.

```c
bool listContains(List list, int value);
```

### Soluzione

```c
bool listContains(List list, int value) {
    for (List current = list; current != NULL; current = current->next) {
        if (current->data == value) {
            return true;
        }
    }

    return false;
}
```

### Errore classico

Non dichiarare due volte la variabile del ciclo:

```c
List current = list;
for (List current; current != NULL; current = current->next) { /* SBAGLIATO */ }
```

Scrivi invece:

```c
for (List current = list; current != NULL; current = current->next) { }
```

---

## C4. Riscrivi questa funzione: inserimento in testa

### Consegna

Inserisci `value` in testa. Restituisci `true` se l’inserimento riesce.

```c
bool listPushFront(List *listPtr, int value);
```

### Soluzione

```c
bool listPushFront(List *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    List node = newNode(value);
    if (node == NULL) {
        return false;
    }

    node->next = *listPtr;
    *listPtr = node;

    return true;
}
```

### Da capire bene

Serve `List *listPtr` perché la testa può cambiare.

---

## C5. Riscrivi questa funzione: append in coda

### Consegna

Inserisci un valore alla fine della lista.

```c
bool listAppend(List *listPtr, int value);
```

### Soluzione con casi separati

```c
bool listAppend(List *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    List node = newNode(value);
    if (node == NULL) {
        return false;
    }

    if (*listPtr == NULL) {
        *listPtr = node;
        return true;
    }

    List current = *listPtr;
    while (current->next != NULL) {
        current = current->next;
    }

    current->next = node;
    return true;
}
```

### Soluzione elegante con puntatore a puntatore

```c
bool listAppend2(List *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    while (*listPtr != NULL) {
        listPtr = &((*listPtr)->next);
    }

    *listPtr = newNode(value);
    return *listPtr != NULL;
}
```

### Da riscrivere 100 volte

Il pattern:

```c
while (*ptr != NULL) {
    ptr = &((*ptr)->next);
}
*ptr = nuovoNodo;
```

È fondamentale per inserimenti e rimozioni senza trattare la testa come caso speciale.

---

## C6. Riscrivi questa funzione: inserimento ordinato senza duplicati

### Consegna

La lista è ordinata crescente. Inserisci `value` mantenendo l’ordine. Se `value` è già presente, non inserire e restituisci `false`.

```c
bool listInsertSortedUnique(List *listPtr, int value);
```

### Soluzione

```c
bool listInsertSortedUnique(List *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    while (*listPtr != NULL && (*listPtr)->data < value) {
        listPtr = &((*listPtr)->next);
    }

    if (*listPtr != NULL && (*listPtr)->data == value) {
        return false;
    }

    List node = newNode(value);
    if (node == NULL) {
        return false;
    }

    node->next = *listPtr;
    *listPtr = node;

    return true;
}
```

### Casi da testare

- inserimento in lista vuota;
- inserimento prima della testa;
- inserimento in mezzo;
- inserimento in fondo;
- valore duplicato;
- valori negativi.

---

## C7. Riscrivi questa funzione: rimuovi la prima occorrenza

### Consegna

Rimuovi la prima occorrenza di `value`. Restituisci `true` se hai rimosso qualcosa.

```c
bool listRemoveFirst(List *listPtr, int value);
```

### Soluzione con puntatore a puntatore

```c
bool listRemoveFirst(List *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    while (*listPtr != NULL && (*listPtr)->data != value) {
        listPtr = &((*listPtr)->next);
    }

    if (*listPtr == NULL) {
        return false;
    }

    List nodeToDelete = *listPtr;
    *listPtr = nodeToDelete->next;
    free(nodeToDelete);

    return true;
}
```

### Da capire bene

Se il nodo da cancellare è in testa, `listPtr` punta alla variabile testa. Se è in mezzo, `listPtr` punta al campo `next` del nodo precedente. Il codice è identico in entrambi i casi.

---

## C8. Riscrivi questa funzione: rimuovi tutte le occorrenze

### Consegna

Rimuovi tutte le occorrenze di `value` e restituisci quante ne hai rimosse.

```c
size_t listRemoveAll(List *listPtr, int value);
```

### Soluzione

```c
size_t listRemoveAll(List *listPtr, int value) {
    if (listPtr == NULL) {
        return 0;
    }

    size_t removed = 0;

    while (*listPtr != NULL) {
        if ((*listPtr)->data == value) {
            List nodeToDelete = *listPtr;
            *listPtr = nodeToDelete->next;
            free(nodeToDelete);
            removed++;
        } else {
            listPtr = &((*listPtr)->next);
        }
    }

    return removed;
}
```

### Errore classico

Dopo aver cancellato un nodo **non devi avanzare** subito: il nuovo `*listPtr` potrebbe essere ancora da cancellare.

---

## C9. Riscrivi questa funzione: distruggi una lista

### Consegna

Libera tutti i nodi e imposta la testa a `NULL`.

```c
void listDestroy(List *listPtr);
```

### Soluzione iterativa

```c
void listDestroy(List *listPtr) {
    if (listPtr == NULL) {
        return;
    }

    List current = *listPtr;

    while (current != NULL) {
        List next = current->next;
        free(current);
        current = next;
    }

    *listPtr = NULL;
}
```

### Soluzione ricorsiva

```c
void listDestroyRecursive(List *listPtr) {
    if (listPtr == NULL || *listPtr == NULL) {
        return;
    }

    listDestroyRecursive(&((*listPtr)->next));
    free(*listPtr);
    *listPtr = NULL;
}
```

### Nota da esame

Per liste molto lunghe preferisci la versione iterativa: la ricorsione può consumare troppo stack.

---

## C10. Riscrivi questa funzione: inverti una lista

### Consegna

Inverti una lista linkata modificando i puntatori, senza creare nuovi nodi.

```c
void listReverse(List *listPtr);
```

### Soluzione

```c
void listReverse(List *listPtr) {
    if (listPtr == NULL) {
        return;
    }

    List previous = NULL;
    List current = *listPtr;

    while (current != NULL) {
        List next = current->next;
        current->next = previous;
        previous = current;
        current = next;
    }

    *listPtr = previous;
}
```

### Pattern da memorizzare

```c
next = current->next;
current->next = previous;
previous = current;
current = next;
```

---

## C11. Riscrivi questa funzione: copia profonda di una lista

### Consegna

Crea una nuova lista con gli stessi valori. Se una `malloc` fallisce, libera tutto e restituisce `NULL`.

```c
List listClone(List list);
```

### Soluzione

```c
List listClone(List list) {
    List copy = NULL;
    List *tailPtr = &copy;

    for (List current = list; current != NULL; current = current->next) {
        *tailPtr = newNode(current->data);

        if (*tailPtr == NULL) {
            listDestroy(&copy);
            return NULL;
        }

        tailPtr = &((*tailPtr)->next);
    }

    return copy;
}
```

---

## C12. Riscrivi questa funzione: merge di due liste ordinate

### Consegna

Date due liste ordinate crescenti, crea una nuova lista ordinata contenente tutti gli elementi.

```c
List listMergeSorted(List a, List b);
```

### Soluzione

```c
List listMergeSorted(List a, List b) {
    List result = NULL;
    List *tailPtr = &result;

    while (a != NULL && b != NULL) {
        int value;

        if (a->data <= b->data) {
            value = a->data;
            a = a->next;
        } else {
            value = b->data;
            b = b->next;
        }

        *tailPtr = newNode(value);
        if (*tailPtr == NULL) {
            listDestroy(&result);
            return NULL;
        }

        tailPtr = &((*tailPtr)->next);
    }

    List rest = (a != NULL) ? a : b;

    while (rest != NULL) {
        *tailPtr = newNode(rest->data);
        if (*tailPtr == NULL) {
            listDestroy(&result);
            return NULL;
        }

        tailPtr = &((*tailPtr)->next);
        rest = rest->next;
    }

    return result;
}
```

---

# PARTE D — Stack, Queue, Set

---

## D1. Riscrivi questa funzione: push di uno stack implementato con lista

### Consegna

Uno stack ha politica LIFO. La testa della lista è il top.

```c
bool stackPush(List *stackPtr, int value);
```

### Soluzione

```c
bool stackPush(List *stackPtr, int value) {
    return listPushFront(stackPtr, value);
}
```

---

## D2. Riscrivi questa funzione: pop di uno stack

### Consegna

Estrai il top dello stack. Scrivi il valore in `outValue`. Restituisci `false` se lo stack è vuoto.

```c
bool stackPop(List *stackPtr, int *outValue);
```

### Soluzione

```c
bool stackPop(List *stackPtr, int *outValue) {
    if (stackPtr == NULL || *stackPtr == NULL || outValue == NULL) {
        return false;
    }

    List nodeToDelete = *stackPtr;
    *outValue = nodeToDelete->data;
    *stackPtr = nodeToDelete->next;
    free(nodeToDelete);

    return true;
}
```

---

## D3. Riscrivi questa funzione: crea una coda

### Consegna

Crea una coda vuota con `front = NULL`, `rear = NULL`, `size = 0`.

```c
Queue queueCreate(void);
```

### Soluzione

```c
Queue queueCreate(void) {
    Queue queue = malloc(sizeof *queue);

    if (queue == NULL) {
        return NULL;
    }

    queue->front = NULL;
    queue->rear = NULL;
    queue->size = 0;

    return queue;
}
```

---

## D4. Riscrivi questa funzione: enqueue in O(1)

### Consegna

Inserisci in fondo alla coda.

```c
bool queueEnqueue(Queue queue, int value);
```

### Soluzione

```c
bool queueEnqueue(Queue queue, int value) {
    if (queue == NULL) {
        return false;
    }

    QueueNodePtr node = malloc(sizeof *node);
    if (node == NULL) {
        return false;
    }

    node->data = value;
    node->next = NULL;

    if (queue->rear == NULL) {
        queue->front = node;
        queue->rear = node;
    } else {
        queue->rear->next = node;
        queue->rear = node;
    }

    queue->size++;
    return true;
}
```

### Errore classico

Quando inserisci il primo elemento, devi aggiornare **sia** `front` sia `rear`.

---

## D5. Riscrivi questa funzione: dequeue corretto

### Consegna

Rimuovi dalla testa della coda. Se dopo la rimozione la coda diventa vuota, aggiorna anche `rear`.

```c
bool queueDequeue(Queue queue, int *outValue);
```

### Soluzione

```c
bool queueDequeue(Queue queue, int *outValue) {
    if (queue == NULL || queue->front == NULL || outValue == NULL) {
        return false;
    }

    QueueNodePtr nodeToDelete = queue->front;
    *outValue = nodeToDelete->data;

    queue->front = nodeToDelete->next;

    if (queue->front == NULL) {
        queue->rear = NULL;
    }

    free(nodeToDelete);
    queue->size--;

    return true;
}
```

### Da ricordare per evitare segmentation fault

Dopo aver tolto l’ultimo elemento:

```c
if (queue->front == NULL) {
    queue->rear = NULL;
}
```

Se non lo fai, `rear` resta appeso a memoria liberata.

---

## D6. Riscrivi questa funzione: distruggi una coda

### Consegna

Libera tutti i nodi e poi la struct della coda.

```c
void queueDestroy(Queue *queuePtr);
```

### Soluzione

```c
void queueDestroy(Queue *queuePtr) {
    if (queuePtr == NULL || *queuePtr == NULL) {
        return;
    }

    Queue queue = *queuePtr;
    QueueNodePtr current = queue->front;

    while (current != NULL) {
        QueueNodePtr next = current->next;
        free(current);
        current = next;
    }

    free(queue);
    *queuePtr = NULL;
}
```

---

## D7. Riscrivi questa funzione: add di un set ordinato

### Consegna

Un set non ha duplicati. Implementalo come lista ordinata crescente. Aggiungi `value` se non presente.

```c
bool setAdd(List *setPtr, int value);
```

### Soluzione

```c
bool setAdd(List *setPtr, int value) {
    return listInsertSortedUnique(setPtr, value);
}
```

---

## D8. Riscrivi questa funzione: intersezione di set ordinati

### Consegna

Date due liste ordinate senza duplicati, restituisci un nuovo set contenente gli elementi comuni.

```c
List setIntersection(List a, List b);
```

### Soluzione

```c
List setIntersection(List a, List b) {
    List result = NULL;
    List *tailPtr = &result;

    while (a != NULL && b != NULL) {
        if (a->data == b->data) {
            *tailPtr = newNode(a->data);
            if (*tailPtr == NULL) {
                listDestroy(&result);
                return NULL;
            }

            tailPtr = &((*tailPtr)->next);
            a = a->next;
            b = b->next;
        } else if (a->data < b->data) {
            a = a->next;
        } else {
            b = b->next;
        }
    }

    return result;
}
```

### Complessità

Con liste ordinate lavori in parallelo: `O(m + n)`. Se per ogni elemento di `a` cercassi in `b`, sarebbe `O(m * n)`.

---

## D9. Riscrivi questa funzione: unione di set ordinati

### Consegna

Restituisci un nuovo set ordinato con tutti gli elementi di `a` e `b`, senza duplicati.

```c
List setUnion(List a, List b);
```

### Soluzione

```c
List setUnion(List a, List b) {
    List result = NULL;
    List *tailPtr = &result;

    while (a != NULL || b != NULL) {
        int value;

        if (b == NULL || (a != NULL && a->data < b->data)) {
            value = a->data;
            a = a->next;
        } else if (a == NULL || b->data < a->data) {
            value = b->data;
            b = b->next;
        } else {
            value = a->data;
            a = a->next;
            b = b->next;
        }

        *tailPtr = newNode(value);
        if (*tailPtr == NULL) {
            listDestroy(&result);
            return NULL;
        }

        tailPtr = &((*tailPtr)->next);
    }

    return result;
}
```

---

## D10. Riscrivi questa funzione: differenza di set ordinati

### Consegna

Restituisci gli elementi presenti in `a` ma non in `b`.

```c
List setDifference(List a, List b);
```

### Soluzione

```c
List setDifference(List a, List b) {
    List result = NULL;
    List *tailPtr = &result;

    while (a != NULL) {
        if (b == NULL || a->data < b->data) {
            *tailPtr = newNode(a->data);
            if (*tailPtr == NULL) {
                listDestroy(&result);
                return NULL;
            }

            tailPtr = &((*tailPtr)->next);
            a = a->next;
        } else if (a->data > b->data) {
            b = b->next;
        } else {
            a = a->next;
            b = b->next;
        }
    }

    return result;
}
```

---

# PARTE E — Ricorsione

---

## E1. Riscrivi questa funzione: somma ricorsiva di lista

### Consegna

Somma tutti gli elementi di una lista ricorsivamente.

```c
int listSumRecursive(List list);
```

### Soluzione

```c
int listSumRecursive(List list) {
    if (list == NULL) {
        return 0;
    }

    return list->data + listSumRecursive(list->next);
}
```

### Da capire bene

Caso base: lista vuota. Caso induttivo: valore del nodo corrente + somma del resto.

---

## E2. Riscrivi questa funzione: somma ricorsiva di coda con accumulatore

### Consegna

Scrivi una versione tail-recursive usando una funzione helper.

```c
int listSumTail(List list);
```

### Soluzione

```c
static int listSumTailRec(List list, int accumulator) {
    if (list == NULL) {
        return accumulator;
    }

    return listSumTailRec(list->next, accumulator + list->data);
}

int listSumTail(List list) {
    return listSumTailRec(list, 0);
}
```

---

## E3. Riscrivi questa funzione: stampa lista al contrario

### Consegna

Stampa gli elementi della lista al contrario usando ricorsione.

```c
void listPrintReverse(List list);
```

### Soluzione

```c
void listPrintReverse(List list) {
    if (list == NULL) {
        return;
    }

    listPrintReverse(list->next);
    printf("%d ", list->data);
}
```

### Da capire bene

Se fai l’azione **prima** della chiamata ricorsiva, stampi normale. Se fai l’azione **dopo**, stampi al ritorno, quindi al contrario.

---

## E4. Riscrivi questa funzione: fattoriale ricorsivo

### Consegna

Calcola `n!`.

```c
unsigned long factorial(unsigned int n);
```

### Soluzione

```c
unsigned long factorial(unsigned int n) {
    if (n == 0 || n == 1) {
        return 1;
    }

    return n * factorial(n - 1);
}
```

### Variante di coda

```c
static unsigned long factorialTailRec(unsigned int n, unsigned long accumulator) {
    if (n == 0 || n == 1) {
        return accumulator;
    }

    return factorialTailRec(n - 1, accumulator * n);
}

unsigned long factorialTail(unsigned int n) {
    return factorialTailRec(n, 1);
}
```

---

# PARTE F — Alberi binari e BST

---

## F1. Riscrivi questa funzione: crea nodo BST

### Consegna

Crea un nodo di albero con figli `NULL`.

```c
Tree treeNewNode(int value);
```

### Soluzione

```c
Tree treeNewNode(int value) {
    Tree node = malloc(sizeof *node);

    if (node == NULL) {
        return NULL;
    }

    node->data = value;
    node->left = NULL;
    node->right = NULL;

    return node;
}
```

---

## F2. Riscrivi questa funzione: cerca in BST iterativamente

### Consegna

Restituisci `true` se `value` è presente in un albero di ricerca binario.

```c
bool bstContains(Tree root, int value);
```

### Soluzione

```c
bool bstContains(Tree root, int value) {
    Tree current = root;

    while (current != NULL) {
        if (value == current->data) {
            return true;
        }

        if (value < current->data) {
            current = current->left;
        } else {
            current = current->right;
        }
    }

    return false;
}
```

---

## F3. Riscrivi questa funzione: cerca in BST ricorsivamente

### Consegna

Stessa cosa, ma ricorsiva.

```c
bool bstContainsRec(Tree root, int value);
```

### Soluzione

```c
bool bstContainsRec(Tree root, int value) {
    if (root == NULL) {
        return false;
    }

    if (value == root->data) {
        return true;
    }

    if (value < root->data) {
        return bstContainsRec(root->left, value);
    }

    return bstContainsRec(root->right, value);
}
```

---

## F4. Riscrivi questa funzione: trova minimo in BST

### Consegna

Dato un BST non vuoto, restituisci il minimo.

```c
int bstMin(Tree root);
```

### Soluzione

```c
int bstMin(Tree root) {
    assert(root != NULL);

    Tree current = root;

    while (current->left != NULL) {
        current = current->left;
    }

    return current->data;
}
```

### Da ricordare

In un BST il minimo è il nodo più a sinistra.

---

## F5. Riscrivi questa funzione: inserimento BST senza duplicati

### Consegna

Inserisci `value` nel BST. Se è già presente, non inserire. Restituisci `true` se hai inserito.

```c
bool bstInsert(Tree *rootPtr, int value);
```

### Soluzione ricorsiva con puntatore a puntatore

```c
bool bstInsert(Tree *rootPtr, int value) {
    if (rootPtr == NULL) {
        return false;
    }

    if (*rootPtr == NULL) {
        *rootPtr = treeNewNode(value);
        return *rootPtr != NULL;
    }

    if (value == (*rootPtr)->data) {
        return false;
    }

    if (value < (*rootPtr)->data) {
        return bstInsert(&((*rootPtr)->left), value);
    }

    return bstInsert(&((*rootPtr)->right), value);
}
```

### Soluzione iterativa con puntatore a puntatore

```c
bool bstInsertIter(Tree *rootPtr, int value) {
    if (rootPtr == NULL) {
        return false;
    }

    while (*rootPtr != NULL) {
        if (value == (*rootPtr)->data) {
            return false;
        }

        if (value < (*rootPtr)->data) {
            rootPtr = &((*rootPtr)->left);
        } else {
            rootPtr = &((*rootPtr)->right);
        }
    }

    *rootPtr = treeNewNode(value);
    return *rootPtr != NULL;
}
```

---

## F6. Riscrivi questa funzione: visita inorder

### Consegna

Stampa un BST in ordine crescente.

```c
void bstPrintInOrder(Tree root);
```

### Soluzione

```c
void bstPrintInOrder(Tree root) {
    if (root == NULL) {
        return;
    }

    bstPrintInOrder(root->left);
    printf("%d ", root->data);
    bstPrintInOrder(root->right);
}
```

### Le tre visite da sapere

```c
/* Pre-order: root, left, right */
void treePrintPreOrder(Tree root) {
    if (root == NULL) return;
    printf("%d ", root->data);
    treePrintPreOrder(root->left);
    treePrintPreOrder(root->right);
}

/* In-order: left, root, right */
void treePrintInOrder(Tree root) {
    if (root == NULL) return;
    treePrintInOrder(root->left);
    printf("%d ", root->data);
    treePrintInOrder(root->right);
}

/* Post-order: left, right, root */
void treePrintPostOrder(Tree root) {
    if (root == NULL) return;
    treePrintPostOrder(root->left);
    treePrintPostOrder(root->right);
    printf("%d ", root->data);
}
```

---

## F7. Riscrivi questa funzione: altezza albero

### Consegna

Altezza dell’albero vuoto = `-1`. Altezza di una foglia = `0`.

```c
int treeHeight(Tree root);
```

### Soluzione

```c
static int maxInt(int a, int b) {
    return (a > b) ? a : b;
}

int treeHeight(Tree root) {
    if (root == NULL) {
        return -1;
    }

    return 1 + maxInt(treeHeight(root->left), treeHeight(root->right));
}
```

---

## F8. Riscrivi questa funzione: conta nodi

### Consegna

Conta i nodi di un albero binario.

```c
size_t treeCountNodes(Tree root);
```

### Soluzione

```c
size_t treeCountNodes(Tree root) {
    if (root == NULL) {
        return 0;
    }

    return 1 + treeCountNodes(root->left) + treeCountNodes(root->right);
}
```

---

## F9. Riscrivi questa funzione: conta foglie

### Consegna

Conta i nodi senza figli.

```c
size_t treeCountLeaves(Tree root);
```

### Soluzione

```c
size_t treeCountLeaves(Tree root) {
    if (root == NULL) {
        return 0;
    }

    if (root->left == NULL && root->right == NULL) {
        return 1;
    }

    return treeCountLeaves(root->left) + treeCountLeaves(root->right);
}
```

---

## F10. Riscrivi questa funzione: distruggi albero

### Consegna

Libera tutti i nodi e imposta la root a `NULL`.

```c
void treeDestroy(Tree *rootPtr);
```

### Soluzione

```c
void treeDestroy(Tree *rootPtr) {
    if (rootPtr == NULL || *rootPtr == NULL) {
        return;
    }

    treeDestroy(&((*rootPtr)->left));
    treeDestroy(&((*rootPtr)->right));
    free(*rootPtr);
    *rootPtr = NULL;
}
```

### Da capire bene

Si libera in post-order: prima figli, poi nodo corrente.

---

## F11. Riscrivi questa funzione: rimozione da BST

### Consegna

Rimuovi `value` da un BST senza duplicati. Restituisci `true` se hai rimosso qualcosa.

```c
bool bstRemove(Tree *rootPtr, int value);
```

### Soluzione

```c
static int bstDetachMin(Tree *rootPtr) {
    assert(rootPtr != NULL);
    assert(*rootPtr != NULL);

    while ((*rootPtr)->left != NULL) {
        rootPtr = &((*rootPtr)->left);
    }

    Tree minNode = *rootPtr;
    int minValue = minNode->data;

    *rootPtr = minNode->right;
    free(minNode);

    return minValue;
}

bool bstRemove(Tree *rootPtr, int value) {
    if (rootPtr == NULL || *rootPtr == NULL) {
        return false;
    }

    if (value < (*rootPtr)->data) {
        return bstRemove(&((*rootPtr)->left), value);
    }

    if (value > (*rootPtr)->data) {
        return bstRemove(&((*rootPtr)->right), value);
    }

    Tree nodeToDelete = *rootPtr;

    if (nodeToDelete->left == NULL) {
        *rootPtr = nodeToDelete->right;
        free(nodeToDelete);
        return true;
    }

    if (nodeToDelete->right == NULL) {
        *rootPtr = nodeToDelete->left;
        free(nodeToDelete);
        return true;
    }

    nodeToDelete->data = bstDetachMin(&(nodeToDelete->right));
    return true;
}
```

### I tre casi da sapere

1. Nodo senza figlio sinistro → sostituisci con figlio destro.
2. Nodo senza figlio destro → sostituisci con figlio sinistro.
3. Nodo con due figli → sostituisci il valore con il minimo del sottoalbero destro, poi rimuovi quel minimo.

---

# PARTE G — void*, puntatori a funzione, ADT generici

---

## G1. Riscrivi questa funzione: confronto passato come parametro

### Consegna

Scrivi una funzione che cerca l’indice del “migliore” elemento secondo una funzione di confronto.

```c
typedef int (*CompareFunc)(int a, int b);
size_t findBestIndex(const int array[], size_t size, CompareFunc better);
```

`better(a, b)` restituisce valore positivo se `a` è migliore di `b`.

### Soluzione

```c
typedef int (*CompareFunc)(int a, int b);

size_t findBestIndex(const int array[], size_t size, CompareFunc better) {
    assert(array != NULL);
    assert(size > 0);
    assert(better != NULL);

    size_t bestIndex = 0;

    for (size_t i = 1; i < size; i++) {
        if (better(array[i], array[bestIndex]) > 0) {
            bestIndex = i;
        }
    }

    return bestIndex;
}

int greaterInt(int a, int b) {
    return a - b;
}

int smallerInt(int a, int b) {
    return b - a;
}
```

---

## G2. Riscrivi questa funzione: lista generica con void*

### Consegna

Crea una lista generica che contiene `void *`. La funzione `destroyData` serve per liberare il contenuto, se necessario.

```c
typedef struct genericNode GenericNode, *GenericList;
struct genericNode {
    void *data;
    GenericList next;
};

void genericListDestroy(GenericList *listPtr, void (*destroyData)(void *));
```

### Soluzione

```c
typedef struct genericNode GenericNode, *GenericList;
struct genericNode {
    void *data;
    GenericList next;
};

void genericListDestroy(GenericList *listPtr, void (*destroyData)(void *)) {
    if (listPtr == NULL) {
        return;
    }

    GenericList current = *listPtr;

    while (current != NULL) {
        GenericList next = current->next;

        if (destroyData != NULL) {
            destroyData(current->data);
        }

        free(current);
        current = next;
    }

    *listPtr = NULL;
}
```

### Da capire bene

`void *` ti dà riuso del codice, ma perdi type checking. La struttura dati non sa cosa contiene: per confrontare o liberare contenuti complessi devi passare funzioni apposite.

---

# PARTE H — File

---

## H1. Riscrivi questa funzione: conta interi in un file

### Consegna

Apri un file di testo e conta quanti interi contiene.

```c
int countIntegersInFile(const char *filename);
```

### Soluzione

```c
int countIntegersInFile(const char *filename) {
    if (filename == NULL) {
        return -1;
    }

    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        return -1;
    }

    int count = 0;
    int value;

    while (fscanf(file, "%d", &value) == 1) {
        count++;
    }

    fclose(file);
    return count;
}
```

---

## H2. Riscrivi questa funzione: somma, minimo e massimo da file

### Consegna

Leggi interi da file. Restituisci `false` se il file non si apre o non contiene interi.

```c
bool fileStats(const char *filename, int *sum, int *min, int *max);
```

### Soluzione

```c
bool fileStats(const char *filename, int *sum, int *min, int *max) {
    if (filename == NULL || sum == NULL || min == NULL || max == NULL) {
        return false;
    }

    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        return false;
    }

    int value;

    if (fscanf(file, "%d", &value) != 1) {
        fclose(file);
        return false;
    }

    *sum = value;
    *min = value;
    *max = value;

    while (fscanf(file, "%d", &value) == 1) {
        *sum += value;

        if (value < *min) {
            *min = value;
        }

        if (value > *max) {
            *max = value;
        }
    }

    fclose(file);
    return true;
}
```

### Pattern da ricordare

Per minimo/massimo, spesso conviene leggere il primo elemento fuori dal ciclo, così hai un valore iniziale sensato.

---

## H3. Riscrivi questa funzione: copia file carattere per carattere

### Consegna

Copia un file sorgente in un file destinazione.

```c
bool copyFile(const char *sourceName, const char *destName);
```

### Soluzione

```c
bool copyFile(const char *sourceName, const char *destName) {
    if (sourceName == NULL || destName == NULL) {
        return false;
    }

    FILE *source = fopen(sourceName, "r");
    if (source == NULL) {
        return false;
    }

    FILE *dest = fopen(destName, "w");
    if (dest == NULL) {
        fclose(source);
        return false;
    }

    int ch;
    while ((ch = fgetc(source)) != EOF) {
        if (fputc(ch, dest) == EOF) {
            fclose(source);
            fclose(dest);
            return false;
        }
    }

    fclose(source);
    fclose(dest);
    return true;
}
```

---

# PARTE I — TDD e test locali

---

## I1. Riscrivi questo mini framework di test

### Consegna

Crea macro semplici per testare funzioni.

### Soluzione

```c
#include <stdio.h>
#include <stdbool.h>

static int testsRun = 0;
static int testsFailed = 0;

#define CHECK(condition) do {                                      \
    testsRun++;                                                    \
    if (!(condition)) {                                            \
        testsFailed++;                                             \
        printf("FAIL: %s:%d: %s\n", __FILE__, __LINE__, #condition); \
    }                                                             \
} while (0)

#define CHECK_INT(expected, actual) do {                            \
    testsRun++;                                                     \
    int expectedValue = (expected);                                 \
    int actualValue = (actual);                                     \
    if (expectedValue != actualValue) {                             \
        testsFailed++;                                              \
        printf("FAIL: %s:%d: expected %d, got %d\n",                \
               __FILE__, __LINE__, expectedValue, actualValue);     \
    }                                                              \
} while (0)

static int testReport(void) {
    printf("Tests run: %d\n", testsRun);
    printf("Tests failed: %d\n", testsFailed);
    return testsFailed == 0 ? 0 : 1;
}
```

---

## I2. Riscrivi questi test per lista ordinata

### Consegna

Testa `listInsertSortedUnique`.

### Soluzione

```c
void testListInsertSortedUnique(void) {
    List list = NULL;

    CHECK(listInsertSortedUnique(&list, 5));
    CHECK_INT(5, list->data);
    CHECK(list->next == NULL);

    CHECK(listInsertSortedUnique(&list, 3));
    CHECK_INT(3, list->data);
    CHECK_INT(5, list->next->data);

    CHECK(listInsertSortedUnique(&list, 7));
    CHECK_INT(3, list->data);
    CHECK_INT(5, list->next->data);
    CHECK_INT(7, list->next->next->data);

    CHECK(!listInsertSortedUnique(&list, 5));
    CHECK_INT(3, list->data);
    CHECK_INT(5, list->next->data);
    CHECK_INT(7, list->next->next->data);
    CHECK(list->next->next->next == NULL);

    listDestroy(&list);
    CHECK(list == NULL);
}
```

### Regola d’oro TDD

Per ogni funzione scrivi almeno:

- test lista/struttura vuota;
- test un solo elemento;
- test testa/root;
- test mezzo;
- test coda/foglia;
- test elemento assente;
- test duplicato, se ha senso;
- test distruzione e puntatore finale a `NULL`.

---

# PARTE J — Moduli `.h` / `.c` e tipi opachi

---

## J1. Riscrivi questo header opaco

### Consegna

Definisci un ADT stack opaco. Il client non deve vedere i campi interni.

### Soluzione: `intStackADT.h`

```c
#ifndef INT_STACK_ADT_H
#define INT_STACK_ADT_H

#include <stdbool.h>

typedef struct intStack *IntStackADT;

IntStackADT stackCreate(void);
void stackDestroy(IntStackADT *stackPtr);
bool stackPushADT(IntStackADT stack, int value);
bool stackPopADT(IntStackADT stack, int *outValue);
bool stackTopADT(IntStackADT stack, int *outValue);
bool stackIsEmptyADT(IntStackADT stack);
int stackSizeADT(IntStackADT stack);

#endif
```

### Soluzione: idea del `.c`

```c
#include "intStackADT.h"
#include <stdlib.h>

struct node {
    int data;
    struct node *next;
};

struct intStack {
    struct node *top;
    int size;
};
```

### Da capire bene

Nel `.h` dichiari il tipo come puntatore a struct incompleta. Nel `.c` definisci davvero i campi. Così il client può usare solo le funzioni pubbliche.

---

# PARTE K — Mini-progetti da rifare interi

Questi sono i “boss finali”. Non limitarti alle singole funzioni: rifai questi moduli completi.

---

## K1. Mini-progetto: lista ordinata di int

### Devi saper implementare

```c
List newNode(int value);
size_t listLength(List list);
bool listContains(List list, int value);
bool listInsertSortedUnique(List *listPtr, int value);
bool listRemoveFirst(List *listPtr, int value);
size_t listRemoveAll(List *listPtr, int value);
void listDestroy(List *listPtr);
List listClone(List list);
void listReverse(List *listPtr);
```

### Test obbligatori

- crea lista vuota;
- inserisci `5, 3, 7, 5, 1`;
- verifica ordine `1, 3, 5, 7`;
- rimuovi testa;
- rimuovi mezzo;
- rimuovi coda;
- rimuovi assente;
- distruggi due volte.

---

## K2. Mini-progetto: coda di char/int

### Devi saper implementare

```c
Queue queueCreate(void);
void queueDestroy(Queue *queuePtr);
bool queueEnqueue(Queue queue, int value);
bool queueDequeue(Queue queue, int *outValue);
bool queueFront(Queue queue, int *outValue);
bool queueIsEmpty(Queue queue);
int queueSize(Queue queue);
```

### Test obbligatori

- dequeue da coda vuota;
- enqueue primo elemento: `front` e `rear` non devono essere `NULL`;
- dequeue ultimo elemento: `front` e `rear` devono tornare `NULL`;
- sequenza lunga: enqueue 10000 elementi, dequeue 10000 elementi;
- alternanza enqueue/dequeue.

---

## K3. Mini-progetto: set di int ordinato con lista

### Devi saper implementare

```c
bool setAdd(List *setPtr, int value);
bool setRemove(List *setPtr, int value);
bool setContains(List set, int value);
List setUnion(List a, List b);
List setIntersection(List a, List b);
List setDifference(List a, List b);
bool setSubset(List a, List b);
bool setEquals(List a, List b);
```

### Funzioni extra utili

```c
bool setSubset(List a, List b) {
    while (a != NULL) {
        while (b != NULL && b->data < a->data) {
            b = b->next;
        }

        if (b == NULL || b->data != a->data) {
            return false;
        }

        a = a->next;
    }

    return true;
}

bool setEquals(List a, List b) {
    while (a != NULL && b != NULL) {
        if (a->data != b->data) {
            return false;
        }

        a = a->next;
        b = b->next;
    }

    return a == NULL && b == NULL;
}
```

---

## K4. Mini-progetto: BST di int

### Devi saper implementare

```c
bool bstInsert(Tree *rootPtr, int value);
bool bstContains(Tree root, int value);
bool bstRemove(Tree *rootPtr, int value);
int bstMin(Tree root);
int bstMax(Tree root);
size_t treeCountNodes(Tree root);
size_t treeCountLeaves(Tree root);
int treeHeight(Tree root);
void bstPrintInOrder(Tree root);
void treeDestroy(Tree *rootPtr);
```

### Test obbligatori

Inserisci:

```text
47, 25, 77, 11, 43, 65, 93, 31, 68
```

Poi testa:

- `contains(47)`, `contains(31)`, `contains(100)`;
- minimo `11`;
- massimo `93`;
- visita inorder crescente;
- rimozione foglia;
- rimozione nodo con un figlio;
- rimozione nodo con due figli;
- rimozione root;
- destroy finale.

---

# PARTE L — Errori tipici da eliminare

## L1. `malloc` senza controllo

Sbagliato:

```c
List node = malloc(sizeof *node);
node->data = value;
```

Giusto:

```c
List node = malloc(sizeof *node);
if (node == NULL) {
    return false;
}
node->data = value;
```

---

## L2. Dereferenziare prima di controllare `NULL`

Sbagliato:

```c
if (list->data == value && list != NULL) { }
```

Giusto:

```c
if (list != NULL && list->data == value) { }
```

---

## L3. Usare memoria dopo `free`

Sbagliato:

```c
free(node);
current = node->next;
```

Giusto:

```c
List next = node->next;
free(node);
current = next;
```

---

## L4. Dimenticare di aggiornare la testa

Se una funzione può cambiare la testa, non basta:

```c
void insert(List list, int value); /* spesso insufficiente */
```

Serve:

```c
bool insert(List *listPtr, int value);
```

oppure devi restituire la nuova testa:

```c
List insert(List list, int value);
```

---

## L5. Dimenticare `rear = NULL` nella queue

Questo è uno dei bug più pericolosi:

```c
queue->front = nodeToDelete->next;
free(nodeToDelete);
```

Corretto:

```c
queue->front = nodeToDelete->next;
if (queue->front == NULL) {
    queue->rear = NULL;
}
free(nodeToDelete);
```

---

## L6. Perdere memoria se una malloc fallisce a metà

Sbagliato:

```c
Person *p = malloc(sizeof *p);
p->name = malloc(strlen(name) + 1);
if (p->name == NULL) return NULL; /* p perso */
```

Giusto:

```c
Person *p = malloc(sizeof *p);
if (p == NULL) return NULL;

p->name = malloc(strlen(name) + 1);
if (p->name == NULL) {
    free(p);
    return NULL;
}
```

---

# PARTE M — Piano di allenamento consigliato

## Giorno 1 — Puntatori e memoria

Riscrivi:

- `swapInt`
- `newInt`
- `strDuplicate`
- `strConcatNew`
- `removeChar`
- `personCreate/personDestroy`

Obiettivo: non sbagliare più `*`, `&`, `->`, `malloc`, `free`.

---

## Giorno 2 — Liste base

Riscrivi:

- `newNode`
- `listLength`
- `listContains`
- `listPushFront`
- `listAppend`
- `listDestroy`

Obiettivo: scorrere liste senza segmentation fault.

---

## Giorno 3 — Liste difficili

Riscrivi:

- `listInsertSortedUnique`
- `listRemoveFirst`
- `listRemoveAll`
- `listReverse`
- `listClone`
- `listMergeSorted`

Obiettivo: padroneggiare puntatore a puntatore.

---

## Giorno 4 — ADT stack/queue/set

Riscrivi:

- stack completo;
- queue completa con `front/rear/size`;
- set ordinato con `add/remove/union/intersection/difference`.

Obiettivo: ragionare per invarianti della struttura dati.

---

## Giorno 5 — Ricorsione e alberi

Riscrivi:

- visite pre/in/post order;
- `bstContains`;
- `bstInsert`;
- `bstRemove`;
- `treeDestroy`;
- `treeHeight`;
- `treeCountLeaves`.

Obiettivo: vedere ogni albero come `NULL` oppure `root + left + right`.

---

## Giorno 6 — File, void*, function pointer

Riscrivi:

- `countIntegersInFile`;
- `fileStats`;
- `copyFile`;
- `findBestIndex` con funzione di confronto;
- lista generica con `void *`.

Obiettivo: gestire risorse esterne e genericità.

---

## Giorno 7 — Simulazione esame

Scegli un mini-progetto e rifallo da zero in 90–120 minuti:

- leggi solo header/prototipi;
- scrivi test minimi;
- implementa funzione per funzione;
- compila spesso;
- fai girare sanitizer;
- correggi warning;
- misura complessità a voce.

---

# PARTE N — Le 15 funzioni più importanti in assoluto

Se hai poco tempo, martella queste:

1. `strDuplicate`
2. `listPushFront`
3. `listAppend2`
4. `listInsertSortedUnique`
5. `listRemoveFirst`
6. `listRemoveAll`
7. `listDestroy`
8. `listReverse`
9. `queueEnqueue`
10. `queueDequeue`
11. `setIntersection`
12. `bstContains`
13. `bstInsert`
14. `bstRemove`
15. `treeDestroy`

---

# PARTE O — Template mentale per ogni esercizio d’esame

Quando leggi una consegna, scrivi su carta:

```text
INPUT:
OUTPUT:
CASI LIMITE:
MODIFICA LA STRUTTURA? sì/no
SERVE malloc? sì/no
CHI FA free?
COMPLESSITÀ ATTESA:
TEST MINIMI:
```

Poi implementa in questo ordine:

1. caso `NULL` / vuoto;
2. caso semplice;
3. caso generale;
4. aggiornamento puntatori;
5. `free`;
6. valore di ritorno;
7. test.

---

# PARTE P — Mantra finale

```text
Se cambio la testa, passo &testa.
Se alloco, controllo.
Se libero, non uso più.
Se tolgo l’ultimo elemento della coda, rear diventa NULL.
Se scorro una lista per modificare link, considero il puntatore a puntatore.
Se visito un albero, penso: caso NULL, poi left/root/right.
Se scrivo un ADT, il .h promette e il .c nasconde.
Se una funzione sembra difficile, scrivo prima i test.
```

