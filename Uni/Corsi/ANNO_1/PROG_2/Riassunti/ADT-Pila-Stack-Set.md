
# ADT Pila / Stack in C

> [!abstract] Obiettivo della lezione  
> Capire cosa significa progettare un **Abstract Data Type** in C e vedere un caso concreto: la **pila**, o **stack**, implementata in due modi:
> 
> 1. tramite **lista linkata**
>     
> 2. tramite **array dinamico**
>     
> 
> Per prendere 30 e lode non basta “sapere il codice”: bisogna capire **interfaccia**, **incapsulamento**, **gestione della memoria**, **invarianti** e **casi limite**.

---

# 1. Abstract Data Type, ADT

Un **Abstract Data Type**, abbreviato **ADT**, è un tipo di dato definito non solo dalla sua rappresentazione interna, ma soprattutto dalle **operazioni** che permette di fare.

In altre parole, un ADT è composto da:

1. un tipo `T`;
    
2. un insieme di funzioni che operano su valori di tipo `T`;
    
3. l’implementazione concreta di queste funzioni.
    

L’idea fondamentale è questa:

> [!important] Idea centrale degli ADT  
> Il codice cliente deve usare il tipo solo attraverso le funzioni pubbliche, senza conoscere i dettagli interni dell’implementazione.

Questo significa che il cliente sa **cosa può fare** con il tipo, ma non sa necessariamente **come è fatto dentro**.

---

## 1.1 Esempio intuitivo

Immagina di usare una pila di piatti.

Puoi fare operazioni come:

- aggiungere un piatto sopra;
    
- togliere il piatto in cima;
    
- controllare se la pila è vuota.
    

Non ti interessa come sono rappresentati internamente i piatti: quello che conta è il comportamento della struttura.

Lo stesso vale in C: l’utente dell’ADT deve conoscere le funzioni disponibili, non la struttura interna.

---

# 2. ADT in C

In C un ADT si realizza tipicamente separando:

|File|Contenuto|Ruolo|
|---|---|---|
|`.h`|typedef e prototipi|Interfaccia pubblica|
|`.c`|struct concreta e funzioni|Implementazione privata|
|file cliente|uso dell’ADT|Usa solo l’interfaccia|

Esempio:

```c
// charStackADT.h
typedef struct charStack *CharStackADT;

CharStackADT mkStack(void);
void dsStack(CharStackADT *ps);
_Bool push(CharStackADT s, char e);
char pop(CharStackADT s);
_Bool isEmptyStack(const CharStackADT s);
int stackSize(const CharStackADT s);
```

Qui il cliente vede solo:

```c
typedef struct charStack *CharStackADT;
```

ma non vede com’è fatta `struct charStack`.

Questo è un esempio di **tipo opaco**.

---

## 2.1 Tipo opaco

Un tipo è detto **opaco** quando il codice cliente conosce il nome del tipo, ma non conosce i dettagli della struttura interna.

Per esempio:

```c
typedef struct charStack *CharStackADT;
```

Il cliente può dichiarare:

```c
CharStackADT s;
```

ma non può fare:

```c
s->top;
s->size;
```

perché non sa cosa c’è dentro `struct charStack`.

> [!tip] Cosa devi capire bene  
> Il tipo opaco serve a proteggere l’implementazione.  
> Il cliente non può modificare direttamente i campi interni dello stack, quindi è costretto a usare le funzioni dell’ADT.

---

# 3. La pila, o stack

Una **pila**, in inglese **stack**, è una struttura dati in cui gli elementi vengono gestiti secondo la politica:

```text
LIFO = Last In, First Out
```

cioè:

> L’ultimo elemento inserito è il primo a essere rimosso.

---

## 3.1 Operazioni fondamentali

Le operazioni principali di una pila sono:

|Operazione|Significato|
|---|---|
|`mkStack()`|crea una pila vuota|
|`push(s, e)`|inserisce `e` in cima alla pila|
|`pop(s)`|rimuove e restituisce l’elemento in cima|
|`isEmptyStack(s)`|controlla se la pila è vuota|
|`stackSize(s)`|restituisce il numero di elementi|
|`dsStack(&s)`|distrugge la pila e libera memoria|

Operazioni opzionali:

|Operazione|Significato|
|---|---|
|`top(s)`|legge l’elemento in cima senza rimuoverlo|
|`isFullStack(s)`|controlla se la pila è piena|
|`mkStack(capacity)`|crea una pila con capacità iniziale|

---

# 4. Esempio di comportamento LIFO

Supponiamo di fare:

```c
push(s, 'A');
push(s, 'B');
push(s, 'C');
```

Lo stack sarà:

```text
top -> C
       B
       A
```

Ora:

```c
pop(s);
```

restituisce `'C'`, perché `'C'` è stato l’ultimo elemento inserito.

Poi:

```c
pop(s);
```

restituisce `'B'`.

Quindi l’ordine di uscita è inverso rispetto all’ordine di inserimento.

---

# 5. Interfaccia dell’ADT `CharStackADT`

Un possibile file header è:

```c
#ifndef CHAR_STACK_ADT_H
#define CHAR_STACK_ADT_H

typedef struct charStack *CharStackADT;

CharStackADT mkStack(void);
void dsStack(CharStackADT *ps);

_Bool push(CharStackADT s, char e);
char pop(CharStackADT s);

_Bool isEmptyStack(const CharStackADT s);
int stackSize(const CharStackADT s);

#endif
```

---

## 5.1 Perché `dsStack` prende `CharStackADT *ps`?

La funzione:

```c
void dsStack(CharStackADT *ps);
```

riceve un puntatore allo stack perché deve poter modificare il puntatore originale del chiamante.

Esempio:

```c
CharStackADT s = mkStack();

dsStack(&s);
```

Dopo la chiamata vogliamo che:

```c
s == NULL
```

Per riuscirci, `dsStack` deve ricevere l’indirizzo di `s`.

---

## 5.2 Perché `push` restituisce `_Bool`?

```c
_Bool push(CharStackADT s, char e);
```

`push` può fallire se la memoria non è disponibile.

Per esempio, se internamente deve fare una `malloc` o una `realloc`, queste possono restituire `NULL`.

Quindi:

```c
if (!push(s, 'A')) {
    printf("Errore: push fallita\n");
}
```

---

## 5.3 Perché `pop` può essere pericolosa?

```c
char pop(CharStackADT s);
```

`pop` ha senso solo se la pila non è vuota.

Questo codice è pericoloso:

```c
char c = pop(s);
```

se `s` è vuota.

Per questo nell’implementazione bisogna controllare:

```c
if (isEmptyStack(s)) {
    exit(EXIT_FAILURE);
}
```

Oppure, in una variante più robusta dell’ADT, si può progettare una `pop` che restituisce un valore booleano:

```c
_Bool pop(CharStackADT s, char *out);
```

Esempio:

```c
char value;

if (pop(s, &value)) {
    printf("Estratto: %c\n", value);
} else {
    printf("Stack vuoto\n");
}
```

---

# 6. Implementazione con lista linkata

Una pila può essere implementata tramite una **lista linkata**.

L’idea è:

- il nodo in testa alla lista rappresenta il **top** dello stack;
    
- `push` inserisce in testa;
    
- `pop` rimuove dalla testa.
    

Questa scelta è molto efficiente, perché inserire e rimuovere in testa richiede tempo costante.

---

## 6.1 Strutture dati interne

Nel file `.c`, quindi non visibili al cliente, possiamo avere:

```c
#include <stdio.h>
#include <stdlib.h>
#include "charStackADT.h"

typedef struct listNode ListNode;
typedef ListNode *ListNodePtr;

struct listNode {
    char data;
    ListNodePtr next;
};

struct charStack {
    ListNodePtr top;
    int size;
};
```

Qui:

```c
struct listNode {
    char data;
    ListNodePtr next;
};
```

rappresenta un nodo della lista.

Mentre:

```c
struct charStack {
    ListNodePtr top;
    int size;
};
```

rappresenta lo stack vero e proprio.

---

## 6.2 Invariante della struttura

> [!important] Invariante dello stack con lista
> 
> - `s->top` punta al nodo in cima alla pila.
>     
> - Se la pila è vuota, `s->top == NULL`.
>     
> - `s->size` contiene il numero di nodi presenti.
>     
> - Ogni `push` aumenta `size`.
>     
> - Ogni `pop` diminuisce `size`.
>     

Capire l’invariante è fondamentale: ogni funzione deve lasciare la struttura in uno stato coerente.

---

# 7. `mkStack` con lista

```c
CharStackADT mkStack(void) {
    CharStackADT s = malloc(sizeof(*s));

    if (s == NULL) {
        return NULL;
    }

    s->top = NULL;
    s->size = 0;

    return s;
}
```

---

## 7.1 Spiegazione riga per riga

```c
CharStackADT s = malloc(sizeof(*s));
```

Alloca memoria per la struttura `struct charStack`.

Si usa:

```c
sizeof(*s)
```

invece di:

```c
sizeof(struct charStack)
```

perché è più robusto: se il tipo cambia, il `sizeof` resta corretto.

Poi:

```c
if (s == NULL) {
    return NULL;
}
```

controlla se la `malloc` è fallita.

Infine:

```c
s->top = NULL;
s->size = 0;
```

inizializza una pila vuota.

---

# 8. `push` con lista

```c
_Bool push(CharStackADT s, char e) {
    ListNodePtr ptr = malloc(sizeof(*ptr));

    if (ptr == NULL) {
        return 0;
    }

    ptr->data = e;

    ptr->next = s->top;
    s->top = ptr;

    s->size++;

    return 1;
}
```

---

## 8.1 Disegno mentale

Prima della `push('B')`:

```text
top -> A -> NULL
size = 1
```

Creo il nuovo nodo:

```text
ptr -> B
```

Poi faccio:

```c
ptr->next = s->top;
```

Risultato:

```text
ptr -> B -> A -> NULL
       ^
      top vecchio
```

Poi:

```c
s->top = ptr;
```

Risultato finale:

```text
top -> B -> A -> NULL
size = 2
```

---

## 8.2 Errore comune

Un errore gravissimo sarebbe scrivere:

```c
s->top = ptr;
ptr->next = s->top;
```

Così il nodo punterebbe a sé stesso.

Infatti dopo:

```c
s->top = ptr;
```

anche `s->top` punta al nuovo nodo.

Quindi:

```c
ptr->next = s->top;
```

farebbe:

```text
ptr->next = ptr;
```

creando un ciclo.

> [!warning] Regola da ricordare  
> Prima collega il nuovo nodo alla vecchia testa, poi aggiorna la testa.

Forma corretta:

```c
ptr->next = s->top;
s->top = ptr;
```

---

# 9. `pop` con lista

```c
char pop(CharStackADT s) {
    if (isEmptyStack(s)) {
        exit(EXIT_FAILURE);
    }

    char e = s->top->data;

    ListNodePtr ptr = s->top;
    s->top = ptr->next;

    free(ptr);

    s->size--;

    return e;
}
```

---

## 9.1 Spiegazione passo passo

Supponiamo:

```text
top -> B -> A -> NULL
size = 2
```

Salvo il dato:

```c
char e = s->top->data;
```

Quindi:

```c
e = 'B';
```

Salvo il nodo da eliminare:

```c
ListNodePtr ptr = s->top;
```

Poi sposto `top` al nodo successivo:

```c
s->top = ptr->next;
```

Ora:

```text
top -> A -> NULL
ptr -> B -> A -> NULL
```

Libero il vecchio nodo:

```c
free(ptr);
```

Aggiorno la dimensione:

```c
s->size--;
```

Restituisco il valore:

```c
return e;
```

---

## 9.2 Perché devo salvare `ptr`?

Perché se facessi direttamente:

```c
s->top = s->top->next;
```

perderei il puntatore al vecchio nodo di testa e non potrei più fare `free` su quel nodo.

Quindi devo prima salvarlo:

```c
ListNodePtr ptr = s->top;
```

---

# 10. `isEmptyStack` e `stackSize` con lista

```c
_Bool isEmptyStack(const CharStackADT s) {
    return s->top == NULL;
}

int stackSize(const CharStackADT s) {
    return s->size;
}
```

---

## 10.1 Osservazione importante

Per uno stack con lista, una pila è vuota se:

```c
s->top == NULL
```

In alternativa si potrebbe controllare:

```c
s->size == 0
```

ma se manteniamo correttamente l’invariante, le due condizioni devono essere equivalenti.

---

# 11. `dsStack` con lista

```c
void dsStack(CharStackADT *ps) {
    ListNodePtr ptr = (*ps)->top;

    while (ptr != NULL) {
        ListNodePtr tmp = ptr;
        ptr = ptr->next;
        free(tmp);
    }

    free(*ps);
    *ps = NULL;
}
```

---

## 11.1 Spiegazione

La funzione deve liberare:

1. tutti i nodi della lista;
    
2. la struttura stack;
    
3. mettere il puntatore del chiamante a `NULL`.
    

La parte centrale è:

```c
while (ptr != NULL) {
    ListNodePtr tmp = ptr;
    ptr = ptr->next;
    free(tmp);
}
```

Non posso fare:

```c
free(ptr);
ptr = ptr->next;
```

perché dopo `free(ptr)` non posso più accedere a `ptr->next`.

Quindi prima salvo il prossimo nodo, poi libero quello corrente.

---

## 11.2 Versione alternativa usando `pop`

Se `pop` è già corretta, posso anche scrivere:

```c
void dsStack(CharStackADT *ps) {
    while (!isEmptyStack(*ps)) {
        pop(*ps);
    }

    free(*ps);
    *ps = NULL;
}
```

Questa versione è più semplice, ma dipende dal fatto che `pop` sia corretta.

---

# 12. Implementazione completa con lista

```c
#include <stdio.h>
#include <stdlib.h>
#include "charStackADT.h"

typedef struct listNode ListNode;
typedef ListNode *ListNodePtr;

struct listNode {
    char data;
    ListNodePtr next;
};

struct charStack {
    ListNodePtr top;
    int size;
};

CharStackADT mkStack(void) {
    CharStackADT s = malloc(sizeof(*s));

    if (s == NULL) {
        return NULL;
    }

    s->top = NULL;
    s->size = 0;

    return s;
}

void dsStack(CharStackADT *ps) {
    if (ps == NULL || *ps == NULL) {
        return;
    }

    ListNodePtr ptr = (*ps)->top;

    while (ptr != NULL) {
        ListNodePtr tmp = ptr;
        ptr = ptr->next;
        free(tmp);
    }

    free(*ps);
    *ps = NULL;
}

_Bool push(CharStackADT s, char e) {
    if (s == NULL) {
        return 0;
    }

    ListNodePtr ptr = malloc(sizeof(*ptr));

    if (ptr == NULL) {
        return 0;
    }

    ptr->data = e;
    ptr->next = s->top;
    s->top = ptr;

    s->size++;

    return 1;
}

char pop(CharStackADT s) {
    if (s == NULL || isEmptyStack(s)) {
        exit(EXIT_FAILURE);
    }

    char e = s->top->data;

    ListNodePtr ptr = s->top;
    s->top = ptr->next;

    free(ptr);

    s->size--;

    return e;
}

_Bool isEmptyStack(const CharStackADT s) {
    if (s == NULL) {
        return 1;
    }

    return s->top == NULL;
}

int stackSize(const CharStackADT s) {
    if (s == NULL) {
        return 0;
    }

    return s->size;
}
```

---

# 13. Complessità della versione con lista

|Operazione|Complessità|
|---|---|
|`mkStack`|`O(1)`|
|`push`|`O(1)`|
|`pop`|`O(1)`|
|`isEmptyStack`|`O(1)`|
|`stackSize`|`O(1)`|
|`dsStack`|`O(n)`|

`dsStack` è `O(n)` perché deve liberare tutti i nodi.

---

# 14. Implementazione con array dinamico

Un’altra implementazione possibile usa un **array dinamico**.

L’idea è:

- gli elementi sono salvati in un array;
    
- `top` indica la posizione dell’elemento in cima;
    
- se l’array si riempie, viene ridimensionato con `realloc`;
    
- se l’array diventa troppo vuoto, può essere ridotto.
    

---

## 14.1 Struttura interna

```c
struct charStack {
    char *a;
    int cap;
    int top;
};
```

Significato dei campi:

|Campo|Significato|
|---|---|
|`a`|array dinamico che contiene gli elementi|
|`cap`|capacità massima attuale dell’array|
|`top`|indice dell’elemento in cima|

---

## 14.2 Invariante della versione con array

> [!important] Invariante dello stack con array
> 
> - Se lo stack è vuoto, `top == -1`.
>     
> - Se ci sono elementi, sono nelle posizioni da `0` a `top`.
>     
> - Il numero di elementi è `top + 1`.
>     
> - La capacità è `cap`.
>     
> - Deve sempre valere `top < cap`.
>     

Esempio:

```text
a = [A, B, C, _, _, _, _, _]
cap = 8
top = 2
```

Lo stack contiene 3 elementi:

```text
A, B, C
```

L’elemento in cima è:

```text
a[top] = a[2] = C
```

---

# 15. `mkStack` con array dinamico

```c
#define INITIAL_CAPACITY 2

CharStackADT mkStack(void) {
    CharStackADT s = malloc(sizeof(*s));

    if (s == NULL) {
        return NULL;
    }

    s->cap = INITIAL_CAPACITY;
    s->a = malloc(s->cap * sizeof(*(s->a)));

    if (s->a == NULL) {
        free(s);
        return NULL;
    }

    s->top = -1;

    return s;
}
```

---

## 15.1 Perché `top = -1`?

Perché se il primo elemento viene inserito con:

```c
s->a[++(s->top)] = e;
```

allora partendo da:

```c
top = -1
```

dopo il pre-incremento:

```c
++top
```

si ottiene:

```c
top = 0
```

e il primo elemento finisce correttamente in posizione `0`.

---

# 16. `push` con array dinamico

```c
_Bool push(CharStackADT s, char e) {
    if (s == NULL) {
        return 0;
    }

    if (s->top == s->cap - 1) {
        char *new_a = realloc(s->a, s->cap * 2 * sizeof(*(s->a)));

        if (new_a == NULL) {
            return 0;
        }

        s->a = new_a;
        s->cap *= 2;
    }

    s->a[++(s->top)] = e;

    return 1;
}
```

---

## 16.1 Quando l’array è pieno?

L’array è pieno quando:

```c
s->top == s->cap - 1
```

Esempio:

```text
cap = 4
top = 3
```

Gli indici validi sono:

```text
0, 1, 2, 3
```

quindi se `top == 3`, l’array è pieno.

---

## 16.2 Perché raddoppiare la capacità?

Quando lo spazio finisce, si usa:

```c
realloc(s->a, s->cap * 2 * sizeof(*(s->a)));
```

Questo raddoppia la capacità.

Esempio:

```text
cap = 4
```

diventa:

```text
cap = 8
```

Raddoppiare è una scelta efficiente perché evita di fare una `realloc` a ogni `push`.

---

## 16.3 Perché usare un puntatore temporaneo con `realloc`?

Forma corretta:

```c
char *new_a = realloc(s->a, new_size);

if (new_a == NULL) {
    return 0;
}

s->a = new_a;
```

Forma pericolosa:

```c
s->a = realloc(s->a, new_size);
```

Se `realloc` fallisce, restituisce `NULL`.

In quel caso perderesti il puntatore al vecchio array, causando un memory leak.

---

# 17. `pop` con array dinamico

```c
char pop(CharStackADT s) {
    if (s == NULL || isEmptyStack(s)) {
        exit(EXIT_FAILURE);
    }

    char e = s->a[(s->top)--];

    if (s->cap > INITIAL_CAPACITY && s->top == s->cap / 4) {
        s->cap /= 2;
        char *new_a = realloc(s->a, s->cap * sizeof(*(s->a)));

        if (new_a != NULL) {
            s->a = new_a;
        }
    }

    return e;
}
```

---

## 17.1 Perché `s->a[(s->top)--]`?

Questa istruzione:

```c
char e = s->a[(s->top)--];
```

usa il valore attuale di `top`, poi lo decrementa.

Esempio:

```text
a = [A, B, C, _]
top = 2
```

Allora:

```c
char e = s->a[(s->top)--];
```

prima prende:

```text
a[2] = C
```

poi aggiorna:

```text
top = 1
```

Quindi `C` viene rimosso logicamente dallo stack.

---

## 17.2 L’elemento viene davvero cancellato dall’array?

No.

Dopo il `pop`, il valore può ancora stare fisicamente nell’array, ma non fa più parte dello stack perché `top` è diminuito.

Esempio:

```text
prima:
a = [A, B, C, _]
top = 2

dopo pop:
a = [A, B, C, _]
top = 1
```

L’elemento `C` è ancora in memoria, ma è fuori dalla porzione considerata valida.

---

## 17.3 Perché ridurre a `cap / 4`?

La slide usa una condizione simile:

```c
if (s->cap > INITIAL_CAPACITY && s->top == s->cap / 4)
```

L’idea è ridurre l’array quando è molto vuoto.

Però è importante capire il motivo della soglia `cap / 4`.

Se riducessimo appena lo stack arriva a metà, rischieremmo molte riallocazioni continue.

Esempio problematico:

```text
cap = 8
size = 4
```

Se riduci subito a 4, basta una `push` per dover tornare a 8.

Questo crea un effetto oscillazione:

```text
realloc giù
realloc su
realloc giù
realloc su
```

La soglia `1/4` evita questo problema.

---

## 17.4 Attenzione a `top` e `size`

Nella versione con array:

```c
size = top + 1
```

Quindi se `top == cap / 4`, il numero reale di elementi è:

```c
top + 1
```

In alcune implementazioni più pulite si usa direttamente un campo `size`, oppure si controlla:

```c
if (s->cap > INITIAL_CAPACITY && stackSize(s) <= s->cap / 4)
```

Questo rende il codice più leggibile.

---

# 18. `isEmptyStack` e `stackSize` con array

```c
_Bool isEmptyStack(const CharStackADT s) {
    if (s == NULL) {
        return 1;
    }

    return s->top < 0;
}

int stackSize(const CharStackADT s) {
    if (s == NULL) {
        return 0;
    }

    return s->top + 1;
}
```

---

# 19. `dsStack` con array dinamico

```c
void dsStack(CharStackADT *ps) {
    if (ps == NULL || *ps == NULL) {
        return;
    }

    free((*ps)->a);
    free(*ps);

    *ps = NULL;
}
```

Qui bisogna liberare:

1. l’array dinamico;
    
2. la struttura stack;
    
3. il puntatore del chiamante, mettendolo a `NULL`.
    

---

# 20. Implementazione completa con array dinamico

```c
#include <stdio.h>
#include <stdlib.h>
#include "charStackADT.h"

#define INITIAL_CAPACITY 2

struct charStack {
    char *a;
    int cap;
    int top;
};

CharStackADT mkStack(void) {
    CharStackADT s = malloc(sizeof(*s));

    if (s == NULL) {
        return NULL;
    }

    s->cap = INITIAL_CAPACITY;
    s->a = malloc(s->cap * sizeof(*(s->a)));

    if (s->a == NULL) {
        free(s);
        return NULL;
    }

    s->top = -1;

    return s;
}

void dsStack(CharStackADT *ps) {
    if (ps == NULL || *ps == NULL) {
        return;
    }

    free((*ps)->a);
    free(*ps);

    *ps = NULL;
}

_Bool push(CharStackADT s, char e) {
    if (s == NULL) {
        return 0;
    }

    if (s->top == s->cap - 1) {
        char *new_a = realloc(s->a, s->cap * 2 * sizeof(*(s->a)));

        if (new_a == NULL) {
            return 0;
        }

        s->a = new_a;
        s->cap *= 2;
    }

    s->a[++(s->top)] = e;

    return 1;
}

char pop(CharStackADT s) {
    if (s == NULL || isEmptyStack(s)) {
        exit(EXIT_FAILURE);
    }

    char e = s->a[(s->top)--];

    if (s->cap > INITIAL_CAPACITY && stackSize(s) <= s->cap / 4) {
        int new_cap = s->cap / 2;

        if (new_cap < INITIAL_CAPACITY) {
            new_cap = INITIAL_CAPACITY;
        }

        char *new_a = realloc(s->a, new_cap * sizeof(*(s->a)));

        if (new_a != NULL) {
            s->a = new_a;
            s->cap = new_cap;
        }
    }

    return e;
}

_Bool isEmptyStack(const CharStackADT s) {
    if (s == NULL) {
        return 1;
    }

    return s->top < 0;
}

int stackSize(const CharStackADT s) {
    if (s == NULL) {
        return 0;
    }

    return s->top + 1;
}
```

---

# 21. Complessità della versione con array dinamico

|Operazione|Complessità|
|---|---|
|`mkStack`|`O(1)`|
|`push`|`O(1)` ammortizzato|
|`pop`|`O(1)` ammortizzato|
|`isEmptyStack`|`O(1)`|
|`stackSize`|`O(1)`|
|`dsStack`|`O(1)` per la struttura, ma libera l’array|

---

## 21.1 Cosa significa “ammortizzato”?

Una singola `push` può costare `O(n)` quando c’è una `realloc`, perché bisogna copiare gli elementi nel nuovo array.

Però non succede a ogni inserimento.

Se la capacità raddoppia, molte `push` successive saranno `O(1)`.

Quindi, considerando tante operazioni, il costo medio è `O(1)` ammortizzato.

---

# 22. Lista vs array dinamico

|Aspetto|Lista linkata|Array dinamico|
|---|---|---|
|Memoria|un nodo per elemento|blocco contiguo|
|`push`|sempre `O(1)` se malloc riesce|`O(1)` ammortizzato|
|`pop`|sempre `O(1)`|`O(1)` ammortizzato|
|Overhead|puntatore `next` per ogni nodo|possibile spazio inutilizzato|
|Località cache|peggiore|migliore|
|Ridimensionamento|non serve|serve `realloc`|
|Accesso diretto|non utile nello stack|possibile internamente|
|Distruzione|bisogna liberare tutti i nodi|basta liberare array e struct|

---

# 23. Test suite minimale

Per allenarti, scrivi un file:

```c
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "charStackADT.h"

int main(void) {
    CharStackADT s = mkStack();

    assert(s != NULL);
    assert(isEmptyStack(s));
    assert(stackSize(s) == 0);

    assert(push(s, 'A'));
    assert(!isEmptyStack(s));
    assert(stackSize(s) == 1);

    assert(push(s, 'B'));
    assert(push(s, 'C'));
    assert(stackSize(s) == 3);

    assert(pop(s) == 'C');
    assert(stackSize(s) == 2);

    assert(pop(s) == 'B');
    assert(stackSize(s) == 1);

    assert(pop(s) == 'A');
    assert(stackSize(s) == 0);
    assert(isEmptyStack(s));

    dsStack(&s);
    assert(s == NULL);

    printf("Tutti i test sono passati.\n");

    return 0;
}
```

---

# 24. Test per verificare davvero il comportamento LIFO

```c
#include <stdio.h>
#include <assert.h>
#include "charStackADT.h"

int main(void) {
    CharStackADT s = mkStack();

    char input[] = {'A', 'B', 'C', 'D'};
    char expected[] = {'D', 'C', 'B', 'A'};

    for (int i = 0; i < 4; i++) {
        assert(push(s, input[i]));
    }

    for (int i = 0; i < 4; i++) {
        assert(pop(s) == expected[i]);
    }

    assert(isEmptyStack(s));

    dsStack(&s);

    printf("Test LIFO superato.\n");

    return 0;
}
```

---

# 25. Applicazione: invertire una stringa

Uno stack è perfetto per invertire una sequenza.

Esempio:

```c
#include <stdio.h>
#include <string.h>
#include "charStackADT.h"

int main(void) {
    char str[] = "ciao";

    CharStackADT s = mkStack();

    for (int i = 0; str[i] != '\0'; i++) {
        push(s, str[i]);
    }

    while (!isEmptyStack(s)) {
        printf("%c", pop(s));
    }

    printf("\n");

    dsStack(&s);

    return 0;
}
```

Output:

```text
oaic
```

---

# 26. Applicazione: controllare parentesi bilanciate

Uno stack è usato spesso per controllare se le parentesi sono bilanciate.

Esempi validi:

```text
()
(())
(()())
```

Esempi non validi:

```text
(
())
())(
```

Versione semplice solo con parentesi tonde:

```c
#include <stdio.h>
#include "charStackADT.h"

_Bool areParenthesesBalanced(const char *str) {
    CharStackADT s = mkStack();

    if (s == NULL) {
        return 0;
    }

    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] == '(') {
            if (!push(s, '(')) {
                dsStack(&s);
                return 0;
            }
        } else if (str[i] == ')') {
            if (isEmptyStack(s)) {
                dsStack(&s);
                return 0;
            }

            pop(s);
        }
    }

    _Bool result = isEmptyStack(s);

    dsStack(&s);

    return result;
}

int main(void) {
    printf("%d\n", areParenthesesBalanced("(())"));
    printf("%d\n", areParenthesesBalanced("(()"));
    printf("%d\n", areParenthesesBalanced("())"));

    return 0;
}
```

---

# 27. Errori comuni da evitare

## 27.1 Non controllare `malloc`

Sbagliato:

```c
CharStackADT s = malloc(sizeof(*s));
s->top = NULL;
```

Se `malloc` fallisce, `s` è `NULL` e il programma va in crash.

Corretto:

```c
CharStackADT s = malloc(sizeof(*s));

if (s == NULL) {
    return NULL;
}
```

---

## 27.2 Perdere memoria con `realloc`

Sbagliato:

```c
s->a = realloc(s->a, new_size);
```

Corretto:

```c
char *new_a = realloc(s->a, new_size);

if (new_a == NULL) {
    return 0;
}

s->a = new_a;
```

---

## 27.3 Fare `pop` su stack vuoto

Sbagliato:

```c
char c = pop(s);
```

senza sapere se `s` contiene elementi.

Meglio:

```c
if (!isEmptyStack(s)) {
    char c = pop(s);
}
```

---

## 27.4 Dimenticare di fare `free`

Ogni `malloc` deve avere una `free`.

Nella versione con lista:

```text
malloc stack
malloc nodo
malloc nodo
malloc nodo
```

devono corrispondere a:

```text
free nodo
free nodo
free nodo
free stack
```

Nella versione con array:

```text
malloc stack
malloc array
```

devono corrispondere a:

```text
free array
free stack
```

---

## 27.5 Non aggiornare `size` o `top`

In ogni `push`:

```c
size++;
```

oppure:

```c
++top;
```

In ogni `pop`:

```c
size--;
```

oppure:

```c
top--;
```

Se dimentichi questi aggiornamenti, lo stack diventa incoerente.

---

# 28. Cosa devi saper spiegare all’esame

> [!success] Checklist da 30 e lode

Devi saper spiegare:

- cos’è un ADT;
    
- perché si separano `.h` e `.c`;
    
- cos’è un tipo opaco;
    
- cosa significa LIFO;
    
- cosa fanno `push` e `pop`;
    
- perché `pop` su pila vuota è un errore;
    
- perché `push` può fallire;
    
- come funziona lo stack con lista;
    
- come funziona lo stack con array dinamico;
    
- perché nella lista si inserisce e rimuove dalla testa;
    
- perché nell’array `top` parte da `-1`;
    
- perché si usa `realloc`;
    
- perché conviene raddoppiare la capacità;
    
- perché conviene ridurre solo quando l’array è molto vuoto;
    
- differenza tra costo normale e costo ammortizzato;
    
- come liberare correttamente la memoria;
    
- come testare l’ADT.
    

---

# 29. Domande tipiche d’esame

## Domanda 1

> Perché la pila è detta struttura LIFO?

Perché l’ultimo elemento inserito è il primo a essere rimosso.

Esempio:

```c
push(s, 'A');
push(s, 'B');
push(s, 'C');
```

La prima `pop` restituisce `'C'`.

---

## Domanda 2

> Perché l’implementazione con lista inserisce in testa?

Perché la testa rappresenta il top dello stack.

Inserire e rimuovere dalla testa costa `O(1)`.

Se inserissimo in coda, dovremmo scorrere la lista oppure mantenere un puntatore aggiuntivo.

---

## Domanda 3

> Perché `dsStack` riceve un puntatore a puntatore?

Perché deve modificare il puntatore originale del chiamante.

```c
dsStack(&s);
```

permette alla funzione di fare:

```c
*ps = NULL;
```

Così dopo la distruzione `s` non punta più a memoria liberata.

---

## Domanda 4

> Perché `push` nella versione array può fallire?

Perché quando l’array è pieno bisogna chiamare `realloc`.

Se `realloc` fallisce, non è possibile inserire il nuovo elemento.

---

## Domanda 5

> Perché nella versione array `stackSize` restituisce `top + 1`?

Perché gli elementi validi sono negli indici:

```text
0, 1, 2, ..., top
```

Quindi il numero di elementi è:

```text
top + 1
```

Se `top == -1`, allora:

```text
top + 1 == 0
```

cioè lo stack è vuoto.

---

# 30. Esercizi da riscrivere per prendere confidenza

## Esercizio 1

Riscrivi da zero il file `charStackADT.h`.

Obiettivo: capire bene l’interfaccia pubblica.

---

## Esercizio 2

Implementa lo stack con lista senza guardare la soluzione.

Funzioni da scrivere:

```c
mkStack
dsStack
push
pop
isEmptyStack
stackSize
```

---

## Esercizio 3

Implementa lo stack con array dinamico.

Vincoli:

- usa `INITIAL_CAPACITY`;
    
- raddoppia la capacità quando l’array è pieno;
    
- dimezza la capacità quando lo stack diventa troppo vuoto;
    
- controlla sempre `malloc` e `realloc`.
    

---

## Esercizio 4

Scrivi una funzione:

```c
char top(CharStackADT s);
```

che restituisce l’elemento in cima senza rimuoverlo.

Versione lista:

```c
char top(CharStackADT s) {
    if (s == NULL || isEmptyStack(s)) {
        exit(EXIT_FAILURE);
    }

    return s->top->data;
}
```

Versione array:

```c
char top(CharStackADT s) {
    if (s == NULL || isEmptyStack(s)) {
        exit(EXIT_FAILURE);
    }

    return s->a[s->top];
}
```

---

## Esercizio 5

Scrivi una funzione:

```c
void clearStack(CharStackADT s);
```

che svuota lo stack senza distruggerlo.

Suggerimento:

```c
while (!isEmptyStack(s)) {
    pop(s);
}
```

---

## Esercizio 6

Scrivi una funzione che inverte una stringa usando lo stack.

Prototipo:

```c
void reverseString(char *str);
```

Idea:

1. fai `push` di tutti i caratteri;
    
2. fai `pop` e riscrivi la stringa.
    

---

## Esercizio 7

Scrivi una funzione che controlla parentesi tonde, quadre e graffe.

Esempi validi:

```text
{[()]}
([]{})
```

Esempi non validi:

```text
{[(])}
((]
```

---

# 31. Mini-progetto consigliato

Crea questa struttura:

```text
StackProject/
├── charStackADT.h
├── charStack_list.c
├── charStack_array.c
├── test_charStackADT.c
└── Makefile
```

Compila prima con la versione lista:

```bash
gcc -Wall -Wextra -std=c11 test_charStackADT.c charStack_list.c -o test_stack
```

Poi con la versione array:

```bash
gcc -Wall -Wextra -std=c11 test_charStackADT.c charStack_array.c -o test_stack
```

L’obiettivo è avere **la stessa interfaccia** ma **due implementazioni diverse**.

Questa è esattamente la potenza dell’ADT.

Il codice cliente non cambia.

---

# 32. Makefile minimale

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -g

all: test_stack

test_stack: test_charStackADT.c charStack_list.c charStackADT.h
	$(CC) $(CFLAGS) test_charStackADT.c charStack_list.c -o test_stack

run: test_stack
	./test_stack

clean:
	rm -f test_stack
```

Per usare la versione array, cambia:

```makefile
charStack_list.c
```

in:

```makefile
charStack_array.c
```

---

# 33. Frase chiave da ricordare

> Un ADT separa il **cosa** dal **come**.

Nel caso dello stack:

- il **cosa** è:
    
    - posso fare `push`;
        
    - posso fare `pop`;
        
    - posso controllare se è vuoto;
        
    - posso sapere quanti elementi contiene.
        
- il **come** può essere:
    
    - lista linkata;
        
    - array dinamico;
        
    - altra struttura interna.
        

Il cliente non deve saperlo.

---

# 34. Riassunto finale

Uno stack è una struttura dati semplice ma molto importante.

La sua logica è LIFO:

```text
Last In, First Out
```

Le operazioni fondamentali sono:

```c
push
pop
isEmptyStack
stackSize
mkStack
dsStack
```

In C, uno stack ben progettato è un ottimo esempio di ADT perché permette di separare:

```text
interfaccia pubblica
```

da:

```text
implementazione privata
```

La stessa interfaccia può avere implementazioni diverse.

Con lista linkata:

```text
top = testa della lista
```

Con array dinamico:

```text
top = indice dell’ultimo elemento inserito
```

La cosa più importante da padroneggiare è la gestione corretta della memoria:

```text
malloc
realloc
free
```

e il mantenimento degli invarianti:

```text
size corretto
top corretto
puntatori coerenti
nessun memory leak
```

Se sai implementare, testare e spiegare entrambe le versioni, questo argomento diventa uno di quelli su cui puoi fare davvero bella figura all’esame.