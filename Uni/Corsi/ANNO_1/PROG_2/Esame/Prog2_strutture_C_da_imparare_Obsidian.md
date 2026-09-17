# Programmazione 2 — Strutture C da imparare a memoria

> [!important] Obiettivo
> Questo file non vuole mostrarti **tutte** le varianti possibili in C.
> Vuole darti **una variante semplice e coerente da usare sempre**, così all'esame non perdi tempo a chiederti:
> “Qui devo scrivere `struct node *`, `Node *`, `List`, `NodePtr`, `typedef struct {...}` oppure altro?”
>
> **Regola:** se la consegna non impone già dei tipi, usa le forme di questo file.

---

# 0. Le 6 regole da fissare prima di tutto

1. **Se non devo modificare il puntatore del chiamante**, passo il puntatore normalmente.
   ```c
   int length(IntList list);
   ```

2. **Se devo poter cambiare testa/root del chiamante**, passo il suo indirizzo.
   ```c
   void insert(IntList *listPtr, int value);
   void treeInsert(IntTree *treePtr, int value);
   ```

3. **Ogni `malloc` va controllata.**
   ```c
   Node *node = malloc(sizeof *node);
   if (node == NULL) {
       return NULL;
   }
   ```

4. **Prima di fare `free`, salva ciò che ti servirà dopo.**
   ```c
   Node *next = current->next;
   free(current);
   current = next;
   ```

5. **Per stringhe e array dinamici pensa sempre anche alla dimensione.**
   Per le stringhe serve inoltre lo spazio per `'\0'`.

6. **Scegli uno stile di `typedef` e non cambiarlo ogni esercizio.**
   In questo file useremo sempre:
   ```c
   typedef struct nomeStruct NomeTipo;
   typedef NomeTipo *NomePuntatore;
   ```

---

# 1. Comandi di compilazione

## Normale

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -g main.c -o main
```

## Più file

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -g main.c struttura.c -o main
```

## Debug di memoria

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -g \
    -fsanitize=address,undefined \
    main.c -o main
```

```bash
./main
```

> [!tip]
> Durante l'allenamento usa sempre almeno `-Wall -Wextra -Wpedantic`.

---

# 2. `#include` utili da conoscere

| Header | Quando ti serve |
|---|---|
| `#include <stdio.h>` | `printf`, `puts`, `scanf`, `FILE`, `fopen`, `fclose`, `fscanf`, `fprintf`, `fgets`, `fputs`, `fgetc`, `fputc` |
| `#include <stdlib.h>` | `malloc`, `calloc`, `realloc`, `free`, `exit` |
| `#include <string.h>` | `strlen`, `strcmp`, `strcpy`, `strncpy`, `memcpy`, `memmove` |
| `#include <stdbool.h>` | `bool`, `true`, `false` |
| `#include <assert.h>` | `assert(...)` |
| `#include <stddef.h>` | `size_t`, `NULL` |
| `#include <math.h>` | `sqrt`, `pow`, funzioni matematiche |
| `#include <ctype.h>` | `isdigit`, `isalpha`, `isspace`, `tolower`, `toupper` |
| `#include <limits.h>` | `INT_MIN`, `INT_MAX`, ecc. |
| `#include <stdint.h>` | tipi come `int32_t`, `uint64_t` quando richiesti |

## Pacchetto base che copre quasi tutti gli esercizi

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>
```

Non includere header “per sicurezza” se non servono, ma in fase di allenamento questi cinque coprono gran parte degli esercizi del corso.

---

# 3. Lo stile `struct` + `typedef` da usare sempre

## 3.1 Struct normale

```c
typedef struct person Person;

struct person {
    char name[50];
    int age;
};
```

Uso:

```c
Person p;
p.age = 20;
```

Puntatore:

```c
Person *pPtr = &p;
pPtr->age = 21;
```

---

## 3.2 Struct autoreferenziale

Questa è la forma da memorizzare.

```c
typedef struct listNode ListNode;
typedef ListNode *IntList;

struct listNode {
    int data;
    IntList next;
};
```

Mentalmente:

```text
ListNode = il nodo vero
IntList  = un puntatore a ListNode
```

Quindi:

```c
IntList list;
```

equivale a:

```c
ListNode *list;
```

e:

```c
IntList *listPtr;
```

equivale a:

```c
ListNode **listPtr;
```

> [!important]
> Questa forma rende molto più leggibile il puntatore a puntatore:
>
> ```c
> void insert(IntList *listPtr, int value);
> ```
>
> invece di:
>
> ```c
> void insert(ListNode **listPtr, int value);
> ```

---

# 4. Come leggere velocemente `*`, `**`, `&` e `->`

Con:

```c
typedef struct listNode ListNode;
typedef ListNode *IntList;
```

se hai:

```c
IntList list;
```

allora:

```text
list          = puntatore al primo nodo
list->data    = dato del primo nodo
list->next    = puntatore al secondo nodo
```

Se hai:

```c
IntList *listPtr = &list;
```

allora:

```text
listPtr           = indirizzo della variabile list
*listPtr          = list
(*listPtr)->data  = dato del primo nodo
&(*listPtr)->next = indirizzo del campo next del primo nodo
```

## Formula mentale

```text
T      -> valore
T *    -> indirizzo di un T
T **   -> indirizzo di una variabile che contiene T *
```

Quindi:

```c
IntList
```

è già un `ListNode *`.

Per questo:

```c
IntList *
```

è un `ListNode **`.

---

# 5. Quando usare puntatore normale e quando puntatore a puntatore

## Solo lettura / scansione

```c
size_t length(IntList list);
bool contains(IntList list, int value);
```

La testa non deve cambiare.

---

## Modifica dei nodi ma non necessariamente della testa

Spesso può bastare:

```c
void changeValues(IntList list);
```

perché puoi modificare:

```c
list->data
```

senza cambiare il puntatore `list` del chiamante.

---

## La testa può cambiare

Usa:

```c
void insertHead(IntList *listPtr, int value);
void deleteFirst(IntList *listPtr, int value);
void deleteAll(IntList *listPtr, int value);
void reverse(IntList *listPtr);
```

Perché devi poter fare:

```c
*listPtr = ...
```

---

# 6. `malloc` e `free`: pattern obbligatori

## 6.1 Allocare un oggetto

```c
Type *ptr = malloc(sizeof *ptr);

if (ptr == NULL) {
    return NULL;
}
```

Preferisci:

```c
malloc(sizeof *ptr)
```

a:

```c
malloc(sizeof(Type))
```

---

## 6.2 Allocare un array

```c
int *array = malloc(n * sizeof *array);

if (array == NULL) {
    return NULL;
}
```

---

## 6.3 Allocare una stringa

```c
char *copy = malloc((length + 1) * sizeof *copy);

if (copy == NULL) {
    return NULL;
}
```

Il `+ 1` è per:

```c
'\0'
```

---

## 6.4 Liberare e azzerare un puntatore del chiamante

```c
void destroy(Type **ptrPtr) {
    if (ptrPtr == NULL || *ptrPtr == NULL) {
        return;
    }

    free(*ptrPtr);
    *ptrPtr = NULL;
}
```

---

# 7. Array: schemi che ricorrono continuamente

## 7.1 Scansione completa

```c
for (size_t i = 0; i < size; i++) {
    // array[i]
}
```

---

## 7.2 Ricerca

```c
for (size_t i = 0; i < size; i++) {
    if (array[i] == value) {
        return true;
    }
}

return false;
```

---

## 7.3 Massimo/minimo

Se l'array è sicuramente non vuoto:

```c
int max = array[0];

for (size_t i = 1; i < size; i++) {
    if (array[i] > max) {
        max = array[i];
    }
}
```

---

## 7.4 Due indici: lettura/scrittura

Pattern importantissimo per filtrare in-place.

```c
size_t write = 0;

for (size_t read = 0; read < size; read++) {
    if (/* elemento da mantenere */) {
        array[write] = array[read];
        write++;
    }
}
```

Alla fine:

```text
write = nuova dimensione logica
```

---

# 8. Stringhe: le forme che devi riconoscere subito

Una stringa C è:

```text
array di char terminato da '\0'
```

## 8.1 Calcolo manuale lunghezza

```c
size_t length = 0;

while (s[length] != '\0') {
    length++;
}
```

---

## 8.2 Scansione

```c
for (size_t i = 0; s[i] != '\0'; i++) {
    // s[i]
}
```

---

## 8.3 Copia manuale

```c
size_t i = 0;

while (source[i] != '\0') {
    dest[i] = source[i];
    i++;
}

dest[i] = '\0';
```

---

## 8.4 Duplica stringa dinamicamente

```c
char *stringDuplicate(const char *source) {
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

---

## 8.5 Filtrare/modificare in-place

```c
size_t read = 0;
size_t write = 0;

while (s[read] != '\0') {
    if (/* carattere da tenere */) {
        s[write] = s[read];
        write++;
    }

    read++;
}

s[write] = '\0';
```

Questo è uno dei pattern più utili per gli esercizi sulle stringhe.

---

# 9. Lista linkata: definizione standard

Usa questa.

```c
typedef struct listNode ListNode;
typedef ListNode *IntList;

struct listNode {
    int data;
    IntList next;
};
```

Lista vuota:

```c
IntList list = NULL;
```

---

# 10. Lista: scansione senza modificare collegamenti

```c
IntList current = list;

while (current != NULL) {
    // usa current->data
    current = current->next;
}
```

Versione `for`:

```c
for (IntList current = list;
     current != NULL;
     current = current->next) {

    // current->data
}
```

---

# 11. Creare un nodo

```c
static IntList makeNode(int value) {
    IntList node = malloc(sizeof *node);

    if (node == NULL) {
        return NULL;
    }

    node->data = value;
    node->next = NULL;

    return node;
}
```

Questo helper riduce tantissimo gli errori.

---

# 12. Inserimento in testa

```c
bool insertHead(IntList *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    IntList node = makeNode(value);

    if (node == NULL) {
        return false;
    }

    node->next = *listPtr;
    *listPtr = node;

    return true;
}
```

Schema da ricordare:

```c
newNode->next = *listPtr;
*listPtr = newNode;
```

---

# 13. Inserimento in fondo

```c
bool insertTail(IntList *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    IntList node = makeNode(value);

    if (node == NULL) {
        return false;
    }

    if (*listPtr == NULL) {
        *listPtr = node;
        return true;
    }

    IntList current = *listPtr;

    while (current->next != NULL) {
        current = current->next;
    }

    current->next = node;

    return true;
}
```

---

# 14. Cancellazione: versione semplice `prev/current`

Usala quando vuoi massima leggibilità.

```c
bool deleteFirst(IntList *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    IntList prev = NULL;
    IntList current = *listPtr;

    while (current != NULL && current->data != value) {
        prev = current;
        current = current->next;
    }

    if (current == NULL) {
        return false;
    }

    if (prev == NULL) {
        *listPtr = current->next;
    } else {
        prev->next = current->next;
    }

    free(current);
    return true;
}
```

## Lista della spesa mentale

```text
prev    = nodo precedente
current = nodo che sto controllando
```

Quando trovi il nodo:

```text
prev == NULL  -> sto cancellando la testa
prev != NULL  -> prev->next deve saltare current
```

---

# 15. Cancellazione: versione con puntatore a puntatore

Più compatta.

```c
bool deleteFirst(IntList *listPtr, int value) {
    if (listPtr == NULL) {
        return false;
    }

    IntList *currentPtr = listPtr;

    while (*currentPtr != NULL &&
           (*currentPtr)->data != value) {

        currentPtr = &(*currentPtr)->next;
    }

    if (*currentPtr == NULL) {
        return false;
    }

    IntList toDelete = *currentPtr;
    *currentPtr = toDelete->next;

    free(toDelete);
    return true;
}
```

## Mentalmente

`currentPtr` non indica “il nodo corrente”.

Indica:

```text
il posto in cui è memorizzato il puntatore al nodo corrente
```

All'inizio:

```c
currentPtr = listPtr;
```

quindi indica la testa.

Poi:

```c
currentPtr = &(*currentPtr)->next;
```

quindi passa a indicare il campo `next`.

> [!tip]
> Per cancellazioni ripetute, inserimenti ordinati e operazioni in cui vuoi trattare testa e nodi interni nello stesso modo, il puntatore a puntatore è spesso molto comodo.

---

# 16. Quando servono `prev`, `current`, `next`

Usa tre variabili quando stai **ricablando** molti collegamenti.

Esempio principale: inversione della lista.

```c
void reverseList(IntList *listPtr) {
    if (listPtr == NULL) {
        return;
    }

    IntList prev = NULL;
    IntList current = *listPtr;

    while (current != NULL) {
        IntList next = current->next;

        current->next = prev;

        prev = current;
        current = next;
    }

    *listPtr = prev;
}
```

Ruoli:

```text
prev    = parte già invertita
current = nodo su cui sto lavorando
next    = salvo il resto prima di spezzare il collegamento
```

---

# 17. Distruggere una lista

```c
void destroyList(IntList *listPtr) {
    if (listPtr == NULL) {
        return;
    }

    IntList current = *listPtr;

    while (current != NULL) {
        IntList next = current->next;
        free(current);
        current = next;
    }

    *listPtr = NULL;
}
```

Regola vitale:

```c
next = current->next;
free(current);
current = next;
```

NON:

```c
free(current);
current = current->next;
```

---

# 18. Lista ricorsiva: scheletro universale

```c
ReturnType function(IntList list) {
    if (list == NULL) {
        // caso base
    }

    // usa list->data
    return function(list->next);
}
```

Esempio conteggio:

```c
size_t lengthRec(IntList list) {
    if (list == NULL) {
        return 0;
    }

    return 1 + lengthRec(list->next);
}
```

Per le liste, se l'esercizio non richiede ricorsione, la versione iterativa è spesso più prudente.

---

# 19. Stack / pila: struttura semplice da ricordare

Politica:

```text
LIFO
```

Se la implementi con lista linkata, lavora sempre in testa.

## Tipo non opaco

```c
typedef struct stack Stack;

struct stack {
    IntList top;
    size_t size;
};
```

## Tipo opaco da ADT

Nel `.h`:

```c
typedef struct stack *Stack;
```

Nel `.c`:

```c
struct stack {
    IntList top;
    size_t size;
};
```

## Push

```c
bool push(Stack s, int value) {
    if (s == NULL) {
        return false;
    }

    IntList node = makeNode(value);

    if (node == NULL) {
        return false;
    }

    node->next = s->top;
    s->top = node;
    s->size++;

    return true;
}
```

## Pop con parametro di output

```c
bool pop(Stack s, int *out) {
    if (s == NULL || out == NULL || s->top == NULL) {
        return false;
    }

    IntList toDelete = s->top;

    *out = toDelete->data;
    s->top = toDelete->next;
    s->size--;

    free(toDelete);
    return true;
}
```

---

# 20. Queue / coda: struttura semplice da ricordare

Politica:

```text
FIFO
```

Definizione:

```c
typedef struct queueNode QueueNode;
typedef QueueNode *QueueNodePtr;

struct queueNode {
    int data;
    QueueNodePtr next;
};

typedef struct queue Queue;

struct queue {
    QueueNodePtr front;
    QueueNodePtr rear;
    size_t size;
};
```

Coda vuota:

```c
q->front = NULL;
q->rear = NULL;
q->size = 0;
```

## Enqueue

```c
bool enqueue(Queue *q, int value) {
    if (q == NULL) {
        return false;
    }

    QueueNodePtr node = malloc(sizeof *node);

    if (node == NULL) {
        return false;
    }

    node->data = value;
    node->next = NULL;

    if (q->rear == NULL) {
        q->front = node;
        q->rear = node;
    } else {
        q->rear->next = node;
        q->rear = node;
    }

    q->size++;

    return true;
}
```

## Dequeue

```c
bool dequeue(Queue *q, int *out) {
    if (q == NULL || out == NULL || q->front == NULL) {
        return false;
    }

    QueueNodePtr toDelete = q->front;

    *out = toDelete->data;
    q->front = toDelete->next;

    if (q->front == NULL) {
        q->rear = NULL;
    }

    q->size--;

    free(toDelete);
    return true;
}
```

> [!important]
> Quando togli l'ultimo nodo:
>
> ```c
> q->front = NULL;
> q->rear = NULL;
> ```

---

# 21. Set / insieme di `int` con lista

Un set deve garantire:

```text
nessun duplicato
```

Puoi riusare la stessa:

```c
typedef struct listNode ListNode;
typedef ListNode *IntSet;
```

oppure, per chiarezza:

```c
typedef IntList IntSet;
```

## Contains

```c
bool setContains(IntSet set, int value) {
    while (set != NULL) {
        if (set->data == value) {
            return true;
        }

        set = set->next;
    }

    return false;
}
```

## Add semplice

```c
bool setAdd(IntSet *setPtr, int value) {
    if (setPtr == NULL) {
        return false;
    }

    if (setContains(*setPtr, value)) {
        return true;
    }

    return insertHead(setPtr, value);
}
```

Se il set deve essere ordinato, l'inserimento deve mantenere l'ordine.

## Intersezione: idea universale

```text
per ogni elemento di A:
    se appartiene a B:
        aggiungilo al risultato
```

Per liste ordinate puoi scorrere entrambe in parallelo.

---

# 22. Albero binario: definizione da usare sempre

```c
typedef struct treeNode TreeNode;
typedef TreeNode *IntTree;

struct treeNode {
    int data;
    IntTree left;
    IntTree right;
};
```

Albero vuoto:

```c
IntTree tree = NULL;
```

Questa definizione è l'equivalente ad albero di:

```c
typedef ListNode *IntList;
```

---

# 23. Albero: scheletro ricorsivo universale

```c
ReturnType function(IntTree tree) {
    if (tree == NULL) {
        // caso base
    }

    // lavoro sul nodo

    function(tree->left);
    function(tree->right);
}
```

Questo pattern copre gran parte degli esercizi.

---

# 24. Conta nodi

```c
size_t treeCountNodes(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    return 1
        + treeCountNodes(tree->left)
        + treeCountNodes(tree->right);
}
```

---

# 25. Conta foglie

```c
size_t treeCountLeaves(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    if (tree->left == NULL && tree->right == NULL) {
        return 1;
    }

    return treeCountLeaves(tree->left)
         + treeCountLeaves(tree->right);
}
```

---

# 26. Visite

## Pre-order

```c
void preorder(IntTree tree) {
    if (tree == NULL) {
        return;
    }

    printf("%d ", tree->data);
    preorder(tree->left);
    preorder(tree->right);
}
```

Ordine:

```text
NODO - LEFT - RIGHT
```

## In-order

```c
void inorder(IntTree tree) {
    if (tree == NULL) {
        return;
    }

    inorder(tree->left);
    printf("%d ", tree->data);
    inorder(tree->right);
}
```

Ordine:

```text
LEFT - NODO - RIGHT
```

Su BST produce valori ordinati.

## Post-order

```c
void postorder(IntTree tree) {
    if (tree == NULL) {
        return;
    }

    postorder(tree->left);
    postorder(tree->right);
    printf("%d ", tree->data);
}
```

Ordine:

```text
LEFT - RIGHT - NODO
```

È anche l'ordine giusto per liberare memoria.

---

# 27. Distruggere un albero

```c
void destroyTree(IntTree *treePtr) {
    if (treePtr == NULL || *treePtr == NULL) {
        return;
    }

    destroyTree(&(*treePtr)->left);
    destroyTree(&(*treePtr)->right);

    free(*treePtr);
    *treePtr = NULL;
}
```

Mentalmente:

```text
prima figli
poi nodo
```

---

# 28. BST: ricerca

```c
bool bstContains(IntTree tree, int value) {
    if (tree == NULL) {
        return false;
    }

    if (value == tree->data) {
        return true;
    }

    if (value < tree->data) {
        return bstContains(tree->left, value);
    }

    return bstContains(tree->right, value);
}
```

---

# 29. BST: inserimento

```c
bool bstInsert(IntTree *treePtr, int value) {
    if (treePtr == NULL) {
        return false;
    }

    if (*treePtr == NULL) {
        IntTree node = malloc(sizeof *node);

        if (node == NULL) {
            return false;
        }

        node->data = value;
        node->left = NULL;
        node->right = NULL;

        *treePtr = node;
        return true;
    }

    if (value < (*treePtr)->data) {
        return bstInsert(&(*treePtr)->left, value);
    }

    if (value > (*treePtr)->data) {
        return bstInsert(&(*treePtr)->right, value);
    }

    return true;
}
```

Nota la forma:

```c
bstInsert(&(*treePtr)->left, value);
```

Stesso concetto del puntatore a puntatore nelle liste.

---

# 30. ADT opaco: la forma più semplice da usare

Quando la consegna parla di:

```text
ADT
tipo opaco
interfaccia
implementazione nascosta
```

usa questo schema.

## `stack.h`

```c
#ifndef STACK_H
#define STACK_H

#include <stdbool.h>
#include <stddef.h>

typedef struct stack *Stack;

Stack stackCreate(void);
void stackDestroy(Stack *stackPtr);

bool stackPush(Stack stack, int value);
bool stackPop(Stack stack, int *out);

bool stackIsEmpty(Stack stack);
size_t stackSize(Stack stack);

#endif
```

## `stack.c`

```c
#include "stack.h"
#include <stdlib.h>

typedef struct node Node;
typedef Node *NodePtr;

struct node {
    int data;
    NodePtr next;
};

struct stack {
    NodePtr top;
    size_t size;
};
```

Il client conosce solo:

```c
typedef struct stack *Stack;
```

ma **non conosce i campi** della `struct stack`.

Quindi il client può fare:

```c
Stack s = stackCreate();
```

ma non:

```c
s->top
```

---

# 31. Regola per non confondersi con gli ADT

## Caso A — esercizio semplice, nessuna opacità richiesta

Puoi usare:

```c
typedef struct stack Stack;

struct stack {
    ...
};
```

e dichiarare:

```c
Stack s;
```

---

## Caso B — ADT opaco

Nel `.h`:

```c
typedef struct stack *Stack;
```

Nel `.c`:

```c
struct stack {
    ...
};
```

In questo caso:

```c
Stack s;
```

è già un puntatore.

> [!danger]
> Se `Stack` è:
>
> ```c
> typedef struct stack *Stack;
> ```
>
> allora:
>
> ```c
> Stack *
> ```
>
> è un `struct stack **`.

---

# 32. Genericità con `void *`

Se una struttura deve contenere elementi di tipo arbitrario:

```c
typedef struct node Node;
typedef Node *NodePtr;

struct node {
    void *data;
    NodePtr next;
};
```

La struttura non sa quale sia il tipo reale di `data`.

## Recupero

Se sai che contiene `int *`:

```c
int *valuePtr = node->data;
int value = *valuePtr;
```

oppure:

```c
int value = *(int *)node->data;
```

> [!warning]
> `void *` aumenta il riuso ma riduce il controllo sui tipi.

---

# 33. Puntatori a funzione: non scriverli inline se puoi evitarlo

Forma difficile:

```c
int (*compare)(const void *, const void *);
```

Forma molto più leggibile:

```c
typedef int (*CompareFunc)(const void *, const void *);
```

Poi:

```c
CompareFunc compare;
```

Esempio ADT generico:

```c
typedef int (*CompareFunc)(const void *, const void *);
typedef void (*DestroyFunc)(void *);

typedef struct set Set;

struct set {
    NodePtr first;
    CompareFunc compare;
    DestroyFunc destroy;
};
```

Mentalmente:

```text
CompareFunc = "tipo funzione di confronto"
DestroyFunc = "tipo funzione distruttrice"
```

---

# 34. Funzione di confronto: convenzione utile

```c
int compareInt(const void *a, const void *b) {
    const int *x = a;
    const int *y = b;

    if (*x < *y) {
        return -1;
    }

    if (*x > *y) {
        return 1;
    }

    return 0;
}
```

Convenzione:

```text
< 0  -> a viene prima di b
= 0  -> equivalenti
> 0  -> a viene dopo b
```

---

# 35. `enum`: usala per stati discreti

```c
typedef enum {
    INSERTED,
    ALREADY_PRESENT,
    OUT_OF_MEMORY
} InsertResult;
```

Poi:

```c
InsertResult result;
```

È più leggibile di usare numeri magici.

---

# 36. `union` + tag

Quando un oggetto può contenere **uno tra più tipi**:

```c
typedef enum {
    VALUE_INT,
    VALUE_DOUBLE
} ValueType;

typedef union {
    int i;
    double d;
} Value;

typedef struct taggedValue TaggedValue;

struct taggedValue {
    ValueType type;
    Value value;
};
```

Uso:

```c
TaggedValue x;
x.type = VALUE_INT;
x.value.i = 42;
```

Il tag dice quale campo della `union` è valido.

---

# 37. File: scheletro universale

```c
FILE *file = fopen(filename, "r");

if (file == NULL) {
    // errore
}

// usa file

fclose(file);
```

---

# 38. Leggere interi fino a fine input

```c
int value;

while (fscanf(file, "%d", &value) == 1) {
    // usa value
}
```

> [!important]
> Non usare:
>
> ```c
> while (!feof(file))
> ```
>
> come ciclo principale di lettura.
>
> Controlla il risultato della funzione che legge.

---

# 39. Leggere una riga

```c
char buffer[256];

while (fgets(buffer, sizeof buffer, file) != NULL) {
    // usa buffer
}
```

---

# 40. Scrivere su file

```c
FILE *file = fopen(filename, "w");

if (file == NULL) {
    return false;
}

fprintf(file, "%d\n", value);

fclose(file);
```

Modalità principali:

```text
"r"  lettura
"w"  scrittura, azzera il file
"a"  append
"rb" lettura binaria
"wb" scrittura binaria
```

---

# 41. TDD: struttura minima da usare all'esame

Se vuoi restare semplice:

```c
#include <stdio.h>
#include <stdbool.h>

static bool allPassed = true;

static void checkInt(
    const char *name,
    int expected,
    int actual
) {
    if (expected != actual) {
        allPassed = false;

        printf(
            "%s FAILED: expected %d, got %d\n",
            name,
            expected,
            actual
        );
    }
}
```

Nel `main`:

```c
int main(void) {
    checkInt("test 1", 3, myFunction(...));
    checkInt("test 2", 0, myFunction(...));

    if (allPassed) {
        puts("TEST PASSED");
    } else {
        puts("TEST FAILED");
    }

    return allPassed ? 0 : 1;
}
```

---

# 42. Struttura test con un metodo per caso

```c
static bool testCase1(void) {
    int result = myFunction(...);
    return result == expected;
}

static bool testCase2(void) {
    int result = myFunction(...);
    return result == expected;
}
```

Poi:

```c
int main(void) {
    bool passed = true;

    passed = testCase1() && passed;
    passed = testCase2() && passed;

    puts(passed ? "TEST PASSED" : "TEST FAILED");

    return passed ? 0 : 1;
}
```

Questa forma ti permette di avere test separati senza complicare troppo il codice.

---

# 43. Header `.h`: scheletro

```c
#ifndef MY_ADT_H
#define MY_ADT_H

#include <stdbool.h>
#include <stddef.h>

typedef struct myADT *MyADT;

MyADT myADTCreate(void);
void myADTDestroy(MyADT *adtPtr);

bool myADTOperation(MyADT adt, int value);
size_t myADTSize(MyADT adt);

#endif
```

---

# 44. File `.c`: scheletro

```c
#include "myADT.h"
#include <stdlib.h>

struct myADT {
    // campi privati
};

static bool helper(/* ... */) {
    // funzione privata del modulo
}

MyADT myADTCreate(void) {
    MyADT adt = malloc(sizeof *adt);

    if (adt == NULL) {
        return NULL;
    }

    // inizializza campi

    return adt;
}
```

Le funzioni helper private:

```c
static
```

---

# 45. Decisione rapida: che firma uso?

| Situazione | Firma tipica |
|---|---|
| Leggere/scansionare una lista | `f(IntList list)` |
| Modificare i dati dei nodi | spesso `f(IntList list)` |
| Cambiare testa lista | `f(IntList *listPtr)` |
| Leggere/scansionare un albero | `f(IntTree tree)` |
| Cambiare root o collegamenti dal chiamante | `f(IntTree *treePtr)` |
| Modificare un normale `int` del chiamante | `f(int *x)` |
| Modificare un puntatore del chiamante | `f(Type **ptrPtr)` |
| ADT opaco | `typedef struct x *X;` |
| Restituire valore + successo/fallimento | `bool f(..., Type *out)` |
| Tipo generico | `void *` |
| Comportamento generico | puntatore a funzione |

---

# 46. Pattern successo/fallimento + output

Molto utile quando un valore di ritorno può essere ambiguo.

```c
bool findValue(
    IntList list,
    int target,
    int *out
) {
    if (out == NULL) {
        return false;
    }

    while (list != NULL) {
        if (list->data == target) {
            *out = list->data;
            return true;
        }

        list = list->next;
    }

    return false;
}
```

Il `bool` dice:

```text
operazione riuscita?
```

`*out` contiene:

```text
il risultato vero
```

---

# 47. Pattern difensivo per più `malloc`

```c
Type *object = malloc(sizeof *object);

if (object == NULL) {
    return NULL;
}

object->data = malloc(...);

if (object->data == NULL) {
    free(object);
    return NULL;
}
```

Se una seconda allocazione fallisce:

```text
libera ciò che avevi già allocato
```

---

# 48. Errori che devi eliminare completamente

## Dereferenziare prima del controllo

SBAGLIATO:

```c
if (node->data == value && node != NULL) {
}
```

GIUSTO:

```c
if (node != NULL && node->data == value) {
}
```

---

## Usare un nodo dopo `free`

SBAGLIATO:

```c
free(current);
current = current->next;
```

GIUSTO:

```c
IntList next = current->next;
free(current);
current = next;
```

---

## Dimenticare `+ 1` nelle stringhe

SBAGLIATO:

```c
malloc(strlen(s));
```

GIUSTO:

```c
malloc((strlen(s) + 1) * sizeof(char));
```

o meglio:

```c
malloc((strlen(s) + 1) * sizeof *copy);
```

---

## Fare `malloc` e usare subito il puntatore

SBAGLIATO:

```c
IntList node = malloc(sizeof *node);
node->data = value;
```

GIUSTO:

```c
IntList node = malloc(sizeof *node);

if (node == NULL) {
    return false;
}

node->data = value;
```

---

## Perdere la testa della lista

SBAGLIATO:

```c
list = list->next;
```

se `list` è la tua unica variabile e ti serviva ancora la testa.

Per scandire usa:

```c
IntList current = list;
```

---

# 49. Le 8 strutture da saper scrivere a memoria

Se sei a corto di tempo, queste sono prioritarie.

## 1. Nodo lista

```c
typedef struct listNode ListNode;
typedef ListNode *IntList;

struct listNode {
    int data;
    IntList next;
};
```

## 2. Nodo albero

```c
typedef struct treeNode TreeNode;
typedef TreeNode *IntTree;

struct treeNode {
    int data;
    IntTree left;
    IntTree right;
};
```

## 3. Allocazione

```c
Type *ptr = malloc(sizeof *ptr);

if (ptr == NULL) {
    return NULL;
}
```

## 4. Scansione lista

```c
for (IntList current = list;
     current != NULL;
     current = current->next) {
}
```

## 5. Distruzione lista

```c
while (current != NULL) {
    IntList next = current->next;
    free(current);
    current = next;
}
```

## 6. Ricorsione albero

```c
if (tree == NULL) {
    // base
}

function(tree->left);
function(tree->right);
```

## 7. File

```c
FILE *file = fopen(filename, "r");

if (file == NULL) {
    // errore
}

...

fclose(file);
```

## 8. ADT opaco

```c
typedef struct myADT *MyADT;
```

nel `.h`, e:

```c
struct myADT {
    ...
};
```

nel `.c`.

---

# 50. Modello mentale finale

Quando leggi una consegna, fai queste domande nell'ordine:

```text
1. Qual è il dato principale?
2. È un valore, un array, una stringa, una lista, un albero o un ADT?
3. Devo modificarlo?
4. Se è un puntatore, devo cambiare anche il puntatore del chiamante?
5. Serve malloc?
6. Chi farà free?
7. Qual è il caso vuoto/NULL?
8. Qual è il caso da un solo elemento?
9. Quali collegamenti rischio di perdere?
10. Quali test minimi dimostrano che funziona?
```

## Traduzione automatica

```text
"Scorri lista"
    -> current

"Cancella un nodo"
    -> prev/current oppure puntatore a puntatore

"Inverti collegamenti"
    -> prev/current/next

"Cambia testa/root"
    -> puntatore a puntatore

"Visita albero"
    -> caso base + sinistra + destra

"Libera albero"
    -> post-order

"ADT opaco"
    -> typedef struct x *X nel .h
       struct x {...} nel .c

"Tipo generico"
    -> void *

"Comportamento generico"
    -> typedef di puntatore a funzione

"Operazione può fallire ma deve produrre un valore"
    -> bool + parametro out
```

---

# 51. Mini-template da aprire prima di un esercizio

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stddef.h>

/* DEFINIZIONE TIPI */

/* PROTOTIPI */

/* HELPER static */

/* FUNZIONI RICHIESTE */

/* TEST */

int main(void) {
    bool allPassed = true;

    /* esegui test */

    puts(allPassed ? "TEST PASSED" : "TEST FAILED");

    return allPassed ? 0 : 1;
}
```

> [!important] Regola per l'esame
> Non cercare la forma “più elegante” mentre stai risolvendo.
>
> Cerca la forma che:
>
> - sai spiegare;
> - sai testare;
> - non perde puntatori;
> - gestisce `NULL`;
> - gestisce `malloc`;
> - compila senza warning;
> - riesci a riscrivere senza pensarci troppo.

