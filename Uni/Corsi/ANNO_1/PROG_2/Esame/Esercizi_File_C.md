# Programmazione 2 — Esercizi sui file in C

> Raccolta progressiva in stile esame: consegna, struttura di partenza, soluzione semplice, eventuale soluzione più robusta o efficiente, complessità, casi limite, gestione delle risorse ed errori tipici.
>
> Focus:
>
> - `FILE *` come risorsa da acquisire, usare e rilasciare;
> - file di testo e file binari;
> - lettura per carattere, riga, token e record;
> - `fopen`, `fclose`, `fgetc`, `fputc`, `fgets`, `fputs`;
> - `fprintf`, `fscanf`, `fread`, `fwrite`;
> - `feof`, `ferror`, `clearerr`;
> - `fseek`, `ftell`, `rewind`;
> - parsing e validazione;
> - array, liste e alberi caricati da file;
> - serializzazione;
> - aggiornamenti tramite file temporaneo;
> - accesso sequenziale e casuale;
> - esercizi misti in stile LeetCode;
> - hidden test, cleanup e failure atomicity.

Compilazione consigliata:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wconversion \
    -g -fsanitize=address,undefined file.c -o file
```

---

# 0. Modello mentale: il file è una risorsa

Il pattern fondamentale è:

```text
acquisizione → uso → rilascio
```

In C:

```c
FILE *file = fopen(path, mode);

if (file == NULL) {
    /* errore di apertura */
}

/* usa file */

if (fclose(file) == EOF) {
    /* errore di chiusura o flush */
}
```

È concettualmente analogo a:

```text
malloc → uso → free
```

## 0.1 Invariante principale

Dopo una `fopen` riuscita, ogni percorso di uscita dalla funzione deve:

```text
chiudere il file esattamente una volta
```

salvo trasferimento esplicito dell'ownership del `FILE *`.

## 0.2 Pattern con singolo punto di cleanup

```c
int operation(const char *path) {
    int success = 0;
    FILE *file = fopen(path, "r");

    if (file == NULL) {
        return 0;
    }

    if (/* errore */) {
        goto cleanup;
    }

    success = 1;

cleanup:
    if (fclose(file) == EOF) {
        success = 0;
    }

    return success;
}
```

In C, un `goto cleanup` ben usato può rendere più sicura la gestione di più risorse.

---

# 1. Modalità di apertura

| Modalità | Lettura | Scrittura | File esistente | File assente | Posizione |
|---|---:|---:|---|---|---|
| `"r"` | sì | no | preservato | errore | inizio |
| `"w"` | no | sì | troncato | creato | inizio |
| `"a"` | no | sì | preservato | creato | ogni scrittura in fondo |
| `"r+"` | sì | sì | preservato | errore | inizio |
| `"w+"` | sì | sì | troncato | creato | inizio |
| `"a+"` | sì | sì | preservato | creato | scritture in fondo |

Per file binari:

```text
"rb", "wb", "ab", "rb+", ...
```

## 1.1 Trappola distruttiva

```c
FILE *file = fopen(path, "w");
```

tronca immediatamente il file esistente.

Non usarlo per “leggere e poi eventualmente modificare”.

## 1.2 Append non significa semplice posizione iniziale in fondo

Con modalità append, ogni scrittura viene effettuata alla fine, anche dopo spostamenti della posizione compatibilmente con l'implementazione e lo standard.

---

# 2. EOF, errori e tipi corretti

## 2.1 `fgetc` restituisce `int`

Corretto:

```c
int c;

while ((c = fgetc(file)) != EOF) {
    /* c contiene un unsigned char convertito a int */
}
```

Sbagliato:

```c
char c;

while ((c = fgetc(file)) != EOF) {
    ...
}
```

Un `char` potrebbe non rappresentare distintamente tutti i byte e `EOF`.

## 2.2 `feof` non anticipa la fine

Sbagliato:

```c
while (!feof(file)) {
    c = fgetc(file);
    ...
}
```

`feof(file)` diventa vero **dopo** un tentativo di lettura oltre la fine.

Corretto:

```c
while ((c = fgetc(file)) != EOF) {
    ...
}

if (ferror(file)) {
    /* errore di lettura */
}
```

## 2.3 `fscanf`

Il valore restituito è il numero di conversioni riuscite.

```c
int value;

while (fscanf(file, "%d", &value) == 1) {
    ...
}
```

Non usare:

```c
while (!feof(file)) {
    fscanf(file, "%d", &value);
}
```

## 2.4 `fread` e `fwrite`

Restituiscono il numero di elementi completi letti o scritti.

```c
size_t read =
    fread(buffer, sizeof(*buffer), count, file);
```

---

# Livello 1 — Operazioni fondamentali su file di testo

---

## Esercizio 1 — Conta i caratteri

### Consegna

Dato il percorso di un file di testo, restituire il numero di byte leggibili.

La funzione restituisce `1` in caso di successo e `0` in caso di errore. Il risultato viene scritto in `*out`.

### Struttura di partenza

```c
#include <stddef.h>

int fileByteCount(
    const char *path,
    size_t *out
);
```

### Soluzione semplice

```c
#include <stdio.h>

int fileByteCount(
    const char *path,
    size_t *out
) {
    if (path == NULL || out == NULL) {
        return 0;
    }

    FILE *file = fopen(path, "rb");

    if (file == NULL) {
        return 0;
    }

    size_t count = 0;
    int c;

    while ((c = fgetc(file)) != EOF) {
        count++;
    }

    int success = !ferror(file);

    if (fclose(file) == EOF) {
        success = 0;
    }

    if (success) {
        *out = count;
    }

    return success;
}
```

### Complessità

- Tempo: `O(B)`, con `B` numero di byte
- Spazio: `O(1)`

### Perché `"rb"`

Per contare i byte fisici in modo più diretto e portabile rispetto alle trasformazioni possibili in modalità testo.

---

## Esercizio 2 — Conta righe

### Consegna

Contare le righe di un file.

Convenzione:

```text
file vuoto → 0 righe
"abc" → 1 riga
"abc\n" → 1 riga
"abc\ndef" → 2 righe
```

### Soluzione semplice

```c
int fileLineCount(
    const char *path,
    size_t *out
) {
    FILE *file = fopen(path, "r");

    if (file == NULL || out == NULL) {
        if (file != NULL) {
            fclose(file);
        }
        return 0;
    }

    size_t lines = 0;
    int c;
    int sawAny = 0;
    int last = '\n';

    while ((c = fgetc(file)) != EOF) {
        sawAny = 1;
        last = c;

        if (c == '\n') {
            lines++;
        }
    }

    int success = !ferror(file);

    if (
        success &&
        sawAny &&
        last != '\n'
    ) {
        lines++;
    }

    if (fclose(file) == EOF) {
        success = 0;
    }

    if (success) {
        *out = lines;
    }

    return success;
}
```

### Trappola

Contare soltanto i `'\n'` perde l'ultima riga se il file non termina con newline.

---

## Esercizio 3 — Conta parole ASCII

### Consegna

Contare le parole, definite come sequenze massimali di caratteri non whitespace.

Usare `isspace`.

### Soluzione

```c
#include <ctype.h>

int fileWordCount(
    const char *path,
    size_t *out
) {
    if (path == NULL || out == NULL) {
        return 0;
    }

    FILE *file = fopen(path, "r");

    if (file == NULL) {
        return 0;
    }

    size_t words = 0;
    int insideWord = 0;
    int c;

    while ((c = fgetc(file)) != EOF) {
        if (isspace((unsigned char)c)) {
            insideWord = 0;
        } else if (!insideWord) {
            insideWord = 1;
            words++;
        }
    }

    int success = !ferror(file);

    if (fclose(file) == EOF) {
        success = 0;
    }

    if (success) {
        *out = words;
    }

    return success;
}
```

### Punto importante

Le funzioni di `<ctype.h>` richiedono:

```c
(unsigned char)c
```

oppure `EOF`.

---

## Esercizio 4 — Statistiche complete

### Consegna

Calcolare in una sola scansione:

```c
typedef struct {
    size_t bytes;
    size_t lines;
    size_t words;
    size_t digits;
    size_t uppercase;
} TextStats;
```

### Soluzione semplice

Combina i pattern degli esercizi precedenti.

### Complessità

- Tempo: `O(B)`
- Spazio: `O(1)`

### Obiettivo d'esame

Evitare cinque scansioni separate quando tutte le statistiche possono essere aggiornate nello stesso ciclo.

---

## Esercizio 5 — Copia di un file

### Consegna

Copiare integralmente `sourcePath` in `destinationPath`.

La destinazione viene sovrascritta.

### Soluzione semplice per byte

```c
int copyFile(
    const char *sourcePath,
    const char *destinationPath
) {
    int success = 0;
    FILE *source = NULL;
    FILE *destination = NULL;

    source = fopen(sourcePath, "rb");

    if (source == NULL) {
        goto cleanup;
    }

    destination = fopen(destinationPath, "wb");

    if (destination == NULL) {
        goto cleanup;
    }

    unsigned char buffer[4096];
    size_t count;

    while (
        (count = fread(
            buffer,
            1,
            sizeof(buffer),
            source
        )) > 0
    ) {
        if (
            fwrite(buffer, 1, count, destination)
            != count
        ) {
            goto cleanup;
        }
    }

    if (ferror(source)) {
        goto cleanup;
    }

    success = 1;

cleanup:
    if (
        destination != NULL &&
        fclose(destination) == EOF
    ) {
        success = 0;
    }

    if (
        source != NULL &&
        fclose(source) == EOF
    ) {
        success = 0;
    }

    return success;
}
```

### Complessità

- Tempo: `O(B)`
- Spazio: `O(1)` rispetto alla dimensione del file

### Perché un buffer

Una chiamata per ogni byte è corretta ma meno efficiente.

---

## Esercizio 6 — Confronta due file byte per byte

### Consegna

Restituire:

- `1` se i file sono identici;
- `0` se sono diversi;
- `-1` in caso di errore.

### Soluzione semplice

```c
int filesEqual(
    const char *pathA,
    const char *pathB
) {
    FILE *a = fopen(pathA, "rb");

    if (a == NULL) {
        return -1;
    }

    FILE *b = fopen(pathB, "rb");

    if (b == NULL) {
        fclose(a);
        return -1;
    }

    int result = 1;

    while (1) {
        int ca = fgetc(a);
        int cb = fgetc(b);

        if (ca != cb) {
            result = 0;
            break;
        }

        if (ca == EOF) {
            if (ferror(a) || ferror(b)) {
                result = -1;
            }
            break;
        }
    }

    if (fclose(a) == EOF) {
        result = -1;
    }

    if (fclose(b) == EOF) {
        result = -1;
    }

    return result;
}
```

### Trappola

Due file possono avere lo stesso prefisso ma lunghezza diversa.

---

## Esercizio 7 — Appendi una riga

### Consegna

Aggiungere una stringa come nuova riga in fondo a un file.

Non aggiungere due newline se la stringa termina già con `'\n'`.

### Soluzione

```c
#include <string.h>

int appendLine(
    const char *path,
    const char *line
) {
    if (path == NULL || line == NULL) {
        return 0;
    }

    FILE *file = fopen(path, "a");

    if (file == NULL) {
        return 0;
    }

    int success = fputs(line, file) != EOF;

    size_t length = strlen(line);

    if (
        success &&
        (length == 0 || line[length - 1] != '\n')
    ) {
        success = fputc('\n', file) != EOF;
    }

    if (fclose(file) == EOF) {
        success = 0;
    }

    return success;
}
```

---

# Livello 2 — Filtri e trasformazioni streaming

---

## Esercizio 8 — Copia solo lettere maiuscole convertite in minuscolo

### Consegna

Leggere un file sorgente e scrivere nel file destinazione tutti e soli i caratteri tra `'A'` e `'Z'`, convertiti in minuscolo.

### Soluzione semplice

```c
int filterUppercaseFile(
    const char *sourcePath,
    const char *destinationPath
) {
    FILE *in = fopen(sourcePath, "r");

    if (in == NULL) {
        return 0;
    }

    FILE *out = fopen(destinationPath, "w");

    if (out == NULL) {
        fclose(in);
        return 0;
    }

    int success = 1;
    int c;

    while ((c = fgetc(in)) != EOF) {
        if (c >= 'A' && c <= 'Z') {
            int lower = c - 'A' + 'a';

            if (fputc(lower, out) == EOF) {
                success = 0;
                break;
            }
        }
    }

    if (ferror(in)) {
        success = 0;
    }

    if (fclose(out) == EOF) {
        success = 0;
    }

    if (fclose(in) == EOF) {
        success = 0;
    }

    return success;
}
```

### Pattern

```text
read → filter → transform → write
```

È la versione streaming del classico esercizio stringa → lista.

---

## Esercizio 9 — Rimuovi righe vuote

### Consegna

Copiare un file di testo eliminando le righe vuote.

Una riga è vuota se contiene soltanto `'\n'`.

### Soluzione semplice con `fgets`

```c
int removeEmptyLines(
    const char *sourcePath,
    const char *destinationPath
) {
    FILE *in = fopen(sourcePath, "r");
    FILE *out = NULL;
    int success = 0;

    if (in == NULL) {
        goto cleanup;
    }

    out = fopen(destinationPath, "w");

    if (out == NULL) {
        goto cleanup;
    }

    char buffer[1024];

    while (fgets(buffer, sizeof(buffer), in) != NULL) {
        if (
            !(buffer[0] == '\n' &&
              buffer[1] == '\0')
        ) {
            if (fputs(buffer, out) == EOF) {
                goto cleanup;
            }
        }
    }

    if (ferror(in)) {
        goto cleanup;
    }

    success = 1;

cleanup:
    if (out != NULL && fclose(out) == EOF) {
        success = 0;
    }

    if (in != NULL && fclose(in) == EOF) {
        success = 0;
    }

    return success;
}
```

### Limite

Una riga più lunga del buffer viene letta in più frammenti.

Se la semantica richiede righe complete, serve un lettore dinamico.

---

## Esercizio 10 — Normalizza whitespace

### Consegna

Scrivere un nuovo file nel quale ogni sequenza di whitespace diventa un singolo spazio e non vi siano spazi iniziali o finali.

### Soluzione streaming

Stato necessario:

```text
hasOutput
pendingSpace
```

```c
int normalizeWhitespaceFile(
    const char *sourcePath,
    const char *destinationPath
) {
    FILE *in = fopen(sourcePath, "r");

    if (in == NULL) {
        return 0;
    }

    FILE *out = fopen(destinationPath, "w");

    if (out == NULL) {
        fclose(in);
        return 0;
    }

    int success = 1;
    int hasOutput = 0;
    int pendingSpace = 0;
    int c;

    while ((c = fgetc(in)) != EOF) {
        if (isspace((unsigned char)c)) {
            if (hasOutput) {
                pendingSpace = 1;
            }
        } else {
            if (pendingSpace) {
                if (fputc(' ', out) == EOF) {
                    success = 0;
                    break;
                }

                pendingSpace = 0;
            }

            if (fputc(c, out) == EOF) {
                success = 0;
                break;
            }

            hasOutput = 1;
        }
    }

    if (ferror(in)) {
        success = 0;
    }

    if (fclose(out) == EOF) {
        success = 0;
    }

    if (fclose(in) == EOF) {
        success = 0;
    }

    return success;
}
```

---

## Esercizio 11 — Numerare le righe

### Consegna

Copiare un file anteponendo a ogni riga:

```text
numero: contenuto
```

Esempio:

```text
1: prima riga
2: seconda riga
```

### Soluzione semplice

Con buffer fisso, bisogna distinguere:

```text
inizio di una nuova riga
frammento successivo della stessa riga lunga
```

Una soluzione più sicura usa una funzione `readLineDynamic`.

---

## Esercizio 12 — Sostituzione di caratteri

### Consegna

Sostituire ogni occorrenza di `oldChar` con `newChar` durante la copia.

### Soluzione

È una scansione lineare:

```c
int output = c == oldChar ? newChar : c;
```

### Complessità

- Tempo: `O(B)`
- Memoria: `O(1)`

---

## Esercizio 13 — Censura di una parola

### Consegna

Sostituire ogni occorrenza non sovrapposta di una parola con asterischi della stessa lunghezza.

### Soluzione semplice

Leggere il file interamente in memoria, applicare una ricerca di sottostringa e scrivere.

### Soluzione streaming più complessa

Mantenere un buffer di lunghezza pari alla parola, perché un match può attraversare i confini dei blocchi letti.

### Punto d'esame

Non tutte le trasformazioni possono essere fatte correttamente trattando ogni blocco in isolamento.

---

# Livello 3 — Lettura per righe e memoria dinamica

---

## Esercizio 14 — Lettura dinamica di una riga

### Consegna

Leggere una riga di lunghezza arbitraria da `FILE *`.

Restituire:

- stringa allocata senza newline;
- `NULL` a EOF prima di leggere caratteri;
- stato separato per distinguere EOF da errore.

### Struttura

```c
typedef enum {
    READ_LINE_OK,
    READ_LINE_EOF,
    READ_LINE_ERROR
} ReadLineResult;

ReadLineResult readLineDynamic(
    FILE *file,
    char **outLine
);
```

### Soluzione

```c
#include <stdlib.h>

ReadLineResult readLineDynamic(
    FILE *file,
    char **outLine
) {
    if (file == NULL || outLine == NULL) {
        return READ_LINE_ERROR;
    }

    *outLine = NULL;

    size_t capacity = 64;
    size_t length = 0;

    char *line = malloc(capacity);

    if (line == NULL) {
        return READ_LINE_ERROR;
    }

    int c;

    while (
        (c = fgetc(file)) != EOF &&
        c != '\n'
    ) {
        if (length + 1 >= capacity) {
            size_t newCapacity = capacity * 2;
            char *tmp = realloc(line, newCapacity);

            if (tmp == NULL) {
                free(line);
                return READ_LINE_ERROR;
            }

            line = tmp;
            capacity = newCapacity;
        }

        line[length++] = (char)c;
    }

    if (c == EOF) {
        if (ferror(file)) {
            free(line);
            return READ_LINE_ERROR;
        }

        if (length == 0) {
            free(line);
            return READ_LINE_EOF;
        }
    }

    line[length] = '\0';

    char *tmp = realloc(line, length + 1);

    if (tmp != NULL) {
        line = tmp;
    }

    *outLine = line;
    return READ_LINE_OK;
}
```

### Complessità

- Tempo ammortizzato: `O(L)`
- Spazio: `O(L)`

---

## Esercizio 15 — Riga più lunga

### Consegna

Restituire una copia dinamica della prima riga di lunghezza massima.

Per file vuoto, restituire una stringa vuota.

### Strategia

1. Usa `readLineDynamic`.
2. Mantieni `best` e `bestLength`.
3. Quando una riga è più lunga:
   - libera il vecchio best;
   - trasferisci ownership della nuova riga.
4. In caso contrario, libera la riga corrente.

### Trappola

Non conservare il puntatore a un buffer riutilizzato da `fgets`.

---

## Esercizio 16 — Carica tutte le righe

### Consegna

Restituire:

```c
typedef struct {
    char **lines;
    size_t size;
} StringArray;
```

contenente copie di tutte le righe.

### Soluzione

Usare capacità dinamica per l'array di puntatori e `readLineDynamic` per ogni riga.

### Cleanup parziale

Se una riallocazione fallisce:

```text
libera ogni lines[i]
libera lines
chiudi file
```

---

## Esercizio 17 — Ultime k righe

### Consegna

Restituire le ultime `k` righe di un file senza caricarle tutte.

### Soluzione semplice con buffer circolare di stringhe

Mantieni un array di `k` puntatori:

```text
slot = count % k
libera vecchia riga nello slot
salva nuova riga
```

Alla fine ricostruisci l'ordine cronologico.

### Complessità

- Tempo: `O(B)`
- Memoria: `O(dimensione totale delle ultime k righe)`

---

## Esercizio 18 — Prima riga che soddisfa un predicato

### Consegna

Restituire la prima riga per cui una callback restituisce vero.

### Struttura

```c
typedef _Bool (*LinePredicate)(
    const char *line,
    void *context
);

char *findFirstLine(
    const char *path,
    LinePredicate predicate,
    void *context
);
```

### Ownership

La stringa restituita è owned dal chiamante.

Le righe scartate vengono liberate.

---

# Livello 4 — Numeri e record testuali

---

## Esercizio 19 — Somma di interi

### Consegna

Il file contiene interi separati da whitespace.

Calcolare la somma.

### Soluzione

```c
int sumIntegersFile(
    const char *path,
    long long *out
) {
    if (path == NULL || out == NULL) {
        return 0;
    }

    FILE *file = fopen(path, "r");

    if (file == NULL) {
        return 0;
    }

    long long sum = 0;
    int value;
    int result;

    while (
        (result = fscanf(file, "%d", &value))
        == 1
    ) {
        sum += value;
    }

    int success;

    if (result == EOF) {
        success = !ferror(file);
    } else {
        /* token non interpretabile come int */
        success = 0;
    }

    if (fclose(file) == EOF) {
        success = 0;
    }

    if (success) {
        *out = sum;
    }

    return success;
}
```

### Distinzione essenziale

`fscanf` può terminare perché:

- EOF;
- errore I/O;
- token non compatibile con il formato.

---

## Esercizio 20 — Carica interi in array dinamico

### Consegna

Restituire tutti gli interi del file in un array dinamico.

### Struttura

```c
typedef struct {
    int *data;
    size_t size;
} IntArray;

int loadIntegers(
    const char *path,
    IntArray *out
);
```

### Soluzione

Capacità geometrica:

```text
0 → 4 → 8 → 16 → ...
```

Ogni valore letto viene aggiunto.

Su errore di parsing o memoria:

```text
libera array
chiudi file
lascia out in stato vuoto
```

---

## Esercizio 21 — Media e varianza in streaming

### Consegna

Calcolare media e varianza senza caricare tutti i valori.

### Soluzione numericamente migliore

Algoritmo di Welford:

```text
count++
delta = x - mean
mean += delta / count
delta2 = x - mean
M2 += delta * delta2
variance = M2 / count
```

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)`

---

## Esercizio 22 — Record studente testuale

### Struttura

```c
typedef struct {
    unsigned int id;
    char name[64];
    double grade;
} Student;
```

Formato di ogni riga:

```text
id;name;grade
```

### Consegna

Leggere un record con validazione.

### Soluzione semplice con `fgets` + parsing

```c
int parseStudentLine(
    const char *line,
    Student *out
) {
    unsigned int id;
    char name[64];
    double grade;
    char extra;

    int converted = sscanf(
        line,
        "%u;%63[^;];%lf %c",
        &id,
        name,
        &grade,
        &extra
    );

    if (converted != 3) {
        return 0;
    }

    if (grade < 0.0 || grade > 30.0) {
        return 0;
    }

    out->id = id;
    memcpy(out->name, name, sizeof(name));
    out->name[sizeof(out->name) - 1] = '\0';
    out->grade = grade;

    return 1;
}
```

### Perché `%63[^;]`

Evita overflow del buffer.

### Limite

Non gestisce nomi contenenti `;` o quoting CSV.

---

## Esercizio 23 — Carica record validi e conta scarti

### Consegna

Caricare in array dinamico tutti i record validi. Le righe invalide vengono ignorate e contate.

### Output

```c
typedef struct {
    Student *data;
    size_t size;
    size_t invalidLines;
} StudentLoadResult;
```

### Pattern

```text
read complete line
parse
if valid → append
else → invalidLines++
```

---

## Esercizio 24 — Cerca studente per ID

### Consegna

Trovare il primo record con ID richiesto senza caricare l'intero file.

### Soluzione streaming

Leggi una riga alla volta e interrompi al primo match.

### Complessità

- Migliore: `O(1)` record
- Peggiore: `O(n)` record
- Memoria: una riga

---

## Esercizio 25 — Studente con voto massimo

### Consegna

Restituire il primo studente con voto massimo.

### Strategia

Mantieni:

```text
hasBest
best
```

Aggiorna soltanto con:

```c
current.grade > best.grade
```

non `>=`, per preservare il primo in caso di parità.

---

# Livello 5 — Unione, merge e ordinamento di file

---

## Esercizio 26 — Merge di due file di interi ordinati

### Consegna

I due file contengono interi ordinati in modo non decrescente.

Scrivere un terzo file ordinato contenente tutti i valori, duplicati compresi.

### Soluzione

Usare due letture correnti:

```c
int hasA = fscanf(a, "%d", &valueA) == 1;
int hasB = fscanf(b, "%d", &valueB) == 1;
```

Poi classico merge:

```text
while hasA && hasB
scrivi minore
avanza solo il file scelto
```

### Complessità

- Tempo: `O(n+m)`
- Spazio: `O(1)`

### Hidden test

- uno o entrambi vuoti;
- lunghezze diverse;
- valori uguali;
- token invalido;
- errore di scrittura.

---

## Esercizio 27 — Intersezione di file ordinati senza duplicati

### Consegna

Scrivere nel risultato i valori presenti in entrambi, una sola volta.

### Strategia

Due cursori:

```text
a < b → avanza A
b < a → avanza B
a == b → scrivi e avanza entrambi
```

### Complessità

- Tempo: `O(n+m)`
- Spazio: `O(1)`

---

## Esercizio 28 — Unione senza duplicati di file ordinati

### Consegna

Produrre un file ordinato con ogni valore una sola volta.

### Punto delicato

Gli input potrebbero contenere duplicati interni.

Serve saltare run di valori uguali anche dentro lo stesso file.

---

## Esercizio 29 — Ordinare un file piccolo

### Consegna

Il file contiene interi e si può assumere che entri in memoria.

Produrre un file ordinato.

### Soluzione semplice

1. `loadIntegers`.
2. `qsort`.
3. `fprintf` dei valori.
4. cleanup.

### Complessità

- Tempo: `O(n log n)`
- Memoria: `O(n)`

---

## Esercizio 30 — External merge sort concettuale

### Consegna

Ordinare un file troppo grande per la memoria disponibile.

### Strategia

1. Leggi blocchi che entrano in memoria.
2. Ordina ogni blocco.
3. Scrivi run temporanee ordinate.
4. Esegui merge delle run.
5. Rimuovi i file temporanei.

### Complessità

Dominata dagli accessi I/O e dai merge.

### Punto didattico

Quando i dati non entrano in memoria, la complessità degli accessi al file diventa parte centrale dell'algoritmo.

---

# Livello 6 — Aggiornamenti sicuri tramite file temporaneo

---

## Esercizio 31 — Rimuovi record per ID

### Consegna

Rimuovere da un archivio testuale tutti i record con un certo ID.

Non si può “accorciare” comodamente il file in mezzo.

### Strategia robusta

1. Apri sorgente in lettura.
2. Crea file temporaneo.
3. Copia soltanto record da conservare.
4. Chiudi entrambi.
5. Se tutto è riuscito:
   - rimuovi o sostituisci il vecchio file;
   - rinomina il temporaneo.
6. In caso di errore:
   - elimina il temporaneo;
   - preserva l'originale.

### Pseudocodice

```c
success = copyFiltered(original, temporary);

if (success) {
    remove(original);
    rename(temporary, original);
} else {
    remove(temporary);
}
```

### Nota di robustezza

La sequenza `remove + rename` non offre sempre atomicità completa su ogni piattaforma. In un esercizio universitario è normalmente il pattern atteso, ma va documentato.

---

## Esercizio 32 — Aggiorna il voto di uno studente

### Consegna

Sostituire il voto del record con ID dato.

Restituire:

```text
UPDATED
NOT_FOUND
ERROR
```

### Strategia

Riscrittura tramite temporaneo.

### Hidden test

- ID assente: originale deve rimanere valido;
- più record con stesso ID: specificare primo o tutti;
- nuovo voto invalido;
- errore di scrittura;
- temporaneo già esistente.

---

## Esercizio 33 — Inserimento ordinato in archivio testuale

### Consegna

Il file contiene record ordinati per ID.

Inserire un nuovo record mantenendo l'ordine e rifiutando ID duplicati.

### Soluzione streaming

Durante la copia:

```text
finché current.id < new.id → copia
se current.id == new.id → duplicato
prima del primo current.id > new.id → scrivi nuovo, poi current
```

Alla fine, se non inserito, scrivi il nuovo record.

### Complessità

- Tempo: `O(n)`
- Spazio: `O(1)` oltre alla riga

---

# Livello 7 — File binari

---

## Esercizio 34 — Scrivi e leggi array di interi

### Consegna

Salvare un array in file binario con formato:

```text
uint64_t count
count valori int32_t
```

### Scrittura

```c
#include <stdint.h>

int saveIntArrayBinary(
    const char *path,
    const int32_t data[],
    uint64_t count
) {
    FILE *file = fopen(path, "wb");

    if (file == NULL) {
        return 0;
    }

    int success =
        fwrite(&count, sizeof(count), 1, file) == 1;

    if (
        success &&
        count > 0
    ) {
        success =
            fwrite(
                data,
                sizeof(*data),
                (size_t)count,
                file
            ) == (size_t)count;
    }

    if (fclose(file) == EOF) {
        success = 0;
    }

    return success;
}
```

### Lettura

1. Leggi count.
2. Verifica che sia rappresentabile in `size_t`.
3. Verifica overflow di `count * sizeof(element)`.
4. Alloca.
5. Leggi esattamente count elementi.
6. Verifica che non vi siano dati troncati.

### Portabilità

Scrivere direttamente interi binari dipende da:

- endianness;
- dimensione del tipo;
- rappresentazione.

L'uso di `int32_t` fissa la dimensione, non l'endianness.

---

## Esercizio 35 — Header con magic e versione

### Consegna

Definire un formato binario con header:

```c
typedef struct {
    unsigned char magic[4];
    uint32_t version;
    uint64_t count;
} FileHeader;
```

Magic:

```text
"P2DB"
```

### Validazione

Dopo `fread`:

- magic corretto;
- versione supportata;
- count plausibile;
- nessun overflow.

### Perché serve

Un file binario non dovrebbe essere interpretato alla cieca come la struct attesa.

---

## Esercizio 36 — Non serializzare puntatori

### Consegna teorico-pratica

Si consideri:

```c
typedef struct {
    char *name;
    int age;
} Person;
```

Perché è sbagliato:

```c
fwrite(&person, sizeof(person), 1, file);
```

### Risposta

Viene scritto il valore del puntatore `name`, non i caratteri della stringa.

Quando il file viene riletto, quell'indirizzo non è valido.

### Formato corretto

```text
uint32_t nameLength
nameLength byte
int32_t age
```

---

## Esercizio 37 — Serializza stringhe length-prefixed

### Consegna

Scrivere e leggere una stringa con formato:

```text
uint32_t length
length byte senza terminatore
```

### Scrittura

```c
int writeString(
    FILE *file,
    const char *s
) {
    size_t length = strlen(s);

    if (length > UINT32_MAX) {
        return 0;
    }

    uint32_t storedLength =
        (uint32_t)length;

    if (
        fwrite(
            &storedLength,
            sizeof(storedLength),
            1,
            file
        ) != 1
    ) {
        return 0;
    }

    return
        length == 0 ||
        fwrite(s, 1, length, file) == length;
}
```

### Lettura

- leggi lunghezza;
- controlla limite massimo ragionevole;
- alloca `length + 1`;
- leggi esattamente `length`;
- aggiungi `'\0'`.

---

## Esercizio 38 — Archivio binario di record a dimensione fissa

### Struttura

```c
typedef struct {
    uint32_t id;
    char name[64];
    double grade;
} FixedStudent;
```

### Consegna

Supportare:

- append;
- lettura sequenziale;
- ricerca per indice;
- aggiornamento per indice.

### Nota di portabilità

Scrivere direttamente una struct può includere:

- padding;
- rappresentazioni dipendenti dalla piattaforma;
- endianness;
- formato `double`.

È accettabile per esercizi locali sulla stessa piattaforma, ma non come formato portabile.

---

# Livello 8 — Accesso casuale

---

## Esercizio 39 — Leggi record per indice

### Consegna

Dato un file di record binari a dimensione fissa, leggere il record in posizione `index`.

### Soluzione

```c
int readRecordAt(
    FILE *file,
    size_t index,
    FixedStudent *out
) {
    if (file == NULL || out == NULL) {
        return 0;
    }

    if (
        index >
        (size_t)(LONG_MAX / sizeof(*out))
    ) {
        return 0;
    }

    long offset =
        (long)(index * sizeof(*out));

    if (fseek(file, offset, SEEK_SET) != 0) {
        return 0;
    }

    return fread(
        out,
        sizeof(*out),
        1,
        file
    ) == 1;
}
```

### Complessità

- Seek + lettura: concettualmente `O(1)` rispetto al numero di record, dipendente dal sistema I/O.

---

## Esercizio 40 — Aggiorna record per indice

### Consegna

Aprire in `"rb+"`, posizionarsi e sovrascrivere un record della stessa dimensione.

### Pattern

```c
fseek(file, offset, SEEK_SET);
fwrite(&record, sizeof(record), 1, file);
```

### Vincolo

La dimensione del record deve rimanere fissa.

---

## Esercizio 41 — Numero di record da dimensione file

### Consegna

Determinare quanti record completi contiene il file.

### Soluzione

```c
int binaryRecordCount(
    FILE *file,
    size_t recordSize,
    size_t *out
) {
    if (
        file == NULL ||
        recordSize == 0 ||
        out == NULL
    ) {
        return 0;
    }

    if (fseek(file, 0, SEEK_END) != 0) {
        return 0;
    }

    long end = ftell(file);

    if (end < 0) {
        return 0;
    }

    if ((unsigned long)end % recordSize != 0) {
        return 0;
    }

    *out =
        (size_t)((unsigned long)end / recordSize);

    rewind(file);
    return 1;
}
```

### Nota

`ftell` su file binari è più adatto al calcolo di offset in byte. Su file di testo, il valore non va interpretato necessariamente come semplice numero di byte portabile.

---

## Esercizio 42 — Ricerca binaria su file ordinato

### Consegna

Un file binario contiene `int32_t` ordinati.

Cercare un valore senza caricare tutto.

### Soluzione

1. Determina count.
2. Intervallo `[left,right)`.
3. `middle`.
4. `fseek` a `middle * sizeof(int32_t)`.
5. `fread` del valore.
6. Aggiorna intervallo.

### Complessità

- `O(log n)` letture casuali
- memoria `O(1)`

---

# Livello 9 — Serializzazione di strutture dinamiche

---

## Esercizio 43 — Salva e carica una lista di interi

### Struttura

```c
typedef struct intNode IntNode;
typedef IntNode *IntList;

struct intNode {
    int32_t data;
    IntList next;
};
```

### Formato semplice

```text
uint64_t count
count valori int32_t
```

### Salvataggio

1. Conta nodi.
2. Scrivi count.
3. Scrivi valori in ordine.

### Caricamento

1. Leggi count.
2. Crea nodi con tail pointer.
3. In caso di malloc fallita:
   - distruggi lista parziale;
   - restituisci errore.

### Complessità

- Tempo: `O(n)`
- Memoria: `O(n)` per la lista

---

## Esercizio 44 — Salva e carica un albero binario

### Problema

La sola sequenza preorder dei valori non conserva la struttura.

### Formato preorder con marker

Per ogni posizione:

```text
byte 0 → NULL
byte 1 → nodo, seguito dal valore e dai due sottoalberi
```

### Serializzazione ricorsiva

```c
int saveTreeNode(
    FILE *file,
    IntTree tree
) {
    unsigned char marker =
        tree == NULL ? 0U : 1U;

    if (
        fwrite(&marker, 1, 1, file) != 1
    ) {
        return 0;
    }

    if (tree == NULL) {
        return 1;
    }

    if (
        fwrite(
            &tree->data,
            sizeof(tree->data),
            1,
            file
        ) != 1
    ) {
        return 0;
    }

    return
        saveTreeNode(file, tree->left) &&
        saveTreeNode(file, tree->right);
}
```

### Deserializzazione

- leggi marker;
- se `0`, `NULL`;
- se diverso da `1`, file corrotto;
- leggi valore;
- alloca nodo;
- carica sinistra;
- carica destra;
- cleanup completo su errore.

---

## Esercizio 45 — Salva ADT opaco

### Consegna

Un ADT opaco deve offrire:

```c
int setSave(Set set, FILE *file);
Set setLoad(FILE *file);
```

### Regola progettuale

Il client non deve accedere alla rappresentazione privata per serializzare.

La serializzazione fa parte dell'interfaccia dell'ADT.

### Punto difficile

Se l'ADT è generico, servono callback:

```text
serializeElement
deserializeElement
```

---

# Livello 10 — File temporanei, errori e robustezza

---

## Esercizio 46 — Copia con checksum

### Consegna

Copiare un file e calcolare contemporaneamente un checksum semplice:

```text
somma dei byte modulo 2^32
```

### Soluzione

Aggiorna checksum mentre i blocchi vengono copiati.

### Vantaggio

Una sola scansione.

---

## Esercizio 47 — Verifica copia

### Consegna

Dopo la copia, verificare che sorgente e destinazione abbiano stesso checksum e stessa dimensione.

### Nota

Un checksum semplice non garantisce identità: collisioni possibili.

Per esercizio è utile; per integrità reale servirebbe un hash crittografico.

---

## Esercizio 48 — Rotazione di log

### Consegna

Se un file supera una dimensione massima:

```text
log.txt → log.1.txt
nuovo log.txt vuoto
```

### Operazioni

- `fseek` / `ftell` o apertura separata per dimensione;
- `rename`;
- creazione del nuovo file.

### Errori da gestire

- file assente;
- rename fallita;
- impossibile creare il nuovo file;
- rischio di perdere il vecchio log.

---

## Esercizio 49 — Scrittura transazionale semplificata

### Consegna

Scrivere un nuovo contenuto senza lasciare un file parzialmente scritto se l'operazione fallisce.

### Pattern

```text
scrivi path.tmp
chiudi correttamente
rename path.tmp → path
```

### Importante

La chiusura va controllata prima del rename: errori di flush possono emergere durante `fclose`.

---

# Livello 11 — Parsing più difficile

---

## Esercizio 50 — CSV semplificato

### Consegna

Leggere righe CSV con campi separati da virgola, senza campi quotati.

### Soluzione semplice

- `readLineDynamic`;
- separazione manuale;
- validazione numero di campi;
- conversione numerica con `strtol` / `strtod`.

### Perché non affidarsi solo a `strtok`

`strtok`:

- modifica la stringa;
- tratta male campi vuoti consecutivi in alcuni usi;
- mantiene stato interno;
- non gestisce quoting CSV.

---

## Esercizio 51 — CSV con campi quotati

### Consegna

Supportare:

```text
"Rossi, Mario",42,"testo ""quotato"""
```

### Macchina a stati

Stati possibili:

```text
FIELD_START
UNQUOTED
QUOTED
AFTER_QUOTE
```

### Punto didattico

Il parsing affidabile è spesso una macchina a stati, non una singola `sscanf`.

---

## Esercizio 52 — File di configurazione key=value

### Consegna

Leggere:

```text
# commento
host = localhost
port = 8080
```

Regole:

- ignora righe vuote e commenti;
- trim whitespace;
- chiavi uniche;
- segnala righe invalide.

### Struttura risultato

Lista o array dinamico di:

```c
typedef struct {
    char *key;
    char *value;
} ConfigEntry;
```

### Punti difficili

- deep copy;
- chiavi duplicate;
- cleanup parziale;
- righe molto lunghe.

---

# Livello 12 — Problemi “infernali”

---

## Esercizio 53 — Top k parole più frequenti

### Consegna

Dato un file di testo, restituire le `k` parole più frequenti.

Normalizzazione:

- lettere ASCII;
- minuscolo;
- separatori non alfabetici.

### Soluzione semplice

1. Carica tutte le parole.
2. Ordina.
3. Conta run uguali.
4. Ordina le frequenze.

### Complessità

- memoria proporzionale al testo;
- tempo `O(w log w)`.

### Soluzione più efficiente

- hash map parola → frequenza;
- min-heap di dimensione `k`.

---

## Esercizio 54 — Merge di k file ordinati

### Consegna

Fondere `k` file di interi ordinati.

### Soluzione semplice

Merge ripetuto di due file:

```text
O(kN)` circa in casi sfavorevoli
```

### Soluzione ottimizzata

Min-heap con un valore corrente per file:

```text
heap element = (value, fileIndex)
```

Ogni estrazione:

1. scrive il minimo;
2. legge il prossimo valore dallo stesso file;
3. lo reinserisce.

### Complessità

```text
O(N log k)
```

---

## Esercizio 55 — Indice secondario

### Consegna

Un archivio binario contiene record a dimensione fissa non ordinati.

Costruire un file indice con coppie:

```text
id
offset
```

ordinate per ID.

### Uso

1. Ricerca binaria nell'indice.
2. Seek nell'archivio dati.
3. Lettura del record.

### Vantaggio

Non serve riordinare il file dati.

---

## Esercizio 56 — Deduplicazione di file enorme

### Consegna

Rimuovere righe duplicate da un file troppo grande per la memoria.

### Strategie

- ordinamento esterno, poi rimozione dei duplicati consecutivi;
- partizionamento hash in file temporanei;
- Bloom filter come pre-filtro, ma con falsi positivi.

### Punto didattico

La scelta dipende da:

```text
memoria disponibile
dimensione input
ordine da preservare
probabilità/ammissibilità di falsi positivi
```

---

## Esercizio 57 — Tail efficiente

### Consegna

Stampare le ultime `k` righe di un file molto grande.

### Soluzione semplice

Buffer circolare durante scansione completa: `O(B)`.

### Soluzione più efficiente su file seekable

1. Parti dalla fine.
2. Leggi blocchi all'indietro.
3. Conta newline.
4. Quando trovi abbastanza righe, stampa il suffisso.

### Punti difficili

- file senza newline finale;
- file più corto di `k` righe;
- offset e blocchi;
- ordine dei dati letti all'indietro.

---

## Esercizio 58 — Reverse delle righe

### Consegna

Scrivere le righe di un file in ordine inverso, senza invertire i caratteri interni.

### Soluzione semplice

Carica tutte le righe e scrivile al contrario.

### Soluzione con offset

1. Prima scansione: salva offset di inizio riga.
2. Seconda fase: seek agli offset in ordine inverso.
3. Leggi e scrivi ogni riga.

### Complessità

- Memoria: `O(numero di righe)` per gli offset, non per tutto il contenuto.

---

## Esercizio 59 — Database append-only con log di operazioni

### Consegna

Memorizzare operazioni:

```text
SET key value
DELETE key
```

Il valore corrente si ricostruisce riproducendo il log.

### Operazioni

- append rapido;
- recovery;
- compaction periodica;
- gestione di una riga finale troncata.

### Punto difficile

Una scrittura interrotta può lasciare un record parziale. Il formato deve permettere di rilevarlo.

---

## Esercizio 60 — Formato binario versionato e checksum

### Consegna

Progettare un formato con:

```text
magic
version
payload length
payload
checksum
```

### Deserializzazione robusta

Ordine dei controlli:

1. header completo;
2. magic;
3. versione supportata;
4. lunghezza entro limite;
5. nessun overflow;
6. payload completo;
7. checksum corretto;
8. assenza o gestione dei byte extra.

### Obiettivo

Non fidarsi mai completamente dei dati del file.

---

# 13. Tracce aggiuntive senza soluzione completa

## Lettura e scrittura base

1. Conta caratteri alfabetici.
2. Conta vocali per tipo.
3. Conta righe che terminano con un punto.
4. Trova la prima posizione di un byte.
5. Trova l'ultima posizione di un byte.
6. Copia soltanto i caratteri stampabili.
7. Converti tutto in maiuscolo.
8. Elimina commenti `//`.
9. Elimina commenti `/* ... */` con macchina a stati.
10. Espandi tab in spazi.
11. Comprimi sequenze di spazi.
12. Aggiungi numeri di colonna.
13. Duplica ogni riga.
14. Scrivi una riga sì e una no.
15. Estrai intervallo di righe.

## Righe e stringhe

16. Conta parole per riga.
17. Trova la riga con più parole.
18. Ordina le righe lessicograficamente.
19. Elimina righe duplicate.
20. Elimina righe consecutive duplicate.
21. Filtra righe per prefisso.
22. Filtra righe per sottostringa.
23. Sostituisci una parola intera.
24. Spezza un file in file da `k` righe.
25. Concatena più file con separatori.
26. Interseca le righe di due file.
27. Differenza tra insiemi di righe.
28. Confronto ignorando whitespace.
29. Confronto ignorando maiuscole.
30. Calcola longest common prefix tra righe.

## Numeri

31. Minimo, massimo e media.
32. Mediana di un file piccolo.
33. Istogramma di valori in range.
34. Rimuovi duplicati da file ordinato.
35. Conta inversioni caricando in memoria.
36. Merge di due file senza duplicati.
37. Intersezione con molteplicità.
38. Differenza simmetrica.
39. Partiziona positivi e negativi in due file.
40. Distribuisci valori in bucket.
41. Trova longest increasing run.
42. Trova primo valore ripetuto.
43. Verifica che il file sia ordinato.
44. Verifica che due file siano permutazioni.
45. Calcola checksum numerico.

## Record

46. Cerca record per nome.
47. Conta record per categoria.
48. Raggruppa record in file separati.
49. Ordina record per chiave.
50. Merge di archivi ordinati.
51. Rimuovi duplicati per ID.
52. Aggiorna più record.
53. Costruisci un indice in memoria.
54. Costruisci indice su file.
55. Join di due archivi per ID.
56. Left join.
57. Record presenti in uno solo dei file.
58. Top studenti per voto.
59. Statistiche per gruppo.
60. Archivio con stringhe dinamiche.

## Binari e accesso casuale

61. Copia file binario a blocchi.
62. Leggi record casuale.
63. Scambia due record sul file.
64. Ordina file binario in place per file piccolo.
65. Ricerca binaria su record.
66. Tombstone per cancellazione logica.
67. Free-list di slot cancellati.
68. Compaction di archivio.
69. Header con contatore record.
70. Upgrade da versione 1 a versione 2.
71. Rileva file troncato.
72. Calcola checksum per record.
73. Salva matrice dinamica.
74. Salva lista di stringhe.
75. Salva BST.
76. Salva set generico con callback.
77. Deserializzazione con limiti di sicurezza.
78. Conversione endianness.
79. Formato TLV: type-length-value.
80. Journal per recovery.

## Avanzati

81. External merge sort.
82. Merge di k run.
83. Top-k in streaming.
84. Reservoir sampling.
85. Conteggio approssimato di distinti.
86. Ricerca di pattern a blocchi.
87. Indicizzazione invertita parola → righe.
88. Deduplicazione preservando prima occorrenza.
89. Tail efficiente.
90. Reverse di record variabili.
91. Compressione RLE.
92. Decompressione RLE.
93. Huffman concettuale.
94. Parser CSV quoted.
95. Parser JSON semplificato.
96. Log append-only.
97. Snapshot + journal.
98. Scrittura transazionale.
99. File locking concettuale.
100. Cache LRU di blocchi.

---

# 14. Errori tipici da riconoscere

## `while (!feof(file))`

È quasi sempre sbagliato.

Usare il risultato della funzione di lettura come condizione.

## Memorizzare `fgetc` in `char`

Perde la distinzione affidabile da `EOF`.

## Ignorare il ritorno di `fscanf`

Il vecchio valore della variabile potrebbe essere riutilizzato dopo una conversione fallita.

## `%s` senza larghezza

Sbagliato:

```c
fscanf(file, "%s", buffer);
```

Corretto con buffer da 64:

```c
fscanf(file, "%63s", buffer);
```

## Confondere riga e frammento di riga

`fgets` con buffer fisso può restituire una parte di una riga lunga.

## Non controllare `fclose`

Gli errori di scrittura bufferizzata possono emergere durante flush/close.

## Aprire output prima di input con stesso percorso

Se i percorsi coincidono e si apre `"w"`, il contenuto viene troncato prima della lettura.

## Serializzare puntatori

Gli indirizzi non sono dati persistenti validi.

## Scrivere struct pensando che il formato sia portabile

Padding, endianness e rappresentazioni possono cambiare.

## Fidarsi delle lunghezze lette dal file

Può causare overflow o allocazioni gigantesche.

## Perdere il temporaneo o l'originale

Ogni ramo di errore deve lasciare uno stato definito.

## Usare `rewind` senza considerare errori precedenti

`rewind` azzera indicatori di EOF ed errore, ma non restituisce un esito. Quando serve controllo, usare `fseek`.

---

# 15. Checklist di test

## Apertura

- [ ] file assente;
- [ ] permessi insufficienti;
- [ ] path `NULL`;
- [ ] directory al posto di file;
- [ ] destinazione non creabile;
- [ ] input e output con stesso percorso.

## Contenuto

- [ ] file vuoto;
- [ ] un byte;
- [ ] una riga senza newline;
- [ ] una riga con newline;
- [ ] righe molto lunghe;
- [ ] caratteri non ASCII;
- [ ] byte zero in file binario;
- [ ] token invalido a metà;
- [ ] record troncato;
- [ ] header corrotto.

## Memoria

- [ ] `malloc` fallita;
- [ ] `realloc` fallita;
- [ ] cleanup di righe già caricate;
- [ ] lista/albero parziale;
- [ ] nessun doppio free;
- [ ] output lasciato vuoto su errore.

## Scrittura

- [ ] spazio disco insufficiente simulato concettualmente;
- [ ] `fwrite` parziale;
- [ ] errore al `fclose`;
- [ ] temporaneo rimosso su fallimento;
- [ ] originale preservato su fallimento.

---

# 16. Ordine consigliato di allenamento

## Fase 1 — API fondamentale

```text
1–7
```

Obiettivo:

- apertura;
- EOF;
- errori;
- chiusura;
- copia.

## Fase 2 — Trasformazioni streaming

```text
8–13
```

Obiettivo:

- leggere, filtrare, trasformare e scrivere senza caricare tutto.

## Fase 3 — Righe dinamiche

```text
14–18
```

Obiettivo:

- righe arbitrarie;
- capacità geometrica;
- ownership.

## Fase 4 — Numeri e record

```text
19–25
```

Obiettivo:

- parsing;
- validazione;
- array dinamici;
- statistiche.

## Fase 5 — Merge e aggiornamenti

```text
26–33
```

Obiettivo:

- due file ordinati;
- temporanei;
- preservazione dell'originale.

## Fase 6 — Binari e accesso casuale

```text
34–45
```

Obiettivo:

- `fread`/`fwrite`;
- formato;
- offset;
- serializzazione corretta.

## Fase 7 — Appelli infernali

```text
46–60
```

Obiettivo:

- robustezza;
- parser;
- file enormi;
- indici;
- formati versionati.

---

# 17. Scheda universale da compilare

```text
TIPO DI FILE:
testo / binario

MODALITÀ DI APERTURA:
____________________________________

CHI POSSIEDE IL FILE*:
____________________________________

COME TERMINA LA LETTURA:
____________________________________

COME DISTINGUO EOF ED ERRORE:
____________________________________

UNITÀ DI LETTURA:
byte / riga / token / record / blocco

INPUT PUÒ ESSERE MALFORMATO?
____________________________________

DIMENSIONE MASSIMA:
____________________________________

SERVE MEMORIA DINAMICA?
____________________________________

OUTPUT NUOVO O AGGIORNAMENTO?
____________________________________

L'ORIGINALE DEVE RESTARE INTATTO SU ERRORE?
____________________________________

SERVE FILE TEMPORANEO?
____________________________________

FORMATO:
____________________________________

HEADER / MAGIC / VERSION:
____________________________________

OWNERSHIP DEI DATI LETTI:
____________________________________

TEMPO:
____________________________________

MEMORIA:
____________________________________

CASI LIMITE:
____________________________________
```

Le domande decisive sono:

> “Qual è l'unità logica che sto leggendo: byte, riga, token o record?”

e:

> “Come distinguo una fine normale da un errore o da un input malformato?”

Per gli aggiornamenti, la domanda più importante diventa:

> “Se qualcosa fallisce a metà, il file originale rimane valido?”

Una soluzione corretta sui file non è soltanto quella che produce il contenuto atteso nel caso ideale. Deve anche:

```text
chiudere ogni risorsa
non riutilizzare dati dopo letture fallite
non perdere l'originale
non fidarsi di dimensioni non validate
ripulire ogni struttura parziale
```
