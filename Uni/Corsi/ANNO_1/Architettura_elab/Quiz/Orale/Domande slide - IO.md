
# Input-Output

## Metodo di ripasso

Ripassa questa sezione confrontando sempre i tre modi principali di gestire l’I/O: **busy waiting**, **interrupt** e **DMA**.  
Per l’orale è importante saper spiegare **chi controlla il trasferimento**, **quando interviene la CPU**, **cosa viene salvato durante un’interruzione** e **quali registri RISC-V sono coinvolti nella gestione delle eccezioni**.

---

## 1. Quali sono i principali modi di gestire l’I/O a livello ISA?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> I principali modi di gestire l’I/O sono:
> 
> - **I/O programmato con busy waiting**, in cui la CPU controlla continuamente lo stato della periferica;
>     
> - **I/O controllato da interrupt**, in cui la periferica avvisa la CPU quando ha bisogno di attenzione;
>     
> - **I/O in DMA**, in cui un componente dedicato trasferisce dati direttamente tra periferica e memoria, riducendo il lavoro della CPU.
>     
> 
> La differenza fondamentale è il grado di coinvolgimento della CPU: massimo nel busy waiting, minore con interrupt, ancora più ridotto con DMA.

---

## 2. Come comunica la CPU con i dispositivi di I/O?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La CPU non comunica direttamente con le periferiche, ma tramite i **controllori di I/O**.
> 
> Il controllore traduce:
> 
> - i comandi della CPU in segnali elettrici per la periferica;
>     
> - i segnali della periferica in dati comprensibili dalla CPU.
>     
> 
> Ogni controllore contiene registri identificati da indirizzi. Questi indirizzi possono appartenere:
> 
> - allo stesso spazio di indirizzi della memoria, nel caso di **memory mapped I/O**;
>     
> - a uno spazio separato, nel caso di **isolated I/O**.
>     
> 
> Per questo motivo, la comunicazione con i controllori è simile agli accessi in memoria.

---

## 3. Quali tipi di registri si trovano nei controllori di I/O?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Nei controllori di I/O si trovano principalmente tre tipi di registri:
> 
> - **registri dati**, usati per contenere i dati in ingresso o in uscita;
>     
> - **registri comando**, usati dalla CPU per inviare ordini alla periferica;
>     
> - **registri di stato**, usati dalla periferica per comunicare alla CPU il proprio stato.
>     
> 
> Per esempio, in una stampante i registri dati possono contenere i dati da stampare, i registri comando possono contenere il comando di stampa e i registri di stato possono indicare se la stampante è pronta o occupata.

---

## 4. Che cos’è l’I/O programmato con busy waiting?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Nell’**I/O programmato con busy waiting**, la CPU controlla continuamente lo stato della periferica leggendo un bit del registro di stato del controllore, per esempio il bit **READY**.
> 
> La CPU rimane in un ciclo finché il dispositivo non segnala di essere pronto per un nuovo comando di I/O.
> 
> Questo controllo ciclico prende il nome di **polling**.
> 
> Lo svantaggio principale è che la CPU resta occupata ad attendere il dispositivo e non può svolgere lavoro utile nel frattempo.

---

## 5. Come funziona una lettura da tastiera con busy waiting?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In una lettura da tastiera con busy waiting:
> 
> 1. quando viene premuto un tasto, il controllore della tastiera mette a 1 un bit del registro di stato;
>     
> 2. il controllore inserisce nel buffer il codice ASCII del carattere premuto;
>     
> 3. la CPU legge ripetutamente il registro di stato finché trova il bit uguale a 1;
>     
> 4. la CPU legge il buffer;
>     
> 5. la CPU trasferisce il dato per l’elaborazione e azzera il bit di stato.
>     
> 
> Il punto critico è che la CPU spreca tempo controllando continuamente se il dato è disponibile.

---

## 6. Come funziona una scrittura su display con busy waiting?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In una scrittura su display con busy waiting:
> 
> 1. la CPU attende che il dispositivo sia pronto, cioè che il bit **Ready** sia uguale a 1;
>     
> 2. la CPU invia il carattere nel buffer del display;
>     
> 3. il controllore azzera il bit Ready e visualizza il contenuto del buffer;
>     
> 4. quando il display è pronto per un nuovo carattere, il controllore rimette Ready a 1.
>     
> 
> Anche qui la CPU resta coinvolta direttamente nell’attesa della periferica.

---

## 7. Che cos’è un interrupt e perché elimina il busy waiting?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un **interrupt** è un segnale generato da un dispositivo per avvisare la CPU che un’operazione di I/O è terminata o richiede attenzione.
> 
> Con gli interrupt, la CPU non deve controllare continuamente il registro di stato della periferica. Può eseguire altro codice e viene interrotta solo quando il dispositivo ha bisogno di essere servito.
> 
> Per questo motivo gli interrupt eliminano il problema del busy waiting.
> 
> La CPU può abilitare gli interrupt impostando a 1 un apposito bit.

---

## 8. Che cosa succede quando arriva un interrupt hardware?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un interrupt hardware è un cambiamento del flusso di controllo causato da una periferica, non dal programma in esecuzione.
> 
> In generale:
> 
> 1. il dispositivo asserisce una linea di interrupt del bus;
>     
> 2. la CPU, quando è pronta, invia un acknowledge;
>     
> 3. il controllore invia un vettore di interrupt;
>     
> 4. la CPU salva il PC e altri registri di stato;
>     
> 5. il vettore di interrupt viene usato per trovare il gestore corretto;
>     
> 6. il PC viene modificato per eseguire il gestore dell’interrupt;
>     
> 7. terminata la gestione, il controllo torna al programma interrotto.
>     
> 
> L’interrupt deve essere gestito in modo trasparente, cioè dopo la gestione il programma deve riprendere come se nulla fosse successo.

---

## 9. Quali sono le azioni software tipiche di un gestore di interrupt?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il gestore di interrupt esegue una serie di azioni software:
> 
> - salva i registri necessari, cioè lo stato del programma interrotto;
>     
> - legge le informazioni dal buffer del dispositivo;
>     
> - gestisce eventuali errori di I/O;
>     
> - aggiorna eventuali variabili, come puntatori e contatori;
>     
> - invia eventualmente nuovi dati al dispositivo;
>     
> - ripristina i registri salvati;
>     
> - esegue un’istruzione di ritorno da interrupt, come **RETI** o, nel caso RISC-V supervisor, **SRET**.
>     
> 
> Lo scopo è servire la periferica senza alterare lo stato logico del programma interrotto.

---

## 10. Qual è la differenza tra interrupt e trap/eccezione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La differenza principale riguarda il rapporto con il programma in esecuzione.
> 
> Gli **interrupt** sono eventi asincroni, cioè non dipendono direttamente dall’istruzione eseguita in quel momento. Per esempio, la pressione di un tasto o il movimento del mouse.
> 
> Le **trap** o **eccezioni sincrone** sono invece legate all’esecuzione del programma. Possono essere causate da condizioni eccezionali, come overflow o divisione per zero, oppure da istruzioni che richiedono servizi del sistema operativo, come una system call.
> 
> Quindi:
> 
> - interrupt: evento esterno e asincrono;
>     
> - trap/eccezione: evento interno o richiesta esplicita, sincrona rispetto al programma.
>     

---

## 11. Che cos’è il DMA e qual è il suo vantaggio?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il **DMA**, cioè **Direct Memory Access**, è una tecnica in cui un componente dedicato trasferisce dati direttamente tra periferica e memoria.
> 
> La CPU o il sistema operativo inizializzano opportuni registri del DMA, indicando per esempio:
> 
> - indirizzo di memoria;
>     
> - quantità di dati da trasferire;
>     
> - dispositivo coinvolto;
>     
> - direzione del trasferimento.
>     
> 
> Dopo l’inizializzazione, il DMA svolge il trasferimento senza richiedere alla CPU di copiare ogni singolo dato.
> 
> Il vantaggio è che la CPU viene liberata da gran parte del lavoro di trasferimento. Tuttavia CPU e DMA possono contendersi l’uso del bus.

---

## 12. Che cosa succede in RISC-V quando si verifica un’eccezione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In RISC-V, quando si verifica un’eccezione, il programma in esecuzione viene sospeso e il controllo passa a un **Exception Handler**.
> 
> Il processore salva informazioni fondamentali in registri speciali:
> 
> - **SEPC**, che contiene l’indirizzo dell’istruzione in cui si è verificata l’eccezione;
>     
> - **SCAUSE**, che indica la causa dell’eccezione;
>     
> - **SSTATUS**, che contiene informazioni di stato, tra cui l’abilitazione globale degli interrupt;
>     
> - **STVEC**, che contiene l’indirizzo base del gestore o della tabella dei vettori.
>     
> 
> Al verificarsi dell’eccezione, la CPU modifica almeno **SEPC**, **SSTATUS**, **SCAUSE** e **PC**.
> 
> Il gestore viene eseguito in modalità protetta, cioè in **supervisor/kernel mode**.

---

## 13. Quali tipi di eccezioni sono presenti nel modello RISC-V descritto?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> I principali tipi di eccezione descritti sono:
> 
> - **interrupt**, causati da eventi esterni, come I/O, pressione di un tasto o movimento del mouse;
>     
> - **errori**, causati da eventi interni, come overflow o divisione per zero;
>     
> - **environment call**, cioè l’istruzione **ecall**, usata per richiedere un servizio di sistema;
>     
> - **environment break**, cioè l’istruzione **ebreak**, usata per debugging o motivi diagnostici.
>     
> 
> Gli interrupt sono asincroni, mentre errori, ecall ed ebreak sono sincroni rispetto al programma.

---

## 14. Che requisiti deve rispettare un Exception Handler?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un **Exception Handler** deve rispettare alcuni requisiti fondamentali:
> 
> - non deve modificare lo stato dell’applicazione interrotta;
>     
> - deve preservare i registri, per esempio i registri x1…x31 e, se presenti, anche f0…f31;
>     
> - deve essere eseguito in modalità protetta, cioè kernel/supervisor mode;
>     
> - deve gestire le eccezioni una alla volta, oppure usare priorità e riabilitazione controllata;
>     
> - deve terminare con un’istruzione speciale di ritorno, come **SRET** in RISC-V.
>     
> 
> In RISC-V il gestore salva solo i registri che usa, per esempio nello stack.

---

## 15. Qual è la differenza tra salto diretto e vettore di interruzione nella gestione delle eccezioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Esistono due metodi principali per trovare il gestore di un’eccezione.
> 
> Nel **salto diretto**, il processore salta a un indirizzo base:
> 
> - `PC ← base`
>     
> 
> In RISC-V l’indirizzo base è contenuto nel registro **STVEC**. Questo metodo è veloce, ma il gestore deve poi analizzare la causa dell’eccezione, usando per esempio **SCAUSE**.
> 
> Nel **vettore di interruzione**, esiste una tabella con gli indirizzi delle routine di gestione. L’indirizzo viene trovato usando la causa dell’eccezione:
> 
> - `PC ← MEM[base + cause * 4]`
>     
> 
> In questo caso la causa permette di raggiungere direttamente il gestore specifico.

---

## 16. A cosa servono i principali registri speciali CSR usati nelle eccezioni RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> I principali registri speciali, detti **CSR** cioè **Control-Status Registers**, sono:
> 
> - **SEPC**, contiene l’indirizzo dell’istruzione coinvolta nell’eccezione;
>     
> - **SCAUSE**, codifica la causa dell’eccezione;
>     
> - **SSTATUS**, contiene informazioni di stato e bit di abilitazione degli interrupt;
>     
> - **STVAL**, contiene informazioni aggiuntive, per esempio l’indirizzo di memoria errato;
>     
> - **SIP**, indica gli interrupt pendenti;
>     
> - **SIE**, contiene abilitazioni più fini per gli interrupt;
>     
> - **STVEC**, contiene l’indirizzo base del gestore o del vettore di interrupt;
>     
> - **SSCRATCH**, usato per salvataggi temporanei.
>     
> 
> Questi registri permettono al processore e al sistema operativo di salvare il contesto, capire la causa dell’evento e riprendere correttamente l’esecuzione.

---

## 17. Come è fatto il registro SCAUSE e a cosa serve?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il registro **SCAUSE** serve a identificare la sorgente dell’eccezione.
> 
> Contiene almeno:
> 
> - un bit **Int**, che vale 1 se la sorgente è un interrupt e 0 se è un’eccezione;
>     
> - un campo **Code**, che codifica la causa specifica.
>     
> 
> Alcuni esempi di codici sono:
> 
> - instruction address misaligned;
>     
> - illegal instruction;
>     
> - breakpoint;
>     
> - load address misaligned;
>     
> - load address fault;
>     
> - store address misaligned;
>     
> - store address fault;
>     
> - environment call from U-mode;
>     
> - environment call from S-mode;
>     
> - instruction page fault.
>     
> 
> SCAUSE è quindi essenziale per decidere quale azione deve compiere il gestore.

---

## 18. Quali istruzioni speciali RISC-V sono legate a CSR, sistema ed eccezioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Le istruzioni speciali RISC-V includono istruzioni per accedere ai registri CSR e istruzioni di sistema.
> 
> Per i registri CSR ci sono istruzioni come:
> 
> - **CSRRW**, lettura/scrittura CSR;
>     
> - **CSRRS**, lettura/impostazione CSR;
>     
> - **CSRRC**, lettura/azzeramento CSR;
>     
> - versioni immediate come **CSRRWI**, **CSRRSI**, **CSRRCI**.
>     
> 
> Le istruzioni di sistema includono:
> 
> - **ECALL**, chiamata di ambiente, usata per richiedere un servizio al sistema operativo;
>     
> - **EBREAK**, breakpoint di ambiente, usato per debugging;
>     
> - **SRET**, ritorno da eccezione del supervisore;
>     
> - **WFI**, attesa di interrupt.
>     
> 
> Queste istruzioni sono fondamentali per la gestione controllata delle eccezioni e del passaggio tra user mode e supervisor mode.