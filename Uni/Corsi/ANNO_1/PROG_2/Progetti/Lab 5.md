# IntSortedSetADT con lista linkata ordinata

Questa implementazione rappresenta un **insieme ordinato di interi** usando una **lista linkata semplice**.

La struttura dati è questa:

```c
typedef struct listNode ListNode, *ListNodePtr;

struct listNode {
   int elem;
   ListNodePtr next;
};

struct intSortedSet {
    ListNodePtr first;
    ListNodePtr last;
    int size;
};
```

## Invarianti fondamentali

Per evitare segmentation fault e comportamenti strani, bisogna mantenere sempre coerenti questi tre campi:

```c
ss->first
ss->last
ss->size
```

In particolare:

- se l'insieme è vuoto:
    
    ```c
    ss->first == NULL
    ss->last == NULL
    ss->size == 0
    ```
    
- se l'insieme contiene un solo elemento:
    
    ```c
    ss->first == ss->last
    ss->size == 1
    ```
    
- se l'insieme contiene più elementi:
    
    ```c
    ss->first
    ```
    
    punta al nodo con elemento minimo, mentre:
    
    ```c
    ss->last
    ```
    
    punta al nodo con elemento massimo.
    

La lista deve essere sempre ordinata in senso crescente:

```c
1 -> 4 -> 7 -> 9 -> NULL
```

---

# Funzione `sset_remove`

Rimuove un elemento dall'insieme.

Restituisce:

- `true` se l'elemento era presente ed è stato rimosso
    
- `false` se l'elemento non era presente oppure se l'insieme è `NULL`
    

```c
_Bool sset_remove(IntSortedSetADT ss, const int elem) {
    if (ss == NULL) {
        return false;
    }

    ListNodePtr prev = NULL;
    ListNodePtr curr = ss->first;

    /*
     * Scorriamo la lista finché troviamo elementi minori di elem.
     *
     * Siccome la lista è ordinata, possiamo fermarci appena troviamo:
     * - curr == NULL
     * - oppure curr->elem >= elem
     *
     * Alla fine del ciclo:
     * - prev punta al nodo precedente a curr
     * - curr punta al primo nodo con valore >= elem
     */
    while (curr != NULL && curr->elem < elem) {
        prev = curr;
        curr = curr->next;
    }

    /*
     * Se curr è NULL, siamo arrivati alla fine senza trovare elem.
     *
     * Se curr->elem è diverso da elem, allora elem non esiste nella lista.
     *
     * Esempio:
     * lista: 1 -> 4 -> 8
     * elem:  6
     *
     * Il ciclo si ferma su 8.
     * Siccome 8 != 6, allora 6 non è presente.
     */
    if (curr == NULL || curr->elem != elem) {
        return false;
    }

    /*
     * Caso 1: dobbiamo rimuovere il primo nodo.
     *
     * Questo succede quando prev == NULL.
     *
     * Esempio:
     * lista: 3 -> 5 -> 7
     * remove(3)
     *
     * Il nuovo first diventa il nodo dopo curr.
     */
    if (prev == NULL) {
        ss->first = curr->next;
    }

    /*
     * Caso 2: dobbiamo rimuovere un nodo in mezzo o in fondo.
     *
     * In questo caso prev deve saltare curr.
     *
     * Prima:
     * prev -> curr -> curr->next
     *
     * Dopo:
     * prev -> curr->next
     */
    else {
        prev->next = curr->next;
    }

    /*
     * Se curr era anche l'ultimo nodo, allora bisogna aggiornare last.
     *
     * Dopo la rimozione, il nuovo ultimo nodo diventa prev.
     *
     * Se stavamo rimuovendo l'unico nodo della lista, prev è NULL.
     */
    if (curr == ss->last) {
        ss->last = prev;
    }

    /*
     * Ora curr non è più collegato alla lista.
     * Possiamo liberare la memoria.
     */
    free(curr);

    /*
     * Abbiamo eliminato un nodo, quindi la size diminuisce.
     */
    ss->size--;

    /*
     * Se dopo la rimozione l'insieme è vuoto, rendiamo esplicita
     * la coerenza della struttura.
     */
    if (ss->size == 0) {
        ss->first = NULL;
        ss->last = NULL;
    }

    return true;
}
```

---

# Funzione `sset_member`

Controlla se un elemento appartiene all'insieme.

Restituisce:

- `true` se l'elemento è presente
    
- `false` se l'elemento non è presente oppure se l'insieme è `NULL`
    

```c
_Bool sset_member(const IntSortedSetADT ss, const int elem) {
    if (ss == NULL) {
        return false;
    }

    ListNodePtr curr = ss->first;

    /*
     * Siccome la lista è ordinata, non serve arrivare sempre alla fine.
     *
     * Scorriamo solo finché curr->elem < elem.
     *
     * Se troviamo un elemento maggiore di elem, possiamo fermarci:
     * elem non può più comparire dopo, perché la lista è ordinata.
     */
    while (curr != NULL && curr->elem < elem) {
        curr = curr->next;
    }

    /*
     * Alla fine:
     * - se curr è NULL, elem non c'è
     * - se curr->elem == elem, elem c'è
     * - se curr->elem > elem, elem non c'è
     */
    return curr != NULL && curr->elem == elem;
}
```

---

# Funzione `isEmptySSet`

Controlla se l'insieme è vuoto.

Restituisce:

- `true` se l'insieme è vuoto
    
- `false` se l'insieme non è vuoto oppure se l'insieme è `NULL`
    

```c
_Bool isEmptySSet(const IntSortedSetADT ss) {
    if (ss == NULL) {
        return false;
    }

    return ss->size == 0;
}
```

---

# Funzione `sset_size`

Restituisce il numero di elementi presenti nell'insieme.

Restituisce:

- `ss->size` se l'insieme esiste
    
- `-1` se l'insieme è `NULL`
    

```c
int sset_size(const IntSortedSetADT ss) {
    if (ss == NULL) {
        return -1;
    }

    return ss->size;
}
```

---

# Funzione `sset_extract`

Toglie e restituisce un elemento dall'insieme.

In questa implementazione viene estratto il primo elemento, cioè il minimo.

La specifica dice "un elemento a caso", quindi va bene estrarre il primo.

Restituisce:

- `true` se l'estrazione è riuscita
    
- `false` se l'insieme è `NULL`, se `ptr` è `NULL`, oppure se l'insieme è vuoto
    

```c
_Bool sset_extract(IntSortedSetADT ss, int *ptr) {
    if (ss == NULL || ptr == NULL || ss->first == NULL) {
        return false;
    }

    /*
     * Salviamo il primo nodo.
     * È il nodo che verrà rimosso.
     */
    ListNodePtr node = ss->first;

    /*
     * Copiamo il valore del nodo dentro la variabile puntata da ptr.
     *
     * Esempio:
     * int x;
     * sset_extract(ss, &x);
     *
     * Qui dentro:
     * *ptr = valore_estratto;
     *
     * Quindi fuori dalla funzione x conterrà quel valore.
     */
    *ptr = node->elem;

    /*
     * Il nuovo first diventa il nodo successivo.
     */
    ss->first = node->next;

    /*
     * Se dopo aver tolto il primo nodo la lista è vuota,
     * allora anche last deve diventare NULL.
     */
    if (ss->first == NULL) {
        ss->last = NULL;
    }

    /*
     * Liberiamo il vecchio primo nodo.
     */
    free(node);

    /*
     * Abbiamo rimosso un elemento.
     */
    ss->size--;

    return true;
}
```

---

# Funzione `sset_equals`

Controlla se due insiemi sono uguali.

Due insiemi sono uguali se hanno:

- stessa dimensione
    
- stessi elementi
    
- nello stesso ordine
    

Dato che gli insiemi sono ordinati, basta confrontare i nodi uno a uno.

```c
_Bool sset_equals(const IntSortedSetADT s1, const IntSortedSetADT s2) {
    if (s1 == NULL || s2 == NULL) {
        return false;
    }

    /*
     * Se le dimensioni sono diverse, gli insiemi non possono essere uguali.
     */
    if (s1->size != s2->size) {
        return false;
    }

    ListNodePtr curr1 = s1->first;
    ListNodePtr curr2 = s2->first;

    /*
     * Scorriamo entrambe le liste in parallelo.
     */
    while (curr1 != NULL && curr2 != NULL) {
        /*
         * Se troviamo due elementi diversi nella stessa posizione,
         * gli insiemi non sono uguali.
         */
        if (curr1->elem != curr2->elem) {
            return false;
        }

        curr1 = curr1->next;
        curr2 = curr2->next;
    }

    /*
     * Se entrambe le liste sono finite, allora sono uguali.
     *
     * In teoria, avendo già controllato la size, basterebbe return true.
     * Questo controllo però rende la funzione più robusta.
     */
    return curr1 == NULL && curr2 == NULL;
}
```

---

# Funzione `sset_subseteq`

Controlla se `s1` è sottoinsieme di `s2`.

In simboli:

```text
s1 ⊆ s2
```

Vuol dire che **ogni elemento di `s1` deve stare anche in `s2`**.

```c
_Bool sset_subseteq(const IntSortedSetADT s1, const IntSortedSetADT s2) {
    if (s1 == NULL || s2 == NULL) {
        return false;
    }

    /*
     * Se s1 ha più elementi di s2, s1 non può essere sottoinsieme di s2.
     */
    if (s1->size > s2->size) {
        return false;
    }

    ListNodePtr curr1 = s1->first;
    ListNodePtr curr2 = s2->first;

    /*
     * Scorriamo entrambe le liste sfruttando l'ordinamento.
     *
     * Esempio:
     *
     * s1: 2 -> 5
     * s2: 1 -> 2 -> 3 -> 5 -> 8
     *
     * curr1 cerca i suoi elementi dentro s2.
     */
    while (curr1 != NULL && curr2 != NULL) {
        /*
         * Caso 1:
         * Gli elementi sono uguali.
         *
         * L'elemento di s1 è stato trovato in s2.
         * Possiamo avanzare entrambi.
         */
        if (curr1->elem == curr2->elem) {
            curr1 = curr1->next;
            curr2 = curr2->next;
        }

        /*
         * Caso 2:
         * curr2->elem è più piccolo.
         *
         * Vuol dire che l'elemento corrente di s2 non ci interessa.
         * Avanziamo solo curr2.
         */
        else if (curr1->elem > curr2->elem) {
            curr2 = curr2->next;
        }

        /*
         * Caso 3:
         * curr1->elem è più piccolo di curr2->elem.
         *
         * Questo significa che curr1->elem non può essere trovato più avanti
         * in s2, perché s2 è ordinato.
         *
         * Quindi s1 non è sottoinsieme di s2.
         */
        else {
            return false;
        }
    }

    /*
     * Se curr1 è NULL, abbiamo trovato tutti gli elementi di s1 in s2.
     *
     * Se curr1 non è NULL, significa che qualche elemento di s1 manca in s2.
     */
    return curr1 == NULL;
}
```

---

# Funzione `sset_subset`

Controlla se `s1` è sottoinsieme stretto di `s2`.

In simboli:

```text
s1 ⊂ s2
```

Vuol dire che:

```text
s1 ⊆ s2
```

ma `s1` e `s2` non sono uguali.

Quindi `s1` deve avere meno elementi di `s2`.

```c
_Bool sset_subset(const IntSortedSetADT s1, const IntSortedSetADT s2) {
    if (s1 == NULL || s2 == NULL) {
        return false;
    }

    /*
     * s1 è sottoinsieme stretto di s2 se:
     *
     * 1. s1 ha meno elementi di s2
     * 2. s1 è sottoinsieme di s2
     */
    return s1->size < s2->size && sset_subseteq(s1, s2);
}
```

---

# Funzione `sset_union`

Calcola l'unione tra due insiemi.

In simboli:

```text
s1 ∪ s2
```

L'unione contiene tutti gli elementi che stanno in `s1`, in `s2`, oppure in entrambi.

Esempio:

```text
s1 = {1, 3, 5}
s2 = {2, 3, 4}

s1 ∪ s2 = {1, 2, 3, 4, 5}
```

Dato che entrambe le liste sono ordinate, si possono scorrere in parallelo.

```c
IntSortedSetADT sset_union(const IntSortedSetADT s1, const IntSortedSetADT s2) {
    if (s1 == NULL || s2 == NULL) {
        return NULL;
    }

    /*
     * Creiamo l'insieme risultato.
     */
    IntSortedSetADT result = mkSSet();

    if (result == NULL) {
        return NULL;
    }

    ListNodePtr curr1 = s1->first;
    ListNodePtr curr2 = s2->first;

    /*
     * Finché entrambe le liste hanno elementi, confrontiamo curr1 e curr2.
     */
    while (curr1 != NULL && curr2 != NULL) {
        int elem;

        /*
         * Se l'elemento di s1 è più piccolo, va inserito lui.
         */
        if (curr1->elem < curr2->elem) {
            elem = curr1->elem;
            curr1 = curr1->next;
        }

        /*
         * Se l'elemento di s2 è più piccolo, va inserito lui.
         */
        else if (curr2->elem < curr1->elem) {
            elem = curr2->elem;
            curr2 = curr2->next;
        }

        /*
         * Se sono uguali, inseriamo l'elemento una volta sola.
         *
         * Questo è fondamentale perché un insieme non può contenere duplicati.
         */
        else {
            elem = curr1->elem;
            curr1 = curr1->next;
            curr2 = curr2->next;
        }

        /*
         * Creiamo un nuovo nodo da aggiungere in fondo a result.
         */
        ListNodePtr newNode = malloc(sizeof(*newNode));

        if (newNode == NULL) {
            dsSSet(&result);
            return NULL;
        }

        newNode->elem = elem;
        newNode->next = NULL;

        /*
         * Se result è vuoto, il nuovo nodo diventa sia first sia last.
         */
        if (result->first == NULL) {
            result->first = newNode;
            result->last = newNode;
        }

        /*
         * Altrimenti lo attacchiamo dopo last e aggiorniamo last.
         */
        else {
            result->last->next = newNode;
            result->last = newNode;
        }

        result->size++;
    }

    /*
     * Se s1 ha ancora elementi rimasti, li copiamo tutti in result.
     */
    while (curr1 != NULL) {
        ListNodePtr newNode = malloc(sizeof(*newNode));

        if (newNode == NULL) {
            dsSSet(&result);
            return NULL;
        }

        newNode->elem = curr1->elem;
        newNode->next = NULL;

        if (result->first == NULL) {
            result->first = newNode;
            result->last = newNode;
        } else {
            result->last->next = newNode;
            result->last = newNode;
        }

        result->size++;
        curr1 = curr1->next;
    }

    /*
     * Se s2 ha ancora elementi rimasti, li copiamo tutti in result.
     */
    while (curr2 != NULL) {
        ListNodePtr newNode = malloc(sizeof(*newNode));

        if (newNode == NULL) {
            dsSSet(&result);
            return NULL;
        }

        newNode->elem = curr2->elem;
        newNode->next = NULL;

        if (result->first == NULL) {
            result->first = newNode;
            result->last = newNode;
        } else {
            result->last->next = newNode;
            result->last = newNode;
        }

        result->size++;
        curr2 = curr2->next;
    }

    return result;
}
```

---

# Funzione `sset_intersection`

Calcola l'intersezione tra due insiemi.

In simboli:

```text
s1 ∩ s2
```

L'intersezione contiene solo gli elementi presenti in entrambi gli insiemi.

Esempio:

```text
s1 = {1, 3, 5}
s2 = {2, 3, 5, 7}

s1 ∩ s2 = {3, 5}
```

```c
IntSortedSetADT sset_intersection(const IntSortedSetADT s1, const IntSortedSetADT s2) {
    if (s1 == NULL || s2 == NULL) {
        return NULL;
    }

    IntSortedSetADT result = mkSSet();

    if (result == NULL) {
        return NULL;
    }

    ListNodePtr curr1 = s1->first;
    ListNodePtr curr2 = s2->first;

    /*
     * Scorriamo entrambe le liste in parallelo.
     */
    while (curr1 != NULL && curr2 != NULL) {
        /*
         * Se curr1 è più piccolo, lo scartiamo avanzando curr1.
         */
        if (curr1->elem < curr2->elem) {
            curr1 = curr1->next;
        }

        /*
         * Se curr2 è più piccolo, lo scartiamo avanzando curr2.
         */
        else if (curr2->elem < curr1->elem) {
            curr2 = curr2->next;
        }

        /*
         * Se sono uguali, l'elemento è presente in entrambi.
         * Quindi va inserito nel risultato.
         */
        else {
            ListNodePtr newNode = malloc(sizeof(*newNode));

            if (newNode == NULL) {
                dsSSet(&result);
                return NULL;
            }

            newNode->elem = curr1->elem;
            newNode->next = NULL;

            if (result->first == NULL) {
                result->first = newNode;
                result->last = newNode;
            } else {
                result->last->next = newNode;
                result->last = newNode;
            }

            result->size++;

            curr1 = curr1->next;
            curr2 = curr2->next;
        }
    }

    return result;
}
```

---

# Funzione `sset_subtraction`

Calcola la sottrazione tra insiemi.

In simboli:

```text
s1 - s2
```

Contiene gli elementi che stanno in `s1` ma non in `s2`.

Esempio:

```text
s1 = {1, 2, 3, 4, 5}
s2 = {2, 4}

s1 - s2 = {1, 3, 5}
```

```c
IntSortedSetADT sset_subtraction(const IntSortedSetADT s1, const IntSortedSetADT s2) {
    if (s1 == NULL || s2 == NULL) {
        return NULL;
    }

    IntSortedSetADT result = mkSSet();

    if (result == NULL) {
        return NULL;
    }

    ListNodePtr curr1 = s1->first;
    ListNodePtr curr2 = s2->first;

    /*
     * Scorriamo tutti gli elementi di s1.
     *
     * Per ogni elemento di s1, controlliamo se compare anche in s2.
     */
    while (curr1 != NULL) {
        /*
         * Portiamo curr2 avanti finché curr2->elem è minore di curr1->elem.
         *
         * Gli elementi più piccoli di curr1->elem non possono più servirci.
         */
        while (curr2 != NULL && curr2->elem < curr1->elem) {
            curr2 = curr2->next;
        }

        /*
         * Se curr2 è NULL, significa che s2 è finito.
         * Quindi tutti gli elementi rimanenti di s1 non sono in s2.
         *
         * Se curr2->elem != curr1->elem, allora l'elemento di s1
         * non è presente in s2.
         *
         * In entrambi i casi, curr1->elem va copiato nel risultato.
         */
        if (curr2 == NULL || curr2->elem != curr1->elem) {
            ListNodePtr newNode = malloc(sizeof(*newNode));

            if (newNode == NULL) {
                dsSSet(&result);
                return NULL;
            }

            newNode->elem = curr1->elem;
            newNode->next = NULL;

            if (result->first == NULL) {
                result->first = newNode;
                result->last = newNode;
            } else {
                result->last->next = newNode;
                result->last = newNode;
            }

            result->size++;
        }

        curr1 = curr1->next;
    }

    return result;
}
```

---

# Funzione `sset_min`

Restituisce il minimo elemento dell'insieme senza rimuoverlo.

Poiché la lista è ordinata, il minimo è sempre in:

```c
ss->first
```

```c
_Bool sset_min(const IntSortedSetADT ss, int *ptr) {
    if (ss == NULL || ptr == NULL || ss->first == NULL) {
        return false;
    }

    /*
     * Il minimo è il primo elemento della lista.
     */
    *ptr = ss->first->elem;

    return true;
}
```

---

# Funzione `sset_max`

Restituisce il massimo elemento dell'insieme senza rimuoverlo.

Poiché manteniamo aggiornato `last`, il massimo è sempre in:

```c
ss->last
```

```c
_Bool sset_max(const IntSortedSetADT ss, int *ptr) {
    if (ss == NULL || ptr == NULL || ss->last == NULL) {
        return false;
    }

    /*
     * Il massimo è l'ultimo elemento della lista.
     */
    *ptr = ss->last->elem;

    return true;
}
```

---

# Funzione `sset_extractMin`

Toglie e restituisce il minimo elemento dell'insieme.

È molto simile a `sset_extract`, perché il minimo è il primo nodo.

```c
_Bool sset_extractMin(IntSortedSetADT ss, int *ptr) {
    if (ss == NULL || ptr == NULL || ss->first == NULL) {
        return false;
    }

    /*
     * Il minimo è il primo nodo.
     */
    ListNodePtr node = ss->first;

    /*
     * Salviamo il valore da restituire.
     */
    *ptr = node->elem;

    /*
     * Il nuovo first diventa il nodo successivo.
     */
    ss->first = node->next;

    /*
     * Se la lista è diventata vuota, anche last deve diventare NULL.
     */
    if (ss->first == NULL) {
        ss->last = NULL;
    }

    free(node);
    ss->size--;

    return true;
}
```

---

# Funzione `sset_extractMax`

Toglie e restituisce il massimo elemento dell'insieme.

Il massimo è `ss->last`, però siccome la lista è semplicemente linkata, non possiamo andare direttamente al nodo precedente.

Per rimuovere l'ultimo nodo dobbiamo trovare il penultimo.

```c
_Bool sset_extractMax(IntSortedSetADT ss, int *ptr) {
    if (ss == NULL || ptr == NULL || ss->first == NULL) {
        return false;
    }

    ListNodePtr prev = NULL;
    ListNodePtr curr = ss->first;

    /*
     * Scorriamo fino all'ultimo nodo.
     *
     * Alla fine:
     * - curr punta all'ultimo nodo
     * - prev punta al penultimo nodo
     */
    while (curr->next != NULL) {
        prev = curr;
        curr = curr->next;
    }

    /*
     * curr ora è il nodo massimo.
     */
    *ptr = curr->elem;

    /*
     * Caso 1:
     * La lista aveva un solo nodo.
     *
     * In questo caso prev è ancora NULL.
     * Dopo l'estrazione, la lista diventa vuota.
     */
    if (prev == NULL) {
        ss->first = NULL;
        ss->last = NULL;
    }

    /*
     * Caso 2:
     * La lista aveva almeno due nodi.
     *
     * Il penultimo nodo diventa il nuovo ultimo.
     */
    else {
        prev->next = NULL;
        ss->last = prev;
    }

    free(curr);
    ss->size--;

    return true;
}
```

---

# Riassunto delle complessità

Indicando con:

```text
n = dimensione del primo insieme
m = dimensione del secondo insieme
```

abbiamo:

|Funzione|Complessità|Motivo|
|---|--:|---|
|`sset_remove`|O(n)|nel caso peggiore cerca l'elemento da rimuovere|
|`sset_member`|O(n)|nel caso peggiore cerca l'elemento|
|`isEmptySSet`|O(1)|legge solo `size`|
|`sset_size`|O(1)|legge solo `size`|
|`sset_extract`|O(1)|rimuove il primo nodo|
|`sset_equals`|O(n)|confronta i nodi uno a uno|
|`sset_subseteq`|O(n + m)|scorre le due liste in parallelo|
|`sset_subset`|O(n + m)|usa `sset_subseteq`|
|`sset_union`|O(n + m)|merge ordinato delle due liste|
|`sset_intersection`|O(n + m)|scorre le due liste in parallelo|
|`sset_subtraction`|O(n + m)|scorre le due liste in parallelo|
|`sset_min`|O(1)|il minimo è `first`|
|`sset_max`|O(1)|il massimo è `last`|
|`sset_extractMin`|O(1)|rimuove `first`|
|`sset_extractMax`|O(n)|deve trovare il penultimo nodo|

---

# Idee chiave da ricordare

## 1. `first` serve per accedere al minimo

Dato che la lista è ordinata:

```c
ss->first->elem
```

è sempre il valore minimo.

---

## 2. `last` serve per accedere velocemente al massimo

Dato che aggiorniamo sempre `last`, possiamo fare:

```c
ss->last->elem
```

per ottenere il massimo in O(1).

---

## 3. Rimuovere l'ultimo nodo costa O(n)

Anche se conosciamo `last`, la lista è semplicemente linkata.

Quindi, per staccare l'ultimo nodo, dobbiamo trovare il penultimo:

```text
1 -> 4 -> 7 -> 9 -> NULL
          ^
          penultimo
```

Serve scorrere la lista.

---

## 4. Nelle funzioni `union`, `intersection`, `subtraction` conviene inserire in fondo

Dato che gli elementi vengono prodotti già in ordine crescente, possiamo aggiungerli direttamente in fondo al risultato.

Questo mantiene la lista ordinata.

Schema generale:

```c
if (result->first == NULL) {
    result->first = newNode;
    result->last = newNode;
} else {
    result->last->next = newNode;
    result->last = newNode;
}

result->size++;
```

---

## 5. Quando si rimuove un nodo bisogna aggiornare sempre `size`

Ogni volta che elimini un nodo:

```c
ss->size--;
```

Ogni volta che aggiungi un nodo:

```c
ss->size++;
```

Se `size` non è coerente, i test possono fallire anche se la lista sembra corretta.

---

## 6. Quando la lista diventa vuota, `first` e `last` devono essere entrambi `NULL`

Dopo una rimozione, se la lista è vuota:

```c
ss->first = NULL;
ss->last = NULL;
```

Questo evita dangling pointer e segmentation fault nelle funzioni successive.