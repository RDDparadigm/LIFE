# ADT Insieme — Set in C

## Obiettivo della lezione

Questa lezione introduce l’**ADT Insieme**, cioè il tipo di dato astratto che rappresenta un **set**.

Un **insieme** è una collezione di elementi con due proprietà fondamentali:

1. **Non esiste un ordine significativo tra gli elementi**
2. **Non ci sono duplicati**

Esempio corretto:

```c
{'a', 'e', 'i', 'o', 'u'}
```

Controesempio:

```c
{'a', 'e', 'i', 'o', 'u', 'a'}
```

Questo **non è un insieme**, perché contiene due volte `'a'`.

---

# 1. Che cos’è un ADT Insieme

Un **ADT**, cioè *Abstract Data Type*, descrive un tipo di dato in base a:

* quali valori può rappresentare;
* quali operazioni si possono fare;
* quale significato hanno queste operazioni.

Non descrive necessariamente **come** i dati sono memorizzati.

Quindi, quando parliamo di `Set`, ci interessa sapere che possiamo fare cose come:

```c
setAdd(s, 10);
setRemove(s, 10);
setMember(s, 10);
setSize(s);
```

Ma non ci interessa, dal punto di vista dell’utente dell’ADT, sapere se internamente il set usa:

* una lista linkata;
* un array statico;
* un array dinamico;
* un albero;
* una tabella hash.

Questa separazione è fondamentale in Programmazione 2.

---

# 2. Proprietà fondamentali di un insieme

Un insieme ha due proprietà importanti.

## 2.1 Gli elementi non sono ordinati

Dire:

```c
{1, 2, 3}
```

è equivalente a dire:

```c
{3, 1, 2}
```

Dal punto di vista matematico, sono lo stesso insieme.

Quindi, se implemento un set con una lista linkata, non devo pensare che il primo nodo sia “più importante” degli altri.

La lista è solo una scelta implementativa.

---

## 2.2 Gli elementi non sono duplicati

Un insieme non può contenere due volte lo stesso elemento.

Quindi, se ho:

```c
{3, 5, 8}
```

e provo ad aggiungere di nuovo `5`, l’insieme rimane:

```c
{3, 5, 8}
```

Non diventa:

```c
{3, 5, 8, 5}
```

Questa è la differenza fondamentale rispetto a una lista generica.

---

# 3. Operazioni principali dell’ADT Set

La slide presenta una possibile interfaccia astratta per un insieme.

Supponiamo di avere un tipo generico:

```c
Set
```

e un tipo degli elementi:

```c
Element
```

Le operazioni fondamentali sono le seguenti.

---

## 3.1 Creazione dell’insieme

```c
Set mkSet();
```

Crea e restituisce un insieme vuoto.

Esempio concettuale:

```c
Set s = mkSet();
```

Dopo questa operazione, `s` rappresenta:

```c
{}
```

cioè l’insieme vuoto.

---

## 3.2 Distruzione dell’insieme

```c
void dsSet(Set *);
```

Distrugge l’insieme e libera la memoria occupata.

La funzione riceve un puntatore al set, cioè un `Set *`, perché molto probabilmente vuole anche mettere il puntatore del chiamante a `NULL`.

Esempio:

```c
dsSet(&s);
```

Dopo questa chiamata, idealmente:

```c
s == NULL
```

Questo serve a evitare dangling pointer.

---

## 3.3 Aggiunta di un elemento

```c
_Bool setAdd(Set, const Element);
```

Aggiunge un elemento all’insieme.

Restituisce:

* `1` se l’elemento è stato aggiunto;
* `0` se l’elemento era già presente.

Esempio:

```c
Set s = mkSet();

setAdd(s, 10); // restituisce 1
setAdd(s, 10); // restituisce 0
```

Il secondo inserimento fallisce logicamente, perché `10` è già presente.

---

## 3.4 Rimozione di un elemento

```c
_Bool setRemove(Set, const Element);
```

Rimuove un elemento dall’insieme.

Restituisce:

* `1` se l’elemento era presente ed è stato rimosso;
* `0` se l’elemento non era presente.

Esempio:

```c
setRemove(s, 10); // restituisce 1 se 10 era presente
setRemove(s, 10); // restituisce 0, perché ora 10 non c’è più
```

---

## 3.5 Controllo di appartenenza

```c
_Bool setMember(const Set, const Element);
```

Controlla se un elemento appartiene all’insieme.

Esempio:

```c
if (setMember(s, 42)) {
    printf("42 appartiene al set\n");
}
```

Questa funzione non modifica il set, quindi il parametro è `const Set`.

---

## 3.6 Controllo insieme vuoto

```c
_Bool isEmptySet(const Set);
```

Restituisce `1` se il set è vuoto, `0` altrimenti.

Esempio:

```c
if (isEmptySet(s)) {
    printf("Il set è vuoto\n");
}
```

Se internamente tengo una variabile `size`, questa operazione può essere fatta in tempo costante:

```c
return s->size == 0;
```

---

## 3.7 Numero di elementi

```c
int setSize(const Set);
```

Restituisce il numero di elementi presenti nell’insieme.

Esempio:

```c
printf("Il set contiene %d elementi\n", setSize(s));
```

Anche questa operazione è molto efficiente se nella struct tengo aggiornato il campo `size`.

---

## 3.8 Estrazione di un elemento

```c
Element setExtract(Set);
```

Toglie e restituisce un elemento a caso dall’insieme.

“A caso” non vuol dire necessariamente casuale nel senso di `rand()`.

Vuol dire che l’ADT Set non garantisce quale elemento verrà estratto.

Per esempio, se internamente uso una lista linkata, potrei semplicemente estrarre il primo nodo.

---

## 3.9 Uguaglianza tra insiemi

```c
_Bool setEquals(const Set, const Set);
```

Controlla se due insiemi sono uguali.

Due insiemi sono uguali se contengono esattamente gli stessi elementi.

Esempio:

```c
{1, 2, 3}
```

è uguale a:

```c
{3, 1, 2}
```

perché l’ordine non conta.

Per implementare questa funzione posso ragionare così:

1. se le dimensioni sono diverse, i set non sono uguali;
2. se hanno la stessa dimensione, controllo che ogni elemento del primo sia contenuto nel secondo.

Pseudo-codice:

```c
_Bool setEquals(Set a, Set b) {
    if (setSize(a) != setSize(b)) {
        return 0;
    }

    for ogni elemento x in a {
        if (!setMember(b, x)) {
            return 0;
        }
    }

    return 1;
}
```

---

# 4. Operazioni insiemistiche

La slide presenta anche le classiche operazioni matematiche sugli insiemi.

---

## 4.1 Sottoinsieme o inclusione

```c
_Bool subsetEq(const Set, const Set);
```

Controlla se il primo insieme è incluso nel secondo.

In simboli:

```text
A ⊆ B
```

Significa che ogni elemento di `A` appartiene anche a `B`.

Esempio:

```text
A = {1, 2}
B = {1, 2, 3}
```

Allora:

```text
A ⊆ B
```

è vero.

---

## 4.2 Sottoinsieme stretto

```c
_Bool subset(const Set, const Set);
```

Controlla se il primo insieme è strettamente incluso nel secondo.

In simboli:

```text
A ⊂ B
```

Significa che:

1. ogni elemento di `A` appartiene anche a `B`;
2. `B` contiene almeno un elemento in più rispetto ad `A`.

Esempio:

```text
A = {1, 2}
B = {1, 2, 3}
```

Qui `A` è sottoinsieme stretto di `B`.

Invece:

```text
A = {1, 2, 3}
B = {1, 2, 3}
```

Qui `A ⊆ B` è vero, ma `A ⊂ B` è falso.

---

## 4.3 Unione

```c
Set setUnion(const Set, const Set);
```

Restituisce l’unione di due insiemi.

In simboli:

```text
A ∪ B
```

Contiene tutti gli elementi che appartengono ad `A`, a `B`, o a entrambi.

Esempio:

```text
A = {1, 2, 3}
B = {3, 4, 5}

A ∪ B = {1, 2, 3, 4, 5}
```

Nota importante: `3` compare una sola volta.

---

## 4.4 Intersezione

```c
Set setIntersection(const Set, const Set);
```

Restituisce l’intersezione di due insiemi.

In simboli:

```text
A ∩ B
```

Contiene solo gli elementi presenti sia in `A` sia in `B`.

Esempio:

```text
A = {1, 2, 3}
B = {3, 4, 5}

A ∩ B = {3}
```

---

## 4.5 Differenza

```c
Set setSubtraction(const Set, const Set);
```

Restituisce l’insieme ottenuto dal primo togliendo gli elementi del secondo.

In simboli:

```text
A - B
```

Esempio:

```text
A = {1, 2, 3, 4}
B = {3, 4, 5}

A - B = {1, 2}
```

Gli elementi `3` e `4` vengono tolti perché sono presenti in `B`.

L’elemento `5` non conta, perché non era presente in `A`.

---

# 5. Possibili implementazioni in C

La slide cita due possibili implementazioni:

1. **con liste linkate**
2. **con array statico**

---

## 5.1 Implementazione con liste linkate

Vantaggi:

* dimensione teoricamente illimitata;
* facile inserire e rimuovere elementi;
* adatta quando non conosco prima il numero massimo di elementi.

Svantaggi:

* serve memoria dinamica;
* bisogna usare correttamente `malloc` e `free`;
* la ricerca è lineare, quindi `O(n)`.

---

## 5.2 Implementazione con array statico

Vantaggi:

* più semplice da gestire;
* niente `malloc` per ogni elemento;
* accesso agli elementi più diretto.

Svantaggi:

* dimensione limitata;
* se l’array è pieno, non posso aggiungere altri elementi;
* rimuovere elementi può richiedere spostamenti.

---

# 6. Esempio: insieme di interi

La slide considera un insieme di `int`.

Il tipo astratto viene dichiarato così:

```c
typedef struct intSet *IntSetADT;
```

Questa è una scelta importantissima.

Significa che l’utente conosce il nome `IntSetADT`, ma non conosce i dettagli della struct.

Nel file `.h` avrò qualcosa del genere:

```c
#ifndef INT_SET_ADT_H
#define INT_SET_ADT_H

#include <stdbool.h>

typedef struct intSet *IntSetADT;

IntSetADT mkSet(void);
void dsSet(IntSetADT *sp);

_Bool setAdd(IntSetADT s, const int e);
_Bool setRemove(IntSetADT s, const int e);
_Bool setMember(const IntSetADT s, const int e);

_Bool isEmptySet(const IntSetADT s);
int setSize(const IntSetADT s);

#endif
```

L’utente può usare il set, ma non può accedere direttamente ai campi interni.

Questa tecnica si chiama **tipo opaco**.

---

# 7. Implementazione con lista linkata

Una possibile implementazione interna è:

```c
typedef struct listNode ListNode;
typedef ListNode *ListNodePtr;

struct listNode {
    int data;
    ListNodePtr next;
};

struct intSet {
    ListNodePtr head;
    int size;
};
```

Graficamente:

```text
Set
+------+
| head | ---> [21 | *] ---> [3 | *] ---> [13 | *] ---> [9 | NULL]
| size | = 4
+------+
```

Qui `head` punta al primo nodo della lista.

Il campo `size` tiene traccia del numero di elementi presenti.

---

# 8. Invarianti dell’implementazione

Un concetto da capire molto bene per l’esame è quello di **invariante**.

Un’invariante è una proprietà che deve essere sempre vera se la struttura dati è corretta.

Per il nostro set implementato con lista linkata, le invarianti principali sono:

1. `size` deve essere uguale al numero reale di nodi della lista;
2. la lista non deve contenere duplicati;
3. se `size == 0`, allora `head == NULL`;
4. se `head == NULL`, allora `size == 0`;
5. tutti i nodi devono essere raggiungibili partendo da `head`.

Ogni funzione dell’ADT deve preservare queste invarianti.

Per esempio, `setAdd` deve:

* non inserire duplicati;
* aumentare `size` solo se inserisce davvero;
* collegare correttamente il nuovo nodo;
* non perdere il riferimento alla vecchia lista.

---

# 9. Implementazione di `mkSet`

```c
IntSetADT mkSet(void) {
    IntSetADT s = malloc(sizeof(*s));

    if (s == NULL) {
        return NULL;
    }

    s->head = NULL;
    s->size = 0;

    return s;
}
```

Cose importanti:

```c
malloc(sizeof(*s))
```

è preferibile a:

```c
malloc(sizeof(struct intSet))
```

perché se un giorno cambia il tipo puntato da `s`, il codice rimane corretto.

Dopo la creazione, il set è vuoto:

```c
s->head = NULL;
s->size = 0;
```

---

# 10. Implementazione di `dsSet`

```c
void dsSet(IntSetADT *sp) {
    if (sp == NULL || *sp == NULL) {
        return;
    }

    ListNodePtr current = (*sp)->head;

    while (current != NULL) {
        ListNodePtr temp = current;
        current = current->next;
        free(temp);
    }

    free(*sp);
    *sp = NULL;
}
```

Questa funzione riceve un `IntSetADT *`, cioè un puntatore al puntatore.

Perché?

Perché vuole modificare il puntatore originale del chiamante.

Esempio:

```c
IntSetADT s = mkSet();

dsSet(&s);
```

Dentro `dsSet`, `sp` punta alla variabile `s`.

Quindi:

```c
*sp = NULL;
```

modifica davvero `s` nel `main`.

Senza questa riga, nel `main` avremmo un dangling pointer: un puntatore che contiene ancora un indirizzo, ma quell’indirizzo non è più valido.

---

# 11. Implementazione di `setMember`

```c
_Bool setMember(const IntSetADT s, const int e) {
    if (s == NULL) {
        return 0;
    }

    ListNodePtr current = s->head;

    while (current != NULL) {
        if (current->data == e) {
            return 1;
        }

        current = current->next;
    }

    return 0;
}
```

Questa funzione visita la lista nodo per nodo.

Se trova l’elemento, restituisce `1`.

Se arriva alla fine della lista, restituisce `0`.

Complessità:

```text
O(n)
```

dove `n` è il numero di elementi nel set.

---

# 12. Implementazione di `setAdd`

La slide mostra il caso più importante: l’aggiunta di un elemento.

Versione corretta e commentata:

```c
_Bool setAdd(IntSetADT s, const int e) {
    if (s == NULL) {
        return 0;
    }

    // Prima controllo se l'elemento è già presente.
    ListNodePtr current = s->head;

    while (current != NULL) {
        if (current->data == e) {
            return 0; // duplicato: non inserisco
        }

        current = current->next;
    }

    // Se arrivo qui, l'elemento non è presente.
    ListNodePtr newNode = malloc(sizeof(*newNode));

    if (newNode == NULL) {
        return 0; // malloc fallita
    }

    // Inserimento in testa.
    newNode->data = e;
    newNode->next = s->head;
    s->head = newNode;

    s->size++;

    return 1;
}
```

Attenzione: nella slide il codice finale sembra restituire `s`, ma semanticamente la funzione dovrebbe restituire `1` se l’inserimento è avvenuto.

Il punto fondamentale è questo:

```c
newNode->next = s->head;
s->head = newNode;
```

Prima collego il nuovo nodo alla vecchia testa.

Poi aggiorno `head`.

Se invertissi l’ordine, rischierei di perdere la lista.

---

# 13. Perché non basta inserire in testa?

Per una lista semplice, inserire in testa sarebbe sufficiente:

```c
newNode->next = head;
head = newNode;
```

Ma per un set no.

Prima devo controllare che l’elemento non sia già presente.

Infatti questa implementazione sarebbe sbagliata:

```c
_Bool setAddWrong(IntSetADT s, const int e) {
    ListNodePtr newNode = malloc(sizeof(*newNode));

    newNode->data = e;
    newNode->next = s->head;
    s->head = newNode;

    s->size++;

    return 1;
}
```

Perché se chiamo:

```c
setAddWrong(s, 5);
setAddWrong(s, 5);
setAddWrong(s, 5);
```

ottengo una lista con tre nodi contenenti `5`.

Quindi non sto più rappresentando un insieme.

---

# 14. Implementazione di `isEmptySet`

```c
_Bool isEmptySet(const IntSetADT s) {
    if (s == NULL) {
        return 1;
    }

    return s->size == 0;
}
```

Se il set è `NULL`, possiamo considerarlo vuoto oppure gestirlo come errore.

La scelta dipende dalla specifica.

Per semplicità, qui restituiamo `1`.

---

# 15. Implementazione di `setSize`

```c
int setSize(const IntSetADT s) {
    if (s == NULL) {
        return 0;
    }

    return s->size;
}
```

Questa funzione è `O(1)` perché il campo `size` viene aggiornato a ogni inserimento e rimozione.

Se non avessimo `size`, dovremmo ogni volta contare i nodi:

```c
int count = 0;

while (current != NULL) {
    count++;
    current = current->next;
}
```

e sarebbe `O(n)`.

---

# 16. Implementazione di `setRemove`

Questa è una delle funzioni più importanti da saper scrivere.

Devo rimuovere un nodo dalla lista, gestendo almeno due casi:

1. il nodo da rimuovere è in testa;
2. il nodo da rimuovere è in mezzo o in fondo.

Versione completa:

```c
_Bool setRemove(IntSetADT s, const int e) {
    if (s == NULL || s->head == NULL) {
        return 0;
    }

    ListNodePtr current = s->head;
    ListNodePtr previous = NULL;

    while (current != NULL) {
        if (current->data == e) {
            if (previous == NULL) {
                // Caso 1: il nodo da rimuovere è la testa.
                s->head = current->next;
            } else {
                // Caso 2: il nodo è in mezzo o in fondo.
                previous->next = current->next;
            }

            free(current);
            s->size--;

            return 1;
        }

        previous = current;
        current = current->next;
    }

    return 0;
}
```

Da capire benissimo:

```c
previous->next = current->next;
```

Questa riga “salta” il nodo `current`.

Esempio:

```text
prima:

previous        current
   |              |
   v              v
 [ 3 | * ] ---> [ 5 | * ] ---> [ 8 | NULL ]

dopo:

previous
   |
   v
 [ 3 | * ] -----------------> [ 8 | NULL ]
```

Poi posso fare:

```c
free(current);
```

per liberare il nodo rimosso.

---

# 17. Implementazione di `setEquals`

```c
_Bool setEquals(const IntSetADT a, const IntSetADT b) {
    if (a == NULL || b == NULL) {
        return a == b;
    }

    if (a->size != b->size) {
        return 0;
    }

    ListNodePtr current = a->head;

    while (current != NULL) {
        if (!setMember(b, current->data)) {
            return 0;
        }

        current = current->next;
    }

    return 1;
}
```

Il controllo sulla dimensione è molto utile.

Se due set hanno dimensioni diverse, non possono essere uguali.

Se hanno la stessa dimensione, basta verificare che ogni elemento del primo sia contenuto nel secondo.

---

# 18. Implementazione di `subsetEq`

```c
_Bool subsetEq(const IntSetADT a, const IntSetADT b) {
    if (a == NULL || b == NULL) {
        return 0;
    }

    ListNodePtr current = a->head;

    while (current != NULL) {
        if (!setMember(b, current->data)) {
            return 0;
        }

        current = current->next;
    }

    return 1;
}
```

Questa funzione controlla:

```text
a ⊆ b
```

cioè se tutti gli elementi di `a` sono contenuti in `b`.

---

# 19. Implementazione di `subset`

```c
_Bool subset(const IntSetADT a, const IntSetADT b) {
    if (a == NULL || b == NULL) {
        return 0;
    }

    return a->size < b->size && subsetEq(a, b);
}
```

Per essere sottoinsieme stretto devono essere vere due condizioni:

1. `a` è incluso in `b`;
2. `a` ha meno elementi di `b`.

---

# 20. Implementazione di `setUnion`

```c
IntSetADT setUnion(const IntSetADT a, const IntSetADT b) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    IntSetADT result = mkSet();

    if (result == NULL) {
        return NULL;
    }

    ListNodePtr current = a->head;

    while (current != NULL) {
        setAdd(result, current->data);
        current = current->next;
    }

    current = b->head;

    while (current != NULL) {
        setAdd(result, current->data);
        current = current->next;
    }

    return result;
}
```

L’idea è semplice:

1. creo un nuovo set;
2. inserisco tutti gli elementi di `a`;
3. inserisco tutti gli elementi di `b`.

Non devo preoccuparmi dei duplicati, perché `setAdd` li gestisce già.

---

# 21. Implementazione di `setIntersection`

```c
IntSetADT setIntersection(const IntSetADT a, const IntSetADT b) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    IntSetADT result = mkSet();

    if (result == NULL) {
        return NULL;
    }

    ListNodePtr current = a->head;

    while (current != NULL) {
        if (setMember(b, current->data)) {
            setAdd(result, current->data);
        }

        current = current->next;
    }

    return result;
}
```

L’idea è:

* scorro gli elementi di `a`;
* se un elemento è anche in `b`, lo inserisco nel risultato.

---

# 22. Implementazione di `setSubtraction`

```c
IntSetADT setSubtraction(const IntSetADT a, const IntSetADT b) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    IntSetADT result = mkSet();

    if (result == NULL) {
        return NULL;
    }

    ListNodePtr current = a->head;

    while (current != NULL) {
        if (!setMember(b, current->data)) {
            setAdd(result, current->data);
        }

        current = current->next;
    }

    return result;
}
```

Questa funzione costruisce:

```text
a - b
```

cioè tutti gli elementi che sono in `a` ma non in `b`.

---

# 23. Complessità computazionale

Con una lista linkata non ordinata:

| Operazione        |                                     Complessità |
| ----------------- | ----------------------------------------------: |
| `mkSet`           |                                          `O(1)` |
| `dsSet`           |                                          `O(n)` |
| `setMember`       |                                          `O(n)` |
| `setAdd`          |                                          `O(n)` |
| `setRemove`       |                                          `O(n)` |
| `isEmptySet`      |                                          `O(1)` |
| `setSize`         |                                          `O(1)` |
| `setEquals`       |                       `O(n²)` nel caso semplice |
| `subsetEq`        |                                        `O(n*m)` |
| `setUnion`        | dipende da `setAdd`, può arrivare a `O((n+m)²)` |
| `setIntersection` |                                        `O(n*m)` |
| `setSubtraction`  |                                        `O(n*m)` |

Perché `setAdd` è `O(n)`?

Perché prima di inserire devo controllare se l’elemento è già presente.

---

# 24. Insieme ordinato

La slide introduce poi l’idea di **insieme ordinato**, o `SortedSet`.

Un insieme ordinato mantiene gli elementi in ordine crescente o decrescente.

Esempio:

```text
{1, 3, 5, 7, 9}
```

In questo caso, anche se matematicamente un insieme non ha ordine, l’implementazione interna sceglie di mantenere gli elementi ordinati per rendere più efficienti alcune operazioni.

---

# 25. Perché ordinare il set?

In una lista non ordinata, per verificare se un elemento è presente, devo potenzialmente scorrere tutta la lista.

Esempio:

```text
3 -> 10 -> 1 -> 8 -> NULL
```

Se cerco `7`, devo arrivare fino alla fine per sapere che non c’è.

In una lista ordinata:

```text
1 -> 3 -> 8 -> 10 -> NULL
```

se cerco `7`, appena arrivo a `8` posso fermarmi.

Perché?

Perché se la lista è ordinata in modo crescente, dopo `8` ci saranno solo elementi ancora più grandi.

Quindi `7` non può più comparire.

---

# 26. Operazioni aggiuntive del Sorted Set

Un `SortedSet` supporta tutte le operazioni di un normale set, più alcune operazioni specifiche.

---

## 26.1 Minimo

```c
Element ssetMin(Set);
```

Restituisce l’elemento minimo.

Se la lista è ordinata in ordine crescente, il minimo è in testa.

Quindi:

```c
return s->head->data;
```

---

## 26.2 Massimo

```c
Element ssetMax(Set);
```

Restituisce l’elemento massimo.

Se la lista è ordinata in ordine crescente e tengo anche un puntatore `tail`, il massimo è in coda.

Quindi:

```c
return s->tail->data;
```

---

## 26.3 Estrazione del minimo

```c
Element ssetExtractMin(Set);
```

Toglie e restituisce l’elemento minimo.

Se il minimo è in testa, basta rimuovere il primo nodo.

---

## 26.4 Estrazione del massimo

```c
Element ssetExtractMax(Set);
```

Toglie e restituisce l’elemento massimo.

Se tengo un puntatore `tail`, trovare il massimo è facile.

Però rimuovere la coda in una lista semplicemente linkata richiede comunque di trovare il nodo precedente alla coda.

Quindi non basta avere `tail` se non ho anche un puntatore al precedente.

---

# 27. Implementazione del Sorted Set con lista

La slide propone una struct di questo tipo:

```c
typedef struct listNode ListNode;
typedef ListNode *ListNodePtr;

struct listNode {
    int data;
    ListNodePtr next;
};

struct intSet {
    ListNodePtr head;
    ListNodePtr tail;
    int size;
};
```

Qui ci sono tre informazioni importanti:

```c
head
```

punta al primo nodo.

```c
tail
```

punta all’ultimo nodo.

```c
size
```

conta gli elementi.

Se la lista è ordinata in ordine crescente:

```text
head -> elemento minimo
tail -> elemento massimo
```

---

# 28. Invarianti del Sorted Set

Per un sorted set, le invarianti sono più forti:

1. `size` è uguale al numero di nodi;
2. non ci sono duplicati;
3. la lista è ordinata;
4. se `size == 0`, allora `head == NULL` e `tail == NULL`;
5. se `size == 1`, allora `head == tail`;
6. se `size > 1`, `head` punta al primo nodo e `tail` all’ultimo;
7. `tail->next == NULL`.

Queste invarianti sono fondamentali.

Se sbaglio ad aggiornare `tail`, il set può sembrare funzionare per alcune operazioni, ma rompersi in altre.

---

# 29. Esempio di `setAdd` in un Sorted Set

Supponiamo di voler inserire mantenendo ordine crescente.

```c
_Bool sortedSetAdd(IntSetADT s, const int e) {
    if (s == NULL) {
        return 0;
    }

    ListNodePtr previous = NULL;
    ListNodePtr current = s->head;

    while (current != NULL && current->data < e) {
        previous = current;
        current = current->next;
    }

    // Se current non è NULL e contiene e, allora e è già presente.
    if (current != NULL && current->data == e) {
        return 0;
    }

    ListNodePtr newNode = malloc(sizeof(*newNode));

    if (newNode == NULL) {
        return 0;
    }

    newNode->data = e;
    newNode->next = current;

    if (previous == NULL) {
        // Inserimento in testa.
        s->head = newNode;
    } else {
        // Inserimento dopo previous.
        previous->next = newNode;
    }

    if (current == NULL) {
        // Inserimento in coda.
        s->tail = newNode;
    }

    if (s->size == 0) {
        // Se era vuoto, head e tail devono coincidere.
        s->tail = newNode;
    }

    s->size++;

    return 1;
}
```

Da capire bene:

```c
while (current != NULL && current->data < e)
```

Mi fermo quando:

* arrivo alla fine;
* oppure trovo un elemento maggiore o uguale a `e`.

Se trovo un elemento uguale, non inserisco.

Se trovo un elemento maggiore, inserisco prima di lui.

---

# 30. Esempio pratico

Supponiamo di avere:

```text
2 -> 5 -> 9 -> NULL
```

e voglio inserire `7`.

Scorro:

```text
2 < 7  sì
5 < 7  sì
9 < 7  no
```

Mi fermo su `9`.

Inserisco `7` prima di `9`.

Risultato:

```text
2 -> 5 -> 7 -> 9 -> NULL
```

---

# 31. Attenzione a `head` e `tail`

Caso 1: inserimento in testa.

```text
prima:
5 -> 8 -> 10

inserisco 3

dopo:
3 -> 5 -> 8 -> 10
```

Devo aggiornare:

```c
s->head = newNode;
```

Caso 2: inserimento in coda.

```text
prima:
3 -> 5 -> 8

inserisco 10

dopo:
3 -> 5 -> 8 -> 10
```

Devo aggiornare:

```c
s->tail = newNode;
```

Caso 3: inserimento in lista vuota.

```text
prima:
NULL

inserisco 3

dopo:
3 -> NULL
```

Devo avere:

```c
s->head = newNode;
s->tail = newNode;
```

---

# 32. Cose da saper spiegare all’esame

Per puntare al 30 e lode, bisogna saper spiegare bene questi concetti.

## Domanda: perché `setAdd` deve cercare prima di inserire?

Perché un set non può contenere duplicati.

Se inserissi direttamente in testa, otterrei una lista, non un insieme.

---

## Domanda: perché conviene tenere il campo `size`?

Perché rende `setSize` e `isEmptySet` operazioni `O(1)`.

Senza `size`, ogni volta dovrei scorrere tutta la lista.

---

## Domanda: perché `dsSet` riceve `Set *`?

Perché deve modificare il puntatore originale del chiamante.

Dopo aver liberato la memoria, è buona pratica mettere il puntatore a `NULL`.

---

## Domanda: che differenza c’è tra set e sorted set?

Un set non garantisce ordine.

Un sorted set mantiene gli elementi ordinati internamente.

Questo può migliorare il caso medio di alcune ricerche, perché posso fermarmi appena incontro un elemento più grande di quello cercato.

---

## Domanda: il caso peggiore migliora con un sorted set?

Non necessariamente.

Se l’elemento cercato è più grande di tutti, o se devo inserirlo in fondo, devo comunque scorrere tutta la lista.

Quindi il caso peggiore rimane `O(n)`.

---

## Domanda: perché in un sorted set può essere utile `tail`?

Perché consente di accedere rapidamente all’elemento massimo.

Se la lista è ordinata in ordine crescente:

```text
head = minimo
tail = massimo
```

Quindi `ssetMax` può essere `O(1)`.

---

# 33. Esercizi consigliati da riscrivere

Per prendere confidenza, conviene riscrivere a mano queste funzioni.

## Esercizio 1 — `setMember`

Scrivere una funzione che controlla se un elemento è presente.

```c
_Bool setMember(const IntSetADT s, const int e);
```

Obiettivo:

* saper scorrere una lista;
* saper usare `current = current->next`;
* saper restituire subito quando trovo l’elemento.

---

## Esercizio 2 — `setAdd`

Scrivere una funzione che aggiunge un elemento solo se non è già presente.

```c
_Bool setAdd(IntSetADT s, const int e);
```

Obiettivo:

* controllare duplicati;
* usare `malloc`;
* inserire in testa;
* aggiornare `size`.

---

## Esercizio 3 — `setRemove`

Scrivere una funzione che rimuove un elemento dal set.

```c
_Bool setRemove(IntSetADT s, const int e);
```

Obiettivo:

* gestire rimozione in testa;
* gestire rimozione in mezzo;
* usare `previous` e `current`;
* fare `free` del nodo rimosso;
* aggiornare `size`.

---

## Esercizio 4 — `setEquals`

Scrivere una funzione che controlla se due set sono uguali.

```c
_Bool setEquals(const IntSetADT a, const IntSetADT b);
```

Obiettivo:

* usare `size` per ottimizzare;
* usare `setMember`;
* ricordare che l’ordine non conta.

---

## Esercizio 5 — `setUnion`

Scrivere una funzione che restituisce l’unione di due set.

```c
IntSetADT setUnion(const IntSetADT a, const IntSetADT b);
```

Obiettivo:

* creare un nuovo set;
* inserire elementi da due set;
* sfruttare `setAdd` per evitare duplicati.

---

## Esercizio 6 — `sortedSetAdd`

Scrivere una funzione che inserisce un elemento mantenendo la lista ordinata.

```c
_Bool sortedSetAdd(IntSetADT s, const int e);
```

Obiettivo:

* capire il ruolo di `previous`;
* capire il ruolo di `current`;
* fermarsi nel punto giusto;
* aggiornare correttamente `head` e `tail`.

---

# 34. Mini cheat sheet finale

```c
typedef struct intSet *IntSetADT;
```

Crea un tipo opaco.

---

```c
struct intSet {
    ListNodePtr head;
    int size;
};
```

Implementazione con lista non ordinata.

---

```c
struct intSet {
    ListNodePtr head;
    ListNodePtr tail;
    int size;
};
```

Implementazione con lista ordinata e puntatore alla coda.

---

```c
setAdd(s, e)
```

Aggiunge `e` solo se non è già presente.

---

```c
setRemove(s, e)
```

Rimuove `e` se presente.

---

```c
setMember(s, e)
```

Controlla se `e` appartiene al set.

---

```c
setSize(s)
```

Restituisce il numero di elementi.

---

```c
setEquals(a, b)
```

Controlla se due set hanno gli stessi elementi.

---

```c
subsetEq(a, b)
```

Controlla se `a ⊆ b`.

---

```c
subset(a, b)
```

Controlla se `a ⊂ b`.

---

```c
setUnion(a, b)
```

Restituisce `a ∪ b`.

---

```c
setIntersection(a, b)
```

Restituisce `a ∩ b`.

---

```c
setSubtraction(a, b)
```

Restituisce `a - b`.

---

# 35. Cose da non sbagliare

## Errore 1 — Inserire senza controllare duplicati

Sbagliato:

```c
newNode->next = s->head;
s->head = newNode;
```

se prima non ho controllato se l’elemento era già presente.

---

## Errore 2 — Dimenticare di aggiornare `size`

Se inserisco un elemento devo fare:

```c
s->size++;
```

Se rimuovo un elemento devo fare:

```c
s->size--;
```

Solo quando l’operazione avviene davvero.

---

## Errore 3 — Perdere la lista durante l’inserimento

Ordine corretto:

```c
newNode->next = s->head;
s->head = newNode;
```

Non devo sovrascrivere `head` prima di aver collegato il nuovo nodo alla vecchia lista.

---

## Errore 4 — Fare `free` prima di salvare il nodo successivo

Sbagliato:

```c
free(current);
current = current->next;
```

Dopo `free(current)`, non posso più usare `current`.

Corretto:

```c
ListNodePtr temp = current;
current = current->next;
free(temp);
```

---

## Errore 5 — Confondere `Set` e `Set *`

Se ho:

```c
void dsSet(IntSetADT *sp)
```

allora dentro la funzione:

```c
*sp
```

è il set vero e proprio.

Quindi:

```c
(*sp)->head
```

accede alla testa del set.

La parentesi è necessaria perché `->` ha precedenza maggiore di `*`.

---

# 36. Riassunto da esame

Un insieme è una collezione non ordinata di elementi senza duplicati.

In C possiamo rappresentarlo come ADT usando un tipo opaco, per esempio:

```c
typedef struct intSet *IntSetADT;
```

L’utente conosce solo le operazioni pubbliche, mentre l’implementazione interna può usare una lista linkata.

Con una lista linkata non ordinata, l’inserimento richiede prima una ricerca per evitare duplicati, quindi `setAdd` è `O(n)`.

Il campo `size` permette di ottenere la dimensione del set in `O(1)`.

Le operazioni insiemistiche principali sono unione, intersezione, differenza, uguaglianza e inclusione.

Un sorted set mantiene gli elementi ordinati internamente. Questo può migliorare il caso medio della ricerca, perché posso fermarmi appena incontro un elemento maggiore di quello cercato. Tuttavia, il caso peggiore resta `O(n)`.

Se nel sorted set tengo anche `tail`, posso accedere rapidamente all’elemento massimo.

La cosa più importante è preservare sempre le invarianti della struttura dati: niente duplicati, `size` coerente, lista ben collegata e, nel caso del sorted set, ordine corretto degli elementi.
