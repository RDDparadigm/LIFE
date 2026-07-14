# Programmazione 2 — Esercizi di ricorsione generale

> Raccolta progressiva in stile esame: consegna, struttura di partenza, soluzione semplice, eventuale soluzione ottimizzata, complessità, casi limite, invarianti ed errori tipici.
>
> Sono volutamente esclusi gli esercizi centrati su **liste linkate** e **alberi**, trattati in raccolte separate. Qui la ricorsione viene allenata su:
>
> - numeri;
> - array;
> - stringhe;
> - intervalli;
> - divide et impera;
> - backtracking;
> - memoizzazione;
> - memoria dinamica.

Compilazione consigliata:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    -g -fsanitize=address,undefined file.c -o file
```

---

# 0. Prima di iniziare: come si progetta una funzione ricorsiva

Una funzione ricorsiva corretta deve rispondere sempre a quattro domande.

## 0.1 Qual è il caso base?

È il problema che può essere risolto direttamente, senza un'altra chiamata ricorsiva.

Esempi:

```text
n == 0
lunghezza == 0
left >= right
stringa terminata
intervallo vuoto
soluzione completa
```

## 0.2 Qual è il problema più piccolo?

Ogni chiamata deve avvicinarsi al caso base.

Esempi:

```text
n        → n - 1
[0, n)   → [1, n)
[left,right] → una metà più piccola
indice   → indice + 1
numero di posizioni libere → una in meno
```

Una funzione che richiama se stessa con gli stessi argomenti, o con un problema non necessariamente più piccolo, può non terminare.

## 0.3 Cosa assumo che faccia correttamente la chiamata ricorsiva?

Non devi simulare contemporaneamente tutte le chiamate mentre scrivi il codice.

Devi ragionare così:

> Suppongo che la funzione sappia già risolvere correttamente il problema più piccolo. Come uso quel risultato per risolvere il problema corrente?

Esempio:

```c
int sum(const int a[], size_t n) {
    if (n == 0) {
        return 0;
    }

    return a[0] + sum(a + 1, n - 1);
}
```

Assunzione induttiva:

```text
sum(a + 1, n - 1)
```

restituisce la somma degli elementi da `a[1]` ad `a[n-1]`.

Quindi basta aggiungere `a[0]`.

## 0.4 Cosa accade prima e dopo la chiamata ricorsiva?

### Elaborazione prima della chiamata

```c
printf("%d ", n);
printDown(n - 1);
```

Stampa:

```text
n, n-1, ..., 1
```

### Elaborazione dopo la chiamata

```c
printUp(n - 1);
printf("%d ", n);
```

Stampa:

```text
1, 2, ..., n
```

L'ordine delle istruzioni rispetto alla chiamata ricorsiva cambia il risultato.

---

# 1. Ricorsione di coda, non di coda e stack

## 1.1 Ricorsione non di coda

Dopo il ritorno della chiamata ricorsiva resta ancora un'operazione da eseguire.

```c
unsigned long long factorial(unsigned int n) {
    if (n <= 1) {
        return 1;
    }

    return n * factorial(n - 1);
}
```

La moltiplicazione viene completata durante la risalita delle chiamate.

## 1.2 Ricorsione di coda

La chiamata ricorsiva è l'ultima operazione della funzione.

```c
static unsigned long long factorialTailAux(
    unsigned int n,
    unsigned long long accumulator
) {
    if (n <= 1) {
        return accumulator;
    }

    return factorialTailAux(n - 1, accumulator * n);
}

unsigned long long factorialTail(unsigned int n) {
    return factorialTailAux(n, 1);
}
```

Il risultato parziale viene trasportato in un accumulatore.

> In C non è garantito che il compilatore elimini i record di attivazione delle chiamate di coda. Una funzione tail-recursive non deve essere considerata automaticamente equivalente a un ciclo per consumo di stack.

## 1.3 Complessità spaziale

Una ricorsione lineare di profondità `n` usa normalmente:

```text
tempo:  O(n)
stack:  O(n)
```

Anche quando non viene allocata memoria sullo heap.

## 1.4 Checklist di terminazione

Prima di compilare, verifica:

- [ ] esiste almeno un caso base raggiungibile;
- [ ] ogni chiamata riduce davvero il problema;
- [ ] non si usa un indice unsigned che va in underflow;
- [ ] non si salta oltre i limiti di un array;
- [ ] il caso vuoto è coerente con la specifica;
- [ ] non si genera una profondità ingestibile per input realistici.

---

# Livello 1 — Ricorsione su numeri

---

## Esercizio 1 — Somma dei primi n naturali

### Consegna

Dato un intero non negativo `n`, restituire:

```text
0 + 1 + 2 + ... + n
```

Si assume che il risultato rientri in `unsigned long long`.

### Struttura di partenza

```c
unsigned long long sumTo(unsigned int n);
```

### Soluzione semplice

```c
unsigned long long sumTo(unsigned int n) {
    if (n == 0) {
        return 0;
    }

    return n + sumTo(n - 1);
}
```

### Soluzione ricorsiva di coda

```c
static unsigned long long sumToAux(
    unsigned int n,
    unsigned long long accumulator
) {
    if (n == 0) {
        return accumulator;
    }

    return sumToAux(n - 1, accumulator + n);
}

unsigned long long sumToTail(unsigned int n) {
    return sumToAux(n, 0);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(n)` salvo ottimizzazioni non garantite

### Osservazione

La formula:

```text
n(n+1)/2
```

risolve il problema in `O(1)`, ma l'obiettivo qui è allenare il modello ricorsivo.

---

## Esercizio 2 — Fattoriale con controllo del dominio

### Consegna

Calcolare `n!` per `n >= 0`.

La funzione riceve un `int` e deve restituire `0` se `n < 0`.

Si assume che per gli input validi il risultato rientri in `unsigned long long`.

### Struttura di partenza

```c
unsigned long long factorialChecked(int n);
```

### Soluzione semplice

```c
unsigned long long factorialChecked(int n) {
    if (n < 0) {
        return 0;
    }

    if (n <= 1) {
        return 1;
    }

    return (unsigned long long)n * factorialChecked(n - 1);
}
```

### Errori tipici

- caso base solo `n == 1`, che non gestisce `0!`;
- chiamata con `n - 1` quando `n` è unsigned e il dominio non è controllato;
- confondere l'errore `0` con un risultato valido: qui è accettabile soltanto perché nessun fattoriale valido vale zero.

---

## Esercizio 3 — Potenza intera lineare

### Consegna

Calcolare `base^exponent` per `exponent >= 0`.

Si assume che il risultato rientri in `long long`.

### Struttura di partenza

```c
long long powerLinear(long long base, unsigned int exponent);
```

### Soluzione semplice

```c
long long powerLinear(long long base, unsigned int exponent) {
    if (exponent == 0) {
        return 1;
    }

    return base * powerLinear(base, exponent - 1);
}
```

### Complessità

- Tempo: `O(exponent)`
- Stack: `O(exponent)`

### Caso importante

```text
0^0
```

Questa implementazione restituisce `1`, seguendo la convenzione spesso usata in programmazione combinatoria. La specifica dell'esame deve chiarire il comportamento desiderato.

---

## Esercizio 4 — Potenza veloce

### Consegna

Calcolare `base^exponent` usando una profondità ricorsiva logaritmica.

Identità:

```text
base^(2k)   = (base^k)^2
base^(2k+1) = base * (base^k)^2
```

### Struttura di partenza

```c
long long fastPower(long long base, unsigned int exponent);
```

### Soluzione ottimizzata

```c
long long fastPower(long long base, unsigned int exponent) {
    if (exponent == 0) {
        return 1;
    }

    long long half = fastPower(base, exponent / 2);
    long long square = half * half;

    if (exponent % 2 == 0) {
        return square;
    }

    return base * square;
}
```

### Complessità

- Tempo: `O(log exponent)`
- Stack: `O(log exponent)`

### Trappola infernale

Questa versione è sbagliata:

```c
return fastPower(base, exponent / 2) *
       fastPower(base, exponent / 2);
```

La stessa sottopotenza viene ricalcolata due volte e il tempo torna lineare rispetto all'esponente.

---

## Esercizio 5 — Massimo comune divisore

### Consegna

Calcolare il massimo comune divisore di due interi non negativi usando l'algoritmo di Euclide.

```text
MCD(a, 0) = a
MCD(a, b) = MCD(b, a % b)
```

### Struttura di partenza

```c
unsigned int gcd(unsigned int a, unsigned int b);
```

### Soluzione

```c
unsigned int gcd(unsigned int a, unsigned int b) {
    if (b == 0) {
        return a;
    }

    return gcd(b, a % b);
}
```

### Complessità

- Tempo: `O(log min(a,b))`
- Stack: `O(log min(a,b))`

### Casi limite

```text
gcd(0, 0) → 0 con questa convenzione
gcd(a, 0) → a
gcd(0, b) → b
```

---

## Esercizio 6 — Conta le cifre decimali

### Consegna

Dato un intero non negativo, restituire il numero di cifre decimali.

Esempi:

```text
0      → 1
7      → 1
12345  → 5
```

### Struttura di partenza

```c
unsigned int digitCount(unsigned long long n);
```

### Soluzione semplice

```c
unsigned int digitCount(unsigned long long n) {
    if (n < 10) {
        return 1;
    }

    return 1 + digitCount(n / 10);
}
```

### Complessità

- Tempo: `O(numero di cifre)`
- Stack: `O(numero di cifre)`

---

## Esercizio 7 — Somma delle cifre

### Consegna

Dato un intero non negativo, restituire la somma delle sue cifre.

```text
50231 → 11
```

### Struttura di partenza

```c
unsigned int digitSum(unsigned long long n);
```

### Soluzione semplice

```c
unsigned int digitSum(unsigned long long n) {
    if (n < 10) {
        return (unsigned int)n;
    }

    return (unsigned int)(n % 10) + digitSum(n / 10);
}
```

### Variante di coda

```c
static unsigned int digitSumAux(
    unsigned long long n,
    unsigned int accumulator
) {
    if (n == 0) {
        return accumulator;
    }

    return digitSumAux(
        n / 10,
        accumulator + (unsigned int)(n % 10)
    );
}

unsigned int digitSumTail(unsigned long long n) {
    return digitSumAux(n, 0);
}
```

---

## Esercizio 8 — Numero palindromo senza conversione in stringa

### Consegna

Verificare ricorsivamente se un intero non negativo è palindromo in base 10.

Esempi:

```text
0      → vero
7      → vero
1221   → vero
1231   → falso
```

### Struttura di partenza

```c
_Bool isNumberPalindrome(unsigned long long n);
```

### Soluzione semplice con costruzione dell'inverso

```c
static unsigned long long reverseNumberAux(
    unsigned long long n,
    unsigned long long reversed
) {
    if (n == 0) {
        return reversed;
    }

    return reverseNumberAux(
        n / 10,
        reversed * 10 + n % 10
    );
}

_Bool isNumberPalindrome(unsigned long long n) {
    return n == reverseNumberAux(n, 0);
}
```

### Complessità

- Tempo: `O(numero di cifre)`
- Stack: `O(numero di cifre)`

### Limite

Il numero invertito può causare overflow anche se l'input è valido. In un esercizio rigoroso, la specifica deve escludere questo caso oppure richiedere una soluzione che confronti le cifre esterne senza costruire l'intero invertito.

---

## Esercizio 9 — Conversione ricorsiva in binario

### Consegna

Dato un intero non negativo `n`, restituire una nuova stringa contenente la sua rappresentazione binaria senza zeri iniziali.

Esempi:

```text
0  → "0"
5  → "101"
10 → "1010"
```

### Struttura di partenza

```c
char *toBinary(unsigned int n);
```

### Soluzione semplice

```c
#include <stdlib.h>

static size_t binaryLength(unsigned int n) {
    if (n < 2) {
        return 1;
    }

    return 1 + binaryLength(n / 2);
}

static void fillBinary(
    unsigned int n,
    char result[],
    size_t index
) {
    if (n >= 2) {
        fillBinary(n / 2, result, index - 1);
    }

    result[index] = (char)('0' + n % 2);
}

char *toBinary(unsigned int n) {
    size_t length = binaryLength(n);
    char *result = malloc(length + 1);

    if (result == NULL) {
        return NULL;
    }

    fillBinary(n, result, length - 1);
    result[length] = '\0';
    return result;
}
```

### Complessità

- Tempo: `O(log n)`
- Stack: `O(log n)`
- Heap: `O(log n)` per l'output

### Punto delicato

La chiamata ricorsiva scrive prima le cifre più significative. Scrivendo il resto prima della chiamata si otterrebbe l'ordine inverso.

---

# Livello 2 — Ricorsione lineare su array

---

## Esercizio 10 — Somma di un array

### Consegna

Restituire la somma degli elementi di un array.

Per `n == 0`, restituire `0`.

### Struttura di partenza

```c
long long arraySum(const int a[], size_t n);
```

### Soluzione semplice sul primo elemento

```c
long long arraySum(const int a[], size_t n) {
    if (n == 0) {
        return 0;
    }

    return a[0] + arraySum(a + 1, n - 1);
}
```

### Soluzione equivalente sull'ultimo elemento

```c
long long arraySumLast(const int a[], size_t n) {
    if (n == 0) {
        return 0;
    }

    return a[n - 1] + arraySumLast(a, n - 1);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(n)`

### Scelta tra le due forme

- `a + 1, n - 1`: il problema più piccolo è il suffisso;
- `a, n - 1`: il problema più piccolo è il prefisso.

Entrambe sono corrette. La forma migliore dipende da ciò che deve essere restituito.

---

## Esercizio 11 — Massimo di un array non vuoto

### Consegna

Dato un array non vuoto, restituire il massimo.

### Struttura di partenza

```c
int recursiveMax(const int a[], size_t n);
```

Si assume `n >= 1`.

### Soluzione semplice

```c
int recursiveMax(const int a[], size_t n) {
    if (n == 1) {
        return a[0];
    }

    int maxRest = recursiveMax(a + 1, n - 1);

    if (a[0] > maxRest) {
        return a[0];
    }

    return maxRest;
}
```

### Errore tipico

Usare `0` come massimo del caso vuoto rende sbagliato il risultato per array contenenti soltanto valori negativi.

---

## Esercizio 12 — Conta elementi che soddisfano una proprietà

### Consegna

Dato un array, contare ricorsivamente quanti elementi sono pari.

### Struttura di partenza

```c
size_t countEven(const int a[], size_t n);
```

### Soluzione semplice

```c
size_t countEven(const int a[], size_t n) {
    if (n == 0) {
        return 0;
    }

    size_t contribution = a[0] % 2 == 0 ? 1U : 0U;

    return contribution + countEven(a + 1, n - 1);
}
```

### Generalizzazione con predicato

```c
typedef _Bool (*IntPredicate)(int);

size_t countIf(
    const int a[],
    size_t n,
    IntPredicate predicate
) {
    if (n == 0 || predicate == NULL) {
        return 0;
    }

    size_t contribution = predicate(a[0]) ? 1U : 0U;

    return contribution +
           countIf(a + 1, n - 1, predicate);
}
```

---

## Esercizio 13 — Prima occorrenza

### Consegna

Restituire l'indice della prima occorrenza di `value` nell'array, oppure `n` se il valore è assente.

### Struttura di partenza

```c
size_t firstIndexOf(
    const int a[],
    size_t n,
    int value
);
```

### Soluzione semplice con helper

```c
static size_t firstIndexAux(
    const int a[],
    size_t n,
    int value,
    size_t index
) {
    if (index == n) {
        return n;
    }

    if (a[index] == value) {
        return index;
    }

    return firstIndexAux(a, n, value, index + 1);
}

size_t firstIndexOf(
    const int a[],
    size_t n,
    int value
) {
    return firstIndexAux(a, n, value, 0);
}
```

### Variante senza indice esplicito

```c
size_t firstIndexOffset(
    const int a[],
    size_t n,
    int value
) {
    if (n == 0) {
        return 0;
    }

    if (a[0] == value) {
        return 0;
    }

    size_t indexInSuffix =
        firstIndexOffset(a + 1, n - 1, value);

    if (indexInSuffix == n - 1) {
        return n;
    }

    return 1 + indexInSuffix;
}
```

La seconda forma è più elegante ma più facile da sbagliare. In sede d'esame, l'helper con indice è spesso più sicuro.

---

## Esercizio 14 — Ultima occorrenza

### Consegna

Restituire l'indice dell'ultima occorrenza di `value`, oppure `n` se assente.

### Struttura di partenza

```c
size_t lastIndexOf(
    const int a[],
    size_t n,
    int value
);
```

### Soluzione semplice

```c
size_t lastIndexOf(
    const int a[],
    size_t n,
    int value
) {
    if (n == 0) {
        return 0;
    }

    if (a[n - 1] == value) {
        return n - 1;
    }

    size_t result = lastIndexOf(a, n - 1, value);

    if (result == n - 1) {
        return n;
    }

    return result;
}
```

### Soluzione più leggibile con helper e `ptrdiff_t`

```c
#include <stddef.h>

static ptrdiff_t lastIndexAux(
    const int a[],
    int value,
    ptrdiff_t index
) {
    if (index < 0) {
        return -1;
    }

    if (a[index] == value) {
        return index;
    }

    return lastIndexAux(a, value, index - 1);
}

ptrdiff_t lastIndexSigned(
    const int a[],
    size_t n,
    int value
) {
    return lastIndexAux(
        a,
        value,
        (ptrdiff_t)n - 1
    );
}
```

### Punto didattico

Un indice signed rende naturale il valore sentinella `-1`, ma bisogna essere certi che `n` sia rappresentabile in `ptrdiff_t`.

---

## Esercizio 15 — Verifica che un array sia ordinato

### Consegna

Restituire vero se l'array è ordinato in modo non decrescente.

Gli array vuoti e di un solo elemento sono considerati ordinati.

### Struttura di partenza

```c
_Bool isSorted(const int a[], size_t n);
```

### Soluzione semplice

```c
_Bool isSorted(const int a[], size_t n) {
    if (n < 2) {
        return 1;
    }

    if (a[0] > a[1]) {
        return 0;
    }

    return isSorted(a + 1, n - 1);
}
```

### Complessità

- Migliore: `O(1)` se la prima coppia è fuori ordine
- Peggiore: `O(n)`
- Stack: `O(n)`

---

## Esercizio 16 — Palindromo su array

### Consegna

Verificare se un array è palindromo.

Esempi:

```text
[]            → vero
[7]           → vero
[1,2,2,1]     → vero
[1,2,3]       → falso
```

### Struttura di partenza

```c
_Bool isArrayPalindrome(const int a[], size_t n);
```

### Soluzione semplice con intervallo semiaperto

```c
static _Bool palindromeRange(
    const int a[],
    size_t left,
    size_t right
) {
    if (right - left < 2) {
        return 1;
    }

    if (a[left] != a[right - 1]) {
        return 0;
    }

    return palindromeRange(a, left + 1, right - 1);
}

_Bool isArrayPalindrome(const int a[], size_t n) {
    return palindromeRange(a, 0, n);
}
```

### Perché usare `[left, right)`

Evita di dover rappresentare `-1` con `size_t`.

---

## Esercizio 17 — Inversione in place

### Consegna

Invertire ricorsivamente un array in place.

### Struttura di partenza

```c
void reverseArray(int a[], size_t n);
```

### Soluzione semplice

```c
static void reverseRangeRecursive(
    int a[],
    size_t left,
    size_t right
) {
    if (right - left < 2) {
        return;
    }

    int tmp = a[left];
    a[left] = a[right - 1];
    a[right - 1] = tmp;

    reverseRangeRecursive(a, left + 1, right - 1);
}

void reverseArray(int a[], size_t n) {
    reverseRangeRecursive(a, 0, n);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(n)`
- Heap: `O(1)`

---

## Esercizio 18 — Numero di cambi di valore

### Consegna

Dato un array, contare quante volte due elementi consecutivi sono diversi.

Esempio:

```text
[1,1,3,3,2,2,2,5] → 3
```

I cambi sono:

```text
1→3, 3→2, 2→5
```

### Struttura di partenza

```c
size_t countTransitions(const int a[], size_t n);
```

### Soluzione semplice

```c
size_t countTransitions(const int a[], size_t n) {
    if (n < 2) {
        return 0;
    }

    size_t current = a[0] != a[1] ? 1U : 0U;

    return current +
           countTransitions(a + 1, n - 1);
}
```

---

## Esercizio 19 — Filtra in un array di output preallocato

### Consegna

Copiare ricorsivamente in `out` tutti gli elementi positivi di `a`, preservandone l'ordine.

Si assume che `out` abbia capacità almeno `n`.

Restituire il numero di elementi scritti.

### Struttura di partenza

```c
size_t copyPositiveRecursive(
    const int a[],
    size_t n,
    int out[]
);
```

### Soluzione semplice

```c
size_t copyPositiveRecursive(
    const int a[],
    size_t n,
    int out[]
) {
    if (n == 0) {
        return 0;
    }

    if (a[0] > 0) {
        out[0] = a[0];

        return 1 + copyPositiveRecursive(
            a + 1,
            n - 1,
            out + 1
        );
    }

    return copyPositiveRecursive(
        a + 1,
        n - 1,
        out
    );
}
```

### Invariante

`out` punta sempre alla prima cella ancora libera.

### Complessità

- Tempo: `O(n)`
- Stack: `O(n)`
- Spazio output: `O(k)`

---

## Esercizio 20 — Filtro dinamico ricorsivo

### Consegna

Restituire un nuovo array contenente tutti i valori dispari dell'input, nello stesso ordine.

### Struttura di partenza

```c
typedef struct {
    int *data;
    size_t size;
} IntArray;

IntArray copyOddRecursive(const int a[], size_t n);
```

### Soluzione semplice in due fasi ricorsive

```c
#include <stdlib.h>

static size_t countOddRecursive(
    const int a[],
    size_t n
) {
    if (n == 0) {
        return 0;
    }

    size_t current = a[0] % 2 != 0 ? 1U : 0U;

    return current +
           countOddRecursive(a + 1, n - 1);
}

static void fillOddRecursive(
    const int a[],
    size_t n,
    int out[],
    size_t *write
) {
    if (n == 0) {
        return;
    }

    if (a[0] % 2 != 0) {
        out[*write] = a[0];
        (*write)++;
    }

    fillOddRecursive(a + 1, n - 1, out, write);
}

IntArray copyOddRecursive(const int a[], size_t n) {
    IntArray result = {NULL, 0};

    size_t count = countOddRecursive(a, n);

    if (count == 0) {
        return result;
    }

    result.data = malloc(count * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    size_t write = 0;
    fillOddRecursive(a, n, result.data, &write);

    result.size = count;
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(n)`
- Heap: `O(k)`

### Perché non fare un `realloc` a ogni elemento

Una riallocazione ripetuta può introdurre copie quadratiche e rende più complessa la gestione degli errori.

---

# Livello 3 — Stringhe ricorsive

---

## Esercizio 21 — Lunghezza di una stringa

### Consegna

Implementare ricorsivamente l'equivalente di `strlen`.

Si assume `s != NULL`.

### Struttura di partenza

```c
size_t recursiveStrlen(const char *s);
```

### Soluzione

```c
size_t recursiveStrlen(const char *s) {
    if (*s == '\0') {
        return 0;
    }

    return 1 + recursiveStrlen(s + 1);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(n)`

---

## Esercizio 22 — Confronto lessicografico

### Consegna

Implementare ricorsivamente una funzione che restituisca:

- un valore negativo se `a < b`;
- zero se `a == b`;
- un valore positivo se `a > b`.

Il confronto deve usare i valori come `unsigned char`, come avviene concettualmente in `strcmp`.

### Struttura di partenza

```c
int recursiveStrcmp(const char *a, const char *b);
```

### Soluzione

```c
int recursiveStrcmp(const char *a, const char *b) {
    unsigned char ca = (unsigned char)*a;
    unsigned char cb = (unsigned char)*b;

    if (ca != cb || ca == '\0') {
        return (int)ca - (int)cb;
    }

    return recursiveStrcmp(a + 1, b + 1);
}
```

### Casi limite

```text
"" vs ""
"" vs "a"
"a" vs ""
"abc" vs "abd"
"abc" vs "abc"
```

---

## Esercizio 23 — Palindromo ignorando maiuscole e caratteri non alfabetici

### Consegna

Verificare se una stringa è palindroma considerando soltanto i caratteri alfabetici ASCII e ignorando la differenza tra maiuscole e minuscole.

Esempio:

```text
"A man, a plan, a canal: Panama!" → vero
```

### Struttura di partenza

```c
_Bool isTextPalindrome(const char *s);
```

### Soluzione semplice

```c
#include <string.h>

static _Bool isAsciiLetter(char c) {
    return (c >= 'A' && c <= 'Z') ||
           (c >= 'a' && c <= 'z');
}

static char asciiLower(char c) {
    if (c >= 'A' && c <= 'Z') {
        return (char)(c - 'A' + 'a');
    }

    return c;
}

static _Bool textPalindromeRange(
    const char *s,
    size_t left,
    size_t right
) {
    while (left < right &&
           !isAsciiLetter(s[left])) {
        left++;
    }

    while (left < right &&
           !isAsciiLetter(s[right - 1])) {
        right--;
    }

    if (right - left < 2) {
        return 1;
    }

    if (asciiLower(s[left]) !=
        asciiLower(s[right - 1])) {
        return 0;
    }

    return textPalindromeRange(
        s,
        left + 1,
        right - 1
    );
}

_Bool isTextPalindrome(const char *s) {
    if (s == NULL) {
        return 0;
    }

    return textPalindromeRange(s, 0, strlen(s));
}
```

### Nota

I piccoli `while` evitano una chiamata ricorsiva per ogni carattere ignorato. Una versione completamente ricorsiva è possibile, ma non è automaticamente più chiara.

---

## Esercizio 24 — Conta le occorrenze di un carattere

### Consegna

Contare ricorsivamente quante volte il carattere `target` compare in una stringa.

### Struttura di partenza

```c
size_t recursiveCharCount(
    const char *s,
    char target
);
```

### Soluzione

```c
size_t recursiveCharCount(
    const char *s,
    char target
) {
    if (*s == '\0') {
        return 0;
    }

    size_t current = *s == target ? 1U : 0U;

    return current +
           recursiveCharCount(s + 1, target);
}
```

---

## Esercizio 25 — Rimuovi un carattere in place

### Consegna

Rimuovere ricorsivamente da una stringa modificabile tutte le occorrenze di `target`.

Esempio:

```text
"banana", 'a' → "bnn"
```

### Struttura di partenza

```c
void removeCharRecursive(char *s, char target);
```

### Soluzione semplice

```c
#include <string.h>

void removeCharRecursive(char *s, char target) {
    if (*s == '\0') {
        return;
    }

    if (*s == target) {
        memmove(s, s + 1, strlen(s));

        removeCharRecursive(s, target);
        return;
    }

    removeCharRecursive(s + 1, target);
}
```

### Complessità

Questa soluzione è semplice ma può costare:

- Tempo: `O(n²)`
- Stack: `O(n)`

perché ogni `memmove` sposta il suffisso.

### Soluzione ottimizzata con due puntatori ricorsivi

```c
static void removeCharAux(
    const char *read,
    char *write,
    char target
) {
    if (*read == '\0') {
        *write = '\0';
        return;
    }

    if (*read != target) {
        *write = *read;

        removeCharAux(
            read + 1,
            write + 1,
            target
        );
    } else {
        removeCharAux(
            read + 1,
            write,
            target
        );
    }
}

void removeCharRecursiveLinear(
    char *s,
    char target
) {
    removeCharAux(s, s, target);
}
```

### Complessità ottimizzata

- Tempo: `O(n)`
- Stack: `O(n)`
- Spazio aggiuntivo sullo heap: `O(1)`

---

## Esercizio 26 — Copia filtrata dinamica

### Consegna

Data una stringa, restituire una nuova stringa contenente soltanto le cifre decimali, nello stesso ordine.

Esempio:

```text
"a1b02Z9" → "1029"
```

### Struttura di partenza

```c
char *copyDigitsRecursive(const char *s);
```

### Soluzione semplice in due passaggi

```c
#include <stdlib.h>

static size_t countDigitsRecursive(
    const char *s
) {
    if (*s == '\0') {
        return 0;
    }

    size_t current =
        *s >= '0' && *s <= '9' ? 1U : 0U;

    return current +
           countDigitsRecursive(s + 1);
}

static void fillDigitsRecursive(
    const char *s,
    char *out
) {
    if (*s == '\0') {
        *out = '\0';
        return;
    }

    if (*s >= '0' && *s <= '9') {
        *out = *s;
        fillDigitsRecursive(s + 1, out + 1);
    } else {
        fillDigitsRecursive(s + 1, out);
    }
}

char *copyDigitsRecursive(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t count = countDigitsRecursive(s);
    char *result = malloc(count + 1);

    if (result == NULL) {
        return NULL;
    }

    fillDigitsRecursive(s, result);
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(n)`
- Heap: `O(k + 1)`

---

## Esercizio 27 — Ricerca ricorsiva di una sottostringa

### Consegna

Restituire un puntatore alla prima occorrenza di `needle` dentro `haystack`, oppure `NULL` se assente.

Una stringa vuota compare all'inizio di qualunque stringa.

### Struttura di partenza

```c
const char *recursiveStrstr(
    const char *haystack,
    const char *needle
);
```

### Soluzione semplice

```c
static _Bool startsWith(
    const char *text,
    const char *prefix
) {
    if (*prefix == '\0') {
        return 1;
    }

    if (*text == '\0' || *text != *prefix) {
        return 0;
    }

    return startsWith(text + 1, prefix + 1);
}

const char *recursiveStrstr(
    const char *haystack,
    const char *needle
) {
    if (*needle == '\0') {
        return haystack;
    }

    if (*haystack == '\0') {
        return NULL;
    }

    if (startsWith(haystack, needle)) {
        return haystack;
    }

    return recursiveStrstr(haystack + 1, needle);
}
```

### Complessità

- Tempo peggiore: `O(nm)`
- Stack: fino a `O(n + m)` lungo le chiamate annidate

### Esempio difficile

```text
haystack = "aaaaaaaaab"
needle   = "aaaab"
```

La soluzione semplice ripete molti confronti. Algoritmi come KMP evitano il problema, ma sono normalmente fuori dal nucleo della ricorsione di base.

---

## Esercizio 28 — Espansione ricorsiva di una stringa compressa

### Consegna

La stringa di input contiene coppie:

```text
carattere non numerico + singola cifra da 1 a 9
```

Restituire la stringa espansa.

Esempio:

```text
"a3b2C1" → "aaabbC"
```

Si assume che l'input sia valido.

### Struttura di partenza

```c
char *decodeRleRecursive(const char *encoded);
```

### Soluzione semplice

```c
#include <stdlib.h>

static size_t decodedLength(const char *s) {
    if (*s == '\0') {
        return 0;
    }

    return (size_t)(s[1] - '0') +
           decodedLength(s + 2);
}

static char *fillRepeated(
    char *out,
    char c,
    unsigned int count
) {
    if (count == 0) {
        return out;
    }

    *out = c;
    return fillRepeated(out + 1, c, count - 1);
}

static char *decodeRleFill(
    const char *s,
    char *out
) {
    if (*s == '\0') {
        *out = '\0';
        return out;
    }

    unsigned int count =
        (unsigned int)(s[1] - '0');

    char *next =
        fillRepeated(out, s[0], count);

    return decodeRleFill(s + 2, next);
}

char *decodeRleRecursive(const char *encoded) {
    if (encoded == NULL) {
        return NULL;
    }

    size_t length = decodedLength(encoded);
    char *result = malloc(length + 1);

    if (result == NULL) {
        return NULL;
    }

    decodeRleFill(encoded, result);
    return result;
}
```

### Complessità

- Tempo: `O(lunghezza output)`
- Stack: `O(lunghezza input + massima ripetizione)`
- Heap: `O(lunghezza output)`

---

# Livello 4 — Divide et impera

---

## Esercizio 29 — Ricerca binaria ricorsiva

### Consegna

Dato un array ordinato in modo crescente, restituire l'indice di una qualunque occorrenza di `value`, oppure `n` se assente.

### Struttura di partenza

```c
size_t binarySearchRecursive(
    const int a[],
    size_t n,
    int value
);
```

### Soluzione con intervallo semiaperto

```c
static size_t binarySearchRange(
    const int a[],
    size_t left,
    size_t right,
    int value,
    size_t notFound
) {
    if (left >= right) {
        return notFound;
    }

    size_t middle = left + (right - left) / 2;

    if (a[middle] == value) {
        return middle;
    }

    if (value < a[middle]) {
        return binarySearchRange(
            a,
            left,
            middle,
            value,
            notFound
        );
    }

    return binarySearchRange(
        a,
        middle + 1,
        right,
        value,
        notFound
    );
}

size_t binarySearchRecursive(
    const int a[],
    size_t n,
    int value
) {
    return binarySearchRange(a, 0, n, value, n);
}
```

### Complessità

- Tempo: `O(log n)`
- Stack: `O(log n)`

### Perché il calcolo del centro è scritto così

```c
left + (right - left) / 2
```

evita l'overflow potenziale di:

```c
(left + right) / 2
```

---

## Esercizio 30 — Prima occorrenza in array ordinato

### Consegna

Dato un array ordinato non decrescente, restituire l'indice della prima occorrenza di `value`, oppure `n`.

Esempio:

```text
[1,2,2,2,7], value = 2 → 1
```

### Struttura di partenza

```c
size_t firstSortedOccurrence(
    const int a[],
    size_t n,
    int value
);
```

### Soluzione ottimizzata

```c
static size_t lowerBoundRecursive(
    const int a[],
    size_t left,
    size_t right,
    int value
) {
    if (left >= right) {
        return left;
    }

    size_t middle = left + (right - left) / 2;

    if (a[middle] < value) {
        return lowerBoundRecursive(
            a,
            middle + 1,
            right,
            value
        );
    }

    return lowerBoundRecursive(
        a,
        left,
        middle,
        value
    );
}

size_t firstSortedOccurrence(
    const int a[],
    size_t n,
    int value
) {
    size_t index =
        lowerBoundRecursive(a, 0, n, value);

    if (index < n && a[index] == value) {
        return index;
    }

    return n;
}
```

### Complessità

- Tempo: `O(log n)`
- Stack: `O(log n)`

### Trappola

Trovare una qualunque occorrenza e poi avanzare a sinistra linearmente può costare `O(n)`.

---

## Esercizio 31 — Somma divide et impera

### Consegna

Calcolare la somma di un array dividendo ricorsivamente l'intervallo in due metà.

### Struttura di partenza

```c
long long divideSum(const int a[], size_t n);
```

### Soluzione

```c
static long long divideSumRange(
    const int a[],
    size_t left,
    size_t right
) {
    if (left >= right) {
        return 0;
    }

    if (right - left == 1) {
        return a[left];
    }

    size_t middle = left + (right - left) / 2;

    return divideSumRange(a, left, middle) +
           divideSumRange(a, middle, right);
}

long long divideSum(const int a[], size_t n) {
    return divideSumRange(a, 0, n);
}
```

### Complessità

- Tempo: `O(n)`
- Stack: `O(log n)`

### Confronto con la ricorsione lineare

Entrambe impiegano `O(n)` tempo, ma:

- ricorsione lineare: profondità `O(n)`;
- divide et impera bilanciato: profondità `O(log n)`.

Il numero totale di chiamate resta lineare.

---

## Esercizio 32 — Merge sort

### Consegna

Ordinare un array in modo non decrescente usando merge sort.

### Struttura di partenza

```c
int mergeSort(int a[], size_t n);
```

Restituire `1` in caso di successo, `0` se l'allocazione fallisce.

### Soluzione

```c
#include <stdlib.h>

static void mergeRanges(
    int a[],
    int tmp[],
    size_t left,
    size_t middle,
    size_t right
) {
    size_t i = left;
    size_t j = middle;
    size_t k = left;

    while (i < middle && j < right) {
        if (a[i] <= a[j]) {
            tmp[k++] = a[i++];
        } else {
            tmp[k++] = a[j++];
        }
    }

    while (i < middle) {
        tmp[k++] = a[i++];
    }

    while (j < right) {
        tmp[k++] = a[j++];
    }

    for (size_t p = left; p < right; p++) {
        a[p] = tmp[p];
    }
}

static void mergeSortRange(
    int a[],
    int tmp[],
    size_t left,
    size_t right
) {
    if (right - left < 2) {
        return;
    }

    size_t middle = left + (right - left) / 2;

    mergeSortRange(a, tmp, left, middle);
    mergeSortRange(a, tmp, middle, right);

    mergeRanges(a, tmp, left, middle, right);
}

int mergeSort(int a[], size_t n) {
    if (n < 2) {
        return 1;
    }

    int *tmp = malloc(n * sizeof(*tmp));

    if (tmp == NULL) {
        return 0;
    }

    mergeSortRange(a, tmp, 0, n);
    free(tmp);

    return 1;
}
```

### Complessità

- Tempo: `O(n log n)`
- Heap: `O(n)`
- Stack: `O(log n)`

### Proprietà

La condizione:

```c
a[i] <= a[j]
```

rende il merge stabile: a parità di valore viene scelto prima l'elemento della metà sinistra.

---

## Esercizio 33 — Conta inversioni

### Consegna

Un'inversione è una coppia di indici `(i, j)` tale che:

```text
i < j e a[i] > a[j]
```

Restituire il numero di inversioni di un array.

Esempio:

```text
[2,4,1,3,5] → 3
```

Inversioni:

```text
(2,1), (4,1), (4,3)
```

### Struttura di partenza

```c
unsigned long long inversionCount(
    const int a[],
    size_t n
);
```

### Soluzione semplice `O(n²)`

```c
unsigned long long inversionCountQuadratic(
    const int a[],
    size_t n
) {
    unsigned long long count = 0;

    for (size_t i = 0; i < n; i++) {
        for (size_t j = i + 1; j < n; j++) {
            if (a[i] > a[j]) {
                count++;
            }
        }
    }

    return count;
}
```

### Soluzione ottimizzata con merge sort

```c
#include <stdlib.h>
#include <string.h>

static unsigned long long countMerge(
    int a[],
    int tmp[],
    size_t left,
    size_t middle,
    size_t right
) {
    size_t i = left;
    size_t j = middle;
    size_t k = left;
    unsigned long long count = 0;

    while (i < middle && j < right) {
        if (a[i] <= a[j]) {
            tmp[k++] = a[i++];
        } else {
            tmp[k++] = a[j++];

            count +=
                (unsigned long long)(middle - i);
        }
    }

    while (i < middle) {
        tmp[k++] = a[i++];
    }

    while (j < right) {
        tmp[k++] = a[j++];
    }

    for (size_t p = left; p < right; p++) {
        a[p] = tmp[p];
    }

    return count;
}

static unsigned long long countInversionsRange(
    int a[],
    int tmp[],
    size_t left,
    size_t right
) {
    if (right - left < 2) {
        return 0;
    }

    size_t middle = left + (right - left) / 2;

    unsigned long long leftCount =
        countInversionsRange(
            a, tmp, left, middle
        );

    unsigned long long rightCount =
        countInversionsRange(
            a, tmp, middle, right
        );

    unsigned long long crossCount =
        countMerge(
            a, tmp, left, middle, right
        );

    return leftCount + rightCount + crossCount;
}

unsigned long long inversionCount(
    const int a[],
    size_t n
) {
    if (n < 2) {
        return 0;
    }

    int *copy = malloc(n * sizeof(*copy));
    int *tmp = malloc(n * sizeof(*tmp));

    if (copy == NULL || tmp == NULL) {
        free(copy);
        free(tmp);
        return 0;
    }

    memcpy(copy, a, n * sizeof(*copy));

    unsigned long long result =
        countInversionsRange(copy, tmp, 0, n);

    free(copy);
    free(tmp);

    return result;
}
```

### Complessità

- Tempo: `O(n log n)`
- Heap: `O(n)`
- Stack: `O(log n)`

### Idea chiave

Quando durante il merge:

```text
a[i] > a[j]
```

allora `a[j]` è minore non soltanto di `a[i]`, ma di tutti gli elementi rimanenti della metà sinistra, perché quella metà è ordinata.

---

## Esercizio 34 — Quicksort ricorsivo

### Consegna

Ordinare un array in place con quicksort.

### Struttura di partenza

```c
void quickSort(int a[], size_t n);
```

### Soluzione semplice con intervalli signed

```c
#include <stddef.h>

static ptrdiff_t partition(
    int a[],
    ptrdiff_t left,
    ptrdiff_t right
) {
    int pivot = a[right];
    ptrdiff_t boundary = left;

    for (ptrdiff_t i = left; i < right; i++) {
        if (a[i] <= pivot) {
            int tmp = a[i];
            a[i] = a[boundary];
            a[boundary] = tmp;
            boundary++;
        }
    }

    int tmp = a[boundary];
    a[boundary] = a[right];
    a[right] = tmp;

    return boundary;
}

static void quickSortRange(
    int a[],
    ptrdiff_t left,
    ptrdiff_t right
) {
    if (left >= right) {
        return;
    }

    ptrdiff_t pivot =
        partition(a, left, right);

    quickSortRange(a, left, pivot - 1);
    quickSortRange(a, pivot + 1, right);
}

void quickSort(int a[], size_t n) {
    if (n < 2) {
        return;
    }

    quickSortRange(
        a,
        0,
        (ptrdiff_t)n - 1
    );
}
```

### Complessità

- Media: `O(n log n)`
- Peggiore: `O(n²)`
- Stack medio: `O(log n)`
- Stack peggiore: `O(n)`

### Quando si verifica il caso peggiore

Con pivot scelto sempre come ultimo elemento, array già ordinati o quasi ordinati possono produrre partizioni estremamente sbilanciate.

---

# Livello 5 — Ricorsione con scelta: backtracking

Il backtracking usa questo schema:

```c
void search(State *state) {
    if (soluzione_completa(state)) {
        usa_soluzione(state);
        return;
    }

    for (ogni scelta possibile) {
        applica_scelta(state);
        search(state);
        annulla_scelta(state);
    }
}
```

Le tre operazioni decisive sono:

```text
scegli
esplora
annulla
```

Se l'annullamento manca, i rami successivi partono da uno stato corrotto.

---

## Esercizio 35 — Conta stringhe binarie senza `11`

### Consegna

Contare quante stringhe binarie di lunghezza `n` non contengono due `1` consecutivi.

Esempi:

```text
n = 0 → 1   // stringa vuota
n = 1 → 2   // 0, 1
n = 2 → 3   // 00, 01, 10
```

### Struttura di partenza

```c
unsigned long long countBinaryNo11(
    unsigned int n
);
```

### Soluzione semplice di backtracking

```c
static unsigned long long countBinaryAux(
    unsigned int remaining,
    _Bool previousWasOne
) {
    if (remaining == 0) {
        return 1;
    }

    unsigned long long count =
        countBinaryAux(remaining - 1, 0);

    if (!previousWasOne) {
        count +=
            countBinaryAux(remaining - 1, 1);
    }

    return count;
}

unsigned long long countBinaryNo11(
    unsigned int n
) {
    return countBinaryAux(n, 0);
}
```

### Complessità

- Tempo esponenziale senza memoizzazione
- Stack: `O(n)`

### Soluzione ottimizzata per ricorrenza

Il numero soddisfa:

```text
f(0) = 1
f(1) = 2
f(n) = f(n-1) + f(n-2)
```

```c
static unsigned long long countBinaryRec(
    unsigned int n
) {
    if (n == 0) {
        return 1;
    }

    if (n == 1) {
        return 2;
    }

    return countBinaryRec(n - 1) +
           countBinaryRec(n - 2);
}
```

Anche questa versione è esponenziale senza memoizzazione; una soluzione iterativa o memoizzata è lineare.

---

## Esercizio 36 — Esistenza di un sottoinsieme con somma target

### Consegna

Dato un array di interi non negativi, verificare se esiste un sottoinsieme di elementi la cui somma sia esattamente `target`.

Ogni posizione può essere usata al massimo una volta.

### Struttura di partenza

```c
_Bool subsetSum(
    const unsigned int a[],
    size_t n,
    unsigned int target
);
```

### Soluzione semplice

```c
_Bool subsetSum(
    const unsigned int a[],
    size_t n,
    unsigned int target
) {
    if (target == 0) {
        return 1;
    }

    if (n == 0) {
        return 0;
    }

    if (a[0] > target) {
        return subsetSum(a + 1, n - 1, target);
    }

    if (subsetSum(
            a + 1,
            n - 1,
            target - a[0]
        )) {
        return 1;
    }

    return subsetSum(
        a + 1,
        n - 1,
        target
    );
}
```

### Albero delle scelte

Per ogni elemento:

```text
lo includo
oppure
non lo includo
```

### Complessità

- Tempo peggiore: `O(2^n)`
- Stack: `O(n)`

### Ottimizzazione

Con memoizzazione sullo stato `(index, target)`:

```text
tempo:  O(n * target)
spazio: O(n * target)
```

---

## Esercizio 37 — Conta i sottoinsiemi con somma target

### Consegna

Contare quanti sottoinsiemi di un array di interi non negativi hanno somma esattamente `target`.

Posizioni diverse sono considerate scelte diverse, anche se contengono lo stesso valore.

### Struttura di partenza

```c
unsigned long long countSubsetSum(
    const unsigned int a[],
    size_t n,
    unsigned int target
);
```

### Soluzione semplice

```c
unsigned long long countSubsetSum(
    const unsigned int a[],
    size_t n,
    unsigned int target
) {
    if (n == 0) {
        return target == 0 ? 1ULL : 0ULL;
    }

    unsigned long long without =
        countSubsetSum(a + 1, n - 1, target);

    unsigned long long with = 0;

    if (a[0] <= target) {
        with = countSubsetSum(
            a + 1,
            n - 1,
            target - a[0]
        );
    }

    return with + without;
}
```

### Trappola con gli zeri

Non fermarsi immediatamente quando `target == 0`.

Esempio:

```text
a = [0,0], target = 0
```

I sottoinsiemi validi sono quattro. Se la funzione restituisse subito `1`, perderebbe le scelte relative agli zeri.

---

## Esercizio 38 — Permutazioni: verifica dell'esistenza

### Consegna

Dati due array della stessa lunghezza, verificare ricorsivamente se il secondo è una permutazione del primo.

Non modificare gli input.

Gli elementi possono essere duplicati.

### Struttura di partenza

```c
_Bool isPermutationBacktracking(
    const int a[],
    const int b[],
    size_t n
);
```

### Soluzione semplice di backtracking

```c
#include <stdlib.h>

static _Bool matchPermutation(
    const int a[],
    const int b[],
    size_t n,
    size_t index,
    _Bool used[]
) {
    if (index == n) {
        return 1;
    }

    for (size_t j = 0; j < n; j++) {
        if (!used[j] && a[index] == b[j]) {
            used[j] = 1;

            if (matchPermutation(
                    a,
                    b,
                    n,
                    index + 1,
                    used
                )) {
                return 1;
            }

            used[j] = 0;
        }
    }

    return 0;
}

_Bool isPermutationBacktracking(
    const int a[],
    const int b[],
    size_t n
) {
    _Bool *used = calloc(n, sizeof(*used));

    if (used == NULL && n > 0) {
        return 0;
    }

    _Bool result =
        matchPermutation(a, b, n, 0, used);

    free(used);
    return result;
}
```

### Complessità

- Peggiore: `O(n!)`
- Heap: `O(n)`
- Stack: `O(n)`

### Soluzione realmente consigliata

Copiare e ordinare entrambi gli array:

```text
tempo: O(n log n)
spazio: O(n)
```

oppure usare una tabella di frequenza se il dominio è limitato.

Questo esercizio serve a capire che **la ricorsione non rende automaticamente buona una soluzione**.

---

## Esercizio 39 — Genera parentesi bilanciate

### Consegna

Generare tutte le sequenze valide formate da `n` coppie di parentesi.

La funzione deve invocare una callback per ogni sequenza prodotta.

Esempio per `n = 2`:

```text
(())
()()
```

### Struttura di partenza

```c
typedef void (*StringConsumer)(const char *);

int generateParentheses(
    unsigned int n,
    StringConsumer consume
);
```

Restituire `1` se l'allocazione riesce, `0` altrimenti.

### Soluzione

```c
#include <stdlib.h>

static void parenthesesAux(
    char buffer[],
    unsigned int n,
    unsigned int openUsed,
    unsigned int closeUsed,
    unsigned int index,
    StringConsumer consume
) {
    if (openUsed == n && closeUsed == n) {
        buffer[index] = '\0';
        consume(buffer);
        return;
    }

    if (openUsed < n) {
        buffer[index] = '(';

        parenthesesAux(
            buffer,
            n,
            openUsed + 1,
            closeUsed,
            index + 1,
            consume
        );
    }

    if (closeUsed < openUsed) {
        buffer[index] = ')';

        parenthesesAux(
            buffer,
            n,
            openUsed,
            closeUsed + 1,
            index + 1,
            consume
        );
    }
}

int generateParentheses(
    unsigned int n,
    StringConsumer consume
) {
    if (consume == NULL) {
        return 0;
    }

    char *buffer =
        malloc((2U * n + 1U) * sizeof(*buffer));

    if (buffer == NULL) {
        return 0;
    }

    parenthesesAux(
        buffer,
        n,
        0,
        0,
        0,
        consume
    );

    free(buffer);
    return 1;
}
```

### Regole di pruning

- si può aprire se `openUsed < n`;
- si può chiudere se `closeUsed < openUsed`.

Non vengono mai generate sequenze già invalide.

### Complessità

Il numero di soluzioni è il numero di Catalan:

```text
C_n = (1 / (n+1)) * binomiale(2n, n)
```

Il tempo è almeno proporzionale al numero totale di caratteri prodotti.

---

## Esercizio 40 — Cammino in una griglia con ostacoli

### Consegna

Data una griglia rettangolare di celle:

```text
0 = libera
1 = bloccata
```

verificare se esiste un cammino dalla cella `(0,0)` alla cella `(rows-1, cols-1)` muovendosi in alto, basso, sinistra o destra.

Non si può visitare due volte la stessa cella nello stesso cammino.

### Struttura di partenza

```c
_Bool gridPathExists(
    const int grid[],
    size_t rows,
    size_t cols
);
```

La cella `(r,c)` è:

```c
grid[r * cols + c]
```

### Soluzione semplice

```c
#include <stdlib.h>

static _Bool pathAux(
    const int grid[],
    size_t rows,
    size_t cols,
    ptrdiff_t row,
    ptrdiff_t col,
    _Bool visited[]
) {
    if (row < 0 || col < 0 ||
        row >= (ptrdiff_t)rows ||
        col >= (ptrdiff_t)cols) {
        return 0;
    }

    size_t index =
        (size_t)row * cols + (size_t)col;

    if (grid[index] != 0 || visited[index]) {
        return 0;
    }

    if ((size_t)row == rows - 1 &&
        (size_t)col == cols - 1) {
        return 1;
    }

    visited[index] = 1;

    _Bool found =
        pathAux(
            grid, rows, cols,
            row - 1, col, visited
        ) ||
        pathAux(
            grid, rows, cols,
            row + 1, col, visited
        ) ||
        pathAux(
            grid, rows, cols,
            row, col - 1, visited
        ) ||
        pathAux(
            grid, rows, cols,
            row, col + 1, visited
        );

    visited[index] = 0;
    return found;
}

_Bool gridPathExists(
    const int grid[],
    size_t rows,
    size_t cols
) {
    if (grid == NULL || rows == 0 || cols == 0) {
        return 0;
    }

    _Bool *visited =
        calloc(rows * cols, sizeof(*visited));

    if (visited == NULL) {
        return 0;
    }

    _Bool result =
        pathAux(
            grid,
            rows,
            cols,
            0,
            0,
            visited
        );

    free(visited);
    return result;
}
```

### Perché annullare `visited[index]`

La specifica vieta di visitare due volte una cella **nello stesso cammino**, ma permette a cammini alternativi di usare la stessa cella.

Se si volesse soltanto sapere quali celle sono raggiungibili, senza enumerare cammini semplici, si potrebbe non annullare la visita e ottenere una ricerca lineare nella dimensione della griglia.

---

## Esercizio 41 — Ricerca di una parola in una matrice

### Consegna

Data una matrice di caratteri e una parola, verificare se la parola può essere costruita partendo da una cella qualunque e muovendosi ortogonalmente.

Ogni cella può essere usata al massimo una volta nel cammino.

### Struttura di partenza

```c
_Bool wordExists(
    const char board[],
    size_t rows,
    size_t cols,
    const char *word
);
```

### Soluzione

```c
#include <stdlib.h>

static _Bool wordFrom(
    const char board[],
    size_t rows,
    size_t cols,
    const char *word,
    size_t wordIndex,
    ptrdiff_t row,
    ptrdiff_t col,
    _Bool used[]
) {
    if (word[wordIndex] == '\0') {
        return 1;
    }

    if (row < 0 || col < 0 ||
        row >= (ptrdiff_t)rows ||
        col >= (ptrdiff_t)cols) {
        return 0;
    }

    size_t index =
        (size_t)row * cols + (size_t)col;

    if (used[index] ||
        board[index] != word[wordIndex]) {
        return 0;
    }

    used[index] = 1;

    _Bool found =
        wordFrom(
            board, rows, cols,
            word, wordIndex + 1,
            row - 1, col, used
        ) ||
        wordFrom(
            board, rows, cols,
            word, wordIndex + 1,
            row + 1, col, used
        ) ||
        wordFrom(
            board, rows, cols,
            word, wordIndex + 1,
            row, col - 1, used
        ) ||
        wordFrom(
            board, rows, cols,
            word, wordIndex + 1,
            row, col + 1, used
        );

    used[index] = 0;
    return found;
}

_Bool wordExists(
    const char board[],
    size_t rows,
    size_t cols,
    const char *word
) {
    if (word == NULL) {
        return 0;
    }

    if (*word == '\0') {
        return 1;
    }

    if (board == NULL || rows == 0 || cols == 0) {
        return 0;
    }

    _Bool *used =
        calloc(rows * cols, sizeof(*used));

    if (used == NULL) {
        return 0;
    }

    for (size_t row = 0; row < rows; row++) {
        for (size_t col = 0; col < cols; col++) {
            if (wordFrom(
                    board,
                    rows,
                    cols,
                    word,
                    0,
                    (ptrdiff_t)row,
                    (ptrdiff_t)col,
                    used
                )) {
                free(used);
                return 1;
            }
        }
    }

    free(used);
    return 0;
}
```

### Complessità

Per parola di lunghezza `L`:

```text
O(rows * cols * 4^L)
```

come limite superiore grezzo, ridotto dal fatto che non si può tornare sulla cella appena usata.

---

# Livello 6 — Ricorsione esponenziale, memoizzazione e programmazione dinamica

---

## Esercizio 42 — Fibonacci: versione ingenua

### Consegna

Calcolare:

```text
F(0) = 0
F(1) = 1
F(n) = F(n-1) + F(n-2)
```

### Struttura di partenza

```c
unsigned long long fibonacci(
    unsigned int n
);
```

### Soluzione ingenua

```c
unsigned long long fibonacci(
    unsigned int n
) {
    if (n < 2) {
        return n;
    }

    return fibonacci(n - 1) +
           fibonacci(n - 2);
}
```

### Complessità

- Tempo: esponenziale, circa `O(φ^n)`
- Stack: `O(n)`

### Perché è inefficiente

Gli stessi sottoproblemi vengono ricalcolati molte volte.

Esempio:

```text
F(5)
├── F(4)
│   ├── F(3)
│   └── F(2)
└── F(3)   ← già calcolato
```

---

## Esercizio 43 — Fibonacci memoizzato

### Consegna

Ottimizzare Fibonacci memorizzando ogni risultato già calcolato.

### Struttura di partenza

```c
unsigned long long fibonacciMemo(
    unsigned int n
);
```

### Soluzione

```c
#include <stdlib.h>

static unsigned long long fibonacciMemoAux(
    unsigned int n,
    unsigned long long memo[],
    _Bool known[]
) {
    if (known[n]) {
        return memo[n];
    }

    memo[n] =
        fibonacciMemoAux(n - 1, memo, known) +
        fibonacciMemoAux(n - 2, memo, known);

    known[n] = 1;
    return memo[n];
}

unsigned long long fibonacciMemo(
    unsigned int n
) {
    unsigned long long *memo =
        calloc((size_t)n + 1, sizeof(*memo));

    _Bool *known =
        calloc((size_t)n + 1, sizeof(*known));

    if (memo == NULL || known == NULL) {
        free(memo);
        free(known);
        return 0;
    }

    known[0] = 1;
    memo[0] = 0;

    if (n >= 1) {
        known[1] = 1;
        memo[1] = 1;
    }

    unsigned long long result =
        fibonacciMemoAux(n, memo, known);

    free(memo);
    free(known);

    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Heap: `O(n)`
- Stack: `O(n)`

### Nota

Una soluzione iterativa usa:

```text
tempo O(n)
spazio O(1)
```

La memoizzazione è utile soprattutto quando lo spazio degli stati è più complesso e non è ovvio un ordine iterativo.

---

## Esercizio 44 — Numero di modi per salire una scala

### Consegna

Si può salire una scala facendo passi da `1`, `2` o `3` gradini.

Restituire il numero di sequenze diverse di passi che raggiungono esattamente il gradino `n`.

Esempi:

```text
n = 0 → 1
n = 1 → 1
n = 2 → 2
n = 3 → 4
```

### Struttura di partenza

```c
unsigned long long countStairWays(
    unsigned int n
);
```

### Soluzione semplice

```c
static unsigned long long stairWaysSigned(int n) {
    if (n == 0) {
        return 1;
    }

    if (n < 0) {
        return 0;
    }

    return stairWaysSigned(n - 1) +
           stairWaysSigned(n - 2) +
           stairWaysSigned(n - 3);
}

unsigned long long countStairWays(
    unsigned int n
) {
    return stairWaysSigned((int)n);
}
```

### Complessità

- Tempo esponenziale
- Stack `O(n)`

### Soluzione memoizzata

```c
#include <stdlib.h>

static unsigned long long stairMemoAux(
    unsigned int n,
    unsigned long long memo[],
    _Bool known[]
) {
    if (known[n]) {
        return memo[n];
    }

    unsigned long long result =
        stairMemoAux(n - 1, memo, known);

    if (n >= 2) {
        result += stairMemoAux(
            n - 2, memo, known
        );
    }

    if (n >= 3) {
        result += stairMemoAux(
            n - 3, memo, known
        );
    }

    memo[n] = result;
    known[n] = 1;
    return result;
}

unsigned long long countStairWaysMemo(
    unsigned int n
) {
    unsigned long long *memo =
        calloc((size_t)n + 1, sizeof(*memo));

    _Bool *known =
        calloc((size_t)n + 1, sizeof(*known));

    if (memo == NULL || known == NULL) {
        free(memo);
        free(known);
        return 0;
    }

    memo[0] = 1;
    known[0] = 1;

    unsigned long long result =
        stairMemoAux(n, memo, known);

    free(memo);
    free(known);

    return result;
}
```

---

## Esercizio 45 — Distanza di Levenshtein

### Consegna

Date due stringhe, calcolare il minimo numero di operazioni necessarie per trasformare la prima nella seconda.

Operazioni ammesse:

- inserimento;
- cancellazione;
- sostituzione.

Esempio:

```text
"kitten" → "sitting"
risultato = 3
```

### Struttura di partenza

```c
size_t editDistance(
    const char *a,
    const char *b
);
```

### Soluzione ricorsiva semplice

```c
static size_t min3(
    size_t x,
    size_t y,
    size_t z
) {
    size_t min = x < y ? x : y;
    return min < z ? min : z;
}

size_t editDistance(
    const char *a,
    const char *b
) {
    if (*a == '\0') {
        return recursiveStrlen(b);
    }

    if (*b == '\0') {
        return recursiveStrlen(a);
    }

    if (*a == *b) {
        return editDistance(a + 1, b + 1);
    }

    size_t deletion =
        editDistance(a + 1, b);

    size_t insertion =
        editDistance(a, b + 1);

    size_t replacement =
        editDistance(a + 1, b + 1);

    return 1 + min3(
        deletion,
        insertion,
        replacement
    );
}
```

### Complessità

La versione ingenua è esponenziale.

### Soluzione memoizzata

```c
#include <stdlib.h>
#include <string.h>

static size_t editMemoAux(
    const char *a,
    const char *b,
    size_t lenA,
    size_t lenB,
    size_t i,
    size_t j,
    size_t memo[],
    _Bool known[]
) {
    size_t cols = lenB + 1;
    size_t index = i * cols + j;

    if (known[index]) {
        return memo[index];
    }

    size_t result;

    if (i == lenA) {
        result = lenB - j;
    } else if (j == lenB) {
        result = lenA - i;
    } else if (a[i] == b[j]) {
        result = editMemoAux(
            a, b, lenA, lenB,
            i + 1, j + 1,
            memo, known
        );
    } else {
        size_t deletion =
            editMemoAux(
                a, b, lenA, lenB,
                i + 1, j,
                memo, known
            );

        size_t insertion =
            editMemoAux(
                a, b, lenA, lenB,
                i, j + 1,
                memo, known
            );

        size_t replacement =
            editMemoAux(
                a, b, lenA, lenB,
                i + 1, j + 1,
                memo, known
            );

        result = 1 + min3(
            deletion,
            insertion,
            replacement
        );
    }

    memo[index] = result;
    known[index] = 1;
    return result;
}

size_t editDistanceMemo(
    const char *a,
    const char *b
) {
    if (a == NULL || b == NULL) {
        return 0;
    }

    size_t lenA = strlen(a);
    size_t lenB = strlen(b);
    size_t cells = (lenA + 1) * (lenB + 1);

    size_t *memo =
        malloc(cells * sizeof(*memo));

    _Bool *known =
        calloc(cells, sizeof(*known));

    if (memo == NULL || known == NULL) {
        free(memo);
        free(known);
        return 0;
    }

    size_t result =
        editMemoAux(
            a, b,
            lenA, lenB,
            0, 0,
            memo, known
        );

    free(memo);
    free(known);

    return result;
}
```

### Complessità memoizzata

- Tempo: `O(|a| * |b|)`
- Heap: `O(|a| * |b|)`
- Stack: `O(|a| + |b|)`

---

# Livello 7 — Esercizi infernali

---

## Esercizio 46 — Espressione con operatori `+` e `*`

### Consegna

Dato un array di cifre positive, verificare se è possibile inserire tra cifre consecutive gli operatori `+` o `*` in modo da ottenere esattamente `target`.

Le operazioni vengono valutate da sinistra a destra, senza precedenza.

Esempio:

```text
digits = [2,3,4]
target = 20
```

è vero perché:

```text
(2 + 3) * 4 = 20
```

### Struttura di partenza

```c
_Bool canReachTarget(
    const unsigned int digits[],
    size_t n,
    unsigned long long target
);
```

### Soluzione semplice

```c
static _Bool expressionAux(
    const unsigned int digits[],
    size_t n,
    size_t index,
    unsigned long long current,
    unsigned long long target
) {
    if (index == n) {
        return current == target;
    }

    if (expressionAux(
            digits,
            n,
            index + 1,
            current + digits[index],
            target
        )) {
        return 1;
    }

    return expressionAux(
        digits,
        n,
        index + 1,
        current * digits[index],
        target
    );
}

_Bool canReachTarget(
    const unsigned int digits[],
    size_t n,
    unsigned long long target
) {
    if (n == 0) {
        return 0;
    }

    return expressionAux(
        digits,
        n,
        1,
        digits[0],
        target
    );
}
```

### Complessità

- Tempo: `O(2^(n-1))`
- Stack: `O(n)`

### Possibile pruning

Se tutti i valori sono positivi e le operazioni non possono diminuire il risultato, si potrebbe interrompere un ramo quando `current > target`.

Non è valido se sono ammessi zero, numeri negativi o altre operazioni.

---

## Esercizio 47 — Segmentazione di una stringa con dizionario

### Consegna

Dato un array di parole `dictionary` e una stringa `s`, verificare se `s` può essere segmentata in una sequenza di parole del dizionario.

Esempio:

```text
dictionary = ["leet", "code"]
s = "leetcode"
→ vero
```

### Struttura di partenza

```c
_Bool canSegment(
    const char *s,
    const char *const dictionary[],
    size_t wordCount
);
```

### Soluzione semplice

```c
#include <string.h>

static _Bool hasPrefixWord(
    const char *s,
    const char *word
) {
    size_t length = strlen(word);

    return strncmp(s, word, length) == 0;
}

_Bool canSegment(
    const char *s,
    const char *const dictionary[],
    size_t wordCount
) {
    if (*s == '\0') {
        return 1;
    }

    for (size_t i = 0; i < wordCount; i++) {
        const char *word = dictionary[i];

        if (word[0] != '\0' &&
            hasPrefixWord(s, word)) {
            if (canSegment(
                    s + strlen(word),
                    dictionary,
                    wordCount
                )) {
                return 1;
            }
        }
    }

    return 0;
}
```

### Complessità

Esponenziale nel caso peggiore, perché lo stesso suffisso può essere analizzato molte volte.

### Ottimizzazione

Memoizzare per ogni indice della stringa se il suffisso a partire da quell'indice è segmentabile:

```text
tempo tipico: O(n * wordCount * lunghezza parola)
spazio: O(n)
```

---

## Esercizio 48 — Numero minimo di monete

### Consegna

Dati tagli di monete positivi e un importo, restituire il numero minimo di monete necessario per formarlo.

Ogni taglio può essere usato un numero illimitato di volte.

Restituire `-1` se impossibile.

### Struttura di partenza

```c
int minimumCoins(
    const unsigned int coins[],
    size_t coinCount,
    unsigned int amount
);
```

### Soluzione ricorsiva semplice

```c
#include <limits.h>

static int minimumCoinsAux(
    const unsigned int coins[],
    size_t coinCount,
    unsigned int amount
) {
    if (amount == 0) {
        return 0;
    }

    int best = INT_MAX;

    for (size_t i = 0; i < coinCount; i++) {
        if (coins[i] <= amount) {
            int rest = minimumCoinsAux(
                coins,
                coinCount,
                amount - coins[i]
            );

            if (rest >= 0 && rest < best - 1) {
                best = rest + 1;
            }
        }
    }

    return best == INT_MAX ? -1 : best;
}

int minimumCoins(
    const unsigned int coins[],
    size_t coinCount,
    unsigned int amount
) {
    return minimumCoinsAux(
        coins,
        coinCount,
        amount
    );
}
```

### Complessità

Esponenziale senza memoizzazione.

### Soluzione memoizzata

```c
#include <stdlib.h>

static int minimumCoinsMemoAux(
    const unsigned int coins[],
    size_t coinCount,
    unsigned int amount,
    int memo[],
    _Bool known[]
) {
    if (known[amount]) {
        return memo[amount];
    }

    int best = INT_MAX;

    for (size_t i = 0; i < coinCount; i++) {
        if (coins[i] <= amount) {
            int rest = minimumCoinsMemoAux(
                coins,
                coinCount,
                amount - coins[i],
                memo,
                known
            );

            if (rest >= 0 && rest < best - 1) {
                best = rest + 1;
            }
        }
    }

    memo[amount] =
        best == INT_MAX ? -1 : best;

    known[amount] = 1;
    return memo[amount];
}

int minimumCoinsMemo(
    const unsigned int coins[],
    size_t coinCount,
    unsigned int amount
) {
    int *memo =
        malloc(((size_t)amount + 1) * sizeof(*memo));

    _Bool *known =
        calloc((size_t)amount + 1, sizeof(*known));

    if (memo == NULL || known == NULL) {
        free(memo);
        free(known);
        return -1;
    }

    memo[0] = 0;
    known[0] = 1;

    int result =
        minimumCoinsMemoAux(
            coins,
            coinCount,
            amount,
            memo,
            known
        );

    free(memo);
    free(known);

    return result;
}
```

### Complessità memoizzata

- Tempo: `O(amount * coinCount)`
- Heap: `O(amount)`
- Stack: `O(amount / minCoin)` nel caso peggiore

---

# 8. Tracce aggiuntive senza soluzione completa

Queste tracce vanno affrontate senza consultare le soluzioni precedenti. Per ognuna, scrivere:

```text
caso base
misura che diminuisce
assunzione sulla chiamata ricorsiva
tempo
spazio di stack
casi limite
```

## Numeri

1. Calcolare il prodotto delle cifre, con `0 → 0`.
2. Contare quante cifre pari contiene un numero.
3. Verificare se le cifre sono ordinate da sinistra a destra.
4. Calcolare la radice digitale ricorsiva.
5. Convertire un numero da base 10 a una base tra 2 e 16.
6. Calcolare il coefficiente binomiale con ricorrenza di Pascal.
7. Moltiplicare due interi usando solo somma e ricorsione.
8. Calcolare `a mod b` usando soltanto sottrazioni.
9. Verificare se un numero è una potenza di due.
10. Calcolare il massimo valore ottenibile eliminando esattamente una cifra.

## Array

11. Restituire la seconda occorrenza di un valore.
12. Verificare se tutti gli elementi sono distinti.
13. Contare i blocchi massimali di valori uguali.
14. Copiare in output un array in ordine inverso.
15. Verificare se due array sono uguali ignorando una posizione.
16. Trovare la somma massima di un prefisso.
17. Trovare il minimo con divide et impera.
18. Restituire contemporaneamente minimo e massimo con una struct.
19. Contare gli zeri con ricorsione di coda.
20. Partizionare ricorsivamente in place valori negativi e non negativi.
21. Verificare se esistono due elementi con somma target.
22. Cercare un valore in una matrice riga per riga.
23. Calcolare la somma del bordo di una matrice.
24. Ruotare ricorsivamente una matrice quadrata di 90 gradi.
25. Implementare heapify ricorsivo.

## Stringhe

26. Implementare `strcpy` ricorsiva.
27. Implementare `strchr` ricorsiva.
28. Verificare se una stringa contiene soltanto cifre.
29. Eliminare duplicati consecutivi in place.
30. Comprimere spazi consecutivi in place.
31. Contare le parole ricorsivamente.
32. Restituire l'ultima parola come nuova stringa.
33. Confrontare due stringhe ignorando maiuscole.
34. Verificare se due stringhe sono anagrammi mediante frequenze ricorsive.
35. Sostituire ricorsivamente ogni cifra con `'*'`.
36. Espandere ricorsivamente sequenze del tipo `"3a2b"`.
37. Calcolare il prefisso comune più lungo di un array di stringhe.
38. Verificare se una stringa è una rotazione di un'altra.
39. Trovare la sottostringa palindroma più lunga.
40. Calcolare la lunghezza della sottosequenza comune più lunga.

## Backtracking e memoizzazione

41. Contare tutte le permutazioni di un array con duplicati senza ripeterle.
42. Generare tutte le combinazioni di `k` elementi.
43. Risolvere il problema delle `n` regine contando le soluzioni.
44. Contare i cammini in una griglia muovendosi solo a destra e in basso.
45. Contare i cammini evitando ostacoli.
46. Trovare un cammino in un labirinto e scriverlo in un array.
47. Dividere un array in due sottoinsiemi con la stessa somma.
48. Trovare il numero minimo di tagli per partizionare una stringa in palindromi.
49. Contare le decodifiche di una stringa numerica con `1→A, ..., 26→Z`.
50. Calcolare la lunghezza della longest increasing subsequence con memoizzazione.
51. Calcolare il massimo valore dello zaino 0/1.
52. Verificare se una parola può essere costruita concatenando parole più corte.
53. Generare tutte le espressioni con `+`, `-`, `*` che raggiungono un target.
54. Risolvere un Sudoku parziale.
55. Trovare una sequenza di mosse per il cavallo che visiti ogni cella una volta.

---

# 9. Errori ricorsivi tipici da riconoscere al volo

## Caso base irraggiungibile

```c
int f(unsigned int n) {
    if (n < 0) {       // impossibile
        return 0;
    }

    return f(n - 1);
}
```

## Underflow di `size_t`

```c
void f(size_t i) {
    if (i == 0) {
        /* ... */
    }

    f(i - 1);          // manca return nel caso base
}
```

## Doppia chiamata inutile

```c
return fastPower(x, n / 2) *
       fastPower(x, n / 2);
```

## Perdita del risultato ricorsivo

```c
int contains(const int a[], size_t n, int x) {
    if (n == 0) {
        return 0;
    }

    if (a[0] == x) {
        return 1;
    }

    contains(a + 1, n - 1, x);  // manca return
}
```

## Stato non ripristinato nel backtracking

```c
used[i] = 1;
search(...);
/* manca used[i] = 0; */
```

## Output scritto sempre nella stessa posizione

```c
if (accept(a[0])) {
    out[0] = a[0];
}

recursive(a + 1, n - 1, out);  // sovrascrive out[0]
```

## Base case matematicamente sbagliato

```c
int max(const int a[], size_t n) {
    if (n == 0) {
        return 0;  // sbagliato per array tutti negativi
    }
}
```

## Heap confuso con stack

```text
malloc/free gestiscono lo heap.
Le chiamate ricorsive consumano stack anche se non usano malloc.
```

## Memoizzazione indicizzata dallo stato incompleto

Nel subset sum, memorizzare soltanto `target` è sbagliato se cambia anche l'indice degli elementi ancora disponibili.

Lo stato corretto è tipicamente:

```text
(index, target)
```

---

# 10. Come testare una funzione ricorsiva

Per ogni funzione, costruire almeno questi casi.

## Caso base puro

```text
n = 0
stringa vuota
intervallo vuoto
target = 0
```

## Primo caso non banale

```text
n = 1
stringa di un carattere
array di due elementi per un confronto tra estremi
```

## Caso che forza la risalita

Esempio per massimo:

```text
[1, 2, 100]
```

Il massimo si trova in profondità e deve risalire correttamente.

## Caso che forza lo stop anticipato

Esempio per `isSorted`:

```text
[9, 1, ...]
```

## Caso che esplora entrambi i rami

Esempio per subset sum:

```text
a = [8, 3, 5]
target = 8
```

e:

```text
a = [8, 3, 5]
target = 6
```

## Caso con stato da ripristinare

Per una griglia, usare un percorso che richieda tornare indietro da un vicolo cieco.

## Caso di performance

- Fibonacci con `n` abbastanza grande da mostrare l'esplosione;
- stringa con molti prefissi uguali per `strstr`;
- quicksort su array già ordinato;
- subset sum con target non raggiungibile.

---

# 11. Ordine consigliato di allenamento

## Prima fase — caso base e problema più piccolo

```text
1, 2, 3, 5, 6, 7
10, 11, 12, 15
21, 22, 24
```

Obiettivo:

- scrivere il caso base senza esitazione;
- scegliere correttamente il sottoproblema;
- non perdere il valore restituito.

## Seconda fase — intervalli e ordine della risalita

```text
9, 13, 14, 16, 17, 18
23, 25, 26, 27, 28
```

Obiettivo:

- usare intervalli `[left, right)`;
- evitare underflow;
- capire cosa accade prima e dopo la chiamata.

## Terza fase — divide et impera

```text
4, 29, 30, 31, 32, 33, 34
```

Obiettivo:

- dividere in sottoproblemi indipendenti;
- combinare risultati;
- distinguere profondità dello stack e numero totale di chiamate.

## Quarta fase — backtracking

```text
35, 36, 37, 39, 40, 41
```

Obiettivo:

- modellare le scelte;
- annullare lo stato;
- fare pruning soltanto quando logicamente valido.

## Quinta fase — memoizzazione e appelli difficili

```text
42, 43, 44, 45, 46, 47, 48
```

Obiettivo:

- riconoscere sottoproblemi ripetuti;
- definire lo stato completo;
- distinguere soluzione corretta, soluzione efficiente e consumo di memoria.

---

# 12. Scheda universale da compilare prima del codice

```text
FUNZIONE:
____________________________________________________

CASO BASE:
____________________________________________________

VALORE RESTITUITO NEL CASO BASE:
____________________________________________________

MISURA CHE DIMINUISCE:
____________________________________________________

CHIAMATA RICORSIVA:
____________________________________________________

COSA ASSUMO CHE RESTITUISCA:
____________________________________________________

COME COMBINO IL RISULTATO:
____________________________________________________

CODICE PRIMA DELLA CHIAMATA:
____________________________________________________

CODICE DOPO LA CHIAMATA:
____________________________________________________

PROFONDITÀ MASSIMA:
____________________________________________________

NUMERO TOTALE DI CHIAMATE:
____________________________________________________

TEMPO:
____________________________________________________

SPAZIO DI STACK:
____________________________________________________

MEMORIA HEAP:
____________________________________________________

CASI LIMITE:
____________________________________________________

POSSIBILE SOLUZIONE ITERATIVA:
____________________________________________________

SOTTOPROBLEMI RIPETUTI?
____________________________________________________

SERVE MEMOIZZAZIONE?
____________________________________________________
```

---

# 13. Regola finale

Di fronte a un esercizio ricorsivo, non cercare nella memoria una funzione già vista.

Riduci la consegna a questa forma:

```text
problema corrente
=
contributo corrente
+
risultato corretto di un problema più piccolo
```

oppure:

```text
problema corrente
=
combinazione dei risultati
di due o più sottoproblemi più piccoli
```

oppure, nel backtracking:

```text
risultato
=
unione dei risultati ottenuti
provando ogni scelta valida
e ripristinando lo stato
```

La ricorsione diventa gestibile quando sai indicare con precisione:

```text
dove termina
cosa diminuisce
cosa restituisce il sottoproblema
come viene usato quel risultato
```
