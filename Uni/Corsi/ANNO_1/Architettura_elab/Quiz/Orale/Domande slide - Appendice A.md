
# Appendice A — The Basics of Logic Design

Basato sulle slide del PDF AppA, escludendo la parte di esercizi A.14. 

## Metodo di ripasso

Ripassa prima la distinzione tra **logica combinatoria** e **logica sequenziale**, poi collega ogni blocco hardware al suo ruolo nel datapath: porte logiche, decoder, mux, ALU, registri, memorie e macchine a stati.  
Per l’orale non serve ricordare ogni formula lunga, ma devi saper spiegare **che problema risolve ogni componente**, **come viene costruito a blocchi** e **perché è utile nel processore**.

---

## 1. Che differenza c’è tra logica combinatoria e logica sequenziale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **logica combinatoria** è un sistema logico senza memoria: le uscite dipendono solo dagli ingressi correnti. A parità di ingressi, produce sempre le stesse uscite.
>
> La **logica sequenziale**, invece, contiene elementi di memoria: le uscite possono dipendere sia dagli ingressi correnti sia dallo **stato interno** memorizzato. Per questo il comportamento non può essere descritto solo dagli ingressi istantanei.
>
> Nei processori, la parte combinatoria calcola risultati e segnali di controllo, mentre la parte sequenziale mantiene stato, per esempio registri, PC, memorie e flip-flop.

---

## 2. A cosa serve una tabella di verità e perché cresce rapidamente?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **tabella di verità** descrive completamente una funzione combinatoria indicando, per ogni combinazione possibile degli ingressi, il valore delle uscite.
>
> Se una funzione ha `n` ingressi, le combinazioni possibili sono `2^n`, quindi la tabella ha `2^n` righe. Questo la rende semplice per funzioni piccole, ma poco pratica per circuiti con molti ingressi.
>
> Per questo spesso si usano rappresentazioni più compatte, come equazioni booleane, PLA, ROM o linguaggi di descrizione hardware come Verilog.

---

## 3. Quali sono gli operatori fondamentali dell’algebra booleana?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli operatori fondamentali sono:
>
> - **OR**, indicato con `+`: vale 1 se almeno un ingresso vale 1.
> - **AND**, indicato con `·`: vale 1 solo se tutti gli ingressi coinvolti valgono 1.
> - **NOT**, cioè la negazione: trasforma 0 in 1 e 1 in 0.
>
> Con questi tre operatori si può descrivere qualsiasi funzione logica combinatoria. Le porte logiche hardware implementano direttamente queste operazioni.

---

## 4. Perché NAND e NOR sono dette porte universali?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> NAND e NOR sono dette **porte universali** perché usando solo porte NAND, oppure solo porte NOR, è possibile costruire qualsiasi funzione logica.
>
> Questo è importante perché, se una porta è universale, un circuito digitale completo può essere realizzato partendo da un unico tipo di componente logico.
>
> In pratica, NAND e NOR combinano un’operazione logica base con una negazione: NAND è un AND negato, NOR è un OR negato.

---

## 5. Che cos’è un decoder e a cosa serve?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **decoder** è un blocco combinatorio con `n` ingressi e `2^n` uscite. Per ogni combinazione degli ingressi, viene attivata una sola uscita.
>
> Se l’ingresso rappresenta il numero binario `i`, allora viene attivata l’uscita `Out_i`, mentre tutte le altre restano disattivate.
>
> Nei circuiti del processore, un decoder è utile quando bisogna selezionare una tra molte risorse, per esempio quale registro scrivere in un register file.

---

## 6. Che cos’è un multiplexor e perché è così importante nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **multiplexor**, o mux, è un selettore: riceve più ingressi dati e, tramite uno o più segnali di controllo, sceglie quale ingresso mandare in uscita.
>
> Per esempio, un mux a 2 ingressi sceglie tra `A` e `B` in base a un segnale di selezione `S`.
>
> È fondamentale nel datapath perché molte scelte hardware sono selezioni tra alternative: quale valore scrivere in un registro, quale operando dare all’ALU, quale prossimo valore assegnare al PC, e così via.

---

## 7. Che cosa significa rappresentare una funzione logica come somma di prodotti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una rappresentazione **somma di prodotti** è una forma a due livelli:
>
> - al primo livello ci sono termini in AND, detti prodotti o mintermini;
> - al secondo livello questi termini vengono combinati con OR.
>
> Ogni riga della tabella di verità in cui l’uscita vale 1 genera un prodotto. La funzione completa è l’OR di tutti questi prodotti.
>
> Questa forma è importante perché permette di passare in modo sistematico da una tabella di verità a un circuito logico implementabile con porte AND, OR e NOT.

---

## 8. Che cos’è una PLA e come implementa una funzione logica?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **PLA**, cioè Programmable Logic Array, è una struttura logica organizzata in due piani:
>
> - un **AND plane**, che genera i termini prodotto a partire dagli ingressi e dai loro complementi;
> - un **OR plane**, che somma alcuni di questi prodotti per produrre le uscite.
>
> Una PLA implementa quindi funzioni in forma **somma di prodotti**.
>
> È efficiente perché usa solo i termini effettivamente necessari e può condividere lo stesso prodotto tra più uscite.

---

## 9. Che differenza c’è tra usare una ROM e una PLA per implementare logica combinatoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **ROM** implementa una funzione logica memorizzando direttamente l’uscita per ogni possibile combinazione degli ingressi. Gli ingressi funzionano da indirizzo, mentre il contenuto della locazione rappresenta le uscite.
>
> Una **PLA**, invece, implementa solo i termini prodotto necessari, cioè quelli legati alle combinazioni utili.
>
> La ROM è più generale e facile da modificare se cambia la funzione, ma cresce esponenzialmente con il numero di ingressi perché contiene una voce per ogni combinazione. La PLA è spesso più efficiente per funzioni reali, perché non deve rappresentare esplicitamente tutte le combinazioni.

---

## 10. Che cosa sono i don’t care e perché aiutano a ottimizzare i circuiti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I **don’t care** sono condizioni in cui non importa quale valore assuma una certa uscita, oppure condizioni in cui alcuni ingressi non influenzano il risultato.
>
> Si indicano spesso con `X` nelle tabelle di verità.
>
> Sono utili perché permettono al progettista o agli strumenti di sintesi logica di scegliere il valore più conveniente per semplificare il circuito. In questo modo si possono ridurre il numero di porte, i mintermini e la complessità complessiva.

---

## 11. Che cos’è un bus in logica digitale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **bus** è un insieme di linee di dati trattate come un unico segnale logico.
>
> Per esempio, un valore a 32 bit non viene trasportato da una sola linea, ma da 32 linee parallele. Nel disegno dei circuiti, un bus è spesso rappresentato con una linea più spessa.
>
> Quando un componente lavora su un bus, spesso significa che lo stesso circuito elementare è replicato più volte: un mux a 32 bit, per esempio, può essere visto come 32 mux a 1 bit controllati dallo stesso segnale di selezione.

---

## 12. A cosa serve un linguaggio di descrizione hardware come Verilog?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un linguaggio di descrizione hardware, come **Verilog**, serve a descrivere circuiti digitali.
>
> Ha due usi principali:
>
> - simulare e verificare il comportamento del circuito;
> - fornire una descrizione che gli strumenti di sintesi possono trasformare in hardware reale.
>
> Verilog può descrivere un circuito in modo **comportamentale**, cioè specificando cosa fa, oppure **strutturale**, cioè specificando come sono collegati i componenti interni.

---

## 13. Qual è la differenza tra `wire` e `reg` in Verilog?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In Verilog, un **wire** rappresenta un segnale combinatorio, cioè un collegamento il cui valore è determinato continuamente da qualche logica.
>
> Un **reg** rappresenta una variabile che può mantenere un valore nel tempo, anche se non sempre corrisponde fisicamente a un registro hardware.
>
> In generale:
>
> - i `wire` sono assegnati tramite assegnamenti continui, come `assign`;
> - i `reg` sono assegnati dentro blocchi procedurali, come `always`.
>
> Bisogna fare attenzione: un `reg` usato male in un blocco `always` può portare alla sintesi involontaria di logica sequenziale.

---

## 14. Come si distingue in Verilog la logica combinatoria da quella sequenziale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La logica combinatoria può essere descritta con `assign` oppure con un blocco `always` sensibile a tutti gli ingressi.
>
> La logica sequenziale, invece, viene descritta con blocchi `always` sensibili a un fronte di clock, per esempio `posedge clock` o `negedge clock`.
>
> La differenza fondamentale è che nella logica combinatoria l’uscita cambia quando cambiano gli ingressi, mentre nella logica sequenziale lo stato viene aggiornato solo in momenti precisi, tipicamente sui fronti del clock.

---

## 15. Come si costruisce una ALU a 1 bit partendo da blocchi logici semplici?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una ALU a 1 bit può essere costruita combinando:
>
> - una porta AND;
> - una porta OR;
> - un sommatore a 1 bit;
> - un multiplexor che seleziona quale risultato mandare in uscita.
>
> Il segnale di controllo della ALU decide se il risultato finale deve essere `a AND b`, `a OR b` oppure la somma.
>
> Questo mostra il principio generale della ALU: più circuiti calcolano risultati diversi in parallelo, poi un mux sceglie il risultato corretto in base all’operazione richiesta.

---

## 16. Come si ottiene una ALU a 32 bit da ALU a 1 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una ALU a 32 bit può essere costruita collegando 32 ALU a 1 bit, una per ogni bit degli operandi.
>
> Per le operazioni logiche, i bit sono indipendenti. Per l’addizione, invece, il carry prodotto da un bit meno significativo deve essere passato al bit successivo.
>
> Quando i carry sono collegati in catena, si parla di **ripple carry adder**: il carry “propaga” dal bit meno significativo fino a quello più significativo. È semplice da costruire, ma può essere lento perché il bit più alto deve aspettare la propagazione dei carry precedenti.

---

## 17. Come viene implementata la sottrazione in una ALU usando il complemento a due?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La sottrazione viene implementata trasformandola in un’addizione:
>
> `a - b = a + (-b)`
>
> In complemento a due, per ottenere `-b` si invertono tutti i bit di `b` e si aggiunge 1.
>
> Nell’ALU questo si ottiene aggiungendo un mux che può scegliere tra `b` e `NOT b`, e impostando il carry iniziale a 1. In questo modo lo stesso sommatore usato per l’addizione può essere riutilizzato anche per la sottrazione.
>
> Questo è uno dei motivi per cui il complemento a due è così comodo nell’hardware.

---

## 18. Come può una ALU supportare l’istruzione `slt`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’istruzione `slt`, cioè **set less than**, deve produrre 1 se `a < b`, altrimenti 0.
>
> L’idea hardware è sottrarre:
>
> `a - b`
>
> Se il risultato è negativo, allora `a < b`. Quindi si può usare il bit di segno del risultato della sottrazione per impostare il bit meno significativo dell’uscita.
>
> Tutti gli altri bit dell’uscita vengono posti a 0. In una ALU completa bisogna però considerare anche l’overflow, perché il solo bit di segno può essere fuorviante in caso di overflow aritmetico.

---

## 19. Come può una ALU supportare il confronto di uguaglianza usato da `beq`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per controllare se due registri sono uguali, la ALU può sottrarre:
>
> `a - b`
>
> Se il risultato è 0, allora `a = b`.
>
> Per rilevare questo caso, si aggiunge un circuito che controlla se tutti i bit del risultato sono 0. Tipicamente si fa un OR di tutti i bit del risultato e poi si nega il risultato: se nessun bit è 1, allora il segnale **Zero** vale 1.
>
> Questo segnale Zero può essere usato dal controllo del processore per decidere se un branch come `beq` deve essere preso.

---

## 20. Perché un ripple carry adder è lento e qual è l’idea del carry lookahead?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **ripple carry adder** è lento perché ogni bit deve aspettare il carry prodotto dal bit precedente. Nel caso peggiore, il carry deve propagarsi dal bit meno significativo fino al bit più significativo.
>
> Il **carry lookahead** accelera l’addizione calcolando in anticipo se un certo bit:
>
> - **genera** un carry, indipendentemente dal carry in ingresso;
> - **propaga** un carry ricevuto in ingresso.
>
> I segnali fondamentali sono:
>
> - `generate`: il bit produce sicuramente un carry;
> - `propagate`: il bit lascia passare un carry proveniente dai bit precedenti.
>
> In questo modo i carry possono essere determinati con meno livelli logici, riducendo il ritardo rispetto alla propagazione sequenziale.

---

## 21. Che ruolo ha il clock nei circuiti sequenziali?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **clock** stabilisce quando gli elementi di stato devono essere aggiornati.
>
> In una metodologia **edge-triggered**, gli elementi di memoria cambiano stato solo su un fronte del clock, per esempio sul fronte di salita o di discesa.
>
> Questo permette di separare due fasi:
>
> - durante il ciclo, la logica combinatoria calcola i nuovi valori;
> - al fronte di clock, i nuovi valori vengono campionati e memorizzati negli elementi di stato.
>
> Il periodo di clock deve essere abbastanza lungo da permettere alla logica combinatoria di stabilizzarsi prima del fronte successivo.

---

## 22. Qual è la differenza tra latch e flip-flop?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **latch** è sensibile al livello del clock: quando il clock è attivo, il latch è “aperto” e l’uscita può seguire l’ingresso. Quando il clock non è attivo, conserva l’ultimo valore.
>
> Un **flip-flop** è sensibile al fronte del clock: aggiorna il proprio stato solo nel momento del fronte, per esempio sul fronte di salita o di discesa.
>
> Nei datapath studiati si usano soprattutto flip-flop, perché rendono più semplice progettare circuiti sincroni: lo stato cambia solo in istanti ben definiti.

---

## 23. Che cosa sono setup time e hold time?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **setup time** è il tempo minimo per cui l’ingresso di un flip-flop deve essere stabile prima del fronte di clock.
>
> L’**hold time** è il tempo minimo per cui l’ingresso deve restare stabile dopo il fronte di clock.
>
> Se questi vincoli non vengono rispettati, il flip-flop potrebbe memorizzare un valore errato o entrare in uno stato instabile.
>
> Questi vincoli sono fondamentali per determinare il periodo minimo del clock e quindi la frequenza massima del circuito.

---

## 24. Come è organizzato un register file?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **register file** è un insieme di registri accessibili tramite numeri di registro.
>
> Nel datapath RISC-V tipico ha:
>
> - due porte di lettura;
> - una porta di scrittura.
>
> Le letture sono combinatorie: dato un numero di registro, il contenuto viene selezionato tramite mux.
>
> La scrittura è sequenziale: avviene sul fronte di clock, se il segnale di scrittura è attivo. Un decoder seleziona quale registro deve essere scritto.
>
> Questo spiega perché leggere un registro non cambia lo stato, mentre scrivere un registro sì.

---

## 25. Che differenza c’è tra SRAM e DRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **SRAM** memorizza i bit in modo statico, usando circuiti simili a flip-flop. Mantiene il valore finché c’è alimentazione, è veloce, ma occupa più area ed è più costosa per bit.
>
> La **DRAM** memorizza i bit come carica in un condensatore. È più densa ed economica, ma la carica si perde nel tempo, quindi deve essere periodicamente rinfrescata.
>
> Per questo:
>
> - la SRAM è adatta alle cache, dove serve velocità;
> - la DRAM è adatta alla memoria principale, dove serve grande capacità a costo minore.

---

## 26. Perché le memorie grandi non usano un unico enorme multiplexor?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una memoria grande, usare un unico multiplexor enorme sarebbe impraticabile.
>
> Per esempio, una SRAM con moltissime locazioni richiederebbe un mux con un numero enorme di ingressi. Questo sarebbe troppo costoso e complesso.
>
> Le memorie grandi usano invece strutture organizzate come array rettangolari, linee di parola, linee di bit, buffer tristate e decodifica a più livelli.
>
> In questo modo si seleziona prima una riga o un blocco, poi una colonna o un sottoinsieme di bit, rendendo l’implementazione molto più efficiente.

---

## 27. Che cos’è il refresh nelle DRAM e perché è necessario?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nelle DRAM il bit è memorizzato come carica elettrica in un condensatore.
>
> Questa carica tende a disperdersi nel tempo, quindi il valore memorizzato non può restare valido indefinitamente.
>
> Il **refresh** consiste nel leggere il contenuto e riscriverlo, così da ripristinare la carica.
>
> Grazie all’organizzazione a righe, una DRAM può rinfrescare un’intera riga alla volta, evitando di dover aggiornare ogni bit singolarmente in modo troppo costoso.

---

## 28. A cosa servono i codici di parità e gli ECC nelle memorie?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I codici di controllo servono a rilevare o correggere errori nei dati memorizzati.
>
> La **parità** aggiunge un bit che indica se il numero di 1 nella parola è pari o dispari. È semplice, ma può rilevare solo certi errori, tipicamente un singolo bit errato.
>
> Gli **ECC**, cioè Error Correction Codes, usano più bit di controllo e permettono non solo di rilevare errori, ma anche di correggere alcuni di essi.
>
> Nelle memorie grandi è comune usare codici capaci di correggere errori a 1 bit e rilevare errori a 2 bit.

---

## 29. Che cos’è una macchina a stati finiti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **macchina a stati finiti**, o FSM, è un sistema sequenziale descritto tramite:
>
> - un insieme finito di stati;
> - una funzione di prossimo stato;
> - una funzione di uscita.
>
> Lo stato corrente è memorizzato in elementi di memoria. La funzione di prossimo stato, che è combinatoria, decide quale sarà lo stato successivo in base allo stato corrente e agli ingressi.
>
> La funzione di uscita produce i segnali di uscita. Le FSM sono molto usate per realizzare unità di controllo, per esempio nel controllo del datapath di un processore.

---

## 30. Che differenza c’è tra macchina di Moore e macchina di Mealy?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una **macchina di Moore**, le uscite dipendono solo dallo stato corrente.
>
> In una **macchina di Mealy**, le uscite possono dipendere sia dallo stato corrente sia dagli ingressi correnti.
>
> Le due forme hanno capacità equivalenti, ma possono differire per efficienza:
>
> - una Moore è spesso più semplice da ragionare e può avere uscite più stabili;
> - una Mealy può richiedere meno stati, perché reagisce direttamente anche agli ingressi.

---

## 31. Che problema risolve una metodologia di temporizzazione edge-triggered?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una metodologia **edge-triggered** fa sì che tutti gli elementi di stato si aggiornino solo sul fronte del clock.
>
> Questo semplifica il progetto perché tra due fronti di clock la logica combinatoria ha tempo per calcolare e stabilizzare i nuovi valori.
>
> Il vincolo principale è che il periodo di clock deve essere almeno abbastanza lungo da includere:
>
> - il tempo di propagazione del flip-flop;
> - il ritardo massimo della logica combinatoria;
> - il setup time del flip-flop di destinazione.
>
> Se questo vincolo è rispettato, il circuito sincrono può funzionare correttamente.

---

## 32. Che cosa sono clock skew e metastabilità?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **clock skew** è la differenza tra gli istanti in cui lo stesso fronte di clock arriva a elementi di stato diversi.
>
> Se lo skew è troppo grande, un valore può propagarsi da un registro a un altro nello stesso fronte di clock, causando una race condition.
>
> La **metastabilità**, invece, può avvenire quando un segnale viene campionato mentre non è stabile, per esempio perché proviene da un dispositivo asincrono. Il flip-flop può temporaneamente trovarsi in una regione non chiaramente 0 né 1.
>
> Per ridurre il rischio di metastabilità si usano sincronizzatori, spesso formati da due flip-flop in cascata.

---

## 33. Che cosa sono FPD, PLD e FPGA?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli **FPD**, cioè Field Programmable Devices, sono circuiti integrati configurabili dall’utente per implementare logica digitale.
>
> I **PLD** sono dispositivi programmabili orientati soprattutto alla logica combinatoria. Possono includere strutture come PLA o PAL.
>
> Gli **FPGA** sono dispositivi più complessi che includono sia logica combinatoria sia flip-flop. Sono formati da blocchi logici configurabili e interconnessioni programmabili.
>
> Gli FPGA permettono di implementare sistemi digitali complessi senza progettare un chip custom.

---

## 34. Perché questa appendice è importante per capire datapath, controllo e memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Questa appendice fornisce le basi hardware necessarie per capire come viene costruito un processore.
>
> I concetti principali si ritrovano direttamente nel datapath:
>
> - mux e decoder servono a selezionare segnali;
> - ALU e adders eseguono operazioni aritmetico-logiche;
> - registri e register file conservano lo stato;
> - SRAM e DRAM spiegano cache e memoria principale;
> - FSM e logica di controllo determinano il comportamento del processore ciclo per ciclo.
>
> Quindi non è solo teoria di logica digitale: è il vocabolario hardware con cui si descrivono processore, memoria e controllo.