# Programmazione 2 — Esercizi su array, stringhe e memoria dinamica

> Raccolta progressiva in stile esame: consegna, struttura di partenza, soluzione semplice, eventuale soluzione ottimizzata, complessità, casi limite ed errori tipici.
>
> Linguaggio: C17.  
> Compilazione consigliata:
>
> ```bash
> gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion -g -fsanitize=address,undefined file.c -o file
> ```
>
> Obiettivo principale: **saper derivare una soluzione corretta dalla specifica**, non memorizzare codice.

---

# 0. Convenzioni usate nella raccolta

## 0.1 Tipi di supporto

Molti esercizi restituiscono un array dinamico insieme alla sua lunghezza.

```c
#include <stddef.h>

typedef struct {
    int *data;
    size_t size;
} IntArray;

typedef struct {
    char **data;
    size_t size;
} StringArray;
```

Convenzione di ownership:

- chi riceve un `IntArray` restituito da una funzione deve eseguire `free(result.data)`;
- chi riceve uno `StringArray` deve liberare ogni stringa e poi l'array di puntatori;
- salvo diversa indicazione, gli input non vengono modificati;
- se una funzione modifica in place, lo dichiara esplicitamente;
- quando `size == 0`, `data` può essere `NULL`.

Funzione utile:

```c
#include <stdlib.h>

void destroyStringArray(StringArray *a) {
    if (a == NULL) {
        return;
    }

    for (size_t i = 0; i < a->size; i++) {
        free(a->data[i]);
    }

    free(a->data);
    a->data = NULL;
    a->size = 0;
}
```

## 0.2 Domande da porsi prima di scrivere codice

1. L'input può essere `NULL`?
2. La lunghezza può essere zero?
3. Devo modificare l'input o produrre una copia?
4. L'ordine deve essere preservato?
5. Quante allocazioni sono ammesse?
6. Chi possiede la memoria restituita?
7. Serve distinguere capacità e dimensione logica?
8. Esiste una soluzione in place?
9. La soluzione semplice è già abbastanza efficiente?
10. Quali implementazioni sbagliate potrebbero superare i test banali?

## 0.3 Pattern fondamentali

### Scansione lineare

```c
for (size_t i = 0; i < n; i++) {
    /* elabora a[i] */
}
```

### Compattazione in place con due indici

```c
size_t write = 0;

for (size_t read = 0; read < n; read++) {
    if (/* elemento da conservare */) {
        a[write++] = a[read];
    }
}
```

### Costruzione dinamica con capacità

```c
size_t size = 0;
size_t capacity = 4;
int *data = malloc(capacity * sizeof(*data));

if (data == NULL) {
    /* gestione errore */
}

if (size == capacity) {
    size_t newCapacity = capacity * 2;
    int *tmp = realloc(data, newCapacity * sizeof(*tmp));

    if (tmp == NULL) {
        free(data);
        /* gestione errore */
    }

    data = tmp;
    capacity = newCapacity;
}

data[size++] = value;
```

### Stringa: non dimenticare `'\0'`

Per memorizzare `n` caratteri servono **n + 1 byte**.

```c
char *s = malloc((n + 1) * sizeof(*s));
s[n] = '\0';
```

---

# Livello 1 — Scansioni e trasformazioni fondamentali

---

## Esercizio 1 — Conta valori appartenenti a un intervallo

### Consegna

Dato un array di interi `a` di lunghezza `n`, restituire il numero di elementi appartenenti all'intervallo chiuso `[low, high]`.

- Se `a == NULL` e `n == 0`, restituire `0`.
- Si assume `low <= high`.
- Non modificare l'array.

### Struttura di partenza

```c
#include <stddef.h>

size_t countInRange(const int a[], size_t n, int low, int high);
```

### Soluzione semplice

```c
size_t countInRange(const int a[], size_t n, int low, int high) {
    size_t count = 0;

    for (size_t i = 0; i < n; i++) {
        if (a[i] >= low && a[i] <= high) {
            count++;
        }
    }

    return count;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio ausiliario: `O(1)`

### Casi limite

- `n == 0`
- nessun elemento nell'intervallo
- tutti gli elementi nell'intervallo
- valori uguali a `low` o `high`

### Errori tipici

- usare `<` invece di `<=`;
- accedere ad `a[0]` prima di verificare `n`;
- trattare `NULL` come errore anche quando `n == 0`.

---

## Esercizio 2 — Prima posizione diversa tra due array

### Consegna

Dati due array `a` e `b`, entrambi di lunghezza `n`, restituire:

- l'indice della prima posizione in cui differiscono;
- `n` se sono uguali in tutte le posizioni.

Gli array non devono essere modificati.

### Struttura di partenza

```c
#include <stddef.h>

size_t firstMismatch(const int a[], const int b[], size_t n);
```

### Soluzione semplice

```c
size_t firstMismatch(const int a[], const int b[], size_t n) {
    for (size_t i = 0; i < n; i++) {
        if (a[i] != b[i]) {
            return i;
        }
    }

    return n;
}
```

### Complessità

- Tempo: migliore `O(1)`, peggiore `O(n)`
- Spazio: `O(1)`

### Test discriminante

```text
a = [1, 2, 9, 4]
b = [1, 2, 3, 4]
risultato = 2
```

Un test con differenza soltanto in posizione zero non individua le implementazioni che confrontano un solo elemento.

---

## Esercizio 3 — Compattazione dei valori positivi in place

### Consegna

Dato un array `a` di lunghezza `n`, spostare nei primi posti dell'array tutti e soli i valori strettamente positivi, preservandone l'ordine relativo.

La funzione restituisce il numero di elementi conservati.

La parte dell'array successiva alla nuova lunghezza non ha contenuto specificato.

Esempio:

```text
[4, -1, 0, 7, -3, 2] → [4, 7, 2, ?, ?, ?]
restituisce 3
```

### Struttura di partenza

```c
#include <stddef.h>

size_t compactPositive(int a[], size_t n);
```

### Soluzione semplice

```c
size_t compactPositive(int a[], size_t n) {
    size_t write = 0;

    for (size_t read = 0; read < n; read++) {
        if (a[read] > 0) {
            a[write] = a[read];
            write++;
        }
    }

    return write;
}
```

### Perché funziona

In ogni momento:

- `a[0 .. write-1]` contiene esattamente i positivi già incontrati;
- tali elementi sono nello stesso ordine dell'input;
- `read` indica il prossimo elemento da esaminare.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

### Trappola

Non usare `memmove` a ogni elemento negativo: funzionerebbe, ma nel caso peggiore costerebbe `O(n²)`.

---

## Esercizio 4 — Rimuovi duplicati consecutivi in place

### Consegna

Dato un array `a` di lunghezza `n`, eliminare in place le ripetizioni consecutive, mantenendo una sola copia per ogni blocco.

Esempio:

```text
[1, 1, 1, 4, 4, 2, 2, 5]
→ [1, 4, 2, 5, ?, ?, ?, ?]
```

Restituire la nuova lunghezza.

### Struttura di partenza

```c
#include <stddef.h>

size_t removeConsecutiveDuplicates(int a[], size_t n);
```

### Soluzione semplice

```c
size_t removeConsecutiveDuplicates(int a[], size_t n) {
    if (n == 0) {
        return 0;
    }

    size_t write = 1;

    for (size_t read = 1; read < n; read++) {
        if (a[read] != a[write - 1]) {
            a[write] = a[read];
            write++;
        }
    }

    return write;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

### Attenzione

Questo esercizio elimina solo duplicati **adiacenti**. Non trasforma `[1, 2, 1]` in `[1, 2]`.

---

## Esercizio 5 — Inverti un intervallo dell'array

### Consegna

Dato un array `a` di lunghezza `n` e due indici `left` e `right`, invertire in place gli elementi compresi tra `left` e `right`, estremi inclusi.

Si assume:

```text
left <= right < n
```

### Struttura di partenza

```c
#include <stddef.h>

void reverseRange(int a[], size_t left, size_t right);
```

### Soluzione semplice

```c
void reverseRange(int a[], size_t left, size_t right) {
    while (left < right) {
        int tmp = a[left];
        a[left] = a[right];
        a[right] = tmp;

        left++;
        right--;
    }
}
```

### Complessità

- Tempo: `O(right - left + 1)`
- Spazio: `O(1)`

### Errore tipico con `size_t`

Non decrementare `right` senza una condizione come `left < right`: `size_t` è unsigned e può andare in underflow.

---

# Livello 2 — Array: ordine, finestre, merge e trasformazioni

---

## Esercizio 6 — Rotazione a destra di k posizioni

### Consegna

Ruotare in place un array di lunghezza `n` verso destra di `k` posizioni.

Esempio:

```text
[1, 2, 3, 4, 5], k = 2
→ [4, 5, 1, 2, 3]
```

Per `n == 0`, non fare nulla.

### Struttura di partenza

```c
#include <stddef.h>

void rotateRight(int a[], size_t n, size_t k);
```

### Soluzione semplice con array temporaneo

```c
#include <stdlib.h>

void rotateRight(int a[], size_t n, size_t k) {
    if (n == 0) {
        return;
    }

    k %= n;

    if (k == 0) {
        return;
    }

    int *tmp = malloc(n * sizeof(*tmp));

    if (tmp == NULL) {
        return; /* politica semplificata */
    }

    for (size_t i = 0; i < n; i++) {
        tmp[(i + k) % n] = a[i];
    }

    for (size_t i = 0; i < n; i++) {
        a[i] = tmp[i];
    }

    free(tmp);
}
```

### Soluzione ottimizzata in place

```c
static void reversePart(int a[], size_t left, size_t right) {
    while (left < right) {
        int tmp = a[left];
        a[left] = a[right];
        a[right] = tmp;
        left++;
        right--;
    }
}

void rotateRightInPlace(int a[], size_t n, size_t k) {
    if (n == 0) {
        return;
    }

    k %= n;

    if (k == 0) {
        return;
    }

    reversePart(a, 0, n - 1);
    reversePart(a, 0, k - 1);
    reversePart(a, k, n - 1);
}
```

### Complessità

| Soluzione | Tempo | Spazio |
|---|---:|---:|
| array temporaneo | `O(n)` | `O(n)` |
| tre inversioni | `O(n)` | `O(1)` |

### Trappole

- `k > n`;
- `k == 0`;
- `n == 0`, perché `k %= n` sarebbe divisione per zero;
- uso di `n - 1` quando `n == 0`.

---

## Esercizio 7 — Partizione stabile in un nuovo array

### Consegna

Dato un array `a`, restituire un nuovo array che contenga:

1. prima tutti i valori negativi;
2. poi tutti i valori non negativi;

preservando l'ordine relativo all'interno dei due gruppi.

Esempio:

```text
[4, -1, 0, -3, 7, -2]
→ [-1, -3, -2, 4, 0, 7]
```

### Struttura di partenza

```c
#include <stddef.h>

typedef struct {
    int *data;
    size_t size;
} IntArray;

IntArray stablePartitionNegative(const int a[], size_t n);
```

### Soluzione semplice

```c
#include <stdlib.h>

IntArray stablePartitionNegative(const int a[], size_t n) {
    IntArray result = {NULL, 0};

    if (n == 0) {
        return result;
    }

    result.data = malloc(n * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    size_t write = 0;

    for (size_t i = 0; i < n; i++) {
        if (a[i] < 0) {
            result.data[write++] = a[i];
        }
    }

    for (size_t i = 0; i < n; i++) {
        if (a[i] >= 0) {
            result.data[write++] = a[i];
        }
    }

    result.size = n;
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

### Osservazione

Una partizione stabile in place con `O(1)` spazio è possibile, ma una soluzione semplice tende a costare `O(n²)` a causa degli spostamenti. Per un esame, la soluzione con nuovo array è spesso la scelta più sicura se la specifica non impone l'in place.

---

## Esercizio 8 — Merge di due array ordinati

### Consegna

Dati due array ordinati in modo non decrescente, restituire un nuovo array ordinato contenente tutti gli elementi di entrambi, duplicati compresi.

### Struttura di partenza

```c
IntArray mergeSorted(const int a[], size_t n,
                     const int b[], size_t m);
```

### Soluzione semplice ma inefficiente

Concatenare e poi ordinare è concettualmente semplice, ma richiede un algoritmo di ordinamento:

- tipicamente `O((n+m) log(n+m))`;
- non sfrutta appieno il fatto che gli input siano già ordinati.

### Soluzione lineare

```c
#include <stdlib.h>

IntArray mergeSorted(const int a[], size_t n,
                     const int b[], size_t m) {
    IntArray result = {NULL, 0};

    if (n + m == 0) {
        return result;
    }

    result.data = malloc((n + m) * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    size_t i = 0;
    size_t j = 0;
    size_t k = 0;

    while (i < n && j < m) {
        if (a[i] <= b[j]) {
            result.data[k++] = a[i++];
        } else {
            result.data[k++] = b[j++];
        }
    }

    while (i < n) {
        result.data[k++] = a[i++];
    }

    while (j < m) {
        result.data[k++] = b[j++];
    }

    result.size = n + m;
    return result;
}
```

### Complessità

- Tempo: `O(n + m)`
- Spazio: `O(n + m)` per l'output

### Invariante

`result.data[0 .. k-1]` contiene esattamente i `k` elementi più piccoli tra quelli già consumati dai due input.

---

## Esercizio 9 — Intersezione con molteplicità di array ordinati

### Consegna

Dati due array ordinati, restituire un nuovo array contenente l'intersezione con molteplicità minima.

Esempio:

```text
a = [1, 1, 2, 4, 4, 4]
b = [1, 3, 4, 4, 5]
risultato = [1, 4, 4]
```

### Struttura di partenza

```c
IntArray intersectSorted(const int a[], size_t n,
                         const int b[], size_t m);
```

### Soluzione semplice

```c
#include <stdlib.h>

IntArray intersectSorted(const int a[], size_t n,
                         const int b[], size_t m) {
    IntArray result = {NULL, 0};

    size_t maxSize = n < m ? n : m;

    if (maxSize == 0) {
        return result;
    }

    result.data = malloc(maxSize * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    size_t i = 0;
    size_t j = 0;
    size_t k = 0;

    while (i < n && j < m) {
        if (a[i] == b[j]) {
            result.data[k++] = a[i];
            i++;
            j++;
        } else if (a[i] < b[j]) {
            i++;
        } else {
            j++;
        }
    }

    if (k == 0) {
        free(result.data);
        result.data = NULL;
        return result;
    }

    int *tmp = realloc(result.data, k * sizeof(*tmp));

    if (tmp != NULL) {
        result.data = tmp;
    }

    result.size = k;
    return result;
}
```

### Complessità

- Tempo: `O(n + m)`
- Spazio: `O(min(n,m))` nel caso peggiore

### Trappola

Usare per ogni elemento di `a` una ricerca completa in `b` porta a `O(nm)` e gestisce male i duplicati se non si marcano gli elementi già utilizzati.

---

## Esercizio 10 — Segmento crescente contiguo più lungo

### Consegna

Dato un array, restituire la lunghezza del più lungo segmento contiguo strettamente crescente.

Esempio:

```text
[5, 1, 2, 3, 0, 4, 5]
risultato = 3
```

### Struttura di partenza

```c
#include <stddef.h>

size_t longestIncreasingRun(const int a[], size_t n);
```

### Soluzione semplice

```c
size_t longestIncreasingRun(const int a[], size_t n) {
    if (n == 0) {
        return 0;
    }

    size_t best = 1;
    size_t current = 1;

    for (size_t i = 1; i < n; i++) {
        if (a[i] > a[i - 1]) {
            current++;
        } else {
            current = 1;
        }

        if (current > best) {
            best = current;
        }
    }

    return best;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

### Attenzione

Il segmento è **contiguo**. Non è la longest increasing subsequence.

---

## Esercizio 11 — Sottoarray di somma massima

### Consegna

Dato un array non vuoto, restituire la somma massima ottenibile scegliendo un sottoarray contiguo non vuoto.

Esempio:

```text
[-2, 1, -3, 4, -1, 2, 1, -5]
risultato = 6   // [4, -1, 2, 1]
```

### Struttura di partenza

```c
int maxSubarraySum(const int a[], size_t n);
```

Si assume `n >= 1` e che le somme non causino overflow di `int`.

### Soluzione semplice `O(n²)`

```c
int maxSubarraySumQuadratic(const int a[], size_t n) {
    int best = a[0];

    for (size_t start = 0; start < n; start++) {
        int sum = 0;

        for (size_t end = start; end < n; end++) {
            sum += a[end];

            if (sum > best) {
                best = sum;
            }
        }
    }

    return best;
}
```

### Soluzione ottimizzata — algoritmo di Kadane

```c
int maxSubarraySum(const int a[], size_t n) {
    int current = a[0];
    int best = a[0];

    for (size_t i = 1; i < n; i++) {
        if (current + a[i] > a[i]) {
            current = current + a[i];
        } else {
            current = a[i];
        }

        if (current > best) {
            best = current;
        }
    }

    return best;
}
```

### Complessità

| Soluzione | Tempo | Spazio |
|---|---:|---:|
| doppio ciclo | `O(n²)` | `O(1)` |
| Kadane | `O(n)` | `O(1)` |

### Trappola importante

Inizializzare `best = 0` è sbagliato se tutti gli elementi sono negativi e il sottoarray deve essere non vuoto.

---

## Esercizio 12 — Prodotto di tutti gli altri elementi

### Consegna

Dato un array `a` di lunghezza `n`, restituire un nuovo array `p` tale che:

```text
p[i] = prodotto di tutti gli elementi di a tranne a[i]
```

Non usare la divisione.

Si assume che i prodotti rientrino in `int`.

### Struttura di partenza

```c
IntArray productExceptSelf(const int a[], size_t n);
```

### Soluzione semplice `O(n²)`

```c
#include <stdlib.h>

IntArray productExceptSelfQuadratic(const int a[], size_t n) {
    IntArray result = {NULL, 0};

    if (n == 0) {
        return result;
    }

    result.data = malloc(n * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    for (size_t i = 0; i < n; i++) {
        int product = 1;

        for (size_t j = 0; j < n; j++) {
            if (i != j) {
                product *= a[j];
            }
        }

        result.data[i] = product;
    }

    result.size = n;
    return result;
}
```

### Soluzione ottimizzata `O(n)`

```c
IntArray productExceptSelf(const int a[], size_t n) {
    IntArray result = {NULL, 0};

    if (n == 0) {
        return result;
    }

    result.data = malloc(n * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    int prefix = 1;

    for (size_t i = 0; i < n; i++) {
        result.data[i] = prefix;
        prefix *= a[i];
    }

    int suffix = 1;

    for (size_t i = n; i > 0; i--) {
        size_t index = i - 1;
        result.data[index] *= suffix;
        suffix *= a[index];
    }

    result.size = n;
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio ausiliario oltre all'output: `O(1)`

### Casi delicati

- uno zero;
- più zeri;
- `n == 1`: il prodotto vuoto viene considerato `1`.

---

# Livello 3 — Stringhe: filtro, normalizzazione e trasformazioni

---

## Esercizio 13 — Filtra maiuscole e converti in minuscolo

### Consegna

Data una stringa `s`, restituire una nuova stringa contenente tutti e soli i caratteri tra `'A'` e `'Z'`, convertiti in minuscolo e nello stesso ordine.

Esempio:

```text
"AZbCuu12R" → "azcr"
```

- Se `s == NULL`, restituire `NULL`.
- La stringa restituita è allocata dinamicamente.
- Non modificare `s`.

### Struttura di partenza

```c
char *uppercaseToLowercaseString(const char *s);
```

### Soluzione semplice in due passaggi

```c
#include <stdlib.h>

char *uppercaseToLowercaseString(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t count = 0;

    for (size_t i = 0; s[i] != '\0'; i++) {
        if (s[i] >= 'A' && s[i] <= 'Z') {
            count++;
        }
    }

    char *result = malloc((count + 1) * sizeof(*result));

    if (result == NULL) {
        return NULL;
    }

    size_t write = 0;

    for (size_t i = 0; s[i] != '\0'; i++) {
        if (s[i] >= 'A' && s[i] <= 'Z') {
            result[write++] = (char)(s[i] - 'A' + 'a');
        }
    }

    result[write] = '\0';
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(k)` per il risultato

### Perché due passaggi

La prima scansione permette un'unica allocazione della dimensione esatta.

---

## Esercizio 14 — Normalizza gli spazi in place

### Consegna

Modificare in place una stringa in modo che:

- gli spazi iniziali e finali vengano rimossi;
- ogni sequenza di uno o più spazi interni diventi un singolo spazio.

Si considera spazio soltanto il carattere `' '`.

Esempio:

```text
"   ciao   mondo  C   " → "ciao mondo C"
```

### Struttura di partenza

```c
void normalizeSpaces(char *s);
```

### Soluzione semplice

```c
void normalizeSpaces(char *s) {
    if (s == NULL) {
        return;
    }

    size_t read = 0;
    size_t write = 0;

    while (s[read] == ' ') {
        read++;
    }

    int pendingSpace = 0;

    while (s[read] != '\0') {
        if (s[read] == ' ') {
            pendingSpace = 1;
        } else {
            if (pendingSpace && write > 0) {
                s[write++] = ' ';
            }

            s[write++] = s[read];
            pendingSpace = 0;
        }

        read++;
    }

    s[write] = '\0';
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

### Trappole

- stringa composta solo da spazi;
- stringa vuota;
- dimenticare il nuovo terminatore;
- scrivere uno spazio finale.

---

## Esercizio 15 — Rimuovi tutti i caratteri appartenenti a un insieme

### Consegna

Data una stringa modificabile `s` e una stringa `forbidden`, rimuovere in place da `s` ogni carattere presente in `forbidden`.

Esempio:

```text
s = "programmazione"
forbidden = "aeiou"
risultato = "prgrmmzn"
```

### Struttura di partenza

```c
void removeForbidden(char *s, const char *forbidden);
```

### Soluzione semplice `O(nm)`

```c
static int containsChar(const char *s, char c) {
    for (size_t i = 0; s[i] != '\0'; i++) {
        if (s[i] == c) {
            return 1;
        }
    }

    return 0;
}

void removeForbiddenSimple(char *s, const char *forbidden) {
    if (s == NULL || forbidden == NULL) {
        return;
    }

    size_t write = 0;

    for (size_t read = 0; s[read] != '\0'; read++) {
        if (!containsChar(forbidden, s[read])) {
            s[write++] = s[read];
        }
    }

    s[write] = '\0';
}
```

### Soluzione ottimizzata con tabella ASCII

```c
#include <limits.h>

void removeForbidden(char *s, const char *forbidden) {
    if (s == NULL || forbidden == NULL) {
        return;
    }

    unsigned char table[UCHAR_MAX + 1] = {0};

    for (size_t i = 0; forbidden[i] != '\0'; i++) {
        table[(unsigned char)forbidden[i]] = 1;
    }

    size_t write = 0;

    for (size_t read = 0; s[read] != '\0'; read++) {
        unsigned char c = (unsigned char)s[read];

        if (!table[c]) {
            s[write++] = s[read];
        }
    }

    s[write] = '\0';
}
```

### Complessità

| Soluzione | Tempo |
|---|---:|
| ricerca lineare in `forbidden` | `O(nm)` |
| tabella di presenza | `O(n + m)` |

---

## Esercizio 16 — Inverti l'ordine delle parole in place

### Consegna

Data una stringa composta da parole separate da un singolo spazio, senza spazi iniziali o finali, invertire in place l'ordine delle parole.

Esempio:

```text
"uno due tre" → "tre due uno"
```

Non invertire i caratteri interni delle parole nel risultato finale.

### Struttura di partenza

```c
void reverseWords(char *s);
```

### Soluzione elegante tramite inversioni

```c
#include <string.h>

static void reverseChars(char *s, size_t left, size_t right) {
    while (left < right) {
        char tmp = s[left];
        s[left] = s[right];
        s[right] = tmp;
        left++;
        right--;
    }
}

void reverseWords(char *s) {
    if (s == NULL || s[0] == '\0') {
        return;
    }

    size_t n = strlen(s);
    reverseChars(s, 0, n - 1);

    size_t start = 0;

    for (size_t i = 0; i <= n; i++) {
        if (s[i] == ' ' || s[i] == '\0') {
            if (i > start) {
                reverseChars(s, start, i - 1);
            }

            start = i + 1;
        }
    }
}
```

### Esempio delle fasi

```text
"uno due tre"
→ "ert eud onu"
→ "tre due uno"
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

---

## Esercizio 17 — Prefisso comune più lungo

### Consegna

Date due stringhe `a` e `b`, restituire una nuova stringa contenente il loro prefisso comune più lungo.

Esempio:

```text
"programmare"
"programma"
→ "programma"
```

Se non hanno alcun carattere iniziale in comune, restituire la stringa vuota allocata dinamicamente.

### Struttura di partenza

```c
char *longestCommonPrefix(const char *a, const char *b);
```

### Soluzione semplice

```c
#include <stdlib.h>

char *longestCommonPrefix(const char *a, const char *b) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    size_t length = 0;

    while (a[length] != '\0' &&
           b[length] != '\0' &&
           a[length] == b[length]) {
        length++;
    }

    char *result = malloc((length + 1) * sizeof(*result));

    if (result == NULL) {
        return NULL;
    }

    for (size_t i = 0; i < length; i++) {
        result[i] = a[i];
    }

    result[length] = '\0';
    return result;
}
```

### Complessità

- Tempo: `O(min(|a|, |b|))`
- Spazio: `O(k)` per l'output

---

## Esercizio 18 — Anti-prefisso tra due stringhe

### Consegna

Date due stringhe `a` e `b`, restituire il più lungo prefisso di `a` tale che, per ogni posizione compresa nel prefisso, il carattere di `a` sia diverso dal carattere corrispondente di `b`.

Se `b` termina prima, il resto di `a` può essere incluso.

Esempi:

```text
a = "superpippo", b = "pippo"       → "su"
a = "pluto",      b = "superpippo"  → "pluto"
a = "abc",        b = ""            → "abc"
a = "abc",        b = "axz"         → ""
```

### Struttura di partenza

```c
char *antiPrefixString(const char *a, const char *b);
```

### Soluzione semplice

```c
#include <stdlib.h>
#include <string.h>

char *antiPrefixString(const char *a, const char *b) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    size_t length = 0;

    while (a[length] != '\0') {
        if (b[length] != '\0' && a[length] == b[length]) {
            break;
        }

        length++;
    }

    char *result = malloc((length + 1) * sizeof(*result));

    if (result == NULL) {
        return NULL;
    }

    memcpy(result, a, length);
    result[length] = '\0';
    return result;
}
```

### Complessità

- Tempo: `O(k)`, dove `k` è la lunghezza del prefisso prodotto più uno
- Spazio: `O(k)`

### Punto delicato

Quando `b` termina, non bisogna leggere oltre il suo `'\0'` come se contenesse altri caratteri validi.

---

## Esercizio 19 — Run-length encoding

### Consegna

Data una stringa, restituire una nuova stringa che codifichi ogni blocco di caratteri uguali consecutivi come:

```text
carattere seguito dal numero di occorrenze
```

Esempio:

```text
"aaabbccccd" → "a3b2c4d1"
```

Si può assumere che la stringa contenga solo caratteri non numerici.

### Struttura di partenza

```c
char *runLengthEncode(const char *s);
```

### Soluzione semplice con capacità dinamica

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int appendText(char **buffer,
                      size_t *size,
                      size_t *capacity,
                      const char *text) {
    size_t length = strlen(text);

    if (*size + length + 1 > *capacity) {
        size_t newCapacity = *capacity;

        while (*size + length + 1 > newCapacity) {
            newCapacity *= 2;
        }

        char *tmp = realloc(*buffer, newCapacity);

        if (tmp == NULL) {
            return 0;
        }

        *buffer = tmp;
        *capacity = newCapacity;
    }

    memcpy(*buffer + *size, text, length);
    *size += length;
    (*buffer)[*size] = '\0';
    return 1;
}

char *runLengthEncode(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t capacity = 16;
    size_t size = 0;
    char *result = malloc(capacity);

    if (result == NULL) {
        return NULL;
    }

    result[0] = '\0';

    size_t i = 0;

    while (s[i] != '\0') {
        char current = s[i];
        size_t count = 0;

        while (s[i] == current) {
            count++;
            i++;
        }

        char piece[64];
        int written = snprintf(piece, sizeof(piece), "%c%zu", current, count);

        if (written < 0 ||
            !appendText(&result, &size, &capacity, piece)) {
            free(result);
            return NULL;
        }
    }

    return result;
}
```

### Complessità

- Tempo ammortizzato: `O(n)`
- Spazio: `O(n)` nel caso peggiore

### Perché raddoppiare la capacità

Riallocare di un solo carattere alla volta può portare a `O(n²)` copie complessive.

---

## Esercizio 20 — Sostituisci tutte le occorrenze di una sottostringa

### Consegna

Date tre stringhe `s`, `target` e `replacement`, restituire una nuova stringa ottenuta sostituendo tutte le occorrenze **non sovrapposte** di `target` con `replacement`.

Esempio:

```text
s = "abcXXabc"
target = "abc"
replacement = "Q"
→ "QXXQ"
```

Si assume `target` non vuota.

### Struttura di partenza

```c
char *replaceAll(const char *s,
                 const char *target,
                 const char *replacement);
```

### Soluzione semplice in due passaggi

```c
#include <stdlib.h>
#include <string.h>

char *replaceAll(const char *s,
                 const char *target,
                 const char *replacement) {
    if (s == NULL || target == NULL || replacement == NULL) {
        return NULL;
    }

    size_t targetLen = strlen(target);
    size_t replacementLen = strlen(replacement);

    if (targetLen == 0) {
        return NULL;
    }

    size_t occurrences = 0;
    size_t i = 0;

    while (s[i] != '\0') {
        if (strncmp(s + i, target, targetLen) == 0) {
            occurrences++;
            i += targetLen;
        } else {
            i++;
        }
    }

    size_t sourceLen = strlen(s);
    size_t resultLen;

    if (replacementLen >= targetLen) {
        resultLen = sourceLen +
                    occurrences * (replacementLen - targetLen);
    } else {
        resultLen = sourceLen -
                    occurrences * (targetLen - replacementLen);
    }

    char *result = malloc(resultLen + 1);

    if (result == NULL) {
        return NULL;
    }

    size_t read = 0;
    size_t write = 0;

    while (s[read] != '\0') {
        if (strncmp(s + read, target, targetLen) == 0) {
            memcpy(result + write, replacement, replacementLen);
            write += replacementLen;
            read += targetLen;
        } else {
            result[write++] = s[read++];
        }
    }

    result[write] = '\0';
    return result;
}
```

### Complessità

Questa implementazione usa `strncmp` a ogni posizione:

- tempo peggiore: `O(n * |target|)`;
- spazio: `O(output)`.

Per pattern molto lunghi si potrebbe usare KMP, ma in un esame di Programmazione 2 la soluzione semplice è normalmente preferibile salvo esplicita richiesta di ottimizzazione.

### Trappole

- `replacement` più lunga o più corta;
- occorrenze adiacenti;
- `target` assente;
- `target` uguale a tutta `s`;
- overflow nel calcolo della dimensione, se gli input fossero enormi.

---

## Esercizio 21 — Sottostringa senza caratteri ripetuti più lunga

### Consegna

Data una stringa, restituire la lunghezza della più lunga sottostringa contigua senza caratteri ripetuti.

Esempio:

```text
"abcabcbb" → 3
"bbbbb"    → 1
""         → 0
```

### Struttura di partenza

```c
#include <stddef.h>

size_t longestUniqueSubstring(const char *s);
```

### Soluzione semplice `O(n²)`

Per ogni possibile inizio, avanzare fino alla prima ripetizione usando una tabella locale.

### Soluzione ottimizzata con finestra scorrevole

```c
#include <limits.h>

size_t longestUniqueSubstring(const char *s) {
    if (s == NULL) {
        return 0;
    }

    size_t last[UCHAR_MAX + 1];

    for (size_t i = 0; i <= UCHAR_MAX; i++) {
        last[i] = (size_t)-1;
    }

    size_t left = 0;
    size_t best = 0;

    for (size_t right = 0; s[right] != '\0'; right++) {
        unsigned char c = (unsigned char)s[right];
        size_t previous = last[c];

        if (previous != (size_t)-1 && previous >= left) {
            left = previous + 1;
        }

        last[c] = right;

        size_t length = right - left + 1;

        if (length > best) {
            best = length;
        }
    }

    return best;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)` rispetto a `n`, perché la tabella ha dimensione fissa

### Invariante

La finestra `s[left .. right]` non contiene duplicati.

---

## Esercizio 22 — Spezza una frase in parole

### Consegna

Data una stringa contenente parole separate da uno o più spazi, restituire un array dinamico di nuove stringhe, una per parola.

Gli spazi iniziali e finali vanno ignorati.

Esempio:

```text
"  uno   due tre " → ["uno", "due", "tre"]
```

### Struttura di partenza

```c
typedef struct {
    char **data;
    size_t size;
} StringArray;

StringArray splitWords(const char *s);
```

### Soluzione semplice

```c
#include <stdlib.h>
#include <string.h>

StringArray splitWords(const char *s) {
    StringArray result = {NULL, 0};

    if (s == NULL) {
        return result;
    }

    size_t count = 0;
    size_t i = 0;

    while (s[i] != '\0') {
        while (s[i] == ' ') {
            i++;
        }

        if (s[i] == '\0') {
            break;
        }

        count++;

        while (s[i] != '\0' && s[i] != ' ') {
            i++;
        }
    }

    if (count == 0) {
        return result;
    }

    result.data = calloc(count, sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    i = 0;
    size_t wordIndex = 0;

    while (s[i] != '\0') {
        while (s[i] == ' ') {
            i++;
        }

        if (s[i] == '\0') {
            break;
        }

        size_t start = i;

        while (s[i] != '\0' && s[i] != ' ') {
            i++;
        }

        size_t length = i - start;
        result.data[wordIndex] = malloc(length + 1);

        if (result.data[wordIndex] == NULL) {
            result.size = wordIndex;

            for (size_t k = 0; k < result.size; k++) {
                free(result.data[k]);
            }

            free(result.data);
            result.data = NULL;
            result.size = 0;
            return result;
        }

        memcpy(result.data[wordIndex], s + start, length);
        result.data[wordIndex][length] = '\0';
        wordIndex++;
    }

    result.size = count;
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)` complessivo per copie e puntatori

### Hidden test probabili

- `NULL`;
- `""`;
- solo spazi;
- una parola;
- molti spazi consecutivi;
- spazi all'inizio e alla fine;
- fallimento durante una delle allocazioni intermedie.

---

## Esercizio 23 — Unisci un array di stringhe

### Consegna

Dato un array di `n` stringhe e un separatore `sep`, restituire una nuova stringa che le unisca.

Esempio:

```text
["uno", "due", "tre"], sep = "-"
→ "uno-due-tre"
```

Per `n == 0`, restituire `""`.

### Struttura di partenza

```c
char *joinStrings(const char *const strings[],
                  size_t n,
                  const char *sep);
```

### Soluzione semplice con calcolo esatto

```c
#include <stdlib.h>
#include <string.h>

char *joinStrings(const char *const strings[],
                  size_t n,
                  const char *sep) {
    if (sep == NULL) {
        return NULL;
    }

    size_t sepLen = strlen(sep);
    size_t total = 0;

    for (size_t i = 0; i < n; i++) {
        if (strings[i] == NULL) {
            return NULL;
        }

        total += strlen(strings[i]);
    }

    if (n > 1) {
        total += (n - 1) * sepLen;
    }

    char *result = malloc(total + 1);

    if (result == NULL) {
        return NULL;
    }

    size_t write = 0;

    for (size_t i = 0; i < n; i++) {
        size_t length = strlen(strings[i]);
        memcpy(result + write, strings[i], length);
        write += length;

        if (i + 1 < n) {
            memcpy(result + write, sep, sepLen);
            write += sepLen;
        }
    }

    result[write] = '\0';
    return result;
}
```

### Complessità

- Tempo: `O(numero totale di caratteri)`
- Spazio: esattamente quello necessario all'output

### Errore tipico

Usare ripetutamente `strcat` dalla posizione iniziale può causare `O(total²)` perché ogni chiamata deve cercare il terminatore corrente.

---

# Livello 4 — Memoria dinamica, vettori ridimensionabili e matrici

---

## Esercizio 24 — Filtra un array dinamico con crescita geometrica

### Consegna

Dato un array, restituire un nuovo array contenente soltanto gli elementi che soddisfano un predicato passato come puntatore a funzione.

Non è noto in anticipo quanti elementi verranno selezionati.

### Struttura di partenza

```c
typedef int (*IntPredicate)(int);

IntArray filterArray(const int a[], size_t n, IntPredicate predicate);
```

### Soluzione semplice in due passaggi

1. Contare gli elementi selezionati.
2. Allocare esattamente.
3. Copiarli.

È spesso la soluzione migliore se l'input è già interamente disponibile.

### Soluzione con crescita dinamica

```c
#include <stdlib.h>

IntArray filterArray(const int a[], size_t n, IntPredicate predicate) {
    IntArray result = {NULL, 0};

    if (predicate == NULL) {
        return result;
    }

    size_t capacity = 0;

    for (size_t i = 0; i < n; i++) {
        if (!predicate(a[i])) {
            continue;
        }

        if (result.size == capacity) {
            size_t newCapacity = capacity == 0 ? 4 : capacity * 2;
            int *tmp = realloc(result.data,
                               newCapacity * sizeof(*tmp));

            if (tmp == NULL) {
                free(result.data);
                result.data = NULL;
                result.size = 0;
                return result;
            }

            result.data = tmp;
            capacity = newCapacity;
        }

        result.data[result.size++] = a[i];
    }

    if (result.size == 0) {
        free(result.data);
        result.data = NULL;
        return result;
    }

    int *tmp = realloc(result.data,
                       result.size * sizeof(*tmp));

    if (tmp != NULL) {
        result.data = tmp;
    }

    return result;
}
```

### Complessità

- Tempo ammortizzato: `O(n)`
- Spazio: `O(k)`

### Quando preferire le due versioni

- **Due passaggi:** input in memoria, predicato economico, allocazione esatta.
- **Crescita dinamica:** stream, input prodotto progressivamente, impossibilità di ripetere la scansione.

---

## Esercizio 25 — Vettore dinamico di interi

### Consegna

Implementare un piccolo vettore dinamico con:

- dimensione logica;
- capacità;
- inserimento in coda;
- accesso;
- distruzione.

### Struttura di partenza

```c
#include <stddef.h>

typedef struct {
    int *data;
    size_t size;
    size_t capacity;
} IntVector;

int vectorInit(IntVector *v);
int vectorPushBack(IntVector *v, int value);
int vectorGet(const IntVector *v, size_t index, int *out);
void vectorDestroy(IntVector *v);
```

### Soluzione

```c
#include <stdlib.h>

int vectorInit(IntVector *v) {
    if (v == NULL) {
        return 0;
    }

    v->data = NULL;
    v->size = 0;
    v->capacity = 0;
    return 1;
}

static int vectorReserve(IntVector *v, size_t newCapacity) {
    if (newCapacity <= v->capacity) {
        return 1;
    }

    int *tmp = realloc(v->data,
                       newCapacity * sizeof(*tmp));

    if (tmp == NULL) {
        return 0;
    }

    v->data = tmp;
    v->capacity = newCapacity;
    return 1;
}

int vectorPushBack(IntVector *v, int value) {
    if (v == NULL) {
        return 0;
    }

    if (v->size == v->capacity) {
        size_t newCapacity =
            v->capacity == 0 ? 4 : v->capacity * 2;

        if (!vectorReserve(v, newCapacity)) {
            return 0;
        }
    }

    v->data[v->size++] = value;
    return 1;
}

int vectorGet(const IntVector *v,
              size_t index,
              int *out) {
    if (v == NULL || out == NULL || index >= v->size) {
        return 0;
    }

    *out = v->data[index];
    return 1;
}

void vectorDestroy(IntVector *v) {
    if (v == NULL) {
        return;
    }

    free(v->data);
    v->data = NULL;
    v->size = 0;
    v->capacity = 0;
}
```

### Invarianti della struttura

```text
0 <= size <= capacity
data == NULL  se capacity == 0
data punta ad almeno capacity interi se capacity > 0
```

### Complessità

- `get`: `O(1)`
- `pushBack`: `O(1)` ammortizzato, `O(n)` quando rialloca
- distruzione: `O(1)` per il buffer unico

---

## Esercizio 26 — Inserisci un segmento in un array dinamico

### Consegna

Dato un array dinamico `*a` di lunghezza `*n`, inserire in posizione `index` tutti gli elementi di `values`, preservando l'ordine.

Esempio:

```text
a = [1, 2, 5], index = 2
values = [3, 4]
→ [1, 2, 3, 4, 5]
```

La funzione restituisce `1` in caso di successo e `0` in caso di errore. In caso di fallimento, `*a` e `*n` devono rimanere invariati.

### Struttura di partenza

```c
int insertSlice(int **a,
                size_t *n,
                size_t index,
                const int values[],
                size_t valueCount);
```

### Soluzione semplice e sicura

```c
#include <stdlib.h>
#include <string.h>

int insertSlice(int **a,
                size_t *n,
                size_t index,
                const int values[],
                size_t valueCount) {
    if (a == NULL || n == NULL || index > *n) {
        return 0;
    }

    if (valueCount == 0) {
        return 1;
    }

    if (values == NULL) {
        return 0;
    }

    size_t newSize = *n + valueCount;
    int *newData = malloc(newSize * sizeof(*newData));

    if (newData == NULL) {
        return 0;
    }

    memcpy(newData,
           *a,
           index * sizeof(*newData));

    memcpy(newData + index,
           values,
           valueCount * sizeof(*newData));

    memcpy(newData + index + valueCount,
           *a + index,
           (*n - index) * sizeof(*newData));

    free(*a);
    *a = newData;
    *n = newSize;
    return 1;
}
```

### Soluzione con `realloc` e `memmove`

```c
int insertSliceRealloc(int **a,
                       size_t *n,
                       size_t index,
                       const int values[],
                       size_t valueCount) {
    if (a == NULL || n == NULL ||
        index > *n ||
        (valueCount > 0 && values == NULL)) {
        return 0;
    }

    if (valueCount == 0) {
        return 1;
    }

    size_t newSize = *n + valueCount;
    int *tmp = realloc(*a, newSize * sizeof(*tmp));

    if (tmp == NULL) {
        return 0;
    }

    memmove(tmp + index + valueCount,
            tmp + index,
            (*n - index) * sizeof(*tmp));

    memcpy(tmp + index,
           values,
           valueCount * sizeof(*tmp));

    *a = tmp;
    *n = newSize;
    return 1;
}
```

### Attenzione all'aliasing

La versione con `realloc` è problematica se `values` punta dentro `*a`, perché `realloc` può spostare il buffer e invalidare `values`.

La prima soluzione con nuovo buffer è più robusta e più semplice da motivare.

---

## Esercizio 27 — Matrice dinamica contigua

### Consegna

Implementare una matrice `rows × cols` di interi con:

- un solo blocco per i dati;
- un array di puntatori alle righe;
- accesso `m.row[i][j]`;
- distruzione corretta.

### Struttura di partenza

```c
typedef struct {
    int **row;
    int *data;
    size_t rows;
    size_t cols;
} IntMatrix;

IntMatrix matrixCreate(size_t rows, size_t cols);
void matrixDestroy(IntMatrix *m);
```

### Soluzione

```c
#include <stdlib.h>

IntMatrix matrixCreate(size_t rows, size_t cols) {
    IntMatrix m = {NULL, NULL, 0, 0};

    if (rows == 0 || cols == 0) {
        return m;
    }

    m.row = malloc(rows * sizeof(*m.row));

    if (m.row == NULL) {
        return m;
    }

    m.data = calloc(rows * cols, sizeof(*m.data));

    if (m.data == NULL) {
        free(m.row);
        m.row = NULL;
        return m;
    }

    for (size_t i = 0; i < rows; i++) {
        m.row[i] = m.data + i * cols;
    }

    m.rows = rows;
    m.cols = cols;
    return m;
}

void matrixDestroy(IntMatrix *m) {
    if (m == NULL) {
        return;
    }

    free(m->data);
    free(m->row);

    m->data = NULL;
    m->row = NULL;
    m->rows = 0;
    m->cols = 0;
}
```

### Vantaggi del blocco contiguo

- due sole allocazioni;
- buona località di memoria;
- distruzione semplice;
- possibilità di trattare tutti gli elementi come un unico array.

### Errore catastrofico

Non fare:

```c
for (...) {
    free(m->row[i]);
}
```

Le righe non sono state allocate separatamente: puntano tutte dentro `m->data`.

---

## Esercizio 28 — Trasposta di una matrice dinamica

### Consegna

Data una matrice `m` di dimensione `rows × cols`, restituire una nuova matrice trasposta di dimensione `cols × rows`.

Non modificare l'input.

### Struttura di partenza

```c
IntMatrix matrixTranspose(const IntMatrix *m);
```

### Soluzione semplice

```c
IntMatrix matrixTranspose(const IntMatrix *m) {
    IntMatrix result = {NULL, NULL, 0, 0};

    if (m == NULL || m->rows == 0 || m->cols == 0) {
        return result;
    }

    result = matrixCreate(m->cols, m->rows);

    if (result.data == NULL) {
        return result;
    }

    for (size_t i = 0; i < m->rows; i++) {
        for (size_t j = 0; j < m->cols; j++) {
            result.row[j][i] = m->row[i][j];
        }
    }

    return result;
}
```

### Complessità

- Tempo: `O(rows * cols)`
- Spazio: `O(rows * cols)` per l'output

### Variante in place

È semplice soltanto per matrici quadrate:

```c
void transposeSquare(IntMatrix *m) {
    for (size_t i = 0; i < m->rows; i++) {
        for (size_t j = i + 1; j < m->cols; j++) {
            int tmp = m->row[i][j];
            m->row[i][j] = m->row[j][i];
            m->row[j][i] = tmp;
        }
    }
}
```

---

# Livello 5 — Problemi misti e difficili

---

## Esercizio 29 — Merge stabile di record ordinati

### Consegna

Si consideri:

```c
typedef struct {
    int key;
    char name[32];
} Record;
```

Dati due array ordinati per `key`, restituire un nuovo array ordinato contenente tutti i record.

In caso di chiavi uguali, i record del primo array devono precedere quelli del secondo. La stabilità interna di ogni input deve essere preservata.

### Struttura di partenza

```c
typedef struct {
    Record *data;
    size_t size;
} RecordArray;

RecordArray mergeRecords(const Record a[], size_t n,
                         const Record b[], size_t m);
```

### Soluzione semplice

```c
#include <stdlib.h>

RecordArray mergeRecords(const Record a[], size_t n,
                         const Record b[], size_t m) {
    RecordArray result = {NULL, 0};

    if (n + m == 0) {
        return result;
    }

    result.data = malloc((n + m) * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    size_t i = 0;
    size_t j = 0;
    size_t k = 0;

    while (i < n && j < m) {
        if (a[i].key <= b[j].key) {
            result.data[k++] = a[i++];
        } else {
            result.data[k++] = b[j++];
        }
    }

    while (i < n) {
        result.data[k++] = a[i++];
    }

    while (j < m) {
        result.data[k++] = b[j++];
    }

    result.size = n + m;
    return result;
}
```

### Punto d'esame

Il confronto `<=` e non `<` garantisce che, a parità di chiave, venga scelto prima il record del primo array.

---

## Esercizio 30 — Somma di interi non negativi arbitrariamente grandi

### Consegna

Date due stringhe contenenti rappresentazioni decimali valide di interi non negativi, restituire una nuova stringa con la loro somma.

Esempio:

```text
"999999999999999999"
"1"
→ "1000000000000000000"
```

Non usare tipi interi per convertire l'intero numero.

### Struttura di partenza

```c
char *addBigUnsigned(const char *a, const char *b);
```

### Soluzione semplice

```c
#include <stdlib.h>
#include <string.h>

char *addBigUnsigned(const char *a, const char *b) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    size_t lenA = strlen(a);
    size_t lenB = strlen(b);
    size_t maxLen = lenA > lenB ? lenA : lenB;

    char *result = malloc(maxLen + 2);

    if (result == NULL) {
        return NULL;
    }

    result[maxLen + 1] = '\0';

    size_t i = lenA;
    size_t j = lenB;
    size_t write = maxLen + 1;
    int carry = 0;

    while (i > 0 || j > 0 || carry != 0) {
        int digitA = 0;
        int digitB = 0;

        if (i > 0) {
            digitA = a[--i] - '0';
        }

        if (j > 0) {
            digitB = b[--j] - '0';
        }

        int sum = digitA + digitB + carry;
        result[--write] = (char)('0' + sum % 10);
        carry = sum / 10;
    }

    size_t length = maxLen + 1 - write;
    memmove(result, result + write, length);
    result[length] = '\0';

    char *tmp = realloc(result, length + 1);

    if (tmp != NULL) {
        result = tmp;
    }

    return result;
}
```

### Complessità

- Tempo: `O(max(|a|, |b|))`
- Spazio: `O(max(|a|, |b|))`

### Hidden test

- `"0" + "0"`;
- numeri di lunghezza diversa;
- riporto finale;
- molti riporti consecutivi;
- input con zeri iniziali, se ammessi dalla specifica.

---

## Esercizio 31 — Parsing di interi da una stringa

### Consegna

Data una stringa contenente interi con segno separati da spazi, restituire un array dinamico con i valori.

Esempio:

```text
"  12 -3 0 45 " → [12, -3, 0, 45]
```

Si assume che:

- il formato sia valido;
- i valori rientrino in `int`;
- non si usi `strtok`;
- non sia noto in anticipo quanti numeri siano presenti.

### Struttura di partenza

```c
IntArray parseIntegers(const char *s);
```

### Soluzione con crescita dinamica

```c
#include <stdlib.h>

IntArray parseIntegers(const char *s) {
    IntArray result = {NULL, 0};

    if (s == NULL) {
        return result;
    }

    size_t capacity = 0;
    size_t i = 0;

    while (s[i] != '\0') {
        while (s[i] == ' ') {
            i++;
        }

        if (s[i] == '\0') {
            break;
        }

        int sign = 1;

        if (s[i] == '-') {
            sign = -1;
            i++;
        } else if (s[i] == '+') {
            i++;
        }

        int value = 0;

        while (s[i] >= '0' && s[i] <= '9') {
            value = value * 10 + (s[i] - '0');
            i++;
        }

        value *= sign;

        if (result.size == capacity) {
            size_t newCapacity =
                capacity == 0 ? 4 : capacity * 2;

            int *tmp = realloc(result.data,
                               newCapacity * sizeof(*tmp));

            if (tmp == NULL) {
                free(result.data);
                result.data = NULL;
                result.size = 0;
                return result;
            }

            result.data = tmp;
            capacity = newCapacity;
        }

        result.data[result.size++] = value;
    }

    if (result.size == 0) {
        free(result.data);
        result.data = NULL;
        return result;
    }

    int *tmp = realloc(result.data,
                       result.size * sizeof(*tmp));

    if (tmp != NULL) {
        result.data = tmp;
    }

    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(k)`

### Variante più robusta

In un esercizio reale potrebbero essere richiesti:

- rilevamento di formato invalido;
- overflow;
- tab e newline come separatori;
- restituzione di un codice d'errore distinto da “nessun numero”.

---

## Esercizio 32 — Fusione di intervalli sovrapposti

### Consegna

Si consideri:

```c
typedef struct {
    int start;
    int end;
} Interval;
```

Dato un array di intervalli ordinati per `start`, con `start <= end`, restituire un nuovo array nel quale gli intervalli sovrapposti o adiacenti siano fusi.

Esempio:

```text
[1,3], [2,6], [8,10], [10,12], [15,18]
→ [1,6], [8,12], [15,18]
```

Gli input non devono essere modificati.

### Struttura di partenza

```c
typedef struct {
    Interval *data;
    size_t size;
} IntervalArray;

IntervalArray mergeIntervals(const Interval a[], size_t n);
```

### Soluzione semplice lineare

```c
#include <stdlib.h>

IntervalArray mergeIntervals(const Interval a[], size_t n) {
    IntervalArray result = {NULL, 0};

    if (n == 0) {
        return result;
    }

    result.data = malloc(n * sizeof(*result.data));

    if (result.data == NULL) {
        return result;
    }

    Interval current = a[0];

    for (size_t i = 1; i < n; i++) {
        if (a[i].start <= current.end) {
            if (a[i].end > current.end) {
                current.end = a[i].end;
            }
        } else {
            result.data[result.size++] = current;
            current = a[i];
        }
    }

    result.data[result.size++] = current;

    Interval *tmp = realloc(result.data,
                            result.size * sizeof(*tmp));

    if (tmp != NULL) {
        result.data = tmp;
    }

    return result;
}
```

### Complessità

- Tempo: `O(n)` perché gli intervalli sono già ordinati
- Spazio: `O(n)` nel caso peggiore

### Se gli intervalli non fossero ordinati

Servirebbe prima un ordinamento:

- tempo totale tipico `O(n log n)`;
- poi scansione lineare.

### Trappole

- dimenticare di inserire l'ultimo intervallo;
- distinguere sovrapposizione da adiacenza;
- usare `a[i].start < current.end` invece di `<=` quando l'adiacenza va fusa;
- restringere erroneamente `current.end`.

---

# Livello 6 — Esercizi “infernali” senza soluzione immediatamente ovvia

Questa sezione propone consegne da svolgere inizialmente senza guardare il codice. Le soluzioni sono comunque presenti sotto ogni traccia.

---

## Esercizio 33 — Minimo segmento da rimuovere per ottenere un array ordinato

### Consegna

Dato un array di interi, trovare la lunghezza minima di un segmento contiguo che, se rimosso, rende il resto dell'array ordinato in modo non decrescente.

Esempi:

```text
[1, 2, 3]             → 0
[5, 4, 3, 2, 1]       → 4
[1, 2, 3, 10, 4, 2, 3, 5] → 3
```

### Struttura di partenza

```c
size_t shortestRemovalForSorted(const int a[], size_t n);
```

### Soluzione semplice `O(n²)`

Provare ogni intervallo `[left, right)` da rimuovere e verificare se il resto è ordinato.

È corretta, ma può essere troppo lenta.

### Soluzione ottimizzata `O(n)`

```c
size_t shortestRemovalForSorted(const int a[], size_t n) {
    if (n < 2) {
        return 0;
    }

    size_t right = n - 1;

    while (right > 0 && a[right - 1] <= a[right]) {
        right--;
    }

    if (right == 0) {
        return 0;
    }

    size_t best = right;

    size_t left = 0;

    while (left + 1 < n && a[left] <= a[left + 1]) {
        left++;
    }

    size_t suffix = right;

    for (size_t prefix = 0; prefix <= left; prefix++) {
        while (suffix < n && a[suffix] < a[prefix]) {
            suffix++;
        }

        size_t removed = suffix - prefix - 1;

        if (removed < best) {
            best = removed;
        }
    }

    return best;
}
```

### Idea

1. Trova il suffisso già ordinato.
2. Trova il prefisso già ordinato.
3. Prova a collegare ogni possibile fine del prefisso con il primo elemento compatibile del suffisso.
4. Il puntatore sul suffisso avanza soltanto, quindi il tempo resta lineare.

---

## Esercizio 34 — Finestra minima contenente tutti i caratteri richiesti

### Consegna

Date due stringhe `s` e `required`, trovare la lunghezza della più corta sottostringa di `s` che contenga tutti i caratteri di `required` con le rispettive molteplicità.

Esempio:

```text
s = "ADOBECODEBANC"
required = "ABC"
risultato = 4  // "BANC"
```

Restituire `0` se nessuna finestra è valida.

### Struttura di partenza

```c
size_t minimumCoverLength(const char *s, const char *required);
```

### Soluzione ottimizzata con finestra scorrevole

```c
#include <limits.h>
#include <stddef.h>

size_t minimumCoverLength(const char *s, const char *required) {
    if (s == NULL || required == NULL ||
        required[0] == '\0') {
        return 0;
    }

    size_t need[UCHAR_MAX + 1] = {0};
    size_t have[UCHAR_MAX + 1] = {0};
    size_t missing = 0;

    for (size_t i = 0; required[i] != '\0'; i++) {
        need[(unsigned char)required[i]]++;
        missing++;
    }

    size_t left = 0;
    size_t best = (size_t)-1;

    for (size_t right = 0; s[right] != '\0'; right++) {
        unsigned char c = (unsigned char)s[right];
        have[c]++;

        if (have[c] <= need[c]) {
            missing--;
        }

        while (missing == 0) {
            size_t length = right - left + 1;

            if (length < best) {
                best = length;
            }

            unsigned char out = (unsigned char)s[left];
            have[out]--;

            if (have[out] < need[out]) {
                missing++;
            }

            left++;
        }
    }

    return best == (size_t)-1 ? 0 : best;
}
```

### Complessità

- Tempo: `O(|s| + |required|)`
- Spazio: `O(1)` rispetto alla lunghezza degli input

### Perché è difficile

Bisogna distinguere:

- quanti caratteri diversi servono;
- quante occorrenze complessive mancano;
- quando una finestra resta valida pur rimuovendo caratteri in eccesso.

---

## Esercizio 35 — Matrice a righe di lunghezza variabile: copia profonda selettiva

### Consegna

Si consideri una matrice irregolare:

```c
typedef struct {
    int **rows;
    size_t *lengths;
    size_t rowCount;
} RaggedMatrix;
```

Restituire una copia profonda contenente soltanto le righe la cui somma è strettamente positiva.

L'ordine delle righe deve essere preservato.

### Struttura di partenza

```c
RaggedMatrix copyPositiveRows(const RaggedMatrix *m);
void raggedDestroy(RaggedMatrix *m);
```

### Soluzione semplice

```c
#include <stdlib.h>
#include <string.h>

void raggedDestroy(RaggedMatrix *m) {
    if (m == NULL) {
        return;
    }

    for (size_t i = 0; i < m->rowCount; i++) {
        free(m->rows[i]);
    }

    free(m->rows);
    free(m->lengths);

    m->rows = NULL;
    m->lengths = NULL;
    m->rowCount = 0;
}

RaggedMatrix copyPositiveRows(const RaggedMatrix *m) {
    RaggedMatrix result = {NULL, NULL, 0};

    if (m == NULL) {
        return result;
    }

    size_t selected = 0;

    for (size_t i = 0; i < m->rowCount; i++) {
        long long sum = 0;

        for (size_t j = 0; j < m->lengths[i]; j++) {
            sum += m->rows[i][j];
        }

        if (sum > 0) {
            selected++;
        }
    }

    if (selected == 0) {
        return result;
    }

    result.rows = calloc(selected, sizeof(*result.rows));
    result.lengths = malloc(selected * sizeof(*result.lengths));

    if (result.rows == NULL || result.lengths == NULL) {
        free(result.rows);
        free(result.lengths);
        result.rows = NULL;
        result.lengths = NULL;
        return result;
    }

    size_t write = 0;

    for (size_t i = 0; i < m->rowCount; i++) {
        long long sum = 0;

        for (size_t j = 0; j < m->lengths[i]; j++) {
            sum += m->rows[i][j];
        }

        if (sum <= 0) {
            continue;
        }

        size_t length = m->lengths[i];

        if (length > 0) {
            result.rows[write] =
                malloc(length * sizeof(*result.rows[write]));

            if (result.rows[write] == NULL) {
                result.rowCount = write;
                raggedDestroy(&result);
                return result;
            }

            memcpy(result.rows[write],
                   m->rows[i],
                   length * sizeof(*result.rows[write]));
        }

        result.lengths[write] = length;
        write++;
    }

    result.rowCount = selected;
    return result;
}
```

### Punti valutati

- deep copy;
- cleanup parziale in caso di fallimento;
- righe vuote;
- ownership;
- preservazione dell'ordine;
- distinzione tra array di puntatori e contenuto delle righe.

---

# 7. Esercizi aggiuntivi senza soluzione completa

Questi esercizi servono a verificare se i pattern sono stati realmente interiorizzati.

## Array

1. Spostare tutti gli zeri in fondo in place preservando l'ordine dei non zeri.
2. Eliminare in place tutti gli elementi compresi tra due valori.
3. Restituire le lunghezze di tutti i blocchi massimali di valori uguali.
4. Trovare la prima posizione di equilibrio in cui la somma a sinistra uguaglia quella a destra.
5. Restituire l'unione senza duplicati di due array ordinati.
6. Restituire la differenza con molteplicità tra due array ordinati.
7. Riordinare in place `[a0,a1,...,an-1]` come `[a0,an-1,a1,an-2,...]`.
8. Trovare il più lungo segmento con somma esattamente `k`, prima con doppi cicli.
9. Verificare se un array è una rotazione di un altro.
10. Applicare una permutazione in place senza un secondo array, se la permutazione è valida.

## Stringhe

11. Rimuovere commenti `//` da una singola riga.
12. Verificare se due stringhe sono anagrammi considerando solo lettere e ignorando maiuscole.
13. Comprimere sequenze di spazi, tab e newline.
14. Restituire la parola più lunga; in caso di parità, la prima.
15. Restituire tutte le posizioni di una sottostringa.
16. Verificare se una stringa è ottenibile ruotandone un'altra.
17. Decodificare una stringa RLE come `"a3b2"`.
18. Restituire la più lunga ripetizione consecutiva di una sottostringa.
19. Eliminare coppie adiacenti uguali finché possibile.
20. Implementare una versione semplificata di `strstr`.

## Memoria dinamica

21. Ridimensionare una matrice contigua preservando la parte comune.
22. Inserire e rimuovere righe in una matrice irregolare.
23. Implementare `vectorInsert`, `vectorErase` e `vectorShrinkToFit`.
24. Copiare profondamente un array di struct contenenti stringhe dinamiche.
25. Ordinare un array di stringhe senza modificare le stringhe, spostando solo i puntatori.
26. Raggruppare valori uguali in una struttura `{value, count}` dinamica.
27. Costruire una tabella di frequenze ordinata.
28. Restituire tutte le sottostringhe di lunghezza `k` come array di stringhe.
29. Spezzare una stringa usando un separatore di più caratteri.
30. Implementare un buffer circolare dinamico di interi.

---

# 8. Checklist di correzione per ogni soluzione

## Correttezza funzionale

- [ ] Il caso vuoto è gestito?
- [ ] Il primo e l'ultimo elemento sono trattati correttamente?
- [ ] L'ordine richiesto è preservato?
- [ ] I duplicati sono gestiti secondo la specifica?
- [ ] Il risultato è sempre terminato da `'\0'`, se è una stringa?
- [ ] Le dimensioni sono espresse in elementi o in byte nel punto corretto?
- [ ] Gli intervalli sono inclusivi o esclusivi come richiesto?
- [ ] L'input resta invariato quando richiesto?

## Memoria

- [ ] Ogni `malloc`, `calloc` o `realloc` è controllata?
- [ ] `realloc` usa un puntatore temporaneo?
- [ ] In caso di errore, la memoria già allocata viene liberata?
- [ ] Non si perde il vecchio puntatore se `realloc` fallisce?
- [ ] Non si esegue `free` su memoria non posseduta?
- [ ] Non si usa un puntatore dopo `free`?
- [ ] Le copie sono profonde quando necessario?
- [ ] La funzione di distruzione azzera i campi?

## Complessità

- [ ] Esiste un doppio ciclo evitabile?
- [ ] Si sta sfruttando l'ordinamento degli input?
- [ ] Una serie di `strcat` sta introducendo `O(n²)`?
- [ ] La capacità cresce geometricamente?
- [ ] Il problema può essere risolto con due indici?
- [ ] Serve davvero una soluzione più sofisticata?

---

# 9. Ordine consigliato di allenamento

## Prima tornata — padronanza degli scheletri

```text
1, 2, 3, 4, 5
13, 14, 17
24, 25
```

Obiettivo: scriverli senza consultare soluzioni.

## Seconda tornata — due cursori e ordine

```text
6, 7, 8, 9, 10
15, 16, 18
26, 28, 29
```

Obiettivo: riconoscere immediatamente:

- due indici;
- scansione parallela;
- costruzione stabile;
- dimensione esatta dell'output.

## Terza tornata — algoritmi e memoria dinamica

```text
11, 12
19, 20, 21, 22, 23
27, 30, 31, 32
```

Obiettivo: tenere insieme correttezza, efficienza e ownership.

## Quarta tornata — simulazione appello difficile

```text
33, 34, 35
```

Procedura:

1. 10 minuti per analizzare la specifica.
2. Scrivere esempi e casi limite.
3. Scrivere prima una soluzione semplice corretta.
4. Valutare la complessità.
5. Ottimizzare soltanto dopo.
6. Compilare con warning e sanitizer.
7. Costruire test che colpiscano implementazioni quasi corrette.

---

# 10. Schema universale per affrontare una consegna

```text
INPUT
- tipo e dimensione
- può essere vuoto?
- può essere NULL?
- ordinato?
- modificabile?

OUTPUT
- valore singolo?
- nuovo array?
- nuova stringa?
- lunghezza separata?
- chi libera?

VINCOLI
- preservare ordine?
- no malloc?
- non modificare input?
- no funzioni di libreria?
- complessità richiesta?

ALGORITMO
- una scansione?
- due indici?
- due passaggi?
- finestra scorrevole?
- merge?
- array temporaneo?
- crescita dinamica?

MEMORIA
- numero di elementi
- numero di byte
- terminatore
- cleanup in caso di errore

TEST
- vuoto
- singolo elemento
- tutti selezionati
- nessuno selezionato
- duplicati
- valori ai bordi
- output più lungo dell'input
- output più corto dell'input
```

La capacità decisiva non è ricordare trentacinque funzioni. È riconoscere che quasi tutte sono combinazioni di pochi pattern:

```text
scansione
+ condizione
+ due indici
+ costruzione o modifica
+ ownership
+ terminazione corretta
```
