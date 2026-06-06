
# 5.2 Tecnologie delle memorie

## Metodo di ripasso

Ripassa questa sezione facendo attenzione ai **confronti tra tecnologie**.  
Per ogni memoria chiediti:

- è volatile o non volatile?
- è veloce o lenta?
- quanto costa per bit?
- dove viene usata nella gerarchia?
- qual è il suo limite principale?

All’orale conviene saper collegare ogni tecnologia al suo ruolo: **SRAM per le cache**, **DRAM per la memoria principale**, **flash per SSD e dispositivi mobili**, **dischi magnetici per memoria di massa economica e capiente**.

---

## 1. Quali sono le principali tecnologie usate nella gerarchia delle memorie?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le principali tecnologie usate nella gerarchia delle memorie sono:
>
> - **SRAM**, usata soprattutto per le cache;
> - **DRAM**, usata per la memoria principale;
> - **memoria flash**, usata negli SSD e nei dispositivi mobili;
> - **dischi magnetici**, usati come memoria secondaria di grande capacità.
>
> Queste tecnologie si distinguono per **tempo di accesso**, **costo per bit**, **densità**, **consumo energetico** e **volatilità**.
>
> In generale, più una memoria è veloce, più è costosa e meno capiente. Al contrario, le memorie più lente tendono a essere più economiche e più grandi.

---

## 2. Che differenza c’è tra SRAM e DRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La differenza principale riguarda il modo in cui viene memorizzato un bit.
>
> Nella **SRAM**, il bit viene memorizzato tramite un circuito bistabile, quindi il dato rimane stabile finché la memoria è alimentata. Non serve refresh periodico.
>
> Nella **DRAM**, invece, il bit viene memorizzato come carica elettrica in un condensatore controllato da un transistor. Poiché la carica tende a disperdersi, il contenuto deve essere periodicamente rinfrescato.
>
> Quindi:
>
> - la **SRAM** è più veloce, ma più costosa e meno densa;
> - la **DRAM** è più lenta, ma più economica e più densa;
> - entrambe sono **volatili**, cioè perdono il contenuto senza alimentazione.

---

## 3. Perché la SRAM viene usata per realizzare le cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La SRAM viene usata per le cache perché ha un tempo di accesso molto basso.
>
> La cache deve fornire rapidamente dati e istruzioni al processore, quindi serve una tecnologia veloce. La SRAM è adatta perché non richiede refresh e permette accessi molto rapidi.
>
> Il limite è che ogni bit richiede diversi transistor, spesso da sei a otto, quindi la SRAM occupa più area ed è più costosa rispetto alla DRAM.
>
> Per questo motivo non viene usata per costruire grandi memorie principali, ma solo memorie piccole e veloci vicine al processore.

---

## 4. Perché la DRAM viene usata come memoria principale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La DRAM viene usata come memoria principale perché offre un buon compromesso tra costo, capacità e prestazioni.
>
> Rispetto alla SRAM, la DRAM è più lenta, ma è molto più densa perché usa un solo transistor per bit. Questo permette di costruire memorie più grandi a un costo inferiore.
>
> Lo svantaggio è che il dato viene memorizzato sotto forma di carica elettrica, quindi deve essere periodicamente rinfrescato.
>
> In sintesi, la DRAM è adatta alla memoria principale perché consente di avere molta capacità a un costo accettabile, anche se non è veloce quanto la SRAM.

---

## 5. Cosa significa che una memoria è volatile o non volatile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una memoria è **volatile** se perde il proprio contenuto quando viene tolta l’alimentazione.
>
> SRAM e DRAM sono memorie volatili: mantengono i dati solo finché il sistema è acceso.
>
> Una memoria è invece **non volatile** se conserva i dati anche senza alimentazione.
>
> Le memorie flash e i dischi magnetici sono non volatili, quindi vengono usati per conservare dati in modo permanente o semi-permanente.

---

## 6. Che cos’è il refresh della DRAM e perché è necessario?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **refresh** è l’operazione con cui il contenuto delle celle DRAM viene periodicamente letto e riscritto.
>
> È necessario perché nella DRAM ogni bit è memorizzato come carica elettrica in un condensatore. Questa carica non rimane indefinitamente, ma tende a disperdersi nel tempo.
>
> Se non venisse eseguito il refresh, il contenuto della memoria andrebbe perso.
>
> Il refresh è quindi una caratteristica fondamentale della DRAM e contribuisce a renderla più lenta rispetto alla SRAM.

---

## 7. Come è organizzata internamente una DRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una DRAM è organizzata come una matrice di celle disposte in **righe** e **colonne**.
>
> Per accedere a un dato, prima si seleziona una riga e il suo contenuto viene trasferito in un buffer di riga. Poi si seleziona la colonna desiderata all’interno di quella riga.
>
> Il buffer di riga si comporta in modo simile a una piccola SRAM: se gli accessi successivi riguardano dati presenti nella stessa riga, possono essere serviti più rapidamente.
>
> Questa organizzazione permette di migliorare le prestazioni quando gli accessi presentano località spaziale, cioè quando vengono richiesti dati vicini tra loro.

---

## 8. Che ruolo ha il buffer di riga in una DRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **buffer di riga** contiene temporaneamente i dati di una riga della DRAM.
>
> Quando viene aperta una riga, il suo contenuto viene copiato nel buffer. Se gli accessi successivi riguardano dati nella stessa riga, non è necessario accedere nuovamente alla matrice DRAM completa: basta leggere dal buffer.
>
> Questo riduce il tempo di accesso per dati vicini tra loro.
>
> Il buffer di riga sfrutta quindi la **località spaziale**, perché rende più veloci gli accessi a parole consecutive o comunque appartenenti alla stessa riga.

---

## 9. Che cosa sono le SDRAM e perché sono importanti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le **SDRAM**, cioè Synchronous DRAM, sono DRAM sincronizzate con il clock del processore o del sistema.
>
> La sincronizzazione consente alla memoria di coordinare meglio i trasferimenti con il resto del sistema.
>
> Un vantaggio importante delle SDRAM è che possono trasferire gruppi di dati adiacenti in sequenza, cioè in modalità burst, senza dover specificare ogni volta un nuovo indirizzo completo.
>
> Questo migliora la banda disponibile, soprattutto quando vengono letti dati consecutivi.

---

## 10. Che cosa significa DDR SDRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> DDR SDRAM significa **Double Data Rate Synchronous DRAM**.
>
> È una memoria DRAM sincrona che trasferisce dati due volte per ciclo di clock: una volta sul fronte di salita e una volta sul fronte di discesa.
>
> Questo permette di aumentare la banda di trasferimento senza aumentare necessariamente la frequenza del clock.
>
> Le generazioni successive, come DDR2, DDR3 e DDR4, migliorano ulteriormente la banda e l’efficienza del trasferimento dati.

---

## 11. Che cosa sono i banchi di memoria nelle DRAM moderne?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I **banchi di memoria** sono sottoinsiemi indipendenti all’interno di una DRAM.
>
> Organizzare la memoria in più banchi permette di sovrapporre parzialmente operazioni diverse. Mentre un banco sta completando un accesso, un altro può essere preparato per un accesso successivo.
>
> Questo aumenta la banda effettiva della memoria.
>
> Inoltre, inviando richieste a banchi diversi in modo alternato, si può sfruttare una forma di interleaving, cioè una distribuzione degli accessi tra più banchi per ridurre i tempi morti.

---

## 12. Che cosa sono i DIMM e che ruolo hanno nella memoria principale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I **DIMM**, cioè Dual Inline Memory Modules, sono moduli di memoria che contengono più chip DRAM.
>
> Sono il formato tipico con cui la DRAM viene installata nei computer.
>
> Un DIMM permette di aumentare la larghezza del trasferimento dati usando più chip in parallelo. Per esempio, più chip possono contribuire insieme a fornire una parola di memoria più ampia.
>
> I DIMM rendono quindi possibile costruire memorie principali capienti e con una banda elevata, combinando più chip DRAM in un unico modulo.

---

## 13. Che caratteristiche hanno le memorie flash?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le memorie flash sono memorie **non volatili**, quindi conservano i dati anche senza alimentazione.
>
> Sono derivate dalle EEPROM, ma permettono una maggiore densità e costi inferiori. Vengono usate negli SSD, nelle chiavette USB, nelle schede di memoria e nei dispositivi mobili.
>
> Un limite importante è che le celle flash si usurano con le scritture. Ogni cella può sopportare solo un numero limitato di cicli di cancellazione e scrittura.
>
> Per questo i controller flash usano tecniche come il **wear leveling**, che distribuisce le scritture su celle diverse per evitare che alcune si consumino troppo rapidamente.

---

## 14. Che cos’è il wear leveling nelle memorie flash?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **wear leveling** è una tecnica usata nelle memorie flash per distribuire uniformemente le scritture tra le celle di memoria.
>
> È necessario perché le celle flash si degradano dopo un certo numero di cicli di scrittura e cancellazione.
>
> Se il sistema scrivesse sempre nelle stesse celle, quelle celle si consumerebbero rapidamente, riducendo la vita utile della memoria.
>
> Il controller flash cerca quindi di evitare questo problema spostando i dati e distribuendo il carico di scrittura su tutta la memoria disponibile.

---

## 15. Come sono organizzati i dischi magnetici?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un disco magnetico è formato da uno o più **piatti** ricoperti di materiale magnetico.
>
> Ogni superficie è divisa in **tracce**, cioè cerchi concentrici, e ogni traccia è divisa in **settori**, che sono le unità minime di memorizzazione.
>
> I dati vengono letti e scritti da una testina di lettura/scrittura, che si sposta sopra la superficie del disco.
>
> Le tracce alla stessa distanza dal centro, presenti su più superfici, formano un **cilindro**.
>
> Questa organizzazione è molto diversa da quella delle memorie elettroniche, perché l’accesso ai dati richiede movimenti meccanici.

---

## 16. Quali componenti determinano il tempo di accesso a un disco magnetico?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il tempo di accesso a un disco magnetico dipende principalmente da tre componenti:
>
> - **tempo di ricerca**, cioè il tempo necessario per spostare la testina sulla traccia corretta;
> - **latenza di rotazione**, cioè il tempo necessario affinché il settore desiderato passi sotto la testina;
> - **tempo di trasferimento**, cioè il tempo necessario per leggere o scrivere i dati una volta raggiunta la posizione corretta.
>
> I primi due tempi sono dovuti alla natura meccanica del disco e sono molto più lenti rispetto ai tempi di accesso delle memorie elettroniche.

---

## 17. Che cos’è la latenza di rotazione di un disco magnetico?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **latenza di rotazione** è il tempo necessario affinché il settore desiderato arrivi sotto la testina di lettura/scrittura.
>
> Dopo che la testina si è posizionata sulla traccia corretta, il disco deve ruotare fino a portare il settore richiesto nella posizione giusta.
>
> In media, si considera come latenza di rotazione metà del tempo necessario per una rotazione completa del disco.
>
> Ad esempio, se un disco ruota a 5400 giri al minuto, la latenza media di rotazione è circa 5,6 millisecondi.

---

## 18. Perché gli accessi sequenziali su disco sono più efficienti degli accessi casuali?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli accessi sequenziali sono più efficienti perché, una volta posizionata la testina sulla traccia corretta, è possibile leggere blocchi consecutivi con poco movimento aggiuntivo.
>
> Negli accessi casuali, invece, la testina deve spostarsi spesso su tracce diverse e bisogna attendere ogni volta la rotazione del disco.
>
> Questo rende gli accessi casuali molto più lenti.
>
> Per questo motivo i dischi magnetici funzionano meglio quando leggono o scrivono grandi blocchi di dati consecutivi.

---

## 19. Qual è il confronto tra dischi magnetici, memorie flash e DRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I dischi magnetici, le memorie flash e le DRAM hanno caratteristiche molto diverse.
>
> I **dischi magnetici** sono molto economici e offrono grandi capacità, ma sono lenti perché dipendono da componenti meccaniche.
>
> Le **memorie flash** sono più veloci dei dischi e non hanno parti mobili, ma sono più costose e hanno un limite nel numero di scritture.
>
> Le **DRAM** sono molto più veloci sia dei dischi sia delle flash, ma sono volatili e hanno un costo per bit maggiore.
>
> Per questo motivo:
>
> - la DRAM viene usata come memoria principale;
> - la flash viene usata per SSD e dispositivi mobili;
> - i dischi magnetici vengono usati per archiviazione economica e molto capiente.

---

## 20. Perché nella gerarchia di memoria non si usa una sola tecnologia?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Non si usa una sola tecnologia perché non esiste una memoria che sia contemporaneamente velocissima, molto capiente, economica e non volatile.
>
> Ogni tecnologia offre un compromesso diverso.
>
> La SRAM è molto veloce ma costosa, quindi viene usata nelle cache.  
> La DRAM è più economica e capiente, quindi viene usata come memoria principale.  
> La flash è non volatile e più veloce dei dischi, quindi viene usata negli SSD.  
> I dischi magnetici sono lenti ma molto economici e capienti, quindi sono adatti all’archiviazione di massa.
>
> La gerarchia di memoria nasce proprio per combinare queste tecnologie, cercando di offrire al processore l’illusione di una memoria grande, veloce ed economica.