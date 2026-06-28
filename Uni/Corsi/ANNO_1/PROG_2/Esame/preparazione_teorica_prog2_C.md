# Programmazione 2 — Preparazione domande teoriche in C

> Formato: **“Si può scrivere questa cosa in C?”** / **“Cosa succede se faccio questa azione?”**  
> Obiettivo: arrivare all'esame sapendo spiegare **cosa compila**, **cosa non compila**, **cosa è corretto**, **cosa è pericoloso**, **cosa è undefined behavior**, e soprattutto **perché**.

---

## Legenda rapida

- ✅ **Si può fare**: è C valido e ha senso.
- ❌ **Non si può fare**: errore di compilazione o concetto sbagliato.
- ⚠️ **Compila ma è pericoloso**: può funzionare in alcuni casi, ma non è robusto.
- 💥 **Undefined behavior**: il programma può fare qualunque cosa. Non dire “stampa X” se formalmente il comportamento è indefinito.
- 🧠 **Risposta da esame**: frase breve da usare quando ti chiedono il perché.

---

# 1. Modello mentale fondamentale del C

## 1.1 Una variabile in C che cos'è?

Una variabile ha almeno quattro aspetti:

1. **Tipo**: dice quanti byte occupa e come interpretare quei byte.
2. **Nome**: identificatore usato dal programmatore.
3. **Indirizzo**: posizione in memoria.
4. **Valore**: bit contenuti in quella porzione di memoria.

```c
int x = 10;
```

Qui `x` è una variabile di tipo `int`, ha un indirizzo, e in quell'indirizzo c'è il valore `10`.

---

## 1.2 Cosa vuol dire L-value e R-value?

```c
x = x + 1;
```

La `x` a sinistra dell'assegnamento è usata come **L-value**: rappresenta la cella di memoria da modificare.  
La `x` a destra è usata come **R-value**: rappresenta il valore contenuto nella cella.

🧠 **Risposta da esame**  
A sinistra di `=` una variabile indica “dove scrivere”; a destra indica “che valore leggere”.

---

## 1.3 Posso usare una variabile locale non inizializzata?

```c
int x;
printf("%d\n", x);
```

⚠️ No, non devi farlo.

Una variabile locale automatica non inizializzata contiene un valore indeterminato. Leggerla produce comportamento non definito o comunque non affidabile.

Versione corretta:

```c
int x = 0;
printf("%d\n", x);
```

🧠 **Risposta da esame**  
Le variabili locali automatiche non sono inizializzate automaticamente. Vanno inizializzate prima di essere lette.

---

## 1.4 Una variabile globale non inizializzata vale zero?

```c
int g;

int main(void) {
    printf("%d\n", g);
}
```

✅ Sì. Le variabili globali e le variabili `static` hanno durata statica e sono inizializzate a zero se non viene dato un valore esplicito.

```c
static int counter;
```

Anche `counter` parte da `0`.

🧠 **Risposta da esame**  
Le variabili automatiche locali non inizializzate hanno valore indeterminato; le variabili statiche e globali sono inizializzate a zero.

---

# 2. Puntatori: domande che fanno malissimo se non sono chiarissime

## 2.1 Posso dichiarare un puntatore senza inizializzarlo?

```c
int *p;
```

✅ Sì, puoi dichiararlo.  
❌ Ma non puoi usarlo finché non gli assegni un indirizzo valido.

Errore grave:

```c
int *p;
*p = 42;   // 💥 undefined behavior
```

`p` contiene un indirizzo casuale. Dereferenziarlo significa scrivere in una zona di memoria non valida o non tua.

Versione corretta:

```c
int x;
int *p = &x;
*p = 42;
```

Oppure:

```c
int *p = malloc(sizeof *p);
if (p != NULL) {
    *p = 42;
    free(p);
}
```

---

## 2.2 Posso dereferenziare `NULL`?

```c
int *p = NULL;
*p = 10;
```

💥 No. Dereferenziare `NULL` è undefined behavior, spesso causa segmentation fault.

✅ Prima controlla:

```c
if (p != NULL) {
    *p = 10;
}
```

🧠 **Risposta da esame**  
`NULL` è un valore sentinella che indica “nessun oggetto puntato”. Non rappresenta una cella di memoria dereferenziabile.

---

## 2.3 Cosa succede qui?

```c
int x = 5;
int *p = &x;
*p = 9;
printf("%d\n", x);
```

Stampa:

```text
9
```

Perché `p` contiene l'indirizzo di `x`. Quindi `*p = 9` modifica direttamente `x`.

---

## 2.4 Che differenza c'è tra `p` e `*p`?

```c
int x = 7;
int *p = &x;
```

- `p` è il valore del puntatore, cioè un indirizzo.
- `*p` è il valore contenuto all'indirizzo puntato.

```c
printf("%p\n", (void *)p);  // indirizzo
printf("%d\n", *p);         // valore: 7
```

---

## 2.5 Che differenza c'è tra `&x` e `*p`?

```c
int x = 10;
int *p = &x;
```

- `&x` prende l'indirizzo di `x`.
- `*p` accede all'oggetto puntato da `p`, cioè `x`.

Relazioni utili:

```c
*&x == x
&*p == p   // se p è valido e dereferenziabile
```

---

## 2.6 Posso fare aritmetica sui puntatori?

```c
int a[3] = {10, 20, 30};
int *p = a;
printf("%d\n", *(p + 1));
```

✅ Sì, se il puntatore punta dentro un array valido. Qui stampa `20`.

Ma questo è pericoloso:

```c
int x = 10;
int *p = &x;
p++;
printf("%d\n", *p);   // 💥 undefined behavior
```

`p++` sposta il puntatore oltre `x`, ma non esiste un array di `int` intorno a `x` su cui puoi muoverti liberamente.

🧠 **Risposta da esame**  
L'aritmetica dei puntatori ha senso sugli array, non su indirizzi arbitrari.

---

## 2.7 Posso confrontare due puntatori?

```c
if (p == q) { ... }
```

✅ Sì, per uguaglianza/disuguaglianza.

Ma confronti ordinati tipo:

```c
if (p < q) { ... }
```

sono sensati solo se `p` e `q` puntano dentro lo stesso array o appena oltre la fine dello stesso array.

---

# 3. Puntatori e funzioni

## 3.1 Se passo un `int` a una funzione, la funzione può modificarlo nel chiamante?

```c
void f(int x) {
    x = 99;
}

int main(void) {
    int a = 10;
    f(a);
    printf("%d\n", a);
}
```

Stampa:

```text
10
```

Perché `x` è una copia di `a`.

---

## 3.2 Se passo un puntatore, posso modificare l'oggetto puntato?

```c
void f(int *p) {
    *p = 99;
}

int main(void) {
    int a = 10;
    f(&a);
    printf("%d\n", a);
}
```

Stampa:

```text
99
```

Perché la funzione riceve l'indirizzo di `a`.

---

## 3.3 Se passo un puntatore a una funzione, posso cambiare il puntatore del chiamante?

```c
void f(int *p) {
    p = NULL;
}

int main(void) {
    int x = 5;
    int *q = &x;
    f(q);
    printf("%p\n", (void *)q);
}
```

`q` nel `main` non diventa `NULL`.  
La funzione riceve una copia del puntatore.

Per cambiare il puntatore del chiamante serve un puntatore a puntatore:

```c
void f(int **p) {
    *p = NULL;
}

int main(void) {
    int x = 5;
    int *q = &x;
    f(&q);
}
```

🧠 **Risposta da esame**  
In C il passaggio è sempre per valore. Per modificare una variabile del chiamante, passo l'indirizzo di quella variabile. Se la variabile è un puntatore, devo passare un puntatore a puntatore.

---

## 3.4 Perché alcune destroy prendono `Stack *sPtr` invece di `Stack s`?

Esempio:

```c
void dsStack(Stack *sPtr) {
    free(*sPtr);
    *sPtr = NULL;
}
```

Perché vogliamo:

1. liberare la memoria puntata;
2. mettere a `NULL` il puntatore nel chiamante.

Se facessi:

```c
void dsStack(Stack s) {
    free(s);
    s = NULL;
}
```

libereresti la memoria, ma il puntatore nel `main` resterebbe con un indirizzo ormai non valido: dangling pointer.

---

# 4. Memoria: statica, automatica, dinamica

## 4.1 Dove vivono le variabili locali normali?

```c
void f(void) {
    int x = 10;
}
```

`x` ha memoria automatica, di solito nello stack. Esiste solo durante l'esecuzione della funzione.

---

## 4.2 Posso restituire l'indirizzo di una variabile locale?

```c
int *bad(void) {
    int x = 10;
    return &x;
}
```

💥 No. Quando la funzione termina, `x` non esiste più. Il puntatore restituito è dangling.

Versione corretta:

```c
int *good(void) {
    int *p = malloc(sizeof *p);
    if (p != NULL) {
        *p = 10;
    }
    return p;
}
```

Qui l'oggetto vive nello heap finché non viene chiamata `free`.

---

## 4.3 Posso restituire un array locale?

```c
int *badArray(void) {
    int a[10];
    return a;
}
```

💥 No. `a` è un array locale automatico. Alla fine della funzione non esiste più.

Alternative corrette:

```c
int *makeArray(size_t n) {
    return malloc(n * sizeof(int));
}
```

Oppure il chiamante passa l'array:

```c
void fillArray(int a[], size_t n) {
    for (size_t i = 0; i < n; i++) {
        a[i] = 0;
    }
}
```

---

## 4.4 Cosa fa `static` su una variabile locale?

```c
int nextNumber(void) {
    static int counter = 1;
    return counter++;
}
```

`counter` mantiene il valore tra una chiamata e l'altra. Non viene ricreata ogni volta.

```text
nextNumber() -> 1
nextNumber() -> 2
nextNumber() -> 3
```

🧠 **Risposta da esame**  
`static` su una variabile locale cambia la durata della variabile: resta viva per tutta l'esecuzione del programma, ma resta visibile solo dentro la funzione.

---

## 4.5 Cosa fa `static` su una funzione globale?

```c
static void helper(void) {
    ...
}
```

La funzione è visibile solo nel file `.c` in cui è definita. È una funzione “privata” del modulo.

🧠 **Risposta da esame**  
`static` a livello file limita la visibilità al translation unit corrente.

---

## 4.6 Cosa fa `extern`?

```c
extern int counter;
```

Dice: “questa variabile esiste, ma è definita altrove”.

Esempio:

```c
// a.c
int counter = 0;
```

```c
// b.c
extern int counter;
```

`b.c` può usare `counter`, ma la memoria della variabile è definita in `a.c`.

⚠️ Le globali sono da usare con parsimonia. In Prog2 quasi sempre puoi evitarle.

---

# 5. `malloc`, `free`, `realloc`: teoria e trappole

## 5.1 Come si usa correttamente `malloc`?

```c
int *p = malloc(sizeof *p);
if (p == NULL) {
    // gestione errore
} else {
    *p = 42;
    free(p);
}
```

Preferisci:

```c
malloc(sizeof *p)
```

invece di:

```c
malloc(sizeof(int))
```

Perché se cambi tipo a `p`, il codice resta corretto.

---

## 5.2 `malloc` inizializza la memoria?

```c
int *p = malloc(10 * sizeof *p);
```

❌ No. La memoria ottenuta con `malloc` ha contenuto indeterminato.

Per inizializzare:

```c
for (size_t i = 0; i < 10; i++) {
    p[i] = 0;
}
```

Oppure:

```c
int *p = calloc(10, sizeof *p);
```

`calloc` inizializza a zero.

---

## 5.3 Posso fare `free(NULL)`?

```c
free(NULL);
```

✅ Sì. Non fa nulla.

Questo rende comodo scrivere destroy sicure:

```c
void destroy(int **pPtr) {
    free(*pPtr);
    *pPtr = NULL;
}
```

---

## 5.4 Posso usare un puntatore dopo `free`?

```c
int *p = malloc(sizeof *p);
*p = 10;
free(p);
printf("%d\n", *p);  // 💥 undefined behavior
```

No. Dopo `free`, la memoria non appartiene più al programma.

Meglio:

```c
free(p);
p = NULL;
```

Così se sbagli e dereferenzi, è più probabile accorgersene subito.

---

## 5.5 Posso chiamare `free` due volte sullo stesso puntatore?

```c
free(p);
free(p);  // 💥 undefined behavior
```

No. Double free.

Corretto:

```c
free(p);
p = NULL;
free(p);  // ok, perché free(NULL) è sicura
```

---

## 5.6 Cosa succede se perdo l'unico puntatore a memoria allocata?

```c
int *p = malloc(sizeof *p);
p = NULL;
```

⚠️ Memory leak. La memoria è ancora allocata, ma non hai più modo di liberarla.

---

## 5.7 Come si usa `realloc` senza perdere memoria?

Versione pericolosa:

```c
p = realloc(p, newSize);
```

Se `realloc` fallisce, restituisce `NULL` e perdi il vecchio puntatore: memory leak.

Versione corretta:

```c
void *tmp = realloc(p, newSize);
if (tmp != NULL) {
    p = tmp;
} else {
    // p è ancora valido: posso gestire l'errore
}
```

---

## 5.8 Posso fare `sizeof(p)` per sapere quanta memoria ho allocato?

```c
int *p = malloc(10 * sizeof *p);
printf("%zu\n", sizeof p);
```

No. `sizeof p` restituisce la dimensione del puntatore, non dell'area allocata.

Devi salvare separatamente capacità/lunghezza:

```c
typedef struct {
    int *data;
    size_t size;
    size_t capacity;
} Vector;
```

---

# 6. Array e puntatori

## 6.1 Un array è un puntatore?

```c
int a[3] = {1, 2, 3};
```

❌ No. Un array non è un puntatore.  
Però in molte espressioni il nome dell'array “decade” a puntatore al primo elemento.

```c
int *p = a;      // equivalente a &a[0]
```

Ma:

```c
sizeof a        // dimensione dell'intero array
sizeof p        // dimensione del puntatore
```

---

## 6.2 Dentro una funzione posso sapere la lunghezza dell'array con `sizeof`?

```c
void f(int a[]) {
    printf("%zu\n", sizeof a);
}
```

⚠️ No. Dentro la funzione `a` è un puntatore, non l'array originale.

Firma corretta:

```c
void f(int a[], size_t n) {
    for (size_t i = 0; i < n; i++) {
        ...
    }
}
```

🧠 **Risposta da esame**  
Quando un array è parametro di funzione, viene passato come puntatore al primo elemento. La lunghezza va passata separatamente.

---

## 6.3 Posso assegnare un array a un altro array?

```c
int a[3] = {1, 2, 3};
int b[3];
b = a;   // ❌ errore
```

No. Gli array non sono assegnabili.

Devi copiare elemento per elemento:

```c
for (size_t i = 0; i < 3; i++) {
    b[i] = a[i];
}
```

Oppure usare `memcpy` se appropriato.

---

## 6.4 Posso accedere ad `a[n]` se l'array ha dimensione `n`?

```c
int a[3] = {1, 2, 3};
printf("%d\n", a[3]);  // 💥 undefined behavior
```

No. Gli indici validi sono `0`, `1`, `2`.

---

# 7. Stringhe in C

## 7.1 Cos'è una stringa in C?

Una stringa è un array di `char` terminato dal carattere nullo `\0`.

```c
char s[] = "ciao";
```

In memoria:

```text
'c' 'i' 'a' 'o' '\0'
```

---

## 7.2 Che differenza c'è tra `char s[] = "ciao"` e `char *s = "ciao"`?

```c
char s1[] = "ciao";
char *s2 = "ciao";
```

`s1` è un array modificabile:

```c
s1[0] = 'C';  // ✅ ok
```

`s2` punta a una string literal, che non va modificata:

```c
s2[0] = 'C';  // 💥 undefined behavior
```

Meglio dichiarare:

```c
const char *s2 = "ciao";
```

Così il compilatore ti impedisce di modificarla.

---

## 7.3 Posso fare così?

```c
char *s;
strcpy(s, "ciao");
```

💥 No. `s` non punta a memoria valida.

Corretto:

```c
char s[100];
strcpy(s, "ciao");
```

Oppure:

```c
char *s = malloc(strlen("ciao") + 1);
if (s != NULL) {
    strcpy(s, "ciao");
}
```

Ricorda `+ 1` per `\0`.

---

## 7.4 `strlen` e `sizeof` sono la stessa cosa?

```c
char s[] = "ciao";
printf("%zu\n", strlen(s));
printf("%zu\n", sizeof s);
```

Risultato:

```text
4
5
```

`strlen` conta i caratteri prima di `\0`.  
`sizeof` conta i byte occupati dall'array, incluso `\0`.

---

## 7.5 Posso confrontare stringhe con `==`?

```c
char a[] = "ciao";
char b[] = "ciao";
if (a == b) { ... }
```

❌ No, così confronti gli indirizzi, non il contenuto.

Corretto:

```c
if (strcmp(a, b) == 0) {
    ...
}
```

---

# 8. `const`: privilegio minimo

## 8.1 Che cosa significa `const int *p`?

```c
const int *p;
```

Il dato puntato è costante attraverso `p`: non puoi fare `*p = ...`.

```c
int x = 10;
const int *p = &x;
*p = 20;   // ❌ errore
p = NULL;  // ✅ ok: il puntatore può cambiare
```

---

## 8.2 Che cosa significa `int *const p`?

```c
int x = 10;
int y = 20;
int *const p = &x;
```

Il puntatore è costante: non può puntare altrove.  
Il dato puntato è modificabile.

```c
*p = 99;   // ✅ ok, modifica x
p = &y;    // ❌ errore
```

---

## 8.3 Che cosa significa `const int *const p`?

Puntatore costante a dato costante.

```c
const int x = 10;
const int *const p = &x;

*p = 20;   // ❌ errore
p = NULL;  // ❌ errore
```

---

## 8.4 Perché usare `const` nei parametri?

```c
size_t length(const char *s);
```

La funzione promette di non modificare la stringa puntata.

🧠 **Risposta da esame**  
`const` applica il principio del privilegio minimo: una funzione riceve solo i privilegi necessari per fare il proprio lavoro.

---

# 9. `struct`, `typedef`, `enum`, `union`

## 9.1 Posso dichiarare una struct autoreferenziale così?

```c
typedef struct Node {
    int data;
    struct Node *next;
} Node;
```

✅ Sì.

Puoi anche scrivere:

```c
typedef struct node Node;

struct node {
    int data;
    Node *next;
};
```

Oppure:

```c
typedef struct node *List;

struct node {
    int data;
    List next;
};
```

---

## 9.2 Posso mettere una struct dentro sé stessa direttamente?

```c
struct Node {
    int data;
    struct Node next;  // ❌ errore concettuale
};
```

No. La struct avrebbe dimensione infinita.

Si usa un puntatore:

```c
struct Node {
    int data;
    struct Node *next;
};
```

Perché un puntatore ha dimensione nota.

---

## 9.3 Posso copiare una struct con `=`?

```c
typedef struct {
    int x;
    int y;
} Point;

Point p1 = {1, 2};
Point p2 = p1;
```

✅ Sì. Copia campo per campo.

⚠️ Ma attenzione se dentro ci sono puntatori:

```c
typedef struct {
    char *name;
} Person;

Person a;
a.name = malloc(10);
Person b = a;
```

Ora `a.name` e `b.name` puntano alla stessa memoria. È una **shallow copy**.

Problema tipico:

```c
free(a.name);
free(b.name);  // 💥 double free
```

---

## 9.4 Quando usare `enum`?

```c
typedef enum {
    INSERTED,
    ALREADY_PRESENT,
    OUT_OF_MEMORY
} Outcome;
```

✅ Quando vuoi rappresentare un insieme finito di stati leggibili.

Meglio di:

```c
#define INSERTED 0
#define ALREADY_PRESENT 1
#define OUT_OF_MEMORY 2
```

perché `enum` dà più informazione al compilatore e rende il codice più chiaro.

---

## 9.5 Che cos'è una `union`?

```c
typedef union {
    int i;
    double d;
} Value;
```

Una `union` contiene campi alternativi sovrapposti nella stessa area di memoria. Può contenere un valore alla volta, interpretato in modi diversi.

Spesso si usa con un tag:

```c
typedef enum { IS_INT, IS_DOUBLE } Kind;

typedef struct {
    Kind kind;
    union {
        int i;
        double d;
    } value;
} TaggedValue;
```

🧠 **Risposta da esame**  
Una union da sola non ricorda quale campo è valido. Serve spesso un tag esterno.

---

# 10. File `.h`, file `.c`, compilazione separata

## 10.1 Che cosa va nel `.h`?

Nel `.h` vanno:

- typedef pubbliche;
- prototipi delle funzioni pubbliche;
- macro pubbliche se necessarie;
- commenti di specifica.

Esempio:

```c
#ifndef STACK_H
#define STACK_H

typedef struct stack *Stack;

Stack mkStack(void);
void dsStack(Stack *sPtr);
_Bool push(Stack s, int value);
_Bool pop(Stack s, int *out);

#endif
```

---

## 10.2 Che cosa va nel `.c`?

Nel `.c` vanno:

- definizione concreta delle struct opache;
- implementazione delle funzioni pubbliche;
- funzioni helper `static` private;
- eventuali macro private.

```c
#include "stack.h"
#include <stdlib.h>

struct stack {
    Node *top;
    size_t size;
};
```

---

## 10.3 Posso includere un `.c`?

```c
#include "stack.c"   // ⚠️ pessima idea
```

Di norma no. Devi includere il `.h` e compilare/linkare il `.c` separatamente.

Corretto:

```bash
gcc -std=c18 -Wall -Wextra -pedantic -c stack.c
gcc -std=c18 -Wall -Wextra -pedantic -c main.c
gcc -o prog main.o stack.o
```

Oppure in un comando:

```bash
gcc -std=c18 -Wall -Wextra -pedantic main.c stack.c -o prog
```

🧠 **Risposta da esame**  
Il `.h` dichiara l'interfaccia; il `.c` implementa. Il compilatore compila i sorgenti e il linker collega gli oggetti.

---

## 10.4 Che differenza c'è tra dichiarazione e definizione?

Dichiarazione:

```c
int f(int x);
```

Dice che `f` esiste e ha quella firma.

Definizione:

```c
int f(int x) {
    return x + 1;
}
```

Crea effettivamente il codice della funzione.

Per variabili globali:

```c
extern int x;  // dichiarazione
int x = 0;     // definizione
```

---

## 10.5 Posso definire una variabile globale nel `.h`?

```c
// bad.h
int counter = 0;
```

⚠️ No, quasi sempre causa multiple definition se incluso in più `.c`.

Corretto:

```c
// counter.h
extern int counter;
```

```c
// counter.c
int counter = 0;
```

---

# 11. Tipi opachi e ADT

## 11.1 Che cos'è un ADT?

Un ADT è un tipo astratto definito da:

1. un tipo `T`;
2. un insieme di operazioni pubbliche su `T`;
3. un'implementazione nascosta di quelle operazioni.

Il codice cliente deve usare il tipo solo tramite le operazioni pubbliche.

---

## 11.2 Come realizzo un tipo opaco in C?

Nel `.h`:

```c
typedef struct stack *Stack;

Stack mkStack(void);
void dsStack(Stack *sPtr);
```

Nel `.c`:

```c
struct stack {
    Node *top;
    size_t size;
};
```

Il client conosce solo `Stack`, cioè un puntatore a una struct incompleta. Può passarlo alle funzioni, confrontarlo con `NULL`, ma non può accedere ai campi.

---

## 11.3 Posso fare `s->top` se `Stack` è opaco?

Nel client:

```c
Stack s = mkStack();
s->top = NULL;  // ❌ errore
```

No. Il client non conosce la definizione di `struct stack`.

🧠 **Risposta da esame**  
Il tipo opaco abbassa l'accoppiamento: il client dipende dall'interfaccia, non dai dettagli implementativi.

---

## 11.4 Qual è il prezzo del tipo opaco?

Vantaggi:

- incapsulamento;
- meno dipendenza dai dettagli;
- puoi cambiare implementazione senza cambiare il client;
- meno possibilità che il client rompa invarianti interne.

Svantaggi:

- più funzioni accessorie;
- possibile overhead di allocazione dinamica;
- codice meno immediato;
- non sempre necessario per strutture semplicissime.

---

## 11.5 Che cos'è la coesione?

Un modulo ha alta coesione se tutte le sue funzioni ruotano intorno a un concetto unico.

Esempio buono:

```c
complex.h
```

contiene operazioni sui numeri complessi: somma, prodotto, modulo, argomento.

Esempio meno buono:

```c
void printComplex(Complex c);
```

Mescola il concetto “numero complesso” con “stampa su terminale”. Può essere accettabile, ma peggiora la purezza del modulo.

---

## 11.6 Che cos'è l'accoppiamento?

L'accoppiamento misura quanto un modulo dipende dai dettagli di un altro.

Accoppiamento alto:

```c
client.c accede direttamente a c.re e c.im
```

Accoppiamento basso:

```c
client.c usa re(c), im(c), modulus(c)
```

Così puoi cambiare rappresentazione da cartesiana a polare senza riscrivere il client.

---

# 12. `void *` e genericità

## 12.1 Posso assegnare qualunque puntatore a `void *`?

```c
int x = 10;
void *p = &x;
```

✅ Sì. `void *` è un puntatore generico.

Per recuperare il valore:

```c
int *ip = p;
printf("%d\n", *ip);
```

---

## 12.2 Posso dereferenziare direttamente un `void *`?

```c
void *p = &x;
printf("%d\n", *p);  // ❌ errore
```

No. Il compilatore non sa quanti byte leggere né come interpretarli.

Serve convertirlo al tipo corretto:

```c
printf("%d\n", *(int *)p);
```

---

## 12.3 Perché `void *` è pericoloso?

Perché cancella il type checking.

```c
int x = 10;
void *p = &x;
double d = *(double *)p;  // 💥 interpretazione sbagliata
```

Il compilatore non può proteggerti.

🧠 **Risposta da esame**  
`void *` aumenta il riuso del codice, ma riduce il controllo statico sui tipi.

---

## 12.4 Come si fa una struttura dati generica ordinata?

Se una lista contiene `void *`, può inserire e togliere elementi senza sapere cosa sono.

Ma per ordinarli serve una funzione di confronto:

```c
typedef int (*CompareFunc)(const void *a, const void *b);
```

Esempio:

```c
struct list {
    Node *first;
    CompareFunc compare;
};
```

Così la lista sa come confrontare elementi del tipo specifico scelto dal client.

---

## 12.5 Chi libera gli elementi in una struttura generica?

Domanda fondamentale di ownership.

Possibilità 1: la struttura conserva solo puntatori, ma non possiede gli oggetti. Allora non li libera.

Possibilità 2: la struttura possiede gli oggetti. Allora deve ricevere una funzione distruttrice:

```c
typedef void (*DestroyFunc)(void *x);
```

E poi:

```c
void dsList(List *lPtr) {
    ...
    destroy(node->data);
    free(node);
}
```

🧠 **Risposta da esame**  
Con `void *` bisogna specificare chiaramente ownership, confronto, copia e distruzione degli elementi.

---

# 13. Puntatori a funzione

## 13.1 Il nome di una funzione è un indirizzo?

```c
int sum(int a, int b) {
    return a + b;
}

int (*op)(int, int) = sum;
```

✅ Sì. Il nome della funzione identifica l'indirizzo del codice della funzione.

Chiamata:

```c
int r = op(2, 3);
```

---

## 13.2 Come leggo questa dichiarazione?

```c
int (*foo)(int, int, int);
```

`foo` è un puntatore a funzione che prende tre `int` e restituisce `int`.

Senza parentesi:

```c
int *foo(int, int, int);
```

significa una funzione che restituisce `int *`.

Le parentesi sono fondamentali.

---

## 13.3 Posso passare una funzione a un'altra funzione?

```c
typedef int (*Compare)(int, int);

int maxIndex(int a[], size_t n, Compare cmp) {
    size_t best = 0;
    for (size_t i = 1; i < n; i++) {
        if (cmp(a[i], a[best]) > 0) {
            best = i;
        }
    }
    return best;
}
```

✅ Sì. È il modo tipico per generalizzare comportamenti.

---

# 14. Liste linkate

## 14.1 Che cos'è una lista linkata?

Una lista è:

- vuota, rappresentata da `NULL`;
- oppure un nodo che contiene un dato e un puntatore alla lista successiva.

```c
typedef struct node Node, *List;

struct node {
    int data;
    List next;
};
```

---

## 14.2 Perché nelle liste serve spesso `List *lsPtr`?

Se l'operazione può modificare la testa della lista, serve passare l'indirizzo della testa.

Esempio inserimento in testa:

```c
_Bool insertHead(List *lsPtr, int value) {
    Node *newNode = malloc(sizeof *newNode);
    if (newNode == NULL) {
        return 0;
    }

    newNode->data = value;
    newNode->next = *lsPtr;
    *lsPtr = newNode;
    return 1;
}
```

Se passassi solo `List ls`, modificheresti una copia del puntatore.

---

## 14.3 Posso cancellare un nodo facendo solo `free(current)`?

```c
free(current);
```

❌ Non basta. Prima devi scollegarlo dalla lista.

Cancellazione corretta di un nodo dopo `prev`:

```c
Node *toDelete = prev->next;
prev->next = toDelete->next;
free(toDelete);
```

Per cancellare la testa:

```c
Node *toDelete = *lsPtr;
*lsPtr = toDelete->next;
free(toDelete);
```

---

## 14.4 Perché l'ordine delle istruzioni è vitale?

Errore:

```c
free(current);
prev->next = current->next;  // 💥 current è già liberato
```

Corretto:

```c
prev->next = current->next;
free(current);
```

Oppure salva prima:

```c
Node *next = current->next;
free(current);
current = next;
```

---

## 14.5 Come si distrugge una lista?

```c
void dsList(List *lsPtr) {
    Node *current = *lsPtr;
    while (current != NULL) {
        Node *next = current->next;
        free(current);
        current = next;
    }
    *lsPtr = NULL;
}
```

Punti chiave:

- salvo `next` prima di `free`;
- libero tutti i nodi;
- metto la testa a `NULL`.

---

## 14.6 Cosa succede se dimentico di aggiornare la testa?

```c
void deleteHead(List ls) {
    Node *tmp = ls;
    ls = ls->next;
    free(tmp);
}
```

⚠️ La lista nel chiamante resta con la vecchia testa, ormai liberata. Dangling pointer.

Corretto:

```c
void deleteHead(List *lsPtr) {
    Node *tmp = *lsPtr;
    *lsPtr = tmp->next;
    free(tmp);
}
```

---

## 14.7 Posso usare la ricorsione sulle liste?

✅ Sì, perché la lista è ricorsiva per natura:

```c
int length(List ls) {
    if (ls == NULL) {
        return 0;
    }
    return 1 + length(ls->next);
}
```

⚠️ Però su liste molto lunghe puoi avere stack overflow.

Versione iterativa:

```c
int length(List ls) {
    int count = 0;
    for (Node *current = ls; current != NULL; current = current->next) {
        count++;
    }
    return count;
}
```

---

# 15. Stack, queue, set

## 15.1 Stack: politica LIFO

Stack = Last In, First Out.

Operazioni tipiche:

- `push`: inserisce in cima;
- `pop`: rimuove dalla cima;
- `top`: legge la cima;
- `isEmpty`;
- `size`.

Con lista linkata, push e pop in testa sono `O(1)`.

---

## 15.2 Queue: politica FIFO

Queue = First In, First Out.

Operazioni tipiche:

- `enqueue`: inserisce in fondo;
- `dequeue`: rimuove dalla testa.

Implementazione con lista e due puntatori:

```c
struct queue {
    Node *front;
    Node *rear;
    size_t size;
};
```

Invariante importante:

```text
queue vuota  <=>  front == NULL && rear == NULL && size == 0
```

Quando rimuovi l'ultimo elemento devi fare:

```c
q->front = NULL;
q->rear = NULL;
q->size = 0;
```

Se dimentichi `rear = NULL`, il puntatore resta appeso a memoria liberata.

---

## 15.3 Perché `dequeue` spesso restituisce `_Bool` e scrive su parametro di output?

```c
_Bool dequeue(Queue q, int *out) {
    if (q == NULL || q->front == NULL) {
        return 0;
    }
    *out = q->front->data;
    ...
    return 1;
}
```

Perché la funzione può fallire se la coda è vuota.  
Il valore estratto viene scritto in `*out`, mentre il valore di ritorno dice se l'operazione è riuscita.

---

## 15.4 Set: che cosa deve garantire?

Un set è una collezione senza duplicati.

Operazioni tipiche:

- `add`;
- `remove`;
- `contains`;
- `union`;
- `intersection`;
- `difference`;
- `isSubset`.

La regola più importante: `add` non deve inserire duplicati.

---

## 15.5 Perché un set ha bisogno di uguaglianza o confronto?

Per decidere se due elementi sono “lo stesso elemento”.

Con `int` basta \==\.

Con struct complesse serve decidere la chiave:

```c
typedef struct {
    char name[50];
    char fiscalCode[17];
} Person;
```

Due persone con stesso nome non sono necessariamente la stessa persona. Potrei confrontare il codice fiscale.

---

## 15.6 Complessità di intersezione tra set su liste non ordinate

Algoritmo semplice:

```text
per ogni elemento di A:
    se appartiene a B:
        inseriscilo nel risultato
```

Se `A` ha `m` elementi e `B` ha `n` elementi, nel caso peggiore è `O(m*n)`.

Se invece le liste sono ordinate, puoi scorrerle in parallelo e ottenere `O(m+n)`.

---

# 16. Ricorsione

## 16.1 Cosa deve avere una funzione ricorsiva corretta?

1. **Caso base**: situazione in cui non richiama sé stessa.
2. **Passo ricorsivo**: riduce il problema.
3. **Progresso verso il caso base**.

Esempio:

```c
int factorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}
```

---

## 16.2 Cosa succede se manca il caso base?

```c
int f(int n) {
    return f(n - 1);
}
```

💥 Ricorsione infinita fino a stack overflow.

---

## 16.3 Ricorsione di testa vs ricorsione di coda

Ricorsione non di coda:

```c
int sum(List ls) {
    if (ls == NULL) {
        return 0;
    }
    return ls->data + sum(ls->next);
}
```

Dopo la chiamata ricorsiva resta da fare `ls->data + ...`.

Ricorsione di coda:

```c
int sumAcc(List ls, int acc) {
    if (ls == NULL) {
        return acc;
    }
    return sumAcc(ls->next, acc + ls->data);
}
```

La chiamata ricorsiva è l'ultima operazione.

⚠️ In C non devi assumere che il compilatore ottimizzi sempre la ricorsione di coda.

---

## 16.4 Liste o alberi: quando ricorsione sì?

Liste: la ricorsione è elegante, ma una lista molto lunga può causare stack overflow.  
Alberi: la ricorsione è spesso naturale e molto leggibile, perché ogni nodo ha sottoalberi ricorsivi.

🧠 **Risposta da esame**  
La ricorsione segue la definizione induttiva della struttura dati, ma usa stack: va valutato il costo in spazio.

---

# 17. Alberi binari e BST

## 17.1 Che cos'è un albero binario?

Un albero binario è:

- vuoto;
- oppure un nodo radice con un sottoalbero sinistro e un sottoalbero destro.

```c
typedef struct node *Tree;

struct node {
    int data;
    Tree left;
    Tree right;
};
```

---

## 17.2 Che cos'è un BST/ARB?

Un albero di ricerca binario mantiene l'invariante:

```text
tutti i valori nel sottoalbero sinistro < valore del nodo
tutti i valori nel sottoalbero destro > valore del nodo
```

A seconda delle specifiche, i duplicati possono essere vietati o gestiti con una politica precisa.

---

## 17.3 Perché la ricerca in BST può essere `O(log n)`?

Se l'albero è bilanciato, a ogni confronto scarti circa metà dei nodi.

```c
_Bool search(Tree t, int value) {
    if (t == NULL) {
        return 0;
    }
    if (value == t->data) {
        return 1;
    }
    if (value < t->data) {
        return search(t->left, value);
    }
    return search(t->right, value);
}
```

⚠️ Se l'albero è sbilanciato, può degenerare in lista e diventare `O(n)`.

---

## 17.4 Visite di un albero

Pre-order:

```text
nodo, sinistro, destro
```

In-order:

```text
sinistro, nodo, destro
```

Post-order:

```text
sinistro, destro, nodo
```

Per un BST, la visita in-order produce i valori ordinati.

---

## 17.5 Come si libera un albero?

Usa post-order: prima liberi i figli, poi il nodo.

```c
void dsTree(Tree *tPtr) {
    if (*tPtr == NULL) {
        return;
    }
    dsTree(&((*tPtr)->left));
    dsTree(&((*tPtr)->right));
    free(*tPtr);
    *tPtr = NULL;
}
```

Se liberassi prima la radice, perderesti i puntatori ai figli.

---

# 18. File in C

## 18.1 Qual è il ciclo di vita di un file?

Come la memoria dinamica:

1. acquisizione: `fopen`;
2. uso: `fscanf`, `fprintf`, `fgets`, `fputs`, `fread`, `fwrite`;
3. rilascio: `fclose`.

```c
FILE *fp = fopen("data.txt", "r");
if (fp == NULL) {
    // errore
} else {
    // uso fp
    fclose(fp);
}
```

---

## 18.2 Posso usare un `FILE *` se `fopen` fallisce?

```c
FILE *fp = fopen("missing.txt", "r");
fscanf(fp, "%d", &x);  // 💥 se fp == NULL
```

No. Devi controllare `fp != NULL`.

---

## 18.3 Come controllo bene `fscanf`?

```c
int x;
while (fscanf(fp, "%d", &x) == 1) {
    printf("%d\n", x);
}
```

Non usare solo `!feof(fp)` come condizione principale.  
Controlla il valore di ritorno della lettura.

---

## 18.4 Devo chiudere sempre il file?

✅ Sì.

```c
fclose(fp);
```

Chiudere il file rilascia la risorsa e forza eventuali buffer in scrittura.

---

# 19. Complessità computazionale

## 19.1 Che cosa misura la complessità?

Misura come cresce il costo dell'algoritmo al crescere della dimensione dell'input.

Costi:

- tempo: numero di passi elementari;
- spazio: memoria usata.

Non interessa il tempo assoluto su una macchina specifica, ma l'andamento asintotico.

---

## 19.2 Differenza tra `O` e `Θ`

- `O(f(n))`: limite superiore asintotico.
- `Θ(f(n))`: crescita strettamente dell'ordine di `f(n)`.

Esempio:

```c
for (int i = 0; i < n; i++) {
    printf("%d\n", i);
}
```

Tempo `Θ(n)`.

---

## 19.3 Cicli annidati

```c
for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
        count++;
    }
}
```

`Θ(n^2)`.

```c
for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
        count++;
    }
}
```

`Θ(n*m)`.

---

## 19.4 Ciclo che dimezza

```c
while (n > 1) {
    n = n / 2;
}
```

`Θ(log n)`.

---

## 19.5 Ricerca in lista

```c
while (current != NULL && current->data != value) {
    current = current->next;
}
```

Caso migliore: `Θ(1)`, se l'elemento è in testa.  
Caso peggiore: `Θ(n)`, se l'elemento non c'è o è in fondo.

---

## 19.6 Accesso casuale: array vs lista

Array:

```c
a[i]
```

`O(1)`.

Lista:

```c
get(lista, i)
```

`O(i)`, nel caso peggiore `O(n)`.

---

# 20. Correttezza e invarianti

## 20.1 Correttezza totale

```text
correttezza totale = correttezza parziale + terminazione
```

- Correttezza parziale: se il programma termina, il risultato è giusto.
- Terminazione: il programma termina davvero.

---

## 20.2 Che cos'è un'invariante di ciclo?

È una proprietà vera:

1. prima della prima iterazione;
2. dopo ogni iterazione;
3. utile per dimostrare la post-condizione quando il ciclo termina.

---

## 20.3 Esempio: massimo in array

```c
int max = a[0];
for (size_t i = 1; i < n; i++) {
    if (a[i] > max) {
        max = a[i];
    }
}
```

Invariante:

```text
all'inizio di ogni iterazione i, max è il massimo degli elementi a[0..i-1]
```

Quando il ciclo termina con `i == n`, `max` è il massimo di `a[0..n-1]`.

---

## 20.4 Esempio: ricerca in lista

```c
Node *current = ls;
while (current != NULL && current->data != value) {
    current = current->next;
}
```

Invariante:

```text
nessuno dei nodi già visitati contiene value
```

Alla fine:

- se `current == NULL`, il valore non è nella lista;
- altrimenti `current->data == value`.

---

# 21. Domande “si può scrivere?” — raccolta flash

## 21.1 `int *p = malloc(sizeof(int)); *p = 3;`

✅ Sì, se controlli che `malloc` non abbia restituito `NULL`.

Meglio:

```c
int *p = malloc(sizeof *p);
if (p != NULL) {
    *p = 3;
}
```

---

## 21.2 `int *p = NULL; free(p);`

✅ Sì. `free(NULL)` è sicura.

---

## 21.3 `int *p = NULL; *p = 3;`

💥 No. Dereferenziazione di `NULL`.

---

## 21.4 `int *p; free(p);`

💥 No. `p` non è inizializzato.

---

## 21.5 `int a[3]; a = NULL;`

❌ No. Gli array non sono assegnabili.

---

## 21.6 `int a[3]; int *p = a;`

✅ Sì. `a` decade a puntatore al primo elemento.

---

## 21.7 `sizeof(a) / sizeof(a[0])` funziona sempre?

✅ Solo se `a` è davvero un array visibile nello stesso scope.

❌ Non funziona dentro una funzione che riceve `int a[]`, perché lì `a` è un puntatore.

---

## 21.8 `char *s = "ciao"; s[0] = 'C';`

💥 No. Tentativo di modificare string literal.

---

## 21.9 `char s[] = "ciao"; s[0] = 'C';`

✅ Sì.

---

## 21.10 `strcmp(a, b) == 0` significa stringhe uguali?

✅ Sì.

---

## 21.11 `a == b` con due stringhe significa stringhe uguali?

❌ No, confronta indirizzi.

---

## 21.12 `struct node { struct node next; };`

❌ No, dimensione infinita.

---

## 21.13 `struct node { struct node *next; };`

✅ Sì.

---

## 21.14 `typedef struct stack *Stack;` nel `.h` e `struct stack { ... };` nel `.c`

✅ Sì. È il pattern del tipo opaco.

---

## 21.15 Il client può fare `sizeof(struct stack)` se `struct stack` è opaca?

❌ No. Non conosce la dimensione della struct.

---

## 21.16 Il client può dichiarare `Stack s;` se `Stack` è puntatore a struct opaca?

✅ Sì. Tutti i puntatori hanno dimensione nota.

---

## 21.17 Il client può dichiarare `struct stack s;` se la struct è incompleta?

❌ No. Non conosce la dimensione dell'oggetto.

---

## 21.18 Posso fare `void *p = &x;`

✅ Sì.

---

## 21.19 Posso fare `*p` se `p` è `void *`?

❌ No. Serve cast al tipo corretto.

---

## 21.20 Posso passare una funzione come parametro?

✅ Sì, tramite puntatore a funzione.

---

## 21.21 Posso usare una funzione senza prototipo?

⚠️ In C moderno no: va evitato. Compila solo in modalità permissive/vecchi standard o con warning/errori. Il prototipo serve per type checking corretto.

---

## 21.22 Posso avere due funzioni con lo stesso nome in C?

❌ No. Il C non supporta overloading delle funzioni.

---

## 21.23 Posso avere una funzione `static` con lo stesso nome in due `.c` diversi?

✅ Sì, perché `static` limita la visibilità al file.

---

## 21.24 Posso fare `free` di memoria allocata sullo stack?

```c
int x;
free(&x);
```

💥 No. `free` va usata solo su memoria ottenuta da `malloc`, `calloc`, `realloc`.

---

## 21.25 Posso fare `free` di un nodo prima di salvarmi `next`?

💥 No, se poi ti serve `next`.

Corretto:

```c
Node *next = current->next;
free(current);
current = next;
```

---

# 22. Mini-colloquio orale: risposte pronte

## Domanda: perché `malloc` può fallire?

Perché la memoria dinamica disponibile potrebbe non essere sufficiente o il sistema potrebbe rifiutare l'allocazione. Per questo il valore restituito va confrontato con `NULL`.

---

## Domanda: perché si usa `sizeof *p`?

Perché lega la dimensione al tipo effettivo puntato da `p`. Se cambia il tipo di `p`, non devo aggiornare manualmente il `sizeof`.

---

## Domanda: perché dopo `free` mettiamo il puntatore a `NULL`?

Per evitare dangling pointer. Non rende magica la memoria liberata, ma riduce il rischio di usare per errore un indirizzo non più valido.

---

## Domanda: perché una lista può essere passata come `List *`?

Perché alcune operazioni modificano la testa della lista. Passando `List *`, la funzione può cambiare il puntatore contenuto nel chiamante.

---

## Domanda: perché una coda con lista ha sia `front` sia `rear`?

Per rendere `enqueue` in fondo `O(1)`. Senza `rear`, bisognerebbe scorrere tutta la lista per trovare l'ultimo nodo.

---

## Domanda: che cosa succede se in una queue elimino l'ultimo nodo ma non aggiorno `rear`?

`rear` resta puntato a memoria liberata. La coda sembra vuota per `front == NULL`, ma contiene un dangling pointer. Le operazioni successive possono causare undefined behavior.

---

## Domanda: perché un ADT riduce l'accoppiamento?

Perché il client conosce solo interfaccia e operazioni pubbliche, non i dettagli della rappresentazione. Se cambio implementazione interna, il client non deve cambiare.

---

## Domanda: perché `void *` serve ma è rischioso?

Serve per scrivere codice generico riutilizzabile. È rischioso perché perde il controllo statico sui tipi: il compilatore non sa se il cast successivo è corretto.

---

## Domanda: perché una visita in-order di un BST restituisce elementi ordinati?

Perché per ogni nodo il sottoalbero sinistro contiene valori minori, poi visiti il nodo, poi il sottoalbero destro con valori maggiori.

---

## Domanda: perché correttezza totale = correttezza parziale + terminazione?

Perché non basta dimostrare che, se il programma termina, produce il risultato corretto. Bisogna anche dimostrare che termina effettivamente.

---

# 23. Checklist finale prima dell'esame

## Puntatori e memoria

- [ ] So spiegare `&`, `*`, `NULL`, dangling pointer.
- [ ] So distinguere puntatore non inizializzato, puntatore `NULL`, puntatore valido.
- [ ] So dire quando c'è undefined behavior.
- [ ] So usare `malloc`, `calloc`, `realloc`, `free`.
- [ ] So perché `free(NULL)` è ok.
- [ ] So perché double free e use-after-free sono errori gravi.
- [ ] So perché non si restituisce l'indirizzo di una variabile locale.

## Array e stringhe

- [ ] So distinguere array e puntatore.
- [ ] So quando un array decade a puntatore.
- [ ] So perché la lunghezza va passata separatamente alle funzioni.
- [ ] So distinguere `strlen` e `sizeof`.
- [ ] So distinguere `char s[]` e `char *s = "..."`.
- [ ] So usare `strcmp` invece di \== per confrontare stringhe.

## Struct e ADT

- [ ] So scrivere struct autoreferenziali.
- [ ] So cosa fa `typedef`.
- [ ] So cosa sono tipo opaco, coesione, accoppiamento.
- [ ] So organizzare `.h` e `.c`.
- [ ] So perché non si include un `.c`.
- [ ] So usare header guard.

## Liste, stack, queue, set

- [ ] So inserire/cancellare in testa con `List *`.
- [ ] So distruggere una lista senza perdere `next`.
- [ ] So le politiche LIFO e FIFO.
- [ ] So gli invarianti di queue vuota.
- [ ] So cosa significa “set senza duplicati”.
- [ ] So confrontare complessità di set non ordinato e ordinato.

## Ricorsione e alberi

- [ ] So individuare caso base e passo ricorsivo.
- [ ] So spiegare stack overflow.
- [ ] So visite pre/in/post-order.
- [ ] So l'invariante del BST.
- [ ] So perché BST bilanciato dà ricerca `O(log n)`.

## File, complessità, correttezza

- [ ] So usare `fopen`/lettura/scrittura/`fclose`.
- [ ] So controllare il valore di ritorno di `fscanf`.
- [ ] So calcolare complessità di cicli semplici, annidati, dimezzamento.
- [ ] So differenza tra caso migliore e peggiore.
- [ ] So definire invariante di ciclo.
- [ ] So spiegare correttezza parziale e terminazione.

---

# 24. Sezione estendibile: aggiungi qui nuove domande

## Template

```markdown
## Domanda

```c
// codice
```

### Si può scrivere?

✅ / ❌ / ⚠️ / 💥

### Cosa succede?

Spiegazione.

### Versione corretta

```c
// codice corretto
```

### Risposta da esame

Frase breve.
```

---

# 25. Allenamento consigliato

Per essere davvero pronto, non limitarti a leggere. Fai così:

1. Prendi una domanda flash.
2. Scrivi il codice senza guardare.
3. Compila con:

```bash
gcc -std=c18 -Wall -Wextra -pedantic file.c -o prog
```

4. Prima di eseguire, prevedi:
   - compila?
   - warning?
   - output?
   - undefined behavior?
5. Esegui e confronta.
6. Scrivi in una riga la regola generale.

Il salto di qualità all'esame arriva quando, davanti a un pezzo di codice, non dici solo “funziona/non funziona”, ma sai dire:

```text
compila, ma è undefined behavior perché...
```

oppure:

```text
non compila perché il tipo è incompleto...
```

oppure:

```text
funziona, ma viola l'ADT perché il client dipende dalla rappresentazione interna...
```

