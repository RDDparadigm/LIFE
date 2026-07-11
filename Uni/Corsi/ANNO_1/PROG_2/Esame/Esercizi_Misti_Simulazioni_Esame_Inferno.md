# Programmazione 2 — Esercizi misti e simulazioni d’esame “modalità inferno”

> Obiettivo: arrivare all’esame avendo già affrontato problemi più lunghi, più ibridi e più infidi di quelli normalmente assegnati.
>
> Questa raccolta non è divisa per singolo argomento. Ogni esercizio combina più competenze:
>
> - array e stringhe;
> - memoria dinamica;
> - liste linkate;
> - pile, code e deque;
> - insiemi;
> - ricorsione;
> - alberi binari e BST;
> - ADT opachi;
> - `void *` e callback;
> - file;
> - analisi della complessità;
> - testing con hidden test;
> - ownership e cleanup su errore.
>
> Struttura di ogni esercizio:
>
> ```text
> consegna
> struttura di partenza
> idea semplice
> soluzione
> complessità
> hidden test
> errori tipici
> ```
>
> La difficoltà cresce fino a simulazioni complete da affrontare a tempo.

Compilazione consigliata:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    -g -fsanitize=address,undefined file.c -o file
```

---

# 0. Regole di combattimento

## 0.1 Prima di scrivere codice

Compila mentalmente questa scheda:

```text
INPUT:
____________________________________________________

OUTPUT:
____________________________________________________

INPUT MODIFICABILE?
____________________________________________________

OUTPUT NUOVO O IN PLACE?
____________________________________________________

ORDINE DA PRESERVARE?
____________________________________________________

DUPLICATI?
____________________________________________________

OWNERSHIP:
____________________________________________________

CASI NULL / VUOTO:
____________________________________________________

STRUTTURE DA ATTRAVERSARE:
____________________________________________________

TEMPO TARGET:
____________________________________________________

SPAZIO TARGET:
____________________________________________________
```

## 0.2 Strategia in tre livelli

Per ogni esercizio:

```text
1. soluzione corretta semplice
2. analisi dei costi
3. ottimizzazione soltanto se utile o richiesta
```

## 0.3 Errori che gli hidden test cercano

```text
NULL
input vuoto
un solo elemento
tutti gli elementi selezionati
nessun elemento selezionato
duplicati
ordine invertito
input modificato per errore
ultimo nodo non gestito
rear dangling
mancato terminatore '\0'
malloc fallita
cleanup parziale
double free
use-after-free
complessità quadratica accidentale
```

---

# 1. Tipi di supporto

```c
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

typedef struct intNode IntNode;
typedef IntNode *IntList;

struct intNode {
    int data;
    IntList next;
};

typedef struct treeNode TreeNode;
typedef TreeNode *IntTree;

struct treeNode {
    IntTree left;
    int data;
    IntTree right;
};

typedef struct {
    int *data;
    size_t size;
} IntArray;

typedef struct {
    char **data;
    size_t size;
} StringArray;
```

Distruzione lista:

```c
#include <stdlib.h>

void listDestroy(IntList *listPtr) {
    if (listPtr == NULL) {
        return;
    }

    while (*listPtr != NULL) {
        IntList victim = *listPtr;
        *listPtr = victim->next;
        free(victim);
    }
}
```

Distruzione albero:

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

---

# Livello 1 — Mischiati ma ancora umani

---

## Esercizio 1 — Stringa → lista filtrata → inversione

### Consegna

Data una stringa `s`, costruire una nuova lista contenente i codici ASCII dei caratteri alfabetici minuscoli presenti in `s`, nello stesso ordine.

Poi invertire la lista **in place**, senza nuove allocazioni.

Se `s == NULL`, restituire `NULL`.

Esempio:

```text
"Abc1dE" → [98,99,100] → [100,99,98]
```

### Struttura di partenza

```c
IntList lowercaseCodesReversed(const char *s);
```

### Idea semplice

1. Costruisci la lista preservando l’ordine con `tail`.
2. Inverti con tre puntatori:
   - `previous`;
   - `current`;
   - `next`.

### Soluzione

```c
IntList lowercaseCodesReversed(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    IntList head = NULL;
    IntList tail = NULL;

    for (size_t i = 0; s[i] != '\0'; i++) {
        if (s[i] >= 'a' && s[i] <= 'z') {
            IntList node = malloc(sizeof(*node));

            if (node == NULL) {
                listDestroy(&head);
                return NULL;
            }

            node->data = (unsigned char)s[i];
            node->next = NULL;

            if (tail == NULL) {
                head = node;
            } else {
                tail->next = node;
            }

            tail = node;
        }
    }

    IntList previous = NULL;
    IntList current = head;

    while (current != NULL) {
        IntList next = current->next;
        current->next = previous;
        previous = current;
        current = next;
    }

    return previous;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio heap: `O(k)`
- Spazio ausiliario: `O(1)`

### Hidden test

- `NULL`;
- stringa vuota;
- nessuna minuscola;
- tutte minuscole;
- una sola minuscola;
- fallimento dopo alcune allocazioni.

---

## Esercizio 2 — Due liste → array delle differenze

### Consegna

Date due liste, costruire un array contenente:

```text
abs(a[i] - b[i])
```

per tutte le posizioni in cui entrambe le liste hanno un nodo.

Se una lista è più lunga, ignorare il resto.

### Struttura

```c
IntArray pairwiseAbsoluteDifference(
    IntList a,
    IntList b
);
```

### Soluzione semplice

Prima conta la lunghezza minima, poi alloca.

```c
static size_t commonLength(
    IntList a,
    IntList b
) {
    size_t count = 0;

    while (a != NULL && b != NULL) {
        count++;
        a = a->next;
        b = b->next;
    }

    return count;
}

IntArray pairwiseAbsoluteDifference(
    IntList a,
    IntList b
) {
    IntArray result = {NULL, 0};

    size_t n = commonLength(a, b);

    if (n == 0) {
        return result;
    }

    result.data = malloc(n * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    for (size_t i = 0; i < n; i++) {
        long long difference =
            (long long)a->data - b->data;

        if (difference < 0) {
            difference = -difference;
        }

        result.data[i] = (int)difference;

        a = a->next;
        b = b->next;
    }

    result.size = n;
    return result;
}
```

### Complessità

- Tempo: `O(min(n,m))`
- Spazio: `O(min(n,m))`

---

## Esercizio 3 — Lista → set ordinato

### Consegna

Data una lista non ordinata con possibili duplicati, restituire un nuovo array ordinato crescente contenente ogni valore una sola volta.

Non modificare la lista.

### Soluzione semplice

1. Copia tutti i valori in array.
2. `qsort`.
3. Compatta duplicati.

```c
static int compareInt(
    const void *a,
    const void *b
) {
    int x = *(const int *)a;
    int y = *(const int *)b;

    return (x > y) - (x < y);
}

IntArray listToSortedSet(IntList list) {
    IntArray result = {NULL, 0};

    size_t n = 0;

    for (IntList p = list; p != NULL; p = p->next) {
        n++;
    }

    if (n == 0) {
        return result;
    }

    int *data = malloc(n * sizeof(*data));

    if (data == NULL) {
        return result;
    }

    size_t i = 0;

    for (IntList p = list; p != NULL; p = p->next) {
        data[i++] = p->data;
    }

    qsort(data, n, sizeof(*data), compareInt);

    size_t write = 1;

    for (size_t read = 1; read < n; read++) {
        if (data[read] != data[write - 1]) {
            data[write++] = data[read];
        }
    }

    int *tmp = realloc(data, write * sizeof(*tmp));

    if (tmp != NULL) {
        data = tmp;
    }

    result.data = data;
    result.size = write;

    return result;
}
```

### Complessità

- Tempo: `O(n log n)`
- Spazio: `O(n)`

---

## Esercizio 4 — Array → BST → inorder

### Consegna

Dato un array, costruire un BST ignorando i duplicati e restituire un nuovo array con la visita inorder.

### Struttura

```c
IntArray sortedUniqueThroughBst(
    const int a[],
    size_t n
);
```

### Soluzione semplice

```c
static int bstInsertSimple(
    IntTree *treePtr,
    int value
) {
    while (*treePtr != NULL) {
        if (value == (*treePtr)->data) {
            return 1;
        }

        treePtr =
            value < (*treePtr)->data
            ? &(*treePtr)->left
            : &(*treePtr)->right;
    }

    IntTree node = malloc(sizeof(*node));

    if (node == NULL) {
        return 0;
    }

    node->left = NULL;
    node->right = NULL;
    node->data = value;

    *treePtr = node;
    return 1;
}

static size_t treeSizeLocal(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    return 1 +
           treeSizeLocal(tree->left) +
           treeSizeLocal(tree->right);
}

static void inorderFillLocal(
    IntTree tree,
    int out[],
    size_t *index
) {
    if (tree == NULL) {
        return;
    }

    inorderFillLocal(tree->left, out, index);
    out[(*index)++] = tree->data;
    inorderFillLocal(tree->right, out, index);
}

IntArray sortedUniqueThroughBst(
    const int a[],
    size_t n
) {
    IntArray result = {NULL, 0};
    IntTree tree = NULL;

    for (size_t i = 0; i < n; i++) {
        if (!bstInsertSimple(&tree, a[i])) {
            treeDestroy(&tree);
            return result;
        }
    }

    size_t size = treeSizeLocal(tree);

    if (size > 0) {
        result.data =
            malloc(size * sizeof(*result.data));

        if (result.data == NULL) {
            treeDestroy(&tree);
            return result;
        }

        size_t index = 0;
        inorderFillLocal(
            tree,
            result.data,
            &index
        );

        result.size = size;
    }

    treeDestroy(&tree);
    return result;
}
```

### Complessità

- Media: `O(n log n)`
- Peggiore: `O(n²)` con BST degenerato
- Spazio: `O(n)`

---

## Esercizio 5 — Albero → lista delle foglie da sinistra a destra

### Consegna

Restituire una nuova lista contenente i valori delle foglie in ordine da sinistra a destra.

### Soluzione

```c
static int appendListValue(
    IntList *head,
    IntList *tail,
    int value
) {
    IntList node = malloc(sizeof(*node));

    if (node == NULL) {
        return 0;
    }

    node->data = value;
    node->next = NULL;

    if (*tail == NULL) {
        *head = node;
    } else {
        (*tail)->next = node;
    }

    *tail = node;
    return 1;
}

static int leavesFill(
    IntTree tree,
    IntList *head,
    IntList *tail
) {
    if (tree == NULL) {
        return 1;
    }

    if (
        tree->left == NULL &&
        tree->right == NULL
    ) {
        return appendListValue(
            head,
            tail,
            tree->data
        );
    }

    return
        leavesFill(tree->left, head, tail) &&
        leavesFill(tree->right, head, tail);
}

IntList treeLeavesList(IntTree tree) {
    IntList head = NULL;
    IntList tail = NULL;

    if (!leavesFill(tree, &head, &tail)) {
        listDestroy(&head);
        return NULL;
    }

    return head;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio output: `O(f)`
- Stack: `O(h)`

---

## Esercizio 6 — File di interi → lista senza duplicati consecutivi

### Consegna

Il file contiene interi separati da whitespace.

Restituire una lista che elimini soltanto i duplicati consecutivi.

Esempio:

```text
1 1 1 4 4 2 1 1
→ [1,4,2,1]
```

### Soluzione

```c
IntList loadRunsFromFile(
    const char *path
) {
    if (path == NULL) {
        return NULL;
    }

    FILE *file = fopen(path, "r");

    if (file == NULL) {
        return NULL;
    }

    IntList head = NULL;
    IntList tail = NULL;

    int value;
    int previous = 0;
    int hasPrevious = 0;
    int scanResult;

    while (
        (scanResult = fscanf(file, "%d", &value))
        == 1
    ) {
        if (!hasPrevious || value != previous) {
            if (!appendListValue(
                    &head,
                    &tail,
                    value
                )) {
                listDestroy(&head);
                fclose(file);
                return NULL;
            }

            previous = value;
            hasPrevious = 1;
        }
    }

    if (scanResult != EOF || ferror(file)) {
        listDestroy(&head);
    }

    if (fclose(file) == EOF) {
        listDestroy(&head);
    }

    return head;
}
```

---

# Livello 2 — Trasformazioni tra strutture

---

## Esercizio 7 — Lista ordinata → BST bilanciato

### Consegna

Data una lista ordinata crescente senza duplicati, costruire un BST bilanciato in `O(n)`.

Non convertire prima in array.

### Idea

Costruzione inorder simulata:

1. costruisci ricorsivamente il sottoalbero sinistro di `n/2` nodi;
2. usa il nodo corrente della lista come radice;
3. avanza la lista;
4. costruisci il sottoalbero destro.

### Soluzione

```c
static IntTree sortedListToBstAux(
    IntList *current,
    size_t n,
    int *success
) {
    if (n == 0 || !*success) {
        return NULL;
    }

    size_t leftSize = n / 2;

    IntTree left =
        sortedListToBstAux(
            current,
            leftSize,
            success
        );

    if (!*success) {
        treeDestroy(&left);
        return NULL;
    }

    IntTree root = malloc(sizeof(*root));

    if (root == NULL) {
        *success = 0;
        treeDestroy(&left);
        return NULL;
    }

    root->left = left;
    root->data = (*current)->data;
    root->right = NULL;

    *current = (*current)->next;

    root->right =
        sortedListToBstAux(
            current,
            n - leftSize - 1,
            success
        );

    if (!*success) {
        treeDestroy(&root);
        return NULL;
    }

    return root;
}

IntTree sortedListToBalancedBst(
    IntList list
) {
    size_t n = 0;

    for (IntList p = list; p != NULL; p = p->next) {
        n++;
    }

    int success = 1;
    IntList current = list;

    return sortedListToBstAux(
        &current,
        n,
        &success
    );
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(log n)` per albero bilanciato
- Spazio heap: `O(n)`

---

## Esercizio 8 — BST → lista doppiamente linkata ordinata in place

### Consegna

Riutilizzare i nodi di un BST per creare una lista doppiamente linkata ordinata.

Interpretare:

```text
left  = prev
right = next
```

Nessuna nuova allocazione.

### Struttura

```c
void bstToDoublyList(
    IntTree tree,
    IntTree *head,
    IntTree *tail
);
```

### Soluzione

```c
void bstToDoublyList(
    IntTree tree,
    IntTree *head,
    IntTree *tail
) {
    if (tree == NULL) {
        return;
    }

    IntTree originalLeft = tree->left;
    IntTree originalRight = tree->right;

    bstToDoublyList(
        originalLeft,
        head,
        tail
    );

    tree->left = *tail;
    tree->right = NULL;

    if (*tail == NULL) {
        *head = tree;
    } else {
        (*tail)->right = tree;
    }

    *tail = tree;

    bstToDoublyList(
        originalRight,
        head,
        tail
    );
}
```

### Punto difficilissimo

Bisogna salvare i figli originali prima di riutilizzare i campi `left` e `right`.

---

## Esercizio 9 — Lista di interi → albero completo per livelli

### Consegna

Usare i valori della lista per costruire un albero binario completo in ordine BFS.

Esempio:

```text
[1,2,3,4,5]
→
    1
   / \
  2   3
 / \
4   5
```

### Soluzione semplice con array di puntatori

1. Conta nodi.
2. Alloca array di `IntTree`.
3. Crea tutti i nodi.
4. Per ogni indice `i`:
   - sinistro `2i+1`;
   - destro `2i+2`.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 10 — Albero → array dei livelli in zigzag

### Consegna

Restituire i valori per livelli alternando il verso.

### Idea semplice

BFS con:

- coda di nodi;
- buffer temporaneo per ogni livello;
- scrittura normale o inversa.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(w)`

---

## Esercizio 11 — Due BST → intersezione ordinata

### Consegna

Restituire un array ordinato con i valori presenti in entrambi i BST.

### Soluzione semplice

1. Inorder del primo in array.
2. Inorder del secondo in array.
3. Intersezione con due cursori.

### Complessità

- Tempo: `O(n+m)`
- Spazio: `O(n+m)`

### Soluzione elegante

Due iteratori inorder con pile, senza salvare tutti i valori:

```text
spazio O(h1+h2)
```

---

## Esercizio 12 — Albero generico → set dei valori a profondità pari

### Consegna

Restituire un array ordinato senza duplicati dei valori presenti a profondità pari.

### Soluzione semplice

1. Visita e raccogli valori in array dinamico.
2. Ordina.
3. Compatta.

### Complessità

- Tempo: `O(n log n)`
- Spazio: `O(n)`

---

# Livello 3 — Ownership e memoria: qui iniziano le trappole vere

---

## Esercizio 13 — Lista di stringhe owned: filtro profondo

### Struttura

```c
typedef struct stringNode StringNode;
typedef StringNode *StringList;

struct stringNode {
    char *data;
    StringList next;
};
```

### Consegna

Restituire una nuova lista contenente copie profonde delle stringhe la cui lunghezza è almeno `minLength`.

L'input non deve essere modificato.

### Soluzione

```c
#include <string.h>

static void stringListDestroy(
    StringList *listPtr
) {
    while (
        listPtr != NULL &&
        *listPtr != NULL
    ) {
        StringList victim = *listPtr;
        *listPtr = victim->next;

        free(victim->data);
        free(victim);
    }
}

StringList stringListFilterMinLength(
    StringList list,
    size_t minLength
) {
    StringList head = NULL;
    StringList tail = NULL;

    for (
        StringList p = list;
        p != NULL;
        p = p->next
    ) {
        size_t length = strlen(p->data);

        if (length < minLength) {
            continue;
        }

        StringList node = malloc(sizeof(*node));

        if (node == NULL) {
            stringListDestroy(&head);
            return NULL;
        }

        node->data = malloc(length + 1);

        if (node->data == NULL) {
            free(node);
            stringListDestroy(&head);
            return NULL;
        }

        memcpy(node->data, p->data, length + 1);
        node->next = NULL;

        if (tail == NULL) {
            head = node;
        } else {
            tail->next = node;
        }

        tail = node;
    }

    return head;
}
```

### Hidden test

Modificare una stringa nell'input dopo la chiamata non deve cambiare l'output.

---

## Esercizio 14 — Sposta nodi tra due liste senza allocare

### Consegna

Date due liste:

- spostare da `source` a `destination` tutti i nodi con valore pari;
- preservare l'ordine relativo sia dei nodi spostati sia di quelli rimasti;
- non allocare e non liberare nodi.

### Soluzione

```c
void moveEvenNodes(
    IntList *source,
    IntList *destination
) {
    if (
        source == NULL ||
        destination == NULL
    ) {
        return;
    }

    IntList movedHead = NULL;
    IntList movedTail = NULL;

    IntList keptHead = NULL;
    IntList keptTail = NULL;

    IntList current = *source;

    while (current != NULL) {
        IntList next = current->next;
        current->next = NULL;

        if (current->data % 2 == 0) {
            if (movedTail == NULL) {
                movedHead = current;
            } else {
                movedTail->next = current;
            }

            movedTail = current;
        } else {
            if (keptTail == NULL) {
                keptHead = current;
            } else {
                keptTail->next = current;
            }

            keptTail = current;
        }

        current = next;
    }

    *source = keptHead;

    if (*destination == NULL) {
        *destination = movedHead;
    } else {
        IntList tail = *destination;

        while (tail->next != NULL) {
            tail = tail->next;
        }

        tail->next = movedHead;
    }
}
```

### Complessità

Questa versione cerca la coda di `destination` in `O(m)`.

Se il wrapper della lista conserva `tail`, tutto diventa `O(n)`.

---

## Esercizio 15 — Merge di liste owned con fallimento atomico

### Consegna

Date due liste immutabili, creare una nuova lista alternando copie dei nodi:

```text
a1,b1,a2,b2,...
```

Se una malloc fallisce:

```text
nessun input modificato
nessuna perdita di memoria
ritorno NULL
```

### Soluzione

Classico tail pointer e cleanup completo.

### Hidden test

Liste di lunghezze diverse.

---

## Esercizio 16 — Copia di albero con filtro strutturale

### Consegna

Restituire una nuova copia dell'albero contenente soltanto i nodi con valore non negativo.

Se un nodo è negativo:

- non viene copiato;
- i suoi sottoalberi vengono promossi?

La specifica definisce:

```text
se il nodo è negativo, l'intero suo sottoalbero viene scartato
```

### Soluzione

```c
IntTree copyNonNegativeSubtrees(
    IntTree tree
) {
    if (tree == NULL || tree->data < 0) {
        return NULL;
    }

    IntTree copy = malloc(sizeof(*copy));

    if (copy == NULL) {
        return NULL;
    }

    copy->data = tree->data;
    copy->left = NULL;
    copy->right = NULL;

    copy->left =
        copyNonNegativeSubtrees(tree->left);

    if (
        tree->left != NULL &&
        tree->left->data >= 0 &&
        copy->left == NULL
    ) {
        free(copy);
        return NULL;
    }

    copy->right =
        copyNonNegativeSubtrees(tree->right);

    if (
        tree->right != NULL &&
        tree->right->data >= 0 &&
        copy->right == NULL
    ) {
        treeDestroy(&copy->left);
        free(copy);
        return NULL;
    }

    return copy;
}
```

### Nota

Il rilevamento di malloc fallita è più difficile quando `NULL` può anche essere un risultato semanticamente valido. Una soluzione robusta usa un parametro `success`.

---

# Livello 4 — Callback, generici e strutture ibride

---

## Esercizio 17 — Generic list filter-map

### Consegna

Data una lista generica borrowed, costruire una nuova lista owned:

1. selezionando con `predicate`;
2. trasformando con `map`;
3. distruggendo con `destroy`.

### Tipi

```c
typedef _Bool (*PredicateFn)(
    const void *element,
    const void *context
);

typedef void *(*MapFn)(
    const void *element,
    const void *context
);

typedef void (*DestroyFn)(void *);
```

### Struttura

```c
typedef struct genericNode GenericNode;

struct genericNode {
    void *data;
    GenericNode *next;
};
```

### Soluzione

```c
GenericNode *filterMapList(
    const GenericNode *source,
    PredicateFn predicate,
    MapFn map,
    DestroyFn destroy,
    const void *context
) {
    if (
        predicate == NULL ||
        map == NULL ||
        destroy == NULL
    ) {
        return NULL;
    }

    GenericNode *head = NULL;
    GenericNode *tail = NULL;

    for (
        const GenericNode *p = source;
        p != NULL;
        p = p->next
    ) {
        if (!predicate(p->data, context)) {
            continue;
        }

        void *mapped = map(p->data, context);

        if (mapped == NULL) {
            while (head != NULL) {
                GenericNode *victim = head;
                head = head->next;
                destroy(victim->data);
                free(victim);
            }

            return NULL;
        }

        GenericNode *node = malloc(sizeof(*node));

        if (node == NULL) {
            destroy(mapped);

            while (head != NULL) {
                GenericNode *victim = head;
                head = head->next;
                destroy(victim->data);
                free(victim);
            }

            return NULL;
        }

        node->data = mapped;
        node->next = NULL;

        if (tail == NULL) {
            head = node;
        } else {
            tail->next = node;
        }

        tail = node;
    }

    return head;
}
```

---

## Esercizio 18 — Generic BST → array borrowed ordinato

### Consegna

Un BST generico conserva puntatori owned.

Restituire un array di puntatori borrowed in ordine crescente.

Il risultato non clona gli elementi.

### Ownership

- array di puntatori: owned dal chiamante;
- elementi puntati: owned dal BST;
- se il BST viene distrutto, tutti i puntatori diventano invalidi.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 19 — Priority queue di processi con callback

### Struttura

```c
typedef struct {
    int id;
    int priority;
    unsigned long long arrival;
} Process;
```

### Consegna

Ordinare per:

1. priorità maggiore;
2. arrivo minore;
3. ID minore.

### Comparatore

```c
int compareProcessPriority(
    const void *a,
    const void *b
) {
    const Process *pa = a;
    const Process *pb = b;

    if (pa->priority != pb->priority) {
        return
            (pa->priority > pb->priority)
            ? 1
            : -1;
    }

    if (pa->arrival != pb->arrival) {
        return
            pa->arrival < pb->arrival
            ? 1
            : -1;
    }

    return
        pa->id < pb->id
        ? 1
        : pa->id > pb->id
          ? -1
          : 0;
}
```

### Punto d'esame

Il significato del segno dipende dal contratto della priority queue.

---

## Esercizio 20 — Set generico di stringhe letto da file

### Consegna

Leggere un file di parole e costruire un set generico owned di stringhe, case-insensitive.

### Callback necessarie

```text
clone string
destroy string
equal case-insensitive
```

### Hidden test

```text
"Casa"
"casa"
"CASA"
```

devono diventare un solo elemento.

---

# Livello 5 — File + strutture dinamiche

---

## Esercizio 21 — File → BST con statistiche

### Consegna

Il file contiene interi.

Costruire un BST ignorando duplicati e restituire:

```c
typedef struct {
    IntTree tree;
    size_t readValues;
    size_t distinctValues;
    size_t duplicates;
} BstLoadResult;
```

Su token invalido:

- distruggere l'albero;
- restituire struttura vuota.

### Soluzione

Usare una `bstInsert` che distingua:

```text
INSERTED
DUPLICATE
OUT_OF_MEMORY
```

### Complessità

- Media: `O(n log n)`
- Peggiore: `O(n²)`

---

## Esercizio 22 — File di righe → lista ordinata unica

### Consegna

Leggere righe arbitrarie, rimuovere whitespace iniziale/finale, ignorare righe vuote e costruire una lista ordinata senza duplicati case-sensitive.

### Strategie

### Semplice

- inserimento ordinato diretto in lista;
- costo peggiore `O(n²)`.

### Migliore

- carica array di stringhe;
- ordina con `qsort`;
- elimina duplicati;
- costruisci lista.

---

## Esercizio 23 — Serializza lista di stringhe

### Formato

```text
uint64_t count
per ogni stringa:
    uint32_t length
    length byte
```

### Consegna

Implementare salvataggio e caricamento.

### Hidden test

- stringa vuota;
- lista vuota;
- file troncato;
- lunghezza enorme malformata;
- malloc fallita a metà.

---

## Esercizio 24 — Unisci due archivi ordinati in BST bilanciato

### Consegna

Due file contengono interi ordinati senza duplicati.

Produrre un BST bilanciato con l'unione.

### Soluzione semplice

1. Merge in array dinamico.
2. Costruzione bilanciata dal centro.

### Complessità

- Tempo: `O(n+m)`
- Spazio: `O(n+m)`

### Variante avanzata

Costruzione streaming senza salvare tutto richiede conoscere prima il numero di elementi distinti e fare due passaggi.

---

# Livello 6 — Algoritmi misti duri

---

## Esercizio 25 — Lista: longest distinct suffix

### Consegna

Data una lista, restituire una nuova lista contenente il più lungo suffisso senza valori duplicati.

Esempio:

```text
[1,2,3,2,4,5]
→ [3,2,4,5]
```

Perché:

- `[3,2,4,5]` è senza duplicati;
- qualunque suffisso più lungo contiene due `2`.

### Soluzione semplice `O(n²)`

Per ogni possibile inizio, verifica duplicati.

### Soluzione migliore

1. Converti in array.
2. Scorri da destra con set/hash.
3. Fermati al primo duplicato.
4. Costruisci lista dal punto trovato.

---

## Esercizio 26 — Albero: distanza tra foglie più vicine

### Consegna

Restituire il numero minimo di archi tra due foglie distinte.

### Idea bottom-up

Per ogni nodo restituisci:

```c
typedef struct {
    size_t nearestLeafDepth;
    size_t bestDistance;
    size_t leafCount;
} LeafDistanceInfo;
```

Combina i figli.

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 27 — BST: coppie con somma target

### Consegna

Restituire tutte le coppie distinte di valori del BST con somma `target`, ordinate per primo valore crescente.

### Soluzione semplice

1. Inorder in array.
2. Due indici `left`, `right`.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

### Soluzione elegante

Due iteratori BST:

- inorder crescente;
- reverse inorder decrescente.

Spazio `O(h)`.

---

## Esercizio 28 — Albero + pila: preorder iterativo filtrato

### Consegna

Restituire un array dei soli valori positivi visitati in preorder, senza ricorsione.

### Strategia

Pila di nodi:

```text
push radice
pop
visita
push destro
push sinistro
```

Per preservare preorder, il destro va inserito prima del sinistro.

---

## Esercizio 29 — Deque + array: finestra minima con massimo-minimo ≤ limit

### Consegna

Dato un array, trovare la lunghezza massima di una finestra contigua tale che:

```text
max - min <= limit
```

### Soluzione ottimizzata

Due deque monotone:

```text
maxDeque decrescente
minDeque crescente
```

Quando il vincolo è violato, avanza `left`.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 30 — Lista + stack: next greater value

### Consegna

Per ogni nodo della lista, costruire un array con il primo valore successivo maggiore, oppure `-1`.

### Soluzione

1. Converti valori in array.
2. Pila monotona di indici.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 31 — Albero: massimo BST contenuto

### Consegna

Dato un albero binario generico, restituire la dimensione del più grande sottoalbero che è un BST.

### Soluzione bottom-up

```c
typedef struct {
    _Bool isBst;
    size_t size;
    size_t best;
    int minValue;
    int maxValue;
} BstInfo;
```

Caso `NULL`:

```text
isBst = true
size = 0
best = 0
min = +∞ concettuale
max = -∞ concettuale
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(h)`

---

## Esercizio 32 — File enorme: top-k numeri più frequenti

### Consegna

Trovare i `k` interi più frequenti.

### Soluzione semplice

Se entra in memoria:

- hash map frequenze;
- min-heap di dimensione `k`.

### Variante senza hash disponibile nel corso

- carica;
- ordina;
- conta run;
- heap o ordinamento delle frequenze.

### Complessità

- `O(n log n)` senza hash.

---

# Livello 7 — Problemi volutamente bastardi

---

## Esercizio 33 — Anti-path tra due alberi

### Consegna

Dati due alberi binari `a` e `b`, costruire una lista partendo dalle radici.

A ogni passo:

- se entrambi i nodi esistono e hanno valore diverso, aggiungi `a->data`;
- se i valori sono uguali, termina;
- se `a` esiste e `b == NULL`, continua solo in `a`;
- la direzione successiva in `a` è:
  - sinistra se `a->data` dispari;
  - destra se pari;
- la direzione successiva in `b` è opposta:
  - destra se `b->data` dispari;
  - sinistra se pari.

### Soluzione

Iterazione su due puntatori, tail pointer per output.

### Hidden test

- radici uguali;
- `a == NULL`;
- `b == NULL`;
- uno dei due termina prima;
- malloc fallita.

---

## Esercizio 34 — Lista di liste: flatten alternato

### Struttura

```c
typedef struct listOfListsNode ListOfListsNode;

struct listOfListsNode {
    IntList list;
    ListOfListsNode *next;
};
```

### Consegna

Costruire una nuova lista prendendo:

```text
1° elemento da ogni lista
2° elemento da ogni lista
3° elemento da ogni lista
...
```

Esempio:

```text
[1,2,3]
[10,20]
[100,200,300,400]

→ [1,10,100,2,20,200,3,300,400]
```

### Soluzione semplice

Ripeti livelli finché almeno una lista ha ancora nodi.

### Complessità

Se a ogni livello riparti dalla testa delle sottoliste, può diventare inefficiente.

Soluzione corretta:

- array di cursori, uno per sottolista.

---

## Esercizio 35 — BST persistente semplificato

### Consegna

Implementare inserimento che restituisce una nuova radice senza modificare il BST originale.

I sottoalberi non coinvolti possono essere condivisi.

### Problema di ownership

Se si condividono nodi, la distruzione semplice causa double free.

### Soluzioni

- reference counting;
- nessuna distruzione finché tutte le versioni esistono;
- deep copy completa, più semplice ma `O(n)` per inserimento.

### Obiettivo

Capire che la condivisione strutturale cambia radicalmente l'ownership.

---

## Esercizio 36 — Tree diff

### Consegna

Dati due alberi con stessa forma, restituire una lista preorder dei soli valori che differiscono, codificati come:

```text
aValue, bValue, aValue, bValue, ...
```

Se la forma differisce, restituire `NULL` e segnalare errore tramite parametro.

### Soluzione

Ricorsione parallela con:

```text
entrambi NULL → ok
uno NULL → shape mismatch
entrambi nodi → confronta e ricorri
```

---

## Esercizio 37 — Intersezione stabile di tre liste

### Consegna

Date tre liste, restituire una nuova lista con i valori che compaiono in tutte e tre, una sola volta, nell'ordine della prima occorrenza nella prima lista.

### Soluzione semplice

Per ogni elemento della prima:

- se non già prodotto;
- cerca nella seconda;
- cerca nella terza.

### Complessità

- `O(n(n+m+k))` circa.

### Soluzione migliore

Set/hash per membership e output.

---

## Esercizio 38 — Parser di espressione → albero → valutazione

### Consegna

Un file contiene un'espressione postfix con interi e operatori `+ - * /`.

Costruire un expression tree usando una pila di alberi e valutarlo.

### Strategia

- numero → crea foglia e push;
- operatore → pop destro, pop sinistro, crea nodo e push;
- alla fine deve restare un solo albero.

### Hidden test

- operatori insufficienti;
- operandi in eccesso;
- divisione per zero;
- malloc fallita;
- token invalido.

---

# 8. Simulazioni complete d’esame

Ogni simulazione contiene tre esercizi:

```text
E1: trasformazione lineare o su lista
E2: ricorsione/albero
E3: problema misto o ottimizzato
```

Tempo consigliato:

```text
analisi: 15 min
codice: 90–120 min
test: 20 min
```

---

# Simulazione 1 — “Ti sembrava facile”

---

## E1 — `alternatingFilter`

### Consegna

Data una lista, costruire una nuova lista contenente:

- i valori positivi alle posizioni pari;
- i valori negativi alle posizioni dispari.

La testa è in posizione `0`.

Preservare l'ordine.

### Firma

```c
IntList alternatingFilter(IntList list);
```

### Soluzione

```c
IntList alternatingFilter(IntList list) {
    IntList head = NULL;
    IntList tail = NULL;
    size_t index = 0;

    for (
        IntList p = list;
        p != NULL;
        p = p->next, index++
    ) {
        int accept =
            (index % 2 == 0 && p->data > 0) ||
            (index % 2 != 0 && p->data < 0);

        if (!accept) {
            continue;
        }

        if (!appendListValue(
                &head,
                &tail,
                p->data
            )) {
            listDestroy(&head);
            return NULL;
        }
    }

    return head;
}
```

---

## E2 — `countAlmostLeaves`

### Consegna

Contare i nodi che hanno esattamente un figlio e quel figlio è una foglia.

### Firma

```c
size_t countAlmostLeaves(IntTree tree);
```

### Soluzione

```c
static _Bool isLeaf(IntTree tree) {
    return
        tree != NULL &&
        tree->left == NULL &&
        tree->right == NULL;
}

size_t countAlmostLeaves(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    size_t current =
        (
            tree->left != NULL &&
            tree->right == NULL &&
            isLeaf(tree->left)
        ) ||
        (
            tree->right != NULL &&
            tree->left == NULL &&
            isLeaf(tree->right)
        )
        ? 1U
        : 0U;

    return current +
           countAlmostLeaves(tree->left) +
           countAlmostLeaves(tree->right);
}
```

---

## E3 — `minimumCoverList`

### Consegna

Data una lista e un array di valori distinti `required`, restituire la lunghezza minima di un segmento contiguo della lista che contenga tutti i valori richiesti.

Restituire `0` se impossibile.

### Soluzione semplice

1. Converti lista in array.
2. Sliding window con tabella/mappa delle frequenze.

### Complessità

- Con ricerca lineare nei required: `O(nk)`
- Con hash/map: `O(n)`

---

# Simulazione 2 — “Due strutture non bastavano”

---

## E1 — `mergeAntiEqual`

### Consegna

Date due liste ordinate della stessa lunghezza, costruire una nuova lista:

- se i valori sono diversi, inserire il minore;
- se sono uguali, non inserire nulla;
- avanzare sempre entrambe.

### Soluzione

Scansione parallela, tail pointer.

---

## E2 — `treeLevelParity`

### Consegna

Restituire vero se:

- a profondità pari tutti i valori sono pari;
- a profondità dispari tutti i valori sono dispari.

### Soluzione

```c
static _Bool treeLevelParityAux(
    IntTree tree,
    size_t depth
) {
    if (tree == NULL) {
        return 1;
    }

    if (
        (tree->data & 1) !=
        (int)(depth & 1)
    ) {
        return 0;
    }

    return
        treeLevelParityAux(
            tree->left,
            depth + 1
        ) &&
        treeLevelParityAux(
            tree->right,
            depth + 1
        );
}

_Bool treeLevelParity(IntTree tree) {
    return treeLevelParityAux(tree, 0);
}
```

---

## E3 — `fileToBalancedBst`

### Consegna

Il file contiene interi non ordinati con duplicati.

Costruire un BST bilanciato contenente i distinti.

### Soluzione

- carica array;
- ordina;
- compatta;
- costruisci dal centro.

### Hidden test

Token invalido → distruzione completa e fallimento.

---

# Simulazione 3 — “Memoria o morte”

---

## E1 — `deepZipStrings`

### Consegna

Date due liste di stringhe owned, costruire una nuova lista di stringhe:

```text
a[i] + ":" + b[i]
```

fino alla fine della lista più corta.

Deep copy completa.

### Punti difficili

- dimensione esatta;
- due allocazioni per nodo;
- cleanup parziale.

---

## E2 — `treeClonePruned`

### Consegna

Copiare l'albero, ma non copiare i sottoalberi la cui radice ha valore minore di una soglia.

Usare parametro `success` per distinguere:

```text
NULL valido
malloc fallita
```

### Firma

```c
IntTree treeClonePruned(
    IntTree tree,
    int threshold,
    int *success
);
```

---

## E3 — `genericStableUnique`

### Consegna

Dato un array generico, costruire una copia contenente soltanto la prima occorrenza di ogni valore, preservando l'ordine.

Callback:

```text
equal
clone element bytes oppure deep clone
destroy
```

### Complessità semplice

- `O(n²)` confronti.

### Variante ottimizzata

Hash coerente con equality.

---

# Simulazione 4 — “Ricorsione con interessi”

---

## E1 — Reverse ricorsivo a blocchi

### Consegna

Invertire una lista in blocchi di `k`.

Esempio:

```text
[1,2,3,4,5,6,7], k=3
→ [3,2,1,6,5,4,7]
```

L'ultimo blocco incompleto non viene invertito.

### Strategia

- verifica che esistano almeno `k` nodi;
- inverti il blocco;
- collega ricorsivamente il resto.

---

## E2 — `treePathProduct`

### Consegna

Contare i percorsi radice-foglia il cui prodotto dei valori è `target`.

I valori possono essere `0`.

### Trappola

Non si può sempre dividere `target` per il valore corrente, perché:

- valore zero;
- divisibilità;
- overflow.

Soluzione più semplice:

- accumulatore del prodotto;
- assumere assenza di overflow per specifica.

---

## E3 — `editDistanceFileLines`

### Consegna

Leggere la prima riga di due file e calcolare la distanza di Levenshtein.

### Difficoltà

- lettura dinamica;
- gestione file;
- memoizzazione;
- cleanup su ogni errore.

---

# Simulazione 5 — “BST e tradimenti”

---

## E1 — `bstRemoveOutsideAndList`

### Consegna

Rimuovere in place dal BST tutti i valori fuori `[low, high]` e restituire una nuova lista inorder dei valori rimasti.

### Soluzione

1. `bstTrim`.
2. Inorder con tail pointer.

---

## E2 — `isAlmostBst`

### Consegna

Verificare se un albero può diventare BST rimuovendo al massimo un nodo.

### Soluzione semplice

Per ogni nodo candidato:

- costruisci/considera albero senza quel nodo;
- valida.

Molto costosa.

### Variante avanzata

Analisi inorder con al massimo una violazione, ma la rimozione strutturale rende il problema più sottile di una semplice sequenza quasi ordinata.

---

## E3 — `twoBstTargetPair`

### Consegna

Verificare se esistono un valore in `a` e uno in `b` con somma `target`.

### Soluzione semplice

- inorder di uno in set;
- visita dell'altro e cerca `target-x`.

### Variante senza hash

- due array inorder;
- due cursori.

---

# Simulazione 6 — “File e strutture insieme”

---

## E1 — `fileRunsToList`

### Consegna

Il file contiene stringhe una per riga.

Costruire una lista di record:

```c
typedef struct {
    char *line;
    size_t repetitions;
} LineRun;
```

Ogni nodo rappresenta una run di righe consecutive uguali.

### Difficoltà

- `readLineDynamic`;
- deep copy/ownership;
- confronto;
- conteggio run;
- cleanup.

---

## E2 — `serializeBstRange`

### Consegna

Salvare in binario soltanto i valori di un BST compresi in `[low, high]`, in ordine crescente.

Formato:

```text
uint64_t count
count int32_t
```

### Soluzione

- primo passaggio conta;
- scrivi count;
- inorder con pruning BST e `fwrite`.

---

## E3 — `externalDistinctMerge`

### Consegna

Due file ordinati possono contenere duplicati interni.

Produrre l'unione ordinata senza duplicati in streaming.

### Difficoltà

- merge;
- skip delle run;
- EOF/errori distinti;
- output failure.

---

# Simulazione 7 — “Generici senza pietà”

---

## E1 — Generic queue clone

### Consegna

Clonare una coda generica owned preservando l'ordine.

Callback:

```text
clone
destroy
```

Fallimento a metà → distruzione completa del clone parziale.

---

## E2 — Generic ordered intersection

### Consegna

Intersezione di due liste generiche ordinate compatibili.

A parità di comparatore, clonare una sola copia.

Tempo `O(n+m)`.

---

## E3 — Generic priority file loader

### Consegna

Leggere record da file testuale, trasformarli con parser callback e inserirli in priority queue generica.

### Callback

```text
parseLine
compare
destroy
```

### Hidden test

Parser restituisce oggetto allocato; se push fallisce, va distrutto.

---

# Simulazione 8 — “Questa è la prova finale”

---

## E1 — `tripleTransform`

### Consegna

Data una stringa:

1. estrai gli interi con segno;
2. costruisci una lista;
3. elimina duplicati preservando la prima occorrenza;
4. inverti la lista in place;
5. restituisci un array con i valori.

### Difficoltà

- parsing;
- lista;
- set;
- inversione;
- array;
- cleanup.

---

## E2 — `treeMaximumAlternatingPath`

### Consegna

Trovare la lunghezza massima di un percorso padre-figlio in cui la parità alterna a ogni passo.

Il percorso può iniziare in qualunque nodo e scende soltanto verso i figli.

### Soluzione bottom-up

Per ogni nodo restituisci:

```text
miglior cammino discendente che parte dal nodo
miglior risultato globale nel sottoalbero
```

### Complessità

- Tempo: `O(n)`

---

## E3 — `transactionalArchiveUpdate`

### Consegna

Un archivio testuale contiene:

```text
id;name;score
```

Ricevi una lista di aggiornamenti:

```c
typedef struct updateNode {
    unsigned int id;
    double delta;
    struct updateNode *next;
} UpdateNode;
```

Devi:

1. leggere ogni record;
2. applicare la somma di tutti i delta con stesso ID;
3. scartare score finali negativi;
4. preservare ordine dei record;
5. scrivere su temporaneo;
6. sostituire l'originale soltanto se tutto riesce;
7. segnalare update riferiti a ID assenti.

### Competenze combinate

```text
file
parsing
lista
ricerca
aggiornamento
temporaneo
failure atomicity
```

---

# 9. Modalità “massacro”: 120 tracce senza soluzione completa

Queste vanno svolte in ordine casuale, non per categoria.

## Liste + array + stringhe

1. Stringa → lista delle lunghezze delle parole.
2. Lista → stringa CSV.
3. Lista di cifre → numero decimale.
4. Numero → lista di cifre.
5. Due liste → longest common prefix.
6. Due liste → longest common suffix.
7. Lista → array dei nodi dominanti a destra.
8. Array → lista dei massimi prefissi.
9. Lista → rimuovi ogni nodo duplicato, non solo copie successive.
10. Lista → partizione stabile in tre gruppi.
11. Lista → reorder primo, ultimo, secondo, penultimo.
12. Lista → reverse dei soli nodi a posizione pari.
13. Lista → swap a coppie senza scambiare dati.
14. Lista → rotate right di k.
15. Lista → merge sort.
16. Lista → quicksort scambiando nodi.
17. Lista → palindrome con ripristino.
18. Lista → intersection by identity.
19. Lista → rileva ciclo.
20. Lista ciclica → trova ingresso del ciclo.

## Alberi + liste

21. Albero → lista preorder.
22. Albero → lista inorder.
23. Albero → lista postorder.
24. Albero → lista foglie.
25. Albero → lista vista destra.
26. Albero → lista nodi a profondità k.
27. Albero → lista cammino verso target.
28. Albero → lista più lungo root-to-leaf.
29. Albero → tutte le somme root-to-leaf.
30. Albero → lista dei valori unici.
31. Lista ordinata → BST bilanciato.
32. Lista non ordinata → BST.
33. BST → lista crescente riusando nodi.
34. BST → lista decrescente.
35. Due BST → unione.
36. Due BST → intersezione.
37. Due BST → differenza.
38. Albero → lista dei nodi con un solo figlio.
39. Albero → lista delle somme per livello.
40. Albero → lista dei massimi per livello.

## Pile, code e deque miste

41. Lista → stack → reverse.
42. Coda → lista invertita.
43. Stack → coda preservando ordine logico.
44. Queue using stacks con clone.
45. Stack using queues con destroy.
46. Deque → palindrome.
47. Sliding window min e max.
48. Next greater in lista.
49. Previous smaller in array.
50. Largest rectangle in matrice binaria.
51. Trapping rain water.
52. Remove k digits.
53. Decode nested string.
54. Canonical path.
55. Undo/redo di lista.
56. Scheduler con priority queue.
57. Round-robin con log su file.
58. BFS di albero con coda generica.
59. BFS di griglia con percorso ricostruito.
60. 0-1 BFS.

## Set + strutture

61. Lista → set stabile.
62. BST → set di foglie.
63. File → set di parole.
64. Set → BST bilanciato.
65. Due file → differenza di insiemi.
66. Tre liste → intersezione unica.
67. Set di stringhe case-insensitive.
68. Generic set di struct.
69. Set snapshots.
70. Jaccard tra due file.
71. Longest substring distinct.
72. Minimum window required chars.
73. Longest consecutive sequence.
74. Happy number.
75. Sudoku validator.
76. Isomorphic strings.
77. Word pattern.
78. Distinct islands.
79. Group anagrams.
80. Top-k frequent.

## Generici + ownership

81. Generic vector map.
82. Generic vector filter.
83. Generic vector reduce.
84. Generic list clone.
85. Generic queue clone.
86. Generic stack reverse.
87. Generic ordered set union.
88. Generic BST remove.
89. Generic heap.
90. Generic stable merge.
91. Generic group-by.
92. Generic distinct-by.
93. Generic top-k.
94. Generic event dispatcher.
95. Generic plugin registry.
96. Tagged union serializer.
97. Vtable di forme.
98. Reference-counted nodes.
99. Failure-atomic replace.
100. Transactional bulk insert.

## File + tutto il resto

101. File → lista → sort → file.
102. File → BST → range output.
103. File → set → dedup.
104. File di record → priority queue.
105. Merge di k file.
106. Tail efficiente.
107. Reverse righe con offset.
108. Indice secondario.
109. Archivio append-only.
110. Snapshot + journal.
111. CSV quoted parser.
112. Binary format versioned.
113. Serialize generic set.
114. Serialize tree with markers.
115. External merge sort.
116. Top-k parole.
117. Dedup enorme.
118. Join di due archivi.
119. Aggiornamento transazionale.
120. Recovery da record finale troncato.

---

# 10. Metodo di allenamento reale

## Sessione A — Codice puro

Scegli 3 esercizi:

```text
uno lineare
uno ricorsivo
uno con memoria dinamica
```

Tempo massimo:

```text
75 minuti
```

## Sessione B — Hidden test

Prendi una tua soluzione e costruisci almeno:

```text
10 test funzionali
3 test di memoria
2 test di performance
```

## Sessione C — Riscrittura da zero

Dopo 48 ore:

```text
riscrivi senza guardare
```

Non serve ricordare il codice identico. Devi ricordare il pattern.

## Sessione D — Spiegazione orale

Per ogni soluzione devi saper dire:

```text
invariante
ownership
caso limite
tempo
spazio
perché non perde memoria
```

---

# 11. Griglia di autovalutazione

## Livello 0

```text
capisco la soluzione leggendo
```

## Livello 1

```text
riesco a riscriverla con piccoli aiuti
```

## Livello 2

```text
la scrivo da zero
```

## Livello 3

```text
trovo hidden test che rompono versioni quasi corrette
```

## Livello 4

```text
propongo soluzione semplice e ottimizzata
```

## Livello 5

```text
spiego ownership, correttezza e complessità senza esitazione
```

Un esercizio è davvero acquisito soltanto al livello 4 o 5.

---

# 12. Checklist finale prima di consegnare all’esame

```text
[ ] ho gestito NULL?
[ ] ho gestito struttura vuota?
[ ] ho gestito un solo elemento?
[ ] ho preservato l'ordine?
[ ] ho modificato input che doveva restare invariato?
[ ] ho chiuso tutti i file?
[ ] ogni malloc ha un cleanup?
[ ] ogni realloc usa un temporaneo?
[ ] il terminatore '\0' è presente?
[ ] front/rear/top sono coerenti?
[ ] dopo la rimozione dell'ultimo nodo i puntatori sono corretti?
[ ] la ricorsione termina?
[ ] ogni chiamata riduce il problema?
[ ] sto ricalcolando informazioni causando O(n²)?
[ ] il comparatore è corretto?
[ ] il clone è profondo quando serve?
[ ] il destroy viene chiamato esattamente una volta?
[ ] il main di test colpisce errori plausibili?
```

---

# 13. Regola finale

Gli esercizi misti diventano affrontabili quando li spezzi in fasi.

Esempio:

```text
file → array → sort → unique → BST → inorder → lista
```

Non devi scrivere tutto mentalmente in una volta.

Devi trasformare il problema in una pipeline:

```text
acquisisci
normalizza
costruisci
trasforma
verifica
rilascia
```

Per ogni fase chiedi:

```text
che struttura entra?
che struttura esce?
chi possiede la memoria?
quanto costa?
cosa succede se fallisce?
```

Quando questa decomposizione diventa automatica, gli esercizi “infernali” smettono di sembrare un blocco unico e diventano una sequenza di pattern già allenati.
