# Dojo C — Automatismi fondamentali

> Obiettivo: arrivare a scrivere queste forme senza pensarci.
>
> Regola d'uso: leggi la richiesta, scrivi il codice da zero su OneCompiler, compila con warning alti, poi apri la soluzione.
>
> Comando consigliato: `gcc -std=c11 -Wall -Wextra -Wpedantic -Wconversion main.c && ./a.out`

Le soluzioni usano i **callout richiudibili nativi di Obsidian**. Funzionano in Modalità lettura e Live Preview; premi sul titolo `Mostra soluzione` per aprirli.

Link foglio per esercizi: https://onecompiler.com/c/453hvf3ab

## Convenzioni fisse del dojo

Per evitare le molte varianti equivalenti del C, in tutto il file useremo queste forme:

```c
typedef struct listNode ListNode;
typedef ListNode *IntList;

struct listNode {
    int data;
    IntList next;
};

typedef struct treeNode TreeNode;
typedef TreeNode *IntTree;

struct treeNode {
    int data;
    IntTree left;
    IntTree right;
};
```

- `ListNode` e `TreeNode` sono le strutture vere.
- `IntList` e `IntTree` sono già puntatori.
- Se devi cambiare la testa o la radice ricevuta dal chiamante, ricevi `IntList *` o `IntTree *`.
- Per allocare usa `malloc(sizeof *ptr)`.
- Una funzione che alloca deve gestire il possibile fallimento di `malloc`.

---

# A. Scheletro del programma

## A01 — Include essenziali

Scrivi gli `#include` per usare input/output, allocazione dinamica, `size_t`, booleani, stringhe e limiti degli interi.

```c
/* SCRIVI QUI */
```

> [!success]- Mostra soluzione
>
> ```c
> #include <stdio.h>
> #include <stdlib.h>
> #include <stddef.h>
> #include <stdbool.h>
> #include <string.h>
> #include <limits.h>
> ```
>
> Includi solo ciò che serve davvero al programma. `size_t` è disponibile anche tramite diversi altri header, ma `<stddef.h>` è il riferimento diretto.


## A02 — Programma minimo

Scrivi un programma C completo con `main` che termina correttamente senza stampare nulla.

```c
/* SCRIVI QUI */
```

> [!success]- Mostra soluzione
>
> ```c
> int main(void) {
>     return 0;
> }
> ```


## A03 — Costante simbolica e `enum`

Definisci:

- una costante `CAPACITY` di valore `100` tramite macro;
- un tipo `Color` con valori `RED`, `GREEN`, `BLUE` tramite `enum`.

> [!success]- Mostra soluzione
>
> ```c
> #define CAPACITY 100
>
> typedef enum {
>     RED,
>     GREEN,
>     BLUE
> } Color;
> ```


## A04 — Firma e chiamata

Scrivi il prototipo di una funzione che riceve un array di `int` in sola lettura e la sua lunghezza, poi restituisce la somma come `long`.

> [!success]- Mostra soluzione
>
> ```c
> long arraySum(const int values[], size_t length);
> ```
>
> Forma equivalente ammessa: `long arraySum(const int *values, size_t length);`.


---

# B. Struct, typedef e puntatori

## B01 — Struct semplice

Definisci un tipo `Point` con coordinate intere `x` e `y`. Crea poi una variabile inizializzata a `(3, 7)`.

> [!success]- Mostra soluzione
>
> ```c
> typedef struct {
>     int x;
>     int y;
> } Point;
>
> Point p = {3, 7};
> ```


## B02 — Struct autoreferenziale

Scrivi la definizione di un nodo di lista contenente un `int` e il puntatore al nodo successivo, usando le convenzioni del dojo.

> [!success]- Mostra soluzione
>
> ```c
> typedef struct listNode ListNode;
> typedef ListNode *IntList;
>
> struct listNode {
>     int data;
>     IntList next;
> };
> ```


## B03 — Accesso con `.` e `->`

Date `Point p` e `Point *ptr = &p`, assegna `10` a `x` una volta usando `p` e assegna `20` a `y` usando `ptr`.

> [!success]- Mostra soluzione
>
> ```c
> p.x = 10;
> ptr->y = 20;
> ```


## B04 — Puntatore a puntatore

Dichiara una lista vuota `list` e un puntatore `link` che punti alla variabile `list`, non al primo nodo.

> [!success]- Mostra soluzione
>
> ```c
> IntList list = NULL;
> IntList *link = &list;
> ```
>
> `link` ha tipo `ListNode **` perché `IntList` è già `ListNode *`.


## B05 — Modificare un valore tramite puntatore

Scrivi `setZero`, che riceve l'indirizzo di un `int` e lo porta a zero. Se riceve `NULL`, non fa nulla.

> [!success]- Mostra soluzione
>
> ```c
> void setZero(int *valuePtr) {
>     if (valuePtr != NULL) {
>         *valuePtr = 0;
>     }
> }
> ```


---

# C. Memoria dinamica

## C01 — Allocare un intero

Alloca dinamicamente un `int`, controlla `malloc`, assegna `42`, poi libera la memoria.

> [!success]- Mostra soluzione
>
> ```c
> int *ptr = malloc(sizeof *ptr);
>
> if (ptr == NULL) {
>     return EXIT_FAILURE;
> }
>
> *ptr = 42;
> free(ptr);
> ptr = NULL;
> ```


## C02 — Allocare un array

Alloca un array dinamico di `length` interi senza inizializzarli. Gestisci correttamente `length == 0` scegliendo di restituire `NULL`.

> [!success]- Mostra soluzione
>
> ```c
> int *makeArray(size_t length) {
>     if (length == 0) {
>         return NULL;
>     }
>
>     return malloc(length * sizeof(int));
> }
> ```
>
> Forma preferibile se hai già una variabile puntatore:
>
> ```c
> int *values = malloc(length * sizeof *values);
> ```


## C03 — `calloc`

Alloca un array dinamico di `length` interi inizializzati a zero.

> [!success]- Mostra soluzione
>
> ```c
> int *values = calloc(length, sizeof *values);
> ```


## C04 — `realloc` senza perdere il vecchio blocco

Dato `int *values`, ridimensionalo per contenere `newLength` elementi senza perdere il vecchio indirizzo se `realloc` fallisce.

> [!success]- Mostra soluzione
>
> ```c
> int *tmp = realloc(values, newLength * sizeof *values);
>
> if (tmp == NULL && newLength != 0) {
>     /* values è ancora valido */
> } else {
>     values = tmp;
> }
> ```


## C05 — Creare un nodo di lista

Implementa `makeListNode`: alloca un nodo, assegna `value`, imposta `next` a `NULL` e restituisce il nodo. Se l'allocazione fallisce, restituisce `NULL`.

> [!success]- Mostra soluzione
>
> ```c
> IntList makeListNode(int value) {
>     IntList node = malloc(sizeof *node);
>
>     if (node == NULL) {
>         return NULL;
>     }
>
>     node->data = value;
>     node->next = NULL;
>     return node;
> }
> ```


## C06 — Duplicare una stringa

Implementa `stringDuplicate` senza usare `strdup`. Se `s == NULL` o `malloc` fallisce, restituisci `NULL`.

> [!success]- Mostra soluzione
>
> ```c
> char *stringDuplicate(const char *s) {
>     if (s == NULL) {
>         return NULL;
>     }
>
>     size_t length = strlen(s);
>     char *copy = malloc((length + 1) * sizeof *copy);
>
>     if (copy == NULL) {
>         return NULL;
>     }
>
>     memcpy(copy, s, length + 1);
>     return copy;
> }
> ```


---

# D. Array e stringhe

## D01 — Scorrere un array

Scrivi un ciclo che stampi tutti gli elementi di `values`, lungo `length`.

> [!success]- Mostra soluzione
>
> ```c
> for (size_t i = 0; i < length; i++) {
>     printf("%d\n", values[i]);
> }
> ```


## D02 — Scorrere una stringa

Scrivi un ciclo che visiti tutti i caratteri di `s` senza usare `strlen` nella condizione.

> [!success]- Mostra soluzione
>
> ```c
> for (size_t i = 0; s[i] != '\0'; i++) {
>     /* usa s[i] */
> }
> ```


## D03 — Lunghezza manuale

Implementa la lunghezza di una stringa. Per questo esercizio puoi assumere `s != NULL`.

> [!success]- Mostra soluzione
>
> ```c
> size_t stringLength(const char *s) {
>     size_t length = 0;
>
>     while (s[length] != '\0') {
>         length++;
>     }
>
>     return length;
> }
> ```


## D04 — Copia manuale

Implementa la copia di `source` in `destination`, incluso il terminatore. Assumi che `destination` abbia spazio sufficiente.

> [!success]- Mostra soluzione
>
> ```c
> void stringCopy(char *destination, const char *source) {
>     size_t i = 0;
>
>     do {
>         destination[i] = source[i];
>     } while (source[i++] != '\0');
> }
> ```


## D05 — Eliminazione in place da un array

Dato un array e un indice valido, elimina l'elemento spostando a sinistra quelli successivi. Aggiorna la lunghezza ricevuta tramite puntatore.

> [!success]- Mostra soluzione
>
> ```c
> void arrayRemoveAt(int values[], size_t *lengthPtr, size_t index) {
>     if (values == NULL || lengthPtr == NULL || index >= *lengthPtr) {
>         return;
>     }
>
>     for (size_t i = index; i + 1 < *lengthPtr; i++) {
>         values[i] = values[i + 1];
>     }
>
>     (*lengthPtr)--;
> }
> ```


---

# E. Liste linkate

## E01 — Attraversamento in sola lettura

Scrivi il ciclo canonico per attraversare una lista senza modificarla.

> [!success]- Mostra soluzione
>
> ```c
> for (IntList current = list; current != NULL; current = current->next) {
>     /* usa current->data */
> }
> ```


## E02 — Lunghezza della lista

Implementa `listLength`.

> [!success]- Mostra soluzione
>
> ```c
> size_t listLength(IntList list) {
>     size_t length = 0;
>
>     for (IntList current = list; current != NULL; current = current->next) {
>         length++;
>     }
>
>     return length;
> }
> ```


## E03 — Somma della lista

Implementa `listSum` restituendo un `long`.

> [!success]- Mostra soluzione
>
> ```c
> long listSum(IntList list) {
>     long sum = 0;
>
>     for (IntList current = list; current != NULL; current = current->next) {
>         sum += current->data;
>     }
>
>     return sum;
> }
> ```


## E04 — Ricerca

Implementa `listContains`, che restituisce `true` se `value` è presente.

> [!success]- Mostra soluzione
>
> ```c
> bool listContains(IntList list, int value) {
>     for (IntList current = list; current != NULL; current = current->next) {
>         if (current->data == value) {
>             return true;
>         }
>     }
>
>     return false;
> }
> ```


## E05 — Inserimento in testa

Implementa `listPushFront`. Restituisce `false` se `listPtr == NULL` o se `malloc` fallisce.

> [!success]- Mostra soluzione
>
> ```c
> bool listPushFront(IntList *listPtr, int value) {
>     if (listPtr == NULL) {
>         return false;
>     }
>
>     IntList node = malloc(sizeof *node);
>
>     if (node == NULL) {
>         return false;
>     }
>
>     node->data = value;
>     node->next = *listPtr;
>     *listPtr = node;
>     return true;
> }
> ```


## E06 — Inserimento in fondo

Implementa `listAppend` usando un puntatore a puntatore. Restituisce `false` in caso di errore.

> [!success]- Mostra soluzione
>
> ```c
> bool listAppend(IntList *listPtr, int value) {
>     if (listPtr == NULL) {
>         return false;
>     }
>
>     IntList node = malloc(sizeof *node);
>
>     if (node == NULL) {
>         return false;
>     }
>
>     node->data = value;
>     node->next = NULL;
>
>     IntList *link = listPtr;
>
>     while (*link != NULL) {
>         link = &(*link)->next;
>     }
>
>     *link = node;
>     return true;
> }
> ```


## E07 — Rimuovere la prima occorrenza

Implementa `listRemoveFirst` con un puntatore a puntatore. Libera il nodo rimosso e restituisce se la rimozione è avvenuta.

> [!success]- Mostra soluzione
>
> ```c
> bool listRemoveFirst(IntList *listPtr, int value) {
>     if (listPtr == NULL) {
>         return false;
>     }
>
>     IntList *link = listPtr;
>
>     while (*link != NULL && (*link)->data != value) {
>         link = &(*link)->next;
>     }
>
>     if (*link == NULL) {
>         return false;
>     }
>
>     IntList removed = *link;
>     *link = removed->next;
>     free(removed);
>     return true;
> }
> ```


## E08 — Rimuovere tutte le occorrenze

Implementa `listRemoveAll`. Restituisci il numero di nodi rimossi.

> [!success]- Mostra soluzione
>
> ```c
> size_t listRemoveAll(IntList *listPtr, int value) {
>     if (listPtr == NULL) {
>         return 0;
>     }
>
>     size_t removedCount = 0;
>     IntList *link = listPtr;
>
>     while (*link != NULL) {
>         if ((*link)->data == value) {
>             IntList removed = *link;
>             *link = removed->next;
>             free(removed);
>             removedCount++;
>         } else {
>             link = &(*link)->next;
>         }
>     }
>
>     return removedCount;
> }
> ```


## E09 — Liberare tutta la lista

Implementa `listClear` e lascia la testa a `NULL`.

> [!success]- Mostra soluzione
>
> ```c
> void listClear(IntList *listPtr) {
>     if (listPtr == NULL) {
>         return;
>     }
>
>     while (*listPtr != NULL) {
>         IntList removed = *listPtr;
>         *listPtr = removed->next;
>         free(removed);
>     }
> }
> ```


## E10 — Invertire la lista

Implementa l'inversione in place con `previous`, `current`, `next`.

> [!success]- Mostra soluzione
>
> ```c
> void listReverse(IntList *listPtr) {
>     if (listPtr == NULL) {
>         return;
>     }
>
>     IntList previous = NULL;
>     IntList current = *listPtr;
>
>     while (current != NULL) {
>         IntList next = current->next;
>         current->next = previous;
>         previous = current;
>         current = next;
>     }
>
>     *listPtr = previous;
> }
> ```


## E11 — Inserimento ordinato

Implementa l'inserimento di `value` in una lista non decrescente. I duplicati sono ammessi e il nuovo valore va prima dei valori uguali.

> [!success]- Mostra soluzione
>
> ```c
> bool listInsertSorted(IntList *listPtr, int value) {
>     if (listPtr == NULL) {
>         return false;
>     }
>
>     IntList node = malloc(sizeof *node);
>
>     if (node == NULL) {
>         return false;
>     }
>
>     IntList *link = listPtr;
>
>     while (*link != NULL && (*link)->data < value) {
>         link = &(*link)->next;
>     }
>
>     node->data = value;
>     node->next = *link;
>     *link = node;
>     return true;
> }
> ```


## E12 — Clonare la lista con rollback

Implementa una copia indipendente. Se una `malloc` fallisce, libera la copia parziale e restituisce `NULL`.

> [!success]- Mostra soluzione
>
> ```c
> IntList listClone(IntList list) {
>     IntList copy = NULL;
>     IntList *tailLink = &copy;
>
>     for (IntList current = list; current != NULL; current = current->next) {
>         IntList node = malloc(sizeof *node);
>
>         if (node == NULL) {
>             listClear(&copy);
>             return NULL;
>         }
>
>         node->data = current->data;
>         node->next = NULL;
>         *tailLink = node;
>         tailLink = &node->next;
>     }
>
>     return copy;
> }
> ```


---

# F. Stack, queue e set

## F01 — Stack: `push`

Usa `IntList` come stack. Implementa `push` inserendo in testa.

> [!success]- Mostra soluzione
>
> ```c
> bool push(IntList *stackPtr, int value) {
>     return listPushFront(stackPtr, value);
> }
> ```


## F02 — Stack: `pop`

Implementa `pop`. Scrivi il valore rimosso in `out`; restituisci `false` se uno dei puntatori è `NULL` o lo stack è vuoto.

> [!success]- Mostra soluzione
>
> ```c
> bool pop(IntList *stackPtr, int *out) {
>     if (stackPtr == NULL || *stackPtr == NULL || out == NULL) {
>         return false;
>     }
>
>     IntList removed = *stackPtr;
>     *out = removed->data;
>     *stackPtr = removed->next;
>     free(removed);
>     return true;
> }
> ```


## F03 — Struct della coda

Definisci una coda con puntatore al primo nodo, puntatore all'ultimo nodo e numero di elementi.

> [!success]- Mostra soluzione
>
> ```c
> typedef struct {
>     IntList front;
>     IntList rear;
>     size_t size;
> } IntQueue;
> ```


## F04 — Inizializzare la coda

Implementa `queueInit`.

> [!success]- Mostra soluzione
>
> ```c
> void queueInit(IntQueue *queue) {
>     if (queue == NULL) {
>         return;
>     }
>
>     queue->front = NULL;
>     queue->rear = NULL;
>     queue->size = 0;
> }
> ```


## F05 — Accodare

Implementa `enqueue` in tempo costante.

> [!success]- Mostra soluzione
>
> ```c
> bool enqueue(IntQueue *queue, int value) {
>     if (queue == NULL) {
>         return false;
>     }
>
>     IntList node = malloc(sizeof *node);
>
>     if (node == NULL) {
>         return false;
>     }
>
>     node->data = value;
>     node->next = NULL;
>
>     if (queue->rear == NULL) {
>         queue->front = node;
>     } else {
>         queue->rear->next = node;
>     }
>
>     queue->rear = node;
>     queue->size++;
>     return true;
> }
> ```


## F06 — Estrarre dalla coda

Implementa `dequeue` in tempo costante e mantieni coerenti `front`, `rear` e `size`.

> [!success]- Mostra soluzione
>
> ```c
> bool dequeue(IntQueue *queue, int *out) {
>     if (queue == NULL || queue->front == NULL || out == NULL) {
>         return false;
>     }
>
>     IntList removed = queue->front;
>     *out = removed->data;
>     queue->front = removed->next;
>
>     if (queue->front == NULL) {
>         queue->rear = NULL;
>     }
>
>     queue->size--;
>     free(removed);
>     return true;
> }
> ```


## F07 — Set: aggiungere senza duplicati

Rappresenta un insieme con una lista non ordinata. Implementa `setAdd`: se il valore esiste già non modificare nulla ma considera l'operazione riuscita.

> [!success]- Mostra soluzione
>
> ```c
> bool setAdd(IntList *setPtr, int value) {
>     if (setPtr == NULL) {
>         return false;
>     }
>
>     if (listContains(*setPtr, value)) {
>         return true;
>     }
>
>     return listPushFront(setPtr, value);
> }
> ```


---

# G. Alberi binari e BST

## G01 — Nodo di albero

Scrivi la definizione di `TreeNode` e `IntTree` secondo le convenzioni del dojo.

> [!success]- Mostra soluzione
>
> ```c
> typedef struct treeNode TreeNode;
> typedef TreeNode *IntTree;
>
> struct treeNode {
>     int data;
>     IntTree left;
>     IntTree right;
> };
> ```


## G02 — Creare un nodo foglia

Implementa `makeTreeNode`.

> [!success]- Mostra soluzione
>
> ```c
> IntTree makeTreeNode(int value) {
>     IntTree node = malloc(sizeof *node);
>
>     if (node == NULL) {
>         return NULL;
>     }
>
>     node->data = value;
>     node->left = NULL;
>     node->right = NULL;
>     return node;
> }
> ```


## G03 — Visita pre-order

Stampa i valori in ordine radice, sinistra, destra.

> [!success]- Mostra soluzione
>
> ```c
> void treePreOrder(IntTree tree) {
>     if (tree == NULL) {
>         return;
>     }
>
>     printf("%d ", tree->data);
>     treePreOrder(tree->left);
>     treePreOrder(tree->right);
> }
> ```


## G04 — Visita in-order

Stampa i valori in ordine sinistra, radice, destra.

> [!success]- Mostra soluzione
>
> ```c
> void treeInOrder(IntTree tree) {
>     if (tree == NULL) {
>         return;
>     }
>
>     treeInOrder(tree->left);
>     printf("%d ", tree->data);
>     treeInOrder(tree->right);
> }
> ```


## G05 — Visita post-order

Stampa i valori in ordine sinistra, destra, radice.

> [!success]- Mostra soluzione
>
> ```c
> void treePostOrder(IntTree tree) {
>     if (tree == NULL) {
>         return;
>     }
>
>     treePostOrder(tree->left);
>     treePostOrder(tree->right);
>     printf("%d ", tree->data);
> }
> ```


## G06 — Contare i nodi

Implementa `treeSize`.

> [!success]- Mostra soluzione
>
> ```c
> size_t treeSize(IntTree tree) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     return 1 + treeSize(tree->left) + treeSize(tree->right);
> }
> ```


## G07 — Contare le foglie

Una foglia non ha figli. Implementa `treeLeafCount`.

> [!success]- Mostra soluzione
>
> ```c
> size_t treeLeafCount(IntTree tree) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     if (tree->left == NULL && tree->right == NULL) {
>         return 1;
>     }
>
>     return treeLeafCount(tree->left) + treeLeafCount(tree->right);
> }
> ```


## G08 — Sommare i valori

Implementa `treeSum`.

> [!success]- Mostra soluzione
>
> ```c
> long treeSum(IntTree tree) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     return tree->data + treeSum(tree->left) + treeSum(tree->right);
> }
> ```


## G09 — Altezza

Definisci l'altezza dell'albero vuoto come `0` e quella di una foglia come `1`. Implementa `treeHeight`.

> [!success]- Mostra soluzione
>
> ```c
> size_t treeHeight(IntTree tree) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     size_t leftHeight = treeHeight(tree->left);
>     size_t rightHeight = treeHeight(tree->right);
>
>     return 1 + (leftHeight > rightHeight ? leftHeight : rightHeight);
> }
> ```


## G10 — Liberare l'albero

Implementa `treeClear`. Perché la visita corretta è post-order?

> [!success]- Mostra soluzione
>
> ```c
> void treeClear(IntTree tree) {
>     if (tree == NULL) {
>         return;
>     }
>
>     treeClear(tree->left);
>     treeClear(tree->right);
>     free(tree);
> }
> ```
>
> Prima si liberano i figli, poi il nodo dal quale si raggiungono. Dopo `free(tree)` non sarebbe più lecito leggere `tree->left` o `tree->right`.


## G11 — Ricerca in un BST

Implementa la ricerca iterativa in un albero binario di ricerca.

> [!success]- Mostra soluzione
>
> ```c
> bool bstContains(IntTree tree, int value) {
>     while (tree != NULL) {
>         if (value == tree->data) {
>             return true;
>         }
>
>         tree = value < tree->data ? tree->left : tree->right;
>     }
>
>     return false;
> }
> ```


## G12 — Inserimento in un BST

Implementa l'inserimento iterativo senza duplicati. Restituisci `false` solo per argomento non valido o fallimento di `malloc`; un valore già presente conta come successo senza modifica.

> [!success]- Mostra soluzione
>
> ```c
> bool bstInsert(IntTree *treePtr, int value) {
>     if (treePtr == NULL) {
>         return false;
>     }
>
>     IntTree *link = treePtr;
>
>     while (*link != NULL) {
>         if (value == (*link)->data) {
>             return true;
>         }
>
>         link = value < (*link)->data
>              ? &(*link)->left
>              : &(*link)->right;
>     }
>
>     IntTree node = makeTreeNode(value);
>
>     if (node == NULL) {
>         return false;
>     }
>
>     *link = node;
>     return true;
> }
> ```


---

# H. ADT opachi, `void *` e puntatori a funzione

## H01 — Tipo opaco nell'header

Nel file `counter.h`, dichiara un ADT opaco `Counter` e le operazioni per crearlo, incrementarlo, leggerlo e distruggerlo.

> [!success]- Mostra soluzione
>
> ```c
> #ifndef COUNTER_H
> #define COUNTER_H
>
> typedef struct counter *Counter;
>
> Counter counterCreate(void);
> void counterIncrement(Counter counter);
> int counterGet(Counter counter);
> void counterDestroy(Counter counter);
>
> #endif
> ```


## H02 — Definizione privata dell'ADT

Nel file `counter.c`, rendi concreta la struct opaca dell'esercizio precedente.

> [!success]- Mostra soluzione
>
> ```c
> #include <stdlib.h>
> #include "counter.h"
>
> struct counter {
>     int value;
> };
> ```


## H03 — Puntatore a funzione

Definisci `IntPredicate` come tipo di funzione che riceve un `int` e restituisce `bool`. Scrivi anche `isPositive`.

> [!success]- Mostra soluzione
>
> ```c
> typedef bool (*IntPredicate)(int value);
>
> bool isPositive(int value) {
>     return value > 0;
> }
> ```


## H04 — Contare secondo predicato

Implementa `listCountIf`, che conta i nodi per i quali `predicate` restituisce `true`.

> [!success]- Mostra soluzione
>
> ```c
> size_t listCountIf(IntList list, IntPredicate predicate) {
>     if (predicate == NULL) {
>         return 0;
>     }
>
>     size_t count = 0;
>
>     for (IntList current = list; current != NULL; current = current->next) {
>         if (predicate(current->data)) {
>             count++;
>         }
>     }
>
>     return count;
> }
> ```


## H05 — Comparatore generico

Definisci un tipo `Comparator` compatibile con confronti generici basati su `const void *`.

> [!success]- Mostra soluzione
>
> ```c
> typedef int (*Comparator)(const void *first, const void *second);
> ```
>
> Convenzione: risultato negativo se `first < second`, zero se uguali, positivo se `first > second`.


---

# I. Mini-harness TDD

## I01 — Test di un intero

Scrivi una funzione `expectInt` che stampa `OK` oppure `FAIL` con nome del test, valore atteso e valore ottenuto. Restituisce `1` se il test passa, `0` altrimenti.

> [!success]- Mostra soluzione
>
> ```c
> int expectInt(const char *name, int expected, int actual) {
>     if (expected == actual) {
>         printf("OK   %s\n", name);
>         return 1;
>     }
>
>     printf("FAIL %s: expected %d, got %d\n", name, expected, actual);
>     return 0;
> }
> ```


## I02 — Esito complessivo

Scrivi un `main` che esegua tre test, accumuli il loro esito senza interrompersi al primo errore e stampi soltanto alla fine `TEST PASSED` oppure `TEST FAILED`.

> [!success]- Mostra soluzione
>
> ```c
> int main(void) {
>     int passed = 1;
>
>     passed &= expectInt("caso 1", 3, functionUnderTest(1));
>     passed &= expectInt("caso 2", 5, functionUnderTest(2));
>     passed &= expectInt("caso 3", 7, functionUnderTest(3));
>
>     printf("%s\n", passed ? "TEST PASSED" : "TEST FAILED");
>     return passed ? EXIT_SUCCESS : EXIT_FAILURE;
> }
> ```


## I03 — Confrontare due array

Implementa `arraysEqual` per due array di `int` della stessa lunghezza.

> [!success]- Mostra soluzione
>
> ```c
> bool arraysEqual(const int first[], const int second[], size_t length) {
>     for (size_t i = 0; i < length; i++) {
>         if (first[i] != second[i]) {
>             return false;
>         }
>     }
>
>     return true;
> }
> ```


---

# Routine consigliata

## Warm-up da 15 minuti

Esegui senza aprire le soluzioni:

1. A01, B02, C05
2. E01, E05, E07
3. G02, G05, G07
4. I01, I02

## Warm-up da 30 minuti

Esegui il warm-up da 15 minuti e aggiungi:

1. C04, D05
2. E08, E10, E11
3. F05, F06
4. G09, G10, G12

## Criterio di padronanza

Considera una forma automatizzata quando riesci a:

- scriverla senza consultare la soluzione;
- compilarla senza warning;
- spiegare perché ogni puntatore ha quel livello di indirezione;
- indicare chi possiede la memoria e chi deve liberarla;
- produrre almeno tre test, incluso un caso vuoto o limite.
