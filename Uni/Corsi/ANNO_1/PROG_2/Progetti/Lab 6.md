# Laboratorio RAM — Buddy System / Sistema Gemellare

Questo laboratorio implementa un sistema semplificato di gestione dinamica della memoria RAM usando il **sistema gemellare**, detto anche **buddy system**.

La memoria viene rappresentata tramite un **albero binario**.

Ogni nodo dell’albero rappresenta un blocco di memoria.

---

# Struct usate

Dal file `ram.h` abbiamo:

```c
typedef enum risultato {OK, NOK} Risultato;

typedef struct nodo *RAM;

typedef enum stato {INTERNO, LIBERO, OCCUPATO} Stato;

struct nodo {
    int KB;
    Stato s;
    RAM parent;
    RAM lbuddy;
    RAM rbuddy;
};
```

Ogni nodo contiene:

|Campo|Significato|
|---|---|
|`KB`|quantità di memoria rappresentata dal nodo|
|`s`|stato del nodo|
|`parent`|puntatore al padre|
|`lbuddy`|figlio sinistro|
|`rbuddy`|figlio destro|

---

# Stati possibili di un nodo

Un nodo può essere:

```c
INTERNO
```

se è stato diviso in due figli.

```c
LIBERO
```

se rappresenta un blocco libero.

```c
OCCUPATO
```

se rappresenta un blocco già allocato.

---

# Idea generale del buddy system

Quando si chiede di allocare `K` KB:

1. si parte dalla radice;
    
2. se il blocco è troppo grande, viene diviso in due blocchi uguali;
    
3. si continua sempre cercando prima nel figlio sinistro;
    
4. quando si trova il blocco più piccolo possibile che può contenere `K`, lo si marca come `OCCUPATO`.
    

Esempio con RAM da `8 KB` e richiesta di `2 KB`:

```text
8 LIBERO
```

viene diviso in:

```text
        8 INTERNO
       /         \
   4 LIBERO    4 LIBERO
```

poi il primo blocco da `4 KB` viene diviso:

```text
        8 INTERNO
       /         \
   4 INTERNO    4 LIBERO
   /      \
2 LIBERO 2 LIBERO
```

infine viene occupato il primo blocco da `2 KB`:

```text
        8 INTERNO
       /         \
   4 INTERNO    4 LIBERO
   /      \
2 OCC   2 LIBERO
```

---

# Codice completo commentato

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ram.h"

/*
 * Crea una RAM di dimensione memorySize.
 *
 * memorySize deve essere:
 * - maggiore o uguale a 1
 * - una potenza di 2
 *
 * Esempi validi:
 * 1, 2, 4, 8, 16, 32, ...
 *
 * Esempi non validi:
 * 0, -1, 3, 6, 10, ...
 */
RAM initram(int memorySize) {
    /*
     * Se la dimensione è minore di 1, la RAM non è valida.
     */
    if (memorySize < 1) {
        return NULL;
    }

    /*
     * Controlliamo che memorySize sia una potenza di 2.
     *
     * L'idea è dividere per 2 finché si arriva a 1.
     * Se durante il percorso troviamo un numero dispari diverso da 1,
     * allora non era una potenza di 2.
     *
     * Esempio valido:
     * 8 -> 4 -> 2 -> 1
     *
     * Esempio non valido:
     * 6 -> 3
     * 3 è dispari, quindi 6 non è potenza di 2.
     */
    int powerCheck = memorySize;

    while (powerCheck > 1) {
        if (powerCheck % 2 != 0) {
            return NULL;
        }

        powerCheck = powerCheck / 2;
    }

    /*
     * Allochiamo il nodo radice.
     */
    RAM newRam = malloc(sizeof(*newRam));

    /*
     * Se malloc fallisce, restituiamo NULL.
     */
    if (newRam == NULL) {
        return NULL;
    }

    /*
     * La radice rappresenta tutta la memoria richiesta.
     *
     * All'inizio tutta la RAM è libera, quindi:
     * - stato LIBERO
     * - nessun padre
     * - nessun figlio
     */
    newRam->KB = memorySize;
    newRam->s = LIBERO;
    newRam->parent = NULL;
    newRam->lbuddy = NULL;
    newRam->rbuddy = NULL;

    return newRam;
}

/*
 * Alloca requestedSize KB dentro la struttura RAM.
 *
 * Restituisce:
 * - il nodo allocato, se esiste spazio
 * - NULL, se non esiste un blocco adatto
 *
 * Nota importante della consegna:
 * la ricerca deve dare priorità al figlio sinistro.
 */
RAM allocram(int requestedSize, RAM ram) {
    /*
     * Controllo degli argomenti non validi.
     *
     * Non possiamo allocare:
     * - dentro una RAM NULL
     * - una quantità <= 0
     * - una quantità maggiore del blocco corrente
     */
    if (ram == NULL || requestedSize <= 0 || requestedSize > ram->KB) {
        return NULL;
    }

    /*
     * Se il nodo è già occupato, non può essere usato.
     */
    if (ram->s == OCCUPATO) {
        return NULL;
    }

    /*
     * Se il nodo è interno, significa che è già stato diviso.
     *
     * In questo caso dobbiamo cercare nei figli.
     *
     * La consegna dice che bisogna dare priorità al figlio sinistro.
     * Quindi proviamo prima ram->lbuddy.
     */
    if (ram->s == INTERNO) {
        RAM allocatedNode = allocram(requestedSize, ram->lbuddy);

        /*
         * Se il figlio sinistro ha trovato spazio, restituiamo quel nodo.
         */
        if (allocatedNode != NULL) {
            return allocatedNode;
        }

        /*
         * Se a sinistra non c'è spazio, proviamo a destra.
         */
        return allocram(requestedSize, ram->rbuddy);
    }

    /*
     * Se siamo qui, il nodo corrente è LIBERO.
     *
     * Dobbiamo decidere se occuparlo direttamente oppure dividerlo.
     *
     * Lo dividiamo se:
     * - il nodo ha dimensione maggiore di 1
     * - metà del nodo è ancora sufficiente per contenere requestedSize
     *
     * Esempio:
     * nodo da 8 KB, richiesta 3 KB
     *
     * 8 / 2 = 4
     * 4 >= 3, quindi conviene dividere.
     *
     * Esempio:
     * nodo da 4 KB, richiesta 3 KB
     *
     * 4 / 2 = 2
     * 2 < 3, quindi non possiamo dividere:
     * dobbiamo occupare tutto il nodo da 4 KB.
     */
    if (ram->KB > 1 && ram->KB / 2 >= requestedSize) {
        /*
         * Creiamo i due buddy, cioè i due figli del nodo corrente.
         */
        RAM leftBuddy = malloc(sizeof(*leftBuddy));
        RAM rightBuddy = malloc(sizeof(*rightBuddy));

        /*
         * Se una delle due malloc fallisce, liberiamo ciò che eventualmente
         * è stato allocato e restituiamo NULL.
         */
        if (leftBuddy == NULL || rightBuddy == NULL) {
            free(leftBuddy);
            free(rightBuddy);
            return NULL;
        }

        /*
         * Il figlio sinistro contiene metà della memoria del padre.
         */
        leftBuddy->KB = ram->KB / 2;
        leftBuddy->s = LIBERO;
        leftBuddy->parent = ram;
        leftBuddy->lbuddy = NULL;
        leftBuddy->rbuddy = NULL;

        /*
         * Anche il figlio destro contiene metà della memoria del padre.
         */
        rightBuddy->KB = ram->KB / 2;
        rightBuddy->s = LIBERO;
        rightBuddy->parent = ram;
        rightBuddy->lbuddy = NULL;
        rightBuddy->rbuddy = NULL;

        /*
         * Il nodo corrente non è più libero direttamente:
         * ora è un nodo interno con due figli.
         */
        ram->s = INTERNO;
        ram->lbuddy = leftBuddy;
        ram->rbuddy = rightBuddy;

        /*
         * Dopo aver diviso, continuiamo ad allocare nel figlio sinistro.
         */
        return allocram(requestedSize, ram->lbuddy);
    }

    /*
     * Se non conviene o non si può dividere ulteriormente,
     * occupiamo il nodo corrente.
     */
    ram->s = OCCUPATO;

    return ram;
}

/*
 * Libera un nodo precedentemente allocato.
 *
 * Dopo aver liberato il nodo, prova a fondere i buddy liberi.
 *
 * Restituisce:
 * - OK se la deallocazione è riuscita
 * - NOK se il nodo è NULL o non era OCCUPATO
 */
Risultato deallocram(RAM ram) {
    /*
     * Possiamo deallocare solo un nodo esistente e occupato.
     */
    if (ram == NULL || ram->s != OCCUPATO) {
        return NOK;
    }

    /*
     * Il nodo torna libero.
     */
    ram->s = LIBERO;

    /*
     * Da questo nodo risaliamo verso il padre,
     * provando a fondere blocchi liberi gemelli.
     */
    RAM currentNode = ram;

    while (currentNode->parent != NULL) {
        RAM parentNode = currentNode->parent;
        RAM leftBuddy = parentNode->lbuddy;
        RAM rightBuddy = parentNode->rbuddy;

        /*
         * Possiamo fondere due figli se:
         * - esistono entrambi
         * - sono entrambi LIBERI
         * - sono foglie, cioè non hanno figli
         *
         * Se un figlio fosse INTERNO, non potremmo eliminarlo direttamente,
         * perché conterrebbe altri blocchi.
         */
        if (leftBuddy != NULL && rightBuddy != NULL &&
            leftBuddy->s == LIBERO && rightBuddy->s == LIBERO &&
            leftBuddy->lbuddy == NULL && leftBuddy->rbuddy == NULL &&
            rightBuddy->lbuddy == NULL && rightBuddy->rbuddy == NULL) {

            /*
             * I due buddy liberi vengono eliminati.
             */
            free(leftBuddy);
            free(rightBuddy);

            /*
             * Il padre torna a essere un blocco libero unico.
             */
            parentNode->lbuddy = NULL;
            parentNode->rbuddy = NULL;
            parentNode->s = LIBERO;

            /*
             * Continuiamo a risalire:
             * magari anche il padre può essere fuso con il suo buddy.
             */
            currentNode = parentNode;
        } else {
            /*
             * Se non possiamo fondere, ci fermiamo.
             */
            break;
        }
    }

    return OK;
}

/*
 * Calcola quanti KB liberi ci sono nella RAM.
 *
 * Restituisce:
 * - quantità di memoria libera
 * - -1 se ram è NULL
 */
int numfree(RAM ram) {
    /*
     * RAM nulla: errore.
     */
    if (ram == NULL) {
        return -1;
    }

    /*
     * Se il nodo è libero, tutta la sua memoria è disponibile.
     */
    if (ram->s == LIBERO) {
        return ram->KB;
    }

    /*
     * Se il nodo è occupato, non contribuisce alla memoria libera.
     */
    if (ram->s == OCCUPATO) {
        return 0;
    }

    /*
     * Se il nodo è interno, la memoria libera è la somma
     * della memoria libera nel figlio sinistro e nel figlio destro.
     */
    int leftFreeMemory = numfree(ram->lbuddy);
    int rightFreeMemory = numfree(ram->rbuddy);

    /*
     * Se una delle due chiamate fallisce, restituiamo -1.
     */
    if (leftFreeMemory == -1 || rightFreeMemory == -1) {
        return -1;
    }

    return leftFreeMemory + rightFreeMemory;
}

/*
 * Converte una RAM in stringa.
 *
 * Il formato usato è:
 *
 * dimensioneRadice:statiNodi
 *
 * Esempio:
 *
 * 8:IIOLOL
 *
 * Dove:
 * - I = INTERNO
 * - L = LIBERO
 * - O = OCCUPATO
 *
 * Gli stati vengono scritti in visita pre-order:
 * prima il nodo corrente, poi il figlio sinistro, poi il figlio destro.
 */
char* ram2str(RAM ram) {
    /*
     * Se la RAM è NULL, la specifica dice di restituire stringa vuota.
     */
    if (ram == NULL) {
        char *emptyString = malloc(1);

        if (emptyString == NULL) {
            return NULL;
        }

        emptyString[0] = '\0';

        return emptyString;
    }

    /*
     * Scriviamo l'intestazione con la dimensione della radice.
     *
     * Esempio:
     * se la root è 8 KB, header diventa "8:".
     */
    char header[64];
    int headerLength = sprintf(header, "%d:", ram->KB);

    /*
     * Allochiamo una stringa iniziale abbastanza grande.
     * Se durante la costruzione non basta, useremo realloc.
     */
    int stringCapacity = headerLength + 64;
    char *representation = malloc(stringCapacity * sizeof(char));

    /*
     * In caso di errore, restituiamo stringa vuota.
     */
    if (representation == NULL) {
        char *emptyString = malloc(1);

        if (emptyString == NULL) {
            return NULL;
        }

        emptyString[0] = '\0';

        return emptyString;
    }

    /*
     * Copiamo l'header nella rappresentazione.
     */
    strcpy(representation, header);

    /*
     * L'indice parte subito dopo l'header.
     */
    int representationIndex = headerLength;

    /*
     * Per fare la visita pre-order senza funzioni ausiliarie,
     * usiamo uno stack esplicito.
     *
     * Lo stack contiene puntatori a nodi RAM da visitare.
     */
    int stackCapacity = 64;
    int stackTop = 0;
    RAM *nodeStack = malloc(stackCapacity * sizeof(RAM));

    if (nodeStack == NULL) {
        free(representation);

        char *emptyString = malloc(1);

        if (emptyString == NULL) {
            return NULL;
        }

        emptyString[0] = '\0';

        return emptyString;
    }

    /*
     * Inseriamo la root nello stack.
     */
    nodeStack[stackTop] = ram;
    stackTop++;

    /*
     * Finché ci sono nodi da visitare, continuiamo.
     */
    while (stackTop > 0) {
        /*
         * Pop dello stack.
         */
        stackTop--;

        RAM currentNode = nodeStack[stackTop];

        /*
         * Se la stringa sta per riempirsi, la allarghiamo.
         */
        if (representationIndex + 2 >= stringCapacity) {
            stringCapacity = stringCapacity * 2;
            char *newRepresentation = realloc(representation, stringCapacity * sizeof(char));

            if (newRepresentation == NULL) {
                free(nodeStack);
                free(representation);

                char *emptyString = malloc(1);

                if (emptyString == NULL) {
                    return NULL;
                }

                emptyString[0] = '\0';

                return emptyString;
            }

            representation = newRepresentation;
        }

        /*
         * Se il nodo è interno, scriviamo 'I'
         * e poi mettiamo nello stack i figli.
         */
        if (currentNode->s == INTERNO) {
            /*
             * Un nodo interno deve avere entrambi i figli.
             * Se manca un figlio, la struttura è incoerente.
             */
            if (currentNode->lbuddy == NULL || currentNode->rbuddy == NULL) {
                free(nodeStack);
                free(representation);

                char *emptyString = malloc(1);

                if (emptyString == NULL) {
                    return NULL;
                }

                emptyString[0] = '\0';

                return emptyString;
            }

            representation[representationIndex] = 'I';
            representationIndex++;

            /*
             * Controlliamo che ci sia spazio nello stack per due figli.
             */
            if (stackTop + 2 >= stackCapacity) {
                stackCapacity = stackCapacity * 2;
                RAM *newNodeStack = realloc(nodeStack, stackCapacity * sizeof(RAM));

                if (newNodeStack == NULL) {
                    free(nodeStack);
                    free(representation);

                    char *emptyString = malloc(1);

                    if (emptyString == NULL) {
                        return NULL;
                    }

                    emptyString[0] = '\0';

                    return emptyString;
                }

                nodeStack = newNodeStack;
            }

            /*
             * Attenzione:
             * per ottenere una visita pre-order sinistra-destra con uno stack,
             * dobbiamo inserire prima il figlio destro e poi il sinistro.
             *
             * Lo stack è LIFO:
             * l'ultimo inserito viene visitato per primo.
             */
            nodeStack[stackTop] = currentNode->rbuddy;
            stackTop++;

            nodeStack[stackTop] = currentNode->lbuddy;
            stackTop++;
        }

        /*
         * Nodo libero: scriviamo 'L'.
         */
        else if (currentNode->s == LIBERO) {
            representation[representationIndex] = 'L';
            representationIndex++;
        }

        /*
         * Nodo occupato: scriviamo 'O'.
         */
        else if (currentNode->s == OCCUPATO) {
            representation[representationIndex] = 'O';
            representationIndex++;
        }

        /*
         * Stato non riconosciuto: errore.
         */
        else {
            free(nodeStack);
            free(representation);

            char *emptyString = malloc(1);

            if (emptyString == NULL) {
                return NULL;
            }

            emptyString[0] = '\0';

            return emptyString;
        }
    }

    /*
     * Chiudiamo la stringa con il terminatore.
     */
    representation[representationIndex] = '\0';

    /*
     * Lo stack non serve più.
     */
    free(nodeStack);

    return representation;
}

/*
 * Ricostruisce una RAM partendo da una stringa prodotta da ram2str.
 *
 * Il formato atteso è:
 *
 * dimensioneRadice:statiNodi
 *
 * Esempio:
 *
 * 8:IIOLOL
 *
 * La dimensione della root serve per calcolare automaticamente
 * la dimensione dei figli.
 */
RAM str2ram(char *representation) {
    /*
     * Stringa nulla o vuota: errore.
     */
    if (representation == NULL || representation[0] == '\0') {
        return NULL;
    }

    int representationIndex = 0;
    int rootSize = 0;

    /*
     * La stringa deve iniziare con una cifra.
     */
    if (representation[representationIndex] < '0' || representation[representationIndex] > '9') {
        return NULL;
    }

    /*
     * Leggiamo la dimensione della root fino al carattere ':'.
     */
    while (representation[representationIndex] >= '0' && representation[representationIndex] <= '9') {
        rootSize = rootSize * 10 + (representation[representationIndex] - '0');
        representationIndex++;
    }

    /*
     * Dopo la dimensione deve esserci ':'.
     */
    if (representation[representationIndex] != ':') {
        return NULL;
    }

    /*
     * La dimensione deve essere almeno 1.
     */
    if (rootSize < 1) {
        return NULL;
    }

    /*
     * Controlliamo che rootSize sia una potenza di 2.
     */
    int powerCheck = rootSize;

    while (powerCheck > 1) {
        if (powerCheck % 2 != 0) {
            return NULL;
        }

        powerCheck = powerCheck / 2;
    }

    /*
     * Saltiamo ':'.
     */
    representationIndex++;

    /*
     * Dopo ':' deve esserci almeno uno stato.
     */
    if (representation[representationIndex] == '\0') {
        return NULL;
    }

    /*
     * Leggiamo lo stato della root.
     */
    char nodeSymbol = representation[representationIndex];
    representationIndex++;

    /*
     * Gli unici simboli validi sono:
     * I, L, O.
     */
    if (nodeSymbol != 'I' && nodeSymbol != 'L' && nodeSymbol != 'O') {
        return NULL;
    }

    /*
     * Un nodo da 1 KB non può essere INTERNO,
     * perché non può essere diviso ulteriormente.
     */
    if (nodeSymbol == 'I' && rootSize <= 1) {
        return NULL;
    }

    /*
     * Allochiamo la root.
     */
    RAM rootNode = malloc(sizeof(*rootNode));

    if (rootNode == NULL) {
        return NULL;
    }

    rootNode->KB = rootSize;
    rootNode->parent = NULL;
    rootNode->lbuddy = NULL;
    rootNode->rbuddy = NULL;

    /*
     * Impostiamo lo stato della root in base al simbolo letto.
     */
    if (nodeSymbol == 'I') {
        rootNode->s = INTERNO;
    } else if (nodeSymbol == 'L') {
        rootNode->s = LIBERO;
    } else {
        rootNode->s = OCCUPATO;
    }

    /*
     * Se la root non è INTERNA, non deve avere figli.
     * Quindi la stringa deve essere già finita.
     */
    if (rootNode->s != INTERNO) {
        if (representation[representationIndex] != '\0') {
            free(rootNode);
            return NULL;
        }

        return rootNode;
    }

    /*
     * Se la root è interna, dobbiamo ricostruire i figli.
     *
     * Anche qui usiamo uno stack esplicito.
     *
     * nodeStack contiene i nodi interni a cui dobbiamo ancora assegnare figli.
     * nextChildIndex dice quale figlio dobbiamo assegnare:
     * - 0 significa prossimo figlio sinistro
     * - 1 significa prossimo figlio destro
     * - 2 significa entrambi i figli assegnati
     */
    int stackCapacity = 64;
    int stackTop = 0;

    RAM *nodeStack = malloc(stackCapacity * sizeof(RAM));
    int *nextChildIndex = malloc(stackCapacity * sizeof(int));

    if (nodeStack == NULL || nextChildIndex == NULL) {
        free(nodeStack);
        free(nextChildIndex);
        free(rootNode);
        return NULL;
    }

    /*
     * La root è il primo nodo interno da completare.
     */
    nodeStack[stackTop] = rootNode;
    nextChildIndex[stackTop] = 0;
    stackTop++;

    /*
     * Continuiamo finché ci sono nodi interni da completare.
     */
    while (stackTop > 0) {
        /*
         * Se la stringa finisce prima di completare l'albero,
         * allora la rappresentazione non è valida.
         */
        if (representation[representationIndex] == '\0') {
            freeram(&rootNode);
            free(nodeStack);
            free(nextChildIndex);
            return NULL;
        }

        /*
         * Il padre corrente è in cima allo stack.
         */
        RAM parentNode = nodeStack[stackTop - 1];

        /*
         * Ogni figlio ha metà della dimensione del padre.
         */
        int childSize = parentNode->KB / 2;

        /*
         * Leggiamo il simbolo del prossimo nodo.
         */
        nodeSymbol = representation[representationIndex];
        representationIndex++;

        if (nodeSymbol != 'I' && nodeSymbol != 'L' && nodeSymbol != 'O') {
            freeram(&rootNode);
            free(nodeStack);
            free(nextChildIndex);
            return NULL;
        }

        /*
         * Anche qui un nodo da 1 KB non può essere interno.
         */
        if (nodeSymbol == 'I' && childSize <= 1) {
            freeram(&rootNode);
            free(nodeStack);
            free(nextChildIndex);
            return NULL;
        }

        /*
         * Allochiamo il figlio.
         */
        RAM childNode = malloc(sizeof(*childNode));

        if (childNode == NULL) {
            freeram(&rootNode);
            free(nodeStack);
            free(nextChildIndex);
            return NULL;
        }

        childNode->KB = childSize;
        childNode->parent = parentNode;
        childNode->lbuddy = NULL;
        childNode->rbuddy = NULL;

        /*
         * Impostiamo lo stato del figlio.
         */
        if (nodeSymbol == 'I') {
            childNode->s = INTERNO;
        } else if (nodeSymbol == 'L') {
            childNode->s = LIBERO;
        } else {
            childNode->s = OCCUPATO;
        }

        /*
         * Colleghiamo il figlio al padre.
         *
         * Se nextChildIndex vale 0, stiamo assegnando il figlio sinistro.
         * Altrimenti stiamo assegnando il figlio destro.
         */
        if (nextChildIndex[stackTop - 1] == 0) {
            parentNode->lbuddy = childNode;
            nextChildIndex[stackTop - 1] = 1;
        } else {
            parentNode->rbuddy = childNode;
            nextChildIndex[stackTop - 1] = 2;
        }

        /*
         * Se il figlio appena creato è INTERNO,
         * dovremo assegnare anche i suoi figli.
         *
         * Quindi lo aggiungiamo allo stack.
         */
        if (childNode->s == INTERNO) {
            /*
             * Se lo stack non basta, lo allarghiamo.
             */
            if (stackTop + 1 >= stackCapacity) {
                stackCapacity = stackCapacity * 2;

                RAM *newNodeStack = realloc(nodeStack, stackCapacity * sizeof(RAM));

                if (newNodeStack == NULL) {
                    freeram(&rootNode);
                    free(nodeStack);
                    free(nextChildIndex);
                    return NULL;
                }

                nodeStack = newNodeStack;

                int *newNextChildIndex = realloc(nextChildIndex, stackCapacity * sizeof(int));

                if (newNextChildIndex == NULL) {
                    freeram(&rootNode);
                    free(nodeStack);
                    free(nextChildIndex);
                    return NULL;
                }

                nextChildIndex = newNextChildIndex;
            }

            nodeStack[stackTop] = childNode;
            nextChildIndex[stackTop] = 0;
            stackTop++;
        }

        /*
         * Se invece il figlio non è interno, non ha figli.
         *
         * Dopo aver assegnato un figlio foglia, potremmo aver completato
         * uno o più nodi interni. Quindi togliamo dallo stack tutti
         * i nodi che hanno già entrambi i figli.
         */
        else {
            while (stackTop > 0 && nextChildIndex[stackTop - 1] == 2) {
                stackTop--;
            }
        }
    }

    /*
     * Se dopo aver ricostruito l'albero rimangono caratteri nella stringa,
     * allora la stringa contiene nodi in più ed è errata.
     */
    if (representation[representationIndex] != '\0') {
        freeram(&rootNode);
        free(nodeStack);
        free(nextChildIndex);
        return NULL;
    }

    free(nodeStack);
    free(nextChildIndex);

    return rootNode;
}

/*
 * Libera completamente una struttura RAM.
 *
 * Riceve un puntatore a RAM, cioè RAM*,
 * perché deve poter mettere a NULL il puntatore originale.
 *
 * Restituisce:
 * - OK se libera effettivamente memoria
 * - NOK se ramptr è NULL oppure *ramptr è NULL
 */
Risultato freeram(RAM* ramPtr) {
    /*
     * Se il puntatore è NULL o punta a una RAM NULL,
     * non c'è niente da liberare.
     */
    if (ramPtr == NULL || *ramPtr == NULL) {
        return NOK;
    }

    RAM ram = *ramPtr;

    /*
     * Prima liberiamo ricorsivamente i figli.
     *
     * Anche se un nodo non ha figli, la chiamata restituirà NOK,
     * ma a noi non interessa: l'importante è liberare tutto ciò che esiste.
     */
    freeram(&(ram->lbuddy));
    freeram(&(ram->rbuddy));

    /*
     * Dopo aver liberato i figli, possiamo liberare il nodo corrente.
     */
    free(ram);

    /*
     * Mettiamo a NULL il puntatore originale.
     *
     * Questo evita dangling pointer.
     */
    *ramPtr = NULL;

    return OK;
}
```

---

# Rappresentazione con `ram2str`

Il formato scelto è:

```text
KB:stati
```

Esempio:

```text
8:IIOLOL
```

Dove:

|Simbolo|Significato|
|---|---|
|`I`|nodo interno|
|`L`|nodo libero|
|`O`|nodo occupato|

La visita è in **pre-order**:

```text
nodo corrente -> figlio sinistro -> figlio destro
```

Questo è importante perché consente a `str2ram` di ricostruire esattamente lo stesso albero.

---

# Esempio di albero e stringa

Supponiamo una RAM da `8 KB`.

Dopo una certa sequenza di allocazioni potremmo avere:

```text
        8 I
       /   \
    4 I     4 L
   /   \
 2 O   2 L
```

La visita pre-order è:

```text
8 I
4 I
2 O
2 L
4 L
```

Quindi la stringa sarà:

```text
8:IIOLL
```

---

# Funzione `allocram`: cosa ricordare

La funzione segue questa logica:

```text
se nodo NULL o richiesta impossibile:
    return NULL

se nodo OCCUPATO:
    return NULL

se nodo INTERNO:
    prova a sinistra
    se fallisce, prova a destra

se nodo LIBERO:
    se può essere diviso:
        dividi
        continua a sinistra
    altrimenti:
        marca come OCCUPATO
```

La priorità a sinistra è obbligatoria per i test.

---

# Funzione `deallocram`: cosa ricordare

Quando liberi un nodo:

1. il nodo diventa `LIBERO`;
    
2. se il suo buddy è libero, i due nodi vengono fusi;
    
3. il padre torna `LIBERO`;
    
4. si prova a fondere ancora salendo verso la root.
    

Esempio:

```text
        4 I
       /   \
    2 L     2 L
```

diventa:

```text
        4 L
```

---

# Perché `freeram` riceve `RAM*`

La funzione è dichiarata così:

```c
Risultato freeram(RAM* ramPtr);
```

e non così:

```c
Risultato freeram(RAM ram);
```

perché deve poter modificare il puntatore originale.

Dentro la funzione facciamo:

```c
*ramPtr = NULL;
```

Così, dopo aver chiamato:

```c
freeram(&ram);
```

il puntatore `ram` nel chiamante diventa davvero `NULL`.

Questo evita un **dangling pointer**, cioè un puntatore che continua a puntare a memoria già liberata.

---

# Complessità principali

Indichiamo con:

```text
n = numero di nodi dell'albero
h = altezza dell'albero
```

|Funzione|Complessità|
|---|--:|
|`initram`|O(log M)|
|`allocram`|O(n) nel caso peggiore|
|`deallocram`|O(h)|
|`numfree`|O(n)|
|`ram2str`|O(n)|
|`str2ram`|O(n)|
|`freeram`|O(n)|

---

# Concetti chiave da sapere per l'esame

## 1. Un nodo `INTERNO` non rappresenta memoria direttamente allocabile

Se un nodo è `INTERNO`, significa che la sua memoria è stata divisa tra i figli.

Quindi non si può allocare direttamente quel nodo.

---

## 2. Un nodo `LIBERO` può essere diviso

Un nodo libero può essere diviso solo se metà della sua dimensione è ancora sufficiente per contenere la richiesta.

Esempio:

```text
richiesta = 3 KB
nodo = 8 KB
```

Si può dividere, perché:

```text
8 / 2 = 4
4 >= 3
```

Ma con:

```text
richiesta = 3 KB
nodo = 4 KB
```

non si divide, perché:

```text
4 / 2 = 2
2 < 3
```

Quindi si occupa tutto il nodo da `4 KB`.

---

## 3. La ricerca deve andare prima a sinistra

Questa parte è fondamentale per i test:

```c
RAM allocatedNode = allocram(requestedSize, ram->lbuddy);

if (allocatedNode != NULL) {
    return allocatedNode;
}

return allocram(requestedSize, ram->rbuddy);
```

Prima si prova sempre il figlio sinistro.

Solo se fallisce si prova il figlio destro.

---

## 4. La fusione avviene solo tra due buddy liberi e foglia

Non basta che un nodo sia libero.

Per fondere due buddy, entrambi devono essere:

```text
LIBERI
```

e devono essere foglie, cioè senza figli.

---

## 5. `ram2str` e `str2ram` devono essere inverse

Idealmente, se fai:

```c
char *s = ram2str(ram);
RAM copy = str2ram(s);
```

allora `copy` deve rappresentare la stessa struttura di `ram`.

Per questo la stringa deve contenere:

1. la dimensione della radice;
    
2. lo stato di tutti i nodi;
    
3. l’ordine corretto dei nodi.
    

---

## 6. Il formato scelto contiene tutto il necessario

La stringa:

```text
8:IIOLL
```

è sufficiente perché:

- `8` dice la dimensione della root;
    
- ogni `I`, `L`, `O` dice lo stato dei nodi;
    
- l’ordine pre-order permette di sapere come collegare i figli;
    
- le dimensioni dei figli si ricavano dividendo per 2.
    

---

# Mini schema mentale

```text
initram
crea root libera

allocram
cerca spazio, splitta se serve, occupa

deallocram
libera un nodo e prova a fondere

numfree
somma i KB dei nodi liberi

ram2str
trasforma l'albero in stringa

str2ram
ricostruisce l'albero dalla stringa

freeram
libera tutto l'albero
```