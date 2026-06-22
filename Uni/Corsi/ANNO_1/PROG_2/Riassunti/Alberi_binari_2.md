# Alberi Binari di Ricerca — Operazioni iterative e ricorsive

> Appunti da studiare come se l’obiettivo fosse prendere **30 e lode**.
> Tema centrale: capire come funzionano le operazioni sugli **Alberi Binari di Ricerca**, sia in versione **iterativa** sia in versione **ricorsiva**, con particolare attenzione a puntatori, `malloc`, `free`, complessità e bilanciamento.

---

## 1. Contesto: cosa sono gli ARB / BST

Un **Albero Binario di Ricerca**, spesso indicato come **ARB** in italiano o **BST** in inglese, è un albero binario in cui ogni nodo rispetta una proprietà fondamentale:

```text
Tutti i valori nel sottoalbero sinistro sono minori del valore del nodo.
Tutti i valori nel sottoalbero destro sono maggiori del valore del nodo.
```

Nel corso viene spesso espressa come:

```text
sottoalbero sinistro <= nodo <= sottoalbero destro
```

Tuttavia, nelle implementazioni viste nelle slide, quando un valore è già presente, **non viene inserito una seconda volta**. Quindi, nella pratica, stiamo lavorando con alberi senza duplicati.

Esempio:

```text
        47
       /  \
     25    93
    /  \   /
  17   31 77
 /       \ /
11       43 65
```

La cosa importantissima è che questa proprietà permette di cercare un valore senza visitare tutto l’albero.

Se cerco `43`:

```text
43 < 47  -> vado a sinistra
43 > 25  -> vado a destra
43 > 31  -> vado a destra
43 == 43 -> trovato
```

Se cerco `69`:

```text
69 > 47  -> destra
69 < 93  -> sinistra
69 < 77  -> sinistra
69 > 65  -> destra
NULL     -> non presente
```

---

## 2. Struttura dati di riferimento in C

Per studiare bene queste slide conviene avere sempre in mente una possibile implementazione del nodo:

```c
typedef struct intTreeNode {
    int data;
    struct intTreeNode *left;
    struct intTreeNode *right;
} IntTreeNode;

typedef IntTreeNode *IntTree;
```

Quindi:

```c
IntTree tree;
```

significa:

```c
IntTreeNode *tree;
```

Cioè `tree` è un puntatore alla radice dell’albero.

Per gli esiti dell’inserimento si può usare un `enum`:

```c
typedef enum {
    INSERTED,
    ALREADYPRESENT,
    OUTOFMEMORY
} Outcome;
```

---

## 3. Operazioni principali sugli ARB

Le slide trattano cinque operazioni iterative:

```c
T findMinBSTiter(Tree tree);
Bool searchBSTiter(IntTree tree, int value);
Outcome insertBSTiter(IntTree *treePtr, int value);
T extractMinBSTiter(Tree *treePtr);
_Bool removeBSTiter(IntTree *treePtr, int value);
```

Poi introducono anche le versioni ricorsive di:

```c
_Bool searchBST(IntTree tree, int value);
Outcome insertBST(IntTree *treePtr, int value);
```

Le operazioni fondamentali sono:

| Operazione          | Cosa fa                                   |
| ------------------- | ----------------------------------------- |
| `findMinBSTiter`    | Trova il minimo senza rimuoverlo          |
| `searchBSTiter`     | Cerca un valore                           |
| `insertBSTiter`     | Inserisce un valore se non è già presente |
| `extractMinBSTiter` | Estrae e rimuove il minimo                |
| `removeBSTiter`     | Rimuove un valore qualsiasi               |
| `searchBST`         | Cerca un valore ricorsivamente            |
| `insertBST`         | Inserisce un valore ricorsivamente        |

---

# Parte I — Algoritmi iterativi

---

## 4. Ricerca del minimo iterativa

### Idea fondamentale

In un Albero Binario di Ricerca, il minimo si trova sempre andando il più possibile a sinistra.

Perché?

Perché ogni volta che vai nel sottoalbero sinistro trovi valori più piccoli del nodo corrente.

Quindi:

```text
Il minimo è il primo nodo che, seguendo sempre left, non ha più figlio sinistro.
```

Esempio:

```text
        47
       /
     25
    /
  17
 /
11
```

Il minimo è `11`.

---

## 5. Implementazione di `findMinBSTiter`

```c
int findMinBSTiter(IntTree tree) {
    if (tree == NULL) {
        exit(-1);
    }

    IntTree nodePtr = tree;

    while (nodePtr->left != NULL) {
        nodePtr = nodePtr->left;
    }

    return nodePtr->data;
}
```

---

## 6. Cosa capire bene di `findMinBSTiter`

La funzione riceve:

```c
IntTree tree
```

cioè un puntatore alla radice.

Non modifica l’albero, quindi basta un normale puntatore a nodo.

La variabile:

```c
IntTree nodePtr = tree;
```

serve per camminare nell’albero senza perdere il puntatore originale alla radice.

Il ciclo:

```c
while (nodePtr->left != NULL)
```

continua finché esiste un figlio sinistro.

Quando il ciclo termina, significa che:

```c
nodePtr->left == NULL
```

Quindi `nodePtr` punta al nodo più a sinistra, cioè al minimo.

---

## 7. Invariante di ciclo per il minimo

L’invariante di ciclo è una frase che rimane vera a ogni iterazione.

Per `findMinBSTiter`:

```text
Il minimo dell’albero originale è il minimo del sottoalbero puntato da nodePtr.
```

All’inizio:

```c
nodePtr = tree;
```

quindi è vero.

A ogni passo:

```c
nodePtr = nodePtr->left;
```

è ancora vero perché se esiste un sottoalbero sinistro, il minimo deve stare lì.

Alla fine:

```c
nodePtr->left == NULL
```

quindi il nodo corrente è il minimo.

---

## 8. Complessità di `findMinBSTiter`

Sia `h` l’altezza dell’albero.

| Caso         | Tempo  |
| ------------ | ------ |
| Caso ottimo  | `O(1)` |
| Caso pessimo | `O(h)` |
| Spazio       | `O(1)` |

Caso ottimo: il minimo è proprio nella radice.

Caso pessimo: l’albero è molto sbilanciato a sinistra e bisogna scendere fino alla foglia più profonda.

---

# 9. Ricerca iterativa di un elemento

## Idea fondamentale

Per cercare un valore `v`:

```text
Se v < nodo corrente, vado a sinistra.
Se v > nodo corrente, vado a destra.
Se v == nodo corrente, ho trovato il valore.
Se arrivo a NULL, il valore non esiste.
```

Questa è la proprietà chiave del BST.

---

## 10. Implementazione di `searchBSTiter`

```c
_Bool searchBSTiter(IntTree tree, int v) {
    IntTree nodePtr = tree;

    while (nodePtr != NULL) {
        if (v < nodePtr->data) {
            nodePtr = nodePtr->left;
        } else if (v > nodePtr->data) {
            nodePtr = nodePtr->right;
        } else {
            return 1;
        }
    }

    return 0;
}
```

---

## 11. Cosa capire bene di `searchBSTiter`

Questa funzione non modifica l’albero.

Per questo motivo il parametro è:

```c
IntTree tree
```

e non:

```c
IntTree *treePtr
```

Durante la ricerca, `nodePtr` viene spostato a sinistra o a destra.

La cosa importante è questa:

```c
nodePtr = nodePtr->left;
```

non modifica l’albero.

Modifica solo la variabile locale `nodePtr`.

È come dire:

```text
Adesso sto guardando il sottoalbero sinistro.
```

Non sto cambiando nessun collegamento tra nodi.

---

## 12. Invariante di ciclo per la ricerca

Per `searchBSTiter`:

```text
v è presente nell’albero originale se e solo se è presente nel sottoalbero puntato da nodePtr.
```

All’inizio:

```c
nodePtr = tree;
```

quindi stiamo cercando in tutto l’albero.

Poi, se `v < nodePtr->data`, sappiamo che `v` non può stare a destra, quindi continuiamo solo a sinistra.

Se `v > nodePtr->data`, sappiamo che `v` non può stare a sinistra, quindi continuiamo solo a destra.

Se arriviamo a `NULL`, significa che non esiste alcun nodo in cui il valore possa stare.

---

## 13. Complessità di `searchBSTiter`

| Caso                      | Tempo  |
| ------------------------- | ------ |
| Valore nella radice       | `O(1)` |
| Valore in foglia profonda | `O(h)` |
| Valore non presente       | `O(h)` |
| Spazio                    | `O(1)` |

La ricerca è efficiente se l’albero è bilanciato.

Se l’albero è bilanciato:

```text
h ≈ log2(n)
```

quindi la ricerca è circa:

```text
O(log n)
```

Se l’albero è completamente sbilanciato:

```text
h ≈ n
```

quindi la ricerca diventa:

```text
O(n)
```

---

# 14. Inserimento iterativo

## Idea fondamentale

Per inserire un valore `v`:

1. Cerco dove dovrebbe trovarsi.
2. Se lo trovo già, restituisco `ALREADYPRESENT`.
3. Se arrivo a un puntatore `NULL`, quello è il punto giusto dove agganciare il nuovo nodo.
4. Alloco il nuovo nodo con `malloc`.
5. Aggancio il nuovo nodo all’albero.

---

## 15. Perché nell’inserimento serve `IntTree *treePtr`

La firma è:

```c
Outcome insertBSTiter(IntTree *treePtr, int v);
```

Perché non basta:

```c
Outcome insertBSTiter(IntTree tree, int v);
```

Il motivo è fondamentale.

L’inserimento modifica l’albero.

In particolare, può modificare:

```c
tree
```

se l’albero era vuoto.

Esempio:

```c
IntTree tree = NULL;
insertBSTiter(&tree, 47);
```

Dopo l’inserimento voglio che `tree` nel `main` punti al nuovo nodo.

Per modificare la variabile `tree` del chiamante, devo passare il suo indirizzo:

```c
&tree
```

Quindi dentro la funzione ricevo:

```c
IntTree *treePtr;
```

cioè un puntatore a un puntatore a nodo.

---

## 16. Il punto chiave: puntatore a puntatore

Questa è la parte più importante delle slide.

Quando scrivo:

```c
IntTree *nodePtrPtr = treePtr;
```

`nodePtrPtr` non punta a un nodo.

Punta a una cella che contiene un puntatore a nodo.

Può puntare a:

```c
&tree
```

oppure a:

```c
&(someNode->left)
```

oppure a:

```c
&(someNode->right)
```

Questo permette di modificare direttamente il collegamento che porta al nodo corrente.

Esempio visivo:

```text
nodePtrPtr
   |
   v
+--------+
| tree   | ----> [47]
+--------+
```

Oppure più in profondità:

```text
nodePtrPtr
   |
   v
+-------------+
| node->left  | ----> [25]
+-------------+
```

Questa tecnica è comodissima perché permette di trattare allo stesso modo:

* inserimento nella radice;
* inserimento come figlio sinistro;
* inserimento come figlio destro.

---

## 17. Implementazione corretta di `insertBSTiter`

```c
Outcome insertBSTiter(IntTree *treePtr, int v) {
    IntTree *nodePtrPtr = treePtr;

    while (*nodePtrPtr != NULL) {
        if (v < (*nodePtrPtr)->data) {
            nodePtrPtr = &((*nodePtrPtr)->left);
        } else if (v > (*nodePtrPtr)->data) {
            nodePtrPtr = &((*nodePtrPtr)->right);
        } else {
            return ALREADYPRESENT;
        }
    }

    IntTree newNode = malloc(sizeof *newNode);
    if (newNode == NULL) {
        return OUTOFMEMORY;
    }

    newNode->data = v;
    newNode->left = NULL;
    newNode->right = NULL;

    *nodePtrPtr = newNode;

    return INSERTED;
}
```

---

## 18. Cosa succede nell’inserimento

Supponiamo di voler inserire `44`.

```text
        47
       /
     25
       \
        31
          \
           43
```

Percorso:

```text
44 < 47 -> sinistra
44 > 25 -> destra
44 > 31 -> destra
44 > 43 -> destra
NULL    -> inserisco qui
```

Durante il ciclo, `nodePtrPtr` si sposta così:

```c
nodePtrPtr = treePtr;
nodePtrPtr = &((*nodePtrPtr)->left);
nodePtrPtr = &((*nodePtrPtr)->right);
nodePtrPtr = &((*nodePtrPtr)->right);
nodePtrPtr = &((*nodePtrPtr)->right);
```

Alla fine:

```c
*nodePtrPtr == NULL
```

Quindi posso fare:

```c
*nodePtrPtr = newNode;
```

Cioè sto dicendo:

```text
La cella che prima conteneva NULL ora deve contenere l’indirizzo del nuovo nodo.
```

---

## 19. Errore classico nell’inserimento

Errore tipico:

```c
IntTree nodePtr = tree;

while (nodePtr != NULL) {
    if (v < nodePtr->data) {
        nodePtr = nodePtr->left;
    } else {
        nodePtr = nodePtr->right;
    }
}

nodePtr = newNode;
```

Questo non funziona.

Perché?

Perché `nodePtr` è solo una variabile locale.

Quando faccio:

```c
nodePtr = newNode;
```

sto modificando la copia locale, non il campo `left` o `right` del padre.

Per modificare davvero l’albero, devo modificare la cella che contiene il puntatore.

Quindi serve:

```c
IntTree *nodePtrPtr;
```

e alla fine:

```c
*nodePtrPtr = newNode;
```

---

## 20. Complessità di `insertBSTiter`

| Caso                           | Tempo  |
| ------------------------------ | ------ |
| Albero vuoto                   | `O(1)` |
| Valore nella radice            | `O(1)` |
| Inserimento in foglia profonda | `O(h)` |
| Spazio                         | `O(1)` |

L’inserimento costa quanto una ricerca più l’allocazione del nuovo nodo.

L’allocazione è `O(1)`, quindi domina la discesa nell’albero.

---

# 21. Estrazione iterativa del minimo

## Differenza tra trovare minimo ed estrarre minimo

`findMinBSTiter` trova il minimo ma non modifica l’albero.

`extractMinBSTiter` invece:

1. trova il minimo;
2. salva il suo valore;
3. rimuove il nodo dall’albero;
4. libera la memoria con `free`;
5. restituisce il valore minimo.

---

## 22. Perché anche qui serve `Tree *treePtr`

La firma è:

```c
int extractMinBSTiter(IntTree *treePtr);
```

Serve un puntatore a puntatore perché la funzione deve modificare l’albero.

Esempio importante:

```text
Albero:
    11
      \
       17
```

Il minimo è la radice `11`.

Dopo l’estrazione, la nuova radice deve diventare `17`.

Quindi la funzione deve poter modificare il puntatore alla radice.

Per questo riceve:

```c
&tree
```

e non solo:

```c
tree
```

---

## 23. Implementazione di `extractMinBSTiter`

```c
int extractMinBSTiter(IntTree *treePtr) {
    if (treePtr == NULL || *treePtr == NULL) {
        exit(-1);
    }

    IntTree *nodePtrPtr = treePtr;

    while ((*nodePtrPtr)->left != NULL) {
        nodePtrPtr = &((*nodePtrPtr)->left);
    }

    IntTree nodeToBeRemovedPtr = *nodePtrPtr;
    int minimum = nodeToBeRemovedPtr->data;

    *nodePtrPtr = nodeToBeRemovedPtr->right;

    free(nodeToBeRemovedPtr);

    return minimum;
}
```

---

## 24. Perché si assegna il figlio destro?

Questa riga è fondamentale:

```c
*nodePtrPtr = nodeToBeRemovedPtr->right;
```

Il nodo minimo non ha figlio sinistro, altrimenti non sarebbe il minimo.

Può però avere un figlio destro.

Esempio:

```text
      25
     /
   11
     \
      17
```

Il minimo è `11`.

Se rimuovo `11`, non posso perdere `17`.

Devo collegare il padre direttamente a `17`.

Prima:

```text
25->left = 11
11->right = 17
```

Dopo:

```text
25->left = 17
```

Quindi:

```c
*nodePtrPtr = nodeToBeRemovedPtr->right;
```

funziona sia se il minimo è una foglia, sia se ha un figlio destro.

Se il figlio destro non esiste, allora:

```c
nodeToBeRemovedPtr->right == NULL
```

e quindi il collegamento del padre diventa semplicemente `NULL`.

---

## 25. Perché prima salvo il puntatore al nodo da eliminare?

Queste righe:

```c
IntTree nodeToBeRemovedPtr = *nodePtrPtr;
int minimum = nodeToBeRemovedPtr->data;
```

sono necessarie perché subito dopo cambio il collegamento:

```c
*nodePtrPtr = nodeToBeRemovedPtr->right;
```

Se non salvassi il puntatore al nodo da rimuovere, rischierei di perdere il riferimento alla memoria da liberare.

Poi faccio:

```c
free(nodeToBeRemovedPtr);
```

Solo dopo posso restituire il minimo.

---

## 26. Complessità di `extractMinBSTiter`

| Caso                      | Tempo  |
| ------------------------- | ------ |
| Minimo nella radice       | `O(1)` |
| Minimo in foglia profonda | `O(h)` |
| Spazio                    | `O(1)` |

---

# 27. Rimozione iterativa di un elemento

## Idea generale

La rimozione è l’operazione più delicata.

Per rimuovere un valore `v`:

1. Cerco il nodo che contiene `v`.
2. Se non lo trovo, restituisco `0`.
3. Se lo trovo, devo distinguere i casi:

   * nodo foglia;
   * nodo con un solo figlio;
   * nodo con due figli.

---

## 28. Caso 1: nodo foglia

Esempio:

```text
    25
   /
 11
```

Se rimuovo `11`, basta mettere a `NULL` il puntatore del padre.

Prima:

```text
25->left = 11
```

Dopo:

```text
25->left = NULL
```

Poi libero il nodo `11`.

---

## 29. Caso 2: nodo con un solo figlio

Esempio:

```text
    25
   /
 11
   \
    17
```

Se rimuovo `11`, devo collegare `25` direttamente a `17`.

Prima:

```text
25->left = 11
11->right = 17
```

Dopo:

```text
25->left = 17
```

Poi libero `11`.

---

## 30. Caso 3: nodo con due figli

Esempio:

```text
        25
       /  \
     17    43
          /
        31
```

Se rimuovo `25`, non posso semplicemente scollegarlo, perché ha due sottoalberi.

La strategia delle slide è:

```text
Sostituire il valore del nodo con il minimo del suo sottoalbero destro.
```

Il minimo del sottoalbero destro si chiama anche **successore inorder**.

Nel caso sopra, il sottoalbero destro di `25` è:

```text
    43
   /
 31
```

Il minimo è `31`.

Quindi:

1. sostituisco `25` con `31`;
2. rimuovo il vecchio nodo che conteneva `31`.

Risultato:

```text
        31
       /  \
     17    43
```

La proprietà BST rimane valida.

---

## 31. Implementazione completa di `removeBSTiter`

```c
_Bool removeBSTiter(IntTree *treePtr, int v) {
    IntTree *nodePtrPtr = treePtr;

    while (*nodePtrPtr != NULL) {
        if (v < (*nodePtrPtr)->data) {
            nodePtrPtr = &((*nodePtrPtr)->left);
        } else if (v > (*nodePtrPtr)->data) {
            nodePtrPtr = &((*nodePtrPtr)->right);
        } else if ((*nodePtrPtr)->left != NULL &&
                   (*nodePtrPtr)->right != NULL) {
            (*nodePtrPtr)->data =
                extractMinBSTiter(&((*nodePtrPtr)->right));
            return 1;
        } else {
            IntTree nodeToBeRemovedPtr = *nodePtrPtr;

            if ((*nodePtrPtr)->left == NULL) {
                *nodePtrPtr = (*nodePtrPtr)->right;
            } else {
                *nodePtrPtr = (*nodePtrPtr)->left;
            }

            free(nodeToBeRemovedPtr);

            return 1;
        }
    }

    return 0;
}
```

---

## 32. Cosa capire benissimo di `removeBSTiter`

La funzione usa ancora:

```c
IntTree *nodePtrPtr;
```

Perché deve poter modificare il puntatore che porta al nodo corrente.

Questo puntatore può essere:

```c
&tree
```

oppure:

```c
&(padre->left)
```

oppure:

```c
&(padre->right)
```

Quando trovo il nodo da eliminare, `*nodePtrPtr` è il nodo corrente.

Quindi:

```c
IntTree nodeToBeRemovedPtr = *nodePtrPtr;
```

salva il nodo da liberare.

Poi, nel caso con zero o un figlio, faccio:

```c
if ((*nodePtrPtr)->left == NULL) {
    *nodePtrPtr = (*nodePtrPtr)->right;
} else {
    *nodePtrPtr = (*nodePtrPtr)->left;
}
```

Questa parte copre sia il caso foglia sia il caso figlio singolo.

### Caso foglia

Se il nodo è foglia:

```c
left == NULL
right == NULL
```

allora:

```c
*nodePtrPtr = (*nodePtrPtr)->right;
```

diventa:

```c
*nodePtrPtr = NULL;
```

Perfetto.

### Caso solo figlio destro

```c
left == NULL
right != NULL
```

allora:

```c
*nodePtrPtr = right;
```

Il padre viene collegato direttamente al figlio destro.

### Caso solo figlio sinistro

```c
left != NULL
right == NULL
```

allora entra nell’`else`:

```c
*nodePtrPtr = left;
```

Il padre viene collegato direttamente al figlio sinistro.

---

## 33. Perché nel caso con due figli non faccio `free` del nodo trovato?

Nel caso con due figli:

```c
(*nodePtrPtr)->data =
    extractMinBSTiter(&((*nodePtrPtr)->right));
```

Non elimino fisicamente il nodo corrente.

Cambio solo il suo valore.

Il nodo fisicamente eliminato è quello che conteneva il minimo nel sottoalbero destro.

La `free` viene fatta dentro:

```c
extractMinBSTiter
```

Quindi non devo fare una seconda `free`.

---

## 34. Complessità di `removeBSTiter`

| Caso                      | Tempo                                |
| ------------------------- | ------------------------------------ |
| Albero vuoto              | `O(1)`                               |
| Valore nella radice       | `O(1)` oppure `O(h)` se ha due figli |
| Valore in foglia profonda | `O(h)`                               |
| Valore non presente       | `O(h)`                               |
| Spazio                    | `O(1)`                               |

Nel caso con due figli, oltre a trovare il nodo da eliminare, bisogna estrarre il minimo dal sottoalbero destro.

Il costo rimane comunque:

```text
O(h)
```

perché si scende lungo cammini dell’albero.

---

# Parte II — Algoritmi ricorsivi

---

## 35. Ricerca ricorsiva in un BST

La versione ricorsiva è molto naturale perché un albero è una struttura dati ricorsiva.

Un albero è:

```text
- vuoto
oppure
- un nodo con un sottoalbero sinistro e un sottoalbero destro
```

Quindi la ricerca ricorsiva segue questa logica:

```text
Se l’albero è vuoto, il valore non c’è.
Se il valore è minore della radice, cerco a sinistra.
Se il valore è maggiore della radice, cerco a destra.
Altrimenti l’ho trovato.
```

---

## 36. Implementazione di `searchBST`

```c
_Bool searchBST(IntTree tree, int v) {
    if (tree == NULL) {
        return 0;
    } else if (v < tree->data) {
        return searchBST(tree->left, v);
    } else if (v > tree->data) {
        return searchBST(tree->right, v);
    } else {
        return 1;
    }
}
```

---

## 37. Cosa capire bene della ricerca ricorsiva

Il caso base principale è:

```c
if (tree == NULL) {
    return 0;
}
```

Significa:

```text
Sono arrivato dove il valore dovrebbe essere, ma il nodo non esiste.
```

I casi ricorsivi sono:

```c
return searchBST(tree->left, v);
return searchBST(tree->right, v);
```

La funzione restituisce direttamente il risultato della chiamata ricorsiva.

Questa è una forma di ricorsione molto pulita.

---

## 38. Complessità di `searchBST`

| Aspetto            | Complessità |
| ------------------ | ----------- |
| Tempo caso ottimo  | `O(1)`      |
| Tempo caso pessimo | `O(h)`      |
| Spazio             | `O(h)`      |

Lo spazio è `O(h)` perché ogni chiamata ricorsiva rimane nello stack finché non si arriva al caso base.

In alcuni casi il compilatore può ottimizzare la ricorsione di coda, ma non bisogna darlo per scontato all’esame.

---

# 39. Inserimento ricorsivo

## Idea

Anche l’inserimento ricorsivo segue la struttura dell’albero.

Se il sottoalbero corrente è vuoto:

```text
ho trovato il punto di inserimento
```

Altrimenti confronto il valore con la radice e chiamo ricorsivamente a sinistra o a destra.

---

## 40. Implementazione corretta di `insertBST`

```c
Outcome insertBST(IntTree *treePtr, int v) {
    if (*treePtr == NULL) {
        IntTree newNode = malloc(sizeof *newNode);
        if (newNode == NULL) {
            return OUTOFMEMORY;
        }

        newNode->data = v;
        newNode->left = NULL;
        newNode->right = NULL;

        *treePtr = newNode;

        return INSERTED;
    } else if (v < (*treePtr)->data) {
        return insertBST(&((*treePtr)->left), v);
    } else if (v > (*treePtr)->data) {
        return insertBST(&((*treePtr)->right), v);
    } else {
        return ALREADYPRESENT;
    }
}
```

---

## 41. Cosa capire benissimo dell’inserimento ricorsivo

La funzione riceve:

```c
IntTree *treePtr
```

perché deve poter modificare il puntatore al sottoalbero corrente.

Quando chiamo:

```c
return insertBST(&((*treePtr)->left), v);
```

sto passando l’indirizzo del campo `left`.

Quindi la chiamata ricorsiva può modificare direttamente quel campo.

Stessa cosa per il campo destro:

```c
return insertBST(&((*treePtr)->right), v);
```

Questa è la stessa idea del puntatore a puntatore vista nella versione iterativa.

La differenza è che nella versione iterativa aggiorno manualmente:

```c
nodePtrPtr = &((*nodePtrPtr)->left);
```

mentre nella versione ricorsiva passo quel puntatore alla chiamata successiva.

---

# 42. Iterativo vs ricorsivo

## Versione ricorsiva

Vantaggi:

* più leggibile;
* più vicina alla definizione matematica di albero;
* più semplice da dimostrare corretta per induzione strutturale;
* spesso più facile da scrivere all’esame.

Svantaggi:

* usa stack di chiamate;
* può consumare `O(h)` memoria;
* se l’albero è molto sbilanciato, può fare molte chiamate ricorsive.

---

## Versione iterativa

Vantaggi:

* usa memoria `O(1)`;
* spesso è più performante;
* evita problemi di stack overflow su alberi molto alti.

Svantaggi:

* più difficile da scrivere correttamente;
* richiede maggiore attenzione ai puntatori;
* nelle operazioni che modificano l’albero conviene usare puntatori a puntatori.

---

# 43. Bilanciamento degli alberi

Molte operazioni su BST hanno complessità:

```text
O(h)
```

dove `h` è l’altezza dell’albero.

Quindi la qualità dell’albero dipende tantissimo dalla sua altezza.

---

## 44. Albero bilanciato vs sbilanciato

Se inserisco valori in ordine crescente:

```text
1, 2, 3, 4, 5, 6, 7
```

ottengo un albero completamente sbilanciato:

```text
1
 \
  2
   \
    3
     \
      4
       \
        5
         \
          6
           \
            7
```

Questo è praticamente una lista linkata.

La ricerca diventa:

```text
O(n)
```

Invece un albero bilanciato con gli stessi valori potrebbe essere:

```text
        4
      /   \
     2     6
    / \   / \
   1   3 5   7
```

Qui l’altezza è circa:

```text
log2(n)
```

e le operazioni diventano:

```text
O(log n)
```

Nota: a seconda della convenzione, l’altezza può essere contata come numero di archi o numero di livelli. Questo cambia al massimo di 1, ma non cambia la complessità asintotica.

---

## 45. Perché il bilanciamento è importante

Le operazioni:

```c
search
insert
remove
findMin
extractMin
```

dipendono tutte dall’altezza.

Quindi:

| Tipo di albero            | Altezza    | Operazioni |
| ------------------------- | ---------- | ---------- |
| Completamente sbilanciato | `O(n)`     | `O(n)`     |
| Bilanciato                | `O(log n)` | `O(log n)` |

Per questo esistono alberi BST bilanciati, come:

* alberi AVL;
* alberi rosso-neri.

Questi alberi mantengono automaticamente l’altezza sotto controllo durante inserimenti e cancellazioni.

---

# 46. Codice completo da riscrivere per esercizio

Questo è un file di esercizio molto utile da riscrivere da zero.

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct intTreeNode {
    int data;
    struct intTreeNode *left;
    struct intTreeNode *right;
} IntTreeNode;

typedef IntTreeNode *IntTree;

typedef enum {
    INSERTED,
    ALREADYPRESENT,
    OUTOFMEMORY
} Outcome;

int findMinBSTiter(IntTree tree) {
    if (tree == NULL) {
        exit(-1);
    }

    IntTree nodePtr = tree;

    while (nodePtr->left != NULL) {
        nodePtr = nodePtr->left;
    }

    return nodePtr->data;
}

_Bool searchBSTiter(IntTree tree, int v) {
    IntTree nodePtr = tree;

    while (nodePtr != NULL) {
        if (v < nodePtr->data) {
            nodePtr = nodePtr->left;
        } else if (v > nodePtr->data) {
            nodePtr = nodePtr->right;
        } else {
            return 1;
        }
    }

    return 0;
}

Outcome insertBSTiter(IntTree *treePtr, int v) {
    IntTree *nodePtrPtr = treePtr;

    while (*nodePtrPtr != NULL) {
        if (v < (*nodePtrPtr)->data) {
            nodePtrPtr = &((*nodePtrPtr)->left);
        } else if (v > (*nodePtrPtr)->data) {
            nodePtrPtr = &((*nodePtrPtr)->right);
        } else {
            return ALREADYPRESENT;
        }
    }

    IntTree newNode = malloc(sizeof *newNode);
    if (newNode == NULL) {
        return OUTOFMEMORY;
    }

    newNode->data = v;
    newNode->left = NULL;
    newNode->right = NULL;

    *nodePtrPtr = newNode;

    return INSERTED;
}

int extractMinBSTiter(IntTree *treePtr) {
    if (treePtr == NULL || *treePtr == NULL) {
        exit(-1);
    }

    IntTree *nodePtrPtr = treePtr;

    while ((*nodePtrPtr)->left != NULL) {
        nodePtrPtr = &((*nodePtrPtr)->left);
    }

    IntTree nodeToBeRemovedPtr = *nodePtrPtr;
    int minimum = nodeToBeRemovedPtr->data;

    *nodePtrPtr = nodeToBeRemovedPtr->right;

    free(nodeToBeRemovedPtr);

    return minimum;
}

_Bool removeBSTiter(IntTree *treePtr, int v) {
    IntTree *nodePtrPtr = treePtr;

    while (*nodePtrPtr != NULL) {
        if (v < (*nodePtrPtr)->data) {
            nodePtrPtr = &((*nodePtrPtr)->left);
        } else if (v > (*nodePtrPtr)->data) {
            nodePtrPtr = &((*nodePtrPtr)->right);
        } else if ((*nodePtrPtr)->left != NULL &&
                   (*nodePtrPtr)->right != NULL) {
            (*nodePtrPtr)->data =
                extractMinBSTiter(&((*nodePtrPtr)->right));
            return 1;
        } else {
            IntTree nodeToBeRemovedPtr = *nodePtrPtr;

            if ((*nodePtrPtr)->left == NULL) {
                *nodePtrPtr = (*nodePtrPtr)->right;
            } else {
                *nodePtrPtr = (*nodePtrPtr)->left;
            }

            free(nodeToBeRemovedPtr);
            return 1;
        }
    }

    return 0;
}

_Bool searchBST(IntTree tree, int v) {
    if (tree == NULL) {
        return 0;
    } else if (v < tree->data) {
        return searchBST(tree->left, v);
    } else if (v > tree->data) {
        return searchBST(tree->right, v);
    } else {
        return 1;
    }
}

Outcome insertBST(IntTree *treePtr, int v) {
    if (*treePtr == NULL) {
        IntTree newNode = malloc(sizeof *newNode);
        if (newNode == NULL) {
            return OUTOFMEMORY;
        }

        newNode->data = v;
        newNode->left = NULL;
        newNode->right = NULL;

        *treePtr = newNode;

        return INSERTED;
    } else if (v < (*treePtr)->data) {
        return insertBST(&((*treePtr)->left), v);
    } else if (v > (*treePtr)->data) {
        return insertBST(&((*treePtr)->right), v);
    } else {
        return ALREADYPRESENT;
    }
}

void printInOrder(IntTree tree) {
    if (tree == NULL) {
        return;
    }

    printInOrder(tree->left);
    printf("%d ", tree->data);
    printInOrder(tree->right);
}

void freeTree(IntTree tree) {
    if (tree == NULL) {
        return;
    }

    freeTree(tree->left);
    freeTree(tree->right);
    free(tree);
}

int main(void) {
    IntTree tree = NULL;

    int values[] = {47, 25, 93, 77, 17, 11, 31, 43, 68, 65};
    int n = sizeof values / sizeof values[0];

    for (int i = 0; i < n; i++) {
        insertBSTiter(&tree, values[i]);
    }

    printf("Visita inorder: ");
    printInOrder(tree);
    printf("\n");

    printf("Minimo: %d\n", findMinBSTiter(tree));

    printf("Cerco 43: %d\n", searchBSTiter(tree, 43));
    printf("Cerco 69: %d\n", searchBSTiter(tree, 69));

    printf("Inserisco 44...\n");
    insertBSTiter(&tree, 44);

    printf("Visita inorder: ");
    printInOrder(tree);
    printf("\n");

    printf("Estraggo minimo: %d\n", extractMinBSTiter(&tree));

    printf("Visita inorder: ");
    printInOrder(tree);
    printf("\n");

    printf("Rimuovo 25...\n");
    removeBSTiter(&tree, 25);

    printf("Visita inorder: ");
    printInOrder(tree);
    printf("\n");

    freeTree(tree);

    return 0;
}
```

---

# 47. Perché la visita inorder è utile

La visita inorder di un BST stampa gli elementi in ordine crescente.

```c
void printInOrder(IntTree tree) {
    if (tree == NULL) {
        return;
    }

    printInOrder(tree->left);
    printf("%d ", tree->data);
    printInOrder(tree->right);
}
```

Questa funzione è utilissima per verificare se inserimento e rimozione funzionano.

Se dopo ogni operazione la visita inorder stampa valori ordinati, è un buon segno che la proprietà BST sia stata mantenuta.

Esempio:

```text
11 17 25 31 43 47 65 68 77 93
```

Dopo aver inserito `44`:

```text
11 17 25 31 43 44 47 65 68 77 93
```

Dopo aver rimosso `25`:

```text
11 17 31 43 44 47 65 68 77 93
```

---

# 48. Errori classici da evitare all’esame

## Errore 1: usare `nodePtr = newNode`

Questo non modifica l’albero.

```c
nodePtr = newNode;
```

modifica solo una variabile locale.

Per modificare l’albero serve:

```c
*nodePtrPtr = newNode;
```

---

## Errore 2: dimenticare `free`

Quando rimuovi un nodo, devi liberarlo.

```c
free(nodeToBeRemovedPtr);
```

Altrimenti hai un memory leak.

---

## Errore 3: fare `free` prima di salvare i dati necessari

Sbagliato:

```c
free(nodeToBeRemovedPtr);
int minimum = nodeToBeRemovedPtr->data;
```

Dopo `free`, non puoi più accedere al nodo.

Corretto:

```c
int minimum = nodeToBeRemovedPtr->data;
free(nodeToBeRemovedPtr);
```

---

## Errore 4: perdere il figlio destro nell’estrazione del minimo

Sbagliato:

```c
*nodePtrPtr = NULL;
free(nodeToBeRemovedPtr);
```

Questo perde l’eventuale figlio destro del minimo.

Corretto:

```c
*nodePtrPtr = nodeToBeRemovedPtr->right;
free(nodeToBeRemovedPtr);
```

---

## Errore 5: dimenticare il caso con due figli nella rimozione

Se un nodo ha due figli, non posso semplicemente sostituirlo con `left` o `right`.

Devo usare una strategia corretta, ad esempio:

```c
(*nodePtrPtr)->data =
    extractMinBSTiter(&((*nodePtrPtr)->right));
```

---

## Errore 6: confondere `treePtr`, `*treePtr` e `(*treePtr)->data`

Se:

```c
IntTree *treePtr;
```

allora:

```c
treePtr
```

è l’indirizzo di una variabile che contiene un puntatore a nodo.

```c
*treePtr
```

è il puntatore al nodo.

```c
(*treePtr)->data
```

è il valore dentro il nodo.

Le parentesi sono fondamentali.

Sbagliato:

```c
*treePtr->data
```

Perché `->` ha precedenza maggiore di `*`.

Corretto:

```c
(*treePtr)->data
```

---

# 49. Mini schema mentale per puntatori a puntatori

Quando hai:

```c
IntTree tree;
```

hai:

```text
tree ----> nodo
```

Quando passi:

```c
&tree
```

hai:

```text
treePtr ----> tree ----> nodo
```

Quindi:

```c
*treePtr
```

è `tree`.

E:

```c
(*treePtr)->data
```

è il dato nella radice.

Nel caso di:

```c
nodePtrPtr = &((*nodePtrPtr)->left);
```

stai dicendo:

```text
Adesso voglio poter modificare direttamente il campo left del nodo corrente.
```

Questa è la frase da ricordare.

---

# 50. Cosa saprei spiegare a voce all’esame

Domande probabili:

## 1. Dove si trova il minimo in un BST?

Nel nodo più a sinistra raggiungibile dalla radice.

---

## 2. Perché la ricerca in un BST è efficiente?

Perché a ogni confronto elimino metà “logica” dell’albero: o il sottoalbero sinistro o quello destro.

Questo è veramente efficiente solo se l’albero è bilanciato.

---

## 3. Perché inserimento e rimozione ricevono `IntTree *treePtr`?

Perché devono modificare l’albero, e in particolare potrebbero modificare la radice o un campo `left` / `right` di qualche nodo.

---

## 4. Come si rimuove un nodo con due figli?

Si può sostituire il suo valore con il minimo del sottoalbero destro, poi eliminare quel minimo dal sottoalbero destro.

---

## 5. Qual è la complessità delle operazioni?

Dipende dall’altezza `h`.

```text
Tempo: O(h)
Spazio iterativo: O(1)
Spazio ricorsivo: O(h)
```

Se l’albero è bilanciato:

```text
h = O(log n)
```

Se è sbilanciato:

```text
h = O(n)
```

---

# 51. Esercizi da fare per prendere confidenza

## Esercizio 1

Riscrivere da zero:

```c
_Bool searchBSTiter(IntTree tree, int v);
```

senza guardare gli appunti.

---

## Esercizio 2

Riscrivere da zero:

```c
Outcome insertBSTiter(IntTree *treePtr, int v);
```

Obiettivo: capire perfettamente questa riga:

```c
nodePtrPtr = &((*nodePtrPtr)->left);
```

---

## Esercizio 3

Riscrivere da zero:

```c
int extractMinBSTiter(IntTree *treePtr);
```

Obiettivo: capire perché si fa:

```c
*nodePtrPtr = nodeToBeRemovedPtr->right;
```

---

## Esercizio 4

Riscrivere da zero:

```c
_Bool removeBSTiter(IntTree *treePtr, int v);
```

Obiettivo: saper gestire bene i tre casi:

```text
foglia
un figlio
due figli
```

---

## Esercizio 5

Implementare:

```c
int countNodes(IntTree tree);
```

Soluzione:

```c
int countNodes(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    return 1 + countNodes(tree->left) + countNodes(tree->right);
}
```

---

## Esercizio 6

Implementare:

```c
int height(IntTree tree);
```

Possibile soluzione contando i livelli:

```c
int height(IntTree tree) {
    if (tree == NULL) {
        return 0;
    }

    int leftHeight = height(tree->left);
    int rightHeight = height(tree->right);

    if (leftHeight > rightHeight) {
        return 1 + leftHeight;
    } else {
        return 1 + rightHeight;
    }
}
```

---

## Esercizio 7

Implementare:

```c
void freeTree(IntTree tree);
```

Soluzione:

```c
void freeTree(IntTree tree) {
    if (tree == NULL) {
        return;
    }

    freeTree(tree->left);
    freeTree(tree->right);
    free(tree);
}
```

Attenzione: prima libero i figli, poi il nodo corrente.

Questa è una visita postorder.

---

# 52. Riassunto finale da ricordare

Gli Alberi Binari di Ricerca permettono di cercare, inserire e rimuovere elementi sfruttando la relazione d’ordine tra nodo, sottoalbero sinistro e sottoalbero destro.

Le operazioni principali costano:

```text
O(h)
```

dove `h` è l’altezza dell’albero.

Se l’albero è bilanciato, il costo diventa:

```text
O(log n)
```

Se l’albero è completamente sbilanciato, il costo peggiora a:

```text
O(n)
```

La parte più importante a livello di C è capire i puntatori a puntatori:

```c
IntTree *treePtr;
IntTree *nodePtrPtr;
```

Questi servono quando una funzione deve modificare il puntatore alla radice o un campo `left` / `right`.

Frase da ricordare:

```text
Un puntatore normale mi permette di raggiungere un nodo.
Un puntatore a puntatore mi permette di modificare il collegamento che porta a quel nodo.
```

Se questa frase è chiara, inserimento, estrazione del minimo e rimozione diventano molto più comprensibili.
