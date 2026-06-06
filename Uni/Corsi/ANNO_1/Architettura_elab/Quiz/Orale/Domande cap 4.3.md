
# 4.3 Realizzazione di un’unità di elaborazione

## Metodo di ripasso

Per ripassare questa sezione, conviene non memorizzare subito lo schema completo. Parti dai blocchi base: **PC**, **memoria istruzioni**, **adder per PC + 4**, **register file**, **ALU**, **memoria dati**, **unità di estensione del segno** e **multiplexer**.

Poi, per ogni classe di istruzioni, chiediti:

- quali registri vengono letti;
- se viene usata la ALU e per fare cosa;
- se viene letta o scritta la memoria dati;
- se viene scritto un registro;
- come viene aggiornato il PC.

L’obiettivo non è solo riconoscere lo schema, ma saper spiegare discorsivamente il percorso dei dati e il ruolo dei segnali di controllo.

---

## 1. Qual è l’idea generale alla base della realizzazione di un’unità di elaborazione per RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’idea generale è costruire l’unità di elaborazione partendo dagli elementi necessari per eseguire le diverse classi di istruzioni RISC-V.
>
> Si parte dal prelievo delle istruzioni, quindi dal program counter e dalla memoria istruzioni, poi si aggiungono i componenti necessari per le istruzioni aritmetico-logiche, per le istruzioni di accesso alla memoria e per i salti condizionati.
>
> Alla fine, questi elementi vengono combinati in un’unica unità di elaborazione. Poiché istruzioni diverse usano in parte gli stessi componenti ma con percorsi dei dati diversi, servono anche segnali di controllo e multiplexer per selezionare, di volta in volta, gli ingressi corretti.

---

## 2. Che cos’è il program counter e qual è il suo ruolo nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il program counter, o PC, è un registro che contiene l’indirizzo dell’istruzione corrente da eseguire.
>
> È un elemento di stato, perché conserva un valore tra un ciclo di clock e il successivo. A ogni ciclo, il valore del PC viene usato come indirizzo per accedere alla memoria istruzioni e prelevare l’istruzione da eseguire.
>
> Normalmente, dopo il prelievo dell’istruzione, il PC viene aggiornato con l’indirizzo dell’istruzione successiva. Nel caso di istruzioni RISC-V a 32 bit, cioè lunghe 4 byte, l’indirizzo successivo è calcolato come `PC + 4`.

---

## 3. Perché l’indirizzo dell’istruzione successiva viene calcolato come PC + 4?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’indirizzo dell’istruzione successiva viene calcolato come `PC + 4` perché le istruzioni considerate sono lunghe 32 bit, cioè 4 byte.
>
> La memoria è indirizzata a byte, quindi due istruzioni consecutive non hanno indirizzi che differiscono di 1, ma di 4. Se un’istruzione si trova all’indirizzo `PC`, la successiva, in esecuzione sequenziale, si trova all’indirizzo `PC + 4`.
>
> Per questo motivo nel datapath è presente un sommatore che riceve in ingresso il valore corrente del PC e la costante 4.

---

## 4. Quali componenti sono necessari per prelevare un’istruzione dalla memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per prelevare un’istruzione dalla memoria servono principalmente il program counter, la memoria istruzioni e un sommatore.
>
> Il PC contiene l’indirizzo dell’istruzione corrente. Questo indirizzo viene fornito alla memoria istruzioni, che restituisce in uscita l’istruzione memorizzata in quella posizione.
>
> In parallelo, un sommatore calcola `PC + 4`, cioè l’indirizzo dell’istruzione successiva nel normale flusso sequenziale del programma.

---

## 5. Che differenza c’è tra elementi di stato ed elementi combinatori nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli elementi di stato sono componenti che memorizzano informazioni e il cui contenuto viene aggiornato in corrispondenza del clock. Esempi sono il program counter, il register file e la memoria.
>
> Gli elementi combinatori, invece, producono un’uscita che dipende solo dagli ingressi correnti e non conservano memoria del passato. Esempi sono la ALU, i sommatori, l’unità di estensione del segno e i multiplexer.
>
> Nel datapath, gli elementi di stato permettono di conservare istruzioni, dati e indirizzi, mentre gli elementi combinatori calcolano risultati, indirizzi e segnali necessari all’esecuzione dell’istruzione.

---

## 6. Che cos’è il register file e perché è necessario?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il register file è la struttura che contiene i registri generali del processore. In RISC-V questi registri vengono usati per contenere gli operandi delle istruzioni e i risultati prodotti dall’esecuzione.
>
> È necessario perché molte istruzioni leggono valori dai registri, li elaborano tramite la ALU e poi scrivono il risultato in un registro di destinazione.
>
> Per supportare le istruzioni più comuni, il register file deve poter leggere due registri contemporaneamente e scrivere, se necessario, un registro di destinazione.

---

## 7. Perché il register file ha due porte di lettura e una porta di scrittura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il register file ha due porte di lettura perché molte istruzioni RISC-V richiedono due operandi sorgente.
>
> Per esempio, un’istruzione aritmetico-logica di tipo R, come `add x1, x2, x3`, deve leggere contemporaneamente i contenuti di `x2` e `x3`. Anche un salto condizionato come `beq` deve leggere due registri per confrontarli.
>
> La porta di scrittura serve invece per salvare un risultato in un registro di destinazione. Nelle istruzioni considerate, al massimo un registro viene scritto per ogni istruzione, quindi è sufficiente una sola porta di scrittura.

---

## 8. Come viene eseguita un’istruzione aritmetico-logica di tipo R nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un’istruzione di tipo R legge due registri sorgente dal register file, invia i due valori letti agli ingressi della ALU e scrive il risultato prodotto dalla ALU in un registro di destinazione.
>
> Per esempio, nell’istruzione `add x1, x2, x3`, il register file legge i registri `x2` e `x3`. La ALU somma i due valori letti e produce un risultato. Questo risultato viene poi scritto nel registro `x1`.
>
> In questo caso la memoria dati non viene usata, perché l’operazione riguarda solo registri e ALU.

---

## 9. Qual è il ruolo della ALU nelle istruzioni di tipo R?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nelle istruzioni di tipo R, la ALU esegue l’operazione aritmetica o logica richiesta dall’istruzione.
>
> Gli ingressi della ALU provengono dai due registri sorgente letti dal register file. A seconda dell’istruzione, la ALU può eseguire una somma, una sottrazione o un’operazione logica.
>
> Il risultato della ALU viene poi riportato al register file e scritto nel registro di destinazione, se il segnale di controllo `RegWrite` è attivo.

---

## 10. A cosa serve il segnale di controllo RegWrite?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `RegWrite` serve a stabilire se il register file deve essere scritto.
>
> Quando `RegWrite` è attivo, il dato presente sull’ingresso di scrittura viene salvato nel registro di destinazione indicato dall’istruzione. Quando invece `RegWrite` non è attivo, il register file non viene modificato.
>
> Questo segnale è necessario perché non tutte le istruzioni scrivono un risultato in un registro. Le istruzioni di tipo R e le istruzioni di load scrivono un registro, mentre le istruzioni di store e i salti condizionati non lo fanno.

---

## 11. A cosa serve il segnale Zero prodotto dalla ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `Zero` indica se il risultato prodotto dalla ALU è uguale a zero.
>
> Questo segnale è utile soprattutto per i salti condizionati. Per esempio, nell’istruzione `beq`, il processore deve verificare se due registri contengono lo stesso valore. Una possibile implementazione consiste nel sottrarre i due valori tramite la ALU.
>
> Se il risultato della sottrazione è zero, significa che i due valori sono uguali. In questo caso il segnale `Zero` viene attivato e può essere usato dalla logica di controllo per decidere se il salto deve essere preso.

---

## 12. Come funzionano le istruzioni di load nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni di load, come `lw`, servono a leggere un dato dalla memoria e copiarlo in un registro.
>
> Il datapath legge dal register file il registro base indicato nell’istruzione. L’offset immediato contenuto nell’istruzione viene esteso di segno a 32 bit. La ALU somma il registro base e l’offset esteso, ottenendo così l’indirizzo effettivo di memoria.
>
> La memoria dati usa questo indirizzo per leggere il dato richiesto. Infine, il dato letto dalla memoria viene scritto nel registro di destinazione del register file.

---

## 13. Come funzionano le istruzioni di store nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni di store, come `sw`, servono a scrivere in memoria un dato contenuto in un registro.
>
> Il datapath legge dal register file due registri: uno contiene l’indirizzo base, l’altro contiene il dato da scrivere in memoria. L’offset immediato dell’istruzione viene esteso di segno a 32 bit.
>
> La ALU somma il registro base e l’offset esteso, producendo l’indirizzo effettivo di memoria. A questo indirizzo, la memoria dati scrive il valore proveniente dal secondo registro letto.
>
> A differenza della load, una store non scrive alcun risultato nel register file.

---

## 14. Perché nelle istruzioni load e store serve l’estensione del segno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nelle istruzioni di load e store serve l’estensione del segno perché l’offset contenuto nell’istruzione ha meno bit rispetto agli operandi della ALU.
>
> Nel caso considerato, l’offset è un immediato a 12 bit, mentre la ALU lavora su valori a 32 bit. Prima di poter sommare l’offset al registro base, è quindi necessario trasformarlo in un valore a 32 bit.
>
> L’estensione del segno copia il bit più significativo dell’immediato nei bit aggiunti a sinistra. In questo modo il valore mantiene correttamente il proprio segno, permettendo di rappresentare sia offset positivi sia offset negativi.

---

## 15. Qual è il ruolo della memoria dati nelle istruzioni load e store?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La memoria dati è il componente usato per leggere o scrivere dati durante le istruzioni di accesso alla memoria.
>
> In una istruzione di load, la memoria dati riceve un indirizzo calcolato dalla ALU e restituisce il dato contenuto in quella posizione. Questo dato viene poi scritto nel register file.
>
> In una istruzione di store, invece, la memoria dati riceve sia l’indirizzo calcolato dalla ALU sia il dato da scrivere, proveniente dal register file. La scrittura avviene solo se il segnale di controllo di scrittura della memoria è attivo.

---

## 16. A cosa servono i segnali MemRead e MemWrite?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I segnali `MemRead` e `MemWrite` controllano l’accesso alla memoria dati.
>
> `MemRead` abilita la lettura dalla memoria dati. Viene usato, per esempio, nelle istruzioni di load, dove il processore deve leggere un valore dalla memoria.
>
> `MemWrite` abilita invece la scrittura nella memoria dati. Viene usato nelle istruzioni di store, dove il processore deve salvare in memoria un dato proveniente da un registro.
>
> Questi segnali sono necessari perché la memoria dati non deve essere letta o scritta in modo indiscriminato, ma solo quando l’istruzione lo richiede.

---

## 17. Perché serve un multiplexer prima del secondo ingresso della ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Serve un multiplexer prima del secondo ingresso della ALU perché istruzioni diverse richiedono sorgenti diverse per il secondo operando.
>
> Nelle istruzioni di tipo R, il secondo ingresso della ALU deve provenire dal secondo registro letto dal register file. Nelle istruzioni di load e store, invece, il secondo ingresso della ALU deve essere l’offset immediato esteso di segno.
>
> Il multiplexer permette quindi di scegliere tra il valore letto dal registro e il valore immediato esteso. Il segnale di controllo che effettua questa scelta è spesso chiamato `ALUSrc`.

---

## 18. A cosa serve il segnale ALUSrc?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `ALUSrc` controlla il multiplexer posto prima del secondo ingresso della ALU.
>
> Se l’istruzione è di tipo R, `ALUSrc` seleziona il valore proveniente dal secondo registro letto dal register file.
>
> Se invece l’istruzione è una load o una store, `ALUSrc` seleziona l’immediato esteso di segno, perché la ALU deve calcolare l’indirizzo effettivo sommando il registro base e l’offset.
>
> In questo modo la stessa ALU può essere riutilizzata per istruzioni diverse.

---

## 19. Perché serve un multiplexer dopo la memoria dati, prima della scrittura nel register file?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Serve un multiplexer dopo la memoria dati perché il valore da scrivere nel register file può provenire da due sorgenti diverse.
>
> Nelle istruzioni di tipo R, il valore da scrivere nel registro di destinazione è il risultato prodotto dalla ALU.
>
> Nelle istruzioni di load, invece, il valore da scrivere nel registro di destinazione è il dato letto dalla memoria dati.
>
> Il multiplexer permette di scegliere quale dei due valori inviare all’ingresso di scrittura del register file. Il segnale di controllo associato è spesso chiamato `MemtoReg`.

---

## 20. A cosa serve il segnale MemtoReg?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `MemtoReg` stabilisce quale valore deve essere scritto nel register file.
>
> Se l’istruzione è aritmetico-logica di tipo R, il dato da scrivere proviene dalla ALU, quindi `MemtoReg` seleziona il risultato della ALU.
>
> Se l’istruzione è una load, il dato da scrivere proviene dalla memoria dati, quindi `MemtoReg` seleziona l’uscita della memoria.
>
> Questo segnale è necessario perché istruzioni diverse producono il valore finale da scrivere nel registro in modi diversi.

---

## 21. Come viene calcolato l’indirizzo di destinazione di un salto condizionato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’indirizzo di destinazione di un salto condizionato viene calcolato sommando al valore del PC l’offset contenuto nell’istruzione.
>
> L’offset del salto viene prima esteso di segno, in modo da ottenere un valore a 32 bit. Poi viene spostato a sinistra di 1 bit, perché nelle istruzioni di salto condizionato RISC-V l’offset rappresenta mezze parole, non singoli byte.
>
> Dopo questo spostamento, il valore ottenuto viene sommato al PC per produrre l’indirizzo di destinazione del salto.

---

## 22. Perché l’offset del branch viene spostato a sinistra di 1 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’offset del branch viene spostato a sinistra di 1 bit perché nell’architettura RISC-V il campo immediato delle istruzioni di salto condizionato non rappresenta direttamente un numero di byte, ma un numero di mezze parole.
>
> Spostare a sinistra di 1 bit equivale a moltiplicare per 2. In questo modo l’offset viene convertito nel corretto spiazzamento in byte.
>
> Questa scelta permette di rappresentare salti più ampi usando lo stesso numero di bit nell’immediato, dato che gli indirizzi di destinazione dei salti sono allineati.

---

## 23. Come viene deciso se un salto condizionato viene preso o non preso?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un salto condizionato viene preso o non preso in base al risultato del confronto tra due registri.
>
> Nel caso dell’istruzione `beq`, il processore deve verificare se i due registri sorgente contengono lo stesso valore. Per farlo, la ALU può sottrarre i due valori. Se il risultato è zero, significa che i due operandi sono uguali.
>
> Il segnale `Zero` prodotto dalla ALU viene quindi combinato con il segnale di controllo del branch. Se la condizione è vera, il PC viene aggiornato con l’indirizzo di destinazione del salto. Se la condizione è falsa, il PC viene aggiornato normalmente con `PC + 4`.

---

## 24. Che cosa significa salto preso e salto non preso?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un salto è detto preso quando la condizione del branch è soddisfatta. In questo caso, il prossimo valore del PC non sarà `PC + 4`, ma l’indirizzo di destinazione del salto.
>
> Un salto è detto non preso quando la condizione non è soddisfatta. In questo caso, il processore continua l’esecuzione sequenziale e il PC viene aggiornato con l’indirizzo dell’istruzione successiva, cioè `PC + 4`.
>
> Quindi la differenza riguarda il modo in cui viene aggiornato il program counter dopo l’istruzione di salto.

---

## 25. Perché serve un multiplexer per scegliere il nuovo valore del PC?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Serve un multiplexer per scegliere il nuovo valore del PC perché il prossimo indirizzo da eseguire può avere due origini diverse.
>
> Se l’esecuzione procede normalmente, il nuovo PC deve essere `PC + 4`, cioè l’indirizzo dell’istruzione successiva.
>
> Se invece un salto condizionato viene preso, il nuovo PC deve essere l’indirizzo di destinazione del salto, calcolato sommando al PC l’offset del branch opportunamente esteso e spostato.
>
> Il multiplexer seleziona quindi tra `PC + 4` e l’indirizzo di salto, in base al segnale di controllo che indica se il branch è preso.

---

## 26. A cosa serve il segnale PCSrc?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `PCSrc` serve a controllare il multiplexer che sceglie il prossimo valore del program counter.
>
> Se `PCSrc` indica esecuzione sequenziale, il PC viene aggiornato con `PC + 4`.
>
> Se invece `PCSrc` indica che il salto deve essere preso, il PC viene aggiornato con l’indirizzo di destinazione del salto.
>
> In genere, per un branch come `beq`, `PCSrc` dipende sia dal fatto che l’istruzione sia effettivamente un branch, sia dal segnale `Zero` prodotto dalla ALU.

---

## 27. Perché la ALU viene usata anche per implementare i salti condizionati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La ALU viene usata nei salti condizionati per confrontare i due registri sorgente.
>
> Nel caso di `beq`, il confronto di uguaglianza può essere realizzato sottraendo i due operandi. Se la differenza è zero, allora i due valori sono uguali.
>
> La ALU produce quindi il segnale `Zero`, che viene usato dalla logica di controllo per decidere se aggiornare il PC con l’indirizzo di destinazione del salto oppure con `PC + 4`.
>
> In questo modo si riutilizza un componente già presente nel datapath, evitando di introdurre un comparatore separato.

---

## 28. Quali sono le principali differenze tra istruzioni di tipo R e istruzioni di accesso alla memoria nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni di tipo R usano la ALU per eseguire un’operazione aritmetica o logica su due valori letti dal register file. Il risultato della ALU viene poi scritto nel registro di destinazione.
>
> Le istruzioni di accesso alla memoria, invece, usano la ALU per calcolare un indirizzo. Questo indirizzo si ottiene sommando un registro base con un offset immediato esteso di segno.
>
> Nel caso di una load, il dato letto dalla memoria viene scritto nel register file. Nel caso di una store, un dato letto da un registro viene scritto nella memoria dati. Quindi le istruzioni di accesso alla memoria coinvolgono anche la memoria dati, mentre le istruzioni di tipo R no.

---

## 29. Perché in un datapath unificato sono necessari i multiplexer?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I multiplexer sono necessari perché la stessa unità di elaborazione deve supportare istruzioni diverse, che spesso usano gli stessi componenti ma con ingressi o uscite differenti.
>
> Per esempio, la ALU può ricevere come secondo operando un valore letto dal register file oppure un immediato esteso di segno. Allo stesso modo, il dato da scrivere nel register file può provenire dalla ALU oppure dalla memoria dati.
>
> I multiplexer permettono di selezionare il percorso corretto dei dati in base all’istruzione in esecuzione. Senza multiplexer, sarebbe necessario duplicare molti componenti oppure costruire datapath separati per ogni tipo di istruzione.

---

## 30. Qual è il vantaggio di riutilizzare gli stessi componenti per più istruzioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Riutilizzare gli stessi componenti permette di costruire un’unità di elaborazione più semplice e meno costosa.
>
> Per esempio, la stessa ALU può essere usata sia per eseguire operazioni aritmetico-logiche, sia per calcolare indirizzi di memoria, sia per confrontare due registri nei salti condizionati.
>
> Questo riduce la quantità di hardware necessario. Tuttavia, poiché istruzioni diverse richiedono percorsi dei dati diversi, è necessario aggiungere multiplexer e segnali di controllo per selezionare il funzionamento corretto in ogni caso.

---

## 31. Che cosa si intende per unità di elaborazione unificata?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per unità di elaborazione unificata si intende un datapath unico capace di eseguire più classi di istruzioni.
>
> Invece di costruire un datapath separato per le istruzioni di tipo R, uno per load e store e uno per i branch, si combinano gli elementi comuni in una sola struttura.
>
> Questa unità contiene, tra gli altri, PC, memoria istruzioni, register file, ALU, memoria dati, sommatori, unità di estensione del segno e multiplexer. I segnali di controllo stabiliscono quali percorsi devono essere attivati per l’istruzione corrente.

---

## 32. Quali operazioni principali deve svolgere il datapath per eseguire una istruzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il datapath deve svolgere alcune operazioni fondamentali.
>
> Prima di tutto deve prelevare l’istruzione dalla memoria istruzioni usando il PC. Poi deve leggere gli eventuali registri sorgente dal register file.
>
> Successivamente deve eseguire l’operazione richiesta: può trattarsi di un’operazione aritmetico-logica, del calcolo di un indirizzo di memoria, oppure del confronto tra due registri per un branch.
>
> Infine, se necessario, deve accedere alla memoria dati, scrivere un risultato nel register file e aggiornare il PC con l’indirizzo dell’istruzione successiva o con l’indirizzo di destinazione di un salto.

---

## 33. Perché la memoria istruzioni e la memoria dati sono rappresentate come elementi separati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La memoria istruzioni e la memoria dati sono rappresentate come elementi separati per semplificare il datapath e permettere di accedere contemporaneamente a istruzioni e dati.
>
> La memoria istruzioni viene usata nella fase di fetch per leggere l’istruzione indicata dal PC. La memoria dati viene invece usata solo dalle istruzioni di load e store per leggere o scrivere dati.
>
> Questa separazione consente di mostrare più chiaramente i diversi percorsi: uno per il prelievo delle istruzioni e uno per l’accesso ai dati.

---

## 34. Qual è la differenza tra il valore scritto nel register file da una istruzione di tipo R e da una load?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una istruzione di tipo R, il valore scritto nel register file è il risultato prodotto dalla ALU.
>
> Per esempio, in una `add`, la ALU somma due valori letti dai registri e il risultato viene scritto nel registro di destinazione.
>
> In una istruzione di load, invece, la ALU non produce il dato finale da scrivere, ma calcola l’indirizzo di memoria. Il valore scritto nel register file è quindi il dato letto dalla memoria dati.
>
> Per questo motivo serve il multiplexer controllato da `MemtoReg`, che sceglie se scrivere nel register file il risultato della ALU o il dato proveniente dalla memoria.

---

## 35. Quali segnali di controllo sono necessari per distinguere le principali classi di istruzioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per distinguere le principali classi di istruzioni servono diversi segnali di controllo.
>
> `RegWrite` stabilisce se scrivere nel register file. `ALUSrc` seleziona il secondo ingresso della ALU, scegliendo tra un registro e un immediato esteso. `MemRead` abilita la lettura dalla memoria dati. `MemWrite` abilita la scrittura nella memoria dati. `MemtoReg` seleziona il valore da scrivere nel register file, scegliendo tra risultato della ALU e dato letto dalla memoria. `PCSrc` seleziona il prossimo valore del PC.
>
> A questi si aggiungono i segnali che determinano quale operazione deve eseguire la ALU. Insieme, questi segnali permettono al datapath unificato di eseguire correttamente istruzioni di tipo R, load, store e branch.

---

## 36. Come si comportano i segnali principali durante una istruzione di tipo R?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante una istruzione di tipo R, il register file legge due registri sorgente e la ALU esegue l’operazione richiesta.
>
> Il secondo ingresso della ALU deve provenire dal secondo registro letto, quindi `ALUSrc` seleziona il dato del register file. Il risultato della ALU viene scritto nel registro di destinazione, quindi `RegWrite` è attivo.
>
> La memoria dati non viene usata, quindi `MemRead` e `MemWrite` non sono attivi. Il valore da scrivere nel registro proviene dalla ALU, quindi `MemtoReg` seleziona il risultato della ALU. Il PC viene aggiornato normalmente con `PC + 4`.

---

## 37. Come si comportano i segnali principali durante una istruzione lw?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante una istruzione `lw`, la ALU calcola l’indirizzo effettivo di memoria sommando il registro base e l’offset immediato esteso di segno.
>
> Per questo motivo `ALUSrc` seleziona l’immediato esteso come secondo ingresso della ALU. La memoria dati viene letta, quindi `MemRead` è attivo, mentre `MemWrite` non è attivo.
>
> Il dato letto dalla memoria deve essere scritto nel register file, quindi `RegWrite` è attivo e `MemtoReg` seleziona il dato proveniente dalla memoria. Il PC viene aggiornato normalmente con `PC + 4`.

---

## 38. Come si comportano i segnali principali durante una istruzione sw?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante una istruzione `sw`, la ALU calcola l’indirizzo effettivo di memoria sommando il registro base e l’offset immediato esteso di segno.
>
> Quindi `ALUSrc` seleziona l’immediato esteso come secondo ingresso della ALU. La memoria dati deve essere scritta, quindi `MemWrite` è attivo, mentre `MemRead` non è attivo.
>
> Il dato da scrivere in memoria proviene dal secondo registro letto dal register file. Poiché una store non scrive alcun risultato nei registri, `RegWrite` non è attivo e il valore di `MemtoReg` non è rilevante. Il PC viene aggiornato normalmente con `PC + 4`.

---

## 39. Come si comportano i segnali principali durante una istruzione beq?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante una istruzione `beq`, il datapath deve confrontare due registri e, se sono uguali, modificare il PC con l’indirizzo di destinazione del salto.
>
> Il register file legge i due registri sorgente. La ALU sottrae i due valori per verificare se sono uguali. Se il risultato è zero, il segnale `Zero` viene attivato.
>
> La memoria dati non viene usata, quindi `MemRead` e `MemWrite` non sono attivi. Il register file non viene scritto, quindi `RegWrite` non è attivo. Il segnale `PCSrc`, combinando il fatto che l’istruzione è un branch con il segnale `Zero`, decide se il PC deve diventare l’indirizzo di salto oppure `PC + 4`.

---

## 40. Perché il datapath descritto può eseguire le istruzioni in un singolo ciclo di clock?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il datapath descritto può eseguire le istruzioni in un singolo ciclo di clock perché tutti i componenti necessari all’esecuzione di una istruzione sono attraversati all’interno dello stesso ciclo.
>
> Durante il ciclo, l’istruzione viene prelevata, i registri vengono letti, la ALU esegue l’operazione richiesta, eventualmente si accede alla memoria dati e infine si scrive il risultato nel register file o si aggiorna il PC.
>
> Questo modello è semplice da capire, ma richiede che il ciclo di clock sia abbastanza lungo da contenere il percorso più lento tra tutte le istruzioni possibili, spesso quello delle istruzioni di load.

---

## 41. Perché il datapath a singolo ciclo può risultare inefficiente?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il datapath a singolo ciclo può risultare inefficiente perché tutte le istruzioni devono completarsi nello stesso intervallo di clock, anche se alcune sono molto più semplici di altre.
>
> Il periodo di clock deve essere abbastanza lungo da permettere l’esecuzione dell’istruzione più lenta, per esempio una `lw`, che deve leggere l’istruzione, leggere il register file, calcolare l’indirizzo, accedere alla memoria dati e scrivere nel registro.
>
> Di conseguenza, anche istruzioni più semplici, come quelle di tipo R, sono costrette a usare lo stesso tempo di ciclo, pur non avendo bisogno di attraversare tutti quei componenti.

---

## 42. Qual è il ruolo dell’unità di controllo rispetto al datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità di controllo ha il compito di generare i segnali che guidano il datapath.
>
> A partire dal campo operativo dell’istruzione, l’unità di controllo stabilisce quali componenti devono essere attivati, quali multiplexer devono selezionare un ingresso piuttosto che un altro, se la memoria dati deve essere letta o scritta, se il register file deve essere scritto e quale operazione deve eseguire la ALU.
>
> Il datapath contiene quindi l’hardware che trasporta ed elabora i dati, mentre l’unità di controllo decide come questo hardware deve essere usato per l’istruzione corrente.

---

## 43. Perché il campo immediato deve essere ricostruito in modo diverso a seconda del tipo di istruzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il campo immediato deve essere ricostruito in modo diverso perché RISC-V usa formati di istruzione diversi per classi di istruzioni diverse.
>
> Per le istruzioni di load, store e branch, i bit dell’immediato non si trovano sempre nelle stesse posizioni dell’istruzione. L’unità che genera la costante immediata deve quindi sapere quale formato sta interpretando e selezionare i bit corretti.
>
> Dopo aver ricostruito l’immediato, l’unità lo estende di segno a 32 bit, così che possa essere usato dalla ALU o dal sommatore che calcola l’indirizzo di salto.

---

## 44. Perché il registro x0 non deve essere realmente scritto anche se un’istruzione lo indica come destinazione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In RISC-V il registro `x0` contiene sempre il valore zero. Per definizione, qualsiasi tentativo di scrivere in `x0` non deve modificarne il contenuto.
>
> Per questo motivo il register file deve essere progettato in modo che le scritture verso il registro 0 vengano ignorate oppure non abbiano effetto.
>
> Questo comportamento è importante perché molte istruzioni possono usare `x0` come sorgente del valore zero o come destinazione apparente quando si vuole scartare un risultato.

---

## 45. Riassumi il percorso dei dati per istruzioni di tipo R, lw, sw e beq.

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nelle istruzioni di tipo R, il PC preleva l’istruzione, il register file legge due registri sorgente, la ALU esegue l’operazione richiesta e il risultato viene scritto nel registro di destinazione. Il PC viene poi aggiornato con `PC + 4`.
>
> Nelle istruzioni `lw`, il register file legge il registro base, l’immediato viene esteso di segno, la ALU calcola l’indirizzo effettivo, la memoria dati viene letta e il dato ottenuto viene scritto nel registro di destinazione.
>
> Nelle istruzioni `sw`, il register file legge il registro base e il registro contenente il dato da scrivere. La ALU calcola l’indirizzo effettivo usando il registro base e l’immediato esteso. La memoria dati scrive il dato nel punto indicato dall’indirizzo calcolato.
>
> Nelle istruzioni `beq`, il register file legge due registri, la ALU li confronta tramite sottrazione e produce il segnale `Zero`. Se la condizione è vera, il PC viene aggiornato con l’indirizzo di destinazione del salto; altrimenti viene aggiornato con `PC + 4`.