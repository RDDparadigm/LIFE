
# Capitolo 4.1 — Introduzione all’implementazione del processore RISC-V

## Metodo di ripasso

Usa queste flashcard in tre passaggi:

1. **Primo giro:** leggi la domanda e prova a rispondere a voce senza aprire il callout.
2. **Controllo:** apri la risposta e confronta quello che hai detto.
3. **Aggiornamento stato:** cambia lo stato in base a quanto eri sicuro:
   - 🔴 non la so / risposta confusa
   - 🟡 la so ma con esitazioni
   - 🟢 la so bene

Nel campo **Ultimo ripasso** puoi scrivere la data, per esempio `2026-05-26`.  
Nel campo **Note mie** puoi aggiungere dubbi, esempi o collegamenti con esercizi.

---

## 1. Da quali fattori dipendono le prestazioni di un calcolatore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le prestazioni di un calcolatore dipendono principalmente da tre fattori:
>
> 1. numero di istruzioni eseguite dal programma;
> 2. durata del ciclo di clock;
> 3. numero medio di cicli di clock per istruzione, cioè il CPI.
>
> In forma sintetica:
>
> `Tempo CPU = numero istruzioni × CPI × tempo di ciclo di clock`
>
> Il compilatore e l’architettura dell’insieme di istruzioni influenzano soprattutto il numero di istruzioni. L’implementazione del processore influenza invece sia il ciclo di clock sia il CPI.

---

## 2. Che cosa si intende per implementazione di un processore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’implementazione di un processore è il modo concreto in cui una certa architettura viene realizzata a livello hardware.
>
> Riguarda principalmente:
>
> - il datapath, cioè il percorso dei dati;
> - l’unità di controllo, che genera i segnali necessari;
> - il modo in cui le istruzioni vengono prelevate, decodificate ed eseguite;
> - eventuali tecniche come la pipeline.
>
> L’ISA descrive “che cosa” il processore deve fare; l’implementazione descrive “come” viene fatto fisicamente.

---

## 3. Che cos’è il datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il datapath è l’insieme delle unità hardware attraversate dai dati durante l’esecuzione delle istruzioni.
>
> Comprende, per esempio:
>
> - Program Counter;
> - memoria istruzioni;
> - banco dei registri;
> - ALU;
> - memoria dati;
> - sommatori;
> - multiplexer;
> - collegamenti tra le varie unità.
>
> Il datapath permette quindi di far circolare operandi, indirizzi, risultati e istruzioni all’interno del processore.

---

## 4. Che cos’è l’unità di controllo di un processore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità di controllo è la parte del processore che decide come usare il datapath in base all’istruzione corrente.
>
> Riceve informazioni dall’istruzione, come opcode e campi funzionali, e genera segnali di controllo.
>
> Per esempio decide:
>
> - quale operazione deve eseguire l’ALU;
> - se scrivere nel banco registri;
> - se leggere o scrivere nella memoria dati;
> - quale ingresso scegliere nei multiplexer;
> - come aggiornare il Program Counter.
>
> In sintesi, il datapath contiene gli strumenti, mentre l’unità di controllo decide come usarli.

---

## 5. Quale sottoinsieme di istruzioni RISC-V viene usato per introdurre l’implementazione di base?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il libro considera un sottoinsieme semplice ma rappresentativo di istruzioni RISC-V:
>
> - istruzioni di accesso alla memoria:
>   - `lw`, load word;
>   - `sw`, store word;
> - istruzioni aritmetico-logiche:
>   - `add`;
>   - `sub`;
>   - `and`;
>   - `or`;
> - istruzione di salto condizionato:
>   - `beq`, branch if equal.
>
> Questo sottoinsieme non contiene tutte le istruzioni RISC-V, ma è sufficiente per mostrare i principi fondamentali del datapath e dell’unità di controllo.

---

## 6. Perché si studia inizialmente solo un sottoinsieme delle istruzioni RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Si studia inizialmente solo un sottoinsieme di istruzioni perché permette di capire i principi fondamentali dell’implementazione senza introdurre subito tutta la complessità del processore.
>
> Le istruzioni scelte permettono di vedere:
>
> - operazioni tra registri;
> - accessi alla memoria;
> - aggiornamento del Program Counter;
> - salti condizionati;
> - uso dell’ALU;
> - uso dei multiplexer;
> - generazione dei segnali di controllo.
>
> Una volta capito questo schema di base, le altre istruzioni possono essere viste come estensioni.

---

## 7. Quali sono le prime due fasi comuni a tutte le istruzioni nell’implementazione base RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le prime due fasi comuni sono:
>
> 1. instruction fetch;
> 2. lettura dei registri.
>
> Nell’instruction fetch il contenuto del Program Counter viene inviato alla memoria istruzioni per leggere l’istruzione corrente.
>
> Poi l’istruzione viene usata per selezionare i registri sorgente nel banco registri.
>
> Dopo queste due fasi, il comportamento dipende dal tipo di istruzione.

---

## 8. Che cosa si intende per instruction fetch?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’instruction fetch è la fase in cui il processore preleva dalla memoria istruzioni l’istruzione da eseguire.
>
> Il Program Counter contiene l’indirizzo dell’istruzione corrente. Questo indirizzo viene mandato alla memoria istruzioni, che restituisce il codice binario dell’istruzione.
>
> Normalmente il PC viene poi aggiornato a:
>
> `PC + 4`
>
> perché le istruzioni RISC-V considerate sono lunghe 32 bit, cioè 4 byte.

---

## 9. Si descriva il ciclo di aggiornamento del Program Counter.

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il Program Counter contiene l’indirizzo dell’istruzione da eseguire.
>
> Nel normale flusso sequenziale, dopo il fetch dell’istruzione, il PC viene aggiornato a:
>
> `PC + 4`
>
> perché ogni istruzione considerata occupa 4 byte.
>
> Nel caso di un salto condizionato, come `beq`, il nuovo valore del PC può invece essere l’indirizzo di destinazione del salto.
>
> Quindi il processore deve scegliere tra:
>
> - `PC + 4`, se il salto non viene preso;
> - indirizzo di branch, se il salto viene preso.
>
> Questa scelta viene fatta tramite un multiplexer controllato dalla logica di controllo e dal risultato del confronto tra i registri.

---

## 10. Perché nell’implementazione del PC serve un multiplexer?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Serve un multiplexer perché il prossimo valore del PC può provenire da sorgenti diverse.
>
> Nel caso normale, il prossimo PC è:
>
> `PC + 4`
>
> Nel caso di un salto condizionato preso, invece, il prossimo PC è l’indirizzo di destinazione del branch.
>
> Il multiplexer seleziona quale valore caricare nel PC:
>
> - il valore sequenziale `PC + 4`;
> - oppure l’indirizzo calcolato per il salto.
>
> La selezione dipende dal segnale di controllo relativo al branch e dal risultato prodotto dall’ALU, per esempio il segnale `Zero`.

---

## 11. Qual è il ruolo dell’ALU nell’implementazione base RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’ALU viene usata in quasi tutte le istruzioni considerate.
>
> Per le istruzioni aritmetico-logiche, come `add`, `sub`, `and` e `or`, l’ALU esegue direttamente l’operazione richiesta sui valori letti dai registri.
>
> Per le istruzioni di accesso alla memoria, come `lw` e `sw`, l’ALU calcola l’indirizzo effettivo sommando il contenuto del registro base e l’immediato esteso di segno.
>
> Per le istruzioni di salto condizionato, come `beq`, l’ALU può confrontare due registri, tipicamente sottraendoli, per verificare se sono uguali.

---

## 12. Come viene eseguita una istruzione aritmetico-logica nell’implementazione base?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una istruzione aritmetico-logica, per esempio `add x1, x2, x3`, viene eseguita così:
>
> 1. il PC fornisce l’indirizzo dell’istruzione alla memoria istruzioni;
> 2. l’istruzione viene letta;
> 3. il banco registri legge i due registri sorgente, per esempio `x2` e `x3`;
> 4. l’ALU esegue l’operazione richiesta;
> 5. il risultato dell’ALU viene scritto nel registro destinazione, per esempio `x1`;
> 6. il PC viene aggiornato a `PC + 4`.
>
> In questo caso non viene usata la memoria dati.

---

## 13. Come viene eseguita una istruzione `lw` nell’implementazione base RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una istruzione `lw` carica una parola dalla memoria dati in un registro.
>
> L’esecuzione avviene così:
>
> 1. si preleva l’istruzione dalla memoria istruzioni;
> 2. si legge dal banco registri il registro base;
> 3. l’immediato viene esteso di segno;
> 4. l’ALU somma il registro base e l’immediato, calcolando l’indirizzo effettivo;
> 5. la memoria dati viene letta a quell’indirizzo;
> 6. il dato letto dalla memoria viene scritto nel registro destinazione;
> 7. il PC viene aggiornato a `PC + 4`.
>
> In `lw`, l’ALU serve quindi a calcolare l’indirizzo di memoria.

---

## 14. Come viene eseguita una istruzione `sw` nell’implementazione base RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una istruzione `sw` salva in memoria il contenuto di un registro.
>
> L’esecuzione avviene così:
>
> 1. si preleva l’istruzione dalla memoria istruzioni;
> 2. si leggono dal banco registri il registro base e il registro contenente il dato da scrivere;
> 3. l’immediato viene esteso di segno;
> 4. l’ALU somma registro base e immediato, calcolando l’indirizzo effettivo;
> 5. la memoria dati scrive il valore del registro sorgente all’indirizzo calcolato;
> 6. il PC viene aggiornato a `PC + 4`.
>
> In questo caso non viene scritto nessun registro del banco registri.

---

## 15. Come viene eseguita una istruzione `beq` nell’implementazione base RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’istruzione `beq` confronta due registri e, se sono uguali, modifica il flusso di esecuzione.
>
> Esempio:
>
> `beq x11, x12, LABEL`
>
> L’esecuzione avviene così:
>
> 1. si preleva l’istruzione dalla memoria istruzioni;
> 2. si leggono i registri `x11` e `x12`;
> 3. l’ALU confronta i due valori, tipicamente tramite una sottrazione;
> 4. se il risultato è zero, i due registri sono uguali;
> 5. viene calcolato l’indirizzo di destinazione del salto;
> 6. il PC viene aggiornato a `LABEL`, se il branch è preso, oppure a `PC + 4`, se il branch non è preso.
>
> Il segnale `Zero` prodotto dall’ALU viene usato insieme al segnale `Branch` per decidere se saltare oppure no.

---

## 16. Perché per implementare `beq` si può usare una sottrazione tra i due registri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Perché due valori sono uguali se la loro differenza è zero.
>
> Per esempio, in:
>
> `beq x11, x12, LABEL`
>
> l’ALU può calcolare:
>
> `x11 - x12`
>
> Se il risultato è zero, allora `x11` e `x12` contengono lo stesso valore. In questo caso l’ALU attiva il segnale `Zero`, che indica alla logica di controllo che la condizione del branch è vera.
>
> Se invece il risultato non è zero, i registri sono diversi e il salto non viene preso.

---

## 17. Qual è il ruolo del segnale `Zero` prodotto dall’ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `Zero` indica che il risultato prodotto dall’ALU è uguale a zero.
>
> È particolarmente importante per le istruzioni di salto condizionato, come `beq`.
>
> Nel caso di `beq`, l’ALU sottrae i due operandi. Se il risultato è zero, allora i due registri sono uguali e `Zero` viene attivato.
>
> La decisione finale di saltare viene presa combinando:
>
> - il segnale `Branch`, generato dall’unità di controllo;
> - il segnale `Zero`, generato dall’ALU.
>
> Se entrambi indicano che il salto va eseguito, il PC viene caricato con l’indirizzo di branch.

---

## 18. A cosa servono i multiplexer nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I multiplexer servono a scegliere tra più possibili sorgenti di dati.
>
> Nel datapath base RISC-V sono necessari perché diversi tipi di istruzione usano gli stessi componenti hardware in modi diversi.
>
> Per esempio, un multiplexer può scegliere:
>
> - se il secondo operando dell’ALU arriva da un registro oppure da un immediato;
> - se il dato da scrivere nel registro arriva dall’ALU oppure dalla memoria dati;
> - se il nuovo valore del PC è `PC + 4` oppure l’indirizzo di branch.
>
> Senza multiplexer bisognerebbe duplicare molte unità hardware, rendendo il processore più complesso.

---

## 19. Perché il secondo ingresso dell’ALU deve poter provenire sia da un registro sia da un immediato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Perché istruzioni diverse richiedono sorgenti diverse per gli operandi dell’ALU.
>
> Nelle istruzioni aritmetico-logiche tra registri, come:
>
> `add x1, x2, x3`
>
> il secondo operando dell’ALU proviene da un registro.
>
> Nelle istruzioni di memoria, come:
>
> `lw x1, 8(x2)`
>
> il secondo operando dell’ALU è invece un immediato, usato come offset da sommare al registro base.
>
> Per questo serve un multiplexer controllato da un segnale, spesso chiamato `ALUSrc`.

---

## 20. A cosa serve l’estensione del segno nell’implementazione di istruzioni come `lw`, `sw` e `beq`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’estensione del segno serve a portare l’immediato contenuto nell’istruzione alla dimensione del datapath, cioè 32 bit, mantenendone il valore e il segno.
>
> È necessaria perché istruzioni come `lw`, `sw` e `beq` usano immediati più corti, per esempio offset a 12 bit, ma l’ALU opera su valori a 32 bit.
>
> Con `lw` e `sw`, l’immediato viene sommato al registro base per calcolare l’indirizzo effettivo.
>
> Con `beq`, l’immediato viene usato per calcolare l’indirizzo di salto.
>
> Poiché questi offset possono essere positivi o negativi, bisogna estendere il bit di segno e non semplicemente aggiungere zeri.
>
> Se il bit più significativo dell’immediato è `0`, vengono aggiunti zeri.  
> Se il bit più significativo è `1`, vengono aggiunti uni.

---

## 21. Perché nelle istruzioni `lw` e `sw` l’ALU viene usata per calcolare un indirizzo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nelle istruzioni `lw` e `sw`, l’indirizzo effettivo di memoria è dato dalla somma tra:
>
> - il contenuto di un registro base;
> - un offset immediato contenuto nell’istruzione.
>
> Per esempio:
>
> `lw x5, 12(x10)`
>
> significa che l’indirizzo di memoria è:
>
> `x10 + 12`
>
> Questa somma viene fatta dall’ALU. Il risultato viene mandato alla memoria dati come indirizzo da cui leggere o in cui scrivere.

---

## 22. Quali sono le differenze principali tra l’esecuzione di `lw` e `sw` nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `lw` e `sw` usano entrambe l’ALU per calcolare l’indirizzo effettivo, ma differiscono nel verso del trasferimento dati.
>
> Per `lw`:
>
> - si legge dalla memoria dati;
> - il dato letto viene scritto in un registro;
> - quindi `MemRead` e `RegWrite` sono attivi.
>
> Per `sw`:
>
> - si legge dal registro il dato da salvare;
> - si scrive quel dato nella memoria dati;
> - quindi `MemWrite` è attivo;
> - `RegWrite` non è attivo.
>
> In sintesi, `lw` porta dati dalla memoria al registro, mentre `sw` porta dati dal registro alla memoria.

---

## 23. Quali segnali di controllo compaiono nello schema base del datapath RISC-V e a cosa servono?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nello schema base compaiono segnali di controllo come:
>
> - `RegWrite`: abilita la scrittura nel banco registri;
> - `MemRead`: abilita la lettura dalla memoria dati;
> - `MemWrite`: abilita la scrittura nella memoria dati;
> - `Branch`: indica che l’istruzione è un salto condizionato;
> - controllo del multiplexer verso l’ALU: sceglie tra registro e immediato;
> - controllo del multiplexer verso il registro destinazione: sceglie tra risultato ALU e dato letto dalla memoria;
> - controllo del PC: sceglie tra `PC + 4` e indirizzo di branch;
> - controllo dell’ALU: stabilisce quale operazione deve eseguire l’ALU.
>
> Questi segnali sono generati dall’unità di controllo sulla base dell’istruzione corrente.

---

## 24. A cosa serve il segnale `RegWrite`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `RegWrite` abilita la scrittura nel banco dei registri.
>
> È attivo per le istruzioni che producono un risultato da salvare in un registro, per esempio:
>
> - `add`;
> - `sub`;
> - `and`;
> - `or`;
> - `lw`.
>
> Non è invece attivo per istruzioni come:
>
> - `sw`, perché scrive in memoria e non in un registro;
> - `beq`, perché modifica eventualmente il PC ma non scrive nel banco registri.

---

## 25. A cosa servono i segnali `MemRead` e `MemWrite`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `MemRead` e `MemWrite` controllano la memoria dati.
>
> `MemRead` abilita la lettura dalla memoria dati. È usato, per esempio, da `lw`.
>
> `MemWrite` abilita la scrittura nella memoria dati. È usato, per esempio, da `sw`.
>
> Le istruzioni aritmetico-logiche e `beq` normalmente non attivano né `MemRead` né `MemWrite`, perché non accedono alla memoria dati.

---

## 26. Perché la memoria istruzioni e la memoria dati sono rappresentate come due blocchi distinti nello schema?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Sono rappresentate come due blocchi distinti per semplificare il datapath e mostrare chiaramente due funzioni diverse:
>
> - la memoria istruzioni serve a leggere l’istruzione da eseguire;
> - la memoria dati serve a leggere o scrivere dati durante istruzioni come `lw` e `sw`.
>
> Questa separazione rende più semplice rappresentare l’esecuzione in un singolo ciclo, perché il processore può prelevare l’istruzione e accedere ai dati senza conflitti strutturali nello schema.

---

## 27. Quali componenti hardware sono necessari per eseguire il fetch di un’istruzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per eseguire il fetch servono principalmente:
>
> - il Program Counter, che contiene l’indirizzo dell’istruzione corrente;
> - la memoria istruzioni, che restituisce l’istruzione memorizzata a quell’indirizzo;
> - un sommatore, che calcola `PC + 4`;
> - un collegamento per aggiornare il PC con l’indirizzo della prossima istruzione.
>
> Se sono presenti salti condizionati, serve anche un multiplexer per scegliere tra `PC + 4` e l’indirizzo di salto.

---

## 28. Perché il PC viene incrementato di 4?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il PC viene incrementato di 4 perché le istruzioni RISC-V considerate sono lunghe 32 bit, cioè 4 byte.
>
> Dato che la memoria è indirizzata a byte, l’istruzione successiva si trova normalmente 4 byte dopo quella corrente.
>
> Quindi, se l’istruzione corrente si trova all’indirizzo `PC`, quella successiva si trova all’indirizzo:
>
> `PC + 4`

---

## 29. Qual è la differenza tra il dato scritto nel registro per una istruzione aritmetico-logica e per una `lw`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una istruzione aritmetico-logica, il dato scritto nel registro destinazione proviene dall’ALU.
>
> Per esempio:
>
> `add x1, x2, x3`
>
> scrive in `x1` il risultato della somma prodotta dall’ALU.
>
> In una istruzione `lw`, invece, il dato scritto nel registro destinazione proviene dalla memoria dati.
>
> Per esempio:
>
> `lw x1, 8(x2)`
>
> l’ALU calcola l’indirizzo `x2 + 8`, ma il valore scritto in `x1` è il contenuto letto dalla memoria a quell’indirizzo.
>
> Per scegliere tra queste due sorgenti serve un multiplexer.

---

## 30. Perché l’unità di controllo deve conoscere il tipo di istruzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità di controllo deve conoscere il tipo di istruzione perché istruzioni diverse usano il datapath in modi diversi.
>
> Per esempio:
>
> - `add` deve leggere due registri, usare l’ALU e scrivere il risultato in un registro;
> - `lw` deve calcolare un indirizzo, leggere la memoria e scrivere nel registro;
> - `sw` deve calcolare un indirizzo e scrivere in memoria;
> - `beq` deve confrontare due registri e forse modificare il PC.
>
> Per ottenere questi comportamenti, l’unità di controllo genera segnali diversi a seconda dell’opcode e degli altri campi dell’istruzione.

---

## 31. Che cosa significa che molte unità funzionali sono condivise tra istruzioni diverse?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Significa che lo stesso componente hardware viene usato per compiti diversi a seconda dell’istruzione.
>
> Per esempio, l’ALU può essere usata:
>
> - per sommare due registri in una `add`;
> - per sottrarre due registri in una `sub`;
> - per calcolare un indirizzo in una `lw` o `sw`;
> - per confrontare due registri in una `beq`.
>
> Questa condivisione riduce la quantità di hardware necessario, ma richiede multiplexer e segnali di controllo per selezionare il corretto flusso dei dati.

---

## 32. Perché la semplicità e regolarità dell’ISA RISC-V facilita l’implementazione del processore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La semplicità e regolarità di RISC-V facilitano l’implementazione perché rendono più prevedibile il formato delle istruzioni e l’uso delle unità hardware.
>
> Per esempio:
>
> - molte istruzioni usano un numero limitato di formati;
> - le operazioni aritmetiche lavorano sui registri;
> - gli accessi alla memoria sono separati dalle operazioni aritmetiche;
> - il PC avanza normalmente di 4;
> - i campi dell’istruzione permettono di individuare registri, immediati e opcode in modo regolare.
>
> Questo rende più semplice progettare datapath e unità di controllo.

---

## 33. Che cosa succede in generale dopo le prime fasi comuni di fetch e lettura dei registri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Dopo il fetch e la lettura dei registri, il comportamento dipende dalla classe dell’istruzione.
>
> Per le istruzioni aritmetico-logiche:
>
> - l’ALU esegue l’operazione;
> - il risultato viene scritto nel registro destinazione.
>
> Per `lw`:
>
> - l’ALU calcola l’indirizzo;
> - la memoria dati viene letta;
> - il dato letto viene scritto nel registro.
>
> Per `sw`:
>
> - l’ALU calcola l’indirizzo;
> - la memoria dati viene scritta.
>
> Per `beq`:
>
> - l’ALU confronta i due registri;
> - se la condizione è vera, il PC viene aggiornato con l’indirizzo di salto.

---

## 34. Si spieghi come deve essere configurato il datapath per eseguire `beq x11, x12, LABEL`.

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per eseguire:
>
> `beq x11, x12, LABEL`
>
> il datapath deve essere configurato così:
>
> 1. il PC manda l’indirizzo alla memoria istruzioni;
> 2. la memoria istruzioni restituisce la codifica della `beq`;
> 3. il banco registri legge `x11` e `x12`;
> 4. l’ALU riceve i due valori letti dai registri;
> 5. l’ALU esegue una sottrazione;
> 6. se il risultato è zero, il segnale `Zero` viene attivato;
> 7. in parallelo viene calcolato l’indirizzo di destinazione del salto usando l’immediato dell’istruzione;
> 8. la logica di controllo attiva il segnale `Branch`;
> 9. se `Branch` e `Zero` sono entrambi veri, il multiplexer del PC seleziona l’indirizzo di `LABEL`;
> 10. altrimenti seleziona `PC + 4`.
>
> In questa istruzione non vengono scritti né registri né memoria dati.

---

## 35. Qual è l’idea principale della Figura 4.1?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La Figura 4.1 mostra uno schema astratto del datapath RISC-V, evidenziando le principali unità funzionali e le connessioni tra esse.
>
> Mostra che l’esecuzione di un’istruzione coinvolge:
>
> - PC;
> - memoria istruzioni;
> - banco registri;
> - ALU;
> - memoria dati;
> - sommatori per `PC + 4` e indirizzi di salto;
> - collegamenti tra le varie unità.
>
> La figura è astratta perché non mostra ancora tutti i multiplexer e tutti i segnali di controllo, ma serve a capire il flusso generale dei dati.

---

## 36. Qual è l’idea principale della Figura 4.2?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La Figura 4.2 mostra una versione più completa del datapath base RISC-V, includendo anche:
>
> - multiplexer;
> - segnali di controllo;
> - unità di controllo;
> - segnali come `RegWrite`, `MemRead`, `MemWrite`, `Branch`;
> - segnale `Zero` dell’ALU.
>
> Questa figura spiega non solo quali unità hardware servono, ma anche come vengono controllate per eseguire istruzioni diverse.

---

## 37. Che differenza c’è tra la Figura 4.1 e la Figura 4.2?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La Figura 4.1 mostra una panoramica astratta del datapath, concentrandosi sulle principali unità funzionali e sulle connessioni generali.
>
> La Figura 4.2 aggiunge dettagli più concreti, come:
>
> - multiplexer;
> - linee di controllo;
> - unità di controllo;
> - segnali per memoria, registri, ALU e branch.
>
> Quindi la Figura 4.1 serve a capire il flusso generale dei dati, mentre la Figura 4.2 mostra come quel flusso viene effettivamente selezionato e controllato.

---

## 38. Perché il datapath deve essere controllato da segnali prodotti dall’unità di controllo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il datapath contiene molte possibili strade per i dati, ma per ogni istruzione ne deve essere scelta solo una configurazione corretta.
>
> I segnali di controllo servono a stabilire:
>
> - quali registri leggere;
> - se scrivere o no nel banco registri;
> - quale operazione deve fare l’ALU;
> - se usare un immediato o un registro come operando;
> - se leggere o scrivere la memoria dati;
> - quale valore assegnare al PC.
>
> Senza questi segnali, il datapath non saprebbe quale comportamento assumere per l’istruzione corrente.

---

## 39. Quali sono le tre grandi classi di istruzioni considerate nello schema base?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le tre grandi classi considerate sono:
>
> 1. istruzioni aritmetico-logiche, come `add`, `sub`, `and`, `or`;
> 2. istruzioni di accesso alla memoria, come `lw` e `sw`;
> 3. istruzioni di salto condizionato, come `beq`.
>
> Queste tre classi permettono di mostrare i principali comportamenti del datapath: calcolo, accesso alla memoria e modifica del flusso di controllo.

---

## 40. Perché l’implementazione completa di tutte le istruzioni è più complessa di quella mostrata nel §4.1?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’implementazione mostrata nel §4.1 riguarda solo un sottoinsieme di istruzioni RISC-V.
>
> Un’implementazione completa deve gestire molte altre istruzioni, per esempio:
>
> - altri tipi di salti;
> - altre istruzioni con immediati;
> - operazioni su tipi diversi;
> - eccezioni;
> - dettagli della pipeline;
> - eventuali ottimizzazioni prestazionali.
>
> Per questo il libro parte da un datapath semplice e poi aggiunge progressivamente dettagli.

---

## 41. In che modo l’implementazione del processore influenza ciclo di clock e CPI?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’implementazione influenza il ciclo di clock perché la durata del clock dipende dal ritardo delle unità hardware attraversate dai dati.
>
> Se il datapath è complesso o se un’istruzione deve attraversare molte unità nello stesso ciclo, il ciclo di clock deve essere abbastanza lungo da permettere il completamento dell’operazione più lenta.
>
> L’implementazione influenza anche il CPI perché stabilisce quante istruzioni possono essere completate in un certo numero di cicli.
>
> Per esempio:
>
> - in una implementazione a singolo ciclo, ogni istruzione può avere CPI circa pari a 1, ma con ciclo di clock lungo;
> - in una implementazione multi-ciclo o pipeline, il ciclo di clock può essere più corto, ma il CPI dipende dall’organizzazione scelta.

---

## 42. Perché il pipelining viene introdotto dopo aver studiato il datapath di base?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il pipelining viene introdotto dopo il datapath di base perché prima bisogna capire quali sono le fasi fondamentali di esecuzione di un’istruzione.
>
> Il datapath base mostra come un’istruzione viene:
>
> - prelevata;
> - decodificata;
> - eseguita;
> - eventualmente mandata alla memoria;
> - eventualmente scritta nel registro destinazione.
>
> Il pipelining sfrutta proprio queste fasi, sovrapponendo l’esecuzione di più istruzioni per migliorare le prestazioni.
>
> Quindi il datapath semplice è il punto di partenza concettuale per capire la pipeline.

---

## 43. Descrivere l’esecuzione generale di un’istruzione nel datapath RISC-V base.

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In generale, l’esecuzione di un’istruzione nel datapath RISC-V base avviene così:
>
> 1. il PC fornisce l’indirizzo alla memoria istruzioni;
> 2. la memoria istruzioni restituisce l’istruzione;
> 3. l’istruzione viene decodificata;
> 4. il banco registri legge i registri sorgente;
> 5. l’ALU esegue un’operazione, che può essere un calcolo aritmetico-logico, un calcolo di indirizzo o un confronto;
> 6. a seconda dell’istruzione, si può accedere alla memoria dati;
> 7. a seconda dell’istruzione, si può scrivere un risultato nel banco registri;
> 8. il PC viene aggiornato a `PC + 4` oppure all’indirizzo di branch.
>
> Il comportamento specifico dipende dai segnali generati dall’unità di controllo.

---

## 44. Qual è la differenza tra architettura dell’insieme di istruzioni e implementazione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’architettura dell’insieme di istruzioni, cioè l’ISA, definisce il comportamento visibile al programmatore.
>
> Specifica, per esempio:
>
> - quali istruzioni esistono;
> - quali registri sono disponibili;
> - quali formati hanno le istruzioni;
> - come funzionano le operazioni;
> - come vengono interpretati gli indirizzi.
>
> L’implementazione, invece, descrive come quell’ISA viene realizzata fisicamente nell’hardware.
>
> Due processori possono avere la stessa ISA RISC-V, quindi eseguire gli stessi programmi, ma avere implementazioni diverse, con prestazioni diverse.

---

## 45. Perché un processore RISC-V può avere prestazioni diverse pur eseguendo la stessa ISA?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Perché l’ISA definisce quali istruzioni esistono e cosa devono fare, ma non impone un’unica implementazione hardware.
>
> Due processori RISC-V possono differire per:
>
> - durata del ciclo di clock;
> - organizzazione del datapath;
> - presenza o assenza di pipeline;
> - gestione della memoria;
> - numero di stadi della pipeline;
> - ottimizzazioni interne.
>
> Di conseguenza, possono eseguire lo stesso codice macchina ma con prestazioni diverse.