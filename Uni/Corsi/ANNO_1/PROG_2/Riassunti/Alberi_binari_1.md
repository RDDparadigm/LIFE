# Alberi Binari — Parte 1

> [!summary] Obiettivo della lezione
> Capire gli **alberi binari** come strutture dati ricorsive, saperli rappresentare in C con `struct` autoreferenziali, conoscere le principali definizioni teoriche e saper implementare le visite ricorsive e iterative.
>
> Questa è una di quelle lezioni in cui teoria e codice sono praticamente la stessa cosa: se capisci la definizione ricorsiva dell’albero, capisci anche perché le funzioni sugli alberi sono quasi sempre ricorsive.

---

# 1. Cos’è un albero binario

Un **albero binario** è una struttura dati gerarchica in cui ogni nodo può avere **al massimo due figli**:

* figlio sinistro;
* figlio destro.

La cosa più importante da capire è che un albero binario è una struttura **ricorsiva**.

Infatti un albero binario è:

1. oppure l’albero vuoto;
2. oppure un nodo formato da:

   * un sottoalbero sinistro;
   * un valore;
   * un sottoalbero destro.

Formalmente:

```text
bt = /
```

oppure:

```text
bt = <left, e, right>
```

dove:

* `e` è il valore contenuto nella radice;
* `left` è il sottoalbero sinistro;
* `right` è il sottoalbero destro.

La definizione è ricorsiva perché `left` e `right` sono a loro volta alberi binari.

---

# 2. Dal concetto astratto al codice C

La definizione astratta:

```text
<left, e, right>
```

in C diventa una `struct` con tre campi:

```c
struct treeNode {
    struct treeNode *left;
    T data;
    struct treeNode *right;
};
```

Dove:

* `left` punta al figlio/sottoalbero sinistro;
* `data` contiene il valore;
* `right` punta al figlio/sottoalbero destro.

La versione con `typedef` è più comoda:

```c
typedef int T;

typedef struct treeNode TreeNode;
typedef TreeNode *Tree;

struct treeNode {
    Tree left;
    T data;
    Tree right;
};
```

Da ricordare benissimo:

```c
typedef TreeNode *Tree;
```

significa che `Tree` è già un puntatore a `struct treeNode`.

Quindi:

```c
Tree t;
```

non è un nodo, ma un puntatore a nodo.

L’albero vuoto si rappresenta con:

```c
NULL
```

Quindi:

```c
Tree t = NULL;
```

rappresenta un albero binario vuoto.

---

# 3. Creazione di un nodo

Funzione utile da saper scrivere senza guardare:

```c
#include <stdio.h>
#include <stdlib.h>

typedef int T;

typedef struct treeNode TreeNode;
typedef TreeNode *Tree;

struct treeNode {
    Tree left;
    T data;
    Tree right;
};

Tree mkNode(T value) {
    Tree newNode = malloc(sizeof(TreeNode));

    if (newNode == NULL) {
        fprintf(stderr, "Errore: memoria insufficiente\n");
        exit(EXIT_FAILURE);
    }

    newNode->left = NULL;
    newNode->data = value;
    newNode->right = NULL;

    return newNode;
}
```

Occhio a questo:

```c
malloc(sizeof(TreeNode))
```

è meglio di:

```c
malloc(sizeof(struct treeNode))
```

solo perché abbiamo fatto il `typedef`.

In alternativa si può scrivere:

```c
Tree newNode = malloc(sizeof(*newNode));
```

che è ancora più robusto, perché alloca esattamente la dimensione dell’oggetto puntato da `newNode`.

---

# 4. Terminologia fondamentale

Dato un albero:

```text
        27
       /  \
     13    42
    / \    / \
   6  17  33 48
```

abbiamo:

## Radice

La **radice** è il nodo iniziale dell’albero.

Nell’esempio:

```text
27
```

è la radice.

---

## Figlio sinistro e figlio destro

Il figlio sinistro di `27` è:

```text
13
```

Il figlio destro di `27` è:

```text
42
```

---

## Fratelli

Due nodi sono **fratelli** se hanno lo stesso padre.

Nell’esempio:

```text
13 e 42
```

sono fratelli.

Anche:

```text
6 e 17
```

sono fratelli.

---

## Foglia

Una **foglia** è un nodo senza figli.

Nell’esempio sono foglie:

```text
6, 17, 33, 48
```

---

## Nodo interno

Nelle slide viene chiamato **interno** un nodo che non è né radice né foglia.

Nell’esempio:

```text
13 e 42
```

sono nodi interni.

---

# 5. Cammini, antenati e discendenti

Un **cammino** da un nodo `n` a un nodo `m` è una sequenza di nodi collegati da archi.

Esempio:

```text
        21
       /
      4
       \
       13
      /
     11
```

Il cammino dalla radice `21` al nodo `11` è:

```text
21 -> 4 -> 13 -> 11
```

Gli **antenati** di un nodo sono i nodi che si trovano lungo il cammino dalla radice a quel nodo.

Ogni nodo è considerato antenato e discendente di sé stesso.

Quindi gli antenati di `11` sono:

```text
21, 4, 13, 11
```

Gli antenati propri sono tutti tranne sé stesso:

```text
21, 4, 13
```

Se `m` è antenato di `n`, allora `n` è discendente di `m`.

---

# 6. Profondità e altezza

## Profondità di un nodo

La **profondità** di un nodo è il numero di archi dalla radice a quel nodo.

La radice ha profondità:

```text
0
```

Esempio:

```text
        27          profondità 0
       /  \
     13    42       profondità 1
    / \    / \
   6  17  33 48     profondità 2
```

Quindi:

```text
profondità(27) = 0
profondità(13) = 1
profondità(6)  = 2
```

---

## Altezza dell’albero

L’**altezza** di un albero è la profondità massima raggiunta da un nodo.

Nel caso sopra:

```text
altezza = 2
```

Per convenzione delle slide:

```text
altezza(albero vuoto) = -1
```

Quindi:

```text
altezza(foglia) = 0
```

Questa convenzione è importante perché rende molto elegante il codice ricorsivo.

---

# 7. Funzione height in C

Attenzione: se l’altezza dell’albero vuoto è `-1`, allora la funzione non dovrebbe restituire `size_t`, perché `size_t` non può rappresentare numeri negativi.

Meglio usare `int`.

```c
int max(int a, int b) {
    return a > b ? a : b;
}

int height(Tree tree) {
    if (tree == NULL) {
        return -1;
    }

    int leftHeight = height(tree->left);
    int rightHeight = height(tree->right);

    return 1 + max(leftHeight, rightHeight);
}
```

Per una foglia:

```c
height(foglia)
```

diventa:

```text
1 + max(-1, -1) = 0
```

Perfetto.

---

# 8. Grado di un nodo

Il **grado** di un nodo è il numero dei suoi figli.

In un albero binario il grado può essere:

```text
0, 1 oppure 2
```

Esempi:

```text
grado(foglia) = 0
grado(nodo con un figlio) = 1
grado(nodo con due figli) = 2
```

---

# 9. Albero binario completo

Un albero binario è **completo** se:

1. tutte le foglie hanno la stessa profondità;
2. tutti i nodi interni hanno grado `2`.

Esempio:

```text
        1
       / \
      2   3
     / \ / \
    4  5 6  7
```

Tutte le foglie sono allo stesso livello e ogni nodo interno ha due figli.

Questo tipo di albero è perfettamente bilanciato.

---

# 10. Albero pseudo quasi completo

Un albero binario è **pseudo quasi completo** se tutti i livelli, tranne al più l’ultimo, sono completi.

In pratica:

* i livelli superiori sono pieni;
* l’ultimo livello può non essere pieno;
* però non è richiesto che i nodi dell’ultimo livello siano compattati verso sinistra.

Esempio intuitivo:

```text
        1
       / \
      2   3
     /     \
    4       7
```

I livelli sopra l’ultimo possono essere completi, ma l’ultimo livello ha dei “buchi” non necessariamente ordinati.

---

# 11. Albero quasi completo

Un albero binario è **quasi completo** se:

1. tutti i livelli tranne eventualmente l’ultimo sono completi;
2. nell’ultimo livello, le foglie mancanti sono consecutive a partire da destra.

In altre parole: l’albero viene riempito da sinistra verso destra.

Esempio quasi completo:

```text
        1
       / \
      2   3
     / \ /
    4  5 6
```

Qui manca il nodo più a destra dell’ultimo livello, quindi va bene.

Esempio non quasi completo:

```text
        1
       / \
      2   3
       \ / \
        5 6 7
```

Qui manca `4`, ma c’è `5`: l’ultimo livello non è riempito da sinistra verso destra.

---

# 12. Albero degenere

Un albero binario con `n` nodi e altezza `h` è **degenere** se ogni nodo ha al massimo un figlio.

Esempio:

```text
1
 \
  2
   \
    3
     \
      4
```

Questo albero è degenere e completamente sbilanciato a destra.

Per un albero degenere vale:

```text
h = n - 1
```

Perché ogni nodo aggiunge un livello.

Con `4` nodi:

```text
h = 3
```

---

# 13. Albero completamente sbilanciato

Un albero è completamente sbilanciato a sinistra se ogni nodo ha al massimo il figlio sinistro:

```text
      4
     /
    3
   /
  2
 /
1
```

Un albero è completamente sbilanciato a destra se ogni nodo ha al massimo il figlio destro:

```text
1
 \
  2
   \
    3
     \
      4
```

Questi alberi sono importanti perché rappresentano il caso pessimo per molte operazioni sugli alberi.

---

# 14. Proprietà degli alberi completi

## Numero di nodi di un albero binario completo

Un albero binario completo di altezza `h` ha:

```text
2^(h + 1) - 1
```

nodi.

Esempio con `h = 0`:

```text
2^(0 + 1) - 1 = 2^1 - 1 = 1
```

Infatti un albero di altezza `0` ha solo la radice.

Esempio con `h = 1`:

```text
2^(1 + 1) - 1 = 2^2 - 1 = 3
```

Albero:

```text
    1
   / \
  2   3
```

Esempio con `h = 2`:

```text
2^(2 + 1) - 1 = 2^3 - 1 = 7
```

Albero:

```text
        1
       / \
      2   3
     / \ / \
    4  5 6  7
```

---

## Numero di foglie di un albero binario completo

Un albero binario completo di altezza `h` ha:

```text
2^h
```

foglie.

Esempio con `h = 2`:

```text
2^2 = 4
```

Le foglie sono:

```text
4, 5, 6, 7
```

---

# 15. Proprietà degli alberi quasi completi

Per un albero quasi completo di altezza `h`, il numero di nodi `n` soddisfa:

```text
2^h <= n <= 2^(h + 1) - 1
```

Il minimo si ha quando l’ultimo livello contiene solo il primo nodo a sinistra.

Il massimo si ha quando l’albero è completo.

Da questa proprietà deriva una formula molto importante:

```text
h = floor(log2(n))
```

Cioè l’altezza di un albero binario quasi completo con `n` nodi è:

```text
⌊log2(n)⌋
```

Esempio:

```text
n = 7
h = floor(log2(7)) = 2
```

Infatti un albero completo con 7 nodi ha altezza 2.

Altro esempio:

```text
n = 10
h = floor(log2(10)) = 3
```

---

# 16. Perché queste formule contano

La differenza tra un albero bilanciato/quasi completo e un albero degenere è enorme.

Con `n` nodi:

## Albero quasi completo

```text
h = O(log n)
```

## Albero degenere

```text
h = O(n)
```

Questo impatta lo spazio usato dalla ricorsione e, in certi alberi come gli alberi di ricerca, anche il tempo di ricerca.

---

# 17. Induzione strutturale sugli alberi

Il principio di induzione strutturale serve per dimostrare proprietà sugli alberi binari.

Per dimostrare che una proprietà `P(bt)` vale per ogni albero binario, bisogna dimostrare:

## Caso base

La proprietà vale per l’albero vuoto:

```text
P(NULL)
```

## Caso induttivo

Supponiamo che la proprietà valga per:

```text
left
```

e per:

```text
right
```

Dobbiamo dimostrare che vale anche per:

```text
<left, e, right>
```

cioè per l’albero formato da:

* sottoalbero sinistro;
* radice;
* sottoalbero destro.

---

# 18. Perché l’induzione strutturale è importante

L’induzione strutturale è la versione teorica della ricorsione sugli alberi.

Quando scrivi una funzione ricorsiva sugli alberi, quasi sempre fai:

```c
if (tree == NULL) {
    // caso base
} else {
    // usa ricorsivamente tree->left e tree->right
}
```

Questo corrisponde esattamente a:

```text
caso base: albero vuoto
caso induttivo: nodo con sottoalberi left e right
```

Quindi:

* la ricorsione è il modo naturale di programmare sugli alberi;
* l’induzione strutturale è il modo naturale di dimostrare proprietà sugli alberi.

---

# 19. Alberi di ricerca binari

Un **albero di ricerca binario**, o **ARB**, in inglese **Binary Search Tree** o **BST**, è un albero binario in cui gli elementi sono ordinati.

Per ogni nodo con valore `k`:

* tutti gli elementi del sottoalbero sinistro sono `<= k`;
* tutti gli elementi del sottoalbero destro sono `>= k`.

Se tutti gli elementi sono distinti, si può usare:

* sottoalbero sinistro `< k`;
* sottoalbero destro `> k`.

Esempio:

```text
        47
       /  \
     25    93
    /  \   /
   7   31 77
    \    \ /
    17   44 68
   /       /
 11       65
```

La proprietà fondamentale è locale ma vale ricorsivamente per tutto l’albero.

Non basta che il figlio sinistro sia minore e il figlio destro sia maggiore: tutta la parte sinistra deve rispettare il vincolo rispetto alla radice, e tutta la parte destra anche.

---

# 20. Perché gli ARB sono importanti

Gli alberi di ricerca binari permettono di cercare un elemento sfruttando l’ordinamento.

Se cerco `x` in un BST:

* se `x == root->data`, trovato;
* se `x < root->data`, cerco a sinistra;
* se `x > root->data`, cerco a destra.

Codice:

```c
bool containsBST(Tree tree, T value) {
    if (tree == NULL) {
        return false;
    }

    if (value == tree->data) {
        return true;
    }

    if (value < tree->data) {
        return containsBST(tree->left, value);
    } else {
        return containsBST(tree->right, value);
    }
}
```

Complessità:

```text
O(h)
```

dove `h` è l’altezza dell’albero.

Se l’albero è bilanciato:

```text
O(log n)
```

Se l’albero è degenere:

```text
O(n)
```

---

# 21. Inserimento in un BST

Anche se nelle slide si parla soprattutto di definizione e visite, conviene saper scrivere almeno l’inserimento.

Versione ricorsiva:

```c
Tree insertBST(Tree tree, T value) {
    if (tree == NULL) {
        return mkNode(value);
    }

    if (value <= tree->data) {
        tree->left = insertBST(tree->left, value);
    } else {
        tree->right = insertBST(tree->right, value);
    }

    return tree;
}
```

Esempio d’uso:

```c
Tree tree = NULL;

tree = insertBST(tree, 27);
tree = insertBST(tree, 13);
tree = insertBST(tree, 42);
tree = insertBST(tree, 6);
tree = insertBST(tree, 17);
tree = insertBST(tree, 33);
tree = insertBST(tree, 48);
```

L’albero risultante è:

```text
        27
       /  \
     13    42
    / \    / \
   6  17  33 48
```

---

# 22. Visite degli alberi binari

Visitare un albero significa processare tutti i suoi nodi secondo un certo ordine.

Le visite ricorsive principali sono:

1. visita in-order;
2. visita pre-order;
3. visita post-order.

Dato questo albero:

```text
        27
       /  \
     13    42
    / \    / \
   6  17  33 48
```

i tre ordini sono diversi.

---

# 23. Visita in-order

La visita **in-order** segue questo ordine:

```text
sinistra -> radice -> destra
```

Schema:

```c
void inOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    inOrder(tree->left);

    // visita la radice

    inOrder(tree->right);
}
```

Per stampare:

```c
void printInOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    printInOrder(tree->left);
    printf("%d ", tree->data);
    printInOrder(tree->right);
}
```

Sull’albero:

```text
        27
       /  \
     13    42
    / \    / \
   6  17  33 48
```

stampa:

```text
6 13 17 27 33 42 48
```

La visita in-order di un BST restituisce gli elementi in ordine crescente.

Questo è un concetto da sapere benissimo.

---

# 24. Perché in-order su un BST stampa in ordine

In un BST:

```text
tutti i valori a sinistra <= radice <= tutti i valori a destra
```

La visita in-order fa:

```text
sinistra, radice, destra
```

Quindi:

1. stampa prima tutti i valori minori;
2. poi stampa la radice;
3. poi stampa tutti i valori maggiori.

Poiché la stessa proprietà vale ricorsivamente per ogni sottoalbero, il risultato finale è ordinato.

---

# 25. Visita pre-order

La visita **pre-order** segue questo ordine:

```text
radice -> sinistra -> destra
```

Schema:

```c
void preOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    // visita la radice

    preOrder(tree->left);
    preOrder(tree->right);
}
```

Per stampare:

```c
void printPreOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    printf("%d ", tree->data);
    printPreOrder(tree->left);
    printPreOrder(tree->right);
}
```

Sull’albero:

```text
        27
       /  \
     13    42
    / \    / \
   6  17  33 48
```

stampa:

```text
27 13 6 17 42 33 48
```

Regola mnemonica:

```text
PRE = radice PRIMA
```

---

# 26. Visita post-order

La visita **post-order** segue questo ordine:

```text
sinistra -> destra -> radice
```

Schema:

```c
void postOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    postOrder(tree->left);
    postOrder(tree->right);

    // visita la radice
}
```

Per stampare:

```c
void printPostOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    printPostOrder(tree->left);
    printPostOrder(tree->right);
    printf("%d ", tree->data);
}
```

Sull’albero:

```text
        27
       /  \
     13    42
    / \    / \
   6  17  33 48
```

stampa:

```text
6 17 13 33 48 42 27
```

Regola mnemonica:

```text
POST = radice DOPO
```

La visita post-order è particolarmente utile quando bisogna liberare memoria, perché prima si liberano i figli e poi il nodo corrente.

---

# 27. Liberare un albero dalla memoria

Questa funzione è importantissima.

Se fai solo:

```c
free(tree);
```

liberi solo la radice e perdi i puntatori ai sottoalberi, causando memory leak.

Bisogna usare una visita post-order:

```c
void destroyTree(Tree *treePtr) {
    if (treePtr == NULL || *treePtr == NULL) {
        return;
    }

    destroyTree(&(*treePtr)->left);
    destroyTree(&(*treePtr)->right);

    free(*treePtr);
    *treePtr = NULL;
}
```

Perché `Tree *treePtr`?

Perché `Tree` è già un puntatore.

Quindi:

```c
Tree *treePtr;
```

è un puntatore a puntatore.

Lo usiamo perché vogliamo anche modificare il puntatore del chiamante, mettendolo a `NULL` dopo la `free`.

Uso:

```c
Tree tree = NULL;

tree = insertBST(tree, 27);
tree = insertBST(tree, 13);
tree = insertBST(tree, 42);

destroyTree(&tree);
```

Dopo:

```c
tree == NULL
```

Così eviti il dangling pointer nel `main`.

---

# 28. Funzioni ricorsive fondamentali

## Calcolare il numero di nodi

```c
size_t size(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    return 1 + size(tree->left) + size(tree->right);
}
```

Qui:

* `1` conta la radice;
* `size(tree->left)` conta il sottoalbero sinistro;
* `size(tree->right)` conta il sottoalbero destro.

---

## Calcolare la somma degli elementi

```c
int sumIntTree(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    return tree->data
         + sumIntTree(tree->left)
         + sumIntTree(tree->right);
}
```

---

## Contare i nodi che soddisfano un predicato

```c
#include <stdbool.h>

size_t countIf(Tree tree, bool (*predicate)(T value)) {
    if (tree == NULL) {
        return 0;
    }

    size_t countRoot = predicate(tree->data) ? 1 : 0;

    return countRoot
         + countIf(tree->left, predicate)
         + countIf(tree->right, predicate);
}
```

Esempio di predicato:

```c
bool isEven(T value) {
    return value % 2 == 0;
}
```

Uso:

```c
size_t evenNumbers = countIf(tree, isEven);
```

---

# 29. Visite e complessità

Per le visite ricorsive:

```text
in-order
pre-order
post-order
```

il tempo è:

```text
O(n)
```

perché ogni nodo viene visitato esattamente una volta.

Lo spazio è:

```text
O(h)
```

dove `h` è l’altezza dell’albero.

Perché?

Perché la ricorsione usa lo stack delle chiamate, e nel caso peggiore ci sono tante chiamate annidate quanto è lunga l’altezza dell’albero.

Quindi:

## Albero degenere

```text
h = n - 1
spazio = O(n)
```

## Albero bilanciato/quasi completo

```text
h = O(log n)
spazio = O(log n)
```

---

# 30. Visita depth-first iterativa

La visita **depth-first** iterativa corrisponde alla visita pre-order:

```text
radice -> sinistra -> destra
```

Per realizzarla iterativamente si usa una **pila**.

Perché una pila?

Perché la pila è LIFO:

```text
Last In, First Out
```

L’ultimo nodo inserito è il primo a essere estratto.

Schema corretto:

```c
void depthFirst(Tree tree) {
    if (tree == NULL) {
        return;
    }

    VoidPtrStackADT s = mkVoidPtrStackADT();

    push(s, tree);

    while (!isEmpty(s)) {
        Tree nodePtr = (Tree) pop(s);

        // visita il nodo
        printf("%d ", nodePtr->data);

        if (nodePtr->right != NULL) {
            push(s, nodePtr->right);
        }

        if (nodePtr->left != NULL) {
            push(s, nodePtr->left);
        }
    }

    dsVoidPtrStackADT(&s);
}
```

Attenzione all’ordine:

```c
push(s, nodePtr->right);
push(s, nodePtr->left);
```

Si inserisce prima il destro e poi il sinistro perché la pila estrae prima l’ultimo elemento inserito.

Quindi, per visitare prima il sinistro, devo pushare il sinistro per ultimo.

---

# 31. Errore tipico nella depth-first iterativa

Errore:

```c
printf("%d", tree->data);
```

dentro il ciclo.

Questo stampa sempre la radice originale.

La variabile corretta è:

```c
nodePtr
```

Quindi:

```c
printf("%d", nodePtr->data);
```

Il nodo corrente è quello appena estratto dalla pila.

---

# 32. Visita breadth-first

La visita **breadth-first**, o visita in ampiezza, visita i nodi livello per livello, da sinistra verso destra.

Esempio:

```text
        27
       /  \
     13    42
    / \    / \
   6  17  33 48
```

Ordine breadth-first:

```text
27 13 42 6 17 33 48
```

Per realizzarla si usa una **coda**.

Perché una coda?

Perché la coda è FIFO:

```text
First In, First Out
```

Il primo nodo inserito è il primo a essere estratto.

Schema corretto:

```c
void breadthFirst(Tree tree) {
    if (tree == NULL) {
        return;
    }

    VoidPtrQueueADT q = mkVoidPtrQueueADT();

    enqueue(q, tree);

    while (!isEmpty(q)) {
        Tree nodePtr = (Tree) dequeue(q);

        // visita il nodo
        printf("%d ", nodePtr->data);

        if (nodePtr->left != NULL) {
            enqueue(q, nodePtr->left);
        }

        if (nodePtr->right != NULL) {
            enqueue(q, nodePtr->right);
        }
    }

    dsVoidPtrQueueADT(&q);
}
```

Attenzione: per visitare da sinistra a destra, devi inserire prima il figlio sinistro e poi il figlio destro.

---

# 33. Complessità della breadth-first

Tempo:

```text
O(n)
```

perché ogni nodo viene visitato una volta.

Spazio:

```text
O(n)
```

Perché?

Perché la coda può contenere molti nodi dello stesso livello.

In un albero quasi completo, l’ultimo livello contiene circa metà dei nodi totali.

Quindi la coda può arrivare a contenere un numero di nodi proporzionale a `n`.

---

# 34. Differenza tra depth-first e breadth-first

## Depth-first

Visita andando in profondità.

Usa:

```text
pila
```

Ordine tipico:

```text
radice -> sinistra -> destra
```

Spazio:

```text
O(h)
```

---

## Breadth-first

Visita livello per livello.

Usa:

```text
coda
```

Ordine:

```text
dall’alto verso il basso, da sinistra a destra
```

Spazio:

```text
O(n)
```

---

# 35. Codice completo da riscrivere per allenarsi

Questo è un esercizio molto utile da copiare, riscrivere e modificare.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef int T;

typedef struct treeNode TreeNode;
typedef TreeNode *Tree;

struct treeNode {
    Tree left;
    T data;
    Tree right;
};

Tree mkNode(T value) {
    Tree newNode = malloc(sizeof(*newNode));

    if (newNode == NULL) {
        fprintf(stderr, "Errore: memoria insufficiente\n");
        exit(EXIT_FAILURE);
    }

    newNode->left = NULL;
    newNode->data = value;
    newNode->right = NULL;

    return newNode;
}

Tree insertBST(Tree tree, T value) {
    if (tree == NULL) {
        return mkNode(value);
    }

    if (value <= tree->data) {
        tree->left = insertBST(tree->left, value);
    } else {
        tree->right = insertBST(tree->right, value);
    }

    return tree;
}

bool containsBST(Tree tree, T value) {
    if (tree == NULL) {
        return false;
    }

    if (value == tree->data) {
        return true;
    }

    if (value < tree->data) {
        return containsBST(tree->left, value);
    } else {
        return containsBST(tree->right, value);
    }
}

void printInOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    printInOrder(tree->left);
    printf("%d ", tree->data);
    printInOrder(tree->right);
}

void printPreOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    printf("%d ", tree->data);
    printPreOrder(tree->left);
    printPreOrder(tree->right);
}

void printPostOrder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    printPostOrder(tree->left);
    printPostOrder(tree->right);
    printf("%d ", tree->data);
}

size_t size(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    return 1 + size(tree->left) + size(tree->right);
}

int max(int a, int b) {
    return a > b ? a : b;
}

int height(Tree tree) {
    if (tree == NULL) {
        return -1;
    }

    return 1 + max(height(tree->left), height(tree->right));
}

int sumIntTree(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    return tree->data
         + sumIntTree(tree->left)
         + sumIntTree(tree->right);
}

bool isEven(T value) {
    return value % 2 == 0;
}

size_t countIf(Tree tree, bool (*predicate)(T value)) {
    if (tree == NULL) {
        return 0;
    }

    size_t countRoot = predicate(tree->data) ? 1 : 0;

    return countRoot
         + countIf(tree->left, predicate)
         + countIf(tree->right, predicate);
}

void destroyTree(Tree *treePtr) {
    if (treePtr == NULL || *treePtr == NULL) {
        return;
    }

    destroyTree(&(*treePtr)->left);
    destroyTree(&(*treePtr)->right);

    free(*treePtr);
    *treePtr = NULL;
}

int main(void) {
    Tree tree = NULL;

    tree = insertBST(tree, 27);
    tree = insertBST(tree, 13);
    tree = insertBST(tree, 42);
    tree = insertBST(tree, 6);
    tree = insertBST(tree, 17);
    tree = insertBST(tree, 33);
    tree = insertBST(tree, 48);

    printf("In-order: ");
    printInOrder(tree);
    printf("\n");

    printf("Pre-order: ");
    printPreOrder(tree);
    printf("\n");

    printf("Post-order: ");
    printPostOrder(tree);
    printf("\n");

    printf("Size: %zu\n", size(tree));
    printf("Height: %d\n", height(tree));
    printf("Sum: %d\n", sumIntTree(tree));
    printf("Even values: %zu\n", countIf(tree, isEven));

    printf("Contains 17? %s\n", containsBST(tree, 17) ? "yes" : "no");
    printf("Contains 99? %s\n", containsBST(tree, 99) ? "yes" : "no");

    destroyTree(&tree);

    return 0;
}
```

Output atteso:

```text
In-order: 6 13 17 27 33 42 48
Pre-order: 27 13 6 17 42 33 48
Post-order: 6 17 13 33 48 42 27
Size: 7
Height: 2
Sum: 186
Even values: 3
Contains 17? yes
Contains 99? no
```

---

# 36. Cosa devi saper fare all’esame

## Teoria

Devi saper spiegare:

* cos’è un albero binario;
* perché è una struttura ricorsiva;
* cosa rappresenta `NULL`;
* cosa sono radice, figli, foglie, fratelli;
* profondità e altezza;
* grado di un nodo;
* differenza tra albero completo, pseudo quasi completo, quasi completo;
* albero degenere e completamente sbilanciato;
* formule sul numero di nodi e foglie;
* principio di induzione strutturale;
* cos’è un BST;
* perché l’in-order di un BST produce valori ordinati.

---

## Codice

Devi saper scrivere:

```c
struct treeNode
```

con puntatori autoreferenziali.

Poi almeno queste funzioni:

```c
Tree mkNode(T value);
Tree insertBST(Tree tree, T value);
bool containsBST(Tree tree, T value);
void printInOrder(Tree tree);
void printPreOrder(Tree tree);
void printPostOrder(Tree tree);
size_t size(Tree tree);
int height(Tree tree);
int sumIntTree(Tree tree);
size_t countIf(Tree tree, bool (*predicate)(T value));
void destroyTree(Tree *treePtr);
```

---

# 37. Errori tipici da evitare

## 1. Dimenticare il caso base

Errore:

```c
void printInOrder(Tree tree) {
    printInOrder(tree->left);
    printf("%d", tree->data);
    printInOrder(tree->right);
}
```

Se `tree == NULL`, il programma va in segmentation fault.

Corretto:

```c
if (tree == NULL) {
    return;
}
```

---

## 2. Confondere `Tree` e `TreeNode`

Ricorda:

```c
typedef TreeNode *Tree;
```

Quindi:

```c
Tree tree;
```

è un puntatore.

Mentre:

```c
TreeNode node;
```

è una struct vera e propria.

---

## 3. Usare `size_t` per l’altezza se vuoi restituire `-1`

Se l’albero vuoto ha altezza `-1`, allora usa:

```c
int height(Tree tree);
```

non:

```c
size_t height(Tree tree);
```

---

## 4. Fare `free` solo della radice

Errore:

```c
free(tree);
```

Corretto:

```c
destroyTree(&tree);
```

con visita post-order.

---

## 5. Nella depth-first iterativa stampare `tree->data`

Errore:

```c
printf("%d", tree->data);
```

Corretto:

```c
printf("%d", nodePtr->data);
```

---

## 6. Nella breadth-first invertire sinistro e destro

Per visitare da sinistra a destra:

```c
enqueue(q, nodePtr->left);
enqueue(q, nodePtr->right);
```

non il contrario.

---

# 38. Collegamento mentale con liste, pile e code

Gli alberi riprendono tante cose già viste:

## Liste linkate

Come le liste, anche gli alberi sono strutture autoreferenziali.

Lista:

```c
struct node {
    T data;
    struct node *next;
};
```

Albero:

```c
struct treeNode {
    struct treeNode *left;
    T data;
    struct treeNode *right;
};
```

La differenza è che la lista ha un solo collegamento, mentre l’albero ne ha due.

---

## Pile

La visita depth-first iterativa usa una pila.

La pila serve a ricordare i nodi da visitare dopo.

---

## Code

La visita breadth-first usa una coda.

La coda serve a visitare i nodi nello stesso ordine in cui vengono scoperti, cioè livello per livello.

---

# 39. Esercizi consigliati

## Esercizio 1

Disegna questo BST dopo gli inserimenti:

```c
27, 13, 42, 6, 17, 33, 48
```

Poi scrivi:

* visita in-order;
* visita pre-order;
* visita post-order;
* visita breadth-first.

Soluzione:

```text
In-order:      6 13 17 27 33 42 48
Pre-order:     27 13 6 17 42 33 48
Post-order:    6 17 13 33 48 42 27
Breadth-first: 27 13 42 6 17 33 48
```

---

## Esercizio 2

Implementa:

```c
size_t countLeaves(Tree tree);
```

Soluzione:

```c
size_t countLeaves(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    if (tree->left == NULL && tree->right == NULL) {
        return 1;
    }

    return countLeaves(tree->left) + countLeaves(tree->right);
}
```

---

## Esercizio 3

Implementa:

```c
size_t countInnerNodes(Tree tree);
```

Versione semplice, considerando interni i nodi che hanno almeno un figlio:

```c
size_t countInnerNodes(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    if (tree->left == NULL && tree->right == NULL) {
        return 0;
    }

    return 1 + countInnerNodes(tree->left) + countInnerNodes(tree->right);
}
```

Nota: nelle slide “interno” viene definito come nodo che non è né radice né foglia. Se l’esercizio usa quella definizione, serve gestire la radice separatamente.

---

## Esercizio 4

Implementa:

```c
bool isLeaf(Tree tree);
```

Soluzione:

```c
bool isLeaf(Tree tree) {
    return tree != NULL
        && tree->left == NULL
        && tree->right == NULL;
}
```

---

## Esercizio 5

Implementa:

```c
size_t countGreaterThan(Tree tree, T value);
```

Versione generica per qualsiasi albero binario:

```c
size_t countGreaterThan(Tree tree, T value) {
    if (tree == NULL) {
        return 0;
    }

    size_t countRoot = tree->data > value ? 1 : 0;

    return countRoot
         + countGreaterThan(tree->left, value)
         + countGreaterThan(tree->right, value);
}
```

Versione ottimizzata per BST:

```c
size_t countGreaterThanBST(Tree tree, T value) {
    if (tree == NULL) {
        return 0;
    }

    if (tree->data <= value) {
        return countGreaterThanBST(tree->right, value);
    }

    return 1
         + size(tree->right)
         + countGreaterThanBST(tree->left, value);
}
```

Perché posso sommare direttamente `size(tree->right)`?

Perché in un BST, se `tree->data > value`, allora tutti i nodi del sottoalbero destro sono ancora più grandi o uguali a `tree->data`, quindi sono sicuramente maggiori di `value`.

---

# 40. Mini cheat sheet finale

```text
Albero vuoto:
NULL

Nodo:
<left, e, right>

Profondità:
numero di archi dalla radice al nodo

Altezza:
massima profondità di un nodo

Altezza albero vuoto:
-1

Altezza foglia:
0

Grado:
numero di figli

Albero completo:
tutte le foglie alla stessa profondità,
tutti i nodi interni hanno grado 2

Albero quasi completo:
livelli pieni tranne forse l’ultimo,
ultimo livello riempito da sinistra verso destra

Albero degenere:
ogni nodo ha al massimo un figlio

Albero degenere:
h = n - 1

Albero completo di altezza h:
nodi = 2^(h + 1) - 1
foglie = 2^h

Albero quasi completo:
h = floor(log2(n))

BST:
sinistra <= radice <= destra

In-order:
sinistra, radice, destra

Pre-order:
radice, sinistra, destra

Post-order:
sinistra, destra, radice

Breadth-first:
livello per livello

DFS iterativa:
pila

BFS iterativa:
coda

Visite ricorsive:
tempo O(n), spazio O(h)

Breadth-first:
tempo O(n), spazio O(n)
```

---

# 41. Frasi da saper dire bene all’orale

> Un albero binario è una struttura dati ricorsiva perché ogni nodo contiene due riferimenti ad altri alberi binari, cioè il sottoalbero sinistro e il sottoalbero destro.

> L’albero vuoto viene rappresentato in C con `NULL`.

> La visita in-order di un albero di ricerca binario restituisce gli elementi in ordine crescente, perché visita prima tutti gli elementi minori della radice, poi la radice, poi tutti gli elementi maggiori.

> Le visite ricorsive hanno tempo `O(n)` perché ogni nodo viene visitato una sola volta, e spazio `O(h)` perché lo stack delle chiamate ricorsive dipende dall’altezza dell’albero.

> Nel caso di albero degenere, l’altezza è `n - 1`, quindi lo spazio può diventare `O(n)`.

> Nel caso di albero quasi completo, l’altezza è `floor(log2(n))`, quindi la profondità cresce molto più lentamente rispetto al numero di nodi.

> La visita depth-first iterativa usa una pila; per ottenere l’ordine radice-sinistra-destra bisogna inserire prima il figlio destro e poi il figlio sinistro.

> La visita breadth-first usa una coda perché deve visitare i nodi nello stesso ordine in cui vengono scoperti, cioè livello per livello da sinistra verso destra.

---

# 42. Piano di studio per prendere 30 e lode

1. Riscrivere a mano la `struct treeNode`.
2. Riscrivere `mkNode`.
3. Riscrivere `insertBST`.
4. Disegnare l’albero ottenuto da una sequenza di inserimenti.
5. Calcolare a mano in-order, pre-order, post-order e breadth-first.
6. Implementare `size`.
7. Implementare `height`.
8. Implementare `sumIntTree`.
9. Implementare `countIf` con puntatore a funzione.
10. Implementare `destroyTree` con `Tree *`.
11. Spiegare a voce perché `destroyTree` usa post-order.
12. Spiegare a voce perché la BFS usa spazio `O(n)`.
13. Spiegare a voce perché la DFS ricorsiva usa spazio `O(h)`.
14. Dimostrare la formula dei nodi di un albero completo.
15. Spiegare perché l’in-order di un BST produce un ordinamento crescente.

Se sai fare questi punti senza guardare, questa parte è pronta per l’esame.
