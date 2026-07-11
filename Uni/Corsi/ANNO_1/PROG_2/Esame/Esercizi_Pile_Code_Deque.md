# Programmazione 2 — Esercizi su pile, code e deque

> Raccolta progressiva in stile esame: consegna, struttura di partenza, soluzione semplice, eventuale soluzione ottimizzata, complessità, casi limite, ownership, gestione della memoria ed errori tipici.
>
> Focus:
>
> - pile LIFO;
> - code FIFO;
> - deque;
> - implementazioni con array e liste;
> - ADT opachi;
> - trasformazioni tra strutture;
> - problemi algoritmici in stile LeetCode;
> - hidden test e casi limite;
> - soluzioni corrette prima, ottimizzazioni dopo.

Compilazione consigliata:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    -g -fsanitize=address,undefined file.c -o file
```

---

# 0. Idee fondamentali

## 0.1 Pila

Politica:

```text
LIFO = Last In, First Out
```

Operazioni tipiche:

```text
push
pop
top / peek
isEmpty
size
destroy
```

Con lista linkata:

```text
top → [dato | next] → [dato | next] → NULL
```

Il nodo in testa rappresenta la cima.

## 0.2 Coda

Politica:

```text
FIFO = First In, First Out
```

Operazioni tipiche:

```text
enqueue
dequeue
front / peek
isEmpty
size
destroy
```

Con lista linkata:

```text
front → [dato | next] → ... → [dato | NULL] ← rear
```

Per avere `enqueue` in `O(1)` servono normalmente entrambi:

```text
front
rear
```

## 0.3 Deque

Una deque consente inserimento e rimozione da entrambe le estremità:

```text
pushFront
pushBack
popFront
popBack
front
back
```

Implementazioni comuni:

- array circolare;
- lista doppiamente linkata.

## 0.4 Domande da porsi prima del codice

1. La struttura è vuota?
2. Cosa succede quando inserisco il primo elemento?
3. Cosa succede quando rimuovo l'ultimo?
4. `front`, `rear`, `top` devono diventare `NULL`?
5. La funzione modifica l'ADT?
6. Il dato viene copiato o spostato?
7. Chi possiede la memoria del dato?
8. La capacità è fissa o dinamica?
9. L'ordine logico coincide con quello fisico nell'array?
10. Serve una struttura ausiliaria?
11. È vietato modificare l'input?
12. È vietato allocare nuovi nodi?

---

# 1. Implementazioni di base

---

## Esercizio 1 — Pila di interi con lista linkata

### Consegna

Implementare un ADT pila di interi con lista linkata.

Operazioni richieste:

```c
IntStack *stackCreate(void);
int stackPush(IntStack *s, int value);
int stackPop(IntStack *s, int *out);
int stackTop(const IntStack *s, int *out);
size_t stackSize(const IntStack *s);
int stackIsEmpty(const IntStack *s);
void stackDestroy(IntStack **sPtr);
```

### Struttura di partenza

```c
#include <stddef.h>

typedef struct intStack IntStack;
```

### Soluzione semplice

```c
#include <stdlib.h>

typedef struct stackNode StackNode;

struct stackNode {
    int data;
    StackNode *next;
};

struct intStack {
    StackNode *top;
    size_t size;
};

IntStack *stackCreate(void) {
    IntStack *s = malloc(sizeof(*s));

    if (s == NULL) {
        return NULL;
    }

    s->top = NULL;
    s->size = 0;
    return s;
}

int stackPush(IntStack *s, int value) {
    if (s == NULL) {
        return 0;
    }

    StackNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        return 0;
    }

    node->data = value;
    node->next = s->top;
    s->top = node;
    s->size++;

    return 1;
}

int stackPop(IntStack *s, int *out) {
    if (s == NULL || out == NULL || s->top == NULL) {
        return 0;
    }

    StackNode *victim = s->top;
    *out = victim->data;
    s->top = victim->next;

    free(victim);
    s->size--;

    return 1;
}

int stackTop(const IntStack *s, int *out) {
    if (s == NULL || out == NULL || s->top == NULL) {
        return 0;
    }

    *out = s->top->data;
    return 1;
}

size_t stackSize(const IntStack *s) {
    return s == NULL ? 0 : s->size;
}

int stackIsEmpty(const IntStack *s) {
    return s == NULL || s->top == NULL;
}

void stackDestroy(IntStack **sPtr) {
    if (sPtr == NULL || *sPtr == NULL) {
        return;
    }

    IntStack *s = *sPtr;

    while (s->top != NULL) {
        StackNode *victim = s->top;
        s->top = s->top->next;
        free(victim);
    }

    free(s);
    *sPtr = NULL;
}
```

### Complessità

| Operazione | Tempo |
|---|---:|
| push | `O(1)` |
| pop | `O(1)` |
| top | `O(1)` |
| size | `O(1)` |
| destroy | `O(n)` |

### Caso limite fondamentale

Dopo il `pop` dell'ultimo elemento:

```text
top == NULL
size == 0
```

---

## Esercizio 2 — Pila dinamica con array

### Consegna

Implementare una pila di interi con array dinamico e crescita geometrica.

### Struttura di partenza

```c
typedef struct {
    int *data;
    size_t size;
    size_t capacity;
} ArrayStack;

int arrayStackInit(ArrayStack *s);
int arrayStackPush(ArrayStack *s, int value);
int arrayStackPop(ArrayStack *s, int *out);
int arrayStackTop(const ArrayStack *s, int *out);
void arrayStackDestroy(ArrayStack *s);
```

### Soluzione

```c
#include <stdlib.h>

int arrayStackInit(ArrayStack *s) {
    if (s == NULL) {
        return 0;
    }

    s->data = NULL;
    s->size = 0;
    s->capacity = 0;
    return 1;
}

int arrayStackPush(ArrayStack *s, int value) {
    if (s == NULL) {
        return 0;
    }

    if (s->size == s->capacity) {
        size_t newCapacity =
            s->capacity == 0 ? 4 : s->capacity * 2;

        int *tmp = realloc(
            s->data,
            newCapacity * sizeof(*tmp)
        );

        if (tmp == NULL) {
            return 0;
        }

        s->data = tmp;
        s->capacity = newCapacity;
    }

    s->data[s->size++] = value;
    return 1;
}

int arrayStackPop(ArrayStack *s, int *out) {
    if (s == NULL || out == NULL || s->size == 0) {
        return 0;
    }

    s->size--;
    *out = s->data[s->size];
    return 1;
}

int arrayStackTop(const ArrayStack *s, int *out) {
    if (s == NULL || out == NULL || s->size == 0) {
        return 0;
    }

    *out = s->data[s->size - 1];
    return 1;
}

void arrayStackDestroy(ArrayStack *s) {
    if (s == NULL) {
        return;
    }

    free(s->data);
    s->data = NULL;
    s->size = 0;
    s->capacity = 0;
}
```

### Complessità

- `push`: `O(1)` ammortizzato
- `pop`: `O(1)`
- spazio: `O(capacity)`

### Nota

Non è necessario ridurre la capacità a ogni `pop`: causerebbe riallocazioni inutili.

---

## Esercizio 3 — Coda di interi con lista linkata

### Consegna

Implementare una coda FIFO con lista linkata e operazioni in `O(1)`.

### Struttura di partenza

```c
typedef struct intQueue IntQueue;

IntQueue *queueCreate(void);
int queueEnqueue(IntQueue *q, int value);
int queueDequeue(IntQueue *q, int *out);
int queueFront(const IntQueue *q, int *out);
size_t queueSize(const IntQueue *q);
void queueDestroy(IntQueue **qPtr);
```

### Soluzione

```c
#include <stdlib.h>

typedef struct queueNode QueueNode;

struct queueNode {
    int data;
    QueueNode *next;
};

struct intQueue {
    QueueNode *front;
    QueueNode *rear;
    size_t size;
};

IntQueue *queueCreate(void) {
    IntQueue *q = malloc(sizeof(*q));

    if (q == NULL) {
        return NULL;
    }

    q->front = NULL;
    q->rear = NULL;
    q->size = 0;
    return q;
}

int queueEnqueue(IntQueue *q, int value) {
    if (q == NULL) {
        return 0;
    }

    QueueNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        return 0;
    }

    node->data = value;
    node->next = NULL;

    if (q->rear == NULL) {
        q->front = node;
        q->rear = node;
    } else {
        q->rear->next = node;
        q->rear = node;
    }

    q->size++;
    return 1;
}

int queueDequeue(IntQueue *q, int *out) {
    if (q == NULL || out == NULL || q->front == NULL) {
        return 0;
    }

    QueueNode *victim = q->front;
    *out = victim->data;

    q->front = victim->next;
    free(victim);

    q->size--;

    if (q->front == NULL) {
        q->rear = NULL;
    }

    return 1;
}

int queueFront(const IntQueue *q, int *out) {
    if (q == NULL || out == NULL || q->front == NULL) {
        return 0;
    }

    *out = q->front->data;
    return 1;
}

size_t queueSize(const IntQueue *q) {
    return q == NULL ? 0 : q->size;
}

void queueDestroy(IntQueue **qPtr) {
    if (qPtr == NULL || *qPtr == NULL) {
        return;
    }

    IntQueue *q = *qPtr;

    while (q->front != NULL) {
        QueueNode *victim = q->front;
        q->front = q->front->next;
        free(victim);
    }

    free(q);
    *qPtr = NULL;
}
```

### Trappola classica

Dopo la rimozione dell'ultimo nodo:

```c
q->front = NULL;
q->rear = NULL;
```

Se `rear` rimane dangling, il successivo `enqueue` può causare segmentation fault.

---

## Esercizio 4 — Coda circolare con array fisso

### Consegna

Implementare una coda circolare di capacità fissa.

### Struttura di partenza

```c
#define QUEUE_CAPACITY 8

typedef struct {
    int data[QUEUE_CAPACITY];
    size_t front;
    size_t size;
} CircularQueue;

void circularQueueInit(CircularQueue *q);
int circularQueueEnqueue(CircularQueue *q, int value);
int circularQueueDequeue(CircularQueue *q, int *out);
int circularQueueFront(const CircularQueue *q, int *out);
```

### Soluzione

```c
void circularQueueInit(CircularQueue *q) {
    q->front = 0;
    q->size = 0;
}

int circularQueueEnqueue(CircularQueue *q, int value) {
    if (q == NULL || q->size == QUEUE_CAPACITY) {
        return 0;
    }

    size_t rear =
        (q->front + q->size) % QUEUE_CAPACITY;

    q->data[rear] = value;
    q->size++;

    return 1;
}

int circularQueueDequeue(CircularQueue *q, int *out) {
    if (q == NULL || out == NULL || q->size == 0) {
        return 0;
    }

    *out = q->data[q->front];

    q->front =
        (q->front + 1) % QUEUE_CAPACITY;

    q->size--;

    return 1;
}

int circularQueueFront(
    const CircularQueue *q,
    int *out
) {
    if (q == NULL || out == NULL || q->size == 0) {
        return 0;
    }

    *out = q->data[q->front];
    return 1;
}
```

### Invarianti

```text
0 <= size <= capacity
front è sempre un indice valido
rear logico = (front + size) % capacity
```

---

## Esercizio 5 — Deque con lista doppiamente linkata

### Consegna

Implementare una deque di interi con operazioni `O(1)` a entrambe le estremità.

### Struttura di partenza

```c
typedef struct intDeque IntDeque;

IntDeque *dequeCreate(void);
int dequePushFront(IntDeque *d, int value);
int dequePushBack(IntDeque *d, int value);
int dequePopFront(IntDeque *d, int *out);
int dequePopBack(IntDeque *d, int *out);
void dequeDestroy(IntDeque **dPtr);
```

### Soluzione

```c
#include <stdlib.h>

typedef struct dequeNode DequeNode;

struct dequeNode {
    int data;
    DequeNode *prev;
    DequeNode *next;
};

struct intDeque {
    DequeNode *front;
    DequeNode *back;
    size_t size;
};

IntDeque *dequeCreate(void) {
    IntDeque *d = malloc(sizeof(*d));

    if (d == NULL) {
        return NULL;
    }

    d->front = NULL;
    d->back = NULL;
    d->size = 0;
    return d;
}

int dequePushFront(IntDeque *d, int value) {
    if (d == NULL) {
        return 0;
    }

    DequeNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        return 0;
    }

    node->data = value;
    node->prev = NULL;
    node->next = d->front;

    if (d->front == NULL) {
        d->back = node;
    } else {
        d->front->prev = node;
    }

    d->front = node;
    d->size++;
    return 1;
}

int dequePushBack(IntDeque *d, int value) {
    if (d == NULL) {
        return 0;
    }

    DequeNode *node = malloc(sizeof(*node));

    if (node == NULL) {
        return 0;
    }

    node->data = value;
    node->next = NULL;
    node->prev = d->back;

    if (d->back == NULL) {
        d->front = node;
    } else {
        d->back->next = node;
    }

    d->back = node;
    d->size++;
    return 1;
}

int dequePopFront(IntDeque *d, int *out) {
    if (d == NULL || out == NULL || d->front == NULL) {
        return 0;
    }

    DequeNode *victim = d->front;
    *out = victim->data;

    d->front = victim->next;

    if (d->front == NULL) {
        d->back = NULL;
    } else {
        d->front->prev = NULL;
    }

    free(victim);
    d->size--;
    return 1;
}

int dequePopBack(IntDeque *d, int *out) {
    if (d == NULL || out == NULL || d->back == NULL) {
        return 0;
    }

    DequeNode *victim = d->back;
    *out = victim->data;

    d->back = victim->prev;

    if (d->back == NULL) {
        d->front = NULL;
    } else {
        d->back->next = NULL;
    }

    free(victim);
    d->size--;
    return 1;
}

void dequeDestroy(IntDeque **dPtr) {
    if (dPtr == NULL || *dPtr == NULL) {
        return;
    }

    IntDeque *d = *dPtr;

    while (d->front != NULL) {
        DequeNode *victim = d->front;
        d->front = d->front->next;
        free(victim);
    }

    free(d);
    *dPtr = NULL;
}
```

### Trappola

Quando si rimuove l'ultimo elemento, entrambe le estremità devono diventare `NULL`.

---

# 2. Esercizi base su pile

---

## Esercizio 6 — Copia di una pila preservando l'ordine

### Consegna

Data una pila `source`, costruire una nuova pila con gli stessi elementi e lo stesso ordine logico.

`source` non deve essere modificata.

### Struttura di partenza

```c
IntStack *stackClone(const IntStack *source);
```

### Soluzione semplice con array temporaneo

```c
IntStack *stackClone(const IntStack *source) {
    if (source == NULL) {
        return NULL;
    }

    IntStack *copy = stackCreate();

    if (copy == NULL) {
        return NULL;
    }

    int *tmp = malloc(source->size * sizeof(*tmp));

    if (tmp == NULL && source->size > 0) {
        stackDestroy(&copy);
        return NULL;
    }

    const StackNode *current = source->top;
    size_t i = 0;

    while (current != NULL) {
        tmp[i++] = current->data;
        current = current->next;
    }

    while (i > 0) {
        i--;

        if (!stackPush(copy, tmp[i])) {
            free(tmp);
            stackDestroy(&copy);
            return NULL;
        }
    }

    free(tmp);
    return copy;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

### Perché non basta fare push durante la scansione

Scorrendo dall'alto verso il basso e facendo subito `push`, si invertirebbe l'ordine.

---

## Esercizio 7 — Inverti una pila usando una coda

### Consegna

Invertire l'ordine di una pila usando una coda ausiliaria.

### Soluzione semplice

```c
void reverseStackWithQueue(
    IntStack *s,
    IntQueue *q
) {
    int value;

    while (stackPop(s, &value)) {
        queueEnqueue(q, value);
    }

    while (queueDequeue(q, &value)) {
        stackPush(s, value);
    }
}
```

### Esempio

```text
top [1,2,3] bottom
→
top [3,2,1] bottom
```

### Complessità

- Tempo: `O(n)`
- Spazio ausiliario: `O(n)`

---

## Esercizio 8 — Verifica parentesi bilanciate

### Consegna

Data una stringa contenente caratteri arbitrari e parentesi `()[]{}`, restituire vero se le parentesi sono correttamente bilanciate e annidate.

Esempi:

```text
"(a+[b*c])" → vero
"([)]"      → falso
"(()"       → falso
```

### Struttura di partenza

```c
_Bool bracketsBalanced(const char *s);
```

### Soluzione semplice

```c
#include <stdlib.h>
#include <string.h>

static int matching(char open, char close) {
    return
        (open == '(' && close == ')') ||
        (open == '[' && close == ']') ||
        (open == '{' && close == '}');
}

_Bool bracketsBalanced(const char *s) {
    if (s == NULL) {
        return 0;
    }

    size_t n = strlen(s);
    char *stack = malloc(n);

    if (stack == NULL && n > 0) {
        return 0;
    }

    size_t top = 0;

    for (size_t i = 0; i < n; i++) {
        char c = s[i];

        if (c == '(' || c == '[' || c == '{') {
            stack[top++] = c;
        } else if (
            c == ')' || c == ']' || c == '}'
        ) {
            if (top == 0) {
                free(stack);
                return 0;
            }

            char open = stack[--top];

            if (!matching(open, c)) {
                free(stack);
                return 0;
            }
        }
    }

    _Bool result = top == 0;
    free(stack);
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 9 — Rimuovi parentesi esterne

### Consegna

Una stringa è concatenazione di blocchi di parentesi bilanciate primitivi.

Rimuovere la coppia più esterna di ogni blocco.

Esempio:

```text
"(()())(())" → "()()()"
```

### Struttura di partenza

```c
char *removeOuterParentheses(const char *s);
```

### Soluzione semplice senza pila esplicita

```c
#include <stdlib.h>
#include <string.h>

char *removeOuterParentheses(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t n = strlen(s);
    char *result = malloc(n + 1);

    if (result == NULL) {
        return NULL;
    }

    size_t depth = 0;
    size_t write = 0;

    for (size_t i = 0; i < n; i++) {
        if (s[i] == '(') {
            if (depth > 0) {
                result[write++] = s[i];
            }

            depth++;
        } else {
            depth--;

            if (depth > 0) {
                result[write++] = s[i];
            }
        }
    }

    result[write] = '\0';
    return result;
}
```

### Osservazione

La profondità svolge il ruolo di una pila compressa, perché esiste un solo tipo di parentesi.

---

## Esercizio 10 — Valutazione di espressione postfix

### Consegna

Valutare un'espressione postfix contenente interi separati da spazi e operatori `+ - * /`.

Esempio:

```text
"2 3 4 * +" → 14
```

Si assume input valido e divisione intera.

### Struttura di partenza

```c
int evalPostfix(const char *expr, int *out);
```

### Soluzione semplice

```c
#include <stdlib.h>
#include <ctype.h>

int evalPostfix(const char *expr, int *out) {
    if (expr == NULL || out == NULL) {
        return 0;
    }

    ArrayStack s;
    arrayStackInit(&s);

    size_t i = 0;

    while (expr[i] != '\0') {
        if (expr[i] == ' ') {
            i++;
            continue;
        }

        if (isdigit((unsigned char)expr[i]) ||
            ((expr[i] == '-' || expr[i] == '+') &&
             isdigit((unsigned char)expr[i + 1]))) {
            char *end;
            long value = strtol(expr + i, &end, 10);

            if (!arrayStackPush(&s, (int)value)) {
                arrayStackDestroy(&s);
                return 0;
            }

            i = (size_t)(end - expr);
        } else {
            int right;
            int left;

            if (!arrayStackPop(&s, &right) ||
                !arrayStackPop(&s, &left)) {
                arrayStackDestroy(&s);
                return 0;
            }

            int result;

            switch (expr[i]) {
                case '+': result = left + right; break;
                case '-': result = left - right; break;
                case '*': result = left * right; break;
                case '/':
                    if (right == 0) {
                        arrayStackDestroy(&s);
                        return 0;
                    }
                    result = left / right;
                    break;
                default:
                    arrayStackDestroy(&s);
                    return 0;
            }

            if (!arrayStackPush(&s, result)) {
                arrayStackDestroy(&s);
                return 0;
            }

            i++;
        }
    }

    if (s.size != 1) {
        arrayStackDestroy(&s);
        return 0;
    }

    arrayStackPop(&s, out);
    arrayStackDestroy(&s);

    return 1;
}
```

### Trappola

Per operatori non commutativi:

```text
left op right
```

Il primo `pop` restituisce l'operando destro.

---

## Esercizio 11 — Elimina duplicati adiacenti da una stringa

### Consegna

Data una stringa, eliminare ripetutamente coppie di caratteri uguali adiacenti fino a stabilizzazione.

Esempio:

```text
"abbaca" → "ca"
```

### Struttura di partenza

```c
char *removeAdjacentPairs(const char *s);
```

### Soluzione con pila su array

```c
#include <stdlib.h>
#include <string.h>

char *removeAdjacentPairs(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t n = strlen(s);
    char *stack = malloc(n + 1);

    if (stack == NULL) {
        return NULL;
    }

    size_t top = 0;

    for (size_t i = 0; i < n; i++) {
        if (top > 0 && stack[top - 1] == s[i]) {
            top--;
        } else {
            stack[top++] = s[i];
        }
    }

    stack[top] = '\0';

    char *tmp = realloc(stack, top + 1);

    if (tmp != NULL) {
        stack = tmp;
    }

    return stack;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 12 — Next greater element

### Consegna

Dato un array `a`, restituire un nuovo array `result` tale che `result[i]` sia il primo elemento a destra di `a[i]` strettamente maggiore, oppure `-1` se non esiste.

Esempio:

```text
[2,1,2,4,3] → [4,2,4,-1,-1]
```

### Soluzione semplice `O(n²)`

Per ogni indice, cercare linearmente a destra.

### Soluzione ottimizzata con pila monotona

```c
#include <stdlib.h>

int *nextGreater(const int a[], size_t n) {
    int *result = malloc(n * sizeof(*result));
    size_t *stack = malloc(n * sizeof(*stack));

    if ((result == NULL || stack == NULL) && n > 0) {
        free(result);
        free(stack);
        return NULL;
    }

    size_t top = 0;

    for (size_t i = n; i > 0; i--) {
        size_t index = i - 1;

        while (
            top > 0 &&
            a[stack[top - 1]] <= a[index]
        ) {
            top--;
        }

        result[index] =
            top == 0 ? -1 : a[stack[top - 1]];

        stack[top++] = index;
    }

    free(stack);
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

### Perché è lineare

Ogni indice entra ed esce dalla pila al massimo una volta.

---

## Esercizio 13 — Temperature giornaliere

### Consegna

Dato un array di temperature, per ogni giorno restituire quanti giorni bisogna aspettare per una temperatura maggiore.

Esempio:

```text
[73,74,75,71,69,72,76,73]
→ [1,1,4,2,1,1,0,0]
```

### Soluzione con pila monotona

```c
size_t *daysUntilWarmer(
    const int t[],
    size_t n
) {
    size_t *result =
        calloc(n, sizeof(*result));

    size_t *stack =
        malloc(n * sizeof(*stack));

    if ((result == NULL || stack == NULL) && n > 0) {
        free(result);
        free(stack);
        return NULL;
    }

    size_t top = 0;

    for (size_t i = 0; i < n; i++) {
        while (
            top > 0 &&
            t[i] > t[stack[top - 1]]
        ) {
            size_t previous = stack[--top];
            result[previous] = i - previous;
        }

        stack[top++] = i;
    }

    free(stack);
    return result;
}
```

---

## Esercizio 14 — Area massima nell'istogramma

### Consegna

Dato un array di altezze non negative, calcolare l'area massima di un rettangolo contenuto nell'istogramma.

Esempio:

```text
[2,1,5,6,2,3] → 10
```

### Soluzione semplice `O(n²)`

Per ogni barra, espandersi a sinistra e a destra finché le altezze restano almeno quella corrente.

### Soluzione ottimizzata con pila monotona

```c
#include <stdlib.h>

size_t largestRectangleArea(
    const size_t h[],
    size_t n
) {
    size_t *stack =
        malloc((n + 1) * sizeof(*stack));

    if (stack == NULL && n > 0) {
        return 0;
    }

    size_t top = 0;
    size_t best = 0;

    for (size_t i = 0; i <= n; i++) {
        size_t currentHeight =
            i == n ? 0 : h[i];

        while (
            top > 0 &&
            h[stack[top - 1]] > currentHeight
        ) {
            size_t heightIndex = stack[--top];
            size_t height = h[heightIndex];

            size_t leftBoundary =
                top == 0 ? 0 : stack[top - 1] + 1;

            size_t width = i - leftBoundary;
            size_t area = height * width;

            if (area > best) {
                best = area;
            }
        }

        stack[top++] = i;
    }

    free(stack);
    return best;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

# 3. Esercizi base su code

---

## Esercizio 15 — Copia di una coda preservando l'ordine

### Consegna

Creare una nuova coda con gli stessi elementi e nello stesso ordine, senza modificare l'input.

### Soluzione

```c
IntQueue *queueClone(const IntQueue *source) {
    if (source == NULL) {
        return NULL;
    }

    IntQueue *copy = queueCreate();

    if (copy == NULL) {
        return NULL;
    }

    const QueueNode *current = source->front;

    while (current != NULL) {
        if (!queueEnqueue(copy, current->data)) {
            queueDestroy(&copy);
            return NULL;
        }

        current = current->next;
    }

    return copy;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 16 — Ruota una coda di k posizioni

### Consegna

Spostare i primi `k` elementi in fondo alla coda.

Esempio:

```text
[1,2,3,4,5], k=2 → [3,4,5,1,2]
```

### Soluzione semplice

```c
void queueRotate(IntQueue *q, size_t k) {
    if (q == NULL || q->size == 0) {
        return;
    }

    k %= q->size;

    for (size_t i = 0; i < k; i++) {
        int value;

        if (queueDequeue(q, &value)) {
            queueEnqueue(q, value);
        }
    }
}
```

### Complessità

- Tempo: `O(k mod n)`
- Spazio: `O(1)`

---

## Esercizio 17 — Inverti i primi k elementi di una coda

### Consegna

Invertire l'ordine dei primi `k` elementi della coda, lasciando invariato l'ordine relativo dei restanti.

Esempio:

```text
[1,2,3,4,5], k=3 → [3,2,1,4,5]
```

### Soluzione semplice con pila

```c
int reverseFirstK(
    IntQueue *q,
    size_t k
) {
    if (q == NULL || k > q->size) {
        return 0;
    }

    ArrayStack s;
    arrayStackInit(&s);

    for (size_t i = 0; i < k; i++) {
        int value;
        queueDequeue(q, &value);

        if (!arrayStackPush(&s, value)) {
            arrayStackDestroy(&s);
            return 0;
        }
    }

    int value;

    while (arrayStackPop(&s, &value)) {
        queueEnqueue(q, value);
    }

    size_t remaining = q->size - k;

    for (size_t i = 0; i < remaining; i++) {
        queueDequeue(q, &value);
        queueEnqueue(q, value);
    }

    arrayStackDestroy(&s);
    return 1;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(k)`

---

## Esercizio 18 — Interleave delle due metà

### Consegna

Data una coda di lunghezza pari:

```text
[1,2,3,4,5,6]
```

riordinarla come:

```text
[1,4,2,5,3,6]
```

### Soluzione semplice con array temporaneo

```c
int interleaveQueue(IntQueue *q) {
    if (q == NULL || q->size % 2 != 0) {
        return 0;
    }

    size_t n = q->size;
    int *a = malloc(n * sizeof(*a));

    if (a == NULL && n > 0) {
        return 0;
    }

    for (size_t i = 0; i < n; i++) {
        queueDequeue(q, &a[i]);
    }

    size_t half = n / 2;

    for (size_t i = 0; i < half; i++) {
        queueEnqueue(q, a[i]);
        queueEnqueue(q, a[i + half]);
    }

    free(a);
    return 1;
}
```

### Soluzione più strutturale

È possibile usare una seconda coda e una pila, ma la soluzione con array è più semplice e meno soggetta a errori.

---

## Esercizio 19 — Generazione dei numeri binari da 1 a n

### Consegna

Generare in ordine le rappresentazioni binarie dei numeri da `1` a `n` usando una coda di stringhe.

Esempio:

```text
n=5 → "1", "10", "11", "100", "101"
```

### Idea

Partire da `"1"`.

Per ogni stringa estratta:

```text
s
s+"0"
s+"1"
```

Le ultime due vengono inserite in coda.

### Complessità

Il costo totale è proporzionale al numero complessivo di caratteri generati.

---

## Esercizio 20 — Primo carattere non ripetuto in uno stream

### Consegna

Data una stringa letta da sinistra a destra, produrre per ogni prefisso il primo carattere con frequenza esattamente uno, oppure `'#'`.

Esempio:

```text
"aabc"
→ "a#bb"
```

### Soluzione con coda e frequenze

```c
#include <limits.h>
#include <stdlib.h>
#include <string.h>

char *firstNonRepeatingStream(
    const char *s
) {
    if (s == NULL) {
        return NULL;
    }

    size_t n = strlen(s);
    char *result = malloc(n + 1);
    unsigned char *queue = malloc(n);

    if ((result == NULL || queue == NULL) && n > 0) {
        free(result);
        free(queue);
        return NULL;
    }

    size_t frequency[UCHAR_MAX + 1] = {0};
    size_t front = 0;
    size_t rear = 0;

    for (size_t i = 0; i < n; i++) {
        unsigned char c = (unsigned char)s[i];
        frequency[c]++;
        queue[rear++] = c;

        while (
            front < rear &&
            frequency[queue[front]] > 1
        ) {
            front++;
        }

        result[i] =
            front < rear ? (char)queue[front] : '#';
    }

    result[n] = '\0';

    free(queue);
    return result;
}
```

---

## Esercizio 21 — Implementa una pila usando due code

### Consegna

Implementare una pila usando esclusivamente due code.

### Strategia semplice: push costoso

Per mantenere sempre in testa alla prima coda l'elemento più recente:

1. inserisci il nuovo elemento nella seconda coda;
2. sposta tutti gli elementi della prima nella seconda;
3. scambia le due code.

### Complessità

| Operazione | Tempo |
|---|---:|
| push | `O(n)` |
| pop | `O(1)` |
| top | `O(1)` |

### Struttura

```c
typedef struct {
    IntQueue *primary;
    IntQueue *secondary;
} StackWithQueues;
```

---

## Esercizio 22 — Implementa una coda usando due pile

### Consegna

Implementare una coda usando due pile:

```text
inStack
outStack
```

### Strategia ammortizzata

- `enqueue`: push in `inStack`;
- `dequeue`: se `outStack` è vuota, sposta tutto da `inStack` a `outStack`, poi pop.

### Soluzione

```c
typedef struct {
    ArrayStack in;
    ArrayStack out;
} QueueWithStacks;

int queueStacksInit(QueueWithStacks *q) {
    if (q == NULL) {
        return 0;
    }

    arrayStackInit(&q->in);
    arrayStackInit(&q->out);
    return 1;
}

int queueStacksEnqueue(
    QueueWithStacks *q,
    int value
) {
    return arrayStackPush(&q->in, value);
}

static int refillOut(QueueWithStacks *q) {
    if (q->out.size > 0) {
        return 1;
    }

    int value;

    while (arrayStackPop(&q->in, &value)) {
        if (!arrayStackPush(&q->out, value)) {
            return 0;
        }
    }

    return 1;
}

int queueStacksDequeue(
    QueueWithStacks *q,
    int *out
) {
    if (q == NULL || out == NULL) {
        return 0;
    }

    if (!refillOut(q)) {
        return 0;
    }

    return arrayStackPop(&q->out, out);
}
```

### Complessità

- `enqueue`: `O(1)` ammortizzato
- `dequeue`: `O(1)` ammortizzato
- ogni elemento viene trasferito al massimo una volta tra le due pile.

---

# 4. Esercizi su deque

---

## Esercizio 23 — Deque circolare dinamica

### Consegna

Implementare una deque su array circolare dinamico.

### Struttura di partenza

```c
typedef struct {
    int *data;
    size_t capacity;
    size_t size;
    size_t front;
} ArrayDeque;
```

### Funzioni

```c
int dequeInit(ArrayDeque *d);
int dequePushFrontArray(ArrayDeque *d, int value);
int dequePushBackArray(ArrayDeque *d, int value);
int dequePopFrontArray(ArrayDeque *d, int *out);
int dequePopBackArray(ArrayDeque *d, int *out);
void dequeDestroyArray(ArrayDeque *d);
```

### Resize corretto

```c
static int dequeGrow(ArrayDeque *d) {
    size_t newCapacity =
        d->capacity == 0 ? 4 : d->capacity * 2;

    int *newData =
        malloc(newCapacity * sizeof(*newData));

    if (newData == NULL) {
        return 0;
    }

    for (size_t i = 0; i < d->size; i++) {
        newData[i] =
            d->data[(d->front + i) % d->capacity];
    }

    free(d->data);
    d->data = newData;
    d->capacity = newCapacity;
    d->front = 0;

    return 1;
}
```

### Push front

```c
int dequePushFrontArray(
    ArrayDeque *d,
    int value
) {
    if (d == NULL) {
        return 0;
    }

    if (d->size == d->capacity) {
        if (!dequeGrow(d)) {
            return 0;
        }
    }

    d->front =
        (d->front + d->capacity - 1) %
        d->capacity;

    d->data[d->front] = value;
    d->size++;

    return 1;
}
```

### Push back

```c
int dequePushBackArray(
    ArrayDeque *d,
    int value
) {
    if (d == NULL) {
        return 0;
    }

    if (d->size == d->capacity) {
        if (!dequeGrow(d)) {
            return 0;
        }
    }

    size_t back =
        (d->front + d->size) % d->capacity;

    d->data[back] = value;
    d->size++;

    return 1;
}
```

### Pop back

```c
int dequePopBackArray(
    ArrayDeque *d,
    int *out
) {
    if (d == NULL || out == NULL || d->size == 0) {
        return 0;
    }

    size_t index =
        (d->front + d->size - 1) % d->capacity;

    *out = d->data[index];
    d->size--;

    if (d->size == 0) {
        d->front = 0;
    }

    return 1;
}
```

---

## Esercizio 24 — Palindromo con deque

### Consegna

Verificare se una stringa è palindroma usando una deque.

### Soluzione semplice

1. Inserire tutti i caratteri nella deque.
2. Estrarre contemporaneamente da fronte e fondo.
3. Confrontare fino a esaurimento.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

### Nota

Per una semplice stringa indicizzata, il confronto con due indici è più diretto. L'esercizio serve a imparare l'uso della deque.

---

## Esercizio 25 — Sliding window maximum

### Consegna

Dato un array `a` e una finestra di ampiezza `k`, restituire il massimo di ogni finestra contigua.

Esempio:

```text
a = [1,3,-1,-3,5,3,6,7]
k = 3
→ [3,3,5,5,6,7]
```

### Soluzione semplice `O(nk)`

Calcolare il massimo separatamente per ogni finestra.

### Soluzione ottimizzata con deque monotona

```c
#include <stdlib.h>

int *slidingWindowMax(
    const int a[],
    size_t n,
    size_t k,
    size_t *outSize
) {
    if (outSize == NULL || k == 0 || k > n) {
        return NULL;
    }

    *outSize = n - k + 1;

    int *result =
        malloc(*outSize * sizeof(*result));

    size_t *deque =
        malloc(n * sizeof(*deque));

    if (result == NULL || deque == NULL) {
        free(result);
        free(deque);
        return NULL;
    }

    size_t front = 0;
    size_t back = 0;
    size_t write = 0;

    for (size_t i = 0; i < n; i++) {
        while (
            front < back &&
            deque[front] + k <= i
        ) {
            front++;
        }

        while (
            front < back &&
            a[deque[back - 1]] <= a[i]
        ) {
            back--;
        }

        deque[back++] = i;

        if (i + 1 >= k) {
            result[write++] = a[deque[front]];
        }
    }

    free(deque);
    return result;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(k)` logicamente, `O(n)` nell'array usato qui

---

## Esercizio 26 — Prima posizione negativa in ogni finestra

### Consegna

Per ogni finestra di ampiezza `k`, restituire il primo valore negativo, oppure `0` se assente.

### Idea

La deque contiene gli indici dei soli elementi negativi ancora appartenenti alla finestra.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(k)`

---

## Esercizio 27 — Shortest subarray con somma almeno K

### Consegna

Dato un array che può contenere anche valori negativi, trovare la lunghezza minima di un sottoarray contiguo con somma almeno `K`.

Restituire `0` se non esiste.

### Idea avanzata

Usare somme prefisse:

```text
prefix[j] - prefix[i] >= K
```

e mantenere in deque indici con somme prefisse strettamente crescenti.

### Soluzione

```c
#include <stdlib.h>

size_t shortestSubarrayAtLeastK(
    const int a[],
    size_t n,
    long long K
) {
    long long *prefix =
        malloc((n + 1) * sizeof(*prefix));

    size_t *deque =
        malloc((n + 1) * sizeof(*deque));

    if (prefix == NULL || deque == NULL) {
        free(prefix);
        free(deque);
        return 0;
    }

    prefix[0] = 0;

    for (size_t i = 0; i < n; i++) {
        prefix[i + 1] = prefix[i] + a[i];
    }

    size_t front = 0;
    size_t back = 0;
    size_t best = n + 1;

    for (size_t i = 0; i <= n; i++) {
        while (
            front < back &&
            prefix[i] - prefix[deque[front]] >= K
        ) {
            size_t length = i - deque[front++];

            if (length < best) {
                best = length;
            }
        }

        while (
            front < back &&
            prefix[i] <= prefix[deque[back - 1]]
        ) {
            back--;
        }

        deque[back++] = i;
    }

    free(prefix);
    free(deque);

    return best == n + 1 ? 0 : best;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

# 5. Problemi misti

---

## Esercizio 28 — Ordina una pila usando una sola pila ausiliaria

### Consegna

Ordinare una pila in modo che il minimo sia in cima, usando una sola pila ausiliaria.

Non usare array.

### Soluzione semplice

```c
void sortStack(IntStack *s) {
    IntStack *aux = stackCreate();

    if (aux == NULL) {
        return;
    }

    int current;
    int topValue;

    while (stackPop(s, &current)) {
        while (
            stackTop(aux, &topValue) &&
            topValue > current
        ) {
            stackPop(aux, &topValue);
            stackPush(s, topValue);
        }

        stackPush(aux, current);
    }

    while (stackPop(aux, &current)) {
        stackPush(s, current);
    }

    stackDestroy(&aux);
}
```

### Complessità

- Tempo peggiore: `O(n²)`
- Spazio: `O(n)`

---

## Esercizio 29 — MinStack

### Consegna

Implementare una pila che supporti:

```text
push
pop
top
getMin
```

tutte in `O(1)`.

### Soluzione semplice con due pile

```text
data stack
min stack
```

Quando si inserisce un valore:

- push nella pila dati;
- push nella pila minimi se è minore o uguale al minimo corrente.

Quando si rimuove:

- se il valore rimosso è uguale al minimo corrente, pop anche dalla pila minimi.

### Complessità

- tutte le operazioni: `O(1)`
- spazio: `O(n)`

---

## Esercizio 30 — Coda con massimo in O(1)

### Consegna

Implementare una coda che supporti:

```text
enqueue
dequeue
front
getMax
```

tutte in tempo ammortizzato `O(1)`.

### Idea

Usare:

- una coda normale per i dati;
- una deque monotona decrescente per i candidati massimi.

In `enqueue(x)`:

```text
rimuovi dal fondo tutti i valori < x
inserisci x in fondo
```

In `dequeue()`:

```text
se il valore rimosso è uguale al fronte della deque dei massimi
rimuovilo anche da lì
```

---

## Esercizio 31 — Verifica sequenza di pop da una pila

### Consegna

Dati due array `pushed` e `popped`, verificare se `popped` può essere ottenuto eseguendo operazioni di push e pop su una pila, inserendo gli elementi nell'ordine di `pushed`.

Esempio:

```text
pushed = [1,2,3,4,5]
popped = [4,5,3,2,1]
→ vero
```

### Soluzione

```c
_Bool validateStackSequences(
    const int pushed[],
    const int popped[],
    size_t n
) {
    int *stack = malloc(n * sizeof(*stack));

    if (stack == NULL && n > 0) {
        return 0;
    }

    size_t top = 0;
    size_t popIndex = 0;

    for (size_t i = 0; i < n; i++) {
        stack[top++] = pushed[i];

        while (
            top > 0 &&
            popIndex < n &&
            stack[top - 1] == popped[popIndex]
        ) {
            top--;
            popIndex++;
        }
    }

    free(stack);
    return popIndex == n;
}
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 32 — Asteroid collision

### Consegna

Ogni intero rappresenta un asteroide:

- segno: direzione;
- valore assoluto: dimensione.

Gli asteroidi si muovono alla stessa velocità. Due asteroidi collidono solo se uno va a destra e il successivo a sinistra.

Restituire gli asteroidi sopravvissuti.

Esempio:

```text
[5,10,-5] → [5,10]
[8,-8]    → []
[10,2,-5] → [10]
```

### Soluzione con pila

```c
int *asteroidCollision(
    const int a[],
    size_t n,
    size_t *outSize
) {
    int *stack = malloc(n * sizeof(*stack));

    if (stack == NULL && n > 0) {
        return NULL;
    }

    size_t top = 0;

    for (size_t i = 0; i < n; i++) {
        int current = a[i];
        int alive = 1;

        while (
            alive &&
            current < 0 &&
            top > 0 &&
            stack[top - 1] > 0
        ) {
            int left = stack[top - 1];

            if (left < -current) {
                top--;
            } else if (left == -current) {
                top--;
                alive = 0;
            } else {
                alive = 0;
            }
        }

        if (alive) {
            stack[top++] = current;
        }
    }

    *outSize = top;

    int *tmp = realloc(stack, top * sizeof(*tmp));

    if (tmp != NULL || top == 0) {
        stack = tmp;
    }

    return stack;
}
```

---

## Esercizio 33 — Decode string

### Consegna

Decodificare stringhe del tipo:

```text
"3[a2[c]]" → "accaccacc"
```

### Idea

Usare due pile:

- pila dei numeri di ripetizione;
- pila delle stringhe parziali.

Quando si legge `[`:

```text
salva count e stringa corrente
azzera lo stato corrente
```

Quando si legge `]`:

```text
ripeti la stringa corrente
appendila alla stringa salvata
```

### Punto delicato

Servono buffer dinamici con gestione corretta di capacità e `realloc`.

---

## Esercizio 34 — Canonical path

### Consegna

Data una path Unix assoluta, semplificarla.

Esempio:

```text
"/a/./b/../../c/" → "/c"
```

Regole:

- `"."` viene ignorato;
- `".."` rimuove la directory precedente;
- slash multipli valgono come uno.

### Idea

Usare una pila di componenti di path.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 35 — Simulazione di processi round-robin

### Consegna

Ogni processo ha:

```c
typedef struct {
    int id;
    unsigned int remaining;
} Process;
```

Data una coda di processi e un quanto `q`, simulare round-robin fino al completamento.

A ogni turno:

- si estrae il processo in testa;
- si eseguono al massimo `q` unità;
- se resta lavoro, il processo torna in fondo;
- altrimenti viene registrato come completato.

### Soluzione semplice

```c
while (!queueEmpty) {
    dequeue process;

    if (process.remaining <= quantum) {
        process.remaining = 0;
        salva completamento;
    } else {
        process.remaining -= quantum;
        enqueue process;
    }
}
```

### Complessità

Dipende dal numero totale di quanti eseguiti.

---

## Esercizio 36 — Undo/redo

### Consegna

Implementare un semplice editor di interi con operazioni:

```text
SET x
UNDO
REDO
```

### Idea

Usare due pile:

```text
undoStack
redoStack
```

Quando si esegue `SET`:

- salva il vecchio stato in `undo`;
- aggiorna il valore;
- svuota `redo`.

Quando si esegue `UNDO`:

- sposta lo stato corrente in `redo`;
- ripristina il top di `undo`.

Quando si esegue `REDO`:

- sposta lo stato corrente in `undo`;
- ripristina il top di `redo`.

### Trappola

Una nuova operazione dopo un undo deve invalidare tutta la cronologia redo.

---

# 6. Esercizi infernali

---

## Esercizio 37 — Largest rectangle in binary matrix

### Consegna

Data una matrice binaria, trovare l'area massima di un rettangolo composto soltanto da `1`.

### Idea

Per ogni riga:

1. aggiorna un istogramma di altezze consecutive;
2. calcola l'area massima dell'istogramma con pila monotona.

### Complessità

- Tempo: `O(rows * cols)`
- Spazio: `O(cols)`

---

## Esercizio 38 — Trapping rain water con pila

### Consegna

Dato un array di altezze, calcolare quanta acqua rimane intrappolata.

Esempio:

```text
[0,1,0,2,1,0,1,3,2,1,2,1] → 6
```

### Soluzione con pila monotona

```c
size_t trappedWater(
    const size_t h[],
    size_t n
) {
    size_t *stack = malloc(n * sizeof(*stack));

    if (stack == NULL && n > 0) {
        return 0;
    }

    size_t top = 0;
    size_t water = 0;

    for (size_t i = 0; i < n; i++) {
        while (
            top > 0 &&
            h[i] > h[stack[top - 1]]
        ) {
            size_t bottom = stack[--top];

            if (top == 0) {
                break;
            }

            size_t left = stack[top - 1];
            size_t width = i - left - 1;

            size_t boundedHeight =
                (h[left] < h[i] ? h[left] : h[i])
                - h[bottom];

            water += width * boundedHeight;
        }

        stack[top++] = i;
    }

    free(stack);
    return water;
}
```

---

## Esercizio 39 — Remove k digits

### Consegna

Data una stringa numerica non negativa e un intero `k`, rimuovere esattamente `k` cifre in modo da ottenere il numero minimo possibile.

Esempio:

```text
"1432219", k=3 → "1219"
"10200",   k=1 → "200"
```

### Idea

Usare una pila monotona crescente di cifre:

```text
finché top > cifra corrente e k > 0:
    pop
push cifra corrente
```

Alla fine, se `k > 0`, rimuovere dal fondo.

Poi eliminare gli zeri iniziali.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 40 — Sum of subarray minimums

### Consegna

Dato un array positivo, calcolare la somma dei minimi di tutti i sottoarray contigui.

Esempio:

```text
[3,1,2,4] → 17
```

### Idea

Per ogni elemento, calcolare:

- quante posizioni può estendersi a sinistra restando minimo;
- quante a destra.

Usare due pile monotone.

Contributo:

```text
a[i] * leftCount[i] * rightCount[i]
```

### Punto infernale

Per gestire duplicati senza doppio conteggio, usare confronti asimmetrici:

```text
sinistra: strettamente minore
destra: minore o uguale
```

oppure viceversa.

---

## Esercizio 41 — 132 pattern

### Consegna

Verificare se esistono indici:

```text
i < j < k
```

tali che:

```text
a[i] < a[k] < a[j]
```

### Soluzione ottimizzata

Scorrere da destra con una pila monotona decrescente e una variabile che rappresenta il miglior candidato per `a[k]`.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(n)`

---

## Esercizio 42 — Deque con min e max in O(1)

### Consegna

Implementare una coda che supporti:

```text
enqueue
dequeue
getMin
getMax
```

in tempo ammortizzato `O(1)`.

### Idea

Usare tre strutture:

```text
queue normale
deque monotona crescente per i minimi
deque monotona decrescente per i massimi
```

### Trappola

Con duplicati, non basta eliminare tutti gli uguali. Bisogna mantenere abbastanza informazione per sapere quante copie restano nella coda.

---

# 7. Tracce aggiuntive senza soluzione completa

## Pile

1. Inserire un elemento in fondo a una pila usando ricorsione.
2. Invertire una pila usando solo ricorsione.
3. Rimuovere il valore minimo da una pila preservando l'ordine degli altri.
4. Verificare se una pila è ordinata senza modificarla.
5. Copiare una pila usando una sola pila ausiliaria.
6. Fondere due pile alternate.
7. Separare pari e dispari in due pile preservando l'ordine.
8. Convertire infix in postfix.
9. Convertire infix in prefix.
10. Valutare un'espressione prefix.
11. Verificare tag HTML semplificati.
12. Calcolare la profondità massima di parentesi.
13. Rimuovere il minimo numero di parentesi invalide.
14. Calcolare stock span.
15. Trovare il previous smaller element.
16. Trovare il next smaller element.
17. Trovare il massimo rettangolo in una skyline circolare.
18. Risolvere collisioni con tre direzioni.
19. Simulare chiamate annidate.
20. Implementare una pila generica di `void *`.

## Code

21. Eliminare dalla coda tutti i valori minori della media.
22. Duplicare ogni elemento della coda.
23. Spostare tutti i negativi in fondo preservando l'ordine.
24. Fondere due code alternando gli elementi.
25. Intersecare due code ordinate.
26. Eliminare duplicati consecutivi.
27. Verificare se due code sono uguali senza modificarle.
28. Trovare il massimo usando solo operazioni di coda.
29. Ordinare una coda usando una sola coda ausiliaria.
30. Simulare una stampante con priorità.
31. Simulare un call center round-robin.
32. Implementare una coda con array dinamico circolare.
33. Implementare una coda generica con funzione di distruzione.
34. Implementare una priority queue semplice con lista ordinata.
35. Eseguire BFS su una matrice.
36. Trovare la distanza minima in un labirinto non pesato.
37. Generare numeri con sole cifre 0 e 1 divisibili per n.
38. Trovare il primo numero negativo in ogni finestra.
39. Trovare il massimo in ogni finestra.
40. Simulare un buffer produttore-consumatore.

## Deque

41. Verificare un palindromo ignorando spazi.
42. Ruotare una deque a destra.
43. Ruotare una deque a sinistra.
44. Partizionare una deque intorno a un pivot.
45. Implementare una deque generica.
46. Implementare una deque circolare con riduzione della capacità.
47. Trovare min e max in ogni finestra.
48. Calcolare shortest subarray con somma almeno K.
49. Risolvere 0-1 BFS.
50. Mantenere il mediano di una finestra con strutture ausiliarie.
51. Calcolare il massimo di una finestra su stream infinito.
52. Implementare un LRU cache semplificato.
53. Simulare un browser avanti/indietro.
54. Implementare undo/redo di stringhe.
55. Risolvere il problema delle carte pescate dalle estremità.

---

# 8. Errori tipici

## Queue: rear dangling

```c
q->front = q->front->next;
free(victim);

/* manca */
if (q->front == NULL) {
    q->rear = NULL;
}
```

## Stack: pop senza salvare next

```c
free(s->top);
s->top = s->top->next;   // use-after-free
```

Corretto:

```c
Node *victim = s->top;
s->top = victim->next;
free(victim);
```

## Array circolare: rear sbagliato

```c
rear = size;
```

Sbagliato quando `front != 0`.

Corretto:

```c
rear = (front + size) % capacity;
```

## Deque: modulo con capacità zero

Prima del primo inserimento bisogna allocare capacità positiva.

## Realloc distruttivo

```c
d->data = realloc(d->data, newSize);
```

Se fallisce, si perde il vecchio puntatore.

Corretto:

```c
int *tmp = realloc(...);

if (tmp != NULL) {
    d->data = tmp;
}
```

## Duplicati nelle strutture monotone

Confronti `<`, `<=`, `>`, `>=` non sono intercambiabili.

Cambiano:

- stabilità;
- gestione dei duplicati;
- conteggio dei contributi;
- durata di permanenza nella deque.

---

# 9. Checklist di test

## Pila

- [ ] pila vuota;
- [ ] push singolo;
- [ ] pop dell'unico elemento;
- [ ] alternanza push/pop;
- [ ] molti push con realloc;
- [ ] top non modifica;
- [ ] destroy rende il puntatore `NULL`.

## Coda

- [ ] coda vuota;
- [ ] primo enqueue;
- [ ] dequeue dell'unico elemento;
- [ ] nuovo enqueue dopo svuotamento completo;
- [ ] wrap-around in array circolare;
- [ ] coda piena;
- [ ] rotazioni con `k > n`.

## Deque

- [ ] push front su vuota;
- [ ] push back su vuota;
- [ ] pop front dell'unico;
- [ ] pop back dell'unico;
- [ ] alternanza delle quattro operazioni;
- [ ] wrap-around;
- [ ] resize con dati spezzati fisicamente.

## Algoritmi

- [ ] input vuoto;
- [ ] un elemento;
- [ ] tutti crescenti;
- [ ] tutti decrescenti;
- [ ] tutti uguali;
- [ ] molti duplicati;
- [ ] massimo/minimo all'inizio;
- [ ] massimo/minimo alla fine;
- [ ] risultato vuoto;
- [ ] risultato uguale all'intero input.

---

# 10. Ordine consigliato di allenamento

## Fase 1 — ADT fondamentali

```text
1, 2, 3, 4, 5
```

Obiettivo:

- padroneggiare invarianti;
- gestire primo e ultimo elemento;
- distinguere testa, coda, cima.

## Fase 2 — Operazioni strutturali

```text
6, 7, 15, 16, 17, 18, 23, 24
```

Obiettivo:

- preservare ordine;
- invertire;
- ruotare;
- usare strutture ausiliarie.

## Fase 3 — Applicazioni classiche

```text
8, 10, 11, 19, 20, 21, 22, 28, 29
```

Obiettivo:

- riconoscere quando serve pila o coda;
- ragionare su ammortizzazione.

## Fase 4 — Strutture monotone

```text
12, 13, 14, 25, 26, 27, 30
```

Obiettivo:

- capire perché ogni indice entra/esce una volta;
- scegliere il verso e il confronto corretto.

## Fase 5 — Appelli infernali

```text
31–42
```

Obiettivo:

- combinare parsing, memoria dinamica, pile, code, deque e analisi della complessità.

---

# 11. Schema universale

```text
STRUTTURA:
pila / coda / deque

RAPPRESENTAZIONE:
lista / array / array circolare / due strutture

ESTREMITÀ:
top
front
rear
back

CASO VUOTO:
____________________________________

PRIMO INSERIMENTO:
____________________________________

RIMOZIONE DELL'ULTIMO:
____________________________________

INVARIANTI:
____________________________________

OWNERSHIP:
____________________________________

TEMPO OPERAZIONI:
____________________________________

SPAZIO:
____________________________________

ORDINE DA PRESERVARE:
____________________________________

STRUTTURA AUSILIARIA:
____________________________________

CASI LIMITE:
____________________________________
```

La domanda decisiva non è:

> “Quale codice devo ricordare?”

ma:

> “Quale ordine devo preservare e quale estremità rappresenta il prossimo elemento da elaborare?”

Per una pila:

```text
l'ultimo inserito è il primo elaborato
```

Per una coda:

```text
il primo inserito è il primo elaborato
```

Per una deque:

```text
la scelta dell'estremità fa parte dell'algoritmo
```
