
# 5.3 Principi base delle memorie cache

## Metodo di ripasso

Per ripassare questa sezione, concentrati su tre livelli:

1. **Idea generale:** perché serve una cache e quale problema risolve nella gerarchia di memoria.
2. **Funzionamento logico:** hit, miss, valid bit, tag, indice, offset e mappatura diretta.
3. **Scelte progettuali:** dimensione dei blocchi, gestione delle miss, gestione delle scritture, write-through, write-back, split cache.

Durante il ripasso prova sempre a spiegare un accesso alla cache “a voce”, partendo dall’indirizzo richiesto dal processore: prima si seleziona il blocco tramite indice, poi si confronta il tag, poi si usa il bit di validità per decidere se il dato è davvero presente.

---

## 1. Che cos’è una memoria cache e perché viene usata?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una memoria cache è un livello di memoria piccolo e veloce posto tra il processore e la memoria principale.
>
> Serve a ridurre il tempo medio di accesso ai dati e alle istruzioni, sfruttando il principio di località.
>
> In pratica, invece di accedere sempre alla memoria principale, il processore prova prima a cercare il dato nella cache. Se il dato è presente, l’accesso è molto più rapido.
>
> La cache è quindi fondamentale nella gerarchia di memoria perché permette di avere, nella maggior parte dei casi, una velocità vicina a quella della memoria più veloce, ma con una capacità complessiva vicina a quella della memoria principale.

---

## 2. Che cosa si intende per hit e miss in una memoria cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **hit** si verifica quando il dato richiesto dal processore è presente nella cache.
>
> In questo caso il dato può essere fornito rapidamente al processore senza accedere alla memoria principale.
>
> Un **miss** si verifica invece quando il dato richiesto non è presente nella cache.
>
> In questo caso il processore deve recuperare il dato dalla memoria principale o da un livello inferiore della gerarchia di memoria. Dopo il recupero, il dato viene normalmente copiato anche nella cache, così che eventuali accessi futuri siano più veloci.
>
> La prestazione della cache dipende molto dalla frequenza degli hit e delle miss.

---

## 3. Che cos’è una cache a mappatura diretta?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **cache a mappatura diretta** è una cache in cui ogni blocco della memoria principale può essere collocato in una sola posizione possibile della cache.
>
> La posizione viene scelta tramite una semplice operazione:
>
> ```text
> numero del blocco di memoria principale modulo numero di blocchi della cache
> ```
>
> Questo rende la cache semplice e veloce da realizzare, perché dato un indirizzo si sa immediatamente in quale posizione della cache bisogna cercare.
>
> Lo svantaggio è che blocchi diversi della memoria principale possono essere mappati nella stessa posizione della cache. Quando questo accade, un blocco può sostituire un altro anche se nella cache ci sarebbero altre posizioni libere.

---

## 4. Perché in una cache a mappatura diretta serve il campo tag?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una cache a mappatura diretta, più blocchi della memoria principale possono corrispondere alla stessa posizione della cache.
>
> Per esempio, se la cache ha 8 blocchi, tutti i blocchi della memoria principale con lo stesso resto modulo 8 finiscono nella stessa riga della cache.
>
> Il solo indice non basta quindi a sapere se il blocco presente in cache è proprio quello richiesto.
>
> Per questo ogni riga della cache contiene un **tag**, cioè una parte dell’indirizzo del blocco di memoria principale.
>
> Quando il processore accede alla cache:
>
> 1. usa l’indice per selezionare una riga;
> 2. confronta il tag dell’indirizzo richiesto con il tag memorizzato nella cache;
> 3. se i tag coincidono e il bit di validità è attivo, allora c’è hit;
> 4. altrimenti c’è miss.
>
> Il tag serve quindi a distinguere quale tra i possibili blocchi mappati nella stessa posizione è effettivamente presente nella cache.

---

## 5. A cosa serve il bit di validità in una cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **bit di validità** indica se una riga della cache contiene effettivamente un dato valido.
>
> È necessario perché, all’accensione del calcolatore, la cache può contenere valori casuali o non significativi.
>
> Anche se il tag sembrasse coincidere, non si potrebbe sapere se il contenuto della riga è davvero un dato caricato correttamente dalla memoria.
>
> Per questo ogni riga della cache ha un bit di validità:
>
> - se vale 0, il contenuto della riga non è valido;
> - se vale 1, il contenuto della riga può essere usato.
>
> Un accesso produce hit solo se:
>
> 1. il bit di validità è attivo;
> 2. il tag memorizzato coincide con il tag dell’indirizzo richiesto.
>
> Se una delle due condizioni manca, si ha una miss.

---

## 6. Come viene suddiviso un indirizzo in una cache a mappatura diretta?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una cache a mappatura diretta, l’indirizzo viene suddiviso in più campi:
>
> - **offset di byte**, per selezionare il byte all’interno della parola;
> - **offset di blocco**, se un blocco contiene più parole;
> - **indice**, per selezionare la riga della cache;
> - **tag**, per verificare se il blocco presente in quella riga è proprio quello richiesto.
>
> L’indice individua dove cercare nella cache.
>
> Il tag serve invece a controllare che il blocco trovato sia quello corretto.
>
> L’offset serve a selezionare il dato specifico all’interno del blocco.
>
> In sintesi, l’indice dice “dove guardare”, il tag dice “se è il blocco giusto” e l’offset dice “quale parte del blocco usare”.

---

## 7. Come si determina il numero di bit dell’indice in una cache a mappatura diretta?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il numero di bit dell’indice dipende dal numero di blocchi presenti nella cache.
>
> Se la cache contiene `2^n` blocchi, allora servono `n` bit di indice.
>
> Questo perché con `n` bit si possono rappresentare `2^n` combinazioni diverse, una per ogni blocco della cache.
>
> Per esempio:
>
> - una cache con 8 blocchi richiede 3 bit di indice;
> - una cache con 1024 blocchi richiede 10 bit di indice;
> - una cache con 4096 blocchi richiede 12 bit di indice.
>
> L’indice è quindi la parte dell’indirizzo usata per selezionare direttamente una riga della cache.

---

## 8. Come si calcola la dimensione del campo tag?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La dimensione del tag si ottiene sottraendo dalla dimensione totale dell’indirizzo i bit usati per indice e offset.
>
> Se l’indirizzo ha 32 bit, allora:
>
> ```text
> bit tag = 32 - bit indice - bit offset
> ```
>
> Se il blocco contiene parole da 4 byte, ci sono sempre 2 bit per selezionare il byte all’interno della parola.
>
> Se inoltre il blocco contiene più parole, servono altri bit per selezionare la parola all’interno del blocco.
>
> Per esempio, se una cache ha:
>
> - indirizzi da 32 bit;
> - 1024 blocchi, quindi 10 bit di indice;
> - blocchi da una parola, quindi 2 bit di offset di byte;
>
> allora il tag è:
>
> ```text
> 32 - 10 - 2 = 20 bit
> ```
>
> Il tag contiene quindi la parte alta dell’indirizzo che identifica quale blocco della memoria principale è memorizzato nella riga selezionata.

---

## 9. Perché la dimensione reale di una cache è maggiore della sola dimensione dei dati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La dimensione reale di una cache è maggiore della sola dimensione dei dati perché ogni riga non contiene soltanto il blocco di dati, ma anche informazioni aggiuntive.
>
> In particolare, ogni riga contiene:
>
> - i dati veri e propri;
> - il campo tag;
> - il bit di validità;
> - eventualmente altri bit di controllo, a seconda della politica di gestione della cache.
>
> Per esempio, una cache dichiarata come cache da 16 KiB indica normalmente 16 KiB di soli dati.
>
> Tuttavia, fisicamente, la cache occupa più spazio perché bisogna memorizzare anche tag e bit di validità.
>
> Quindi la dimensione “commerciale” o nominale della cache di solito si riferisce solo alla memoria dati, non all’intero hardware necessario per implementarla.

---

## 10. Che cosa succede quando si verifica una miss in lettura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Quando si verifica una **miss in lettura**, il dato richiesto non è disponibile nella cache.
>
> La gestione tipica è la seguente:
>
> 1. il processore invia l’indirizzo alla cache;
> 2. la cache verifica che il dato non è presente;
> 3. il processore viene messo in stallo;
> 4. il blocco contenente il dato viene richiesto alla memoria principale;
> 5. quando il blocco arriva, viene scritto nella cache;
> 6. il tag viene aggiornato;
> 7. il bit di validità viene impostato a 1;
> 8. l’istruzione può essere rieseguita o completata usando il dato appena caricato.
>
> La miss è quindi più costosa di un hit, perché richiede un accesso alla memoria principale e può bloccare temporaneamente il processore.

---

## 11. Perché nelle cache si trasferiscono blocchi e non solo singole parole?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le cache trasferiscono blocchi di più parole per sfruttare la **località spaziale**.
>
> La località spaziale dice che, se un programma accede a un certo indirizzo, è probabile che poco dopo acceda anche a indirizzi vicini.
>
> Per esempio, questo accade spesso:
>
> - nelle istruzioni sequenziali;
> - negli array;
> - nelle strutture dati contigue in memoria.
>
> Caricando un intero blocco, la cache non salva solo la parola richiesta, ma anche parole vicine che potrebbero essere richieste subito dopo.
>
> Questo può ridurre la frequenza di miss.
>
> Tuttavia, blocchi troppo grandi possono peggiorare le prestazioni, perché aumentano il tempo di trasferimento dalla memoria principale e riducono il numero di blocchi diversi che possono stare nella cache.

---

## 12. Qual è l’effetto della dimensione del blocco sulla frequenza di miss?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Aumentare la dimensione del blocco può ridurre la frequenza di miss perché sfrutta meglio la località spaziale.
>
> Infatti, quando viene caricato un blocco più grande, vengono portate in cache anche parole vicine a quella richiesta.
>
> Questo può evitare miss successive su indirizzi contigui.
>
> Tuttavia, oltre una certa dimensione, blocchi troppo grandi possono peggiorare le prestazioni.
>
> I motivi principali sono:
>
> - aumentano il tempo necessario per trasferire il blocco dalla memoria principale;
> - nella cache entrano meno blocchi distinti;
> - può aumentare la probabilità di sostituire dati ancora utili;
> - la penalità di miss cresce perché bisogna attendere il trasferimento di un blocco più grande.
>
> Quindi esiste un compromesso: blocchi più grandi aiutano la località spaziale, ma se diventano troppo grandi aumentano la penalità delle miss e possono ridurre l’efficacia della cache.

---

## 13. Che cosa si intende per penalità di miss?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **penalità di miss** è il tempo aggiuntivo necessario per gestire una miss.
>
> Quando il dato non è presente in cache, il processore deve attendere che il blocco venga recuperato da un livello inferiore della gerarchia di memoria, come la memoria principale.
>
> Questa attesa può richiedere molti cicli di clock.
>
> La penalità di miss include quindi:
>
> - il tempo per accedere alla memoria principale;
> - il tempo per trasferire il blocco nella cache;
> - il tempo durante il quale il processore resta fermo o non può completare l’istruzione.
>
> Una cache efficace non deve solo avere una bassa frequenza di miss, ma anche una penalità di miss contenuta.

---

## 14. Che cos’è la ripartenza anticipata e perché può migliorare le prestazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **ripartenza anticipata** è una tecnica usata per ridurre l’effetto della penalità di miss.
>
> Invece di aspettare che l’intero blocco venga trasferito dalla memoria principale alla cache, il processore può ripartire appena arriva la parola effettivamente richiesta.
>
> Il resto del blocco continua poi a essere trasferito in cache.
>
> Questa tecnica è utile perché spesso il processore ha bisogno subito solo di una parola, non necessariamente dell’intero blocco.
>
> Il vantaggio è che si riduce il tempo di stallo del processore.
>
> La ripartenza anticipata è particolarmente utile quando i blocchi sono grandi, perché attendere il trasferimento completo del blocco potrebbe richiedere molti cicli.

---

## 15. Come vengono gestite le miss nelle cache per le istruzioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Quando si verifica una miss nella cache istruzioni, l’istruzione richiesta non è disponibile.
>
> In genere il processore:
>
> 1. salva o usa il valore corretto del program counter;
> 2. invia l’indirizzo alla memoria principale;
> 3. attende che l’istruzione venga letta;
> 4. scrive l’istruzione nella cache;
> 5. aggiorna il tag e il bit di validità;
> 6. riprende l’esecuzione dall’istruzione corretta.
>
> Poiché il processore non può eseguire l’istruzione se questa non è stata caricata, una miss nella cache istruzioni causa normalmente uno stallo.
>
> La gestione è comunque più semplice rispetto alle scritture, perché le istruzioni vengono normalmente solo lette e non modificate durante l’esecuzione ordinaria.

---

## 16. Perché la gestione delle scritture in cache è più complessa della gestione delle letture?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La gestione delle scritture è più complessa perché quando il processore modifica un dato in cache bisogna mantenere coerente anche la memoria principale.
>
> In lettura, se il dato è presente in cache, basta restituirlo al processore.
>
> In scrittura, invece, bisogna decidere cosa fare del dato modificato:
>
> - scriverlo subito anche in memoria principale;
> - oppure scriverlo solo nella cache e aggiornare la memoria principale più tardi.
>
> Questo introduce il problema della coerenza tra cache e memoria.
>
> Inoltre bisogna gestire anche i casi di miss in scrittura: se il dato da modificare non è presente in cache, il sistema deve decidere se caricare prima il blocco in cache oppure scrivere direttamente in memoria.
>
> Per questo le politiche di scrittura sono una parte importante del progetto di una cache.

---

## 17. Che cos’è la politica write-through?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La politica **write-through** prevede che ogni scrittura venga effettuata sia nella cache sia nella memoria principale.
>
> In questo modo cache e memoria principale rimangono sempre coerenti.
>
> Il vantaggio principale è la semplicità:
>
> - la memoria principale contiene sempre il valore aggiornato;
> - in caso di sostituzione di un blocco, non bisogna riscriverlo in memoria;
> - la gestione è più semplice.
>
> Lo svantaggio è che ogni scrittura richiede anche un accesso alla memoria principale, che è molto più lenta della cache.
>
> Per evitare che il processore resti fermo a ogni scrittura, spesso si usa un **buffer di scrittura**, che memorizza temporaneamente i dati da scrivere in memoria principale.

---

## 18. A cosa serve un buffer di scrittura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **buffer di scrittura** è una piccola coda usata per memorizzare temporaneamente i dati che devono essere scritti in memoria principale.
>
> È utile soprattutto con la politica write-through.
>
> Senza buffer, il processore dovrebbe attendere il completamento di ogni scrittura in memoria principale, rallentando molto l’esecuzione.
>
> Con il buffer di scrittura, invece:
>
> 1. il processore scrive il dato nella cache;
> 2. il dato viene inserito nel buffer;
> 3. il processore può continuare l’esecuzione;
> 4. la memoria principale viene aggiornata successivamente.
>
> Il problema è che, se il buffer si riempie, il processore deve comunque fermarsi finché non si libera spazio.
>
> Quindi il buffer migliora le prestazioni, ma non elimina completamente il costo delle scritture.

---

## 19. Che cos’è la politica write-back?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La politica **write-back** prevede che una scrittura aggiorni inizialmente solo il blocco presente nella cache.
>
> La memoria principale non viene aggiornata subito.
>
> Il blocco modificato viene scritto in memoria principale solo quando deve essere sostituito nella cache.
>
> Il vantaggio è che si riduce il numero di scritture verso la memoria principale, perché più modifiche allo stesso blocco possono essere accumulate in cache e trasferite una sola volta.
>
> Lo svantaggio è che la gestione è più complessa:
>
> - la memoria principale può contenere una copia non aggiornata del dato;
> - bisogna sapere quali blocchi sono stati modificati;
> - quando un blocco modificato viene sostituito, bisogna prima riscriverlo in memoria.
>
> Per questo una cache write-back usa normalmente un bit aggiuntivo, spesso chiamato dirty bit, per indicare se il blocco è stato modificato.

---

## 20. Qual è la differenza tra write-through e write-back?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La differenza principale riguarda quando viene aggiornata la memoria principale.
>
> Nella politica **write-through**, ogni scrittura aggiorna subito sia la cache sia la memoria principale.
>
> Nella politica **write-back**, invece, la scrittura aggiorna solo la cache; la memoria principale viene aggiornata più tardi, quando il blocco modificato deve essere sostituito.
>
> Il write-through è più semplice e mantiene sempre coerente la memoria principale, ma può generare molte scritture lente verso la memoria.
>
> Il write-back riduce il traffico verso la memoria principale, ma richiede una gestione più complessa perché la cache può contenere dati più aggiornati rispetto alla memoria.
>
> In sintesi:
>
> - **write-through:** più semplice, ma più traffico in memoria;
> - **write-back:** più efficiente, ma più complesso da gestire.

---

## 21. Che cosa sono write-allocate e no-write-allocate?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> **Write-allocate** e **no-write-allocate** sono politiche usate per gestire una miss in scrittura.
>
> Con **write-allocate**, se il processore vuole scrivere un dato non presente in cache, il blocco corrispondente viene prima caricato dalla memoria principale alla cache. Poi la scrittura viene effettuata nella cache.
>
> Questa politica è adatta quando si prevede che lo stesso blocco verrà usato di nuovo a breve.
>
> Con **no-write-allocate**, invece, se il dato non è presente in cache, la scrittura viene effettuata direttamente in memoria principale senza caricare il blocco in cache.
>
> Questa politica evita di occupare spazio in cache con dati che potrebbero non essere più riutilizzati.
>
> Spesso:
>
> - write-back si combina bene con write-allocate;
> - write-through si combina spesso con no-write-allocate.
>
> La scelta dipende dal comportamento atteso dei programmi e dal progetto della memoria.

---

## 22. Che cosa si intende per cache separate per istruzioni e dati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una cache separata per istruzioni e dati divide la cache in due parti distinte:
>
> - una cache per le istruzioni;
> - una cache per i dati.
>
> Questa organizzazione è chiamata anche **split cache**.
>
> Il vantaggio principale è che il processore può accedere contemporaneamente a un’istruzione e a un dato.
>
> Questo è particolarmente utile nei processori con pipeline, dove in uno stesso ciclo può essere necessario:
>
> - prelevare una nuova istruzione;
> - leggere o scrivere un dato.
>
> Una cache unica potrebbe creare conflitti tra questi due accessi.
>
> Con due cache separate, invece, si aumenta la banda disponibile e si riduce il rischio che istruzioni e dati interferiscano tra loro.

---

## 23. Qual è la differenza tra cache unificata e split cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **cache unificata** contiene sia istruzioni sia dati nella stessa struttura.
>
> Una **split cache**, invece, usa due cache separate:
>
> - una per le istruzioni;
> - una per i dati.
>
> La cache unificata è più flessibile, perché lo spazio può essere usato dinamicamente da istruzioni o dati a seconda delle necessità.
>
> Però può creare conflitti: un accesso ai dati e un accesso alle istruzioni possono competere per la stessa cache.
>
> La split cache riduce questi conflitti e permette accessi paralleli a istruzioni e dati, migliorando le prestazioni nei processori con pipeline.
>
> Lo svantaggio è che lo spazio è diviso rigidamente: se la cache dati è piena e quella istruzioni ha spazio libero, non sempre quello spazio può essere usato per i dati.

---

## 24. Perché la larghezza di banda della memoria principale è importante per le prestazioni della cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La larghezza di banda della memoria principale indica quanti dati possono essere trasferiti tra memoria e cache in un certo intervallo di tempo.
>
> È importante perché, in caso di miss, la cache deve caricare un intero blocco dalla memoria principale.
>
> Se la banda è bassa, il trasferimento del blocco richiede molto tempo e la penalità di miss aumenta.
>
> Questo problema diventa più evidente quando i blocchi sono grandi.
>
> Per migliorare le prestazioni si può aumentare la banda trasferendo più dati in parallelo oppure organizzando la memoria in modo interallacciato, così da trasferire blocchi più velocemente.
>
> Quindi una cache con blocchi grandi può essere vantaggiosa solo se la memoria principale riesce a trasferire quei blocchi in modo sufficientemente rapido.

---

## 25. Quali sono i concetti principali da ricordare sulle memorie cache a mappatura diretta?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I concetti fondamentali sono:
>
> - la cache è una memoria piccola e veloce che riduce il tempo medio di accesso;
> - sfrutta la località temporale e spaziale;
> - in una cache a mappatura diretta ogni blocco della memoria principale può andare in una sola posizione della cache;
> - l’indice seleziona la riga della cache;
> - il tag verifica se il blocco presente è quello richiesto;
> - il bit di validità dice se il contenuto della riga è utilizzabile;
> - un hit avviene quando il dato è presente e valido;
> - una miss richiede il recupero del blocco dalla memoria principale;
> - blocchi più grandi possono ridurre le miss, ma aumentano la penalità di miss;
> - le scritture richiedono politiche specifiche, come write-through e write-back.
>
> Una buona risposta d’esame deve collegare sempre struttura della cache, suddivisione dell’indirizzo e gestione di hit/miss.