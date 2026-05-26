# Unità di controllo della ALU e unità di controllo principale

## Metodo di ripasso

Ripassa queste flashcard in modalità attiva: leggi solo la domanda, prova a rispondere oralmente come se fossi all’esame, poi apri il callout e confronta la tua risposta. Concentrati soprattutto su tre collegamenti: quale operazione deve fare la ALU, quali segnali di controllo vengono generati e come cambia il comportamento tra istruzioni di tipo R, `lw`, `sw` e `beq`.

---

## 1. Qual è il ruolo dell’unità di controllo della ALU in un processore RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità di controllo della ALU ha il compito di decidere quale operazione deve eseguire concretamente la ALU durante l’esecuzione di un’istruzione.
>
> La ALU, infatti, non interpreta direttamente tutta l’istruzione RISC-V. Essa riceve invece alcuni bit di controllo che le indicano se deve eseguire, per esempio, una somma, una sottrazione, un AND oppure un OR.
>
> Questa unità è quindi un livello intermedio tra l’unità di controllo principale e la ALU: riceve informazioni come `ALUOp` e alcuni campi funzionali dell’istruzione, e produce il codice di controllo effettivo da inviare alla ALU.

---

## 2. Quali operazioni fondamentali della ALU sono considerate nel datapath RISC-V semplificato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nel datapath RISC-V semplificato considerato, la ALU deve poter eseguire quattro operazioni fondamentali: AND, OR, somma e sottrazione.
>
> Queste operazioni sono sufficienti per implementare il sottoinsieme di istruzioni studiato: le istruzioni di load e store usano la somma per calcolare un indirizzo di memoria, l’istruzione `beq` usa la sottrazione per confrontare due registri, mentre le istruzioni di tipo R possono richiedere operazioni aritmetiche o logiche come `add`, `sub`, `and` e `or`.
>
> Ogni operazione viene selezionata tramite un codice di controllo della ALU, formato da 4 bit.

---

## 3. Perché le istruzioni `lw` e `sw` richiedono che la ALU esegua una somma?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni `lw` e `sw` devono calcolare un indirizzo effettivo di memoria. Questo indirizzo si ottiene sommando il contenuto di un registro base con un offset immediato contenuto nell’istruzione.
>
> Per esempio, in un’istruzione come `lw x1, offset(x2)`, il registro `x2` contiene l’indirizzo base, mentre `offset` indica lo spiazzamento rispetto a quell’indirizzo. La ALU somma questi due valori e produce l’indirizzo da usare per accedere alla memoria dati.
>
> Anche per `sw` il principio è lo stesso: la ALU calcola l’indirizzo in cui deve essere scritto il dato. Per questo motivo, sia `lw` sia `sw` impostano la ALU per eseguire una somma.

---

## 4. Perché l’istruzione `beq` richiede che la ALU esegua una sottrazione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’istruzione `beq` deve verificare se due registri contengono lo stesso valore. Per farlo, il datapath usa la ALU per sottrarre un operando dall’altro.
>
> Se i due valori sono uguali, la sottrazione produce zero. L’uscita `Zero` della ALU viene quindi attivata e può essere usata dalla logica di controllo del salto per decidere se il branch deve essere preso.
>
> La sottrazione, quindi, non serve perché interessa conservare il risultato aritmetico, ma perché permette di stabilire se i due registri confrontati sono uguali.

---

## 5. Che cos’è il segnale `ALUOp` e perché viene usato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `ALUOp` è un segnale di controllo a 2 bit generato dall’unità di controllo principale. Esso indica in modo generale quale tipo di operazione la ALU dovrà eseguire.
>
> Per esempio, per `lw` e `sw`, `ALUOp` indica che la ALU deve eseguire una somma; per `beq`, indica che la ALU deve eseguire una sottrazione; per le istruzioni di tipo R, indica invece che l’operazione non è determinata solo dal codice operativo, ma deve essere ricavata dai campi funzionali dell’istruzione.
>
> L’uso di `ALUOp` permette di semplificare la progettazione: l’unità di controllo principale non deve generare direttamente tutti i bit di controllo della ALU, ma può delegare parte della decisione all’unità di controllo della ALU.

---

## 6. Perché per le istruzioni di tipo R non basta sapere il codice operativo per decidere l’operazione della ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nelle istruzioni di tipo R, il codice operativo identifica la classe generale dell’istruzione, cioè il fatto che si tratta di un’istruzione aritmetico-logica tra registri. Tuttavia, non basta da solo a distinguere quale operazione specifica deve essere eseguita.
>
> Per distinguere, per esempio, tra `add`, `sub`, `and` e `or`, occorre considerare anche i campi funzionali dell’istruzione, in particolare `funct7` e `funct3`.
>
> Per questo motivo, quando `ALUOp` indica un’istruzione di tipo R, l’unità di controllo della ALU combina `ALUOp` con i campi funzionali per produrre il codice di controllo definitivo da inviare alla ALU.

---

## 7. Qual è la differenza tra unità di controllo principale e unità di controllo della ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità di controllo principale analizza il codice operativo dell’istruzione e genera i segnali di controllo generali del datapath, come `RegWrite`, `ALUSrc`, `MemRead`, `MemWrite`, `MemtoReg`, `Branch` e `ALUOp`.
>
> L’unità di controllo della ALU, invece, ha un compito più specifico: determinare quale operazione deve eseguire la ALU. Per farlo usa il segnale `ALUOp` prodotto dall’unità di controllo principale e, quando serve, i campi funzionali dell’istruzione.
>
> Quindi l’unità di controllo principale decide il comportamento complessivo del datapath, mentre l’unità di controllo della ALU decide l’operazione interna della ALU.

---

## 8. Perché la progettazione usa più livelli di controllo invece di una sola unità che genera direttamente tutti i segnali?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’uso di più livelli di controllo serve a rendere più semplice e modulare la progettazione del processore.
>
> Invece di costruire un’unica grande unità di controllo che genera direttamente tutti i segnali, si divide il problema in parti più piccole. L’unità di controllo principale genera segnali generali a partire dal codice operativo, mentre l’unità di controllo della ALU si occupa solo di scegliere l’operazione della ALU.
>
> Questa tecnica può ridurre la complessità della logica e, in alcuni casi, anche la latenza, perché ogni unità di controllo è più piccola e specializzata.

---

## 9. Che cosa sono i termini indifferenti nella progettazione della logica di controllo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I termini indifferenti, spesso indicati con `X`, sono valori di ingresso o di uscita che non influenzano il comportamento corretto del circuito in un certo caso.
>
> Per esempio, se per una certa istruzione alcuni campi dell’istruzione non servono a determinare l’operazione della ALU, quei bit possono essere considerati indifferenti. Significa che possono valere 0 oppure 1 senza cambiare il risultato utile.
>
> I termini indifferenti sono importanti perché permettono di semplificare la tabella della verità e quindi la logica combinatoria da realizzare. In pratica, aiutano a costruire circuiti più semplici ed efficienti.

---

## 10. Quali informazioni dell’istruzione vengono usate per progettare l’unità di controllo principale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per progettare l’unità di controllo principale si parte dai campi dell’istruzione che identificano la classe dell’istruzione e i registri coinvolti.
>
> Il campo più importante è il codice operativo, o opcode, contenuto nei bit meno significativi dell’istruzione. Esso identifica il tipo generale di istruzione, per esempio tipo R, load, store o branch condizionato.
>
> Altri campi indicano i registri sorgente e destinazione o parti dell’immediato. Tuttavia, per generare molti segnali principali di controllo, il campo più importante è l’opcode, perché permette di capire quale percorso del datapath dovrà essere attivato.

---

## 11. Quali sono i principali formati di istruzione RISC-V citati in questa parte del capitolo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I principali formati di istruzione RISC-V citati sono il formato R, il formato I, il formato S, il formato SB, il formato UJ e il formato U.
>
> Il formato R è usato per istruzioni aritmetico-logiche tra registri. Il formato I è usato, tra le altre cose, per le istruzioni di load e per operazioni con immediato. Il formato S è usato per le istruzioni di store. Il formato SB è usato per i salti condizionati, come `beq`. Il formato UJ è usato per salti incondizionati, mentre il formato U è usato per istruzioni che caricano immediati di dimensione più grande.
>
> Questi formati sono importanti perché stabiliscono dove si trovano, dentro i 32 bit dell’istruzione, campi come registri, opcode, `funct3`, `funct7` e immediati.

---

## 12. Perché i campi immediati non sono sempre contigui nei vari formati RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei formati RISC-V, i bit dell’immediato non sono sempre contigui perché l’architettura cerca di mantenere alcuni campi, come `opcode`, `rs1`, `rs2`, `rd` e `funct3`, nelle stesse posizioni quando possibile.
>
> Questa scelta semplifica la progettazione hardware, perché i registri sorgente e destinazione possono essere letti da posizioni fisse dell’istruzione, indipendentemente dal formato.
>
> Di conseguenza, in alcuni formati, come S, SB o UJ, l’immediato viene spezzato in più parti e poi ricostruito dall’unità che genera la costante. Questa scelta rende il formato meno intuitivo, ma semplifica alcune parti critiche del datapath.

---

## 13. A cosa serve l’unità “Genera cost” nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità “Genera cost” serve a costruire il valore immediato, cioè la costante, a partire dai bit contenuti nell’istruzione.
>
> Poiché i vari formati RISC-V collocano i bit dell’immediato in posizioni diverse, questa unità deve selezionare, riordinare ed estendere correttamente tali bit per produrre una costante utilizzabile dal datapath.
>
> Il valore generato può poi essere usato, per esempio, come offset nelle istruzioni `lw` e `sw`, oppure come offset di salto nelle istruzioni di branch.

---

## 14. Qual è il ruolo del segnale `ALUSrc`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `ALUSrc` controlla il multiplexer che sceglie il secondo operando della ALU.
>
> Se `ALUSrc` non è asserito, il secondo operando della ALU proviene dal secondo dato letto dal registro file, cioè dal registro `rs2`. Questo è il caso tipico delle istruzioni di tipo R e di `beq`, che confronta due registri.
>
> Se invece `ALUSrc` è asserito, il secondo operando della ALU proviene dall’immediato esteso generato a partire dall’istruzione. Questo accade nelle istruzioni `lw` e `sw`, dove la ALU deve sommare un registro base e un offset.

---

## 15. Qual è il ruolo del segnale `RegWrite`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `RegWrite` abilita la scrittura nel registro file.
>
> Quando `RegWrite` è asserito, il valore selezionato per la scrittura viene scritto nel registro destinazione indicato dall’istruzione. Questo accade, per esempio, nelle istruzioni di tipo R, che scrivono nel registro destinazione il risultato prodotto dalla ALU, e nelle istruzioni `lw`, che scrivono nel registro destinazione il dato letto dalla memoria.
>
> Quando `RegWrite` non è asserito, nessun registro viene modificato. Questo è il caso di istruzioni come `sw`, che scrive in memoria, e `beq`, che modifica eventualmente il PC ma non scrive nel registro file.

---

## 16. Qual è la funzione dei segnali `MemRead` e `MemWrite`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I segnali `MemRead` e `MemWrite` controllano l’accesso alla memoria dati.
>
> `MemRead` viene asserito quando il processore deve leggere un dato dalla memoria. Questo accade nelle istruzioni di load, come `lw`, dove l’indirizzo di memoria è calcolato dalla ALU e il dato letto deve poi essere scritto in un registro.
>
> `MemWrite` viene invece asserito quando il processore deve scrivere un dato in memoria. Questo accade nelle istruzioni di store, come `sw`, dove la ALU calcola l’indirizzo di destinazione e il dato da scrivere proviene dal registro file.
>
> Normalmente, per una stessa istruzione, non ha senso asserire entrambi contemporaneamente nel datapath semplificato.

---

## 17. Qual è il ruolo del segnale `MemtoReg`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `MemtoReg` controlla il multiplexer che sceglie quale valore deve essere scritto nel registro file.
>
> Se `MemtoReg` non è asserito, nel registro destinazione viene scritto il risultato prodotto dalla ALU. Questo è il caso delle istruzioni di tipo R, come `add`, `sub`, `and` e `or`.
>
> Se `MemtoReg` è asserito, nel registro destinazione viene scritto il dato letto dalla memoria dati. Questo è il caso delle istruzioni `lw`.
>
> Per istruzioni che non scrivono nel registro file, come `sw` e `beq`, il valore di `MemtoReg` può essere considerato indifferente, perché `RegWrite` è disattivato.

---

## 18. Qual è il ruolo del segnale `Branch` e come contribuisce alla scelta del prossimo PC?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `Branch` indica che l’istruzione corrente è un salto condizionato, come `beq`.
>
> Tuttavia, il solo segnale `Branch` non basta per decidere se il salto deve essere preso. Bisogna anche sapere se la condizione del branch è vera. Nel caso di `beq`, questa informazione arriva dall’uscita `Zero` della ALU, che viene attivata se i due registri confrontati sono uguali.
>
> La logica di controllo del PC combina quindi `Branch` e `Zero`: se l’istruzione è una branch e il confronto dà esito positivo, il PC viene aggiornato con l’indirizzo di destinazione del salto; altrimenti viene caricato normalmente `PC + 4`.

---

## 19. Perché il segnale `PCSrc` dipende sia da `Branch` sia dall’uscita `Zero` della ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `PCSrc` determina quale valore deve essere scritto nel PC: il normale indirizzo sequenziale `PC + 4` oppure l’indirizzo di destinazione del salto.
>
> Per una `beq`, il salto deve essere preso solo se due condizioni sono vere: l’istruzione deve essere effettivamente una branch, e i due registri confrontati devono essere uguali. La prima informazione è rappresentata dal segnale `Branch`, mentre la seconda è rappresentata dall’uscita `Zero` della ALU.
>
> Per questo motivo, `PCSrc` viene ottenuto combinando `Branch` e `Zero`, tipicamente con una porta AND. Solo quando entrambi valgono 1, il PC viene aggiornato con l’indirizzo di branch.

---

## 20. Come si comporta il datapath durante l’esecuzione di un’istruzione di tipo R?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante l’esecuzione di un’istruzione di tipo R, il processore preleva l’istruzione dalla memoria istruzioni e incrementa il PC di 4 per puntare all’istruzione successiva.
>
> Successivamente legge dal registro file i due operandi indicati dai campi `rs1` e `rs2`. La ALU esegue l’operazione richiesta dall’istruzione, determinata combinando `ALUOp` con i campi funzionali come `funct3` e `funct7`.
>
> Il risultato prodotto dalla ALU viene poi scritto nel registro destinazione `rd`. In questo caso non si accede alla memoria dati: la parte rilevante del datapath è quella che collega registro file, ALU e scrittura del risultato nel registro destinazione.

---

## 21. Come si comporta il datapath durante l’esecuzione di un’istruzione `lw`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante l’esecuzione di una `lw`, il processore preleva l’istruzione dalla memoria istruzioni e aggiorna il PC a `PC + 4`.
>
> Poi legge dal registro file il registro base indicato da `rs1`. L’immediato contenuto nell’istruzione viene estratto, esteso correttamente e inviato alla ALU come secondo operando, grazie al segnale `ALUSrc`.
>
> La ALU somma il registro base e l’immediato, ottenendo l’indirizzo effettivo di memoria. La memoria dati viene letta tramite `MemRead`, e il dato ottenuto viene scritto nel registro destinazione `rd`. Per questo motivo, in una `lw`, sono fondamentali i segnali `ALUSrc`, `MemRead`, `MemtoReg` e `RegWrite`.

---

## 22. Come si comporta il datapath durante l’esecuzione di un’istruzione `sw`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante l’esecuzione di una `sw`, il processore preleva l’istruzione e incrementa il PC di 4.
>
> Il registro file fornisce il registro base, usato per calcolare l’indirizzo di memoria, e il registro che contiene il dato da scrivere. L’immediato dell’istruzione viene generato ed esteso, poi inviato alla ALU come secondo operando.
>
> La ALU somma registro base e immediato, producendo l’indirizzo effettivo di memoria. A questo punto il segnale `MemWrite` abilita la scrittura nella memoria dati. A differenza di `lw`, la `sw` non scrive alcun registro, quindi `RegWrite` è disattivato.

---

## 23. Come si comporta il datapath durante l’esecuzione di una `beq`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante l’esecuzione di una `beq`, il processore preleva l’istruzione dalla memoria istruzioni e calcola normalmente anche `PC + 4`.
>
> Vengono poi letti dal registro file i due registri da confrontare. La ALU esegue una sottrazione tra questi due valori. Se il risultato è zero, significa che i due registri sono uguali e l’uscita `Zero` della ALU viene asserita.
>
> In parallelo, il datapath calcola anche l’indirizzo di destinazione del branch usando il PC e l’immediato dell’istruzione. Se il segnale `Branch` è attivo e `Zero` vale 1, il PC viene aggiornato con l’indirizzo di salto; altrimenti viene aggiornato con `PC + 4`.

---

## 24. Perché alcune uscite dell’unità di controllo possono essere indicate come `X` nella tabella dei segnali?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Alcune uscite dell’unità di controllo possono essere indicate come `X` perché, per quella specifica istruzione, il loro valore non influenza il comportamento del datapath.
>
> Per esempio, in una `sw` non viene scritto nessun registro, quindi il segnale `MemtoReg`, che sceglierebbe il valore da scrivere nel registro file, è irrilevante. Anche se valesse 0 o 1, non cambierebbe nulla, perché `RegWrite` è disattivato.
>
> Indicare questi valori come indifferenti permette di semplificare la logica combinatoria dell’unità di controllo, evitando di imporre vincoli inutili.

---

## 25. Quali segnali di controllo caratterizzano una istruzione di tipo R nel datapath semplificato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un’istruzione di tipo R usa due registri sorgente come operandi della ALU e scrive il risultato in un registro destinazione.
>
> Per questo motivo, `ALUSrc` vale 0, perché il secondo operando della ALU viene dal registro file e non da un immediato. `RegWrite` vale 1, perché il risultato deve essere scritto nel registro destinazione. `MemRead` e `MemWrite` valgono 0, perché non si accede alla memoria dati. `MemtoReg` vale 0, perché il valore scritto nel registro proviene dalla ALU e non dalla memoria.
>
> Infine, `Branch` vale 0 e `ALUOp` indica che l’operazione della ALU deve essere determinata dai campi funzionali dell’istruzione.

---

## 26. Quali segnali di controllo caratterizzano una istruzione `lw`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una `lw` deve calcolare un indirizzo di memoria, leggere un dato dalla memoria dati e scriverlo in un registro.
>
> Per questo motivo, `ALUSrc` vale 1, perché la ALU deve sommare il registro base con l’immediato. `MemRead` vale 1, perché la memoria dati deve essere letta. `MemtoReg` vale 1, perché il valore da scrivere nel registro proviene dalla memoria. `RegWrite` vale 1, perché il dato letto deve essere scritto nel registro destinazione.
>
> Invece `MemWrite` vale 0, perché non si scrive in memoria, e `Branch` vale 0, perché non si tratta di un salto condizionato. `ALUOp` indica alla ALU di eseguire una somma.

---

## 27. Quali segnali di controllo caratterizzano una istruzione `sw`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una `sw` deve calcolare un indirizzo di memoria e scrivere in quella posizione un dato proveniente da un registro.
>
> Per questo motivo, `ALUSrc` vale 1, perché la ALU deve sommare il registro base con l’immediato. `MemWrite` vale 1, perché la memoria dati deve essere scritta.
>
> Invece `RegWrite` vale 0, perché la `sw` non scrive nel registro file. `MemRead` vale 0, perché non legge dalla memoria. `Branch` vale 0, perché non modifica il PC tramite salto condizionato. `ALUOp` indica una somma. Il valore di `MemtoReg` è indifferente, perché non avviene alcuna scrittura nel registro file.

---

## 28. Quali segnali di controllo caratterizzano una istruzione `beq`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una `beq` deve confrontare due registri e, se sono uguali, aggiornare il PC con l’indirizzo di destinazione del salto.
>
> Per questo motivo, `ALUSrc` vale 0, perché entrambi gli operandi della ALU provengono dal registro file. La ALU deve eseguire una sottrazione, quindi `ALUOp` indica l’operazione di confronto tramite sottrazione.
>
> `Branch` vale 1, perché l’istruzione è un salto condizionato. `RegWrite`, `MemRead` e `MemWrite` valgono 0, perché la `beq` non scrive registri e non accede alla memoria dati. `MemtoReg` è indifferente, perché non viene scritto nulla nel registro file.

---

## 29. Perché la progettazione dell’unità di controllo principale può partire da una tabella della verità?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità di controllo principale è una rete combinatoria: i suoi segnali di uscita dipendono dai bit di ingresso, in particolare dal codice operativo dell’istruzione.
>
> Per questo motivo, si può descrivere il suo comportamento tramite una tabella della verità. Per ogni tipo di istruzione si indica quale valore devono assumere i segnali di controllo come `ALUSrc`, `MemtoReg`, `RegWrite`, `MemRead`, `MemWrite`, `Branch` e `ALUOp`.
>
> Una volta costruita la tabella, è possibile ricavare le equazioni logiche o il circuito combinatorio che produce quei segnali. I valori indifferenti aiutano a semplificare ulteriormente la rete logica.

---

## 30. Perché il datapath descritto è detto a singolo ciclo di clock?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il datapath è detto a singolo ciclo di clock perché ogni istruzione viene completata interamente in un solo ciclo di clock.
>
> In quel singolo ciclo devono avvenire tutte le operazioni necessarie: prelievo dell’istruzione, lettura dei registri, eventuale generazione dell’immediato, esecuzione della ALU, eventuale accesso alla memoria dati e possibile scrittura nel registro destinazione.
>
> Questo rende il controllo relativamente semplice, perché i segnali possono essere generati in base all’istruzione corrente. Tuttavia, il periodo di clock deve essere abbastanza lungo da permettere il completamento dell’istruzione più lenta.
