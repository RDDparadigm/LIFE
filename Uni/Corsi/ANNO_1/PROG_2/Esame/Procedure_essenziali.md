# Programmazione 2 — Procedure essenziali in C

> Promemoria operativo: **che cosa fare e in quale ordine**.  
> Convenzione: `NULL` indica assenza di un oggetto, nodo o puntatore valido.

---

# 0. Metodo universale per affrontare un esercizio

## Prima di scrivere codice

1. Individua:
   1. Input.
   2. Output.
   3. Casi di errore.
   4. Struttura dati coinvolta.
   5. Chi possiede la memoria.
2. Scrivi l'invariante della struttura:
   1. Cosa deve essere sempre vero.
   2. Quali puntatori possono valere `NULL`.
   3. Quali campi devono essere aggiornati insieme.
3. Tratta subito i casi limite:
   1. Struttura vuota.
   2. Un solo elemento.
   3. Elemento in testa o radice.
   4. Elemento in coda o foglia.
   5. Elemento assente.
   6. Fallimento di `malloc` o `realloc`.
4. Solo dopo implementa il caso generale.
5. Testa nell'ordine:
   1. Caso vuoto.
   2. Caso minimo.
   3. Caso normale.
   4. Caso estremo.
   5. Operazioni ripetute.

## Quando manipolo puntatori

1. Salva prima ciò che rischi di perdere.
2. Collega il nuovo oggetto al resto della struttura.
3. Modifica il puntatore della struttura principale.
4. Libera memoria solo quando nessun collegamento utile dipende più dall'oggetto.
5. Dopo `free`, non dereferenziare più quel puntatore.

---

# 1. Variabili, indirizzi e puntatori

## Leggere una variabile

1. Ricorda le quattro proprietà:
   1. Tipo.
   2. Nome.
   3. Indirizzo.
   4. Valore.
5. A sinistra di = una variabile rappresenta dove scrivere.
6. A destra di = rappresenta il valore da leggere.

## Ottenere e usare un indirizzo

1. `&x` restituisce l'indirizzo di `x`.
2. `*p` accede all'oggetto puntato da `p`.
3. Prima di usare `*p`, verifica che `p != NULL`.
4. Per modificare una variabile del chiamante:
   1. Passa il suo indirizzo.
   2. Dereferenzia il parametro nella funzione.

## Puntatore a puntatore

1. Usalo quando la funzione deve modificare il puntatore del chiamante.
2. Il parametro riceve l'indirizzo del puntatore.
3. `*pp` è il puntatore del chiamante.
4. `**pp` è l'oggetto puntato dal puntatore del chiamante.

## Accesso ai campi di una `struct`

1. Se hai una variabile `s`, usa `s.campo`.
2. Se hai un puntatore `p`, usa `p->campo`.
3. `p->campo` equivale a `(*p).campo`.

## Usare `const`

1. `const T *p`:
   1. Puoi cambiare `p`.
   2. Non puoi modificare `*p` attraverso `p`.
2. `T *const p`:
   1. Non puoi cambiare `p`.
   2. Puoi modificare `*p`.
3. `const T *const p`:
   1. Non puoi cambiare né `p` né `*p`.
4. Dai a una funzione solo i privilegi necessari.

## Endianness

1. Riguarda l'ordine dei byte di un valore multibyte in memoria.
2. Little endian: byte meno significativo all'indirizzo più basso.
3. Big endian: byte più significativo all'indirizzo più basso.
4. Non dedurre il valore numerico osservando un solo byte senza conoscere l'endianness.

---

# 2. `struct`, `typedef`, `enum`, `union`

## Definire una `struct`

1. Elenca i campi correlati.
2. Assegna a ogni campo il tipo corretto.
3. Considera che il compilatore può inserire padding.
4. Usa `sizeof(struct ...)`, non la somma manuale delle dimensioni dei campi.

## Passare una `struct` a una funzione

1. Per sola lettura e strutture piccole:
   1. Puoi passare per valore.
2. Per evitare copie:
   1. Passa un puntatore `const`.
3. Per modificarla:
   1. Passa un puntatore non `const`.
4. Per sostituire anche il puntatore alla struttura:
   1. Passa un puntatore a puntatore.

## Usare `typedef`

1. Usa `typedef` per dare un nome leggibile a un tipo.
2. Non crea un tipo con rappresentazione diversa: crea un alias.
3. Mantieni uno stile coerente in tutto il progetto.

## Usare `enum`

1. Elenca stati o categorie finite con nomi significativi.
2. Usa i valori dell'`enum` invece di numeri magici.
3. Usa un `enum` come tag quando il contenuto può avere forme diverse.

## Usare `union`

1. Ricorda che tutti i campi condividono la stessa memoria.
2. In un dato istante considera valido un solo campo.
3. Affianca sempre un tag che indica quale campo è valido.
4. Quando cambi tag:
   1. Inizializza il campo corrispondente.
   2. Non leggere il campo precedente.

## Creare una struttura autoreferenziale

1. La `struct` non può contenere direttamente un'altra istanza completa di se stessa.
2. Può contenere un puntatore allo stesso tipo.
3. Definisci prima il nome della `struct`.
4. Usa poi il puntatore nel campo ricorsivo.

---

# 3. Codice su più file e compilazione

## Separare interfaccia e implementazione

1. Nel file `.h` metti:
   1. Tipi pubblici.
   2. Costanti pubbliche.
   3. Prototipi delle funzioni pubbliche.
2. Nel file `.c` metti:
   1. Implementazioni.
   2. Tipi privati.
   3. Funzioni di supporto `static`.
3. Nel file di test o `main.c` usa solo l'interfaccia pubblica.

## Proteggere un header

1. Apri con una include guard.
2. Definisci il simbolo della guardia.
3. Chiudi con `#endif`.
4. Non inserire definizioni multiple di variabili globali nell'header.

## Compilare un programma multifile

1. Ogni `.c` viene compilato in un file oggetto.
2. Il linker unisce i file oggetto e le librerie.
3. Se manca una definizione, ottieni un errore di linking.
4. Se la dichiarazione è incompatibile, ottieni errori o comportamento indefinito.
5. Compila con warning severi prima di correggere i test.

## Usare `static` ed `extern`

1. Variabile o funzione globale `static`:
   1. È visibile solo nel file corrente.
2. Dichiarazione `extern`:
   1. Comunica che la definizione esiste altrove.
3. Definisci una variabile globale una sola volta.
4. Usa le variabili globali solo quando realmente necessarie.

---

# 4. Test Driven Development

## Ciclo TDD

1. Scrivi un test piccolo che inizialmente fallisce.
2. Implementa il minimo codice per farlo passare.
3. Esegui tutta la suite.
4. Rifattorizza senza cambiare il comportamento.
5. Ripeti con un nuovo caso.

## Costruire una test suite

1. Inserisci casi normali.
2. Inserisci casi limite.
3. Inserisci input non validi previsti dalla specifica.
4. Verifica sia il valore restituito sia gli effetti collaterali.
5. Mantieni i vecchi test come regression test.
6. Ogni test deve essere:
   1. Ripetibile.
   2. Indipendente.
   3. Facile da diagnosticare.

---

# 5. Memoria in C

## Distinguere le aree di memoria

1. Memoria statica:
   1. Variabili globali.
   2. Variabili locali `static`.
   3. Vita pari all'intero programma.
2. Memoria automatica, stack:
   1. Parametri.
   2. Variabili locali non `static`.
   3. Vita pari alla chiamata della funzione.
3. Memoria dinamica, heap:
   1. Allocata esplicitamente.
   2. Rimane valida finché non viene liberata.

## Usare `malloc`

1. Calcola la dimensione con `sizeof`.
2. Preferisci `malloc(sizeof *ptr)`.
3. Controlla subito se il risultato è `NULL`.
4. Inizializza tutti i campi prima di usare l'oggetto.
5. Stabilisci chi dovrà chiamare `free`.

## Usare `calloc`

1. Passa numero di elementi e dimensione di ciascun elemento.
2. Controlla il risultato.
3. Ricorda che azzera i byte, non costruisce oggetti complessi.

## Usare `realloc`

1. Calcola la nuova capacità.
2. Salva il risultato in un puntatore temporaneo.
3. Se il temporaneo è `NULL`:
   1. Il vecchio blocco è ancora valido.
   2. Gestisci l'errore senza perdere il puntatore originale.
4. Se ha successo:
   1. Aggiorna il puntatore principale.
   2. Aggiorna la capacità.
5. Non assumere che l'indirizzo resti uguale.

## Usare `free`

1. Libera ogni blocco dinamico esattamente una volta.
2. Libera prima gli oggetti interni.
3. Libera poi la struttura contenitore.
4. Se il puntatore resta accessibile, impostalo a `NULL`.
5. Non usare il puntatore dopo la `free`.

## Creare un array dinamico

1. Conserva:
   1. Puntatore ai dati.
   2. Numero di elementi usati.
   3. Capacità allocata.
2. Prima di inserire controlla se c'è spazio.
3. Se pieno, aumenta la capacità.
4. Esegui `realloc` in sicurezza.
5. Inserisci il nuovo elemento.
6. Aggiorna la dimensione logica.

## Creare una stringa dinamica

1. Conserva:
   1. `char *content`.
   2. Capacità.
   3. Indice del primo posto libero.
2. Mantieni sempre spazio per `\0`.
3. Prima di concatenare calcola la lunghezza aggiuntiva.
4. Se serve, rialloca.
5. Copia a partire dal primo posto libero.
6. Aggiorna l'indice libero.
7. Scrivi il terminatore finale.

## Evitare errori di memoria

1. Memory leak:
   1. Non perdere l'ultimo puntatore a un blocco allocato.
2. Dangling pointer:
   1. Non lasciare puntatori a memoria già liberata.
3. Double free:
   1. Non liberare due volte lo stesso blocco.
4. Buffer overflow:
   1. Non scrivere oltre la capacità.
5. Use after free:
   1. Non leggere o scrivere dopo `free`.

---

# 6. Moduli, tipi opachi e ADT

## Creare un tipo opaco

1. Nel `.h` dichiara la `struct` senza mostrarne i campi.
2. Esponi un `typedef` a puntatore alla `struct` incompleta.
3. Nel `.c` definisci la `struct` completa.
4. Fornisci funzioni per creare, usare e distruggere l'oggetto.
5. Il client non deve accedere direttamente ai campi.

## Progettare un ADT

1. Definisci il tipo astratto.
2. Definisci le operazioni pubbliche.
3. Specifica per ogni operazione:
   1. Precondizioni.
   2. Risultato.
   3. Effetti collaterali.
   4. Errori.
4. Scegli una rappresentazione privata.
5. Mantieni invarianti coerenti dopo ogni operazione.

## Ridurre l'accoppiamento

1. Esponi solo ciò che il client deve conoscere.
2. Non far dipendere il client dai campi interni.
3. Non duplicare conoscenza della rappresentazione.
4. Modifica l'implementazione senza modificare l'interfaccia quando possibile.

## Aumentare la coesione

1. Raggruppa nello stesso modulo dati e funzioni strettamente correlati.
2. Mantieni ogni funzione focalizzata su un compito.
3. Sposta le funzioni di supporto nel modulo che usa la rappresentazione.

## Scegliere tra passaggio per valore e per puntatore

1. Per oggetti piccoli e immutabili:
   1. Il valore può essere semplice.
2. Per oggetti grandi:
   1. Usa un puntatore `const` per leggere.
3. Per modificare l'oggetto:
   1. Usa un puntatore.
4. Per sostituire l'oggetto opaco del chiamante:
   1. Usa puntatore a puntatore oppure restituisci il nuovo valore.

---

# 7. Puntatori a funzione

## Dichiarare un puntatore a funzione

1. Parti dalla firma della funzione.
2. Sostituisci il nome con `(*nomePuntatore)`.
3. Mantieni identici tipo di ritorno e tipi dei parametri.
4. Assegna solo funzioni con firma compatibile.

## Usare una callback

1. La funzione generica riceve il puntatore alla funzione.
2. Durante l'algoritmo invoca la callback sui dati.
3. La callback decide il comportamento variabile:
   1. Confronto.
   2. Predicato.
   3. Stampa.
   4. Distruzione.
4. Documenta il significato del valore restituito dalla callback.

## Memorizzare una funzione dentro una struttura

1. Inserisci il puntatore a funzione tra i campi.
2. Inizializzalo nel costruttore.
3. Usalo in tutte le operazioni che richiedono quel comportamento.
4. Evita di passarlo di nuovo a ogni chiamata.

---

# 8. `void *` e strutture generiche

## Usare `void *`

1. Usalo per conservare indirizzi di oggetti di tipi diversi.
2. Non dereferenziarlo direttamente.
3. Convertilo al tipo corretto prima dell'accesso.
4. Ricorda che perdi il controllo statico sul tipo effettivo.

## Progettare un ADT generico

1. Memorizza gli elementi come `void *`.
2. Ricevi callback quando servono operazioni dipendenti dal tipo:
   1. Confronto.
   2. Copia.
   3. Distruzione.
   4. Stampa.
3. Definisci chiaramente l'ownership:
   1. L'ADT possiede gli elementi.
   2. Oppure conserva soltanto i puntatori.
4. Non liberare automaticamente elementi che non appartengono all'ADT.

## Gestire dati eterogenei

1. Aggiungi un tag che identifichi il tipo concreto.
2. Conserva il dato in una `union` o tramite `void *`.
3. Prima di usare il contenuto controlla il tag.
4. Applica l'operazione corretta per quel tipo.

---

# 9. Liste linkate

## Rappresentare una lista

1. Ogni nodo contiene:
   1. Dato.
   2. Puntatore al nodo successivo.
2. La lista è il puntatore al primo nodo.
3. Lista vuota: puntatore uguale a `NULL`.
4. Ultimo nodo: `next == NULL`.

## Visitare tutti i nodi

1. Parti dalla testa.
2. Continua finché il nodo corrente è diverso da `NULL`.
3. Elabora il nodo corrente.
4. Avanza con `current = current->next`.
5. Non usare `current->next` prima di verificare `current != NULL`.

## Cercare un elemento

1. Parti dalla testa.
2. Per ogni nodo confronta il dato.
3. Se corrisponde, restituisci subito il risultato.
4. Altrimenti avanza.
5. Se raggiungi `NULL`, l'elemento non è presente.

## Calcolare la lunghezza

1. Inizializza il contatore a zero.
2. Visita ogni nodo esistente.
3. Incrementa una volta per nodo.
4. Restituisci il contatore.

## Inserire in testa

1. Alloca il nuovo nodo.
2. Inizializza il dato.
3. Il `next` del nuovo nodo punta alla vecchia testa.
4. La testa della lista punta al nuovo nodo.

## Inserire in coda

1. Alloca e inizializza il nuovo nodo con `next = NULL`.
2. Se la lista è vuota:
   1. La testa diventa il nuovo nodo.
3. Altrimenti:
   1. Raggiungi l'ultimo nodo.
   2. Il suo `next` punta al nuovo nodo.
4. Se possiedi un puntatore `tail`, aggiornalo direttamente.

## Inserire dopo un nodo dato

1. Verifica che il nodo posizione esista.
2. Alloca il nuovo nodo.
3. Il `next` del nuovo nodo punta al vecchio successore della posizione.
4. Il `next` della posizione punta al nuovo nodo.

## Inserire prima di un nodo dato

1. Gestisci il caso in cui il nodo sia la testa.
2. Altrimenti trova il predecessore.
3. Il `next` del nuovo nodo punta al nodo posizione.
4. Il `next` del predecessore punta al nuovo nodo.
5. Variante robusta:
   1. Scorri con un puntatore al collegamento, cioè un puntatore a puntatore.
   2. Inserisci modificando direttamente quel collegamento.

## Inserire in una lista ordinata

1. Individua il primo collegamento il cui elemento non deve precedere il nuovo valore.
2. Alloca il nuovo nodo.
3. Il nuovo nodo punta al nodo trovato.
4. Il collegamento precedente punta al nuovo nodo.
5. Mantieni la stessa regola per i duplicati in tutto il programma.

## Eliminare la testa

1. Se la lista è vuota, non fare nulla o segnala l'errore.
2. Salva la vecchia testa in un temporaneo.
3. Sposta la testa sul nodo successivo.
4. Libera il vecchio nodo.

## Eliminare la prima occorrenza

1. Cerca il collegamento che punta al nodo da eliminare.
2. Se non esiste, restituisci “non trovato”.
3. Salva il nodo da eliminare.
4. Fai puntare il collegamento al successore del nodo.
5. Libera il nodo eliminato.
6. Se l'ADT possiede il dato, libera anche il dato secondo la politica stabilita.

## Eliminare la coda

1. Se la lista è vuota, termina.
2. Se ha un solo nodo:
   1. Libera il nodo.
   2. Imposta la testa a `NULL`.
3. Altrimenti raggiungi il penultimo nodo.
4. Salva e libera l'ultimo nodo.
5. Imposta `penultimo->next = NULL`.

## Distruggere l'intera lista

1. Finché la testa non è `NULL`:
   1. Salva la testa corrente.
   2. Avanza la testa.
   3. Libera il nodo salvato.
2. Se i dati sono posseduti dalla lista, liberali prima del nodo.
3. Alla fine la testa deve valere `NULL`.

## Modificare una lista dal chiamante

1. Soluzione con ritorno:
   1. La funzione restituisce la nuova testa.
   2. Il chiamante deve riassegnarla.
2. Soluzione per riferimento:
   1. Passa l'indirizzo della testa.
   2. Modifica `*listPtr` nella funzione.
3. Soluzione con contenitore:
   1. Incapsula `first`, eventuale `last` e `size` in una `struct`.
   2. Passa il puntatore alla struttura.

## Errori tipici nelle liste

1. Usare `current->next` quando `current == NULL`.
2. Fermarsi a `current->next == NULL` quando serve visitare anche l'ultimo nodo.
3. Sovrascrivere un collegamento prima di salvarne il valore.
4. Dimenticare il caso della testa.
5. Liberare un nodo prima di leggere il suo `next`.
6. Perdere la testa originale durante la visita.
7. Non aggiornare `tail` o `size` dopo una modifica.

---

# 10. Ricorsione

## Progettare una funzione ricorsiva

1. Definisci il caso base.
2. Assicurati che il caso base non richiami la funzione.
3. Definisci il problema più piccolo.
4. Fai una chiamata ricorsiva sul problema più piccolo.
5. Combina il risultato ricorsivo con il lavoro locale.
6. Dimostra che ogni chiamata compie progresso verso il caso base.

## Capire lo stack di esecuzione

1. Ogni chiamata crea un record di attivazione.
2. Il record conserva parametri, variabili locali e punto di ritorno.
3. Le chiamate si accumulano fino al caso base.
4. I risultati vengono poi restituiti in ordine inverso.
5. Una profondità eccessiva può causare stack overflow.

## Ricorsione di testa

1. Esegui la chiamata ricorsiva.
2. Dopo il ritorno svolgi ancora lavoro.
3. Lo stack deve conservare il lavoro sospeso.

## Ricorsione di coda

1. Porta il risultato parziale in un accumulatore.
2. Esegui la chiamata ricorsiva come ultima operazione.
3. Non svolgere altro lavoro dopo il ritorno.
4. Non assumere che il compilatore C ottimizzi sempre la tail recursion.

## Ricorsione su una lista

1. Caso base: lista vuota.
2. Caso ricorsivo:
   1. Elabora la testa.
   2. Richiama la funzione sulla coda `list->next`.
3. Per elaborare in ordine inverso:
   1. Richiama prima sulla coda.
   2. Elabora la testa dopo il ritorno.

## Modificare ricorsivamente una lista

1. Il risultato della chiamata sulla sottolista può essere una nuova testa.
2. Ricollega sempre il risultato al nodo corrente.
3. Restituisci la nuova testa della lista risultante.
4. Nei casi di eliminazione, libera il nodo escluso prima di restituire il successore.

## Evitare ricorsione inefficiente

1. Non ricalcolare più volte lo stesso sottoproblema.
2. La Fibonacci ricorsiva ingenua genera molte chiamate duplicate.
3. Usa iterazione, memoizzazione o programmazione dinamica quando i sottoproblemi si ripetono.

---

# 11. ADT Pila — Stack

## Semantica

1. Politica LIFO: ultimo inserito, primo estratto.
2. Operazioni essenziali:
   1. Creazione.
   2. Distruzione.
   3. `push`.
   4. `pop`.
   5. `top` o `peek`.
   6. `isEmpty`.
   7. Eventuale `size`.

## `push` con lista linkata

1. Alloca il nuovo nodo.
2. Salva il dato.
3. Il nuovo nodo punta al vecchio `top`.
4. `top` punta al nuovo nodo.
5. Incrementa `size`.

## `pop` con lista linkata

1. Verifica che la pila non sia vuota.
2. Salva il nodo `top`.
3. Salva il valore da restituire.
4. Sposta `top` sul nodo successivo.
5. Libera il vecchio nodo.
6. Decrementa `size`.
7. Restituisci il valore o segnala l'esito tramite parametro.

## Pila con array dinamico

1. Conserva array, dimensione e capacità.
2. `push`:
   1. Se pieno, aumenta la capacità.
   2. Scrivi in posizione `size`.
   3. Incrementa `size`.
3. `pop`:
   1. Verifica che non sia vuoto.
   2. Decrementa `size`.
   3. Leggi l'elemento ora in cima.
4. Ridimensiona verso il basso solo se previsto e senza oscillazioni continue.

## Distruggere una pila opaca

1. Ricevi il puntatore all'handle se vuoi azzerarlo nel chiamante.
2. Libera tutti gli elementi interni.
3. Libera la struttura della pila.
4. Imposta l'handle del chiamante a `NULL`.

---

# 12. ADT Coda — Queue

## Semantica

1. Politica FIFO: primo inserito, primo estratto.
2. Operazioni essenziali:
   1. `enqueue` in fondo.
   2. `dequeue` dalla testa.
   3. `peek` della testa.
   4. `isEmpty`.

## Coda con lista linkata

1. Mantieni `front` e `rear`.
2. Coda vuota:
   1. `front == NULL`.
   2. `rear == NULL`.
3. Mantieni entrambi coerenti dopo ogni operazione.

## `enqueue` con lista linkata

1. Alloca il nuovo nodo con `next = NULL`.
2. Se la coda è vuota:
   1. `front` e `rear` puntano al nuovo nodo.
3. Altrimenti:
   1. `rear->next` punta al nuovo nodo.
   2. `rear` diventa il nuovo nodo.
4. Incrementa `size`.

## `dequeue` con lista linkata

1. Verifica che la coda non sia vuota.
2. Salva il nodo `front` e il suo valore.
3. Sposta `front` sul successore.
4. Se `front` diventa `NULL`, imposta anche `rear = NULL`.
5. Libera il vecchio nodo.
6. Decrementa `size`.
7. Restituisci il valore o l'esito previsto.

## Coda circolare con array

1. Conserva:
   1. Array.
   2. Capacità.
   3. Indice della testa.
   4. Numero di elementi.
2. Calcola una posizione con il modulo della capacità.
3. La posizione di inserimento è `(front + size) % capacity`.
4. `dequeue`:
   1. Leggi `array[front]`.
   2. Aggiorna `front = (front + 1) % capacity`.
   3. Decrementa `size`.
5. Se ridimensioni:
   1. Copia gli elementi in ordine logico.
   2. Reimposta `front = 0`.

---

# 13. ADT Insieme — Set

## Invariante di un insieme

1. Gli elementi non hanno duplicati.
2. L'ordine non fa parte del significato dell'insieme, salvo sorted set.
3. Deve esistere una regola per stabilire l'uguaglianza.

## Inserire in un insieme non ordinato

1. Verifica se l'elemento è già presente.
2. Se presente, non modificare l'insieme.
3. Se assente, inseriscilo.
4. Aggiorna `size` solo in caso di inserimento effettivo.

## Inserire in un insieme ordinato

1. Scorri finché gli elementi precedono quello nuovo.
2. Se trovi un elemento uguale, non inserire.
3. Altrimenti inserisci nel punto trovato.
4. Mantieni contemporaneamente ordine e assenza di duplicati.

## Intersezione non ottimizzata

1. Visita ogni elemento del primo insieme.
2. Verifica l'appartenenza nel secondo.
3. Se presente, aggiungilo al risultato.
4. Con liste non ordinate può richiedere fino a `M × N` confronti.

## Intersezione di insiemi ordinati

1. Mantieni un cursore per ogni insieme.
2. Finché nessuno dei due è terminato:
   1. Se i valori sono uguali, inserisci e avanza entrambi.
   2. Se il primo è minore, avanza il primo.
   3. Altrimenti avanza il secondo.
3. Il lavoro è proporzionale a `M + N`.

## Unione di insiemi ordinati

1. Confronta i due elementi correnti.
2. Inserisci il minore e avanza il relativo cursore.
3. Se sono uguali, inseriscine uno e avanza entrambi.
4. Quando una lista termina, copia il resto dell'altra.

## Differenza `A - B` ordinata

1. Confronta gli elementi correnti.
2. Se sono uguali, scartali da `A` e avanza entrambi.
3. Se `A` è minore, inseriscilo nel risultato e avanza `A`.
4. Se `B` è minore, avanza `B`.
5. Alla fine copia gli elementi rimasti in `A`.

---

# 14. Alberi binari

## Rappresentare un nodo

1. Ogni nodo contiene:
   1. Dato.
   2. Figlio sinistro.
   3. Figlio destro.
2. Albero vuoto: radice `NULL`.
3. Foglia: entrambi i figli `NULL`.
4. L'albero è una struttura ricorsiva.

## Progettare un algoritmo ricorsivo su un albero

1. Caso base: albero vuoto.
2. Risolvi ricorsivamente il sottoalbero sinistro.
3. Risolvi ricorsivamente il sottoalbero destro.
4. Combina i risultati con il dato della radice.
5. La posizione del lavoro sulla radice determina il tipo di visita.

## Visita pre-order

1. Elabora la radice.
2. Visita il sottoalbero sinistro.
3. Visita il sottoalbero destro.

## Visita in-order

1. Visita il sottoalbero sinistro.
2. Elabora la radice.
3. Visita il sottoalbero destro.
4. In un BST produce gli elementi in ordine.

## Visita post-order

1. Visita il sottoalbero sinistro.
2. Visita il sottoalbero destro.
3. Elabora la radice.
4. È adatta alla distruzione dell'albero.

## Visita depth-first iterativa

1. Usa una pila esplicita.
2. Inserisci la radice se esiste.
3. Finché la pila non è vuota:
   1. Estrai un nodo.
   2. Elaboralo.
   3. Inserisci i figli nell'ordine necessario alla visita desiderata.

## Visita breadth-first

1. Usa una coda.
2. Inserisci la radice se esiste.
3. Finché la coda non è vuota:
   1. Estrai il nodo in testa.
   2. Elaboralo.
   3. Accoda il figlio sinistro se esiste.
   4. Accoda il figlio destro se esiste.

## Calcolare la dimensione

1. Albero vuoto: dimensione zero.
2. Albero non vuoto:
   1. Uno per la radice.
   2. Più dimensione del sottoalbero sinistro.
   3. Più dimensione del sottoalbero destro.

## Calcolare l'altezza

1. Stabilisci la convenzione per l'albero vuoto.
2. Calcola ricorsivamente le altezze dei figli.
3. Prendi il massimo.
4. Aggiungi uno per la radice secondo la convenzione scelta.
5. Non mescolare altezza in nodi e altezza in archi.

## Distruggere un albero

1. Distruggi il sottoalbero sinistro.
2. Distruggi il sottoalbero destro.
3. Libera il dato se posseduto.
4. Libera il nodo corrente.
5. Azzera la radice del chiamante quando necessario.

## Albero n-ario con rappresentazione binaria

1. Usa un collegamento al primo figlio.
2. Usa un collegamento al fratello successivo.
3. Il figlio sinistro rappresenta il primo figlio.
4. Il figlio destro rappresenta il fratello successivo.

---

# 15. Alberi di ricerca binari — BST/ARB

## Invariante del BST

1. Tutti gli elementi del sottoalbero sinistro rispettano la relazione “minori”.
2. Tutti gli elementi del sottoalbero destro rispettano la relazione “maggiori”.
3. Definisci esplicitamente dove vanno eventuali duplicati.
4. Ogni operazione deve preservare questa proprietà.

## Cercare un elemento

1. Parti dalla radice.
2. Se il nodo è `NULL`, l'elemento è assente.
3. Se il valore è uguale, hai trovato l'elemento.
4. Se è minore, continua a sinistra.
5. Se è maggiore, continua a destra.

## Trovare il minimo

1. Verifica che l'albero non sia vuoto.
2. Parti dalla radice.
3. Continua sul figlio sinistro finché esiste.
4. L'ultimo nodo raggiunto contiene il minimo.

## Inserire un elemento iterativamente

1. Scorri conservando il collegamento da modificare.
2. Se trovi un valore uguale, applica la politica sui duplicati.
3. Quando il collegamento vale `NULL`, hai trovato la posizione.
4. Alloca e inizializza il nuovo nodo.
5. Assegna il nuovo nodo al collegamento trovato.

## Inserire un elemento ricorsivamente

1. Caso base: sottoalbero vuoto.
   1. Alloca il nodo.
   2. Restituiscilo come nuova radice del sottoalbero.
2. Se il valore è minore:
   1. Inserisci nel figlio sinistro.
   2. Riassegna il risultato a `left`.
3. Se è maggiore:
   1. Inserisci nel figlio destro.
   2. Riassegna il risultato a `right`.
4. Restituisci la radice corrente.

## Estrarre il minimo

1. Se la radice non ha figlio sinistro:
   1. Essa è il minimo.
   2. Salva il suo figlio destro.
   3. Estrai il dato o il nodo.
   4. Sostituisci il sottoalbero con il figlio destro.
2. Altrimenti continua nel sottoalbero sinistro.
3. Ricollega sempre la nuova radice del sottoalbero sinistro.

## Eliminare un nodo da un BST

1. Cerca il nodo da eliminare.
2. Se non esiste, non modificare l'albero.
3. Caso zero figli:
   1. Libera il nodo.
   2. Sostituiscilo con `NULL`.
4. Caso un figlio:
   1. Salva il figlio esistente.
   2. Libera il nodo.
   3. Sostituiscilo con il figlio.
5. Caso due figli:
   1. Estrai il minimo dal sottoalbero destro oppure il massimo dal sinistro.
   2. Copia o trasferisci il valore nel nodo da eliminare.
   3. Mantieni collegati entrambi i sottoalberi.

## Valutare l'efficienza di un BST

1. Il costo dipende dall'altezza `h`.
2. Ricerca, inserimento ed eliminazione costano `O(h)`.
3. Albero bilanciato: `h` è logaritmica.
4. Albero degenere: `h` è lineare.
5. Un BST non si bilancia automaticamente, salvo strutture specifiche.

---

# 16. File

## Usare una risorsa file

1. Acquisizione: apri il file.
2. Uso: leggi o scrivi.
3. Rilascio: chiudi il file.
4. Gestisci gli errori in ogni fase.

## Aprire un file

1. Scegli la modalità corretta:
   1. `"r"` per leggere un file esistente.
   2. `"w"` per creare o sovrascrivere.
   3. `"a"` per aggiungere in fondo, se previsto.
2. Chiama `fopen`.
3. Controlla che il `FILE *` non sia `NULL`.
4. Non usare il file se l'apertura fallisce.

## Scrivere dati formattati

1. Apri il file in modalità di scrittura.
2. Usa `fprintf` con formato coerente ai dati.
3. Controlla il valore restituito se la specifica richiede la gestione degli errori.
4. Chiudi il file.

## Leggere dati formattati

1. Apri il file in lettura.
2. Usa il risultato di `fscanf` come condizione del ciclo.
3. Elabora il dato solo se la conversione è riuscita.
4. Distingui fine file da dato malformato quando necessario.
5. Chiudi il file.

## Evitare l'errore con `feof`

1. Non usare `while (!feof(file))` per guidare la lettura.
2. `feof` diventa vero solo dopo un tentativo di lettura fallito per fine file.
3. Guida il ciclo con il valore restituito dalla funzione di lettura.

## Usare gli stream standard

1. `stdin`: input standard.
2. `stdout`: output standard.
3. `stderr`: messaggi di errore.
4. Non chiuderli normalmente nel codice applicativo semplice.

---

# 17. Correttezza dei programmi e cicli

## Specificare una funzione

1. Scrivi la precondizione:
   1. Cosa deve essere vero all'ingresso.
2. Scrivi la postcondizione:
   1. Cosa deve essere vero all'uscita.
3. Indica gli effetti collaterali ammessi.
4. Indica il comportamento sugli input non validi.

## Dimostrare la correttezza

1. Correttezza parziale:
   1. Se il programma termina, il risultato soddisfa la postcondizione.
2. Terminazione:
   1. Il programma termina per tutti gli input ammessi.
3. Correttezza totale:
   1. Correttezza parziale più terminazione.

## Progettare un ciclo con un invariante

1. Scegli una proprietà vera prima di ogni iterazione.
2. Inizializzazione:
   1. Rendila vera prima del ciclo.
3. Conservazione:
   1. Mostra che il corpo la mantiene vera.
4. Uscita:
   1. Combina invariante e negazione della guardia.
   2. Ottieni la postcondizione.
5. Terminazione:
   1. Individua una quantità non negativa.
   2. Falla diminuire a ogni iterazione.

## Progettare un ciclo su un array

1. Decidi quale porzione è già stata elaborata.
2. Esprimi il risultato parziale su quella porzione.
3. Inizializza sulla porzione minima.
4. A ogni iterazione incorpora un nuovo elemento.
5. Aggiorna l'indice senza saltare o ripetere elementi.
6. All'uscita la porzione elaborata deve coincidere con quella richiesta.

## Scegliere tra `for` e `while`

1. Usa `for` quando inizializzazione, guardia e avanzamento formano un'unica scansione.
2. Usa `while` quando il numero di iterazioni dipende da una condizione strutturale.
3. Sono spesso equivalenti se:
   1. Inizializzazione avviene prima.
   2. Guardia è identica.
   3. Avanzamento avviene una volta per iterazione.
4. Verifica sempre che il ciclo gestisca correttamente zero iterazioni.

---

# 18. Complessità computazionale

## Analizzare il tempo

1. Definisci la dimensione dell'input `n`.
2. Individua le operazioni elementari dominanti.
3. Conta quante volte vengono eseguite.
4. Considera separatamente caso migliore e peggiore quando differiscono.
5. Elimina costanti moltiplicative e termini di ordine inferiore per l'andamento asintotico.

## Analizzare lo spazio

1. Conta la memoria aggiuntiva rispetto all'input.
2. Includi:
   1. Strutture allocate dinamicamente.
   2. Pile e code di supporto.
   3. Record di attivazione ricorsivi.
3. Una ricorsione profonda `h` usa normalmente `O(h)` spazio di stack.

## Combinare costi

1. Blocchi consecutivi:
   1. Somma i costi.
   2. Mantieni il termine dominante.
2. Cicli annidati dipendenti:
   1. Conta realmente le iterazioni interne.
3. Cicli annidati indipendenti di lunghezza `n`:
   1. Tipicamente `O(n²)`.
4. Dimezzamento ripetuto dell'input:
   1. Tipicamente `O(log n)`.
5. Divisione in sottoproblemi:
   1. Considera numero e dimensione delle chiamate ricorsive.

## Distinguere `O` e `Θ`

1. `O(f(n))` è un limite superiore asintotico.
2. `Θ(f(n))` descrive un ordine di crescita stretto.
3. Non usare `O` come sinonimo automatico di “esattamente”.
4. Specifica se stai parlando del caso migliore, medio o peggiore.

## Ordini di crescita comuni

1. `O(1)`: costo costante.
2. `O(log n)`: riduzione moltiplicativa del problema.
3. `O(n)`: una scansione completa.
4. `O(n log n)`: lavoro lineare su più livelli logaritmici.
5. `O(n²)`: confronti tra molte coppie.
6. `O(2^n)` o peggio: esplorazione combinatoria senza riuso.

## Costi tipici delle strutture del corso

1. Lista linkata:
   1. Accesso per posizione: `O(n)`.
   2. Inserimento in testa: `O(1)`.
   3. Inserimento in coda senza `tail`: `O(n)`.
   4. Inserimento in coda con `tail`: `O(1)`.
2. Stack:
   1. `push` e `pop`: normalmente `O(1)`.
3. Queue con `front` e `rear`:
   1. `enqueue` e `dequeue`: `O(1)`.
4. Set con lista non ordinata:
   1. Appartenenza: `O(n)`.
5. BST:
   1. Operazioni: `O(h)`.
   2. Bilanciato: `O(log n)`.
   3. Degenere: `O(n)`.
6. Visita completa di lista o albero:
   1. `O(n)` tempo.

---

# 19. Ottimizzazione e qualità del codice

## Ottimizzare correttamente

1. Scegli prima un algoritmo adeguato.
2. Scrivi una versione corretta e leggibile.
3. Crea test affidabili.
4. Compila con ottimizzazioni del compilatore.
5. Misura il tempo reale.
6. Individua il collo di bottiglia.
7. Ottimizza solo la parte misurata.
8. Ripeti i test dopo ogni modifica.

## Evitare micro-ottimizzazioni premature

1. Non sacrificare leggibilità senza una misura.
2. Lascia al compilatore le trasformazioni locali semplici.
3. Preferisci evitare lavoro duplicato.
4. Cambiare algoritmo o struttura dati produce spesso il guadagno maggiore.

## Scrivere codice mantenibile

1. Usa nomi che descrivono il ruolo.
2. Mantieni funzioni brevi e coese.
3. Evita duplicazione.
4. Commenta il perché, non la sintassi evidente.
5. Documenta ownership, precondizioni ed errori.
6. Mantieni interfaccia pubblica minima.

---

# 20. Checklist finale da esame

## Prima di consegnare una funzione

1. Tutti i puntatori sono controllati prima della dereferenziazione?
2. I casi vuoto e singolo elemento funzionano?
3. La testa, la radice, `front`, `rear`, `top`, `size` e `capacity` restano coerenti?
4. Ogni `malloc` è controllata?
5. Ogni oggetto allocato ha un proprietario chiaro?
6. Ogni `free` avviene una sola volta?
7. Nessun collegamento viene perso prima di essere salvato?
8. Il ciclo visita anche l'ultimo elemento?
9. La ricorsione raggiunge certamente il caso base?
10. Il valore restituito segnala correttamente successo ed errore?
11. La funzione modifica solo ciò che la specifica consente?
12. I test coprono vuoto, minimo, normale, assente e fallimento?
13. La complessità è compatibile con la struttura dati scelta?
14. Il codice compila senza warning rilevanti?

---

# 21. Regole lampo da ricordare

1. Prima colleghi, poi sposti la testa.
2. Prima salvi il successore, poi liberi il nodo.
3. Se una funzione deve cambiare un puntatore del chiamante, serve il suo indirizzo oppure un valore di ritorno.
4. Lista vuota e albero vuoto sono casi normali, non eccezioni.
5. `while (current != NULL)` visita tutti i nodi; `while (current->next != NULL)` richiede che `current` esista e si ferma prima dell'ultimo.
6. Dopo `free`, il blocco non esiste più anche se il puntatore conserva lo stesso numero.
7. `realloc` può spostare il blocco: usa sempre un temporaneo.
8. Una coda vuota con lista richiede normalmente sia `front == NULL` sia `rear == NULL`.
9. In un BST, ogni scelta elimina un intero sottoalbero solo se l'invariante è rispettato.
10. Non usare `feof` come condizione principale di lettura.
11. Correttezza prima, efficienza dopo, misure prima delle ottimizzazioni.
