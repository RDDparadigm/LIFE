# 10.0 — File e dati in C

> Appunti per Obsidian — Programmazione II  
> Argomento: gestione dei file in C tramite I/O formattato (`stdio.h`)  
> Obiettivo: capire bene il ciclo di vita di un file, usare `fopen`, `fclose`, `fprintf`, `fscanf`, evitare errori classici e saper scrivere piccoli programmi che producono/consumano file.

---

## 1. Che cos'è un file?

Un **file** è un'unità con cui il sistema operativo organizza la **memoria persistente**.

Memoria persistente significa: i dati **sopravvivono allo spegnimento del computer**.

Esempi di file:

- immagini: `.jpg`, `.png`, `.gif`
- video: `.mov`, `.mp4`
- testi: `.txt`
- codice sorgente: `.c`, `.h`, `.java`
- slide: `.pdf`
- dati prodotti da un programma

In Programmazione II ci interessa soprattutto questo punto:

> Un file può essere usato come mezzo per salvare dati prodotti da un programma e farli leggere successivamente da un altro programma.

---

## 2. Programmi che elaborano file

Molti programmi lavorano sui file:

| Programma | Cosa fa con i file |
|---|---|
| `gcc` | legge file sorgenti e produce un eseguibile |
| editor | crea o modifica file |
| galleria immagini | visualizza file immagine |
| video player | legge file video |
| browser | legge file HTML/CSS/JS |

Quindi un file non è “qualcosa di speciale” solo per C: è uno strumento generale usato da tantissimi programmi.

---

## 3. Caso di studio: Termometro e Cruscotto

Le slide usano un esempio molto utile:

### Termometro

Il programma **Termometro** registra in un file le temperature delle ore 12:00 per ogni giorno della settimana.

È un:

```text
produttore di dati
```

perché crea/scrive dati dentro un file.

### Cruscotto

Il programma **Cruscotto** legge quel file e calcola:

- temperatura media
- temperatura minima
- temperatura massima

È un:

```text
consumatore di dati
```

perché legge/elabora dati prodotti da un altro programma.

Schema mentale:

```text
Termometro  --->  dati.txt  --->  Cruscotto
 scrive           file          legge/elabora
```

Domande fondamentali da saper rispondere:

1. Come si crea un file?
2. Come si apre un file?
3. Come si scrive in un file?
4. Come si legge da un file?
5. Come si chiude un file?
6. Come si gestiscono gli errori?

---

## 4. I file sono risorse

Un file è una **risorsa**.

Come per la memoria dinamica, una risorsa va:

1. acquisita
2. usata
3. rilasciata

Confronto importantissimo:

| Memoria dinamica | File |
|---|---|
| `malloc` | `fopen` |
| uso del puntatore | uso del `FILE *` |
| `free` | `fclose` |

Quindi:

```c
int *p = malloc(sizeof(int));
// uso p
free(p);
```

è concettualmente simile a:

```c
FILE *fp = fopen("dati.txt", "r");
// uso fp
fclose(fp);
```

La cosa importante è:

> Se acquisisco una risorsa, devo ricordarmi di rilasciarla.

Nel caso dei file, dimenticare `fclose` può causare:

- dati non scritti correttamente su disco
- perdita di dati ancora nel buffer
- consumo inutile di risorse del sistema operativo
- inconsistenza dei dati

---

## 5. Il formato dei dati

I dati dentro un file non sono magicamente comprensibili.

Devono seguire un **formato**.

Esempio:

```text
23 18 21 20 19 22 24
```

Questo formato potrebbe significare:

```text
sette numeri interi separati da spazi
```

Ma un altro programma potrebbe aspettarsi:

```text
giorno: lunedi temperatura: 23
giorno: martedi temperatura: 18
...
```

Quindi chi scrive e chi legge devono condividere lo stesso formato.

Regola da esame:

> Il programma che legge un file deve sapere in anticipo come sono organizzati i dati.

Se il formato atteso e il formato reale non coincidono, la lettura può fallire o produrre risultati sbagliati.

---

## 6. Funzioni principali per I/O formattato su file

Le funzioni viste nelle slide sono contenute in:

```c
#include <stdio.h>
```

Le principali sono:

| Funzione | Scopo |
|---|---|
| `fopen` | apre un file |
| `fclose` | chiude un file |
| `fprintf` | scrive dati formattati su file |
| `fscanf` | legge dati formattati da file |
| `feof` | controlla se è stata raggiunta la fine del file |

Prototipi importanti:

```c
FILE *fopen(const char *pathname, const char *mode);

int fclose(FILE *stream);

int fprintf(FILE *stream, const char *format, ...);

int fscanf(FILE *stream, const char *format, ...);

int feof(FILE *stream);
```

---

## 7. Il tipo `FILE *`

`FILE` è un tipo definito in `stdio.h`.

Non dobbiamo sapere com'è fatto internamente.

A noi interessa che:

```c
FILE *fp;
```

è un puntatore a una struttura gestita dalla libreria standard C, che rappresenta un **flusso di dati** da o verso un file.

Esempio:

```c
FILE *fp = fopen("dati.txt", "w");
```

Qui `fp` rappresenta il collegamento tra il programma e il file `dati.txt`.

Da questo momento, tutte le operazioni sul file passano da `fp`.

---

## 8. `fopen`: apertura di un file

La funzione:

```c
FILE *fopen(const char *pathname, const char *mode);
```

serve ad aprire un file.

Esempio:

```c
FILE *fp = fopen("dati.txt", "w");
```

Dove:

- `"dati.txt"` è il nome/percorso del file
- `"w"` è la modalità di apertura
- `fp` è il puntatore che useremo per scrivere/leggere

---

## 9. Modalità `"r"`: apertura in lettura

```c
FILE *fp = fopen("dati.txt", "r");
```

Significa:

```text
apro dati.txt per leggerlo
```

Caratteristiche:

- se il file esiste, viene aperto
- se il file non esiste, `fopen` restituisce `NULL`
- il puntatore interno al file si posiziona all'inizio
- ogni lettura sposta automaticamente la posizione in avanti

Esempio:

```c
FILE *fp = fopen("dati.txt", "r");

if (fp == NULL) {
    printf("Errore: impossibile aprire il file in lettura.\n");
    return 1;
}

// uso il file

fclose(fp);
```

---

## 10. Modalità `"w"`: apertura in scrittura

```c
FILE *fp = fopen("dati.txt", "w");
```

Significa:

```text
apro dati.txt per scriverci dentro
```

Caratteristiche:

- se il file non esiste, viene creato
- se il file esiste già, il contenuto precedente viene cancellato
- il puntatore interno al file si posiziona all'inizio
- ogni scrittura sposta automaticamente la posizione in avanti
- se l'apertura fallisce, `fopen` restituisce `NULL`

Attenzione enorme:

> `"w"` cancella il contenuto precedente del file.

Esempio:

```c
FILE *fp = fopen("dati.txt", "w");

if (fp == NULL) {
    printf("Errore: impossibile aprire il file in scrittura.\n");
    return 1;
}

fprintf(fp, "Ciao file!\n");

fclose(fp);
```

---

## 11. Modalità `"a"`: append

Extra importante.

```c
FILE *fp = fopen("dati.txt", "a");
```

Significa:

```text
apro dati.txt per aggiungere dati in fondo
```

Caratteristiche:

- se il file non esiste, viene creato
- se il file esiste, i nuovi dati vengono aggiunti alla fine
- il contenuto precedente non viene cancellato

Esempio:

```c
FILE *fp = fopen("log.txt", "a");

if (fp == NULL) {
    printf("Errore apertura file.\n");
    return 1;
}

fprintf(fp, "Nuova riga di log\n");

fclose(fp);
```

Differenza fondamentale:

| Modalità | Effetto |
|---|---|
| `"w"` | scrive da zero, cancellando il contenuto precedente |
| `"a"` | aggiunge in fondo, conservando il contenuto precedente |
| `"r"` | legge un file esistente |

---

## 12. `fclose`: chiusura del file

Ogni file aperto deve essere chiuso:

```c
fclose(fp);
```

Pattern corretto:

```c
FILE *fp = fopen("dati.txt", "r");

if (fp == NULL) {
    printf("Errore apertura file.\n");
    return 1;
}

// uso il file

fclose(fp);
```

Da ricordare:

> Dopo `fclose(fp)`, non devo più usare `fp` per leggere o scrivere.

È simile a ciò che succede dopo `free(p)` con la memoria dinamica.

---

## 13. `fprintf`: scrittura formattata su file

`fprintf` funziona come `printf`, ma invece di stampare sul terminale, scrive su un file.

Confronto:

```c
printf("Temperatura: %d\n", temp);
```

stampa sul terminale.

```c
fprintf(fp, "Temperatura: %d\n", temp);
```

scrive nel file associato a `fp`.

Esempio semplice:

```c
#include <stdio.h>

int main(void) {
    int x = 42;

    FILE *fp = fopen("dati.txt", "w");

    if (fp == NULL) {
        printf("Errore apertura file.\n");
        return 1;
    }

    fprintf(fp, "%d\n", x);

    fclose(fp);

    return 0;
}
```

Dopo l'esecuzione, `dati.txt` conterrà:

```text
42
```

---

## 14. `fscanf`: lettura formattata da file

`fscanf` funziona come `scanf`, ma legge da un file invece che da tastiera.

Confronto:

```c
scanf("%d", &x);
```

legge da tastiera.

```c
fscanf(fp, "%d", &x);
```

legge dal file associato a `fp`.

Esempio semplice:

```c
#include <stdio.h>

int main(void) {
    int x;

    FILE *fp = fopen("dati.txt", "r");

    if (fp == NULL) {
        printf("Errore apertura file.\n");
        return 1;
    }

    fscanf(fp, "%d", &x);

    printf("Ho letto: %d\n", x);

    fclose(fp);

    return 0;
}
```

Se `dati.txt` contiene:

```text
42
```

il programma stampa:

```text
Ho letto: 42
```

---

## 15. Perché in `fscanf` serve `&x`?

Questa è una cosa da capire molto bene.

Quando faccio:

```c
fscanf(fp, "%d", &x);
```

passo l'indirizzo di `x`.

Perché?

Perché `fscanf` deve modificare la variabile `x`.

Se passassi solo `x`, passerei una copia del valore. Invece con `&x` passo l'indirizzo della variabile originale.

Schema:

```c
int x;

fscanf(fp, "%d", &x);
```

significa:

```text
leggi un intero dal file e salvalo dentro la variabile x
```

Esattamente come con `scanf`.

---

## 16. Pattern base per leggere un file

Pattern generale:

```c
#include <stdio.h>

int main(void) {
    FILE *fp;
    int valore;

    fp = fopen("dati.txt", "r");

    if (fp == NULL) {
        printf("Errore: file non aperto.\n");
        return 1;
    }

    // uso del file
    fscanf(fp, "%d", &valore);

    fclose(fp);

    printf("Valore letto: %d\n", valore);

    return 0;
}
```

Le sezioni sono:

1. dichiarazione del `FILE *`
2. apertura con `fopen`
3. controllo errore
4. uso del file
5. chiusura con `fclose`
6. eventuale elaborazione/stampa finale

---

## 17. `feof`: fine del file

`feof(fp)` controlla se il file ha raggiunto la condizione di **end of file**.

Restituisce:

- `0` se la fine del file non è stata raggiunta
- valore diverso da `0` se la fine è stata raggiunta

Le slide introducono il pattern:

```c
while (!feof(fp)) {
    fscanf(fp, "%d", &temp);
    // elabora temp
}
```

Questo significa:

```text
finché non sono alla fine del file, leggo un dato ed elaboro
```

Però attenzione.

---

## 18. Il problema classico di `while (!feof(fp))`

Questo è un punto da 30 e lode.

Il pattern:

```c
while (!feof(fp)) {
    fscanf(fp, "%d", &temp);
    // elabora temp
}
```

è didatticamente semplice, ma in C può essere pericoloso.

Perché?

Perché `feof` diventa vero **solo dopo** che una lettura ha provato ad andare oltre la fine del file.

Quindi rischi di elaborare un valore non valido o di elaborare due volte l'ultimo valore, se non controlli bene l'esito di `fscanf`.

Pattern migliore:

```c
while (fscanf(fp, "%d", &temp) == 1) {
    // elabora temp
}
```

Questo significa:

```text
continua solo se fscanf è riuscita davvero a leggere un intero
```

Regola pratica:

> Per leggere una sequenza di dati formattati, è meglio controllare il valore restituito da `fscanf`.

---

## 19. Valore restituito da `fscanf`

`fscanf` restituisce il numero di elementi letti correttamente.

Esempio:

```c
int result = fscanf(fp, "%d", &x);
```

Se legge correttamente un intero:

```text
result == 1
```

Se non riesce a leggere:

```text
result != 1
```

Quindi il ciclo corretto è:

```c
while (fscanf(fp, "%d", &x) == 1) {
    printf("Letto: %d\n", x);
}
```

Per due valori:

```c
while (fscanf(fp, "%d %d", &a, &b) == 2) {
    printf("Letti: %d %d\n", a, b);
}
```

---

## 20. Esempio: Termometro completo

Programma che chiede 7 temperature all'utente e le scrive su file.

```c
#include <stdio.h>

#define GIORNI 7

int main(void) {
    int temp;
    FILE *fp = fopen("dati.txt", "w");

    if (fp == NULL) {
        printf("Errore: impossibile aprire dati.txt in scrittura.\n");
        return 1;
    }

    for (int i = 0; i < GIORNI; i++) {
        printf("Temperatura giorno %d: ", i + 1);
        scanf("%d", &temp);

        fprintf(fp, "%d ", temp);
    }

    fclose(fp);

    printf("Temperature salvate correttamente.\n");

    return 0;
}
```

Possibile contenuto di `dati.txt`:

```text
20 22 19 18 21 23 24
```

Cose importanti:

- apertura in `"w"`
- controllo `fp == NULL`
- scrittura con `fprintf`
- chiusura con `fclose`
- le temperature sono separate da spazi

---

## 21. Termometro generalizzato

Invece di leggere sempre 7 temperature, chiediamo all'utente quanti valori vuole inserire.

```c
#include <stdio.h>

int main(void) {
    int n;
    int temp;

    FILE *fp = fopen("dati.txt", "w");

    if (fp == NULL) {
        printf("Errore: impossibile aprire il file.\n");
        return 1;
    }

    printf("Quante temperature vuoi inserire? ");
    scanf("%d", &n);

    for (int i = 0; i < n; i++) {
        printf("Temperatura %d: ", i + 1);
        scanf("%d", &temp);

        fprintf(fp, "%d ", temp);
    }

    fclose(fp);

    return 0;
}
```

Domanda importante delle slide:

> Se il termometro viene generalizzato, il cruscotto deve cambiare?

Risposta:

> No, se il cruscotto legge fino a fine file.

Infatti il cruscotto non deve sapere in anticipo quanti valori ci sono: legge finché riesce a leggere interi.

---

## 22. Cruscotto: calcolo minimo, massimo e media

Versione robusta, usando `fscanf` nel modo consigliato.

```c
#include <stdio.h>

int main(void) {
    FILE *fp = fopen("dati.txt", "r");

    if (fp == NULL) {
        printf("Errore: impossibile aprire dati.txt in lettura.\n");
        return 1;
    }

    int temp;
    int min;
    int max;
    int somma = 0;
    int count = 0;

    if (fscanf(fp, "%d", &temp) == 1) {
        min = temp;
        max = temp;
        somma = temp;
        count = 1;

        while (fscanf(fp, "%d", &temp) == 1) {
            if (temp < min) {
                min = temp;
            }

            if (temp > max) {
                max = temp;
            }

            somma += temp;
            count++;
        }

        printf("Minimo: %d\n", min);
        printf("Massimo: %d\n", max);
        printf("Media: %.2f\n", (double)somma / count);
    } else {
        printf("Il file non contiene temperature valide.\n");
    }

    fclose(fp);

    return 0;
}
```

Questa versione è migliore rispetto a inizializzare `min` e `max` con valori artificiali tipo `MAX_VALUE` e `MIN_VALUE`.

Perché?

Perché inizializza `min` e `max` con il primo valore reale letto dal file.

---

## 23. Versione alternativa con limiti iniziali

Le slide suggeriscono concettualmente:

```c
min = MAX_VALUE;
max = MIN_VALUE;
```

In C potremmo farlo usando `limits.h`.

```c
#include <stdio.h>
#include <limits.h>

int main(void) {
    FILE *fp = fopen("dati.txt", "r");

    if (fp == NULL) {
        printf("Errore apertura file.\n");
        return 1;
    }

    int temp;
    int min = INT_MAX;
    int max = INT_MIN;
    int somma = 0;
    int count = 0;

    while (fscanf(fp, "%d", &temp) == 1) {
        if (temp < min) {
            min = temp;
        }

        if (temp > max) {
            max = temp;
        }

        somma += temp;
        count++;
    }

    fclose(fp);

    if (count > 0) {
        printf("Minimo: %d\n", min);
        printf("Massimo: %d\n", max);
        printf("Media: %.2f\n", (double)somma / count);
    } else {
        printf("Nessun dato valido trovato.\n");
    }

    return 0;
}
```

Questa è buona, ma devi ricordarti di controllare `count > 0`.

Se il file è vuoto, non puoi calcolare la media.

---

## 24. Attenzione alla divisione intera

Se fai:

```c
int somma = 10;
int count = 4;

printf("%d\n", somma / count);
```

ottieni:

```text
2
```

non:

```text
2.5
```

Perché `somma` e `count` sono interi.

Per ottenere una media decimale:

```c
printf("%.2f\n", (double)somma / count);
```

Cast importante:

```c
(double)somma
```

trasforma `somma` in `double`, quindi la divisione diventa reale.

---

## 25. Esempio riassuntivo: scrivere o leggere lo stesso file

Le slide propongono un programma in cui l'utente sceglie se scrivere o leggere.

Versione migliorata:

```c
#include <stdio.h>

#define MAX 20

int main(void) {
    int scrivi;
    FILE *fp;
    char nome[MAX];
    int id;

    printf("Vuoi scrivere o leggere? 1 = scrivere, 0 = leggere: ");
    scanf("%d", &scrivi);

    if (scrivi) {
        fp = fopen("dati.txt", "w");

        if (fp == NULL) {
            printf("Errore apertura file in scrittura.\n");
            return 1;
        }

        fprintf(fp, "nome: Anna id: 123\n");

        fclose(fp);

        printf("Dati scritti correttamente.\n");
    } else {
        fp = fopen("dati.txt", "r");

        if (fp == NULL) {
            printf("Errore apertura file in lettura.\n");
            return 1;
        }

        if (fscanf(fp, "nome: %19s id: %d", nome, &id) == 2) {
            printf("Ho letto: %s %d\n", nome, id);
        } else {
            printf("Formato del file non valido.\n");
        }

        fclose(fp);
    }

    return 0;
}
```

Nota importante:

```c
fscanf(fp, "nome: %19s id: %d", nome, &id)
```

- legge una stringa dentro `nome`
- legge un intero dentro `id`
- pretende che nel file ci siano anche le parti letterali `"nome:"` e `"id:"`
- `%19s` evita di scrivere oltre la dimensione dell'array `nome`

Dato atteso nel file:

```text
nome: Anna id: 123
```

Se il file contiene:

```text
Anna 123
```

la lettura fallisce, perché manca il pattern atteso.

---

## 26. Lettura formattata: pattern esplicito

Questa riga:

```c
fscanf(fp, "nome: %s id: %d", datiS, &datiN);
```

significa:

```text
mi aspetto di trovare:
nome: <stringa> id: <intero>
```

Le parti:

```text
nome:
id:
```

sono pattern espliciti.

Non vengono salvate nelle variabili.

Le parti con `%` vengono salvate:

```c
%s   -> datiS
%d   -> datiN
```

Quindi se il file contiene:

```text
nome: Anna id: 123
```

allora:

```c
datiS = "Anna";
datiN = 123;
```

Attenzione:

```c
%s
```

legge una parola fino al primo spazio.

Quindi se il file contiene:

```text
nome: Anna Maria id: 123
```

`%s` legge solo:

```text
Anna
```

Per leggere nomi con spazi servirebbero tecniche diverse, ad esempio `fgets`.

---

## 27. Pathname: dove viene creato il file?

Quando scrivi:

```c
fopen("dati.txt", "w");
```

stai usando un percorso relativo.

Significa:

```text
crea/apri dati.txt nella working directory del programma
```

La working directory non è sempre la cartella dove si trova il file `.c`.

Dipende da come esegui il programma.

In CLion, VS Code o terminale, può cambiare.

Per evitare confusione durante lo studio:

1. stampa un messaggio quando scrivi il file
2. controlla la cartella da cui stai eseguendo il programma
3. prova anche con un path assoluto solo per test

Esempio di path relativo con sottocartella:

```c
FILE *fp = fopen("data/dati.txt", "w");
```

La cartella `data` deve esistere già.

`fopen` crea il file, ma non crea automaticamente le cartelle mancanti.

---

## 28. `fseek`: spostare il puntatore nel file

Extra delle slide.

Normalmente leggiamo e scriviamo in modo sequenziale:

```text
leggo un dato -> il puntatore avanza
leggo un altro dato -> il puntatore avanza ancora
```

Con `fseek` posso spostare manualmente la posizione nel file.

Prototipo:

```c
int fseek(FILE *fp, long distanza, int partenza);
```

Dove:

- `fp` è il file
- `distanza` è di quanti byte mi sposto
- `partenza` indica da dove parto

Valori possibili di `partenza`:

| Costante | Significato |
|---|---|
| `SEEK_SET` | inizio del file |
| `SEEK_CUR` | posizione corrente |
| `SEEK_END` | fine del file |

Esempio:

```c
fseek(fp, 0, SEEK_SET);
```

significa:

```text
torna all'inizio del file
```

Esempio completo:

```c
#include <stdio.h>

int main(void) {
    FILE *fp = fopen("dati.txt", "r");

    if (fp == NULL) {
        printf("Errore apertura file.\n");
        return 1;
    }

    int x;

    fscanf(fp, "%d", &x);
    printf("Prima lettura: %d\n", x);

    fseek(fp, 0, SEEK_SET);

    fscanf(fp, "%d", &x);
    printf("Seconda lettura dopo fseek: %d\n", x);

    fclose(fp);

    return 0;
}
```

Se `dati.txt` contiene:

```text
10 20 30
```

stamperà:

```text
Prima lettura: 10
Seconda lettura dopo fseek: 10
```

---

## 29. Errori tipici da evitare

### 1. Non controllare `fopen`

Errore:

```c
FILE *fp = fopen("dati.txt", "r");
fscanf(fp, "%d", &x);
```

Se `fopen` fallisce, `fp == NULL`.

Usare `fscanf` su `NULL` è un errore grave.

Corretto:

```c
FILE *fp = fopen("dati.txt", "r");

if (fp == NULL) {
    printf("Errore apertura file.\n");
    return 1;
}
```

---

### 2. Dimenticare `fclose`

Errore:

```c
FILE *fp = fopen("dati.txt", "w");
fprintf(fp, "%d", 42);
return 0;
```

Corretto:

```c
FILE *fp = fopen("dati.txt", "w");

if (fp == NULL) {
    return 1;
}

fprintf(fp, "%d", 42);
fclose(fp);

return 0;
```

---

### 3. Aprire in `"w"` quando volevi aggiungere dati

Errore:

```c
FILE *fp = fopen("log.txt", "w");
```

Se `log.txt` esiste già, lo cancelli.

Se vuoi aggiungere:

```c
FILE *fp = fopen("log.txt", "a");
```

---

### 4. Usare `while (!feof(fp))` senza controllare `fscanf`

Fragile:

```c
while (!feof(fp)) {
    fscanf(fp, "%d", &x);
    printf("%d\n", x);
}
```

Meglio:

```c
while (fscanf(fp, "%d", &x) == 1) {
    printf("%d\n", x);
}
```

---

### 5. Non controllare file vuoto

Errore:

```c
printf("Media: %d\n", somma / count);
```

Se `count == 0`, divisione per zero.

Corretto:

```c
if (count > 0) {
    printf("Media: %.2f\n", (double)somma / count);
} else {
    printf("Nessun dato letto.\n");
}
```

---

### 6. Usare `%s` senza limite

Rischioso:

```c
char nome[20];
fscanf(fp, "%s", nome);
```

Meglio:

```c
char nome[20];
fscanf(fp, "%19s", nome);
```

Perché `nome` ha 20 celle e serve spazio anche per `'\0'`.

---

## 30. Esercizio delle slide: da cifre a parole

Richiesta:

> Scrivere un programma che legge dati da un primo file contenente cifre scritte come numeri (`0`, `1`, `2`, ..., `9`) e produce un secondo file contenente le stesse cifre scritte come parole (`zero`, `uno`, ..., `nove`).

Esempio:

Input `input.txt`:

```text
1 5 9 0 3
```

Output `output.txt`:

```text
uno cinque nove zero tre
```

---

## 31. Soluzione esercizio cifre/parole

```c
#include <stdio.h>

int main(void) {
    FILE *in = fopen("input.txt", "r");

    if (in == NULL) {
        printf("Errore: impossibile aprire input.txt.\n");
        return 1;
    }

    FILE *out = fopen("output.txt", "w");

    if (out == NULL) {
        printf("Errore: impossibile aprire output.txt.\n");
        fclose(in);
        return 1;
    }

    int cifra;

    while (fscanf(in, "%d", &cifra) == 1) {
        switch (cifra) {
            case 0:
                fprintf(out, "zero ");
                break;
            case 1:
                fprintf(out, "uno ");
                break;
            case 2:
                fprintf(out, "due ");
                break;
            case 3:
                fprintf(out, "tre ");
                break;
            case 4:
                fprintf(out, "quattro ");
                break;
            case 5:
                fprintf(out, "cinque ");
                break;
            case 6:
                fprintf(out, "sei ");
                break;
            case 7:
                fprintf(out, "sette ");
                break;
            case 8:
                fprintf(out, "otto ");
                break;
            case 9:
                fprintf(out, "nove ");
                break;
            default:
                fprintf(out, "? ");
                break;
        }
    }

    fclose(in);
    fclose(out);

    printf("Conversione completata.\n");

    return 0;
}
```

Nota importante:

Se apro `input.txt` correttamente ma poi fallisce `output.txt`, devo chiudere `input.txt` prima di uscire:

```c
fclose(in);
return 1;
```

Questo dimostra che ho capito davvero il concetto di rilascio delle risorse.

---

## 32. Versione più elegante con array di stringhe

Quando hai preso confidenza, puoi scrivere una versione più compatta.

```c
#include <stdio.h>

int main(void) {
    const char *parole[] = {
        "zero", "uno", "due", "tre", "quattro",
        "cinque", "sei", "sette", "otto", "nove"
    };

    FILE *in = fopen("input.txt", "r");

    if (in == NULL) {
        printf("Errore apertura input.txt.\n");
        return 1;
    }

    FILE *out = fopen("output.txt", "w");

    if (out == NULL) {
        printf("Errore apertura output.txt.\n");
        fclose(in);
        return 1;
    }

    int cifra;

    while (fscanf(in, "%d", &cifra) == 1) {
        if (cifra >= 0 && cifra <= 9) {
            fprintf(out, "%s ", parole[cifra]);
        } else {
            fprintf(out, "? ");
        }
    }

    fclose(in);
    fclose(out);

    return 0;
}
```

Questa versione è interessante perché usa:

- file
- array
- puntatori a stringhe
- controllo dei limiti
- `fscanf`
- `fprintf`

---

## 33. Mini-cheat sheet

### Aprire in lettura

```c
FILE *fp = fopen("dati.txt", "r");

if (fp == NULL) {
    printf("Errore apertura file.\n");
    return 1;
}
```

### Aprire in scrittura

```c
FILE *fp = fopen("dati.txt", "w");

if (fp == NULL) {
    printf("Errore apertura file.\n");
    return 1;
}
```

### Aprire in append

```c
FILE *fp = fopen("dati.txt", "a");

if (fp == NULL) {
    printf("Errore apertura file.\n");
    return 1;
}
```

### Scrivere un intero

```c
fprintf(fp, "%d\n", x);
```

### Leggere un intero

```c
fscanf(fp, "%d", &x);
```

### Leggere tanti interi

```c
while (fscanf(fp, "%d", &x) == 1) {
    printf("%d\n", x);
}
```

### Chiudere

```c
fclose(fp);
```

---

## 34. Cosa devi saper dire all'esame

Domande molto probabili:

### Che cos'è un file?

Un file è un'unità di memorizzazione persistente che contiene dati correlati e che può essere letto o scritto da programmi.

---

### Cos'è `FILE *`?

È un puntatore a una struttura gestita da `stdio.h`, che rappresenta un flusso di dati associato a un file.

---

### Cosa fa `fopen`?

Apre un file in una certa modalità e restituisce un `FILE *`.

Se fallisce, restituisce `NULL`.

---

### Differenza tra `"r"` e `"w"`?

- `"r"` apre un file esistente in lettura; se non esiste fallisce
- `"w"` apre un file in scrittura; se non esiste lo crea, se esiste lo cancella

---

### Perché devo controllare `fp == NULL`?

Perché l'apertura del file può fallire. Se uso un `FILE *` nullo con `fscanf` o `fprintf`, il programma può avere comportamento errato o crashare.

---

### Perché devo fare `fclose`?

Per rilasciare la risorsa file e garantire che eventuali dati buffered vengano effettivamente scritti.

---

### Differenza tra `printf` e `fprintf`?

- `printf` scrive sullo standard output, cioè di solito il terminale
- `fprintf` scrive su un file specificato tramite `FILE *`

---

### Differenza tra `scanf` e `fscanf`?

- `scanf` legge dallo standard input, cioè di solito la tastiera
- `fscanf` legge da un file specificato tramite `FILE *`

---

### Perché in `fscanf` uso `&x`?

Perché la funzione deve modificare la variabile `x`, quindi ha bisogno del suo indirizzo.

---

### Come leggo tutti gli interi da un file?

Pattern consigliato:

```c
while (fscanf(fp, "%d", &x) == 1) {
    // elabora x
}
```

---

### Perché `while (!feof(fp))` può essere rischioso?

Perché `feof` diventa vero solo dopo un tentativo di lettura oltre la fine del file. È più robusto controllare direttamente se `fscanf` è riuscita a leggere.

---

## 35. Esercizi consigliati da riscrivere a mano

Per prendere confidenza, riscrivi questi programmi senza copiare.

### Esercizio 1 — Scrivere un numero su file

Scrivi un programma che:

1. apre `numero.txt` in scrittura
2. chiede un intero all'utente
3. lo scrive nel file
4. chiude il file

---

### Esercizio 2 — Leggere un numero da file

Scrivi un programma che:

1. apre `numero.txt` in lettura
2. legge un intero
3. lo stampa a video
4. chiude il file

---

### Esercizio 3 — Somma di numeri

Dato un file `numeri.txt` contenente interi separati da spazi, calcola la somma.

Esempio:

```text
10 20 30
```

Output:

```text
Somma: 60
```

---

### Esercizio 4 — Minimo, massimo e media

Dato un file di temperature, calcola:

- minimo
- massimo
- media

Gestisci anche il caso di file vuoto.

---

### Esercizio 5 — Append log

Scrivi un programma che apre `log.txt` in append e aggiunge una nuova riga ogni volta che viene eseguito.

---

### Esercizio 6 — Cifre in parole

Risolvi l'esercizio delle slide:

```text
0 1 2 3
```

deve diventare:

```text
zero uno due tre
```

---

### Esercizio 7 — Formato nome/id

Scrivi su file:

```text
nome: Luca id: 456
```

Poi scrivi un altro programma che legge il file e stampa:

```text
Nome = Luca
ID = 456
```

---

## 36. Mappa mentale finale

```text
FILE
 |
 |-- memoria persistente
 |
 |-- formato dei dati
 |     |-- chi scrive e chi legge devono concordarlo
 |
 |-- stdio.h
 |     |-- FILE *
 |     |-- fopen
 |     |-- fclose
 |     |-- fprintf
 |     |-- fscanf
 |     |-- feof
 |
 |-- modalità apertura
 |     |-- r: lettura
 |     |-- w: scrittura, cancella contenuto precedente
 |     |-- a: append, aggiunge in fondo
 |
 |-- ciclo di vita
 |     |-- acquisizione: fopen
 |     |-- uso: fscanf/fprintf
 |     |-- rilascio: fclose
 |
 |-- errori
       |-- fopen può restituire NULL
       |-- fclose non va dimenticata
       |-- while(!feof) è fragile
       |-- formato fscanf deve combaciare col file
```

---

## 37. Sintesi da ricordare

Il concetto centrale della lezione è:

> Un file in C si usa tramite un `FILE *`, ottenuto con `fopen`, usato con funzioni come `fprintf` e `fscanf`, e obbligatoriamente rilasciato con `fclose`.

La sequenza mentale corretta è sempre:

```text
apro -> controllo errore -> uso -> chiudo
```

Pattern fondamentale:

```c
FILE *fp = fopen("dati.txt", "r");

if (fp == NULL) {
    printf("Errore apertura file.\n");
    return 1;
}

// uso del file

fclose(fp);
```

Per leggere tanti valori:

```c
while (fscanf(fp, "%d", &x) == 1) {
    // elabora x
}
```

Questo è il pattern che devi avere nelle mani.
