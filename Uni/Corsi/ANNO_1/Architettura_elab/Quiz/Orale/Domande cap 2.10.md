
# Capitolo 2.10 — Indirizzamento RISC-V di un campo immediato e di un indirizzo ampio

## Metodo di ripasso

Per ripassare questa sezione, concentrati su tre idee principali: prima capisci **perché gli immediati e gli indirizzi non sempre entrano in 32 bit**, poi ripassa **come RISC-V costruisce costanti e salti tramite più formati di istruzione**, infine allenati a riconoscere i campi delle istruzioni macchina usando **opcode, registri, funct3 e funct7**.

---

## 1. Perché in RISC-V esiste il problema degli immediati e degli indirizzi ampi?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni RISC-V sono lunghe 32 bit. Questo semplifica l’hardware, ma crea un problema: non sempre c’è spazio sufficiente per rappresentare costanti o indirizzi molto grandi dentro una singola istruzione.
>
> Per esempio, molte istruzioni con immediato possono contenere solo costanti piccole, spesso a 12 bit. Se invece serve caricare una costante a 32 bit, una sola istruzione non basta.
>
> Per risolvere il problema, RISC-V usa una combinazione di istruzioni. In particolare, per caricare costanti grandi si usa spesso:
>
> ```asm
> lui
> addi
> ```
>
> `lui` carica i bit più significativi della costante, mentre `addi` completa il valore aggiungendo i bit meno significativi.

---

## 2. A cosa serve l’istruzione `lui` in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’istruzione `lui`, cioè **load upper immediate**, serve a caricare una costante nei bit più significativi di un registro.
>
> In particolare, `lui` prende un immediato di 20 bit e lo posiziona nei 20 bit più alti del registro, mettendo a zero i 12 bit meno significativi.
>
> Per esempio:
>
> ```asm
> lui x19, 976
> ```
>
> carica il valore `976` nella parte alta del registro `x19`, lasciando a zero i 12 bit bassi.
>
> Questa istruzione è fondamentale quando bisogna costruire una costante a 32 bit che non può essere rappresentata direttamente con una sola istruzione immediata.

---

## 3. Come si carica una costante a 32 bit usando `lui` e `addi`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per caricare una costante a 32 bit, RISC-V può usare due istruzioni:
>
> ```asm
> lui  rd, parte_alta
> addi rd, rd, parte_bassa
> ```
>
> La prima istruzione, `lui`, carica i 20 bit più significativi della costante nel registro, spostandoli automaticamente a sinistra di 12 bit.
>
> La seconda istruzione, `addi`, aggiunge i 12 bit meno significativi della costante.
>
> Per esempio, per costruire una costante composta da una parte alta e una parte bassa:
>
> ```asm
> lui  x19, 976
> addi x19, x19, 1280
> ```
>
> Dopo `lui`, il registro contiene la parte alta della costante con i 12 bit bassi a zero. Dopo `addi`, il registro contiene il valore finale desiderato.

---

## 4. Perché a volte, usando `lui` e `addi`, bisogna correggere il valore caricato da `lui`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il problema nasce perché l’immediato di `addi` è interpretato come un valore con segno a 12 bit.
>
> Se il bit più significativo dei 12 bit bassi della costante vale `1`, allora quei 12 bit rappresentano un numero negativo in complemento a due.
>
> In quel caso, usando direttamente `addi`, il processore sottrarrebbe invece di aggiungere semplicemente la parte bassa desiderata.
>
> Per correggere questo effetto, l’assembler aumenta di 1 il valore caricato da `lui`. Poiché `lui` carica la parte alta già scalata di `2^12`, aumentare di 1 la parte alta equivale ad aggiungere `2^12`. Questo compensa il fatto che `addi` interpreterà la parte bassa come negativa.
>
> Quindi, quando la parte bassa ha il bit 11 uguale a 1, l’assembler deve fare attenzione alla rappresentazione con segno dell’immediato.

---

## 5. Perché l’assembler è importante nella gestione di costanti grandi e salti lontani?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’assembler permette al programmatore di scrivere istruzioni simboliche semplici, anche quando l’hardware richiede più istruzioni macchina per realizzarle.
>
> Per esempio, il programmatore può voler caricare una costante grande o saltare a un indirizzo lontano. Se la costante o l’indirizzo non entrano nei campi immediati dell’istruzione, l’assembler può trasformare automaticamente il codice in una sequenza equivalente di istruzioni.
>
> Questo è un esempio di interfaccia hardware/software: il linguaggio assembly può essere più comodo e simbolico, mentre l’hardware resta semplice e regolare.
>
> L’architettura del processore non include necessariamente tutte le pseudoistruzioni dell’assembler: esse servono per rendere più semplice la scrittura del codice.

---

## 6. Come sono rappresentati i salti condizionati in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni di salto condizionato RISC-V, come `beq` e `bne`, usano un formato che contiene:
>
> - due registri da confrontare;
> - un codice funzione, come `funct3`;
> - un immediato che rappresenta lo spiazzamento del salto;
> - un opcode che identifica il tipo di istruzione.
>
> Un esempio è:
>
> ```asm
> bne x10, x11, 2000
> ```
>
> Questa istruzione confronta `x10` e `x11`. Se sono diversi, il programma salta alla destinazione calcolata tramite l’immediato.
>
> I salti condizionati usano indirizzamento relativo al PC: la destinazione non è un indirizzo assoluto, ma uno spiazzamento rispetto al valore del program counter.

---

## 7. Che cos’è l’indirizzamento relativo al program counter nei salti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’indirizzamento relativo al program counter, detto anche **PC-relative addressing**, è una modalità in cui la destinazione del salto viene calcolata sommando uno spiazzamento al valore corrente del PC.
>
> La formula concettuale è:
>
> ```text
> destinazione = PC + spiazzamento
> ```
>
> Questa modalità è molto utile perché i salti nei programmi tendono spesso a essere vicini all’istruzione corrente, per esempio nei cicli o negli `if`.
>
> Inoltre, il codice diventa più facilmente rilocabile: se il programma viene spostato in memoria, i salti relativi continuano a funzionare perché dipendono dalla distanza tra istruzioni, non da indirizzi assoluti.

---

## 8. Perché nei salti RISC-V lo spiazzamento è espresso in mezze parole e non direttamente in byte?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni RISC-V standard sono ampie 4 byte, ma l’architettura prevede anche istruzioni compresse da 2 byte.
>
> Per questo motivo, nei campi immediati dei salti, lo spiazzamento è espresso in **mezze parole**, cioè gruppi da 2 byte.
>
> Questo permette di rappresentare una distanza maggiore usando lo stesso numero di bit.
>
> Per esempio, un campo immediato da 12 bit nei salti condizionati può rappresentare uno spiazzamento effettivo di 13 bit in termini di byte, perché il bit meno significativo è implicitamente zero.
>
> In pratica, il salto avviene sempre verso indirizzi allineati almeno a 2 byte.

---

## 9. Qual è la differenza tra salti condizionati e salto incondizionato `jal`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I salti condizionati, come `beq` e `bne`, vengono eseguiti solo se una certa condizione è vera.
>
> Per esempio:
>
> ```asm
> beq x10, x0, L1
> ```
>
> salta a `L1` solo se `x10` è uguale a zero.
>
> L’istruzione `jal`, cioè **jump-and-link**, invece è un salto incondizionato. Salta sempre alla destinazione indicata e salva anche l’indirizzo di ritorno nel registro destinazione.
>
> Per esempio:
>
> ```asm
> jal x1, funzione
> ```
>
> salta a `funzione` e salva in `x1` l’indirizzo dell’istruzione successiva, così da poter tornare dopo la chiamata.
>
> Se invece si scrive:
>
> ```asm
> jal x0, L1
> ```
>
> il salto è incondizionato ma l’indirizzo di ritorno viene scartato, perché `x0` vale sempre zero.

---

## 10. Come si può realizzare un salto condizionato verso un indirizzo lontano?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I salti condizionati hanno un campo immediato limitato, quindi possono raggiungere solo destinazioni relativamente vicine.
>
> Se bisogna saltare condizionatamente a un indirizzo troppo lontano, l’assembler può invertire la condizione e usare poi un salto incondizionato.
>
> Per esempio, un salto:
>
> ```asm
> beq x10, x0, L1
> ```
>
> può essere trasformato in:
>
> ```asm
> bne x10, x0, L2
> jal x0, L1
> L2:
> ```
>
> Il significato è:
>
> - se `x10` non è zero, si salta a `L2` e si evita il salto lungo;
> - se `x10` è zero, non si prende il `bne` e si esegue il `jal` verso `L1`.
>
> In questo modo si riesce a raggiungere una destinazione lontana anche se il salto condizionato da solo non sarebbe sufficiente.

---

## 11. Quali sono i principali formati di istruzione RISC-V mostrati in questa sezione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In questa sezione vengono richiamati quattro formati principali:
>
> - **Formato R**, usato per istruzioni aritmetiche tra registri.
> - **Formato I**, usato per istruzioni con immediato e per i caricamenti da memoria.
> - **Formato S**, usato per le istruzioni di store.
> - **Formato U**, usato per istruzioni con immediato alto, come `lui`.
>
> Nei salti condizionati e incondizionati esistono anche varianti collegate ai formati S e U:
>
> - i salti condizionati usano un formato spesso chiamato **SB**;
> - `jal` usa un formato spesso chiamato **UJ**.
>
> Questi formati distribuiscono i campi dell’istruzione in modo diverso, ma mantengono l’obiettivo di avere istruzioni regolari e semplici da decodificare.

---

## 12. Come è strutturato il formato R in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il formato R è usato per operazioni aritmetico-logiche tra registri, come:
>
> ```asm
> add x16, x15, x5
> ```
>
> I campi principali sono:
>
> - `funct7`, che contribuisce a distinguere l’operazione;
> - `rs2`, secondo registro sorgente;
> - `rs1`, primo registro sorgente;
> - `funct3`, altro campo che specifica l’operazione;
> - `rd`, registro destinazione;
> - `opcode`, che identifica la classe dell’istruzione.
>
> Quindi il formato R è pensato per istruzioni con due operandi sorgente nei registri e un registro destinazione.

---

## 13. Come è strutturato il formato I in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il formato I è usato per istruzioni con immediato, come:
>
> ```asm
> addi x5, x6, 10
> ```
>
> ed è usato anche per istruzioni di caricamento dalla memoria, come:
>
> ```asm
> lw x5, 8(x10)
> ```
>
> I campi principali sono:
>
> - immediato a 12 bit;
> - `rs1`, registro sorgente o registro base;
> - `funct3`;
> - `rd`, registro destinazione;
> - `opcode`.
>
> Nel caso di `addi`, l’immediato è un valore costante da sommare. Nel caso di `lw`, l’immediato è lo spiazzamento da sommare al registro base per calcolare l’indirizzo di memoria.

---

## 14. Come è strutturato il formato S in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il formato S è usato per le istruzioni di store, cioè per scrivere dati in memoria.
>
> Un esempio è:
>
> ```asm
> sw x5, 8(x10)
> ```
>
> In questo caso:
>
> - `x10` è il registro base;
> - `8` è lo spiazzamento;
> - `x5` contiene il valore da salvare in memoria.
>
> Il formato S contiene:
>
> - una parte dell’immediato nei bit più alti;
> - `rs2`, cioè il registro che contiene il dato da scrivere;
> - `rs1`, cioè il registro base;
> - `funct3`;
> - l’altra parte dell’immediato;
> - `opcode`.
>
> A differenza del formato I, non c’è un registro destinazione `rd`, perché l’istruzione non scrive in un registro ma in memoria.

---

## 15. Come è strutturato il formato U e perché è utile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il formato U è usato per istruzioni che devono contenere un immediato molto ampio, in particolare un immediato da 20 bit.
>
> L’esempio principale è:
>
> ```asm
> lui rd, immediato
> ```
>
> Il formato U contiene:
>
> - un immediato da 20 bit;
> - il registro destinazione `rd`;
> - l’opcode.
>
> È utile perché permette di caricare la parte alta di una costante a 32 bit. I 20 bit immediati vengono collocati nei bit più significativi del registro, mentre i 12 bit meno significativi vengono posti a zero.
>
> Per completare la costante, spesso si usa poi un’istruzione come `addi`.

---

## 16. Come si decodifica un’istruzione RISC-V in linguaggio macchina?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per decodificare un’istruzione RISC-V in linguaggio macchina bisogna seguire alcuni passaggi ordinati.
>
> Prima si converte il valore esadecimale in binario.
>
> Poi si osserva l’opcode, cioè i 7 bit meno significativi dell’istruzione. L’opcode permette di capire il formato dell’istruzione.
>
> Una volta riconosciuto il formato, si dividono i bit nei campi corretti. Per esempio, nel formato R i campi sono:
>
> ```text
> funct7 | rs2 | rs1 | funct3 | rd | opcode
> ```
>
> Infine, si traducono i numeri dei registri nei corrispondenti registri RISC-V e si usano `funct3` e `funct7` per identificare l’operazione precisa.
>
> Per esempio, se l’opcode indica un’istruzione aritmetica di tipo R e i campi corrispondono ad `add`, si può ottenere un’istruzione del tipo:
>
> ```asm
> add x16, x15, x5
> ```

---

## 17. A cosa servono i campi `opcode`, `funct3` e `funct7`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il campo `opcode` identifica la classe generale dell’istruzione.
>
> Per esempio, permette di capire se l’istruzione è:
>
> - aritmetica;
> - di caricamento;
> - di memorizzazione;
> - di salto;
> - con immediato alto.
>
> Tuttavia, spesso l’opcode da solo non basta per distinguere l’operazione precisa.
>
> Per questo si usano anche i campi `funct3` e, in alcuni formati, `funct7`.
>
> Per esempio, nelle istruzioni di tipo R, molte operazioni hanno lo stesso opcode, ma si distinguono tramite `funct3` e `funct7`.
>
> Quindi:
>
> - `opcode` dice la famiglia dell’istruzione;
> - `funct3` restringe il tipo di operazione;
> - `funct7` distingue ulteriormente operazioni simili, come `add` e `sub`.

---

## 18. Perché RISC-V usa formati regolari ma non sempre immediati contigui?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> RISC-V cerca di mantenere le istruzioni semplici e regolari per facilitare la decodifica hardware.
>
> Tuttavia, in alcuni formati, come quelli per store e salti, l’immediato non è scritto in bit tutti consecutivi. Viene diviso in più parti all’interno dell’istruzione.
>
> Questo accade per mantenere alcuni campi, come `rs1`, `rs2`, `rd`, `funct3` e `opcode`, sempre in posizioni simili tra i vari formati.
>
> Il vantaggio è che l’hardware può leggere più facilmente i registri e i campi principali.
>
> Lo svantaggio è che l’assembler deve fare un lavoro maggiore per ricostruire o distribuire correttamente gli immediati.

---

## 19. Qual è il ruolo dell’interfaccia hardware/software nel caso delle istruzioni RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’interfaccia hardware/software indica il confine tra ciò che viene gestito direttamente dal processore e ciò che viene semplificato dagli strumenti software, come assembler e compilatore.
>
> RISC-V mantiene l’hardware semplice usando istruzioni regolari, campi limitati e formati ben definiti.
>
> Però alcune operazioni comode per il programmatore, come caricare costanti grandi o saltare a indirizzi lontani, possono richiedere più istruzioni reali.
>
> In questi casi interviene l’assembler, che traduce istruzioni simboliche o pseudoistruzioni in sequenze di istruzioni macchina valide.
>
> Quindi l’hardware resta semplice, mentre il software nasconde parte della complessità al programmatore.

---

## 20. Quali sono le idee fondamentali da ricordare per l’esame su questa sezione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le idee fondamentali sono:
>
> - le istruzioni RISC-V sono lunghe 32 bit, quindi immediati e indirizzi grandi non sempre entrano in una sola istruzione;
> - `lui` serve a caricare i 20 bit alti di una costante;
> - `addi` può completare una costante aggiungendo i 12 bit bassi;
> - bisogna fare attenzione al segno degli immediati a 12 bit;
> - i salti usano spesso indirizzamento relativo al PC;
> - gli spiazzamenti dei salti sono espressi in mezze parole, non direttamente in byte;
> - i salti condizionati hanno raggio limitato, ma l’assembler può gestire salti lontani invertendo la condizione e usando `jal`;
> - per decodificare un’istruzione macchina bisogna guardare prima l’opcode, poi dividere i campi secondo il formato corretto;
> - `opcode`, `funct3` e `funct7` servono insieme a identificare l’istruzione precisa;
> - l’assembler semplifica il lavoro del programmatore traducendo forme simboliche in istruzioni macchina reali.