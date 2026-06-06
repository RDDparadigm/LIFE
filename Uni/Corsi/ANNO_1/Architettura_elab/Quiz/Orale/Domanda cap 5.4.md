
# 5.4 Come misurare e migliorare le prestazioni di una cache

## Metodo di ripasso

Per ripassare questa sezione, non partire dalle formule a memoria. Parti sempre da una domanda pratica: “da dove vengono i cicli di stallo della memoria?”. Poi collega ogni tecnica al problema che risolve:

- miss rate troppo alta → aumentare l’associatività o migliorare il software;
- penalità di miss troppo alta → usare cache multilivello;
- tempo di hit troppo alto → attenzione alla dimensione e all’associatività della cache;
- accessi poco locali → riorganizzare il programma, ad esempio con il blocking.

---

## 1. Come si può esprimere il tempo di CPU tenendo conto degli stalli dovuti alla memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il tempo di CPU può essere visto come la somma del tempo impiegato per eseguire le istruzioni più il tempo perso negli stalli dovuti alla memoria.
>
> La formula generale è:
>
> ```text
> Tempo di CPU =
> (Cicli di esecuzione CPU + Cicli di stallo della memoria)
> × Durata del ciclo di clock
> ```
>
> I cicli di stallo della memoria sono dovuti soprattutto alle miss della cache: quando il dato o l’istruzione richiesti non sono presenti in cache, il processore deve aspettare il recupero dalla memoria principale o da un livello inferiore della gerarchia.

---

## 2. Da cosa sono composti i cicli di stallo della memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I cicli di stallo della memoria si dividono in due componenti principali:
>
> ```text
> Cicli di stallo della memoria =
> Cicli di stallo in lettura + Cicli di stallo in scrittura
> ```
>
> Gli stalli in lettura si verificano quando il processore deve leggere un’istruzione o un dato non presente in cache.
>
> Gli stalli in scrittura dipendono dal tipo di politica usata, ad esempio write-through o write-back, e possono includere anche gli stalli dovuti al buffer di scrittura.

---

## 3. Come si calcolano i cicli di stallo dovuti alle letture?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I cicli di stallo dovuti alle letture dipendono da tre fattori:
>
> - numero di letture per programma;
> - frequenza di miss in lettura;
> - penalità di miss in lettura.
>
> La formula è:
>
> ```text
> Cicli di stallo in lettura =
> (Letture / Programma)
> × Frequenza di miss in lettura
> × Penalità di miss in lettura
> ```
>
> Quindi non conta solo quante letture fa il programma, ma anche quante di queste generano miss e quanto costa ogni miss.

---

## 4. Perché gli stalli in scrittura sono più complicati da modellare rispetto a quelli in lettura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli stalli in scrittura sono più complicati perché dipendono fortemente dalla politica di scrittura usata.
>
> In uno schema write-through, ogni scrittura deve essere propagata anche al livello inferiore della memoria. Per evitare che il processore resti fermo a ogni scrittura, si usa spesso un buffer di scrittura.
>
> Tuttavia, se il buffer si riempie, il processore deve aspettare: questi sono gli stalli del buffer di scrittura.
>
> Una possibile formula è:
>
> ```text
> Cicli di stallo in scrittura =
> (Scritture / Programma)
> × Frequenza di miss in scrittura
> × Penalità di miss in scrittura
> + Numero di stalli del buffer di scrittura
> ```
>
> Nei sistemi reali, però, il numero di stalli del buffer non è facile da calcolare con una formula semplice, perché dipende da quanto sono ravvicinate nel tempo le scritture.

---

## 5. Che cos’è la frequenza di miss e come entra nel calcolo delle prestazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La frequenza di miss indica la percentuale di accessi alla cache che non trovano il dato o l’istruzione richiesta.
>
> Più è alta la frequenza di miss, più spesso il processore deve aspettare la memoria.
>
> Se si considera una sola frequenza di miss per letture e scritture, i cicli di stallo della memoria possono essere scritti come:
>
> ```text
> Cicli di stallo della memoria =
> (Accessi alla memoria / Programma)
> × Frequenza di miss
> × Penalità di miss
> ```
>
> Oppure:
>
> ```text
> Cicli di stallo della memoria =
> (Istruzioni / Programma)
> × (Miss / Istruzione)
> × Penalità di miss
> ```
>
> Questa formula mostra che le prestazioni dipendono sia dal programma sia dall’organizzazione della cache.

---

## 6. Che cos’è l’AMAT e perché è utile per valutare una cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’AMAT, cioè Average Memory Access Time, è il tempo medio di accesso alla memoria.
>
> Serve per valutare una cache tenendo conto sia degli accessi che vanno a buon fine, cioè gli hit, sia degli accessi che generano miss.
>
> La formula è:
>
> ```text
> AMAT =
> Durata di una hit
> + Frequenza di miss × Penalità di miss
> ```
>
> L’AMAT permette di capire che una cache non è migliore solo perché ha meno miss: bisogna considerare anche quanto costa una hit e quanto costa una miss.
>
> Ad esempio, se una hit richiede 1 ciclo, la frequenza di miss è 5% e la penalità di miss è 20 cicli:
>
> ```text
> AMAT = 1 + 0,05 × 20 = 2 cicli di clock
> ```
>
> Quindi ogni accesso alla memoria costa in media 2 cicli.

---

## 7. Perché aumentare la dimensione della cache non migliora sempre le prestazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Aumentare la dimensione della cache può ridurre la frequenza di miss, perché ci sono più blocchi disponibili.
>
> Tuttavia, una cache più grande può aumentare il tempo di hit, cioè il tempo necessario per trovare un dato quando è presente in cache.
>
> Questo può obbligare ad aumentare la durata del ciclo di clock oppure ad aggiungere stadi di pipeline.
>
> Quindi esiste un compromesso:
>
> - cache più grande → meno miss;
> - cache più grande → possibile hit time maggiore;
> - hit time maggiore → possibile peggioramento del tempo di ciclo.
>
> Una cache più grande non è automaticamente più veloce: bisogna valutare l’effetto complessivo su AMAT e tempo di CPU.

---

## 8. Qual è la differenza tra cache a mappatura diretta, completamente associativa e set-associativa?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una cache a mappatura diretta, ogni blocco della memoria principale può andare in una sola posizione della cache.
>
> Questo rende la ricerca semplice e veloce, ma può generare molte miss da conflitto: due blocchi diversi possono competere per la stessa posizione.
>
> In una cache completamente associativa, un blocco della memoria principale può essere caricato in qualsiasi blocco della cache.
>
> Questo riduce le miss da conflitto, ma rende la ricerca più costosa, perché bisogna confrontare il tag con tutti i blocchi della cache.
>
> In una cache set-associativa, la cache è divisa in insiemi. Ogni blocco della memoria principale può andare in un certo insieme, ma dentro quell’insieme può occupare una tra più vie.
>
> È una soluzione intermedia:
>
> - mappatura diretta → una sola posizione possibile;
> - completamente associativa → qualunque posizione possibile;
> - set-associativa → un insieme possibile, ma più vie dentro l’insieme.

---

## 9. Come si determina la posizione di un blocco in una cache a mappatura diretta e in una cache set-associativa?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una cache a mappatura diretta, la posizione del blocco si ottiene con:
>
> ```text
> Numero del blocco modulo Numero dei blocchi nella cache
> ```
>
> Quindi ogni blocco della memoria principale ha una sola posizione possibile nella cache.
>
> In una cache set-associativa, invece, si determina prima l’insieme:
>
> ```text
> Numero del blocco modulo Numero degli insiemi nella cache
> ```
>
> Una volta scelto l’insieme, il blocco può essere collocato in una qualsiasi delle vie disponibili in quell’insieme.
>
> Questo riduce i conflitti rispetto alla mappatura diretta.

---

## 10. Come cambia il formato dell’indirizzo in una cache set-associativa o a mappatura diretta?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’indirizzo viene diviso in tre campi principali:
>
> ```text
> Tag | Indice | Offset di blocco
> ```
>
> L’offset di blocco seleziona il dato specifico all’interno del blocco.
>
> L’indice seleziona la linea o l’insieme della cache.
>
> Il tag serve per verificare se il blocco presente in quella posizione è davvero quello richiesto.
>
> Nella mappatura diretta, l’indice seleziona direttamente l’unico blocco possibile.
>
> Nella cache set-associativa, l’indice seleziona l’insieme, poi il tag viene confrontato con i tag di tutte le vie presenti in quell’insieme.

---

## 11. Perché aumentare l’associatività può ridurre la frequenza di miss?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Aumentare l’associatività riduce le miss da conflitto.
>
> In una cache a mappatura diretta, due blocchi che finiscono nella stessa posizione si sostituiscono continuamente, anche se nella cache ci sarebbero altri spazi disponibili.
>
> In una cache set-associativa, invece, un blocco può essere collocato in una tra più vie dello stesso insieme.
>
> Questo rende meno probabile che due blocchi entrino subito in conflitto.
>
> Però il miglioramento non cresce indefinitamente: passando da mappatura diretta a due vie si ottiene spesso un beneficio importante, ma aumentando ancora il grado di associatività il miglioramento tende a diventare sempre più piccolo.

---

## 12. Qual è lo svantaggio principale dell’aumento del grado di associatività?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Lo svantaggio principale è l’aumento del tempo di hit e della complessità hardware.
>
> In una cache set-associativa, per sapere se un blocco è presente, bisogna confrontare il tag richiesto con i tag di tutte le vie dell’insieme.
>
> Quindi servono più comparatori e una logica per scegliere quale dato restituire.
>
> Ad esempio, in una cache set-associativa a quattro vie, il tag deve essere confrontato con quattro tag diversi.
>
> Questo riduce le miss da conflitto, ma può rendere l’accesso alla cache più lento e più costoso in termini di hardware.

---

## 13. Che cosa succede quando bisogna sostituire un blocco in una cache associativa?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una cache a mappatura diretta non c’è scelta: se si verifica una miss, il nuovo blocco sostituisce l’unico blocco nella posizione corrispondente.
>
> In una cache associativa o set-associativa, invece, ci sono più possibili blocchi da sostituire.
>
> Serve quindi una politica di sostituzione.
>
> Una politica molto usata è LRU, Least Recently Used, cioè “meno recentemente usato”.
>
> L’idea è sostituire il blocco che non viene usato da più tempo, perché si presume che abbia minore probabilità di essere riutilizzato a breve.
>
> LRU è semplice per cache a bassa associatività, ad esempio a due vie, ma diventa più complesso all’aumentare del numero di vie.

---

## 14. Che cos’è una cache multilivello e perché riduce la penalità di miss?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una cache multilivello è una gerarchia composta da più livelli di cache.
>
> Di solito si ha una cache di primo livello, L1, molto veloce e vicina al processore, e una cache di secondo livello, L2, più grande ma più lenta.
>
> Quando c’è una miss in L1, il processore non deve andare subito in memoria principale: prima controlla L2.
>
> Se il dato è presente in L2, la penalità della miss di L1 è molto più bassa rispetto a un accesso diretto alla memoria principale.
>
> Quindi la cache multilivello serve soprattutto a ridurre la penalità di miss percepita dal processore.
>
> Il principio è:
>
> - L1 → piccola e veloce, ottimizzata per il tempo di hit;
> - L2 → più grande, ottimizzata per ridurre la penalità delle miss di L1;
> - memoria principale → molto più lenta.

---

## 15. Come si calcola il CPI effettivo con una cache multilivello?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Con una cache multilivello, il CPI effettivo è dato dal CPI base più gli stalli dovuti alla memoria.
>
> Con un solo livello di cache:
>
> ```text
> CPI totale =
> CPI base + Frequenza di miss L1 × Penalità di miss verso memoria principale
> ```
>
> Con due livelli di cache, se una miss in L1 può essere risolta in L2, allora:
>
> ```text
> CPI totale =
> CPI base
> + Stalli primari per istruzione
> + Stalli secondari per istruzione
> ```
>
> Dove:
>
> ```text
> Stalli primari =
> Frequenza di miss L1 × Penalità di accesso a L2
> ```
>
> ```text
> Stalli secondari =
> Frequenza di miss globale × Penalità di accesso alla memoria principale
> ```
>
> La cache L2 riduce il numero di volte in cui bisogna accedere alla memoria principale, quindi abbassa il CPI effettivo.

---

## 16. Qual è la differenza tra frequenza di miss globale e frequenza di miss locale in una cache multilivello?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La frequenza di miss locale misura la percentuale di accessi che falliscono all’interno di un singolo livello della cache.
>
> Ad esempio, la frequenza di miss locale della L2 considera solo gli accessi che arrivano alla L2, cioè quelli che hanno già fatto miss in L1.
>
> La frequenza di miss globale, invece, misura la percentuale di accessi complessivi alla memoria che falliscono in tutti i livelli della cache.
>
> Esempio:
>
> - miss rate L1 = 2%;
> - miss rate locale L2 = 25%.
>
> La frequenza di miss globale è:
>
> ```text
> 2% × 25% = 0,5%
> ```
>
> Quindi solo lo 0,5% degli accessi totali arriva davvero fino alla memoria principale.

---

## 17. Perché la cache primaria e la cache secondaria hanno obiettivi progettuali diversi?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La cache primaria, cioè L1, è consultata molto spesso, praticamente a ogni istruzione o quasi.
>
> Per questo deve essere molto veloce: il suo obiettivo principale è ridurre il tempo di hit.
>
> La cache secondaria, cioè L2, viene consultata solo quando c’è una miss in L1.
>
> Per questo può essere più grande e un po’ più lenta: il suo obiettivo principale è ridurre la frequenza di accesso alla memoria principale e quindi abbassare la penalità effettiva delle miss.
>
> In sintesi:
>
> - L1 → ottimizzata per velocità di accesso;
> - L2 → ottimizzata per capacità e riduzione delle miss verso la memoria principale.

---

## 18. Perché le prestazioni della cache dipendono anche dal software?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le prestazioni della cache non dipendono solo dall’hardware, ma anche dal modo in cui il programma accede ai dati.
>
> Un programma che accede ai dati con buona località spaziale e temporale sfrutta meglio la cache.
>
> La località spaziale significa usare dati vicini in memoria.
>
> La località temporale significa riutilizzare a breve distanza di tempo dati già caricati.
>
> Per esempio, negli algoritmi di ordinamento o nel prodotto tra matrici, l’organizzazione degli accessi può influenzare molto il numero di miss.
>
> Due programmi che fanno lo stesso calcolo possono quindi avere prestazioni molto diverse se accedono alla memoria in modo diverso.

---

## 19. Che cos’è l’ottimizzazione software mediante elaborazione a blocchi?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’elaborazione a blocchi, o blocking, è una tecnica software che riorganizza il programma per lavorare su sottoinsiemi di dati abbastanza piccoli da rimanere in cache.
>
> È molto utile, ad esempio, nel prodotto tra matrici.
>
> Invece di scorrere intere righe e colonne causando molti accessi a dati lontani, il programma lavora su blocchi più piccoli delle matrici.
>
> Così aumenta la probabilità che i dati già caricati in cache vengano riutilizzati prima di essere sostituiti.
>
> Il blocking migliora quindi:
>
> - la località temporale, perché si riusano dati già caricati;
> - la località spaziale, perché si lavora su dati vicini;
> - la frequenza di miss, perché diminuiscono gli accessi alla memoria principale.

---

## 20. Qual è l’idea generale dietro l’autocalibrazione o autotuning delle prestazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’autotuning consiste nel generare e provare automaticamente diverse versioni di un algoritmo, variando parametri come:
>
> - dimensione dei blocchi;
> - livello di unrolling;
> - uso dei registri;
> - ordine dei cicli;
> - organizzazione degli accessi alla memoria.
>
> L’obiettivo è trovare la versione più veloce per una specifica architettura.
>
> È utile perché non esiste una scelta ottima universale: la soluzione migliore dipende dalla gerarchia di memoria, dalla dimensione delle cache, dall’associatività, dalla dimensione dei blocchi e dal processore usato.
>
> Quindi l’autotuning cerca sperimentalmente la combinazione più adatta alla macchina reale.

---