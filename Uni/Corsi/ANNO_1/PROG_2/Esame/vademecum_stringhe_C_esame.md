# Vademecum operativo sulle stringhe in C
## Programmazione 2 — ripasso da esame

> Obiettivo: riconoscere subito il tipo di esercizio, evitare gli errori formali del C e scrivere una soluzione corretta in tempi brevi.
>
> Regola generale: una stringa C è una sequenza di `char` terminata dal carattere `\0`.

---

# 0. Le dieci regole da ricordare

```text
1. Una stringa valida termina sempre con '\0'.
2. n caratteri visibili richiedono almeno n + 1 celle.
3. s[i] è un char; "testo" è una stringa.
4. Le stringhe si confrontano con strcmp, non con ==.
5. char *s = "ciao" non va modificata.
6. char s[] = "ciao" è modificabile.
7. Se costruisci una nuova stringa, devi allocarla e terminarla.
8. Se filtri o comprimi in place, usa indice di lettura e indice di scrittura.
9. Se la stringa può crescere, serve nuova memoria o capacità sufficiente.
10. Chi riceve memoria da malloc deve sapere chi farà free.
```

Header normalmente utili:

```c
#include <stddef.h>  /* size_t */
#include <stdlib.h>  /* malloc, realloc, free */
#include <string.h>  /* strlen, strcmp, strcpy, memcpy, memmove */
#include <ctype.h>   /* isupper, isdigit, tolower... */
#include <stdio.h>   /* printf, fgets */
```

---

# 1. Che cos'è formalmente una stringa C

```c
char s[] = "ciao";
```

crea questo array:

```text
indice:    0    1    2    3     4
valore:   'c'  'i'  'a'  'o'  '\0'
```

I caratteri visibili sono quattro, ma le celle occupate sono cinque.

```c
strlen(s)   /* 4 */
sizeof(s)   /* 5, perché qui s è davvero un array */
```

Il terminatore:

```c
'\0'
```

è un singolo carattere di valore zero. Indica dove finisce la stringa.

Non confonderlo con:

```c
'0'    /* carattere cifra zero */
'\n'   /* newline */
NULL   /* puntatore nullo */
""     /* stringa vuota: contiene soltanto '\0' */
```

---

# 2. Carattere, stringa e puntatore: tipi diversi

## Apici singoli: un carattere

```c
'a'
' '
'\0'
```

## Doppi apici: una stringa

```c
"a"     /* 'a', '\0' */
"ciao"  /* 'c', 'i', 'a', 'o', '\0' */
""      /* '\0' */
```

## Conseguenza fondamentale

```c
s[0]
```

è un singolo `char`.

```c
s[0] = 'A';    /* corretto, se s è modificabile */
s[0] = '\0';   /* corretto: rende la stringa vuota */
s[0] = "";     /* errato: stringa assegnata a un char */
s[0] = "A";    /* errato: puntatore assegnato a un char */
```

## Confronti

Tra caratteri:

```c
if (s[i] == 'A') {
}
```

Tra stringhe:

```c
if (strcmp(s, "ciao") == 0) {
    /* contenuto uguale */
}
```

Errato:

```c
if (s == "ciao") {
    /* confronta indirizzi, non contenuti */
}
```

Errato:

```c
if (res == 'a') {
    /* res è char *, 'a' è un carattere */
}
```

Corretto:

```c
if (res != NULL && strcmp(res, "a") == 0) {
}
```

---

# 3. `char[]`, `char *` e `const char *`

## Array modificabile

```c
char s[] = "ciao";
s[0] = 'C';    /* corretto */
```

## Puntatore a string literal

```c
char *s = "ciao";
s[0] = 'C';    /* comportamento indefinito */
```

Scrittura consigliata:

```c
const char *s = "ciao";
```

## Puntatore a memoria dinamica

```c
char *s = malloc(6 * sizeof *s);

if (s != NULL) {
    strcpy(s, "ciao");
    s[0] = 'C';
    free(s);
}
```

## Tabella rapida

| Dichiarazione | Modificare i caratteri? | Riassegnare `s`? |
|---|---:|---:|
| `char s[] = "ciao";` | sì | no: un array non è assegnabile |
| `char *s = "ciao";` | no, sarebbe UB | sì |
| `const char *s = "ciao";` | no | sì |
| `char *s = malloc(...);` | sì | sì, ma non perdere il blocco da liberare |

## Capacità e lunghezza

```c
char s[20] = "ciao";
```

```c
sizeof(s)   /* 20: capacità dell'array */
strlen(s)   /* 4: lunghezza della stringa */
```

Attenzione:

```c
char s[4] = "ciao";
```

contiene i quattro caratteri, ma non ha spazio per `\0`: non è una stringa C valida per `strlen`, `strcmp`, `printf("%s")`, ecc.

Meglio:

```c
char s[5] = "ciao";
```

oppure:

```c
char s[] = "ciao";
```

---

# 4. Indici e aritmetica dei puntatori

Per una stringa valida `s`:

```c
s[i]
```

equivale a:

```c
*(s + i)
```

E:

```c
&s[i]
```

equivale a:

```c
s + i
```

Esempio:

```c
char s[] = "ciao";

char primo = s[0];       /* 'c' */
char terzo = *(s + 2);   /* 'a' */
char *daSecondo = s + 1; /* punta a "iao" */
```

```c
printf("%s\n", s + 1); /* iao */
```

## Spostare il puntatore non sposta la stringa

```c
void f(char *s) {
    s++;
}
```

modifica soltanto la copia locale del puntatore. Nessun carattere viene cancellato e il puntatore del chiamante non cambia.

Per eliminare davvero caratteri in place devi sovrascrivere l'array, normalmente con due indici.

---

# 5. Il terminatore `\0`

## Rendere una stringa vuota

```c
char s[] = "ciao";
s[0] = '\0';
```

## Troncare una stringa

```c
char s[] = "ciao mondo";
s[4] = '\0';
printf("%s\n", s);   /* ciao */
```

## Costruire manualmente

```c
char s[5];

s[0] = 'c';
s[1] = 'i';
s[2] = 'a';
s[3] = 'o';
s[4] = '\0';
```

## Indice del terminatore

Dopo aver scritto `j` caratteri nelle posizioni `0 ... j - 1`, il primo posto libero è `j`:

```c
result[j] = '\0';
```

Non:

```c
result[++j] = '\0'; /* salta una cella */
```

---

# 6. `strlen` e `sizeof`

## `strlen`

```c
size_t length = strlen(s);
```

Conta i caratteri prima di `\0`. Non include il terminatore.

Richiede:

- `s != NULL`;
- una sequenza validamente terminata;
- memoria leggibile fino al terminatore.

```c
strlen(NULL);          /* comportamento indefinito */
strlen(nonTerminata);  /* comportamento indefinito */
```

## `sizeof`

```c
char a[] = "ciao";
char *p = a;
```

```c
sizeof(a)   /* 5 */
sizeof(p)   /* dimensione di un puntatore */
strlen(a)   /* 4 */
strlen(p)   /* 4 */
```

Dentro una funzione:

```c
void f(char s[]) {
}
```

`char s[]` è trattato come `char *s`. `sizeof(s)` è quindi la dimensione di un puntatore, non quella dell'array originale.

## Non ricalcolare `strlen` a ogni iterazione

Poco efficiente:

```c
for (size_t i = 0; i < strlen(s); i++) {
}
```

Meglio:

```c
size_t length = strlen(s);

for (size_t i = 0; i < length; i++) {
}
```

Oppure:

```c
for (size_t i = 0; s[i] != '\0'; i++) {
}
```

---

# 7. Firme: sola lettura o modifica

## Sola lettura

```c
size_t countUppercase(const char *s);
```

Il `const` dichiara che la funzione non deve modificare i caratteri.

```c
size_t countUppercase(const char *s) {
    if (s == NULL) {
        return 0;
    }

    size_t count = 0;

    for (size_t i = 0; s[i] != '\0'; i++) {
        if (s[i] >= 'A' && s[i] <= 'Z') {
            count++;
        }
    }

    return count;
}
```

## Modifica in place

```c
void lowercaseInPlace(char *s);
```

Serve memoria modificabile:

```c
char s[] = "CiAo";
lowercaseInPlace(s);
```

Non passare una string literal a una funzione che scrive:

```c
lowercaseInPlace("CiAo"); /* pericoloso */
```

---

# 8. Trasformazione uno-a-uno

Se ogni carattere viene sostituito da esattamente un carattere, la lunghezza non cambia.

```c
void lowercaseInPlace(char *s) {
    if (s == NULL) {
        return;
    }

    for (size_t i = 0; s[i] != '\0'; i++) {
        if (s[i] >= 'A' && s[i] <= 'Z') {
            s[i] = (char)(s[i] - 'A' + 'a');
        }
    }
}
```

Altri casi:

```text
cifra -> '#'
minuscola -> maiuscola
',' -> '.'
```

Se ogni input produce esattamente un output, basta un solo indice.

---

# 9. Filtraggio o compressione in place: read/write

Quando alcuni caratteri devono sparire o più caratteri diventano uno solo:

```c
size_t read = 0;
size_t write = 0;

while (s[read] != '\0') {
    if (carattere_da_tenere) {
        s[write] = s[read];
        write++;
    }

    read++;
}

s[write] = '\0';
```

Invariante mentale:

```text
s[0 .. write-1] contiene già il risultato corretto
s[read ..] è la parte ancora da leggere
write <= read
```

## Rimuovere tutte le occorrenze di un carattere

```c
void removeChar(char *s, char target) {
    if (s == NULL) {
        return;
    }

    size_t read = 0;
    size_t write = 0;

    while (s[read] != '\0') {
        if (s[read] != target) {
            s[write++] = s[read];
        }

        read++;
    }

    s[write] = '\0';
}
```

```text
"a-b--c", target '-' -> "abc"
```

Non devi riempire le celle rimosse con `""` o scrivere `\0` durante la scansione. Devi copiare in avanti ciò che rimane e terminare una volta sola alla fine.

---

# 10. Normalizzare gli spazi

Consegna tipica:

- eliminare spazi iniziali;
- eliminare spazi finali;
- ridurre ogni sequenza interna a uno spazio;
- considerare spazio soltanto `' '`.

```c
void normalizeSpaces(char *s) {
    if (s == NULL) {
        return;
    }

    size_t read = 0;
    size_t write = 0;

    /* Salta gli spazi iniziali */
    while (s[read] == ' ') {
        read++;
    }

    while (s[read] != '\0') {
        if (s[read] != ' ') {
            s[write++] = s[read++];
        } else {
            /* Salta tutta la sequenza */
            while (s[read] == ' ') {
                read++;
            }

            /* Uno spazio solo se dopo c'è altro testo */
            if (s[read] != '\0') {
                s[write++] = ' ';
            }
        }
    }

    s[write] = '\0';
}
```

Esempi:

```text
""                    -> ""
"     "               -> ""
"ciao"                -> "ciao"
"  ciao"              -> "ciao"
"ciao   "             -> "ciao"
"  ciao   mondo   "   -> "ciao mondo"
```

Perché funziona:

```text
1. gli spazi iniziali vengono soltanto letti, non scritti;
2. i caratteri normali vengono copiati;
3. una sequenza di spazi viene saltata tutta;
4. si scrive un solo spazio solo se dopo esiste un altro carattere;
5. gli spazi finali non vengono quindi scritti;
6. alla fine si aggiunge '\0'.
```

---

# 11. Togliere un carattere iniziale

## Modificando l'array

```c
char s[] = " ciao";

for (size_t i = 0; s[i] != '\0'; i++) {
    s[i] = s[i + 1];
}
```

Il ciclo copia anche `\0`.

Con libreria:

```c
memmove(s, s + 1, strlen(s));
```

`memmove` è corretto perché sorgente e destinazione si sovrappongono.

## Ignorandolo senza modificare la memoria

```c
const char *s = " ciao";

if (*s == ' ') {
    s++;
}

printf("%s\n", s); /* ciao */
```

Questo sposta il puntatore, non i caratteri.

Se il blocco proviene da `malloc`, conserva l'indirizzo iniziale:

```c
char *base = malloc(100);
char *cursor = base;

cursor++;

free(base); /* non free(cursor) */
```

---

# 12. Costruire una nuova stringa: template fondamentale

Firma tipica:

```c
char *filter(const char *s);
```

Checklist:

```text
1. Gestisci s == NULL.
2. Calcola una capacità sufficiente.
3. malloc.
4. Controlla malloc.
5. Leggi con i.
6. Scrivi con j.
7. Aggiungi result[j] = '\0'.
8. Restituisci result.
9. Il chiamante farà free.
```

Template:

```c
char *filter(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t length = strlen(s);

    char *result = malloc((length + 1) * sizeof *result);
    if (result == NULL) {
        return NULL;
    }

    size_t j = 0;

    for (size_t i = 0; i < length; i++) {
        if (CONDIZIONE) {
            result[j++] = VALORE_DA_SCRIVERE;
        }
    }

    result[j] = '\0';
    return result;
}
```

Allocare `length + 1` è corretto quando il risultato non può essere più lungo dell'input.

La memoria inutilizzata può rimanere allocata. In un esercizio d'esame non serve restringere il blocco con `realloc`.

---

# 13. Esempio: tenere soltanto le maiuscole e convertirle

```c
char *uppercaseToLowercaseString(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t length = strlen(s);

    char *result = malloc((length + 1) * sizeof *result);
    if (result == NULL) {
        return NULL;
    }

    size_t j = 0;

    for (size_t i = 0; i < length; i++) {
        if (s[i] >= 'A' && s[i] <= 'Z') {
            result[j++] = (char)(s[i] - 'A' + 'a');
        }
    }

    result[j] = '\0';
    return result;
}
```

```text
"AZbCuu12R" -> "azcr"
```

Errori tipici:

```c
isalpha(s[i])       /* accetta anche le minuscole */
result[++j] = '\0'; /* terminatore troppo avanti */
malloc(length)      /* manca una cella per '\0' */
s[i] = "";          /* char = stringa */
```

---

# 14. Dimensionare il risultato

## Strategia veloce: capacità massima

Se il risultato non cresce:

```c
size_t length = strlen(s);
char *result = malloc((length + 1) * sizeof *result);
```

Vantaggi:

- meno codice;
- un solo attraversamento di costruzione;
- meno possibilità di errore;
- ottima scelta da esame.

## Strategia esatta: due passate

Prima conti:

```c
size_t count = 0;

for (size_t i = 0; s[i] != '\0'; i++) {
    if (CONDIZIONE) {
        count++;
    }
}
```

Poi:

```c
char *result = malloc((count + 1) * sizeof *result);
```

Infine fai una seconda scansione per riempirlo.

## Regola pratica

```text
Risultato lungo al massimo quanto l'input -> strlen(s) + 1.
Risultato potenzialmente più lungo -> calcola la nuova lunghezza.
```

---

# 15. Quando la stringa può crescere

Esempio:

```text
"a1b2" -> "a11b22"
```

La nuova lunghezza è maggiore. Serve nuova memoria, salvo che la consegna garantisca capacità aggiuntiva.

```c
char *duplicateDigits(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t newLength = 0;

    for (size_t i = 0; s[i] != '\0'; i++) {
        newLength++;

        if (s[i] >= '0' && s[i] <= '9') {
            newLength++;
        }
    }

    char *result = malloc((newLength + 1) * sizeof *result);
    if (result == NULL) {
        return NULL;
    }

    size_t j = 0;

    for (size_t i = 0; s[i] != '\0'; i++) {
        result[j++] = s[i];

        if (s[i] >= '0' && s[i] <= '9') {
            result[j++] = s[i];
        }
    }

    result[j] = '\0';
    return result;
}
```

Formula mentale:

```text
nuova lunghezza = caratteri originali + caratteri aggiuntivi
celle allocate = nuova lunghezza + 1
```

---

# 16. Copiare una stringa

## Manualmente

```c
char *duplicateString(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t length = strlen(s);

    char *copy = malloc((length + 1) * sizeof *copy);
    if (copy == NULL) {
        return NULL;
    }

    for (size_t i = 0; i <= length; i++) {
        copy[i] = s[i];
    }

    return copy;
}
```

Il ciclo usa `i <= length` per copiare anche il terminatore.

## Con `strcpy`

```c
char *copy = malloc((strlen(s) + 1) * sizeof *copy);

if (copy != NULL) {
    strcpy(copy, s);
}
```

La destinazione deve avere spazio sufficiente.

## Con `memcpy`

```c
size_t length = strlen(s);
char *copy = malloc((length + 1) * sizeof *copy);

if (copy != NULL) {
    memcpy(copy, s, length + 1);
}
```

`length + 1` copia anche `\0`.

---

# 17. Concatenare due stringhe

```c
char *concatNew(const char *a, const char *b) {
    if (a == NULL || b == NULL) {
        return NULL;
    }

    size_t lenA = strlen(a);
    size_t lenB = strlen(b);

    char *result =
        malloc((lenA + lenB + 1) * sizeof *result);

    if (result == NULL) {
        return NULL;
    }

    memcpy(result, a, lenA);
    memcpy(result + lenA, b, lenB + 1);

    return result;
}
```

La seconda `memcpy` copia `lenB + 1` per includere il terminatore.

Con funzioni di stringa:

```c
strcpy(result, a);
strcat(result, b);
```

ma `result` deve essere già abbastanza grande.

---

# 18. Estrarre una sottostringa

```c
char *substring(const char *s, size_t start, size_t count) {
    if (s == NULL) {
        return NULL;
    }

    size_t length = strlen(s);

    if (start > length) {
        return NULL;
    }

    if (count > length - start) {
        count = length - start;
    }

    char *result = malloc((count + 1) * sizeof *result);
    if (result == NULL) {
        return NULL;
    }

    for (size_t i = 0; i < count; i++) {
        result[i] = s[start + i];
    }

    result[count] = '\0';
    return result;
}
```

Usare:

```c
count > length - start
```

è più robusto di:

```c
start + count > length
```

perché evita un'eventuale somma in overflow.

---

# 19. Invertire una stringa in place

```c
void reverseString(char *s) {
    if (s == NULL) {
        return;
    }

    size_t length = strlen(s);

    for (size_t i = 0; i < length / 2; i++) {
        size_t j = length - 1 - i;

        char temp = s[i];
        s[i] = s[j];
        s[j] = temp;
    }
}
```

Casi limite:

```text
NULL
""
"a"
"ab"
"abc"
```

Attenzione a:

```c
size_t right = length - 1;
```

quando `length == 0`: `size_t` è senza segno e va in underflow.

---

# 20. Confrontare stringhe

```c
int cmp = strcmp(a, b);
```

```text
cmp == 0  -> contenuto uguale
cmp < 0   -> a precede b lessicograficamente
cmp > 0   -> a segue b lessicograficamente
```

Non assumere che il risultato sia soltanto `-1`, `0` o `1`.

Prima controlla gli eventuali `NULL`:

```c
strcmp(NULL, b) /* comportamento indefinito */
```

---

# 21. Funzioni principali di `<string.h>`

## `strlen`

```c
size_t strlen(const char *s);
```

Conta i caratteri prima di `\0`.

## `strcmp`

```c
int strcmp(const char *a, const char *b);
```

Confronta il contenuto.

## `strcpy`

```c
char *strcpy(char *destination, const char *source);
```

Copia compreso `\0`. La destinazione deve avere spazio sufficiente.

## `strcat`

```c
char *strcat(char *destination, const char *source);
```

La destinazione deve essere già una stringa valida e avere capacità sufficiente.

## `memcpy`

```c
void *memcpy(void *destination, const void *source, size_t n);
```

Copia esattamente `n` byte. Non aggiunge automaticamente `\0`. Le aree non devono sovrapporsi.

## `memmove`

```c
void *memmove(void *destination, const void *source, size_t n);
```

Funziona anche con aree sovrapposte.

## `strchr`

```c
char *strchr(const char *s, int c);
```

Trova la prima occorrenza del carattere o restituisce `NULL`.

## `strcspn`

Utile per rimuovere il newline di `fgets`:

```c
s[strcspn(s, "\n")] = '\0';
```

## Attenzione a `strncpy`

`strncpy` non garantisce sempre il terminatore se la sorgente è troppo lunga. Non usarla automaticamente pensando che sia una `strcpy` sicura.

---

# 22. `<ctype.h>`: classificazione e conversione

Funzioni comuni:

```c
isupper(c)
islower(c)
isalpha(c)
isdigit(c)
isspace(c)
tolower(c)
toupper(c)
```

La specifica può però essere più stretta.

> Si considera spazio soltanto `' '`.

Allora non usare `isspace`, perché riconosce anche tab, newline e altri whitespace.

```c
s[i] == ' '
```

> Tenere soltanto i caratteri tra `'A'` e `'Z'`.

```c
s[i] >= 'A' && s[i] <= 'Z'
```

## Uso formalmente sicuro

Le funzioni di `ctype.h` richiedono `EOF` oppure un valore rappresentabile come `unsigned char`.

```c
unsigned char c = (unsigned char)s[i];

if (isupper(c)) {
    result[j++] = (char)tolower(c);
}
```

Negli esercizi ASCII, i confronti espliciti sono spesso più chiari.

---

# 23. `malloc`, `realloc` e `free`

## Allocazione

```c
char *s = malloc((capacity + 1) * sizeof *s);
```

Per `char`, `sizeof(char)` vale sempre 1, ma il pattern con `sizeof *s` resta uniforme.

## Controllo

```c
if (s == NULL) {
    return NULL;
}
```

## Ownership

```c
char *result = funzioneCheAlloca(...);

/* uso result */

free(result);
```

## `free(NULL)`

È valido:

```c
free(NULL);
```

## Non liberare memoria non dinamica

Errato:

```c
char s[] = "ciao";
free(s);
```

Errato:

```c
char *s = "ciao";
free(s);
```

## Non liberare un puntatore spostato

Errato:

```c
char *s = malloc(100);
s++;
free(s);
```

Corretto:

```c
char *base = malloc(100);
char *cursor = base;

cursor++;

free(base);
```

## Uso sicuro di `realloc`

```c
char *tmp = realloc(s, newCapacity * sizeof *s);

if (tmp == NULL) {
    /* s è ancora valido */
} else {
    s = tmp;
}
```

Non:

```c
s = realloc(s, newCapacity);
```

perché, se fallisce, perdi il puntatore al vecchio blocco.

## Restringere è spesso inutile

Dopo un filtraggio:

```c
result[j] = '\0';
return result;
```

va bene anche se il blocco è più grande del necessario.

---

# 24. Stringa dinamica con capacità variabile

Struttura tipica:

```c
typedef struct {
    char *content;
    size_t capacity;
    size_t length;
} DynString;
```

Invarianti:

```text
content[length] == '\0'
capacity >= length + 1
```

Prima di aggiungere `additional` caratteri:

```text
required = length + additional + 1
```

Il `+1` è sempre per il terminatore.

Schema di espansione:

```c
int ensureCapacity(DynString *s, size_t required) {
    if (required <= s->capacity) {
        return 1;
    }

    size_t newCapacity = s->capacity == 0 ? 1 : s->capacity;

    while (newCapacity < required) {
        newCapacity *= 2;
    }

    char *tmp =
        realloc(s->content, newCapacity * sizeof *tmp);

    if (tmp == NULL) {
        return 0;
    }

    s->content = tmp;
    s->capacity = newCapacity;
    return 1;
}
```

Append:

```c
int append(DynString *s, const char *suffix) {
    if (s == NULL || suffix == NULL) {
        return 0;
    }

    size_t extra = strlen(suffix);
    size_t required = s->length + extra + 1;

    if (!ensureCapacity(s, required)) {
        return 0;
    }

    memcpy(s->content + s->length, suffix, extra + 1);
    s->length += extra;

    return 1;
}
```

---

# 25. Input con `fgets`

```c
char buffer[100];

if (fgets(buffer, sizeof buffer, stdin) != NULL) {
    /* buffer può contenere '\n' */
}
```

Rimuovere il newline:

```c
buffer[strcspn(buffer, "\n")] = '\0';
```

Versione manuale:

```c
for (size_t i = 0; buffer[i] != '\0'; i++) {
    if (buffer[i] == '\n') {
        buffer[i] = '\0';
        break;
    }
}
```

`scanf("%s", buffer)` si ferma al primo whitespace e, senza limite, può superare il buffer.

---

# 26. Come scegliere il pattern

## Solo lettura

Esempi:

- contare;
- cercare;
- verificare un prefisso;
- palindromia.

Usa:

```c
const char *s
```

## Sostituzione uno-a-uno

Esempi:

- maiuscole in minuscole;
- cifre in `#`;
- sostituzione di un simbolo.

Puoi modificare in place con un indice.

## Risultato più corto o uguale

Esempi:

- rimuovere caratteri;
- tenere soltanto certe lettere;
- comprimere spazi.

Usa read/write in place oppure una nuova stringa di capacità `strlen(s) + 1`.

## Risultato più lungo

Esempi:

- duplicare cifre;
- inserire separatori;
- sostituire un carattere con più caratteri.

Calcola la nuova lunghezza e alloca.

## Riordinamento con stessa lunghezza

Esempi:

- reverse;
- scambio di metà;
- rotazione.

Usa due indici.

---

# 27. Pattern di indici

## Lettura e scrittura

```c
size_t read = 0;
size_t write = 0;
```

Per filtrare, eliminare o comprimere.

## Sinistra e destra

```c
size_t left = 0;
size_t right = length;
```

Per reverse, palindromia e confronto degli estremi.

## Due stringhe

```c
size_t i = 0;
size_t j = 0;
```

Per confronto, merge, alternanza e ricerca.

## Input e output separati

```c
size_t i = 0;
size_t out = 0;
```

Per costruire una nuova stringa.

---

# 28. Palindromia

```c
int isPalindrome(const char *s) {
    if (s == NULL) {
        return 0;
    }

    size_t length = strlen(s);

    for (size_t left = 0; left < length / 2; left++) {
        size_t right = length - 1 - left;

        if (s[left] != s[right]) {
            return 0;
        }
    }

    return 1;
}
```

---

# 29. Verificare un prefisso

```c
int startsWith(const char *s, const char *prefix) {
    if (s == NULL || prefix == NULL) {
        return 0;
    }

    size_t i = 0;

    while (prefix[i] != '\0') {
        if (s[i] == '\0' || s[i] != prefix[i]) {
            return 0;
        }

        i++;
    }

    return 1;
}
```

La stringa principale può finire prima del prefisso: va controllato.

---

# 30. Errori formali classici

## Assegnare una stringa a un carattere

```c
s[i] = "";
```

Possibili assegnamenti a un carattere:

```c
s[i] = '\0';
s[i] = ' ';
s[i] = 'A';
```

Ma per eliminare un carattere interno devi normalmente compattare.

## Confrontare stringa e carattere

```c
res == 'a'
```

Corretto:

```c
strcmp(res, "a") == 0
```

## Usare `==` tra stringhe

```c
a == b
```

confronta indirizzi.

```c
strcmp(a, b) == 0
```

confronta contenuti.

## Assegnare a un array

```c
char a[10];
a = "ciao";
```

Un array non è assegnabile.

Alternative:

```c
strcpy(a, "ciao");
```

oppure:

```c
char a[10] = "ciao";
```

## Confondere `NULL` e `\0`

```c
s[i] = NULL;
```

Meglio:

```c
s[i] = '\0';
```

## Scrivere fuori dai limiti

Errato:

```c
char *s = malloc(length);
s[length] = '\0';
```

Corretto:

```c
char *s = malloc(length + 1);
s[length] = '\0';
```

---

# 31. Comportamenti indefiniti frequenti

```c
strlen(NULL);
strcmp(NULL, "a");
strcpy(destTroppoPiccola, source);
char *s = "ciao"; s[0] = 'C';
free(stringLiteral);
free(arrayLocale);
free(puntatoreSpostato);
usare memoria dopo free;
leggere oltre i limiti;
scrivere oltre la capacità;
usare strlen su dati senza '\0';
```

Il fatto che il programma sembri funzionare non lo rende corretto.

---

# 32. Correzione degli errori più probabili

## Ciclo fino a `strlen(s) + 1`

```c
for (size_t i = 0; i < strlen(s) + 1; i++)
```

Elabora anche il terminatore e ricalcola `strlen`.

Meglio:

```c
for (size_t i = 0; s[i] != '\0'; i++)
```

## Terminatore con preincremento

```c
result[++j] = '\0';
```

Se `j` è già il primo posto libero:

```c
result[j] = '\0';
```

## `isalpha` quando servono solo maiuscole

```c
isalpha(s[i])
```

accetta anche minuscole.

```c
s[i] >= 'A' && s[i] <= 'Z'
```

## `s++` per rimuovere in place

```c
s++;
```

sposta soltanto il puntatore locale. Usa copia, `memmove` o read/write.

## Indice destro uguale a `strlen(s)`

```c
size_t right = strlen(s);
```

punta al terminatore. L'ultimo carattere visibile è `strlen(s) - 1`, solo se la stringa non è vuota.

## Scrivere `\0` negli spazi interni

Tronca la stringa. Per eliminare o comprimere devi spostare ciò che viene dopo.

---

# 33. TDD essenziale da esame

Niente framework complesso. Cinque casi ben scelti bastano.

Esempio:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    int passed = 0;
    char *result;

    /* 1. NULL */
    result = uppercaseToLowercaseString(NULL);
    if (result == NULL) {
        passed++;
    }
    free(result);

    /* 2. Stringa vuota */
    result = uppercaseToLowercaseString("");
    if (result != NULL && strcmp(result, "") == 0) {
        passed++;
    }
    free(result);

    /* 3. Nessun carattere selezionato */
    result = uppercaseToLowercaseString("ciao123");
    if (result != NULL && strcmp(result, "") == 0) {
        passed++;
    }
    free(result);

    /* 4. Tutti selezionati */
    result = uppercaseToLowercaseString("ABC");
    if (result != NULL && strcmp(result, "abc") == 0) {
        passed++;
    }
    free(result);

    /* 5. Caso misto */
    result = uppercaseToLowercaseString("AZbCuu12R");
    if (result != NULL && strcmp(result, "azcr") == 0) {
        passed++;
    }
    free(result);

    if (passed == 5) {
        printf("OK\n");
    } else {
        printf("KO: %d/5\n", passed);
    }

    return 0;
}
```

Categorie universali:

```text
1. NULL;
2. vuoto;
3. nessun elemento soddisfa la condizione;
4. tutti gli elementi soddisfano la condizione;
5. caso misto significativo.
```

Per una funzione in place:

```c
char s[] = "  ciao   mondo  ";
normalizeSpaces(s);

if (strcmp(s, "ciao mondo") == 0) {
    passed++;
}
```

---

# 34. Cinque test per `normalizeSpaces`

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    int passed = 0;

    char a[] = "";
    normalizeSpaces(a);
    if (strcmp(a, "") == 0) passed++;

    char b[] = "     ";
    normalizeSpaces(b);
    if (strcmp(b, "") == 0) passed++;

    char c[] = "ciao";
    normalizeSpaces(c);
    if (strcmp(c, "ciao") == 0) passed++;

    char d[] = "   ciao   ";
    normalizeSpaces(d);
    if (strcmp(d, "ciao") == 0) passed++;

    char e[] = "  ciao    mondo   ";
    normalizeSpaces(e);
    if (strcmp(e, "ciao mondo") == 0) passed++;

    if (passed == 5) {
        printf("OK\n");
    } else {
        printf("KO: %d/5\n", passed);
    }

    return 0;
}
```

Per `normalizeSpaces(NULL)`, il controllo consiste nel verificare che ritorni senza crash.

---

# 35. Strategia per un esercizio da un'ora

## Primi 5 minuti: leggi la specifica

Segna:

```text
Input può essere NULL?
Output è nuova memoria o modifica in place?
Il risultato può essere più lungo?
Devo preservare l'ordine?
Quali caratteri sono validi?
Chi libera la memoria?
```

## Minuti 5–12: scrivi cinque test

```text
NULL
vuoto
nessuno
tutti
misto
```

## Minuti 12–20: scegli il pattern

```text
solo lettura       -> un indice
trasformazione 1:1 -> in place
compressione       -> read/write
espansione         -> nuova lunghezza + malloc
reverse            -> left/right
nuova stringa      -> input index + output index
```

## Minuti 20–45: implementa

Ordine consigliato:

```text
guard clause
lunghezze necessarie
malloc
controllo malloc
ciclo
terminatore
return
```

## Minuti 45–55: prova i casi limite

```text
'\0'
+1 nella malloc
indice del primo posto libero
stringa vuota
tutto scartato
tutto mantenuto
spazi finali
```

## Ultimi 5 minuti: caccia agli errori

```text
"..." assegnato a char
'...' usato come stringa
== tra stringhe
malloc senza +1
mancanza di free nei test
strlen dentro il ciclo
realloc assegnato direttamente
scrittura su string literal
underflow con size_t
```

---

# 36. Template da ricordare: nuova stringa

```c
char *function(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t length = strlen(s);

    char *result = malloc((CAPACITA + 1) * sizeof *result);
    if (result == NULL) {
        return NULL;
    }

    size_t j = 0;

    for (size_t i = 0; i < length; i++) {
        if (CONDIZIONE) {
            result[j++] = VALORE;
        }
    }

    result[j] = '\0';
    return result;
}
```

`CAPACITA` può essere:

```text
length          se il risultato non cresce
newLength       se hai contato la dimensione esatta
lenA + lenB     per concatenazione
count           per una sottostringa di count caratteri
```

---

# 37. Template da ricordare: compressione in place

```c
void function(char *s) {
    if (s == NULL) {
        return;
    }

    size_t read = 0;
    size_t write = 0;

    while (s[read] != '\0') {
        if (CONDIZIONE_PER_TENERE) {
            s[write++] = s[read];
        }

        read++;
    }

    s[write] = '\0';
}
```

Per saltare sequenze:

```c
while (s[read] == CARATTERE_DA_SALTARE) {
    read++;
}
```

---

# 38. Tabella “voglio fare X”

| Operazione | Pattern |
|---|---|
| Contare caratteri | scansione fino a `\0` |
| Cercare un carattere | scansione, ritorna indice o puntatore |
| Confrontare stringhe | `strcmp` o ciclo parallelo |
| Rendere vuota | `s[0] = '\0'` |
| Troncare | `s[pos] = '\0'` |
| Copiare | `length + 1`, copia anche `\0` |
| Filtrare in nuova memoria | `i` legge, `j` scrive |
| Filtrare in place | `read/write` |
| Comprimere sequenze | salta sequenza, scrivi una volta |
| Eliminare spazi laterali | salta iniziali; non scrivere spazio prima di `\0` |
| Concatenare | `lenA + lenB + 1` |
| Estrarre sottostringa | `count + 1` |
| Reverse | indici `left/right` |
| Espandere | prima calcola nuova lunghezza |
| Modificare il puntatore del chiamante | restituisci il puntatore o usa `char **` |
| Spostare il cursore senza modificare | `cursor++`, conserva la base |
| Spostare caratteri sovrapposti | `memmove` |

---

# 39. Checklist finale

## Validità della stringa

- [ ] Ogni stringa prodotta termina con `\0`.
- [ ] Ho allocato anche la cella del terminatore.
- [ ] Non chiamo funzioni di stringa su `NULL`.
- [ ] Non tratto un array non terminato come stringa.

## Tipi

- [ ] Uso `'x'` per un carattere.
- [ ] Uso `"x"` per una stringa.
- [ ] Uso `strcmp` per confrontare contenuti.
- [ ] Non assegno una stringa a `s[i]`.

## Memoria

- [ ] Controllo `malloc`.
- [ ] Non perdo il puntatore originale.
- [ ] Il chiamante può fare `free` sul risultato.
- [ ] Nei test libero ogni risultato dinamico.
- [ ] Non faccio `free` su array locali o string literal.
- [ ] Non uso memoria dopo `free`.

## Indici

- [ ] Non leggo oltre `\0`.
- [ ] Il terminatore è scritto nel primo posto libero.
- [ ] Gestisco la stringa vuota.
- [ ] Evito `length - 1` quando `length == 0`.
- [ ] Se uso read/write, vale sempre `write <= read`.

## Specifica

- [ ] Ho usato esattamente la definizione di carattere richiesta.
- [ ] Non modifico l'input se è `const`.
- [ ] Modifico in place solo se richiesto.
- [ ] Preservo l'ordine dei caratteri.
- [ ] Ho testato NULL, vuoto, nessuno, tutti e misto.

---

# 40. Ultimo ripasso da memorizzare

```c
/* Attraversare */
for (size_t i = 0; s[i] != '\0'; i++) {
}

/* Lunghezza */
size_t n = strlen(s);

/* Nuova stringa non più lunga dell'input */
char *r = malloc((strlen(s) + 1) * sizeof *r);

/* Terminare */
r[j] = '\0';

/* Confrontare */
strcmp(a, b) == 0

/* Rendere vuota */
s[0] = '\0';

/* Array modificabile */
char s[] = "ciao";

/* Literal da non modificare */
const char *s = "ciao";

/* Filtrare in place */
if (KEEP(s[read])) {
    s[write++] = s[read];
}

/* Copiare includendo il terminatore */
memcpy(copy, s, strlen(s) + 1);

/* Spostare memoria sovrapposta */
memmove(destination, source, bytes);

/* Liberare risultato dinamico */
free(result);
```

## Formula conclusiva

```text
Stringa corretta =
    caratteri validi
    + spazio sufficiente
    + '\0'
    + indici entro i limiti
    + ownership chiara
```
