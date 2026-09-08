# Programmazione 2 — Warm-up totale C

> **Obiettivo:** arrivare all'esame con sintassi e pattern fondamentali automatici.
>
> **Uso:** leggi la domanda, scrivi la risposta *prima* di aprire il riquadro, poi confronta.
>
> Le risposte sono nascoste con `<details>` / `<summary>`, quindi sono rivelabili nei renderer Markdown che supportano HTML.

## Routine consigliata

- **Warm-up quotidiano:** 20–30 domande.
- **Prima di un esercizio di liste:** fai almeno 10 domande della sezione liste.
- **Prima di un esercizio di alberi:** fai almeno 10 domande alberi/ricorsione.
- **Negli ultimi giorni:** usa la sezione “Raffica da 2 secondi” finché la mano parte senza ricostruire la sintassi.

---

# 1. Fondamentali assoluti

### Domanda: Come si dichiara una variabile intera inizializzata a 0?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int x = 0;
```

</details>

### Domanda: Come si dichiara un `char` contenente la lettera a?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
char c = 'a';
```

</details>

### Domanda: Differenza tra `'a'` e `"a"`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
'a'   // char
"a"   // stringa: {'a', '\0'}
```

</details>

### Domanda: Come si rappresenta il terminatore di una stringa C?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
'\0'
```

</details>

### Domanda: A cosa serve `NULL`?

<details>
<summary><strong>Mostra risposta</strong></summary>

A rappresentare un puntatore nullo.

```c
int *p = NULL;
```

Non va confuso con `'\0'`.

</details>

### Domanda: Come si dichiara un puntatore a `int`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int *p;
```

</details>

### Domanda: Come si prende l'indirizzo di `x`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
&x
```

</details>

### Domanda: Come si dereferenzia `p`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
*p
```

</details>

### Domanda: Posso dereferenziare `NULL`?

<details>
<summary><strong>Mostra risposta</strong></summary>

No. È comportamento indefinito.

</details>

### Domanda: Accesso a campo `data` tramite variabile struct?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
s.data
```

</details>

### Domanda: Accesso a campo `data` tramite puntatore a struct?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
p->data
```

Equivale a `(*p).data`.

</details>

### Domanda: Come si dichiara una funzione senza parametri?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int f(void);
```

</details>

### Domanda: Come si dichiara una funzione che non restituisce niente?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
void f(void);
```

</details>

### Domanda: Cosa significa `const char *s`?

<details>
<summary><strong>Mostra risposta</strong></summary>

La funzione può leggere i caratteri puntati tramite `s`, ma non deve modificarli.

</details>

# 2. struct, typedef, enum, union

### Domanda: Come si crea una `struct` con `int x` e `double y`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
struct Point {
    int x;
    double y;
};
```

</details>

### Domanda: Come si dichiara una variabile della `struct Point`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
struct Point p;
```

</details>

### Domanda: Come si crea un typedef `Point` per una struct nominata?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
typedef struct Point Point;

struct Point {
    int x;
    double y;
};
```

</details>

### Domanda: Come si crea direttamente una struct con typedef?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
typedef struct {
    int x;
    double y;
} Point;
```

</details>

### Domanda: Come si definisce una struct autoreferenziale per lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
typedef struct node Node, *List;

struct node {
    int data;
    List next;
};
```

</details>

### Domanda: Con `typedef struct node Node, *List;`, che tipo è `List`?

<details>
<summary><strong>Mostra risposta</strong></summary>

`Node *`.

</details>

### Domanda: Come si definisce una `enum`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
enum Color {
    RED,
    GREEN,
    BLUE
};
```

</details>

### Domanda: Che valori assumono di default gli elementi di una enum?

<details>
<summary><strong>Mostra risposta</strong></summary>

`0, 1, 2, ...` salvo assegnazioni esplicite.

</details>

### Domanda: Come si assegna un valore esplicito in una enum?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
enum Status {
    OK = 1,
    ERROR = -1
};
```

</details>

### Domanda: Cos'è una `union`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Una struttura i cui membri condividono la stessa area di memoria.

</details>

### Domanda: Quando è utile `enum + union`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Per dati eterogenei con un tag che dice quale membro della union è attivo.

</details>

# 3. Puntatori e funzioni

### Domanda: In C i parametri sono passati per valore o per riferimento?

<details>
<summary><strong>Mostra risposta</strong></summary>

Sempre per valore.

</details>

### Domanda: Come si modifica un `int` del chiamante?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
void setZero(int *p) {
    if (p != NULL) {
        *p = 0;
    }
}
```

Chiamata: `setZero(&x);`

</details>

### Domanda: Perché `void f(int *p) { p = NULL; }` non azzera il puntatore del chiamante?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché `p` è una copia del puntatore.

</details>

### Domanda: Come si modifica il puntatore del chiamante?

<details>
<summary><strong>Mostra risposta</strong></summary>

Serve un puntatore a puntatore.

```c
void clearPtr(int **p) {
    if (p != NULL) {
        *p = NULL;
    }
}
```

</details>

### Domanda: Se `List` è `Node *`, che tipo è `List *`?

<details>
<summary><strong>Mostra risposta</strong></summary>

`Node **`.

</details>

### Domanda: Quando serve tipicamente un `List *`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Quando una funzione può cambiare la testa della lista.

</details>

### Domanda: Differenza tra `p`, `*p`, `&p`?

<details>
<summary><strong>Mostra risposta</strong></summary>

`p`: indirizzo contenuto. `*p`: oggetto puntato. `&p`: indirizzo della variabile puntatore.

</details>

### Domanda: Che differenza c'è tra `*p++` e `(*p)++`?

<details>
<summary><strong>Mostra risposta</strong></summary>

`*p++` equivale a `*(p++)`; `(*p)++` incrementa il valore puntato.

</details>

### Domanda: Come si dichiara un puntatore a funzione `int -> (int,int)`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int (*f)(int, int);
```

</details>

### Domanda: Come si assegna una funzione `sum` a un puntatore a funzione?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int (*f)(int, int) = sum;
```

</details>

### Domanda: Come si chiama una funzione tramite puntatore `f`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
f(2, 3);
```

oppure `(*f)(2, 3);`.

</details>

### Domanda: Come interpreti `&((*currentPtr)->next)`?

<details>
<summary><strong>Mostra risposta</strong></summary>

È l'indirizzo del campo `next` del nodo puntato da `*currentPtr`.

</details>

# 4. Memoria dinamica

### Domanda: Come si alloca un singolo `int`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int *p = malloc(sizeof *p);
```

</details>

### Domanda: Cosa controlli subito dopo `malloc`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (p == NULL) {
    /* errore */
}
```

</details>

### Domanda: Come si alloca un array dinamico di `n` int?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int *a = malloc(n * sizeof *a);
```

</details>

### Domanda: Come si libera memoria?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
free(p);
```

</details>

### Domanda: Posso fare `free(NULL)`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Sì. È definito e non fa nulla.

</details>

### Domanda: Cosa succede con un double free?

<details>
<summary><strong>Mostra risposta</strong></summary>

Comportamento indefinito.

</details>

### Domanda: Cos'è un memory leak?

<details>
<summary><strong>Mostra risposta</strong></summary>

Memoria allocata che non viene più liberata e di cui si perde il riferimento.

</details>

### Domanda: Cos'è un dangling pointer?

<details>
<summary><strong>Mostra risposta</strong></summary>

Un puntatore che punta a memoria già liberata.

</details>

### Domanda: Perché è sbagliato `p = NULL; free(p);`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché perdi l'indirizzo originale prima di liberarlo.

</details>

### Domanda: Pattern sicuro per `realloc`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int *tmp = realloc(p, newN * sizeof *p);
if (tmp != NULL) {
    p = tmp;
}
```

</details>

### Domanda: Come si alloca memoria azzerata?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int *a = calloc(n, sizeof *a);
```

</details>

### Domanda: Se una malloc successiva fallisce durante la costruzione di una struttura?

<details>
<summary><strong>Mostra risposta</strong></summary>

Devi liberare correttamente ciò che avevi già allocato.

</details>

# 5. Array e stringhe

### Domanda: Come si crea un array locale di 5 int?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int a[5];
```

</details>

### Domanda: Come si inizializza un array?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int a[] = {1, 2, 3};
```

</details>

### Domanda: Come si crea una stringa locale modificabile?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
char s[] = "ciao";
```

</details>

### Domanda: Perché `char s[]` può essere passato a `char *`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché nella maggior parte delle espressioni l'array decade a `&s[0]`.

</details>

### Domanda: Come si scorre una stringa?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
for (size_t i = 0; s[i] != '\0'; i++) {
    char ch = s[i];
}
```

</details>

### Domanda: Come si calcola manualmente la lunghezza?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
size_t len = 0;
while (s[len] != '\0') {
    len++;
}
```

</details>

### Domanda: Per `char s[] = "ciao"`, `strlen(s)` e `sizeof s`?

<details>
<summary><strong>Mostra risposta</strong></summary>

`strlen(s) == 4`, `sizeof s == 5`.

</details>

### Domanda: Come si confrontano due stringhe?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
strcmp(a, b) == 0
```

</details>

### Domanda: Perché non si usa `a == b` per confrontare stringhe?

<details>
<summary><strong>Mostra risposta</strong></summary>

Confronta gli indirizzi, non il contenuto.

</details>

### Domanda: Come si copia una stringa in un buffer abbastanza grande?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
strcpy(dest, source);
```

</details>

### Domanda: Come si concatena in un buffer abbastanza grande?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
strcat(dest, source);
```

</details>

### Domanda: Quanta memoria serve per una nuova stringa di lunghezza `len`?

<details>
<summary><strong>Mostra risposta</strong></summary>

`len + 1` caratteri, per includere `\0`.

</details>

### Domanda: Come si crea una stringa dinamica vuota?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
char *s = malloc(sizeof *s);
if (s != NULL) {
    s[0] = '\0';
}
```

</details>

### Domanda: Pattern read/write per filtrare in-place?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
size_t write = 0;
for (size_t read = 0; s[read] != '\0'; read++) {
    if (/* keep */) {
        s[write++] = s[read];
    }
}
s[write] = '\0';
```

</details>

### Domanda: Come riconosci una cifra?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
c >= '0' && c <= '9'
```

</details>

### Domanda: Come riconosci una minuscola?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
c >= 'a' && c <= 'z'
```

</details>

### Domanda: Come riconosci una maiuscola?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
c >= 'A' && c <= 'Z'
```

</details>

### Domanda: Pattern a due passaggi per nuova stringa filtrata?

<details>
<summary><strong>Mostra risposta</strong></summary>

`conta -> malloc(count + 1) -> copia -> '\0'`.

</details>

### Domanda: Come inverti una stringa in-place?

<details>
<summary><strong>Mostra risposta</strong></summary>

Due indici, `left` e `right`, e swap finché `left < right`.

</details>

### Domanda: Perché non devi modificare una string literal?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché la memoria della string literal non è modificabile in modo definito. Usa `char s[] = "..."` se devi modificare.

</details>

# 6. Liste linkate

### Domanda: Definizione base di lista di int?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
typedef struct node Node, *List;
struct node {
    int data;
    List next;
};
```

</details>

### Domanda: Come rappresenti la lista vuota?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
List ls = NULL;
```

</details>

### Domanda: Come crei un nodo?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
static List makeNode(int value) {
    List node = malloc(sizeof *node);
    if (node == NULL) return NULL;
    node->data = value;
    node->next = NULL;
    return node;
}
```

</details>

### Domanda: Come scorri una lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
for (List current = ls; current != NULL; current = current->next) {
    /* usa current->data */
}
```

</details>

### Domanda: Inserimento in testa: le due righe?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
node->next = head;
head = node;
```

</details>

### Domanda: Perché inserire 1,2,3 in testa produce 3,2,1?

<details>
<summary><strong>Mostra risposta</strong></summary>

Ogni nuovo nodo viene messo davanti alla testa precedente.

</details>

### Domanda: Inserimento in testa modificando il chiamante?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
node->next = *lsPtr;
*lsPtr = node;
```

</details>

### Domanda: Inserimento in coda con head/tail?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (head == NULL) {
    head = node;
    tail = node;
} else {
    tail->next = node;
    tail = node;
}
```

</details>

### Domanda: Quando basta `head`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Quando inserisci in testa o fai solo scansione.

</details>

### Domanda: Quando conviene `head + tail`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Quando costruisci mantenendo l'ordine o appendi spesso.

</details>

### Domanda: Come calcoli la lunghezza di una lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

Scansione con contatore finché `current != NULL`.

</details>

### Domanda: Come cerchi un valore?

<details>
<summary><strong>Mostra risposta</strong></summary>

Scorri e confronti `current->data` con il valore cercato.

</details>

### Domanda: Come liberi tutta una lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
void freeList(List ls) {
    while (ls != NULL) {
        List temp = ls;
        ls = ls->next;
        free(temp);
    }
}
```

</details>

### Domanda: Perché salvi `next` prima di fare free?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché dopo il free non puoi più leggere i campi del nodo.

</details>

### Domanda: Come inverti iterativamente una lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

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

</details>

### Domanda: Tre variabili classiche per reverse/spostamenti?

<details>
<summary><strong>Mostra risposta</strong></summary>

`previous`, `current`, `next`.

</details>

### Domanda: Come rimuovi la testa?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
List temp = *lsPtr;
*lsPtr = (*lsPtr)->next;
free(temp);
```

</details>

### Domanda: Come rimuovi un nodo interno con prev/current?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
prev->next = current->next;
free(current);
```

</details>

### Domanda: Come riconosci che current è la testa nel pattern prev/current?

<details>
<summary><strong>Mostra risposta</strong></summary>

`prev == NULL`.

</details>

### Domanda: Come rimuovi il primo valore con puntatore a puntatore?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
while (*lsPtr != NULL && (*lsPtr)->data != value) {
    lsPtr = &((*lsPtr)->next);
}
if (*lsPtr != NULL) {
    List temp = *lsPtr;
    *lsPtr = temp->next;
    free(temp);
}
```

</details>

### Domanda: Perché il puntatore a puntatore elimina il caso speciale della testa?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché punta al link da modificare: prima alla variabile testa, poi ai campi `next`.

</details>

### Domanda: Come avanzi con `List *currentPtr`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
currentPtr = &((*currentPtr)->next);
```

</details>

### Domanda: Come concateni list2 a list1 senza tail?

<details>
<summary><strong>Mostra risposta</strong></summary>

Vai fino all'ultimo nodo di `list1`, poi `last->next = list2`.

</details>

### Domanda: Dopo l'inversione, cosa diventa la vecchia testa?

<details>
<summary><strong>Mostra risposta</strong></summary>

La nuova coda.

</details>

### Domanda: Come costruisci cifre in ordine inverso durante scansione stringa?

<details>
<summary><strong>Mostra risposta</strong></summary>

Inserisci ogni cifra in testa.

</details>

### Domanda: Come costruisci lettere nello stesso ordine della stringa?

<details>
<summary><strong>Mostra risposta</strong></summary>

Inserisci in coda con head/tail.

</details>

### Domanda: Come fai merge digits + letters se non hai digitTail?

<details>
<summary><strong>Mostra risposta</strong></summary>

Scorri `digitHead` fino all'ultimo nodo e collega `digitTail->next = letterHead`.

</details>

### Domanda: Come distruggi una lista mettendo a NULL il puntatore del chiamante?

<details>
<summary><strong>Mostra risposta</strong></summary>

Usa `List *lsPtr`, avanza `*lsPtr`, libera il vecchio nodo; alla fine `*lsPtr == NULL`.

</details>

# 7. Ricorsione

### Domanda: Due ingredienti obbligatori di una ricorsione?

<details>
<summary><strong>Mostra risposta</strong></summary>

Caso base e caso ricorsivo che riduce il problema.

</details>

### Domanda: Caso base tipico su lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (ls == NULL) { ... }
```

</details>

### Domanda: Somma ricorsiva di lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (ls == NULL) return 0;
return ls->data + sumList(ls->next);
```

</details>

### Domanda: Conta nodi ricorsivo?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (ls == NULL) return 0;
return 1 + countList(ls->next);
```

</details>

### Domanda: Ricerca ricorsiva in lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

Caso base NULL; se `data == value` ritorna vero; altrimenti ricorri su `next`.

</details>

### Domanda: Rischio ricorsione su liste molto lunghe?

<details>
<summary><strong>Mostra risposta</strong></summary>

Stack overflow.

</details>

### Domanda: Perché gli alberi si prestano bene alla ricorsione?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché ogni figlio è a sua volta un albero.

</details>

# 8. Alberi binari e BST

### Domanda: Definizione base di albero binario di int?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
typedef struct treeNode TreeNode, *Tree;
struct treeNode {
    int data;
    Tree left;
    Tree right;
};
```

</details>

### Domanda: Come rappresenti un albero vuoto?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
Tree tree = NULL;
```

</details>

### Domanda: Come crei un nodo di albero?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
Tree node = malloc(sizeof *node);
if (node == NULL) return NULL;
node->data = value;
node->left = NULL;
node->right = NULL;
```

</details>

### Domanda: Caso base ricorsivo più comune?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (tree == NULL) { ... }
```

</details>

### Domanda: Ordine pre-order?

<details>
<summary><strong>Mostra risposta</strong></summary>

`nodo -> sinistra -> destra`.

</details>

### Domanda: Ordine in-order?

<details>
<summary><strong>Mostra risposta</strong></summary>

`sinistra -> nodo -> destra`.

</details>

### Domanda: Ordine post-order?

<details>
<summary><strong>Mostra risposta</strong></summary>

`sinistra -> destra -> nodo`.

</details>

### Domanda: Come conti tutti i nodi?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (tree == NULL) return 0;
return 1 + count(tree->left) + count(tree->right);
```

</details>

### Domanda: Come riconosci una foglia?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
tree->left == NULL && tree->right == NULL
```

</details>

### Domanda: Come conti le foglie?

<details>
<summary><strong>Mostra risposta</strong></summary>

Se NULL -> 0; se foglia -> 1; altrimenti somma foglie left + right.

</details>

### Domanda: Come calcoli l'altezza con vuoto=0?

<details>
<summary><strong>Mostra risposta</strong></summary>

`1 + max(height(left), height(right))`, con caso base `NULL -> 0`.

</details>

### Domanda: Cosa devi controllare sempre sulla definizione di altezza?

<details>
<summary><strong>Mostra risposta</strong></summary>

La convenzione: vuoto 0/foglia 1 oppure vuoto -1/foglia 0.

</details>

### Domanda: Invariante di un BST?

<details>
<summary><strong>Mostra risposta</strong></summary>

Valori minori a sinistra, maggiori a destra; la politica sui duplicati dipende dalla specifica.

</details>

### Domanda: Ricerca ricorsiva in BST?

<details>
<summary><strong>Mostra risposta</strong></summary>

Se NULL -> falso; se value<data vai a sinistra; se value>data vai a destra; altrimenti trovato.

</details>

### Domanda: Minimo in BST?

<details>
<summary><strong>Mostra risposta</strong></summary>

Vai sempre a sinistra finché `left == NULL`.

</details>

### Domanda: Massimo in BST?

<details>
<summary><strong>Mostra risposta</strong></summary>

Vai sempre a destra finché `right == NULL`.

</details>

### Domanda: Perché inserimento ricorsivo in BST usa spesso `Tree *`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché può modificare la root o il puntatore a un figlio.

</details>

### Domanda: Come passi ricorsivamente il figlio sinistro con Tree *?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
&((*treePtr)->left)
```

</details>

### Domanda: Schema del clone di un albero?

<details>
<summary><strong>Mostra risposta</strong></summary>

`NULL->NULL`, crea nuovo nodo, clona left, clona right, restituisci nuovo nodo.

</details>

### Domanda: Cosa significa clone indipendente?

<details>
<summary><strong>Mostra risposta</strong></summary>

Nessun nodo condiviso con l'originale.

</details>

### Domanda: Ordine corretto per distruggere un albero?

<details>
<summary><strong>Mostra risposta</strong></summary>

Post-order: distruggi sinistra, distruggi destra, libera nodo.

</details>

### Domanda: Perché non puoi liberare il nodo prima dei figli?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché perderesti/invalidaresti i puntatori `left` e `right`.

</details>

# 9. ADT, opacità, void*, puntatori a funzione

### Domanda: Cos'è un ADT?

<details>
<summary><strong>Mostra risposta</strong></summary>

Tipo + operazioni pubbliche; il client usa il tipo attraverso l'interfaccia senza dipendere dalla rappresentazione interna.

</details>

### Domanda: Separazione tipica dei file?

<details>
<summary><strong>Mostra risposta</strong></summary>

`.h` interfaccia, `.c` implementazione, file di test separato.

</details>

### Domanda: Cos'è un tipo opaco?

<details>
<summary><strong>Mostra risposta</strong></summary>

Un tipo la cui struttura interna è nascosta al client.

</details>

### Domanda: Perché usare un tipo opaco?

<details>
<summary><strong>Mostra risposta</strong></summary>

Per ridurre accoppiamento e proteggere l'implementazione.

</details>

### Domanda: Cos'è `void *`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Un puntatore generico a oggetto.

</details>

### Domanda: Posso dereferenziare direttamente un void*?

<details>
<summary><strong>Mostra risposta</strong></summary>

No. Prima devi convertirlo a un tipo concreto.

</details>

### Domanda: Rischio principale di void*?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perdita di type checking.

</details>

### Domanda: Perché un contenitore generico ordinato ha bisogno di una compare?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché non conosce il tipo concreto e quindi non sa confrontare gli elementi.

</details>

### Domanda: Firma tipica di compare generica?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int compare(const void *a, const void *b);
```

</details>

### Domanda: Come memorizzi una compare dentro una struct?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int (*compare)(const void *, const void *);
```

</details>

# 10. File

### Domanda: Tipo di un file aperto?

<details>
<summary><strong>Mostra risposta</strong></summary>

`FILE *`.

</details>

### Domanda: Header per i file?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
#include <stdio.h>
```

</details>

### Domanda: Aprire in lettura?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
FILE *fp = fopen("file.txt", "r");
```

</details>

### Domanda: Cosa controlli dopo fopen?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (fp == NULL) { ... }
```

</details>

### Domanda: Aprire in scrittura sovrascrivendo?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
fopen("file.txt", "w");
```

</details>

### Domanda: Aprire in append?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
fopen("file.txt", "a");
```

</details>

### Domanda: Chiudere file?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
fclose(fp);
```

</details>

### Domanda: Leggere un int da file?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
if (fscanf(fp, "%d", &x) == 1) { ... }
```

</details>

### Domanda: Scrivere un int su file?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
fprintf(fp, "%d\n", x);
```

</details>

### Domanda: Leggere una riga?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
fgets(buffer, sizeof buffer, fp)
```

</details>

### Domanda: Scrivere una stringa?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
fputs(s, fp);
```

</details>

### Domanda: Pattern corretto per leggere fino a fine file con fscanf?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
while (fscanf(fp, "%d", &x) == 1) {
    ...
}
```

</details>

# 11. TDD e CodeRunner

### Domanda: Ciclo base del TDD?

<details>
<summary><strong>Mostra risposta</strong></summary>

`test -> fallisce -> minimo codice -> passa -> refactor -> ripeti`.

</details>

### Domanda: Pattern mentale di un test?

<details>
<summary><strong>Mostra risposta</strong></summary>

`input -> chiamata -> actual -> expected -> confronto -> cleanup`.

</details>

### Domanda: Test NULL per `List f(const char *s)`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
static int testNull(void) {
    List result = f(NULL);
    return result == NULL;
}
```

</details>

### Domanda: Test di funzione che restituisce memoria dinamica?

<details>
<summary><strong>Mostra risposta</strong></summary>

Salva l'esito in `passed`, libera il risultato, poi `return passed;`.

</details>

### Domanda: Perché non fare `return 1` prima del free?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché creeresti un leak nel test.

</details>

### Domanda: Controllo esplicito di lista `a -> b -> NULL`?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int passed = result != NULL &&
    result->data == 'a' &&
    result->next != NULL &&
    result->next->data == 'b' &&
    result->next->next == NULL;
```

</details>

### Domanda: Perché controllare i puntatori intermedi?

<details>
<summary><strong>Mostra risposta</strong></summary>

Per non dereferenziare NULL.

</details>

### Domanda: Main semplice con TEST PASSED/FAILED?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
int passed = 1;
if (!test1()) passed = 0;
if (!test2()) passed = 0;
printf(passed ? "TEST PASSED\n" : "TEST FAILED\n");
```

</details>

### Domanda: Perché `passed = passed && test2()` può saltare test?

<details>
<summary><strong>Mostra risposta</strong></summary>

Per lo short-circuit se `passed` è già 0.

</details>

### Domanda: Alternativa compatta che esegue comunque tutti i test?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
passed &= test1();
passed &= test2();
```

</details>

### Domanda: Il test deve costruire manualmente l'output?

<details>
<summary><strong>Mostra risposta</strong></summary>

No. Deve costruire l'input, chiamare la funzione reale e controllare l'output.

</details>

### Domanda: Perché `"abcL123"` è un test migliore di `"L"` per invalidazione maiuscole?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché verifica il caso in cui la funzione abbia già elaborato/allocato qualcosa prima di incontrare l'errore.

</details>

# 12. Cicli e complessità

### Domanda: Pattern per scorrere array di n elementi?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
for (size_t i = 0; i < n; i++) { ... }
```

</details>

### Domanda: Pattern per massimo di array non vuoto?

<details>
<summary><strong>Mostra risposta</strong></summary>

Inizializza `max = a[0]`, poi scorri da `i = 1`.

</details>

### Domanda: Cos'è un invariante di ciclo?

<details>
<summary><strong>Mostra risposta</strong></summary>

Una proprietà vera prima del ciclo e preservata da ogni iterazione.

</details>

### Domanda: Correttezza di un programma = ?

<details>
<summary><strong>Mostra risposta</strong></summary>

`correttezza parziale + terminazione`.

</details>

### Domanda: Costo scansione lista di n nodi?

<details>
<summary><strong>Mostra risposta</strong></summary>

`O(n)`.

</details>

### Domanda: Costo inserimento in testa?

<details>
<summary><strong>Mostra risposta</strong></summary>

`O(1)`.

</details>

### Domanda: Costo append con tail?

<details>
<summary><strong>Mostra risposta</strong></summary>

`O(1)`.

</details>

### Domanda: Costo trovare coda senza tail?

<details>
<summary><strong>Mostra risposta</strong></summary>

`O(n)`.

</details>

### Domanda: Ricerca in BST bilanciato?

<details>
<summary><strong>Mostra risposta</strong></summary>

`O(log n)` tipicamente.

</details>

### Domanda: Ricerca in BST degenerato?

<details>
<summary><strong>Mostra risposta</strong></summary>

`O(n)` nel caso peggiore.

</details>

### Domanda: Visita completa di albero con n nodi?

<details>
<summary><strong>Mostra risposta</strong></summary>

`O(n)`.

</details>

### Domanda: Differenza intuitiva tra O e Theta?

<details>
<summary><strong>Mostra risposta</strong></summary>

`O` è limite superiore asintotico; `Theta` è ordine di crescita stretto.

</details>

# 13. Trappole teoriche

### Domanda: Locale automatica non inizializzata vale 0?

<details>
<summary><strong>Mostra risposta</strong></summary>

No. Ha valore indeterminato.

</details>

### Domanda: Globale non inizializzata vale 0?

<details>
<summary><strong>Mostra risposta</strong></summary>

Sì.

</details>

### Domanda: Locale static non inizializzata vale 0?

<details>
<summary><strong>Mostra risposta</strong></summary>

Sì.

</details>

### Domanda: Locale static mantiene il valore tra chiamate?

<details>
<summary><strong>Mostra risposta</strong></summary>

Sì.

</details>

### Domanda: Posso restituire puntatore a array locale?

<details>
<summary><strong>Mostra risposta</strong></summary>

No. L'array locale cessa di esistere al ritorno.

</details>

### Domanda: Posso restituire memoria malloc?

<details>
<summary><strong>Mostra risposta</strong></summary>

Sì, se il contratto definisce chi farà free.

</details>

### Domanda: Posso modificare una string literal?

<details>
<summary><strong>Mostra risposta</strong></summary>

No.

</details>

### Domanda: Quanto vale sizeof(char)?

<details>
<summary><strong>Mostra risposta</strong></summary>

`1` per definizione.

</details>

### Domanda: malloc azzera memoria?

<details>
<summary><strong>Mostra risposta</strong></summary>

No.

</details>

### Domanda: calloc azzera memoria?

<details>
<summary><strong>Mostra risposta</strong></summary>

Sì, azzera i byte allocati.

</details>

### Domanda: Confronto puntatori con == valido?

<details>
<summary><strong>Mostra risposta</strong></summary>

Sì.

</details>

### Domanda: Confronto stringhe con == confronta contenuto?

<details>
<summary><strong>Mostra risposta</strong></summary>

No.

</details>

### Domanda: `sizeof *list` con `List = Node *` misura cosa?

<details>
<summary><strong>Mostra risposta</strong></summary>

La dimensione di `Node`.

</details>

### Domanda: Perché `malloc(sizeof *node)` è preferibile?

<details>
<summary><strong>Mostra risposta</strong></summary>

Resta coerente col tipo puntato anche se il tipo cambia.

</details>

### Domanda: Dopo free posso leggere node->next?

<details>
<summary><strong>Mostra risposta</strong></summary>

No.

</details>

### Domanda: `a[i]` equivale a?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
*(a + i)
```

</details>

### Domanda: `p->field` equivale a?

<details>
<summary><strong>Mostra risposta</strong></summary>

```c
(*p).field
```

</details>

### Domanda: Parametro `char s[]` e `char *s`?

<details>
<summary><strong>Mostra risposta</strong></summary>

Come parametri di funzione sono regolati allo stesso modo.

</details>

### Domanda: Perché sizeof su parametro array è una trappola?

<details>
<summary><strong>Mostra risposta</strong></summary>

Perché misura il puntatore, non l'array originale.

</details>

# 14. Integrati stile esame

### Domanda: Stringa `123`: lista `321` in un passaggio?

<details>
<summary><strong>Mostra risposta</strong></summary>

Inserisci ogni cifra in testa.

</details>

### Domanda: Stringa `abc`: lista `abc` in un passaggio?

<details>
<summary><strong>Mostra risposta</strong></summary>

Inserisci ogni lettera in coda con head/tail.

</details>

### Domanda: Stringa `123ab`: strutture minime per `321ab`?

<details>
<summary><strong>Mostra risposta</strong></summary>

`digitHead`, `letterHead`, `letterTail`; cifre in testa, lettere in coda, poi merge.

</details>

### Domanda: Se durante `abcL123` incontri L?

<details>
<summary><strong>Mostra risposta</strong></summary>

Libera tutto ciò che hai già allocato e restituisci NULL.

</details>

### Domanda: Cancellare tutti i nodi pari con testa modificabile: approccio elegante?

<details>
<summary><strong>Mostra risposta</strong></summary>

Puntatore a puntatore.

</details>

### Domanda: Invertire lista senza allocare: quattro passi?

<details>
<summary><strong>Mostra risposta</strong></summary>

`salva next -> gira link -> previous=current -> current=next`.

</details>

### Domanda: Clone albero: malloc fallisce nel ramo destro. Cosa devi evitare?

<details>
<summary><strong>Mostra risposta</strong></summary>

Leak della copia parziale già costruita.

</details>

### Domanda: Due alberi uguali per struttura e valori: schema?

<details>
<summary><strong>Mostra risposta</strong></summary>

Entrambi NULL -> vero; uno solo NULL -> falso; dati uguali && same(left) && same(right).

</details>

### Domanda: Staccare/riagganciare nodi senza perderli: prima cosa?

<details>
<summary><strong>Mostra risposta</strong></summary>

Salva `next = current->next`.

</details>

### Domanda: Firma `void f(List *lsPtr)`: prima domanda mentale?

<details>
<summary><strong>Mostra risposta</strong></summary>

Può cambiare la testa del chiamante.

</details>

### Domanda: Firma `List f(const char *s)`: prima lettura mentale?

<details>
<summary><strong>Mostra risposta</strong></summary>

Input stringa, output lista; nel test `char input[]` e `List result = f(input);`.

</details>

### Domanda: Funzione restituisce nuova stringa dinamica: test minimo?

<details>
<summary><strong>Mostra risposta</strong></summary>

Chiama, verifica `result != NULL` e `strcmp`, poi `free(result)`.

</details>

### Domanda: Funzione modifica stringa in-place: cosa testi?

<details>
<summary><strong>Mostra risposta</strong></summary>

Il contenuto dell'array originale dopo la chiamata.

</details>

### Domanda: Funzione modifica lista in-place e può cambiare testa: cosa passi?

<details>
<summary><strong>Mostra risposta</strong></summary>

L'indirizzo della lista: `f(&ls);`.

</details>

### Domanda: Funzione legge soltanto una lista: cosa passi?

<details>
<summary><strong>Mostra risposta</strong></summary>

La lista per valore: `f(ls);`.

</details>

# 15. Raffica da 2 secondi

### Domanda: Inserimento in testa?

<details>
<summary><strong>Mostra risposta</strong></summary>

`node->next = head; head = node;`

</details>

### Domanda: Inserimento in coda caso non vuoto?

<details>
<summary><strong>Mostra risposta</strong></summary>

`tail->next = node; tail = node;`

</details>

### Domanda: Fine stringa?

<details>
<summary><strong>Mostra risposta</strong></summary>

`s[i] == '\0'`.

</details>

### Domanda: Fine lista?

<details>
<summary><strong>Mostra risposta</strong></summary>

`current == NULL`.

</details>

### Domanda: Caso base albero?

<details>
<summary><strong>Mostra risposta</strong></summary>

`tree == NULL`.

</details>

### Domanda: Malloc nodo?

<details>
<summary><strong>Mostra risposta</strong></summary>

`malloc(sizeof *node)`.

</details>

### Domanda: Dopo malloc?

<details>
<summary><strong>Mostra risposta</strong></summary>

`if (node == NULL) ...`.

</details>

### Domanda: Char nullo?

<details>
<summary><strong>Mostra risposta</strong></summary>

`'\0'`.

</details>

### Domanda: Puntatore nullo?

<details>
<summary><strong>Mostra risposta</strong></summary>

`NULL`.

</details>

### Domanda: Stringhe uguali?

<details>
<summary><strong>Mostra risposta</strong></summary>

`strcmp(a,b) == 0`.

</details>

### Domanda: Campo via puntatore?

<details>
<summary><strong>Mostra risposta</strong></summary>

`p->field`.

</details>

### Domanda: Indirizzo?

<details>
<summary><strong>Mostra risposta</strong></summary>

`&x`.

</details>

### Domanda: Dereferenziazione?

<details>
<summary><strong>Mostra risposta</strong></summary>

`*p`.

</details>

### Domanda: Se List=Node*, List*= ?

<details>
<summary><strong>Mostra risposta</strong></summary>

`Node **`.

</details>

### Domanda: Free lista: ordine?

<details>
<summary><strong>Mostra risposta</strong></summary>

`salva -> avanza -> free`.

</details>

### Domanda: Reverse lista: ordine?

<details>
<summary><strong>Mostra risposta</strong></summary>

`salva next -> gira -> previous -> current`.

</details>

### Domanda: BST value < data?

<details>
<summary><strong>Mostra risposta</strong></summary>

`sinistra`.

</details>

### Domanda: BST value > data?

<details>
<summary><strong>Mostra risposta</strong></summary>

`destra`.

</details>

### Domanda: Destroy albero?

<details>
<summary><strong>Mostra risposta</strong></summary>

`sinistra -> destra -> nodo`.

</details>

### Domanda: Clone albero?

<details>
<summary><strong>Mostra risposta</strong></summary>

`nodi nuovi, nessun nodo condiviso`.

</details>

### Domanda: Nuova stringa len?

<details>
<summary><strong>Mostra risposta</strong></summary>

`len + 1`.

</details>

### Domanda: Filtraggio in-place?

<details>
<summary><strong>Mostra risposta</strong></summary>

`read/write`.

</details>

### Domanda: Nuova stringa filtrata?

<details>
<summary><strong>Mostra risposta</strong></summary>

`conta -> malloc -> copia -> \0`.

</details>

### Domanda: TDD?

<details>
<summary><strong>Mostra risposta</strong></summary>

`input -> funzione -> check -> cleanup`.

</details>

### Domanda: Output finale?

<details>
<summary><strong>Mostra risposta</strong></summary>

`printf(passed ? "TEST PASSED\n" : "TEST FAILED\n");`

</details>

---

# Traguardo

Questo file contiene **231 domande**.

L'obiettivo non è ricordare una spiegazione elegante: è arrivare a questo livello:

```text
leggo la richiesta
→ riconosco il pattern
→ la mano scrive
→ solo dopo ragiono sui dettagli specifici dell'esercizio
```

Se una domanda richiede più di 10–15 secondi, segnala quella risposta come non ancora automatica.
