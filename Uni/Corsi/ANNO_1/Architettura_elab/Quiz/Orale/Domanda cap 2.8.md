
# Capitolo 2.8 — Supporto hardware alle procedure

## Metodo di ripasso

Ripassa questa sezione concentrandoti sul “viaggio” di una chiamata a procedura: passaggio dei parametri, salto alla procedura, salvataggio dei registri, uso dello stack, ritorno al chiamante.  
Per l’orale è importante saper distinguere bene tra registri salvati dal chiamante e registri salvati dal chiamato, e spiegare perché servono stack pointer, return address e frame pointer.

---

## 1. Che cos’è una procedura e perché è importante nell’architettura degli elaboratori?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una procedura è un sottoprogramma che svolge un compito specifico usando parametri forniti dal programma chiamante.
>
> Le procedure permettono di:
> - organizzare meglio il programma;
> - riutilizzare codice;
> - implementare l’astrazione del software;
> - dividere un problema complesso in parti più semplici.
>
> Dal punto di vista dell’architettura, una procedura richiede supporto hardware perché bisogna gestire:
> - il passaggio dei parametri;
> - il salto al codice della procedura;
> - il ritorno al punto corretto del programma chiamante;
> - il salvataggio e il ripristino dei registri;
> - l’eventuale uso dello stack.

---

## 2. Quali sono i passi principali nell’esecuzione di una procedura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per eseguire una procedura, il programma deve normalmente:
>
> 1. mettere i parametri in un luogo accessibile alla procedura;
> 2. trasferire il controllo alla procedura;
> 3. acquisire le risorse necessarie alla procedura;
> 4. eseguire il compito richiesto;
> 5. mettere il risultato in un luogo accessibile al programma chiamante;
> 6. restituire il controllo al punto corretto del programma chiamante.
>
> In RISC-V molti di questi passaggi sono gestiti tramite registri e istruzioni specifiche di salto.

---

## 3. Quali registri usa RISC-V per passare parametri e restituire risultati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> RISC-V usa convenzionalmente i registri `x10-x17` per il passaggio dei parametri e la restituzione dei risultati.
>
> Questi registri sono anche chiamati registri argomento/risultato.
>
> Per esempio:
> - `x10` può contenere il primo parametro;
> - `x11` il secondo parametro;
> - e così via fino a `x17`.
>
> Se una procedura restituisce un risultato, questo viene normalmente messo in `x10`.

---

## 4. Qual è il ruolo dell’istruzione `jal` nella chiamata a procedura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’istruzione `jal`, cioè *jump and link*, serve per chiamare una procedura.
>
> La forma tipica è:
>
> ```asm
> jal x1, IndirizzoProcedura
> ```
>
> Questa istruzione fa due cose:
>
> 1. salta all’indirizzo della procedura;
> 2. salva nel registro `x1` l’indirizzo di ritorno, cioè l’indirizzo dell’istruzione successiva alla chiamata.
>
> Il registro `x1` è detto anche `ra`, cioè *return address*.

---

## 5. Che cos’è l’indirizzo di ritorno e perché viene salvato nel registro `x1`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’indirizzo di ritorno è l’indirizzo dell’istruzione a cui il programma deve tornare dopo aver terminato la procedura.
>
> Quando viene eseguita una chiamata con `jal`, RISC-V salva automaticamente questo indirizzo nel registro `x1`, chiamato anche `ra`.
>
> Questo è necessario perché la stessa procedura può essere chiamata da punti diversi del programma: senza salvare l’indirizzo di ritorno, la procedura non saprebbe dove restituire il controllo.

---

## 6. Come avviene il ritorno da una procedura in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il ritorno da una procedura avviene tramite l’istruzione `jalr`, cioè *jump and link register*.
>
> La forma tipica è:
>
> ```asm
> jalr x0, 0(x1)
> ```
>
> Questa istruzione salta all’indirizzo contenuto in `x1`, cioè al return address.
>
> Poiché il registro destinazione è `x0`, non viene salvato un nuovo indirizzo di ritorno. In pratica, `jalr x0, 0(x1)` significa: “torna al programma chiamante”.

---

## 7. Qual è la differenza tra programma chiamante e procedura chiamata?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il programma chiamante è la parte di codice che invoca una procedura e le fornisce i parametri necessari.
>
> La procedura chiamata è la procedura che viene eseguita dopo la chiamata.
>
> Durante la chiamata:
> - il chiamante prepara i parametri;
> - la procedura chiamata esegue il proprio compito;
> - la procedura chiamata restituisce eventualmente un risultato;
> - il controllo torna al chiamante.
>
> Questa distinzione è importante perché alcuni registri devono essere preservati dal chiamante, altri dalla procedura chiamata.

---

## 8. Perché durante una procedura può essere necessario usare lo stack?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Lo stack serve quando i registri disponibili non bastano o quando bisogna preservare temporaneamente dei valori.
>
> In particolare, viene usato per:
> - salvare registri che verranno modificati dalla procedura;
> - salvare l’indirizzo di ritorno in caso di chiamate annidate o ricorsive;
> - conservare parametri o variabili locali;
> - gestire dati temporanei.
>
> Lo stack è organizzato come una pila LIFO: l’ultimo dato inserito è il primo a essere estratto.
>
> Le operazioni principali sono:
> - `push`: inserimento di un dato nello stack;
> - `pop`: estrazione di un dato dallo stack.

---

## 9. Che cos’è lo stack pointer e come viene usato in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Lo stack pointer è il registro che punta alla cima dello stack.
>
> In RISC-V lo stack pointer è il registro `x2`, chiamato anche `sp`.
>
> Lo stack cresce verso indirizzi di memoria più bassi. Per questo:
>
> - quando si riserva spazio nello stack, si sottrae da `sp`;
> - quando si libera spazio dallo stack, si aggiunge a `sp`.
>
> Esempio:
>
> ```asm
> addi sp, sp, -12
> ```
>
> riserva spazio per 3 parole da 4 byte.
>
> Alla fine della procedura:
>
> ```asm
> addi sp, sp, 12
> ```
>
> libera quello spazio.

---

## 10. Che cosa succede nello stack durante il salvataggio e il ripristino dei registri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Quando una procedura deve usare registri che contengono valori ancora utili al chiamante, salva quei registri nello stack.
>
> Per esempio:
>
> ```asm
> addi sp, sp, -12
> sw x5, 8(sp)
> sw x6, 4(sp)
> sw x20, 0(sp)
> ```
>
> Qui vengono riservate 3 parole nello stack e vengono salvati i registri `x5`, `x6` e `x20`.
>
> Alla fine della procedura i valori vengono ripristinati:
>
> ```asm
> lw x20, 0(sp)
> lw x6, 4(sp)
> lw x5, 8(sp)
> addi sp, sp, 12
> ```
>
> In questo modo il chiamante ritrova i registri nello stato corretto.

---

## 11. Qual è la differenza tra registri temporanei e registri da preservare in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> RISC-V distingue i registri in base a chi ha la responsabilità di salvarli.
>
> I registri temporanei sono:
>
> - `x5-x7`;
> - `x28-x31`.
>
> Questi non sono preservati automaticamente in caso di chiamata a procedura. Se il chiamante vuole conservarli, deve salvarli prima della chiamata.
>
> I registri da preservare sono:
>
> - `x8-x9`;
> - `x18-x27`.
>
> Se una procedura chiamata li usa, deve salvarli all’inizio e ripristinarli prima di ritornare al chiamante.
>
> Questa convenzione evita conflitti tra chiamante e procedura chiamata.

---

## 12. Che problema nasce con le procedure annidate e come viene risolto?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le procedure annidate sono procedure che chiamano altre procedure.
>
> Il problema principale riguarda il registro `x1`, cioè il return address.
>
> Se una procedura A viene chiamata dal programma principale e poi A chiama B, la nuova chiamata con `jal` sovrascrive il contenuto di `x1`.
>
> Se il vecchio indirizzo di ritorno non viene salvato, A non saprà più dove tornare.
>
> La soluzione è salvare nello stack l’indirizzo di ritorno prima di effettuare una nuova chiamata:
>
> ```asm
> addi sp, sp, -8
> sw x1, 4(sp)
> sw x10, 0(sp)
> ```
>
> Alla fine della procedura, il vecchio valore di `x1` viene ripristinato con una `lw`.

---

## 13. Perché la ricorsione richiede lo stack?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La ricorsione richiede lo stack perché ogni chiamata ricorsiva deve conservare il proprio stato.
>
> In una procedura ricorsiva, ogni invocazione deve salvare:
> - il proprio indirizzo di ritorno;
> - i propri parametri;
> - eventuali valori temporanei;
> - eventuali registri che devono essere preservati.
>
> Senza lo stack, le chiamate successive sovrascriverebbero i dati delle chiamate precedenti.
>
> Per esempio, nella procedura ricorsiva del fattoriale:
>
> ```c
> int fatt(int n) {
>     if (n < 1) return 1;
>     else return n * fatt(n - 1);
> }
> ```
>
> ogni chiamata deve ricordare il valore corrente di `n` e il proprio indirizzo di ritorno, altrimenti non sarebbe possibile calcolare correttamente il risultato dopo il ritorno dalla chiamata ricorsiva.

---

## 14. Che cos’è il global pointer e a cosa serve?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il global pointer è un registro usato per puntare alla zona dei dati statici.
>
> In RISC-V è il registro `x3`, chiamato anche `gp`.
>
> I dati statici sono variabili che esistono per tutta la durata del programma, come:
> - variabili globali;
> - variabili statiche;
> - costanti;
> - strutture allocate staticamente.
>
> Il global pointer permette di accedere rapidamente a questi dati senza dover ricalcolare ogni volta indirizzi lunghi o complessi.

---

## 15. Che cos’è il frame pointer e perché può essere utile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il frame pointer è un registro che punta a una posizione stabile all’interno del record di attivazione di una procedura.
>
> In RISC-V può essere usato il registro `x8`, chiamato anche `fp`.
>
> È utile perché lo stack pointer può cambiare durante l’esecuzione della procedura, per esempio se vengono aggiunti o rimossi dati dallo stack.
>
> Se gli indirizzi delle variabili locali fossero calcolati rispetto a `sp`, cambierebbero quando cambia `sp`.
>
> Il frame pointer invece rimane stabile, quindi permette di accedere più facilmente a:
> - parametri salvati;
> - variabili locali;
> - registri salvati;
> - indirizzo di ritorno.

---

## 16. Che cos’è un record di attivazione o frame della procedura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il record di attivazione, o frame della procedura, è la parte dello stack associata a una singola chiamata di procedura.
>
> Può contenere:
> - registri salvati;
> - indirizzo di ritorno;
> - parametri salvati;
> - variabili locali;
> - dati temporanei;
> - eventuali vettori o strutture locali.
>
> Ogni chiamata a procedura può avere il proprio frame.
>
> Quando la procedura termina, il frame viene rimosso dallo stack ripristinando il valore dello stack pointer.

---

## 17. Come sono organizzate memoria statica, heap e stack in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La memoria di un programma è divisa in diverse zone.
>
> Tipicamente troviamo:
>
> - il segmento di testo, che contiene il codice macchina del programma;
> - i dati statici, che contengono variabili globali, variabili statiche e costanti;
> - lo heap, usato per l’allocazione dinamica;
> - lo stack, usato per chiamate a procedura, registri salvati e variabili locali.
>
> Lo stack cresce verso indirizzi più bassi.
>
> Lo heap invece cresce verso indirizzi più alti.
>
> Questa organizzazione consente di separare codice, dati statici, dati dinamici e dati temporanei delle procedure.

---

## 18. Qual è la differenza tra allocazione nello stack e allocazione nello heap?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’allocazione nello stack riguarda dati temporanei legati a una chiamata di procedura.
>
> Per esempio:
> - registri salvati;
> - indirizzo di ritorno;
> - variabili locali;
> - parametri salvati.
>
> Quando la procedura termina, lo spazio viene liberato automaticamente ripristinando lo stack pointer.
>
> L’allocazione nello heap riguarda invece dati dinamici, la cui durata non è necessariamente legata a una singola procedura.
>
> In C, lo heap viene usato tramite funzioni come `malloc` e `free`.
>
> Se si dimentica di liberare memoria nello heap si può avere una perdita di memoria, cioè un *memory leak*.

---

## 19. Quali registri RISC-V devono essere conservati durante una chiamata a procedura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Secondo le convenzioni RISC-V:
>
> - `x1` (`ra`) contiene l’indirizzo di ritorno e deve essere conservato se la procedura effettua altre chiamate;
> - `x2` (`sp`) è lo stack pointer e deve essere preservato correttamente;
> - `x3` (`gp`) è il global pointer;
> - `x4` (`tp`) è il thread pointer;
> - `x8-x9` e `x18-x27` sono registri da preservare;
> - `x10-x17` sono registri argomento/risultato e non sono garantiti dopo una chiamata;
> - `x5-x7` e `x28-x31` sono registri temporanei e non sono preservati.
>
> Questa convenzione stabilisce chi deve salvare cosa, evitando errori tra chiamante e chiamato.

---

## 20. Qual è l’idea principale delle convenzioni di chiamata in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le convenzioni di chiamata stabiliscono regole comuni per usare i registri durante le procedure.
>
> Servono per fare in modo che codice scritto da compilatori diversi, o da programmatori diversi, possa funzionare insieme correttamente.
>
> In particolare stabiliscono:
>
> - dove mettere i parametri;
> - dove mettere i risultati;
> - quale registro contiene l’indirizzo di ritorno;
> - quale registro contiene lo stack pointer;
> - quali registri deve salvare il chiamante;
> - quali registri deve salvare la procedura chiamata.
>
> L’idea fondamentale è che una procedura possa usare registri e memoria senza distruggere valori che il programma chiamante si aspetta ancora validi.