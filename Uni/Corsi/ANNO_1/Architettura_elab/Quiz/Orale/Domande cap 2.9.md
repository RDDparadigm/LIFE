
# 2.9 Comunicare con le persone

## Metodo di ripasso

Concentrati su tre idee centrali: perché ASCII e Unicode sono necessari, come vengono rappresentate stringhe e caratteri in memoria, e come RISC-V manipola byte e mezze parole con istruzioni dedicate.  
Per l’orale, saper collegare il concetto astratto di “testo” alla sua rappresentazione concreta in memoria è più importante che ricordare tutta la tabella ASCII.

---

## 1. Perché i calcolatori usano codifiche come ASCII per rappresentare i caratteri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I calcolatori memorizzano solo sequenze di bit, quindi anche i caratteri devono essere rappresentati tramite numeri binari.
>
> La codifica ASCII associa a ogni carattere un codice numerico. Per esempio, lettere, cifre, simboli e caratteri speciali hanno ciascuno un valore intero associato.
>
> ASCII usa 8 bit, cioè 1 byte, per rappresentare un carattere. Questo consente di codificare fino a 256 valori diversi.
>
> È importante distinguere il carattere dal numero che lo rappresenta: ad esempio il carattere `'A'` non è la stessa cosa del numero 65, ma in ASCII viene rappresentato dal codice 65.

---

## 2. Perché non conviene rappresentare i numeri come stringhe ASCII invece che come interi binari?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Rappresentare i numeri come stringhe ASCII sarebbe inefficiente sia in memoria sia nelle operazioni aritmetiche.
>
> Per esempio, il numero `1.000.000.000` come intero a 32 bit occupa 4 byte. Se invece fosse rappresentato come stringa ASCII, richiederebbe 10 caratteri, quindi 10 byte.
>
> Inoltre, eseguire somme, sottrazioni, moltiplicazioni e divisioni su caratteri ASCII sarebbe molto più complesso: l’hardware dovrebbe interpretare ogni cifra, gestire la posizione decimale e trasformare la stringa in un valore numerico.
>
> Per questo i numeri vengono normalmente rappresentati in binario, mentre ASCII è usato per rappresentare testo leggibile dalle persone.

---

## 3. Che differenza c’è tra caratteri, stringhe e terminatore nullo nel linguaggio C?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In C una stringa è una sequenza di caratteri memorizzati in memoria uno dopo l’altro.
>
> Ogni carattere occupa normalmente 1 byte, perché viene codificato con ASCII o con una codifica compatibile.
>
> La fine della stringa viene indicata dal carattere nullo, cioè dal byte con valore `0`, scritto come `'\0'`.
>
> Per esempio, la stringa `"Cal"` in C viene memorizzata come:
>
> ```text
> 'C' 'a' 'l' '\0'
> ```
>
> Quindi una stringa C occupa un byte in più rispetto al numero di caratteri visibili, perché serve il terminatore nullo.

---

## 4. Quali sono i tre modi principali per rappresentare una stringa in memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Esistono tre modi principali per rappresentare una stringa:
>
> 1. Il primo elemento contiene la lunghezza della stringa.
> 2. Una variabile separata contiene la lunghezza della stringa.
> 3. Un carattere speciale indica la fine della stringa.
>
> Il linguaggio C usa il terzo metodo: la stringa termina quando si incontra il byte nullo `'\0'`.
>
> Java invece usa un approccio diverso: una stringa è un oggetto che contiene anche informazioni sulla propria lunghezza, quindi non si basa sul terminatore nullo come C.

---

## 5. A cosa servono le istruzioni RISC-V `lbu` e `sb`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni `lbu` e `sb` servono a manipolare singoli byte in memoria.
>
> `lbu`, cioè *load byte unsigned*, carica un byte dalla memoria in un registro. Poiché i registri RISC-V sono più grandi di un byte, il valore caricato viene esteso con zeri nei bit più significativi.
>
> Esempio:
>
> ```assembly
> lbu x12, 0(x10)
> ```
>
> carica in `x12` il byte che si trova all’indirizzo contenuto in `x10`.
>
> `sb`, cioè *store byte*, salva in memoria solo gli 8 bit meno significativi di un registro.
>
> Esempio:
>
> ```assembly
> sb x12, 0(x11)
> ```
>
> scrive in memoria, all’indirizzo contenuto in `x11`, il byte meno significativo di `x12`.

---

## 6. Come funziona la copia di una stringa C in assembly RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La copia di una stringa C consiste nel leggere un carattere alla volta dalla stringa sorgente e scriverlo nella stringa destinazione, finché non viene copiato anche il terminatore nullo `'\0'`.
>
> In RISC-V si usa un ciclo:
>
> 1. Si calcola l’indirizzo del carattere sorgente `y[i]`.
> 2. Si carica il byte con `lbu`.
> 3. Si calcola l’indirizzo del carattere destinazione `x[i]`.
> 4. Si salva il byte con `sb`.
> 5. Si controlla se il byte copiato vale `0`.
> 6. Se non vale `0`, si incrementa `i` e si ripete il ciclo.
>
> Il controllo sul byte nullo è essenziale perché in C la fine della stringa non è nota da una variabile di lunghezza, ma viene rilevata leggendo il carattere `'\0'`.

---

## 7. Perché nella copia di una stringa C si usa `lbu` invece di una normale istruzione di caricamento di parola?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Si usa `lbu` perché i caratteri di una stringa C occupano 1 byte ciascuno.
>
> Una normale istruzione di caricamento di parola, come `lw`, caricherebbe 4 byte alla volta, cioè una parola intera, mentre per copiare una stringa bisogna gestire un singolo carattere alla volta.
>
> `lbu` carica esattamente un byte e lo estende con zeri nel registro. Questo è adatto per caratteri ASCII, perché i loro codici sono valori non negativi.
>
> In modo analogo, per scrivere il carattere nella stringa destinazione si usa `sb`, che memorizza solo un byte.

---

## 8. Qual è il ruolo dello stack nella procedura RISC-V che copia una stringa?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nella procedura RISC-V per copiare una stringa, lo stack viene usato per salvare temporaneamente registri che devono essere preservati.
>
> In particolare, se la procedura usa un registro come `x19`, deve salvarne il valore originale nello stack prima di modificarlo.
>
> All’inizio della procedura si decrementa lo stack pointer per riservare spazio:
>
> ```assembly
> addi sp, sp, -4
> sw x19, 0(sp)
> ```
>
> Alla fine della procedura si ripristina il valore salvato:
>
> ```assembly
> lw x19, 0(sp)
> addi sp, sp, 4
> ```
>
> Questo permette alla procedura chiamante di ritrovare i propri registri invariati dopo il ritorno dalla procedura.

---

## 9. Che cos’è Unicode e perché è stato introdotto?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Unicode è una codifica universale pensata per rappresentare i caratteri di molte lingue e alfabeti del mondo.
>
> ASCII è sufficiente per l’inglese e per alcuni simboli comuni, ma non basta per rappresentare alfabeti come greco, cirillico, arabo, devanagari, cinese, giapponese, coreano e molti altri.
>
> Unicode assegna un codice a un insieme molto più ampio di caratteri rispetto ad ASCII.
>
> In questo modo, testi scritti in lingue diverse possono essere rappresentati in modo standardizzato e scambiati tra sistemi diversi.

---

## 10. Come rappresenta Java i caratteri e in cosa differisce dal C?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Java usa Unicode per rappresentare i caratteri e normalmente utilizza 16 bit per un singolo carattere.
>
> Questo è diverso dal C tradizionale, dove un carattere occupa tipicamente 8 bit, cioè 1 byte, ed è spesso associato ad ASCII.
>
> Inoltre, le stringhe Java non terminano con il carattere nullo `'\0'`. Una stringa Java è un oggetto e contiene informazioni sulla propria lunghezza.
>
> Quindi:
>
> - in C le stringhe sono array di caratteri terminati da `'\0'`;
> - in Java le stringhe sono oggetti con lunghezza esplicita;
> - in C un carattere occupa spesso 1 byte;
> - in Java un carattere occupa normalmente 16 bit.

---

## 11. A cosa servono le istruzioni RISC-V `lhu` e `sh`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni `lhu` e `sh` servono a caricare e memorizzare mezze parole, cioè gruppi di 16 bit.
>
> `lhu`, cioè *load half unsigned*, carica una mezza parola dalla memoria e riempie con zeri i bit più significativi del registro.
>
> Esempio:
>
> ```assembly
> lhu x19, 0(x10)
> ```
>
> carica in `x19` una mezza parola dall’indirizzo contenuto in `x10`.
>
> `sh`, cioè *store half*, salva in memoria i 16 bit meno significativi di un registro.
>
> Esempio:
>
> ```assembly
> sh x19, 0(x11)
> ```
>
> scrive in memoria una mezza parola all’indirizzo contenuto in `x11`.
>
> Queste istruzioni sono utili, ad esempio, per gestire caratteri Unicode rappresentati su 16 bit.

---

## 12. Perché nelle architetture moderne il testo è più complesso dei semplici caratteri ASCII?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il testo moderno deve rappresentare molte più informazioni rispetto ai semplici caratteri ASCII.
>
> ASCII gestisce bene lettere latine, cifre e simboli comuni, ma non rappresenta adeguatamente alfabeti internazionali, accenti, simboli matematici, punteggiatura speciale, emoji e caratteri di molte lingue.
>
> Per questo sono state introdotte codifiche come Unicode, che permettono di rappresentare un insieme molto più ampio di caratteri.
>
> Dal punto di vista dell’architettura degli elaboratori, questo implica che non sempre un carattere corrisponde a un singolo byte. Alcune codifiche possono usare 16 bit o una lunghezza variabile.
>
> Quindi la gestione del testo richiede istruzioni e convenzioni adatte a byte, mezze parole e rappresentazioni più complesse.
> 