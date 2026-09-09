# Programmazione 2 — Quiz C: compila, non compila, runtime, UB?

> Livello: **intermedio → difficile → molto difficile → demoniaco**.
>
> Questo non è un ripasso introduttivo. L'obiettivo è riconoscere al volo:
>
> - codice sintatticamente valido ma semanticamente sbagliato;
> - errori di compilazione;
> - errori di linking;
> - bug logici;
> - memory leak;
> - dangling pointer e use-after-free;
> - comportamento indefinito;
> - errori di ownership;
> - trappole su stringhe, liste, alberi, ADT, `void *`, puntatori a funzione, file, TDD e complessità.
>
> **Regola di allenamento:** prima di aprire la risposta devi dire ad alta voce:
>
> 1. **Compila o no?**
> 2. **Se compila, è corretto?**
> 3. **Se è sbagliato, il problema emerge a compile time, link time o runtime?**
> 4. **È un bug logico, leak, dangling pointer, UB, violazione di contratto o solo cattivo design?**
>
> Le risposte sono nascoste con **callout pieghevoli nativi di Obsidian**. In Reading View o Live Preview, clicca su **Mostra risposta** per espanderle.

---


> [!info] Uso in Obsidian
> Apri il file in **Reading View** oppure **Live Preview**.
> I blocchi `Mostra risposta` sono chiusi di default.
> In **Source Mode** vedrai invece la sintassi Markdown dei callout.

# LIVELLO 1 — INTERMEDIO

### 1. Questo puntatore può essere dereferenziato?

```c
int *p;
*p = 42;
```

> [!answer]- Mostra risposta
> **Verdetto:** No. La dichiarazione compila, ma l'uso è invalido.
>
> **Quando emerge:** Runtime: comportamento indefinito.
>
> **Perché:** `p` è un puntatore locale non inizializzato e contiene un valore indeterminato.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> int x;
> int *p = &x;
> *p = 42;
> ```

### 2. `free(NULL)` è valido?

```c
int *p = NULL;
free(p);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: operazione definita, non succede nulla.
>
> **Perché:** Lo standard permette di passare `NULL` a `free`.

### 3. Posso assegnare un array a un altro array?

```c
int a[3] = {1,2,3};
int b[3];
b = a;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Gli array in C non sono assegnabili con `=`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> for (size_t i = 0; i < 3; i++) {
>     b[i] = a[i];
> }
> ```

### 4. Questo accesso è valido?

```c
int a[3] = {1,2,3};
printf("%d\n", a[3]);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: comportamento indefinito.
>
> **Perché:** Gli indici validi sono `0`, `1`, `2`. `a[3]` è un elemento oltre la fine.

### 5. Questo confronto confronta il contenuto delle stringhe?

```c
char a[] = "ciao";
char b[] = "ciao";
if (a == b) { puts("uguali"); }
```

> [!answer]- Mostra risposta
> **Verdetto:** Compila, ma non confronta il contenuto.
>
> **Quando emerge:** Runtime: risultato del confronto tra indirizzi.
>
> **Perché:** `a` e `b` decadono a puntatori ai rispettivi primi elementi. Per il contenuto serve `strcmp`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> if (strcmp(a, b) == 0) {
>     puts("uguali");
> }
> ```

### 6. Posso modificare questa stringa?

```c
char s[] = "ciao";
s[0] = 'C';
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: comportamento definito.
>
> **Perché:** `s` è un array locale modificabile inizializzato con i caratteri della stringa.

### 7. Posso modificare questa stringa?

```c
char *s = "ciao";
s[0] = 'C';
```

> [!answer]- Mostra risposta
> **Verdetto:** La dichiarazione può compilare in C, ma la modifica non è valida.
>
> **Quando emerge:** Runtime: comportamento indefinito.
>
> **Perché:** `s` punta a una string literal, che non deve essere modificata.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> const char *s = "ciao";
> ```

### 8. `sizeof` restituisce la lunghezza della stringa?

```c
char s[] = "ciao";
printf("%zu\n", sizeof s);
```

> [!answer]- Mostra risposta
> **Verdetto:** Compila, ma stampa la dimensione dell'array, non `strlen`.
>
> **Quando emerge:** Runtime: comportamento definito.
>
> **Perché:** Per questo array `sizeof s` vale 5, perché include `\0`; `strlen(s)` vale 4.

### 9. Questo `sizeof` dà il numero di elementi dell'array originale?

```c
void f(int a[]) {
    size_t n = sizeof a / sizeof a[0];
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Compile time: normalmente warning; a runtime il calcolo usa la dimensione del puntatore.
>
> **Perché:** Nei parametri di funzione `int a[]` è trattato come `int *a`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> void f(int a[], size_t n) {
>     /* usa n */
> }
> ```

### 10. Questo `malloc` alloca un `int`?

```c
int *p = malloc(sizeof *p);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: se `malloc` riesce.
>
> **Perché:** `*p` ha tipo `int`, quindi `sizeof *p` è la dimensione corretta.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> int *p = malloc(sizeof *p);
> if (p == NULL) {
>     /* errore */
> }
> ```

### 11. Questo `malloc` è sempre corretto?

```c
int *p = malloc(sizeof p);
```

> [!answer]- Mostra risposta
> **Verdetto:** No come regola generale.
>
> **Quando emerge:** Runtime: può allocare una quantità diversa da quella richiesta.
>
> **Perché:** `sizeof p` è la dimensione del puntatore, non dell'oggetto puntato. Potrebbe casualmente essere sufficiente, ma è concettualmente sbagliato.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> int *p = malloc(sizeof *p);
> ```

### 12. Posso leggere `p` dopo `free(p)`?

```c
int *p = malloc(sizeof *p);
*p = 3;
free(p);
printf("%d\n", *p);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: comportamento indefinito.
>
> **Perché:** Dopo `free`, `p` è un dangling pointer e la memoria non appartiene più al programma.

### 13. Questo azzera davvero il puntatore dopo il `free`?

```c
void destroy(int *p) {
    free(p);
    p = NULL;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Azzera solo la copia locale.
>
> **Quando emerge:** Runtime: la memoria viene liberata, ma il puntatore del chiamante resta dangling.
>
> **Perché:** I parametri sono passati per valore.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> void destroy(int **p) {
>     if (p != NULL) {
>         free(*p);
>         *p = NULL;
>     }
> }
> ```

### 14. Posso copiare una `struct` con `=`?

```c
struct P { int x; double y; };
struct P a = {1, 2.0};
struct P b = a;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Compile time e runtime: comportamento definito.
>
> **Perché:** L'assegnamento tra struct dello stesso tipo copia i membri.

### 15. E se la `struct` contiene un puntatore?

```c
struct P { char *name; };
struct P b = a;
```

> [!answer]- Mostra risposta
> **Verdetto:** Compila ed è valido come assegnamento, ma è una copia superficiale.
>
> **Quando emerge:** Runtime: possibili aliasing, double free o modifiche condivise se gestite male.
>
> **Perché:** Viene copiato l'indirizzo contenuto in `name`, non la stringa puntata.

### 16. Questa struct autoreferenziale è valida?

```c
struct node {
    int data;
    struct node next;
};
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Una struct non può contenere direttamente un oggetto del proprio stesso tipo: avrebbe dimensione infinita.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> struct node {
>     int data;
>     struct node *next;
> };
> ```

### 17. Questa invece è valida?

```c
struct node {
    int data;
    struct node *next;
};
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Un puntatore ha dimensione nota anche se il tipo puntato è ancora in definizione.

### 18. `List` qui è una struct o un puntatore?

```c
typedef struct node Node, *List;
```

> [!answer]- Mostra risposta
> **Verdetto:** `List` è un puntatore a `struct node`.
>
> **Quando emerge:** Compile time.
>
> **Perché:** È equivalente concettualmente a `typedef Node *List;`.

### 19. Se `List` è `Node *`, cosa riceve questa funzione?

```c
void f(List *lsPtr);
```

> [!answer]- Mostra risposta
> **Verdetto:** Riceve un `Node **`.
>
> **Quando emerge:** Compile time.
>
> **Perché:** `List *` è un puntatore alla variabile che contiene la testa della lista.

### 20. Questo test su un `char` è corretto?

```c
if (node->data == "a") {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Compile time: tipi incompatibili / warning diagnostico; comunque confronto semanticamente errato.
>
> **Perché:** `node->data` è un `char`, mentre `"a"` decade a `char *`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> if (node->data == 'a') {
> }
> ```

### 21. Questo test di fine lista è corretto?

```c
if (node->data == NULL) {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No come concetto.
>
> **Quando emerge:** Compile time: può ricevere diagnostica per confronto/assegnamento improprio; semanticamente sbagliato.
>
> **Perché:** `data` è un dato, mentre `NULL` serve per puntatori.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> if (node->next == NULL) {
> }
> ```

### 22. Questo accesso è sicuro?

```c
if (result != NULL && result->next->data == 'a') {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Non necessariamente.
>
> **Quando emerge:** Runtime: comportamento indefinito se `result->next == NULL`.
>
> **Perché:** Il controllo protegge `result`, ma non `result->next`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> if (result != NULL &&
>     result->next != NULL &&
>     result->next->data == 'a') {
> }
> ```

### 23. La sequenza di controlli è sicura grazie allo short-circuit?

```c
if (p != NULL && p->next != NULL && p->next->data == 3) {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: comportamento definito.
>
> **Perché:** `&&` valuta da sinistra a destra e interrompe quando una condizione è falsa.

### 24. Posso restituire questo indirizzo?

```c
int *f(void) {
    int x = 3;
    return &x;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Il codice può compilare con warning, ma il puntatore restituito non è valido.
>
> **Quando emerge:** Runtime: usarlo porta a comportamento indefinito.
>
> **Perché:** `x` ha durata automatica e cessa di esistere quando `f` termina.

### 25. Posso restituire memoria di `malloc`?

```c
int *f(void) {
    int *p = malloc(sizeof *p);
    return p;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: valido se il chiamante gestisce anche il caso `NULL` e successivamente libera la memoria.
>
> **Perché:** La memoria dinamica sopravvive al ritorno dalla funzione.

### 26. `static` locale mantiene il valore?

```c
int next(void) {
    static int x = 0;
    return ++x;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: comportamento definito.
>
> **Perché:** Una variabile locale `static` ha durata statica e conserva il valore tra chiamate.

### 27. Questa variabile globale non inizializzata parte da 0?

```c
int counter;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Prima dell'esecuzione: inizializzazione statica a zero.
>
> **Perché:** Le variabili con durata statica sono inizializzate a zero se manca un inizializzatore esplicito.

### 28. Questa variabile locale normale parte da 0?

```c
void f(void) {
    int x;
    printf("%d\n", x);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: leggere il valore indeterminato non è un uso valido.
>
> **Perché:** Le variabili automatiche locali non sono inizializzate automaticamente.

### 29. Questo confronto di `void *` è possibile?

```c
int x;
void *p = &x;
if (p != NULL) {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Compile time e runtime: valido.
>
> **Perché:** Un puntatore a oggetto può essere convertito a `void *` e confrontato con `NULL`.

### 30. Posso dereferenziare direttamente `void *`?

```c
void *p = &x;
printf("%d\n", *p);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Compile time.
>
> **Perché:** `void` non è un tipo di oggetto completo da dereferenziare.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> printf("%d\n", *(int *)p);
> ```

# LIVELLO 2 — DIFFICILE

### 31. Questo `realloc` è sicuro in caso di fallimento?

```c
p = realloc(p, newSize);
```

> [!answer]- Mostra risposta
> **Verdetto:** Compila, ma è un pattern pericoloso.
>
> **Quando emerge:** Runtime: se `realloc` fallisce, restituisce `NULL` e puoi perdere l'unico riferimento al vecchio blocco.
>
> **Perché:** Serve un temporaneo.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> void *tmp = realloc(p, newSize);
> if (tmp != NULL) {
>     p = tmp;
> }
> ```

### 32. `free` su un puntatore interno all'array dinamico è valido?

```c
int *a = malloc(10 * sizeof *a);
free(a + 3);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: comportamento indefinito.
>
> **Perché:** `free` deve ricevere `NULL` oppure esattamente un puntatore restituito da una funzione di allocazione compatibile, non un indirizzo interno.

### 33. `free` su memoria automatica?

```c
int x;
free(&x);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: comportamento indefinito.
>
> **Perché:** `&x` non è stato restituito da `malloc/calloc/realloc`.

### 34. Questo `realloc` può spostare il blocco?

```c
int *q = realloc(p, 100 * sizeof *p);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime.
>
> **Perché:** `realloc` può restituire lo stesso indirizzo oppure un nuovo indirizzo; se riesce, il vecchio puntatore non va più usato indipendentemente.

### 35. Dopo `realloc` riuscito, un puntatore interno al vecchio blocco resta valido?

```c
int *inside = p + 2;
p = realloc(p, 100 * sizeof *p);
printf("%d", *inside);
```

> [!answer]- Mostra risposta
> **Verdetto:** Non puoi farci affidamento.
>
> **Quando emerge:** Runtime: `inside` può diventare dangling se il blocco viene spostato.
>
> **Perché:** Dopo `realloc`, ricalcola eventuali puntatori interni a partire dal nuovo base pointer.

### 36. Questa conversione scarta `const`?

```c
const int x = 3;
const int *p = &x;
int *q = p;
```

> [!answer]- Mostra risposta
> **Verdetto:** Non è una conversione corretta senza diagnostica.
>
> **Quando emerge:** Compile time: il compilatore deve diagnosticare l'incompatibilità.
>
> **Perché:** Assegnare a `int *` permetterebbe di tentare una modifica di un oggetto qualificato `const`.

### 37. Il cast rende sicura la modifica?

```c
const int x = 3;
int *q = (int *)&x;
*q = 4;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: modificare un oggetto realmente definito `const` produce comportamento indefinito.
>
> **Perché:** Il cast può silenziare il type checking, non cambiare la natura dell'oggetto.

### 38. Cosa significa `const int *p`?

```c
const int *p;
```

> [!answer]- Mostra risposta
> **Verdetto:** Puntatore a `int` non modificabile tramite `p`.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Puoi cambiare `p`, ma non fare `*p = ...` tramite quel puntatore.

### 39. Cosa significa `int *const p = &x`?

```c
int *const p = &x;
```

> [!answer]- Mostra risposta
> **Verdetto:** Puntatore costante a `int` modificabile.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Puoi fare `*p = ...`, ma non puoi riassegnare `p`.

### 40. Questo prototipo protegge la lista dal cambio della testa?

```c
size_t length(const List ls);
```

> [!answer]- Mostra risposta
> **Verdetto:** Non nel modo che spesso si pensa.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Se `List` è un typedef di puntatore, `const List` rende costante la variabile puntatore locale del parametro, non i nodi puntati. Per esprimere sola lettura dei nodi serve progettare il tipo/parametro in modo coerente.

### 41. Questo ciclo libera correttamente la lista?

```c
while (ls != NULL) {
    free(ls);
    ls = ls->next;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: use-after-free / comportamento indefinito.
>
> **Perché:** Dopo `free(ls)` non puoi leggere `ls->next`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> while (ls != NULL) {
>     List next = ls->next;
>     free(ls);
>     ls = next;
> }
> ```

### 42. Questa cancellazione scollega il nodo?

```c
List current = *lsPtr;
free(current);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica: la lista contiene ancora un link verso memoria liberata.
>
> **Perché:** Prima devi aggiornare la testa o il `next` del predecessore.

### 43. Questo inserimento in testa è corretto?

```c
node->next = *lsPtr;
*lsPtr = node;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì, assumendo `lsPtr` e `node` validi.
>
> **Quando emerge:** Runtime: comportamento definito.
>
> **Perché:** È il pattern fondamentale di inserimento in testa.

### 44. Questo inserimento produce l'ordine originale?

```c
for (...) {
    node->next = head;
    head = node;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No: produce l'ordine inverso rispetto alla sequenza di elaborazione.
>
> **Quando emerge:** Runtime: logica.
>
> **Perché:** L'inserimento in testa mette ogni nuovo elemento davanti ai precedenti.

### 45. Questo inserimento in coda mantiene `tail` coerente?

```c
tail->next = node;
/* manca altro */
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Dopo l'aggancio devi aggiornare `tail = node`; inoltre va gestito il caso lista vuota.

### 46. Caso lista vuota: è sufficiente fare solo `head = node`?

```c
if (head == NULL) {
    head = node;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Non se stai mantenendo anche `tail`.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `tail` resterebbe `NULL` o incoerente.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> if (head == NULL) {
>     head = node;
>     tail = node;
> }
> ```

### 47. Dopo aver invertito la lista, la vecchia `tail` è ancora la coda?

```c
List reversed = reverseList(head);
/* uso la vecchia tail come coda */
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Dopo un'inversione, la vecchia testa diventa la nuova coda e la vecchia coda diventa la nuova testa.

### 48. Questo merge dopo reverse è corretto?

```c
List reversed = reverseList(digitHead);
digitTail->next = letters;
```

> [!answer]- Mostra risposta
> **Verdetto:** Dipende da cosa rappresenta ancora `digitTail`; spesso è sbagliato.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Se `digitTail` era la coda prima del reverse, dopo il reverse è la nuova testa. La nuova coda è la vecchia `digitHead`.

### 49. Questo pattern con `List *` può cancellare anche la testa senza caso speciale?

```c
while (*p != NULL && (*p)->data != value) {
    p = &((*p)->next);
}
List tmp = *p;
*p = tmp->next;
free(tmp);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì, ma solo se prima controlli che `*p != NULL` dopo il ciclo.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Il puntatore a puntatore punta al link da modificare, sia esso la testa sia un campo `next`.

### 50. Manca un controllo qui?

```c
while (*p != NULL && (*p)->data != value) {
    p = &((*p)->next);
}
List tmp = *p;
*p = tmp->next;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: se il valore non esiste, `*p == NULL` e `tmp->next` dereferenzia `NULL`.
>
> **Perché:** Dopo il ciclo serve `if (*p == NULL) return 0;`.

### 51. Questa ricorsione su lista termina?

```c
int count(List ls) {
    if (ls == NULL) return 0;
    return 1 + count(ls);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: ricorsione infinita fino a esaurimento dello stack.
>
> **Perché:** La chiamata ricorsiva non riduce il problema.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> return 1 + count(ls->next);
> ```

### 52. Questa funzione ricorsiva su albero conta correttamente?

```c
size_t count(Tree t) {
    if (t == NULL) return 0;
    return 1 + count(t->left) + count(t->right);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Caso base corretto e combinazione dei due sottoalberi.

### 53. Questa distruzione di albero è corretta?

```c
void destroy(Tree t) {
    if (t == NULL) return;
    free(t);
    destroy(t->left);
    destroy(t->right);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: use-after-free.
>
> **Perché:** Dopo `free(t)` non puoi leggere `t->left` e `t->right`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> destroy(t->left);
> destroy(t->right);
> free(t);
> ```

### 54. Questa clone è indipendente?

```c
Tree clone(Tree t) {
    return t;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Restituisce lo stesso puntatore; clone e originale condividono tutti i nodi.

### 55. Questa copia della root crea un clone completo?

```c
Tree c = malloc(sizeof *c);
*c = *t;
```

> [!answer]- Mostra risposta
> **Verdetto:** Compila, ma è una copia superficiale.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** I campi `left` e `right` vengono copiati come indirizzi, quindi i sottoalberi restano condivisi.

### 56. Se `malloc` del clone sinistro fallisce, basta `return NULL`?

```c
copy->left = clone(t->left);
if (t->left != NULL && copy->left == NULL) {
    return NULL;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: memory leak.
>
> **Perché:** `copy` è già stato allocato e deve essere liberato prima di fallire.

### 57. Questa ricerca BST è logicamente corretta?

```c
if (value < t->data)
    return search(t->right, value);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica, non errore di compilazione.
>
> **Perché:** In un BST i valori minori vanno cercati nel sottoalbero sinistro.

### 58. Questa visita in-order su BST produce ordine crescente?

```c
inorder(t->left);
visit(t);
inorder(t->right);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì, se l'albero rispetta l'invariante BST adottato.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** La visita sinistra-nodo-destra sfrutta l'ordinamento dell'ARB/BST.

### 59. Questa altezza è universalmente corretta?

```c
if (t == NULL) return 0;
return 1 + max(height(t->left), height(t->right));
```

> [!answer]- Mostra risposta
> **Verdetto:** Dipende dalla specifica.
>
> **Quando emerge:** Logica.
>
> **Perché:** È corretta con convenzione albero vuoto 0 / foglia 1. Alcune consegne usano vuoto -1 / foglia 0.

### 60. Posso accedere ai campi di una struct opaca dal client?

```c
Stack s;
printf("%d", s->top);
```

> [!answer]- Mostra risposta
> **Verdetto:** No se la definizione completa della struct non è visibile.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Il client conosce solo il puntatore a tipo incompleto e deve usare le operazioni pubbliche dell'ADT.

### 61. Posso dichiarare un puntatore a tipo incompleto?

```c
struct stack;
struct stack *s;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Compile time.
>
> **Perché:** La dimensione del puntatore è nota anche senza conoscere i campi della struct.

### 62. Posso dichiarare un oggetto completo di tipo incompleto?

```c
struct stack;
struct stack s;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Il compilatore non conosce la dimensione dell'oggetto.

### 63. Questo uso di `extern` definisce la variabile?

```c
extern int counter;
```

> [!answer]- Mostra risposta
> **Verdetto:** No, è una dichiarazione.
>
> **Quando emerge:** Link time se manca una definizione effettiva quando la variabile viene usata.
>
> **Perché:** La definizione deve comparire in esattamente un'unità di traduzione, per esempio `int counter = 0;`.

### 64. Definire una globale normale in un `.h` incluso da più `.c` è sicuro?

```c
/* header.h */
int counter = 0;
```

> [!answer]- Mostra risposta
> **Verdetto:** No in un normale progetto multi-file.
>
> **Quando emerge:** Link time: tipicamente definizioni multiple.
>
> **Perché:** Nel `.h` metti `extern int counter;`, in un solo `.c` metti la definizione.

### 65. Due funzioni `static` con lo stesso nome in due `.c` diversi confliggono?

```c
/* a.c */ static void helper(void) {}
/* b.c */ static void helper(void) {}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Link time: nessun conflitto.
>
> **Perché:** `static` a livello di file dà linkage interno: ogni funzione è privata alla propria unità di traduzione.

### 66. Includere direttamente un `.c` è una buona pratica?

```c
#include "list.c"
```

> [!answer]- Mostra risposta
> **Verdetto:** Può essere preprocessato/compilato, ma è progettualmente sbagliato nel modello del corso.
>
> **Quando emerge:** Compile/link time: può anche causare definizioni duplicate.
>
> **Perché:** Si includono gli header; i `.c` si compilano come unità separate.

### 67. Questo `fscanf` controlla bene la lettura?

```c
int x;
while (!feof(fp)) {
    fscanf(fp, "%d", &x);
    use(x);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `feof` diventa vero solo dopo un tentativo di lettura fallito. Puoi usare dati vecchi/invalidi.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> while (fscanf(fp, "%d", &x) == 1) {
>     use(x);
> }
> ```

### 68. Se `fopen` restituisce `NULL`, posso fare `fscanf(fp, ...)`?

```c
FILE *fp = fopen("x.txt", "r");
fscanf(fp, "%d", &x);
```

> [!answer]- Mostra risposta
> **Verdetto:** No senza controllo.
>
> **Quando emerge:** Runtime: uso di stream non valido.
>
> **Perché:** Va verificato `fp != NULL` prima delle operazioni.

### 69. Posso continuare a usare `fp` dopo `fclose(fp)`?

```c
fclose(fp);
fprintf(fp, "ciao");
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: comportamento indefinito / stream non più valido.
>
> **Perché:** Dopo la chiusura il puntatore non rappresenta più uno stream aperto.

### 70. Questo test TDD libera sempre la lista?

```c
if (passed) {
    return 1;
}
freeList(result);
return 0;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: memory leak quando il test passa.
>
> **Perché:** Salva l'esito, libera sempre, poi restituisci.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> int passed = /* controlli */;
> freeList(result);
> return passed;
> ```

# LIVELLO 3 — MOLTO DIFFICILE

### 71. Questo ciclo modifica correttamente tutti gli elementi?

```c
for (int *p = a; p < a + n; p++) {
    *p *= 2;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì, se `a` punta a un array valido di almeno `n` elementi.
>
> **Quando emerge:** Runtime.
>
> **Perché:** L'aritmetica sui puntatori è valida all'interno dello stesso array e fino a un elemento oltre la fine.

### 72. Posso dereferenziare `a + n`?

```c
int *end = a + n;
printf("%d", *end);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: comportamento indefinito.
>
> **Perché:** È lecito formare il puntatore one-past-the-end, ma non dereferenziarlo.

### 73. Posso confrontare con `<` puntatori a due array distinti?

```c
int a[2], b[2];
if (&a[0] < &b[0]) {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Non è un confronto su cui sia lecito basare il programma.
>
> **Quando emerge:** Runtime/semantica del C: l'ordinamento relazionale tra puntatori non appartenenti allo stesso array non ha il comportamento definito richiesto per questo uso.
>
> **Perché:** I confronti relazionali di puntatori vanno usati nel contesto dello stesso array.

### 74. Questo `memcpy` è sempre equivalente a copiare una stringa?

```c
memcpy(dst, src, strlen(src));
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Non copia il terminatore `\0`. Se `dst` deve diventare una stringa, va scritto/trasferito anche il terminatore.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> memcpy(dst, src, strlen(src) + 1);
> ```

### 75. Questo buffer è sufficiente per `"ciao"`?

```c
char *s = malloc(strlen("ciao"));
strcpy(s, "ciao");
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: scrittura oltre il blocco allocato.
>
> **Perché:** Manca lo spazio per `\0`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> char *s = malloc(strlen("ciao") + 1);
> ```

### 76. Questo filtro in-place è corretto?

```c
size_t write = 0;
for (size_t read = 0; s[read] != '\0'; read++) {
    if (keep(s[read])) s[write++] = s[read];
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Manca un passaggio.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Alla fine devi scrivere il nuovo terminatore.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> s[write] = '\0';
> ```

### 77. Questa scansione può andare oltre la stringa?

```c
while (s[i] != '\0') {
    i++;
}
printf("%c", s[i + 1]);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: accedere a `s[i+1]` è fuori dalla stringa e può essere fuori dall'array.
>
> **Perché:** Quando il ciclo termina, `s[i]` è il terminatore.

### 78. Questa funzione modifica il puntatore del chiamante?

```c
void skipSpaces(char *s) {
    while (*s == ' ') s++;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Modifica solo la copia locale del puntatore. I caratteri puntati non vengono spostati e il puntatore del chiamante resta invariato.

### 79. Per cambiare il `char *` del chiamante cosa serve?

```c
void skipSpaces(char **sPtr) {
    while (**sPtr == ' ') (*sPtr)++;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Può farlo, se tutti i puntatori sono validi.
>
> **Quando emerge:** Runtime.
>
> **Perché:** `char **` permette di modificare la variabile puntatore del chiamante.

### 80. Questo `return` da funzione che costruisce due liste perde memoria?

```c
if (isUpper(c)) {
    return NULL;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì, se prima della maiuscola erano già stati allocati nodi.
>
> **Quando emerge:** Runtime: memory leak.
>
> **Perché:** Prima di restituire errore bisogna distruggere tutte le strutture parziali create.

### 81. Questa funzione con due liste gestisce bene il fallimento di una `malloc`?

```c
List node = malloc(sizeof *node);
if (node == NULL) return NULL;
```

> [!answer]- Mostra risposta
> **Verdetto:** Non necessariamente.
>
> **Quando emerge:** Runtime: può perdere le liste costruite fino a quel momento.
>
> **Perché:** Il fallimento deve effettuare cleanup di ogni struttura parziale posseduta dalla funzione.

### 82. Posso riutilizzare lo stesso nodo in due liste?

```c
node->next = listA;
listA = node;
node->next = listB;
listB = node;
```

> [!answer]- Mostra risposta
> **Verdetto:** Il codice compila, ma non crea due copie del nodo.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Il secondo assegnamento a `node->next` modifica lo stesso nodo condiviso: le strutture si intrecciano e la gestione della memoria diventa pericolosa.

### 83. Questa funzione di reverse perde il resto della lista?

```c
while (current != NULL) {
    current->next = previous;
    previous = current;
    current = current->next;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Dopo `current->next = previous`, `current->next` non punta più al resto originale.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> List next = current->next;
> current->next = previous;
> previous = current;
> current = next;
> ```

### 84. Questo delete-all con `prev` aggiorna correttamente `prev` anche quando cancella?

```c
if (current->data == value) {
    prev = current;
    current = current->next;
    free(prev);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `prev` non deve diventare il nodo eliminato: il predecessore logico dei nodi successivi resta quello precedente.

### 85. Nel pattern pointer-to-pointer, quando elimini devi avanzare `currentPtr`?

```c
List tmp = *currentPtr;
*currentPtr = tmp->next;
free(tmp);
currentPtr = &((*currentPtr)->next);
```

> [!answer]- Mostra risposta
> **Verdetto:** In genere no.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Dopo la cancellazione `*currentPtr` è già il nodo successivo; avanzare subito salterebbe un nodo, importante soprattutto in delete-all.

### 86. Questo controllo di lista attesa è completo?

```c
while (list != NULL && expected[i] != '\0') {
    if (list->data != expected[i]) return 0;
    list = list->next;
    i++;
}
return 1;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica: può accettare prefissi.
>
> **Perché:** Devi verificare che entrambe le sequenze terminino insieme.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> return list == NULL && expected[i] == '\0';
> ```

### 87. Questa funzione di confronto liste può leggere `expected` se è `NULL`?

```c
size_t i = 0;
while (list != NULL && expected[i] != '\0') { ... }
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: dereferenziazione indiretta di puntatore nullo.
>
> **Perché:** Se `expected` può essere `NULL`, va gestito prima.

### 88. Questo clone di lista gestisce il fallimento a metà?

```c
while (src != NULL) {
    List n = makeNode(src->data);
    if (n == NULL) return NULL;
    /* append */
    src = src->next;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: memory leak della copia parziale.
>
> **Perché:** In caso di fallimento devi liberare la lista clone già costruita.

### 89. Questo destroy ricorsivo di lista è corretto?

```c
void destroy(List ls) {
    if (ls == NULL) return;
    destroy(ls->next);
    free(ls);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Il `next` viene letto prima del `free` effettivo del nodo corrente grazie alla chiamata ricorsiva.

### 90. Questo destroy ricorsivo mette a `NULL` la lista del chiamante?

```c
void destroy(List ls) {
    if (ls == NULL) return;
    destroy(ls->next);
    free(ls);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Libera i nodi, ma la variabile del chiamante conserva il vecchio indirizzo. Per azzerarla serve `List *` oppure un'assegnazione nel chiamante.

### 91. Questo inserimento BST crea correttamente la root?

```c
void insert(Tree t, int value) {
    if (t == NULL) {
        t = makeNode(value);
        return;
    }
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No per il chiamante.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `t` è una copia del puntatore. La nuova root viene persa al ritorno.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> void insert(Tree *tPtr, int value) {
>     if (*tPtr == NULL) {
>         *tPtr = makeNode(value);
>         return;
>     }
> }
> ```

### 92. Questo inserimento ricorsivo con `Tree *` può scendere correttamente?

```c
insert(&((*treePtr)->left), value);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Passa l'indirizzo del campo puntatore `left`, così la chiamata ricorsiva può modificarlo.

### 93. Questa funzione `sameTree` gestisce il caso uno nullo e l'altro no?

```c
if (a == NULL && b == NULL) return 1;
return a->data == b->data && ...;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: se esattamente uno è `NULL`, dereferenzia `NULL`.
>
> **Perché:** Serve un secondo caso: `if (a == NULL || b == NULL) return 0;`.

### 94. Questa condizione identifica una foglia?

```c
if (t->left == NULL || t->right == NULL)
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Identifica un nodo a cui manca almeno un figlio. Una foglia non ha nessuno dei due figli.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> if (t->left == NULL && t->right == NULL)
> ```

### 95. Distruggere solo `left` e poi `free(root)` è sufficiente?

```c
destroy(root->left);
free(root);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: leak del sottoalbero destro.
>
> **Perché:** Vanno liberati entrambi i sottoalberi prima della root.

### 96. Questo min BST gestisce l'albero vuoto?

```c
while (tree->left != NULL) tree = tree->left;
return tree->data;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: dereferenzia `NULL` se `tree == NULL`.
>
> **Perché:** La precondizione deve escludere l'albero vuoto oppure la funzione deve gestirlo esplicitamente.

### 97. Se un BST è degenerato, questa ricerca resta `O(log n)`?

```c
searchBST(tree, value);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Complessità.
>
> **Perché:** Nel caso peggiore un BST degenerato ha altezza `n`, quindi ricerca `O(n)`.

### 98. Due cicli annidati sono sempre `O(n^2)`?

```c
for (i = 0; i < n; i++)
    for (j = 0; j < i; j++) ...
```

> [!answer]- Mostra risposta
> **Verdetto:** In questo esempio sì asintoticamente, ma non perché 'annidato' implichi sempre automaticamente `n^2`.
>
> **Quando emerge:** Analisi di complessità.
>
> **Perché:** Qui il numero di iterazioni è circa `n(n-1)/2`, quindi `Theta(n^2)`.

### 99. Questo ciclo è `O(n)`?

```c
for (size_t i = n; i > 1; i /= 2) {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Analisi di complessità.
>
> **Perché:** Il valore viene dimezzato a ogni iterazione: il numero di passi è `Theta(log n)`.

### 100. Questo ciclo termina per `size_t i >= 0`?

```c
for (size_t i = n - 1; i >= 0; i--) {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Non nel modo desiderato.
>
> **Quando emerge:** Runtime/logica: `size_t` è unsigned; la condizione `i >= 0` è sempre vera.
>
> **Perché:** Quando `i` passa da 0, va in wrap-around verso un valore molto grande.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> for (size_t i = n; i-- > 0; ) {
>     /* usa i */
> }
> ```

### 101. Questo `for` su stringa è sicuro se `s == NULL`?

```c
for (size_t i = 0; s[i] != '\0'; i++) {
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: accesso tramite puntatore nullo.
>
> **Perché:** Se `NULL` è ammesso dal contratto, va gestito prima.

### 102. Questa funzione di file distingue EOF da dato non valido?

```c
while (fscanf(fp, "%d", &x) != EOF) {
    use(x);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Non necessariamente.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `fscanf` può restituire 0 per conversione fallita senza essere a EOF. In tal caso il ciclo può non progredire come atteso.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> while (fscanf(fp, "%d", &x) == 1) {
>     use(x);
> }
> ```

### 103. Questo header guard è corretto?

```c
#ifndef STACK_H
#define STACK_H
/* dichiarazioni */
#endif
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Preprocessing/compile time.
>
> **Perché:** Evita inclusioni multiple dello stesso header nella stessa unità di traduzione.

### 104. Due definizioni non-`static` della stessa funzione in due `.c` possono coesistere?

```c
/* a.c */ void helper(void) {}
/* b.c */ void helper(void) {}
```

> [!answer]- Mostra risposta
> **Verdetto:** No in un normale link dello stesso programma.
>
> **Quando emerge:** Link time: definizione multipla del simbolo.
>
> **Perché:** Se devono essere private, usa `static`; se è una sola funzione pubblica, definiscila in un solo `.c`.

### 105. Una funzione `static` dichiarata in un `.c` è visibile da un altro `.c` con `extern`?

```c
/* a.c */ static void f(void) {}
/* b.c */ extern void f(void);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Link time.
>
> **Perché:** La funzione `static` a livello di file ha linkage interno e non esporta quel simbolo.

# LIVELLO 4 — DEMONIACO

### 106. Questa espressione è ben definita?

```c
int i = 1;
i = i++ + 1;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: comportamento indefinito secondo le regole di sequenziamento del C.
>
> **Perché:** `i` viene modificato e usato/modificato senza il necessario ordinamento tra gli effetti.

### 107. Questa espressione è ben definita?

```c
int i = 1;
printf("%d %d\n", i++, i++);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: comportamento indefinito per modifiche non sequenziate dello stesso oggetto.
>
> **Perché:** L'ordine di valutazione degli argomenti non fornisce il sequenziamento richiesto tra i due `i++`.

### 108. Questo macro è sicuro per argomenti con side effect?

```c
#define SQUARE(x) ((x) * (x))
int y = SQUARE(i++);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: l'espansione valuta `i++` due volte e porta a un'espressione con side effect problematici.
>
> **Perché:** I macro-funzione possono valutare l'argomento più volte. Evita side effect negli argomenti.

### 109. Questo macro `MAX` è semanticamente innocuo?

```c
#define MAX(a,b) ((a) > (b) ? (a) : (b))
int m = MAX(i++, j++);
```

> [!answer]- Mostra risposta
> **Verdetto:** Non è sicuro come funzione generale.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Uno degli argomenti può essere valutato più di una volta a seconda dell'esito del confronto.

### 110. Questo `sizeof` valuta `i++`?

```c
int i = 0;
size_t n = sizeof(i++);
```

> [!answer]- Mostra risposta
> **Verdetto:** No nel normale caso di tipo non VLA.
>
> **Quando emerge:** Runtime: `i` resta invariato.
>
> **Perché:** L'operando di `sizeof` non viene valutato, salvo casi specifici legati ai VLA.

### 111. Questo puntatore è ancora valido dopo aver liberato la struct che lo contiene?

```c
char *name = person->name;
free(person);
printf("%s", name);
```

> [!answer]- Mostra risposta
> **Verdetto:** Dipende dalla proprietà della memoria di `name`.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Se `person->name` puntava a un blocco separato non liberato, il puntatore può restare valido; se puntava dentro la stessa allocazione della struct o viene liberato insieme, no. La proprietà della memoria è decisiva.

### 112. Questo destroy di struct con stringa dinamica è completo?

```c
free(person);
```

> [!answer]- Mostra risposta
> **Verdetto:** No se `person->name` è stato allocato separatamente e appartiene alla struct.
>
> **Quando emerge:** Runtime: memory leak.
>
> **Perché:** Prima libera i membri dinamici posseduti, poi la struct.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> free(person->name);
> free(person);
> ```

### 113. Questo ordine di `free` è valido?

```c
free(person);
free(person->name);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: use-after-free.
>
> **Perché:** Dopo aver liberato `person`, non puoi più leggere `person->name`.

### 114. Copiare questa struct e distruggere entrambe è sicuro?

```c
struct P { char *name; };
struct P b = a;
free(a.name);
free(b.name);
```

> [!answer]- Mostra risposta
> **Verdetto:** No se `b.name` e `a.name` sono lo stesso indirizzo, come avviene con la copia superficiale.
>
> **Quando emerge:** Runtime: double free.
>
> **Perché:** Serve una deep copy della stringa oppure una politica di ownership condivisa ben definita.

### 115. Questo swap di due puntatori a lista richiede spostare nodi?

```c
List tmp = a;
a = b;
b = tmp;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: valido.
>
> **Perché:** Scambi solo gli indirizzi delle teste; i nodi restano dove sono.

### 116. Questo codice crea un ciclo nella lista?

```c
tail->next = head;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì se `head` e `tail` appartengono alla stessa lista lineare non vuota.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** La coda torna a puntare alla testa; una scansione `while (p != NULL)` non terminerà più.

### 117. `freeList` standard termina su una lista ciclica?

```c
while (ls != NULL) {
    List next = ls->next;
    free(ls);
    ls = next;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Non è progettata per liste cicliche.
>
> **Quando emerge:** Runtime: dopo aver liberato nodi del ciclo può tornare a indirizzi già liberati e produrre comportamento indefinito.
>
> **Perché:** La struttura deve rispettare la precondizione di lista aciclica oppure va rilevato/rotto il ciclo.

### 118. Questo test può causare UB prima di determinare che è fallito?

```c
int passed =
    result != NULL &&
    result->next->data == 'a';
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Se `result` esiste ma `result->next == NULL`, il secondo controllo dereferenzia `NULL`.

### 119. Cambiando l'ordine, diventa sicuro?

```c
int passed =
    result != NULL &&
    result->next != NULL &&
    result->next->data == 'a';
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì rispetto a questi dereferenziamenti.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Lo short-circuit impedisce di accedere al campo successivo quando il puntatore intermedio è `NULL`.

### 120. Questa cancellazione di tutti i valori consecutivi funziona?

```c
while (*p != NULL) {
    if ((*p)->data == value) {
        List tmp = *p;
        *p = tmp->next;
        free(tmp);
    }
    p = &((*p)->next);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica e possibile dereferenziazione di `NULL`.
>
> **Perché:** Dopo una cancellazione non devi avanzare `p`: il link corrente ora punta già al nodo successivo, che va riesaminato. Inoltre se `*p` diventa `NULL`, l'avanzamento dereferenzia `NULL`.

### 121. Versione pointer-to-pointer: quando mantieni il nodo, come avanzi?

```c
p = &((*p)->next);
```

> [!answer]- Mostra risposta
> **Verdetto:** È il passaggio corretto.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Solo nel ramo in cui il nodo viene mantenuto sposti `p` sul suo campo `next`.

### 122. Questa `rotateLeft` può funzionare senza `malloc`?

```c
void rotateLeft(List *lsPtr, size_t k);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Puoi staccare un prefisso e riagganciarlo in coda modificando solo i link esistenti.

### 123. In `rotateLeft`, se `k` supera la lunghezza, usare direttamente `k` è sempre corretto?

```c
/* sposta k nodi uno per uno senza controllo */
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** La specifica deve dire cosa fare. Una scelta comune è ridurre `k % length`; senza gestire il caso, puoi arrivare a `NULL` durante lo spostamento.

### 124. Questo clone ricorsivo distingue `NULL` da fallimento di `malloc`?

```c
Tree left = clone(t->left);
if (left == NULL) return NULL;
```

> [!answer]- Mostra risposta
> **Verdetto:** Non correttamente.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `NULL` è un clone perfettamente corretto quando `t->left == NULL`. Devi considerare fallimento solo se l'originale sinistro non era `NULL` ma il clone è `NULL`.

### 125. Lo stesso problema vale per una lista clone?

```c
List copyNext = clone(ls->next);
if (copyNext == NULL) return NULL;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Se `ls->next == NULL`, ottenere `NULL` è il risultato corretto, non un errore.

### 126. Questa funzione di clone può fare double free nel cleanup?

```c
copy->left = clone(t->left);
copy->right = clone(t->right);
if (copy->right == NULL) {
    destroyTree(&copy);
    free(copy);
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Runtime: double free.
>
> **Perché:** Se `destroyTree(&copy)` libera anche la root `copy`, il successivo `free(copy)` libera di nuovo lo stesso blocco.

### 127. Questa funzione `destroyTree(Tree tree)` può mettere la root del chiamante a `NULL`?

```c
void destroyTree(Tree tree) {
    ...
    tree = NULL;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `tree` è una copia del puntatore. Per azzerare la root del chiamante serve `Tree *`.

### 128. Questa funzione di inserimento restituisce un puntatore a nodo interno: resta valido dopo una futura cancellazione?

```c
Node *found = find(ls, value);
removeFirst(&ls, value);
printf("%d", found->data);
```

> [!answer]- Mostra risposta
> **Verdetto:** Non se il nodo trovato è quello cancellato.
>
> **Quando emerge:** Runtime: dangling pointer / use-after-free.
>
> **Perché:** I puntatori a nodi interni dipendono dalla lifetime della struttura.

### 129. Posso conservare `tail` dopo aver distrutto la lista tramite `head`?

```c
freeList(head);
if (tail != NULL) printf("%d", tail->data);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: `tail` è dangling.
>
> **Perché:** Liberare i nodi invalida tutti i puntatori che li indicavano, non solo `head`.

### 130. Questo `head = NULL` dopo `freeList(head)` elimina tutti i dangling pointer?

```c
freeList(head);
head = NULL;
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** Azzera solo `head`. Altri alias come `tail`, `current` o puntatori salvati restano dangling.

### 131. Questo test di fallimento di `malloc` è realmente esercitabile con test normali?

```c
if (node == NULL) { ... }
```

> [!answer]- Mostra risposta
> **Verdetto:** Il ramo è corretto e necessario in codice robusto, ma normalmente non puoi garantire di attivarlo con semplici input piccoli.
>
> **Quando emerge:** Testing/runtime.
>
> **Perché:** Per testarlo davvero servirebbe un meccanismo controllato di injection/mock dell'allocatore o condizioni di memoria specifiche.

### 132. Questo TDD con `assert` garantisce la stampa `TEST FAILED`?

```c
assert(result != NULL);
printf("TEST PASSED\n");
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Se l'assert fallisce il programma viene abortito e non raggiunge una stampa personalizzata `TEST FAILED`. Inoltre con `NDEBUG` gli assert possono essere disabilitati.

### 133. `passed = passed && test2();` esegue sempre `test2`?

```c
passed = passed && test2();
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime.
>
> **Perché:** Se `passed` è già 0, lo short-circuit evita la chiamata a `test2`.

### 134. `passed &= test2();` esegue `test2`?

```c
passed &= test2();
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì per operandi interi ordinari.
>
> **Quando emerge:** Runtime.
>
> **Perché:** `&` non è short-circuit. È però opportuno che i test restituiscano valori booleani coerenti.

### 135. Questo `main` può stampare PASS anche se un test restituisce 2?

```c
int passed = 1;
passed &= test1();
if (passed) puts("PASS");
```

> [!answer]- Mostra risposta
> **Verdetto:** Dipende dai bit dei valori restituiti.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `&` è bitwise, non logico. Se vuoi usare `&=` come aggregatore, fai in modo che ogni test restituisca esattamente 0 o 1.

### 136. Questa dichiarazione di puntatore a funzione è corretta?

```c
int *f(int, int);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì, ma non è un puntatore a funzione.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Dichiara una funzione `f` che riceve due `int` e restituisce `int *`.
>
>
> **Forma corretta / più sicura:**
>
> ```c
> int (*f)(int, int);
> ```

### 137. Queste parentesi cambiano davvero il significato?

```c
int (*f)(int, int);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Le parentesi fanno sì che `*f` sia il nome dichiarato: `f` è un puntatore a funzione che restituisce `int`.

### 138. Posso assegnare una funzione con firma incompatibile al puntatore?

```c
int (*f)(int, int) = someDoubleFunction;
```

> [!answer]- Mostra risposta
> **Verdetto:** Non correttamente se la firma di `someDoubleFunction` è incompatibile.
>
> **Quando emerge:** Compile time: diagnostica per tipi incompatibili.
>
> **Perché:** I tipi di ritorno e parametri devono essere compatibili.

### 139. Un cast di puntatore a funzione incompatibile rende la chiamata sicura?

```c
int (*f)(int) = (int (*)(int))other;
int x = f(3);
```

> [!answer]- Mostra risposta
> **Verdetto:** No come tecnica generale.
>
> **Quando emerge:** Runtime: chiamare attraverso un tipo di funzione incompatibile può produrre comportamento indefinito.
>
> **Perché:** Il cast può nascondere il problema al type checker.

### 140. Questo ADT con `void *` sa automaticamente come liberare il payload?

```c
struct node { void *data; struct node *next; };
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Progettazione/runtime.
>
> **Perché:** `void *` non codifica ownership né funzione di distruzione. L'interfaccia deve stabilire chi possiede e chi libera gli elementi.

### 141. Questo ADT generico può ordinare elementi senza altre informazioni?

```c
struct Set { void *first; };
```

> [!answer]- Mostra risposta
> **Verdetto:** Non in generale.
>
> **Quando emerge:** Progettazione.
>
> **Perché:** Per ordinare valori di tipo ignoto serve tipicamente una funzione di confronto memorizzata/passata all'ADT.

### 142. Un cast da `void *` al tipo sbagliato compila?

```c
void *p = &d;
int x = *(int *)p;
```

> [!answer]- Mostra risposta
> **Verdetto:** Può compilare.
>
> **Quando emerge:** Runtime: interpretare memoria attraverso un tipo non corretto può produrre comportamento non valido/indefinito a seconda del caso.
>
> **Perché:** Il punto del `void *` è proprio che il cast può togliere protezioni del type checking.

### 143. `sizeof` di una struct opaca dal client è possibile?

```c
typedef struct stack *Stack;
printf("%zu", sizeof(struct stack));
```

> [!answer]- Mostra risposta
> **Verdetto:** No se `struct stack` è ancora incompleta in quel punto.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Il compilatore non conosce la dimensione della rappresentazione privata.

### 144. `sizeof(Stack)` invece è possibile con tipo opaco puntatore?

```c
typedef struct stack *Stack;
printf("%zu", sizeof(Stack));
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Compile time/runtime.
>
> **Perché:** `Stack` è un tipo puntatore e la sua dimensione è nota anche se la struct puntata è incompleta.

### 145. Questo codice viola il principio del privilegio minimo?

```c
void printList(List ls) {
    /* non modifica la lista ma il tipo permette modifiche ai nodi */
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Può essere meno restrittivo del necessario.
>
> **Quando emerge:** Progettazione.
>
> **Perché:** Il corso usa `const` e interfacce ristrette per ridurre modifiche accidentali; quando possibile il contratto dovrebbe esprimere sola lettura.

### 146. Questo `fopen` in modalità `w` preserva il contenuto precedente?

```c
FILE *fp = fopen("data.txt", "w");
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime.
>
> **Perché:** La modalità `w` crea/tronca il file per la scrittura.

### 147. Questo `fopen` in modalità `a` scrive dall'inizio?

```c
FILE *fp = fopen("data.txt", "a");
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime.
>
> **Perché:** La modalità append aggiunge le scritture in fondo al file.

### 148. Questa lettura di riga garantisce che il newline venga rimosso?

```c
fgets(buffer, sizeof buffer, fp);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime/logica.
>
> **Perché:** `fgets` conserva il newline se viene letto e c'è spazio nel buffer.

### 149. Questa ricorsione su albero è sempre `O(log n)`?

```c
visit(tree->left);
visit(tree->right);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Complessità.
>
> **Perché:** Se visita entrambi i sottoalberi, una visita completa è `Theta(n)` indipendentemente dal bilanciamento.

### 150. Una ricerca BST può essere `Theta(n)` anche con codice che sceglie un solo ramo?

```c
if (value < t->data) t = t->left; else t = t->right;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Complessità.
>
> **Perché:** In un albero degenerato l'altezza può essere `n`; scegliere un solo ramo non garantisce altezza logaritmica.

### 151. Questo algoritmo di intersezione tra due liste non ordinate è `O(n+m)`?

```c
for each x in A:
    search x in B
```

> [!answer]- Mostra risposta
> **Verdetto:** No in generale.
>
> **Quando emerge:** Complessità.
>
> **Perché:** Se la ricerca in `B` è lineare, nel caso peggiore il costo è `O(n*m)`.

### 152. Se due liste ordinate vengono percorse in parallelo, l'intersezione può essere `O(n+m)`?

```c
while (a != NULL && b != NULL) {
    /* confronta e avanza uno o entrambi */
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Complessità.
>
> **Perché:** Ogni avanzamento consuma almeno un elemento e nessuna lista viene riattraversata dall'inizio.

### 153. Correttezza parziale senza terminazione basta per dire che il programma è corretto?

```c
/* algoritmo che, se termina, restituisce il risultato giusto */
```

> [!answer]- Mostra risposta
> **Verdetto:** No per correttezza totale.
>
> **Quando emerge:** Ragionamento formale.
>
> **Perché:** Nel corso: correttezza totale = correttezza parziale + terminazione.

### 154. Un invariante di ciclo deve essere vero solo alla fine?

```c
/* proprietà dichiarata come invariante */
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Ragionamento formale.
>
> **Perché:** Deve valere prima del ciclo ed essere preservato da ogni iterazione; poi, insieme alla condizione di uscita, aiuta a concludere la correttezza.

### 155. Questo massimo in array può leggere fuori limite quando `n == 0`?

```c
int max = a[0];
for (size_t i = 1; i < n; i++) { ... }
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì se `n == 0` è ammesso.
>
> **Quando emerge:** Runtime: `a[0]` non è un elemento valido dell'array vuoto.
>
> **Perché:** Serve una precondizione `n > 0` oppure una gestione esplicita del caso vuoto.

### 156. Questo `strcmp` è sicuro se uno dei due puntatori è `NULL`?

```c
strcmp(a, b)
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: `strcmp` richiede puntatori a stringhe valide.
>
> **Perché:** Se `NULL` è possibile, controllalo prima.

### 157. Questo `strlen` è sicuro su un buffer senza `\0`?

```c
char a[3] = {'a','b','c'};
size_t n = strlen(a);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: `strlen` continua a leggere oltre l'array cercando un terminatore; comportamento indefinito.
>
> **Perché:** Una stringa C valida deve contenere `\0` entro l'area accessibile.

### 158. Questo `strcpy` è sicuro solo perché `dest` è dinamico?

```c
char *dest = malloc(4);
strcpy(dest, "abcdef");
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: buffer overflow.
>
> **Perché:** La memoria dinamica non si espande automaticamente; deve essere abbastanza grande per contenuto e terminatore.

### 159. Questa concatenazione è sicura se `dest` contiene una stringa ma non ha capacità residua?

```c
strcat(dest, src);
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Runtime: scrittura oltre il buffer.
>
> **Perché:** `strcat` richiede spazio sufficiente in `dest` per vecchio contenuto + `src` + `\0`.

### 160. Questa funzione può restituire una stringa dinamica senza specificare chi la libera?

```c
char *makeString(void);
```

> [!answer]- Mostra risposta
> **Verdetto:** Può farlo, ma l'interfaccia è incompleta dal punto di vista dell'ownership se il contratto non lo chiarisce.
>
> **Quando emerge:** Progettazione/runtime.
>
> **Perché:** Il chiamante deve sapere se e come liberare il risultato.

### 161. Una funzione che riceve `const char *s` può modificare la variabile puntatore locale `s`?

```c
void f(const char *s) {
    s++;
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì.
>
> **Quando emerge:** Compile time/runtime.
>
> **Perché:** `const` qualifica i caratteri puntati, non la variabile puntatore `s`.

### 162. La stessa funzione può fare `s[0] = 'X'`?

```c
void f(const char *s) {
    s[0] = 'X';
}
```

> [!answer]- Mostra risposta
> **Verdetto:** No.
>
> **Quando emerge:** Compile time: violazione della qualificazione `const`.
>
> **Perché:** I caratteri puntati non sono modificabili tramite `s`.

### 163. Questo tipo impedisce sia di cambiare il puntatore sia il dato puntato?

```c
const int *const p = &x;
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì attraverso `p`.
>
> **Quando emerge:** Compile time.
>
> **Perché:** Il primo `const` protegge l'oggetto puntato tramite `p`; il secondo rende `p` non riassegnabile.

### 164. Questo controllo `if (malloc(...))` perde il puntatore?

```c
if (malloc(sizeof(Node))) {
    /* ... */
}
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì come pattern utile: se l'allocazione riesce, non hai salvato l'indirizzo da liberare/usare.
>
> **Quando emerge:** Runtime: memory leak.
>
> **Perché:** Il valore restituito da `malloc` deve essere memorizzato.

### 165. Questa espressione può essere corretta ma pessima da leggere?

```c
List *p = &((*lsPtr)->next);
```

> [!answer]- Mostra risposta
> **Verdetto:** Sì, se `lsPtr` e `*lsPtr` sono validi.
>
> **Quando emerge:** Runtime.
>
> **Perché:** È sintassi legittima: `p` punta al campo `next`. Il problema non è la validità, ma capire esattamente quale link stai facendo puntare/modificando.


---

# Modalità "macchina da esame"

Il file contiene **165 quiz**.

Routine consigliata:

```text
Warm-up normale:
- 10 Intermedio
- 10 Difficile
- 5 Molto difficile

Warm-up serio:
- 5 Intermedio
- 10 Difficile
- 10 Molto difficile
- 5 Demoniaco

Ultima settimana:
- scegli 30 domande casuali
- massimo 10 secondi per classificare ciascuna
- poi apri la risposta
```

Per ogni frammento prova a produrre una risposta nel formato:

```text
COMPILA / NON COMPILA
↓
COMPORTAMENTO DEFINITO / BUG LOGICO / LEAK / UB / LINK ERROR
↓
PERCHÉ
↓
CORREZIONE MINIMA
```

L'obiettivo finale non è ricordare la risposta specifica: è riconoscere **il pattern di errore** appena lo vedi.
