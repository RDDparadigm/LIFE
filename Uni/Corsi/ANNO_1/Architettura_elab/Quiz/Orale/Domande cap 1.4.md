# 1.4 Componenti di un calcolatore

## Metodo di ripasso

Ripassa questa sezione partendo dalla visione generale: un calcolatore riceve dati, li elabora, li memorizza, produce risultati e comunica con altri sistemi. Per l’orale devi saper collegare i cinque componenti classici — input, output, memoria, datapath e unità di controllo — agli esempi concreti: schermo, touchscreen, memoria DRAM/SRAM/flash, processore, ISA e reti.

---

## 1. Quali sono i cinque componenti classici di un calcolatore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I cinque componenti classici di un calcolatore sono:
> 
> - **input**, cioè i dispositivi che permettono di inserire dati e comandi;
> - **output**, cioè i dispositivi che mostrano o comunicano i risultati;
> - **memoria**, dove vengono conservati dati e programmi;
> - **datapath**, cioè la parte che esegue le operazioni aritmetico-logiche;
> - **unità di controllo**, che comanda il datapath, la memoria e i dispositivi di I/O.
> 
> Datapath e unità di controllo sono spesso considerati insieme e formano il **processore** o **CPU**. Questa suddivisione è una classificazione logica utile per capire l’organizzazione di un calcolatore, indipendentemente dalla tecnologia hardware usata.

---

## 2. Che cosa sono i dispositivi di input e di output?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I **dispositivi di input** permettono al calcolatore di ricevere informazioni dall’esterno. Esempi tipici sono tastiera, mouse, touchscreen, microfono, fotocamera e sensori.
> 
> I **dispositivi di output** permettono invece al calcolatore di comunicare i risultati dell’elaborazione all’utente o ad altri sistemi. Esempi sono schermo, altoparlanti, stampante e interfacce di comunicazione.
> 
> Alcuni dispositivi svolgono entrambe le funzioni. Per esempio, il **touchscreen** è sia output, perché mostra immagini, sia input, perché rileva il tocco dell’utente.

---

## 3. Come funziona uno schermo LCD e qual è il ruolo dei pixel?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Uno **schermo LCD** è un dispositivo di output che usa cristalli liquidi per controllare il passaggio della luce.
> 
> Lo schermo non genera direttamente l’immagine da solo, ma controlla la trasmissione della luce proveniente da una sorgente posta dietro lo schermo o riflessa.
> 
> L’immagine è composta da una matrice di **pixel**, cioè piccoli elementi che rappresentano i punti dell’immagine. Nei monitor a colori, ogni pixel è in genere formato da tre componenti: rosso, verde e blu.
> 
> La qualità dell’immagine dipende dalla **risoluzione**, cioè dal numero di pixel presenti sullo schermo. Più pixel ci sono, più l’immagine può essere dettagliata.

---

## 4. Che cos’è il frame buffer e perché è importante nella visualizzazione grafica?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **frame buffer** è una zona di memoria che contiene la rappresentazione dell’immagine da visualizzare sullo schermo.
> 
> Ogni posizione del frame buffer corrisponde a un punto dello schermo, cioè a un pixel. Il valore memorizzato in quella posizione determina il colore o il livello di grigio del pixel corrispondente.
> 
> Il controller grafico legge continuamente il frame buffer e aggiorna lo schermo.
> 
> Il frame buffer è importante perché collega la memoria del calcolatore alla rappresentazione visiva prodotta dal dispositivo di output.

---

## 5. Come funziona un touchscreen capacitivo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **touchscreen capacitivo** è uno schermo che funziona sia come dispositivo di output sia come dispositivo di input.
> 
> È ricoperto da uno strato conduttivo trasparente. Quando un dito tocca lo schermo, modifica il campo elettrico superficiale.
> 
> Il sistema rileva questa variazione e determina la posizione del tocco.
> 
> Questa tecnologia permette anche di riconoscere più punti di contatto contemporaneamente, rendendo possibile il **multi-touch**, usato per operazioni come zoomare, ruotare o interagire con interfacce grafiche complesse.

---

## 6. Che cosa sono i circuiti integrati e perché sono importanti nei calcolatori moderni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **circuito integrato**, o **chip**, è un dispositivo che contiene moltissimi transistor e componenti elettronici miniaturizzati su un unico supporto.
> 
> Nei calcolatori moderni i circuiti integrati permettono di realizzare processori, memorie, controller di I/O e molti altri componenti in dimensioni molto ridotte.
> 
> Sono fondamentali perché permettono di aumentare la complessità e la potenza dei sistemi digitali, riducendo dimensioni, consumi e costi rispetto a circuiti costruiti con componenti separati.

---

## 7. Qual è la differenza tra datapath e unità di controllo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **datapath** è la parte del processore che esegue effettivamente le operazioni sui dati. Comprende le unità aritmetico-logiche, i registri e i collegamenti attraverso cui passano i dati.
> 
> L’**unità di controllo** coordina invece il funzionamento del processore. Decide quali operazioni devono essere eseguite, quali dati devono essere letti o scritti e quali segnali devono essere attivati.
> 
> In modo intuitivo, il datapath è il “braccio” che esegue le operazioni, mentre l’unità di controllo è la “mente” che organizza e comanda l’esecuzione.

---

## 8. Che cos’è la memoria principale e qual è il ruolo della DRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **memoria principale** è la memoria in cui vengono conservati i programmi in esecuzione e i dati su cui essi stanno lavorando.
> 
> Nei calcolatori moderni la memoria principale è normalmente realizzata con **DRAM**, cioè memoria dinamica ad accesso casuale.
> 
> La DRAM è detta **ad accesso casuale** perché il tempo necessario per accedere a una posizione di memoria è indipendente dalla sua posizione.
> 
> È detta **dinamica** perché le informazioni devono essere periodicamente rinfrescate per non andare perse.
> 
> La memoria principale è veloce rispetto alla memoria secondaria, ma è **volatile**: perde il contenuto quando manca l’alimentazione.

---

## 9. Qual è la differenza tra SRAM e DRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> **SRAM** e **DRAM** sono due tipi di memoria ad accesso casuale.
> 
> La **SRAM**, memoria statica, è più veloce ma più costosa e meno densa. Per questo viene usata soprattutto nelle **cache**, cioè piccole memorie molto rapide poste vicino al processore.
> 
> La **DRAM**, memoria dinamica, è più lenta della SRAM ma più economica e più densa. Per questo viene usata come **memoria principale** del calcolatore.
> 
> In sintesi: la SRAM privilegia la velocità, mentre la DRAM privilegia capacità e costo minore.

---

## 10. Che cos’è la gerarchia delle memorie?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **gerarchia delle memorie** è l’organizzazione dei diversi tipi di memoria in livelli, ordinati in base a velocità, costo e capacità.
> 
> Ai livelli più vicini al processore si trovano memorie piccole, veloci e costose, come registri e cache SRAM.
> 
> Più lontano dal processore si trovano memorie più grandi, più lente ed economiche, come DRAM, memoria flash e dischi.
> 
> L’idea fondamentale è usare memorie veloci per i dati usati più spesso e memorie più grandi per conservare quantità maggiori di dati. In questo modo si ottengono buone prestazioni senza usare solo memoria costosa.

---

## 11. Qual è la differenza tra memoria volatile e memoria non volatile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **memoria volatile** conserva i dati solo finché è alimentata. Quando il calcolatore viene spento, il suo contenuto viene perso.
> 
> La memoria principale DRAM è un esempio di memoria volatile.
> 
> Una **memoria non volatile** conserva invece le informazioni anche senza alimentazione. Esempi sono dischi magnetici, SSD, memorie flash, CD e DVD.
> 
> Questa distinzione è importante perché i programmi in esecuzione devono stare in memoria principale, mentre dati e programmi da conservare nel tempo devono essere salvati su memoria non volatile.

---

## 12. Che differenza c’è tra memoria principale e memoria secondaria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **memoria principale** è usata durante l’esecuzione dei programmi. È veloce, direttamente accessibile dal processore, ma volatile.
> 
> Nei calcolatori moderni è in genere realizzata con DRAM.
> 
> La **memoria secondaria** serve invece per conservare programmi e dati in modo permanente. È più lenta della memoria principale, ma ha maggiore capacità ed è non volatile.
> 
> Esempi di memoria secondaria sono hard disk, SSD e memoria flash.
> 
> Quindi la memoria principale serve per lavorare sui dati durante l’esecuzione, mentre la memoria secondaria serve per conservarli nel tempo.

---

## 13. Che cos’è l’architettura dell’insieme di istruzioni, o ISA?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’**ISA**, cioè **Instruction Set Architecture**, è l’interfaccia tra software e hardware.
> 
> Definisce le istruzioni che il processore può eseguire, i registri disponibili, i tipi di dati, le modalità di accesso alla memoria e il comportamento visibile al programmatore.
> 
> L’ISA permette ai programmatori e ai compilatori di scrivere programmi senza conoscere tutti i dettagli interni dell’hardware.
> 
> Processori diversi possono avere implementazioni diverse ma condividere la stessa ISA, riuscendo quindi a eseguire lo stesso codice macchina.

---

## 14. Qual è la differenza tra architettura e implementazione di un calcolatore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’**architettura** descrive ciò che il programmatore vede del calcolatore: insieme di istruzioni, registri, tipi di dati, indirizzamento della memoria e comportamento delle istruzioni.
> 
> L’**implementazione** descrive invece come quell’architettura viene realizzata fisicamente nell’hardware: organizzazione interna del processore, pipeline, cache, circuiti, tecnologie usate e scelte progettuali.
> 
> Due processori possono avere la stessa architettura ma implementazioni diverse.
> 
> Questo significa che possono eseguire gli stessi programmi, pur avendo prestazioni, consumi e organizzazione interna differenti.

---

## 15. Che cos’è l’ABI e a cosa serve?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’**ABI**, cioè **Application Binary Interface**, è un’interfaccia binaria tra i programmi applicativi e il sistema.
> 
> Definisce convenzioni pratiche come:
> 
> - il modo in cui vengono passati i parametri alle funzioni;
> - quali registri devono essere preservati;
> - come vengono gestite le chiamate di funzione;
> - il formato dei file eseguibili;
> - l’interazione con il sistema operativo.
> 
> È importante perché permette la compatibilità tra programmi compilati, librerie e sistema operativo.
> 
> Mentre l’ISA riguarda soprattutto le istruzioni della macchina, l’ABI riguarda le regole concrete che rendono eseguibile e collegabile un programma binario.

---

## 16. Perché i calcolatori comunicano attraverso le reti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I calcolatori comunicano attraverso le reti perché il collegamento tra sistemi permette di scambiare informazioni e condividere risorse.
> 
> I principali vantaggi delle reti sono:
> 
> - **comunicazione**, cioè scambio rapido di dati tra calcolatori;
> - **condivisione delle risorse**, come file, stampanti, memoria e servizi;
> - **accesso non locale**, cioè possibilità di usare risorse lontane senza essere fisicamente vicini.
> 
> Le reti sono diventate una parte essenziale dei calcolatori moderni perché permettono a dispositivi personali, server e sistemi distribuiti di lavorare insieme.

---

## 17. Qual è la differenza tra rete locale LAN e rete geografica WAN?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **LAN**, cioè **Local Area Network**, è una rete locale progettata per collegare dispositivi in un’area geografica limitata, come una stanza, un edificio, un laboratorio o un campus.
> 
> Un esempio tipico di tecnologia LAN è Ethernet.
> 
> Una **WAN**, cioè **Wide Area Network**, è una rete geografica che collega dispositivi o reti locali su distanze molto più grandi, anche tra città, paesi o continenti.
> 
> In sintesi: una LAN collega dispositivi vicini, mentre una WAN collega sistemi distribuiti su grandi distanze.

---

## 18. Perché la connessione in rete è diventata fondamentale nei calcolatori moderni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La connessione in rete è diventata fondamentale perché molti usi moderni del calcolatore dipendono dallo scambio continuo di dati.
> 
> Le reti permettono di accedere a Internet, usare servizi remoti, condividere file, comunicare in tempo reale e collegare dispositivi mobili, server e calcolatori personali.
> 
> Con il miglioramento delle tecnologie di comunicazione, le reti sono diventate più veloci, economiche e diffuse.
> 
> Oggi il calcolatore non è più visto solo come una macchina isolata, ma come parte di un sistema più grande di dispositivi interconnessi.