# Programmazione 2 — Allenamento intensivo sulle liste linkate

> Raccolta progressiva di esercizi in stile esonero/esame: specifica, struttura di partenza, soluzione semplice, eventuale soluzione più elegante o efficiente, complessità e casi limite.
>
> Il focus non è ricordare il codice a memoria, ma riconoscere i **pattern di attraversamento, costruzione e modifica dei collegamenti**.

---

# 0. Convenzioni comuni

Negli esercizi useremo principalmente queste strutture.

```c
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>

typedef struct intNode IntNode, *IntList;
struct intNode {
    int data;
    IntList next;
};

typedef struct charNode CharNode, *CharList;
struct charNode {
    char data;
    CharList next;
};
```

Negli esercizi che costruiscono una nuova lista assumiamo, salvo indicazione contraria, che `malloc` non fallisca. In un progetto reale va sempre gestito l'errore.

Helper comodi per costruire una lista preservando l'ordine:

```c
static IntList newIntNode(int value) {
    IntList node = malloc(sizeof(*node));

    if (node == NULL) {
        exit(EXIT_FAILURE);
    }

    node->data = value;
    node->next = NULL;
    return node;
}

static void appendInt(IntList *headPtr, IntList *tailPtr, int value) {
    IntList node = newIntNode(value);

    if (*tailPtr == NULL) {
        *headPtr = node;
    } else {
        (*tailPtr)->next = node;
    }

    *tailPtr = node;
}

static CharList newCharNode(char value) {
    CharList node = malloc(sizeof(*node));

    if (node == NULL) {
        exit(EXIT_FAILURE);
    }

    node->data = value;
    node->next = NULL;
    return node;
}

static void appendChar(CharList *headPtr, CharList *tailPtr, char value) {
    CharList node = newCharNode(value);

    if (*tailPtr == NULL) {
        *headPtr = node;
    } else {
        (*tailPtr)->next = node;
    }

    *tailPtr = node;
}
```

Distruzione di una lista:

```c
void destroyIntList(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    while (*lsPtr != NULL) {
        IntList victim = *lsPtr;
        *lsPtr = (*lsPtr)->next;
        free(victim);
    }
}
```

## Domande da farsi prima di scrivere codice

1. L'input può essere `NULL`?
2. Devo costruire nuovi nodi o riutilizzare quelli esistenti?
3. La testa può cambiare?
4. Devo preservare l'ordine?
5. Devo modificare l'input?
6. Quando elimino un nodo, ho salvato il collegamento successivo?
7. Se uso due liste, quando avanza ciascun cursore?
8. La funzione deve lasciare invariata la struttura originale?

---

# Livello 1 — Attraversamenti fondamentali

## Esercizio 1 — Lunghezza della lista

### Consegna

Data una lista di interi, restituire il numero di nodi presenti. La lista vuota ha lunghezza `0`. La funzione non deve modificare la lista.

### Struttura di partenza

```c
size_t listLength(IntList ls);
```

### Soluzione semplice

```c
size_t listLength(IntList ls) {
    size_t length = 0;

    for (IntList current = ls;
         current != NULL;
         current = current->next) {
        length++;
    }

    return length;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio ausiliario: `O(1)`

### Casi limite

- Lista vuota.
- Un solo nodo.
- Lista molto lunga.

---

## Esercizio 2 — Numero di occorrenze

### Consegna

Data una lista `ls` e un valore `value`, restituire quante volte `value` compare nella lista. La funzione non modifica `ls`.

### Struttura di partenza

```c
size_t countOccurrences(IntList ls, int value);
```

### Soluzione semplice

```c
size_t countOccurrences(IntList ls, int value) {
    size_t count = 0;

    for (IntList current = ls;
         current != NULL;
         current = current->next) {
        if (current->data == value) {
            count++;
        }
    }

    return count;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

---

## Esercizio 3 — Ultima posizione di un valore

### Consegna

Restituire l'indice dell'ultima occorrenza di `value` nella lista. Il primo nodo ha indice `0`. Se il valore non compare, restituire `-1`.

### Struttura di partenza

```c
long lastIndexOf(IntList ls, int value);
```

### Soluzione semplice

```c
long lastIndexOf(IntList ls, int value) {
    long result = -1;
    long index = 0;

    for (IntList current = ls;
         current != NULL;
         current = current->next, index++) {
        if (current->data == value) {
            result = index;
        }
    }

    return result;
}
```

### Idea chiave

Non serve tornare indietro: basta aggiornare il risultato ogni volta che si incontra un'occorrenza.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

---

## Esercizio 4 — Lista strettamente crescente

### Consegna

Restituire `true` se i valori della lista sono in ordine strettamente crescente. La lista vuota e la lista con un solo nodo sono considerate crescenti.

### Struttura di partenza

```c
bool isStrictlyIncreasing(IntList ls);
```

### Soluzione semplice

```c
bool isStrictlyIncreasing(IntList ls) {
    for (IntList current = ls;
         current != NULL && current->next != NULL;
         current = current->next) {
        if (current->data >= current->next->data) {
            return false;
        }
    }

    return true;
}
```

### Complessità

- Tempo: `O(n)` nel caso peggiore.
- Spazio: `O(1)`.
- Miglior caso: `O(1)` se la prima coppia viola l'ordinamento.

---

## Esercizio 5 — Somma del prefisso positivo

### Consegna

Restituire la somma del più lungo prefisso iniziale formato esclusivamente da valori positivi. Il primo valore non positivo interrompe il calcolo.

Esempi:

```text
[4, 2, 7, 0, 9] -> 13
[-3, 4, 5]       -> 0
[]                -> 0
```

### Struttura di partenza

```c
long sumPositivePrefix(IntList ls);
```

### Soluzione semplice

```c
long sumPositivePrefix(IntList ls) {
    long sum = 0;

    for (IntList current = ls;
         current != NULL && current->data > 0;
         current = current->next) {
        sum += current->data;
    }

    return sum;
}
```

### Pattern allenato

Attraversamento con **arresto anticipato**.

---

## Esercizio 6 — Copia completa della lista

### Consegna

Restituire una nuova lista con gli stessi valori e nello stesso ordine di `ls`. La lista originale non deve essere modificata e i nodi della copia devono essere distinti da quelli originali.

### Struttura di partenza

```c
IntList cloneList(IntList ls);
```

### Soluzione semplice

```c
IntList cloneList(IntList ls) {
    IntList newList = NULL;
    IntList tail = NULL;

    for (IntList currEl = ls;
         currEl != NULL;
         currEl = currEl->next) {

        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return newList;
        }

        newNode->data = currEl->data;
        newNode->next = NULL;
		
        if (newList == NULL) {
	        // e il primo nodo
            newList = newNode;
            tail = newNode;
        } else {
	        // esistono già dei nodi
            tail->next = newNode;
            
            // sposta la coda all'ultimo  elemento
            tail = newNode; 
        }
    }

    return newList;
}
```

### Complessità

- Tempo: `O(n)`.
- Memoria nuova: `O(n)`.

### Errore tipico

```c
return ls;
```

Questo non crea una copia: crea solo un secondo puntatore agli stessi nodi.

---

# Livello 2 — Costruzione di nuove liste

## Esercizio 7 — Filtra e trasforma caratteri

### Consegna

Data una lista di caratteri, restituire una nuova lista contenente tutti e soli i caratteri maiuscoli `'A'`–`'Z'`, convertiti in minuscolo e mantenuti nello stesso ordine. Non modificare la lista originale.

Esempio:

```text
[A, z, C, 4, R] -> [a, c, r]
```

### Struttura di partenza

```c
CharList uppercaseToLowercaseList(CharList ls);
```

### Soluzione semplice

```c
CharList uppercaseToLowercaseList(CharList ls) {

    CharList newList = NULL;
    CharList tail = NULL;

    for (CharList chlist = ls; chlist != NULL; chlist = chlist -> next) {

		// verifica i maiuscoli
        if (isupper((unsigned char) chlist->data)) {
        
            CharList newNode = malloc(sizeof *newNode);
            if (newNode == NULL) {
                return newList;
            }
            
            // prende solo i caratteri maiuscoli
            newNode->data = tolower((unsigned char) chlist->data);
            newNode->next = NULL;

            if (newList == NULL) {
                newList = newNode;
                tail = newNode;
            } else {
                tail->next = newNode;
                tail = newNode;
            }
        }
    }

    return newList;
}
```

### Complessità

- Tempo: `O(n)`.
- Memoria: `O(k)`, con `k` caratteri selezionati.

---

## Esercizio 8 — Mantieni un elemento ogni `k`

### Consegna

Data una lista e un intero `k > 0`, restituire una nuova lista contenente gli elementi alle posizioni `0, k, 2k, 3k, ...`. Non modificare l'input.

Esempio:

```text
ls = [10, 20, 30, 40, 50, 60], k = 2
risultato = [10, 30, 50]
```

### Struttura di partenza

```c
IntList everyKth(IntList ls, size_t k);
```

### Soluzione semplice

```c
IntList everyKth(IntList ls, size_t k) {
    if (k == 0) {
        return NULL;
    }

    IntList newList = NULL;
    IntList tail = NULL;

    size_t index = 0;

    for (IntList currEl = ls;
         currEl != NULL;
         currEl = currEl->next, index++) {

        if (index % k == 0) {
            IntList newNode = malloc(sizeof *newNode);

            if (newNode == NULL) {
                return newList;
            }

            newNode->data = currEl->data;
            newNode->next = NULL;

            if (newList == NULL) {
                newList = newNode;
                tail = newNode;
            } else {
                tail->next = newNode;
                tail = newNode;
            }
        }
    }

    return newList;
}
```

### Soluzione leggermente più efficiente

Evita l'operazione `%` a ogni iterazione usando un conto alla rovescia.

```c
IntList everyKthFast(IntList ls, size_t k) {
    if (k == 0) {
        return NULL;
    }

    IntList result = NULL;
    IntList tail = NULL;
    size_t remaining = 0;

    for (IntList current = ls;
         current != NULL;
         current = current->next) {
        if (remaining == 0) {
            appendInt(&result, &tail, current->data);
            remaining = k - 1;
        } else {
            remaining--;
        }
    }

    return result;
}
```

Entrambe sono `O(n)`; la seconda riduce solo il costo costante.

---

## Esercizio 9 — Duplica i valori negativi

### Consegna

Restituire una nuova lista che contiene gli stessi valori di `ls`, ma ogni valore negativo compare due volte consecutive.

Esempio:

```text
[3, -2, 0, -7] -> [3, -2, -2, 0, -7, -7]
```

### Struttura di partenza

```c
IntList duplicateNegatives(IntList ls);
```

### Soluzione semplice

```c
IntList duplicateNegatives(IntList ls) {

    IntList newList = NULL;
    IntList tail = NULL;

    for (IntList currEl = ls; currEl != NULL; currEl = currEl -> next) {

        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return newList;
        }

        newNode -> data = currEl -> data;
        newNode -> next = NULL;

        if (newList == NULL) {
            newList = newNode;
            tail = newNode;
        } else {
            tail -> next = newNode;
            tail = newNode;
        }

		// inserimento del duplicato. Devo creare un nuovo nodo
        if (currEl->data < 0) { 
	        IntList duplicate = malloc(sizeof *duplicate); 
	        
	        if (duplicate == NULL) { 
		        return newList; 
		    } 
		    
		    duplicate->data = currEl->data;
		    duplicate->next = NULL; 
		    
		    tail->next = duplicate; 
		    tail = duplicate; 
		}
    }

    return newList;
}
```

### Complessità

- Tempo: `O(n)`.
- Memoria: tra `O(n)` e `O(2n)`, quindi `O(n)`.

---

## Esercizio 10 — Compressione delle ripetizioni consecutive

### Consegna

Restituire una nuova lista ottenuta mantenendo una sola copia per ogni gruppo di valori consecutivi uguali.

Esempio:

```text
[1, 1, 1, 2, 2, 3, 1, 1] -> [1, 2, 3, 1]
```

### Struttura di partenza

```c
IntList compressRuns(IntList ls);
```

### Soluzione semplice

```c
IntList compressRuns(IntList ls) {

    IntList newList = NULL;
    IntList tail = NULL;

    for (IntList currEl = ls; currEl != NULL; currEl = currEl -> next) {

        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return newList;
        }

        newNode -> data = currEl -> data;
        newNode -> next = NULL;

        if (newList == NULL) {
            newList = newNode;
            tail = newNode;
        } else {
            tail -> next = newNode;
            tail = newNode;
        }

        while (currEl -> next != NULL && currEl -> next -> data == currEl -> data) {
            currEl = currEl -> next;
        }
    }

    return newList;

}
```

### Nota

Qui `tail->data` coincide con l'ultimo valore inserito nella lista risultato.

---

## Esercizio 11 — Prefisso strettamente crescente copiato

### Consegna

Restituire una nuova lista contenente il più lungo prefisso iniziale di `ls` che sia strettamente crescente. Il primo nodo appartiene sempre al prefisso, se esiste.

Esempi:

```text
[1, 4, 7, 6, 9] -> [1, 4, 7]
[5]             -> [5]
[]              -> []
```

### Struttura di partenza

```c
IntList increasingPrefix(IntList ls);
```

### Soluzione semplice

```c
IntList increasingPrefix(IntList ls) {

    IntList newList = NULL;
    IntList tail = NULL;

    for (IntList currEl = ls; currEl != NULL; currEl = currEl -> next) {
        // significa che c'è almeno un elemento nella nuova lista e che l'elemento corrente
        // di currEl ha un valore non è strettamente maggiore del precedente. quindi abbiamo terminato

        if (tail != NULL && currEl -> data <= tail -> data) {
            return newList;
        }

        // altrimenti inseriamo il nodo nella nuova lista
        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return newList;
        }

        newNode -> data = currEl -> data;
        newNode -> next = NULL;

        if (newList == NULL) {
            newList = newNode;
            tail = newNode;
        } else {
            tail -> next = newNode;
            tail = newNode;
        }
    }
    return newList;

}
```

### Complessità

- Tempo: `O(p)`, con `p` lunghezza del prefisso.
- Memoria: `O(p)`.

---

# Livello 3 — Modifiche in place

## Esercizio 12 — Inserimento ordinato senza duplicati

### Consegna

La lista `*lsPtr` è ordinata in modo crescente e non contiene duplicati. Inserire `value` nella posizione corretta soltanto se non è già presente. Restituire `true` se il valore è stato inserito.

### Struttura di partenza

```c
bool insertSortedUnique(IntList *lsPtr, int value);
```

### Soluzione semplice con puntatore al collegamento

```c
bool insertSortedUnique(IntList *lsPtr, int value) {
    IntList previousEl = NULL;
    IntList currEl = *lsPtr;

    while (currEl != NULL && currEl->data < value) {
        previousEl = currEl;
        currEl = currEl->next;
    }

    /* Il valore è già presente. */
    if (currEl != NULL && currEl->data == value) {
        return false;
    }

    IntList newNode = malloc(sizeof *newNode);

    if (newNode == NULL) {
        return false;
    }

    newNode->data = value;
    newNode->next = currEl;

    if (previousEl == NULL) {
        /* Lista vuota oppure inserimento prima della testa. */
        *lsPtr = newNode;
    } else {
        /* Inserimento al centro oppure in fondo. */
        previousEl->next = newNode;
    }

    return true;
}
```

### Complessità

- Tempo: `O(n)`.
- Spazio: `O(1)` oltre al nuovo nodo.

---

## Esercizio 13 — Cancella la prima occorrenza

### Consegna

Rimuovere la prima occorrenza di `value` dalla lista. Liberare il nodo eliminato. Restituire `true` se un nodo è stato rimosso.

### Struttura di partenza

```c
bool deleteFirst(IntList *lsPtr, int value);
```

### Soluzione semplice

```c
bool deleteFirst(IntList *lsPtr, int value) {

    IntList prevEl = NULL;
    IntList currEl = *lsPtr;
    
    while (currEl != NULL && currEl -> data != value) {
        prevEl = currEl;
        currEl = currEl -> next;
    }

    // sono arrivato alla fine senza trovare occorrenze oppure la lista era vuota in partenza, niente da rimuovere
    if (currEl == NULL) {
        return false;
    }

    // recupero il nodo corrente
    IntList node = currEl;

    // spostamento della testa
    if (prevEl == NULL) {
        *lsPtr = currEl -> next;
    } else {
        // sgancio il nodo
        prevEl -> next = currEl -> next;
    }

    free(node);
    node = NULL;

    return true;

}
```

### Soluzione ottimizzata

```c
bool deleteFirst(IntList *lsPtr, int value) {
    if (lsPtr == NULL) {
        return false;
    }

    IntList *linkPtr = lsPtr;

    while (*linkPtr != NULL && (*linkPtr)->data != value) {
        linkPtr = &(*linkPtr)->next;
    }

    if (*linkPtr == NULL) {
        return false;
    }

    IntList victim = *linkPtr;
    *linkPtr = victim->next;
    free(victim);
    return true;
}
```

### Errore tipico

Fare `free(current)` e solo dopo leggere `current->next`: è un accesso a memoria già liberata.

---

## Esercizio 14 — Cancella tutte le occorrenze

### Consegna

Rimuovere tutte le occorrenze di `value` da `*lsPtr`, liberando i nodi eliminati. Restituire il numero di nodi rimossi.

### Struttura di partenza

```c
size_t deleteAll(IntList *lsPtr, int value);
```

### Soluzione semplice

```c
size_t deleteAll(IntList *lsPtr, int value) {

    IntList prevEl = NULL;
    IntList currEl = *lsPtr;

    size_t occ = 0;

    while (currEl != NULL) {

        if (currEl -> data == value) {
            IntList temp = currEl;

            // rimuovo in testa
            if (prevEl == NULL) {
                *lsPtr = currEl -> next;
                currEl = currEl -> next;
            } else {
	            // rimuovo in mezzo, devo aggiornare anche currEl
	            // perché non c'è il for e dopo non viene aggiornato 
                prevEl -> next = currEl -> next;
                currEl = currEl -> next;
            }
            
            // libero la memoria
            free(temp);
            temp = NULL;
            
            occ++;
        } else {
	        // altrimenti porto avanti prevEl
            prevEl = currEl;
            currEl = currEl -> next;
        }
    }
    return occ;

}
```

### Soluzione ottimizzata

```c
size_t deleteAll(IntList *lsPtr, int value) {
    if (lsPtr == NULL) {
        return 0;
    }

    size_t removed = 0;
    IntList *linkPtr = lsPtr;

    while (*linkPtr != NULL) {
        if ((*linkPtr)->data == value) {
            IntList victim = *linkPtr;
            *linkPtr = victim->next;
            free(victim);
            removed++;
        } else {
            linkPtr = &(*linkPtr)->next;
        }
    }

    return removed;
}
```

### Punto delicato

Quando si elimina un nodo, `linkPtr` non deve avanzare: ora punta già al collegamento del nodo successivo.

---

## Esercizio 15 — Inversione iterativa

### Consegna

Invertire l'ordine dei nodi di `*lsPtr` senza allocare o liberare nodi.

### Struttura di partenza

```c
void reverseIterative(IntList *lsPtr);
```

### Soluzione semplice

```c
void reverseIterative(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    IntList previous = NULL;
    IntList current = *lsPtr;

	// pattern (salva, gira, avanza, avanza)
    while (current != NULL) {
        IntList next = current->next; // ricordo il nodo successivo
        current->next = previous; // il nodo corrente punta verso la parte invertita
        previous = current; // primo nodo della parte invertita
        current = next; // continuo dal nodo che ho salvato all'inizio
    }

    *lsPtr = previous;
}
```

### Invariante utile

- `previous` è la porzione già invertita.
- `current` è il primo nodo della porzione ancora da elaborare.

### Complessità

- Tempo: `O(n)`.
- Spazio: `O(1)`.

---

## Esercizio 16 — Inversione ricorsiva

### Consegna

Invertire una lista usando la ricorsione, senza allocare nuovi nodi.

### Struttura di partenza

```c
void reverseRecursive(IntList *lsPtr);
```

### Soluzione semplice

```c
void reverse(IntList *lsPtr) {
    /* Caso base: lista vuota o con un solo nodo */
    if (lsPtr == NULL || *lsPtr == NULL || (*lsPtr)->next == NULL) {
        return;
    }

    /* Salviamo il primo nodo e l'inizio del resto della lista */
    IntList first = *lsPtr;
    IntList rest = first->next;

    /* Invertiamo ricorsivamente il resto */
    reverse(&rest);

    /* Mettiamo il primo nodo alla fine */
    first->next->next = first;
    first->next = NULL;

    /* Aggiorniamo la testa */
    *lsPtr = rest;
}
```

### Soluzione con funzione ausiliaria

```c
static IntList reverseRecHelper(IntList ls) {
	// caso base: lista vuota o un solo nodo
    if (ls == NULL || ls->next == NULL) {
        return ls;
    }

    IntList newHead = reverseRecHelper(ls->next);
    ls->next->next = ls;
    ls->next = NULL;
    return newHead;
}

void reverseRecursive(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    *lsPtr = reverseRecHelper(*lsPtr);
}
```

### Complessità

- Tempo: `O(n)`.
- Stack ricorsivo: `O(n)`.

### Nota pratica

La versione iterativa è preferibile per liste molto lunghe, perché non rischia stack overflow.

---

## Esercizio 17 — Rotazione a sinistra di `k` posizioni

### Consegna

Spostare i primi `k` nodi in fondo alla lista, mantenendo il loro ordine. Non allocare nuovi nodi.

Esempio:

```text
[1, 2, 3, 4, 5], k = 2 -> [3, 4, 5, 1, 2]
```

### Struttura di partenza

```c
void rotateLeft(IntList *lsPtr, size_t k);
```

### Soluzione semplice e già ottimale

```c
void rotateLeft(IntList *lsPtr, size_t k) {
    if (lsPtr == NULL || *lsPtr == NULL || (*lsPtr)->next == NULL) {
        return;
    }

    size_t length = 1;
    IntList tail = *lsPtr;

    while (tail->next != NULL) {
        tail = tail->next;
        length++;
    }

    k %= length;

    if (k == 0) {
        return;
    }

    IntList newTail = *lsPtr;

    for (size_t i = 1; i < k; i++) {
        newTail = newTail->next;
    }

    IntList newHead = newTail->next;
    newTail->next = NULL;
    tail->next = *lsPtr;
    *lsPtr = newHead;
}
```

### Complessità

- Tempo: `O(n)`.
- Spazio: `O(1)`.

---

## Esercizio 18 — Partizione stabile pari/dispari

### Consegna

Riorganizzare i nodi affinché tutti i valori pari precedano tutti i valori dispari. L'ordine relativo tra i pari e tra i dispari deve rimanere invariato. Non allocare né liberare nodi.

Esempio:

```text
[3, 2, 5, 4, 6, 1] -> [2, 4, 6, 3, 5, 1]
```

### Struttura di partenza

```c
void stableEvenOddPartition(IntList *lsPtr);
```

### Soluzione semplice

```c
void stableEvenOddPartition(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    IntList evenHead = NULL;
    IntList evenTail = NULL;
    IntList oddHead = NULL;
    IntList oddTail = NULL;
    IntList current = *lsPtr;

    while (current != NULL) {
        IntList next = current->next;
        current->next = NULL;

        if (current->data % 2 == 0) {
            if (evenTail == NULL) {
                evenHead = current;
            } else {
                evenTail->next = current;
            }
            evenTail = current;
        } else {
            if (oddTail == NULL) {
                oddHead = current;
            } else {
                oddTail->next = current;
            }
            oddTail = current;
        }

        current = next;
    }

    if (evenTail != NULL) {
        evenTail->next = oddHead;
        *lsPtr = evenHead;
    } else {
        *lsPtr = oddHead;
    }
}
```

### Complessità

- Tempo: `O(n)`.
- Spazio: `O(1)`.

### Errore tipico

Non scollegare `current->next` prima di aggiungere il nodo a una nuova catena può creare collegamenti indesiderati o cicli.

---

## Esercizio 19 — Scambia i nodi a coppie

### Consegna

Scambiare il primo nodo con il secondo, il terzo con il quarto e così via. Se il numero di nodi è dispari, l'ultimo resta in posizione. Non scambiare soltanto i valori: bisogna modificare i collegamenti.

Esempio:

```text
[1, 2, 3, 4, 5] -> [2, 1, 4, 3, 5]
```

### Struttura di partenza

```c
void swapPairs(IntList *lsPtr);
```

### Soluzione semplice con nodo sentinella locale

```c
void swapPairs(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    IntNode dummy = {0, *lsPtr};
    IntList previous = &dummy;

    while (previous->next != NULL &&
           previous->next->next != NULL) {
        IntList first = previous->next;
        IntList second = first->next;

        first->next = second->next;
        second->next = first;
        previous->next = second;

        previous = first;
    }

    *lsPtr = dummy.next;
}
```

### Complessità

- Tempo: `O(n)`.
- Spazio: `O(1)`.

---

## Esercizio 20 — Inverti blocchi completi di `k` nodi

### Consegna

Invertire ogni blocco completo di `k` nodi. Un eventuale blocco finale con meno di `k` nodi deve restare invariato. Non allocare nuovi nodi.

Esempio:

```text
[1, 2, 3, 4, 5, 6, 7], k = 3
-> [3, 2, 1, 6, 5, 4, 7]
```

### Struttura di partenza

```c
void reverseKGroups(IntList *lsPtr, size_t k);
```

### Soluzione semplice

```c
void reverseKGroups(IntList *lsPtr, size_t k) {
    if (lsPtr == NULL || k < 2) {
        return;
    }

    IntNode dummy = {0, *lsPtr};
    IntList groupPrevious = &dummy;

    while (true) {
        IntList kth = groupPrevious;

        for (size_t i = 0; i < k && kth != NULL; i++) {
            kth = kth->next;
        }

        if (kth == NULL) {
            break;
        }

        IntList groupNext = kth->next;
        IntList previous = groupNext;
        IntList current = groupPrevious->next;

        while (current != groupNext) {
            IntList next = current->next;
            current->next = previous;
            previous = current;
            current = next;
        }

        IntList oldGroupHead = groupPrevious->next;
        groupPrevious->next = kth;
        groupPrevious = oldGroupHead;
    }

    *lsPtr = dummy.next;
}
```

### Complessità

- Tempo: `O(n)`.
- Spazio: `O(1)`.

### Livello di difficoltà

Alto: combina ricerca del limite del blocco, inversione e ricucitura con il resto della lista.

---

# Livello 4 — Due liste contemporaneamente

## Esercizio 21 — Prefisso senza uguaglianze posizionali

### Consegna

Date due liste `l` e `r`, restituire una nuova lista contenente il più lungo prefisso di `l` per cui, in ogni posizione in cui `r` possiede un nodo, i due valori sono diversi. Se `r` termina, il resto di `l` appartiene al risultato. Non modificare gli input.

Esempi:

```text
l = [1, 2, 3, 4], r = [9, 8]       -> [1, 2, 3, 4]
l = [1, 2, 3, 4], r = [9, 2, 7]    -> [1]
l = [], r = [1, 2]                  -> []
```

### Struttura di partenza

```c
IntList antiEqualPrefix(IntList l, IntList r);
```

### Soluzione semplice

```c
IntList antiEqualPrefix(IntList l, IntList r) {
    IntList result = NULL;
    IntList tail = NULL;

    while (l != NULL) {
        if (r != NULL && l->data == r->data) {
            break;
        }

        appendInt(&result, &tail, l->data);
        l = l->next;

        if (r != NULL) {
            r = r->next;
        }
    }

    return result;
}
```

### Complessità

- Tempo: `O(p)`, con `p` lunghezza del prefisso prodotto più al massimo un confronto finale.
- Memoria: `O(p)`.

---

## Esercizio 22 — Prefisso comune

### Consegna

Restituire una nuova lista contenente il più lungo prefisso iniziale identico di `l` e `r`.

Esempio:

```text
[1, 2, 3, 8] e [1, 2, 3, 9, 4] -> [1, 2, 3]
```

### Struttura di partenza

```c
IntList commonPrefix(IntList l, IntList r);
```

### Soluzione semplice

```c
IntList commonPrefix(IntList l, IntList r) {
    IntList result = NULL;
    IntList tail = NULL;

    while (l != NULL && r != NULL && l->data == r->data) {
        appendInt(&result, &tail, l->data);
        l = l->next;
        r = r->next;
    }

    return result;
}
```

### Complessità

- Tempo: `O(min(m, n))` nel caso peggiore.
- Memoria: `O(p)`.

---

## Esercizio 23 — Fusione ordinata con copia

### Consegna

Date due liste ordinate in modo crescente, restituire una nuova lista ordinata contenente tutti i loro valori. Le liste originali non devono essere modificate. I duplicati vanno mantenuti.

### Struttura di partenza

```c
IntList mergeSortedCopy(IntList l, IntList r);
```

### Soluzione semplice

```c
IntList mergeSortedCopy(IntList l, IntList r) {
    IntList result = NULL;
    IntList tail = NULL;

    while (l != NULL && r != NULL) {
        if (l->data <= r->data) {
            appendInt(&result, &tail, l->data);
            l = l->next;
        } else {
            appendInt(&result, &tail, r->data);
            r = r->next;
        }
    }

    while (l != NULL) {
        appendInt(&result, &tail, l->data);
        l = l->next;
    }

    while (r != NULL) {
        appendInt(&result, &tail, r->data);
        r = r->next;
    }

    return result;
}
```

### Complessità

- Tempo: `O(m + n)`.
- Memoria: `O(m + n)`.

---

## Esercizio 24 — Fusione ordinata in place

### Consegna

Date due liste ordinate, fondere i loro nodi in una sola lista ordinata senza allocare nuovi nodi. Dopo la chiamata, `*lPtr` deve contenere la lista risultante e `*rPtr` deve valere `NULL`.

### Struttura di partenza

```c
void mergeSortedInPlace(IntList *lPtr, IntList *rPtr);
```

### Soluzione semplice

```c
void mergeSortedInPlace(IntList *lPtr, IntList *rPtr) {
    if (lPtr == NULL || rPtr == NULL) {
        return;
    }

    IntList l = *lPtr;
    IntList r = *rPtr;
    IntNode dummy = {0, NULL};
    IntList tail = &dummy;

    while (l != NULL && r != NULL) {
        if (l->data <= r->data) {
            tail->next = l;
            l = l->next;
        } else {
            tail->next = r;
            r = r->next;
        }

        tail = tail->next;
    }

    tail->next = (l != NULL) ? l : r;
    *lPtr = dummy.next;
    *rPtr = NULL;
}
```

### Complessità

- Tempo: `O(m + n)`.
- Spazio: `O(1)`.

### Punto da controllare

Nessun nodo deve essere copiato o liberato.

---

## Esercizio 25 — Alternanza di due liste con copia

### Consegna

Restituire una nuova lista ottenuta alternando un nodo di `l` e un nodo di `r`, iniziando da `l`. Quando una lista termina, copiare tutto il resto dell'altra.

Esempio:

```text
l = [1, 3, 5, 7]
r = [2, 4]
risultato = [1, 2, 3, 4, 5, 7]
```

### Struttura di partenza

```c
IntList zipAlternating(IntList l, IntList r);
```

### Soluzione semplice

```c
IntList zipAlternating(IntList l, IntList r) {
    IntList result = NULL;
    IntList tail = NULL;

    while (l != NULL || r != NULL) {
        if (l != NULL) {
            appendInt(&result, &tail, l->data);
            l = l->next;
        }

        if (r != NULL) {
            appendInt(&result, &tail, r->data);
            r = r->next;
        }
    }

    return result;
}
```

### Complessità

- Tempo: `O(m + n)`.
- Memoria: `O(m + n)`.

---

## Esercizio 26 — Rimuovi dalla prima lista le uguaglianze posizionali

### Consegna

Date `*lPtr` e `r`, rimuovere da `*lPtr` ogni nodo che ha lo stesso valore del nodo nella posizione corrispondente di `r`. Quando `r` termina, il resto di `*lPtr` non viene modificato. `r` deve restare invariata.

Esempio:

```text
l = [1, 2, 3, 4, 5]
r = [9, 2, 8, 4]
risultato l = [1, 3, 5]
```

### Struttura di partenza

```c
size_t removeEqualPositions(IntList *lPtr, IntList r);
```

### Soluzione semplice

```c
size_t removeEqualPositions(IntList *lPtr, IntList r) {
    if (lPtr == NULL) {
        return 0;
    }

    size_t removed = 0;
    IntList *linkPtr = lPtr;

    while (*linkPtr != NULL && r != NULL) {
        if ((*linkPtr)->data == r->data) {
            IntList victim = *linkPtr;
            *linkPtr = victim->next;
            free(victim);
            removed++;
        } else {
            linkPtr = &(*linkPtr)->next;
        }

        r = r->next;
    }

    return removed;
}
```

### Punto molto importante

La posizione in `r` avanza sempre, anche quando un nodo viene rimosso da `l`.

---

## Esercizio 27 — Intersezione senza duplicati di liste ordinate

### Consegna

Date due liste ordinate in modo crescente, restituire una nuova lista contenente i valori presenti in entrambe, una sola volta ciascuno.

Esempio:

```text
l = [1, 1, 2, 4, 4, 7]
r = [1, 3, 4, 4, 8]
risultato = [1, 4]
```

### Struttura di partenza

```c
IntList sortedIntersectionUnique(IntList l, IntList r);
```

### Soluzione semplice e ottimale

```c
IntList sortedIntersectionUnique(IntList l, IntList r) {
    IntList result = NULL;
    IntList tail = NULL;

    while (l != NULL && r != NULL) {
        if (l->data < r->data) {
            int value = l->data;
            while (l != NULL && l->data == value) {
                l = l->next;
            }
        } else if (r->data < l->data) {
            int value = r->data;
            while (r != NULL && r->data == value) {
                r = r->next;
            }
        } else {
            int value = l->data;
            appendInt(&result, &tail, value);

            while (l != NULL && l->data == value) {
                l = l->next;
            }

            while (r != NULL && r->data == value) {
                r = r->next;
            }
        }
    }

    return result;
}
```

### Complessità

- Tempo: `O(m + n)`.
- Memoria: `O(k)` per il risultato.

---

# Livello 5 — Problemi avanzati

## Esercizio 28 — Palindromo con ripristino della lista

### Consegna

Restituire `true` se la sequenza dei valori è palindroma. La funzione deve lasciare la lista identica a prima della chiamata.

Esempi:

```text
[1, 2, 3, 2, 1] -> true
[1, 2, 2, 1]    -> true
[1, 2, 3]       -> false
```

### Struttura di partenza

```c
bool isPalindrome(IntList ls);
```

### Soluzione semplice con array

```c
bool isPalindromeSimple(IntList ls) {
    size_t n = listLength(ls);

    if (n < 2) {
        return true;
    }

    int *values = malloc(n * sizeof(*values));

    if (values == NULL) {
        exit(EXIT_FAILURE);
    }

    size_t i = 0;

    for (IntList current = ls;
         current != NULL;
         current = current->next) {
        values[i++] = current->data;
    }

    bool result = true;

    for (size_t left = 0, right = n - 1;
         left < right;
         left++, right--) {
        if (values[left] != values[right]) {
            result = false;
            break;
        }
    }

    free(values);
    return result;
}
```

### Complessità della soluzione semplice

- Tempo: `O(n)`.
- Spazio: `O(n)`.

### Soluzione ottimizzata `O(1)` spazio

```c
static IntList reverseChain(IntList ls) {
    IntList previous = NULL;

    while (ls != NULL) {
        IntList next = ls->next;
        ls->next = previous;
        previous = ls;
        ls = next;
    }

    return previous;
}

bool isPalindrome(IntList ls) {
    if (ls == NULL || ls->next == NULL) {
        return true;
    }

    IntList slow = ls;
    IntList fast = ls;

    while (fast != NULL && fast->next != NULL) {
        slow = slow->next;
        fast = fast->next->next;
    }

    IntList secondHalfStart =
        (fast != NULL) ? slow->next : slow;

    IntList reversed = reverseChain(secondHalfStart);
    IntList left = ls;
    IntList right = reversed;
    bool result = true;

    while (right != NULL) {
        if (left->data != right->data) {
            result = false;
            break;
        }

        left = left->next;
        right = right->next;
    }

    reverseChain(reversed);
    return result;
}
```

### Complessità ottimizzata

- Tempo: `O(n)`.
- Spazio: `O(1)`.

### Punto d'esame

Non basta ottenere il risultato corretto: la lista va ripristinata.

---

## Esercizio 29 — Elimina i nodi che hanno un valore maggiore alla loro destra

### Consegna

Rimuovere ogni nodo per cui esiste, più avanti nella lista, un nodo con valore strettamente maggiore.

Esempio:

```text
[12, 15, 10, 11, 5, 6, 2, 3]
-> [15, 11, 6, 3]
```

### Struttura di partenza

```c
size_t removeWithGreaterOnRight(IntList *lsPtr);
```

### Soluzione semplice `O(n²)`

```c
size_t removeWithGreaterOnRightSimple(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return 0;
    }

    size_t removed = 0;
    IntList *linkPtr = lsPtr;

    while (*linkPtr != NULL) {
        bool greaterExists = false;

        for (IntList scan = (*linkPtr)->next;
             scan != NULL;
             scan = scan->next) {
            if (scan->data > (*linkPtr)->data) {
                greaterExists = true;
                break;
            }
        }

        if (greaterExists) {
            IntList victim = *linkPtr;
            *linkPtr = victim->next;
            free(victim);
            removed++;
        } else {
            linkPtr = &(*linkPtr)->next;
        }
    }

    return removed;
}
```

### Soluzione ottimizzata `O(n)`

Idea:

1. Inverti la lista.
2. Scorri mantenendo il massimo visto finora.
3. Elimina i valori inferiori al massimo.
4. Inverti di nuovo.

```c
size_t removeWithGreaterOnRight(IntList *lsPtr) {
    if (lsPtr == NULL || *lsPtr == NULL) {
        return 0;
    }

    *lsPtr = reverseChain(*lsPtr);

    size_t removed = 0;
    int maxSoFar = (*lsPtr)->data;
    IntList current = *lsPtr;

    while (current->next != NULL) {
        if (current->next->data < maxSoFar) {
            IntList victim = current->next;
            current->next = victim->next;
            free(victim);
            removed++;
        } else {
            current = current->next;
            maxSoFar = current->data;
        }
    }

    *lsPtr = reverseChain(*lsPtr);
    return removed;
}
```

### Complessità

- Soluzione semplice: `O(n²)` tempo, `O(1)` spazio.
- Soluzione ottimizzata: `O(n)` tempo, `O(1)` spazio.

---

## Esercizio 30 — Riordina alternando primo e ultimo

### Consegna

Riorganizzare i nodi nell'ordine:

```text
L0, Ln, L1, Ln-1, L2, Ln-2, ...
```

Non allocare nuovi nodi e non modificare i valori.

Esempi:

```text
[1, 2, 3, 4, 5]    -> [1, 5, 2, 4, 3]
[1, 2, 3, 4, 5, 6] -> [1, 6, 2, 5, 3, 4]
```

### Struttura di partenza

```c
void reorderEnds(IntList *lsPtr);
```

### Soluzione semplice con array di puntatori

```c
void reorderEndsSimple(IntList *lsPtr) {
    if (lsPtr == NULL || *lsPtr == NULL) {
        return;
    }

    size_t n = listLength(*lsPtr);
    IntList *nodes = malloc(n * sizeof(*nodes));

    if (nodes == NULL) {
        exit(EXIT_FAILURE);
    }

    IntList current = *lsPtr;

    for (size_t i = 0; i < n; i++) {
        nodes[i] = current;
        current = current->next;
    }

    size_t left = 0;
    size_t right = n - 1;
    IntNode dummy = {0, NULL};
    IntList tail = &dummy;

    while (left <= right) {
        tail->next = nodes[left++];
        tail = tail->next;

        if (left <= right) {
            tail->next = nodes[right--];
            tail = tail->next;
        }
    }

    tail->next = NULL;
    *lsPtr = dummy.next;
    free(nodes);
}
```

### Complessità semplice

- Tempo: `O(n)`.
- Spazio: `O(n)`.

### Soluzione elegante `O(1)` spazio

1. Trova il centro.
2. Separa la lista in due metà.
3. Inverti la seconda metà.
4. Intreccia le due catene.

```c
void reorderEnds(IntList *lsPtr) {
    if (lsPtr == NULL || *lsPtr == NULL || (*lsPtr)->next == NULL) {
        return;
    }

    IntList slow = *lsPtr;
    IntList fast = *lsPtr;

    while (fast->next != NULL && fast->next->next != NULL) {
        slow = slow->next;
        fast = fast->next->next;
    }

    IntList second = slow->next;
    slow->next = NULL;
    second = reverseChain(second);

    IntList first = *lsPtr;

    while (second != NULL) {
        IntList firstNext = first->next;
        IntList secondNext = second->next;

        first->next = second;
        second->next = firstNext;

        first = firstNext;
        second = secondNext;
    }
}
```

### Complessità ottimizzata

- Tempo: `O(n)`.
- Spazio: `O(1)`.

---

## Esercizio 31 — Merge sort su lista linkata

### Consegna

Ordinare la lista in modo crescente usando merge sort. Non allocare nuovi nodi; è consentito modificare i collegamenti.

### Struttura di partenza

```c
void mergeSortList(IntList *lsPtr);
```

### Soluzione

```c
static IntList mergeChains(IntList a, IntList b) {
    IntNode dummy = {0, NULL};
    IntList tail = &dummy;

    while (a != NULL && b != NULL) {
        if (a->data <= b->data) {
            tail->next = a;
            a = a->next;
        } else {
            tail->next = b;
            b = b->next;
        }

        tail = tail->next;
    }

    tail->next = (a != NULL) ? a : b;
    return dummy.next;
}

static void splitHalf(IntList source,
                      IntList *frontPtr,
                      IntList *backPtr) {
    IntList slow = source;
    IntList fast = source->next;

    while (fast != NULL) {
        fast = fast->next;

        if (fast != NULL) {
            slow = slow->next;
            fast = fast->next;
        }
    }

    *frontPtr = source;
    *backPtr = slow->next;
    slow->next = NULL;
}

static IntList mergeSortChain(IntList ls) {
    if (ls == NULL || ls->next == NULL) {
        return ls;
    }

    IntList left = NULL;
    IntList right = NULL;
    splitHalf(ls, &left, &right);

    left = mergeSortChain(left);
    right = mergeSortChain(right);
    return mergeChains(left, right);
}

void mergeSortList(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    *lsPtr = mergeSortChain(*lsPtr);
}
```

### Complessità

- Tempo: `O(n log n)`.
- Spazio ausiliario: `O(log n)` per lo stack ricorsivo.

### Perché merge sort è adatto alle liste

La fusione di due liste ordinate richiede solo modifiche ai puntatori e non necessita di accesso casuale.

---

# Livello 6 — Bonus infernali

## Esercizio 32 — Rileva e rimuovi un ciclo

### Consegna

La lista potrebbe contenere un ciclo. Se il ciclo esiste, spezzarlo mantenendo tutti i nodi raggiungibili una sola volta e restituire `true`. Se la lista è già lineare, non modificarla e restituire `false`.

### Struttura di partenza

```c
bool removeCycle(IntList ls);
```

### Soluzione semplice con algoritmo di Floyd

```c
bool removeCycle(IntList ls) {
    if (ls == NULL) {
        return false;
    }

    IntList slow = ls;
    IntList fast = ls;

    do {
        if (fast == NULL || fast->next == NULL) {
            return false;
        }

        slow = slow->next;
        fast = fast->next->next;
    } while (slow != fast);

    IntList entry = ls;

    while (entry != slow) {
        entry = entry->next;
        slow = slow->next;
    }

    IntList lastInCycle = entry;

    while (lastInCycle->next != entry) {
        lastInCycle = lastInCycle->next;
    }

    lastInCycle->next = NULL;
    return true;
}
```

### Complessità

- Tempo: `O(n)`.
- Spazio: `O(1)`.

---

## Esercizio 33 — Intersezione per identità dei nodi

### Consegna

Due liste acicliche possono condividere fisicamente una coda di nodi. Restituire il primo nodo condiviso, confrontando gli indirizzi e non i valori. Se non esiste intersezione, restituire `NULL`.

Esempio concettuale:

```text
l: A -> B -> C -> D
              ^
r:       X -> Y
```

Il risultato è il nodo `C`.

### Struttura di partenza

```c
IntList firstSharedNode(IntList l, IntList r);
```

### Soluzione semplice

```c
IntList firstSharedNode(IntList l, IntList r) {
    size_t lenL = listLength(l);
    size_t lenR = listLength(r);

    while (lenL > lenR) {
        l = l->next;
        lenL--;
    }

    while (lenR > lenL) {
        r = r->next;
        lenR--;
    }

    while (l != r) {
        l = l->next;
        r = r->next;
    }

    return l;
}
```

### Complessità

- Tempo: `O(m + n)`.
- Spazio: `O(1)`.

### Attenzione

```c
l->data == r->data
```

non indica che i nodi sono gli stessi.

---

## Esercizio 34 — Somma di numeri rappresentati da liste

### Consegna

Ogni lista rappresenta un intero non negativo, con la cifra meno significativa in testa. Restituire una nuova lista che rappresenta la somma.

Esempio:

```text
[2, 4, 3] rappresenta 342
[5, 6, 4] rappresenta 465
risultato [7, 0, 8] rappresenta 807
```

Ogni nodo contiene una cifra tra `0` e `9`.

### Struttura di partenza

```c
IntList addDigitLists(IntList a, IntList b);
```

### Soluzione semplice

```c
IntList addDigitLists(IntList a, IntList b) {
    IntList result = NULL;
    IntList tail = NULL;
    int carry = 0;

    while (a != NULL || b != NULL || carry != 0) {
        int sum = carry;

        if (a != NULL) {
            sum += a->data;
            a = a->next;
        }

        if (b != NULL) {
            sum += b->data;
            b = b->next;
        }

        appendInt(&result, &tail, sum % 10);
        carry = sum / 10;
    }

    return result;
}
```

### Complessità

- Tempo: `O(max(m, n))`.
- Memoria: `O(max(m, n) + 1)`.

---

## Esercizio 35 — Elimina tutti i valori non unici

### Consegna

Rimuovere dalla lista ogni nodo il cui valore compare più di una volta nella lista originale. Devono rimanere soltanto i valori che comparivano esattamente una volta.

Esempio:

```text
[1, 2, 3, 2, 4, 1, 5] -> [3, 4, 5]
```

### Struttura di partenza

```c
size_t removeAllNonUnique(IntList *lsPtr);
```

### Soluzione semplice `O(n²)`

```c
size_t removeAllNonUnique(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return 0;
    }

    size_t removed = 0;
    IntList *linkPtr = lsPtr;

    while (*linkPtr != NULL) {
        int value = (*linkPtr)->data;
        size_t count = 0;

        for (IntList scan = *lsPtr;
             scan != NULL;
             scan = scan->next) {
            if (scan->data == value) {
                count++;
            }
        }

        if (count > 1) {
            IntList victim = *linkPtr;
            *linkPtr = victim->next;
            free(victim);
            removed++;
        } else {
            linkPtr = &(*linkPtr)->next;
        }
    }

    return removed;
}
```

### Complessità

- Tempo: `O(n²)`.
- Spazio: `O(1)`.

### Possibile ottimizzazione

Con una tabella hash delle frequenze si può ottenere tempo medio `O(n)`, ma richiede una struttura dati aggiuntiva non sempre disponibile negli esercizi del corso.

---

# 7. Pattern da riconoscere immediatamente

| Frase nella consegna | Pattern probabile |
|---|---|
| “senza modificare la lista” | costruzione di una nuova lista |
| “mantenendo lo stesso ordine” | append in coda con `head` e `tail` |
| “senza allocare nuova memoria” | riuso dei nodi e modifica dei `next` |
| “riorganizza i nodi” | operazione in place |
| “prefisso più lungo” | ciclo con arresto anticipato |
| “posizione corrispondente” | due cursori che avanzano in parallelo |
| “liste ordinate” | avanzare il cursore con valore minore |
| “eliminare nodi” | puntatore al collegamento `IntList *linkPtr` |
| “invertire” | `previous`, `current`, `next` |
| “dal primo e dall'ultimo” | centro + inversione seconda metà + merge |
| “valore maggiore a destra” | scansione quadratica oppure inversione + massimo |
| “non modificare l'input” | vietato riutilizzare i nodi nel risultato |

---

# 8. Checklist per la consegna d'esame

Prima di considerare finita una funzione, verifica:

- [ ] Compila senza warning importanti.
- [ ] Gestisce `NULL` dove previsto.
- [ ] Gestisce lista vuota e lista di un solo nodo.
- [ ] Non dereferenzia mai un puntatore prima di verificare che sia diverso da `NULL`.
- [ ] Non perde la testa della lista.
- [ ] Prima di cambiare un `next`, salva il resto della lista se necessario.
- [ ] Ogni nodo eliminato viene liberato una sola volta.
- [ ] Nessun nodo della lista originale viene liberato quando la consegna richiede una copia.
- [ ] L'ordine richiesto è preservato.
- [ ] Le liste dichiarate “non modificabili” sono realmente invariate.
- [ ] Il risultato vuoto è rappresentato da `NULL`.
- [ ] La complessità è compatibile con i limiti impliciti della consegna.

---

# 9. Ordine consigliato di allenamento

## Prima tornata — Meccanica

1. `listLength`
2. `countOccurrences`
3. `cloneList`
4. `deleteFirst`
5. `deleteAll`
6. `reverseIterative`

## Seconda tornata — Costruzione e ordine

7. `uppercaseToLowercaseList`
8. `duplicateNegatives`
9. `compressRuns`
10. `increasingPrefix`
11. `insertSortedUnique`

## Terza tornata — Due liste

12. `antiEqualPrefix`
13. `commonPrefix`
14. `mergeSortedCopy`
15. `mergeSortedInPlace`
16. `removeEqualPositions`
17. `sortedIntersectionUnique`

## Quarta tornata — Puntatori avanzati

18. `rotateLeft`
19. `stableEvenOddPartition`
20. `swapPairs`
21. `reverseKGroups`
22. `reorderEnds`

## Quinta tornata — Appello infernale

23. `isPalindrome`
24. `removeWithGreaterOnRight`
25. `mergeSortList`
26. `removeCycle`
27. `firstSharedNode`
28. `addDigitLists`
29. `removeAllNonUnique`

---

# 10. Regola finale

Quando la consegna sembra nuova, riducila a questa griglia:

```text
1. Quanti cursori servono?
2. Chi avanza e quando?
3. Devo fermarmi prima della fine?
4. Creo nodi nuovi o sposto quelli vecchi?
5. La testa può cambiare?
6. Quale collegamento devo aggiornare?
7. Posso perdere il resto della lista?
8. Qual è la complessità della soluzione più immediata?
9. Esiste un modo per evitare scansioni ripetute?
```

Quasi tutti gli esercizi “infernali” sono combinazioni di due o tre pattern già presenti in questa raccolta.
