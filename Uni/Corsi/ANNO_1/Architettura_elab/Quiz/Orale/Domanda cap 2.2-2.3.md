# Capitolo 2.2-2.3 — Operazioni e operandi dell’hardware del calcolatore

## Metodo di ripasso

Ripassa queste flashcard concentrandoti su tre idee centrali:  
1. perché RISC-V usa istruzioni semplici e regolari;  
2. perché gli operandi principali stanno nei registri;  
3. quando servono memoria, load/store e costanti immediate.  

Per l’orale prova sempre a rispondere collegando il concetto al principio di progettazione corrispondente: semplicità, regolarità, dimensioni ridotte e velocità.

---

## 1. Perché in RISC-V un’operazione aritmetica complessa viene scomposta in più istruzioni semplici?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In RISC-V ogni istruzione aritmetica esegue una sola operazione e lavora su un numero fisso di operandi.
>
> Per esempio, un’espressione come:
>
> `a = b + c + d + e`
>
> non può essere tradotta con una sola istruzione, ma viene scomposta in più somme:
>
> ```asm
> add a,b,c
> add a,a,d
> add a,a,e
> ```
>
> Questo perché l’hardware è più semplice se tutte le istruzioni hanno una forma regolare e prevedibile.
>
> Il principio di progettazione collegato è:
>
> **la semplicità favorisce la regolarità**.
>
> Avere istruzioni sempre simili rende più facile progettare l’hardware, anche se il programma richiede più istruzioni.

---

## 2. Che cosa rappresentano i commenti in assembler RISC-V e perché sono utili?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In assembler RISC-V i commenti iniziano con `//`.
>
> Tutto ciò che si trova a destra di `//` viene ignorato dal calcolatore ed è scritto solo per il programmatore.
>
> Esempio:
>
> ```asm
> add a,b,c   // la somma di b e c è posta in a
> ```
>
> I commenti servono a rendere più leggibile il codice, soprattutto perché il linguaggio assembly è molto vicino all’hardware e quindi meno espressivo rispetto ai linguaggi ad alto livello come C o Java.

---

## 3. Come viene tradotto in RISC-V un assegnamento semplice come `a = b + c`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un’istruzione RISC-V lavora normalmente su due operandi sorgente e produce un risultato in un registro destinazione.
>
> L’assegnamento:
>
> ```c
> a = b + c;
> ```
>
> può essere tradotto come:
>
> ```asm
> add a,b,c
> ```
>
> Il significato è: somma il contenuto di `b` e `c`, poi inserisci il risultato in `a`.
>
> In forma generale:
>
> ```asm
> add destinazione, sorgente1, sorgente2
> ```

---

## 4. Come viene tradotto un assegnamento complesso come `f = (g + h) - (i + j)`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un’istruzione RISC-V può svolgere una sola operazione aritmetica alla volta, quindi l’espressione deve essere scomposta.
>
> Prima si calcola `g + h` e si salva il risultato in un registro temporaneo:
>
> ```asm
> add t0,g,h
> ```
>
> Poi si calcola `i + j` e si salva in un altro temporaneo:
>
> ```asm
> add t1,i,j
> ```
>
> Infine si sottrae il secondo risultato dal primo:
>
> ```asm
> sub f,t0,t1
> ```
>
> Il codice completo è:
>
> ```asm
> add t0,g,h   // t0 contiene g + h
> add t1,i,j   // t1 contiene i + j
> sub f,t0,t1  // f = (g + h) - (i + j)
> ```
>
> I registri temporanei servono a conservare i risultati intermedi.

---

## 5. Che cosa sono gli operandi dell’hardware del calcolatore in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli operandi sono i dati su cui agiscono le istruzioni aritmetiche.
>
> Nei linguaggi ad alto livello gli operandi possono essere variabili, elementi di array o strutture dati complesse.
>
> In RISC-V, invece, gli operandi delle istruzioni aritmetiche devono trovarsi in un numero limitato di locazioni speciali chiamate **registri**.
>
> I registri sono elementi hardware interni al processore, molto veloci da leggere e scrivere.
>
> Nell’architettura RISC-V considerata nel libro ci sono **32 registri da 64 bit**.

---

## 6. Perché RISC-V usa un numero limitato di registri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> RISC-V usa un numero limitato di registri perché un numero troppo elevato renderebbe l’hardware più complesso e più lento.
>
> Se ci fossero molti più registri:
>
> - aumenterebbe la dimensione del circuito;
> - servirebbe più tempo per selezionare il registro corretto;
> - il ciclo di clock potrebbe diventare più lungo.
>
> Il principio di progettazione collegato è:
>
> **minori sono le dimensioni, maggiore è la velocità**.
>
> Quindi avere 32 registri è un compromesso: abbastanza registri per lavorare in modo efficiente, ma non così tanti da rallentare l’hardware.

---

## 7. Come si rappresentano i registri RISC-V e qual è il ruolo dei registri temporanei?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I registri RISC-V possono essere indicati con nomi come:
>
> ```asm
> x0, x1, x2, ..., x31
> ```
>
> Alcuni registri hanno anche nomi convenzionali, più comodi per il programmatore.
>
> I registri temporanei vengono usati per memorizzare risultati intermedi durante la traduzione di espressioni complesse.
>
> Per esempio:
>
> ```asm
> add x5,x20,x21
> add x6,x22,x23
> sub x19,x5,x6
> ```
>
> Qui:
>
> - `x5` contiene temporaneamente `g + h`;
> - `x6` contiene temporaneamente `i + j`;
> - `x19` riceve il risultato finale.
>
> I temporanei sono quindi utili quando un’espressione non può essere calcolata con una sola istruzione.

---

## 8. Perché non tutti i dati possono stare nei registri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I registri sono pochi e possono contenere solo una quantità limitata di dati.
>
> Tuttavia i programmi usano spesso strutture dati grandi, come:
>
> - vettori;
> - strutture;
> - array;
> - dati allocati dinamicamente.
>
> Questi dati non possono stare tutti nei registri, quindi vengono conservati in **memoria**.
>
> Il processore può poi trasferire dati tra memoria e registri usando istruzioni specifiche chiamate **istruzioni di trasferimento dati**.

---

## 9. Che differenza c’è tra registri e memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I registri sono locazioni interne al processore, molto veloci ma in numero limitato.
>
> La memoria è molto più grande, ma più lenta da accedere.
>
> Le istruzioni aritmetiche RISC-V lavorano direttamente sui registri, non direttamente sulla memoria.
>
> Quindi, se un dato si trova in memoria, deve prima essere caricato in un registro con una istruzione di load. Dopo il calcolo, se necessario, il risultato deve essere scritto di nuovo in memoria con una istruzione di store.
>
> Questa scelta rende l’hardware più semplice e veloce, ma richiede istruzioni esplicite per spostare i dati.

---

## 10. Che cosa sono le istruzioni di trasferimento dati in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni di trasferimento dati servono a spostare dati tra memoria e registri.
>
> In RISC-V le due istruzioni principali sono:
>
> - `lw`, cioè **load word**, che carica una parola dalla memoria a un registro;
> - `sw`, cioè **store word**, che salva una parola da un registro alla memoria.
>
> Le istruzioni aritmetiche lavorano sui registri, quindi il trasferimento dati è necessario quando gli operandi o il risultato si trovano in memoria.

---

## 11. Come funziona un’istruzione `lw` in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’istruzione `lw` carica una parola dalla memoria in un registro.
>
> La forma tipica è:
>
> ```asm
> lw x9, 8(x22)
> ```
>
> Il significato è: carica nel registro `x9` il dato che si trova in memoria all’indirizzo ottenuto sommando:
>
> - il contenuto del registro base `x22`;
> - l’offset `8`.
>
> Quindi:
>
> ```text
> indirizzo effettivo = x22 + 8
> ```
>
> `x22` è il **registro base**, mentre `8` è l’**offset** o spiazzamento.

---

## 12. Come viene tradotto un assegnamento come `g = h + A[8]`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’assegnamento:
>
> ```c
> g = h + A[8];
> ```
>
> contiene un operando in memoria, cioè `A[8]`.
>
> Prima bisogna caricare `A[8]` in un registro temporaneo:
>
> ```asm
> lw x9, 8(x22)
> ```
>
> Poi si può eseguire la somma:
>
> ```asm
> add x20,x21,x9
> ```
>
> Qui:
>
> - `x22` contiene l’indirizzo base del vettore `A`;
> - `8` è l’offset usato per selezionare l’elemento;
> - `x9` contiene temporaneamente `A[8]`;
> - `x21` contiene `h`;
> - `x20` contiene `g`.
>
> Il codice mostra che un dato in memoria deve prima essere trasferito in un registro prima di essere usato in un’operazione aritmetica.

---

## 13. Che cosa sono registro base e offset nelle istruzioni di load/store?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nelle istruzioni di trasferimento dati, l’indirizzo di memoria viene calcolato usando due elementi:
>
> - un **registro base**, che contiene un indirizzo di partenza;
> - un **offset**, cioè uno spiazzamento costante da sommare al registro base.
>
> La forma è:
>
> ```asm
> offset(registro_base)
> ```
>
> Per esempio:
>
> ```asm
> lw x9, 8(x22)
> ```
>
> significa che l’indirizzo effettivo è:
>
> ```text
> x22 + 8
> ```
>
> Questa modalità è molto utile per accedere agli elementi di array e strutture dati.

---

## 14. Come funziona un’istruzione `sw` in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’istruzione `sw`, cioè **store word**, salva in memoria il contenuto di un registro.
>
> La forma tipica è:
>
> ```asm
> sw x9, 48(x22)
> ```
>
> Il significato è: salva il contenuto del registro `x9` nella locazione di memoria il cui indirizzo è ottenuto sommando:
>
> - il contenuto di `x22`;
> - l’offset `48`.
>
> Quindi:
>
> ```text
> indirizzo effettivo = x22 + 48
> ```
>
> `sw` è usata quando il risultato di un calcolo deve essere scritto in memoria, ad esempio dentro un array.

---

## 15. Come viene tradotto un assegnamento come `A[12] = h + A[8]`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’assegnamento:
>
> ```c
> A[12] = h + A[8];
> ```
>
> richiede sia un caricamento dalla memoria sia una scrittura in memoria.
>
> Prima si carica `A[8]` in un registro temporaneo:
>
> ```asm
> lw x9, 32(x22)
> ```
>
> Poi si somma con `h`:
>
> ```asm
> add x9,x21,x9
> ```
>
> Infine si salva il risultato in `A[12]`:
>
> ```asm
> sw x9, 48(x22)
> ```
>
> L’offset dipende dalla dimensione degli elementi dell’array.
>
> Se ogni parola occupa 4 byte:
>
> - `A[8]` si trova a `8 × 4 = 32` byte dall’inizio;
> - `A[12]` si trova a `12 × 4 = 48` byte dall’inizio.
>
> Questo esempio mostra che RISC-V indirizza la memoria a byte, quindi per accedere a parole consecutive bisogna usare offset multipli della dimensione della parola.

---

## 16. Che cosa significa dire che RISC-V indirizza la memoria a byte?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Dire che RISC-V indirizza la memoria a byte significa che ogni indirizzo identifica un singolo byte.
>
> Anche se una parola è composta da più byte, gli indirizzi avanzano byte per byte.
>
> Per esempio, se una parola occupa 4 byte, allora parole consecutive non hanno indirizzi consecutivi come 0, 1, 2, 3, ma indirizzi:
>
> ```text
> 0, 4, 8, 12, ...
> ```
>
> Questo è importante quando si calcolano gli offset negli array.
>
> Se voglio accedere ad `A[i]` e ogni elemento occupa 4 byte, l’offset è:
>
> ```text
> i × 4
> ```

---

## 17. Che cosa sono indirizzamento little endian e big endian?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Little endian e big endian indicano come vengono ordinati i byte di una parola in memoria.
>
> In un sistema **big endian**, il byte più significativo viene memorizzato all’indirizzo più basso.
>
> In un sistema **little endian**, il byte meno significativo viene memorizzato all’indirizzo più basso.
>
> RISC-V usa l’ordinamento **little endian**.
>
> Questa scelta riguarda il modo in cui i byte di una parola vengono disposti in memoria, non il valore logico della parola.

---

## 18. Che cos’è il vincolo di allineamento in memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il vincolo di allineamento richiede che i dati inizino a indirizzi multipli della loro dimensione.
>
> Per esempio, se una parola occupa 4 byte, allora dovrebbe iniziare a un indirizzo multiplo di 4:
>
> ```text
> 0, 4, 8, 12, ...
> ```
>
> L’allineamento semplifica e velocizza l’accesso alla memoria.
>
> Nel testo viene spiegato che RISC-V e Intel x86 non hanno un vincolo di allineamento rigido, mentre altre architetture, come MIPS, lo prevedono.

---

## 19. Che cos’è il register spilling e perché avviene?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **register spilling** avviene quando il compilatore non ha abbastanza registri disponibili per tutte le variabili utili in un certo momento.
>
> In questo caso alcune variabili vengono spostate temporaneamente dalla CPU alla memoria.
>
> Questo permette di liberare registri, ma ha un costo:
>
> - accedere alla memoria è più lento che accedere ai registri;
> - servono istruzioni aggiuntive di load e store;
> - il programma può diventare meno efficiente.
>
> Per questo i compilatori cercano di usare i registri nel modo più efficace possibile e di ridurre al minimo gli accessi alla memoria.

---

## 20. Perché i registri sono così importanti per le prestazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I registri sono fondamentali perché sono molto più veloci della memoria.
>
> Le istruzioni aritmetiche RISC-V lavorano direttamente sui registri e possono leggere rapidamente gli operandi.
>
> Se invece i dati sono in memoria, servono istruzioni aggiuntive per trasferirli:
>
> - `lw` per caricare dalla memoria;
> - `sw` per salvare in memoria.
>
> Questo aumenta il numero di istruzioni e il tempo di esecuzione.
>
> Perciò un uso efficiente dei registri è essenziale per ottenere buone prestazioni.

---

## 21. Che cosa sono gli operandi immediati o costanti in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli operandi immediati sono costanti inserite direttamente dentro un’istruzione.
>
> Sono utili perché molti programmi usano spesso valori costanti, ad esempio per incrementare un indice o aggiornare un contatore.
>
> Senza immediati, per sommare una costante bisognerebbe prima caricarla dalla memoria:
>
> ```asm
> lw x9, IndirizzoCostante(x3)
> add x22,x22,x9
> ```
>
> Con un’istruzione immediata si può invece scrivere:
>
> ```asm
> addi x22,x22,4
> ```
>
> `addi` significa **add immediate**, cioè somma immediata.
>
> Questa soluzione è più veloce perché evita un accesso alla memoria.

---

## 22. Perché l’uso delle costanti immediate rende più veloce il programma?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le costanti immediate rendono più veloce il programma perché evitano di caricare dalla memoria valori costanti molto frequenti.
>
> Per esempio, invece di caricare la costante `4` da memoria e poi sommarla, si può inserirla direttamente nell’istruzione:
>
> ```asm
> addi x22,x22,4
> ```
>
> Questo riduce:
>
> - il numero di istruzioni;
> - gli accessi alla memoria;
> - il tempo di esecuzione.
>
> Il principio collegato è:
>
> **rendere veloci le situazioni più comuni**.
>
> Poiché le costanti sono molto frequenti nei programmi, RISC-V fornisce istruzioni dedicate per usarle in modo efficiente.

---

## 23. Qual è il ruolo del registro `x0` in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il registro `x0` in RISC-V contiene sempre il valore zero.
>
> Questo significa che non può essere modificato dal programma.
>
> La presenza di un registro sempre uguale a zero semplifica alcune operazioni.
>
> Per esempio, può essere usato per copiare un valore o per ottenere rapidamente la costante zero senza doverla caricare dalla memoria.
>
> Anche questa scelta segue l’idea di rendere efficienti le situazioni comuni.

---

## 24. Quali sono i principi di progettazione introdotti nelle sezioni 2.2 e 2.3?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le sezioni 2.2 e 2.3 introducono diversi principi fondamentali della progettazione dell’hardware.
>
> Il primo è:
>
> **la semplicità favorisce la regolarità**.
>
> Questo spiega perché RISC-V usa istruzioni semplici, con formato regolare e numero fisso di operandi.
>
> Il secondo è:
>
> **minori sono le dimensioni, maggiore è la velocità**.
>
> Questo spiega perché RISC-V usa un numero limitato di registri: più registri renderebbero l’hardware più complesso e potenzialmente più lento.
>
> Un altro principio implicito è:
>
> **rendere veloci le situazioni più comuni**.
>
> Questo spiega l’introduzione delle istruzioni immediate, dato che le costanti sono molto usate nei programmi.
>
> In sintesi, RISC-V privilegia un insieme di istruzioni semplice, regolare e veloce da implementare in hardware.

---