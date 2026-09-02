# Pattern classici sulle liste linkate in C

```c
#include <stddef.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct intNode IntNode, *IntList;

struct intNode {
    int data;
    IntList next;
};
```

## Scorrimento semplice

```c
void printLikeTraversal(IntList ls) {
    for (IntList curr = ls; curr != NULL; curr = curr->next) {
        int value = curr->data;
        (void)value;
    }
}
```

## Lunghezza

```c
size_t listLength(IntList ls) {
    size_t count = 0;

    for (IntList curr = ls; curr != NULL; curr = curr->next) {
        count++;
    }

    return count;
}
```

## Ricerca di un valore

```c
bool contains(IntList ls, int value) {
    for (IntList curr = ls; curr != NULL; curr = curr->next) {
        if (curr->data == value) {
            return true;
        }
    }

    return false;
}
```

## Inserimento in testa

```c
bool insertFirst(IntList *lsPtr, int value) {
    if (lsPtr == NULL) {
        return false;
    }

    IntList newNode = malloc(sizeof *newNode);

    if (newNode == NULL) {
        return false;
    }

    newNode->data = value;
    newNode->next = *lsPtr;
    *lsPtr = newNode;

    return true;
}
```

## Inserimento in fondo con scansione

```c
bool insertLast(IntList *lsPtr, int value) {
    if (lsPtr == NULL) {
        return false;
    }

    IntList newNode = malloc(sizeof *newNode);

    if (newNode == NULL) {
        return false;
    }

    newNode->data = value;
    newNode->next = NULL;

    if (*lsPtr == NULL) {
        *lsPtr = newNode;
        return true;
    }

    IntList curr = *lsPtr;

    while (curr->next != NULL) {
        curr = curr->next;
    }

    curr->next = newNode;

    return true;
}
```

## Inserimento in fondo con puntatore al collegamento

```c
bool insertLastCompact(IntList *lsPtr, int value) {
    if (lsPtr == NULL) {
        return false;
    }

    while (*lsPtr != NULL) {
        lsPtr = &(*lsPtr)->next;
    }

    IntList newNode = malloc(sizeof *newNode);

    if (newNode == NULL) {
        return false;
    }

    newNode->data = value;
    newNode->next = NULL;
    *lsPtr = newNode;

    return true;
}
```

## Inserimento ordinato

```c
bool insertSorted(IntList *lsPtr, int value) {
    if (lsPtr == NULL) {
        return false;
    }

    IntList *currPtr = lsPtr;

    while (*currPtr != NULL && (*currPtr)->data < value) {
        currPtr = &(*currPtr)->next;
    }

    IntList newNode = malloc(sizeof *newNode);

    if (newNode == NULL) {
        return false;
    }

    newNode->data = value;
    newNode->next = *currPtr;
    *currPtr = newNode;

    return true;
}
```

## Eliminazione della prima occorrenza

```c
bool deleteFirst(IntList *lsPtr, int value) {
    if (lsPtr == NULL) {
        return false;
    }

    IntList *currPtr = lsPtr;

    while (*currPtr != NULL && (*currPtr)->data != value) {
        currPtr = &(*currPtr)->next;
    }

    if (*currPtr == NULL) {
        return false;
    }

    IntList victim = *currPtr;
    *currPtr = victim->next;
    free(victim);

    return true;
}
```

## Eliminazione di tutte le occorrenze

```c
size_t deleteAll(IntList *lsPtr, int value) {
    if (lsPtr == NULL) {
        return 0;
    }

    size_t removed = 0;
    IntList *currPtr = lsPtr;

    while (*currPtr != NULL) {
        if ((*currPtr)->data == value) {
            IntList victim = *currPtr;
            *currPtr = victim->next;
            free(victim);
            removed++;
        } else {
            currPtr = &(*currPtr)->next;
        }
    }

    return removed;
}
```

## Distruzione completa

```c
void destroyList(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    while (*lsPtr != NULL) {
        IntList victim = *lsPtr;
        *lsPtr = victim->next;
        free(victim);
    }
}
```

## Clonazione mantenendo l'ordine

```c
IntList cloneList(IntList ls) {
    IntList copy = NULL;
    IntList tail = NULL;

    for (IntList curr = ls; curr != NULL; curr = curr->next) {
        IntList newNode = malloc(sizeof *newNode);

        if (newNode == NULL) {
            destroyList(&copy);
            return NULL;
        }

        newNode->data = curr->data;
        newNode->next = NULL;

        if (copy == NULL) {
            copy = newNode;
            tail = newNode;
        } else {
            tail->next = newNode;
            tail = newNode;
        }
    }

    return copy;
}
```

## Selezione degli elementi alle posizioni multiple di k

```c
IntList everyKth(IntList ls, size_t k) {
    if (k == 0) {
        return NULL;
    }

    IntList result = NULL;
    IntList tail = NULL;
    size_t index = 0;

    for (IntList curr = ls; curr != NULL; curr = curr->next) {
        if (index % k == 0) {
            IntList newNode = malloc(sizeof *newNode);

            if (newNode == NULL) {
                destroyList(&result);
                return NULL;
            }

            newNode->data = curr->data;
            newNode->next = NULL;

            if (result == NULL) {
                result = newNode;
                tail = newNode;
            } else {
                tail->next = newNode;
                tail = newNode;
            }
        }

        index++;
    }

    return result;
}
```

## Inversione completa iterativa

```c
void reverseList(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    IntList prev = NULL;
    IntList curr = *lsPtr;

    while (curr != NULL) {
        IntList next = curr->next;
        curr->next = prev;
        prev = curr;
        curr = next;
    }

    *lsPtr = prev;
}
```

## Inversione completa ricorsiva

```c
IntList reverseListRecursive(IntList ls) {
    if (ls == NULL || ls->next == NULL) {
        return ls;
    }

    IntList newHead = reverseListRecursive(ls->next);

    ls->next->next = ls;
    ls->next = NULL;

    return newHead;
}
```

## Scambio dei nodi a coppie

```c
void swapPairs(IntList *lsPtr) {
    if (lsPtr == NULL) {
        return;
    }

    IntList *currPtr = lsPtr;

    while (*currPtr != NULL && (*currPtr)->next != NULL) {
        IntList first = *currPtr;
        IntList second = first->next;

        first->next = second->next;
        second->next = first;
        *currPtr = second;

        currPtr = &first->next;
    }
}
```

## Inversione di ogni gruppo completo di k nodi

```c
void reverseKGroups(IntList *lsPtr, size_t k) {
    if (lsPtr == NULL || k < 2) {
        return;
    }

    IntList *groupPtr = lsPtr;

    while (*groupPtr != NULL) {
        IntList afterGroup = *groupPtr;
        size_t count = 0;

        while (count < k && afterGroup != NULL) {
            afterGroup = afterGroup->next;
            count++;
        }

        if (count < k) {
            break;
        }

        IntList oldFirst = *groupPtr;
        IntList prev = afterGroup;
        IntList curr = oldFirst;

        for (size_t i = 0; i < k; i++) {
            IntList next = curr->next;
            curr->next = prev;
            prev = curr;
            curr = next;
        }

        *groupPtr = prev;
        groupPtr = &oldFirst->next;
    }
}
```

## Rotazione a sinistra di k posizioni

```c
void rotateLeft(IntList *lsPtr, size_t k) {
    if (lsPtr == NULL || *lsPtr == NULL || k == 0) {
        return;
    }

    size_t length = listLength(*lsPtr);
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

    IntList oldTail = newHead;

    while (oldTail->next != NULL) {
        oldTail = oldTail->next;
    }

    oldTail->next = *lsPtr;
    *lsPtr = newHead;
}
```

## Fusione di due liste ordinate senza nuovi nodi

```c
IntList mergeSorted(IntList a, IntList b) {
    IntList result = NULL;
    IntList *tailPtr = &result;

    while (a != NULL && b != NULL) {
        if (a->data <= b->data) {
            *tailPtr = a;
            a = a->next;
        } else {
            *tailPtr = b;
            b = b->next;
        }

        tailPtr = &(*tailPtr)->next;
    }

    if (a != NULL) {
        *tailPtr = a;
    } else {
        *tailPtr = b;
    }

    return result;
}
```

## Separazione in nodi pari e dispari per posizione

```c
void splitAlternating(
    IntList ls,
    IntList *evenPtr,
    IntList *oddPtr
) {
    if (evenPtr == NULL || oddPtr == NULL) {
        return;
    }

    *evenPtr = NULL;
    *oddPtr = NULL;

    IntList *evenTailPtr = evenPtr;
    IntList *oddTailPtr = oddPtr;
    size_t index = 0;

    while (ls != NULL) {
        IntList next = ls->next;
        ls->next = NULL;

        if (index % 2 == 0) {
            *evenTailPtr = ls;
            evenTailPtr = &ls->next;
        } else {
            *oddTailPtr = ls;
            oddTailPtr = &ls->next;
        }

        ls = next;
        index++;
    }
}
```

# Sequenze da memorizzare

## Scorrimento

```c
curr = curr->next;
```

## Spostamento del puntatore al collegamento

```c
currPtr = &(*currPtr)->next;
```

## Eliminazione tramite collegamento

```c
IntList victim = *currPtr;
*currPtr = victim->next;
free(victim);
```

## Inserimento tramite collegamento

```c
newNode->next = *currPtr;
*currPtr = newNode;
```

## Inversione

```c
IntList next = curr->next;
curr->next = prev;
prev = curr;
curr = next;
```

## Inserimento in coda con tail

```c
tail->next = newNode;
tail = newNode;
```

## Scambio di una coppia

```c
first->next = second->next;
second->next = first;
*currPtr = second;
currPtr = &first->next;
```
