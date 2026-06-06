
# Capitolo 5.1 — Gerarchie delle memorie

## Metodo di ripasso

Ripassa queste flashcard cercando di rispondere **a voce**, come se fossi all’orale.  
L’obiettivo non è memorizzare le definizioni parola per parola, ma saper spiegare:

- perché esiste una gerarchia di memoria;
- cosa sono blocchi, hit, miss, hit rate e miss rate;
- come si calcola il tempo medio di accesso;
- perché la località dei programmi rende efficace la cache.

---

## 1. Perché nei calcolatori si usa una gerarchia di memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei calcolatori si usa una gerarchia di memoria perché nessuna singola tecnologia di memoria riesce a essere contemporaneamente molto veloce, molto capiente e poco costosa.
>
> Le memorie più vicine al processore sono più veloci, ma anche più piccole e costose per bit, come le SRAM usate nelle cache. Le memorie più lontane sono più lente, ma più grandi ed economiche, come DRAM, dischi magnetici o memoria flash.
>
> La gerarchia cerca quindi di dare al processore l’illusione di avere una memoria grande quanto i livelli inferiori, ma veloce quasi quanto i livelli superiori. Questo è possibile perché i programmi tendono a riutilizzare spesso solo una parte relativamente piccola dei dati e delle istruzioni.

---

## 2. Come è organizzata una gerarchia di memoria e cosa succede al crescere della distanza dalla CPU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una gerarchia di memoria è formata da più livelli. Il livello più vicino alla CPU è il più veloce, ma anche il più piccolo e costoso. Man mano che ci si allontana dalla CPU, i livelli diventano più grandi, più lenti e meno costosi per bit.
>
> In genere:
>
> - i livelli alti usano tecnologie veloci, come SRAM;
> - i livelli intermedi possono usare DRAM;
> - i livelli più bassi usano memorie molto capienti ma lente, come disco magnetico o memoria flash.
>
> La CPU prova ad accedere prima ai dati presenti nei livelli superiori. Se il dato non si trova lì, viene cercato nei livelli inferiori e poi copiato verso l’alto.

---

## 3. Che cos’è un blocco nella gerarchia di memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un blocco è l’unità minima di informazione che può essere presente o assente in un certo livello della gerarchia di memoria.
>
> Quando il processore richiede un dato, non viene trasferito necessariamente solo quel singolo dato, ma un intero blocco che lo contiene. Questo perché è probabile che, dopo aver usato un dato, il programma utilizzi anche dati vicini.
>
> Ad esempio, in una cache, il blocco è la quantità di dati che viene trasferita dalla memoria inferiore alla cache quando avviene un miss.

---

## 4. Che cosa sono hit e miss in una gerarchia di memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un hit si verifica quando il dato richiesto dal processore si trova nel livello della gerarchia che viene controllato.
>
> Un miss si verifica invece quando il dato richiesto non è presente in quel livello. In questo caso, bisogna accedere a un livello inferiore della gerarchia, che di solito è più lento, per recuperare il blocco contenente il dato.
>
> Quindi:
>
> - hit: il dato è trovato nel livello considerato;
> - miss: il dato non è trovato e bisogna cercarlo più in basso nella gerarchia.

---

## 5. Che cosa indicano hit rate e miss rate?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’hit rate, o frequenza degli hit, è la frazione degli accessi alla memoria che vengono soddisfatti nel livello considerato della gerarchia.
>
> Il miss rate, o frequenza dei miss, è invece la frazione degli accessi alla memoria che non vengono trovati nel livello considerato.
>
> Le due grandezze sono complementari:
>
> ```text
> miss rate = 1 - hit rate
> ```
>
> Se l’hit rate è alto, significa che la maggior parte degli accessi viene servita rapidamente dal livello superiore. Se il miss rate è alto, il processore deve accedere spesso ai livelli inferiori, con un peggioramento delle prestazioni.

---

## 6. Che differenza c’è tra hit time e miss penalty?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’hit time è il tempo necessario per accedere a un dato quando questo si trova nel livello superiore della gerarchia. Include anche il tempo necessario a capire se l’accesso ha prodotto un hit oppure un miss.
>
> La miss penalty è invece il tempo aggiuntivo richiesto quando avviene un miss. In questo caso bisogna recuperare il blocco dal livello inferiore, copiarlo nel livello superiore e poi fornire il dato al processore.
>
> In sintesi:
>
> - hit time: tempo di accesso quando il dato è presente;
> - miss penalty: tempo necessario per gestire un miss e recuperare il dato da un livello più lento.

---

## 7. Come si può esprimere il tempo medio di accesso alla memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il tempo medio di accesso alla memoria dipende dal tempo necessario in caso di hit e dal costo aggiuntivo dei miss.
>
> Una forma semplificata della formula è:
>
> ```text
> Tempo medio di accesso = hit time + miss rate × miss penalty
> ```
>
> Questa formula mostra che anche se gli hit sono veloci, le prestazioni possono peggiorare molto se il miss rate o la miss penalty sono elevati.
>
> Per questo una buona gerarchia di memoria cerca sia di rendere basso il miss rate, sia di ridurre il costo dei miss.

---

## 8. Perché il principio di località rende efficace la gerarchia di memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La gerarchia di memoria funziona bene perché i programmi mostrano località, cioè tendono a riutilizzare una parte limitata dei dati e delle istruzioni.
>
> Esistono due tipi principali di località:
>
> - località temporale: se un dato viene usato ora, è probabile che venga usato di nuovo a breve;
> - località spaziale: se un dato viene usato ora, è probabile che vengano usati presto anche dati vicini in memoria.
>
> Grazie alla località, i livelli superiori della gerarchia, pur essendo piccoli, riescono spesso a contenere i dati che serviranno al processore nel prossimo futuro.

---

## 9. Che cos’è la località temporale? Fai un esempio.

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La località temporale è la tendenza di un programma a riutilizzare nel tempo gli stessi dati o le stesse istruzioni.
>
> Ad esempio, se una variabile viene usata dentro un ciclo, è probabile che venga letta o modificata molte volte in un intervallo breve. Conviene quindi mantenerla in un livello veloce della memoria, come la cache.
>
> La località temporale giustifica il mantenimento nei livelli superiori dei blocchi usati di recente, perché potrebbero servire di nuovo presto.

---

## 10. Che cos’è la località spaziale? Fai un esempio.

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La località spaziale è la tendenza di un programma ad accedere a dati o istruzioni che si trovano vicini in memoria.
>
> Un esempio tipico è la scansione di un array. Se il programma accede all’elemento `A[i]`, è probabile che subito dopo acceda anche ad `A[i+1]`, `A[i+2]` e così via.
>
> Per questo motivo, quando avviene un miss, spesso viene trasferito in cache un intero blocco di memoria e non solo il singolo dato richiesto. In questo modo, gli accessi successivi a dati vicini possono diventare hit.

---

## 11. Perché nei trasferimenti tra livelli della gerarchia si copiano blocchi interi e non singoli dati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei trasferimenti tra livelli della gerarchia si copiano blocchi interi perché i programmi mostrano località spaziale.
>
> Se il processore richiede un certo dato, è probabile che a breve richieda anche dati vicini in memoria. Trasferire un blocco contenente più dati vicini permette quindi di ridurre i miss successivi.
>
> Questa scelta ha un costo, perché trasferire un blocco richiede più tempo rispetto a trasferire un singolo dato. Tuttavia, se la località spaziale è buona, il costo viene compensato dal fatto che molti accessi successivi saranno hit.

---

## 12. Qual è l’obiettivo complessivo di una gerarchia di memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’obiettivo complessivo di una gerarchia di memoria è ottenere prestazioni simili a quelle di una memoria veloce, ma con una capacità e un costo simili a quelli di una memoria grande ed economica.
>
> In pratica, il sistema cerca di mantenere nei livelli più vicini alla CPU i dati e le istruzioni usati più spesso o più probabilmente nel prossimo futuro.
>
> Se la gerarchia è progettata bene, la maggior parte degli accessi produce hit nei livelli superiori, riducendo il tempo medio di accesso alla memoria e migliorando le prestazioni del processore.