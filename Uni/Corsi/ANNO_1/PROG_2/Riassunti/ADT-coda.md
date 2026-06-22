# ADT Coda / Queue in C

> Argomento: **Abstract Data Type Coda**
> Corso: Programmazione II
> Obiettivo: capire bene la struttura dati **coda**, la politica **FIFO**, le operazioni fondamentali e le due implementazioni viste: **lista linkata** e **array dinamico circolare**.

---

# 1. Cos’è una coda?

Una **coda**, in inglese **queue**, è una struttura dati che contiene elementi dello stesso tipo e li gestisce secondo la politica:

```text
FIFO = First In, First Out
```

cioè:

> Il primo elemento inserito è il primo elemento che verrà rimosso.

Esempio intuitivo:

```text
Coda in biglietteria:

[Alice] [Bob] [Carlo] [Diana]
  ↑
prima persona arrivata
```

Se arriva una nuova persona, si mette **in fondo** alla coda.

Se viene servita una persona, esce quella **in testa** alla coda.

---

# 2. Operazioni fondamentali

Le operazioni principali di una coda sono:

```c
Queue mkQueue();
```

Crea una coda vuota.

---

```c
_Bool enqueue(Queue q, Element e);
```

Inserisce un elemento **in fondo** alla coda.

Può fallire, per esempio se:

* la `malloc` fallisce;
* la coda ha capacità fissa ed è piena;
* la `realloc` o una nuova allocazione fallisce durante il resize.

---

```c
Element dequeue(Queue q);
```

Rimuove e restituisce l’elemento **in testa** alla coda.

Se la coda è vuota, l’operazione non ha senso: bisogna decidere come gestire l’errore.

Esempi possibili:

```c
exit(EXIT_FAILURE);
```

oppure restituire un valore speciale, oppure usare un parametro di output con esito booleano.

---

```c
_Bool isEmptyQueue(const Queue q);
```

Controlla se la coda è vuota.

---

```c
int queueSize(const Queue q);
```

Restituisce il numero di elementi presenti nella coda.

---

```c
Element front(const Queue q);
```

Restituisce l’elemento in testa senza rimuoverlo.

---

```c
Element rear(const Queue q);
```

Restituisce l’elemento in fondo senza rimuoverlo.

---

```c
Element peek(const Queue q, int pos);
```

Restituisce l’elemento alla posizione `pos` senza rimuoverlo.

Di solito nelle implementazioni si usa posizione **0-based**:

```text
posizione:   0   1   2   3
elementi:    A   B   C   D
```

Quindi:

```c
peek(q, 0); // A
peek(q, 2); // C
```

---

```c
void dsQueue(Queue *qs);
```

Distrugge la coda, libera la memoria e mette il puntatore a `NULL`.

Questa funzione riceve un **puntatore a puntatore** perché deve modificare il puntatore originale presente nel `main`.

---

# 3. Attenzione ai refusi delle slide

Nelle slide compaiono alcuni nomi tipo:

```c
mkStack
dsStack
isEmptyStack
```

ma in questo argomento si sta parlando di **code**, non di pile.

Quindi concettualmente i nomi corretti sono:

```c
mkQueue
dsQueue
isEmptyQueue
```

La differenza è importante:

| Struttura    | Politica | Inserimento | Rimozione |
| ------------ | -------: | ----------: | --------: |
| Pila / Stack |     LIFO |        push |       pop |
| Coda / Queue |     FIFO |     enqueue |   dequeue |

---

# 4. Coda vs pila

## Pila

La pila usa politica:

```text
LIFO = Last In, First Out
```

Esempio:

```text
push A
push B
push C

pop restituisce C
```

L’ultimo inserito è il primo a uscire.

---

## Coda

La coda usa politica:

```text
FIFO = First In, First Out
```

Esempio:

```text
enqueue A
enqueue B
enqueue C

dequeue restituisce A
```

Il primo inserito è il primo a uscire.

---

# 5. Esempio astratto

Partiamo da una coda vuota:

```text
q = []
```

Eseguiamo:

```text
enqueue(q, 'A')
enqueue(q, 'B')
enqueue(q, 'C')
```

Otteniamo:

```text
front
  ↓
[A] [B] [C]
        ↑
       rear
```

Ora facciamo:

```text
dequeue(q)
```

Viene rimosso `'A'`.

La coda diventa:

```text
front
  ↓
[B] [C]
    ↑
   rear
```

Poi:

```text
enqueue(q, 'D')
```

Otteniamo:

```text
front
  ↓
[B] [C] [D]
        ↑
       rear
```

---

# 6. ADT: cosa significa davvero

ADT significa:

```text
Abstract Data Type
```

Un ADT separa due livelli:

## Livello astratto

Dice **cosa** fa la struttura dati.

Esempio:

```c
enqueue(q, 'A');
dequeue(q);
isEmptyQueue(q);
```

L’utente sa usare la coda, ma non sa come è fatta internamente.

---

## Livello implementativo

Dice **come** è realizzata la struttura dati.

Per esempio:

* tramite lista linkata;
* tramite array dinamico;
* tramite array circolare;
* tramite lista double-ended.

---

# 7. Tipo opaco

In C possiamo nascondere i dettagli della struttura usando un tipo opaco.

Nel file `.h` scriviamo:

```c
typedef struct charQueue *CharQueueADT;
```

Questo significa:

> `CharQueueADT` è un puntatore a una struct `charQueue`, ma il contenuto della struct non è visibile all’esterno.

Nel file `.c` invece definiamo davvero la struct.

Quindi l’utente può scrivere:

```c
CharQueueADT q = mkQueue();
enqueue(q, 'A');
dequeue(q);
```

ma non può fare:

```c
q->front = NULL;
q->size = 999;
```

perché non conosce la struttura interna.

Questa è una forma di **information hiding**.

---

# 8. Header dell’ADT

Un possibile file `charQueueADT.h` è:

```c
#ifndef CHAR_QUEUE_ADT_H
#define CHAR_QUEUE_ADT_H

typedef struct charQueue *CharQueueADT;

CharQueueADT mkQueue(void);

void dsQueue(CharQueueADT *qs);

_Bool enqueue(CharQueueADT q, char e);

char dequeue(CharQueueADT q);

_Bool isEmptyQueue(const CharQueueADT q);

int queueSize(const CharQueueADT q);

char peek(const CharQueueADT q, int pos);

char front(const CharQueueADT q);

char rear(const CharQueueADT q);

#endif
```

Questo file contiene la **specifica pubblica** dell’ADT.

Chi usa la coda deve includere solo questo file:

```c
#include "charQueueADT.h"
```

---

# 9. Implementazione con lista linkata

Una prima implementazione della coda usa una lista linkata.

Ogni nodo contiene:

```c
struct listNode {
    char data;
    struct listNode *next;
};
```

La coda contiene due puntatori:

```c
front
rear
```

dove:

* `front` punta al primo elemento da rimuovere;
* `rear` punta all’ultimo elemento inserito;
* `size` contiene il numero di elementi.

Schema:

```text
front
  ↓
[A] -> [B] -> [D] -> [E] -> NULL
                         ↑
                        rear

size = 4
```

---

# 10. Perché servono sia front sia rear?

Se avessimo solo `front`, per inserire in fondo dovremmo ogni volta visitare tutta la lista:

```text
front
  ↓
[A] -> [B] -> [C] -> NULL
```

Per inserire `'D'`, dovremmo arrivare fino a `'C'`.

Costo:

```text
O(n)
```

Con `rear`, invece, sappiamo già dov’è l’ultimo nodo.

Inserire in fondo costa:

```text
O(1)
```

Quindi una coda con lista linkata usa una lista **double-ended**, cioè con puntatore sia alla testa sia alla coda.

---

# 11. Invarianti della coda con lista

Gli invarianti sono proprietà che devono essere sempre vere.

Per una coda con lista:

## Coda vuota

```text
front == NULL
rear  == NULL
size  == 0
```

---

## Coda con un elemento

```text
front == rear
size == 1
front->next == NULL
```

Schema:

```text
front
  ↓
[A] -> NULL
  ↑
 rear
```

---

## Coda con più elementi

```text
front != NULL
rear != NULL
rear->next == NULL
size > 1
```

Schema:

```text
front
  ↓
[A] -> [B] -> [C] -> NULL
                  ↑
                 rear
```

---

# 12. Implementazione completa con lista

File `charQueueADT_list.c`:

```c
#include <stdio.h>
#include <stdlib.h>
#include "charQueueADT.h"

typedef struct listNode ListNode;
typedef ListNode *ListNodePtr;

struct listNode {
    char data;
    ListNodePtr next;
};

struct charQueue {
    ListNodePtr front;
    ListNodePtr rear;
    int size;
};

CharQueueADT mkQueue(void) {
    CharQueueADT q = malloc(sizeof(*q));

    if (q == NULL) {
        return NULL;
    }

    q->front = NULL;
    q->rear = NULL;
    q->size = 0;

    return q;
}

_Bool isEmptyQueue(const CharQueueADT q) {
    if (q == NULL) {
        return 1;
    }

    return q->size == 0;
}

int queueSize(const CharQueueADT q) {
    if (q == NULL) {
        return 0;
    }

    return q->size;
}

_Bool enqueue(CharQueueADT q, char e) {
    if (q == NULL) {
        return 0;
    }

    ListNodePtr newPtr = malloc(sizeof(*newPtr));

    if (newPtr == NULL) {
        return 0;
    }

    newPtr->data = e;
    newPtr->next = NULL;

    if (isEmptyQueue(q)) {
        q->front = newPtr;
        q->rear = newPtr;
    } else {
        q->rear->next = newPtr;
        q->rear = newPtr;
    }

    q->size++;

    return 1;
}

char dequeue(CharQueueADT q) {
    if (q == NULL || isEmptyQueue(q)) {
        exit(EXIT_FAILURE);
    }

    ListNodePtr oldFront = q->front;
    char e = oldFront->data;

    q->front = q->front->next;

    free(oldFront);

    q->size--;

    if (q->size == 0) {
        q->rear = NULL;
    }

    return e;
}

char front(const CharQueueADT q) {
    if (q == NULL || isEmptyQueue(q)) {
        exit(EXIT_FAILURE);
    }

    return q->front->data;
}

char rear(const CharQueueADT q) {
    if (q == NULL || isEmptyQueue(q)) {
        exit(EXIT_FAILURE);
    }

    return q->rear->data;
}

char peek(const CharQueueADT q, int pos) {
    if (q == NULL || pos < 0 || pos >= q->size) {
        exit(EXIT_FAILURE);
    }

    ListNodePtr current = q->front;

    for (int i = 0; i < pos; i++) {
        current = current->next;
    }

    return current->data;
}

void dsQueue(CharQueueADT *qs) {
    if (qs == NULL || *qs == NULL) {
        return;
    }

    CharQueueADT q = *qs;

    while (!isEmptyQueue(q)) {
        dequeue(q);
    }

    free(q);

    *qs = NULL;
}
```

---

# 13. Analisi di `enqueue` con lista

La funzione:

```c
_Bool enqueue(CharQueueADT q, char e)
```

deve aggiungere un nodo in fondo.

Il nuovo nodo viene creato così:

```c
ListNodePtr newPtr = malloc(sizeof(*newPtr));
```

Poi viene inizializzato:

```c
newPtr->data = e;
newPtr->next = NULL;
```

`next` è `NULL` perché il nuovo nodo sarà l’ultimo della lista.

---

## Caso 1: coda vuota

Prima:

```text
front -> NULL
rear  -> NULL
size = 0
```

Dopo `enqueue(q, 'A')`:

```text
front
  ↓
[A] -> NULL
  ↑
 rear

size = 1
```

Codice:

```c
q->front = newPtr;
q->rear = newPtr;
```

Il primo elemento è sia testa sia coda.

---

## Caso 2: coda non vuota

Prima:

```text
front
  ↓
[A] -> [B] -> NULL
       ↑
      rear
```

Inseriamo `'C'`.

Dobbiamo fare:

```c
q->rear->next = newPtr;
q->rear = newPtr;
```

Dopo:

```text
front
  ↓
[A] -> [B] -> [C] -> NULL
              ↑
             rear
```

---

# 14. Analisi di `dequeue` con lista

La funzione:

```c
char dequeue(CharQueueADT q)
```

deve rimuovere dalla testa.

Prima salva il nodo da eliminare:

```c
ListNodePtr oldFront = q->front;
```

Poi salva il dato da restituire:

```c
char e = oldFront->data;
```

Poi sposta `front` al nodo successivo:

```c
q->front = q->front->next;
```

Poi libera il vecchio nodo:

```c
free(oldFront);
```

Poi decrementa la size:

```c
q->size--;
```

Se la coda è diventata vuota, bisogna sistemare anche `rear`:

```c
if (q->size == 0) {
    q->rear = NULL;
}
```

---

# 15. Errore comune in `dequeue`

Errore tipico:

```c
free(q->front);
q->front = q->front->next;
```

Questo è sbagliato.

Dopo `free(q->front)`, il puntatore `q->front` punta a memoria liberata.

Quindi fare:

```c
q->front->next
```

significa accedere a memoria non più valida.

La sequenza corretta è:

```c
ListNodePtr oldFront = q->front;
q->front = q->front->next;
free(oldFront);
```

Prima sposto `front`, poi libero il vecchio nodo.

---

# 16. Perché `dsQueue` riceve `CharQueueADT *qs`

La funzione:

```c
void dsQueue(CharQueueADT *qs)
```

riceve un puntatore a puntatore.

Ricorda:

```c
typedef struct charQueue *CharQueueADT;
```

Quindi:

```c
CharQueueADT q;
```

è già un puntatore.

Quando scrivo:

```c
CharQueueADT *qs;
```

sto dicendo:

```text
qs è un puntatore a una variabile che contiene un puntatore alla coda
```

Serve perché voglio modificare anche il puntatore nel `main`.

Esempio:

```c
int main(void) {
    CharQueueADT q = mkQueue();

    enqueue(q, 'A');
    enqueue(q, 'B');

    dsQueue(&q);

    return 0;
}
```

Dentro `dsQueue`, dopo aver liberato la memoria, faccio:

```c
*qs = NULL;
```

Così anche `q` nel `main` diventa `NULL`.

---

# 17. Differenza tra `qs` e `*qs`

Dentro:

```c
void dsQueue(CharQueueADT *qs)
```

abbiamo:

```c
qs
```

che è l’indirizzo della variabile `q` del `main`.

Invece:

```c
*qs
```

è il valore contenuto in quella variabile, cioè il puntatore alla coda vera.

Schema:

```text
main:

q  ----->  struct charQueue
          front
          rear
          size

dsQueue(&q):

qs -----> q -----> struct charQueue
```

Quindi:

```c
free(*qs);
```

libera la coda.

Poi:

```c
*qs = NULL;
```

mette `q` del `main` a `NULL`.

---

# 18. Test per la coda con lista

Un file di test utile può essere:

```c
#include <stdio.h>
#include <stdlib.h>
#include "charQueueADT.h"

int main(void) {
    CharQueueADT q = mkQueue();

    if (q == NULL) {
        printf("Errore creazione coda\n");
        return EXIT_FAILURE;
    }

    printf("Vuota? %d\n", isEmptyQueue(q));
    printf("Size: %d\n", queueSize(q));

    enqueue(q, 'A');
    enqueue(q, 'B');
    enqueue(q, 'C');

    printf("Vuota? %d\n", isEmptyQueue(q));
    printf("Size: %d\n", queueSize(q));

    printf("Front: %c\n", front(q));
    printf("Rear: %c\n", rear(q));

    printf("Peek 0: %c\n", peek(q, 0));
    printf("Peek 1: %c\n", peek(q, 1));
    printf("Peek 2: %c\n", peek(q, 2));

    printf("Dequeue: %c\n", dequeue(q));
    printf("Dequeue: %c\n", dequeue(q));

    enqueue(q, 'D');

    printf("Dequeue: %c\n", dequeue(q));
    printf("Dequeue: %c\n", dequeue(q));

    printf("Vuota? %d\n", isEmptyQueue(q));
    printf("Size: %d\n", queueSize(q));

    dsQueue(&q);

    if (q == NULL) {
        printf("Coda distrutta correttamente\n");
    }

    return 0;
}
```

Output atteso:

```text
Vuota? 1
Size: 0
Vuota? 0
Size: 3
Front: A
Rear: C
Peek 0: A
Peek 1: B
Peek 2: C
Dequeue: A
Dequeue: B
Dequeue: C
Dequeue: D
Vuota? 1
Size: 0
Coda distrutta correttamente
```

---

# 19. Complessità con lista linkata

| Operazione     |                                 Costo |
| -------------- | ------------------------------------: |
| `mkQueue`      |                                  O(1) |
| `enqueue`      |                                  O(1) |
| `dequeue`      |                                  O(1) |
| `front`        |                                  O(1) |
| `rear`         |                                  O(1) |
| `queueSize`    |                                  O(1) |
| `isEmptyQueue` |                                  O(1) |
| `peek(q, pos)` | O(pos), quindi O(n) nel caso peggiore |
| `dsQueue`      |                                  O(n) |

La cosa fondamentale è che `enqueue` è O(1) perché abbiamo `rear`.

Se non avessimo `rear`, `enqueue` sarebbe O(n).

---

# 20. Implementazione con array dinamico

Una seconda implementazione usa un array dinamico.

La struct può essere:

```c
struct charQueue {
    char *a;
    int capacity;
    int rear;
    int front;
    int size;
};
```

Significato dei campi:

| Campo      | Significato                              |
| ---------- | ---------------------------------------- |
| `a`        | array dinamico che contiene gli elementi |
| `capacity` | dimensione fisica dell’array             |
| `front`    | indice del primo elemento della coda     |
| `rear`     | indice della prima posizione libera      |
| `size`     | numero di elementi presenti              |

---

# 21. Perché l’array deve essere circolare?

Supponiamo di avere un array di capacità 5.

```text
indici:  0   1   2   3   4
array:  [A] [B] [C] [ ] [ ]
front = 0
rear  = 3
size  = 3
```

Facciamo due `dequeue`.

Escono `A` e `B`.

```text
indici:  0   1   2   3   4
array:  [ ] [ ] [C] [ ] [ ]
front = 2
rear  = 3
size  = 1
```

Ora inseriamo `D` ed `E`.

```text
indici:  0   1   2   3   4
array:  [ ] [ ] [C] [D] [E]
front = 2
rear  = 0
size  = 3
```

Dopo aver raggiunto la fine dell’array, `rear` torna all’inizio.

Questo è il comportamento di un **array circolare**.

---

# 22. Operatore modulo

Per far tornare un indice a zero quando arriva alla fine, si usa il modulo.

```c
int successor(int i, int capacity) {
    return (i + 1) % capacity;
}
```

Esempio con `capacity = 5`:

```text
successor(0, 5) = 1
successor(1, 5) = 2
successor(2, 5) = 3
successor(3, 5) = 4
successor(4, 5) = 0
```

Il modulo serve a creare il comportamento circolare.

---

# 23. Esempio visivo di array circolare

Supponiamo:

```text
capacity = 8
front = 6
rear = 2
size = 4
```

Gli elementi sono logicamente in ordine:

```text
indice 6
indice 7
indice 0
indice 1
```

Schema:

```text
indici:  0   1   2   3   4   5   6   7
array:  [C] [D] [ ] [ ] [ ] [ ] [A] [B]
                   ↑               ↑
                  rear            front
```

Ordine logico della coda:

```text
front -> A -> B -> C -> D -> rear
```

Anche se nell’array fisico gli elementi sono spezzati in due blocchi.

---

# 24. Perché `realloc` da sola può essere problematica?

Quando l’array circolare è “spezzato”, gli elementi non sono in un unico blocco ordinato.

Esempio:

```text
capacity = 4
front = 2
rear = 2
size = 4

indici:  0   1   2   3
array:  [C] [D] [A] [B]
              ↑
          front = 2
              ↑
          rear = 2 perché la coda è piena
```

Ordine logico:

```text
A, B, C, D
```

Se uso semplicemente `realloc` per passare a capacità 8, l’array potrebbe diventare:

```text
indici:  0   1   2   3   4   5   6   7
array:  [C] [D] [A] [B] [ ] [ ] [ ] [ ]
```

Ma l’ordine logico è ancora spezzato.

Per semplificare, quando ridimensiono conviene creare un nuovo array e copiare gli elementi in ordine logico:

```text
indici:  0   1   2   3   4   5   6   7
array:  [A] [B] [C] [D] [ ] [ ] [ ] [ ]
front = 0
rear = 4
```

Quindi il resize corretto deve:

1. allocare un nuovo array;
2. copiare gli elementi da `front` in poi rispettando l’ordine FIFO;
3. liberare il vecchio array;
4. mettere `front = 0`;
5. mettere `rear = size`;
6. aggiornare `capacity`.

---

# 25. Implementazione completa con array dinamico circolare

File `charQueueADT_array.c`:

```c
#include <stdio.h>
#include <stdlib.h>
#include "charQueueADT.h"

#define INITIAL_CAPACITY 4

struct charQueue {
    char *a;
    int capacity;
    int rear;
    int front;
    int size;
};

static int successor(int i, int capacity) {
    return (i + 1) % capacity;
}

static int realIndex(const CharQueueADT q, int pos) {
    return (q->front + pos) % q->capacity;
}

static _Bool resizeQueue(CharQueueADT q) {
    int newCapacity = q->capacity * 2;

    char *newArray = malloc(sizeof(char) * newCapacity);

    if (newArray == NULL) {
        return 0;
    }

    for (int i = 0; i < q->size; i++) {
        int oldIndex = realIndex(q, i);
        newArray[i] = q->a[oldIndex];
    }

    free(q->a);

    q->a = newArray;
    q->capacity = newCapacity;
    q->front = 0;
    q->rear = q->size;

    return 1;
}

CharQueueADT mkQueue(void) {
    CharQueueADT q = malloc(sizeof(*q));

    if (q == NULL) {
        return NULL;
    }

    q->a = malloc(sizeof(char) * INITIAL_CAPACITY);

    if (q->a == NULL) {
        free(q);
        return NULL;
    }

    q->capacity = INITIAL_CAPACITY;
    q->front = 0;
    q->rear = 0;
    q->size = 0;

    return q;
}

_Bool isEmptyQueue(const CharQueueADT q) {
    if (q == NULL) {
        return 1;
    }

    return q->size == 0;
}

int queueSize(const CharQueueADT q) {
    if (q == NULL) {
        return 0;
    }

    return q->size;
}

_Bool enqueue(CharQueueADT q, char e) {
    if (q == NULL) {
        return 0;
    }

    if (q->size == q->capacity) {
        if (!resizeQueue(q)) {
            return 0;
        }
    }

    q->a[q->rear] = e;
    q->rear = successor(q->rear, q->capacity);
    q->size++;

    return 1;
}

char dequeue(CharQueueADT q) {
    if (q == NULL || isEmptyQueue(q)) {
        exit(EXIT_FAILURE);
    }

    char e = q->a[q->front];

    q->front = successor(q->front, q->capacity);
    q->size--;

    if (q->size == 0) {
        q->front = 0;
        q->rear = 0;
    }

    return e;
}

char front(const CharQueueADT q) {
    if (q == NULL || isEmptyQueue(q)) {
        exit(EXIT_FAILURE);
    }

    return q->a[q->front];
}

char rear(const CharQueueADT q) {
    if (q == NULL || isEmptyQueue(q)) {
        exit(EXIT_FAILURE);
    }

    int lastIndex = (q->rear - 1 + q->capacity) % q->capacity;

    return q->a[lastIndex];
}

char peek(const CharQueueADT q, int pos) {
    if (q == NULL || pos < 0 || pos >= q->size) {
        exit(EXIT_FAILURE);
    }

    int index = realIndex(q, pos);

    return q->a[index];
}

void dsQueue(CharQueueADT *qs) {
    if (qs == NULL || *qs == NULL) {
        return;
    }

    CharQueueADT q = *qs;

    free(q->a);
    free(q);

    *qs = NULL;
}
```

---

# 26. Analisi di `enqueue` con array circolare

La funzione principale è:

```c
_Bool enqueue(CharQueueADT q, char e) {
    if (q == NULL) {
        return 0;
    }

    if (q->size == q->capacity) {
        if (!resizeQueue(q)) {
            return 0;
        }
    }

    q->a[q->rear] = e;
    q->rear = successor(q->rear, q->capacity);
    q->size++;

    return 1;
}
```

Passaggi:

1. controllo che la coda esista;
2. se l’array è pieno, ridimensiono;
3. inserisco nella posizione `rear`;
4. aggiorno `rear` con il modulo;
5. incremento `size`.

---

# 27. Analisi di `dequeue` con array circolare

La funzione:

```c
char dequeue(CharQueueADT q)
```

deve rimuovere l’elemento in posizione `front`.

Codice importante:

```c
char e = q->a[q->front];

q->front = successor(q->front, q->capacity);

q->size--;
```

Non serve cancellare fisicamente il vecchio valore dall’array.

Basta spostare `front`.

Il dato vecchio rimane nell’array, ma non fa più parte della coda perché `size` e `front` definiscono quali celle sono valide.

---

# 28. Perché `rear` indica la prima posizione libera?

In una coda con array circolare, `rear` non punta necessariamente all’ultimo elemento.

Punta alla **prima cella libera dove inserire il prossimo elemento**.

Esempio:

```text
indici:  0   1   2   3   4
array:  [A] [B] [C] [ ] [ ]
front = 0
rear  = 3
size  = 3
```

`rear = 3` indica che il prossimo elemento verrà inserito in `a[3]`.

Dopo:

```c
enqueue(q, 'D');
```

diventa:

```text
indici:  0   1   2   3   4
array:  [A] [B] [C] [D] [ ]
front = 0
rear  = 4
size  = 4
```

---

# 29. Caso ambiguo: `front == rear`

Con array circolare può succedere che:

```c
front == rear
```

sia quando la coda è vuota sia quando la coda è piena.

Per questo serve `size`.

Esempio coda vuota:

```text
front = 0
rear = 0
size = 0
```

Esempio coda piena:

```text
capacity = 4
front = 0
rear = 0
size = 4
```

Senza `size`, sarebbe difficile distinguere i due casi.

---

# 30. Complessità con array dinamico circolare

| Operazione     |                            Costo |
| -------------- | -------------------------------: |
| `mkQueue`      |                             O(1) |
| `enqueue`      |                O(1) ammortizzato |
| `dequeue`      |                             O(1) |
| `front`        |                             O(1) |
| `rear`         |                             O(1) |
| `queueSize`    |                             O(1) |
| `isEmptyQueue` |                             O(1) |
| `peek(q, pos)` |                             O(1) |
| `dsQueue`      | O(1) per liberare array e struct |

Attenzione: `enqueue` è O(1) **ammortizzato** perché normalmente costa O(1), ma quando serve il resize costa O(n).

---

# 31. Lista vs array dinamico

| Aspetto                    |                   Lista linkata |          Array dinamico circolare |
| -------------------------- | ------------------------------: | --------------------------------: |
| Inserimento in coda        |                            O(1) |                 O(1) ammortizzato |
| Rimozione in testa         |                            O(1) |                              O(1) |
| Accesso a posizione `pos`  |                            O(n) |                              O(1) |
| Memoria                    |            un nodo per elemento |                    array contiguo |
| Resize                     | non serve, cresce nodo per nodo |                serve quando pieno |
| Località in cache          |                        peggiore |                          migliore |
| Puntatori                  |                              sì |               no, oltre all’array |
| Complessità implementativa |                           media | più alta per circolarità e resize |

---

# 32. Cosa devi capire bene per l’esame

## 1. La politica FIFO

Devi saper spiegare chiaramente:

```text
enqueue inserisce in fondo
dequeue rimuove dalla testa
```

Esempio:

```text
enqueue A
enqueue B
enqueue C
dequeue -> A
dequeue -> B
```

---

## 2. La differenza tra front e rear

Con lista:

```text
front = nodo da rimuovere
rear  = ultimo nodo inserito
```

Con array:

```text
front = indice del primo elemento
rear  = indice della prima cella libera
```

Questa differenza è fondamentale.

---

## 3. I casi limite

Devi saper gestire:

* coda vuota;
* inserimento del primo elemento;
* rimozione dell’ultimo elemento;
* `malloc` fallita;
* `dequeue` su coda vuota;
* `peek` con posizione fuori range;
* array pieno;
* resize;
* ritorno degli indici a zero con modulo.

---

## 4. Gli invarianti

Devi sempre chiederti:

> Dopo questa operazione, `front`, `rear` e `size` sono coerenti?

Esempio con lista:

```text
se size == 0:
    front == NULL
    rear == NULL
```

Esempio con array:

```text
0 <= front < capacity
0 <= rear < capacity
0 <= size <= capacity
```

---

## 5. Il puntatore a puntatore in `dsQueue`

Questo è importantissimo.

```c
void dsQueue(CharQueueADT *qs)
```

serve per fare:

```c
*qs = NULL;
```

e quindi annullare anche il puntatore del chiamante.

Nel `main`:

```c
CharQueueADT q = mkQueue();

dsQueue(&q);

if (q == NULL) {
    printf("ok\n");
}
```

Se invece facessi:

```c
void dsQueue(CharQueueADT q)
```

potresti liberare la memoria, ma non potresti mettere a `NULL` il puntatore originale del `main`.

---

# 33. Esercizi da rifare a mano

## Esercizio 1

Implementa da zero:

```c
_Bool enqueue(CharQueueADT q, char e);
```

Versione lista.

Cose da ricordare:

```c
newPtr->next = NULL;
```

poi:

```c
if (isEmptyQueue(q)) {
    q->front = newPtr;
    q->rear = newPtr;
} else {
    q->rear->next = newPtr;
    q->rear = newPtr;
}
```

---

## Esercizio 2

Implementa da zero:

```c
char dequeue(CharQueueADT q);
```

Versione lista.

Cose da ricordare:

```c
ListNodePtr oldFront = q->front;
char e = oldFront->data;

q->front = q->front->next;

free(oldFront);

q->size--;

if (q->size == 0) {
    q->rear = NULL;
}
```

---

## Esercizio 3

Disegna la coda dopo ogni operazione:

```c
enqueue(q, 'A');
enqueue(q, 'B');
enqueue(q, 'C');
dequeue(q);
enqueue(q, 'D');
dequeue(q);
enqueue(q, 'E');
```

Soluzione logica:

```text
enqueue A -> [A]
enqueue B -> [A, B]
enqueue C -> [A, B, C]
dequeue   -> [B, C]
enqueue D -> [B, C, D]
dequeue   -> [C, D]
enqueue E -> [C, D, E]
```

---

## Esercizio 4

Implementa:

```c
char peek(const CharQueueADT q, int pos);
```

Versione lista.

Soluzione:

```c
char peek(const CharQueueADT q, int pos) {
    if (q == NULL || pos < 0 || pos >= q->size) {
        exit(EXIT_FAILURE);
    }

    ListNodePtr current = q->front;

    for (int i = 0; i < pos; i++) {
        current = current->next;
    }

    return current->data;
}
```

---

## Esercizio 5

Implementa la funzione:

```c
static int successor(int i, int capacity);
```

Soluzione:

```c
static int successor(int i, int capacity) {
    return (i + 1) % capacity;
}
```

Poi verifica a mano:

```text
capacity = 5

successor(0, 5) = 1
successor(1, 5) = 2
successor(2, 5) = 3
successor(3, 5) = 4
successor(4, 5) = 0
```

---

## Esercizio 6

Implementa il resize dell’array circolare.

Schema da ricordare:

```c
for (int i = 0; i < q->size; i++) {
    newArray[i] = q->a[(q->front + i) % q->capacity];
}
```

Questo copia gli elementi in ordine FIFO.

---

# 34. Mini test TDD consigliati

La metodologia TDD consiste nel procedere così:

1. scrivo un test;
2. lo faccio fallire;
3. implemento il minimo necessario;
4. rifaccio il test;
5. passo al test successivo.

Test utili:

---

## Test 1: coda appena creata

```c
CharQueueADT q = mkQueue();

assert(q != NULL);
assert(isEmptyQueue(q));
assert(queueSize(q) == 0);
```

---

## Test 2: enqueue singolo

```c
enqueue(q, 'A');

assert(!isEmptyQueue(q));
assert(queueSize(q) == 1);
assert(front(q) == 'A');
assert(rear(q) == 'A');
```

---

## Test 3: FIFO

```c
enqueue(q, 'A');
enqueue(q, 'B');
enqueue(q, 'C');

assert(dequeue(q) == 'A');
assert(dequeue(q) == 'B');
assert(dequeue(q) == 'C');
```

---

## Test 4: alternanza enqueue/dequeue

```c
enqueue(q, 'A');
enqueue(q, 'B');

assert(dequeue(q) == 'A');

enqueue(q, 'C');

assert(dequeue(q) == 'B');
assert(dequeue(q) == 'C');
```

---

## Test 5: array circolare

Questo test serve soprattutto per l’implementazione con array.

```c
enqueue(q, 'A');
enqueue(q, 'B');
enqueue(q, 'C');
enqueue(q, 'D');

assert(dequeue(q) == 'A');
assert(dequeue(q) == 'B');

enqueue(q, 'E');
enqueue(q, 'F');

assert(dequeue(q) == 'C');
assert(dequeue(q) == 'D');
assert(dequeue(q) == 'E');
assert(dequeue(q) == 'F');
```

Serve a controllare che gli indici tornino correttamente all’inizio dell’array.

---

# 35. Applicazioni delle code

Le code sono usate in tanti contesti.

---

## Buffer produttore-consumatore

Un produttore inserisce dati nella coda.

Un consumatore li preleva nell’ordine in cui sono stati prodotti.

Schema:

```text
produttore -> enqueue -> [dati in coda] -> dequeue -> consumatore
```

Esempio:

* streaming;
* stampa;
* comunicazione tra processi;
* input/output.

---

## Scheduling della CPU

Il sistema operativo può mantenere una coda di processi pronti.

```text
ready queue:
[P1] [P2] [P3] [P4]
```

Il processo in testa viene eseguito.

Poi eventualmente torna in fondo.

---

## Ricerca in ampiezza

La BFS, cioè Breadth-First Search, usa una coda.

Idea:

1. parto da un nodo;
2. inserisco i suoi vicini in coda;
3. estraggo il prossimo nodo dalla coda;
4. continuo.

La coda garantisce che i nodi vengano visitati per livelli.

---

# 36. Domande tipiche da esame

## Domanda 1

Spiega la differenza tra stack e queue.

Risposta:

> Lo stack usa politica LIFO: l’ultimo elemento inserito è il primo a essere rimosso. La queue usa politica FIFO: il primo elemento inserito è il primo a essere rimosso.

---

## Domanda 2

Perché in una coda con lista conviene mantenere sia `front` sia `rear`?

Risposta:

> Perché `front` permette di rimuovere dalla testa in O(1), mentre `rear` permette di inserire in fondo in O(1). Senza `rear`, per inserire in fondo sarebbe necessario scorrere tutta la lista, con costo O(n).

---

## Domanda 3

Cosa succede quando rimuovo l’ultimo elemento da una coda con lista?

Risposta:

> Dopo aver rimosso l’ultimo nodo, la coda diventa vuota. Quindi bisogna impostare sia `front` sia `rear` a `NULL` e portare `size` a 0.

---

## Domanda 4

Perché in una coda circolare uso il modulo?

Risposta:

> Perché quando un indice arriva all’ultima posizione dell’array, il modulo permette di farlo tornare a 0. In questo modo l’array viene usato come se fosse circolare.

Esempio:

```c
rear = (rear + 1) % capacity;
```

---

## Domanda 5

Perché `realloc` da sola può non bastare per ridimensionare una coda circolare?

Risposta:

> Perché gli elementi possono essere spezzati in due blocchi fisici nell’array. La `realloc` aumenta lo spazio, ma non riordina automaticamente gli elementi secondo l’ordine FIFO. Conviene quindi allocare un nuovo array e copiare gli elementi partendo da `front`.

---

## Domanda 6

Perché `dsQueue` prende un `CharQueueADT *`?

Risposta:

> Perché `CharQueueADT` è già un puntatore alla struct della coda. Passando `CharQueueADT *`, la funzione riceve l’indirizzo del puntatore del chiamante. Così può liberare la memoria e poi mettere il puntatore originale a `NULL`, evitando dangling pointer.

---

# 37. Errori da evitare

## Errore 1: confondere pila e coda

Sbagliato:

```text
La coda rimuove l’ultimo elemento inserito.
```

Corretto:

```text
La coda rimuove il primo elemento inserito.
```

---

## Errore 2: dimenticare `rear` quando inserisco

Sbagliato:

```c
q->rear->next = newPtr;
```

ma senza poi fare:

```c
q->rear = newPtr;
```

Così `rear` rimarrebbe indietro.

---

## Errore 3: dimenticare `rear = NULL` dopo aver rimosso l’ultimo nodo

Sbagliato:

```c
q->front = q->front->next;
q->size--;
```

Se la coda diventa vuota, `rear` potrebbe ancora puntare a memoria liberata.

Corretto:

```c
if (q->size == 0) {
    q->rear = NULL;
}
```

---

## Errore 4: accedere a memoria dopo `free`

Sbagliato:

```c
free(q->front);
q->front = q->front->next;
```

Corretto:

```c
ListNodePtr oldFront = q->front;
q->front = q->front->next;
free(oldFront);
```

---

## Errore 5: dimenticare il modulo nell’array circolare

Sbagliato:

```c
q->rear++;
```

Corretto:

```c
q->rear = (q->rear + 1) % q->capacity;
```

---

## Errore 6: copiare l’array in ordine fisico durante resize

Sbagliato:

```c
for (int i = 0; i < q->size; i++) {
    newArray[i] = q->a[i];
}
```

Questo funziona solo se `front == 0`.

Corretto:

```c
for (int i = 0; i < q->size; i++) {
    newArray[i] = q->a[(q->front + i) % q->capacity];
}
```

---

# 38. Checklist finale

Prima dell’esame devo saper fare queste cose senza guardare:

* [ ] spiegare FIFO;
* [ ] distinguere queue da stack;
* [ ] scrivere le signature principali dell’ADT;
* [ ] spiegare cos’è un tipo opaco;
* [ ] implementare `mkQueue`;
* [ ] implementare `enqueue` con lista;
* [ ] implementare `dequeue` con lista;
* [ ] implementare `peek` con lista;
* [ ] implementare `dsQueue` con puntatore a puntatore;
* [ ] spiegare perché `rear` rende `enqueue` O(1);
* [ ] spiegare array circolare;
* [ ] usare il modulo;
* [ ] implementare `successor`;
* [ ] implementare `enqueue` con array;
* [ ] implementare `dequeue` con array;
* [ ] implementare `resizeQueue`;
* [ ] spiegare perché `realloc` da sola può essere problematica;
* [ ] scrivere test FIFO;
* [ ] gestire casi limite;
* [ ] ragionare sugli invarianti.

---

# 39. Frase da ricordare

> Una coda è una struttura FIFO: si inserisce in fondo con `enqueue` e si rimuove dalla testa con `dequeue`. Nell’implementazione con lista servono `front` e `rear` per avere entrambe le operazioni in O(1). Nell’implementazione con array dinamico si usa un array circolare, aggiornando gli indici con il modulo e ridimensionando quando la coda è piena.

---

# 40. Mini riassunto da 30 e lode

L’ADT Coda permette di modellare una sequenza di elementi gestita secondo politica FIFO. Le operazioni fondamentali sono `mkQueue`, `enqueue`, `dequeue`, `isEmptyQueue`, `queueSize`, `peek` e `dsQueue`. L’implementazione deve essere nascosta tramite tipo opaco, lasciando all’utente solo l’interfaccia pubblica.

Con lista linkata, la coda viene rappresentata tramite puntatori `front` e `rear`: `front` indica il primo elemento da rimuovere, `rear` l’ultimo elemento inserito. Questa scelta rende sia `enqueue` sia `dequeue` operazioni O(1). Bisogna però gestire attentamente i casi limite: coda vuota, inserimento del primo nodo, rimozione dell’ultimo nodo e liberazione della memoria.

Con array dinamico, la coda viene rappresentata tramite un array circolare. Gli indici `front` e `rear` vengono aggiornati usando il modulo, in modo da riutilizzare le celle liberate all’inizio dell’array. Quando la coda è piena, bisogna ridimensionare l’array copiando gli elementi nel loro ordine logico FIFO, non semplicemente nel loro ordine fisico. Questa implementazione consente accesso a `peek` in O(1), ma richiede più attenzione nella gestione degli indici.

Le code sono fondamentali in molti contesti, come buffer produttore-consumatore, scheduling della CPU e ricerca in ampiezza.
