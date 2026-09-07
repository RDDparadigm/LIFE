# Programmazione 2 — Ripasso operativo: Liste Linkate, Alberi, Stringhe

> Obiettivo: recuperare rapidamente le **regole fondamentali da scrivere a memoria** negli esercizi di C.
>
> Focus: sintassi, puntatori, `malloc/free`, trasformazioni, casi limite e schemi mentali.
>
> Non include code, stack e insiemi.

---

# 0. Regole trasversali da ricordare prima di tutto

## 0.1 `NULL` è per i puntatori

```c
List ls = NULL;
char *s = NULL;
Tree t = NULL;
```

Un campo `char` contiene invece un carattere:

```c
node->data = 'a';
node->data = '\0';
```

Non confondere:

```c
'a'     // char
"a"     // stringa: array di char terminato da '\0'
NULL    // valore nullo per puntatori
'\0'    // carattere nullo che termina una stringa
```

---

## 0.2 Prima controlla il puntatore, poi dereferenzia

Sbagliato:

```c
if (ls->data == 3 && ls != NULL) {
}
```

Corretto:

```c
if (ls != NULL && ls->data == 3) {
}
```

Lo `&&` viene valutato da sinistra a destra con short-circuit.

---

## 0.3 Pattern base di `malloc`

```c
List node = malloc(sizeof *node);

if (node == NULL) {
    return NULL;
}
```

oppure, se la funzione restituisce `_Bool`:

```c
List node = malloc(sizeof *node);

if (node == NULL) {
    return 0;
}
```

Regola:

```c
malloc(sizeof *ptr)
```

quando possibile.

---

## 0.4 Non perdere il puntatore prima di `free`

Sbagliato:

```c
ptr = NULL;
free(ptr);
```

Hai perso l'indirizzo originale.

Corretto:

```c
free(ptr);
ptr = NULL;
```

---

## 0.5 Prima salva ciò che ti serve, poi fai `free`

Sbagliato:

```c
free(node);
node = node->next;
```

Corretto:

```c
List next = node->next;
free(node);
node = next;
```

---

## 0.6 Se devi modificare un puntatore del chiamante, passa il suo indirizzo

Se hai:

```c
typedef struct node Node, *List;
```

allora:

```c
List ls;
```

è già un `Node *`.

Quindi:

```c
List *lsPtr;
```

è un:

```c
Node **
```

Serve quando devi poter cambiare `ls` nel chiamante, per esempio:

- inserimento in testa;
- cancellazione della testa;
- distruzione con assegnazione finale a `NULL`;
- modifica della root di un albero.

---

# 1. LISTE LINKATE

---

## 1.1 Definizione fondamentale

```c
typedef struct node Node, *List;

struct node {
    int data;
    List next;
};
```

Leggila così:

```text
Node = struct node
List = Node *
```

Quindi:

```c
List ls;
```

è un puntatore al primo nodo.

Lista vuota:

```c
List ls = NULL;
```

Una lista è concettualmente:

```text
NULL
```

oppure:

```text
[nodo] -> [resto della lista]
```

---

## 1.2 Accesso ai campi

Se hai:

```c
List current;
```

usa:

```c
current->data
current->next
```

equivalente a:

```c
(*current).data
(*current).next
```

---

## 1.3 Creazione di un nodo

Da saper scrivere senza pensare:

```c
static List makeNode(int value) {
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

# 2. Attraversare una lista

Pattern fondamentale:

```c
List current = ls;

while (current != NULL) {
    /* usa current->data */
    current = current->next;
}
```

Oppure:

```c
for (List current = ls;
     current != NULL;
     current = current->next) {

    /* usa current->data */
}
```

Esempio: lunghezza.

```c
size_t listLength(List ls) {
    size_t count = 0;

    for (List current = ls;
         current != NULL;
         current = current->next) {
        count++;
    }

    return count;
}
```

Esempio: ricerca.

```c
_Bool contains(List ls, int value) {
    for (List current = ls;
         current != NULL;
         current = current->next) {

        if (current->data == value) {
            return 1;
        }
    }

    return 0;
}
```

---

# 3. Inserimento in testa

Questa è una delle regole più importanti del corso.

Hai:

```text
head
 ↓
[A] -> [B] -> NULL
```

Vuoi inserire `X`.

## Regola

```c
newNode->next = head;
head = newNode;
```

Se devi modificare la testa del chiamante:

```c
_Bool pushFront(List *lsPtr, int value) {
    if (lsPtr == NULL) {
        return 0;
    }

    List node = makeNode(value);

    if (node == NULL) {
        return 0;
    }

    node->next = *lsPtr;
    *lsPtr = node;

    return 1;
}
```

Schema mentale:

```text
1. nuovo.next = vecchia testa
2. testa = nuovo
```

---

# 4. Inserire sempre in testa = inversione automatica

Questo è il principio che ti aveva fregato.

Input:

```text
1 2 3
```

Parti da:

```c
List head = NULL;
```

Leggi `1`:

```text
1
```

Leggi `2`, inserisci in testa:

```text
2 -> 1
```

Leggi `3`, inserisci in testa:

```text
3 -> 2 -> 1
```

Quindi:

```c
node->next = head;
head = node;
```

su una sequenza letta da sinistra verso destra costruisce la sequenza al contrario.

---

# 5. Inserimento in coda

Se devi mantenere l'ordine originale conviene avere:

```c
List head = NULL;
List tail = NULL;
```

Nuovo nodo:

```c
List node = makeNode(value);
```

Caso lista vuota:

```c
if (head == NULL) {
    head = node;
    tail = node;
}
```

Caso generale:

```c
else {
    tail->next = node;
    tail = node;
}
```

Schema:

```text
lista vuota:
head = tail = nuovo

lista non vuota:
tail->next = nuovo
tail = nuovo
```

Con `tail`, l'inserimento in fondo è `O(1)`.

Senza `tail` devi cercare ogni volta l'ultimo nodo.

---

# 6. Costruire due liste durante una scansione

Pattern utilissimo negli esercizi misti.

Esempio:

- numeri in ordine inverso;
- lettere nello stesso ordine.

```c
List digitHead = NULL;

List letterHead = NULL;
List letterTail = NULL;
```

Per un numero:

```c
node->next = digitHead;
digitHead = node;
```

Per una lettera:

```c
if (letterHead == NULL) {
    letterHead = node;
    letterTail = node;
} else {
    letterTail->next = node;
    letterTail = node;
}
```

Alla fine devi unire le due liste.

Se `digitHead == NULL`:

```c
return letterHead;
```

Altrimenti cerchi la coda dei numeri:

```c
List digitTail = digitHead;

while (digitTail->next != NULL) {
    digitTail = digitTail->next;
}

digitTail->next = letterHead;

return digitHead;
```

---

# 7. Quando usare `head` e `tail`

## Solo `head`

Ti basta quando:

- inserisci sempre in testa;
- leggi la lista;
- cancelli usando altre tecniche;
- non ti serve aggiungere rapidamente in fondo.

## `head` + `tail`

Conviene quando:

- costruisci una lista mantenendo l'ordine;
- fai molti inserimenti in fondo;
- stai costruendo una nuova lista durante una scansione.

Attenzione: se inverti una lista, la vecchia `head` diventa la nuova coda.

---

# 8. Inversione iterativa di una lista

Le tre variabili da ricordare:

```c
List previous = NULL;
List current = ls;
List next = NULL;
```

Algoritmo:

```c
List reverseList(List ls) {
    List previous = NULL;
    List current = ls;

    while (current != NULL) {
        List next = current->next;

        current->next = previous;

        previous = current;
        current = next;
    }

    return previous;
}
```

Schema mentale:

```text
salva next
gira la freccia
avanza previous
avanza current
```

Non invertire senza aver salvato prima:

```c
current->next
```

altrimenti perdi il resto della lista.

---

# 9. `prev`, `current`, `next`: quando servono

Questa tripletta è utile quando devi:

- invertire;
- cancellare mantenendo il predecessore;
- spostare nodi;
- riordinare senza allocare;
- staccare e riagganciare pezzi.

Pattern:

```c
List prev = NULL;
List current = ls;

while (current != NULL) {
    List next = current->next;

    /* operazione su current */

    prev = current;
    current = next;
}
```

---

# 10. Puntatore a puntatore: il pattern più potente

Se hai:

```c
List *currentPtr = lsPtr;
```

allora `currentPtr` non punta necessariamente a un nodo.

Punta a una **variabile che contiene un `List`**.

All'inizio:

```text
currentPtr -> testa
```

Poi puoi fare:

```c
currentPtr = &((*currentPtr)->next);
```

e allora:

```text
currentPtr -> campo next di un nodo
```

Questo permette di trattare allo stesso modo:

- testa;
- link interni.

Pattern di avanzamento:

```c
while (*currentPtr != NULL) {
    currentPtr = &((*currentPtr)->next);
}
```

---

# 11. Cancellazione con puntatore a puntatore

Questa è una forma da esame molto importante.

```c
_Bool removeFirst(List *lsPtr, int value) {
    if (lsPtr == NULL) {
        return 0;
    }

    while (*lsPtr != NULL &&
           (*lsPtr)->data != value) {

        lsPtr = &((*lsPtr)->next);
    }

    if (*lsPtr == NULL) {
        return 0;
    }

    List toDelete = *lsPtr;

    *lsPtr = toDelete->next;

    free(toDelete);

    return 1;
}
```

Perché funziona?

Se devi cancellare la testa:

```text
lsPtr punta alla testa
```

Se devi cancellare un nodo interno:

```text
lsPtr punta al next del predecessore
```

La stessa istruzione:

```c
*lsPtr = toDelete->next;
```

ricuce la lista in entrambi i casi.

---

# 12. Cancellazione con `prev/current`

Versione più verbosa ma spesso più facile da visualizzare.

```c
_Bool removeFirst(List *lsPtr, int value) {
    if (lsPtr == NULL) {
        return 0;
    }

    List prev = NULL;
    List current = *lsPtr;

    while (current != NULL &&
           current->data != value) {

        prev = current;
        current = current->next;
    }

    if (current == NULL) {
        return 0;
    }

    if (prev == NULL) {
        *lsPtr = current->next;
    } else {
        prev->next = current->next;
    }

    free(current);

    return 1;
}
```

Regola:

```text
prev == NULL
```

significa che `current` è la testa.

---

# 13. Distruggere una lista

```c
static void freeList(List ls) {
    while (ls != NULL) {
        List temp = ls;
        ls = ls->next;
        free(temp);
    }
}
```

Se vuoi anche mettere a `NULL` il puntatore del chiamante:

```c
static void destroyList(List *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    while (*lsPtr != NULL) {
        List temp = *lsPtr;
        *lsPtr = (*lsPtr)->next;
        free(temp);
    }
}
```

Alla fine:

```c
*lsPtr == NULL
```

---

# 14. Ricorsione su lista

Una lista è:

```text
vuota
```

oppure:

```text
testa + resto della lista
```

Quindi lo scheletro è:

```c
int funzione(List ls) {
    if (ls == NULL) {
        /* caso base */
    }

    /* usa ls->data */
    return funzione(ls->next);
}
```

Esempio somma:

```c
int sumList(List ls) {
    if (ls == NULL) {
        return 0;
    }

    return ls->data + sumList(ls->next);
}
```

Le slide sottolineano che la ricorsione sulle liste è naturale, ma liste molto lunghe possono usare molto stack.

---

# 15. Errori classici sulle liste

## Dereferenziare un `next` senza sapere se esiste

Pericoloso:

```c
result->next->next->data
```

se non hai verificato prima che i puntatori intermedi siano non `NULL`.

Nei test:

```c
result != NULL &&
result->next != NULL &&
result->next->next != NULL &&
result->next->next->data == ...
```

---

## Confondere `data` e `next`

Se:

```c
char data;
List next;
```

allora:

```c
node->data == 'a'
node->next == NULL
```

Non:

```c
node->data == NULL
```

---

## Fare `free` senza scollegare

Prima:

```c
prev->next = current->next;
```

poi:

```c
free(current);
```

---

## Dimenticare il fallimento di `malloc`

Se una funzione costruisce più nodi e una `malloc` fallisce, devi liberare quello che hai già costruito prima di restituire errore.

---

# 16. ALBERI BINARI

---

## 16.1 Definizione base

```c
typedef struct treeNode TreeNode, *Tree;

struct treeNode {
    int data;
    Tree left;
    Tree right;
};
```

Un albero binario è:

```text
NULL
```

oppure:

```text
        nodo
       /    \
    left    right
```

`left` e `right` sono a loro volta alberi.

---

# 17. Creare un nodo di albero

```c
static Tree makeTreeNode(int value) {
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

Da ricordare:

```c
left = NULL;
right = NULL;
```

per un nuovo nodo senza figli.

---

# 18. Scheletro ricorsivo di un albero

Quasi tutte le funzioni iniziano così:

```c
qualcosa funzione(Tree tree) {
    if (tree == NULL) {
        /* caso base */
    }

    /* usa tree->data */

    funzione(tree->left);
    funzione(tree->right);
}
```

Il caso base più frequente è:

```c
tree == NULL
```

---

# 19. Visite

## Pre-order

```text
nodo
sinistro
destro
```

```c
void preorder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    printf("%d ", tree->data);
    preorder(tree->left);
    preorder(tree->right);
}
```

## In-order

```text
sinistro
nodo
destro
```

```c
void inorder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    inorder(tree->left);
    printf("%d ", tree->data);
    inorder(tree->right);
}
```

Su un BST/ARB produce i valori nell'ordine previsto dall'invariante dell'albero.

## Post-order

```text
sinistro
destro
nodo
```

```c
void postorder(Tree tree) {
    if (tree == NULL) {
        return;
    }

    postorder(tree->left);
    postorder(tree->right);
    printf("%d ", tree->data);
}
```

La post-order è fondamentale per la distruzione.

---

# 20. Contare i nodi

```c
size_t treeCount(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    return 1 +
           treeCount(tree->left) +
           treeCount(tree->right);
}
```

Schema mentale:

```text
me stesso
+ nodi a sinistra
+ nodi a destra
```

---

# 21. Contare le foglie

Foglia:

```c
tree->left == NULL &&
tree->right == NULL
```

```c
size_t countLeaves(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    if (tree->left == NULL &&
        tree->right == NULL) {
        return 1;
    }

    return countLeaves(tree->left) +
           countLeaves(tree->right);
}
```

---

# 22. Altezza

Prima di implementarla, controlla sempre **come la consegna definisce l'altezza**.

Possibili convenzioni:

```text
albero vuoto = -1, foglia = 0
```

oppure:

```text
albero vuoto = 0, foglia = 1
```

Non inventare: segui la specifica dell'esercizio.

Con convenzione `vuoto = 0`:

```c
size_t height(Tree tree) {
    if (tree == NULL) {
        return 0;
    }

    size_t leftH = height(tree->left);
    size_t rightH = height(tree->right);

    return 1 + (leftH > rightH ? leftH : rightH);
}
```

---

# 23. BST / ARB: invariante fondamentale

Per ogni nodo:

```text
valori a sinistra <= / < nodo
valori a destra   >= / > nodo
```

La politica esatta sui duplicati dipende dalla specifica.

Questa proprietà permette di scegliere un solo sottoalbero durante la ricerca.

---

# 24. Ricerca in BST

```c
_Bool searchBST(Tree tree, int value) {
    if (tree == NULL) {
        return 0;
    }

    if (value < tree->data) {
        return searchBST(tree->left, value);
    }

    if (value > tree->data) {
        return searchBST(tree->right, value);
    }

    return 1;
}
```

Schema:

```text
value < data -> sinistra
value > data -> destra
value == data -> trovato
```

---

# 25. Inserimento in BST

Se l'inserimento può modificare la root:

```c
Tree *treePtr
```

Pattern ricorsivo:

```c
_Bool insertBST(Tree *treePtr, int value) {
    if (treePtr == NULL) {
        return 0;
    }

    if (*treePtr == NULL) {
        Tree node = makeTreeNode(value);

        if (node == NULL) {
            return 0;
        }

        *treePtr = node;
        return 1;
    }

    if (value < (*treePtr)->data) {
        return insertBST(&((*treePtr)->left), value);
    }

    if (value > (*treePtr)->data) {
        return insertBST(&((*treePtr)->right), value);
    }

    return 0;
}
```

Il passaggio:

```c
&((*treePtr)->left)
```

significa:

```text
indirizzo della variabile che contiene il puntatore al figlio sinistro
```

Stesso principio del puntatore a puntatore nelle liste.

---

# 26. Trovare minimo e massimo in BST

Minimo:

```c
Tree current = tree;

while (current->left != NULL) {
    current = current->left;
}
```

Massimo:

```c
Tree current = tree;

while (current->right != NULL) {
    current = current->right;
}
```

Prima devi sapere dalla specifica se `tree == NULL` è ammesso.

---

# 27. Clonare un albero

Idea:

```text
clona nodo
clona sottoalbero sinistro
clona sottoalbero destro
```

Versione concettuale:

```c
Tree cloneTree(Tree tree) {
    if (tree == NULL) {
        return NULL;
    }

    Tree copy = makeTreeNode(tree->data);

    if (copy == NULL) {
        return NULL;
    }

    copy->left = cloneTree(tree->left);
    copy->right = cloneTree(tree->right);

    return copy;
}
```

Ma se vuoi gestire correttamente i fallimenti di `malloc`, devi evitare di lasciare copie parziali allocate.

Idea difensiva:

```text
se il clone del figlio doveva esistere ma torna NULL
-> libera ciò che hai già costruito
-> fallisci
```

Il clone deve essere **indipendente**:

```text
nodi nuovi
stessi valori
nessun nodo condiviso
```

---

# 28. Distruggere un albero

Devi usare post-order:

```text
distruggi sinistra
distruggi destra
libera nodo
```

```c
void destroyTree(Tree *treePtr) {
    if (treePtr == NULL ||
        *treePtr == NULL) {
        return;
    }

    destroyTree(&((*treePtr)->left));
    destroyTree(&((*treePtr)->right));

    free(*treePtr);
    *treePtr = NULL;
}
```

Non fare:

```c
free(*treePtr);
destroyTree(&((*treePtr)->left));
```

perché dopo `free` non puoi più leggere i figli.

---

# 29. Alberi: regole mentali da avere automatiche

```text
funzione ricorsiva -> caso base tree == NULL
```

```text
visita / conteggio -> ricorsione su left e right
```

```text
BST search -> scegli UNO dei due rami
```

```text
destroy -> post-order
```

```text
modifico root o child pointer -> Tree *
```

```text
clone -> malloc di nuovi nodi
```

---

# 30. STRINGHE IN C

---

## 30.1 Cos'è una stringa

Una stringa C è una sequenza di `char` terminata da:

```c
'\0'
```

```c
char s[] = "ciao";
```

Memoria:

```text
'c' 'i' 'a' 'o' '\0'
```

---

# 31. `char` vs stringa

Un carattere:

```c
'a'
```

ha tipo `char`.

Una stringa:

```c
"a"
```

è una sequenza:

```text
'a' '\0'
```

Quindi:

```c
node->data == 'a'
```

se `data` è `char`.

Non:

```c
node->data == "a"
```

---

# 32. Array di char e puntatore

```c
char s[] = "abc";
```

`s` è un array.

Quando lo passi a una funzione:

```c
funzione(s);
```

nella maggior parte delle espressioni `s` decade a:

```c
&s[0]
```

cioè a un:

```c
char *
```

Per questo:

```c
void funzione(char *s);
```

può ricevere:

```c
char data[] = "abc";
funzione(data);
```

Non devi fare `malloc` solo per preparare una stringa di test nota.

---

# 33. `char s[]` vs `char *s = "..."`

```c
char s1[] = "ciao";
```

crea un array modificabile.

```c
s1[0] = 'C';
```

è valido.

Invece:

```c
char *s2 = "ciao";
```

punta a una string literal, che non devi modificare.

Meglio:

```c
const char *s2 = "ciao";
```

---

# 34. Parametri `const char *`

Se una funzione legge soltanto:

```c
List buildList(const char *s);
```

`const` comunica che la funzione non deve modificare i caratteri puntati tramite `s`.

---

# 35. Scansione di una stringa

Pattern fondamentale:

```c
for (size_t i = 0;
     s[i] != '\0';
     i++) {

    char c = s[i];

    /* usa c */
}
```

Oppure:

```c
size_t i = 0;

while (s[i] != '\0') {
    char c = s[i];
    i++;
}
```

Non devi conoscere prima la lunghezza per fare una scansione semplice.

---

# 36. Lunghezza manuale

```c
size_t length = 0;

while (s[length] != '\0') {
    length++;
}
```

Alla fine:

```text
length = numero di caratteri prima di '\0'
```

---

# 37. `strlen` vs `sizeof`

```c
char s[] = "ciao";
```

```c
strlen(s)   // 4
sizeof s    // 5
```

`strlen` conta i caratteri prima di `'\0'`.

`sizeof` sull'array locale conta tutti i byte dell'array, incluso il terminatore.

Dentro una funzione con parametro:

```c
void f(char s[])
```

`s` è trattato come puntatore, quindi `sizeof s` non dà la lunghezza della stringa.

---

# 38. Confrontare stringhe

Sbagliato:

```c
if (a == b) {
}
```

confronta gli indirizzi.

Corretto:

```c
if (strcmp(a, b) == 0) {
}
```

Per un singolo `char` invece:

```c
if (c == 'a') {
}
```

---

# 39. Allocare una nuova stringa

Se devi copiare una stringa di lunghezza `n`, servono:

```text
n + 1
```

caratteri.

Il `+1` è per:

```c
'\0'
```

Pattern:

```c
size_t length = strlen(source);

char *copy =
    malloc((length + 1) * sizeof *copy);

if (copy == NULL) {
    return NULL;
}
```

---

# 40. Copia manuale

```c
for (size_t i = 0; i <= length; i++) {
    copy[i] = source[i];
}
```

Nota il:

```c
<=
```

perché devi copiare anche:

```c
'\0'
```

Oppure:

```c
strcpy(copy, source);
```

se lo spazio è sufficiente.

---

# 41. Stringa vuota dinamica

Una stringa vuota è:

```text
""
```

ma contiene comunque:

```c
'\0'
```

Quindi serve almeno:

```c
malloc(1)
```

e:

```c
result[0] = '\0';
```

---

# 42. Pattern a due passaggi

Molto utile quando la dimensione finale non è nota subito.

Esempio: voglio una nuova stringa con solo le cifre.

Primo passaggio:

```text
conto quante cifre
```

Poi:

```c
malloc(count + 1)
```

Secondo passaggio:

```text
copio le cifre
```

Alla fine:

```c
result[write] = '\0';
```

---

# 43. Pattern read/write per modifica in-place

Quando devi filtrare una stringa senza allocare:

```c
size_t read = 0;
size_t write = 0;

while (s[read] != '\0') {
    if (/* carattere da mantenere */) {
        s[write] = s[read];
        write++;
    }

    read++;
}

s[write] = '\0';
```

Esempio: rimuovere tutti gli spazi.

```c
void removeSpaces(char *s) {
    if (s == NULL) {
        return;
    }

    size_t write = 0;

    for (size_t read = 0;
         s[read] != '\0';
         read++) {

        if (s[read] != ' ') {
            s[write] = s[read];
            write++;
        }
    }

    s[write] = '\0';
}
```

---

# 44. Classificare caratteri manualmente

Cifra:

```c
c >= '0' && c <= '9'
```

Minuscola:

```c
c >= 'a' && c <= 'z'
```

Maiuscola:

```c
c >= 'A' && c <= 'Z'
```

Queste comparazioni funzionano perché i caratteri sono rappresentati da valori ordinati coerentemente per questi intervalli nell'ambiente C usato dal corso.

---

# 45. Stringa -> lista

Pattern generale dell'esercizio che stai facendo:

```c
List buildSomething(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    /* teste/code */

    for (size_t i = 0;
         s[i] != '\0';
         i++) {

        char c = s[i];

        /* valida c */

        /* se serve: malloc nodo */

        /* aggancia nodo */
    }

    /* merge */

    return result;
}
```

Attenzione:

```text
la stringa è input
la lista è output
```

Nel test:

```c
char input[] = "123ab";

List result = buildSomething(input);
```

Non devi creare dinamicamente l'input se è noto a compile-time.

---

# 46. Validazione globale durante una costruzione

Esempio:

```text
se compare una maiuscola -> risultato invalido
```

Se hai già allocato nodi:

```c
if (c >= 'A' && c <= 'Z') {
    freeList(head);
    return NULL;
}
```

Non basta:

```c
return NULL;
```

se perderesti memoria già allocata.

---

# 47. Trasformazioni tipiche sulle stringhe

## Invertire una stringa in-place

Idea:

```text
left
right
swap
```

```c
void reverseString(char *s) {
    if (s == NULL) {
        return;
    }

    size_t len = strlen(s);

    if (len == 0) {
        return;
    }

    size_t left = 0;
    size_t right = len - 1;

    while (left < right) {
        char temp = s[left];
        s[left] = s[right];
        s[right] = temp;

        left++;
        right--;
    }
}
```

---

## Filtrare in nuova memoria

```text
1. conta
2. malloc
3. copia
4. '\0'
```

---

## Filtrare in-place

```text
read / write
```

---

## Confrontare

```c
strcmp
```

non `==`.

---

# 48. TDD minimo per queste strutture

Anche se il focus è il ripasso delle strutture, tieni fisso questo schema.

## Funzione che restituisce una lista

```c
static int testCase(void) {
    char input[] = "abc";

    List result = buildList(input);

    int passed =
        /* controlli */;

    freeList(result);

    return passed;
}
```

## Caso che deve restituire `NULL`

```c
static int testInvalid(void) {
    char input[] = "abcL123";

    List result = buildList(input);

    return result == NULL;
}
```

## Attenzione a una lista restituita

Se controlli:

```c
result->next->next->data
```

prima devi essere sicuro che tutti i puntatori intermedi esistano.

Esempio:

```c
int passed =
    result != NULL &&
    result->data == 'a' &&
    result->next != NULL &&
    result->next->data == 'b' &&
    result->next->next == NULL;
```

---

# 49. Checklist rapidissima — LISTE

Prima di scrivere:

- [ ] `List` è già un puntatore?
- [ ] Devo cambiare la testa? Se sì, serve `List *`.
- [ ] Sto inserendo in testa o in coda?
- [ ] Inserimento in testa = ordine inverso.
- [ ] Inserimento in coda = ordine mantenuto.
- [ ] Se uso la coda, ho aggiornato `tail`?
- [ ] Prima di `free`, ho salvato `next`?
- [ ] Se cancello, ho ricucito la lista?
- [ ] Se `malloc` fallisce, cosa libero?
- [ ] Dopo la distruzione, resta qualche dangling pointer?

---

# 50. Checklist rapidissima — ALBERI

- [ ] Caso base `tree == NULL`.
- [ ] Ho inizializzato `left` e `right`?
- [ ] Devo visitare entrambi i figli o solo uno?
- [ ] Se è BST: `<` sinistra, `>` destra.
- [ ] Se modifico root/figlio: `Tree *`.
- [ ] Destroy: sinistra, destra, nodo.
- [ ] Clone: nodi nuovi, non puntatori condivisi.
- [ ] Se una `malloc` fallisce durante clone/insert, gestisco la memoria già allocata?

---

# 51. Checklist rapidissima — STRINGHE

- [ ] `'a'` è `char`, `"a"` è stringa.
- [ ] Stringa termina con `'\0'`.
- [ ] Nuova stringa: `lunghezza + 1`.
- [ ] `char input[] = "..."` va bene come argomento `char *` / `const char *`.
- [ ] `strlen` non è `sizeof`.
- [ ] Stringhe: `strcmp`, non `==`.
- [ ] Modifica in-place: spesso `read/write`.
- [ ] Nuova stringa filtrata: conta -> `malloc` -> copia -> `'\0'`.
- [ ] Non modificare una string literal.
- [ ] Se la funzione promette sola lettura, usa `const char *`.

---

# 52. Le 12 righe da saper riscrivere a memoria

## Nodo lista

```c
List node = malloc(sizeof *node);
if (node == NULL) return NULL;
node->data = value;
node->next = NULL;
```

## Inserimento in testa

```c
node->next = head;
head = node;
```

## Inserimento in coda

```c
if (head == NULL) {
    head = tail = node;
} else {
    tail->next = node;
    tail = node;
}
```

## Scansione lista

```c
for (List current = head;
     current != NULL;
     current = current->next) {
}
```

## Free lista

```c
while (head != NULL) {
    List temp = head;
    head = head->next;
    free(temp);
}
```

## Scheletro albero

```c
if (tree == NULL) {
    return ...;
}
```

## Ricorsione sui figli

```c
funzione(tree->left);
funzione(tree->right);
```

## Scansione stringa

```c
for (size_t i = 0; s[i] != '\0'; i++) {
    char c = s[i];
}
```

## Nuova stringa

```c
char *result = malloc((length + 1) * sizeof *result);
if (result == NULL) {
    return NULL;
}
```

## Terminazione stringa

```c
result[write] = '\0';
```

---

# 53. Fonte e perimetro

Questo ripasso è costruito sui materiali del progetto di Programmazione 2, in particolare sui contenuti relativi a:

- liste linkate e ricorsione su liste;
- alberi binari e alberi di ricerca binari;
- allocazione dinamica e puntatori;
- stringhe dinamiche e operazioni su array di `char`;
- materiale di preparazione teorica e allenamento d'esame già presente nel progetto.

L'obiettivo non è sostituire le slide, ma condensare le regole operative da recuperare velocemente prima di tornare agli esercizi.
