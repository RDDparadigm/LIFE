# Programmazione 2 in C — Cheat sheet operativo

## Tipi di base

```c
#include <assert.h>
#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    OK,
    INSERTED,
    REMOVED,
    ALREADY_PRESENT,
    NOT_FOUND,
    EMPTY,
    OUT_OF_MEMORY,
    IO_ERROR
} Outcome;

/* Lista di int */
typedef struct IntListNode {
    int data;
    struct IntListNode *next;
} IntListNode, *IntList;

/* Lista doppiamente linkata */
typedef struct DListNode {
    int data;
    struct DListNode *prev;
    struct DListNode *next;
} DListNode, *DList;

/* Pila linkata */
typedef struct StackNode {
    int data;
    struct StackNode *next;
} StackNode;

typedef struct IntStack {
    StackNode *top;
    size_t size;
} IntStack, *IntStackADT;

/* Coda linkata */
typedef struct QueueNode {
    int data;
    struct QueueNode *next;
} QueueNode;

typedef struct IntQueue {
    QueueNode *front;
    QueueNode *rear;
    size_t size;
} IntQueue, *IntQueueADT;

/* Deque doppiamente linkata */
typedef struct IntDeque {
    DListNode *front;
    DListNode *rear;
    size_t size;
} IntDeque, *IntDequeADT;

/* Insieme di int con lista ordinata */
typedef struct IntSet {
    IntList first;
    size_t size;
} IntSet, *IntSetADT;

/* Albero binario di int */
typedef struct IntTreeNode {
    int data;
    struct IntTreeNode *left;
    struct IntTreeNode *right;
} IntTreeNode, *IntTree;

/* Albero n-ario: primo figlio / fratello successivo */
typedef struct NTreeNode {
    int data;
    struct NTreeNode *firstChild;
    struct NTreeNode *nextSibling;
} NTreeNode, *NTree;

/* Callback generiche */
typedef int   (*CompareFn)(const void *, const void *);
typedef bool  (*PredicateFn)(const void *);
typedef void *(*CopyFn)(const void *);
typedef void  (*DestroyFn)(void *);
typedef void  (*PrintFn)(const void *);

/* Lista generica */
typedef struct GNode {
    void *data;
    struct GNode *next;
} GNode, *GList;

typedef struct GenericList {
    GList first;
    size_t size;
    CompareFn compare;
    CopyFn copy;
    DestroyFn destroy;
} GenericList, *GenericListADT;

/* Stringa dinamica */
typedef struct DynString {
    char *content;
    size_t length;
    size_t capacity;
} DynString, *DynStringPtr;

/* Valore eterogeneo con tag */
typedef enum {
    VALUE_INT,
    VALUE_DOUBLE,
    VALUE_STRING
} ValueTag;

typedef struct TaggedValue {
    ValueTag tag;
    union {
        int i;
        double d;
        char *s;
    } value;
} TaggedValue;

/* Tipi di supporto per visite iterative */
typedef struct TreeStack *TreeStackADT;
typedef struct TreeQueue *TreeQueueADT;
typedef struct NTreeQueue *NTreeQueueADT;

/* Esempio di record */
typedef struct Person {
    int id;
    char *name;
} Person;
```

## Firme principali

```c
/* Memoria, array, stringhe */
int *cloneArray(const int a[], size_t n);
bool appendInt(int **aPtr, size_t *nPtr, size_t *capPtr, int value);
void reverseArrayIter(int a[], size_t n);
void reverseArrayRec(int a[], size_t left, size_t right);
long sumArrayIter(const int a[], size_t n);
long sumArrayRec(const int a[], size_t n);
ptrdiff_t linearSearchIter(const int a[], size_t n, int value);
ptrdiff_t linearSearchRec(const int a[], size_t n, int value);
ptrdiff_t binarySearchIter(const int a[], size_t n, int value);
ptrdiff_t binarySearchRec(const int a[], ptrdiff_t left, ptrdiff_t right, int value);
char *cloneString(const char *s);
DynStringPtr mkDynString(size_t initialCapacity);
bool appendDynString(DynStringPtr s, const char *suffix);
void resetDynString(DynStringPtr s);
void dsDynString(DynStringPtr *sPtr);

/* Liste */
IntList makeNode(int value);
size_t listLengthIter(const IntListNode *ls);
size_t listLengthRec(const IntListNode *ls);
long listSumIter(const IntListNode *ls);
long listSumRec(const IntListNode *ls);
bool listContainsIter(const IntListNode *ls, int value);
bool listContainsRec(const IntListNode *ls, int value);
void insertHead(IntList *lsPtr, int value);
void insertTailVerbose(IntList *lsPtr, int value);
void insertTailPP(IntList *lsPtr, int value);
Outcome insertSortedVerbose(IntList *lsPtr, int value);
Outcome insertSortedPP(IntList *lsPtr, int value);
Outcome insertSortedRec(IntList *lsPtr, int value);
Outcome deleteFirstVerbose(IntList *lsPtr, int value);
Outcome deleteFirstPP(IntList *lsPtr, int value);
size_t deleteAllVerbose(IntList *lsPtr, int value);
size_t deleteAllPP(IntList *lsPtr, int value);
size_t deleteAllRec(IntList *lsPtr, int value);
void reverseListIter(IntList *lsPtr);
IntList reverseListRec(IntList ls);
bool cloneListIter(const IntListNode *src, IntList *dstPtr);
bool cloneListRec(const IntListNode *src, IntList *dstPtr);
void concatLists(IntList *aPtr, IntList b);
IntList mergeSortedRelink(IntList a, IntList b);
void rotateLeft(IntList *lsPtr, size_t k);
void splitAt(IntList *lsPtr, size_t k, IntList *secondPtr);
void destroyListIter(IntList *lsPtr);
void destroyListRec(IntList *lsPtr);

/* Pila */
IntStackADT mkStack(void);
bool stackIsEmpty(IntStackADT s);
size_t stackSize(IntStackADT s);
Outcome push(IntStackADT s, int value);
Outcome pop(IntStackADT s, int *valuePtr);
Outcome peek(IntStackADT s, int *valuePtr);
void dsStack(IntStackADT *sPtr);

/* Coda */
IntQueueADT mkQueue(void);
bool queueIsEmpty(IntQueueADT q);
size_t queueSize(IntQueueADT q);
Outcome enqueue(IntQueueADT q, int value);
Outcome dequeue(IntQueueADT q, int *valuePtr);
Outcome queueFront(IntQueueADT q, int *valuePtr);
void dsQueue(IntQueueADT *qPtr);

/* Deque */
IntDequeADT mkDeque(void);
Outcome pushFront(IntDequeADT d, int value);
Outcome pushBack(IntDequeADT d, int value);
Outcome popFront(IntDequeADT d, int *valuePtr);
Outcome popBack(IntDequeADT d, int *valuePtr);
void dsDeque(IntDequeADT *dPtr);

/* Insiemi */
IntSetADT mkSet(void);
bool setContainsIter(const struct IntSet *s, int value);
bool setContainsRec(const IntListNode *ls, int value);
Outcome setAdd(IntSetADT s, int value);
Outcome setRemove(IntSetADT s, int value);
bool setSubset(const struct IntSet *a, const struct IntSet *b);
bool setEqual(const struct IntSet *a, const struct IntSet *b);
IntSetADT setUnion(const struct IntSet *a, const struct IntSet *b);
IntSetADT setIntersection(const struct IntSet *a, const struct IntSet *b);
IntSetADT setDifference(const struct IntSet *a, const struct IntSet *b);
void dsSet(IntSetADT *sPtr);

/* Alberi binari */
IntTree makeTreeNode(int value);
size_t treeCountNodesRec(const IntTreeNode *tree);
size_t treeCountNodesIter(const IntTreeNode *tree);
size_t treeCountLeavesRec(const IntTreeNode *tree);
long treeSumRec(const IntTreeNode *tree);
long treeSumIter(const IntTreeNode *tree);
long sumDirectChildren(const IntTreeNode *node);
int treeHeightNodesRec(const IntTreeNode *tree);
int treeHeightNodesIter(const IntTreeNode *tree);
bool treeContainsRec(const IntTreeNode *tree, int value);
bool treeContainsIter(const IntTreeNode *tree, int value);
void preOrderRec(const IntTreeNode *tree, void (*visit)(int));
void inOrderRec(const IntTreeNode *tree, void (*visit)(int));
void postOrderRec(const IntTreeNode *tree, void (*visit)(int));
void depthFirstIter(const IntTreeNode *tree, void (*visit)(int));
void breadthFirstIter(const IntTreeNode *tree, void (*visit)(int));
bool cloneTreeRec(const IntTreeNode *src, IntTree *dstPtr);
void mirrorTreeRec(IntTree tree);
bool equalTreesRec(const IntTreeNode *a, const IntTreeNode *b);
void destroyTreeRec(IntTree *treePtr);
void destroyTreeIter(IntTree *treePtr);

/* BST */
bool searchBSTiter(const IntTreeNode *tree, int value);
bool searchBSTrec(const IntTreeNode *tree, int value);
Outcome findMinBSTiter(const IntTreeNode *tree, int *valuePtr);
Outcome findMaxBSTiter(const IntTreeNode *tree, int *valuePtr);
Outcome insertBSTverbose(IntTree *treePtr, int value);
Outcome insertBSTpp(IntTree *treePtr, int value);
Outcome insertBSTrec(IntTree *treePtr, int value);
Outcome extractMinBSTpp(IntTree *treePtr, int *valuePtr);
Outcome deleteBSTpp(IntTree *treePtr, int value);
IntTree deleteBSTrec(IntTree tree, int value, bool *removedPtr);
bool isBST(const IntTreeNode *tree);
long sumBSTRange(const IntTreeNode *tree, int low, int high);

/* Alberi n-ari */
NTree makeNTreeNode(int value);
Outcome addFirstChild(NTree parent, int value);
Outcome addLastChild(NTree parent, int value);
size_t nTreeCountRec(const NTreeNode *tree);
size_t nTreeCountIter(const NTreeNode *tree);
long nTreeSumRec(const NTreeNode *tree);
int nTreeHeightRec(const NTreeNode *tree);
void nTreeDepthFirstRec(const NTreeNode *tree, void (*visit)(int));
void nTreeBreadthFirstIter(const NTreeNode *tree, void (*visit)(int));
void destroyNTreeRec(NTree *treePtr);

/* void* e callback */
GenericListADT mkGenericList(CompareFn compare, CopyFn copy, DestroyFn destroy);
Outcome genericInsertHead(GenericListADT ls, const void *value);
Outcome genericInsertSorted(GenericListADT ls, const void *value);
void *genericFind(const struct GenericList *ls, const void *key);
Outcome genericRemove(GenericListADT ls, const void *key);
size_t genericCountIf(const struct GenericList *ls, PredicateFn predicate);
void dsGenericList(GenericListADT *lsPtr);

/* File */
bool copyFileBinary(const char *srcPath, const char *dstPath);
bool appendText(const char *path, const char *text);
size_t countLines(const char *path);
bool sumIntsFromFile(const char *path, long *sumPtr);
bool loadInts(const char *path, int **aPtr, size_t *nPtr);
bool saveIntsBinary(const char *path, const int a[], size_t n);
bool loadIntsBinary(const char *path, int **aPtr, size_t *nPtr);
```

# 1. Puntatori, `struct`, memoria dinamica

## Accesso e modifica

- Per ottenere l'indirizzo di `x`: `&x`.
- Per leggere o modificare l'oggetto puntato da `p`: `*p`.
- Per accedere a un campo di una `struct` variabile `s`: `s.field`.
- Per accedere a un campo tramite puntatore `p`: `p->field`.
- Per ottenere l'indirizzo del campo `next`: `&node->next`.
- Per ottenere l'indirizzo del campo `next` del nodo puntato da `link`: `&(*link)->next`.
- Per modificare il puntatore del chiamante: passa `T **ptr` e assegna `*ptr = nuovoValore`.
- Per modificare solo l'oggetto puntato: passa `T *ptr` e modifica `*ptr` o `ptr->field`.
- Per impedire la modifica del dato puntato: `const T *p`.
- Per impedire la modifica del puntatore: `T *const p`.
- Per impedire entrambe: `const T *const p`.
- Con `typedef T *AliasPtr`, `const AliasPtr p` rende costante il puntatore alias, non il dato puntato.
- Con `typedef T *AliasPtr`, per dati read-only usa `const T *p`.

## Allocazione

- Per allocare un oggetto `T`: `T *p = malloc(sizeof *p);`.
- Per allocare `n` oggetti `T`: `T *a = malloc(n * sizeof *a);`.
- Per allocare e azzerare `n` oggetti `T`: `T *a = calloc(n, sizeof *a);`.
- Per controllare l'allocazione: `if (p == NULL) { ... }`.
- Per liberare: `free(p);`.
- Per eliminare il dangling pointer locale: `free(p); p = NULL;`.
- Per eliminare il dangling pointer del chiamante: `free(*pPtr); *pPtr = NULL;`.

## `realloc`

- Per ridimensionare senza perdere il vecchio blocco:

```c
T *tmp = realloc(p, newCount * sizeof *p);
if (tmp == NULL) {
    /* p è ancora valido */
} else {
    p = tmp;
}
```

- Per aggiungere un elemento a un array dinamico:

```c
if (*nPtr == *capPtr) {
    size_t newCap = (*capPtr == 0) ? 1 : 2 * (*capPtr);
    int *tmp = realloc(*aPtr, newCap * sizeof **aPtr);
    if (tmp == NULL) return false;
    *aPtr = tmp;
    *capPtr = newCap;
}
(*aPtr)[(*nPtr)++] = value;
```

## Matrice dinamica

- Per allocare una matrice contigua `rows x cols`:

```c
int *data = malloc(rows * cols * sizeof *data);
/* elemento [i][j] */
data[i * cols + j]
```

- Per allocare una matrice come array di righe:

```c
int **m = malloc(rows * sizeof *m);
for (size_t i = 0; i < rows; i++)
    m[i] = malloc(cols * sizeof *m[i]);
```

- Per liberare una matrice a righe:

```c
for (size_t i = 0; i < rows; i++) free(m[i]);
free(m);
```

## `struct`, `enum`, `union`

- Per dichiarare un tipo struttura:

```c
typedef struct Point {
    double x;
    double y;
} Point;
```

- Per dichiarare un tipo puntatore alla struttura:

```c
typedef struct Point Point, *PointPtr;
```

- Per rappresentare casi nominati: `enum Stato { VUOTO, PIENO, ERRORE };`.
- Per rappresentare dati alternativi: usa `union`.
- Per sapere quale campo della `union` è valido: affianca un `enum tag`.

# 2. Array e stringhe

## Array — iterativo

- Per attraversare tutto l'array:

```c
for (size_t i = 0; i < n; i++) {
    /* usa a[i] */
}
```

- Per sommare:

```c
long sum = 0;
for (size_t i = 0; i < n; i++) sum += a[i];
```

- Per cercare la prima occorrenza:

```c
for (size_t i = 0; i < n; i++)
    if (a[i] == value) return (ptrdiff_t)i;
return -1;
```

- Per cercare l'ultima occorrenza:

```c
for (size_t i = n; i > 0; i--)
    if (a[i - 1] == value) return (ptrdiff_t)(i - 1);
return -1;
```

- Per trovare il massimo:

```c
assert(n > 0);
int max = a[0];
for (size_t i = 1; i < n; i++)
    if (a[i] > max) max = a[i];
```

- Per invertire:

```c
for (size_t i = 0, j = n; i < j && i < --j; i++) {
    int tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}
```

- Per ruotare a sinistra di `k`: `k %= n`, inverti `[0,k)`, inverti `[k,n)`, inverti `[0,n)`.
- Per rimuovere in-place gli elementi che soddisfano una condizione: usa un indice `write`.

```c
size_t write = 0;
for (size_t read = 0; read < n; read++)
    if (!removeCondition(a[read])) a[write++] = a[read];
n = write;
```

- Per eliminare duplicati da un array ordinato: conserva `a[0]`, copia `a[read]` solo se diverso da `a[write - 1]`.
- Per fondere due array ordinati: confronta `a[i]` e `b[j]`, copia il minore, poi copia la coda residua.

## Array — ricorsivo

- Per sommare i primi `n` elementi:

```c
return n == 0 ? 0 : a[n - 1] + sumArrayRec(a, n - 1);
```

- Per cercare:

```c
if (n == 0) return -1;
if (a[0] == value) return 0;
ptrdiff_t pos = linearSearchRec(a + 1, n - 1, value);
return pos < 0 ? -1 : pos + 1;
```

- Per invertire:

```c
if (left >= right) return;
swap(&a[left], &a[right]);
reverseArrayRec(a, left + 1, right - 1);
```

- Per ricerca binaria:

```c
if (left > right) return -1;
ptrdiff_t mid = left + (right - left) / 2;
if (a[mid] == value) return mid;
if (value < a[mid]) return binarySearchRec(a, left, mid - 1, value);
return binarySearchRec(a, mid + 1, right, value);
```

## Stringhe

- Per ottenere la lunghezza: `strlen(s)`.
- Per copiare in un buffer già capiente: `strcpy(dst, src)`.
- Per concatenare in un buffer già capiente: `strcat(dst, src)`.
- Per confrontare: `strcmp(a, b)`.
- Per confrontare i primi `n` caratteri: `strncmp(a, b, n)`.
- Per cercare un carattere: `strchr(s, c)`.
- Per cercare una sottostringa: `strstr(s, needle)`.
- Per clonare una stringa:

```c
char *copy = malloc(strlen(s) + 1);
if (copy != NULL) strcpy(copy, s);
```

- Per concatenare due stringhe in un nuovo blocco:

```c
size_t na = strlen(a), nb = strlen(b);
char *out = malloc(na + nb + 1);
if (out != NULL) {
    memcpy(out, a, na);
    memcpy(out + na, b, nb + 1);
}
```

- Per leggere una riga in un buffer fisso:

```c
if (fgets(buffer, sizeof buffer, stdin) != NULL)
    buffer[strcspn(buffer, "\n")] = '\0';
```

## Stringa dinamica

- Per creare:

```c
DynStringPtr s = malloc(sizeof *s);
s->capacity = initialCapacity > 0 ? initialCapacity : 1;
s->content = malloc(s->capacity);
s->length = 0;
s->content[0] = '\0';
```

- Per aggiungere una stringa:

```c
size_t add = strlen(suffix);
size_t needed = s->length + add + 1;
if (needed > s->capacity) {
    size_t newCap = s->capacity;
    while (newCap < needed) newCap *= 2;
    char *tmp = realloc(s->content, newCap);
    if (tmp == NULL) return false;
    s->content = tmp;
    s->capacity = newCap;
}
memcpy(s->content + s->length, suffix, add + 1);
s->length += add;
```

- Per azzerare: `s->length = 0; s->content[0] = '\0';`.
- Per distruggere: `free((*sPtr)->content); free(*sPtr); *sPtr = NULL;`.

# 3. Liste linkate semplici

## Nodo

- Per creare un nodo:

```c
IntList node = malloc(sizeof *node);
if (node == NULL) return NULL;
node->data = value;
node->next = NULL;
```

## Visita senza modifica — iterativo

- Per attraversare:

```c
for (IntList current = ls; current != NULL; current = current->next) {
    /* usa current->data */
}
```

- Per calcolare la lunghezza: inizializza `count = 0`, incrementa una volta per nodo.
- Per sommare: inizializza `sum = 0`, aggiungi `current->data`.
- Per cercare: avanza finché `current != NULL && current->data != value`.
- Per contare occorrenze: incrementa solo se `current->data == value`.
- Per trovare il minimo: richiedi lista non vuota, inizializza con `ls->data`, visita da `ls->next`.
- Per ottenere il nodo in posizione `index`: avanza `index` volte; se arrivi a `NULL`, restituisci `NULL`.
- Per trovare l'ultimo nodo: avanza finché `current->next != NULL`.

## Visita senza modifica — ricorsivo

- Per calcolare la lunghezza:

```c
return ls == NULL ? 0 : 1 + listLengthRec(ls->next);
```

- Per sommare:

```c
return ls == NULL ? 0 : ls->data + listSumRec(ls->next);
```

- Per cercare:

```c
return ls != NULL && (ls->data == value || listContainsRec(ls->next, value));
```

- Per contare occorrenze:

```c
return ls == NULL ? 0 : (ls->data == value) + countRec(ls->next, value);
```

- Per stampare in ordine: usa il nodo, poi richiama su `ls->next`.
- Per stampare al contrario: richiama su `ls->next`, poi usa il nodo.

## Inserimento in testa

- Per inserire in testa:

```c
newNode->next = *lsPtr;
*lsPtr = newNode;
```

- Per inserire in testa restituendo la nuova testa:

```c
newNode->next = ls;
return newNode;
```

## Inserimento in coda — verboso

```c
IntList newNode = makeNode(value);
if (newNode == NULL) return OUT_OF_MEMORY;

if (*lsPtr == NULL) {
    *lsPtr = newNode;
} else {
    IntList current = *lsPtr;
    while (current->next != NULL) current = current->next;
    current->next = newNode;
}
```

## Inserimento in coda — puntatore a puntatore

```c
IntList *link = lsPtr;
while (*link != NULL) link = &(*link)->next;
*link = newNode;
```

## Inserimento in posizione — verboso

- Per inserire in posizione `index`:

```c
if (index == 0) {
    newNode->next = *lsPtr;
    *lsPtr = newNode;
} else {
    IntList prev = *lsPtr;
    for (size_t i = 1; i < index && prev != NULL; i++)
        prev = prev->next;
    if (prev == NULL) return NOT_FOUND;
    newNode->next = prev->next;
    prev->next = newNode;
}
```

## Inserimento in posizione — puntatore a puntatore

```c
IntList *link = lsPtr;
size_t i = 0;
while (i < index && *link != NULL) {
    link = &(*link)->next;
    i++;
}
if (i < index) return NOT_FOUND;
newNode->next = *link;
*link = newNode;
```

## Inserimento ordinato — verboso

```c
IntList prev = NULL;
IntList current = *lsPtr;

while (current != NULL && current->data < value) {
    prev = current;
    current = current->next;
}

newNode->next = current;
if (prev == NULL) *lsPtr = newNode;
else prev->next = newNode;
```

## Inserimento ordinato — puntatore a puntatore

```c
IntList *link = lsPtr;
while (*link != NULL && (*link)->data < value)
    link = &(*link)->next;

newNode->next = *link;
*link = newNode;
```

## Inserimento ordinato — ricorsivo

```c
if (*lsPtr == NULL || (*lsPtr)->data >= value) {
    newNode->next = *lsPtr;
    *lsPtr = newNode;
    return INSERTED;
}
return insertSortedRec(&(*lsPtr)->next, value);
```

## Eliminazione della testa

```c
if (*lsPtr == NULL) return EMPTY;
IntList tmp = *lsPtr;
*lsPtr = tmp->next;
free(tmp);
```

## Eliminazione della prima occorrenza — verboso

```c
IntList prev = NULL;
IntList current = *lsPtr;

while (current != NULL && current->data != value) {
    prev = current;
    current = current->next;
}

if (current == NULL) return NOT_FOUND;
if (prev == NULL) *lsPtr = current->next;
else prev->next = current->next;
free(current);
```

## Eliminazione della prima occorrenza — puntatore a puntatore

```c
IntList *link = lsPtr;
while (*link != NULL && (*link)->data != value)
    link = &(*link)->next;

if (*link == NULL) return NOT_FOUND;
IntList tmp = *link;
*link = tmp->next;
free(tmp);
```

## Eliminazione di tutte le occorrenze — verboso

```c
IntList prev = NULL;
IntList current = *lsPtr;

while (current != NULL) {
    if (current->data == value) {
        IntList tmp = current;
        current = current->next;
        if (prev == NULL) *lsPtr = current;
        else prev->next = current;
        free(tmp);
        removed++;
    } else {
        prev = current;
        current = current->next;
    }
}
```

## Eliminazione di tutte le occorrenze — puntatore a puntatore

```c
IntList *link = lsPtr;

while (*link != NULL) {
    if ((*link)->data == value) {
        IntList tmp = *link;
        *link = tmp->next;
        free(tmp);
        removed++;
    } else {
        link = &(*link)->next;
    }
}
```

## Eliminazione di tutte le occorrenze — ricorsivo

```c
if (*lsPtr == NULL) return 0;

if ((*lsPtr)->data == value) {
    IntList tmp = *lsPtr;
    *lsPtr = tmp->next;
    free(tmp);
    return 1 + deleteAllRec(lsPtr, value);
}

return deleteAllRec(&(*lsPtr)->next, value);
```

## Eliminazione dell'ultimo nodo — verboso

```c
if (*lsPtr == NULL) return EMPTY;

IntList prev = NULL;
IntList current = *lsPtr;
while (current->next != NULL) {
    prev = current;
    current = current->next;
}

if (prev == NULL) *lsPtr = NULL;
else prev->next = NULL;
free(current);
```

## Eliminazione dell'ultimo nodo — puntatore a puntatore

```c
if (*lsPtr == NULL) return EMPTY;
IntList *link = lsPtr;
while ((*link)->next != NULL) link = &(*link)->next;
IntList tmp = *link;
*link = NULL;
free(tmp);
```

## Inversione — iterativo

```c
IntList prev = NULL;
IntList current = *lsPtr;

while (current != NULL) {
    IntList next = current->next;
    current->next = prev;
    prev = current;
    current = next;
}

*lsPtr = prev;
```

## Inversione — ricorsivo

```c
if (ls == NULL || ls->next == NULL) return ls;
IntList newHead = reverseListRec(ls->next);
ls->next->next = ls;
ls->next = NULL;
return newHead;
```

## Clonazione — iterativo con puntatore alla coda

```c
*dstPtr = NULL;
IntList *tail = dstPtr;

for (IntList current = src; current != NULL; current = current->next) {
    IntList node = makeNode(current->data);
    if (node == NULL) {
        destroyListIter(dstPtr);
        return false;
    }
    *tail = node;
    tail = &node->next;
}
```

## Clonazione — ricorsivo

```c
if (src == NULL) {
    *dstPtr = NULL;
    return true;
}

IntList node = makeNode(src->data);
if (node == NULL) return false;
*dstPtr = node;

if (!cloneListRec(src->next, &node->next)) {
    destroyListRec(dstPtr);
    return false;
}
return true;
```

## Concatenazione senza allocare

- Per appendere `b` ad `a`:

```c
IntList *link = aPtr;
while (*link != NULL) link = &(*link)->next;
*link = b;
```

## Merge ordinato senza allocare — puntatore a puntatore

```c
IntList out = NULL;
IntList *tail = &out;

while (a != NULL && b != NULL) {
    IntList *source = (a->data <= b->data) ? &a : &b;
    *tail = *source;
    *source = (*source)->next;
    tail = &(*tail)->next;
}

*tail = (a != NULL) ? a : b;
return out;
```

## Split in posizione `k`

```c
IntList *link = lsPtr;
for (size_t i = 0; i < k && *link != NULL; i++)
    link = &(*link)->next;

*secondPtr = *link;
*link = NULL;
```

## Rotazione a sinistra di `k`

```c
if (*lsPtr == NULL || (*lsPtr)->next == NULL || k == 0) return;

size_t n = listLengthIter(*lsPtr);
k %= n;
if (k == 0) return;

IntList cut = *lsPtr;
for (size_t i = 1; i < k; i++) cut = cut->next;

IntList newHead = cut->next;
cut->next = NULL;

IntList tail = newHead;
while (tail->next != NULL) tail = tail->next;
tail->next = *lsPtr;
*lsPtr = newHead;
```

## Rimozione duplicati da lista ordinata

```c
IntList current = *lsPtr;
while (current != NULL && current->next != NULL) {
    if (current->data == current->next->data) {
        IntList tmp = current->next;
        current->next = tmp->next;
        free(tmp);
    } else {
        current = current->next;
    }
}
```

## Distruzione — iterativo

```c
while (*lsPtr != NULL) {
    IntList tmp = *lsPtr;
    *lsPtr = tmp->next;
    free(tmp);
}
```

## Distruzione — ricorsivo

```c
if (*lsPtr == NULL) return;
IntList tmp = *lsPtr;
*lsPtr = tmp->next;
free(tmp);
destroyListRec(lsPtr);
```

## Scambio di due nodi adiacenti tramite link

```c
IntList first = *link;
IntList second = first->next;
first->next = second->next;
second->next = first;
*link = second;
```

## Bubble pass senza `prev`

```c
for (IntList *link = lsPtr; *link != NULL && (*link)->next != NULL; ) {
    if ((*link)->data > (*link)->next->data) {
        IntList first = *link;
        IntList second = first->next;
        first->next = second->next;
        second->next = first;
        *link = second;
        link = &first->next;
    } else {
        link = &(*link)->next;
    }
}
```

# 4. Liste doppiamente linkate

## Inserimento prima di `current`

```c
newNode->next = current;
newNode->prev = current->prev;

if (current->prev != NULL) current->prev->next = newNode;
else *headPtr = newNode;

current->prev = newNode;
```

## Inserimento dopo `current`

```c
newNode->prev = current;
newNode->next = current->next;

if (current->next != NULL) current->next->prev = newNode;
else *tailPtr = newNode;

current->next = newNode;
```

## Rimozione di `current`

```c
if (current->prev != NULL) current->prev->next = current->next;
else *headPtr = current->next;

if (current->next != NULL) current->next->prev = current->prev;
else *tailPtr = current->prev;

free(current);
```

## Inversione

```c
DList current = *headPtr;
while (current != NULL) {
    DList tmp = current->next;
    current->next = current->prev;
    current->prev = tmp;
    current = tmp;
}

DList tmp = *headPtr;
*headPtr = *tailPtr;
*tailPtr = tmp;
```

# 5. Pila — LIFO

## Creazione

```c
IntStackADT s = malloc(sizeof *s);
if (s == NULL) return NULL;
s->top = NULL;
s->size = 0;
```

## Push

```c
StackNode *node = malloc(sizeof *node);
if (node == NULL) return OUT_OF_MEMORY;
node->data = value;
node->next = s->top;
s->top = node;
s->size++;
```

## Pop

```c
if (s == NULL || s->top == NULL) return EMPTY;
StackNode *tmp = s->top;
*valuePtr = tmp->data;
s->top = tmp->next;
free(tmp);
s->size--;
```

## Peek

```c
if (s == NULL || s->top == NULL) return EMPTY;
*valuePtr = s->top->data;
```

## Distruzione

```c
if (sPtr == NULL || *sPtr == NULL) return;
while ((*sPtr)->top != NULL) {
    StackNode *tmp = (*sPtr)->top;
    (*sPtr)->top = tmp->next;
    free(tmp);
}
free(*sPtr);
*sPtr = NULL;
```

## Invertire una pila con ricorsione

- Per inserire un valore sul fondo:

```c
if (stackIsEmpty(s)) {
    push(s, value);
    return;
}
int top;
pop(s, &top);
insertAtBottomRec(s, value);
push(s, top);
```

- Per invertire:

```c
if (stackIsEmpty(s)) return;
int top;
pop(s, &top);
reverseStackRec(s);
insertAtBottomRec(s, top);
```

## Uso come stack esplicito

- Per DFS iterativa: `push(root)`, poi `pop`; inserisci prima il destro e poi il sinistro.
- Per validare parentesi: `push` sugli aperti; su chiuso fai `pop` e confronta.
- Per valutare una postfix: `push` operandi; su operatore fai due `pop`, calcola, `push` risultato.

# 6. Coda — FIFO

## Creazione

```c
IntQueueADT q = malloc(sizeof *q);
if (q == NULL) return NULL;
q->front = NULL;
q->rear = NULL;
q->size = 0;
```

## Enqueue

```c
QueueNode *node = malloc(sizeof *node);
if (node == NULL) return OUT_OF_MEMORY;
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
```

## Dequeue

```c
if (q == NULL || q->front == NULL) return EMPTY;
QueueNode *tmp = q->front;
*valuePtr = tmp->data;
q->front = tmp->next;
if (q->front == NULL) q->rear = NULL;
free(tmp);
q->size--;
```

## Front

```c
if (q == NULL || q->front == NULL) return EMPTY;
*valuePtr = q->front->data;
```

## Distruzione

```c
if (qPtr == NULL || *qPtr == NULL) return;
while ((*qPtr)->front != NULL) {
    QueueNode *tmp = (*qPtr)->front;
    (*qPtr)->front = tmp->next;
    free(tmp);
}
free(*qPtr);
*qPtr = NULL;
```

## Coda circolare su array

```c
typedef struct {
    int *data;
    size_t capacity;
    size_t front;
    size_t size;
} ArrayQueue;
```

- Per calcolare la posizione logica `i`: `(q->front + i) % q->capacity`.
- Per enqueue: scrivi in `(front + size) % capacity`, poi `size++`.
- Per dequeue: leggi `data[front]`, poi `front = (front + 1) % capacity`, `size--`.
- Per verificare vuota: `size == 0`.
- Per verificare piena: `size == capacity`.

# 7. Deque

## Push front

```c
DListNode *node = malloc(sizeof *node);
node->data = value;
node->prev = NULL;
node->next = d->front;

if (d->front != NULL) d->front->prev = node;
else d->rear = node;

d->front = node;
d->size++;
```

## Push back

```c
DListNode *node = malloc(sizeof *node);
node->data = value;
node->next = NULL;
node->prev = d->rear;

if (d->rear != NULL) d->rear->next = node;
else d->front = node;

d->rear = node;
d->size++;
```

## Pop front

```c
if (d->front == NULL) return EMPTY;
DListNode *tmp = d->front;
*valuePtr = tmp->data;
d->front = tmp->next;
if (d->front != NULL) d->front->prev = NULL;
else d->rear = NULL;
free(tmp);
d->size--;
```

## Pop back

```c
if (d->rear == NULL) return EMPTY;
DListNode *tmp = d->rear;
*valuePtr = tmp->data;
d->rear = tmp->prev;
if (d->rear != NULL) d->rear->next = NULL;
else d->front = NULL;
free(tmp);
d->size--;
```

# 8. Insiemi con lista ordinata

## Appartenenza — iterativo

```c
IntList current = s->first;
while (current != NULL && current->data < value)
    current = current->next;
return current != NULL && current->data == value;
```

## Appartenenza — ricorsivo

```c
if (ls == NULL || ls->data > value) return false;
if (ls->data == value) return true;
return setContainsRec(ls->next, value);
```

## Inserimento senza duplicati — puntatore a puntatore

```c
IntList *link = &s->first;
while (*link != NULL && (*link)->data < value)
    link = &(*link)->next;

if (*link != NULL && (*link)->data == value)
    return ALREADY_PRESENT;

IntList node = makeNode(value);
if (node == NULL) return OUT_OF_MEMORY;
node->next = *link;
*link = node;
s->size++;
```

## Rimozione — puntatore a puntatore

```c
IntList *link = &s->first;
while (*link != NULL && (*link)->data < value)
    link = &(*link)->next;

if (*link == NULL || (*link)->data != value)
    return NOT_FOUND;

IntList tmp = *link;
*link = tmp->next;
free(tmp);
s->size--;
```

## Sottoinsieme — iterativo ordinato

```c
IntList pa = a->first;
IntList pb = b->first;

while (pa != NULL && pb != NULL) {
    if (pa->data == pb->data) {
        pa = pa->next;
        pb = pb->next;
    } else if (pa->data > pb->data) {
        pb = pb->next;
    } else {
        return false;
    }
}
return pa == NULL;
```

## Uguaglianza

- Per confrontare: verifica `size` uguale, poi confronta i nodi in parallelo.

## Unione ordinata — iterativo

```c
while (pa != NULL && pb != NULL) {
    if (pa->data < pb->data) {
        setAdd(out, pa->data);
        pa = pa->next;
    } else if (pa->data > pb->data) {
        setAdd(out, pb->data);
        pb = pb->next;
    } else {
        setAdd(out, pa->data);
        pa = pa->next;
        pb = pb->next;
    }
}
while (pa != NULL) { setAdd(out, pa->data); pa = pa->next; }
while (pb != NULL) { setAdd(out, pb->data); pb = pb->next; }
```

## Intersezione ordinata — iterativo

```c
while (pa != NULL && pb != NULL) {
    if (pa->data < pb->data) pa = pa->next;
    else if (pa->data > pb->data) pb = pb->next;
    else {
        setAdd(out, pa->data);
        pa = pa->next;
        pb = pb->next;
    }
}
```

## Differenza `A \ B` ordinata — iterativo

```c
while (pa != NULL && pb != NULL) {
    if (pa->data < pb->data) {
        setAdd(out, pa->data);
        pa = pa->next;
    } else if (pa->data > pb->data) {
        pb = pb->next;
    } else {
        pa = pa->next;
        pb = pb->next;
    }
}
while (pa != NULL) { setAdd(out, pa->data); pa = pa->next; }
```

## Intersezione — ricorsivo

```c
if (a == NULL || b == NULL) return true;
if (a->data < b->data) return intersectionRec(a->next, b, tailPtr);
if (a->data > b->data) return intersectionRec(a, b->next, tailPtr);

IntList node = makeNode(a->data);
if (node == NULL) return false;
*tailPtr = node;
return intersectionRec(a->next, b->next, &node->next);
```

# 9. Alberi binari generici

## Nodo

```c
IntTree node = malloc(sizeof *node);
if (node == NULL) return NULL;
node->data = value;
node->left = NULL;
node->right = NULL;
```

## Visite — ricorsivo

- Per pre-order: nodo, sinistro, destro.

```c
if (tree == NULL) return;
visit(tree->data);
preOrderRec(tree->left, visit);
preOrderRec(tree->right, visit);
```

- Per in-order: sinistro, nodo, destro.

```c
if (tree == NULL) return;
inOrderRec(tree->left, visit);
visit(tree->data);
inOrderRec(tree->right, visit);
```

- Per post-order: sinistro, destro, nodo.

```c
if (tree == NULL) return;
postOrderRec(tree->left, visit);
postOrderRec(tree->right, visit);
visit(tree->data);
```

## Conteggi e aggregazioni — ricorsivo

- Per contare i nodi:

```c
return tree == NULL
    ? 0
    : 1 + treeCountNodesRec(tree->left)
        + treeCountNodesRec(tree->right);
```

- Per sommare i nodi:

```c
return tree == NULL
    ? 0
    : tree->data + treeSumRec(tree->left) + treeSumRec(tree->right);
```

- Per sommare i figli diretti di un nodo:

```c
return node == NULL
    ? 0
    : (node->left  == NULL ? 0 : node->left->data)
    + (node->right == NULL ? 0 : node->right->data);
```

- Per contare le foglie:

```c
if (tree == NULL) return 0;
if (tree->left == NULL && tree->right == NULL) return 1;
return countLeaves(tree->left) + countLeaves(tree->right);
```

- Per contare i nodi interni:

```c
if (tree == NULL || (tree->left == NULL && tree->right == NULL)) return 0;
return 1 + countInternal(tree->left) + countInternal(tree->right);
```

- Per contare nodi con due figli:

```c
return tree == NULL
    ? 0
    : (tree->left != NULL && tree->right != NULL)
      + countTwoChildren(tree->left)
      + countTwoChildren(tree->right);
```

- Per contare nodi con un solo figlio:

```c
bool exactlyOne = (tree->left == NULL) != (tree->right == NULL);
return exactlyOne + countOneChild(tree->left) + countOneChild(tree->right);
```

- Per calcolare l'altezza in numero di nodi:

```c
if (tree == NULL) return 0;
int hl = treeHeightNodesRec(tree->left);
int hr = treeHeightNodesRec(tree->right);
return 1 + (hl > hr ? hl : hr);
```

- Per calcolare l'altezza in numero di archi: restituisci `-1` sull'albero vuoto.
- Per cercare in un albero non ordinato:

```c
return tree != NULL &&
       (tree->data == value ||
        treeContainsRec(tree->left, value) ||
        treeContainsRec(tree->right, value));
```

- Per trovare il massimo:

```c
if (tree == NULL) return INT_MIN;
int leftMax = treeMax(tree->left);
int rightMax = treeMax(tree->right);
return max3(tree->data, leftMax, rightMax);
```

- Per contare i nodi al livello `k`:

```c
if (tree == NULL) return 0;
if (k == 0) return 1;
return countAtLevel(tree->left, k - 1)
     + countAtLevel(tree->right, k - 1);
```

- Per sommare i nodi al livello `k`:

```c
if (tree == NULL) return 0;
if (k == 0) return tree->data;
return sumAtLevel(tree->left, k - 1)
     + sumAtLevel(tree->right, k - 1);
```

- Per verificare che ogni nodo sia uguale alla somma dei figli diretti:

```c
if (tree == NULL || (tree->left == NULL && tree->right == NULL)) return true;
return tree->data == sumDirectChildren(tree)
    && childrenSumProperty(tree->left)
    && childrenSumProperty(tree->right);
```

- Per verificare l'esistenza di un cammino radice-foglia con somma `target`:

```c
if (tree == NULL) return false;
if (tree->left == NULL && tree->right == NULL)
    return tree->data == target;
return hasPathSum(tree->left, target - tree->data)
    || hasPathSum(tree->right, target - tree->data);
```

## DFS — iterativo

```c
if (tree == NULL) return;
TreeStackADT stack = mkTreeStack();
pushTree(stack, tree);

while (!treeStackEmpty(stack)) {
    IntTree node = popTree(stack);
    visit(node->data);
    if (node->right != NULL) pushTree(stack, node->right);
    if (node->left != NULL) pushTree(stack, node->left);
}
```

## BFS — iterativo

```c
if (tree == NULL) return;
TreeQueueADT q = mkTreeQueue();
enqueueTree(q, tree);

while (!treeQueueEmpty(q)) {
    IntTree node = dequeueTree(q);
    visit(node->data);
    if (node->left != NULL) enqueueTree(q, node->left);
    if (node->right != NULL) enqueueTree(q, node->right);
}
```

## Conteggio e somma — iterativo BFS

```c
size_t count = 0;
long sum = 0;

enqueueTree(q, tree);
while (!treeQueueEmpty(q)) {
    IntTree node = dequeueTree(q);
    count++;
    sum += node->data;
    if (node->left != NULL) enqueueTree(q, node->left);
    if (node->right != NULL) enqueueTree(q, node->right);
}
```

## Altezza — iterativo BFS

```c
int height = 0;
enqueueTree(q, tree);

while (!treeQueueEmpty(q)) {
    size_t levelSize = treeQueueSize(q);
    height++;
    while (levelSize-- > 0) {
        IntTree node = dequeueTree(q);
        if (node->left != NULL) enqueueTree(q, node->left);
        if (node->right != NULL) enqueueTree(q, node->right);
    }
}
```

## Clonazione — ricorsivo

```c
if (src == NULL) {
    *dstPtr = NULL;
    return true;
}

IntTree node = makeTreeNode(src->data);
if (node == NULL) return false;
*dstPtr = node;

if (!cloneTreeRec(src->left, &node->left) ||
    !cloneTreeRec(src->right, &node->right)) {
    destroyTreeRec(dstPtr);
    return false;
}
return true;
```

## Uguaglianza — ricorsivo

```c
if (a == NULL || b == NULL) return a == b;
return a->data == b->data
    && equalTreesRec(a->left, b->left)
    && equalTreesRec(a->right, b->right);
```

## Mirror — ricorsivo

```c
if (tree == NULL) return;
IntTree tmp = tree->left;
tree->left = tree->right;
tree->right = tmp;
mirrorTreeRec(tree->left);
mirrorTreeRec(tree->right);
```

## Distruzione — ricorsivo post-order

```c
if (*treePtr == NULL) return;
destroyTreeRec(&(*treePtr)->left);
destroyTreeRec(&(*treePtr)->right);
free(*treePtr);
*treePtr = NULL;
```

## Distruzione — iterativo

- Per distruggere iterativamente: usa due pile oppure una pila con coppia `(nodo, visitato)`.
- Con due pile: sposta da `s1` a `s2`, inserisci i figli in `s1`, poi libera estraendo da `s2`.

# 10. Alberi di ricerca binari — BST

## Ricerca — iterativo

```c
IntTree current = tree;
while (current != NULL && current->data != value) {
    current = value < current->data
        ? current->left
        : current->right;
}
return current != NULL;
```

## Ricerca — ricorsivo

```c
if (tree == NULL) return false;
if (tree->data == value) return true;
if (value < tree->data) return searchBSTrec(tree->left, value);
return searchBSTrec(tree->right, value);
```

## Minimo e massimo — iterativo

- Per il minimo: avanza sempre a sinistra.
- Per il massimo: avanza sempre a destra.

```c
IntTree current = tree;
while (current->left != NULL) current = current->left;
return current->data;
```

## Minimo e massimo — ricorsivo

```c
if (tree->left == NULL) return tree->data;
return findMinBSTrec(tree->left);
```

## Inserimento — verboso

```c
IntTree parent = NULL;
IntTree current = *treePtr;

while (current != NULL) {
    parent = current;
    if (value < current->data) current = current->left;
    else if (value > current->data) current = current->right;
    else return ALREADY_PRESENT;
}

IntTree node = makeTreeNode(value);
if (node == NULL) return OUT_OF_MEMORY;

if (parent == NULL) *treePtr = node;
else if (value < parent->data) parent->left = node;
else parent->right = node;
```

## Inserimento — puntatore a puntatore

```c
IntTree *link = treePtr;

while (*link != NULL) {
    if (value < (*link)->data) link = &(*link)->left;
    else if (value > (*link)->data) link = &(*link)->right;
    else return ALREADY_PRESENT;
}

*link = makeTreeNode(value);
return *link == NULL ? OUT_OF_MEMORY : INSERTED;
```

## Inserimento — ricorsivo con puntatore a puntatore

```c
if (*treePtr == NULL) {
    *treePtr = makeTreeNode(value);
    return *treePtr == NULL ? OUT_OF_MEMORY : INSERTED;
}

if (value < (*treePtr)->data)
    return insertBSTrec(&(*treePtr)->left, value);
if (value > (*treePtr)->data)
    return insertBSTrec(&(*treePtr)->right, value);
return ALREADY_PRESENT;
```

## Inserimento — ricorsivo restituendo la radice

```c
if (tree == NULL) return makeTreeNode(value);
if (value < tree->data) tree->left = insertBSTreturn(tree->left, value);
else if (value > tree->data) tree->right = insertBSTreturn(tree->right, value);
return tree;
```

## Estrazione del minimo — puntatore a puntatore

```c
if (*treePtr == NULL) return EMPTY;

IntTree *link = treePtr;
while ((*link)->left != NULL)
    link = &(*link)->left;

IntTree tmp = *link;
*valuePtr = tmp->data;
*link = tmp->right;
free(tmp);
```

## Eliminazione — puntatore a puntatore

```c
IntTree *link = treePtr;

while (*link != NULL && (*link)->data != value) {
    link = value < (*link)->data
        ? &(*link)->left
        : &(*link)->right;
}

if (*link == NULL) return NOT_FOUND;
IntTree target = *link;

if (target->left == NULL) {
    *link = target->right;
    free(target);
} else if (target->right == NULL) {
    *link = target->left;
    free(target);
} else {
    IntTree *successorLink = &target->right;
    while ((*successorLink)->left != NULL)
        successorLink = &(*successorLink)->left;

    IntTree successor = *successorLink;
    target->data = successor->data;
    *successorLink = successor->right;
    free(successor);
}
```

## Eliminazione — ricorsivo

```c
if (tree == NULL) return NULL;

if (value < tree->data) {
    tree->left = deleteBSTrec(tree->left, value, removedPtr);
} else if (value > tree->data) {
    tree->right = deleteBSTrec(tree->right, value, removedPtr);
} else {
    *removedPtr = true;

    if (tree->left == NULL) {
        IntTree right = tree->right;
        free(tree);
        return right;
    }

    if (tree->right == NULL) {
        IntTree left = tree->left;
        free(tree);
        return left;
    }

    int successor = findMinBSTrec(tree->right);
    tree->data = successor;
    tree->right = deleteBSTrec(tree->right, successor, removedPtr);
}

return tree;
```

## Validazione BST — ricorsivo con limiti

```c
bool isBSTrange(IntTree tree, const int *minPtr, const int *maxPtr) {
    if (tree == NULL) return true;
    if (minPtr != NULL && tree->data <= *minPtr) return false;
    if (maxPtr != NULL && tree->data >= *maxPtr) return false;
    return isBSTrange(tree->left, minPtr, &tree->data)
        && isBSTrange(tree->right, &tree->data, maxPtr);
}
```

## Somma nell'intervallo `[low, high]`

```c
if (tree == NULL) return 0;
if (tree->data < low) return sumBSTRange(tree->right, low, high);
if (tree->data > high) return sumBSTRange(tree->left, low, high);
return tree->data
    + sumBSTRange(tree->left, low, high)
    + sumBSTRange(tree->right, low, high);
```

## K-esimo elemento minimo — iterativo in-order

```c
TreeStackADT stack = mkTreeStack();
IntTree current = tree;

while (current != NULL || !treeStackEmpty(stack)) {
    while (current != NULL) {
        pushTree(stack, current);
        current = current->left;
    }
    current = popTree(stack);
    if (--k == 0) return current->data;
    current = current->right;
}
```

## Costruzione BST bilanciato da array ordinato — ricorsivo

```c
if (left > right) return NULL;
size_t mid = left + (right - left) / 2;
IntTree root = makeTreeNode(a[mid]);
root->left = buildBalanced(a, left, mid - 1);
root->right = buildBalanced(a, mid + 1, right);
return root;
```

# 11. Alberi n-ari — primo figlio / fratello successivo

## Nodo

```c
NTree node = malloc(sizeof *node);
if (node == NULL) return NULL;
node->data = value;
node->firstChild = NULL;
node->nextSibling = NULL;
```

## Inserimento come primo figlio

```c
NTree node = makeNTreeNode(value);
if (node == NULL) return OUT_OF_MEMORY;
node->nextSibling = parent->firstChild;
parent->firstChild = node;
```

## Inserimento come ultimo figlio — verboso

```c
NTree node = makeNTreeNode(value);
if (node == NULL) return OUT_OF_MEMORY;

if (parent->firstChild == NULL) {
    parent->firstChild = node;
} else {
    NTree child = parent->firstChild;
    while (child->nextSibling != NULL)
        child = child->nextSibling;
    child->nextSibling = node;
}
```

## Inserimento come ultimo figlio — puntatore a puntatore

```c
NTree *link = &parent->firstChild;
while (*link != NULL) link = &(*link)->nextSibling;
*link = node;
```

## Conteggio — ricorsivo

```c
if (tree == NULL) return 0;
size_t count = 1;
for (NTree child = tree->firstChild;
     child != NULL;
     child = child->nextSibling) {
    count += nTreeCountRec(child);
}
return count;
```

## Somma — ricorsivo

```c
if (tree == NULL) return 0;
long sum = tree->data;
for (NTree child = tree->firstChild;
     child != NULL;
     child = child->nextSibling) {
    sum += nTreeSumRec(child);
}
return sum;
```

## Altezza — ricorsivo

```c
if (tree == NULL) return 0;
int maxChildHeight = 0;
for (NTree child = tree->firstChild;
     child != NULL;
     child = child->nextSibling) {
    int h = nTreeHeightRec(child);
    if (h > maxChildHeight) maxChildHeight = h;
}
return 1 + maxChildHeight;
```

## DFS — ricorsivo

```c
if (tree == NULL) return;
visit(tree->data);
for (NTree child = tree->firstChild;
     child != NULL;
     child = child->nextSibling) {
    nTreeDepthFirstRec(child, visit);
}
```

## DFS — iterativo

- Per conservare l'ordine dei figli: inserisci i fratelli nello stack in ordine inverso.
- Per evitare l'inversione: usa una pila temporanea per i figli.

## BFS — iterativo

- Per contare iterativamente: inizializza `count = 0` e incrementa una volta per nodo estratto.
- Per sommare iterativamente: inizializza `sum = 0` e aggiungi `node->data` a ogni estrazione.

```c
NTreeQueueADT q = mkNTreeQueue();
enqueueNTree(q, tree);
while (!empty(q)) {
    NTree node = dequeueNTree(q);
    visit(node->data);
    for (NTree child = node->firstChild;
         child != NULL;
         child = child->nextSibling) {
        enqueueNTree(q, child);
    }
}
```

## Distruzione — ricorsivo

```c
if (*treePtr == NULL) return;
NTree child = (*treePtr)->firstChild;
while (child != NULL) {
    NTree next = child->nextSibling;
    child->nextSibling = NULL;
    destroyNTreeRec(&child);
    child = next;
}
free(*treePtr);
*treePtr = NULL;
```

# 12. `void *`, callback e ADT generici

## Puntatore generico

- Per salvare un puntatore tipato in `void *`: `void *p = typedPtr;`.
- Per recuperarlo: `T *typedPtr = p;`.
- Per leggere il contenuto: `T value = *(T *)p;`.
- Per evitare cast nel C standard su conversione da `void *`: assegna direttamente a `T *`.
- Per fare aritmetica: converti a `unsigned char *`; non fare `p + 1` su `void *` in C standard.

## Comparatori

- Per confrontare interi senza overflow:

```c
int compareInt(const void *a, const void *b) {
    int x = *(const int *)a;
    int y = *(const int *)b;
    return (x > y) - (x < y);
}
```

- Per confrontare stringhe:

```c
int compareStringPtr(const void *a, const void *b) {
    const char *const *sa = a;
    const char *const *sb = b;
    return strcmp(*sa, *sb);
}
```

- Per confrontare `struct Person` per id:

```c
int comparePersonId(const void *a, const void *b) {
    const Person *pa = a;
    const Person *pb = b;
    return (pa->id > pb->id) - (pa->id < pb->id);
}
```

## Copia e distruzione

- Per copiare un `int`:

```c
void *copyInt(const void *value) {
    int *copy = malloc(sizeof *copy);
    if (copy != NULL) *copy = *(const int *)value;
    return copy;
}
```

- Per copiare una stringa: alloca `strlen(s) + 1`, poi copia.
- Per distruggere un dato heap: `free(data)`.
- Per non possedere i dati: usa `copy == NULL` e `destroy == NULL`.
- Per possedere una deep copy: usa entrambe le callback.

## Inserimento generico in testa

```c
void *stored = ls->copy != NULL ? ls->copy(value) : (void *)value;
if (ls->copy != NULL && stored == NULL) return OUT_OF_MEMORY;

GList node = malloc(sizeof *node);
if (node == NULL) {
    if (ls->copy != NULL && ls->destroy != NULL) ls->destroy(stored);
    return OUT_OF_MEMORY;
}

node->data = stored;
node->next = ls->first;
ls->first = node;
ls->size++;
```

## Inserimento generico ordinato — puntatore a puntatore

```c
GList *link = &ls->first;
while (*link != NULL && ls->compare((*link)->data, value) < 0)
    link = &(*link)->next;

node->next = *link;
*link = node;
```

## Ricerca generica

```c
for (GList current = ls->first;
     current != NULL;
     current = current->next) {
    if (ls->compare(current->data, key) == 0)
        return current->data;
}
return NULL;
```

## Rimozione generica — puntatore a puntatore

```c
GList *link = &ls->first;
while (*link != NULL && ls->compare((*link)->data, key) != 0)
    link = &(*link)->next;

if (*link == NULL) return NOT_FOUND;
GList tmp = *link;
*link = tmp->next;
if (ls->destroy != NULL) ls->destroy(tmp->data);
free(tmp);
ls->size--;
```

## Conteggio tramite predicato

```c
size_t count = 0;
for (GList current = ls->first;
     current != NULL;
     current = current->next) {
    if (predicate(current->data)) count++;
}
```

## Distruzione generica

```c
while (ls->first != NULL) {
    GList tmp = ls->first;
    ls->first = tmp->next;
    if (ls->destroy != NULL) ls->destroy(tmp->data);
    free(tmp);
}
free(ls);
```

## `qsort`

- Per ordinare:

```c
qsort(array, n, sizeof array[0], compareInt);
```

## `bsearch`

- Per cercare in un array ordinato:

```c
int *found = bsearch(&key, array, n, sizeof array[0], compareInt);
```

## Puntatori a funzione

- Per dichiarare: `int (*operation)(int, int);`.
- Per assegnare: `operation = sum;`.
- Per chiamare: `operation(a, b)` oppure `(*operation)(a, b)`.
- Per semplificare:

```c
typedef int (*BinaryOperation)(int, int);
```

- Per selezionare una funzione:

```c
BinaryOperation op = choice == '+' ? add : multiply;
int result = op(a, b);
```

## Dati eterogenei con tag

```c
switch (value.tag) {
    case VALUE_INT:    useInt(value.value.i); break;
    case VALUE_DOUBLE: useDouble(value.value.d); break;
    case VALUE_STRING: useString(value.value.s); break;
}
```

# 13. File di testo e binari

## Apertura e chiusura

- Per leggere testo: `fopen(path, "r")`.
- Per scrivere sostituendo: `fopen(path, "w")`.
- Per aggiungere in coda: `fopen(path, "a")`.
- Per leggere e scrivere: `fopen(path, "r+")`.
- Per creare e leggere/scrivere: `fopen(path, "w+")`.
- Per modalità binaria: aggiungi `b`, esempio `"rb"`, `"wb"`, `"ab"`.
- Per controllare: `if (file == NULL) ...`.
- Per chiudere: `fclose(file)`.

## Lettura corretta

- Per leggere interi finché disponibili:

```c
int value;
while (fscanf(file, "%d", &value) == 1) {
    /* usa value */
}
```

- Per leggere coppie:

```c
while (fscanf(file, "%d %lf", &id, &value) == 2) {
    /* usa id e value */
}
```

- Per leggere righe:

```c
char line[1024];
while (fgets(line, sizeof line, file) != NULL) {
    /* usa line */
}
```

- Per leggere caratteri:

```c
int ch;
while ((ch = fgetc(file)) != EOF) {
    /* usa ch */
}
```

- Per non sbagliare il ciclo: usa il valore di ritorno della funzione di lettura; non usare `while (!feof(file))`.

## Scrittura

- Per scrivere testo formattato: `fprintf(file, "%d %s\n", id, name);`.
- Per scrivere una stringa: `fputs(text, file);`.
- Per scrivere un carattere: `fputc(ch, file);`.
- Per forzare il buffer: `fflush(file);`.

## Copia binaria

```c
FILE *src = fopen(srcPath, "rb");
FILE *dst = fopen(dstPath, "wb");
unsigned char buffer[8192];
size_t readCount;

while ((readCount = fread(buffer, 1, sizeof buffer, src)) > 0) {
    if (fwrite(buffer, 1, readCount, dst) != readCount) {
        /* errore */
    }
}
```

## Conteggio righe

```c
size_t lines = 0;
int ch;
int previous = '\n';

while ((ch = fgetc(file)) != EOF) {
    if (ch == '\n') lines++;
    previous = ch;
}
if (previous != '\n') lines++;
```

## Somma di interi

```c
long sum = 0;
int value;
while (fscanf(file, "%d", &value) == 1)
    sum += value;
```

## Caricamento in array dinamico

```c
int *a = NULL;
size_t n = 0, capacity = 0;
int value;

while (fscanf(file, "%d", &value) == 1) {
    if (!appendInt(&a, &n, &capacity, value)) {
        free(a);
        fclose(file);
        return false;
    }
}
```

## Scrittura binaria di array

```c
fwrite(&n, sizeof n, 1, file);
fwrite(a, sizeof *a, n, file);
```

## Lettura binaria di array

```c
size_t n;
if (fread(&n, sizeof n, 1, file) != 1) return false;

int *a = malloc(n * sizeof *a);
if (a == NULL && n != 0) return false;

if (fread(a, sizeof *a, n, file) != n) {
    free(a);
    return false;
}
```

## Scrittura e lettura di `struct`

- Per scrivere un record binario: `fwrite(&record, sizeof record, 1, file)`.
- Per leggere un record binario: `fread(&record, sizeof record, 1, file)`.
- Per record con puntatori: serializza separatamente i dati puntati; non scrivere il valore del puntatore.

## Posizionamento

- Per tornare all'inizio: `rewind(file)`.
- Per spostarti: `fseek(file, offset, SEEK_SET)`.
- Per ottenere la posizione: `long pos = ftell(file)`.
- Per ottenere la dimensione:

```c
fseek(file, 0, SEEK_END);
long size = ftell(file);
rewind(file);
```

- Per leggere il record `index`:

```c
fseek(file, (long)(index * sizeof record), SEEK_SET);
fread(&record, sizeof record, 1, file);
```

- Per aggiornare il record `index` in-place:

```c
fseek(file, (long)(index * sizeof record), SEEK_SET);
fwrite(&record, sizeof record, 1, file);
```

## Merge di due file ordinati

- Per fondere due file ordinati: leggi un valore corrente da ogni file; scrivi il minore; aggiorna solo il file da cui hai scritto; alla fine copia il residuo.

## Cleanup unico

```c
bool ok = false;
FILE *a = NULL;
FILE *b = NULL;
void *buffer = NULL;

/* acquisizioni e operazioni */
ok = true;

cleanup:
free(buffer);
if (b != NULL) fclose(b);
if (a != NULL) fclose(a);
return ok;
```

# 14. ADT opachi e moduli

## Header pubblico `.h`

```c
#ifndef INT_STACK_ADT_H
#define INT_STACK_ADT_H

#include <stdbool.h>
#include <stddef.h>

typedef struct IntStack *IntStackADT;

IntStackADT mkStack(void);
bool stackIsEmpty(IntStackADT s);
size_t stackSize(IntStackADT s);
bool push(IntStackADT s, int value);
bool pop(IntStackADT s, int *valuePtr);
void dsStack(IntStackADT *sPtr);

#endif
```

## Implementazione privata `.c`

```c
#include "intStackADT.h"
#include <stdlib.h>

struct IntStack {
    StackNode *top;
    size_t size;
};

static bool invariant(const struct IntStack *s) {
    /* controllo privato */
}
```

## Operazioni

- Per nascondere i campi: nel `.h` dichiara solo `typedef struct Type *TypeADT;`.
- Per definire i campi: definisci `struct Type { ... };` nel `.c`.
- Per esporre operazioni: metti i prototipi nel `.h`.
- Per rendere privata una funzione: dichiarala `static` nel `.c`.
- Per creare: alloca la struttura, inizializza ogni campo, restituisci il puntatore.
- Per distruggere: libera prima le risorse interne, poi la struttura, poi assegna `NULL` nel chiamante.
- Per leggere senza modificare l'oggetto dietro un typedef-puntatore: usa internamente `const struct Type *`.
- Per rendere costante solo il puntatore alias: `TypeADT const p`; non rende costante la struttura puntata.
- Per compilare:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    main.c intStackADT.c -o programma
```

- Per cercare errori di memoria:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic \
    -fsanitize=address,undefined -g \
    main.c modulo.c -o programma
```

# 15. Ricorsione — schemi

## Ricorsione lineare

- Per una sequenza di lunghezza `n`: caso base `n == 0`; passo su `n - 1`.
- Per una lista: caso base `ls == NULL`; passo su `ls->next`.
- Per un albero: caso base `tree == NULL`; passi su `left` e `right`.

## Ricorsione di testa

```c
Result f(Input x) {
    if (base(x)) return baseResult;
    return f(smaller(x));
}
```

## Ricorsione non di coda

```c
Result f(Input x) {
    if (base(x)) return baseResult;
    return combine(current(x), f(smaller(x)));
}
```

## Ricorsione con accumulatore

```c
Result helper(Input x, Result acc) {
    if (base(x)) return acc;
    return helper(smaller(x), update(acc, x));
}
```

- Per il fattoriale: `helper(n, acc) -> helper(n - 1, acc * n)`.
- Per la somma array: `helper(a, n, acc) -> helper(a, n - 1, acc + a[n - 1])`.
- Per invertire una lista in coda: passa `current` e `prev`.

## Backtracking

```c
bool solve(State *state) {
    if (complete(state)) return true;

    for (Choice c = firstChoice(state); hasChoice(c); c = nextChoice(c)) {
        apply(state, c);
        if (solve(state)) return true;
        undo(state, c);
    }
    return false;
}
```

## Divide et impera

- Per dividere: calcola `mid`.
- Per risolvere: richiama sulla metà sinistra e destra.
- Per combinare: fondi i due risultati.

# 16. Cicli, correttezza e complessità

## Scelta del ciclo

- Per visitare esattamente `n` elementi: `for (size_t i = 0; i < n; i++)`.
- Per avanzare finché una condizione resta vera: `while (condition)`.
- Per eseguire almeno una volta: `do { ... } while (condition);`.
- Per una lista: condizione `current != NULL`.
- Per usare `current->next`: controlla prima `current != NULL`.
- Per visitare anche l'ultimo nodo: usa `current != NULL`, non `current->next != NULL`.

## Schema invarianti

- Per progettare un ciclo: definisci `inizializzazione`, `invariante`, `condizione`, `avanzamento`, `postcondizione`.
- Per una ricerca su prefisso: prima dell'iterazione `i`, gli elementi `[0, i)` sono già stati esclusi o processati.
- Per un accumulatore: prima dell'iterazione `i`, `acc` contiene il risultato su `[0, i)`.
- Per due indici: prima dell'iterazione, la zona esterna agli indici è già sistemata.
- Per puntatore a puntatore su lista: `link` punta sempre al campo che deve essere aggiornato per modificare il nodo corrente.

## Complessità operative

- Per un solo attraversamento di array/lista: `O(n)` tempo.
- Per due cicli annidati completi: `O(n²)` tempo.
- Per dimezzamento a ogni passo: `O(log n)` tempo.
- Per visita completa di un albero: `O(n)` tempo.
- Per BST bilanciato, ricerca/inserimento/rimozione: `O(log n)` medio.
- Per BST degenerato, ricerca/inserimento/rimozione: `O(n)`.
- Per accesso a indice di array: `O(1)`.
- Per accesso a indice di lista: `O(n)`.
- Per push/pop pila linkata: `O(1)`.
- Per enqueue/dequeue con `front` e `rear`: `O(1)`.
- Per unione/intersezione di set con due liste ordinate: `O(n + m)`.
- Per appartenenza ripetuta su liste non ordinate: fino a `O(nm)`.
- Per ricorsione lineare: spazio stack `O(n)`.
- Per ricorsione su albero: spazio stack `O(h)`.
