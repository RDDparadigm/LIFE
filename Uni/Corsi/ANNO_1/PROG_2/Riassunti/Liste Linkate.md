---
titolo: "Liste linkate o concatenate in C"
corso: "Programmazione II"
tags:
  - programmazione-2
  - c
  - liste-linkate
  - puntatori
  - malloc
  - const
---

# Liste linkate o concatenate in C

> [!success] Obiettivo da 30 e lode
> Non basta ricordare il codice a memoria. Devi saper spiegare **perché** una lista è rappresentata da un puntatore, perché certe funzioni ricevono un `List *`, perché l'ordine degli assegnamenti sui puntatori è decisivo, e perché ogni nodo allocato con `malloc` deve prima o poi essere liberato con `free`.

Questa lezione collega tre idee fondamentali:

1. **Principio del privilegio minimo**: dare a una funzione solo i permessi di cui ha bisogno.
2. **Struct autoreferenziali**: `struct` che contengono un puntatore a un'altra `struct` dello stesso tipo.
3. **Liste linkate**: strutture dati dinamiche composte da nodi collegati tramite puntatori.

---

# 1. Principio del privilegio minimo

Il **principio del privilegio minimo** dice che un pezzo di codice deve avere solo i privilegi necessari per svolgere il proprio compito, non di più.

In C questo principio si vede molto bene con il qualificatore `const`.

## Perché `const` è importante?

`const` comunica al compilatore e a chi legge il codice che una certa cosa **non deve essere modificata**.

Serve a:

- evitare modifiche accidentali;
- ridurre bug difficili da trovare;
- documentare meglio l'intenzione della funzione;
- rispettare il principio del privilegio minimo.

Esempio:

```c
void printArray(const int *arr, size_t n);
```

Questa funzione riceve un array di interi, ma dichiara esplicitamente che **non modificherà gli elementi**.

Se dentro la funzione scrivessi:

```c
arr[0] = 10;
```

il compilatore segnalerebbe errore.

---

# 2. I quattro casi principali di `const` con i puntatori

Quando ci sono i puntatori, `const` può riferirsi al **dato puntato**, al **puntatore stesso**, o a entrambi.

| Dichiarazione | Posso cambiare il dato? | Posso cambiare il puntatore? | Significato |
|---|---:|---:|---|
| `char *p` | sì | sì | puntatore modificabile a dato modificabile |
| `const char *p` | no | sì | puntatore modificabile a dato costante |
| `char *const p` | sì | no | puntatore costante a dato modificabile |
| `const char *const p` | no | no | puntatore costante a dato costante |

## 2.1 `char *p`

```c
char s[] = "ciao";
char *p = s;

p[0] = 'C';  // OK: modifico il dato
p++;         // OK: modifico il puntatore
```

Qui posso modificare sia il contenuto sia il puntatore.

---

## 2.2 `const char *p`

```c
char s[] = "ciao";
const char *p = s;

// p[0] = 'C';  // ERRORE: il dato puntato è considerato costante
p++;            // OK: posso spostare il puntatore
```

Qui il puntatore può cambiare, ma non posso modificare il dato attraverso quel puntatore.

> [!important] Da sapere bene
> `const char *p` si legge spesso come: "p è un puntatore a carattere costante".
> Il dato non si tocca, ma il puntatore può essere spostato.

---

## 2.3 `char *const p`

```c
char s[] = "ciao";
char *const p = s;

p[0] = 'C';  // OK: posso modificare il dato
// p++;      // ERRORE: il puntatore è costante
```

Qui il puntatore non può essere cambiato: punta sempre alla stessa posizione.

---

## 2.4 `const char *const p`

```c
char s[] = "ciao";
const char *const p = s;

// p[0] = 'C';  // ERRORE
// p++;         // ERRORE
```

Qui non posso modificare né il dato né il puntatore.

---

# 3. Struct autoreferenziali

Una **struct autoreferenziale** è una `struct` che contiene un membro puntatore a una struttura dello stesso tipo.

Esempio classico:

```c
struct node {
    int data;
    struct node *nextPtr;
};
```

Il campo `data` contiene il valore del nodo.
Il campo `nextPtr` contiene l'indirizzo del nodo successivo.

Graficamente:

```text
+------+---------+      +------+---------+
|  15  |   ----  | ---> |  45  |  NULL   |
+------+---------+      +------+---------+
 data    nextPtr          data   nextPtr
```

Il valore `NULL` indica che non c'è un nodo successivo.

> [!warning] Attenzione
> Una `struct node` non può contenere direttamente un'altra `struct node` come campo, perché avrebbe dimensione infinita.
>
> Questo NON va bene:
>
> ```c
> struct node {
>     int data;
>     struct node next; // SBAGLIATO
> };
> ```
>
> Questo invece va bene:
>
> ```c
> struct node {
>     int data;
>     struct node *next; // OK
> };
> ```
>
> Il puntatore ha dimensione fissa, quindi la `struct` ha dimensione finita.

---

# 4. Che cos'è una lista linkata

Una **lista linkata** è una ==collezione lineare di nodi collegati tramite puntatori==

Ogni nodo contiene:

1. uno o più dati;
2. un puntatore al nodo successivo.

Esempio:

```text
ls
 |
 v
+------+------+
|  12  |  o---|---->
+------+------+
              +------+------+
              |  7   |  o---|---->
              +------+------+
                            +------+------+
                            |  11  | NULL |
                            +------+------+
```

In forma compatta:

```text
[12, 7, 11]
```

La lista vuota si rappresenta così:

```c
NULL
```

oppure, graficamente:

```text
[]
```

---

# 5. Definizione astratta di lista

Una lista di elementi di tipo `T` è:

- la lista vuota;
- oppure una coppia `<e, tl>`, dove:
  - `e` è il primo elemento, detto **testa** o **head**;
  - `tl` è il resto della lista, detto **coda** o **tail**.

Esempio:

```text
[10, 20, 30]
```

può essere vista come:

```text
<10, <20, <30, []>>>
```

Questa visione è importante perché ogni nodo contiene un dato e il riferimento alla lista successiva.

---

# 6. Implementazione concreta in C

## Versione senza `typedef`

```c
struct listNode {
    int data;
    struct listNode *next;
};
```

Una lista sarà rappresentata da un puntatore al primo nodo:

```c
struct listNode *ls;
```

Se `ls == NULL`, la lista è vuota.

Se `ls != NULL`, `ls` punta al primo nodo.

---

## Versione con `typedef`

Una versione comoda può essere:

```c
typedef struct listNode {
    int data;
    struct listNode *next;
} ListNode;

typedef ListNode *List;
```

A questo punto:

```c
List ls = NULL;
```

significa:

```c
ListNode *ls = NULL;
```

> [!important] Cosa devi capire davvero
> `List` non è un nodo.  
> `List` è un **puntatore a nodo**.  
> Quindi una variabile di tipo `List` rappresenta la lista perché punta alla sua testa.

---

# 7. Perché la testa della lista è un puntatore?

Potresti chiederti: perché scrivere così?

```c
struct listNode *ls;
```

invece di così?

```c
struct listNode ls;
```

I motivi principali sono due.

## 7.1 Rappresentare la lista vuota

Con un puntatore posso scrivere:

```c
List ls = NULL;
```

Questo rappresenta naturalmente una lista vuota.

Con una `struct` diretta, invece, avrei sempre almeno un nodo, anche quando la lista dovrebbe essere vuota.

---

## 7.2 Evitare spreco di memoria

Se i nodi sono grandi, dichiarare sempre un nodo anche per una lista vuota spreca spazio.

Con un puntatore, invece, alloco nodi solo quando servono.

---

# 8. Stack, heap, `malloc` e nodi

Esempio:

```c
#include <stdio.h>
#include <stdlib.h>

struct listIntNode {
    int data;
    struct listIntNode *next;
};

int main(void) {
    struct listIntNode *ls;

    ls = malloc(sizeof(struct listIntNode));
    ls->data = 12;

    ls->next = malloc(sizeof(struct listIntNode));
    ls->next->data = 7;

    ls->next->next = malloc(sizeof(struct listIntNode));
    ls->next->next->data = 11;

    ls->next->next->next = NULL;

    return 0;
}
```

Qui:

- la variabile `ls` sta sullo **stack**;
- i nodi creati con `malloc` stanno nello **heap**;
- `ls` contiene l'indirizzo del primo nodo;
- ogni nodo punta al successivo;
- l'ultimo nodo ha `next == NULL`.

> [!warning] Questo esempio è didattico ma incompleto
> Mancano i controlli su `malloc` e manca la `free`. In codice serio bisogna sempre controllare se `malloc` ha restituito `NULL` e bisogna liberare la memoria allocata.

Versione più corretta:

```c
#include <stdio.h>
#include <stdlib.h>

struct listIntNode {
    int data;
    struct listIntNode *next;
};

int main(void) {
    struct listIntNode *ls = malloc(sizeof *ls);
    if (ls == NULL) {
        return 1;
    }
    ls->data = 12;

    ls->next = malloc(sizeof *ls->next);
    if (ls->next == NULL) {
        free(ls);
        return 1;
    }
    ls->next->data = 7;

    ls->next->next = malloc(sizeof *ls->next->next);
    if (ls->next->next == NULL) {
        free(ls->next);
        free(ls);
        return 1;
    }
    ls->next->next->data = 11;
    ls->next->next->next = NULL;

    free(ls->next->next);
    free(ls->next);
    free(ls);

    return 0;
}
```

---

# 9. Il ruolo fondamentale di `NULL`

`NULL` indica la fine della lista.

```text
[12, 7, 11]

12 -> 7 -> 11 -> NULL
```

Se dimentichi di impostare `next` a `NULL`, il campo `next` contiene bit casuali.

Il programma potrebbe interpretare quei bit come un indirizzo valido e tentare di accedere a memoria non allocata.

Risultato tipico:

```text
Segmentation fault
```

> [!danger] Regola d'oro
> Ogni volta che crei un nuovo nodo, inizializza subito `next`.
>
> ```c
> newNode->next = NULL;
> ```

---

# 10. Dangling pointer

Un **dangling pointer** è un puntatore che non punta più a un oggetto valido.

Esempio:

```c
int *p = malloc(sizeof *p);
*p = 42;

free(p);

printf("%d\n", *p); // ERRORE: p è dangling
```

Dopo `free(p)`, il puntatore `p` contiene ancora un indirizzo, ma quell'indirizzo non è più utilizzabile dal programma.

Buona pratica:

```c
free(p);
p = NULL;
```

---

# 11. Nodo mono-dato e nodo multi-dato

Un nodo può contenere un solo dato:

```c
struct listIntNode {
    int data;
    struct listIntNode *next;
};
```

oppure più dati:

```c
struct studentNode {
    int matricola;
    char nome[50];
    double media;
    struct studentNode *next;
};
```

La logica della lista non cambia: cambia solo la parte dati del nodo.

---

# 12. Liste ordinate, non ordinate e duplicati

Una lista linkata può essere:

## Non ordinata

```text
[13, 4, 9, 6]
```

Gli elementi sono inseriti senza una proprietà d'ordine.

## Ordinata

```text
[4, 6, 13, 13]
```

Gli elementi rispettano una proprietà, per esempio ordine crescente.

## Con duplicati

```text
[4, 4, 6, 6]
```

Una lista può contenere più volte lo stesso valore.

> [!important] Nota da esame
> Se una lista è ordinata, ogni operazione di inserimento o cancellazione deve preservare l'ordinamento, quando necessario.

---

# 13. Array vs lista linkata

| Aspetto | Array | Lista linkata |
|---|---|---|
| Dimensione | spesso fissa | dinamica |
| Accesso a un elemento | diretto con indice, `O(1)` | sequenziale, `O(n)` |
| Inserimento in mezzo | costoso, bisogna spostare elementi | più semplice se ho già il punto di inserimento |
| Cancellazione in mezzo | costosa, bisogna spostare elementi | più semplice se ho già il predecessore |
| Memoria | contigua | nodi non necessariamente contigui |
| Overhead | nessun puntatore extra per elemento | ogni nodo contiene almeno un puntatore extra |
| Cache locality | buona | peggiore, perché i nodi possono essere sparsi in memoria |

> [!tip] Frase da esame
> Gli array permettono accesso diretto tramite indice, mentre le liste linkate richiedono una visita sequenziale. Le liste linkate però permettono crescita dinamica e inserimenti/cancellazioni efficienti quando si conosce la posizione corretta o il predecessore.

---

# 14. Operazioni principali sulle liste

Le operazioni viste sono:

1. **visita** della lista;
2. **inserimento** di un nodo;
3. **cancellazione** di un nodo.

Durante una visita posso:

- stampare gli elementi;
- contare i nodi;
- sommare i valori;
- contare gli elementi che soddisfano una proprietà;
- cercare un valore.

Durante un inserimento posso inserire:

- in testa;
- in coda;
- prima di un nodo;
- dopo un nodo;
- nella posizione giusta di una lista ordinata.

Durante una cancellazione posso eliminare:

- la prima occorrenza di un valore;
- un nodo specifico;
- il nodo dopo un nodo dato;
- il nodo di testa.

---

# 15. Pattern generale di visita

La visita di una lista segue sempre questo schema:

```c
for (List currentPtr = ls;
     currentPtr != NULL;
     currentPtr = currentPtr->next) {
    // usa currentPtr->data
}
```

Significato:

- `currentPtr` parte dalla testa;
- finché non è `NULL`, siamo su un nodo valido;
- a ogni iterazione ci spostiamo al nodo successivo.

Complessità:

```text
Tempo:  O(n)
Spazio: O(1)
```

Perché?

- Tempo `O(n)`: devo visitare tutti gli `n` nodi.
- Spazio `O(1)`: uso solo poche variabili ausiliarie.

---

# 16. Esempio completo: lista di caratteri

Useremo questa definizione:

```c
typedef struct charListNode {
    char data;
    struct charListNode *next;
} CharListNode;

typedef CharListNode *CharList;
```

Quindi:

```c
CharList ls = NULL;
```

significa che `ls` è un puntatore al primo nodo della lista.

---

# 17. Stampa della lista

```c
#include <stdio.h>

void printCharList(CharList ls) {
    for (CharList currentPtr = ls;
         currentPtr != NULL;
         currentPtr = currentPtr->next) {
        printf("%c\n", currentPtr->data);
    }
}
```

Questa funzione non modifica la lista.

Una versione ancora più rispettosa del privilegio minimo è:

```c
void printCharListConst(const CharListNode *ls) {
    for (const CharListNode *currentPtr = ls;
         currentPtr != NULL;
         currentPtr = currentPtr->next) {
        printf("%c\n", currentPtr->data);
    }
}
```

Qui `const CharListNode *` significa: posso scorrere la lista, ma non posso modificare i nodi.

> [!warning] Trappola con `typedef`
> Se hai scritto:
>
> ```c
> typedef CharListNode *CharList;
> ```
>
> allora:
>
> ```c
> const CharList ls;
> ```
>
> significa "puntatore costante a nodo modificabile", non "puntatore a nodo costante".
>
> Per indicare un puntatore a nodo costante è più chiaro scrivere:
>
> ```c
> const CharListNode *ls
> ```

---

# 18. Lunghezza della lista

```c
#include <stddef.h>

size_t length(CharList ls) {
    size_t count = 0;

    for (CharList currentPtr = ls;
         currentPtr != NULL;
         currentPtr = currentPtr->next) {
        count++;
    }

    return count;
}
```

`size_t` è il tipo corretto per rappresentare dimensioni e quantità di elementi.

---

# 19. Somma degli elementi di una lista di interi

Definizione:

```c
typedef struct intListNode {
    int data;
    struct intListNode *next;
} IntListNode;

typedef IntListNode *IntList;
```

Funzione:

```c
int sumIntList(IntList ls) {
    int sum = 0;

    for (IntList currentPtr = ls;
         currentPtr != NULL;
         currentPtr = currentPtr->next) {
        sum += currentPtr->data;
    }

    return sum;
}
```

Esempio:

```text
[13, 6, 4, 11]
```

Risultato:

```text
34
```

---

# 20. Count con puntatore a funzione

Una funzione può ricevere un'altra funzione come parametro.

Esempio: contare quanti caratteri soddisfano un predicato.

```c
#include <stddef.h>

size_t countIf(CharList ls, int (*predicate)(char e)) {
    size_t count = 0;

    for (CharList currentPtr = ls;
         currentPtr != NULL;
         currentPtr = currentPtr->next) {
        if (predicate(currentPtr->data)) {
            count++;
        }
    }

    return count;
}
```

Esempio di predicato:

```c
int isUppercase(char c) {
    return c >= 'A' && c <= 'Z';
}
```

Uso:

```c
size_t uppercaseCount = countIf(ls, isUppercase);
```

> [!important] Come leggere `int (*predicate)(char e)`
> `predicate` è un puntatore a una funzione che prende un `char` e restituisce un `int`.

---

# 21. Perché le funzioni di inserimento ricevono `List *lsPtr`?

Questa è una delle cose più importanti.

Se una funzione deve modificare la testa della lista, deve poter modificare la variabile che contiene l'indirizzo del primo nodo.

Esempio:

```c
_Bool insertInHead(CharList *lsPtr, char value);
```

Qui:

- `CharList` è già un puntatore a nodo;
- `CharList *` è quindi un puntatore al puntatore di testa.

In altre parole:

```c
CharList ls;
```

è il puntatore alla testa.

```c
CharList *lsPtr;
```

è l'indirizzo della variabile `ls`.

Serve perché dentro la funzione potrei dover fare:

```c
*lsPtr = newPtr;
```

cioè aggiornare la testa della lista.

---

# 22. Inserimento in testa

```c
#include <stdlib.h>

_Bool insertInHead(CharList *lsPtr, char value) {
    CharList newPtr = malloc(sizeof *newPtr);
    if (newPtr == NULL) {
        return 0;
    }

    newPtr->data = value;
    newPtr->next = *lsPtr;
    *lsPtr = newPtr;

    return 1;
}
```

Supponiamo di avere:

```text
ls -> A -> B -> NULL
```

Dopo aver inserito `C` in testa:

```text
ls -> C -> A -> B -> NULL
```

---

# 23. L'ordine degli assegnamenti è fondamentale

Corretto:

```c
newPtr->next = *lsPtr;
*lsPtr = newPtr;
```

Prima collego il nuovo nodo alla vecchia testa.
Poi aggiorno la testa.

Sbagliato:

```c
*lsPtr = newPtr;
newPtr->next = *lsPtr;
```

In questo caso, dopo il primo assegnamento, `*lsPtr` punta già a `newPtr`.
Quindi la seconda riga fa puntare `newPtr->next` a `newPtr` stesso.

Risultato:

```text
C -> C -> C -> ...
```

cioè una lista ciclica involontaria.

> [!danger] Regola da ricordare
> Prima salva i collegamenti che rischi di perdere, poi modifica i puntatori principali.

---

# 24. Inserimento in lista ordinata

Obiettivo: inserire un carattere nella posizione corretta mantenendo la lista ordinata.

Esempio:

```text
[A, B, D, E]
```

Inserisco `C`:

```text
[A, B, C, D, E]
```

Codice:

```c
#include <stdlib.h>

_Bool insertInSortedCharList(CharList *lsPtr, char value) {
    if (lsPtr == NULL) {
        return 0;
    }

    CharList newPtr = malloc(sizeof *newPtr);
    if (newPtr == NULL) {
        return 0;
    }

    newPtr->data = value;
    newPtr->next = NULL;

    CharList previousPtr = NULL;
    CharList currentPtr = *lsPtr;

    while (currentPtr != NULL && value > currentPtr->data) {
        previousPtr = currentPtr;
        currentPtr = currentPtr->next;
    }

    newPtr->next = currentPtr;

    if (previousPtr == NULL) {
        *lsPtr = newPtr;
    } else {
        previousPtr->next = newPtr;
    }

    return 1;
}
```

## Come funziona la ricerca della posizione?

```c
while (currentPtr != NULL && value > currentPtr->data) {
    previousPtr = currentPtr;
    currentPtr = currentPtr->next;
}
```

Manteniamo due puntatori:

- `previousPtr`: nodo precedente;
- `currentPtr`: nodo corrente.

Ci fermiamo quando:

1. arriviamo alla fine (`currentPtr == NULL`);
2. troviamo un nodo con valore maggiore o uguale a `value`.

Poi inseriamo il nuovo nodo tra `previousPtr` e `currentPtr`.

---

# 25. Inserimento prima di un nodo dato

Firma:

```c
_Bool insertBefore(CharList *lsPtr, char value, CharList positionPtr);
```

Significato:

- inserisce `value` prima del nodo puntato da `positionPtr`;
- se `positionPtr == NULL`, inserisce in coda;
- se `positionPtr` non appartiene alla lista, l'operazione fallisce.

Codice:

```c
#include <stdlib.h>

_Bool insertBefore(CharList *lsPtr, char value, CharList positionPtr) {
    if (lsPtr == NULL) {
        return 0;
    }

    CharList previousPtr = NULL;
    CharList currentPtr = *lsPtr;

    while (currentPtr != NULL && currentPtr != positionPtr) {
        previousPtr = currentPtr;
        currentPtr = currentPtr->next;
    }

    if (currentPtr != positionPtr) {
        return 0;
    }

    CharList newPtr = malloc(sizeof *newPtr);
    if (newPtr == NULL) {
        return 0;
    }

    newPtr->data = value;
    newPtr->next = currentPtr;

    if (previousPtr == NULL) {
        *lsPtr = newPtr;
    } else {
        previousPtr->next = newPtr;
    }

    return 1;
}
```

## Caso particolare: inserimento in coda

Se `positionPtr == NULL`, il ciclo arriva fino alla fine della lista.
Alla fine `currentPtr == NULL`, quindi il nuovo nodo viene collegato dopo l'ultimo nodo.

---

# 26. Inserimento dopo un nodo dato

Firma:

```c
_Bool insertAfter(CharList *lsPtr, char value, CharList positionPtr);
```

Significato:

- inserisce `value` dopo il nodo puntato da `positionPtr`;
- se `positionPtr == NULL`, inserisce in testa.

Codice semplice:

```c
#include <stdlib.h>

_Bool insertAfter(CharList *lsPtr, char value, CharList positionPtr) {
    if (lsPtr == NULL) {
        return 0;
    }

    CharList newPtr = malloc(sizeof *newPtr);
    if (newPtr == NULL) {
        return 0;
    }

    newPtr->data = value;

    if (positionPtr != NULL) {
        newPtr->next = positionPtr->next;
        positionPtr->next = newPtr;
    } else {
        newPtr->next = *lsPtr;
        *lsPtr = newPtr;
    }

    return 1;
}
```

> [!warning] Nota sulla robustezza
> Questa versione assume che `positionPtr`, se diverso da `NULL`, sia davvero un nodo della lista. Se vuoi una funzione più difensiva, devi prima verificare che `positionPtr` appartenga alla lista.

---

# 27. Cancellazione della prima occorrenza

Obiettivo: eliminare la prima occorrenza di un valore.

Esempio:

```text
[A, B, C, D, E]
```

Cancello `C`:

```text
[A, B, D, E]
```

Codice:

```c
#include <stdlib.h>

_Bool deleteFromCharList(CharList *lsPtr, char value) {
    if (lsPtr == NULL) {
        return 0;
    }

    CharList previousPtr = NULL;
    CharList currentPtr = *lsPtr;

    while (currentPtr != NULL && currentPtr->data != value) {
        previousPtr = currentPtr;
        currentPtr = currentPtr->next;
    }

    if (currentPtr == NULL) {
        return 0;
    }

    if (previousPtr == NULL) {
        *lsPtr = currentPtr->next;
    } else {
        previousPtr->next = currentPtr->next;
    }

    free(currentPtr);
    return 1;
}
```

## I tre passi della cancellazione

1. Cerco il nodo da cancellare.
2. Scollego il nodo dalla lista.
3. Libero la memoria con `free`.

> [!danger] Errore grave
> Non fare `free(currentPtr)` prima di aver sistemato i collegamenti.
>
> Prima devi salvare o collegare `currentPtr->next`, poi puoi liberare `currentPtr`.

---

# 28. Cancellazione di un nodo dato

Esercizio delle slide: implementare una funzione che cancella il nodo puntato da `positionPtr`.

Firma:

```c
_Bool deleteNode(CharList *lsPtr, CharList positionPtr);
```

Codice:

```c
#include <stdlib.h>

_Bool deleteNode(CharList *lsPtr, CharList positionPtr) {
    if (lsPtr == NULL || positionPtr == NULL) {
        return 0;
    }

    CharList previousPtr = NULL;
    CharList currentPtr = *lsPtr;

    while (currentPtr != NULL && currentPtr != positionPtr) {
        previousPtr = currentPtr;
        currentPtr = currentPtr->next;
    }

    if (currentPtr == NULL) {
        return 0;
    }

    if (previousPtr == NULL) {
        *lsPtr = currentPtr->next;
    } else {
        previousPtr->next = currentPtr->next;
    }

    free(currentPtr);
    return 1;
}
```

---

# 29. Cancellazione del nodo dopo un nodo dato

Esercizio delle slide: cancellare il nodo dopo `positionPtr`.

Se `positionPtr == NULL`, si cancella il nodo di testa.

Firma:

```c
_Bool deleteAfter(CharList *lsPtr, CharList positionPtr);
```

Codice robusto:

```c
#include <stdlib.h>

_Bool deleteAfter(CharList *lsPtr, CharList positionPtr) {
    if (lsPtr == NULL || *lsPtr == NULL) {
        return 0;
    }

    CharList targetPtr = NULL;

    if (positionPtr == NULL) {
        targetPtr = *lsPtr;
        *lsPtr = targetPtr->next;
        free(targetPtr);
        return 1;
    }

    CharList currentPtr = *lsPtr;
    while (currentPtr != NULL && currentPtr != positionPtr) {
        currentPtr = currentPtr->next;
    }

    if (currentPtr == NULL || currentPtr->next == NULL) {
        return 0;
    }

    targetPtr = currentPtr->next;
    currentPtr->next = targetPtr->next;
    free(targetPtr);

    return 1;
}
```

---

# 30. Liberare tutta una lista

Ogni nodo creato con `malloc` deve essere liberato.

Funzione utile:

```c
#include <stdlib.h>

void freeCharList(CharList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    CharList currentPtr = *lsPtr;

    while (currentPtr != NULL) {
        CharList tempPtr = currentPtr;
        currentPtr = currentPtr->next;
        free(tempPtr);
    }

    *lsPtr = NULL;
}
```

Perché serve `tempPtr`?

Perché se facessi:

```c
free(currentPtr);
currentPtr = currentPtr->next; // ERRORE
```

staresti accedendo a `currentPtr->next` dopo aver liberato `currentPtr`.

---

# 31. Programma completo da riscrivere per allenarsi

Questo è il codice che ti consiglio di riscrivere a mano in CLion/VS Code, compilarlo, modificarlo e debuggare passo passo.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

// Nodo di una lista di caratteri
typedef struct charListNode {
    char data;
    struct charListNode *next;
} CharListNode;

// Una lista è un puntatore al primo nodo
typedef CharListNode *CharList;

void printCharList(CharList ls) {
    printf("[");

    for (CharList currentPtr = ls;
         currentPtr != NULL;
         currentPtr = currentPtr->next) {
        printf("%c", currentPtr->data);

        if (currentPtr->next != NULL) {
            printf(", ");
        }
    }

    printf("]\n");
}

size_t length(CharList ls) {
    size_t count = 0;

    for (CharList currentPtr = ls;
         currentPtr != NULL;
         currentPtr = currentPtr->next) {
        count++;
    }

    return count;
}

size_t countIf(CharList ls, int (*predicate)(char e)) {
    size_t count = 0;

    for (CharList currentPtr = ls;
         currentPtr != NULL;
         currentPtr = currentPtr->next) {
        if (predicate(currentPtr->data)) {
            count++;
        }
    }

    return count;
}

int isUppercase(char c) {
    return c >= 'A' && c <= 'Z';
}

_Bool insertInSortedCharList(CharList *lsPtr, char value) {
    if (lsPtr == NULL) {
        return 0;
    }

    CharList newPtr = malloc(sizeof *newPtr);
    if (newPtr == NULL) {
        return 0;
    }

    newPtr->data = value;
    newPtr->next = NULL;

    CharList previousPtr = NULL;
    CharList currentPtr = *lsPtr;

    while (currentPtr != NULL && value > currentPtr->data) {
        previousPtr = currentPtr;
        currentPtr = currentPtr->next;
    }

    newPtr->next = currentPtr;

    if (previousPtr == NULL) {
        *lsPtr = newPtr;
    } else {
        previousPtr->next = newPtr;
    }

    return 1;
}

_Bool deleteFromCharList(CharList *lsPtr, char value) {
    if (lsPtr == NULL) {
        return 0;
    }

    CharList previousPtr = NULL;
    CharList currentPtr = *lsPtr;

    while (currentPtr != NULL && currentPtr->data != value) {
        previousPtr = currentPtr;
        currentPtr = currentPtr->next;
    }

    if (currentPtr == NULL) {
        return 0;
    }

    if (previousPtr == NULL) {
        *lsPtr = currentPtr->next;
    } else {
        previousPtr->next = currentPtr->next;
    }

    free(currentPtr);
    return 1;
}

void freeCharList(CharList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    CharList currentPtr = *lsPtr;

    while (currentPtr != NULL) {
        CharList tempPtr = currentPtr;
        currentPtr = currentPtr->next;
        free(tempPtr);
    }

    *lsPtr = NULL;
}

int main(void) {
    CharList ls = NULL;

    insertInSortedCharList(&ls, 'D');
    insertInSortedCharList(&ls, 'A');
    insertInSortedCharList(&ls, 'E');
    insertInSortedCharList(&ls, 'B');
    insertInSortedCharList(&ls, 'C');

    printf("Lista ordinata: ");
    printCharList(ls);

    printf("Lunghezza: %zu\n", length(ls));
    printf("Maiuscole: %zu\n", countIf(ls, isUppercase));

    deleteFromCharList(&ls, 'C');

    printf("Dopo cancellazione di C: ");
    printCharList(ls);

    freeCharList(&ls);

    printf("Dopo freeCharList: ");
    printCharList(ls);

    return 0;
}
```

Compilazione consigliata:

```bash
gcc -std=c99 -Wall -Wextra -pedantic main.c -o main
```

Esecuzione:

```bash
./main
```

Output atteso:

```text
Lista ordinata: [A, B, C, D, E]
Lunghezza: 5
Maiuscole: 5
Dopo cancellazione di C: [A, B, D, E]
Dopo freeCharList: []
```

---

# 32. Errori tipici da evitare

## 32.1 Non controllare `malloc`

Sbagliato:

```c
CharList newPtr = malloc(sizeof *newPtr);
newPtr->data = value;
```

Corretto:

```c
CharList newPtr = malloc(sizeof *newPtr);
if (newPtr == NULL) {
    return 0;
}
newPtr->data = value;
```

---

## 32.2 Perdere la testa della lista

Sbagliato:

```c
ls = ls->next;
```

Se non hai salvato il vecchio nodo, potresti perdere l'unico riferimento per liberarlo.

Corretto:

```c
CharList oldHead = ls;
ls = ls->next;
free(oldHead);
```

---

## 32.3 Usare memoria già liberata

Sbagliato:

```c
free(currentPtr);
previousPtr->next = currentPtr->next;
```

Corretto:

```c
previousPtr->next = currentPtr->next;
free(currentPtr);
```

---

## 32.4 Dimenticare il caso testa

Molte funzioni devono distinguere:

```c
if (previousPtr == NULL) {
    // sto modificando la testa
} else {
    // sto modificando un collegamento interno
}
```

Se non gestisci il caso testa, il codice funziona solo per nodi interni.

---

## 32.5 Confondere nodo e lista

Ricorda:

```c
CharListNode node;
```

è un nodo.

```c
CharList ls;
```

è un puntatore a nodo, quindi rappresenta una lista.

```c
CharList *lsPtr;
```

è un puntatore alla variabile che contiene la testa della lista.

---

# 33. Complessità delle operazioni

| Operazione | Complessità | Motivo |
|---|---:|---|
| Visita | `O(n)` | devo scorrere i nodi |
| Lunghezza | `O(n)` | devo contarli uno a uno |
| Ricerca | `O(n)` | nel caso peggiore arrivo alla fine |
| Inserimento in testa | `O(1)` | non devo scorrere la lista |
| Inserimento in coda senza puntatore tail | `O(n)` | devo trovare l'ultimo nodo |
| Inserimento dopo un nodo già noto | `O(1)` | modifico pochi puntatori |
| Cancellazione della testa | `O(1)` | aggiorno la testa |
| Cancellazione per valore | `O(n)` | devo cercare il valore |
| Cancellazione dopo un nodo già noto | `O(1)` | se non devo verificare appartenenza |

---

# 34. Tipi di lista citati nella lezione

La lista linkata semplice è la base per strutture più ricche.

## Lista circolare

L'ultimo nodo non punta a `NULL`, ma torna alla testa.

```text
A -> B -> C
^         |
|_________|
```

Utile quando si vuole ciclare continuamente sugli elementi.

---

## Lista double-ended

Mantiene sia un puntatore alla testa sia un puntatore alla coda.

```text
head -> A -> B -> C <- tail
```

Permette operazioni efficienti a entrambe le estremità.

---

## Lista doppiamente linkata

Ogni nodo ha due puntatori:

- uno al successivo;
- uno al precedente.

```text
NULL <- A <-> B <-> C -> NULL
```

Permette di muoversi sia in avanti sia all'indietro.

---

# 35. Domande da esame

## Domanda 1

**Perché una lista linkata viene rappresentata come puntatore al primo nodo?**

Risposta ottima:

> Perché così posso rappresentare la lista vuota con `NULL` e allocare nodi dinamicamente solo quando servono. Inoltre, il puntatore alla testa permette di accedere all'intera struttura, perché ogni nodo contiene il puntatore al nodo successivo.

---

## Domanda 2

**Perché nelle funzioni di inserimento si passa `CharList *lsPtr` e non `CharList ls`?**

Risposta ottima:

> Perché l'inserimento può modificare la testa della lista. Se passassi solo `CharList ls`, modificherei una copia locale del puntatore. Passando `CharList *lsPtr`, la funzione può aggiornare direttamente la variabile del chiamante tramite `*lsPtr`.

---

## Domanda 3

**Che cosa succede se dimentico di mettere `next = NULL` nell'ultimo nodo?**

Risposta ottima:

> Il campo `next` potrebbe contenere bit casuali interpretati come indirizzo. Visitando la lista, il programma potrebbe tentare di accedere a memoria non valida, causando comportamento indefinito o segmentation fault.

---

## Domanda 4

**Qual è la differenza tra `const char *p` e `char *const p`?**

Risposta ottima:

> In `const char *p` il dato puntato non può essere modificato tramite `p`, ma il puntatore può cambiare. In `char *const p` il puntatore non può cambiare, ma il dato puntato può essere modificato.

---

## Domanda 5

**Perché l'ordine degli assegnamenti è importante nell'inserimento in testa?**

Risposta ottima:

> Perché se aggiorno prima la testa perdo il riferimento alla vecchia lista. Devo prima collegare il nuovo nodo alla vecchia testa con `newPtr->next = *lsPtr`, poi aggiornare la testa con `*lsPtr = newPtr`.

---

## Domanda 6

**Quali sono i passi della cancellazione di un nodo?**

Risposta ottima:

> Prima cerco il nodo da cancellare, mantenendo anche il predecessore. Poi scollego il nodo dalla lista aggiornando il puntatore del predecessore o la testa. Infine libero la memoria del nodo cancellato con `free`.

---

# 36. Esercizi consigliati

## Esercizio 1

Implementa una funzione:

```c
_Bool contains(CharList ls, char value);
```

che restituisce `1` se `value` è presente nella lista, `0` altrimenti.

---

## Esercizio 2

Implementa:

```c
CharList find(CharList ls, char value);
```

che restituisce il puntatore al primo nodo che contiene `value`, oppure `NULL` se non esiste.

---

## Esercizio 3

Implementa:

```c
_Bool insertBefore(CharList *lsPtr, char value, CharList positionPtr);
```

Testa i casi:

- lista vuota;
- inserimento prima della testa;
- inserimento in mezzo;
- inserimento in coda con `positionPtr == NULL`;
- `positionPtr` non appartenente alla lista.

---

## Esercizio 4

Implementa:

```c
_Bool deleteNode(CharList *lsPtr, CharList positionPtr);
```

Testa i casi:

- cancellazione della testa;
- cancellazione di un nodo interno;
- cancellazione dell'ultimo nodo;
- `positionPtr == NULL`;
- lista vuota.

---

## Esercizio 5

Implementa una lista di studenti:

```c
typedef struct studentNode {
    int matricola;
    char nome[50];
    double media;
    struct studentNode *next;
} StudentNode;

typedef StudentNode *StudentList;
```

Poi scrivi funzioni per:

- inserire uno studente in testa;
- stampare la lista;
- cercare per matricola;
- cancellare per matricola;
- liberare tutta la lista.

---

# 37. Mini-cheat sheet finale

```c
// Nodo
typedef struct node {
    int data;
    struct node *next;
} Node;

// Lista
typedef Node *List;

// Lista vuota
List ls = NULL;

// Visita
for (List cur = ls; cur != NULL; cur = cur->next) {
    // usa cur->data
}

// Nuovo nodo
List newPtr = malloc(sizeof *newPtr);
if (newPtr == NULL) {
    // errore
}
newPtr->data = value;
newPtr->next = NULL;

// Inserimento in testa
newPtr->next = ls;
ls = newPtr;

// Cancellazione testa
List oldHead = ls;
ls = ls->next;
free(oldHead);

// Libera tutta la lista
while (ls != NULL) {
    List temp = ls;
    ls = ls->next;
    free(temp);
}
```

---

# 38. Cosa devi saper fare senza guardare gli appunti

Per puntare al 30 e lode, devi saper fare queste cose a mano:

- disegnare una lista con nodi e puntatori;
- spiegare cosa significa `NULL`;
- scrivere una `struct` autoreferenziale;
- distinguere nodo, lista e puntatore alla testa;
- scrivere una visita con `for` o `while`;
- implementare `length`;
- implementare inserimento in testa;
- implementare inserimento ordinato;
- implementare cancellazione della prima occorrenza;
- spiegare perché serve `free`;
- spiegare perché serve `List *lsPtr`;
- spiegare la differenza tra array e lista linkata;
- spiegare i quattro casi principali di `const` con puntatori.

> [!quote] Frase finale da ricordare
> Una lista linkata non è un blocco contiguo di memoria: è una catena di nodi allocati dinamicamente, in cui ogni nodo sa dove si trova il successivo.
