# Ricorsione — Ripasso Algoritmi Ricorsivi

## Obiettivo della lezione

Questa lezione ripassa il concetto di **algoritmo ricorsivo**, cioè un procedimento in cui una funzione **richiama sé stessa** per risolvere un problema.

Gli argomenti principali sono:

- cos’è una funzione ricorsiva;
    
- il ruolo del **caso base**;
    
- il ruolo del **progresso** verso il caso base;
    
- cosa succede nello **stack di esecuzione**;
    
- ricorsione lineare e ricorsione ad albero;
    
- esempi classici: **fattoriale**, **Torri di Hanoi**, **Fibonacci**;
    
- differenza tra **ricorsione di testa** e **ricorsione di coda**;
    
- trasformazione di una funzione ricorsiva non di coda in una funzione ricorsiva di coda tramite **accumulatore**.
    

---

# 1. Che cos’è la ricorsione?

Una funzione è detta **ricorsiva** quando, direttamente o indirettamente, richiama sé stessa.

L’idea generale è:

> Per risolvere un problema grande, lo riduco a uno o più problemi più piccoli dello stesso tipo.

Esempio concettuale:

```c
risolvi(problema_grande) {
    if (problema_semplice) {
        restituisci_risultato;
    } else {
        risolvi(problema_piu_piccolo);
    }
}
```

Una funzione ricorsiva corretta deve avere sempre almeno due elementi fondamentali:

1. **Caso base**
    
2. **Passo ricorsivo con progresso**
    

---

# 2. Caso base

Il **caso base** è la condizione che ferma la ricorsione.

Senza caso base, la funzione continuerebbe a chiamare sé stessa all’infinito, fino a esaurire lo stack.

Esempio con il fattoriale:

```c
unsigned int fattoriale(unsigned int n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * fattoriale(n - 1);
    }
}
```

Qui il caso base è:

```c
if (n <= 1) {
    return 1;
}
```

Infatti:

```text
0! = 1
1! = 1
```

Quando `n` arriva a `1`, la funzione non richiama più sé stessa.

---

# 3. Passo ricorsivo

Il **passo ricorsivo** è la parte in cui la funzione richiama sé stessa.

Nel fattoriale:

```c
return n * fattoriale(n - 1);
```

La funzione `fattoriale(n)` viene calcolata usando `fattoriale(n - 1)`.

Esempio:

```text
5! = 5 * 4!
4! = 4 * 3!
3! = 3 * 2!
2! = 2 * 1!
1! = 1
```

Quindi:

```text
5! = 5 * 4 * 3 * 2 * 1 = 120
```

---

# 4. Il progresso: la cosa più importante da capire

Una funzione ricorsiva deve sempre fare **progresso** verso il caso base.

Nel fattoriale corretto:

```c
fattoriale(n - 1)
```

Ogni chiamata lavora su un valore più piccolo:

```text
fattoriale(5)
fattoriale(4)
fattoriale(3)
fattoriale(2)
fattoriale(1)
```

Alla fine si arriva al caso base.

---

## Errore grave: assenza di progresso

Questa versione è sbagliata:

```c
unsigned int fattoriale(unsigned int n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * fattoriale(n);
    }
}
```

Il problema è qui:

```c
fattoriale(n)
```

La funzione richiama sé stessa con lo **stesso valore**.

Esempio:

```text
fattoriale(5)
fattoriale(5)
fattoriale(5)
fattoriale(5)
...
```

Non si arriva mai al caso base.

Questa situazione causa una ricorsione infinita e, in pratica, un errore di tipo:

```text
stack overflow
```

---

# 5. Schema mentale per scrivere una funzione ricorsiva

Quando devo scrivere una funzione ricorsiva, mi conviene sempre farmi queste domande:

1. Qual è il caso più semplice?
    
2. Qual è il risultato in quel caso?
    
3. Come posso ridurre il problema a un problema più piccolo?
    
4. Sono sicuro che prima o poi raggiungo il caso base?
    
5. Dopo la chiamata ricorsiva devo fare ancora qualcosa?
    

Esempio con il fattoriale:

|Domanda|Risposta|
|---|---|
|Caso semplice?|`n <= 1`|
|Risultato nel caso semplice?|`1`|
|Problema più piccolo?|`fattoriale(n - 1)`|
|C’è progresso?|Sì, `n` diminuisce|
|Dopo la chiamata devo fare altro?|Sì, moltiplicare per `n`|

---

# 6. Fattoriale in C

Versione classica:

```c
#include <stdio.h>

unsigned int fattoriale(unsigned int n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * fattoriale(n - 1);
    }
}

int main(void) {
    unsigned int n = 5;
    printf("%u! = %u\n", n, fattoriale(n));
    return 0;
}
```

Output:

```text
5! = 120
```

---

# 7. Stack di esecuzione

Ogni chiamata di funzione crea un **record di attivazione** nello stack.

Nel caso di:

```c
fattoriale(5)
```

succede questo:

```text
fattoriale(5)
    fattoriale(4)
        fattoriale(3)
            fattoriale(2)
                fattoriale(1)
```

Quando si raggiunge il caso base, le chiamate iniziano a “ritornare” il risultato:

```text
fattoriale(1) ritorna 1
fattoriale(2) ritorna 2 * 1 = 2
fattoriale(3) ritorna 3 * 2 = 6
fattoriale(4) ritorna 4 * 6 = 24
fattoriale(5) ritorna 5 * 24 = 120
```

Quindi la ricorsione ha due fasi:

1. **fase di discesa**, in cui vengono create nuove chiamate;
    
2. **fase di risalita**, in cui vengono restituiti i risultati.
    

---

# 8. Ricorsione lineare

La ricorsione è detta **lineare** quando ogni chiamata genera al massimo una nuova chiamata ricorsiva.

Esempio:

```c
unsigned int fattoriale(unsigned int n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * fattoriale(n - 1);
    }
}
```

Ogni chiamata produce una sola altra chiamata:

```text
fattoriale(5)
fattoriale(4)
fattoriale(3)
fattoriale(2)
fattoriale(1)
```

Questa è una catena, non un albero.

---

# 9. Ricorsione e overhead

La ricorsione può rendere il codice molto elegante e leggibile, ma ha un costo.

Ogni chiamata ricorsiva richiede:

- creazione di un record di attivazione;
    
- salvataggio dei parametri;
    
- salvataggio delle variabili locali;
    
- salvataggio dell’indirizzo di ritorno;
    
- ritorno alla funzione chiamante.
    

Questo costo si chiama **overhead**.

In certi casi la ricorsione è molto comoda.

In altri casi una soluzione iterativa può essere più efficiente.

---

# 10. Torri di Hanoi

Le **Torri di Hanoi** sono un classico esempio in cui la ricorsione è molto naturale.

Il problema ha:

- tre pali;
    
- `n` dischi;
    
- un palo sorgente;
    
- un palo destinazione;
    
- un palo ausiliario.
    

Regola fondamentale:

> Non si può mai mettere un disco più grande sopra un disco più piccolo.

L’obiettivo è spostare tutti i dischi dal palo sorgente al palo destinazione.

---

## Idea ricorsiva

Per spostare `n` dischi da `src` a `dst` usando `aux`:

1. Sposto `n - 1` dischi da `src` ad `aux`.
    
2. Sposto il disco più grande da `src` a `dst`.
    
3. Sposto `n - 1` dischi da `aux` a `dst`.
    

Il caso base è:

```text
n == 0
```

Se non ci sono dischi da spostare, non faccio nulla.

---

## Codice C: Torri di Hanoi

```c
#include <stdio.h>

int towerOfHanoi(int n, char src, char dst, char aux, int m) {
    if (n == 0) {
        return m;
    }

    m = towerOfHanoi(n - 1, src, aux, dst, m);

    m++;
    printf("Mossa %d: disco %d spostato da %c -> %c\n",
           m, n, src, dst);

    m = towerOfHanoi(n - 1, aux, dst, src, m);

    return m;
}

int main(void) {
    int n = 3;

    towerOfHanoi(n, 'A', 'C', 'B', 0);

    return 0;
}
```

---

## Esempio con 3 dischi

Chiamata:

```c
towerOfHanoi(3, 'A', 'C', 'B', 0);
```

Significa:

```text
Sposta 3 dischi da A a C usando B come ausiliario.
```

Output atteso:

```text
Mossa 1: disco 1 spostato da A -> C
Mossa 2: disco 2 spostato da A -> B
Mossa 3: disco 1 spostato da C -> B
Mossa 4: disco 3 spostato da A -> C
Mossa 5: disco 1 spostato da B -> A
Mossa 6: disco 2 spostato da B -> C
Mossa 7: disco 1 spostato da A -> C
```

Numero minimo di mosse:

```text
2^n - 1
```

Con `n = 3`:

```text
2^3 - 1 = 7
```

---

# 11. Perché Hanoi è un buon esempio di ricorsione?

Perché la soluzione ricorsiva è molto più semplice da capire rispetto a una soluzione iterativa.

La funzione dice esattamente ciò che va fatto:

```text
Per spostare n dischi:
1. sposta n - 1 dischi sul palo ausiliario;
2. sposta il disco grande;
3. sposta n - 1 dischi sul palo destinazione.
```

Il codice ricorsivo è breve, chiaro e vicino alla definizione matematica del problema.

La versione iterativa, invece, richiede più gestione manuale dello stato:

- array;
    
- strutture;
    
- contatori;
    
- controlli sulle mosse;
    
- gestione dei pali;
    
- gestione del disco più piccolo;
    
- simulazione esplicita dello stato.
    

Quindi Hanoi mostra bene quando la ricorsione è una scelta naturale.

---

# 12. Fibonacci: quando la ricorsione può essere inefficiente

La successione di Fibonacci è definita così:

```text
F(0) = 0
F(1) = 1
F(n) = F(n - 1) + F(n - 2)
```

Una versione ricorsiva immediata è:

```c
#include <stdint.h>

uint32_t fibonacciRicorsive(uint32_t n) {
    if (n < 2) {
        return n;
    }

    return fibonacciRicorsive(n - 1) + fibonacciRicorsive(n - 2);
}
```

Il codice è molto compatto, ma ha un problema enorme: molte chiamate vengono ripetute.

---

## Esempio: fibonacciRicorsive(4)

```text
fib(4)
├── fib(3)
│   ├── fib(2)
│   │   ├── fib(1)
│   │   └── fib(0)
│   └── fib(1)
└── fib(2)
    ├── fib(1)
    └── fib(0)
```

Notare che:

```text
fib(2) viene calcolato più volte
fib(1) viene calcolato più volte
fib(0) viene calcolato più volte
```

Questo genera una ricorsione ad albero.

---

# 13. Ricorsione lineare vs ricorsione ad albero

## Ricorsione lineare

Ogni chiamata genera una sola chiamata ricorsiva.

Esempio:

```c
fattoriale(n - 1)
```

Schema:

```text
f(5)
  f(4)
    f(3)
      f(2)
        f(1)
```

---

## Ricorsione ad albero

Ogni chiamata genera più chiamate ricorsive.

Esempio:

```c
fibonacci(n - 1) + fibonacci(n - 2)
```

Schema:

```text
fib(4)
       fib(4)
      /      \
   fib(3)   fib(2)
   /   \     /   \
fib(2) fib(1) fib(1) fib(0)
```

La ricorsione ad albero può diventare molto costosa.

---

# 14. Fibonacci iterativo

La versione iterativa è molto più efficiente:

```c
#include <stdint.h>

uint32_t fibonacciIterative(uint32_t N) {
    uint32_t n = 0;
    uint32_t n1 = 1;
    uint32_t n2 = 1;

    for (uint32_t i = 0; i < N; i++) {
        n = n1;
        n1 = n2;
        n2 = n + n1;
    }

    return n;
}
```

L’idea è mantenere in memoria solo gli ultimi due valori.

Esempio:

```text
F(1) = 1
F(2) = 1
F(3) = 2
F(4) = 3
F(5) = 5
F(6) = 8
```

---

# 15. Codice utile per vedere il problema di Fibonacci ricorsivo

Questo codice conta quante volte viene chiamata la funzione ricorsiva.

```c
#include <stdio.h>
#include <stdint.h>

uint32_t calls = 0;

uint32_t fibonacciRicorsive(uint32_t n) {
    calls++;

    if (n < 2) {
        return n;
    }

    return fibonacciRicorsive(n - 1) + fibonacciRicorsive(n - 2);
}

int main(void) {
    uint32_t n = 10;

    uint32_t result = fibonacciRicorsive(n);

    printf("fib(%u) = %u\n", n, result);
    printf("Numero di chiamate = %u\n", calls);

    return 0;
}
```

Da riscrivere e provare aumentando `n`:

```text
10
20
30
40
```

Con valori grandi, la versione ricorsiva semplice diventa molto lenta.

---

# 16. Quando conviene usare la ricorsione?

La ricorsione conviene quando il problema è naturalmente ricorsivo.

Esempi tipici:

- alberi;
    
- liste concatenate;
    
- visita di strutture dati;
    
- divide et impera;
    
- backtracking;
    
- Torri di Hanoi;
    
- parsing;
    
- ricerca in profondità.
    

Conviene meno quando:

- la soluzione iterativa è più semplice;
    
- ci sono troppe chiamate ripetute;
    
- la profondità ricorsiva può diventare enorme;
    
- non c’è ottimizzazione della chiamata di coda;
    
- si rischia stack overflow.
    

---

# 17. Ricorsione di testa e ricorsione di coda

Questa distinzione è importante.

---

## Ricorsione non di coda

Nel fattoriale classico:

```c
uint32_t fattoriale(uint32_t n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * fattoriale(n - 1);
    }
}
```

La chiamata ricorsiva è:

```c
fattoriale(n - 1)
```

Però dopo che `fattoriale(n - 1)` ritorna, bisogna ancora moltiplicare per `n`.

Quindi questa NON è una vera ricorsione di coda.

Infatti:

```c
return n * fattoriale(n - 1);
```

non è semplicemente:

```c
return fattoriale(n - 1);
```

C’è ancora un’operazione da fare dopo la chiamata ricorsiva.

---

## Ricorsione di testa

Si parla spesso di ricorsione di testa quando la chiamata ricorsiva avviene prima di altre operazioni significative.

Esempio:

```c
void stampaDa1AN(int n) {
    if (n == 0) {
        return;
    }

    stampaDa1AN(n - 1);
    printf("%d\n", n);
}
```

Chiamata:

```c
stampaDa1AN(5);
```

Output:

```text
1
2
3
4
5
```

Qui prima si scende fino al caso base, poi durante la risalita si stampa.

La chiamata ricorsiva avviene prima della `printf`.

---

## Ricorsione di coda

Una funzione è ricorsiva di coda quando la chiamata ricorsiva è l’ultima cosa che la funzione deve fare.

Esempio:

```c
void stampaDaNVerso1(int n) {
    if (n == 0) {
        return;
    }

    printf("%d\n", n);
    stampaDaNVerso1(n - 1);
}
```

Chiamata:

```c
stampaDaNVerso1(5);
```

Output:

```text
5
4
3
2
1
```

La chiamata ricorsiva è l’ultima istruzione.

Dopo:

```c
stampaDaNVerso1(n - 1);
```

non c’è più nulla da fare.

---

# 18. Chiamata di coda o chiamata terminale

Una chiamata è di coda quando, dopo quella chiamata, la funzione chiamante non deve eseguire altre istruzioni.

Esempio di chiamata di coda:

```c
int f(int x) {
    return g(x);
}
```

Dopo `g(x)` non c’è altro da fare.

Esempio di chiamata NON di coda:

```c
int f(int x) {
    return 1 + g(x);
}
```

Dopo `g(x)` bisogna ancora sommare `1`.

Altro esempio NON di coda:

```c
void f(int x) {
    g(x);
    printf("Ciao!\n");
}
```

Dopo `g(x)` bisogna ancora eseguire la `printf`.

---

# 19. Perché la ricorsione di coda è importante?

Le chiamate di coda possono essere ottimizzate dal compilatore.

L’ottimizzazione consiste nel non creare un nuovo record di attivazione per ogni chiamata.

In pratica, il compilatore può trasformare una ricorsione di coda in qualcosa di simile a un ciclo.

Questo può ridurre la complessità spaziale.

Attenzione però:

> In C non bisogna dare per scontato che il compilatore applichi sempre questa ottimizzazione.

Dipende dal compilatore, dalle opzioni di compilazione e dal codice.

---

# 20. Trasformare il fattoriale in ricorsione di coda

Il fattoriale classico non è ricorsivo di coda:

```c
int fact(int n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * fact(n - 1);
    }
}
```

Il problema è:

```c
return n * fact(n - 1);
```

Dopo la chiamata ricorsiva bisogna ancora moltiplicare.

Per renderlo ricorsivo di coda uso un **accumulatore**.

---

## Versione con accumulatore

```c
int factAux(int n, int acc) {
    if (n <= 1) {
        return acc;
    } else {
        return factAux(n - 1, acc * n);
    }
}

int fact(int n) {
    return factAux(n, 1);
}
```

Qui la chiamata ricorsiva è:

```c
return factAux(n - 1, acc * n);
```

Questa è una chiamata di coda, perché dopo non c’è più nulla da fare.

---

# 21. Come funziona l’accumulatore?

L’accumulatore conserva il risultato parziale.

Esempio:

```c
fact(5)
```

chiama:

```c
factAux(5, 1)
```

Poi:

```text
factAux(5, 1)
factAux(4, 5)
factAux(3, 20)
factAux(2, 60)
factAux(1, 120)
```

Quando `n <= 1`, ritorna `acc`.

Risultato:

```text
120
```

---

# 22. Confronto tra fattoriale classico e fattoriale tail-recursive

## Versione classica

```c
int fact(int n) {
    if (n <= 1) {
        return 1;
    }

    return n * fact(n - 1);
}
```

Schema:

```text
fact(5)
= 5 * fact(4)
= 5 * 4 * fact(3)
= 5 * 4 * 3 * fact(2)
= 5 * 4 * 3 * 2 * fact(1)
= 5 * 4 * 3 * 2 * 1
= 120
```

Il lavoro viene completato durante la risalita.

---

## Versione con accumulatore

```c
int factAux(int n, int acc) {
    if (n <= 1) {
        return acc;
    }

    return factAux(n - 1, acc * n);
}

int fact(int n) {
    return factAux(n, 1);
}
```

Schema:

```text
factAux(5, 1)
factAux(4, 5)
factAux(3, 20)
factAux(2, 60)
factAux(1, 120)
return 120
```

Il lavoro viene fatto durante la discesa.

---

# 23. Funzione wrapper

La funzione:

```c
int fact(int n) {
    return factAux(n, 1);
}
```

è una **funzione wrapper**.

Serve per nascondere all’utente il parametro accumulatore.

Infatti chi usa la funzione vuole scrivere:

```c
fact(5);
```

Non vuole dover scrivere:

```c
factAux(5, 1);
```

Il parametro `acc` è un dettaglio implementativo.

---

# 24. Esempio: somma ricorsiva dei numeri da 1 a n

Versione classica:

```c
int somma(int n) {
    if (n <= 0) {
        return 0;
    }

    return n + somma(n - 1);
}
```

Esempio:

```text
somma(5) = 5 + 4 + 3 + 2 + 1 = 15
```

Questa non è di coda, perché dopo la chiamata ricorsiva bisogna ancora sommare `n`.

---

## Versione con accumulatore

```c
int sommaAux(int n, int acc) {
    if (n <= 0) {
        return acc;
    }

    return sommaAux(n - 1, acc + n);
}

int somma(int n) {
    return sommaAux(n, 0);
}
```

Esempio:

```text
sommaAux(5, 0)
sommaAux(4, 5)
sommaAux(3, 9)
sommaAux(2, 12)
sommaAux(1, 14)
sommaAux(0, 15)
return 15
```

---

# 25. Esempio: contare gli elementi di una lista ricorsivamente

Esempio con lista concatenata:

```c
typedef struct node {
    int data;
    struct node *next;
} Node;
```

Funzione ricorsiva classica:

```c
int length(Node *head) {
    if (head == NULL) {
        return 0;
    }

    return 1 + length(head->next);
}
```

Caso base:

```c
head == NULL
```

Passo ricorsivo:

```c
length(head->next)
```

Progresso:

```text
ogni volta passo al nodo successivo
```

---

## Versione con accumulatore

```c
int lengthAux(Node *head, int acc) {
    if (head == NULL) {
        return acc;
    }

    return lengthAux(head->next, acc + 1);
}

int length(Node *head) {
    return lengthAux(head, 0);
}
```

Questa versione è ricorsiva di coda.

---

# 26. Esempio: cercare un valore in una lista

```c
#include <stdbool.h>

typedef struct node {
    int data;
    struct node *next;
} Node;

bool contains(Node *head, int value) {
    if (head == NULL) {
        return false;
    }

    if (head->data == value) {
        return true;
    }

    return contains(head->next, value);
}
```

Qui la chiamata:

```c
return contains(head->next, value);
```

è di coda.

Dopo la chiamata ricorsiva non devo fare altro.

---

# 27. Pattern da riconoscere all’esame

## Pattern 1: caso base mancante

Errore:

```c
int f(int n) {
    return f(n - 1);
}
```

Manca un caso base.

---

## Pattern 2: nessun progresso

Errore:

```c
int f(int n) {
    if (n == 0) {
        return 0;
    }

    return f(n);
}
```

La funzione richiama sé stessa con lo stesso valore.

---

## Pattern 3: progresso nella direzione sbagliata

Errore:

```c
int f(int n) {
    if (n == 0) {
        return 0;
    }

    return f(n + 1);
}
```

Se parto da `n = 5`, non arriverò mai a `0`.

---

## Pattern 4: chiamate duplicate inutili

Esempio:

```c
int fib(int n) {
    if (n < 2) {
        return n;
    }

    return fib(n - 1) + fib(n - 2);
}
```

Funziona, ma è inefficiente perché ripete gli stessi calcoli.

---

# 28. Cose da saper spiegare bene all’esame

Per prendere un voto alto, devo saper spiegare:

1. Che cos’è una funzione ricorsiva.
    
2. Cos’è il caso base.
    
3. Cos’è il passo ricorsivo.
    
4. Cos’è il progresso.
    
5. Perché senza progresso la ricorsione non termina.
    
6. Come funziona lo stack di esecuzione.
    
7. Perché il fattoriale è ricorsione lineare.
    
8. Perché Fibonacci genera un albero di chiamate.
    
9. Perché Fibonacci ricorsivo semplice è inefficiente.
    
10. Perché Hanoi è elegante in forma ricorsiva.
    
11. Cos’è l’overhead della ricorsione.
    
12. Cos’è una chiamata di coda.
    
13. Perché `return n * fact(n - 1);` non è una vera chiamata di coda.
    
14. A cosa serve un accumulatore.
    
15. A cosa serve una funzione wrapper.
    

---

# 29. Frasi da esame

## Definizione di ricorsione

> Una funzione ricorsiva è una funzione che richiama sé stessa per risolvere un problema riconducendolo a uno o più sottoproblemi dello stesso tipo, ma di dimensione minore.

---

## Caso base

> Il caso base è la condizione che permette alla ricorsione di terminare. Senza caso base, la funzione continuerebbe a chiamarsi indefinitamente.

---

## Progresso

> Il progresso è la garanzia che ogni chiamata ricorsiva si avvicini al caso base. Senza progresso, anche in presenza di un caso base, la funzione potrebbe non terminarlo mai.

---

## Stack

> Ogni chiamata ricorsiva crea un nuovo record di attivazione nello stack. Per questo la ricorsione ha un costo in memoria e può causare stack overflow se la profondità delle chiamate è troppo grande.

---

## Ricorsione di coda

> Una chiamata ricorsiva è di coda quando è l’ultima operazione eseguita dalla funzione. In questo caso il compilatore può, in alcuni casi, ottimizzare la chiamata evitando la creazione di nuovi record di attivazione.

---

## Accumulatore

> L’accumulatore è un parametro aggiuntivo che conserva il risultato parziale e permette di trasformare alcune funzioni ricorsive non di coda in funzioni ricorsive di coda.

---

# 30. Esercizi da riscrivere per prendere confidenza

## Esercizio 1: fattoriale classico

Scrivere:

```c
int fact(int n);
```

Comportamento:

```text
fact(5) = 120
fact(0) = 1
fact(1) = 1
```

---

## Esercizio 2: fattoriale con accumulatore

Scrivere:

```c
int factAux(int n, int acc);
int fact(int n);
```

Obiettivo:

```text
fact(5) -> factAux(5, 1) -> 120
```

---

## Esercizio 3: somma da 1 a n

Scrivere:

```c
int somma(int n);
```

Esempio:

```text
somma(5) = 15
```

Poi trasformarla in versione con accumulatore.

---

## Esercizio 4: stampa da n a 1

Scrivere:

```c
void stampaDecrescente(int n);
```

Esempio:

```text
stampaDecrescente(5)
5
4
3
2
1
```

Questa è ricorsione di coda.

---

## Esercizio 5: stampa da 1 a n

Scrivere:

```c
void stampaCrescente(int n);
```

Esempio:

```text
stampaCrescente(5)
1
2
3
4
5
```

Questa è ricorsione di testa, perché la stampa avviene dopo la chiamata ricorsiva.

---

## Esercizio 6: Fibonacci ricorsivo

Scrivere:

```c
int fib(int n);
```

Poi aggiungere una variabile globale per contare il numero di chiamate.

---

## Esercizio 7: Fibonacci iterativo

Scrivere una versione iterativa di Fibonacci e confrontarla con quella ricorsiva.

Domande da farsi:

```text
Quale è più veloce?
Quale usa meno memoria?
Quale è più facile da leggere?
```

---

## Esercizio 8: lunghezza lista concatenata

Scrivere:

```c
int length(Node *head);
```

Prima versione:

```c
return 1 + length(head->next);
```

Seconda versione:

```c
return lengthAux(head->next, acc + 1);
```

---

## Esercizio 9: contains ricorsivo su lista

Scrivere:

```c
bool contains(Node *head, int value);
```

Casi:

```text
lista vuota -> false
primo nodo contiene value -> true
altrimenti cerca nel resto della lista
```

---

# 31. Codice completo di allenamento

```c
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>

/*
 * FATTORIALE CLASSICO
 * Non è ricorsione di coda, perché dopo fact(n - 1)
 * devo ancora moltiplicare per n.
 */
int fact(int n) {
    if (n <= 1) {
        return 1;
    }

    return n * fact(n - 1);
}

/*
 * FATTORIALE CON ACCUMULATORE
 * Questa versione è ricorsiva di coda.
 */
int factAux(int n, int acc) {
    if (n <= 1) {
        return acc;
    }

    return factAux(n - 1, acc * n);
}

int factTail(int n) {
    return factAux(n, 1);
}

/*
 * SOMMA CLASSICA
 */
int somma(int n) {
    if (n <= 0) {
        return 0;
    }

    return n + somma(n - 1);
}

/*
 * SOMMA CON ACCUMULATORE
 */
int sommaAux(int n, int acc) {
    if (n <= 0) {
        return acc;
    }

    return sommaAux(n - 1, acc + n);
}

int sommaTail(int n) {
    return sommaAux(n, 0);
}

/*
 * STAMPA DECRESCENTE
 * Ricorsione di coda.
 */
void stampaDecrescente(int n) {
    if (n == 0) {
        return;
    }

    printf("%d\n", n);
    stampaDecrescente(n - 1);
}

/*
 * STAMPA CRESCENTE
 * Ricorsione di testa.
 */
void stampaCrescente(int n) {
    if (n == 0) {
        return;
    }

    stampaCrescente(n - 1);
    printf("%d\n", n);
}

/*
 * FIBONACCI RICORSIVO
 */
uint32_t fibRic(uint32_t n) {
    if (n < 2) {
        return n;
    }

    return fibRic(n - 1) + fibRic(n - 2);
}

/*
 * FIBONACCI ITERATIVO
 */
uint32_t fibIter(uint32_t n) {
    if (n < 2) {
        return n;
    }

    uint32_t prev = 0;
    uint32_t curr = 1;

    for (uint32_t i = 2; i <= n; i++) {
        uint32_t next = prev + curr;
        prev = curr;
        curr = next;
    }

    return curr;
}

int main(void) {
    int n = 5;

    printf("fact(%d) = %d\n", n, fact(n));
    printf("factTail(%d) = %d\n", n, factTail(n));

    printf("somma(%d) = %d\n", n, somma(n));
    printf("sommaTail(%d) = %d\n", n, sommaTail(n));

    printf("\nStampa decrescente:\n");
    stampaDecrescente(n);

    printf("\nStampa crescente:\n");
    stampaCrescente(n);

    printf("\nfibRic(10) = %u\n", fibRic(10));
    printf("fibIter(10) = %u\n", fibIter(10));

    return 0;
}
```

---

# 32. Checklist finale

Prima dell’esame devo essere in grado di guardare una funzione ricorsiva e dire:

- qual è il caso base;
    
- qual è il passo ricorsivo;
    
- se c’è progresso;
    
- se la funzione termina;
    
- se è ricorsione lineare o ad albero;
    
- se è ricorsione di testa o di coda;
    
- se può essere trasformata con accumulatore;
    
- che cosa succede nello stack;
    
- se è efficiente o se ripete calcoli inutili.
    

---

# 33. Mini-riassunto da memorizzare

Una funzione ricorsiva corretta ha sempre:

```text
1. Caso base
2. Passo ricorsivo
3. Progresso verso il caso base
```

La ricorsione è elegante quando il problema è naturalmente definito in modo ricorsivo.

Però ogni chiamata ha un costo in tempo e memoria.

La ricorsione di coda è importante perché può essere ottimizzata dal compilatore.

Per trasformare una funzione non di coda in una funzione di coda, spesso si introduce un accumulatore.

---