# Dojo C — Esercizi progressivi

> Obiettivo: partire da funzioni immediate e arrivare a esercizi che richiedono modellazione, invarianti e gestione difensiva della memoria.
>
> Per ogni esercizio: copia la consegna su OneCompiler, scrivi tutto il programma, prepara i test, compila con warning alti e solo dopo apri la soluzione.

Comando consigliato:

```bash
gcc -std=c11 -Wall -Wextra -Wpedantic -Wconversion main.c && ./a.out
```

Le soluzioni usano i **callout richiudibili nativi di Obsidian**. Funzionano in Modalità lettura e Live Preview; premi sul titolo per aprirli.

## Tipi usati negli esercizi

Quando una consegna usa `IntList` o `IntTree`, considera disponibili queste definizioni:

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

Include normalmente utili:

```c
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>
```

## Protocollo di allenamento

Per ogni esercizio devi scrivere:

1. gli `#include` necessari;
2. le definizioni dei tipi richiesti;
3. la funzione richiesta;
4. eventuali helper;
5. almeno un metodo di test per ciascuna categoria importante;
6. un `main` che stampi infine `TEST PASSED` o `TEST FAILED`.

Categorie minime da considerare nei test:

- struttura vuota;
- un solo elemento;
- caso normale;
- valori assenti o nessuna modifica;
- testa o radice coinvolta;
- più elementi consecutivi da modificare;
- eventuale fallimento logico indicato dalla firma.

---

# Livello 1 — Immediati

Target: 5-10 minuti per esercizio, test inclusi.

## 01 — Somma degli elementi di una lista

Implementa:

```c
long listSum(IntList list);
```

Restituisci la somma dei valori. La lista vuota ha somma `0`. Non modificare la lista.

> [!success]- Mostra soluzione e test minimi
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
>
> Test minimi:
>
> - `[] -> 0`
> - `[7] -> 7`
> - `[3, -2, 5] -> 6`
> - `[-4, -6] -> -10`


## 02 — Somma dei soli valori positivi

Implementa:

```c
long listPositiveSum(IntList list);
```

Somma soltanto i valori strettamente maggiori di zero.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> long listPositiveSum(IntList list) {
>     long sum = 0;
>
>     for (IntList current = list; current != NULL; current = current->next) {
>         if (current->data > 0) {
>             sum += current->data;
>         }
>     }
>
>     return sum;
> }
> ```
>
> Test minimi: lista vuota, soli negativi e zero, lista mista, soli positivi.


## 03 — Contare le occorrenze

Implementa:

```c
size_t listCountValue(IntList list, int value);
```

Conta quante volte `value` compare nella lista.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t listCountValue(IntList list, int value) {
>     size_t count = 0;
>
>     for (IntList current = list; current != NULL; current = current->next) {
>         if (current->data == value) {
>             count++;
>         }
>     }
>
>     return count;
> }
> ```
>
> Test minimi: zero occorrenze, una in testa, una in fondo, più occorrenze consecutive.


## 04 — Leggere l'ultimo valore

Implementa:

```c
bool listLast(IntList list, int *out);
```

Se la lista e `out` sono validi, scrivi in `*out` il valore dell'ultimo nodo e restituisci `true`. In caso contrario restituisci `false` senza scrivere.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> bool listLast(IntList list, int *out) {
>     if (list == NULL || out == NULL) {
>         return false;
>     }
>
>     while (list->next != NULL) {
>         list = list->next;
>     }
>
>     *out = list->data;
>     return true;
> }
> ```
>
> Test minimi: lista vuota, `out == NULL`, un nodo, più nodi.


## 05 — Contare le parole separate da spazi

Implementa:

```c
size_t countWords(const char *s);
```

Considera separatore soltanto `' '`. Una parola è una sequenza non vuota di caratteri diversi da spazio. Se `s == NULL`, restituisci `0`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t countWords(const char *s) {
>     if (s == NULL) {
>         return 0;
>     }
>
>     size_t count = 0;
>     bool insideWord = false;
>
>     for (size_t i = 0; s[i] != '\0'; i++) {
>         if (s[i] == ' ') {
>             insideWord = false;
>         } else if (!insideWord) {
>             count++;
>             insideWord = true;
>         }
>     }
>
>     return count;
> }
> ```
>
> Test minimi: `""`, soli spazi, una parola, spazi laterali, più spazi interni.


## 06 — Rimuovere un carattere da una stringa

Implementa:

```c
size_t removeChar(char *s, char target);
```

Rimuovi in place tutte le occorrenze di `target`, conserva l'ordine degli altri caratteri e restituisci il numero di rimozioni. Se `s == NULL`, restituisci `0`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t removeChar(char *s, char target) {
>     if (s == NULL) {
>         return 0;
>     }
>
>     size_t read = 0;
>     size_t write = 0;
>
>     while (s[read] != '\0') {
>         if (s[read] != target) {
>             s[write++] = s[read];
>         }
>         read++;
>     }
>
>     s[write] = '\0';
>     return read - write;
> }
> ```
>
> Test minimi: stringa vuota, carattere assente, tutte occorrenze, occorrenze consecutive e ai bordi.


## 07 — Somma delle foglie

Implementa:

```c
long treeLeafSum(IntTree tree);
```

Somma solo i valori delle foglie. L'albero vuoto vale `0`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> long treeLeafSum(IntTree tree) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     if (tree->left == NULL && tree->right == NULL) {
>         return tree->data;
>     }
>
>     return treeLeafSum(tree->left) + treeLeafSum(tree->right);
> }
> ```
>
> Test minimi: albero vuoto, sola radice, albero con foglie positive e negative, nodo con un solo figlio.


## 08 — Nodi con un solo figlio

Implementa:

```c
size_t treeSingleChildCount(IntTree tree);
```

Conta i nodi che hanno esattamente un figlio non `NULL`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t treeSingleChildCount(IntTree tree) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     bool hasExactlyOneChild =
>         (tree->left == NULL) != (tree->right == NULL);
>
>     return (hasExactlyOneChild ? 1U : 0U)
>          + treeSingleChildCount(tree->left)
>          + treeSingleChildCount(tree->right);
> }
> ```
>
> Test minimi: vuoto, foglia, radice con un figlio, catena, albero pieno.


## 09 — Somma dei valori dispari nell'albero

Implementa:

```c
long treeOddSum(IntTree tree);
```

Somma tutti e soli i valori dispari, inclusi quelli negativi.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> long treeOddSum(IntTree tree) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     long current = tree->data % 2 != 0 ? tree->data : 0;
>
>     return current
>          + treeOddSum(tree->left)
>          + treeOddSum(tree->right);
> }
> ```
>
> Test minimi: vuoto, soli pari, dispari negativi, albero misto.


## 10 — Minimo di un BST

Implementa:

```c
bool bstMinimum(IntTree tree, int *out);
```

L'albero rispetta la proprietà BST senza duplicati. Restituisci il minimo senza usare ricorsione.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> bool bstMinimum(IntTree tree, int *out) {
>     if (tree == NULL || out == NULL) {
>         return false;
>     }
>
>     while (tree->left != NULL) {
>         tree = tree->left;
>     }
>
>     *out = tree->data;
>     return true;
> }
> ```
>
> Test minimi: albero vuoto, sola radice, minimo in profondità, BST privo di figli sinistri.


---

# Livello 2 — Meccanica con una decisione

Target: 10-20 minuti per esercizio, test inclusi.

## 11 — Compattare i valori pari di un array

Implementa:

```c
size_t keepEven(int values[], size_t length);
```

Sposta all'inizio dell'array soltanto i valori pari, mantenendone l'ordine relativo. Non allocare memoria. Restituisci la nuova lunghezza logica.

Esempio: `[3, 4, 2, 7, 8] -> [4, 2, 8]`, nuova lunghezza `3`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t keepEven(int values[], size_t length) {
>     size_t write = 0;
>
>     for (size_t read = 0; read < length; read++) {
>         if (values[read] % 2 == 0) {
>             values[write++] = values[read];
>         }
>     }
>
>     return write;
> }
> ```
>
> Test minimi: array vuoto, tutti pari, tutti dispari, alternati, pari consecutivi.


## 12 — Comprimere gli spazi interni

Implementa:

```c
void collapseSpaces(char *s);
```

Ogni sequenza di uno o più spazi deve diventare un singolo spazio. Non rimuovere lo spazio iniziale o finale se presente. Considera spazio soltanto `' '`.

Esempio: `"  a   b  " -> " a b "`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> void collapseSpaces(char *s) {
>     if (s == NULL) {
>         return;
>     }
>
>     size_t read = 0;
>     size_t write = 0;
>     bool previousWasSpace = false;
>
>     while (s[read] != '\0') {
>         if (s[read] != ' ' || !previousWasSpace) {
>             s[write++] = s[read];
>         }
>
>         previousWasSpace = s[read] == ' ';
>         read++;
>     }
>
>     s[write] = '\0';
> }
> ```
>
> Test minimi: vuota, nessuno spazio, soli spazi, spazi ai bordi, più gruppi interni.


## 13 — Rimuovere tutte le occorrenze dalla lista

Implementa:

```c
size_t listRemoveAll(IntList *listPtr, int value);
```

Rimuovi e libera tutti i nodi contenenti `value`. Restituisci il numero di nodi eliminati. Se `listPtr == NULL`, restituisci `0`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t listRemoveAll(IntList *listPtr, int value) {
>     if (listPtr == NULL) {
>         return 0;
>     }
>
>     size_t count = 0;
>     IntList *link = listPtr;
>
>     while (*link != NULL) {
>         if ((*link)->data == value) {
>             IntList removed = *link;
>             *link = removed->next;
>             free(removed);
>             count++;
>         } else {
>             link = &(*link)->next;
>         }
>     }
>
>     return count;
> }
> ```
>
> Test minimi: `listPtr == NULL`, lista vuota, valore assente, rimozioni in testa, in mezzo, in fondo, lista composta solo dal valore.


## 14 — Spostare il minimo in testa

Implementa:

```c
void listMoveMinimumToFront(IntList *listPtr);
```

Sposta in testa il primo nodo che contiene il valore minimo. Non allocare, non liberare e non scambiare i campi `data`: devi modificare i collegamenti. Liste vuote o con un nodo restano invariate.

Esempio: `[4, 2, 7, 2, 5] -> [2, 4, 7, 2, 5]`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> void listMoveMinimumToFront(IntList *listPtr) {
>     if (listPtr == NULL || *listPtr == NULL || (*listPtr)->next == NULL) {
>         return;
>     }
>
>     IntList *minimumLink = listPtr;
>
>     for (IntList *link = &(*listPtr)->next;
>          *link != NULL;
>          link = &(*link)->next) {
>         if ((*link)->data < (*minimumLink)->data) {
>             minimumLink = link;
>         }
>     }
>
>     if (minimumLink != listPtr) {
>         IntList minimum = *minimumLink;
>         *minimumLink = minimum->next;
>         minimum->next = *listPtr;
>         *listPtr = minimum;
>     }
> }
> ```
>
> Test minimi: vuota, un nodo, minimo già in testa, minimo in mezzo, minimo in fondo, minimo duplicato.


## 15 — Dividere una lista in pari e dispari

Implementa:

```c
void listSplitParity(IntList *sourcePtr, IntList *evenPtr, IntList *oddPtr);
```

Sposta tutti i nodi di `*sourcePtr` in due liste: prima i pari e poi i dispari, conservando in ciascuna l'ordine originale. Non allocare e non liberare. All'inizio `*evenPtr` e `*oddPtr` devono essere vuote. Al termine `*sourcePtr == NULL`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> void listSplitParity(IntList *sourcePtr, IntList *evenPtr, IntList *oddPtr) {
>     if (sourcePtr == NULL || evenPtr == NULL || oddPtr == NULL) {
>         return;
>     }
>
>     *evenPtr = NULL;
>     *oddPtr = NULL;
>     IntList *evenTail = evenPtr;
>     IntList *oddTail = oddPtr;
>
>     while (*sourcePtr != NULL) {
>         IntList node = *sourcePtr;
>         *sourcePtr = node->next;
>         node->next = NULL;
>
>         if (node->data % 2 == 0) {
>             *evenTail = node;
>             evenTail = &node->next;
>         } else {
>             *oddTail = node;
>             oddTail = &node->next;
>         }
>     }
> }
> ```
>
> Test minimi: sorgente vuota, soli pari, soli dispari, alternati, ordine relativo verificato.


## 16 — Contare i nodi a profondità `k`

Implementa:

```c
size_t treeCountAtDepth(IntTree tree, size_t k);
```

La radice ha profondità `0`. Conta i nodi che si trovano esattamente a profondità `k`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t treeCountAtDepth(IntTree tree, size_t k) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     if (k == 0) {
>         return 1;
>     }
>
>     return treeCountAtDepth(tree->left, k - 1)
>          + treeCountAtDepth(tree->right, k - 1);
> }
> ```
>
> Test minimi: albero vuoto, `k == 0`, livello completo, livello parziale, `k` maggiore dell'altezza.


## 17 — Massimo tra le foglie

Implementa:

```c
bool treeLeafMaximum(IntTree tree, int *out);
```

Scrivi in `*out` il massimo valore tra le foglie. Restituisci `false` se l'albero è vuoto o `out == NULL`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static void leafMaximumRec(IntTree tree, int *maximum) {
>     if (tree->left == NULL && tree->right == NULL) {
>         if (tree->data > *maximum) {
>             *maximum = tree->data;
>         }
>         return;
>     }
>
>     if (tree->left != NULL) {
>         leafMaximumRec(tree->left, maximum);
>     }
>
>     if (tree->right != NULL) {
>         leafMaximumRec(tree->right, maximum);
>     }
> }
>
> bool treeLeafMaximum(IntTree tree, int *out) {
>     if (tree == NULL || out == NULL) {
>         return false;
>     }
>
>     *out = INT_MIN;
>     leafMaximumRec(tree, out);
>     return true;
> }
> ```
>
> Test minimi: vuoto, foglia unica, sole foglie negative, massimo a sinistra e a destra.


## 18 — Tutte le foglie alla stessa profondità

Implementa:

```c
bool treeLeavesSameDepth(IntTree tree);
```

L'albero vuoto e l'albero con una sola foglia soddisfano la proprietà.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static bool sameDepthRec(IntTree tree, size_t depth,
>                          bool *foundLeaf, size_t *leafDepth) {
>     if (tree == NULL) {
>         return true;
>     }
>
>     if (tree->left == NULL && tree->right == NULL) {
>         if (!*foundLeaf) {
>             *foundLeaf = true;
>             *leafDepth = depth;
>             return true;
>         }
>
>         return depth == *leafDepth;
>     }
>
>     return sameDepthRec(tree->left, depth + 1, foundLeaf, leafDepth)
>         && sameDepthRec(tree->right, depth + 1, foundLeaf, leafDepth);
> }
>
> bool treeLeavesSameDepth(IntTree tree) {
>     bool foundLeaf = false;
>     size_t leafDepth = 0;
>     return sameDepthRec(tree, 0, &foundLeaf, &leafDepth);
> }
> ```
>
> Test minimi: vuoto, foglia, albero perfetto, foglie su livelli diversi, catena.


## 19 — Contare i valori del BST in un intervallo

Implementa:

```c
size_t bstCountRange(IntTree tree, int low, int high);
```

Conta i valori nell'intervallo chiuso `[low, high]`. Sfrutta la proprietà BST per evitare rami sicuramente inutili. Se `low > high`, restituisci `0`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t bstCountRange(IntTree tree, int low, int high) {
>     if (tree == NULL || low > high) {
>         return 0;
>     }
>
>     if (tree->data < low) {
>         return bstCountRange(tree->right, low, high);
>     }
>
>     if (tree->data > high) {
>         return bstCountRange(tree->left, low, high);
>     }
>
>     return 1
>          + bstCountRange(tree->left, low, high)
>          + bstCountRange(tree->right, low, high);
> }
> ```
>
> Test minimi: vuoto, intervallo invertito, nessun valore, tutti i valori, solo estremi, sottoalbero potato.


---

# Livello 3 — Esercizi da ragionare

Target: 20-35 minuti per esercizio, test inclusi.

## 20 — Normalizzare gli spazi

Implementa:

```c
void normalizeSpaces(char *s);
```

Modifica la stringa in place in modo che:

- gli spazi iniziali e finali siano rimossi;
- ogni sequenza di spazi interni diventi un singolo spazio;
- si consideri spazio soltanto `' '`.

Esempio: `"   alfa   beta  " -> "alfa beta"`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> void normalizeSpaces(char *s) {
>     if (s == NULL) {
>         return;
>     }
>
>     size_t read = 0;
>     size_t write = 0;
>
>     while (s[read] == ' ') {
>         read++;
>     }
>
>     while (s[read] != '\0') {
>         if (s[read] != ' ') {
>             s[write++] = s[read++];
>         } else {
>             while (s[read] == ' ') {
>                 read++;
>             }
>
>             if (s[read] != '\0') {
>                 s[write++] = ' ';
>             }
>         }
>     }
>
>     s[write] = '\0';
> }
> ```
>
> Test minimi: `NULL`, vuota, soli spazi, nessuno spazio, spazi iniziali, finali, interni e tutti insieme.


## 21 — Rimuovere duplicati consecutivi

Implementa:

```c
size_t listRemoveAdjacentDuplicates(IntList list);
```

Ogni sequenza di valori uguali consecutivi deve lasciare un solo nodo. Libera i nodi rimossi e restituiscine il numero. La testa non deve cambiare, quindi la funzione riceve `IntList` e non `IntList *`.

Esempio: `[1, 1, 1, 3, 3, 2] -> [1, 3, 2]`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t listRemoveAdjacentDuplicates(IntList list) {
>     size_t removedCount = 0;
>     IntList current = list;
>
>     while (current != NULL && current->next != NULL) {
>         if (current->data == current->next->data) {
>             IntList removed = current->next;
>             current->next = removed->next;
>             free(removed);
>             removedCount++;
>         } else {
>             current = current->next;
>         }
>     }
>
>     return removedCount;
> }
> ```
>
> Test minimi: vuota, un nodo, nessun duplicato, duplicati in testa/in mezzo/in fondo, tutti uguali.


## 22 — Rotazione a sinistra

Implementa:

```c
void listRotateLeft(IntList *listPtr, size_t k);
```

Sposta i primi `k` nodi in fondo, mantenendo l'ordine. Non allocare e non liberare. Se `k` supera la lunghezza, usa `k % length`.

Esempio: `[1, 2, 3, 4, 5]`, `k = 2` diventa `[3, 4, 5, 1, 2]`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> void listRotateLeft(IntList *listPtr, size_t k) {
>     if (listPtr == NULL || *listPtr == NULL || (*listPtr)->next == NULL) {
>         return;
>     }
>
>     size_t length = 1;
>     IntList tail = *listPtr;
>
>     while (tail->next != NULL) {
>         tail = tail->next;
>         length++;
>     }
>
>     k %= length;
>
>     if (k == 0) {
>         return;
>     }
>
>     IntList newTail = *listPtr;
>
>     for (size_t i = 1; i < k; i++) {
>         newTail = newTail->next;
>     }
>
>     IntList newHead = newTail->next;
>     newTail->next = NULL;
>     tail->next = *listPtr;
>     *listPtr = newHead;
> }
> ```
>
> Test minimi: vuota, un nodo, `k == 0`, `k == length`, `k > length`, rotazione di `1`, rotazione di `length - 1`.


## 23 — Fondere due liste ordinate senza allocare

Implementa:

```c
IntList listMergeSorted(IntList first, IntList second);
```

Le due liste sono ordinate in modo non decrescente. Fondile riutilizzando i nodi esistenti, senza allocare o liberare. A parità, scegli prima il nodo proveniente da `first`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> IntList listMergeSorted(IntList first, IntList second) {
>     IntList result = NULL;
>     IntList *tailLink = &result;
>
>     while (first != NULL && second != NULL) {
>         IntList selected;
>
>         if (first->data <= second->data) {
>             selected = first;
>             first = first->next;
>         } else {
>             selected = second;
>             second = second->next;
>         }
>
>         *tailLink = selected;
>         tailLink = &selected->next;
>     }
>
>     *tailLink = first != NULL ? first : second;
>     return result;
> }
> ```
>
> Test minimi: entrambe vuote, una vuota, valori alternati, duplicati fra le liste, una lista interamente precedente all'altra.


## 24 — Intersezione di due liste ordinate

Implementa:

```c
IntList listSortedIntersection(IntList first, IntList second);
```

Le liste rappresentano insiemi ordinati: non contengono duplicati. Restituisci una nuova lista indipendente con i valori comuni in ordine. Se una `malloc` fallisce, libera il risultato parziale e restituisci `NULL`. Le liste originali non devono cambiare.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static void clearList(IntList *listPtr) {
>     while (listPtr != NULL && *listPtr != NULL) {
>         IntList removed = *listPtr;
>         *listPtr = removed->next;
>         free(removed);
>     }
> }
>
> IntList listSortedIntersection(IntList first, IntList second) {
>     IntList result = NULL;
>     IntList *tailLink = &result;
>
>     while (first != NULL && second != NULL) {
>         if (first->data < second->data) {
>             first = first->next;
>         } else if (second->data < first->data) {
>             second = second->next;
>         } else {
>             IntList node = malloc(sizeof *node);
>
>             if (node == NULL) {
>                 clearList(&result);
>                 return NULL;
>             }
>
>             node->data = first->data;
>             node->next = NULL;
>             *tailLink = node;
>             tailLink = &node->next;
>             first = first->next;
>             second = second->next;
>         }
>     }
>
>     return result;
> }
> ```
>
> Test minimi: due vuote, una vuota, disgiunte, identiche, intersezione parziale, indipendenza del risultato.


## 25 — Somma delle foglie con genitore positivo

Implementa:

```c
long treeLeafSumWithPositiveParent(IntTree tree);
```

Somma i valori delle foglie il cui genitore ha valore strettamente positivo. La radice, se è una foglia, non ha genitore e non va sommata.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static long leafSumParentRec(IntTree tree, bool hasParent,
>                              int parentValue) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     if (tree->left == NULL && tree->right == NULL) {
>         return hasParent && parentValue > 0 ? tree->data : 0;
>     }
>
>     return leafSumParentRec(tree->left, true, tree->data)
>          + leafSumParentRec(tree->right, true, tree->data);
> }
>
> long treeLeafSumWithPositiveParent(IntTree tree) {
>     return leafSumParentRec(tree, false, 0);
> }
> ```
>
> Test minimi: vuoto, radice-foglia, foglie sotto genitori positivi, nulli e negativi.


## 26 — Esistenza di un cammino con somma data

Implementa:

```c
bool treeHasRootToLeafSum(IntTree tree, long target);
```

Restituisci `true` se esiste almeno un cammino dalla radice a una foglia la cui somma è `target`. Un albero vuoto non contiene cammini, nemmeno per `target == 0`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> bool treeHasRootToLeafSum(IntTree tree, long target) {
>     if (tree == NULL) {
>         return false;
>     }
>
>     long remaining = target - tree->data;
>
>     if (tree->left == NULL && tree->right == NULL) {
>         return remaining == 0;
>     }
>
>     return treeHasRootToLeafSum(tree->left, remaining)
>         || treeHasRootToLeafSum(tree->right, remaining);
> }
> ```
>
> Test minimi: vuoto, sola radice corretta e scorretta, somma trovata a sinistra/destra, valori negativi, somma che termina su nodo non foglia.


## 27 — Specchiare un albero in place

Implementa:

```c
void treeMirror(IntTree tree);
```

Scambia ricorsivamente il sottoalbero sinistro con quello destro. Non allocare e non liberare.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> void treeMirror(IntTree tree) {
>     if (tree == NULL) {
>         return;
>     }
>
>     IntTree temporary = tree->left;
>     tree->left = tree->right;
>     tree->right = temporary;
>
>     treeMirror(tree->left);
>     treeMirror(tree->right);
> }
> ```
>
> Test minimi: vuoto, foglia, solo figlio sinistro, albero asimmetrico, doppia applicazione che ripristina l'originale.


## 28 — Clonare un albero in modo difensivo

Implementa:

```c
IntTree treeClone(IntTree tree);
```

Restituisci una copia profonda. Se una qualsiasi allocazione fallisce, libera tutta la copia parziale e restituisci `NULL`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static void treeFree(IntTree tree) {
>     if (tree == NULL) {
>         return;
>     }
>
>     treeFree(tree->left);
>     treeFree(tree->right);
>     free(tree);
> }
>
> IntTree treeClone(IntTree tree) {
>     if (tree == NULL) {
>         return NULL;
>     }
>
>     IntTree copy = malloc(sizeof *copy);
>
>     if (copy == NULL) {
>         return NULL;
>     }
>
>     copy->data = tree->data;
>     copy->left = NULL;
>     copy->right = NULL;
>
>     if (tree->left != NULL) {
>         copy->left = treeClone(tree->left);
>
>         if (copy->left == NULL) {
>             treeFree(copy);
>             return NULL;
>         }
>     }
>
>     if (tree->right != NULL) {
>         copy->right = treeClone(tree->right);
>
>         if (copy->right == NULL) {
>             treeFree(copy);
>             return NULL;
>         }
>     }
>
>     return copy;
> }
> ```
>
> Test minimi: vuoto, foglia, albero asimmetrico, uguaglianza dei valori, indirizzi diversi, modifica della copia che non altera l'originale.


---

# Livello 4 — Impestati

Target: 35-60 minuti per esercizio, test inclusi.

## 29 — Partizione stabile in place

Implementa:

```c
typedef bool (*IntPredicate)(int value);

void listStablePartition(IntList *listPtr, IntPredicate predicate);
```

Riordina i nodi mettendo prima quelli per cui `predicate` è vera e poi gli altri. Conserva l'ordine relativo all'interno dei due gruppi. Non allocare, non liberare e non scambiare i dati. Se uno degli argomenti è `NULL`, non fare nulla.

Esempio con predicato “è pari”: `[3, 2, 4, 1, 6] -> [2, 4, 6, 3, 1]`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> void listStablePartition(IntList *listPtr, IntPredicate predicate) {
>     if (listPtr == NULL || predicate == NULL) {
>         return;
>     }
>
>     IntList yes = NULL;
>     IntList no = NULL;
>     IntList *yesTail = &yes;
>     IntList *noTail = &no;
>
>     while (*listPtr != NULL) {
>         IntList node = *listPtr;
>         *listPtr = node->next;
>         node->next = NULL;
>
>         if (predicate(node->data)) {
>             *yesTail = node;
>             yesTail = &node->next;
>         } else {
>             *noTail = node;
>             noTail = &node->next;
>         }
>     }
>
>     *yesTail = no;
>     *listPtr = yes;
> }
> ```
>
> Test minimi: vuota, tutti veri, tutti falsi, alternati, ordine relativo, predicato `NULL`.


## 30 — Invertire la lista a blocchi di `k`

Implementa:

```c
void listReverseGroups(IntList *listPtr, size_t k);
```

Inverti i nodi in gruppi consecutivi di `k`, senza allocare e senza scambiare i dati. Se l'ultimo gruppo contiene meno di `k` nodi, lascialo invariato.

Esempio: `[1, 2, 3, 4, 5, 6, 7]`, `k = 3` diventa `[3, 2, 1, 6, 5, 4, 7]`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> void listReverseGroups(IntList *listPtr, size_t k) {
>     if (listPtr == NULL || k < 2) {
>         return;
>     }
>
>     IntList *groupLink = listPtr;
>
>     while (*groupLink != NULL) {
>         IntList check = *groupLink;
>
>         for (size_t i = 0; i < k; i++) {
>             if (check == NULL) {
>                 return;
>             }
>             check = check->next;
>         }
>
>         IntList oldHead = *groupLink;
>         IntList previous = check;
>         IntList current = oldHead;
>
>         for (size_t i = 0; i < k; i++) {
>             IntList next = current->next;
>             current->next = previous;
>             previous = current;
>             current = next;
>         }
>
>         *groupLink = previous;
>         groupLink = &oldHead->next;
>     }
> }
> ```
>
> Test minimi: vuota, `k == 0`, `k == 1`, `k > length`, lunghezza multipla di `k`, resto finale, `k == length`.


## 31 — Eliminare in base alla somma precedente

Implementa:

```c
size_t listRemoveBelowPrefixSum(IntList *listPtr);
```

Scorri la lista originale da sinistra a destra. Rimuovi un nodo se il suo valore è strettamente minore della somma dei valori di tutti i nodi originali che lo precedevano. La somma prefissa deve includere anche i valori dei nodi rimossi. Libera i nodi eliminati e restituiscine il numero.

Esempio: `[3, 1, 10, 5]` diventa `[3, 10]`:

- `3` resta, prefisso successivo `3`;
- `1 < 3`, quindi si elimina, ma il prefisso diventa `4`;
- `10 >= 4`, resta, prefisso `14`;
- `5 < 14`, si elimina.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> size_t listRemoveBelowPrefixSum(IntList *listPtr) {
>     if (listPtr == NULL) {
>         return 0;
>     }
>
>     long prefixSum = 0;
>     size_t removedCount = 0;
>     IntList *link = listPtr;
>
>     while (*link != NULL) {
>         IntList current = *link;
>         long value = current->data;
>
>         if (value < prefixSum) {
>             *link = current->next;
>             free(current);
>             removedCount++;
>         } else {
>             link = &current->next;
>         }
>
>         prefixSum += value;
>     }
>
>     return removedCount;
> }
> ```
>
> Test minimi: vuota, un nodo, esempio dato, nodi negativi, eliminazioni consecutive, verifica che i rimossi contribuiscano ancora al prefisso.


## 32 — Validare un BST senza duplicati

Implementa:

```c
bool treeIsStrictBST(IntTree tree);
```

Verifica che per ogni nodo tutti i valori a sinistra siano strettamente minori e tutti quelli a destra strettamente maggiori. Devi gestire correttamente anche `INT_MIN` e `INT_MAX`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static bool strictBstRec(IntTree tree,
>                          bool hasLower, int lower,
>                          bool hasUpper, int upper) {
>     if (tree == NULL) {
>         return true;
>     }
>
>     if ((hasLower && tree->data <= lower)
>         || (hasUpper && tree->data >= upper)) {
>         return false;
>     }
>
>     return strictBstRec(tree->left,
>                         hasLower, lower,
>                         true, tree->data)
>         && strictBstRec(tree->right,
>                         true, tree->data,
>                         hasUpper, upper);
> }
>
> bool treeIsStrictBST(IntTree tree) {
>     return strictBstRec(tree, false, 0, false, 0);
> }
> ```
>
> Test minimi: vuoto, foglia, BST valido, violazione locale, violazione profonda, duplicato, nodi `INT_MIN` e `INT_MAX`.


## 33 — Somma condizionale con profondità e genitore

Implementa:

```c
long treeConditionalSum(IntTree tree);
```

Somma il valore di un nodo soltanto se valgono tutte queste condizioni:

- il valore è dispari;
- il nodo si trova a profondità pari, con radice a profondità `0`;
- il nodo non è una foglia;
- il nodo è la radice oppure il genitore ha valore negativo.

Non modificare l'albero.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static long conditionalSumRec(IntTree tree, size_t depth,
>                               bool hasParent, int parentValue) {
>     if (tree == NULL) {
>         return 0;
>     }
>
>     bool isLeaf = tree->left == NULL && tree->right == NULL;
>     bool include = tree->data % 2 != 0
>                 && depth % 2 == 0
>                 && !isLeaf
>                 && (!hasParent || parentValue < 0);
>
>     long current = include ? tree->data : 0;
>
>     return current
>          + conditionalSumRec(tree->left, depth + 1, true, tree->data)
>          + conditionalSumRec(tree->right, depth + 1, true, tree->data);
> }
>
> long treeConditionalSum(IntTree tree) {
>     return conditionalSumRec(tree, 0, false, 0);
> }
> ```
>
> Test minimi: vuoto, radice foglia, radice inclusa, esclusione per parità/profondità/foglia/genitore, valori dispari negativi.


## 34 — Rimuovere i sottoalberi con somma troppo bassa

Implementa:

```c
long treePruneBySubtreeSum(IntTree *treePtr, long threshold);
```

Per ogni nodo calcola la somma del sottoalbero **originale** radicato in quel nodo. Se la somma è strettamente minore di `threshold`, libera l'intero sottoalbero e sostituiscilo con `NULL`. La decisione sul padre deve usare la somma originale, anche se uno dei figli è stato potato. Restituisci la somma originale dell'albero ricevuto. Se `treePtr == NULL` o l'albero è vuoto, restituisci `0`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static void freeTree(IntTree tree) {
>     if (tree == NULL) {
>         return;
>     }
>
>     freeTree(tree->left);
>     freeTree(tree->right);
>     free(tree);
> }
>
> long treePruneBySubtreeSum(IntTree *treePtr, long threshold) {
>     if (treePtr == NULL || *treePtr == NULL) {
>         return 0;
>     }
>
>     IntTree tree = *treePtr;
>     long leftSum = treePruneBySubtreeSum(&tree->left, threshold);
>     long rightSum = treePruneBySubtreeSum(&tree->right, threshold);
>     long originalSum = tree->data + leftSum + rightSum;
>
>     if (originalSum < threshold) {
>         freeTree(tree);
>         *treePtr = NULL;
>     }
>
>     return originalSum;
> }
> ```
>
> Test minimi: vuoto, foglia tenuta/potata, solo un figlio potato, padre valutato sulla somma originale, intero albero potato, valori negativi.


## 35 — Estrarre un intervallo dal BST in una lista

Implementa:

```c
IntList bstRangeToList(IntTree tree, int low, int high);
```

Restituisci una nuova lista ordinata contenente tutti i valori del BST nell'intervallo chiuso `[low, high]`. Non modificare l'albero. Sfrutta la proprietà BST. Se `low > high`, restituisci `NULL`. Se una `malloc` fallisce, libera il risultato parziale e restituisci `NULL`.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static void listFree(IntList list) {
>     while (list != NULL) {
>         IntList next = list->next;
>         free(list);
>         list = next;
>     }
> }
>
> static bool bstRangeBuild(IntTree tree, int low, int high,
>                           IntList *resultPtr, IntList **tailLinkPtr) {
>     if (tree == NULL) {
>         return true;
>     }
>
>     if (tree->data > low
>         && !bstRangeBuild(tree->left, low, high,
>                           resultPtr, tailLinkPtr)) {
>         return false;
>     }
>
>     if (tree->data >= low && tree->data <= high) {
>         IntList node = malloc(sizeof *node);
>
>         if (node == NULL) {
>             listFree(*resultPtr);
>             *resultPtr = NULL;
>             return false;
>         }
>
>         node->data = tree->data;
>         node->next = NULL;
>         **tailLinkPtr = node;
>         *tailLinkPtr = &node->next;
>     }
>
>     if (tree->data < high
>         && !bstRangeBuild(tree->right, low, high,
>                           resultPtr, tailLinkPtr)) {
>         return false;
>     }
>
>     return true;
> }
>
> IntList bstRangeToList(IntTree tree, int low, int high) {
>     if (low > high) {
>         return NULL;
>     }
>
>     IntList result = NULL;
>     IntList *tailLink = &result;
>
>     if (!bstRangeBuild(tree, low, high, &result, &tailLink)) {
>         return NULL;
>     }
>
>     return result;
> }
> ```
>
> Test minimi: vuoto, intervallo invertito, nessun valore, tutti i valori, estremi inclusi, ordine crescente, indipendenza della lista.


## 36 — Lista generica filtrata con copia profonda

Usa questi tipi:

```c
typedef struct genericNode GenericNode;
typedef GenericNode *GenericList;

struct genericNode {
    void *data;
    GenericList next;
};

typedef bool (*Predicate)(const void *data);
typedef void *(*CloneData)(const void *data);
typedef void (*FreeData)(void *data);
```

Implementa:

```c
GenericList genericFilterClone(GenericList list,
                               Predicate predicate,
                               CloneData cloneData,
                               FreeData freeData);
```

Costruisci una nuova lista contenente copie profonde, nello stesso ordine, dei dati che soddisfano il predicato. Se un callback è `NULL`, restituisci `NULL`. Se fallisce la clonazione di un dato o l'allocazione di un nodo, libera completamente il risultato parziale usando `freeData` e restituisci `NULL`. Non modificare la lista originale.

> [!success]- Mostra soluzione e test minimi
>
> ```c
> static void genericClear(GenericList list, FreeData freeData) {
>     while (list != NULL) {
>         GenericList next = list->next;
>         freeData(list->data);
>         free(list);
>         list = next;
>     }
> }
>
> GenericList genericFilterClone(GenericList list,
>                                Predicate predicate,
>                                CloneData cloneData,
>                                FreeData freeData) {
>     if (predicate == NULL || cloneData == NULL || freeData == NULL) {
>         return NULL;
>     }
>
>     GenericList result = NULL;
>     GenericList *tailLink = &result;
>
>     for (GenericList current = list;
>          current != NULL;
>          current = current->next) {
>         if (!predicate(current->data)) {
>             continue;
>         }
>
>         void *dataCopy = cloneData(current->data);
>
>         if (dataCopy == NULL) {
>             genericClear(result, freeData);
>             return NULL;
>         }
>
>         GenericList node = malloc(sizeof *node);
>
>         if (node == NULL) {
>             freeData(dataCopy);
>             genericClear(result, freeData);
>             return NULL;
>         }
>
>         node->data = dataCopy;
>         node->next = NULL;
>         *tailLink = node;
>         tailLink = &node->next;
>     }
>
>     return result;
> }
> ```
>
> Test minimi:
>
> - lista vuota;
> - callback `NULL`;
> - nessun dato accettato;
> - tutti o alcuni dati accettati;
> - ordine preservato;
> - copie a indirizzi diversi dagli originali;
> - callback di clonazione simulata che fallisce dopo alcune copie, verificando il rollback.


---

# Round finali

## Round A — Rapidità

Estrai casualmente cinque esercizi dai livelli 1 e 2. Hai 60 minuti totali, inclusi i test.

## Round B — Simulazione d'esame

Scegli:

- un esercizio su stringhe o array;
- un esercizio su liste;
- un esercizio su alberi;
- un esercizio dal livello 4.

Scrivi ogni volta un programma completo da zero. Non consultare il file degli automatismi durante il primo tentativo.

## Round C — Padronanza

Per un esercizio già risolto:

1. riscrivilo con una firma diversa ma sensata;
2. aggiungi gestione di `NULL` e fallimenti di allocazione;
3. dichiara chi possiede ogni blocco di memoria;
4. calcola la complessità temporale e spaziale;
5. crea almeno un test capace di rompere una soluzione ingenua.

## Soglia pratica

- **Base solida:** risolvi senza aiuti tutti gli esercizi 01-19.
- **Livello esame:** risolvi senza aiuti almeno 7 esercizi su 9 del livello 3.
- **Livello alto:** risolvi almeno 5 esercizi su 8 del livello 4, con memoria corretta e test seri.
- **Padronanza:** sai spiegare perché la firma usa `T`, `T *` oppure `T **`, e sai prevedere tutti i casi limite prima di scrivere il ciclo o la ricorsione.
