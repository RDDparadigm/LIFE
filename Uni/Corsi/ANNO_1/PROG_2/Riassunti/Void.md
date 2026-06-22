# ADT generici in C con `void*`

## Obiettivo della lezione

In questa parte del corso l’idea centrale è capire come scrivere **codice riutilizzabile** in C quando vogliamo implementare strutture dati che possano contenere elementi di tipi diversi.

Fino ad ora abbiamo visto ADT specifici, per esempio:

* pila di `char`;
* coda di `char`;
* insieme di `char`;
* liste di un certo tipo specifico;
* ADT opachi, dove il client non conosce la struttura interna.

Il problema è che, se voglio una pila di `char`, una pila di `char *`, una pila di `ContactPtr`, una pila di `int *`, rischio di dover riscrivere ogni volta quasi lo stesso codice.

Esempio:

```c
charStackADT.h
charLinkedListStackADT.c
```

potrebbe diventare:

```c
stringStackADT.h
stringLinkedListStackADT.c

contactOpqStackADT.h
contactOpqLinkedListStackADT.c
```

Il codice sarebbe praticamente identico, tranne per il tipo degli elementi.

La domanda importante è:

> Possiamo scrivere una sola pila utilizzabile per elementi di qualsiasi tipo?

In C non esistono i generics come in Java, quindi non possiamo scrivere una cosa tipo:

```java
Stack<Integer>
Stack<String>
Stack<Contact>
```

Però possiamo simulare una forma di genericità usando i puntatori `void*`.

---

# Il tipo `void*`

## Che cos’è `void*`

Un valore di tipo:

```c
void *
```

è un puntatore a un tipo sconosciuto.

Significa:

> contiene un indirizzo di memoria, ma il compilatore non sa che tipo di dato si trova a quell’indirizzo.

Esempio:

```c
int x = 10;
void *p = &x;
```

Qui `p` contiene l’indirizzo di `x`, ma il suo tipo è `void*`.

Il compilatore sa che `p` è un puntatore, quindi sa quanto spazio occupa `p` stesso.

Ma non sa cosa ci sia dentro l’area di memoria puntata.

Potrebbe essere:

```c
int
char
double
struct Contact
char *
```

oppure qualunque altro tipo.

---

## Cosa sa il compilatore

Se scrivo:

```c
int *p;
```

il compilatore sa che `p` punta a un `int`.

Quindi, quando faccio:

```c
*p
```

il compilatore sa che deve leggere un `int`, quindi sa quanti byte prendere dalla memoria.

Se invece scrivo:

```c
void *p;
```

il compilatore sa solo che `p` contiene un indirizzo.

Non sa quanti byte leggere.

Per questo motivo:

```c
void *p;
*p;        // ERRORE
```

non è valido.

---

# Perché non posso dereferenziare un `void*`

Questa è una delle cose più importanti da capire.

Un puntatore normale contiene un indirizzo, ma il suo tipo dice al compilatore **come interpretare la memoria**.

Esempio:

```c
int x = 42;
int *p = &x;

printf("%d\n", *p);
```

Qui `*p` va bene perché `p` è un `int *`.

Il compilatore sa che deve leggere `sizeof(int)` byte.

Invece:

```c
int x = 42;
void *p = &x;

printf("%d\n", *p);   // ERRORE
```

non va bene perché `p` è `void*`.

Il compilatore non sa se leggere:

```c
sizeof(int)
sizeof(char)
sizeof(double)
sizeof(struct Contact)
```

Per poter dereferenziare, dobbiamo prima convertire il puntatore al tipo corretto.

```c
int x = 42;
void *p = &x;

printf("%d\n", *(int *)p);
```

Qui:

```c
(int *)p
```

dice al compilatore:

> tratta questo `void*` come se fosse un `int*`.

Poi:

```c
*(int *)p
```

dereferenzia il puntatore convertito.

---

# Schema mentale fondamentale

Un `void*` è come un indirizzo senza etichetta.

```c
void *p;
```

vuol dire:

> so dove si trova qualcosa in memoria, ma non so che cosa sia.

Per usarlo davvero, devo rimettere l’etichetta corretta:

```c
(int *)p
(char *)p
(ContactPtr)p
```

Solo dopo posso dereferenziare.

---

# Conversioni tra puntatori e `void*`

In C, un puntatore di tipo specifico può essere assegnato a un `void*`.

Esempio:

```c
int x = 10;

int *ip = &x;
void *vp = ip;
```

Questo è valido.

Allo stesso modo, posso assegnare un `void*` a un puntatore specifico:

```c
void *vp = &x;
int *ip = vp;
```

Anche questo in C è valido.

Tuttavia, quando voglio dereferenziare, conviene essere espliciti:

```c
printf("%d\n", *(int *)vp);
```

Nota importante:

> In C il cast da `void*` a puntatore specifico è spesso implicito, ma scriverlo quando si dereferenzia rende il codice più chiaro.

---

# `void*` non significa “qualsiasi valore”

Questa è una trappola molto comune.

`void*` significa:

> puntatore a qualcosa.

Non significa:

> posso passarci direttamente un valore qualsiasi.

Esempio sbagliato:

```c
int x = 10;

push(s, x);      // SBAGLIATO
```

Se `push` riceve un `void*`, allora vuole un indirizzo.

Quindi devo passare:

```c
push(s, &x);     // GIUSTO
```

Perché `&x` è l’indirizzo di `x`.

---

# Perché usare `void*` negli ADT

Supponiamo di avere una pila implementata con lista linkata.

La versione per `char` potrebbe avere nodi fatti così:

```c
struct listNode {
    char data;
    struct listNode *next;
};
```

Se voglio una pila di stringhe, potrei fare:

```c
struct listNode {
    char *data;
    struct listNode *next;
};
```

Se voglio una pila di contatti:

```c
struct listNode {
    ContactPtr data;
    struct listNode *next;
};
```

Ma il resto della pila sarebbe praticamente identico.

Con `void*`, invece, posso scrivere:

```c
struct listNode {
    void *data;
    struct listNode *next;
};
```

Ora ogni nodo contiene un puntatore generico.

Quindi posso inserire nella pila:

```c
int *
char *
ContactPtr
double *
struct qualsiasi *
```

L’ADT non conosce il tipo reale degli elementi.

Si limita a memorizzare indirizzi.

---

# Pila generica con `void*`

## Strutture dati interne

Una pila generica implementata con lista linkata può avere questa struttura:

```c
typedef struct listNode ListNode, *ListNodePtr;

struct listNode {
    void *data;
    ListNodePtr next;
};

struct stack {
    ListNodePtr top;
    int size;
};
```

Il campo più importante è:

```c
void *data;
```

Questo significa che ogni nodo della pila contiene un puntatore generico.

La pila non sa se quel puntatore punta a:

```c
int
char
char *
Contact
double
```

o altro.

---

# Rappresentazione mentale della pila

Immagina questa pila:

```c
StackADT s;
```

Internamente ha:

```c
struct stack {
    ListNodePtr top;
    int size;
};
```

Ogni nodo ha:

```c
struct listNode {
    void *data;
    ListNodePtr next;
};
```

Quindi la pila è fatta così:

```text
Stack
+------+
| top  | ----> [ data | next ] ---> [ data | next ] ---> NULL
| size |
+------+
```

Il campo `data` non contiene direttamente un `int`, un `char` o un `Contact`.

Contiene un indirizzo.

Per esempio:

```text
data ----> int in memoria
data ----> stringa in memoria
data ----> struct Contact in memoria
```

---

# API possibile della pila generica

Un header plausibile potrebbe essere:

```c
#ifndef STACK_ADT_H
#define STACK_ADT_H

#include <stdbool.h>

typedef struct stack *StackADT;

StackADT mkStack(void);
void dsStack(StackADT *sp);

_Bool isEmptyStack(StackADT s);
int stackSize(StackADT s);

_Bool push(StackADT s, void *e);
void *pop(StackADT s);

#endif
```

Osserviamo le due funzioni fondamentali:

```c
_Bool push(StackADT s, void *e);
void *pop(StackADT s);
```

`push` riceve un `void*`.

`pop` restituisce un `void*`.

Quindi la pila è generica perché non parla più di `char`, `int`, `Contact` o altro.

Parla solo di puntatori generici.

---

# Implementazione di `push`

La funzione `push` aggiunge un nuovo nodo in testa alla lista.

```c
_Bool push(StackADT s, void *e) {
    // Crea un nuovo nodo
    ListNodePtr ptr = malloc(sizeof(*ptr));

    // Controlla se malloc è fallita
    if (ptr == NULL) {
        return 0;
    }

    // Salva il puntatore generico nel nodo
    ptr->data = e;

    // Inserisce il nodo in testa alla lista
    ptr->next = s->top;
    s->top = ptr;

    // Aggiorna la dimensione
    s->size++;

    return 1;
}
```

La cosa importante è questa:

```c
ptr->data = e;
```

Qui non viene copiato il valore puntato.

Viene copiato solo l’indirizzo.

Se faccio:

```c
int x = 10;
push(s, &x);
```

la pila memorizza l’indirizzo di `x`.

Non memorizza una copia indipendente di `10`.

Questo è fondamentale.

---

# Implementazione di `pop`

La funzione `pop` rimuove il nodo in cima alla pila e restituisce il dato contenuto.

```c
void *pop(StackADT s) {
    // Se la pila è vuota, non c'è nulla da restituire
    if (isEmptyStack(s)) {
        return NULL;
    }

    // Salvo il dato contenuto nel nodo in cima
    void *e = s->top->data;

    // Salvo il puntatore al nodo da eliminare
    ListNodePtr ptr = s->top;

    // La nuova cima diventa il nodo successivo
    s->top = ptr->next;

    // Libero il nodo della lista
    free(ptr);

    // Aggiorno la dimensione
    s->size--;

    // Restituisco il puntatore generico
    return e;
}
```

La riga fondamentale è:

```c
void *e = s->top->data;
```

Prima salvo il dato.

Poi libero il nodo.

```c
free(ptr);
```

Attenzione:

> `free(ptr)` libera il nodo della lista, non libera il dato puntato da `data`.

Questo è giusto perché la pila non sa che tipo di dato ci sia in `data`.

La pila sa gestire i suoi nodi, ma non sa gestire la memoria degli oggetti del client.

---

# Chi è responsabile della memoria?

Con una pila di `void*`, bisogna distinguere due livelli:

## 1. Memoria dei nodi della pila

Questa è responsabilità dell’ADT.

Quando faccio `push`, la pila alloca un nodo:

```c
ListNodePtr ptr = malloc(sizeof(*ptr));
```

Quando faccio `pop`, la pila libera il nodo:

```c
free(ptr);
```

## 2. Memoria degli elementi puntati

Questa è responsabilità del codice client.

Esempio:

```c
int *x = malloc(sizeof(*x));
*x = 42;

push(s, x);
```

La pila memorizza il puntatore `x`.

Quando faccio:

```c
int *p = pop(s);
```

ottengo di nuovo quel puntatore.

Poi, se quell’intero era stato allocato dinamicamente, devo liberarlo io:

```c
free(p);
```

La pila non può farlo automaticamente, perché non sa cosa contiene.

---

# Esempio completo: pila di `int`

## Caso con array locale

```c
#include <stdio.h>
#include "stackADT.h"

int main(void) {
    int a[] = {2, 4, 8};

    StackADT s = mkStack();

    printf("Stampa in ordine:\n");

    for (int i = 0; i < sizeof(a) / sizeof(*a); i++) {
        printf("%d\n", a[i]);
    }

    for (int i = 0; i < sizeof(a) / sizeof(*a); i++) {
        push(s, &a[i]);
    }

    printf("La pila contiene %d elementi\n", stackSize(s));

    printf("Stampa in ordine inverso:\n");

    for (int i = 0; i < sizeof(a) / sizeof(*a); i++) {
        int *p = pop(s);
        printf("%d\n", *p);
    }

    printf("La pila è vuota? %d\n", isEmptyStack(s));

    dsStack(&s);

    return 0;
}
```

In questo esempio:

```c
push(s, &a[i]);
```

inserisce nella pila l’indirizzo dell’elemento `a[i]`.

Quando estraggo:

```c
int *p = pop(s);
printf("%d\n", *p);
```

sto dicendo:

> il `void*` restituito da `pop` in realtà è un `int*`.

La versione compatta è:

```c
printf("%d\n", *(int *)pop(s));
```

Però, per studiare, all’inizio è meglio scriverla in due righe:

```c
int *p = pop(s);
printf("%d\n", *p);
```

Così si capisce meglio cosa sta succedendo.

---

# Perché la stampa è in ordine inverso?

Se inserisco:

```c
2
4
8
```

nella pila, succede questo:

```text
push 2     top -> 2
push 4     top -> 4 -> 2
push 8     top -> 8 -> 4 -> 2
```

La pila è LIFO:

```text
Last In, First Out
```

L’ultimo elemento inserito è il primo a uscire.

Quindi `pop` restituisce:

```text
8
4
2
```

---

# Attenzione alla validità dei puntatori

La slide sottolinea una cosa importantissima:

> La pila memorizza puntatori. La validità dei puntatori è responsabilità del codice client.

Questo significa che l’ADT non controlla se il puntatore che gli passi continuerà a essere valido.

Esempio pericoloso:

```c
StackADT creaStack(void) {
    StackADT s = mkStack();

    int x = 42;
    push(s, &x);

    return s;
}
```

Questo codice è sbagliato.

Perché?

`x` è una variabile locale della funzione `creaStack`.

Quando la funzione termina, `x` non esiste più.

La pila contiene ancora l’indirizzo di `x`, ma quell’indirizzo non è più valido.

Quindi abbiamo un dangling pointer.

Uso successivo:

```c
StackADT s = creaStack();

int *p = pop(s);
printf("%d\n", *p);   // comportamento indefinito
```

Questo è un errore molto grave.

---

# Versione corretta con memoria dinamica

Se voglio che il dato sopravviva anche dopo la fine della funzione, devo allocarlo dinamicamente.

```c
StackADT creaStack(void) {
    StackADT s = mkStack();

    int *x = malloc(sizeof(*x));

    if (x == NULL) {
        dsStack(&s);
        return NULL;
    }

    *x = 42;
    push(s, x);

    return s;
}
```

Poi chi usa la pila dovrà liberare il dato:

```c
StackADT s = creaStack();

int *p = pop(s);

printf("%d\n", *p);

free(p);
dsStack(&s);
```

Qui:

```c
free(p);
```

libera l’intero allocato dinamicamente.

```c
dsStack(&s);
```

libera la struttura della pila e i suoi nodi.

---

# Esempio: pila di stringhe

Con `void*` posso usare la stessa pila anche per stringhe.

```c
#include <stdio.h>
#include "stackADT.h"

int main(void) {
    char *words[] = {"ciao", "mondo", "stack"};

    StackADT s = mkStack();

    for (int i = 0; i < 3; i++) {
        push(s, words[i]);
    }

    while (!isEmptyStack(s)) {
        char *word = pop(s);
        printf("%s\n", word);
    }

    dsStack(&s);

    return 0;
}
```

Output:

```text
stack
mondo
ciao
```

Anche qui la pila non sa di contenere stringhe.

Per la pila sono solo `void*`.

Il client invece sa che quei puntatori sono `char*`, quindi fa:

```c
char *word = pop(s);
```

oppure:

```c
printf("%s\n", (char *)pop(s));
```

---

# Esempio: pila di `ContactPtr`

Immaginiamo di avere un ADT opaco `Contact`.

Nel file `contact.h` potremmo avere:

```c
typedef struct contact *ContactPtr;
```

Il client non conosce i campi interni del contatto.

Però può comunque gestire puntatori a contatti.

Con la pila generica:

```c
StackADT s = mkStack();

ContactPtr c1 = mkContact("Mario", "Rossi");
ContactPtr c2 = mkContact("Luca", "Bianchi");

push(s, c1);
push(s, c2);

ContactPtr top = pop(s);
printContact(top);

dsContact(&top);

top = pop(s);
printContact(top);

dsContact(&top);

dsStack(&s);
```

Qui la pila memorizza `ContactPtr`, ma per lei sono semplicemente `void*`.

Il vantaggio è enorme:

> la stessa pila può essere riutilizzata per qualsiasi ADT opaco.

---

# Errore tipico: cast sbagliato

Con `void*` perdiamo il controllo statico del tipo.

Questo significa che il compilatore non può impedirci di fare stupidaggini.

Esempio:

```c
int x = 65;

StackADT s = mkStack();

push(s, &x);

char *p = pop(s);       // SBAGLIATO
printf("%c\n", *p);     // comportamento scorretto
```

Abbiamo inserito un `int*`, ma lo stiamo leggendo come `char*`.

Il compilatore potrebbe anche non protestare, perché `void*` consente conversioni tra puntatori.

Ma il programma è logicamente sbagliato.

Regola:

> chi fa `pop` deve sapere esattamente che tipo di puntatore era stato inserito con `push`.

---

# Errore tipico: passare valori invece di indirizzi

Questa cosa va capita benissimo.

Se la funzione è:

```c
_Bool push(StackADT s, void *e);
```

allora il secondo parametro deve essere un puntatore.

Sbagliato:

```c
int x = 10;
push(s, x);
```

Giusto:

```c
int x = 10;
push(s, &x);
```

Sbagliato:

```c
char c = 'A';
push(s, c);
```

Giusto:

```c
char c = 'A';
push(s, &c);
```

Però attenzione: se `c` è una variabile locale che muore prima del `pop`, allora il puntatore diventa non valido.

---

# Esempio con `char`

Se voglio inserire un singolo carattere nella pila generica:

```c
char c = 'A';
push(s, &c);
```

Per recuperarlo:

```c
char *p = pop(s);
printf("%c\n", *p);
```

Oppure:

```c
printf("%c\n", *(char *)pop(s));
```

Ma questa soluzione è sicura solo se `c` è ancora viva quando faccio `pop`.

Se invece voglio una versione più robusta:

```c
char *c = malloc(sizeof(*c));

if (c != NULL) {
    *c = 'A';
    push(s, c);
}
```

Poi:

```c
char *p = pop(s);
printf("%c\n", *p);
free(p);
```

---

# `pop` restituisce `NULL`

Nella pila vista nella slide, se la pila è vuota:

```c
if (isEmptyStack(s)) {
    return NULL;
}
```

Quindi:

```c
void *e = pop(s);
```

potrebbe restituire `NULL`.

Il client dovrebbe sempre controllare:

```c
void *e = pop(s);

if (e != NULL) {
    // uso e
}
```

Però c’è una sottigliezza:

siccome la pila accetta `void*`, potrei teoricamente fare:

```c
push(s, NULL);
```

In quel caso `pop` restituirebbe `NULL`, ma la pila non era vuota.

Quindi in un’API più robusta si potrebbe evitare di permettere `NULL`, oppure usare un altro modo per segnalare il fallimento.

Per il corso, probabilmente basta ricordare:

> in questa implementazione `NULL` viene usato per dire che la pila è vuota.

---

# Differenza tra pila specifica e pila generica

## Pila specifica di `char`

```c
_Bool push(StackADT s, char e);
char pop(StackADT s);
```

Il nodo contiene:

```c
char data;
```

Quindi la pila memorizza direttamente il carattere.

## Pila generica con `void*`

```c
_Bool push(StackADT s, void *e);
void *pop(StackADT s);
```

Il nodo contiene:

```c
void *data;
```

Quindi la pila memorizza un puntatore.

Questa differenza è enorme.

Nel primo caso:

```c
push(s, 'A');
```

Nel secondo caso:

```c
char c = 'A';
push(s, &c);
```

Oppure:

```c
char *c = malloc(sizeof(*c));
*c = 'A';
push(s, c);
```

---

# Vantaggi di `void*`

## 1. Riuso del codice

Scrivo una sola implementazione:

```c
stackADT.h
stackADT.c
```

e posso usarla con tanti tipi diversi.

## 2. Funziona bene con ADT opachi

Se ho:

```c
typedef struct contact *ContactPtr;
```

posso inserire `ContactPtr` nella pila senza conoscere la struttura interna.

## 3. Riduce duplicazione

Non devo creare:

```c
intStack
charStack
stringStack
contactStack
```

Scrivo una sola pila.

## 4. È una tecnica classica del C

Molte librerie C usano `void*` per implementare strutture dati generiche, callback, confronti, ordinamenti e container.

---

# Svantaggi di `void*`

## 1. Perdo sicurezza sui tipi

Il compilatore non sa più cosa sto mettendo nella pila.

Posso inserire un `int*` e poi estrarlo come `char*`.

Il compilatore potrebbe non accorgersene.

## 2. Devo fare cast corretti

Quando estraggo:

```c
void *e = pop(s);
```

devo sapere io che tipo reale ha `e`.

Esempio:

```c
int *p = e;
```

oppure:

```c
int *p = (int *)e;
```

## 3. Devo gestire la memoria con attenzione

La pila libera i nodi.

Il client deve liberare i dati, se sono stati allocati dinamicamente.

## 4. Posso creare dangling pointer

Se inserisco l’indirizzo di una variabile locale e poi quella variabile non esiste più, la pila contiene un puntatore non valido.

---

# Esempio completo da riscrivere per esercitarsi

Questo esempio è molto utile da riscrivere a mano perché contiene tutti i concetti importanti.

```c
#include <stdio.h>
#include <stdlib.h>
#include "stackADT.h"

int main(void) {
    StackADT s = mkStack();

    if (s == NULL) {
        printf("Errore creazione stack\n");
        return 1;
    }

    int *a = malloc(sizeof(*a));
    int *b = malloc(sizeof(*b));
    int *c = malloc(sizeof(*c));

    if (a == NULL || b == NULL || c == NULL) {
        free(a);
        free(b);
        free(c);
        dsStack(&s);
        return 1;
    }

    *a = 10;
    *b = 20;
    *c = 30;

    push(s, a);
    push(s, b);
    push(s, c);

    while (!isEmptyStack(s)) {
        int *value = pop(s);

        printf("%d\n", *value);

        free(value);
    }

    dsStack(&s);

    return 0;
}
```

Output:

```text
30
20
10
```

Qui:

```c
int *a = malloc(sizeof(*a));
```

crea un intero dinamico.

```c
push(s, a);
```

mette nella pila l’indirizzo dell’intero.

```c
int *value = pop(s);
```

recupera l’indirizzo.

```c
printf("%d\n", *value);
```

stampa il valore puntato.

```c
free(value);
```

libera l’intero dinamico.

```c
dsStack(&s);
```

libera la pila.

---

# Possibile implementazione completa dell’ADT

## File `stackADT.h`

```c
#ifndef STACK_ADT_H
#define STACK_ADT_H

#include <stdbool.h>

typedef struct stack *StackADT;

StackADT mkStack(void);
void dsStack(StackADT *sp);

_Bool isEmptyStack(StackADT s);
int stackSize(StackADT s);

_Bool push(StackADT s, void *e);
void *pop(StackADT s);

#endif
```

---

## File `stackADT.c`

```c
#include <stdlib.h>
#include "stackADT.h"

typedef struct listNode ListNode, *ListNodePtr;

struct listNode {
    void *data;
    ListNodePtr next;
};

struct stack {
    ListNodePtr top;
    int size;
};

StackADT mkStack(void) {
    StackADT s = malloc(sizeof(*s));

    if (s == NULL) {
        return NULL;
    }

    s->top = NULL;
    s->size = 0;

    return s;
}

_Bool isEmptyStack(StackADT s) {
    return s == NULL || s->top == NULL;
}

int stackSize(StackADT s) {
    if (s == NULL) {
        return 0;
    }

    return s->size;
}

_Bool push(StackADT s, void *e) {
    if (s == NULL) {
        return 0;
    }

    ListNodePtr ptr = malloc(sizeof(*ptr));

    if (ptr == NULL) {
        return 0;
    }

    ptr->data = e;
    ptr->next = s->top;
    s->top = ptr;

    s->size++;

    return 1;
}

void *pop(StackADT s) {
    if (s == NULL || isEmptyStack(s)) {
        return NULL;
    }

    void *e = s->top->data;

    ListNodePtr ptr = s->top;
    s->top = ptr->next;

    free(ptr);

    s->size--;

    return e;
}

void dsStack(StackADT *sp) {
    if (sp == NULL || *sp == NULL) {
        return;
    }

    StackADT s = *sp;

    while (!isEmptyStack(s)) {
        pop(s);
    }

    free(s);

    *sp = NULL;
}
```

Nota importantissima su `dsStack`:

```c
while (!isEmptyStack(s)) {
    pop(s);
}
```

Questa libera i nodi della pila, perché `pop` fa:

```c
free(ptr);
```

Ma non libera i dati puntati.

Quindi, se dentro la pila ci sono puntatori a memoria dinamica ancora non liberata, questa versione di `dsStack` non basta a evitare memory leak.

---

# Distruzione della pila e dati dinamici

Supponiamo di fare:

```c
int *x = malloc(sizeof(*x));
*x = 42;

push(s, x);

dsStack(&s);
```

Problema:

* `dsStack` libera il nodo;
* `dsStack` libera la struttura della pila;
* ma non libera `x`.

Quindi `x` rimane allocato e abbiamo una perdita di memoria.

La soluzione semplice è svuotare manualmente la pila prima:

```c
while (!isEmptyStack(s)) {
    int *x = pop(s);
    free(x);
}

dsStack(&s);
```

Questa è la soluzione più chiara per il corso.

---

# Variante più avanzata: distruttore tramite puntatore a funzione

Per una soluzione più elegante si potrebbe dare a `dsStack` una funzione che sa come distruggere ogni elemento.

Esempio:

```c
void dsStackWithData(StackADT *sp, void (*destroy)(void *));
```

Uso:

```c
void destroyInt(void *p) {
    free(p);
}
```

Poi:

```c
dsStackWithData(&s, destroyInt);
```

Implementazione possibile:

```c
void dsStackWithData(StackADT *sp, void (*destroy)(void *)) {
    if (sp == NULL || *sp == NULL) {
        return;
    }

    StackADT s = *sp;

    while (!isEmptyStack(s)) {
        void *data = pop(s);

        if (destroy != NULL) {
            destroy(data);
        }
    }

    free(s);
    *sp = NULL;
}
```

Questa versione unisce due concetti molto importanti del corso:

* `void*`;
* puntatori a funzione.

Per un esame da 30 e lode, è utile capire perché questa versione è più generica.

La pila continua a non sapere che tipo di elementi contiene, però riceve dal client una funzione capace di distruggerli.

---

# Cosa succede davvero in memoria

Consideriamo:

```c
int a[] = {2, 4, 8};

push(s, &a[0]);
push(s, &a[1]);
push(s, &a[2]);
```

In memoria abbiamo:

```text
Array a:

+-----+-----+-----+
|  2  |  4  |  8  |
+-----+-----+-----+
  ^     ^     ^
  |     |     |
&a[0] &a[1] &a[2]
```

La pila contiene nodi che puntano a quegli elementi:

```text
top
 |
 v
+---------+------+     +---------+------+     +---------+------+
| &a[2]   | next | --> | &a[1]   | next | --> | &a[0]   | NULL |
+---------+------+     +---------+------+     +---------+------+
```

Quando faccio:

```c
int *p = pop(s);
```

ottengo:

```c
&a[2]
```

Quindi:

```c
*p
```

vale:

```c
8
```

---

# Differenza tra copiare valore e copiare indirizzo

Questa è una distinzione da sapere benissimo.

## Copia del valore

In una pila di `char`:

```c
push(s, 'A');
```

il valore `'A'` viene copiato dentro il nodo.

Se poi modifico la variabile originale, la pila non cambia.

## Copia dell’indirizzo

In una pila di `void*`:

```c
int x = 10;
push(s, &x);
```

viene copiato l’indirizzo di `x`.

Se poi modifico `x`:

```c
x = 99;
```

la pila punta sempre a `x`, quindi quando faccio `pop` e dereferenzio vedrò `99`.

Esempio:

```c
int x = 10;

push(s, &x);

x = 99;

int *p = pop(s);

printf("%d\n", *p);
```

Output:

```text
99
```

Questo succede perché la pila non aveva salvato una copia di `10`.

Aveva salvato l’indirizzo di `x`.

---

# Mini esercizio 1

Prevedi l’output.

```c
int x = 5;
int y = 7;

StackADT s = mkStack();

push(s, &x);
push(s, &y);

x = 100;
y = 200;

printf("%d\n", *(int *)pop(s));
printf("%d\n", *(int *)pop(s));

dsStack(&s);
```

Soluzione:

```text
200
100
```

Perché:

* la pila è LIFO;
* il primo `pop` restituisce `&y`;
* `y` è stato modificato a `200`;
* il secondo `pop` restituisce `&x`;
* `x` è stato modificato a `100`.

---

# Mini esercizio 2

Individua l’errore.

```c
StackADT s = mkStack();

int x = 42;

push(s, x);

printf("%d\n", *(int *)pop(s));

dsStack(&s);
```

Errore:

```c
push(s, x);
```

`push` vuole un `void*`, quindi un puntatore.

Correzione:

```c
push(s, &x);
```

Codice corretto:

```c
StackADT s = mkStack();

int x = 42;

push(s, &x);

printf("%d\n", *(int *)pop(s));

dsStack(&s);
```

---

# Mini esercizio 3

Individua il problema.

```c
StackADT makeStack(void) {
    StackADT s = mkStack();

    int x = 42;

    push(s, &x);

    return s;
}
```

Problema:

```c
x
```

è una variabile locale.

Quando `makeStack` termina, `x` non esiste più.

La pila contiene un dangling pointer.

Correzione:

```c
StackADT makeStack(void) {
    StackADT s = mkStack();

    int *x = malloc(sizeof(*x));

    if (x == NULL) {
        dsStack(&s);
        return NULL;
    }

    *x = 42;

    push(s, x);

    return s;
}
```

Poi il client deve fare:

```c
int *p = pop(s);
printf("%d\n", *p);
free(p);

dsStack(&s);
```

---

# Mini esercizio 4

Scrivi una pila di stringhe usando la pila generica.

Soluzione:

```c
#include <stdio.h>
#include "stackADT.h"

int main(void) {
    StackADT s = mkStack();

    char *a = "uno";
    char *b = "due";
    char *c = "tre";

    push(s, a);
    push(s, b);
    push(s, c);

    while (!isEmptyStack(s)) {
        char *word = pop(s);
        printf("%s\n", word);
    }

    dsStack(&s);

    return 0;
}
```

Output:

```text
tre
due
uno
```

---

# Domande da esame

## 1. Che cos’è un `void*`?

È un puntatore generico.

Contiene un indirizzo di memoria, ma il compilatore non conosce il tipo del dato puntato.

---

## 2. Perché non posso fare `*p` se `p` è `void*`?

Perché il compilatore non sa quanti byte leggere e come interpretarli.

Devo prima convertire il puntatore a un tipo specifico.

Esempio:

```c
*(int *)p
```

---

## 3. Perché una pila con `void*` è generica?

Perché i nodi non contengono direttamente valori di un tipo specifico, ma puntatori generici.

Quindi la stessa struttura dati può contenere indirizzi di oggetti diversi.

---

## 4. Chi deve liberare i dati puntati?

Il client.

La pila libera i suoi nodi, ma non sa come liberare i dati puntati da `void*`.

---

## 5. Qual è il rischio principale usando `void*`?

Perdere sicurezza sui tipi.

Il compilatore non può verificare che il tipo usato in fase di `pop` sia lo stesso usato in fase di `push`.

---

## 6. Perché `push(s, &a[i])` è corretto?

Perché `push` vuole un puntatore.

`&a[i]` è l’indirizzo dell’elemento `a[i]`.

---

## 7. Perché `printf("%d\n", *(int *)pop(s));` funziona?

Perché:

```c
pop(s)
```

restituisce un `void*`.

Poi:

```c
(int *)pop(s)
```

lo converte in `int*`.

Infine:

```c
*(int *)pop(s)
```

dereferenzia l’`int*` ottenuto.

---

# Frase da ricordare

> `void*` permette di scrivere ADT generici in C, ma sposta sul client la responsabilità di sapere il tipo reale degli elementi e di gestire correttamente la memoria.

---

# Checklist per il 30 e lode

Devo saper spiegare bene:

* che cos’è un `void*`;
* perché non si può dereferenziare direttamente;
* perché bisogna fare cast al tipo corretto;
* perché una pila di `void*` memorizza puntatori, non valori;
* chi gestisce la memoria dei nodi;
* chi gestisce la memoria dei dati;
* cosa succede se inserisco l’indirizzo di una variabile locale;
* perché `pop` restituisce un `void*`;
* perché `push` riceve un `void*`;
* come usare la stessa pila con `int`, `char*` e `ContactPtr`;
* quali sono i rischi di type safety;
* come evitare dangling pointer e memory leak.

---

# Codici da riscrivere a mano

Per prendere confidenza, conviene riscrivere almeno questi esempi:

1. `stackADT.h` generico con `void*`;
2. implementazione di `push`;
3. implementazione di `pop`;
4. esempio con array di `int`;
5. esempio con `malloc` e `free`;
6. esempio con stringhe;
7. esempio sbagliato con dangling pointer;
8. versione avanzata con funzione distruttrice.

Se riesco a riscrivere questi esempi senza guardarli, allora ho capito davvero il senso di `void*`.
