# Puntatori a funzione in C

> Argomento: **Puntatori a funzione**  
> Corso: Programmazione II  
> Obiettivo: capire come trattare una funzione come “valore” da salvare, passare ad altre funzioni o usare per rendere il codice più generico.

---

## 1. Idea fondamentale

In C, il **nome di una funzione** non è una variabile normale, ma può essere usato come riferimento all’indirizzo in memoria in cui inizia il codice della funzione.

Per esempio, se ho:

```c
int somma(int a, int b) {
    return a + b;
}
```

il nome `somma` identifica la funzione, ma può anche essere usato come “indirizzo” della funzione.

Un **puntatore a funzione** è quindi una variabile che contiene l’indirizzo di una funzione.

---

## 2. Perché servono i puntatori a funzione?

I puntatori a funzione servono quando vogliamo scrivere codice più generale.

In particolare, permettono di:

- memorizzare una funzione dentro una variabile;
    
- passare una funzione come parametro a un’altra funzione;
    
- restituire una funzione da un’altra funzione;
    
- scegliere a runtime quale comportamento usare;
    
- rendere generiche funzioni che hanno la stessa struttura ma cambiano in un piccolo dettaglio.
    

L’idea importante è questa:

> Se una parte dell’algoritmo cambia, posso passarla come funzione.

---

## 3. Sintassi base

Supponiamo di avere una funzione così:

```c
int foo(int a, int b, int c);
```

Un puntatore a una funzione con la stessa firma si dichiara così:

```c
int (*ptr)(int, int, int);
```

Attenzione alle parentesi:

```c
int (*ptr)(int, int, int);
```

significa:

> `ptr` è un puntatore a una funzione che prende tre `int` e restituisce un `int`.

Senza parentesi, invece:

```c
int *ptr(int, int, int);
```

significherebbe un’altra cosa:

> `ptr` è una funzione che prende tre `int` e restituisce un puntatore a `int`.

Quindi le parentesi sono fondamentali.

---

## 4. Esempio semplice

```c
#include <stdio.h>

int somma(int a, int b) {
    return a + b;
}

int moltiplica(int a, int b) {
    return a * b;
}

int main(void) {
    int (*operazione)(int, int);

    operazione = somma;
    printf("%d\n", operazione(3, 4));   // stampa 7

    operazione = moltiplica;
    printf("%d\n", operazione(3, 4));   // stampa 12

    return 0;
}
```

Qui `operazione` può puntare sia a `somma` sia a `moltiplica`, perché entrambe hanno la stessa firma:

```c
int funzione(int, int);
```

La firma comprende:

- tipo di ritorno;
    
- numero dei parametri;
    
- tipo dei parametri.
    

---

## 5. Due modi per chiamare la funzione puntata

Se ho:

```c
int (*operazione)(int, int);
```

posso chiamare la funzione in due modi equivalenti:

```c
operazione(3, 4);
```

oppure:

```c
(*operazione)(3, 4);
```

La seconda forma rende più esplicito che sto dereferenziando un puntatore a funzione.

Esempio:

```c
#include <stdio.h>

int somma(int a, int b) {
    return a + b;
}

int main(void) {
    int (*f)(int, int) = somma;

    printf("%d\n", f(10, 20));
    printf("%d\n", (*f)(10, 20));

    return 0;
}
```

Entrambe le chiamate stampano:

```text
30
30
```

---

## 6. Esempio della slide: trovare l’ultima occorrenza del massimo

La funzione vista nella slide è:

```c
#include <stddef.h>

size_t findLastMax(const int a[], size_t n) {
    size_t iMax = 0;

    for (size_t i = 1; i < n; i++) {
        if (a[iMax] <= a[i]) {
            iMax = i;
        }
    }

    return iMax;
}
```

Questa funzione restituisce l’indice dell’ultima occorrenza del massimo in un array.

Esempio:

```c
int a[] = {4, 9, 2, 9, 5};
```

Il massimo è `9`.

Compare in posizione:

```text
1
3
```

La funzione restituisce:

```text
3
```

perché cerca l’ultima occorrenza del massimo.

---

## 7. Perché restituisce l’ultima occorrenza?

Il punto chiave è questa condizione:

```c
if (a[iMax] <= a[i]) {
    iMax = i;
}
```

La condizione usa `<=`.

Questo significa:

- se trovo un valore maggiore, aggiorno `iMax`;
    
- se trovo un valore uguale al massimo corrente, aggiorno comunque `iMax`.
    

Quindi, in caso di parità, vince l’elemento più a destra.

Esempio:

```c
int a[] = {9, 3, 9};
```

All’inizio:

```c
iMax = 0;
```

cioè punta al primo `9`.

Quando arrivo all’indice `2`, controllo:

```c
a[iMax] <= a[i]
```

cioè:

```c
9 <= 9
```

vero.

Quindi:

```c
iMax = 2;
```

Alla fine viene restituito `2`.

---

## 8. Se volessi la prima occorrenza del massimo?

Basterebbe cambiare la condizione:

```c
if (a[iMax] < a[i]) {
    iMax = i;
}
```

Ora uso `<` invece di `<=`.

In questo caso aggiorno `iMax` solo quando trovo un valore strettamente maggiore.

Se trovo un valore uguale, non aggiorno.

Esempio:

```c
int a[] = {9, 3, 9};
```

Con `<`, quando arrivo all’ultimo `9`, controllo:

```c
9 < 9
```

falso.

Quindi `iMax` resta `0`.

La funzione restituisce la prima occorrenza del massimo.

---

## 9. Problema: due funzioni quasi identiche

Potrei scrivere due funzioni diverse:

```c
size_t findLastMax(const int a[], size_t n);
size_t findFirstMax(const int a[], size_t n);
```

Ma sarebbero quasi identiche.

Cambierebbe solo questa parte:

```c
a[iMax] <= a[i]
```

oppure:

```c
a[iMax] < a[i]
```

Il resto dell’algoritmo rimane uguale.

Questa è una situazione tipica in cui conviene usare un puntatore a funzione.

---

## 10. Rendere generica la ricerca

Posso definire due funzioni predicato:

```c
int lessEq(int x, int y) {
    return x <= y;
}

int less(int x, int y) {
    return x < y;
}
```

Queste funzioni restituiscono un intero usato come booleano:

- `0` significa falso;
    
- valore diverso da `0` significa vero.
    

Ora posso passare una di queste due funzioni a una funzione più generale.

---

## 11. Funzione generica con puntatore a funzione

```c
#include <stddef.h>

int lessEq(int x, int y) {
    return x <= y;
}

int less(int x, int y) {
    return x < y;
}

size_t findPar(const int a[], size_t n, int (*compare)(int, int)) {
    size_t iMax = 0;

    for (size_t i = 1; i < n; i++) {
        if (compare(a[iMax], a[i])) {
            iMax = i;
        }
    }

    return iMax;
}
```

Qui il parametro importante è:

```c
int (*compare)(int, int)
```

Significa:

> `compare` è un puntatore a funzione che prende due `int` e restituisce un `int`.

Dentro `findPar`, invece di scrivere direttamente:

```c
a[iMax] <= a[i]
```

scrivo:

```c
compare(a[iMax], a[i])
```

Così la funzione `findPar` non sa quale criterio sto usando.

Il criterio viene deciso da chi chiama la funzione.

---

## 12. Uso di `findPar`

```c
#include <stdio.h>
#include <stddef.h>

int lessEq(int x, int y) {
    return x <= y;
}

int less(int x, int y) {
    return x < y;
}

size_t findPar(const int a[], size_t n, int (*compare)(int, int)) {
    size_t iMax = 0;

    for (size_t i = 1; i < n; i++) {
        if (compare(a[iMax], a[i])) {
            iMax = i;
        }
    }

    return iMax;
}

int main(void) {
    int a[] = {4, 9, 2, 9, 5};
    size_t n = sizeof(a) / sizeof(a[0]);

    size_t lastMax = findPar(a, n, lessEq);
    size_t firstMax = findPar(a, n, less);

    printf("Indice ultima occorrenza massimo: %zu\n", lastMax);
    printf("Indice prima occorrenza massimo: %zu\n", firstMax);

    return 0;
}
```

Output atteso:

```text
Indice ultima occorrenza massimo: 3
Indice prima occorrenza massimo: 1
```

---

## 13. Cosa succede davvero?

Quando chiamo:

```c
findPar(a, n, lessEq);
```

sto dicendo:

> Usa `lessEq` come criterio di confronto.

Quindi dentro `findPar` questa riga:

```c
compare(a[iMax], a[i])
```

diventa concettualmente:

```c
lessEq(a[iMax], a[i])
```

cioè:

```c
a[iMax] <= a[i]
```

Quando invece chiamo:

```c
findPar(a, n, less);
```

la riga:

```c
compare(a[iMax], a[i])
```

diventa concettualmente:

```c
less(a[iMax], a[i])
```

cioè:

```c
a[iMax] < a[i]
```

La struttura dell’algoritmo è la stessa.

Cambia solo il predicato.

---

## 14. Concetto chiave: predicato

Un **predicato** è una funzione che controlla una condizione e restituisce vero o falso.

In C, spesso il valore booleano viene rappresentato con `int`:

```c
int predicato(int x, int y);
```

Esempi:

```c
int less(int x, int y) {
    return x < y;
}
```

```c
int lessEq(int x, int y) {
    return x <= y;
}
```

```c
int greater(int x, int y) {
    return x > y;
}
```

```c
int equal(int x, int y) {
    return x == y;
}
```

---

## 15. Versione con `_Bool`

In C moderno posso anche scrivere:

```c
#include <stdbool.h>

bool less(int x, int y) {
    return x < y;
}
```

Oppure, usando direttamente `_Bool`:

```c
_Bool less(int x, int y) {
    return x < y;
}
```

In quel caso il puntatore a funzione diventa:

```c
_Bool (*compare)(int, int)
```

Esempio:

```c
#include <stdio.h>
#include <stddef.h>
#include <stdbool.h>

bool lessEq(int x, int y) {
    return x <= y;
}

bool less(int x, int y) {
    return x < y;
}

size_t findPar(const int a[], size_t n, bool (*compare)(int, int)) {
    size_t iMax = 0;

    for (size_t i = 1; i < n; i++) {
        if (compare(a[iMax], a[i])) {
            iMax = i;
        }
    }

    return iMax;
}

int main(void) {
    int a[] = {4, 9, 2, 9, 5};
    size_t n = sizeof(a) / sizeof(a[0]);

    printf("%zu\n", findPar(a, n, lessEq)); // 3
    printf("%zu\n", findPar(a, n, less));   // 1

    return 0;
}
```

Questa versione è più leggibile perché il tipo `bool` comunica meglio l’idea di vero/falso.

---

## 16. Perché non scrivere direttamente `if (a[iMax] <= a[i])`?

Perché così la funzione sarebbe rigida.

Con:

```c
if (a[iMax] <= a[i])
```

la funzione trova sempre l’ultima occorrenza del massimo.

Con:

```c
if (compare(a[iMax], a[i]))
```

la funzione può comportarsi in modi diversi in base alla funzione passata.

Questo permette di separare:

- la struttura dell’algoritmo;
    
- il criterio di confronto.
    

Questa è un’idea importantissima.

---

## 17. `typedef` per rendere il codice più leggibile

La sintassi dei puntatori a funzione può diventare pesante.

Per esempio:

```c
size_t findPar(const int a[], size_t n, int (*compare)(int, int));
```

Posso usare `typedef`:

```c
typedef int (*CompareFunc)(int, int);
```

Ora `CompareFunc` è un alias per:

```c
int (*)(int, int)
```

Quindi posso scrivere:

```c
size_t findPar(const int a[], size_t n, CompareFunc compare);
```

Codice completo:

```c
#include <stdio.h>
#include <stddef.h>

typedef int (*CompareFunc)(int, int);

int lessEq(int x, int y) {
    return x <= y;
}

int less(int x, int y) {
    return x < y;
}

size_t findPar(const int a[], size_t n, CompareFunc compare) {
    size_t iMax = 0;

    for (size_t i = 1; i < n; i++) {
        if (compare(a[iMax], a[i])) {
            iMax = i;
        }
    }

    return iMax;
}

int main(void) {
    int a[] = {4, 9, 2, 9, 5};
    size_t n = sizeof(a) / sizeof(a[0]);

    printf("%zu\n", findPar(a, n, lessEq));
    printf("%zu\n", findPar(a, n, less));

    return 0;
}
```

Questa versione è più pulita.

---

## 18. Come leggere una dichiarazione di puntatore a funzione

Prendiamo:

```c
int (*compare)(int, int);
```

Si legge così:

1. `compare` è il nome della variabile;
    
2. `*compare` indica che è un puntatore;
    
3. `(*compare)(int, int)` indica che punta a una funzione con due parametri `int`;
    
4. l’`int` iniziale indica che la funzione restituisce un `int`.
    

Quindi:

```c
int (*compare)(int, int);
```

significa:

> `compare` è un puntatore a funzione che prende due `int` e restituisce un `int`.

Altro esempio:

```c
double (*f)(double);
```

significa:

> `f` è un puntatore a funzione che prende un `double` e restituisce un `double`.

Altro esempio:

```c
void (*printer)(int);
```

significa:

> `printer` è un puntatore a funzione che prende un `int` e non restituisce nulla.

---

## 19. Esempio con funzione che stampa

```c
#include <stdio.h>

void printInt(int x) {
    printf("Valore: %d\n", x);
}

void applyToValue(int value, void (*action)(int)) {
    action(value);
}

int main(void) {
    applyToValue(42, printInt);

    return 0;
}
```

Output:

```text
Valore: 42
```

Qui `applyToValue` riceve una funzione da applicare al valore.

Il parametro:

```c
void (*action)(int)
```

significa:

> funzione che prende un `int` e non restituisce nulla.

---

## 20. Esempio con array di puntatori a funzione

Posso anche avere un array di funzioni.

```c
#include <stdio.h>

int somma(int a, int b) {
    return a + b;
}

int sottrai(int a, int b) {
    return a - b;
}

int moltiplica(int a, int b) {
    return a * b;
}

int main(void) {
    int (*operazioni[3])(int, int);

    operazioni[0] = somma;
    operazioni[1] = sottrai;
    operazioni[2] = moltiplica;

    printf("%d\n", operazioni[0](10, 5)); // 15
    printf("%d\n", operazioni[1](10, 5)); // 5
    printf("%d\n", operazioni[2](10, 5)); // 50

    return 0;
}
```

Dichiarazione importante:

```c
int (*operazioni[3])(int, int);
```

Significa:

> `operazioni` è un array di 3 puntatori a funzione.  
> Ogni funzione prende due `int` e restituisce un `int`.

---

## 21. Errore comune: dimenticare le parentesi

Sbagliato:

```c
int *compare(int, int);
```

Questo non dichiara un puntatore a funzione.

Dichiara una funzione che prende due `int` e restituisce un puntatore a `int`.

Corretto:

```c
int (*compare)(int, int);
```

Le parentesi servono perché l’operatore di chiamata `()` ha precedenza su `*`.

---

## 22. Errore comune: firme incompatibili

Se ho:

```c
int less(int x, int y) {
    return x < y;
}
```

posso assegnarla a:

```c
int (*compare)(int, int);
```

perché la firma è compatibile.

Ma non posso assegnarla correttamente a:

```c
double (*compare)(double, double);
```

perché cambia sia il tipo di ritorno sia il tipo dei parametri.

Le funzioni passate tramite puntatore devono avere una firma compatibile con quella attesa.

---

## 23. Errore comune: passare il risultato invece della funzione

Corretto:

```c
findPar(a, n, less);
```

Sbagliato:

```c
findPar(a, n, less(a[0], a[1]));
```

Nel primo caso passo la funzione `less`.

Nel secondo caso chiamo subito `less(a[0], a[1])` e passo il suo risultato, cioè un `int`.

Ma `findPar` si aspetta un puntatore a funzione, non un `int`.

---

## 24. Esercizio guidato 1: trova massimo con criterio personalizzato

Riscrivere da zero questo codice:

```c
#include <stdio.h>
#include <stddef.h>

int lessEq(int x, int y) {
    return x <= y;
}

int less(int x, int y) {
    return x < y;
}

size_t findPar(const int a[], size_t n, int (*compare)(int, int)) {
    size_t iMax = 0;

    for (size_t i = 1; i < n; i++) {
        if (compare(a[iMax], a[i])) {
            iMax = i;
        }
    }

    return iMax;
}

int main(void) {
    int a[] = {7, 2, 9, 9, 1};
    size_t n = sizeof(a) / sizeof(a[0]);

    printf("Prima occorrenza massimo: %zu\n", findPar(a, n, less));
    printf("Ultima occorrenza massimo: %zu\n", findPar(a, n, lessEq));

    return 0;
}
```

Domande da sapersi fare:

1. Perché con `less` ottengo la prima occorrenza?
    
2. Perché con `lessEq` ottengo l’ultima occorrenza?
    
3. Che tipo ha `compare`?
    
4. Che tipo ha `less`?
    
5. Perché posso passare `less` come parametro?
    

---

## 25. Esercizio guidato 2: applicare una funzione a ogni elemento

Scrivere una funzione che riceve un array e una funzione da applicare a ogni elemento.

```c
#include <stdio.h>
#include <stddef.h>

void printSquare(int x) {
    printf("%d\n", x * x);
}

void printDouble(int x) {
    printf("%d\n", x * 2);
}

void forEach(const int a[], size_t n, void (*action)(int)) {
    for (size_t i = 0; i < n; i++) {
        action(a[i]);
    }
}

int main(void) {
    int a[] = {1, 2, 3, 4};
    size_t n = sizeof(a) / sizeof(a[0]);

    printf("Quadrati:\n");
    forEach(a, n, printSquare);

    printf("Doppi:\n");
    forEach(a, n, printDouble);

    return 0;
}
```

Questo esempio è importante perché mostra chiaramente che una funzione può ricevere un comportamento dall’esterno.

---

## 26. Esercizio guidato 3: scegliere un’operazione

```c
#include <stdio.h>

int somma(int a, int b) {
    return a + b;
}

int sottrai(int a, int b) {
    return a - b;
}

int moltiplica(int a, int b) {
    return a * b;
}

int calcola(int a, int b, int (*op)(int, int)) {
    return op(a, b);
}

int main(void) {
    printf("%d\n", calcola(10, 5, somma));
    printf("%d\n", calcola(10, 5, sottrai));
    printf("%d\n", calcola(10, 5, moltiplica));

    return 0;
}
```

Da capire:

```c
int (*op)(int, int)
```

è il parametro funzione.

Dentro `calcola`:

```c
return op(a, b);
```

chiama la funzione ricevuta.

---

## 27. Collegamento con funzioni generiche

I puntatori a funzione sono alla base di molte funzioni generiche.

Per esempio, in C esiste `qsort`, una funzione di libreria che ordina array generici.

`qsort` riceve anche una funzione di confronto, perché non può sapere da sola come confrontare due elementi.

L’idea è la stessa vista con `findPar`:

> l’algoritmo generale rimane uguale, ma il criterio viene passato dall’esterno.

---

## 28. Versione molto semplice stile `qsort`

Esempio didattico:

```c
#include <stdio.h>
#include <stddef.h>

int crescente(int x, int y) {
    return x > y;
}

int decrescente(int x, int y) {
    return x < y;
}

void bubbleSort(int a[], size_t n, int (*shouldSwap)(int, int)) {
    for (size_t i = 0; i < n; i++) {
        for (size_t j = 0; j + 1 < n; j++) {
            if (shouldSwap(a[j], a[j + 1])) {
                int temp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = temp;
            }
        }
    }
}

void printArray(const int a[], size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%d ", a[i]);
    }
    printf("\n");
}

int main(void) {
    int a[] = {4, 1, 5, 2, 3};
    size_t n = sizeof(a) / sizeof(a[0]);

    bubbleSort(a, n, crescente);
    printArray(a, n);

    bubbleSort(a, n, decrescente);
    printArray(a, n);

    return 0;
}
```

Output:

```text
1 2 3 4 5
5 4 3 2 1
```

Qui la funzione `bubbleSort` non decide direttamente se ordinare in modo crescente o decrescente.

Lo decide la funzione passata come parametro:

```c
crescente
```

oppure:

```c
decrescente
```

---

## 29. Schema mentale da ricordare

Quando vedo:

```c
int (*f)(int, int);
```

devo pensare:

> `f` è una variabile che può contenere una funzione compatibile.

Quando vedo:

```c
int calcola(int a, int b, int (*op)(int, int))
```

devo pensare:

> `calcola` riceve due numeri e una funzione da usare su quei numeri.

Quando vedo:

```c
op(a, b);
```

devo pensare:

> Sto chiamando la funzione puntata da `op`.

---

## 30. Cose da sapere bene per l’esame

### Devo saper spiegare

- Che cos’è un puntatore a funzione.
    
- Perché il nome di una funzione può essere usato come indirizzo.
    
- Come si dichiara un puntatore a funzione.
    
- Perché servono le parentesi in `int (*f)(int, int)`.
    
- Come si passa una funzione come parametro.
    
- Come si chiama una funzione tramite puntatore.
    
- Perché `findPar` è più generale di `findLastMax`.
    
- Perché `less` trova la prima occorrenza del massimo.
    
- Perché `lessEq` trova l’ultima occorrenza del massimo.
    
- Cosa significa usare una funzione come predicato.
    
- Come usare `typedef` per rendere più leggibili i puntatori a funzione.
    

### Devo saper scrivere

- Una funzione con un puntatore a funzione come parametro.
    
- Una funzione predicato.
    
- Una chiamata in cui passo una funzione come parametro.
    
- Una versione con `typedef`.
    
- Un piccolo esempio con array di puntatori a funzione.
    

---

## 31. Domande tipiche da esame

### Domanda 1

Che tipo ha `compare` nella seguente dichiarazione?

```c
size_t findPar(const int a[], size_t n, int (*compare)(int, int));
```

Risposta:

`compare` è un puntatore a funzione.  
La funzione puntata prende due `int` e restituisce un `int`.

---

### Domanda 2

Perché questa chiamata è corretta?

```c
findPar(a, n, less);
```

Risposta:

Perché `less` è il nome di una funzione compatibile con il tipo atteso da `findPar`.

Se `less` è dichiarata così:

```c
int less(int x, int y);
```

allora può essere passata a un parametro di tipo:

```c
int (*compare)(int, int)
```

---

### Domanda 3

Qual è la differenza tra `less` e `lessEq` nell’esempio del massimo?

```c
int less(int x, int y) {
    return x < y;
}

int lessEq(int x, int y) {
    return x <= y;
}
```

Risposta:

`less` aggiorna l’indice solo se trova un valore strettamente maggiore.  
Quindi mantiene la prima occorrenza del massimo.

`lessEq` aggiorna l’indice anche se trova un valore uguale.  
Quindi restituisce l’ultima occorrenza del massimo.

---

### Domanda 4

Cosa cambia tra queste due dichiarazioni?

```c
int (*f)(int, int);
```

```c
int *f(int, int);
```

Risposta:

La prima dichiara un puntatore a funzione.

La seconda dichiara una funzione che restituisce un puntatore a `int`.

---

## 32. Mini-cheatsheet

```c
// Funzione normale
int somma(int a, int b);

// Puntatore a funzione
int (*op)(int, int);

// Assegnazione
op = somma;

// Chiamata
op(3, 4);

// Chiamata equivalente
(*op)(3, 4);

// Funzione che riceve un puntatore a funzione
int calcola(int a, int b, int (*op)(int, int)) {
    return op(a, b);
}

// typedef
typedef int (*Operation)(int, int);

// Uso del typedef
int calcola2(int a, int b, Operation op) {
    return op(a, b);
}
```

---

## 33. Frase da ricordare

> Un puntatore a funzione permette di passare un comportamento come parametro.

Questa frase riassume tutto.

Nel caso della slide:

- `findPar` contiene l’algoritmo generale;
    
- `less` e `lessEq` contengono il comportamento specifico;
    
- passando `less` o `lessEq`, cambio il risultato senza riscrivere l’algoritmo.
    

---

## 34. Allenamento consigliato

Per prendere confidenza, riscrivere a mano almeno questi esempi:

1. esempio `somma` / `moltiplica` con puntatore a funzione;
    
2. esempio `findPar` con `less` e `lessEq`;
    
3. esempio `forEach`;
    
4. esempio `calcola`;
    
5. esempio con `typedef`;
    
6. esempio con array di puntatori a funzione;
    
7. piccolo ordinamento con criterio crescente/decrescente.
    

L’obiettivo non è solo far compilare il codice.

L’obiettivo è riuscire a leggere immediatamente dichiarazioni come:

```c
int (*compare)(int, int)
```

senza bloccarsi.

Quando questa sintassi diventa familiare, i puntatori a funzione smettono di sembrare strani e diventano semplicemente un modo per rendere il codice più flessibile.

---