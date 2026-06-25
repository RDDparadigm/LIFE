# Correttezza di Programmi e Cicli

> Appunti da studiare bene per Programmazione II
> Argomento: **correttezza dei programmi, terminazione, invarianti di ciclo, progettazione corretta dei cicli**

---

# 1. Idea centrale della lezione

Queste slide spiegano come ragionare formalmente sulla correttezza di un programma, in particolare quando il programma contiene **cicli**.

L’idea fondamentale è questa:

> Un programma non è corretto solo perché “sembra funzionare” su alcuni esempi.
> Un programma è corretto se possiamo dimostrare che, dati certi input validi, produce sempre il risultato richiesto e termina.

Per arrivare a questo obiettivo si introducono tre concetti chiave:

1. **correttezza parziale**
2. **terminazione**
3. **invariante di ciclo**

---

# 2. Correttezza di un programma

La corretzza di un programma è data da:

```text
Correttezza = Correttezza parziale + Terminazione
```

Questa divisione è molto importante.

Un programma può essere:

* **parzialmente corretto**, cioè se termina restituisce il risultato giusto;
* ma **non terminante**, cioè potrebbe entrare in un ciclo infinito.

In quel caso il programma non è corretto in senso completo.

---

# 3. Predicato di input e predicato di output

Supponiamo di avere una funzione generica:

```c
t prog(t1 x1, ..., tn xn) {
    /* corpo della funzione */
}
```

Per ragionare sulla sua correttezza definiamo due condizioni:

## P-IN

Il predicato di input descrive quando gli input sono validi.

```text
P-IN(x1, ..., xn)
```

Esempio:

```text
P-IN(a, n): lunghezza(a) >= n >= 1
```

Significa che:

* `a` deve essere un array con almeno `n` elementi;
* `n` deve essere almeno `1`.

Quindi la funzione non promette di funzionare per array vuoti o per `n <= 0`.

---

## P-OUT

Il predicato di output descrive cosa deve essere vero sul risultato.

```text
P-OUT(x1, ..., xn, z)
```

dove `z` è il valore restituito dalla funzione.

Esempio:

```text
P-OUT(a, n, r): r è il massimo elemento in a[0..n-1]
```

Significa che il risultato `r` deve essere il massimo tra gli elementi dell’array dalla posizione `0` alla posizione `n - 1`.

---

# 4. Correttezza parziale

Una funzione è **parzialmente corretta** rispetto a `P-IN` e `P-OUT` se vale questa cosa:

> Se gli input soddisfano `P-IN`
> e se la funzione termina restituendo un valore `z`,
> allora `z` soddisfa `P-OUT`.

In formula informale:

```text
P-IN vero + programma termina => P-OUT vero
```

Attenzione: la correttezza parziale **non garantisce** che il programma termini.

Esempio assurdo:

```c
int f(void) {
    while (1) {
        // ciclo infinito
    }

    return 42;
}
```

Questa funzione non termina mai.
Quindi non restituisce mai un risultato sbagliato, ma non è comunque corretta.

---

# 5. Terminazione

Una funzione è **terminante** se:

> Per tutti gli input che soddisfano `P-IN`, l’esecuzione della funzione termina.

Quindi, per dimostrare la correttezza totale di una funzione, devo dimostrare entrambe le cose:

```text
1. Se termina, produce il risultato giusto.
2. Termina davvero.
```

---

# 6. Post-hoc Verification e Correctness by Construction

Le slide distinguono due modi di ragionare sulla correttezza.

---

## 6.1 Post-hoc Verification

Nella **Post-hoc Verification**, prima si scrive il programma e poi si verifica se è corretto.

Schema:

```text
1. Scrivo specifica.
2. Scrivo programma.
3. Verifico dopo che il programma rispetti la specifica.
```

È un approccio “a posteriori”.

---

## 6.2 Correctness by Construction

Nella **Correctness by Construction**, invece, il programma viene costruito già seguendo regole che dovrebbero garantirne la correttezza.

Schema:

```text
1. Parto dalla specifica.
2. Costruisco il programma passo passo.
3. Ogni passo mantiene la correttezza.
```

Nelle slide viene applicato questo approccio ai cicli usando:

```text
metodologia di sviluppo guidata dall’invariante di ciclo
```

---

# 7. Invariante di ciclo

L’**invariante di ciclo** è il concetto più importante della lezione.

Un invariante di ciclo è una proprietà che deve essere vera:

1. prima della prima iterazione;
2. dopo ogni iterazione;
3. all’uscita dal ciclo, insieme alla negazione della condizione, deve permettermi di concludere che il risultato è corretto.

In modo intuitivo:

> L’invariante descrive cosa abbiamo già risolto in un punto intermedio del ciclo.

Non bisogna pensare solo all’inizio o alla fine del ciclo.
Bisogna pensare a un punto generico durante l’esecuzione.

---

## Esempio mentale

Se sto cercando il massimo in un array, a metà ciclo posso dire:

```text
max contiene il massimo degli elementi già visitati.
```

Questa è l’idea di invariante.

Se ho già guardato gli elementi:

```text
a[0], a[1], ..., a[i-1]
```

allora posso dire:

```text
max è il massimo in a[0..i-1]
```

Questa frase è l’invariante del ciclo.

---

# 8. Come progettare un ciclo corretto

Un ciclo di solito viene scritto così:

```c
inizializzazione;

while (condizione) {
    corpo;
}
```

oppure:

```c
for (inizializzazione; condizione; aggiornamento) {
    corpo;
}
```

Ma secondo la metodologia delle slide, per progettare un ciclo corretto bisogna ragionare nell’ordine opposto rispetto a come il codice appare scritto.

Ordine di progettazione:

```text
1. Corpo del ciclo
2. Condizione del ciclo
3. Inizializzazione
```

Perché?

Perché prima devo capire:

* come avanzo verso la soluzione;
* quando posso fermarmi;
* da dove devo partire affinché l’invariante sia vero già all’inizio.

---

# 9. Schema generale per costruire un ciclo con invariante

Quando devi scrivere un ciclo non banale, puoi usare questo schema.

## Passo 1: scrivi P-IN e P-OUT

Prima devi sapere cosa deve fare la funzione.

Esempio:

```text
P-IN(a, n): lunghezza(a) >= n >= 1
P-OUT(a, n, r): r è il massimo in a[0..n-1]
```

---

## Passo 2: pensa ai test

Anche se il testing non dimostra la correttezza matematica del programma, aiuta molto a capire i casi importanti.

Tipi di casi da testare:

* array con un solo elemento;
* massimo all’inizio;
* massimo alla fine;
* massimo in mezzo;
* massimo ripetuto;
* tutti gli elementi uguali;
* valori negativi;
* combinazioni miste.

---

## Passo 3: scrivi l’idea informale

Prima del codice, scrivi in italiano cosa vuoi fare.

Esempio:

```text
Ispeziono gli elementi dell'array da sinistra verso destra.
Mantengo in max il massimo degli elementi già osservati.
Quando incontro un elemento più grande, aggiorno max.
Alla fine max sarà il massimo dell'intero array.
```

---

## Passo 4: scrivi l’invariante

Esempio:

```text
I.C.: max è il massimo in a[0..i-1]
```

---

## Passo 5: scrivi il corpo del ciclo

Se l’invariante dice che `max` è il massimo degli elementi già visitati, allora quando visito `a[i]` devo confrontarlo con `max`.

```c
if (max < a[i]) {
    max = a[i];
}
```

Dopo questa istruzione, `max` diventa il massimo in:

```text
a[0..i]
```

cioè:

```text
a[0..(i+1)-1]
```

Poi l’incremento `i++` ripristina l’invariante per la prossima iterazione.

---

## Passo 6: scrivi la condizione

Se voglio arrivare fino ad `a[n-1]`, allora devo continuare finché:

```c
i < n
```

Quando il ciclo termina, avrò:

```text
i == n
```

e l’invariante diventa:

```text
max è il massimo in a[0..n-1]
```

cioè esattamente il predicato di output.

---

## Passo 7: scrivi l’inizializzazione

Devo inizializzare le variabili in modo che l’invariante sia vero prima della prima iterazione.

Se scrivo:

```c
int max = a[0];
int i = 1;
```

allora prima della prima iterazione vale:

```text
max è il massimo in a[0..0]
```

cioè `max` è il massimo della porzione già visitata, composta solo da `a[0]`.

---

# 10. Esempio 1: massimo in un array

Vogliamo implementare questa funzione:

```c
int maximum(const int a[], int n);
```

## Specifica

```text
P-IN(a, n): lunghezza(a) >= n >= 1

P-OUT(a, n, r): r è il massimo elemento in a[0..n-1]
```

---

## File maximum.h

```c
#ifndef MAXIMUM_H
#define MAXIMUM_H

/**
 * @brief Restituisce il massimo elemento nella porzione a[0..n-1].
 *
 * P-IN(a, n): lunghezza(a) >= n >= 1
 * P-OUT(a, n, r): r è il massimo in a[0..n-1]
 */
int maximum(const int a[], int n);

#endif
```

---

## File maximum.c

```c
#include "maximum.h"

int maximum(const int a[], int n) {
    int max = a[0];

    /*
     * I.C.:
     * max è il massimo nella porzione a[0..i-1].
     *
     * All'inizio:
     * i = 1
     * max = a[0]
     * quindi max è il massimo in a[0..0].
     */
    for (int i = 1; i < n; i++) {
        /*
         * Prima del corpo:
         * max è il massimo in a[0..i-1].
         *
         * Ora considero a[i].
         * Se a[i] è più grande, aggiorno max.
         */
        if (max < a[i]) {
            max = a[i];
        }

        /*
         * Dopo il corpo:
         * max è il massimo in a[0..i].
         *
         * Dopo i++:
         * l'invariante torna nella forma:
         * max è il massimo in a[0..i-1].
         */
    }

    /*
     * Alla fine del ciclo:
     * i == n
     *
     * Per l'invariante:
     * max è il massimo in a[0..n-1].
     *
     * Quindi P-OUT è vero.
     */
    return max;
}
```

---

# 11. Dimostrazione della correttezza parziale di maximum

Per dimostrare la correttezza parziale, ragiono così.

## Inizializzazione

Prima del ciclo:

```c
int max = a[0];
int i = 1;
```

La porzione già considerata è:

```text
a[0..0]
```

Il massimo di una porzione con un solo elemento è quell’elemento stesso.

Quindi:

```text
max è il massimo in a[0..i-1]
```

è vero.

---

## Conservazione dell’invariante

Assumo che prima di una iterazione valga:

```text
max è il massimo in a[0..i-1]
```

Ora considero `a[i]`.

Ci sono due casi.

### Caso 1: `a[i] > max`

Allora `a[i]` è il nuovo massimo tra gli elementi visti finora.

Quindi faccio:

```c
max = a[i];
```

e dopo il corpo `max` è il massimo in:

```text
a[0..i]
```

---

### Caso 2: `a[i] <= max`

Allora il massimo rimane quello precedente.

Non aggiorno `max`.

Anche in questo caso dopo il corpo `max` è il massimo in:

```text
a[0..i]
```

Dopo l’incremento `i++`, l’invariante torna nella forma:

```text
max è il massimo in a[0..i-1]
```

---

## Uscita dal ciclo

Il ciclo termina quando:

```c
i < n
```

diventa falso.

Quindi:

```text
i == n
```

L’invariante dice:

```text
max è il massimo in a[0..i-1]
```

Sostituendo `i == n`:

```text
max è il massimo in a[0..n-1]
```

che è esattamente `P-OUT`.

---

# 12. Terminazione di maximum

La terminazione si dimostra osservando che:

```c
for (int i = 1; i < n; i++)
```

* `i` parte da `1`;
* a ogni iterazione aumenta di `1`;
* `n` rimane costante;
* prima o poi `i` raggiunge `n`;
* quando `i == n`, la condizione `i < n` diventa falsa.

Quindi il ciclo termina dopo un numero finito di iterazioni.

Dato che abbiamo:

```text
correttezza parziale + terminazione
```

la funzione `maximum` è corretta.

---

# 13. Test suite per maximum

Un buon modo per prendere confidenza con il codice è riscrivere una piccola test suite.

```c
#include <stdio.h>
#include "maximum.h"

void checkMaximum(int testNumber, const int a[], int n, int expected) {
    int result = maximum(a, n);

    if (result != expected) {
        printf("-- TEST %d FAILED --\n", testNumber);
        printf("Expected: %d\n", expected);
        printf("Result:   %d\n\n", result);
    } else {
        printf("TEST %d OK\n", testNumber);
    }
}

int main(void) {
    puts("BEGIN TEST maximum.c");

    {
        int a[] = {3};
        checkMaximum(1, a, 1, 3);
    }

    {
        int a[] = {1, 3};
        checkMaximum(2, a, 2, 3);
    }

    {
        int a[] = {3, 1};
        checkMaximum(3, a, 2, 3);
    }

    {
        int a[] = {1, 2, 3, 5};
        checkMaximum(4, a, 4, 5);
    }

    {
        int a[] = {5, 1, 2, 3};
        checkMaximum(5, a, 4, 5);
    }

    {
        int a[] = {1, 5, 2, 3};
        checkMaximum(6, a, 4, 5);
    }

    {
        int a[] = {5, 5, 3, 2};
        checkMaximum(7, a, 4, 5);
    }

    {
        int a[] = {5, 5, 5, 5};
        checkMaximum(8, a, 4, 5);
    }

    {
        int a[] = {-10, -3, -7, -20};
        checkMaximum(9, a, 4, -3);
    }

    return 0;
}
```

---

# 14. Esempio 2: ultima occorrenza del massimo

Ora vogliamo scrivere una funzione che non restituisce il massimo, ma l’indice dell’ultima occorrenza del massimo.

Esempio:

```text
a = {3, 1, 5, 5}
```

Il massimo è `5`.

Compare in posizione `2` e in posizione `3`.

L’ultima occorrenza è in posizione:

```text
3
```

La funzione deve restituire `3`.

---

## Specifica

```c
int findLastMax(const int a[], int n);
```

Predicati:

```text
P-IN(a, n): lunghezza(a) >= n >= 1

P-OUT(a, n, r): r è l'indice dell'ultima occorrenza del massimo in a[0..n-1]
```

---

## File findLastMax.h

```c
#ifndef FIND_LAST_MAX_H
#define FIND_LAST_MAX_H

/**
 * @brief Restituisce l'indice dell'ultima occorrenza del massimo in a[0..n-1].
 *
 * P-IN(a, n): lunghezza(a) >= n >= 1
 * P-OUT(a, n, r): r è l'indice dell'ultima occorrenza del massimo in a[0..n-1]
 */
int findLastMax(const int a[], int n);

#endif
```

---

## File findLastMax.c

```c
#include "findLastMax.h"

int findLastMax(const int a[], int n) {
    int iMax = 0;

    /*
     * I.C.:
     * iMax è l'indice dell'ultima occorrenza del massimo
     * nella porzione a[0..i-1].
     *
     * All'inizio:
     * i = 1
     * iMax = 0
     * quindi iMax è l'indice dell'ultima occorrenza del massimo
     * nella porzione a[0..0].
     */
    for (int i = 1; i < n; i++) {
        /*
         * Se a[i] è maggiore del massimo corrente,
         * allora il massimo cambia.
         *
         * Se a[i] è uguale al massimo corrente,
         * allora voglio aggiornare comunque iMax,
         * perché mi interessa l'ultima occorrenza.
         */
        if (a[iMax] <= a[i]) {
            iMax = i;
        }
    }

    /*
     * Alla fine:
     * i == n
     *
     * Per l'invariante:
     * iMax è l'indice dell'ultima occorrenza del massimo in a[0..n-1].
     */
    return iMax;
}
```

---

# 15. Perché in findLastMax si usa <= e non <?

Questa è una cosa importantissima.

Nel calcolo del massimo normale scrivevamo:

```c
if (max < a[i]) {
    max = a[i];
}
```

Perché ci bastava trovare il valore massimo.

Ma in `findLastMax` vogliamo l’indice dell’ultima occorrenza del massimo.

Quindi, se troviamo un valore uguale al massimo corrente, dobbiamo aggiornare l’indice.

Per questo si scrive:

```c
if (a[iMax] <= a[i]) {
    iMax = i;
}
```

Esempio:

```text
a = {5, 5, 3, 2}
```

All’inizio:

```text
iMax = 0
a[iMax] = 5
```

Quando `i = 1`:

```text
a[i] = 5
```

Il confronto è:

```c
a[iMax] <= a[i]
```

cioè:

```text
5 <= 5
```

vero.

Quindi aggiorno:

```text
iMax = 1
```

Così ottengo l’ultima occorrenza, non la prima.

Se invece avessi scritto:

```c
if (a[iMax] < a[i])
```

allora con due valori uguali non aggiornerei l’indice, e otterrei la prima occorrenza del massimo.

---

# 16. Dimostrazione della correttezza parziale di findLastMax

## Invariante

```text
I.C.: iMax è l'indice dell'ultima occorrenza del massimo in a[0..i-1]
```

---

## Inizializzazione

Prima del ciclo:

```c
int iMax = 0;
int i = 1;
```

La porzione considerata è:

```text
a[0..0]
```

L’unico elemento è `a[0]`.

Quindi l’indice dell’ultima occorrenza del massimo è sicuramente `0`.

L’invariante è vero.

---

## Conservazione

Supponiamo che prima di una iterazione valga:

```text
iMax è l'indice dell'ultima occorrenza del massimo in a[0..i-1]
```

Ora considero `a[i]`.

Ci sono tre casi.

---

### Caso 1: `a[i] > a[iMax]`

Ho trovato un nuovo massimo.

Quindi l’ultima occorrenza del massimo è sicuramente `i`.

```c
iMax = i;
```

---

### Caso 2: `a[i] == a[iMax]`

Ho trovato un’altra occorrenza dello stesso massimo.

Siccome voglio l’ultima occorrenza, aggiorno comunque:

```c
iMax = i;
```

---

### Caso 3: `a[i] < a[iMax]`

Il massimo non cambia.

L’ultima occorrenza del massimo rimane quella precedente.

Non aggiorno `iMax`.

---

In tutti e tre i casi, dopo il corpo del ciclo:

```text
iMax è l'indice dell'ultima occorrenza del massimo in a[0..i]
```

Dopo `i++`, l’invariante viene ripristinato nella forma:

```text
iMax è l'indice dell'ultima occorrenza del massimo in a[0..i-1]
```

---

## Uscita dal ciclo

Il ciclo termina quando:

```text
i == n
```

L’invariante dice:

```text
iMax è l'indice dell'ultima occorrenza del massimo in a[0..i-1]
```

Sostituendo `i == n`:

```text
iMax è l'indice dell'ultima occorrenza del massimo in a[0..n-1]
```

che coincide con `P-OUT`.

---

# 17. Terminazione di findLastMax

Il ciclo è:

```c
for (int i = 1; i < n; i++)
```

Anche qui:

* `i` parte da `1`;
* cresce di `1` a ogni iterazione;
* `n` rimane costante;
* prima o poi `i == n`;
* quando `i == n`, la condizione `i < n` diventa falsa.

Quindi il ciclo termina.

Dato che abbiamo correttezza parziale e terminazione, la funzione è corretta.

---

# 18. Test suite per findLastMax

```c
#include <stdio.h>
#include "findLastMax.h"

void checkFindLastMax(int testNumber, const int a[], int n, int expected) {
    int result = findLastMax(a, n);

    if (result != expected) {
        printf("-- TEST %d FAILED --\n", testNumber);
        printf("Expected: %d\n", expected);
        printf("Result:   %d\n\n", result);
    } else {
        printf("TEST %d OK\n", testNumber);
    }
}

int main(void) {
    puts("BEGIN TEST findLastMax.c");

    {
        int a[] = {3};
        checkFindLastMax(1, a, 1, 0);
    }

    {
        int a[] = {1, 3};
        checkFindLastMax(2, a, 2, 1);
    }

    {
        int a[] = {3, 1};
        checkFindLastMax(3, a, 2, 0);
    }

    {
        int a[] = {3, 3};
        checkFindLastMax(4, a, 2, 1);
    }

    {
        int a[] = {1, 2, 3, 5};
        checkFindLastMax(5, a, 4, 3);
    }

    {
        int a[] = {5, 1, 2, 3};
        checkFindLastMax(6, a, 4, 0);
    }

    {
        int a[] = {1, 5, 2, 3};
        checkFindLastMax(7, a, 4, 1);
    }

    {
        int a[] = {5, 5, 3, 2};
        checkFindLastMax(8, a, 4, 1);
    }

    {
        int a[] = {3, 1, 5, 5};
        checkFindLastMax(9, a, 4, 3);
    }

    {
        int a[] = {5, 5, 5, 5};
        checkFindLastMax(10, a, 4, 3);
    }

    return 0;
}
```

---

# 19. Notazioni: valori iniziali delle variabili

Le slide introducono una convenzione importante.

A volte una funzione modifica direttamente uno dei suoi parametri.

Per esempio:

```c
void swap(int a[], int first, int second);
```

Questa funzione modifica l’array `a`.

Se voglio dire “il valore iniziale di `a`”, uso la notazione:

```text
a'
```

che si legge “a primo” oppure “a iniziale”.

---

## Esempio con array

```c
void swap(int a[], int first, int second) {
    int hold = a[first];
    a[first] = a[second];
    a[second] = hold;
}
```

Specifica:

```text
P-IN(a, first, second):
    first e second sono indici validi di a

P-OUT(a, first, second):
    a[first] == a'[second]
    e
    a[second] == a'[first]
```

Significa:

* alla fine `a[first]` contiene il valore che inizialmente era in `a[second]`;
* alla fine `a[second]` contiene il valore che inizialmente era in `a[first]`.

---

## Esempio con puntatori

```c
void swap2(int *px, int *py) {
    int hold = *px;
    *px = *py;
    *py = hold;
}
```

Specifica:

```text
P-IN(px, py): true

P-OUT(px, py):
    *px == (*py)'
    e
    *py == (*px)'
```

Qui:

```text
(*px)'
```

significa:

```text
il valore iniziale della variabile puntata da px
```

Attenzione: non è il puntatore `px` a cambiare, ma il contenuto della cella puntata.

---

# 20. TDD vs CbC vs PhV

Le slide confrontano tre approcci:

* TDD
* Correctness by Construction
* Post-hoc Verification

---

## TDD

TDD significa **Test Driven Development**.

La test suite funziona come una specifica fatta di esempi.

Esempio:

```text
Input:  {1, 3}
Output: 3

Input:  {3, 1}
Output: 3

Input:  {5, 5, 3, 2}
Output: 5
```

Il vantaggio è che i test sono eseguibili automaticamente.

Il limite è che una test suite è quasi sempre incompleta.

Può dimostrare che il codice funziona su alcuni casi, ma non su tutti i casi possibili.

---

## CbC / PhV

Con CbC e PhV si lavora con specifiche logiche:

```text
P-IN(...)
P-OUT(...)
Invarianti di ciclo
```

Questo approccio è più formale.

La specifica non elenca solo esempi, ma descrive la relazione generale tra input e output.

Esempio:

```text
r è il massimo in a[0..n-1]
```

Questa frase descrive tutti gli array validi, non solo alcuni esempi.

---

## Differenza importante

La test suite è una specifica **estensionale**.

Significa che descrive alcuni esempi concreti:

```text
(input, output)
(input, output)
(input, output)
```

La specifica logica è una specifica **intensionale**.

Significa che descrive una proprietà generale.

Esempio:

```text
r è il massimo in a[0..n-1]
```

---

# 21. Cosa bisogna capire bene per l’esame

## 1. Correttezza parziale non significa correttezza totale

Non basta dire:

```text
se il programma termina, il risultato è giusto
```

Bisogna anche dimostrare che termina.

---

## 2. L’invariante non è la condizione del ciclo

Queste due cose sono diverse.

La condizione dice se continuare:

```c
i < n
```

L’invariante dice cosa è vero durante il ciclo:

```text
max è il massimo in a[0..i-1]
```

---

## 3. L’invariante deve essere vero all’inizio

Se scegli un invariante, devi inizializzare le variabili in modo coerente.

Per esempio:

```c
int max = a[0];
for (int i = 1; i < n; i++)
```

funziona perché prima della prima iterazione `max` è il massimo in `a[0..0]`.

---

## 4. Il corpo deve preservare l’invariante

Dopo ogni iterazione, l’invariante deve tornare vero.

Questa è la parte più importante della dimostrazione.

---

## 5. All’uscita dal ciclo devi ottenere P-OUT

Di solito il ragionamento è:

```text
I.C. vero
e
condizione falsa
=>
P-OUT vero
```

Esempio:

```text
I.C.: max è il massimo in a[0..i-1]
condizione falsa: i == n

Quindi:
max è il massimo in a[0..n-1]
```

---

## 6. Per la terminazione devi trovare una quantità che si avvicina alla fine

Nel caso dei cicli sugli array:

```c
for (int i = 1; i < n; i++)
```

la quantità importante è:

```text
n - i
```

A ogni iterazione diminuisce di `1`.

Quando arriva a `0`, il ciclo termina.

Questa quantità viene spesso chiamata informalmente “misura di avanzamento”.

---

# 22. Errori tipici da evitare

## Errore 1: partire da `i = 0` con `max = a[0]`

Questo codice funziona, ma fa un confronto inutile:

```c
int max = a[0];

for (int i = 0; i < n; i++) {
    if (max < a[i]) {
        max = a[i];
    }
}
```

Alla prima iterazione confronta `a[0]` con se stesso.

Non è sbagliato, ma è meno elegante rispetto a:

```c
int max = a[0];

for (int i = 1; i < n; i++) {
    if (max < a[i]) {
        max = a[i];
    }
}
```

---

## Errore 2: usare `<` invece di `<=` in findLastMax

Sbagliato per l’ultima occorrenza:

```c
if (a[iMax] < a[i]) {
    iMax = i;
}
```

Questo trova la prima occorrenza del massimo, non l’ultima.

Corretto:

```c
if (a[iMax] <= a[i]) {
    iMax = i;
}
```

---

## Errore 3: dimenticare il caso `n == 1`

Se `n == 1`, il ciclo:

```c
for (int i = 1; i < n; i++)
```

non viene mai eseguito.

Questo è corretto.

Per `maximum`, restituisce:

```c
a[0]
```

Per `findLastMax`, restituisce:

```c
0
```

---

## Errore 4: confondere valore massimo e indice del massimo

Queste due funzioni fanno cose diverse:

```c
int maximum(const int a[], int n);
int findLastMax(const int a[], int n);
```

La prima restituisce un valore dell’array.

La seconda restituisce un indice.

Esempio:

```text
a = {10, 20, 30}
```

`maximum(a, 3)` restituisce:

```text
30
```

`findLastMax(a, 3)` restituisce:

```text
2
```

---

# 23. Esercizi consigliati da riscrivere

Per prendere confidenza, conviene riscrivere questi esercizi senza guardare la soluzione.

---

## Esercizio 1: massimo in un array

Scrivere:

```c
int maximum(const int a[], int n);
```

Con:

```text
P-IN(a, n): lunghezza(a) >= n >= 1
P-OUT(a, n, r): r è il massimo in a[0..n-1]
```

Invariante suggerito:

```text
max è il massimo in a[0..i-1]
```

---

## Esercizio 2: indice della prima occorrenza del massimo

Scrivere:

```c
int findFirstMax(const int a[], int n);
```

Esempio:

```text
a = {3, 5, 5, 2}
```

Risultato:

```text
1
```

Invariante suggerito:

```text
iMax è l'indice della prima occorrenza del massimo in a[0..i-1]
```

Corpo del ciclo:

```c
if (a[iMax] < a[i]) {
    iMax = i;
}
```

Nota che qui uso `<`, non `<=`, perché voglio mantenere la prima occorrenza.

---

## Esercizio 3: indice dell’ultima occorrenza del massimo

Scrivere:

```c
int findLastMax(const int a[], int n);
```

Invariante suggerito:

```text
iMax è l'indice dell'ultima occorrenza del massimo in a[0..i-1]
```

Corpo del ciclo:

```c
if (a[iMax] <= a[i]) {
    iMax = i;
}
```

---

## Esercizio 4: minimo in un array

Scrivere:

```c
int minimum(const int a[], int n);
```

Invariante suggerito:

```text
min è il minimo in a[0..i-1]
```

Soluzione:

```c
int minimum(const int a[], int n) {
    int min = a[0];

    for (int i = 1; i < n; i++) {
        if (a[i] < min) {
            min = a[i];
        }
    }

    return min;
}
```

---

## Esercizio 5: somma degli elementi

Scrivere:

```c
int sumArray(const int a[], int n);
```

Con:

```text
P-IN(a, n): lunghezza(a) >= n >= 0
P-OUT(a, n, r): r è la somma degli elementi in a[0..n-1]
```

Invariante:

```text
sum è la somma degli elementi in a[0..i-1]
```

Soluzione:

```c
int sumArray(const int a[], int n) {
    int sum = 0;

    /*
     * I.C.:
     * sum è la somma degli elementi in a[0..i-1].
     *
     * Quando i = 0, la porzione a[0..-1] è vuota.
     * La somma della porzione vuota è 0.
     */
    for (int i = 0; i < n; i++) {
        sum += a[i];
    }

    return sum;
}
```

Questo esercizio è interessante perché l’inizializzazione è diversa:

```c
int sum = 0;
int i = 0;
```

Qui la porzione iniziale è vuota.

---

## Esercizio 6: verifica se un array contiene un valore

Scrivere:

```c
bool contains(const int a[], int n, int value);
```

Invariante possibile:

```text
found è true se value compare in a[0..i-1]
```

Soluzione:

```c
#include <stdbool.h>

bool contains(const int a[], int n, int value) {
    bool found = false;

    /*
     * I.C.:
     * found è true se e solo se value compare in a[0..i-1].
     */
    for (int i = 0; i < n && !found; i++) {
        if (a[i] == value) {
            found = true;
        }
    }

    return found;
}
```

---

# 24. Mini schema da usare all’esame

Quando ti chiedono di ragionare su un ciclo, puoi seguire questa scaletta.

```text
1. Scrivo P-IN.
2. Scrivo P-OUT.
3. Scelgo l'invariante di ciclo.
4. Dimostro che l'invariante è vero all'inizio.
5. Dimostro che il corpo preserva l'invariante.
6. Dimostro che all'uscita dal ciclo, invariante + condizione falsa implicano P-OUT.
7. Dimostro la terminazione.
```

---

# 25. Template mentale per array

Questo schema ricorre spesso:

```c
risultato = valore_iniziale;

for (int i = indice_iniziale; i < n; i++) {
    aggiorna risultato usando a[i];
}

return risultato;
```

La domanda fondamentale è:

```text
Che cosa rappresenta risultato rispetto alla porzione a[0..i-1]?
```

Se sai rispondere bene a questa domanda, spesso hai trovato l’invariante.

---

# 26. Riassunto finale

La lezione insegna che i cicli non vanno scritti “a intuito”, soprattutto quando sono non banali.

Il modo corretto di ragionare è:

```text
specifica -> invariante -> corpo -> condizione -> inizializzazione -> terminazione
```

La correttezza totale richiede:

```text
correttezza parziale + terminazione
```

L’invariante è la proprietà che collega il codice alla specifica.

Nel caso del massimo:

```text
max è il massimo in a[0..i-1]
```

Nel caso dell’ultima occorrenza del massimo:

```text
iMax è l'indice dell'ultima occorrenza del massimo in a[0..i-1]
```

La differenza tra:

```c
<
```

e:

```c
<=
```

è fondamentale:

* `<` mantiene la prima occorrenza del massimo;
* `<=` aggiorna anche in caso di uguaglianza e quindi trova l’ultima occorrenza.

---

# 27. Da ricordare assolutamente

> Un test può convincerti che il programma funziona su alcuni casi.
> Un invariante ti permette di dimostrare perché funziona in generale.

> La condizione del ciclo decide quando fermarsi.
> L’invariante spiega cosa hai costruito fino a quel momento.

> Per prendere 30 e lode non basta saper scrivere il ciclo: bisogna saper spiegare perché è corretto.
