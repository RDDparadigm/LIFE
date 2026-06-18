# Allocazione della Memoria in C

Argomenti principali:

- variabili locali `static`
    
- variabili globali
    
- `extern`
    
- `static` a livello globale
    
- memoria statica
    
- memoria automatica / stack
    
- memoria dinamica / heap
    
- `malloc`
    
- `free`
    
- array statici e dinamici
    
- struct allocate staticamente o dinamicamente
    
- passaggio di array e struct alle funzioni
    
- funzioni variadiche
    
- `va_list`, `va_start`, `va_arg`, `va_end`
    

---

# 1. Idea centrale della lezione

In C è fondamentale capire **dove vive una variabile in memoria**, **quanto dura la sua vita**, **chi gestisce la sua allocazione** e **come vi si accede**.

Una variabile può essere allocata principalmente in tre zone:

| Tipo di memoria    | Dove         | Gestione                    | Esempi                                          |
| ------------------ | ------------ | --------------------------- | ----------------------------------------------- |
| Memoria statica    | area statica | automatica dal programma    | variabili globali, variabili locali `static`    |
| Memoria automatica | stack        | automatica                  | variabili locali normali, parametri di funzione |
| Memoria dinamica   | heap         | esplicita dal programmatore | memoria ottenuta con `malloc`                   |

La distinzione più importante è questa che segue:

> Le variabili automatiche e statiche vengono gestite dal ==linguaggio/runtime==.  
> La memoria ==dinamica== deve essere **gestita manualmente** dal programmatore con `malloc` e `free`.

---

# 2. Variabili locali normali

Una variabile locale è una variabile dichiarata dentro una funzione.

Esempio:

```c
void funzione(void) {
    int x = 0;
}
```

La variabile `x`:

- nasce quando la funzione viene chiamata;
    
- ==vive nello stack==;
    
- muore quando la funzione termina;
    
- **non conserva** il valore tra una chiamata e l’altra.
    

Esempio:

```c
#include <stdio.h>

void conta(void) {
    int x = 1;
    printf("x = %d\n", x);
    x++;
}

int main(void) {
    conta();
    conta();
    conta();

    return 0;
}
```

Output:

```text
x = 1
x = 1
x = 1
```

Perché?

Ogni chiamata a `conta()` crea una nuova variabile locale `x`, inizializzata di nuovo a `1`.

---

# 3. Variabili locali `static`

Una variabile locale dichiarata `static` è diversa.

Esempio:

```c
int nextNumber(void) {
    static int counter = 1;
    return counter++;
}
```

Qui `counter`:

- è visibile solo dentro la funzione `nextNumber`;
    
- viene inizializzata una sola volta;
    
- **mantiene** il suo valore tra una chiamata e l’altra;
    
- vive in ==memoria statica==, non nello stack.
    

Esempio completo:

```c
#include <stdio.h>

int nextNumber(void) {
    static int counter = 1;
    return counter++;
}

int main(void) {
    printf("%d\n", nextNumber());
    printf("%d\n", nextNumber());
    printf("%d\n", nextNumber());
    printf("%d\n", nextNumber());

    return 0;
}
```

Output:

```text
1
2
3
4
```

## Cosa capire bene

Una variabile locale `static` ha:

- **scope locale**, cioè è accessibile solo dentro la funzione;
    
- **lifetime globale/statico**, cioè resta viva per tutta la durata del programma.
    

Questa distinzione è importantissima:

|Concetto|Significato|
|---|---|
|Scope|Dove posso usare il nome della variabile|
|Lifetime|Per quanto tempo la variabile esiste in memoria|

Quindi:

```c
void f(void) {
    static int x = 0;
}
```

`x` **non si può usare fuori** da `f`, ma continua a esistere anche quando `f` termina.

---

# 4. Variabili globali

Una variabile globale è dichiarata ==fuori da ogni funzione==.

Esempio:

```c
#include <stdio.h>

int g = 10;

void stampa(void) {
    printf("%d\n", g);
}

int main(void) {
    stampa();
    g = 20;
    stampa();

    return 0;
}
```

Output:

```text
10
20
```

Una variabile globale:

- vive in ==memoria statica==;
    
- esiste per tutta la durata del programma;
    
- è visibile nel file da dove viene dichiarata in poi;
    
- può essere resa **accessibile anche da altri** file usando `extern`.
    

## Attenzione

Le variabili globali vanno usate con molta parsimonia.

Perché?

- rendono il codice meno modulare;
    
- rendono più difficile capire chi modifica cosa;
    
- possono creare dipendenze nascoste tra funzioni;
    
- complicano il debugging.
    

Per l’esame bisogna saperle capire, ma nei programmi ben scritti spesso si preferisce passare i dati alle funzioni tramite parametri.

---

# 5. `extern`

La parola chiave `extern` serve a dire:

> Questa variabile esiste, ma la sua definizione vera si trova altrove.

Esempio con più file.

File `main.c`:

```c
#include <stdio.h>

extern int contatore;

void incrementa(void);

int main(void) {
    printf("contatore = %d\n", contatore);

    incrementa();

    printf("contatore = %d\n", contatore);

    return 0;
}
```

File `counter.c`:

```c
int contatore = 0;

void incrementa(void) {
    contatore++;
}
```

Qui:

```c
extern int contatore;
```

non crea una nuova variabile.

Dice solo al compilatore:

> Esiste una variabile globale di tipo `int` chiamata `contatore`, definita da qualche altra parte.

## Differenza tra dichiarazione e definizione

Questa è una dichiarazione:

```c
extern int x;
```

Questa è una definizione:

```c
int x = 0;
```

La definizione ==alloca memoria==.

La dichiarazione con `extern` no.

---

# 6. `static` su variabili globali

A livello globale, `static` ha un significato diverso rispetto alle variabili locali `static`.

Esempio:

```c
static int segreto = 42;
```

Qui `segreto`:

- è una variabile globale;
    
- vive in memoria statica;
    
- esiste per tutta la durata del programma;
    
- è visibile solo dentro quel file `.c`.
    

Quindi `static` a livello globale serve a **nascondere** una variabile agli altri file.

Esempio:

File `modulo.c`:

```c
static int contatoreInterno = 0;

void incrementa(void) {
    contatoreInterno++;
}
```

File `main.c`:

```c
extern int contatoreInterno; // ERRORE concettuale: non posso accedervi
```

`contatoreInterno` è nascosto dentro `modulo.c`.

## Riassunto dei due usi di `static`

| Dove uso `static`     | Effetto                                                 |
| --------------------- | ------------------------------------------------------- |
| Dentro una funzione   | la variabile mantiene il valore tra le chiamate         |
| Fuori da una funzione | la variabile/funzione è visibile solo nel file corrente |

---

# 7. Visibilità delle funzioni

Anche le funzioni possono essere `static`.

Esempio:

```c
static void funzioneDiSupporto(void) {
    // usabile solo in questo file
}
```

Una funzione normale:

```c
void f(void);
```

è implicitamente `extern`, quindi **può essere vista** anche da altri file se dichiarata con un prototipo.

Per questo di solito non si scrive:

```c
extern void f(void);
```

anche se sarebbe possibile.

---

# 8. Tipi di memoria in un programma C

Un programma C in esecuzione usa diverse aree di memoria.

Schema concettuale:

```text
+---------------------+
| Area programma      |
+---------------------+
| Area statica        |
+---------------------+
| Heap                |
|   cresce/diminuisce |
+---------------------+
| Stack               |
|   cresce/diminuisce |
+---------------------+
```

## Area programma

Contiene il ==codice compilato ed eseguibile==.

Esempio: le istruzioni macchina corrispondenti al tuo `main`, alle tue funzioni, ecc.

## Area statica

Contiene:

- variabili globali;
    
- variabili locali `static`.
    

Esempio:

```c
int globale = 5;

void f(void) {
    static int x = 0;
}
```

Sia `globale` sia `x` vivono in memoria statica.

## Stack

Contiene:

- parametri delle funzioni;
    
- variabili locali non `static`;
    
- informazioni per tornare alla funzione chiamante.
    

Esempio:

```c
void f(int n) {
    int x = 10;
}
```

`n` e `x` vivono nello stack.

Quando `f` termina, spariscono.

## Heap

Contiene memoria ==allocata dinamicamente==.

Esempio:

```c
int *p = malloc(sizeof(*p));
```

La variabile `p` vive nello stack se dichiarata dentro una funzione, ma la memoria a cui punta vive nell’heap.

Questa distinzione è essenziale.

---

# 9. Puntatore vs memoria puntata

Esempio:

```c
int *p = malloc(sizeof(*p));
```

Qui ci sono due cose diverse:

1. `p`, cioè il puntatore;
    
2. `*p`, cioè l’intero allocato dinamicamente.
    

Se `p` è una variabile locale, allora:

- `p` vive **nello stack**;
    
- la memoria ottenuta con `malloc` vive nell’heap.
    

Schema:

```text
Stack:             Heap:

p  ----------->    [ int ]
```

Quindi quando scrivo:

```c
free(p);
```

libero la memoria nello heap, non la variabile `p`.

La variabile `p` continua a esistere fino alla fine della funzione.

---

# 10. `malloc`

La funzione `malloc` serve ad allocare memoria dinamica.

Prototipo:

```c
void *malloc(size_t size);
```

Sta in:

```c
#include <stdlib.h>
```

Esempio:

```c
#include <stdlib.h>

int *p = malloc(sizeof(*p));
```

`malloc`:

- riceve il numero di byte da allocare;
    
- restituisce un **puntatore al primo byte** dell’area allocata;
    
- restituisce `NULL` se l’allocazione fallisce.
    

## Controllare sempre il risultato di `malloc`

Esempio corretto:

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = malloc(sizeof(*p));

    if (p == NULL) {
        printf("Errore di allocazione\n");
        return 1;
    }

    *p = 42;

    printf("*p = %d\n", *p);

    free(p);
    p = NULL;

    return 0;
}
```

Questo è uno schema da imparare bene:

```c
T *p = malloc(sizeof(*p));

if (p == NULL) {
    // gestisci errore
}

// usa p

free(p);
p = NULL;
```


---

# 11. Perché scrivere `sizeof(*p)` e non `sizeof(int)`

È meglio scrivere:

```c
int *p = malloc(sizeof(*p));
```

invece di:

```c
int *p = malloc(sizeof(int));
```

Perché?

Se in futuro cambio tipo:

```c
double *p = malloc(sizeof(*p));
```

il codice rimane corretto.

Invece questo potrebbe diventare sbagliato:

```c
double *p = malloc(sizeof(int)); // ERRORE: alloco spazio per int, ma voglio double
```

Regola d’oro:

> Quando allochi memoria per un puntatore `p`, usa quasi sempre `sizeof(*p)`.

---

# 12. Il cast di `malloc` in C

In C il cast del risultato di `malloc` non è necessario.

Si può scrivere:

```c
int *p = malloc(sizeof(*p));
```

Non serve scrivere:

```c
int *p = (int *) malloc(sizeof(*p));
```

Anzi, in C moderno è spesso preferibile evitare il cast.

Perché?

- `malloc` restituisce `void *`;
    
- in C, `void *` viene convertito automaticamente nel tipo di puntatore corretto;
    
- il cast può nascondere errori, per esempio se dimentico `#include <stdlib.h>`.
    

Nota: in C++ il cast sarebbe necessario, ma qui stiamo parlando di C.

---

# 13. `free`

La funzione `free` libera memoria allocata dinamicamente.

Prototipo:

```c
void free(void *ptr);
```

Esempio:

```c
int *p = malloc(sizeof(*p));

if (p == NULL) {
    return 1;
}

*p = 10;

free(p);
p = NULL;
```

Dopo:

```c
free(p);
```

la memoria puntata da `p` viene liberata.

Però attenzione:

> `free(p)` non mette automaticamente `p` a `NULL`.

Quindi dopo `free(p)`, `p` contiene ancora un indirizzo, ma quell’indirizzo non è più valido.

Questo puntatore si chiama **dangling pointer**.

---

# 14. Dangling pointer

Esempio sbagliato:

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = malloc(sizeof(*p));

    if (p == NULL) {
        return 1;
    }

    *p = 42;

    free(p);

    printf("%d\n", *p); // ERRORE: uso memoria già liberata

    return 0;
}
```

Dopo `free(p)`, non posso più usare:

```c
*p
```

Per sicurezza:

```c
free(p);
p = NULL;
```

Così posso controllare:

```c
if (p != NULL) {
    printf("%d\n", *p);
}
```

## Attenzione

Mettere `p = NULL` non libera memoria.

La sequenza corretta è:

```c
free(p);
p = NULL;
```

Non:

```c
p = NULL; // se lo faccio prima di free, perdo l'indirizzo della memoria allocata
```

Esempio di memory leak:

```c
int *p = malloc(sizeof(*p));

p = NULL; // ERRORE: ho perso l'indirizzo, non posso più fare free
```

---

# 15. Memory leak

Un memory leak avviene quando alloco memoria dinamica ma non la libero più.

Esempio:

```c
void f(void) {
    int *p = malloc(sizeof(*p));

    if (p == NULL) {
        return;
    }

    *p = 10;

    // manca free(p)
}
```

Quando `f` termina:

- la variabile `p` sparisce dallo stack;
    
- la memoria nello heap resta occupata;
    
- non ho più l’indirizzo per liberarla.
    

Questo è un errore grave nei programmi lunghi.

Regola:

> Ogni `malloc` deve avere una `free` corrispondente.

---

# 16. Allocazione statica/automatica di variabile semplice

Esempio:

```c
int x;
x = 0;
```

Qui `x` è una variabile normale.

Se è dichiarata dentro una funzione:

```c
void f(void) {
    int x = 0;
}
```

allora vive nello stack.

Se è dichiarata fuori da ogni funzione:

```c
int x = 0;
```

allora vive in memoria statica.

In entrambi i casi, il programmatore non deve chiamare `free`.

---

# 17. Allocazione dinamica di variabile semplice

Esempio:

```c
int *x;

x = malloc(sizeof(*x));

if (x == NULL) {
    return 1;
}

*x = 0;

free(x);
x = NULL;
```

Differenza importante:

```c
int x = 0;
```

qui `x` è direttamente un intero.

```c
int *x = malloc(sizeof(*x));
*x = 0;
```

qui `x` è un puntatore a un intero allocato dinamicamente.

---

# 18. Allocazione statica/automatica vs dinamica

## Allocazione statica/automatica

Esempio:

```c
int array[100];
```

Vantaggi:

- più semplice;
    
- più veloce;
    
- non devo fare `malloc`;
    
- non devo fare `free`.
    

Svantaggi:

- dimensione spesso fissata prima;
    
- potrei allocare più spazio di quello che uso;
    
- la memoria automatica sparisce alla fine della funzione.
    

## Allocazione dinamica

Esempio:

```c
int *array = malloc(sizeof(*array) * n);
```

Vantaggi:

- posso decidere la dimensione a runtime;
    
- uso solo la memoria che mi serve;
    
- posso creare strutture dati più flessibili.
    

Svantaggi:

- devo controllare `malloc`;
    
- devo ricordarmi `free`;
    
- rischio memory leak;
    
- rischio dangling pointer;
    
- accesso concettualmente più complesso.
    

---

# 19. Array statici/automatici

Esempio:

```c
int v[10];
```

Se `sizeof(int) == 4`, allora:

```c
sizeof(v) == sizeof(int) * 10
```

quindi:

```c
sizeof(v) == 40
```

Un array è una zona contigua di memoria.

Posso scrivere:

```c
v[1]
```

oppure:

```c
*(v + 1)
```

Sono equivalenti.

Esempio:

```c
#include <stdio.h>

int main(void) {
    int v[3] = {10, 20, 30};

    printf("%d\n", v[0]);
    printf("%d\n", *(v + 0));

    printf("%d\n", v[1]);
    printf("%d\n", *(v + 1));

    printf("%d\n", v[2]);
    printf("%d\n", *(v + 2));

    return 0;
}
```

Output:

```text
10
10
20
20
30
30
```

## Posso fare `v + 1`?

Sì.

```c
printf("%d\n", *(v + 1));
```

## Posso fare `v++`?

No.

```c
v++; // ERRORE
```

Perché?

Il nome dell’array non è una variabile puntatore modificabile.

`v` può essere usato come indirizzo del primo elemento, ma non posso cambiare il valore di `v`.

---

# 20. Array dinamici

Esempio:

```c
int n = 10;
int *d = malloc(sizeof(*d) * n);
```

Qui `d` punta al primo elemento di un array dinamico di `n` interi.

Esempio completo:

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int n = 5;

    int *d = malloc(sizeof(*d) * n);

    if (d == NULL) {
        printf("Errore allocazione\n");
        return 1;
    }

    for (int i = 0; i < n; i++) {
        d[i] = (i + 1) * 10;
    }

    for (int i = 0; i < n; i++) {
        printf("d[%d] = %d\n", i, d[i]);
    }

    free(d);
    d = NULL;

    return 0;
}
```

Output:

```text
d[0] = 10
d[1] = 20
d[2] = 30
d[3] = 40
d[4] = 50
```

## Notazione equivalente

Per un puntatore `d`:

```c
d[i]
```

è equivalente a:

```c
*(d + i)
```

Quindi:

```c
d[2] = 30;
```

equivale a:

```c
*(d + 2) = 30;
```

---

# 21. Differenza tra array statico e puntatore dinamico

```c
int v[10];
int *d = malloc(sizeof(*d) * 10);
```

Somiglianza:

```c
v[1]
d[1]
```

funzionano entrambi.

Differenza:

```c
v++; // NO
d++; // SÌ, ma pericoloso
```

`v` è il nome di un array e non può essere modificato.

`d` è una variabile puntatore, quindi può essere incrementata.

---

# 22. Effetto di `d++`

Esempio:

```c
int *d = malloc(sizeof(*d) * 10);

d++;
```

Dopo `d++`, il puntatore non punta più al primo elemento, ma al secondo.

Se prima avevo:

```text
d -> elemento 0
```

dopo ho:

```text
d -> elemento 1
```

Per un array di `int`, se `sizeof(int) == 4`, l’indirizzo viene incrementato di 4 byte.

## Problema enorme

Se faccio:

```c
int *d = malloc(sizeof(*d) * 10);

d++;

free(d); // ERRORE
```

sto passando a `free` un indirizzo diverso da quello restituito da `malloc`.

Questo è sbagliato.

La `free` deve ricevere esattamente il puntatore originale restituito da `malloc`.

Soluzione:

```c
int *d = malloc(sizeof(*d) * 10);

if (d == NULL) {
    return 1;
}

int *inizio = d;

d++;

printf("%d\n", d[-1]); // accesso al vecchio elemento 0, se inizializzato

free(inizio);
inizio = NULL;
d = NULL;
```

Meglio ancora: evitare di modificare il puntatore originale.

Usa un indice:

```c
for (int i = 0; i < n; i++) {
    d[i] = i;
}
```

---

# 23. Deallocazione di array dinamici

Esempio corretto:

```c
int *d = malloc(sizeof(*d) * n);

if (d == NULL) {
    return 1;
}

// uso d

free(d);
d = NULL;
```

La `free` libera l’intero blocco allocato.

Non devo fare:

```c
for (int i = 0; i < n; i++) {
    free(&d[i]); // ERRORE
}
```

Perché ho fatto una sola `malloc`, quindi devo fare una sola `free`.

Regola:

> Una `malloc`, una `free`.

---

# 24. Passaggio di array come parametro

Esempio:

```c
void init(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        arr[i] = 0;
    }
}
```

Oppure:

```c
void init(int *arr, int n) {
    for (int i = 0; i < n; i++) {
        arr[i] = 0;
    }
}
```

Sono equivalenti come parametro di funzione.

Esempio completo:

```c
#include <stdio.h>
#include <stdlib.h>

void init(int *arr, int n) {
    for (int i = 0; i < n; i++) {
        arr[i] = i + 1;
    }
}

void stampa(int *arr, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main(void) {
    int n = 5;

    int astatico[5];
    int *adinamico = malloc(sizeof(*adinamico) * n);

    if (adinamico == NULL) {
        return 1;
    }

    init(astatico, n);
    stampa(astatico, n);

    init(adinamico, n);
    stampa(adinamico, n);

    free(adinamico);
    adinamico = NULL;

    return 0;
}
```

Output:

```text
1 2 3 4 5
1 2 3 4 5
```

## Cosa capire bene

Quando passo un array a una funzione, in realtà sto passando l’indirizzo del primo elemento.

Per questo la funzione può modificare il contenuto dell’array.

---

# 25. Struct

Una `struct` permette di raggruppare più campi sotto un unico tipo.

Esempio:

```c
#define MAXT 100
#define MAXN 100

typedef struct {
    char titolo[MAXT];
    int pagine;
    char autore[MAXN];
    float prezzo;
} Libro;
```

Qui `Libro` diventa un nuovo tipo.

Posso dichiarare:

```c
Libro l;
```

Questa dichiarazione alloca memoria per una variabile `l` di tipo `Libro`.

## Attenzione

Il `typedef struct { ... } Libro;` definisce un tipo.

Non alloca memoria per un libro specifico.

La memoria viene allocata quando scrivo:

```c
Libro l;
```

oppure:

```c
Libro *p = malloc(sizeof(*p));
```

---

# 26. Struct allocata automaticamente

Esempio:

```c
Libro l;

l.pagine = 200;
```

Uso il punto `.` quando ho direttamente una struct.

Esempio:

```c
#include <stdio.h>

#define MAXT 100
#define MAXN 100

typedef struct {
    char titolo[MAXT];
    int pagine;
    char autore[MAXN];
    float prezzo;
} Libro;

int main(void) {
    Libro l;

    l.pagine = 200;
    l.prezzo = 19.99f;

    printf("Pagine: %d\n", l.pagine);
    printf("Prezzo: %.2f\n", l.prezzo);

    return 0;
}
```

---

# 27. Struct allocata dinamicamente

Esempio:

```c
Libro *l = malloc(sizeof(*l));
```

Qui `l` è un puntatore a `Libro`.

Per accedere ai campi posso scrivere:

```c
(*l).pagine = 200;
```

Oppure, più comodamente:

```c
l->pagine = 200;
```

Le due scritture sono equivalenti:

```c
l->pagine
```

equivale a:

```c
(*l).pagine
```

Esempio completo:

```c
#include <stdio.h>
#include <stdlib.h>

#define MAXT 100
#define MAXN 100

typedef struct {
    char titolo[MAXT];
    int pagine;
    char autore[MAXN];
    float prezzo;
} Libro;

int main(void) {
    Libro *l = malloc(sizeof(*l));

    if (l == NULL) {
        printf("Errore allocazione\n");
        return 1;
    }

    l->pagine = 200;
    l->prezzo = 19.99f;

    printf("Pagine: %d\n", l->pagine);
    printf("Prezzo: %.2f\n", l->prezzo);

    free(l);
    l = NULL;

    return 0;
}
```

---

# 28. `.` vs `->`

Regola fondamentale:

|Caso|Operatore|
|---|---|
|Ho una struct|`.`|
|Ho un puntatore a struct|`->`|

Esempio:

```c
Libro l;
Libro *p = &l;

l.pagine = 100;
p->pagine = 200;
```

Equivalentemente:

```c
(*p).pagine = 200;
```

Attenzione alle parentesi:

```c
*p.pagine
```

è sbagliato rispetto all’intenzione, perché `.` ha precedenza più alta di `*`.

Serve:

```c
(*p).pagine
```

oppure:

```c
p->pagine
```

---

# 29. Deallocazione di struct dinamica

Esempio:

```c
Libro *l = malloc(sizeof(*l));

if (l == NULL) {
    return 1;
}

// uso l

free(l);
l = NULL;
```

Anche qui:

> `free(l)` libera la memoria nello heap, ma non mette automaticamente `l` a `NULL`.

---

# 30. Passaggio di struct alle funzioni

Consideriamo:

```c
typedef struct {
    int x;
    int y;
} Point;
```

Funzione che stampa:

```c
void stampa(Point p) {
    printf("x=%d y=%d\n", p.x, p.y);
}
```

Funzione che modifica:

```c
void init(Point *p) {
    p->x = 15;
    p->y = 25;
}
```

## Perché `stampa` prende `Point p`?

Perché non deve modificare il punto originale.

Riceve una copia.

## Perché `init` prende `Point *p`?

Perché deve modificare il punto originale.

Riceve l’indirizzo.

---

# 31. Invocare funzioni su struct automatica e dinamica

Esempio:

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int x;
    int y;
} Point;

void stampa(Point p) {
    printf("x=%d y=%d\n", p.x, p.y);
}

void init(Point *p) {
    p->x = 15;
    p->y = 25;
}

int main(void) {
    Point automatica;
    Point *dinamica = malloc(sizeof(*dinamica));

    if (dinamica == NULL) {
        return 1;
    }

    automatica.x = 10;
    automatica.y = 20;

    dinamica->x = 20;
    dinamica->y = 20;

    stampa(automatica);
    stampa(*dinamica);

    init(&automatica);
    init(dinamica);

    stampa(automatica);
    stampa(*dinamica);

    free(dinamica);
    dinamica = NULL;

    return 0;
}
```

## Cosa succede?

Per la variabile automatica:

```c
Point automatica;
```

Per stamparla:

```c
stampa(automatica);
```

Per modificarla:

```c
init(&automatica);
```

Per la variabile dinamica:

```c
Point *dinamica;
```

Per stamparla:

```c
stampa(*dinamica);
```

Per modificarla:

```c
init(dinamica);
```

Tabella fondamentale:

|Variabile|Tipo|Stampa|Modifica|
|---|---|---|---|
|`automatica`|`Point`|`stampa(automatica)`|`init(&automatica)`|
|`dinamica`|`Point *`|`stampa(*dinamica)`|`init(dinamica)`|

---

# 32. Differenza tra array e struct nel passaggio a funzione

Gli array e le struct si comportano in modo diverso.

## Array

```c
int v[10];
init(v);
```

Il nome dell’array decade a puntatore al primo elemento.

Quindi la funzione può modificare l’array originale.

## Struct

```c
Point p;
stampa(p);
```

La struct viene copiata.

La funzione riceve una copia.

Se voglio modificare l’originale:

```c
init(&p);
```

Questa è una distinzione da sapere benissimo.

---

# 33. Quiz sui tipi

Dato:

```c
#define MAXT 100
#define MAXN 100

typedef struct {
    char titolo[MAXT];
    int pagine;
    char autore[MAXN];
    float prezzo;
} Libro;

Libro l;
Libro *p = malloc(sizeof(*p));
```

Domanda: quali istruzioni compilano correttamente?

## a. `p = l;`

No.

Perché:

- `p` è di tipo `Libro *`;
    
- `l` è di tipo `Libro`.
    

Sto cercando di assegnare una struct a un puntatore.

Tipi diversi.

---

## b. `p = &l;`

Sì.

Perché:

- `p` è di tipo `Libro *`;
    
- `&l` è l’indirizzo di una variabile `Libro`, quindi è di tipo `Libro *`.
    

Attenzione però: se prima `p` puntava a memoria allocata con `malloc`, facendo:

```c
p = &l;
```

perdo l’indirizzo della memoria dinamica precedente, a meno che non abbia fatto prima `free`.

Esempio problematico:

```c
Libro *p = malloc(sizeof(*p));
p = &l; // memory leak: ho perso il blocco allocato
```

Corretto:

```c
Libro *p = malloc(sizeof(*p));

if (p == NULL) {
    return 1;
}

free(p);
p = &l;
```

---

## c. `*p = &l;`

No.

Perché:

- `*p` è di tipo `Libro`;
    
- `&l` è di tipo `Libro *`.
    

Sto cercando di assegnare un puntatore a una struct.

Tipi diversi.

---

## d. `p->titolo = l->titolo;`

No.

Perché `l` non è un puntatore.

`l->titolo` è sbagliato.

Dovrei scrivere:

```c
l.titolo
```

Ma anche:

```c
p->titolo = l.titolo;
```

non va bene, perché gli array in C non si assegnano con `=`.

Per copiare stringhe bisogna usare, ad esempio:

```c
strcpy(p->titolo, l.titolo);
```

con:

```c
#include <string.h>
```

Esempio:

```c
#include <string.h>

strcpy(p->titolo, l.titolo);
```

---

# 34. Tipi di alcune espressioni

Dato:

```c
Libro l;
```

## Tipo di `l.titolo[3]`

```c
char
```

Perché è un singolo carattere dell’array `titolo`.

## Tipo di `l.titolo`

Concettualmente è un array di `char`.

In molte espressioni decade a:

```c
char *
```

Più precisamente:

- `l.titolo` è un array di `char`;
    
- quando usato in molte espressioni, diventa puntatore al primo elemento.
    

## Tipo di `&(l.pagine)`

```c
int *
```

Perché `l.pagine` è un `int`, quindi il suo indirizzo è un puntatore a `int`.

---

# 35. Esercizio consigliato: array dinamico di struct

Obiettivo:

- definire un tipo `Canzone`;
    
- allocare dinamicamente un array di `Canzone`;
    
- riempirlo;
    
- stamparlo;
    
- liberare memoria.
    

Esempio completo:

```c
#include <stdio.h>
#include <stdlib.h>

#define MAX 3
#define MAX_TITOLO 100
#define MAX_AUTORE 100

typedef struct {
    char titolo[MAX_TITOLO];
    char autore[MAX_AUTORE];
    int durataSecondi;
} Canzone;

void leggiCanzone(Canzone *c) {
    printf("Titolo: ");
    scanf(" %99[^\n]", c->titolo);

    printf("Autore: ");
    scanf(" %99[^\n]", c->autore);

    printf("Durata in secondi: ");
    scanf("%d", &c->durataSecondi);
}

void stampaCanzone(Canzone c) {
    printf("Titolo: %s\n", c.titolo);
    printf("Autore: %s\n", c.autore);
    printf("Durata: %d secondi\n", c.durataSecondi);
}

int main(void) {
    Canzone *playlist = malloc(sizeof(*playlist) * MAX);

    if (playlist == NULL) {
        printf("Errore di allocazione\n");
        return 1;
    }

    for (int i = 0; i < MAX; i++) {
        printf("\nInserisci canzone %d\n", i + 1);
        leggiCanzone(&playlist[i]);
    }

    printf("\n--- Playlist ---\n");

    for (int i = 0; i < MAX; i++) {
        printf("\nCanzone %d\n", i + 1);
        stampaCanzone(playlist[i]);
    }

    free(playlist);
    playlist = NULL;

    return 0;
}
```

## Cose importanti in questo esercizio

Questa riga:

```c
Canzone *playlist = malloc(sizeof(*playlist) * MAX);
```

alloca un array dinamico di `MAX` elementi.

Questa riga:

```c
leggiCanzone(&playlist[i]);
```

passa alla funzione l’indirizzo della singola canzone, perché la funzione deve modificarla.

Questa riga:

```c
stampaCanzone(playlist[i]);
```

passa una copia della canzone, perché la funzione deve solo stamparla.

---

# 36. Funzioni variadiche

Una funzione variadica è una funzione che accetta un numero variabile di argomenti.

Esempio famoso:

```c
printf("x = %d, y = %.2f\n", x, y);
```

Il prototipo di `printf` è:

```c
int printf(const char *format, ...);
```

I tre puntini:

```c
...
```

indicano che la funzione può ricevere altri argomenti oltre a quelli fissi.

---

# 37. Regole per scrivere una funzione variadica

Per scrivere una funzione variadica servono:

```c
#include <stdarg.h>
```

Gli strumenti principali sono:

|Strumento|Significato|
|---|---|
|`va_list`|tipo che rappresenta la lista degli argomenti variabili|
|`va_start`|inizializza la lettura degli argomenti variabili|
|`va_arg`|legge il prossimo argomento|
|`va_end`|termina la lettura e pulisce|

Una funzione variadica deve avere almeno un parametro fisso.

Esempio:

```c
double average(int n, ...);
```

Qui `n` è il parametro fisso.

I puntini devono essere l’ultimo parametro.

Corretto:

```c
double average(int n, ...);
```

Sbagliato:

```c
double average(..., int n);
```

---

# 38. Esempio corretto: media di `double`

```c
#include <stdio.h>
#include <stdarg.h>

double average(int n, ...) {
    double total = 0.0;

    va_list ap;

    va_start(ap, n);

    for (int i = 0; i < n; i++) {
        total += va_arg(ap, double);
    }

    va_end(ap);

    return total / n;
}

int main(void) {
    double w = 37.5;
    double x = 22.5;
    double y = 1.7;
    double z = 10.2;

    printf("w = %.1f x = %.1f y = %.1f z = %.1f\n", w, x, y, z);

    printf("Media di w e x = %.3f\n", average(2, w, x));
    printf("Media di w, x e y = %.3f\n", average(3, w, x, y));
    printf("Media di w, x, y e z = %.3f\n", average(4, w, x, y, z));

    return 0;
}
```

## Cosa succede

La chiamata:

```c
average(3, w, x, y)
```

passa:

- `n = 3`;
    
- poi tre valori variabili: `w`, `x`, `y`.
    

Dentro la funzione:

```c
va_start(ap, n);
```

dice:

> Gli argomenti variabili iniziano dopo `n`.

Poi:

```c
va_arg(ap, double)
```

legge ogni volta il prossimo argomento, interpretandolo come `double`.

Infine:

```c
va_end(ap);
```

chiude correttamente la gestione della lista.

---

# 39. Come fa `printf` a sapere i tipi?

`printf` usa la stringa di formato.

Esempio:

```c
printf("x = %d, y = %.2f, c = %c\n", x, y, c);
```

La stringa:

```c
"x = %d, y = %.2f, c = %c\n"
```

dice a `printf` come interpretare gli argomenti successivi:

|Specificatore|Tipo atteso|
|---|---|
|`%d`|`int`|
|`%f`|`double`|
|`%c`|`int`, poi stampato come carattere|
|`%s`|`char *`|

Quindi `printf` non “scopre” magicamente i tipi.

Li deduce dalla stringa di formato.

Se sbaglio formato, il comportamento può essere indefinito.

Esempio sbagliato:

```c
int x = 10;
printf("%f\n", x); // ERRORE: %f si aspetta un double
```

---

# 40. Errori tipici da evitare all’esame

## 1. Dimenticare `stdlib.h`

Sbagliato:

```c
int *p = malloc(sizeof(*p));
```

senza:

```c
#include <stdlib.h>
```

Corretto:

```c
#include <stdlib.h>
```

---

## 2. Non controllare `malloc`

Sbagliato:

```c
int *p = malloc(sizeof(*p));
*p = 10;
```

Corretto:

```c
int *p = malloc(sizeof(*p));

if (p == NULL) {
    return 1;
}

*p = 10;
```

---

## 3. Dimenticare `free`

Sbagliato:

```c
int *p = malloc(sizeof(*p));
*p = 10;
return 0;
```

Corretto:

```c
int *p = malloc(sizeof(*p));

if (p == NULL) {
    return 1;
}

*p = 10;

free(p);
p = NULL;
```

---

## 4. Usare memoria dopo `free`

Sbagliato:

```c
free(p);
printf("%d\n", *p);
```

Corretto:

```c
free(p);
p = NULL;
```

---

## 5. Fare `free` su un puntatore modificato

Sbagliato:

```c
int *p = malloc(sizeof(*p) * 10);

p++;

free(p);
```

Corretto:

```c
int *p = malloc(sizeof(*p) * 10);

if (p == NULL) {
    return 1;
}

// uso p[i], non modifico p

free(p);
p = NULL;
```

---

## 6. Confondere `.` e `->`

Sbagliato:

```c
Libro *p = malloc(sizeof(*p));
p.pagine = 10;
```

Corretto:

```c
p->pagine = 10;
```

Oppure:

```c
(*p).pagine = 10;
```

---

## 7. Passare una struct quando serve un puntatore

Sbagliato:

```c
Point p;
init(p);
```

se:

```c
void init(Point *p);
```

Corretto:

```c
init(&p);
```

---

## 8. Passare un puntatore quando serve una struct

Sbagliato:

```c
Point *p = malloc(sizeof(*p));
stampa(p);
```

se:

```c
void stampa(Point p);
```

Corretto:

```c
stampa(*p);
```

---

## 9. Assegnare array con `=`

Sbagliato:

```c
p->titolo = l.titolo;
```

Corretto:

```c
strcpy(p->titolo, l.titolo);
```

---

## 10. Dimenticare `stdarg.h` con funzioni variadiche

Sbagliato:

```c
double average(int n, ...) {
    va_list ap;
}
```

senza:

```c
#include <stdarg.h>
```

Corretto:

```c
#include <stdarg.h>
```

---

# 41. Mini cheat sheet

## Variabile locale normale

```c
void f(void) {
    int x = 0;
}
```

- stack;
    
- muore a fine funzione;
    
- non conserva il valore.
    

## Variabile locale `static`

```c
void f(void) {
    static int x = 0;
}
```

- memoria statica;
    
- conserva il valore;
    
- visibile solo nella funzione.
    

## Variabile globale

```c
int x = 0;
```

- memoria statica;
    
- visibile nel file da dove è dichiarata in poi;
    
- accessibile da altri file con `extern`.
    

## Variabile globale `static`

```c
static int x = 0;
```

- memoria statica;
    
- visibile solo nel file corrente.
    

## `extern`

```c
extern int x;
```

- dichiara una variabile definita altrove;
    
- non alloca memoria.
    

## Allocazione dinamica singolo valore

```c
int *p = malloc(sizeof(*p));

if (p == NULL) {
    return 1;
}

*p = 10;

free(p);
p = NULL;
```

## Allocazione dinamica array

```c
int *v = malloc(sizeof(*v) * n);

if (v == NULL) {
    return 1;
}

for (int i = 0; i < n; i++) {
    v[i] = i;
}

free(v);
v = NULL;
```

## Struct automatica

```c
Libro l;
l.pagine = 100;
```

## Struct dinamica

```c
Libro *l = malloc(sizeof(*l));

if (l == NULL) {
    return 1;
}

l->pagine = 100;

free(l);
l = NULL;
```

## Funzione variadica

```c
#include <stdarg.h>

double average(int n, ...) {
    double total = 0.0;
    va_list ap;

    va_start(ap, n);

    for (int i = 0; i < n; i++) {
        total += va_arg(ap, double);
    }

    va_end(ap);

    return total / n;
}
```

---

# 42. Domande da sapersi fare per prendere 30

## Su una variabile

Chiediti sempre:

1. Dove è dichiarata?
    
2. Vive nello stack, nell’heap o in memoria statica?
    
3. Chi la inizializza?
    
4. Chi la libera?
    
5. Quanto dura?
    
6. È una variabile o un puntatore?
    
7. Se è un puntatore, dove vive il puntatore?
    
8. Dove vive la memoria puntata?
    

---

## Su una `malloc`

Chiediti:

1. Sto allocando il numero giusto di byte?
    
2. Ho usato `sizeof(*p)`?
    
3. Ho controllato se il risultato è `NULL`?
    
4. Ho conservato il puntatore originale?
    
5. Ho fatto `free`?
    
6. Ho messo il puntatore a `NULL` dopo `free`?
    
7. Sto evitando di usare il puntatore dopo `free`?
    

---

## Su array e puntatori

Chiediti:

1. È un array vero o un puntatore?
    
2. Posso fare `v + 1`?
    
3. Posso fare `v++`?
    
4. Sto passando l’array a una funzione?
    
5. La funzione può modificarne gli elementi?
    
6. Sto usando correttamente `sizeof`?
    

---

## Su struct

Chiediti:

1. Ho una struct o un puntatore a struct?
    
2. Devo usare `.` o `->`?
    
3. La funzione deve modificare la struct?
    
4. Se sì, sto passando l’indirizzo?
    
5. Se no, posso passare una copia?
    
6. Se nella struct ci sono array/stringhe, sto usando `strcpy` invece di `=`?
    

---

# 43. Esercizi da riscrivere per prendere confidenza

## Esercizio 1: contatore con `static`

Scrivi una funzione:

```c
int nextNumber(void);
```

che restituisce 1 alla prima chiamata, 2 alla seconda, 3 alla terza, ecc.

---

## Esercizio 2: array dinamico

Scrivi un programma che:

1. chiede all’utente quanti interi vuole inserire;
    
2. alloca dinamicamente un array di quella dimensione;
    
3. legge gli interi;
    
4. stampa somma e media;
    
5. libera la memoria.
    

---

## Esercizio 3: struct dinamica

Scrivi un programma che:

1. definisce una struct `Studente`;
    
2. contiene nome, matricola, media;
    
3. alloca dinamicamente uno studente;
    
4. legge i dati;
    
5. stampa i dati;
    
6. libera la memoria.
    

---

## Esercizio 4: array dinamico di struct

Scrivi un programma che:

1. definisce una struct `Canzone`;
    
2. alloca dinamicamente un array di canzoni;
    
3. legge i dati;
    
4. stampa la playlist;
    
5. libera la memoria.
    

---

## Esercizio 5: funzione variadica

Scrivi una funzione:

```c
int somma(int n, ...);
```

che riceve `n` interi e restituisce la loro somma.

Esempio:

```c
printf("%d\n", somma(3, 10, 20, 30));
```

Output:

```text
60
```

---

# 44. Esercizio bonus: `somma` variadica

Soluzione:

```c
#include <stdio.h>
#include <stdarg.h>

int somma(int n, ...) {
    int totale = 0;

    va_list ap;
    va_start(ap, n);

    for (int i = 0; i < n; i++) {
        totale += va_arg(ap, int);
    }

    va_end(ap);

    return totale;
}

int main(void) {
    printf("%d\n", somma(3, 10, 20, 30));
    printf("%d\n", somma(5, 1, 2, 3, 4, 5));

    return 0;
}
```

Output:

```text
60
15
```

---

# 45. Frase finale da ricordare

In C non basta sapere “che valore ha una variabile”.

Bisogna sapere anche:

- dove si trova;
    
- quanto vive;
    
- chi la gestisce;
    
- se è un valore o un indirizzo;
    
- se va liberata manualmente;
    
- se la funzione riceve una copia o può modificare l’originale.
    

La memoria dinamica è potente perché permette di decidere a runtime quanta memoria usare, ma richiede disciplina: ogni allocazione deve essere controllata, usata correttamente e liberata.