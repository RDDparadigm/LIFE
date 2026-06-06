
# 1.6 Prestazioni

## Metodo di ripasso

Per ripassare questa sezione, concentrati su tre idee fondamentali: **prestazioni = inverso del tempo di esecuzione**, differenza tra **tempo di risposta** e **throughput**, ed equazione classica delle prestazioni della CPU. All’orale devi saper spiegare non solo le formule, ma anche **quale componente del sistema influenza quale parametro**: numero di istruzioni, CPI e periodo/frequenza di clock.

---

## 1. Che cosa significa dire che un calcolatore ha prestazioni superiori a un altro?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Dire che un calcolatore ha prestazioni superiori significa che, a parità di programma o attività, riesce a completare il lavoro in **meno tempo**.
>
> Nel testo si definisce la prestazione come inversamente proporzionale al tempo di esecuzione:
>
> \[
> Prestazioni_X = \frac{1}{Tempo\ di\ esecuzione_X}
> \]
>
> Quindi, se il calcolatore X ha prestazioni maggiori del calcolatore Y, allora:
>
> \[
> Prestazioni_X > Prestazioni_Y
> \]
>
> e di conseguenza:
>
> \[
> Tempo\ di\ esecuzione_X < Tempo\ di\ esecuzione_Y
> \]
>
> In altre parole, il calcolatore più veloce è quello che impiega meno tempo a eseguire lo stesso programma.

---

## 2. Qual è la differenza tra tempo di risposta e throughput?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **tempo di risposta**, detto anche **tempo di esecuzione**, è il tempo totale necessario a un calcolatore per completare un singolo task. Include tutti i tempi coinvolti: accessi alla memoria, operazioni di I/O, esecuzione del sistema operativo e attività della CPU.
>
> Il **throughput**, detto anche **larghezza di banda**, indica invece quanti task vengono completati nell’unità di tempo.
>
> La differenza è quindi:
>
> - il tempo di risposta riguarda **quanto tempo serve per completare un singolo lavoro**;
> - il throughput riguarda **quanti lavori vengono completati in un certo intervallo di tempo**.
>
> Migliorare il tempo di risposta spesso migliora anche il throughput, ma non sempre vale il contrario. Ad esempio, aggiungere processori può aumentare il throughput perché più task vengono eseguiti in parallelo, ma non necessariamente riduce il tempo di esecuzione di un singolo task.

---

## 3. Come si confrontano quantitativamente le prestazioni di due calcolatori?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per confrontare quantitativamente due calcolatori si usa il rapporto tra le loro prestazioni.
>
> Se diciamo che il calcolatore X è \(n\) volte più veloce del calcolatore Y, intendiamo:
>
> \[
> \frac{Prestazioni_X}{Prestazioni_Y} = n
> \]
>
> Poiché le prestazioni sono l’inverso del tempo di esecuzione:
>
> \[
> \frac{Prestazioni_X}{Prestazioni_Y}
> =
> \frac{Tempo\ di\ esecuzione_Y}{Tempo\ di\ esecuzione_X}
> \]
>
> Quindi:
>
> \[
> \frac{Prestazioni_X}{Prestazioni_Y} = n
> \Rightarrow
> Tempo\ di\ esecuzione_Y = n \cdot Tempo\ di\ esecuzione_X
> \]
>
> Esempio: se A esegue un programma in 10 secondi e B in 15 secondi:
>
> \[
> \frac{Prestazioni_A}{Prestazioni_B} =
> \frac{15}{10} = 1{,}5
> \]
>
> Quindi A è 1,5 volte più veloce di B.

---

## 4. Perché non bisogna confondere “aumentare le prestazioni” con “aumentare il tempo di esecuzione”?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Non bisogna confondere questi termini perché prestazioni e tempo di esecuzione sono grandezze inverse.
>
> Se il tempo di esecuzione diminuisce, le prestazioni aumentano.
>
> Se il tempo di esecuzione aumenta, le prestazioni diminuiscono.
>
> Per questo il testo consiglia di usare espressioni chiare:
>
> - “migliorare le prestazioni” significa **aumentare le prestazioni**;
> - “aumentare il tempo di esecuzione” significa invece **peggiorare le prestazioni**;
> - “ridurre il tempo di esecuzione” significa **migliorare le prestazioni**.
>
> In sintesi, un calcolatore è più veloce non perché impiega più tempo, ma perché impiega meno tempo.

---

## 5. Che differenza c’è tra tempo trascorso, tempo di CPU utente e tempo di CPU di sistema?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **tempo trascorso**, detto anche tempo di esecuzione o tempo di risposta, è il tempo totale percepito dall’utente per completare un programma. Comprende tutto: CPU, I/O, memoria, sistema operativo e altri programmi in esecuzione.
>
> Il **tempo di CPU** considera invece solo il tempo in cui la CPU lavora effettivamente per quel programma.
>
> Il tempo di CPU si divide in:
>
> - **tempo di CPU utente**, cioè il tempo speso dalla CPU per eseguire il codice del programma utente;
> - **tempo di CPU di sistema**, cioè il tempo speso dalla CPU per eseguire funzioni del sistema operativo richieste dal programma.
>
> Il tempo trascorso è utile dal punto di vista dell’utente, mentre il tempo di CPU è utile per analizzare le prestazioni del processore.

---

## 6. Che cosa sono i cicli di clock, il periodo di clock e la frequenza di clock?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei calcolatori digitali le operazioni sono sincronizzate da un segnale di clock, che scandisce intervalli regolari di tempo.
>
> I **cicli di clock** sono questi intervalli temporali.
>
> Il **periodo di clock** è la durata di un ciclo di clock, misurata in secondi o frazioni di secondo, ad esempio picosecondi.
>
> La **frequenza di clock** è il numero di cicli di clock al secondo, misurata in hertz.
>
> Periodo e frequenza sono grandezze inverse:
>
> \[
> Frequenza\ di\ clock = \frac{1}{Periodo\ di\ clock}
> \]
>
> e quindi:
>
> \[
> Periodo\ di\ clock = \frac{1}{Frequenza\ di\ clock}
> \]
>
> Una frequenza più alta significa cicli più brevi, ma non garantisce sempre da sola prestazioni migliori, perché contano anche il numero di cicli necessari e il CPI.

---

## 7. Qual è l’equazione del tempo di CPU in funzione dei cicli di clock?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il tempo di CPU può essere espresso come:
>
> \[
> Tempo\ di\ CPU =
> Cicli\ di\ clock\ della\ CPU \times Periodo\ di\ clock
> \]
>
> Poiché il periodo di clock è l’inverso della frequenza di clock, si può anche scrivere:
>
> \[
> Tempo\ di\ CPU =
> \frac{Cicli\ di\ clock\ della\ CPU}{Frequenza\ di\ clock}
> \]
>
> Questa equazione mostra che per migliorare le prestazioni si può:
>
> - ridurre il numero di cicli di clock necessari;
> - ridurre il periodo di clock;
> - aumentare la frequenza di clock.
>
> Tuttavia, nella pratica, questi fattori non sono sempre indipendenti: una modifica che riduce i cicli di clock potrebbe aumentare il periodo di clock, o viceversa.

---

## 8. Che cos’è il CPI e perché è importante nella misura delle prestazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **CPI**, cioè **cicli di clock per istruzione**, indica il numero medio di cicli di clock necessari per eseguire un’istruzione.
>
> È importante perché il tempo di esecuzione di un programma non dipende solo dal numero di istruzioni, ma anche da quanti cicli richiede mediamente ciascuna istruzione.
>
> Il numero totale di cicli di clock può essere espresso come:
>
> \[
> Cicli\ di\ clock\ della\ CPU =
> Numero\ di\ istruzioni \times CPI
> \]
>
> Il CPI è una media perché istruzioni diverse possono richiedere un numero diverso di cicli di clock.
>
> Un CPI più basso, a parità di numero di istruzioni e frequenza di clock, porta a un tempo di CPU minore e quindi a prestazioni migliori.

---

## 9. Qual è l’equazione classica delle prestazioni della CPU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’equazione classica delle prestazioni della CPU è:
>
> \[
> Tempo\ di\ CPU =
> Numero\ di\ istruzioni \times CPI \times Periodo\ di\ clock
> \]
>
> Poiché il periodo di clock è l’inverso della frequenza di clock, si può anche scrivere:
>
> \[
> Tempo\ di\ CPU =
> \frac{Numero\ di\ istruzioni \times CPI}{Frequenza\ di\ clock}
> \]
>
> Questa formula mostra che il tempo di CPU dipende da tre fattori fondamentali:
>
> - numero di istruzioni eseguite dal programma;
> - CPI, cioè cicli medi per istruzione;
> - periodo di clock, oppure frequenza di clock.
>
> Per migliorare le prestazioni bisogna ridurre il tempo di CPU, agendo su uno o più di questi fattori.

---

## 10. Perché la frequenza di clock da sola non basta per confrontare due processori?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La frequenza di clock da sola non basta perché indica solo quanti cicli al secondo vengono eseguiti, ma non dice quanti cicli servono per completare un programma.
>
> Due processori possono avere frequenze diverse, ma anche CPI diversi e numero di istruzioni diverso.
>
> Il tempo di CPU dipende infatti da:
>
> \[
> Tempo\ di\ CPU =
> \frac{Numero\ di\ istruzioni \times CPI}{Frequenza\ di\ clock}
> \]
>
> Quindi un processore con frequenza più alta può comunque essere più lento se:
>
> - esegue più istruzioni;
> - ha un CPI maggiore;
> - richiede più cicli di clock complessivi.
>
> Per questo non si può dire che un processore sia migliore solo perché ha una frequenza di clock maggiore.

---

## 11. Perché non basta confrontare solo il numero di istruzioni di due programmi?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Non basta confrontare solo il numero di istruzioni perché le istruzioni possono avere costi diversi.
>
> Un programma con meno istruzioni non è necessariamente più veloce se quelle istruzioni richiedono molti cicli di clock.
>
> Il tempo di CPU dipende infatti sia dal numero di istruzioni sia dal CPI:
>
> \[
> Cicli\ di\ clock =
> Numero\ di\ istruzioni \times CPI
> \]
>
> oppure, più in generale:
>
> \[
> Tempo\ di\ CPU =
> Numero\ di\ istruzioni \times CPI \times Periodo\ di\ clock
> \]
>
> Quindi un programma con più istruzioni può essere più veloce se ha un CPI più basso o se viene eseguito su un processore con periodo di clock minore.

---

## 12. Che cos’è l’instruction mix e perché influenza le prestazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’**instruction mix**, o composizione delle istruzioni, indica la frequenza dinamica con cui i vari tipi di istruzioni compaiono ed effettivamente vengono eseguiti in un programma.
>
> È importante perché tipi diversi di istruzioni possono avere CPI diversi.
>
> Se un programma usa molte istruzioni costose, il CPI medio sarà più alto. Se invece usa soprattutto istruzioni semplici e veloci, il CPI medio sarà più basso.
>
> Quando le istruzioni hanno CPI diversi, il numero totale di cicli di clock si calcola sommando il contributo di ciascun tipo di istruzione:
>
> \[
> Cicli\ di\ clock =
> \sum_{i=1}^{n}(CPI_i \times C_i)
> \]
>
> dove:
>
> - \(CPI_i\) è il CPI del tipo di istruzione \(i\);
> - \(C_i\) è il numero di istruzioni di quel tipo.
>
> Per questo il CPI medio dipende dalla composizione effettiva delle istruzioni eseguite.

---

## 13. Quali componenti influenzano le prestazioni di un programma?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le prestazioni di un programma dipendono da diversi componenti hardware e software.
>
> L’**algoritmo** influenza il numero di istruzioni eseguite e può influenzare anche il CPI, perché determina il tipo di operazioni svolte.
>
> Il **linguaggio di programmazione** influenza il numero di istruzioni e il CPI, perché linguaggi diversi producono codice macchina diverso.
>
> Il **compilatore** influenza il numero di istruzioni e il CPI, perché traduce il programma sorgente in istruzioni macchina e può ottimizzare il codice.
>
> L’**architettura dell’insieme delle istruzioni** influenza numero di istruzioni, CPI e frequenza di clock, perché definisce quali istruzioni sono disponibili e come vengono implementate.
>
> Quindi le prestazioni non dipendono da un solo fattore, ma dall’interazione tra algoritmo, linguaggio, compilatore, ISA e hardware.

---

## 14. Perché il tempo di esecuzione è considerato l’unica misura completa e affidabile delle prestazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il tempo di esecuzione è considerato la misura più completa e affidabile perché racchiude l’effetto complessivo di tutti i fattori che influenzano le prestazioni.
>
> Singoli parametri come numero di istruzioni, CPI o frequenza di clock possono essere fuorvianti se considerati da soli.
>
> Ad esempio:
>
> - ridurre il numero di istruzioni può aumentare il CPI;
> - aumentare la frequenza di clock può richiedere più cicli;
> - un CPI più basso non garantisce sempre un tempo minore se il numero di istruzioni aumenta.
>
> Per questo l’obiettivo finale è sempre ridurre:
>
> \[
> Tempo\ di\ CPU =
> Numero\ di\ istruzioni \times CPI \times Periodo\ di\ clock
> \]
>
> Il tempo è quindi la misura che permette di valutare davvero quale calcolatore esegue più velocemente un programma.

---

## 15. Che cosa significa che una prestazione può migliorare un parametro ma peggiorarne un altro?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Significa che i fattori dell’equazione delle prestazioni non sono indipendenti.
>
> Una modifica progettuale può migliorare un parametro, ma peggiorarne un altro.
>
> Ad esempio:
>
> - aumentare la frequenza di clock riduce il periodo di clock, ma può richiedere più cicli per eseguire lo stesso programma;
> - usare istruzioni più complesse può ridurre il numero di istruzioni, ma aumentare il CPI;
> - ottimizzare il compilatore può ridurre il numero di istruzioni oppure cambiare l’instruction mix.
>
> Per questo non basta osservare un solo fattore: bisogna valutare l’effetto finale sul tempo di esecuzione.
>
> Il miglioramento reale delle prestazioni si ha solo se il tempo complessivo diminuisce.

---