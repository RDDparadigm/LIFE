# Capitolo 2.1 — Introduzione al linguaggio macchina e a RISC-V

## Metodo di ripasso

Ripassa questa sezione puntando su tre idee fondamentali:

1. che cos’è un **insieme delle istruzioni**;
2. perché architetture diverse hanno linguaggi simili;
3. qual è il ruolo del **concetto di programma memorizzato**.

Per la tabella RISC-V non cercare di imparare ogni istruzione a memoria: concentrati sulle grandi famiglie di istruzioni e sul significato generale di operandi, registri, memoria, salti e operazioni aritmetico-logiche.

---

## 1. Che cosa si intende per insieme delle istruzioni di un calcolatore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’**insieme delle istruzioni**, o *instruction set*, è il vocabolario dei comandi che l’hardware di un calcolatore è in grado di comprendere ed eseguire.
>
> In altre parole, rappresenta il linguaggio macchina della specifica architettura.
>
> Ogni programma scritto in un linguaggio ad alto livello, per poter essere eseguito, deve essere tradotto in istruzioni appartenenti all’instruction set della macchina.
>
> L’insieme delle istruzioni è quindi il punto di contatto tra software e hardware: descrive quali operazioni elementari il processore sa svolgere.

---

## 2. Perché molti linguaggi macchina, pur essendo diversi, si assomigliano tra loro?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I linguaggi macchina sono diversi perché ogni architettura può avere un proprio insieme di istruzioni, ma si assomigliano perché tutti i calcolatori moderni si basano su principi progettuali simili.
>
> In particolare, tutti devono permettere operazioni fondamentali come:
>
> - elaborare dati;
> - leggere e scrivere in memoria;
> - prendere decisioni tramite salti condizionati;
> - modificare il flusso di esecuzione di un programma.
>
> Inoltre i progettisti cercano spesso lo stesso obiettivo: realizzare un linguaggio macchina abbastanza semplice da essere implementato efficientemente in hardware, ma abbastanza potente da supportare i linguaggi di programmazione.

---

## 3. Qual è l’idea centrale del principio “semplicità dei dispositivi”?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il principio della **semplicità dei dispositivi** afferma che un’architettura dovrebbe avere un insieme di istruzioni semplice e regolare, perché questo rende più facile costruire l’hardware, verificarne il funzionamento e ottenere buone prestazioni.
>
> Un insieme di istruzioni troppo complesso può rendere più difficile la progettazione del processore e può peggiorare l’efficienza.
>
> Questo principio è particolarmente importante nelle architetture di tipo RISC, come RISC-V, che cercano di usare istruzioni semplici, regolari e facilmente implementabili.

---

## 4. Che cos’è RISC-V e perché viene usato come architettura di riferimento nel capitolo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> **RISC-V** è un insieme di istruzioni di tipo RISC sviluppato a partire dal 2010 all’Università di Berkeley.
>
> Viene usato come architettura di riferimento perché è semplice, moderno e adatto a mostrare i concetti fondamentali del linguaggio macchina.
>
> Il nome RISC indica un’architettura basata sull’idea di un insieme ridotto e regolare di istruzioni.
>
> Studiare RISC-V permette quindi di capire i principi generali dell’architettura degli elaboratori senza partire da un instruction set troppo complesso.

---

## 5. Che cosa sono MIPS e Intel x86 e perché vengono citati insieme a RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> **MIPS** e **Intel x86** sono altri esempi importanti di insiemi di istruzioni.
>
> MIPS è un’architettura RISC progettata a partire dagli anni ’80 ed è molto simile a RISC-V.
>
> Intel x86 è invece un’architettura nata negli anni ’70, ancora oggi molto usata nei personal computer e nei server.
>
> Vengono citate per mostrare che esistono più instruction set, ma che molti concetti fondamentali sono comuni: registri, memoria, istruzioni aritmetiche, istruzioni logiche, salti e trasferimenti di dati.

---

## 6. Che cosa significa dire che un calcolatore usa il concetto di programma memorizzato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **concetto di programma memorizzato** indica che le istruzioni di un programma e i dati vengono conservati nella memoria del calcolatore.
>
> Il processore preleva le istruzioni dalla memoria, le interpreta e le esegue una dopo l’altra.
>
> Questo principio è fondamentale perché permette al calcolatore di eseguire programmi diversi semplicemente caricando in memoria sequenze diverse di istruzioni.
>
> In questo modo il comportamento della macchina non è fissato una volta per tutte dall’hardware, ma può essere modificato tramite il software.

---

## 7. Qual è il rapporto tra linguaggio di programmazione ad alto livello, assembly e linguaggio macchina?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un linguaggio di programmazione ad alto livello, come C o Java, è pensato per essere scritto e letto facilmente dagli esseri umani.
>
> Tuttavia, il processore non esegue direttamente queste istruzioni: il programma deve essere tradotto in istruzioni macchina appartenenti all’instruction set dell’architettura.
>
> Il linguaggio **assembly** è una rappresentazione simbolica del linguaggio macchina: usa nomi leggibili, come `add`, `lw` o `beq`, al posto delle codifiche binarie.
>
> Quindi il rapporto è:
>
> - linguaggio ad alto livello: vicino al programmatore;
> - assembly: forma simbolica delle istruzioni macchina;
> - linguaggio macchina: forma effettivamente eseguita dall’hardware.

---

## 8. Quali sono i principali operandi in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In RISC-V gli operandi principali sono i **registri** e la **memoria**.
>
> I registri sono piccole locazioni interne al processore usate per contenere temporaneamente i dati su cui operano le istruzioni.
>
> Nel caso mostrato, RISC-V dispone di **32 registri**, indicati da `x0` a `x31`.
>
> La memoria contiene invece dati e istruzioni ed è indirizzata tramite indirizzi. In RISC-V gli accessi alla memoria avvengono tramite specifiche istruzioni di caricamento e memorizzazione.
>
> Una caratteristica importante è che molte istruzioni aritmetiche e logiche lavorano direttamente sui registri, non direttamente sulla memoria.

---

## 9. Perché in RISC-V molte istruzioni aritmetiche e logiche lavorano su registri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In RISC-V molte istruzioni aritmetiche e logiche lavorano su registri perché i registri sono molto più veloci della memoria.
>
> Questo segue il principio delle architetture RISC: mantenere le istruzioni semplici e regolari.
>
> Le operazioni come somma, sottrazione, AND, OR o XOR prendono gli operandi dai registri e scrivono il risultato in un registro.
>
> Se un dato si trova in memoria, deve prima essere caricato in un registro con un’istruzione di load; dopo l’elaborazione, può essere scritto di nuovo in memoria con un’istruzione di store.

---

## 10. Quali sono le principali famiglie di istruzioni RISC-V mostrate nella tabella?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le principali famiglie di istruzioni RISC-V mostrate sono:
>
> - **istruzioni aritmetiche**, come somma e sottrazione;
> - **istruzioni di trasferimento dati**, per leggere dalla memoria o scrivere in memoria;
> - **istruzioni logiche**, come AND, OR e XOR;
> - **istruzioni di scorrimento**, che spostano i bit a sinistra o a destra;
> - **salti condizionati**, che modificano il flusso del programma solo se una condizione è vera;
> - **salti incondizionati**, che modificano sempre il flusso di esecuzione.
>
> Questa classificazione è importante perché mostra che un programma macchina è costruito combinando poche categorie fondamentali di operazioni.

---

## 11. Che differenza c’è tra istruzioni di trasferimento dati, istruzioni aritmetiche e istruzioni di salto?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le **istruzioni di trasferimento dati** servono a spostare informazioni tra memoria e registri. Esempi tipici sono le istruzioni di load, che leggono dalla memoria, e le istruzioni di store, che scrivono in memoria.
>
> Le **istruzioni aritmetiche** servono a eseguire operazioni numeriche, come somma e sottrazione, di solito usando valori contenuti nei registri.
>
> Le **istruzioni di salto** servono invece a modificare il normale ordine sequenziale di esecuzione del programma.
>
> I salti possono essere:
>
> - condizionati, se dipendono dal risultato di un confronto;
> - incondizionati, se vengono sempre eseguiti.
>
> Insieme, queste tre famiglie permettono di costruire programmi completi: manipolare dati, conservarli o recuperarli dalla memoria, e controllare il flusso dell’esecuzione.

---

## 12. A cosa servono i salti condizionati in un linguaggio macchina?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I **salti condizionati** servono a far dipendere il flusso del programma da una condizione.
>
> Per esempio, un’istruzione può dire: se due registri sono uguali, allora salta a un’altra istruzione; altrimenti continua con l’istruzione successiva.
>
> In RISC-V esempi di salti condizionati sono:
>
> - `beq`, salto se due valori sono uguali;
> - `bne`, salto se due valori sono diversi;
> - `blt`, salto se un valore è minore di un altro;
> - `bge`, salto se un valore è maggiore o uguale a un altro.
>
> Queste istruzioni sono fondamentali per implementare costrutti dei linguaggi ad alto livello come `if`, `else`, `while` e `for`.

---

## 13. Qual è la differenza tra un salto condizionato e un salto incondizionato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **salto condizionato** viene eseguito solo se una certa condizione è vera.
>
> Per esempio, `beq x5, x6, 100` fa saltare il programma solo se il contenuto di `x5` è uguale al contenuto di `x6`.
>
> Un **salto incondizionato**, invece, modifica sempre il flusso di esecuzione, senza controllare alcuna condizione.
>
> In RISC-V un esempio è `jal`, che salta a un indirizzo relativo al program counter e salva anche l’indirizzo di ritorno.
>
> La differenza fondamentale è quindi che il salto condizionato serve per prendere decisioni, mentre il salto incondizionato serve per trasferire direttamente il controllo a un’altra parte del programma.

---

## 14. Che ruolo ha il program counter nei salti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **program counter**, o PC, contiene l’indirizzo dell’istruzione corrente o della prossima istruzione da eseguire.
>
> Normalmente, durante l’esecuzione sequenziale, il PC viene aggiornato per puntare all’istruzione successiva.
>
> Le istruzioni di salto modificano invece il valore del PC, facendo proseguire l’esecuzione da un altro punto del programma.
>
> Nei salti relativi al PC, l’indirizzo di destinazione viene calcolato sommando uno spostamento al valore corrente del program counter.
>
> Questo meccanismo permette di implementare cicli, condizioni, chiamate di funzione e ritorni.

---

## 15. Perché la tabella delle istruzioni RISC-V non va studiata solo come elenco mnemonico?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La tabella delle istruzioni RISC-V non va studiata solo come elenco mnemonico perché l’obiettivo principale non è memorizzare ogni singola istruzione, ma capire la logica dell’instruction set.
>
> È più importante riconoscere:
>
> - quali istruzioni lavorano sui registri;
> - quali istruzioni leggono o scrivono in memoria;
> - quali istruzioni svolgono operazioni aritmetiche o logiche;
> - quali istruzioni modificano il flusso del programma;
> - come vengono usati registri, memoria e program counter.
>
> Una volta compresi questi gruppi, diventa più semplice interpretare anche istruzioni non ancora viste, perché seguono schemi regolari.