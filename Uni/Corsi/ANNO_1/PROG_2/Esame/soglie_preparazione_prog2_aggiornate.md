# Programmazione 2 — Nuove soglie operative per esonero ed esame

> Obiettivo: concentrarsi sugli esercizi con il miglior rapporto tra tempo investito e probabilità/utilità d’esame, evitando di restare bloccati per ore su problemi troppo avanzati rispetto alle esigenze reali.

---

# Soglia generale consigliata

```text
Allenamento generale: A–F tutto
Array/stringhe:       esercizi 1–23
Liste linkate:        esercizi 1–27
Alberi generici:      esercizi 1–29
BST:                  fino all’esercizio 37
Ricorsione:           esercizi 1–26
Generici/void*:       esercizi 1–19 + comprensione 20–28
File:                 esercizi 1–16 + selettivamente 19–23
Misti:                esercizi 1–16 + simulazioni 1–2
Teoria e quiz:        tutto
```

---

# 1. Allenamento generale

## Da padroneggiare completamente

- Parte A — Puntatori, `malloc`, stringhe e `struct`
- Parte B — Array e costruzione di output dinamici
- Parte C — Liste linkate
- Parte D — Stack, code e set
- Parte E — Ricorsione
- Parte F — Alberi e BST

## Da conoscere bene senza riscrivere tutto ossessivamente

- `void *`
- callback
- file
- TDD
- suddivisione `.h` / `.c`
- tipi opachi

## Soglia

```text
Fermarsi dopo la Parte F come preparazione pratica fondamentale.
Le parti successive vanno comprese, ma non serve martellarle tutte.
```

---

# 2. Array, stringhe e memoria dinamica

## Soglia principale

```text
Esercizi 1–23
```

## Devi saper fare bene

- scansioni lineari;
- conteggi e filtri;
- compattazione in place;
- uso di due indici `read` / `write`;
- inversioni;
- rotazioni;
- merge di array ordinati;
- intersezione;
- costruzione di nuovi array;
- costruzione di nuove stringhe;
- calcolo preventivo della dimensione dell’output;
- `malloc`;
- terminatore `'\0'`;
- sostituzioni;
- split;
- join;
- gestione corretta dell’ownership.

## Facoltativi

```text
Esercizi 24–28
```

Utili per:

- `realloc`;
- capacità dinamica;
- vettori dinamici;
- inserimento di slice;
- matrici dinamiche.

## Da rimandare

```text
Esercizi 29+
```

Sono più algoritmici o strutturati e hanno priorità inferiore.

---

# 3. Liste linkate

## Soglia principale

```text
Esercizi 1–27
```

## Devi saper fare bene

- lunghezza;
- ricerca;
- conteggio;
- clone;
- inserimento in testa;
- inserimento in fondo;
- inserimento ordinato;
- cancellazione della prima occorrenza;
- cancellazione di tutte le occorrenze;
- distruzione;
- inversione iterativa;
- inversione ricorsiva;
- rotazione;
- partizione stabile;
- confronto parallelo tra due liste;
- merge;
- merge riutilizzando i nodi;
- alternanza di due liste;
- trasferimento di nodi senza nuova allocazione;
- rimozione in base alla posizione;
- intersezione ordinata senza duplicati;
- uso corretto di `IntList *lsPtr`;
- uso del puntatore a puntatore;
- aggiornamento della testa;
- salvataggio del nodo successivo prima di un `free`.

## Punto di arresto consigliato

```text
Dopo l’esercizio 27.
```

## Da rimandare

```text
Esercizi 28+
```

Comprendono problemi più infidi, come:

- palindromo con ripristino;
- nodi con maggiore a destra;
- reorder;
- merge sort;
- rilevamento di cicli;
- problemi basati sull’identità dei nodi.

---

# 4. Alberi binari e BST

## Alberi binari generici

### Soglia

```text
Esercizi 1–29
```

### Devi saper fare bene

- numero di nodi;
- numero di foglie;
- numero di nodi interni;
- somma;
- minimo e massimo;
- altezza;
- ricerca;
- clone;
- distruzione;
- uguaglianza;
- mirror;
- conteggio a profondità fissata;
- conteggio tra due profondità;
- preorder;
- inorder;
- postorder;
- visita per livelli;
- somme o conteggi basati sul rapporto padre-figlio;
- cammini;
- path sum;
- proprietà strutturali locali;
- ricorsione su sottoalbero sinistro e destro.

## BST

### Soglia

```text
Fino all’esercizio 37
```

### Devi saper fare bene

- ricerca;
- minimo;
- massimo;
- inserimento;
- inserimento tramite puntatore alla radice;
- `floor`;
- `ceil`;
- rimozione di:
  - foglia;
  - nodo con un figlio;
  - nodo con due figli;
  - radice.

## Facoltativi

```text
Esercizi 38–44
```

Utili per:

- validazione globale del BST;
- `kthSmallest`;
- range sum;
- LCA;
- proprietà più complesse.

## Da rimandare

```text
Esercizi 49+
```

Comprendono problemi avanzati come:

- diametro;
- maximum path sum;
- ricostruzione;
- largest BST subtree;
- recupero di BST corrotto.

---

# 5. Ricorsione generale

## Soglia principale

```text
Esercizi 1–26
```

## Devi saper fare bene

- riconoscere il caso base;
- definire il problema più piccolo;
- capire cosa restituisce la chiamata ricorsiva;
- combinare il risultato;
- fattoriale;
- potenza;
- MCD;
- operazioni sulle cifre;
- somma di array;
- massimo di array;
- ricerca;
- palindromo;
- inversione;
- scansione ricorsiva di stringhe;
- filtri ricorsivi;
- costruzione ricorsiva di output;
- rimozione ricorsiva di caratteri;
- uso corretto degli indici.

## Facoltativi

```text
Esercizi 27–32
```

Comprendono:

- `strstr` ricorsiva;
- RLE;
- binary search;
- divide et impera;
- merge sort.

## Da rimandare

```text
Esercizi 35+
```

Comprendono:

- backtracking;
- subset sum;
- permutazioni;
- labirinti;
- memoizzazione;
- edit distance.

---

# 6. ADT generici, `void *` e puntatori a funzione

## Da saper scrivere

```text
Esercizi 1–19
```

## Devi saper fare bene

- dichiarare un puntatore a funzione;
- passare una funzione come parametro;
- restituire una funzione;
- predicati;
- comparatori;
- callback;
- `void *`;
- cast corretti;
- aritmetica tramite `unsigned char *`;
- swap generico;
- ricerca generica;
- uso di `qsort`;
- uso di `bsearch`;
- contratto del comparatore;
- differenza tra valore puntato e indirizzo;
- perdita del type checking con `void *`.

## Da comprendere bene

```text
Esercizi 20–28
```

Concetti principali:

- ADT opaco;
- interfaccia `.h`;
- implementazione `.c`;
- clone;
- destroy;
- shallow copy;
- deep copy;
- borrowed ownership;
- owned ownership;
- transferred ownership;
- failure atomicity.

## Punto di arresto consigliato

```text
Non serve completare sistematicamente gli esercizi 29+.
```

## Da rimandare

- liste generiche complete;
- stack generici completi;
- code generiche complete;
- set generici completi;
- priority queue generiche complete.

---

# 7. File in C

## Soglia principale

```text
Esercizi 1–16
```

## Devi saper fare bene

- `FILE *`;
- `fopen`;
- modalità `"r"`, `"w"`, `"a"` e varianti;
- controllo dell’apertura;
- `fclose`;
- lettura per carattere;
- lettura per riga;
- copia di file;
- conteggio di caratteri, righe o parole;
- trasformazioni in streaming;
- distinzione tra EOF ed errore;
- gestione di tutte le risorse;
- singolo punto di cleanup;
- lettura dinamica di una riga.

## Se resta tempo

```text
Esercizi 19–23
```

Utili per:

- somma di numeri letti da file;
- caricamento in array dinamico;
- statistiche in streaming;
- parsing di record;
- validazione di input.

## Da rimandare

- aggiornamenti complessi con file temporaneo;
- file binari avanzati;
- header;
- magic number;
- accesso casuale;
- serializzazione complessa di liste e alberi.

---

# 8. Esercizi misti e simulazioni

## Soglia principale

```text
Esercizi 1–16
```

## Poi svolgere

```text
Simulazioni 1–2 a tempo
```

## Obiettivo

Verificare la capacità di combinare:

- stringhe;
- memoria dinamica;
- liste;
- alberi;
- file;
- ownership;
- cleanup;
- casi limite.

## Seconda battuta

```text
Esercizi 17–24
```

Solo dopo aver raggiunto le soglie degli altri file.

## Da rimandare

```text
Esercizi 25+
```

Sono esercizi da sovrapreparazione e non devono rallentare il consolidamento dei pattern più probabili.

---

# 9. Teoria e quiz

## Soglia

```text
Tutto il file.
```

## Devi saper distinguere

- codice che non compila;
- codice che compila;
- codice formalmente valido ma pericoloso;
- undefined behavior;
- possibile segmentation fault;
- possibile non terminazione;
- risultato determinato;
- risultato dipendente dall’input o dallo stato della memoria.

## Argomenti prioritari

- espansione dei `typedef`;
- conteggio dei livelli di puntatore;
- `.` e `->`;
- `&` e `*`;
- struct;
- union;
- enum;
- array;
- stringhe;
- compatibilità dei parametri;
- `malloc`;
- `sizeof`;
- `void *`;
- puntatori a funzione;
- output dei cicli;
- terminazione;
- ricorsione;
- accessi fuori limite;
- `NULL`;
- variabili non inizializzate;
- memoria liberata;
- shallow copy e deep copy.

---

# Regola antisperco

## Tempi massimi consigliati

```text
15 minuti:
devi aver individuato il pattern e le variabili principali.

30–40 minuti:
devi avere una prima soluzione completa o quasi completa.

50–60 minuti:
interrompi il tentativo.
```

## Se resti bloccato

1. Scrivi l’algoritmo in italiano.
2. Individua input, output e strutture modificate.
3. Segna i casi limite.
4. Guarda soltanto l’idea generale della soluzione.
5. Chiudi la soluzione.
6. Riprova da zero il giorno successivo.

## Non fare

```text
Restare due ore sullo stesso esercizio avanzato
mentre non sono ancora automatici i pattern fondamentali.
```

---

# Ordine di priorità

```text
1. Array, stringhe e malloc
2. Liste linkate
3. Alberi binari
4. BST
5. Ricorsione
6. Quiz teorici
7. ADT, void* e callback
8. File
9. Simulazioni miste
10. Esercizi hardcore
```

---

# Criterio per considerare raggiunta una soglia

Una sezione è preparata bene quando:

- risolvi autonomamente almeno 8 esercizi su 10;
- non guardi la soluzione prima di aver tentato;
- sai spiegare il pattern usato;
- gestisci `NULL`, struttura vuota e caso singolo;
- non produci leak o use-after-free;
- sai indicare la complessità;
- completi gli esercizi normali in circa 30–40 minuti;
- riconosci gli esercizi troppo avanzati e li rimandi senza perdere ore.

---

# Riassunto finale

```text
DA FARE BENE
- Allenamento generale A–F
- Array/stringhe 1–23
- Liste 1–27
- Alberi generici 1–29
- BST fino a 37
- Ricorsione 1–26
- Generici/void* 1–19
- File 1–16
- Misti 1–16
- Simulazioni 1–2
- Teoria tutta

DA COMPRENDERE O FARE SE AVANZA TEMPO
- Array 24–28
- Alberi/BST 38–44
- Ricorsione 27–32
- Generici/ADT 20–28
- File 19–23
- Misti 17–24

DA RIMANDARE
- Array 29+
- Liste 28+
- Alberi 49+
- Ricorsione 35+
- Generici 29+
- File binari avanzati
- Misti 25+
```
