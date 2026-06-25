# Ricorsione e Liste Linkate

## Obiettivo della lezione

Questa lezione unisce due concetti fondamentali di Programmazione II:

1. **ricorsione**
2. **liste linkate**

Il punto centrale da capire è che una lista linkata è **ricorsiva per natura**.

Una lista può essere vista così:

```text
lista = NULL
```

oppure:

```text
lista = nodo + resto_della_lista
```

Esempio:

```text
13 -> 6 -> 4 -> 11 -> NULL
```

può essere letta come:

```text
13 -> [6 -> 4 -> 11 -> NULL]
```

cioè:

```text
testa + coda
```

Questa struttura si presta molto bene alla ricorsione, perché ogni nodo contiene un puntatore alla “lista rimanente”.

---

# 1. Struttura ricorsiva di una lista linkata

Supponiamo di avere questa definizione:

```c
typedef struct int_list_node {
    int v;
    struct int_list_node *next;
} IntListNode;

typedef IntListNode *IntList;
```

Quindi:

```c
IntList ls;
```

è un puntatore al primo nodo della lista.

Ogni nodo contiene:

```c
int v;
IntList next;
```

quindi ogni nodo punta al nodo successivo.

Graficamente:

```text
ls
 |
 v
[13 | next] -> [6 | next] -> [4 | next] -> NULL
```

---

# 2. Schema generale di una funzione ricorsiva su lista

Ogni funzione ricorsiva su lista deve avere almeno due parti:

## Caso base

Di solito:

```c
if (L == NULL)
```

cioè la lista è vuota.

Questo significa:

```text
non ci sono più nodi da visitare
```

## Caso induttivo / ricorsivo

La lista non è vuota.

Quindi posso:

1. lavorare sul nodo corrente
2. richiamare la funzione sul resto della lista

Schema:

```c
void funzioneRicorsiva(IntList L) {
    if (L == NULL) {
        return;
    }

    // lavoro sul nodo corrente
    // L->v

    funzioneRicorsiva(L->next);
}
```

La cosa importante è questa:

```c
L->next
```

è a sua volta una lista.

Quindi se `L` è:

```text
13 -> 6 -> 4 -> NULL
```

allora `L->next` è:

```text
6 -> 4 -> NULL
```

---

# 3. Stampa ricorsiva di una lista

## Versione normale: stampa in ordine

```c
void printIntList(IntList L) {
    if (L == NULL) {
        return;
    }

    printf("%d ", L->v);

    printIntList(L->next);
}
```

Se la lista è:

```text
13 -> 6 -> 4 -> NULL
```

la stampa sarà:

```text
13 6 4
```

## Perché?

La funzione fa:

```text
printIntList([13, 6, 4])
    stampa 13
    printIntList([6, 4])
        stampa 6
        printIntList([4])
            stampa 4
            printIntList([])
                return
```

Quindi stampa mentre “scende” nella ricorsione.

---

# 4. Stampa in ordine inverso

Se invece metto la chiamata ricorsiva prima della `printf`, succede una cosa diversa:

```c
void printIntListReverse(IntList L) {
    if (L == NULL) {
        return;
    }

    printIntListReverse(L->next);

    printf("%d ", L->v);
}
```

Con lista:

```text
13 -> 6 -> 4 -> NULL
```

la stampa sarà:

```text
4 6 13
```

## Perché?

La funzione prima arriva fino alla fine:

```text
printIntListReverse([13, 6, 4])
    printIntListReverse([6, 4])
        printIntListReverse([4])
            printIntListReverse([])
                return
            stampa 4
        stampa 6
    stampa 13
```

Quindi stampa mentre “risale” dalla ricorsione.

---

# 5. Ricorsione in testa e ricorsione in coda

Questa distinzione è importantissima.

## Ricorsione in coda

Una funzione è ricorsiva in coda quando la chiamata ricorsiva è **l’ultima operazione** eseguita.

Esempio:

```c
void printIntList(IntList L) {
    if (L == NULL) {
        return;
    }

    printf("%d ", L->v);

    printIntList(L->next);
}
```

Dopo:

```c
printIntList(L->next);
```

non devo fare altro.

Quindi questa è ricorsione di coda.

---

## Ricorsione non di coda

Esempio:

```c
void printIntListReverse(IntList L) {
    if (L == NULL) {
        return;
    }

    printIntListReverse(L->next);

    printf("%d ", L->v);
}
```

Qui, dopo la chiamata ricorsiva, devo ancora fare:

```c
printf("%d ", L->v);
```

Quindi non è ricorsione di coda.

---

# 6. Somma degli elementi di una lista

Supponiamo di voler sommare tutti i valori contenuti in una lista.

Lista:

```text
13 -> 6 -> 4 -> NULL
```

Risultato:

```text
23
```

## Versione ricorsiva semplice

```c
int sumIntList(IntList L) {
    if (L == NULL) {
        return 0;
    }

    return L->v + sumIntList(L->next);
}
```

## Come ragionare

La somma di una lista vuota è:

```c
0
```

La somma di una lista non vuota è:

```text
valore corrente + somma del resto della lista
```

Quindi:

```text
sum([13, 6, 4])
= 13 + sum([6, 4])
= 13 + 6 + sum([4])
= 13 + 6 + 4 + sum([])
= 13 + 6 + 4 + 0
= 23
```

---

# 7. Complessità di `sumIntList`

```c
int sumIntList(IntList L) {
    if (L == NULL) {
        return 0;
    }

    return L->v + sumIntList(L->next);
}
```

## Tempo

Visito ogni nodo una volta.

Se la lista ha `N` nodi:

```text
O(N)
```

## Spazio

Ogni chiamata ricorsiva rimane nello stack finché non torna il risultato.

Quindi, senza ottimizzazioni:

```text
O(N)
```

Questa funzione **non è ricorsiva di coda**, perché dopo la chiamata ricorsiva devo ancora fare la somma:

```c
L->v + risultato_della_chiamata
```

---

# 8. Somma con accumulatore

Per rendere la funzione ricorsiva di coda, uso un accumulatore.

```c
int sumIntListTailRec(IntList L, int acc) {
    if (L == NULL) {
        return acc;
    }

    return sumIntListTailRec(L->next, acc + L->v);
}
```

Uso poi una funzione wrapper:

```c
int sumIntListV2(IntList L) {
    return sumIntListTailRec(L, 0);
}
```

## Perché serve il wrapper?

L’utente della funzione vuole semplicemente scrivere:

```c
sumIntListV2(ls);
```

Non dovrebbe preoccuparsi dell’accumulatore.

L’accumulatore è un dettaglio interno dell’implementazione.

---

# 9. Attenzione al refuso della slide

Nella versione con accumulatore, il caso base deve restituire l’accumulatore.

Quindi è corretto:

```c
if (L == NULL) {
    return acc;
}
```

Non avrebbe senso restituire una variabile `s` non definita.

---

# 10. Funzione `length`

La lunghezza di una lista è il numero dei nodi.

## Versione ricorsiva semplice

```c
size_t length(IntList L) {
    if (L == NULL) {
        return 0;
    }

    return 1 + length(L->next);
}
```

## Ragionamento

```text
length([])
= 0

length([13, 6, 4])
= 1 + length([6, 4])
= 1 + 1 + length([4])
= 1 + 1 + 1 + length([])
= 3
```

---

# 11. Funzione `count` con predicato

La funzione `count` conta quanti elementi soddisfano una certa condizione.

Per esempio:

```text
conta quanti valori sono pari
conta quanti valori sono maggiori di 10
conta quanti valori sono negativi
```

Serve un puntatore a funzione.

```c
typedef _Bool (*Predicate)(int e);
```

Esempio di predicato:

```c
_Bool isEven(int x) {
    return x % 2 == 0;
}
```

Funzione `count`:

```c
size_t count(IntList L, Predicate predicate) {
    if (L == NULL) {
        return 0;
    }

    if (predicate(L->v)) {
        return 1 + count(L->next, predicate);
    }

    return count(L->next, predicate);
}
```

Versione più compatta:

```c
size_t count(IntList L, Predicate predicate) {
    if (L == NULL) {
        return 0;
    }

    return predicate(L->v) + count(L->next, predicate);
}
```

Perché funziona?

In C, una `_Bool` vale:

```text
0 se falso
1 se vero
```

---

# 12. Rimozione di una lista linkata

Rimuovere una lista non significa solo “non usarla più”.

Significa liberare tutta la memoria allocata dinamicamente.

Se ho:

```text
13 -> 6 -> 4 -> 11 -> NULL
```

devo fare `free` di tutti i nodi.

---

# 13. Cancellazione ricorsiva della lista

Una strategia naturale è cancellare dalla coda verso la testa.

```c
IntList deleteList(IntList L) {
    if (L != NULL) {
        deleteList(L->next);
        free(L);
    }

    return NULL;
}
```

Uso:

```c
ls = deleteList(ls);
```

## Perché funziona?

Con lista:

```text
13 -> 6 -> 4 -> NULL
```

la funzione fa:

```text
deleteList(13)
    deleteList(6)
        deleteList(4)
            deleteList(NULL)
            free(4)
        free(6)
    free(13)
```

Dopo la cancellazione assegno:

```c
ls = NULL;
```

così evito un dangling pointer.

---

# 14. Dangling pointer

Un dangling pointer è un puntatore che contiene ancora un indirizzo di memoria che però è già stato liberato.

Esempio pericoloso:

```c
free(ls);
printf("%d", ls->v);   // ERRORE: memoria già liberata
```

Dopo una `free`, quando possibile, è buona pratica fare:

```c
ls = NULL;
```

Però attenzione: se passo un puntatore per valore a una funzione, la funzione non può modificare il puntatore originale del chiamante.

---

# 15. Perché serve passare la lista per riferimento

Se scrivo:

```c
void f(IntList L) {
    L = NULL;
}
```

e chiamo:

```c
f(ls);
```

il puntatore `ls` nel `main` non cambia.

Perché?

Perché `L` è una copia del puntatore.

Se voglio modificare davvero `ls`, devo passare il suo indirizzo:

```c
void f(IntList *Lptr) {
    *Lptr = NULL;
}
```

Chiamata:

```c
f(&ls);
```

---

# 16. Cancellazione lista con puntatore a puntatore

```c
void deleteListV2(IntList *Lptr) {
    if (Lptr == NULL) {
        return;
    }

    if (*Lptr == NULL) {
        return;
    }

    deleteListV2(&((*Lptr)->next));

    free(*Lptr);

    *Lptr = NULL;
}
```

## Punto fondamentale

`Lptr` è un puntatore alla variabile che contiene il puntatore al nodo corrente.

Quindi:

```c
*Lptr
```

è il nodo corrente.

Mentre:

```c
(*Lptr)->next
```

è il puntatore al nodo successivo.

E:

```c
&((*Lptr)->next)
```

è l’indirizzo del campo `next`.

Questa cosa è importantissima.

---

# 17. Capire `&((*Lptr)->next)`

Supponiamo:

```text
ls -> [13 | next] -> [6 | next] -> [4 | NULL]
```

Quando chiamo:

```c
deleteListV2(&ls);
```

passo l’indirizzo della variabile `ls`.

Poi, nella chiamata ricorsiva:

```c
deleteListV2(&((*Lptr)->next));
```

passo l’indirizzo del campo `next` del nodo corrente.

Quindi la funzione può modificare direttamente quel `next`.

È come dire:

```text
alla prossima chiamata, lavora sul puntatore che collega questo nodo al successivo
```

---

# 18. Inserimento in lista ordinata

Vogliamo implementare:

```c
_Bool insertInSortedIntList(IntList *ls, int v);
```

La funzione deve inserire `v` in una lista ordinata mantenendo l’ordine.

Esempio:

```text
4 -> 6 -> 13 -> NULL
```

Inserisco `8`:

```text
4 -> 6 -> 8 -> 13 -> NULL
```

---

# 19. Casi dell’inserimento ordinato

## Caso 1: parametro non valido

```c
if (ls == NULL) {
    return 0;
}
```

## Caso 2: lista vuota

Se:

```c
*ls == NULL
```

devo inserire qui.

## Caso 3: valore minore o uguale alla testa

Se:

```c
v <= (*ls)->v
```

devo inserire prima del nodo corrente.

## Caso 4: valore maggiore della testa

Devo inserire nel resto della lista:

```c
insertInSortedIntList(&((*ls)->next), v);
```

---

# 20. Implementazione corretta di `insertInSortedIntList`

```c
#include <stdlib.h>

_Bool insertInSortedIntList(IntList *ls, int v) {
    if (ls == NULL) {
        return 0;
    }

    if (*ls == NULL || v <= (*ls)->v) {
        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return 0;
        }

        newNode->v = v;
        newNode->next = *ls;
        *ls = newNode;

        return 1;
    }

    return insertInSortedIntList(&((*ls)->next), v);
}
```

## Perché `*ls = newNode`?

Perché `ls` è l’indirizzo del puntatore da modificare.

Se sto inserendo in testa, `ls` punta alla variabile `head`.

Se sto inserendo nel mezzo, `ls` punta al campo `next` del nodo precedente.

Quindi:

```c
*ls = newNode;
```

aggancia il nuovo nodo nel punto giusto.

---

# 21. Visualizzazione dell’inserimento ordinato

Lista iniziale:

```text
4 -> 6 -> 13 -> NULL
```

Inserisco `8`.

Chiamate:

```text
insertInSortedIntList(&ls, 8)
```

`8 > 4`, quindi vado avanti:

```c
insertInSortedIntList(&(4->next), 8)
```

Ora il nodo corrente è `6`.

`8 > 6`, quindi vado avanti:

```c
insertInSortedIntList(&(6->next), 8)
```

Ora il nodo corrente è `13`.

`8 <= 13`, quindi inserisco qui.

Prima:

```text
6 -> 13
```

Dopo:

```text
6 -> 8 -> 13
```

---

# 22. Cancellazione di un elemento da una lista

Vogliamo implementare:

```c
_Bool deleteFromIntList(IntList *ls, int v);
```

La funzione cancella la prima occorrenza di `v`.

Esempio:

```text
9 -> 6 -> 13 -> NULL
```

Cancello `6`:

```text
9 -> 13 -> NULL
```

---

# 23. Casi della cancellazione

## Caso base 1: parametro non valido o lista vuota

```c
if (ls == NULL || *ls == NULL) {
    return 0;
}
```

Vuol dire che l’elemento non è stato trovato.

## Caso base 2: il nodo corrente contiene il valore

```c
if ((*ls)->v == v)
```

Allora cancello il nodo corrente.

## Caso induttivo

Il nodo corrente non contiene il valore.

Allora provo a cancellare nel resto della lista:

```c
return deleteFromIntList(&((*ls)->next), v);
```

---

# 24. Implementazione corretta di `deleteFromIntList`

```c
#include <stdlib.h>

_Bool deleteFromIntList(IntList *ls, int v) {
    if (ls == NULL || *ls == NULL) {
        return 0;
    }

    if ((*ls)->v == v) {
        IntList tmp = *ls;
        *ls = (*ls)->next;
        free(tmp);
        return 1;
    }

    return deleteFromIntList(&((*ls)->next), v);
}
```

## Ordine delle operazioni

Questa parte è fondamentale:

```c
IntList tmp = *ls;
*ls = (*ls)->next;
free(tmp);
```

Prima salvo il nodo da cancellare:

```c
IntList tmp = *ls;
```

Poi scollego il nodo dalla lista:

```c
*ls = (*ls)->next;
```

Poi libero la memoria:

```c
free(tmp);
```

Non devo fare `free(*ls)` dopo aver già spostato `*ls`, perché a quel punto `*ls` punta al nodo successivo.

---

# 25. Inserimento prima di un nodo

Esercizio:

```c
_Bool insertBefore(IntList *lsPtr, int e, IntList positionPtr);
```

La funzione deve inserire `e` prima del nodo puntato da `positionPtr`.

Se:

```c
positionPtr == NULL
```

allora inserisce in coda.

---

## Implementazione

```c
_Bool insertBefore(IntList *lsPtr, int e, IntList positionPtr) {
    if (lsPtr == NULL) {
        return 0;
    }

    if (*lsPtr == positionPtr || (positionPtr == NULL && *lsPtr == NULL)) {
        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return 0;
        }

        newNode->v = e;
        newNode->next = *lsPtr;
        *lsPtr = newNode;

        return 1;
    }

    if (*lsPtr == NULL) {
        return 0;
    }

    return insertBefore(&((*lsPtr)->next), e, positionPtr);
}
```

## Cosa devi capire

Questa funzione cerca il punto in cui il puntatore corrente `*lsPtr` coincide con `positionPtr`.

Quando lo trova, inserisce il nuovo nodo “prima” modificando il puntatore che portava al nodo corrente.

Esempio:

```text
4 -> 6 -> 13 -> NULL
```

Voglio inserire `5` prima del nodo `6`.

Prima:

```text
4 -> 6
```

Dopo:

```text
4 -> 5 -> 6
```

---

# 26. Inserimento dopo un nodo

Esercizio:

```c
_Bool insertAfter(IntList *lsPtr, int e, IntList positionPtr);
```

La funzione deve inserire `e` dopo il nodo puntato da `positionPtr`.

Se:

```c
positionPtr == NULL
```

allora inserisce in testa.

---

## Implementazione

```c
_Bool insertAfter(IntList *lsPtr, int e, IntList positionPtr) {
    if (lsPtr == NULL) {
        return 0;
    }

    if (positionPtr == NULL) {
        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return 0;
        }

        newNode->v = e;
        newNode->next = *lsPtr;
        *lsPtr = newNode;

        return 1;
    }

    if (*lsPtr == NULL) {
        return 0;
    }

    if (*lsPtr == positionPtr) {
        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return 0;
        }

        newNode->v = e;
        newNode->next = positionPtr->next;
        positionPtr->next = newNode;

        return 1;
    }

    return insertAfter(&((*lsPtr)->next), e, positionPtr);
}
```

## Errore tipico

Se devo inserire dopo `positionPtr`, non devo fare:

```c
*lsPtr = newNode;
```

nel caso generale.

Perché?

Perché così sostituirei il puntatore al nodo corrente.

Se sono arrivato al nodo `positionPtr`, devo modificare il suo `next`:

```c
newNode->next = positionPtr->next;
positionPtr->next = newNode;
```

Ordine corretto:

```c
newNode->next = positionPtr->next;
positionPtr->next = newNode;
```

Se invertissi l’ordine, perderei il riferimento al resto della lista.

---

# 27. Cancellare un nodo dato il suo puntatore

Esercizio:

```c
_Bool deleteNode(IntList *ls, IntList positionPtr);
```

Cancella dalla lista il nodo puntato da `positionPtr`.

---

## Implementazione

```c
_Bool deleteNode(IntList *ls, IntList positionPtr) {
    if (ls == NULL || *ls == NULL || positionPtr == NULL) {
        return 0;
    }

    if (*ls == positionPtr) {
        IntList tmp = *ls;
        *ls = (*ls)->next;
        free(tmp);
        return 1;
    }

    return deleteNode(&((*ls)->next), positionPtr);
}
```

## Ragionamento

La funzione cerca il nodo da cancellare.

A ogni chiamata, `ls` rappresenta l’indirizzo del puntatore che punta al nodo corrente.

Quando trovo il nodo:

```c
*ls == positionPtr
```

faccio:

```c
tmp = *ls;
*ls = (*ls)->next;
free(tmp);
```

Così il nodo precedente viene collegato direttamente al nodo successivo.

---

# 28. Cancellare il nodo dopo un certo nodo

Esercizio:

```c
_Bool deleteAfter(IntList *ls, IntList positionPtr);
```

Se:

```c
positionPtr == NULL
```

cancella il nodo in testa.

Altrimenti cancella il nodo dopo `positionPtr`.

---

## Implementazione

```c
_Bool deleteAfter(IntList *ls, IntList positionPtr) {
    if (ls == NULL || *ls == NULL) {
        return 0;
    }

    if (positionPtr == NULL) {
        IntList tmp = *ls;
        *ls = (*ls)->next;
        free(tmp);
        return 1;
    }

    if (*ls == positionPtr) {
        if ((*ls)->next == NULL) {
            return 0;
        }

        IntList tmp = (*ls)->next;
        (*ls)->next = tmp->next;
        free(tmp);

        return 1;
    }

    return deleteAfter(&((*ls)->next), positionPtr);
}
```

## Caso importante

Se `positionPtr` è l’ultimo nodo:

```text
4 -> 6 -> 13 -> NULL
          ^
          positionPtr
```

non c’è nessun nodo dopo da cancellare.

Quindi la funzione deve restituire:

```c
0
```

---

# 29. Codice completo da riscrivere per esercitarsi

Questo è un file completo che puoi copiare in CLion o VS Code e riscrivere a mano.

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct int_list_node {
    int v;
    struct int_list_node *next;
} IntListNode;

typedef IntListNode *IntList;

typedef _Bool (*Predicate)(int e);

_Bool isEven(int x) {
    return x % 2 == 0;
}

void printIntList(IntList L) {
    if (L == NULL) {
        return;
    }

    printf("%d ", L->v);
    printIntList(L->next);
}

void printIntListReverse(IntList L) {
    if (L == NULL) {
        return;
    }

    printIntListReverse(L->next);
    printf("%d ", L->v);
}

size_t length(IntList L) {
    if (L == NULL) {
        return 0;
    }

    return 1 + length(L->next);
}

size_t count(IntList L, Predicate predicate) {
    if (L == NULL) {
        return 0;
    }

    return predicate(L->v) + count(L->next, predicate);
}

int sumIntList(IntList L) {
    if (L == NULL) {
        return 0;
    }

    return L->v + sumIntList(L->next);
}

int sumIntListTailRec(IntList L, int acc) {
    if (L == NULL) {
        return acc;
    }

    return sumIntListTailRec(L->next, acc + L->v);
}

int sumIntListV2(IntList L) {
    return sumIntListTailRec(L, 0);
}

_Bool insertInSortedIntList(IntList *ls, int v) {
    if (ls == NULL) {
        return 0;
    }

    if (*ls == NULL || v <= (*ls)->v) {
        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            return 0;
        }

        newNode->v = v;
        newNode->next = *ls;
        *ls = newNode;

        return 1;
    }

    return insertInSortedIntList(&((*ls)->next), v);
}

_Bool deleteFromIntList(IntList *ls, int v) {
    if (ls == NULL || *ls == NULL) {
        return 0;
    }

    if ((*ls)->v == v) {
        IntList tmp = *ls;
        *ls = (*ls)->next;
        free(tmp);
        return 1;
    }

    return deleteFromIntList(&((*ls)->next), v);
}

void deleteListV2(IntList *Lptr) {
    if (Lptr == NULL) {
        return;
    }

    if (*Lptr == NULL) {
        return;
    }

    deleteListV2(&((*Lptr)->next));

    free(*Lptr);

    *Lptr = NULL;
}

int main(void) {
    IntList ls = NULL;

    insertInSortedIntList(&ls, 13);
    insertInSortedIntList(&ls, 4);
    insertInSortedIntList(&ls, 6);
    insertInSortedIntList(&ls, 8);

    printf("Lista: ");
    printIntList(ls);
    printf("\n");

    printf("Lista inversa: ");
    printIntListReverse(ls);
    printf("\n");

    printf("Length: %zu\n", length(ls));
    printf("Somma: %d\n", sumIntList(ls));
    printf("Somma V2: %d\n", sumIntListV2(ls));
    printf("Pari: %zu\n", count(ls, isEven));

    deleteFromIntList(&ls, 6);

    printf("Dopo cancellazione di 6: ");
    printIntList(ls);
    printf("\n");

    deleteListV2(&ls);

    if (ls == NULL) {
        printf("Lista cancellata correttamente.\n");
    }

    return 0;
}
```

---

# 30. Esercizi da fare per prendere confidenza

## Esercizio 1

Riscrivi da zero:

```c
void printIntList(IntList L);
```

Poi modifica la funzione per stampare la lista al contrario.

---

## Esercizio 2

Implementa:

```c
size_t length(IntList L);
```

Obiettivo: saper riconoscere il caso base:

```c
L == NULL
```

e il caso ricorsivo:

```c
1 + length(L->next)
```

---

## Esercizio 3

Implementa:

```c
int sumIntList(IntList L);
```

Poi implementa la versione con accumulatore:

```c
int sumIntListTailRec(IntList L, int acc);
```

e la wrapper:

```c
int sumIntListV2(IntList L);
```

---

## Esercizio 4

Implementa:

```c
_Bool contains(IntList L, int value);
```

Soluzione:

```c
_Bool contains(IntList L, int value) {
    if (L == NULL) {
        return 0;
    }

    if (L->v == value) {
        return 1;
    }

    return contains(L->next, value);
}
```

---

## Esercizio 5

Implementa:

```c
_Bool insertInSortedIntList(IntList *ls, int value);
```

Questo è uno degli esercizi più importanti perché ti costringe a capire bene:

```c
IntList *ls
```

e:

```c
&((*ls)->next)
```

---

## Esercizio 6

Implementa:

```c
_Bool deleteFromIntList(IntList *ls, int value);
```

Questo esercizio è essenziale per capire:

```c
tmp = *ls;
*ls = (*ls)->next;
free(tmp);
```

---

# 31. Errori tipici da evitare

## Errore 1: dimenticare il caso base

Sbagliato:

```c
void printIntList(IntList L) {
    printf("%d ", L->v);
    printIntList(L->next);
}
```

Se `L == NULL`, il programma prova a fare:

```c
L->v
```

e va in errore.

Corretto:

```c
if (L == NULL) {
    return;
}
```

---

## Errore 2: confondere `L` con `L->next`

`L` è il nodo corrente.

`L->next` è il resto della lista.

---

## Errore 3: passare la lista per valore quando bisogna modificarla

Se devo modificare la testa della lista, non basta:

```c
void insert(IntList L);
```

Serve:

```c
void insert(IntList *Lptr);
```

Perché devo poter modificare il puntatore originale.

---

## Errore 4: dimenticare la doppia verifica

Quando hai un puntatore a puntatore:

```c
IntList *Lptr
```

devi spesso controllare:

```c
if (Lptr == NULL)
```

e poi:

```c
if (*Lptr == NULL)
```

Sono due cose diverse.

`Lptr == NULL` significa:

```text
non ho neanche l’indirizzo del puntatore
```

`*Lptr == NULL` significa:

```text
ho il puntatore, ma la lista è vuota
```

---

## Errore 5: perdere il resto della lista durante un inserimento

Sbagliato:

```c
positionPtr->next = newNode;
newNode->next = positionPtr->next;
```

Perché dopo la prima riga hai già perso il vecchio `positionPtr->next`.

Corretto:

```c
newNode->next = positionPtr->next;
positionPtr->next = newNode;
```

Prima collego il nuovo nodo al resto della lista, poi collego il nodo precedente al nuovo nodo.

---

## Errore 6: fare `free` prima di salvare il collegamento

Sbagliato:

```c
free(*ls);
*ls = (*ls)->next;
```

Dopo `free(*ls)`, non posso più accedere a:

```c
(*ls)->next
```

Corretto:

```c
IntList tmp = *ls;
*ls = (*ls)->next;
free(tmp);
```

---

## Errore 7: non mettere il puntatore a `NULL` dopo la cancellazione

Se libero tutta la lista ma lascio:

```c
ls
```

con il vecchio indirizzo, rischio un dangling pointer.

Meglio:

```c
deleteListV2(&ls);
```

così alla fine:

```c
ls == NULL
```

---

# 32. Mini-schema mentale da esame

Quando vedi una funzione ricorsiva su lista chiediti sempre:

## 1. Qual è il caso base?

Di solito:

```c
L == NULL
```

oppure:

```c
*Lptr == NULL
```

---

## 2. Cosa devo fare sul nodo corrente?

Esempi:

```c
printf("%d", L->v);
```

```c
somma += L->v;
```

```c
if (L->v == value)
```

---

## 3. Su cosa faccio la chiamata ricorsiva?

Se la lista è passata per valore:

```c
funzione(L->next);
```

Se la lista è passata per riferimento:

```c
funzione(&((*Lptr)->next));
```

---

## 4. Sto modificando la lista?

Se no, può bastare:

```c
IntList L
```

Esempi:

```c
print
length
sum
contains
count
```

Se sì, probabilmente serve:

```c
IntList *Lptr
```

Esempi:

```c
insert
delete
deleteListV2
insertInSorted
```

---

# 33. Frase da ricordare

Una lista linkata è ricorsiva perché ogni nodo contiene il resto della lista.

Quindi quasi ogni operazione può essere pensata così:

```text
caso base: lista vuota
caso ricorsivo: lavoro sulla testa + richiamo sulla coda
```

Oppure:

```text
funzione(lista) = qualcosa_sulla_testa + funzione(resto_della_lista)
```

---

# 34. Cosa devi saper fare bene per il 30 e lode

Per padroneggiare questa parte devi saper fare senza esitazione:

1. riconoscere il caso base;
2. distinguere ricorsione in coda e non in coda;
3. spiegare perché una lista è una struttura ricorsiva;
4. usare correttamente `L->next`;
5. usare correttamente `&((*Lptr)->next)`;
6. inserire un nodo senza perdere il resto della lista;
7. cancellare un nodo senza creare dangling pointer;
8. spiegare perché serve `IntList *` quando modifico la testa;
9. scrivere `insertInSortedIntList`;
10. scrivere `deleteFromIntList`;
11. spiegare la complessità `O(N)`;
12. riconoscere quando una funzione usa spazio `O(N)` sullo stack;
13. usare un accumulatore per trasformare una funzione in ricorsiva di coda.

---

# 35. Riassunto finale super compatto

Una lista linkata è definita ricorsivamente:

```text
lista = NULL oppure nodo + lista
```

Per questo le operazioni ricorsive seguono quasi sempre questo schema:

```c
if (L == NULL) {
    // caso base
}

//
// lavoro sul nodo corrente
//

return funzione(L->next);
```

Se la funzione deve modificare la lista, uso un puntatore a puntatore:

```c
IntList *ls
```

e per andare avanti passo:

```c
&((*ls)->next)
```

Questo permette alla funzione ricorsiva di modificare direttamente il puntatore che collega un nodo al successivo.

La cosa più importante da capire è che `IntList *ls` non punta direttamente a un nodo: punta a una variabile o a un campo `next` che contiene l’indirizzo di un nodo.

Questa è la chiave per capire inserimenti e cancellazioni ricorsive.
