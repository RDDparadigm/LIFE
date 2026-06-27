
## Obiettivo della lezione

Questa lezione usa l’esempio dei **numeri complessi** per introdurre un tema molto importante della programmazione in C:

> Come progettare un tipo di dato in modo che sia comodo da usare, ben incapsulato, poco accoppiato con il resto del programma e possibilmente efficiente.

L’argomento centrale non è soltanto “come rappresentare un numero complesso”, ma soprattutto **come progettare un modulo in C**.

I concetti chiave sono:

- numeri complessi;
    
- `struct`;
    
- tipo di dato trasparente;
    
- tipo di dato opaco;
    
- ADT, cioè Abstract Data Type;
    
- modulo;
    
- signature;
    
- accoppiamento;
    
- coesione;
    
- uso di file `.h` e `.c`;
    
- memoria dinamica;
    
- `malloc` e `free`;
    
- `static`;
    
- passaggio per valore;
    
- passaggio per riferimento;
    
- uso di `const`;
    
- efficienza e compromessi progettuali.
    

---

# 1. Numeri complessi

Un numero complesso ha la forma:

```text
z = a + i * b
```

dove:

- `a` è la parte reale;
    
- `b` è la parte immaginaria;
    
- `i` è l’unità immaginaria;
    
- `i^2 = -1`.
    

Un numero complesso può essere rappresentato in due modi principali.

## 1.1 Rappresentazione cartesiana

La rappresentazione cartesiana usa direttamente:

```text
z = a + i * b
```

Quindi il numero complesso è rappresentato da:

```c
double re;
double im;
```

dove:

- `re` è la parte reale;
    
- `im` è la parte immaginaria.
    

Esempio:

```text
3 + 4i
```

può essere rappresentato come:

```c
re = 3.0
im = 4.0
```

## 1.2 Rappresentazione polare

La rappresentazione polare usa:

```text
z = r, φ
```

dove:

- `r` è il modulo;
    
- `φ` è l’argomento, cioè l’angolo.
    

Il modulo si calcola così:

```text
r = sqrt(a^2 + b^2)
```

L’argomento si può calcolare con:

```c
atan2(im, re)
```

In C, `atan2` è preferibile rispetto ad `atan(im / re)` perché gestisce correttamente anche i quadranti e i casi particolari.

---

# 2. Operazioni sui numeri complessi

Supponiamo di voler realizzare un modulo che gestisce numeri complessi.

Le operazioni principali sono:

```c
sum
product
modulus
argument
equal
```

## 2.1 Somma

Dati:

```text
z1 = a1 + i b1
z2 = a2 + i b2
```

la somma è:

```text
z1 + z2 = (a1 + a2) + i(b1 + b2)
```

In C:

```c
c.re = c1.re + c2.re;
c.im = c1.im + c2.im;
```

## 2.2 Prodotto

Dati:

```text
z1 = a1 + i b1
z2 = a2 + i b2
```

il prodotto è:

```text
z1 * z2 = (a1a2 - b1b2) + i(a1b2 + b1a2)
```

In C:

```c
c.re = (c1.re * c2.re) - (c1.im * c2.im);
c.im = (c1.re * c2.im) + (c1.im * c2.re);
```

> [!warning]  
> Questa formula va saputa bene.  
> È facile sbagliare i segni nel prodotto.

## 2.3 Modulo

```text
|z| = sqrt(re^2 + im^2)
```

In C:

```c
double modulus(Dcomplex c) {
    return sqrt((c.re * c.re) + (c.im * c.im));
}
```

Serve includere:

```c
#include <math.h>
```

e, in fase di compilazione, spesso serve linkare la libreria matematica con `-lm`:

```bash
gcc main.c dcomplex.c -lm -o app
```

## 2.4 Argomento

L’argomento è l’angolo del numero complesso nel piano.

In C:

```c
double argument(Dcomplex c) {
    return atan2(c.im, c.re);
}
```

## 2.5 Uguaglianza con epsilon

Con i `double` non è buona pratica confrontare direttamente con `==`.

Per esempio:

```c
0.1 + 0.2 == 0.3
```

può non essere vero a causa degli errori di rappresentazione dei floating point.

Per questo si usa una tolleranza `epsilon`.

```c
_Bool equal(Dcomplex c1, Dcomplex c2, double epsilon) {
    return fabs(c1.re - c2.re) <= epsilon &&
           fabs(c1.im - c2.im) <= epsilon;
}
```

Meglio usare `fabs` da `<math.h>` invece di una macro fatta a mano.

---

# 3. Prima soluzione: tipo di dato trasparente

Una prima soluzione consiste nel definire il numero complesso come una `struct` visibile nel file `.h`.

## dcomplex.h

```c
#ifndef DCOMPLEX_H
#define DCOMPLEX_H

typedef struct {
    double re;
    double im;
} Dcomplex;

Dcomplex sum(Dcomplex c1, Dcomplex c2);
Dcomplex product(Dcomplex c1, Dcomplex c2);
double modulus(Dcomplex c);
double argument(Dcomplex c);
_Bool equal(Dcomplex c1, Dcomplex c2, double epsilon);

#endif
```

Questa soluzione è detta **trasparente** perché chi include `dcomplex.h` vede com’è fatta internamente la `struct`.

Quindi il codice client può fare:

```c
Dcomplex c;
c.re = 3.0;
c.im = 4.0;
```

Questo sembra comodo, ma introduce un problema importante.

---

# 4. Problema del tipo trasparente

Se il codice client può accedere direttamente ai campi:

```c
c.re
c.im
```

allora il codice client dipende dalla rappresentazione interna del dato.

Questo significa che se un giorno decidiamo di cambiare la rappresentazione interna da cartesiana:

```c
typedef struct {
    double re;
    double im;
} Dcomplex;
```

a polare:

```c
typedef struct {
    double modulus;
    double argument;
} Dcomplex;
```

allora tutto il codice client che usa `c.re` e `c.im` si rompe.

Esempio:

```c
printf("%f\n", c.re);
```

non compila più, perché nella nuova rappresentazione non esiste più il campo `re`.

Il problema non è tecnico, ma progettuale:

> Il modulo che usa i numeri complessi conosce troppi dettagli interni del modulo che li implementa.

Questo genera ==**accoppiamento forte**==.

---

# 5. Modulo, signature, accoppiamento e coesione

## 5.1 Modulo

Un **modulo** è un’unità di codice che può essere compilata separatamente.

In C, di solito un modulo corrisponde a un file `.c`.

Esempio:

```text
dcomplex.c
```

contiene l’implementazione delle funzioni sui numeri complessi.

## 5.2 Signature

La **signature** di un modulo è la parte visibile dall’esterno.

In C, di solito corrisponde al file `.h`.

Esempio:

```text
dcomplex.h
```

dichiara il tipo e le funzioni disponibili.

Il file `.h` dice agli altri file:

> Queste sono le cose che potete usare.

Il file `.c` invece contiene:

> Come queste cose sono implementate.

## 5.3 Accoppiamento

L’**accoppiamento** misura quanto due moduli dipendono l’uno dall’altro.

Un accoppiamento alto è negativo perché:

- rende difficile modificare il codice;
    
- rende il sistema fragile;
    
- costringe a ricompilare o riscrivere molti file;
    
- aumenta la possibilità di introdurre bug.
    

Esempio di accoppiamento alto:

```c
printf("%f\n", c.re);
```

Il codice client conosce il campo interno `re`.

Se cambia la rappresentazione interna, il client va modificato.

## 5.4 Coesione

La **coesione** misura quanto le funzioni di un modulo sono ==legate a un unico concetto==.

Un modulo ha alta coesione se tutte le sue funzioni ruotano attorno allo stesso concetto.

Nel nostro caso, un modulo `dcomplex` è coeso se contiene funzioni come:

```c
sum
product
modulus
argument
equal
```

perché tutte riguardano i numeri complessi.

La coesione peggiora se aggiungiamo funzioni che non riguardano direttamente il concetto principale.

Per esempio:

```c
void printDcomplex(Dcomplex c);
```

Questa funzione mescola il concetto di numero complesso con il concetto di stampa su schermo.

Meglio evitare, oppure separare in un modulo diverso.

---

# 6. Obiettivo progettuale

In generale, un buon progetto dovrebbe avere:

```text
basso accoppiamento
alta coesione
```

Cioè:

- ogni modulo deve avere una responsabilità chiara;
    
- i moduli devono conoscere il meno possibile dei dettagli interni degli altri moduli;
    
- l’interfaccia pubblica deve essere stabile;
    
- l’implementazione deve poter cambiare senza rompere il codice client.
    

---

# 7. Tipo di dato opaco

Per ridurre l’accoppiamento possiamo usare un **tipo di dato opaco**.

Un tipo opaco è un tipo di cui il client conosce l’esistenza, ma non conosce la struttura interna.

In C si può ottenere dichiarando nel file `.h` solo un ==puntatore a una== `struct` ==non definita==.

## ADTcomplexOps.h

```c
#ifndef ADTCOMPLEXOPS_H
#define ADTCOMPLEXOPS_H

typedef struct dcomplex *ADTcomplex;

ADTcomplex mkADTcomplex(double re, double im);
void dsADTcomplex(ADTcomplex *pc);

ADTcomplex sum(ADTcomplex c1, ADTcomplex c2);
ADTcomplex product(ADTcomplex c1, ADTcomplex c2);

double modulus(ADTcomplex c);
double argument(ADTcomplex c);
double re(ADTcomplex c);
double im(ADTcomplex c);

_Bool equal(ADTcomplex c1, ADTcomplex c2, double epsilon);

#endif
```

Qui il client sa che `ADTcomplex` è un puntatore a `struct dcomplex`, ma non sa com’è fatta `struct dcomplex`.

Quindi può dichiarare variabili:

```c
ADTcomplex c;
```

ma non può fare:

```c
c->re = 3.0;
```

perché il campo `re` non è visibile.

---

# 8. Implementazione con struct opaca

Nel file `.c`, invece, la `struct` viene definita davvero.

## ADTcomplexCartesian.c

```c
#include <stdlib.h>
#include <math.h>
#include "ADTcomplexOps.h"

struct dcomplex {
    double re;
    double im;
};

ADTcomplex mkADTcomplex(double re, double im) {
    ADTcomplex c = malloc(sizeof(struct dcomplex));

    if (c == NULL) {
        return NULL;
    }

    c->re = re;
    c->im = im;

    return c;
}

void dsADTcomplex(ADTcomplex *pc) {
    if (pc != NULL && *pc != NULL) {
        free(*pc);
        *pc = NULL;
    }
}

ADTcomplex sum(ADTcomplex c1, ADTcomplex c2) {
    return mkADTcomplex(c1->re + c2->re,
                        c1->im + c2->im);
}

ADTcomplex product(ADTcomplex c1, ADTcomplex c2) {
    return mkADTcomplex((c1->re * c2->re) - (c1->im * c2->im),
                        (c1->re * c2->im) + (c1->im * c2->re));
}

double modulus(ADTcomplex c) {
    return sqrt((c->re * c->re) + (c->im * c->im));
}

double argument(ADTcomplex c) {
    return atan2(c->im, c->re);
}

double re(ADTcomplex c) {
    return c->re;
}

double im(ADTcomplex c) {
    return c->im;
}

_Bool equal(ADTcomplex c1, ADTcomplex c2, double epsilon) {
    return fabs(c1->re - c2->re) <= epsilon &&
           fabs(c1->im - c2->im) <= epsilon;
}
```

Il client non conosce i campi `re` e `im`.

Può solo usare le funzioni pubbliche.

Esempio:

```c
ADTcomplex c = mkADTcomplex(3.0, 4.0);

printf("Parte reale: %f\n", re(c));
printf("Parte immaginaria: %f\n", im(c));

dsADTcomplex(&c);
```

---

# 9. Vantaggio del tipo opaco

Il vantaggio principale è che si può cambiare implementazione senza cambiare il codice client.

Per esempio, possiamo sostituire l’implementazione cartesiana con una polare.

## ADTcomplexPolar.c

```c
#include <stdlib.h>
#include <math.h>
#include "ADTcomplexOps.h"

struct dcomplex {
    double modulus;
    double argument;
};

ADTcomplex mkADTcomplex(double re, double im) {
    ADTcomplex c = malloc(sizeof(struct dcomplex));

    if (c == NULL) {
        return NULL;
    }

    c->modulus = sqrt((re * re) + (im * im));
    c->argument = atan2(im, re);

    return c;
}

void dsADTcomplex(ADTcomplex *pc) {
    if (pc != NULL && *pc != NULL) {
        free(*pc);
        *pc = NULL;
    }
}

double modulus(ADTcomplex c) {
    return c->modulus;
}

double argument(ADTcomplex c) {
    return c->argument;
}

double re(ADTcomplex c) {
    return c->modulus * cos(c->argument);
}

double im(ADTcomplex c) {
    return c->modulus * sin(c->argument);
}

ADTcomplex sum(ADTcomplex c1, ADTcomplex c2) {
    return mkADTcomplex(re(c1) + re(c2),
                        im(c1) + im(c2));
}

ADTcomplex product(ADTcomplex c1, ADTcomplex c2) {
    ADTcomplex c = malloc(sizeof(struct dcomplex));

    if (c == NULL) {
        return NULL;
    }

    c->modulus = c1->modulus * c2->modulus;
    c->argument = c1->argument + c2->argument;

    return c;
}

_Bool equal(ADTcomplex c1, ADTcomplex c2, double epsilon) {
    return fabs(re(c1) - re(c2)) <= epsilon &&
           fabs(im(c1) - im(c2)) <= epsilon;
}
```

Il codice client continua a usare:

```c
re(c)
im(c)
modulus(c)
argument(c)
```

e non deve sapere se internamente il numero complesso è memorizzato come:

```c
re, im
```

oppure come:

```c
modulus, argument
```

Questo è il cuore del tipo opaco.

---

# 10. Compilazione separata e linking

Supponiamo di avere questi file:

```text
app_v2.c
ADTcomplexOps.h
ADTcomplexCartesian.c
ADTcomplexPolar.c
```

Possiamo compilare separatamente il client:

```bash
gcc -c app_v2.c
```

Poi compilare l’implementazione cartesiana:

```bash
gcc -c ADTcomplexCartesian.c
```

E linkare:

```bash
gcc -o app app_v2.o ADTcomplexCartesian.o -lm
```

Se poi vogliamo passare all’implementazione polare:

```bash
gcc -c ADTcomplexPolar.c
gcc -o app app_v2.o ADTcomplexPolar.o -lm
```

Il punto importante è questo:

> Con il tipo opaco posso cambiare il file `.o` dell’implementazione senza modificare il codice sorgente del client.

Il client dipende solo dalla signature, cioè dal file `.h`.

---

# 11. Svantaggi del tipo opaco

Il tipo opaco è elegante, ma ha un prezzo.

## 11.1 Serve memoria dinamica

Ogni numero complesso viene allocato con:

```c
malloc
```

e deve essere liberato con:

```c
free
```

Quindi il programmatore deve ricordarsi di chiamare:

```c
dsADTcomplex(&c);
```

quando il numero complesso non serve più.

Se se ne dimentica, si ha un **memory leak**.

## 11.2 Rischio di aliasing

Esempio:

```c
ADTcomplex c1 = mkADTcomplex(3.0, 4.0);
ADTcomplex c2 = c1;
```

Ora `c1` e `c2` puntano allo stesso blocco di memoria.

Se faccio:

```c
dsADTcomplex(&c1);
```

allora `c1` diventa `NULL`, ma `c2` contiene ancora l’indirizzo della memoria liberata.

Se uso `c2`, ho comportamento indefinito:

```c
printf("%f\n", re(c2)); // ERRORE: uso memoria già liberata
```

Questo è un classico caso di **dangling pointer**.

## 11.3 `malloc` e `free` hanno un costo

Le operazioni di allocazione e deallocazione dinamica sono più lente rispetto all’uso di variabili automatiche sullo stack.

Per un tipo piccolo come un numero complesso, allocare tutto sullo heap può essere eccessivo.

---

# 12. Compromesso: interfaccia agnostica rispetto alla rappresentazione

Per evitare alcuni svantaggi del tipo opaco, le slide propongono un compromesso.

L’idea è separare:

- la rappresentazione del tipo;
    
- le funzioni da usare per manipolare il tipo.
    

Si usano due file:

```text
dcomplexRep.h
dcomplexAgn.h
```

## 12.1 dcomplexRep.h

Questo file contiene la rappresentazione.

```c
#ifndef DCOMPLEXREP_H
#define DCOMPLEXREP_H

typedef struct {
    double re;
    double im;
} Dcomplex;

#endif
```

## 12.2 dcomplexAgn.h

Questo file contiene le funzioni da usare.

```c
#ifndef DCOMPLEXAGN_H
#define DCOMPLEXAGN_H

#include "dcomplexRep.h"

Dcomplex mkDcomplexCar(double re, double im);
Dcomplex mkDcomplexPol(double modulus, double argument);

Dcomplex sum(Dcomplex c1, Dcomplex c2);
Dcomplex product(Dcomplex c1, Dcomplex c2);

double modulus(Dcomplex c);
double argument(Dcomplex c);
double re(Dcomplex c);
double im(Dcomplex c);

_Bool equal(Dcomplex c1, Dcomplex c2, double epsilon);

#endif
```

La `struct` è visibile, quindi tecnicamente il client potrebbe fare:

```c
c.re
```

ma la regola progettuale è:

> Il codice client non deve accedere direttamente ai campi della struct.

Il client deve usare solo:

```c
re(c)
im(c)
modulus(c)
argument(c)
```

Questa è una soluzione “agnostica” perché il client, ==pur vedendo la rappresentazione==, non dovrebbe dipendere da essa.

---

# 13. Differenza tra tipo opaco e soluzione agnostica

## Tipo opaco vero

Nel tipo opaco:

```c
typedef struct dcomplex *ADTcomplex;
```

il client non può proprio accedere ai campi.

Quindi l’incapsulamento è garantito dal compilatore.

## Soluzione agnostica

Nella soluzione agnostica:

```c
typedef struct {
    double re;
    double im;
} Dcomplex;
```

il client potrebbe accedere ai campi, ma per disciplina non dovrebbe farlo.

Quindi l’incapsulamento è garantito dalla convenzione, non dal compilatore.

## Confronto

|Soluzione|Vantaggi|Svantaggi|
|---|---|---|
|Tipo trasparente|semplice, efficiente|accoppiamento alto|
|Tipo opaco|accoppiamento basso, incapsulamento forte|usa heap, serve gestire memoria|
|Soluzione agnostica|efficiente, niente heap obbligatorio|incapsulamento più debole|

---

# 14. Uso di `static`

Nelle slide compare una funzione ausiliaria:

```c
static double dabs(double x) {
    return (x > 0) ? x : -x;
}
```

Il significato di `static` davanti a una funzione globale è:

> La funzione è visibile solo dentro quel file `.c`.

Questa cosa si chiama **internal linkage**.

Senza `static`, una funzione globale è normalmente visibile anche da altri file in fase di linking.

Con `static`, invece, la funzione è privata del modulo.

## Perché è utile?

Perché `dabs` è una funzione di supporto interna.

Non fa parte dell’interfaccia pubblica del modulo.

Quindi non deve comparire nel `.h`.

Non vogliamo che altri file la usino.

Non vogliamo rischiare conflitti con altre funzioni chiamate `dabs` in altri file.

Quindi scrivere:

```c
static double dabs(double x)
```

è una buona scelta.

> [!important]  
> Le funzioni che fanno parte dell’API pubblica vanno nel `.h`.  
> Le funzioni di supporto interne al modulo vanno nel `.c` e, se possibile, vanno dichiarate `static`.

---

# 15. Macro vs funzione

Nelle slide compare anche una macro:

```c
#define ABS(x) ((x) > 0) ? (x) : -(x)
```

Le macro possono essere pericolose.

Una versione più sicura sarebbe almeno:

```c
#define ABS(x) (((x) > 0) ? (x) : -(x))
```

Però in questo caso è ancora meglio usare una funzione:

```c
static double dabs(double x) {
    return (x > 0) ? x : -x;
}
```

oppure direttamente:

```c
#include <math.h>

fabs(x)
```

## Perché le macro sono delicate?

Perché sono ==sostituzioni testuali fatte dal preprocessore==.

Esempio pericoloso:

```c
ABS(i++)
```

può incrementare `i` più di una volta, perché `x` compare più volte nella macro.

Le funzioni evitano questo problema.

---

# 16. Efficienza: passaggio per valore

Nella soluzione agnostica iniziale, le funzioni ricevono strutture per valore.

Esempio:

```c
Dcomplex sum(Dcomplex c1, Dcomplex c2);
```

Questo significa che quando chiamo:

```c
Dcomplex c3 = sum(c1, c2);
```

i valori di `c1` e `c2` vengono copiati.

Per una struct piccola, come:

```c
typedef struct {
    double re;
    double im;
} Dcomplex;
```

il costo è basso.

Ma se la struct fosse molto grande, copiare tutta la struct ogni volta potrebbe diventare inefficiente.

---

# 17. Passaggio per riferimento

Per evitare copie grandi, possiamo passare puntatori.

Esempio:

```c
Dcomplex sum(const Dcomplex *const pc1,
             const Dcomplex *const pc2);
```

Questa funzione riceve gli indirizzi dei due numeri complessi invece di copiarli.

La chiamata diventa:

```c
Dcomplex c3 = sum(&c1, &c2);
```

## Spiegazione di `const Dcomplex *const pc1`

Questa dichiarazione contiene due `const`.

```c
const Dcomplex *const pc1
```

Si legge così:

- `pc1` è un puntatore costante;
    
- punta a un `Dcomplex` costante.
    

Quindi dentro la funzione:

```c
pc1 = altro_indirizzo;   // vietato
pc1->re = 10.0;          // vietato
```

Il primo `const` protegge il dato puntato.

Il secondo `const` protegge il puntatore stesso.

In pratica, la funzione promette:

> Non modificherò né il puntatore né il numero complesso puntato.

---

# 18. Versione ottimizzata con parametri per riferimento

## dcomplexAgnOpt.h

```c
#ifndef DCOMPLEXAGNOPT_H
#define DCOMPLEXAGNOPT_H

#include "dcomplexRep.h"

Dcomplex mkDcomplexCar(double re, double im);
Dcomplex mkDcomplexPol(double modulus, double argument);

Dcomplex sum(const Dcomplex *const pc1,
             const Dcomplex *const pc2);

Dcomplex product(const Dcomplex *const pc1,
                 const Dcomplex *const pc2);

double modulus(const Dcomplex *const pc);
double argument(const Dcomplex *const pc);
double re(const Dcomplex *const pc);
double im(const Dcomplex *const pc);

_Bool equal(const Dcomplex *const pc1,
            const Dcomplex *const pc2,
            double epsilon);

#endif
```

## dcomplexCarOpt.c

```c
#include <math.h>
#include "dcomplexAgnOpt.h"

Dcomplex mkDcomplexCar(double re, double im) {
    Dcomplex c;
    c.re = re;
    c.im = im;
    return c;
}

Dcomplex mkDcomplexPol(double modulus, double argument) {
    return mkDcomplexCar(modulus * cos(argument),
                         modulus * sin(argument));
}

Dcomplex sum(const Dcomplex *const pc1,
             const Dcomplex *const pc2) {
    return mkDcomplexCar(pc1->re + pc2->re,
                         pc1->im + pc2->im);
}

Dcomplex product(const Dcomplex *const pc1,
                 const Dcomplex *const pc2) {
    return mkDcomplexCar((pc1->re * pc2->re) - (pc1->im * pc2->im),
                         (pc1->re * pc2->im) + (pc1->im * pc2->re));
}

double modulus(const Dcomplex *const pc) {
    return sqrt((pc->re * pc->re) + (pc->im * pc->im));
}

double argument(const Dcomplex *const pc) {
    return atan2(pc->im, pc->re);
}

double re(const Dcomplex *const pc) {
    return pc->re;
}

double im(const Dcomplex *const pc) {
    return pc->im;
}

_Bool equal(const Dcomplex *const pc1,
            const Dcomplex *const pc2,
            double epsilon) {
    return fabs(pc1->re - pc2->re) <= epsilon &&
           fabs(pc1->im - pc2->im) <= epsilon;
}
```

---

# 19. Efficienza: ritorno per valore

Anche se passiamo i parametri per riferimento, alcune funzioni restituiscono ancora una struct per valore.

Esempio:

```c
Dcomplex sum(const Dcomplex *const pc1,
             const Dcomplex *const pc2);
```

La funzione crea un `Dcomplex` e lo restituisce.

Per struct piccole va bene.

Per struct grandi può essere costoso.

Per ottimizzare ulteriormente, possiamo passare alla funzione anche il puntatore alla variabile in cui salvare il risultato.

---

# 20. Funzioni che modificano direttamente un risultato in memoria

Si aggiungono funzioni come:

```c
void initDcomplexCar(Dcomplex *pc, double re, double im);
void initDcomplexPol(Dcomplex *pc, double modulus, double argument);

void sum3(Dcomplex *pc,
          const Dcomplex *const pc1,
          const Dcomplex *const pc2);

void product3(Dcomplex *pc,
              const Dcomplex *const pc1,
              const Dcomplex *const pc2);
```

Qui `pc` è il puntatore al risultato.

Esempio d’uso:

```c
Dcomplex c1;
Dcomplex c2;
Dcomplex result;

initDcomplexCar(&c1, 3.0, 4.0);
initDcomplexCar(&c2, 1.0, 2.0);

sum3(&result, &c1, &c2);
```

Invece di fare:

```c
result = sum(&c1, &c2);
```

modifichiamo direttamente `result`.

## Implementazione

```c
void initDcomplexCar(Dcomplex *pc, double re, double im) {
    pc->re = re;
    pc->im = im;
}

void initDcomplexPol(Dcomplex *pc, double modulus, double argument) {
    pc->re = modulus * cos(argument);
    pc->im = modulus * sin(argument);
}

void sum3(Dcomplex *pc,
          const Dcomplex *const pc1,
          const Dcomplex *const pc2) {
    pc->re = pc1->re + pc2->re;
    pc->im = pc1->im + pc2->im;
}

void product3(Dcomplex *pc,
              const Dcomplex *const pc1,
              const Dcomplex *const pc2) {
    pc->re = (pc1->re * pc2->re) - (pc1->im * pc2->im);
    pc->im = (pc1->re * pc2->im) + (pc1->im * pc2->re);
}
```

Questa tecnica è molto usata in C quando si vuole evitare di restituire grandi strutture per valore.

---

# 21. Perché non eliminare le funzioni comode?

Anche se introduciamo funzioni più efficienti come:

```c
sum3
product3
initDcomplexCar
initDcomplexPol
```

può avere senso mantenere anche funzioni come:

```c
mkDcomplexCar
mkDcomplexPol
sum
product
```

Perché sono più comode in alcuni casi.

Esempio:

```c
Dcomplex c = mkDcomplexCar(3.0, 4.0);
```

è più leggibile di:

```c
Dcomplex c;
initDcomplexCar(&c, 3.0, 4.0);
```

Oppure, per espressioni brevi, può essere comodo scrivere:

```c
Dcomplex c = sum(&x, &y);
```

Il punto è che in C spesso bisogna bilanciare:

```text
leggibilità
semplicità
sicurezza
efficienza
```

Non esiste sempre una soluzione migliore in assoluto.

---

# 22. Inlining del compilatore

Le slide fanno notare che i moderni compilatori possono ottimizzare funzioni piccole facendo **inlining**.

Inlining significa che il compilatore sostituisce la chiamata di funzione con il corpo della funzione.

Per esempio, una funzione piccola come:

```c
double re(const Dcomplex *const pc) {
    return pc->re;
}
```

può essere trasformata dal compilatore direttamente in un accesso al campo.

Quindi il programmatore non deve sempre sostituire tutto con macro per “ottimizzare”.

Spesso è meglio scrivere codice chiaro e lasciare al compilatore le ottimizzazioni semplici.

---

# 23. TDD: Test Driven Development

Le slide citano anche la metodologia TDD.

TDD significa:

```text
Test Driven Development
```

L’idea è:

1. scrivo prima i test;
    
2. implemento una funzione;
    
3. compilo ed eseguo i test;
    
4. correggo;
    
5. ripeto finché tutti i test passano.
    

Nel caso dei numeri complessi, una test suite dovrebbe verificare:

- costruzione da coordinate cartesiane;
    
- costruzione da coordinate polari;
    
- somma;
    
- prodotto;
    
- modulo;
    
- argomento;
    
- parte reale;
    
- parte immaginaria;
    
- uguaglianza con epsilon;
    
- casi limite.
    

---

# 24. Esempio di test minimale

```c
#include <stdio.h>
#include <math.h>
#include "dcomplexAgnOpt.h"

#define EPS 1e-9

int main(void) {
    Dcomplex c1 = mkDcomplexCar(3.0, 4.0);
    Dcomplex c2 = mkDcomplexCar(1.0, 2.0);

    Dcomplex s = sum(&c1, &c2);

    if (!equal(&s, &(Dcomplex){4.0, 6.0}, EPS)) {
        printf("Test somma fallito\n");
        return 1;
    }

    Dcomplex p = product(&c1, &c2);

    if (fabs(re(&p) - (-5.0)) > EPS ||
        fabs(im(&p) - 10.0) > EPS) {
        printf("Test prodotto fallito\n");
        return 1;
    }

    if (fabs(modulus(&c1) - 5.0) > EPS) {
        printf("Test modulo fallito\n");
        return 1;
    }

    printf("Tutti i test superati\n");
    return 0;
}
```

Nota importante:

```c
&(Dcomplex){4.0, 6.0}
```

è un compound literal: crea temporaneamente una struct `Dcomplex` e ne prende l’indirizzo.

È comodo nei test, ma va usato sapendo cosa si sta facendo.

---

# 25. Esercizio fondamentale da riscrivere

Per prendere confidenza con questi concetti, conviene riscrivere a mano un mini-progetto con questa struttura:

```text
complex_project/
├── main.c
├── dcomplexRep.h
├── dcomplexAgnOpt.h
├── dcomplexCarOpt.c
└── test.c
```

## dcomplexRep.h

```c
#ifndef DCOMPLEXREP_H
#define DCOMPLEXREP_H

typedef struct {
    double re;
    double im;
} Dcomplex;

#endif
```

## dcomplexAgnOpt.h

```c
#ifndef DCOMPLEXAGNOPT_H
#define DCOMPLEXAGNOPT_H

#include "dcomplexRep.h"

Dcomplex mkDcomplexCar(double re, double im);
Dcomplex mkDcomplexPol(double modulus, double argument);

Dcomplex sum(const Dcomplex *const pc1,
             const Dcomplex *const pc2);

Dcomplex product(const Dcomplex *const pc1,
                 const Dcomplex *const pc2);

double modulus(const Dcomplex *const pc);
double argument(const Dcomplex *const pc);
double re(const Dcomplex *const pc);
double im(const Dcomplex *const pc);

_Bool equal(const Dcomplex *const pc1,
            const Dcomplex *const pc2,
            double epsilon);

#endif
```

## dcomplexCarOpt.c

```c
#include <math.h>
#include "dcomplexAgnOpt.h"

Dcomplex mkDcomplexCar(double re, double im) {
    Dcomplex c;
    c.re = re;
    c.im = im;
    return c;
}

Dcomplex mkDcomplexPol(double modulus, double argument) {
    return mkDcomplexCar(modulus * cos(argument),
                         modulus * sin(argument));
}

Dcomplex sum(const Dcomplex *const pc1,
             const Dcomplex *const pc2) {
    return mkDcomplexCar(pc1->re + pc2->re,
                         pc1->im + pc2->im);
}

Dcomplex product(const Dcomplex *const pc1,
                 const Dcomplex *const pc2) {
    return mkDcomplexCar((pc1->re * pc2->re) - (pc1->im * pc2->im),
                         (pc1->re * pc2->im) + (pc1->im * pc2->re));
}

double modulus(const Dcomplex *const pc) {
    return sqrt((pc->re * pc->re) + (pc->im * pc->im));
}

double argument(const Dcomplex *const pc) {
    return atan2(pc->im, pc->re);
}

double re(const Dcomplex *const pc) {
    return pc->re;
}

double im(const Dcomplex *const pc) {
    return pc->im;
}

_Bool equal(const Dcomplex *const pc1,
            const Dcomplex *const pc2,
            double epsilon) {
    return fabs(pc1->re - pc2->re) <= epsilon &&
           fabs(pc1->im - pc2->im) <= epsilon;
}
```

## main.c

```c
#include <stdio.h>
#include "dcomplexAgnOpt.h"

int main(void) {
    Dcomplex c1 = mkDcomplexCar(3.0, 4.0);
    Dcomplex c2 = mkDcomplexCar(1.0, 2.0);

    Dcomplex s = sum(&c1, &c2);
    Dcomplex p = product(&c1, &c2);

    printf("c1 = %f + %fi\n", re(&c1), im(&c1));
    printf("c2 = %f + %fi\n", re(&c2), im(&c2));

    printf("somma = %f + %fi\n", re(&s), im(&s));
    printf("prodotto = %f + %fi\n", re(&p), im(&p));

    printf("modulo c1 = %f\n", modulus(&c1));
    printf("argomento c1 = %f\n", argument(&c1));

    return 0;
}
```

Compilazione:

```bash
gcc -Wall -Wextra -pedantic main.c dcomplexCarOpt.c -lm -o app
```

Esecuzione:

```bash
./app
```

---

# 26. Domande da saper rispondere all’esame

## Che cos’è un tipo di dato trasparente?

È un tipo la cui rappresentazione interna è visibile al codice client.

Esempio:

```c
typedef struct {
    double re;
    double im;
} Dcomplex;
```

Il client può accedere direttamente a:

```c
c.re
c.im
```

## Che cos’è un tipo di dato opaco?

È un tipo la cui rappresentazione interna è nascosta al codice client.

Esempio:

```c
typedef struct dcomplex *ADTcomplex;
```

Il client sa che esiste un tipo `ADTcomplex`, ma non sa com’è fatta la `struct dcomplex`.

## Perché il tipo opaco riduce l’accoppiamento?

Perché il client non dipende dalla rappresentazione interna.

Se cambio la struct da cartesiana a polare, il client non deve essere modificato.

## Qual è il prezzo da pagare con il tipo opaco?

Di solito:

- serve memoria dinamica;
    
- bisogna usare `malloc`;
    
- bisogna usare `free`;
    
- aumenta il rischio di memory leak;
    
- aumenta il rischio di dangling pointer;
    
- `malloc` e `free` hanno un costo.
    

## Che cos’è la signature di un modulo?

È la parte pubblica del modulo.

In C, di solito è il file `.h`.

## Che cos’è un modulo?

È un’unità compilabile separatamente.

In C, di solito è un file `.c`.

## Che cosa significa alta coesione?

Significa che tutte le funzioni di un modulo sono legate allo stesso concetto.

## Che cosa significa basso accoppiamento?

Significa che un modulo dipende poco dai dettagli interni degli altri moduli.

## Perché usare `static` davanti a una funzione in un `.c`?

Per renderla privata a quel file.

Esempio:

```c
static double dabs(double x);
```

Così la funzione non è visibile agli altri moduli e non crea conflitti in fase di linking.

## Perché usare `const` nei parametri puntatore?

Per comunicare e garantire che la funzione non modificherà il dato puntato.

Esempio:

```c
double modulus(const Dcomplex *const pc);
```

## Quando conviene passare una struct per valore?

Quando la struct è piccola e il codice resta più semplice e leggibile.

## Quando conviene passare una struct per riferimento?

Quando la struct è grande o quando vogliamo evitare copie inutili.

## Quando conviene usare un parametro di output?

Quando vogliamo evitare anche il ritorno di una struct per valore.

Esempio:

```c
void sum3(Dcomplex *result,
          const Dcomplex *const c1,
          const Dcomplex *const c2);
```

---

# 27. Errori tipici da evitare

## Errore 1: accedere direttamente ai campi quando non si dovrebbe

Da evitare:

```c
printf("%f\n", c.re);
```

Meglio:

```c
printf("%f\n", re(&c));
```

Questo rende il codice più indipendente dalla rappresentazione interna.

## Errore 2: dimenticare `free`

```c
ADTcomplex c = mkADTcomplex(3.0, 4.0);

// uso c...

// mi dimentico:
dsADTcomplex(&c);
```

Questo causa memory leak.

## Errore 3: usare un puntatore dopo `free`

```c
ADTcomplex c1 = mkADTcomplex(3.0, 4.0);
ADTcomplex c2 = c1;

dsADTcomplex(&c1);

printf("%f\n", re(c2)); // ERRORE
```

## Errore 4: sbagliare formula del prodotto

Formula corretta:

```c
real = a1 * a2 - b1 * b2;
imag = a1 * b2 + b1 * a2;
```

## Errore 5: confrontare `double` con ==

Da evitare:

```c
if (x == y)
```

Meglio:

```c
if (fabs(x - y) <= epsilon)
```

## Errore 6: mettere funzioni non pertinenti nel modulo

Una funzione come:

```c
void printDcomplex(Dcomplex c);
```

può peggiorare la coesione del modulo, perché mescola logica matematica e output su schermo.

---

# 28. Mini-riassunto finale

La lezione mostra che progettare bene un tipo di dato in C significa scegliere con attenzione cosa rendere pubblico e cosa nascondere.

Una `struct` trasparente è semplice ed efficiente, ma espone la rappresentazione interna e crea accoppiamento forte.

Un tipo opaco nasconde la rappresentazione e riduce l’accoppiamento, ma richiede spesso memoria dinamica e gestione manuale di `malloc` e `free`.

La soluzione agnostica è un compromesso: la rappresentazione è visibile, ma il codice client viene scritto come se non la conoscesse, usando funzioni di accesso.

Per scrivere buon codice bisogna puntare a:

```text
alta coesione
basso accoppiamento
interfacce pulite
implementazioni modificabili
gestione corretta della memoria
efficienza ragionata
```

La frase chiave da ricordare è:

> Il codice client deve dipendere dall’interfaccia del modulo, non dalla sua rappresentazione interna.

---

# 29. Cosa riscrivere a mano per prendere confidenza

Per prepararsi bene all’esame, conviene riscrivere questi esempi senza copiarli:

1. versione con tipo trasparente;
    
2. versione con tipo opaco;
    
3. versione agnostica con `dcomplexRep.h` e `dcomplexAgn.h`;
    
4. versione ottimizzata con passaggio per riferimento;
    
5. versione con parametro di output `sum3` e `product3`;
    
6. test automatici per somma, prodotto, modulo, argomento ed equal.
    

Esercizio consigliato:

> Implementare sia una versione cartesiana sia una versione polare dello stesso modulo, mantenendo invariata l’interfaccia pubblica.

Se riesci a farlo, hai capito davvero:

- cos’è una signature;
    
- cos’è un modulo;
    
- perché l’accoppiamento è importante;
    
- perché i tipi opachi sono utili;
    
- quali compromessi introduce la memoria dinamica;
    
- come progettare codice C più robusto e manutenibile.
    

---

# 30. Frase da 30 e lode

Un tipo di dato opaco permette di separare l’interfaccia dalla rappresentazione interna del dato.  
In questo modo il codice client dipende solo dalle operazioni pubbliche fornite dal modulo e non dai dettagli implementativi.  
Questo riduce l’accoppiamento e migliora la manutenibilità, perché l’implementazione può cambiare senza obbligare il client a modificare il proprio codice.  
Il prezzo da pagare, in C, è spesso l’uso della memoria dinamica e quindi la necessità di gestire correttamente allocazione, deallocazione e possibili alias tra puntatori.