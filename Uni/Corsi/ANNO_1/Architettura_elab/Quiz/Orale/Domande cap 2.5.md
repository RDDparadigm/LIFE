
# Capitolo 2 — Linguaggio macchina, formato delle istruzioni e programma memorizzato

## Metodo di ripasso

Per preparare l’orale, concentrati sul collegamento tra tre livelli: istruzione assembler, rappresentazione binaria e formato dei campi RISC-V. Devi saper spiegare perché le istruzioni sono codificate come numeri, come sono divise in campi, quali sono i formati principali R, I e S, e perché questo porta al concetto di programma memorizzato.

---

## 1. Che cosa si intende per formato dell’istruzione in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il formato dell’istruzione è il modo in cui una singola istruzione macchina viene suddivisa in campi binari, ciascuno con un significato preciso.
>
> In RISC-V ogni istruzione è rappresentata come una parola di 32 bit. Questi 32 bit non sono letti come un unico numero generico, ma come una sequenza di campi, ad esempio:
>
> - `codop`, che identifica l’operazione di base;
> - `rd`, registro destinazione;
> - `rs1` e `rs2`, registri sorgente;
> - `funct3` e `funct7`, che specificano ulteriormente l’operazione;
> - `immediato`, usato per costanti o offset.
>
> Il formato permette quindi all’hardware di capire che operazione eseguire e su quali operandi.

---

## 2. Perché le istruzioni assembler devono essere tradotte in linguaggio macchina?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni assembler sono leggibili dai programmatori, ma non possono essere eseguite direttamente dall’hardware.
>
> Il processore lavora solo con sequenze di bit, quindi ogni istruzione assembler deve essere tradotta in una rappresentazione binaria chiamata linguaggio macchina.
>
> Ad esempio, un’istruzione come:
>
> `add x1, x2, x3`
>
> deve essere codificata in una parola di 32 bit, dove alcuni bit indicano l’operazione di somma, altri indicano i registri sorgente e altri ancora il registro destinazione.
>
> L’assembler ha proprio il compito di trasformare istruzioni simboliche in codice macchina eseguibile.

---

## 3. Che ruolo hanno i numeri esadecimali nella rappresentazione delle istruzioni macchina?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I numeri esadecimali vengono usati perché rendono più compatta e leggibile la rappresentazione dei numeri binari.
>
> Poiché la base 16 è una potenza di 2, ogni cifra esadecimale corrisponde esattamente a 4 bit.
>
> Per esempio:
>
> - `0` corrisponde a `0000`;
> - `1` corrisponde a `0001`;
> - `a` corrisponde a `1010`;
> - `f` corrisponde a `1111`.
>
> Questo rende molto semplice convertire un numero binario in esadecimale e viceversa, raggruppando i bit a gruppi di 4.
>
> Per evitare confusione, i numeri esadecimali sono spesso indicati con il prefisso `0x`.

---

## 4. Quali sono i campi principali di un’istruzione RISC-V e che significato hanno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I principali campi di un’istruzione RISC-V sono:
>
> - `codop`: identifica l’operazione di base dell’istruzione;
> - `rd`: registro destinazione, cioè il registro che riceve il risultato;
> - `rs1`: primo registro sorgente;
> - `rs2`: secondo registro sorgente;
> - `funct3`: campo aggiuntivo che specifica meglio l’operazione;
> - `funct7`: ulteriore campo aggiuntivo, usato in alcuni formati;
> - `immediato`: valore costante o offset contenuto direttamente nell’istruzione.
>
> Non tutte le istruzioni usano tutti questi campi. La scelta dei campi dipende dal formato dell’istruzione.

---

## 5. Perché in RISC-V esistono formati diversi di istruzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Esistono formati diversi perché istruzioni diverse hanno bisogno di campi diversi.
>
> Per esempio, un’istruzione aritmetica tra registri, come `add`, deve specificare due registri sorgente e un registro destinazione. Invece, un’istruzione di load deve specificare un registro base, un registro destinazione e un offset immediato.
>
> Se tutte le istruzioni avessero esattamente lo stesso formato, alcuni campi sarebbero inutili o troppo piccoli per certe istruzioni.
>
> RISC-V mantiene però una scelta progettuale importante: tutte le istruzioni hanno la stessa lunghezza, cioè 32 bit. I formati cambiano nella suddivisione interna dei campi, ma la lunghezza complessiva resta fissa.
>
> Questo è un compromesso tra semplicità dell’hardware e flessibilità nella codifica delle istruzioni.

---

## 6. Qual è la struttura del formato R e per quali istruzioni viene usato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il formato R è usato per istruzioni che operano solo su registri, come `add` e `sub`.
>
> La sua struttura è:
>
> - `funct7`: 7 bit;
> - `rs2`: 5 bit;
> - `rs1`: 5 bit;
> - `funct3`: 3 bit;
> - `rd`: 5 bit;
> - `codop`: 7 bit.
>
> In questo formato ci sono due registri sorgente, `rs1` e `rs2`, e un registro destinazione, `rd`.
>
> Per esempio:
>
> `add x1, x2, x3`
>
> significa che il contenuto di `x2` e `x3` viene sommato e il risultato viene scritto in `x1`.
>
> Il campo `codop`, insieme a `funct3` e `funct7`, permette di distinguere operazioni diverse che hanno una struttura simile, come `add` e `sub`.

---

## 7. Qual è la struttura del formato I e per quali istruzioni viene usato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il formato I è usato per istruzioni che contengono un operando immediato, cioè una costante codificata direttamente nell’istruzione.
>
> La sua struttura è:
>
> - `immediato`: 12 bit;
> - `rs1`: 5 bit;
> - `funct3`: 3 bit;
> - `rd`: 5 bit;
> - `codop`: 7 bit.
>
> È usato, ad esempio, da istruzioni come:
>
> `addi x1, x2, 1000`
>
> oppure da istruzioni di caricamento come:
>
> `lw x1, 1000(x2)`
>
> Nel caso di `addi`, l’immediato rappresenta una costante da sommare. Nel caso di `lw`, l’immediato rappresenta un offset rispetto all’indirizzo contenuto nel registro base `rs1`.

---

## 8. Qual è la struttura del formato S e perché l’immediato è diviso in due parti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il formato S è usato per le istruzioni di store, come:
>
> `sw x1, 1000(x2)`
>
> La sua struttura è:
>
> - `immediato[11:5]`: 7 bit;
> - `rs2`: 5 bit;
> - `rs1`: 5 bit;
> - `funct3`: 3 bit;
> - `immediato[4:0]`: 5 bit;
> - `codop`: 7 bit.
>
> In una store servono due registri:
>
> - `rs1`, che contiene l’indirizzo base;
> - `rs2`, che contiene il dato da memorizzare.
>
> Non serve invece un registro destinazione `rd`, perché l’istruzione non scrive un risultato in un registro, ma in memoria.
>
> Per questo motivo i bit che in altri formati sarebbero occupati da `rd` vengono usati per contenere una parte dell’immediato. L’immediato viene quindi spezzato in due campi, ma logicamente rappresenta un unico valore.

---

## 9. Come si traduce un’istruzione assembler RISC-V in linguaggio macchina?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per tradurre un’istruzione assembler in linguaggio macchina bisogna:
>
> 1. riconoscere il tipo di istruzione;
> 2. scegliere il formato corretto, ad esempio R, I o S;
> 3. individuare i registri usati e sostituirli con il loro numero;
> 4. inserire eventuali costanti o offset nel campo immediato;
> 5. riempire i campi `codop`, `funct3` e, se presente, `funct7`;
> 6. convertire ogni campo nella sua rappresentazione binaria.
>
> Per esempio, in un’istruzione:
>
> `lw x9, 120(x10)`
>
> il registro destinazione è `x9`, il registro base è `x10`, e `120` è l’offset immediato. L’istruzione viene codificata usando il formato I.
>
> Invece:
>
> `sw x9, 120(x10)`
>
> usa il formato S, perché il valore contenuto in `x9` viene salvato in memoria all’indirizzo ottenuto da `x10 + 120`.

---

## 10. Perché il campo immediato da 12 bit viene interpretato in complemento a due?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il campo immediato da 12 bit viene interpretato in complemento a due perché deve poter rappresentare sia valori positivi sia valori negativi.
>
> Con 12 bit in complemento a due si possono rappresentare valori da:
>
> `-2048` a `+2047`.
>
> Questo è utile, ad esempio, per indicare offset rispetto a un indirizzo base. Un offset può infatti essere positivo, se ci si sposta in avanti in memoria, oppure negativo, se ci si sposta all’indietro.
>
> Nel caso delle istruzioni di load e store, l’indirizzo effettivo viene calcolato sommando il registro base e l’immediato:
>
> `indirizzo effettivo = contenuto di rs1 + immediato`

---

## 11. Perché RISC-V mantiene alcuni campi nella stessa posizione nei diversi formati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> RISC-V cerca di mantenere alcuni campi nella stessa posizione nei diversi formati per semplificare l’hardware.
>
> Per esempio, i campi `rs1`, `rs2` e `funct3` si trovano spesso nelle stesse posizioni anche quando cambia il formato dell’istruzione.
>
> Questo permette al processore di leggere più facilmente i registri e interpretare i campi principali, senza dover usare circuiti troppo complessi per ogni formato.
>
> È un esempio del principio di progettazione secondo cui un buon progetto richiede buoni compromessi: si accetta una certa complessità nella codifica, come l’immediato spezzato nel formato S, per ottenere un hardware più semplice e regolare.

---

## 12. Che cosa si intende per principio del programma memorizzato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il principio del programma memorizzato afferma che le istruzioni di un programma sono rappresentate come numeri e possono essere conservate in memoria insieme ai dati.
>
> Questo significa che la memoria non contiene solo dati, ma anche istruzioni macchina.
>
> Il processore preleva le istruzioni dalla memoria, le interpreta e le esegue.
>
> Questo principio è fondamentale perché permette di trattare i programmi come dati: possono essere caricati, copiati, modificati, compilati e trasmessi come sequenze di bit.
>
> È anche ciò che rende possibile avere software diversi sulla stessa macchina, senza cambiare l’hardware.

---

## 13. Qual è il rapporto tra compilatore, assembler e linguaggio macchina?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il compilatore e l’assembler trasformano progressivamente un programma scritto dall’uomo in una forma eseguibile dal processore.
>
> Il compilatore traduce un linguaggio ad alto livello, come C, in istruzioni assembler.
>
> L’assembler traduce poi le istruzioni assembler in linguaggio macchina, cioè in sequenze binarie compatibili con il formato delle istruzioni dell’architettura.
>
> Quindi il percorso è:
>
> programma C → linguaggio assembler → linguaggio macchina.
>
> Alla fine, il programma eseguibile è una sequenza di istruzioni macchina memorizzate in memoria.

---

## 14. Perché si dice che i programmi sono numeri come i dati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Si dice che i programmi sono numeri come i dati perché anche le istruzioni vengono rappresentate tramite sequenze di bit.
>
> Una stessa memoria può quindi contenere:
>
> - dati numerici;
> - testi;
> - indirizzi;
> - istruzioni macchina;
> - programmi compilati.
>
> Dal punto di vista fisico, tutto è rappresentato da bit. È il contesto di utilizzo che stabilisce se una certa sequenza di bit deve essere interpretata come dato oppure come istruzione.
>
> Questa idea è alla base del concetto di programma memorizzato e permette ai computer moderni di caricare ed eseguire programmi diversi senza modificare il processore.