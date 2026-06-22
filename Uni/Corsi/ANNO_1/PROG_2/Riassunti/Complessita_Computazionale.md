# Complessità Computazionale

## Obiettivo della lezione

La **complessità computazionale** serve a descrivere quanto “costa” eseguire un algoritmo quando cresce la dimensione dell’input.

In particolare studiamo:

* **complessità temporale**: quanti passi elementari vengono eseguiti;
* **complessità spaziale**: quanta memoria aggiuntiva viene usata;
* **andamento asintotico**: come cresce il costo per input molto grandi;
* **notazione O grande**: limite superiore asintotico;
* **notazione Θ grande**: crescita asintotica precisa;
* **caso migliore** e **caso peggiore**.

L’idea fondamentale è questa:

> Non ci interessa sapere esattamente quanti nanosecondi impiega un programma su un certo computer, ma capire come cresce il suo costo quando l’input diventa grande.

---

# 1. Tempo e spazio di calcolo

## Complessità temporale

La complessità temporale misura il numero di **passi elementari** eseguiti da un algoritmo.

Un passo elementare può essere, per esempio:

* un’operazione aritmetica;
* un confronto;
* un’assegnazione;
* un accesso a una variabile;
* un accesso a un elemento di array;
* un accesso a un campo di una `struct`;
* una chiamata di funzione;
* un ritorno da funzione;
* il test di un `if`;
* il test di un ciclo.

In C, ogni istruzione viene poi tradotta in istruzioni macchina. Per studiare gli algoritmi, però, assumiamo che ogni operazione elementare abbia costo costante.

Quindi:

```text
tempo di calcolo ≈ numero di passi elementari
```

Non ci interessa la macchina specifica.

---

## Complessità spaziale

La complessità spaziale misura quanta memoria aggiuntiva serve all’algoritmo durante l’esecuzione.

Attenzione:

> Di solito, quando si calcola la complessità spaziale, non si conta lo spazio occupato dall’input.

Esempio:

```c
int maximum(const int a[], int n) {
    int max = a[0];

    for (int i = 1; i < n; i++) {
        if (max < a[i]) {
            max = a[i];
        }
    }

    return max;
}
```

L’array `a` è input, quindi non viene contato nello spazio aggiuntivo.

Le variabili aggiuntive sono:

```c
int max;
int i;
```

Quindi lo spazio è costante:

```text
S(n) ∈ Θ(1)
```

---

# 2. Dimensione dell’input

Per studiare la complessità dobbiamo prima capire qual è la **dimensione dell’input**.

Negli esempi delle slide, la dimensione dell’input è spesso:

```text
n = numero di elementi dell’array considerati
```

Esempio:

```c
int maximum(const int a[], int n);
```

Qui `n` è la lunghezza della porzione di array `a[0..n-1]`.

Quindi:

```text
dimensione input = n
```

Questa cosa va sempre detta all’esame.

Una buona risposta parte così:

> Sia `n` la dimensione dell’input, cioè il numero di elementi dell’array su cui l’algoritmo opera.

---

# 3. Caso migliore e caso peggiore

Uno stesso algoritmo può richiedere tempi diversi su input diversi della stessa dimensione.

Per questo distinguiamo:

## Caso migliore

Il **caso migliore** è l’input di dimensione `n` su cui l’algoritmo impiega meno tempo.

Formalmente:

```text
Tb(n) = min { t(I) | I ha dimensione n }
```

Dove:

* `Tb(n)` è il tempo nel caso migliore;
* `t(I)` è il tempo di esecuzione sull’input specifico `I`.

---

## Caso peggiore

Il **caso peggiore** è l’input di dimensione `n` su cui l’algoritmo impiega più tempo.

Formalmente:

```text
Tw(n) = max { t(I) | I ha dimensione n }
```

Dove:

* `Tw(n)` è il tempo nel caso peggiore;
* `t(I)` è il tempo di esecuzione sull’input specifico `I`.

---

## Esempio intuitivo

Consideriamo la ricerca sequenziale:

```c
int search(const int a[], size_t n, int key) {
    for (size_t i = 0; i < n; i++) {
        if (key == a[i]) {
            return (int)i;
        }
    }

    return -1;
}
```

Caso migliore:

```text
key == a[0]
```

Trovo subito l’elemento.

Quindi:

```text
Tb(n) ∈ Θ(1)
```

Caso peggiore:

```text
key non presente
```

oppure:

```text
key in ultima posizione
```

Devo controllare tutto l’array.

Quindi:

```text
Tw(n) ∈ Θ(n)
```

---

# 4. Esempio 1: massimo di un array

Codice:

```c
int maximum(const int a[], int n) {
    int max = a[0];

    for (int i = 1; i < n; i++) {
        if (max < a[i]) {
            max = a[i];
        }
    }

    return max;
}
```

## Cosa fa

Restituisce il massimo nella porzione:

```text
a[0..n-1]
```

Precondizione:

```text
n >= 1
```

Perché accediamo subito ad `a[0]`.

---

## Dimensione dell’input

```text
n = numero di elementi dell’array considerati
```

---

## Caso migliore

Il massimo si trova in posizione `0`.

Esempio:

```text
[99, 4, 7, 1, 3]
```

Il massimo è già `a[0]`.

Però il ciclo deve comunque controllare tutti gli altri elementi, perché non può sapere in anticipo che `99` sia davvero il massimo.

Quindi il ciclo viene comunque eseguito `n - 1` volte.

Risultato:

```text
Tb(n) ∈ Θ(n)
```

---

## Caso peggiore

L’array è ordinato in ordine strettamente crescente.

Esempio:

```text
[1, 3, 5, 9, 12]
```

Ogni nuovo elemento diventa il nuovo massimo.

Quindi l’assegnazione:

```c
max = a[i];
```

viene eseguita molte volte.

Però anche qui il numero di iterazioni resta proporzionale a `n`.

Risultato:

```text
Tw(n) ∈ Θ(n)
```

---

## Complessità spaziale

Le variabili aggiuntive sono:

```c
int max;
int i;
```

L’array non si conta perché è input.

Quindi:

```text
S(n) ∈ Θ(1)
```

---

## Conclusione

```text
maximum
Tempo caso migliore: Θ(n)
Tempo caso peggiore: Θ(n)
Spazio: Θ(1)
```

Nota importante:

> Anche se nel caso migliore eseguo meno assegnazioni, devo comunque leggere tutti gli elementi. Per questo il massimo di un array non ordinato è lineare anche nel caso migliore.

---

# 5. Esempio 2: ricerca sequenziale

Codice:

```c
int search(const int a[], size_t n, int key) {
    for (size_t i = 0; i < n; i++) {
        if (key == a[i]) {
            return (int)i;
        }
    }

    return -1;
}
```

## Cosa fa

Cerca `key` nell’array e restituisce:

* l’indice della prima occorrenza di `key`;
* `-1` se `key` non compare.

---

## Dimensione dell’input

```text
n = numero di elementi dell’array
```

---

## Caso migliore

`key` è in posizione `0`.

Esempio:

```text
key = 7
a = [7, 3, 9, 2, 1]
```

L’algoritmo controlla il primo elemento e termina subito.

Quindi:

```text
Tb(n) ∈ Θ(1)
```

---

## Caso peggiore

`key` è in ultima posizione:

```text
key = 7
a = [3, 9, 2, 1, 7]
```

oppure non è presente:

```text
key = 7
a = [3, 9, 2, 1, 5]
```

In entrambi i casi, l’algoritmo deve scorrere tutti gli elementi.

Quindi:

```text
Tw(n) ∈ Θ(n)
```

---

## Complessità spaziale

L’unica variabile aggiuntiva rilevante è:

```c
size_t i;
```

Quindi:

```text
S(n) ∈ Θ(1)
```

---

## Conclusione

```text
search
Tempo caso migliore: Θ(1)
Tempo caso peggiore: Θ(n)
Spazio: Θ(1)
```

---

# 6. Esempio 3: ricerca binaria

La ricerca binaria funziona solo se l’array è ordinato.

Precondizione fondamentale:

```text
a[0..n-1] ordinato in ordine crescente
```

---

## Idea della ricerca binaria

Invece di controllare gli elementi uno alla volta, controllo l’elemento centrale.

Se `key` è più piccolo del valore centrale, continuo nella metà sinistra.

Se `key` è più grande, continuo nella metà destra.

Se è uguale, ho trovato l’elemento.

A ogni iterazione dimezzo la porzione in cui cercare.

---

## Versione C robusta

Una versione sicura, evitando problemi con `size_t` e sottrazioni sotto zero, è questa:

```c
#include <stddef.h>

int binSearch(const int a[], size_t n, int key) {
    size_t low = 0;
    size_t high = n;   // intervallo [low, high)

    while (low < high) {
        size_t middle = low + (high - low) / 2;

        if (key < a[middle]) {
            high = middle;
        } else if (key > a[middle]) {
            low = middle + 1;
        } else {
            return (int)middle;
        }
    }

    return -1;
}
```

Questa versione usa l’intervallo semiaperto:

```text
[low, high)
```

cioè include `low`, ma esclude `high`.

All’inizio:

```text
[0, n)
```

cioè tutto l’array.

---

## Dimensione dell’input

```text
n = numero di elementi dell’array ordinato
```

---

## Caso migliore

`key` si trova subito al centro.

Esempio:

```text
a = [1, 3, 5, 7, 9]
key = 5
```

L’algoritmo controlla l’elemento centrale e termina.

Quindi:

```text
Tb(n) ∈ Θ(1)
```

---

## Caso peggiore

`key` non è presente oppure si trova in una posizione che richiede il massimo numero di dimezzamenti.

Esempio:

```text
a = [1, 3, 5, 7, 9, 11, 13, 15]
key = 14
```

A ogni iterazione dimezzo la dimensione del problema:

```text
n
n/2
n/4
n/8
...
1
```

Quante volte posso dividere `n` per `2` prima di arrivare a `1`?

Circa:

```text
log2(n)
```

Quindi:

```text
Tw(n) ∈ Θ(log2 n)
```

---

## Complessità spaziale

Variabili aggiuntive:

```c
size_t low;
size_t high;
size_t middle;
```

Il numero di variabili non dipende da `n`.

Quindi:

```text
S(n) ∈ Θ(1)
```

---

## Conclusione

```text
binSearch
Tempo caso migliore: Θ(1)
Tempo caso peggiore: Θ(log n)
Spazio: Θ(1)
```

---

# 7. Crescita lineare

Una funzione ha crescita lineare quando è proporzionale a `n`.

Esempio:

```text
T(n) = 3n + 5
```

Il termine dominante è:

```text
n
```

Quindi:

```text
T(n) ∈ Θ(n)
```

---

## Cosa significa intuitivamente

Se raddoppio l’input:

```text
n → 2n
```

allora il tempo circa raddoppia.

Se triplico l’input:

```text
n → 3n
```

allora il tempo circa triplica.

---

## Esempi di algoritmi Θ(n)

* ricerca sequenziale nel caso peggiore;
* calcolo del massimo di un array;
* somma degli elementi di un array;
* conteggio degli elementi che soddisfano una proprietà.

Esempio:

```c
int sumArray(const int a[], size_t n) {
    int sum = 0;

    for (size_t i = 0; i < n; i++) {
        sum += a[i];
    }

    return sum;
}
```

Complessità:

```text
Tempo: Θ(n)
Spazio: Θ(1)
```

---

# 8. Crescita quadratica

Una funzione ha crescita quadratica quando il termine dominante è `n²`.

Esempio:

```text
T(n) = 3n² + 5n + 9
```

Il termine dominante è:

```text
n²
```

Quindi:

```text
T(n) ∈ Θ(n²)
```

---

## Cosa significa intuitivamente

Se raddoppio l’input:

```text
n → 2n
```

allora il tempo circa quadruplica:

```text
n² → (2n)² = 4n²
```

Se triplico l’input:

```text
n → 3n
```

allora il tempo circa diventa nove volte più grande:

```text
n² → (3n)² = 9n²
```

---

## Esempio tipico: due cicli annidati

```c
void printPairs(const int a[], size_t n) {
    for (size_t i = 0; i < n; i++) {
        for (size_t j = 0; j < n; j++) {
            printf("(%d, %d)\n", a[i], a[j]);
        }
    }
}
```

Il ciclo esterno fa `n` iterazioni.

Per ogni iterazione del ciclo esterno, il ciclo interno fa `n` iterazioni.

Totale:

```text
n * n = n²
```

Complessità:

```text
Tempo: Θ(n²)
Spazio: Θ(1)
```

---

# 9. Crescita logaritmica

Una funzione ha crescita logaritmica quando il problema viene ridotto di un fattore costante a ogni passo.

Esempio classico:

```text
ricerca binaria
```

A ogni iterazione dimezzo l’intervallo di ricerca.

Quindi:

```text
n
n/2
n/4
n/8
...
1
```

Il numero di iterazioni è:

```text
log2(n)
```

---

## Cosa significa intuitivamente

La crescita logaritmica è molto lenta.

Esempio:

```text
n = 1 000 000
log2(n) ≈ 20
```

Quindi su un milione di elementi, la ricerca binaria può richiedere circa 20 confronti nel caso peggiore.

Questo è il motivo per cui `Θ(log n)` è molto meglio di `Θ(n)` per input grandi.

---

# 10. Fattori costanti e termini trascurabili

Nell’analisi asintotica ignoriamo:

* costanti moltiplicative;
* termini di grado inferiore;
* termini costanti.

Esempi:

```text
5n + 3 ∈ Θ(n)
100n + 9000 ∈ Θ(n)
3n² + 5n + 9 ∈ Θ(n²)
7log2(n) + 100 ∈ Θ(log n)
```

---

## Perché ignoriamo le costanti?

Perché vogliamo capire la crescita per input molto grandi.

Esempio:

```text
T1(n) = 5n
T2(n) = 100n
```

Entrambe crescono linearmente.

Anche se `T2` è più lenta, entrambe appartengono a:

```text
Θ(n)
```

---

## Però attenzione alla pratica

Asintoticamente:

```text
n ∈ O(n²)
```

ma un algoritmo lineare con costanti enormi può essere più lento, per input piccoli o medi, di un algoritmo quadratico con costanti molto piccole.

Esempio:

```text
P1(n) = 1000000n
P2(n) = n²
```

Per certi valori piccoli di `n`, può succedere che:

```text
P2(n) < P1(n)
```

Anche se `P2` è asintoticamente peggiore.

Conclusione importante:

> L’analisi asintotica è fondamentale per capire il comportamento su input grandi, ma nella pratica possono contare anche costanti, cache, implementazione, macchina e dati reali.

---

# 11. Notazione O grande

## Significato informale

Scrivere:

```text
g(n) ∈ O(f(n))
```

significa:

```text
g cresce al più come f
```

oppure:

```text
f è un limite superiore asintotico per g
```

---

## Definizione

```text
O(f(n)) = { h | esistono c > 0 e n0 >= 0 tali che
           per ogni n >= n0 vale h(n) <= c * f(n) }
```

In parole semplici:

> Da un certo punto in poi, `h(n)` resta sotto un multiplo costante di `f(n)`.

---

## Esempi

```text
3n + 5 ∈ O(n)
3n + 5 ∈ O(n²)
n² + 7n + 10 ∈ O(n²)
log n ∈ O(n)
1 ∈ O(n)
```

Attenzione:

```text
O grande non dice necessariamente la crescita precisa.
```

Per esempio:

```text
3n + 5 ∈ O(n²)
```

è vero, ma poco preciso.

Una descrizione più precisa è:

```text
3n + 5 ∈ Θ(n)
```

---

# 12. Notazione Θ grande

## Significato informale

Scrivere:

```text
g(n) ∈ Θ(f(n))
```

significa:

```text
g cresce come f
```

Cioè `f` è sia un limite superiore sia un limite inferiore asintotico per `g`.

---

## Definizione

```text
Θ(f(n)) = { h | esistono c1, c2 > 0 e n0 >= 0 tali che
           per ogni n >= n0 vale c1*f(n) <= h(n) <= c2*f(n) }
```

In parole semplici:

> Da un certo punto in poi, `h(n)` rimane compresa tra due multipli costanti di `f(n)`.

---

## Esempi

```text
3n + 5 ∈ Θ(n)
100n + 2 ∈ Θ(n)
4n² + 20n + 1 ∈ Θ(n²)
7log2(n) + 10 ∈ Θ(log n)
```

---

# 13. Differenza tra O e Θ

## O grande

`O` indica un limite superiore.

Esempio:

```text
3n + 5 ∈ O(n²)
```

Vero, perché una funzione lineare è sicuramente limitata superiormente da una quadratica per `n` abbastanza grande.

Però non è una descrizione precisa.

---

## Θ grande

`Θ` indica la crescita precisa.

Esempio:

```text
3n + 5 ∈ Θ(n)
```

Questa è l’informazione migliore.

---

## Come ricordarselo

```text
O(f(n))  = cresce al massimo come f(n)
Θ(f(n)) = cresce esattamente come f(n), a meno di costanti
```

---

# 14. Confronto tra search e binSearch

## Ricerca sequenziale

```c
int search(const int a[], size_t n, int key) {
    for (size_t i = 0; i < n; i++) {
        if (key == a[i]) {
            return (int)i;
        }
    }

    return -1;
}
```

Complessità:

```text
Caso migliore: Θ(1)
Caso peggiore: Θ(n)
Spazio: Θ(1)
```

Vantaggio:

```text
Funziona anche su array non ordinati.
```

Svantaggio:

```text
Nel caso peggiore deve guardare tutti gli elementi.
```

---

## Ricerca binaria

```c
int binSearch(const int a[], size_t n, int key) {
    size_t low = 0;
    size_t high = n;

    while (low < high) {
        size_t middle = low + (high - low) / 2;

        if (key < a[middle]) {
            high = middle;
        } else if (key > a[middle]) {
            low = middle + 1;
        } else {
            return (int)middle;
        }
    }

    return -1;
}
```

Complessità:

```text
Caso migliore: Θ(1)
Caso peggiore: Θ(log n)
Spazio: Θ(1)
```

Vantaggio:

```text
Molto più efficiente su array grandi.
```

Svantaggio:

```text
Richiede che l’array sia ordinato.
```

---

## Tabella di confronto

| Algoritmo   | Input richiesto | Caso migliore | Caso peggiore | Spazio |
| ----------- | --------------- | ------------- | ------------- | ------ |
| `search`    | array qualunque | Θ(1)          | Θ(n)          | Θ(1)   |
| `binSearch` | array ordinato  | Θ(1)          | Θ(log n)      | Θ(1)   |

---

## Osservazione importante

Per array molto piccoli, la ricerca sequenziale può essere più conveniente della ricerca binaria.

Perché?

La ricerca binaria ha più logica interna:

```c
middle = ...
if ...
else if ...
else ...
```

Mentre la ricerca sequenziale è semplicissima.

Quindi, per input piccoli, le costanti possono contare più dell’andamento asintotico.

Per input grandi, invece, `Θ(log n)` vince nettamente su `Θ(n)`.

---

# 15. Operazione dominante

A volte non conviene contare tutti i passi elementari, ma solo l’operazione più importante, detta:

```text
operazione dominante
```

Esempio:

In un algoritmo di ordinamento, il confronto tra chiavi può essere molto costoso.

Allora possiamo contare solo il numero di confronti.

Esempio:

```text
quanti confronti tra chiavi fa l’algoritmo?
```

Questo è utile quando un’operazione pesa molto più delle altre.

Attenzione però:

> Bisogna verificare che l’andamento asintotico delle operazioni dominanti sia rappresentativo dell’andamento complessivo.

---

# 16. Esercizio delle slide: smartSearch

La funzione richiesta è:

```c
int smartSearch(const int a[], size_t n, int key);
```

L’array è ordinato.

La funzione deve restituire:

* l’indice dell’ultima occorrenza di `key`;
* `-1` se `key` non compare.

Inoltre deve fermarsi appena incontra un elemento maggiore di `key`.

---

## Idea

Dato che l’array è ordinato, se durante la scansione trovo:

```text
a[i] > key
```

posso fermarmi.

Perché tutti gli elementi successivi saranno ancora più grandi o uguali.

---

## Possibile implementazione

```c
#include <stddef.h>

int smartSearch(const int a[], size_t n, int key) {
    int lastFound = -1;

    for (size_t i = 0; i < n; i++) {
        if (a[i] == key) {
            lastFound = (int)i;
        } else if (a[i] > key) {
            return lastFound;
        }
    }

    return lastFound;
}
```

---

## Esempio

```text
a = [1, 2, 2, 2, 5, 8, 10]
key = 2
```

L’algoritmo visita:

```text
1, 2, 2, 2, 5
```

Quando trova `5`, capisce che non potranno esserci altri `2`.

Restituisce:

```text
3
```

cioè l’indice dell’ultima occorrenza di `2`.

---

## Caso migliore

Ci sono due casi molto favorevoli.

### Caso 1: il primo elemento è già maggiore di key

Esempio:

```text
a = [5, 7, 9]
key = 3
```

Alla prima iterazione:

```text
a[0] > key
```

quindi termina subito.

Complessità:

```text
Θ(1)
```

### Caso 2: key è presente solo in posizione 0 e subito dopo arriva un elemento maggiore

Esempio:

```text
a = [3, 5, 7, 9]
key = 3
```

Visita pochi elementi e termina.

Anche qui:

```text
Θ(1)
```

Quindi:

```text
Tb(n) ∈ Θ(1)
```

---

## Caso peggiore

Il caso peggiore si ha quando l’algoritmo deve arrivare fino alla fine.

Succede per esempio se:

```text
key è maggiore di tutti gli elementi
```

Esempio:

```text
a = [1, 2, 3, 4, 5]
key = 99
```

Oppure se `key` è uguale a molti elementi fino alla fine:

```text
a = [1, 2, 3, 5, 5, 5]
key = 5
```

In questi casi devo visitare tutti gli elementi.

Quindi:

```text
Tw(n) ∈ Θ(n)
```

---

## Complessità spaziale

Variabili aggiuntive:

```c
int lastFound;
size_t i;
```

Quindi:

```text
S(n) ∈ Θ(1)
```

---

## Tabella smartSearch

| Algoritmo     | Input richiesto | Caso migliore | Caso peggiore | Spazio |
| ------------- | --------------- | ------------- | ------------- | ------ |
| `smartSearch` | array ordinato  | Θ(1)          | Θ(n)          | Θ(1)   |

---

## Confronto search, smartSearch, binSearch

| Algoritmo     | Input           | Cosa cerca        | Caso migliore | Caso peggiore | Spazio |
| ------------- | --------------- | ----------------- | ------------- | ------------- | ------ |
| `search`      | array qualunque | prima occorrenza  | Θ(1)          | Θ(n)          | Θ(1)   |
| `smartSearch` | array ordinato  | ultima occorrenza | Θ(1)          | Θ(n)          | Θ(1)   |
| `binSearch`   | array ordinato  | una occorrenza    | Θ(1)          | Θ(log n)      | Θ(1)   |

Nota:

> `smartSearch` sfrutta l’ordinamento per fermarsi prima in alcuni casi, ma nel caso peggiore resta lineare.

---

# 17. Come analizzare un algoritmo all’esame

Quando ti chiedono la complessità di un algoritmo, segui sempre questa scaletta.

---

## Passo 1: identifica la dimensione dell’input

Esempio:

```text
Sia n il numero di elementi dell’array.
```

Oppure:

```text
Sia n il numero di nodi della lista.
```

Oppure:

```text
Sia n il numero di caratteri della stringa.
```

---

## Passo 2: individua le parti che dipendono da n

Guarda:

* cicli;
* ricorsione;
* chiamate a funzioni;
* allocazioni;
* scansioni di array/liste;
* accessi annidati.

---

## Passo 3: valuta caso migliore e peggiore

Chiediti:

* può terminare subito?
* deve sempre leggere tutto?
* esiste un input che lo costringe a fare il massimo lavoro?
* l’array è ordinato?
* c’è un `return` dentro il ciclo?
* c’è un `break`?
* il ciclo si dimezza ogni volta?

---

## Passo 4: semplifica asintoticamente

Esempi:

```text
7n + 3        → Θ(n)
5n² + 2n + 1  → Θ(n²)
10log n + 90  → Θ(log n)
42            → Θ(1)
```

Regola pratica:

> Conta il termine che cresce più velocemente e ignora costanti e termini più piccoli.

---

## Passo 5: calcola lo spazio

Chiediti:

* quante variabili aggiuntive creo?
* alloco array ausiliari?
* uso ricorsione?
* creo nuove strutture dati?
* lo spazio cresce con `n`?

Esempi:

```text
solo poche variabili → Θ(1)
array ausiliario di n elementi → Θ(n)
matrice n x n → Θ(n²)
ricorsione con profondità n → Θ(n) sullo stack
```

---

# 18. Esempi da riscrivere per prendere confidenza

## Esercizio 1: massimo di un array

Scrivere e testare:

```c
#include <stdio.h>

int maximum(const int a[], int n) {
    int max = a[0];

    for (int i = 1; i < n; i++) {
        if (max < a[i]) {
            max = a[i];
        }
    }

    return max;
}

int main(void) {
    int a[] = {4, 9, 2, 17, 3};
    int n = sizeof(a) / sizeof(a[0]);

    printf("Massimo = %d\n", maximum(a, n));

    return 0;
}
```

Da sapere spiegare:

```text
Tempo: Θ(n)
Spazio: Θ(1)
```

---

## Esercizio 2: ricerca sequenziale

```c
#include <stdio.h>
#include <stddef.h>

int search(const int a[], size_t n, int key) {
    for (size_t i = 0; i < n; i++) {
        if (key == a[i]) {
            return (int)i;
        }
    }

    return -1;
}

int main(void) {
    int a[] = {4, 9, 2, 17, 3};
    size_t n = sizeof(a) / sizeof(a[0]);

    int key = 17;
    int index = search(a, n, key);

    if (index != -1) {
        printf("Trovato in posizione %d\n", index);
    } else {
        printf("Non trovato\n");
    }

    return 0;
}
```

Da sapere spiegare:

```text
Caso migliore: Θ(1)
Caso peggiore: Θ(n)
Spazio: Θ(1)
```

---

## Esercizio 3: ricerca binaria

```c
#include <stdio.h>
#include <stddef.h>

int binSearch(const int a[], size_t n, int key) {
    size_t low = 0;
    size_t high = n;

    while (low < high) {
        size_t middle = low + (high - low) / 2;

        if (key < a[middle]) {
            high = middle;
        } else if (key > a[middle]) {
            low = middle + 1;
        } else {
            return (int)middle;
        }
    }

    return -1;
}

int main(void) {
    int a[] = {1, 3, 5, 7, 9, 11, 13};
    size_t n = sizeof(a) / sizeof(a[0]);

    int key = 7;
    int index = binSearch(a, n, key);

    if (index != -1) {
        printf("Trovato in posizione %d\n", index);
    } else {
        printf("Non trovato\n");
    }

    return 0;
}
```

Da sapere spiegare:

```text
Caso migliore: Θ(1)
Caso peggiore: Θ(log n)
Spazio: Θ(1)
```

---

## Esercizio 4: smartSearch

```c
#include <stdio.h>
#include <stddef.h>

int smartSearch(const int a[], size_t n, int key) {
    int lastFound = -1;

    for (size_t i = 0; i < n; i++) {
        if (a[i] == key) {
            lastFound = (int)i;
        } else if (a[i] > key) {
            return lastFound;
        }
    }

    return lastFound;
}

int main(void) {
    int a[] = {1, 2, 2, 2, 5, 8, 10};
    size_t n = sizeof(a) / sizeof(a[0]);

    int key = 2;
    int index = smartSearch(a, n, key);

    if (index != -1) {
        printf("Ultima occorrenza in posizione %d\n", index);
    } else {
        printf("Non trovato\n");
    }

    return 0;
}
```

Da sapere spiegare:

```text
Caso migliore: Θ(1)
Caso peggiore: Θ(n)
Spazio: Θ(1)
```

---

# 19. Errori tipici da evitare

## Errore 1: dire che maximum è Θ(1) nel caso migliore

Sbagliato.

Anche se il massimo è in posizione `0`, il ciclo deve comunque verificare tutti gli altri elementi.

Corretto:

```text
maximum è Θ(n) sia nel caso migliore sia nel caso peggiore
```

---

## Errore 2: confondere O e Θ

Dire:

```text
T(n) = O(n²)
```

per una funzione lineare non è falso, ma è poco preciso.

Meglio dire:

```text
T(n) = Θ(n)
```

quando si conosce la crescita esatta.

---

## Errore 3: dimenticare la precondizione della ricerca binaria

La ricerca binaria funziona solo se l’array è ordinato.

Senza ordinamento, il risultato non è affidabile.

---

## Errore 4: contare l’array di input nello spazio

Se l’array viene passato alla funzione come input, non lo conto come spazio aggiuntivo.

Esempio:

```c
int sumArray(const int a[], size_t n);
```

Spazio:

```text
Θ(1)
```

Non:

```text
Θ(n)
```

---

## Errore 5: pensare che due cicli siano sempre Θ(n²)

Non sempre.

Esempio:

```c
for (int i = 0; i < n; i++) {
    printf("%d\n", i);
}

for (int j = 0; j < n; j++) {
    printf("%d\n", j);
}
```

Sono due cicli separati:

```text
n + n = 2n
```

Quindi:

```text
Θ(n)
```

Invece:

```c
for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
        printf("%d %d\n", i, j);
    }
}
```

Sono cicli annidati:

```text
n * n = n²
```

Quindi:

```text
Θ(n²)
```

---

# 20. Mini formulario

## Complessità comuni

| Forma           | Complessità |
| --------------- | ----------- |
| `42`            | Θ(1)        |
| `3n + 5`        | Θ(n)        |
| `100n + 9000`   | Θ(n)        |
| `4n² + 2n + 1`  | Θ(n²)       |
| `7log n + 10`   | Θ(log n)    |
| `n log n + n`   | Θ(n log n)  |
| `2n³ + 9n² + 1` | Θ(n³)       |

---

## Crescite ordinate dalla migliore alla peggiore

```text
Θ(1)
Θ(log n)
Θ(n)
Θ(n log n)
Θ(n²)
Θ(n³)
Θ(2^n)
```

---

# 21. Frasi da usare all’esame

## Per maximum

> La dimensione dell’input è `n`, cioè il numero di elementi dell’array considerati. La funzione deve confrontare il massimo corrente con tutti gli elementi dell’array, quindi sia nel caso migliore sia nel caso peggiore il tempo è Θ(n). Lo spazio è Θ(1), perché usa solo un numero costante di variabili aggiuntive.

---

## Per search

> Nel caso migliore l’elemento cercato si trova in prima posizione, quindi la funzione termina dopo un numero costante di operazioni: Θ(1). Nel caso peggiore l’elemento è assente oppure si trova in ultima posizione, quindi vengono controllati tutti gli elementi: Θ(n). Lo spazio è Θ(1).

---

## Per binSearch

> La ricerca binaria richiede che l’array sia ordinato. Nel caso migliore l’elemento cercato è al centro e viene trovato subito, quindi il tempo è Θ(1). Nel caso peggiore, a ogni iterazione lo spazio di ricerca viene dimezzato, quindi il numero di iterazioni è proporzionale a log₂(n). Il tempo è Θ(log n) e lo spazio è Θ(1).

---

## Per O grande

> Dire che `g(n)` è `O(f(n))` significa che, da un certo valore di `n` in poi, `g(n)` è limitata superiormente da un multiplo costante di `f(n)`.

---

## Per Θ grande

> Dire che `g(n)` è `Θ(f(n))` significa che, da un certo valore di `n` in poi, `g(n)` è compresa tra due multipli costanti di `f(n)`. Quindi le due funzioni hanno la stessa crescita asintotica.

---

# 22. Checklist finale da 30 e lode

Prima dell’esame devo saper fare queste cose:

* [ ] Spiegare cosa misura la complessità temporale.
* [ ] Spiegare cosa misura la complessità spaziale.
* [ ] Dire qual è la dimensione dell’input.
* [ ] Distinguere caso migliore e caso peggiore.
* [ ] Capire quando un algoritmo è Θ(1).
* [ ] Capire quando un algoritmo è Θ(n).
* [ ] Capire quando un algoritmo è Θ(n²).
* [ ] Capire quando un algoritmo è Θ(log n).
* [ ] Spiegare perché `maximum` è Θ(n) anche nel caso migliore.
* [ ] Spiegare perché `search` è Θ(1) nel caso migliore e Θ(n) nel peggiore.
* [ ] Spiegare perché `binSearch` è Θ(log n) nel caso peggiore.
* [ ] Non confondere O grande e Θ grande.
* [ ] Sapere che i fattori costanti sono ignorati nell’analisi asintotica.
* [ ] Sapere che nella pratica le costanti possono comunque contare.
* [ ] Sapere cos’è un’operazione dominante.
* [ ] Saper riscrivere `maximum`, `search`, `binSearch` e `smartSearch` in C.

---

# 23. Riassunto super compatto

La complessità computazionale studia come crescono tempo e spazio al crescere della dimensione dell’input.

Il tempo si misura contando passi elementari.

Lo spazio si misura contando memoria aggiuntiva, senza contare l’input.

La notazione `O` dà un limite superiore asintotico.

La notazione `Θ` dà una crescita asintotica precisa.

Il caso migliore è l’input più favorevole di dimensione `n`.

Il caso peggiore è l’input più sfavorevole di dimensione `n`.

Esempi fondamentali:

```text
maximum:
Tb(n) = Θ(n)
Tw(n) = Θ(n)
S(n)  = Θ(1)

search:
Tb(n) = Θ(1)
Tw(n) = Θ(n)
S(n)  = Θ(1)

binSearch:
Tb(n) = Θ(1)
Tw(n) = Θ(log n)
S(n)  = Θ(1)

smartSearch:
Tb(n) = Θ(1)
Tw(n) = Θ(n)
S(n)  = Θ(1)
```

Frase chiave:

> L’analisi asintotica non misura il tempo esatto su una macchina specifica, ma il modo in cui il costo dell’algoritmo cresce quando l’input diventa grande.
