# Capitolo 4.2 - Convenzioni del progetto logico

## Metodo di ripasso

Legenda:

- 🔴 = non la so
- 🟡 = la so a metà
- 🟢 = la so bene

Durante il ripasso:
1. Leggo solo la domanda.
2. Provo a rispondere a voce o per iscritto senza guardare.
3. Apro la risposta.
4. Cambio lo stato della domanda.

---

# Flashcard

---

## 1. Cosa si intende per elemento combinatorio?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **elemento combinatorio** è un elemento logico la cui uscita dipende **solo dagli ingressi correnti**.
>
> Non ha memoria interna: se gli ingressi sono gli stessi, l’uscita sarà sempre la stessa.
>
> Esempi:
>
> - porta AND;
> - porta OR;
> - multiplexer;
> - ALU.
>
> Nel datapath RISC-V, molti blocchi sono combinatori: per esempio la ALU riceve due operandi e un segnale di controllo, e produce un risultato in base a quei valori.

---

## 2. Qual è la caratteristica principale della logica combinatoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La caratteristica principale della logica combinatoria è che **non conserva informazioni sul passato**.
>
> L’uscita dipende solo dagli ingressi presenti in quel momento.
>
> Quindi, a parità di ingressi, il risultato prodotto è sempre lo stesso.

---

## 3. Cosa si intende per elemento di stato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **elemento di stato** è un elemento logico che può **memorizzare informazioni**.
>
> A differenza di un elemento combinatorio, la sua uscita può dipendere anche da valori salvati in precedenza.
>
> Esempi:
>
> - registri;
> - memoria dati;
> - memoria istruzioni;
> - Program Counter;
> - flip-flop.
>
> Nel processore, gli elementi di stato permettono di ricordare dati tra un ciclo di clock e il successivo.

---

## 4. Qual è la differenza tra elemento combinatorio ed elemento di stato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **elemento combinatorio** produce un’uscita che dipende solo dagli ingressi attuali.
>
> Un **elemento di stato**, invece, può memorizzare un valore e quindi la sua uscita può dipendere anche da ciò che è stato scritto in passato.
>
> Esempio:
>
> - la ALU è combinatoria, perché dati due operandi produce un risultato;
> - un registro è un elemento di stato, perché conserva un valore finché non viene aggiornato.

---

## 5. Perché gli elementi di stato sono necessari in un processore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli elementi di stato sono necessari perché un processore deve conservare informazioni tra un’istruzione e l’altra o tra un ciclo di clock e il successivo.
>
> Senza elementi di stato, il processore non potrebbe ricordare:
>
> - il contenuto dei registri;
> - il valore del Program Counter;
> - i dati presenti in memoria;
> - lo stato dell’elaborazione precedente.
>
> Senza elementi di stato, il processore sarebbe solo una rete combinatoria incapace di evolvere nel tempo.

---

## 6. Cosa si intende per logica sequenziale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **logica sequenziale** è una logica che contiene elementi di stato.
>
> Le sue uscite possono dipendere:
>
> - dagli ingressi attuali;
> - dal contenuto memorizzato negli elementi di stato.
>
> Per questo motivo la logica sequenziale può rappresentare l’evoluzione temporale di un sistema digitale, come un processore che esegue istruzioni una dopo l’altra.

---

## 7. Perché i circuiti con elementi di stato sono detti sequenziali?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Sono detti **sequenziali** perché il loro comportamento dipende dalla sequenza degli eventi passati.
>
> Un registro, ad esempio, non produce un’uscita solo in base agli ingressi attuali, ma anche in base al valore che era stato scritto in precedenza.
>
> Quindi il sistema ha memoria della sequenza precedente di operazioni.

---

## 8. Qual è il ruolo del clock in un circuito sequenziale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **clock** serve a sincronizzare l’aggiornamento degli elementi di stato.
>
> In un processore sincrono, gli elementi di stato non cambiano valore in qualsiasi momento, ma vengono aggiornati in istanti precisi, determinati dal segnale di clock.
>
> Questo permette di coordinare il passaggio dei dati tra registri, ALU, memorie e altri blocchi del datapath.

---

## 9. Cosa significa che un elemento di stato è sensibile ai fronti?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un elemento di stato è **sensibile ai fronti** se aggiorna il proprio contenuto solo in corrispondenza di un fronte del clock.
>
> Il fronte può essere:
>
> - **fronte di salita**, cioè passaggio da 0 a 1;
> - **fronte di discesa**, cioè passaggio da 1 a 0.
>
> Nel testo si assume una metodologia sensibile ai fronti di salita, quindi gli elementi di stato vengono aggiornati quando il clock passa da basso ad alto.

---

## 10. Cosa si intende per metodologia di temporizzazione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **metodologia di temporizzazione** definisce quando i segnali possono essere letti e scritti in modo sicuro.
>
> Serve a garantire che i dati letti da un elemento di stato siano stabili e validi quando vengono usati dalla logica combinatoria o scritti in un altro elemento di stato.
>
> Senza una metodologia di temporizzazione, si rischierebbe di leggere dati mentre stanno cambiando, ottenendo risultati imprevedibili.

---

## 11. Perché è importante temporizzare correttamente lettura e scrittura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> È importante perché, se lettura e scrittura avvenissero in modo non controllato, un elemento potrebbe leggere un dato mentre un altro lo sta modificando.
>
> Questo renderebbe il comportamento del circuito imprevedibile.
>
> La temporizzazione garantisce invece che:
>
> 1. un elemento di stato fornisca un dato stabile;
> 2. la logica combinatoria elabori quel dato;
> 3. il risultato venga scritto nel successivo elemento di stato solo al fronte di clock corretto.

---

## 12. Si descriva il funzionamento generale di un circuito sincrono con elementi di stato e logica combinatoria.

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In un circuito sincrono, gli elementi di stato vengono aggiornati solo in corrispondenza del fronte attivo del clock.
>
> Tra due fronti di clock:
>
> 1. un elemento di stato fornisce in uscita un valore stabile;
> 2. questo valore attraversa la logica combinatoria;
> 3. la logica combinatoria produce un nuovo risultato;
> 4. al successivo fronte di clock, il nuovo risultato viene scritto in un altro elemento di stato.
>
> Questo schema permette al processore di avanzare in modo ordinato da uno stato al successivo.

---

## 13. Cosa rappresenta la Figura 4.3?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La Figura 4.3 mostra il rapporto tra:
>
> - elementi di stato;
> - logica combinatoria;
> - clock.
>
> Un elemento di stato produce un valore in uscita. Questo valore passa attraverso la logica combinatoria e genera un nuovo valore destinato a un altro elemento di stato.
>
> Il clock determina quando il nuovo valore può essere scritto nell’elemento di stato successivo.
>
> L’idea fondamentale è che la logica combinatoria lavora **tra due aggiornamenti di stato**.

---

## 14. Perché la logica combinatoria deve avere tempo sufficiente per produrre il risultato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La logica combinatoria deve avere tempo sufficiente perché il risultato deve essere stabile prima del successivo fronte di clock.
>
> Se il clock arriva troppo presto, il valore calcolato potrebbe non essere ancora corretto.
>
> In quel caso l’elemento di stato successivo rischierebbe di memorizzare un valore sbagliato.
>
> Per questo il periodo di clock deve essere abbastanza lungo da permettere:
>
> 1. la lettura dell’elemento di stato iniziale;
> 2. la propagazione attraverso la logica combinatoria;
> 3. la stabilizzazione del risultato;
> 4. la scrittura nel nuovo elemento di stato.

---

## 15. Cosa determina la durata minima del ciclo di clock?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La durata minima del ciclo di clock è determinata dal tempo necessario affinché un dato:
>
> 1. esca da un elemento di stato;
> 2. attraversi la logica combinatoria;
> 3. arrivi stabile all’ingresso dell’elemento di stato successivo.
>
> In altre parole, il clock non può essere più veloce del percorso logico più lento che i dati devono attraversare.

---

## 16. Cosa significa che il clock regola il passaggio da uno stato al successivo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Significa che il processore evolve solo in corrispondenza dei fronti attivi del clock.
>
> Durante un ciclo di clock, la logica combinatoria calcola i nuovi valori.
>
> Al fronte successivo, questi valori vengono salvati negli elementi di stato.
>
> Quindi ogni ciclo di clock corrisponde a un passaggio ordinato da uno stato del processore al successivo.

---

## 17. Cosa si intende per segnale di controllo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **segnale di controllo** è un segnale che determina il comportamento di un blocco del datapath.
>
> Ad esempio può decidere:
>
> - quale ingresso deve selezionare un multiplexer;
> - se un registro deve essere scritto oppure no;
> - quale operazione deve eseguire la ALU;
> - se la memoria dati deve essere letta o scritta.
>
> I segnali di controllo non trasportano dati veri e propri, ma indicano agli elementi hardware cosa devono fare.

---

## 18. Cosa significa che un segnale è asserito?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un segnale è **asserito** quando è posto nel livello logico che indica che il segnale è attivo.
>
> Spesso, nel testo, “asserito” significa che il segnale è posto a 1 logico.
>
> Esempio:
>
> Se il segnale `RegWrite` è asserito, allora il banco registri è abilitato alla scrittura.

---

## 19. Cosa significa che un segnale è deasserito?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un segnale è **deasserito** quando è posto nel livello logico che indica che il segnale non è attivo.
>
> Di solito, nel testo, un segnale deasserito è a 0 logico.
>
> Esempio:
>
> Se `MemWrite` è deasserito, la memoria dati non viene scritta.

---

## 20. Perché il libro usa i termini “asserito” e “deasserito” invece di dire sempre “1” e “0”?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Perché non tutti i segnali sono necessariamente attivi quando valgono 1.
>
> Alcuni segnali possono essere **attivi al livello alto**, quindi sono asseriti quando valgono 1.
>
> Altri segnali possono essere **attivi al livello basso**, quindi sono asseriti quando valgono 0.
>
> Usare “asserito” e “deasserito” evita ambiguità:
>
> - **asserito** significa attivo;
> - **deasserito** significa non attivo.
>
> Questo vale indipendentemente dal fatto che il livello fisico sia 1 o 0.

---

## 21. Cosa significa che un segnale è attivo alto o attivo basso?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un segnale è **attivo alto** se viene considerato attivo quando vale 1.
>
> Un segnale è **attivo basso** se viene considerato attivo quando vale 0.
>
> Esempio:
>
> - un segnale `WriteEnable` attivo alto abilita la scrittura quando vale 1;
> - un segnale attivo basso abilita una funzione quando vale 0.
>
> Per questo motivo è più preciso usare i termini “asserito” e “deasserito”.

---

## 22. Cosa mostra la Figura 4.4?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La Figura 4.4 mostra che, con una metodologia sensibile ai fronti, è possibile leggere e scrivere lo stesso elemento di stato nello stesso ciclo di clock senza creare conflitti.
>
> Il valore viene letto durante il ciclo, attraversa la logica combinatoria e viene riscritto solo al fronte attivo del clock.
>
> Questo evita che l’elemento di stato venga continuamente aggiornato durante lo stesso ciclo, cosa che potrebbe causare instabilità o risultati imprevedibili.

---

## 23. Perché la metodologia sensibile ai fronti evita problemi di retroazione nello stesso ciclo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Perché l’elemento di stato non viene aggiornato continuamente, ma solo al fronte del clock.
>
> Se invece un elemento potesse aggiornarsi durante tutto il ciclo, il suo nuovo valore potrebbe rientrare nella logica combinatoria e modificarne di nuovo l’uscita nello stesso ciclo.
>
> Questo creerebbe una retroazione incontrollata.
>
> Con la temporizzazione a fronte, il valore viene aggiornato una sola volta per ciclo, al momento stabilito dal clock.

---

## 24. Perché è possibile leggere e scrivere un registro nello stesso ciclo di clock?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> È possibile perché la lettura e la scrittura non avvengono nello stesso identico istante logico.
>
> Il registro fornisce il vecchio valore in uscita durante il ciclo.
>
> La logica combinatoria usa quel valore per calcolare un nuovo risultato.
>
> Il nuovo risultato viene scritto solo al fronte attivo del clock.
>
> Quindi, nello stesso ciclo, si può usare il vecchio valore per calcolare il nuovo valore da salvare.

---

## 25. Quali elementi dell’architettura RISC-V sono elementi di stato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nell’architettura RISC-V, sono elementi di stato:
>
> - il Program Counter;
> - il banco dei registri;
> - la memoria dati;
> - la memoria istruzioni;
> - eventuali registri interni del datapath.
>
> Questi elementi conservano informazioni tra cicli di clock diversi.

---

## 26. Quali elementi del datapath RISC-V sono tipicamente combinatori?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Sono tipicamente combinatori:
>
> - la ALU;
> - i multiplexer;
> - il sommatore per `PC + 4`;
> - il sommatore per calcolare indirizzi di salto;
> - l’unità di estensione del segno;
> - la logica di controllo, se vista come combinatoria rispetto all’istruzione corrente.
>
> Questi blocchi non memorizzano dati: producono uscite in base agli ingressi correnti.

---

## 27. Come si collega questo capitolo al datapath di un processore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il datapath di un processore è costruito combinando:
>
> - elementi combinatori, che elaborano i dati;
> - elementi di stato, che memorizzano i dati;
> - segnali di controllo, che decidono quali operazioni eseguire;
> - clock, che sincronizza gli aggiornamenti.
>
> Per esempio, durante l’esecuzione di un’istruzione:
>
> 1. il Program Counter fornisce l’indirizzo dell’istruzione;
> 2. la memoria istruzioni restituisce l’istruzione;
> 3. la logica combinatoria calcola risultati, indirizzi o condizioni;
> 4. al fronte di clock vengono aggiornati registri, memoria o Program Counter.

---

## 28. Perché il Program Counter è un elemento di stato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **Program Counter** è un elemento di stato perché memorizza l’indirizzo dell’istruzione corrente o della prossima istruzione da eseguire.
>
> Il suo valore deve essere conservato tra un ciclo di clock e il successivo.
>
> A ogni ciclo, il PC può essere aggiornato con:
>
> - `PC + 4`, per passare all’istruzione successiva;
> - un indirizzo di salto, nel caso di branch o jump.

---

## 29. Perché la ALU è considerata un elemento combinatorio?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La ALU è considerata combinatoria perché non memorizza dati.
>
> Riceve in ingresso:
>
> - due operandi;
> - un segnale di controllo che indica l’operazione da eseguire.
>
> Produce poi un risultato in uscita.
>
> A parità di ingressi e controllo, il risultato è sempre lo stesso.

---

## 30. Perché il banco registri è un elemento di stato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il banco registri è un elemento di stato perché conserva i valori dei registri della CPU.
>
> Questi valori devono rimanere disponibili tra un’istruzione e l’altra.
>
> Il banco registri può essere letto per fornire operandi alla ALU e può essere scritto per salvare il risultato di un’istruzione.

---

## 31. Cosa succederebbe se gli elementi di stato non fossero sincronizzati dal clock?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il circuito potrebbe comportarsi in modo imprevedibile.
>
> Gli elementi di stato potrebbero aggiornarsi in momenti diversi e la logica combinatoria potrebbe ricevere valori non ancora stabili.
>
> Questo potrebbe causare:
>
> - risultati errati;
> - letture incoerenti;
> - scritture sbagliate;
> - retroazioni indesiderate;
> - impossibilità di prevedere lo stato successivo del processore.

---

## 32. Cosa significa che la metodologia di temporizzazione garantisce valori “validi e stabili”?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Significa che, quando un elemento di stato legge un valore in ingresso, quel valore deve essere già corretto e non deve più cambiare.
>
> La logica combinatoria ha bisogno di un certo tempo per produrre il risultato.
>
> La temporizzazione serve proprio a garantire che il clock arrivi solo dopo che il risultato è diventato stabile.

---

## 33. Perché il clock non può essere arbitrariamente veloce?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il clock non può essere arbitrariamente veloce perché i segnali non si propagano istantaneamente nella logica combinatoria.
>
> Ogni porta logica, multiplexer, ALU o sommatore introduce un ritardo.
>
> Se il clock fosse troppo veloce, il circuito proverebbe a scrivere il risultato prima che esso sia stato calcolato correttamente.
>
> Quindi la frequenza massima del clock dipende dal ritardo del percorso combinatorio più lento.

---

## 34. Cosa si intende per percorso combinatorio tra due elementi di stato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> È il percorso che un dato compie partendo dall’uscita di un elemento di stato, attraversando uno o più blocchi combinatori, fino ad arrivare all’ingresso di un altro elemento di stato.
>
> Esempi:
>
> ```text
> registro → ALU → registro
> ```
>
> oppure:
>
> ```text
> PC → sommatore PC+4 → PC
> ```
>
> Il tempo necessario per attraversare questo percorso influenza la durata minima del ciclo di clock.

---

## 35. In un processore, cosa avviene durante un ciclo di clock?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Durante un ciclo di clock:
>
> 1. gli elementi di stato forniscono i loro valori in uscita;
> 2. la logica combinatoria elabora quei valori;
> 3. vengono prodotti nuovi risultati;
> 4. al fronte attivo successivo, gli elementi di stato vengono aggiornati.
>
> Questo meccanismo permette al processore di eseguire istruzioni in modo ordinato.

---

## 36. Qual è la differenza tra dato e segnale di controllo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **dato** rappresenta un valore da elaborare.
>
> Esempi di dati:
>
> - un operando;
> - un indirizzo;
> - un valore da scrivere in memoria;
> - il contenuto di un registro.
>
> Un **segnale di controllo**, invece, non è un dato da elaborare, ma serve a comandare il comportamento dei blocchi hardware.
>
> Esempio:
>
> - il contenuto di `x11` è un dato;
> - `RegWrite` è un segnale di controllo che decide se scrivere nel banco registri.

---

## 37. Perché nel datapath alcuni collegamenti sono larghi più di 1 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Perché molti dati del processore sono rappresentati da più bit.
>
> In un’architettura a 32 bit, molti segnali dati sono larghi 32 bit, come:
>
> - valori nei registri;
> - risultati della ALU;
> - indirizzi;
> - dati letti o scritti in memoria.
>
> Nel libro, quando una linea rappresenta più bit, può essere disegnata come una linea più spessa.

---

## 38. Perché nel datapath RISC-V molti dati sono larghi 32 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Perché l’architettura considerata è una versione RISC-V a 32 bit.
>
> Questo significa che molti valori elaborati dal processore, come registri, dati e indirizzi, hanno ampiezza di 32 bit.
>
> Non tutti i segnali però sono larghi 32 bit: alcuni segnali di controllo possono essere larghi anche solo 1 bit.

---

## 39. Perché i segnali di controllo sono spesso larghi 1 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I segnali di controllo sono spesso larghi 1 bit perché devono semplicemente indicare se una certa operazione è abilitata oppure no.
>
> Esempi:
>
> - `RegWrite`: scrivere o non scrivere nel banco registri;
> - `MemWrite`: scrivere o non scrivere in memoria;
> - `Branch`: eseguire o non eseguire un branch.
>
> In questi casi bastano due valori possibili: 0 o 1.

---

## 40. Perché alcuni segnali di controllo possono essere larghi più di 1 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Alcuni segnali di controllo devono scegliere tra più di due possibilità.
>
> Per esempio, il controllo della ALU deve indicare operazioni diverse, come:
>
> - somma;
> - sottrazione;
> - AND;
> - OR;
> - confronto.
>
> In questi casi un solo bit non basta, quindi si usano segnali di controllo a più bit.

---

## 41. Come si può collegare il concetto di temporizzazione all’esecuzione di un’istruzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’esecuzione di un’istruzione richiede che diversi valori vengano letti, elaborati e poi eventualmente scritti.
>
> Per esempio, in una istruzione aritmetica:
>
> 1. il banco registri fornisce gli operandi;
> 2. la ALU calcola il risultato;
> 3. il risultato viene scritto nel registro destinazione al fronte di clock.
>
> La temporizzazione assicura che il risultato della ALU sia pronto prima che il registro destinazione venga aggiornato.

---

## 42. Come si può collegare il concetto di temporizzazione al ciclo di aggiornamento del Program Counter?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il Program Counter è un elemento di stato.
>
> Durante un ciclo di clock, il valore corrente del PC viene letto e usato dalla logica combinatoria per calcolare il prossimo valore del PC.
>
> Il prossimo valore può essere:
>
> - `PC + 4`;
> - un indirizzo di branch;
> - un indirizzo di jump.
>
> Al fronte attivo del clock, il nuovo valore viene scritto nel PC.
>
> Quindi l’aggiornamento del PC è un esempio classico di passaggio:
>
> ```text
> elemento di stato → logica combinatoria → elemento di stato
> ```

---

## 43. Perché un circuito combinatorio da solo non basta per implementare un processore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un circuito combinatorio da solo non basta perché un processore deve ricordare lo stato dell’esecuzione.
>
> Deve sapere:
>
> - quale istruzione sta eseguendo;
> - quali valori sono nei registri;
> - quali dati sono in memoria;
> - quale sarà la prossima istruzione.
>
> Un circuito puramente combinatorio non può memorizzare queste informazioni.
>
> Per questo servono elementi di stato sincronizzati dal clock.

---

## 44. Perché un circuito sequenziale può implementare un processore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un circuito sequenziale può implementare un processore perché combina:
>
> - logica combinatoria, che esegue i calcoli;
> - elementi di stato, che memorizzano le informazioni;
> - clock, che coordina gli aggiornamenti.
>
> Questa combinazione permette al processore di eseguire istruzioni in sequenza, aggiornando il proprio stato a ogni ciclo.

---

## 45. Domanda da esame: descrivere il ruolo di logica combinatoria, elementi di stato e clock in un datapath.

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nel datapath, la logica combinatoria elabora i dati e produce risultati in base agli ingressi correnti.
>
> Esempi di logica combinatoria sono:
>
> - ALU;
> - multiplexer;
> - sommatori;
> - estensore del segno.
>
> Gli elementi di stato memorizzano informazioni tra cicli diversi, come:
>
> - Program Counter;
> - registri;
> - memoria.
>
> Il clock sincronizza l’aggiornamento degli elementi di stato.
>
> Durante il ciclo, la logica combinatoria calcola i nuovi valori; al fronte attivo del clock, questi valori vengono salvati.
>
> In questo modo il processore evolve ordinatamente da uno stato al successivo.

---

# Mini-riepilogo

Il processore è fatto da:

- **elementi di stato**, che memorizzano informazioni;
- **logica combinatoria**, che elabora le informazioni;
- **segnali di controllo**, che comandano il datapath;
- **clock**, che stabilisce quando aggiornare gli elementi di stato.

Schema mentale:

```text
stato corrente
   ↓
logica combinatoria
   ↓
prossimo stato
   ↓
aggiornamento al fronte di clock