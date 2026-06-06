
# Capitolo 2.6-2.7 — Operazioni logiche e istruzioni per prendere decisioni

## Metodo di ripasso

Ripassa prima le operazioni logiche bit a bit, distinguendo bene tra `AND`, `OR`, `XOR`, `NOT` e operazioni di shift. Poi passa alle istruzioni di salto condizionato, collegandole ai costrutti C come `if`, `while` e `switch`.  
Per l’orale è importante saper spiegare non solo **cosa fa l’istruzione**, ma anche **perché viene usata nella traduzione in assembly RISC-V**.

---

## 1. Che cosa sono le operazioni logiche in RISC-V e perché sono utili?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le operazioni logiche sono istruzioni che lavorano sui singoli bit di una parola.
>
> Sono utili perché permettono di manipolare direttamente campi di bit, maschere e singoli valori all’interno di un registro.
>
> A differenza delle operazioni aritmetiche, che interpretano l’intera parola come un numero, le operazioni logiche agiscono bit per bit.
>
> In RISC-V le principali operazioni logiche sono:
>
> - shift a sinistra;
> - shift a destra logico;
> - shift a destra aritmetico;
> - `AND`;
> - `OR`;
> - `XOR`;
> - `NOT`, ottenuto tramite `XOR` con tutti bit a 1.
>
> Queste istruzioni sono fondamentali per isolare campi, costruire maschere, modificare bit e implementare controlli a basso livello.

---

## 2. Che differenza c’è tra shift a sinistra, shift a destra logico e shift a destra aritmetico?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Lo **shift a sinistra** sposta tutti i bit verso sinistra e inserisce zeri nei bit meno significativi.
>
> In RISC-V si usa:
>
> ```asm
> sll
> slli
> ```
>
> Uno shift a sinistra di `i` posizioni corrisponde, se non c’è overflow, a una moltiplicazione per `2^i`.
>
> Lo **shift a destra logico** sposta i bit verso destra e inserisce zeri nei bit più significativi.
>
> In RISC-V si usa:
>
> ```asm
> srl
> srli
> ```
>
> È adatto soprattutto per valori senza segno.
>
> Lo **shift a destra aritmetico** sposta i bit verso destra ma replica il bit di segno, cioè il bit più significativo.
>
> In RISC-V si usa:
>
> ```asm
> sra
> srai
> ```
>
> È usato per mantenere correttamente il segno nei numeri rappresentati in complemento a due.

---

## 3. Perché uno shift a sinistra può essere visto come una moltiplicazione per una potenza di 2?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In binario, spostare un numero a sinistra di una posizione equivale a moltiplicarlo per 2.
>
> Spostarlo a sinistra di `i` posizioni equivale quindi a moltiplicarlo per:
>
> ```text
> 2^i
> ```
>
> Per esempio, se un registro contiene il valore 9:
>
> ```text
> 9 << 4 = 144
> ```
>
> perché:
>
> ```text
> 9 × 2^4 = 9 × 16 = 144
> ```
>
> In RISC-V questo si può fare con:
>
> ```asm
> slli x11, x19, 4
> ```
>
> che significa:
>
> ```text
> x11 = x19 << 4
> ```
>
> Questa tecnica è molto usata anche per calcolare indirizzi, ad esempio quando si accede ad array di interi da 4 byte: moltiplicare l’indice per 4 equivale a fare uno shift a sinistra di 2 posizioni.

---

## 4. Che cosa fanno le operazioni `AND`, `OR` e `XOR` bit a bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le operazioni `AND`, `OR` e `XOR` lavorano bit per bit tra due operandi.
>
> L’operazione **AND** produce 1 solo se entrambi i bit confrontati sono 1.
>
> ```asm
> and x9, x10, x11
> ```
>
> significa:
>
> ```text
> x9 = x10 & x11
> ```
>
> È spesso usata per applicare una maschera e isolare alcuni bit.
>
> L’operazione **OR** produce 1 se almeno uno dei due bit confrontati è 1.
>
> ```asm
> or x9, x10, x11
> ```
>
> significa:
>
> ```text
> x9 = x10 | x11
> ```
>
> È utile per impostare a 1 determinati bit.
>
> L’operazione **XOR** produce 1 se i due bit confrontati sono diversi.
>
> ```asm
> xor x9, x10, x12
> ```
>
> significa:
>
> ```text
> x9 = x10 ^ x12
> ```
>
> È utile anche per invertire bit quando viene usata con una maschera di tutti 1.

---

## 5. Come si ottiene l’operazione NOT in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In RISC-V non esiste una vera istruzione `NOT` come operazione separata a tre operandi.
>
> L’operazione di negazione bit a bit si ottiene usando `XOR` con una parola composta da tutti bit a 1.
>
> Infatti:
>
> - se un bit viene messo in XOR con 0, rimane uguale;
> - se un bit viene messo in XOR con 1, viene invertito.
>
> Quindi, facendo XOR con tutti bit a 1, tutti i bit dell’operando vengono invertiti.
>
> Esempio concettuale:
>
> ```asm
> xor x9, x10, x12
> ```
>
> dove `x12` contiene tutti bit a 1.
>
> In questo modo:
>
> ```text
> x9 = NOT x10
> ```
>
> Questa scelta mantiene il formato a tre operandi tipico delle istruzioni RISC-V.

---

## 6. Che cosa sono le maschere e perché sono importanti nelle operazioni logiche?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una **maschera** è una sequenza di bit usata per selezionare, nascondere o modificare alcune parti di una parola.
>
> Con `AND` si può usare una maschera per isolare certi bit.
>
> Per esempio, se la maschera contiene 1 nelle posizioni che vogliamo conservare e 0 nelle altre, allora:
>
> ```text
> valore AND maschera
> ```
>
> mantiene solo i bit corrispondenti agli 1 della maschera e azzera gli altri.
>
> Con `OR` si possono invece forzare a 1 determinati bit.
>
> Con `XOR` si possono invertire determinati bit.
>
> Le maschere sono molto importanti perché permettono di lavorare su campi contenuti all’interno di una parola, come avviene spesso nei formati di istruzione, nei registri di controllo e nei dati compatti.

---

## 7. Che cosa sono le istruzioni di salto condizionato in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni di salto condizionato permettono al programma di modificare il flusso di esecuzione in base al risultato di un confronto.
>
> Sono fondamentali per implementare costrutti decisionali come:
>
> - `if`;
> - `if-then-else`;
> - `while`;
> - cicli;
> - controlli su condizioni.
>
> In RISC-V due istruzioni fondamentali sono:
>
> ```asm
> beq rs1, rs2, L1
> ```
>
> e:
>
> ```asm
> bne rs1, rs2, L1
> ```
>
> `beq` significa **branch if equal**: salta all’etichetta `L1` se i due registri sono uguali.
>
> `bne` significa **branch if not equal**: salta all’etichetta `L1` se i due registri sono diversi.
>
> Queste istruzioni prendono il nome di salti condizionati perché il salto avviene solo se la condizione è vera.

---

## 8. Come si traduce un costrutto `if-then-else` in assembly RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un costrutto `if-then-else` viene tradotto usando salti condizionati ed etichette.
>
> Esempio in C:
>
> ```c
> if (i == j)
>     f = g + h;
> else
>     f = g - h;
> ```
>
> Supponendo:
>
> - `f` in `x19`;
> - `g` in `x20`;
> - `h` in `x21`;
> - `i` in `x22`;
> - `j` in `x23`;
>
> una possibile traduzione RISC-V è:
>
> ```asm
> bne x22, x23, Else     // se i != j, vai a Else
> add x19, x20, x21      // f = g + h
> beq x0, x0, Esci       // salto incondizionato a Esci
>
> Else:
> sub x19, x20, x21      // f = g - h
>
> Esci:
> ```
>
> L’idea è usare il salto condizionato per andare direttamente al ramo `else` quando la condizione dell’`if` non è verificata.
>
> Dopo aver eseguito il ramo `then`, si usa un salto incondizionato per evitare di eseguire anche il ramo `else`.

---

## 9. Come si realizza un salto incondizionato usando un’istruzione condizionata?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un salto incondizionato può essere ottenuto usando una condizione che è sempre vera.
>
> In RISC-V il registro `x0` contiene sempre il valore 0.
>
> Quindi:
>
> ```asm
> beq x0, x0, Etichetta
> ```
>
> significa:
>
> ```text
> se x0 == x0, salta a Etichetta
> ```
>
> Poiché `x0` è sempre uguale a sé stesso, il salto viene sempre eseguito.
>
> Questa tecnica può essere usata per saltare alla fine di un costrutto `if-then-else` dopo aver eseguito il ramo `then`.

---

## 10. Come si traduce un ciclo `while` in assembly RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un ciclo `while` viene tradotto usando:
>
> - un’etichetta all’inizio del ciclo;
> - un test condizionato per uscire;
> - il corpo del ciclo;
> - un salto all’inizio del ciclo.
>
> Esempio in C:
>
> ```c
> while (salva[i] == k)
>     i += 1;
> ```
>
> Supponendo:
>
> - `i` in `x22`;
> - `k` in `x24`;
> - indirizzo base di `salva` in `x25`;
>
> bisogna prima calcolare l’indirizzo di `salva[i]`.
>
> Poiché ogni intero occupa 4 byte, si moltiplica `i` per 4 usando uno shift a sinistra di 2:
>
> ```asm
> Ciclo:
> slli x10, x22, 2       // x10 = i * 4
> add x10, x10, x25      // x10 = indirizzo di salva[i]
> lw x9, 0(x10)          // x9 = salva[i]
> bne x9, x24, Esci      // se salva[i] != k, esci
> addi x22, x22, 1       // i = i + 1
> beq x0, x0, Ciclo      // torna all'inizio del ciclo
>
> Esci:
> ```
>
> La struttura generale è quindi:
>
> ```text
> test della condizione
> se falsa, esci
> corpo del ciclo
> torna al test
> ```

---

## 11. Che cosa sono i blocchi di base e perché sono utili nella compilazione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **blocco di base** è una sequenza di istruzioni che:
>
> - non contiene salti, tranne eventualmente nell’ultima istruzione;
> - non contiene etichette di destinazione, tranne eventualmente nella prima istruzione.
>
> In altre parole, se l’esecuzione entra in un blocco di base, le istruzioni vengono eseguite in sequenza fino alla fine del blocco.
>
> I blocchi di base sono importanti perché aiutano il compilatore ad analizzare e ottimizzare il programma.
>
> Una delle prime fasi della compilazione consiste proprio nel suddividere il programma in blocchi di base.
>
> Questo rende più semplice ragionare sul flusso di controllo e sulle ottimizzazioni locali.

---

## 12. Quali istruzioni usa RISC-V per confronti tra numeri con segno e senza segno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> RISC-V distingue tra confronti con segno e confronti senza segno.
>
> Per i confronti con segno si usano istruzioni come:
>
> ```asm
> blt
> bge
> ```
>
> `blt` significa **branch if less than**: salta se il primo registro è minore del secondo, interpretando i valori come numeri con segno.
>
> `bge` significa **branch if greater than or equal**: salta se il primo registro è maggiore o uguale al secondo, sempre con interpretazione con segno.
>
> Per i confronti senza segno si usano:
>
> ```asm
> bltu
> bgeu
> ```
>
> `bltu` significa **branch if less than unsigned**.
>
> `bgeu` significa **branch if greater than or equal unsigned**.
>
> La differenza è importante perché lo stesso insieme di bit può rappresentare valori diversi a seconda che venga interpretato con segno o senza segno.
>
> Per esempio, una parola che rappresenta un numero negativo in complemento a due può invece rappresentare un numero molto grande se interpretata senza segno.

---

## 13. Perché il confronto senza segno è utile nel controllo dei limiti di un vettore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il confronto senza segno permette di controllare in modo compatto se un indice è fuori dai limiti di un vettore.
>
> Supponiamo di voler controllare che:
>
> ```text
> 0 <= x < y
> ```
>
> dove `y` è il limite superiore del vettore.
>
> Se `x` è negativo, nella rappresentazione senza segno viene interpretato come un numero molto grande.
>
> Quindi, per verificare se `x` è fuori limite, basta controllare:
>
> ```text
> x >= y
> ```
>
> usando un confronto senza segno.
>
> In RISC-V:
>
> ```asm
> bgeu x20, x11, IndiceFuoriLimiti
> ```
>
> Questa istruzione salta a `IndiceFuoriLimiti` se `x20 >= x11` senza segno.
>
> In questo modo si intercettano sia i casi in cui:
>
> - `x20` è maggiore o uguale al limite superiore;
> - `x20` è negativo, perché interpretato senza segno risulta molto grande.
>
> È una scorciatoia efficiente per il controllo dei limiti.

---

## 14. Come può essere implementato un costrutto `case/switch` in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un costrutto `case/switch` permette di scegliere tra più alternative in base al valore di una variabile.
>
> Può essere implementato con una sequenza di confronti, come una catena di `if-then-else`.
>
> Tuttavia, quando i casi sono numerosi, questa soluzione può essere inefficiente.
>
> Un metodo più efficiente consiste nell’usare una **tabella degli indirizzi di salto**, detta anche **branch address table** o **tabella di salto**.
>
> La tabella contiene gli indirizzi delle istruzioni corrispondenti ai diversi casi.
>
> Il programma:
>
> 1. calcola l’indice corrispondente al valore dello `switch`;
> 2. accede alla tabella di salto;
> 3. carica l’indirizzo della sequenza di istruzioni da eseguire;
> 4. salta indirettamente a quell’indirizzo.
>
> In RISC-V questo può essere fatto con un salto indiretto tramite registro:
>
> ```asm
> jalr
> ```
>
> cioè **jump and link register**.
>
> Il salto indiretto è più generale perché l’indirizzo di destinazione non è scritto direttamente nell’istruzione, ma è contenuto in un registro.

---

## 15. Qual è il ruolo delle etichette nell’assembly prodotto dal compilatore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le etichette servono a indicare punti del programma verso cui è possibile saltare.
>
> Nei linguaggi ad alto livello, il programmatore usa costrutti come:
>
> - `if`;
> - `else`;
> - `while`;
> - `switch`.
>
> In assembly, questi costrutti vengono tradotti in istruzioni di salto verso etichette.
>
> Le etichette rendono più leggibile il codice assembly, perché evitano al programmatore di calcolare manualmente gli indirizzi delle istruzioni.
>
> Sarà poi l’assemblatore a trasformare le etichette in indirizzi effettivi di memoria.
>
> Questo mostra bene il ruolo dell’interfaccia hardware/software: il linguaggio assembly nasconde alcuni dettagli numerici, ma espone comunque la struttura reale del controllo di flusso della macchina.

---

## 16. Qual è l’idea principale dell’interfaccia hardware/software in questa parte del capitolo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’idea principale è che i costrutti dei linguaggi ad alto livello vengono tradotti in istruzioni molto semplici eseguite dall’hardware.
>
> Per esempio:
>
> - un `if` diventa una combinazione di confronti, salti condizionati ed etichette;
> - un `while` diventa un test condizionato più un salto all’inizio del ciclo;
> - uno `switch` può diventare una tabella di indirizzi di salto;
> - un accesso a un array richiede il calcolo esplicito dell’indirizzo dell’elemento.
>
> Il compilatore si occupa di trasformare strutture comode per il programmatore in sequenze di istruzioni eseguibili dalla CPU.
>
> Per questo il linguaggio assembly rappresenta un livello intermedio tra software e hardware: è più vicino alla macchina, ma conserva ancora simboli come registri, etichette e istruzioni mnemoniche.