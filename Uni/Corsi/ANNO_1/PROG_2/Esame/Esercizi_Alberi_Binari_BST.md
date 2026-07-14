# Programmazione 2 — Esercizi su alberi binari e BST

> Raccolta progressiva in stile esame: consegna, struttura di partenza, soluzione semplice, eventuale soluzione elegante o ottimizzata, complessità, casi limite, invarianti, ownership ed errori tipici.
>
> Focus:
>
> - alberi binari generici;
> - alberi binari di ricerca (BST / ABR);
> - ricorsione su strutture ramificate;
> - visite preorder, inorder, postorder e per livelli;
> - conteggi, proprietà strutturali e cammini;
> - costruzione di liste e array a partire da alberi;
> - inserimento, ricerca e rimozione nei BST;
> - validazione e bilanciamento;
> - problemi in stile LeetCode;
> - hidden test, memoria dinamica e casi limite.

Compilazione consigliata:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    -g -fsanitize=address,undefined file.c -o file
```

---

# 0. Strutture di riferimento

## 0.1 Albero binario di interi

```c
#include <stddef.h>

typedef struct treeNode TreeNode;
typedef TreeNode *IntTree;

struct treeNode {
    IntTree left;
    int data;
    IntTree right;
};
```

Un albero binario è:

```text
vuoto
oppure
radice + sottoalbero sinistro + sottoalbero destro
```

## 0.2 BST

Un albero binario di ricerca soddisfa:

```text
tutti i valori a sinistra < data della radice
tutti i valori a destra  > data della radice
```

In questa raccolta, salvo diversa indicazione:

```text
i duplicati non sono ammessi
```

## 0.3 Costruttore di nodo

```c
#include <stdlib.h>

static IntTree makeNode(int value) {
    IntTree node = malloc(sizeof(*node));

    if (node == NULL) {
        return NULL;
    }

    node->left = NULL;
    node->data = value;
    node->right = NULL;

    return node;
}
```

---

# 1. Come ragionare su un albero

Ogni funzione ricorsiva su un albero deve chiarire:

```text
1. cosa restituisce per l'albero vuoto;
2. cosa assume sui due sottoalberi;
3. come combina:
   - dato della radice;
   - risultato a sinistra;
   - risultato a destra.
```

Schema fondamentale:

```c
ReturnType f(IntTree tree) {
    if (tree == NULL) {
        return /* caso base */;
    }

    ReturnType leftResult = f(tree->left);
    ReturnType rightResult = f(tree->right);

    return /* combinazione */;
}
```

## 1.1 Profondità dello stack

Per un albero di altezza `h`:

```text
stack ricorsivo: O(h)
```

Quindi:

- albero bilanciato: `O(log n)`;
- albero degenerato: `O(n)`.

## 1.2 Visite

### Preorder

```text
radice
sinistra
destra
```

### Inorder

```text
sinistra
radice
destra
```

In un BST produce i valori in ordine crescente.

### Postorder

```text
sinistra
destra
radice
```

È naturale per distruzione e calcoli bottom-up.

### Per livelli

Usa una coda:

```text
livello 0
livello 1
livello 2
...
```

---

# Livello 1 — Operazioni fondamentali su alberi binari

---

## Esercizio 1 — Numero di nodi

### Consegna

Restituire il numero totale di nodi dell'albero.

### Struttura di partenza

```c
size_t treeSize(IntTree tree);
```

### Soluzione semplice

```c
size_t treeSize(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    return 1 +
           treeSize(tree->left) +
           treeSize(tree->right);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 2 — Numero di foglie

### Consegna

Restituire il numero di foglie.

Una foglia è un nodo senza figli.

### Struttura

```c
size_t leafCount(IntTree tree);
```

### Soluzione

```c
size_t leafCount(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    if (tree->left == NULL &&
        tree->right == NULL) {
        return 1;
    }

    return leafCount(tree->left) +
           leafCount(tree->right);
}
```

### Trappola

Un albero con sola radice contiene una foglia, non zero.

---

## Esercizio 3 — Numero di nodi interni

### Consegna

Contare i nodi che hanno almeno un figlio.

### Soluzione

```c
size_t internalNodeCount(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    size_t current =
        (tree->left != NULL ||
         tree->right != NULL)
        ? 1U
        : 0U;

    return current +
           internalNodeCount(tree->left) +
           internalNodeCount(tree->right);
}
```

### Identità utile

Per un albero non vuoto:

```text
nodi totali = foglie + nodi interni
```

---

## Esercizio 4 — Somma dei valori

### Consegna

Restituire la somma dei valori dei nodi.

### Soluzione

```c
long long treeSum(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    return tree->data +
           treeSum(tree->left) +
           treeSum(tree->right);
}
```

---

## Esercizio 5 — Conteggio secondo predicato

### Consegna

Contare quanti nodi soddisfano un predicato.

### Struttura

```c
typedef _Bool (*IntPredicate)(int);

size_t treeCountIf(
    IntTree tree,
    IntPredicate predicate
);
```

### Soluzione

```c
size_t treeCountIf(
    IntTree tree,
    IntPredicate predicate
) {
    if (tree == NULL || predicate == NULL) {
        return 0;
    }

    size_t current =
        predicate(tree->data) ? 1U : 0U;

    return current +
           treeCountIf(tree->left, predicate) +
           treeCountIf(tree->right, predicate);
}
```

---

## Esercizio 6 — Altezza

### Consegna

Definire l'altezza come:

```text
0 per albero vuoto
1 per sola radice
```

### Struttura

```c
size_t treeHeight(IntTree tree);
```

### Soluzione

```c
size_t treeHeight(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    size_t leftHeight =
        treeHeight(tree->left);

    size_t rightHeight =
        treeHeight(tree->right);

    return 1 +
           (leftHeight > rightHeight
            ? leftHeight
            : rightHeight);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 7 — Ricerca in albero binario generico

### Consegna

Restituire vero se `value` compare almeno una volta.

Non assumere proprietà BST.

### Soluzione

```c
_Bool treeContains(
    IntTree tree,
    int value
) {
    if (tree == NULL) {
        return 0;
    }

    if (tree->data == value) {
        return 1;
    }

    return treeContains(tree->left, value) ||
           treeContains(tree->right, value);
}
```

### Complessità

- Migliore: `O(1)`
- Peggiore: `O(n)`

---

## Esercizio 8 — Minimo in albero generico

### Consegna

Restituire il minimo valore.

Si assume albero non vuoto.

### Soluzione semplice

```c
int treeMin(IntTree tree) {
    int minValue = tree->data;

    if (tree->left != NULL) {
        int leftMin = treeMin(tree->left);

        if (leftMin < minValue) {
            minValue = leftMin;
        }
    }

    if (tree->right != NULL) {
        int rightMin = treeMin(tree->right);

        if (rightMin < minValue) {
            minValue = rightMin;
        }
    }

    return minValue;
}
```

### Trappola

Usare `0` come minimo del caso vuoto è scorretto per alberi con soli positivi o soli negativi, a seconda della combinazione.

---

## Esercizio 9 — Copia profonda

### Consegna

Restituire una copia indipendente dell'albero.

### Struttura

```c
IntTree treeClone(IntTree tree);
```

### Soluzione semplice

```c
IntTree treeClone(IntTree tree) {
    if (tree == NULL) {
        return NULL;
    }

    IntTree copy = makeNode(tree->data);

    if (copy == NULL) {
        return NULL;
    }

    copy->left = treeClone(tree->left);

    if (tree->left != NULL &&
        copy->left == NULL) {
        free(copy);
        return NULL;
    }

    copy->right = treeClone(tree->right);

    if (tree->right != NULL &&
        copy->right == NULL) {
        /* serve distruggere copy->left */
        treeDestroy(&copy->left);
        free(copy);
        return NULL;
    }

    return copy;
}
```

### Nota

Per usare `treeDestroy` qui, serve un prototipo precedente:

```c
void treeDestroy(IntTree *treePtr);
```

### Ownership

La copia deve avere nodi propri. Questo è sbagliato:

```c
copy = tree;
```

---

## Esercizio 10 — Distruzione completa

### Consegna

Liberare tutti i nodi e porre il puntatore del chiamante a `NULL`.

### Struttura

```c
void treeDestroy(IntTree *treePtr);
```

### Soluzione postorder

```c
void treeDestroy(IntTree *treePtr) {
    if (treePtr == NULL || *treePtr == NULL) {
        return;
    }

    treeDestroy(&(*treePtr)->left);
    treeDestroy(&(*treePtr)->right);

    free(*treePtr);
    *treePtr = NULL;
}
```

### Perché postorder

Bisogna liberare i figli prima del padre.

---

# Livello 2 — Proprietà strutturali

---

## Esercizio 11 — Alberi identici

### Consegna

Verificare se due alberi hanno stessa struttura e stessi valori.

### Soluzione

```c
_Bool treeEquals(
    IntTree a,
    IntTree b
) {
    if (a == NULL || b == NULL) {
        return a == b;
    }

    return
        a->data == b->data &&
        treeEquals(a->left, b->left) &&
        treeEquals(a->right, b->right);
}
```

---

## Esercizio 12 — Alberi speculari

### Consegna

Verificare se due alberi sono uno lo specchio dell'altro.

### Soluzione

```c
_Bool treeAreMirrors(
    IntTree a,
    IntTree b
) {
    if (a == NULL || b == NULL) {
        return a == b;
    }

    return
        a->data == b->data &&
        treeAreMirrors(a->left, b->right) &&
        treeAreMirrors(a->right, b->left);
}
```

---

## Esercizio 13 — Specchia in place

### Consegna

Trasformare l'albero nel proprio specchio senza allocare nuovi nodi.

### Soluzione

```c
void treeMirror(IntTree tree) {
    if (tree == NULL) {
        return;
    }

    IntTree tmp = tree->left;
    tree->left = tree->right;
    tree->right = tmp;

    treeMirror(tree->left);
    treeMirror(tree->right);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`
- Heap aggiuntivo: `O(1)`

---

## Esercizio 14 — Albero pieno

### Consegna

Verificare se ogni nodo ha:

```text
0 oppure 2 figli
```

### Soluzione

```c
_Bool isFullTree(IntTree tree) {
    if (tree == NULL) {
        return 1;
    }

    if (tree->left == NULL &&
        tree->right == NULL) {
        return 1;
    }

    if (tree->left == NULL ||
        tree->right == NULL) {
        return 0;
    }

    return isFullTree(tree->left) &&
           isFullTree(tree->right);
}
```

---

## Esercizio 15 — Albero perfetto

### Consegna

Verificare se:

- ogni nodo interno ha due figli;
- tutte le foglie sono alla stessa profondità.

### Soluzione semplice

1. Calcolare la profondità della foglia più a sinistra.
2. Verificare ricorsivamente tutte le foglie.

```c
static size_t leftmostLeafDepth(IntTree tree) {
    size_t depth = 0;

    while (tree != NULL) {
        depth++;
        tree = tree->left;
    }

    return depth;
}

static _Bool perfectAux(
    IntTree tree,
    size_t depth,
    size_t expectedLeafDepth
) {
    if (tree == NULL) {
        return 1;
    }

    if (tree->left == NULL &&
        tree->right == NULL) {
        return depth == expectedLeafDepth;
    }

    if (tree->left == NULL ||
        tree->right == NULL) {
        return 0;
    }

    return
        perfectAux(
            tree->left,
            depth + 1,
            expectedLeafDepth
        ) &&
        perfectAux(
            tree->right,
            depth + 1,
            expectedLeafDepth
        );
}

_Bool isPerfectTree(IntTree tree) {
    if (tree == NULL) {
        return 1;
    }

    size_t expected =
        leftmostLeafDepth(tree);

    return perfectAux(tree, 1, expected);
}
```

---

## Esercizio 16 — Albero bilanciato

### Consegna

Un albero è bilanciato se per ogni nodo:

```text
|altezza sinistra - altezza destra| <= 1
```

### Soluzione semplice ma inefficiente

```c
_Bool isBalancedSlow(IntTree tree) {
    if (tree == NULL) {
        return 1;
    }

    size_t lh = treeHeight(tree->left);
    size_t rh = treeHeight(tree->right);

    size_t diff =
        lh > rh ? lh - rh : rh - lh;

    return
        diff <= 1 &&
        isBalancedSlow(tree->left) &&
        isBalancedSlow(tree->right);
}
```

### Complessità

Nel caso peggiore:

```text
O(n²)
```

perché l'altezza viene ricalcolata molte volte.

### Soluzione ottimizzata

```c
static ptrdiff_t balancedHeight(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    ptrdiff_t left =
        balancedHeight(tree->left);

    if (left < 0) {
        return -1;
    }

    ptrdiff_t right =
        balancedHeight(tree->right);

    if (right < 0) {
        return -1;
    }

    ptrdiff_t diff = left - right;

    if (diff < -1 || diff > 1) {
        return -1;
    }

    return 1 + (left > right ? left : right);
}

_Bool isBalanced(IntTree tree) {
    return balancedHeight(tree) >= 0;
}
```

### Complessità ottimizzata

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 17 — Numero di nodi a profondità k

### Consegna

La radice ha profondità `0`.

Contare i nodi a profondità `k`.

### Soluzione

```c
size_t nodesAtDepth(
    IntTree tree,
    size_t k
) {
    if (tree == NULL) {
        return 0;
    }

    if (k == 0) {
        return 1;
    }

    return
        nodesAtDepth(tree->left, k - 1) +
        nodesAtDepth(tree->right, k - 1);
}
```

---

## Esercizio 18 — Somma a profondità k

### Soluzione

```c
long long sumAtDepth(
    IntTree tree,
    size_t k
) {
    if (tree == NULL) {
        return 0;
    }

    if (k == 0) {
        return tree->data;
    }

    return
        sumAtDepth(tree->left, k - 1) +
        sumAtDepth(tree->right, k - 1);
}
```

---

# Livello 3 — Visite e costruzione di sequenze

---

## Esercizio 19 — Preorder in array

### Consegna

Restituire un array dinamico contenente la visita preorder.

### Struttura

```c
typedef struct {
    int *data;
    size_t size;
} IntArray;

IntArray preorderArray(IntTree tree);
```

### Soluzione semplice in due passaggi

```c
static void preorderFill(
    IntTree tree,
    int out[],
    size_t *index
) {
    if (tree == NULL) {
        return;
    }

    out[(*index)++] = tree->data;
    preorderFill(tree->left, out, index);
    preorderFill(tree->right, out, index);
}

IntArray preorderArray(IntTree tree) {
    IntArray result = {NULL, 0};

    size_t n = treeSize(tree);

    if (n == 0) {
        return result;
    }

    result.data =
        malloc(n * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    size_t index = 0;
    preorderFill(tree, result.data, &index);

    result.size = n;
    return result;
}
```

---

## Esercizio 20 — Inorder in array

### Soluzione

```c
static void inorderFill(
    IntTree tree,
    int out[],
    size_t *index
) {
    if (tree == NULL) {
        return;
    }

    inorderFill(tree->left, out, index);
    out[(*index)++] = tree->data;
    inorderFill(tree->right, out, index);
}
```

### Proprietà BST

Per un BST senza duplicati, l'array risultante è strettamente crescente.

---

## Esercizio 21 — Postorder in array

### Soluzione

```c
static void postorderFill(
    IntTree tree,
    int out[],
    size_t *index
) {
    if (tree == NULL) {
        return;
    }

    postorderFill(tree->left, out, index);
    postorderFill(tree->right, out, index);
    out[(*index)++] = tree->data;
}
```

---

## Esercizio 22 — Visita iterativa inorder

### Consegna

Realizzare inorder senza ricorsione usando una pila.

### Idea

```text
finché current != NULL o pila non vuota:
    scendi a sinistra pushando i nodi
    pop
    visita
    vai a destra
```

### Soluzione con pila dinamica di puntatori

```c
typedef struct {
    IntTree *data;
    size_t size;
    size_t capacity;
} TreeStack;
```

Il pattern è importante anche per iteratori su BST.

---

## Esercizio 23 — Visita per livelli

### Consegna

Restituire un array con i nodi in ordine BFS.

### Idea

Usare una coda di puntatori a nodo:

```text
enqueue radice
while coda non vuota:
    dequeue nodo
    salva dato
    enqueue figlio sinistro
    enqueue figlio destro
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(w)`, dove `w` è la larghezza massima.

---

## Esercizio 24 — Somma per livello

### Consegna

Restituire un array in cui la posizione `d` contiene la somma dei nodi a profondità `d`.

### Soluzione semplice

1. Calcola altezza `h`.
2. Alloca array di `h` somme inizializzate a zero.
3. Visita ricorsivamente portando la profondità.

```c
static void levelSumsFill(
    IntTree tree,
    size_t depth,
    long long sums[]
) {
    if (tree == NULL) {
        return;
    }

    sums[depth] += tree->data;

    levelSumsFill(
        tree->left,
        depth + 1,
        sums
    );

    levelSumsFill(
        tree->right,
        depth + 1,
        sums
    );
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(h)` output + stack `O(h)`

---

# Livello 4 — Cammini

---

## Esercizio 25 — Somma lungo un percorso guidato

### Consegna

Partendo dalla radice:

- vai a sinistra se il valore è dispari;
- vai a destra se è pari.

Restituire la somma dei valori incontrati.

### Soluzione iterativa semplice

```c
long long parityPathSum(IntTree tree) {
    long long sum = 0;

    while (tree != NULL) {
        sum += tree->data;

        if (tree->data % 2 != 0) {
            tree = tree->left;
        } else {
            tree = tree->right;
        }
    }

    return sum;
}
```

### Complessità

- Tempo: `O(h)`
- Spazio: `O(1)`

---

## Esercizio 26 — Percorso guidato in nuova lista

### Consegna

Restituire una lista contenente i valori del percorso guidato dalla parità.

### Struttura

```c
typedef struct intNode IntNode;
typedef IntNode *IntList;

struct intNode {
    int data;
    IntList next;
};
```

### Soluzione semplice con tail pointer

```c
IntList parityPathList(IntTree tree) {
    IntList head = NULL;
    IntList tail = NULL;

    while (tree != NULL) {
        IntList node = malloc(sizeof(*node));

        if (node == NULL) {
            /* distruggere lista parziale */
            return NULL;
        }

        node->data = tree->data;
        node->next = NULL;

        if (tail == NULL) {
            head = node;
        } else {
            tail->next = node;
        }

        tail = node;

        tree =
            tree->data % 2 != 0
            ? tree->left
            : tree->right;
    }

    return head;
}
```

---

## Esercizio 27 — Esistenza di root-to-leaf sum

### Consegna

Verificare se esiste un percorso dalla radice a una foglia la cui somma sia `target`.

### Soluzione

```c
_Bool hasRootToLeafSum(
    IntTree tree,
    long long target
) {
    if (tree == NULL) {
        return 0;
    }

    target -= tree->data;

    if (tree->left == NULL &&
        tree->right == NULL) {
        return target == 0;
    }

    return
        hasRootToLeafSum(tree->left, target) ||
        hasRootToLeafSum(tree->right, target);
}
```

### Trappola

Non basta arrivare a un nodo qualunque con somma zero: deve essere una foglia.

---

## Esercizio 28 — Conta i cammini root-to-leaf con somma target

### Soluzione

```c
size_t countRootToLeafSum(
    IntTree tree,
    long long target
) {
    if (tree == NULL) {
        return 0;
    }

    target -= tree->data;

    if (tree->left == NULL &&
        tree->right == NULL) {
        return target == 0 ? 1U : 0U;
    }

    return
        countRootToLeafSum(tree->left, target) +
        countRootToLeafSum(tree->right, target);
}
```

---

## Esercizio 29 — Somma dei numeri rappresentati dai cammini

### Consegna

Ogni nodo contiene una cifra `0..9`.

Ogni percorso radice-foglia rappresenta un numero.

Esempio:

```text
    1
   / \
  2   3
```

produce:

```text
12 + 13 = 25
```

### Soluzione

```c
static long long rootNumbersAux(
    IntTree tree,
    long long prefix
) {
    if (tree == NULL) {
        return 0;
    }

    long long current =
        prefix * 10 + tree->data;

    if (tree->left == NULL &&
        tree->right == NULL) {
        return current;
    }

    return
        rootNumbersAux(tree->left, current) +
        rootNumbersAux(tree->right, current);
}

long long sumRootNumbers(IntTree tree) {
    return rootNumbersAux(tree, 0);
}
```

---

## Esercizio 30 — Tutti i percorsi root-to-leaf

### Consegna

Restituire tutti i percorsi come array di stringhe del tipo:

```text
"1->2->5"
```

### Strategia semplice

Backtracking con buffer dinamico:

1. append del valore corrente;
2. se foglia, copia il buffer nel risultato;
3. visita figli;
4. ripristina lunghezza del buffer.

### Punto difficile

Gestione contemporanea di:

```text
buffer corrente
array dinamico di stringhe
cleanup parziale in caso di malloc fallita
```

---

# Livello 5 — BST: ricerca, inserimento e minimo/massimo

---

## Esercizio 31 — Ricerca iterativa nel BST

### Consegna

Restituire vero se `value` appartiene al BST.

### Soluzione

```c
_Bool bstContains(
    IntTree tree,
    int value
) {
    while (tree != NULL) {
        if (value == tree->data) {
            return 1;
        }

        tree =
            value < tree->data
            ? tree->left
            : tree->right;
    }

    return 0;
}
```

### Complessità

- Tempo: `O(h)`
- Spazio: `O(1)`

---

## Esercizio 32 — Minimo e massimo BST

### Soluzione iterativa

```c
int bstMin(IntTree tree) {
    while (tree->left != NULL) {
        tree = tree->left;
    }

    return tree->data;
}

int bstMax(IntTree tree) {
    while (tree->right != NULL) {
        tree = tree->right;
    }

    return tree->data;
}
```

Si assume albero non vuoto.

---

## Esercizio 33 — Inserimento ricorsivo con esito

### Consegna

Inserire un valore se assente.

Restituire:

```c
typedef enum {
    BST_INSERTED,
    BST_ALREADY_PRESENT,
    BST_OUT_OF_MEMORY
} BstInsertResult;
```

### Struttura

```c
BstInsertResult bstInsert(
    IntTree *treePtr,
    int value
);
```

### Soluzione

```c
BstInsertResult bstInsert(
    IntTree *treePtr,
    int value
) {
    if (*treePtr == NULL) {
        IntTree node = makeNode(value);

        if (node == NULL) {
            return BST_OUT_OF_MEMORY;
        }

        *treePtr = node;
        return BST_INSERTED;
    }

    if (value == (*treePtr)->data) {
        return BST_ALREADY_PRESENT;
    }

    if (value < (*treePtr)->data) {
        return bstInsert(
            &(*treePtr)->left,
            value
        );
    }

    return bstInsert(
        &(*treePtr)->right,
        value
    );
}
```

### Complessità

- Tempo: `O(h)`
- Stack: `O(h)`

---

## Esercizio 34 — Inserimento iterativo con puntatore a puntatore

### Soluzione elegante

```c
BstInsertResult bstInsertIter(
    IntTree *treePtr,
    int value
) {
    while (*treePtr != NULL) {
        if (value == (*treePtr)->data) {
            return BST_ALREADY_PRESENT;
        }

        treePtr =
            value < (*treePtr)->data
            ? &(*treePtr)->left
            : &(*treePtr)->right;
    }

    IntTree node = makeNode(value);

    if (node == NULL) {
        return BST_OUT_OF_MEMORY;
    }

    *treePtr = node;
    return BST_INSERTED;
}
```

### Perché funziona

`treePtr` punta sempre al collegamento che deve contenere il nuovo nodo.

---

## Esercizio 35 — Floor

### Consegna

Restituire il massimo valore del BST minore o uguale a `x`.

Restituire `0` se non esiste, con un parametro `out` per distinguere fallimento da valore valido.

### Struttura

```c
int bstFloor(
    IntTree tree,
    int x,
    int *out
);
```

### Soluzione iterativa

```c
int bstFloor(
    IntTree tree,
    int x,
    int *out
) {
    int found = 0;
    int candidate = 0;

    while (tree != NULL) {
        if (tree->data == x) {
            *out = x;
            return 1;
        }

        if (tree->data < x) {
            candidate = tree->data;
            found = 1;
            tree = tree->right;
        } else {
            tree = tree->left;
        }
    }

    if (found) {
        *out = candidate;
    }

    return found;
}
```

---

## Esercizio 36 — Ceil

Analogo al floor:

```text
minimo valore >= x
```

Quando `tree->data > x`, il nodo corrente è candidato e si continua a sinistra.

---

# Livello 6 — Rimozione BST

---

## Esercizio 37 — Rimozione con tre casi

### Consegna

Rimuovere `value` dal BST.

Casi:

```text
0 figli
1 figlio
2 figli
```

### Struttura

```c
int bstRemove(
    IntTree *treePtr,
    int value
);
```

### Soluzione semplice

```c
static IntTree detachMin(
    IntTree *treePtr
) {
    while ((*treePtr)->left != NULL) {
        treePtr = &(*treePtr)->left;
    }

    IntTree minNode = *treePtr;
    *treePtr = minNode->right;

    return minNode;
}

int bstRemove(
    IntTree *treePtr,
    int value
) {
    if (treePtr == NULL || *treePtr == NULL) {
        return 0;
    }

    if (value < (*treePtr)->data) {
        return bstRemove(
            &(*treePtr)->left,
            value
        );
    }

    if (value > (*treePtr)->data) {
        return bstRemove(
            &(*treePtr)->right,
            value
        );
    }

    IntTree victim = *treePtr;

    if (victim->left == NULL) {
        *treePtr = victim->right;
        free(victim);
        return 1;
    }

    if (victim->right == NULL) {
        *treePtr = victim->left;
        free(victim);
        return 1;
    }

    IntTree successor =
        detachMin(&victim->right);

    successor->left = victim->left;
    successor->right = victim->right;

    *treePtr = successor;
    free(victim);

    return 1;
}
```

### Soluzione alternativa più semplice

Copiare nel nodo da rimuovere il valore del successore e poi rimuovere il successore dal sottoalbero destro.

```c
int successorValue = bstMin(victim->right);
victim->data = successorValue;
return bstRemove(&victim->right, successorValue);
```

Questa è spesso la soluzione più semplice all'esame.

### Complessità

- Tempo: `O(h)`
- Stack: `O(h)`

---

## Esercizio 38 — Rimuovi il minimo

### Soluzione

```c
int bstRemoveMin(
    IntTree *treePtr,
    int *out
) {
    if (treePtr == NULL ||
        *treePtr == NULL ||
        out == NULL) {
        return 0;
    }

    while ((*treePtr)->left != NULL) {
        treePtr = &(*treePtr)->left;
    }

    IntTree victim = *treePtr;
    *out = victim->data;

    *treePtr = victim->right;
    free(victim);

    return 1;
}
```

---

## Esercizio 39 — Rimuovi tutti i valori fuori intervallo

### Consegna

Dato un BST, rimuovere tutti i nodi con valore fuori da `[low, high]`.

### Soluzione ricorsiva elegante

```c
IntTree bstTrim(
    IntTree tree,
    int low,
    int high
) {
    if (tree == NULL) {
        return NULL;
    }

    if (tree->data < low) {
        IntTree right =
            bstTrim(tree->right, low, high);

        treeDestroy(&tree->left);
        free(tree);

        return right;
    }

    if (tree->data > high) {
        IntTree left =
            bstTrim(tree->left, low, high);

        treeDestroy(&tree->right);
        free(tree);

        return left;
    }

    tree->left =
        bstTrim(tree->left, low, high);

    tree->right =
        bstTrim(tree->right, low, high);

    return tree;
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

# Livello 7 — Validazione e proprietà BST

---

## Esercizio 40 — Verifica BST con intervalli

### Consegna

Verificare se un albero binario generico rispetta la proprietà BST.

### Soluzione sbagliata comune

Controllare soltanto:

```text
left child < node < right child
```

Non basta.

### Soluzione corretta

```c
#include <limits.h>

static _Bool bstValidRange(
    IntTree tree,
    long long minExclusive,
    long long maxExclusive
) {
    if (tree == NULL) {
        return 1;
    }

    if (
        tree->data <= minExclusive ||
        tree->data >= maxExclusive
    ) {
        return 0;
    }

    return
        bstValidRange(
            tree->left,
            minExclusive,
            tree->data
        ) &&
        bstValidRange(
            tree->right,
            tree->data,
            maxExclusive
        );
}

_Bool isValidBst(IntTree tree) {
    return bstValidRange(
        tree,
        LLONG_MIN,
        LLONG_MAX
    );
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 41 — Validazione tramite inorder

### Idea

Un BST senza duplicati produce inorder strettamente crescente.

### Soluzione

```c
static _Bool inorderValid(
    IntTree tree,
    _Bool *hasPrevious,
    int *previous
) {
    if (tree == NULL) {
        return 1;
    }

    if (!inorderValid(
            tree->left,
            hasPrevious,
            previous
        )) {
        return 0;
    }

    if (
        *hasPrevious &&
        tree->data <= *previous
    ) {
        return 0;
    }

    *previous = tree->data;
    *hasPrevious = 1;

    return inorderValid(
        tree->right,
        hasPrevious,
        previous
    );
}

_Bool isValidBstInorder(IntTree tree) {
    _Bool hasPrevious = 0;
    int previous = 0;

    return inorderValid(
        tree,
        &hasPrevious,
        &previous
    );
}
```

---

## Esercizio 42 — k-esimo elemento minimo

### Consegna

Restituire il k-esimo valore più piccolo, con `k` a partire da `1`.

### Soluzione inorder con contatore

```c
static int kthAux(
    IntTree tree,
    size_t k,
    size_t *visited,
    int *out
) {
    if (tree == NULL) {
        return 0;
    }

    if (kthAux(
            tree->left,
            k,
            visited,
            out
        )) {
        return 1;
    }

    (*visited)++;

    if (*visited == k) {
        *out = tree->data;
        return 1;
    }

    return kthAux(
        tree->right,
        k,
        visited,
        out
    );
}

int bstKthSmallest(
    IntTree tree,
    size_t k,
    int *out
) {
    if (k == 0 || out == NULL) {
        return 0;
    }

    size_t visited = 0;

    return kthAux(
        tree,
        k,
        &visited,
        out
    );
}
```

### Complessità

- Tempo: `O(h+k)` nel caso favorevole
- Peggiore: `O(n)`

---

## Esercizio 43 — Range sum BST

### Consegna

Somma dei valori nell'intervallo `[low, high]`.

### Soluzione che sfrutta il BST

```c
long long bstRangeSum(
    IntTree tree,
    int low,
    int high
) {
    if (tree == NULL) {
        return 0;
    }

    if (tree->data < low) {
        return bstRangeSum(
            tree->right,
            low,
            high
        );
    }

    if (tree->data > high) {
        return bstRangeSum(
            tree->left,
            low,
            high
        );
    }

    return
        tree->data +
        bstRangeSum(tree->left, low, high) +
        bstRangeSum(tree->right, low, high);
}
```

### Complessità

Dipende dalla forma e dal numero di nodi visitati:

```text
O(h + k)
```

circa, dove `k` è il numero di nodi nel range.

---

## Esercizio 44 — Lowest common ancestor in BST

### Consegna

Dati due valori presenti nel BST, restituire il nodo antenato comune più basso.

### Soluzione iterativa

```c
IntTree bstLca(
    IntTree tree,
    int a,
    int b
) {
    while (tree != NULL) {
        if (
            a < tree->data &&
            b < tree->data
        ) {
            tree = tree->left;
        } else if (
            a > tree->data &&
            b > tree->data
        ) {
            tree = tree->right;
        } else {
            return tree;
        }
    }

    return NULL;
}
```

### Complessità

- Tempo: `O(h)`
- Spazio: `O(1)`

---

# Livello 8 — Costruzione e trasformazione

---

## Esercizio 45 — BST da array ordinato bilanciato

### Consegna

Dato un array strettamente crescente, costruire un BST bilanciato.

### Soluzione

```c
static IntTree bstFromSortedRange(
    const int a[],
    size_t left,
    size_t right
) {
    if (left >= right) {
        return NULL;
    }

    size_t middle =
        left + (right - left) / 2;

    IntTree root = makeNode(a[middle]);

    if (root == NULL) {
        return NULL;
    }

    root->left =
        bstFromSortedRange(a, left, middle);

    root->right =
        bstFromSortedRange(
            a,
            middle + 1,
            right
        );

    return root;
}

IntTree bstFromSorted(
    const int a[],
    size_t n
) {
    return bstFromSortedRange(a, 0, n);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(log n)` per albero bilanciato

### Nota

Una gestione rigorosa della malloc fallita deve distruggere l'albero parziale.

---

## Esercizio 46 — Bilancia un BST

### Consegna

Dato un BST arbitrario, restituire un nuovo BST bilanciato con gli stessi valori.

### Soluzione semplice

1. Visita inorder in array ordinato.
2. Costruisci BST bilanciato dal centro.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 47 — Flatten preorder in place

### Consegna

Riorganizzare l'albero in una catena usando solo puntatori `right`, nell'ordine preorder.

Esempio:

```text
    1
   / \
  2   5
 / \   \
3   4   6
```

diventa:

```text
1 -> 2 -> 3 -> 4 -> 5 -> 6
```

con tutti i `left == NULL`.

### Soluzione semplice con array di nodi

- visita preorder e salva puntatori;
- ricollega.

Tempo `O(n)`, spazio `O(n)`.

### Soluzione ricorsiva in place

```c
static IntTree flattenAux(IntTree tree) {
    if (tree == NULL) {
        return NULL;
    }

    IntTree leftTail =
        flattenAux(tree->left);

    IntTree rightTail =
        flattenAux(tree->right);

    if (leftTail != NULL) {
        leftTail->right = tree->right;
        tree->right = tree->left;
        tree->left = NULL;
    }

    if (rightTail != NULL) {
        return rightTail;
    }

    if (leftTail != NULL) {
        return leftTail;
    }

    return tree;
}

void flattenPreorder(IntTree tree) {
    flattenAux(tree);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 48 — Converti BST in lista ordinata

### Consegna

Restituire una nuova lista linkata contenente i valori in ordine crescente.

### Idea

Visita inorder e tail pointer.

### Complessità

- Tempo: `O(n)`
- Spazio output: `O(n)`
- Stack: `O(h)`

---

# Livello 9 — Problemi classici in stile LeetCode

---

## Esercizio 49 — Diametro dell'albero

### Consegna

Il diametro è il numero massimo di archi in un percorso tra due nodi.

### Soluzione semplice inefficiente

Per ogni nodo:

```text
altezza sinistra + altezza destra
```

ricalcolando altezze: `O(n²)`.

### Soluzione ottimizzata

```c
static size_t diameterHeight(
    IntTree tree,
    size_t *best
) {
    if (tree == NULL) {
        return 0;
    }

    size_t left =
        diameterHeight(tree->left, best);

    size_t right =
        diameterHeight(tree->right, best);

    size_t through = left + right;

    if (through > *best) {
        *best = through;
    }

    return 1 + (left > right ? left : right);
}

size_t treeDiameter(IntTree tree) {
    size_t best = 0;
    diameterHeight(tree, &best);
    return best;
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 50 — Maximum path sum

### Consegna

Trovare la somma massima di un percorso non vuoto tra due nodi qualsiasi.

I valori possono essere negativi.

### Soluzione

```c
#include <limits.h>

static long long maxPathGain(
    IntTree tree,
    long long *best
) {
    if (tree == NULL) {
        return 0;
    }

    long long left =
        maxPathGain(tree->left, best);

    long long right =
        maxPathGain(tree->right, best);

    if (left < 0) {
        left = 0;
    }

    if (right < 0) {
        right = 0;
    }

    long long through =
        tree->data + left + right;

    if (through > *best) {
        *best = through;
    }

    return
        tree->data +
        (left > right ? left : right);
}

long long maximumPathSum(IntTree tree) {
    long long best = LLONG_MIN;
    maxPathGain(tree, &best);
    return best;
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

### Trappola

Non inizializzare `best = 0`: un albero con soli valori negativi avrebbe risultato sbagliato.

---

## Esercizio 51 — Subtree

### Consegna

Verificare se `small` compare come sottoalbero identico dentro `big`.

### Soluzione semplice

```c
_Bool isSubtree(
    IntTree big,
    IntTree small
) {
    if (small == NULL) {
        return 1;
    }

    if (big == NULL) {
        return 0;
    }

    if (treeEquals(big, small)) {
        return 1;
    }

    return
        isSubtree(big->left, small) ||
        isSubtree(big->right, small);
}
```

### Complessità

Peggiore:

```text
O(nm)
```

---

## Esercizio 52 — Lowest common ancestor in albero generico

### Consegna

Dati due valori distinti presenti nell'albero, restituire il loro antenato comune più basso.

### Soluzione

```c
IntTree treeLca(
    IntTree tree,
    int a,
    int b
) {
    if (tree == NULL) {
        return NULL;
    }

    if (
        tree->data == a ||
        tree->data == b
    ) {
        return tree;
    }

    IntTree left =
        treeLca(tree->left, a, b);

    IntTree right =
        treeLca(tree->right, a, b);

    if (left != NULL && right != NULL) {
        return tree;
    }

    return left != NULL ? left : right;
}
```

### Assunzione

Entrambi i valori esistono. Se non è garantito, bisogna verificare la presenza.

---

## Esercizio 53 — Right side view

### Consegna

Restituire i valori visibili guardando l'albero da destra.

### Soluzione ricorsiva

Visita prima il ramo destro.

Il primo nodo incontrato a ogni profondità viene salvato.

```c
static void rightViewFill(
    IntTree tree,
    size_t depth,
    int out[],
    size_t *written
) {
    if (tree == NULL) {
        return;
    }

    if (depth == *written) {
        out[(*written)++] = tree->data;
    }

    rightViewFill(
        tree->right,
        depth + 1,
        out,
        written
    );

    rightViewFill(
        tree->left,
        depth + 1,
        out,
        written
    );
}
```

---

## Esercizio 54 — Zigzag level order

### Consegna

Visitare i livelli alternando:

```text
sinistra→destra
destra→sinistra
```

### Soluzioni

- BFS con array temporaneo per livello;
- due pile;
- deque.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(w)`

---

## Esercizio 55 — Complete binary tree

### Consegna

Verificare se l'albero è completo:

```text
tutti i livelli pieni tranne forse l'ultimo
ultimo livello riempito da sinistra
```

### Soluzione BFS

Quando si incontra il primo figlio mancante:

```text
tutti i nodi successivi devono non avere figli
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(w)`

---

# Livello 10 — Esercizi infernali

---

## Esercizio 56 — Ricostruzione da preorder e inorder

### Consegna

Dati:

```text
preorder
inorder
```

con valori distinti, ricostruire l'albero.

### Soluzione semplice

1. La prima posizione del preorder è la radice.
2. Cercala nell'inorder.
3. La parte sinistra dell'inorder è il sottoalbero sinistro.
4. La parte destra è il sottoalbero destro.

### Complessità semplice

Se si cerca linearmente la radice nell'inorder a ogni chiamata:

```text
O(n²)
```

### Soluzione ottimizzata

Costruire una mappa:

```text
valore → indice inorder
```

Tempo `O(n)` atteso con hash map.

---

## Esercizio 57 — Serializzazione e deserializzazione

### Consegna

Convertire un albero in stringa e ricostruirlo.

Bisogna rappresentare anche i figli mancanti.

Esempio preorder:

```text
"1 2 # # 3 # #"
```

### Perché servono i `#`

Senza marker per i `NULL`, alberi diversi possono produrre la stessa sequenza di valori.

### Punti difficili

- parsing;
- memoria dinamica;
- cleanup su errore;
- valori negativi;
- dimensione del buffer.

---

## Esercizio 58 — Largest BST subtree

### Consegna

Dato un albero binario generico, trovare la dimensione del più grande sottoalbero che è un BST.

### Idea bottom-up

Per ogni nodo restituire una struct:

```c
typedef struct {
    _Bool isBst;
    size_t size;
    int minValue;
    int maxValue;
    size_t best;
} BstInfo;
```

Combinare le informazioni dei figli in `O(1)`.

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 59 — Recover swapped BST

### Consegna

In un BST due valori sono stati scambiati.

Ripristinare il BST senza cambiare la struttura.

### Idea

Durante inorder, la sequenza dovrebbe essere crescente.

Individuare le inversioni:

```text
previous > current
```

- prima violazione: primo nodo errato = previous;
- ogni violazione: secondo nodo errato = current.

Alla fine scambiare i due valori.

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)` con ricorsione.

---

## Esercizio 60 — Count complete tree nodes meglio di O(n)

### Consegna

Dato un albero completo, contare i nodi più velocemente di `O(n)`.

### Idea

Calcolare:

```text
altezza del bordo sinistro
altezza del bordo destro
```

Se coincidono, il sottoalbero è perfetto:

```text
2^h - 1
```

Altrimenti, ricorrere sui figli.

### Complessità

```text
O(log² n)
```

---

# 11. Tracce aggiuntive senza soluzione completa

## Alberi binari base

1. Conta nodi con un solo figlio.
2. Conta nodi con due figli.
3. Conta valori positivi.
4. Conta nodi pari a una certa profondità.
5. Somma delle foglie.
6. Somma delle foglie sinistre.
7. Massimo valore per livello.
8. Numero di livelli non vuoti.
9. Verifica se tutti i valori sono uguali.
10. Verifica se ogni padre è maggiore dei figli.
11. Conta nodi che hanno valore maggiore della radice.
12. Copia solo i nodi a profondità pari.
13. Elimina tutte le foglie.
14. Elimina tutti i nodi con un solo figlio.
15. Duplica ogni nodo come figlio sinistro.

## Cammini e visite

16. Restituisci il percorso verso un valore.
17. Verifica se una sequenza rappresenta un percorso radice-foglia.
18. Conta cammini con somma target non necessariamente dalla radice.
19. Massima somma root-to-leaf.
20. Minima profondità di una foglia.
21. Percorso più lungo tra radice e foglia.
22. Stampa tutti i percorsi in ordine lessicografico.
23. Conta foglie a profondità massima.
24. Trova il primo nodo preorder con proprietà.
25. Trova l'ultimo nodo inorder con proprietà.

## BST

26. Predecessore di un valore.
27. Successore di un valore.
28. Nodo più vicino a un target reale.
29. Conta valori in intervallo.
30. Elimina tutti i valori pari.
31. Unisci due BST in un BST bilanciato.
32. Intersezione tra due BST.
33. Differenza tra due BST.
34. Verifica se due BST contengono gli stessi valori.
35. Costruisci BST da preorder.
36. Costruisci BST da postorder.
37. Verifica se una sequenza può essere preorder di un BST.
38. Calcola rank di un valore.
39. Calcola mediana di un BST.
40. Trasforma BST in greater sum tree.

## Problemi classici

41. Symmetric tree.
42. Same tree.
43. Invert binary tree.
44. Path sum II.
45. Path sum III.
46. Binary tree maximum width.
47. Boundary traversal.
48. Vertical order traversal.
49. Top view.
50. Bottom view.
51. Cousins in binary tree.
52. Distance between two nodes.
53. Duplicate subtrees.
54. House robber III.
55. Binary tree cameras.

## Avanzati

56. Threaded binary tree iterator.
57. Morris inorder traversal.
58. AVL insertion.
59. AVL deletion.
60. Rotazione semplice e doppia.
61. Red-black tree invariants.
62. Trie di stringhe.
63. Segment tree.
64. Fenwick tree.
65. Expression tree.
66. Huffman tree.
67. Parse tree di espressioni.
68. N-ary tree to binary tree.
69. Persistent BST.
70. Order-statistic tree.

---

# 12. Errori tipici

## Caso base sbagliato

```c
if (tree->left == NULL &&
    tree->right == NULL)
```

senza prima controllare:

```c
tree == NULL
```

provoca dereferenziazione di `NULL`.

## Dimenticare una branca

```c
return f(tree->left);
```

quando la specifica richiede entrambi i sottoalberi.

## Altezza definita in modo incoerente

Prima dell'esercizio chiarire:

```text
altezza vuoto = 0 oppure -1?
altezza foglia = 1 oppure 0?
```

## Validazione BST locale

Controllare soltanto i figli immediati non basta.

## Distruzione preorder

```c
free(tree);
treeDestroy(&tree->left);
```

è use-after-free.

## Rimozione BST con due figli

Non perdere uno dei due sottoalberi.

## Copia parziale su malloc fallita

Bisogna distruggere tutto ciò che è già stato allocato.

## Ricorsione O(n²) nascosta

Esempi:

```text
isBalanced + height ricalcolata
diameter + height ricalcolata
largest BST + validazione completa ripetuta
```

## Assunzione BST usata su albero generico

Ricerca solo a sinistra o destra è corretta soltanto se la proprietà BST è garantita.

---

# 13. Checklist di test

## Strutture minime

- [ ] albero vuoto;
- [ ] sola radice;
- [ ] solo figlio sinistro;
- [ ] solo figlio destro;
- [ ] catena degenerata;
- [ ] albero perfetto;
- [ ] albero sbilanciato.

## Valori

- [ ] negativi;
- [ ] zero;
- [ ] tutti uguali, se il tipo di albero lo consente;
- [ ] valori min/max di `int`;
- [ ] target assente;
- [ ] target in radice;
- [ ] target in foglia.

## BST

- [ ] inserimento in albero vuoto;
- [ ] duplicato;
- [ ] rimozione foglia;
- [ ] rimozione con un figlio;
- [ ] rimozione con due figli;
- [ ] rimozione della radice;
- [ ] rimozione assente;
- [ ] BST degenerato;
- [ ] BST bilanciato.

## Memoria

- [ ] destroy su `NULL`;
- [ ] destroy due volte;
- [ ] clone indipendente;
- [ ] cleanup su malloc fallita;
- [ ] nessun nodo perso dopo rimozione.

---

# 14. Ordine consigliato di allenamento

## Fase 1 — Ricorsione strutturale

```text
1–10
```

Obiettivo:

- caso base;
- due sottoalberi;
- combinazione dei risultati.

## Fase 2 — Proprietà

```text
11–18
```

Obiettivo:

- distinguere proprietà locali e globali;
- evitare ricomputazioni.

## Fase 3 — Visite e cammini

```text
19–30
```

Obiettivo:

- padroneggiare preorder/inorder/postorder;
- produrre array, liste e percorsi.

## Fase 4 — BST base

```text
31–39
```

Obiettivo:

- sfruttare ordinamento;
- puntatore a puntatore;
- tre casi della rimozione.

## Fase 5 — BST avanzati

```text
40–48
```

Obiettivo:

- validazione globale;
- inorder ordinato;
- bilanciamento e trasformazioni.

## Fase 6 — Appelli infernali

```text
49–60
```

Obiettivo:

- risultati multipli per chiamata;
- algoritmi bottom-up;
- memoria dinamica;
- complessità lineare contro quadratica.

---

# 15. Scheda universale

```text
TIPO DI ALBERO:
binario generico / BST

CASO VUOTO:
____________________________________

RISULTATO DEL SOTTOALBERO SINISTRO:
____________________________________

RISULTATO DEL SOTTOALBERO DESTRO:
____________________________________

CONTRIBUTO DELLA RADICE:
____________________________________

COME COMBINO:
____________________________________

VISITA:
pre / in / post / livelli

POSSO POTARE UN RAMO?
____________________________________

DEVO MODIFICARE L'ALBERO?
____________________________________

DEVO ALLOCARE NUOVI NODI?
____________________________________

OWNERSHIP:
____________________________________

ALTEZZA MASSIMA:
____________________________________

TEMPO:
____________________________________

STACK:
____________________________________

CASI LIMITE:
____________________________________
```

La domanda decisiva è:

> “Il risultato del nodo corrente dipende da entrambi i sottoalberi o posso sfruttare una proprietà per sceglierne uno solo?”

Negli alberi binari generici, spesso bisogna visitare tutto.

Nei BST, spesso si può potare metà del problema.

La seconda domanda decisiva è:

> “Sto ricalcolando più volte la stessa informazione?”

Quando altezza, minimo, massimo, validità o dimensione vengono ricalcolati per ogni nodo, una soluzione apparentemente semplice può diventare `O(n²)`.

Molti esercizi difficili diventano lineari quando ogni chiamata restituisce tutte le informazioni utili al padre in una sola struct.
