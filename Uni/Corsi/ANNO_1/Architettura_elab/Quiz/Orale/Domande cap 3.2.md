# 3.2 Somme e sottrazioni

## Metodo di ripasso

Per ripassare questa sezione, concentrati su tre idee fondamentali: come si eseguono somma e sottrazione in binario, quando può verificarsi overflow e perché il software deve decidere come gestirlo. All’orale è importante saper spiegare non solo la regola, ma anche il motivo: l’overflow dipende dalla dimensione finita della parola e dal segno degli operandi.

---

## 1. Come vengono eseguite somma e sottrazione binaria in un calcolatore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La somma binaria in un calcolatore è eseguita in modo simile alla somma manuale in base 10: si parte dal bit meno significativo, cioè da destra, e si procede verso sinistra.
>
> A ogni posizione si sommano i bit degli operandi e l’eventuale riporto proveniente dalla posizione precedente.
>
> Le regole fondamentali sono:
> - 0 + 0 = 0, senza riporto;
> - 0 + 1 = 1, senza riporto;
> - 1 + 1 = 0, con riporto 1;
> - 1 + 1 + 1 = 1, con riporto 1.
>
> La sottrazione può essere eseguita direttamente, ma nei calcolatori viene spesso trasformata in una somma: invece di calcolare `A - B`, si calcola `A + (-B)`.
>
> Nei numeri con segno rappresentati in complemento a 2, il valore negativo di un numero si ottiene invertendo i bit e aggiungendo 1. In questo modo la stessa circuiteria usata per la somma può essere usata anche per la sottrazione.

---

## 2. Che cos’è l’overflow aritmetico?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’overflow aritmetico si verifica quando il risultato di un’operazione non può essere rappresentato con il numero di bit disponibili.
>
> Per esempio, se il calcolatore usa parole da 32 bit, il risultato di una somma o sottrazione deve poter essere contenuto in 32 bit. Se il risultato matematico richiederebbe più bit, il valore ottenuto nei registri non rappresenta correttamente il risultato.
>
> L’overflow dipende quindi dalla dimensione finita della parola usata dal calcolatore.
>
> È importante distinguere tra risultato matematico e risultato rappresentabile: il calcolatore può produrre una configurazione di bit, ma quella configurazione può corrispondere a un valore errato rispetto al risultato atteso.

---

## 3. Quando può verificarsi overflow in una somma tra numeri con segno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nella somma tra numeri con segno, l’overflow può verificarsi solo quando i due operandi hanno lo stesso segno.
>
> I casi principali sono:
>
> - somma di due numeri positivi che produce un risultato negativo;
> - somma di due numeri negativi che produce un risultato positivo.
>
> In questi casi il bit di segno del risultato è incoerente con il segno atteso.
>
> Se invece si sommano un numero positivo e un numero negativo, l’overflow non può verificarsi, perché il risultato sarà in valore assoluto minore o uguale al più grande dei due operandi. Quindi non può richiedere più bit di quelli già necessari per rappresentare gli operandi.

---

## 4. Quali sono le condizioni di overflow per somma e sottrazione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le condizioni di overflow dipendono dal segno degli operandi e dal segno del risultato.
>
> Per la somma:
>
> - `A + B`, con `A >= 0` e `B >= 0`, genera overflow se il risultato è `< 0`;
> - `A + B`, con `A < 0` e `B < 0`, genera overflow se il risultato è `>= 0`.
>
> Per la sottrazione:
>
> - `A - B`, con `A >= 0` e `B < 0`, genera overflow se il risultato è `< 0`;
> - `A - B`, con `A < 0` e `B >= 0`, genera overflow se il risultato è `>= 0`.
>
> In generale, nella sottrazione l’overflow può verificarsi quando gli operandi hanno segno opposto, perché sottrarre un numero equivale a sommare il suo opposto.
>
> Per esempio:
>
> `A - B = A + (-B)`
>
> Quindi, se `A` è positivo e `B` è negativo, si sta sommando un numero positivo con un altro numero positivo. Se il risultato diventa negativo, c’è overflow.

---

## 5. Perché l’overflow non si verifica sommando due operandi di segno opposto?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’overflow non si verifica sommando due operandi di segno opposto perché il risultato è compreso tra i due valori iniziali.
>
> Se si sommano un numero positivo e uno negativo, l’operazione equivale a calcolare una differenza tra valori assoluti. Il risultato non può avere un valore assoluto maggiore del più grande tra i due operandi.
>
> Per questo motivo il risultato sarà sempre rappresentabile con lo stesso numero di bit degli operandi, supponendo che gli operandi stessi fossero rappresentabili.
>
> L’overflow nella somma con segno è quindi possibile solo quando entrambi gli operandi sono positivi oppure entrambi sono negativi.

---

## 6. Come si riconosce l’overflow osservando il bit di segno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei numeri con segno in complemento a 2, il bit più significativo rappresenta il segno:
>
> - 0 indica un numero positivo o nullo;
> - 1 indica un numero negativo.
>
> L’overflow può essere riconosciuto quando il bit di segno del risultato è incompatibile con il risultato atteso.
>
> Per esempio:
>
> - positivo + positivo dovrebbe dare un risultato positivo;
> - se invece il risultato ha bit di segno 1, allora appare negativo e c’è overflow;
> - negativo + negativo dovrebbe dare un risultato negativo;
> - se invece il risultato ha bit di segno 0, allora appare positivo e c’è overflow.
>
> Quindi, in caso di overflow, il bit di segno non rappresenta più correttamente il segno del risultato matematico.

---

## 7. Qual è la differenza tra overflow nei numeri con segno e nei numeri senza segno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei numeri con segno, l’overflow si interpreta guardando la coerenza tra il segno degli operandi e il segno del risultato.
>
> Nei numeri senza segno, invece, non esiste un bit di segno. Tutti i bit rappresentano il valore numerico.
>
> Per i numeri senza segno, una somma genera overflow quando il risultato è troppo grande per essere rappresentato con il numero di bit disponibili.
>
> Una sottrazione tra numeri senza segno genera overflow quando il minuendo è minore del sottraendo, cioè quando il risultato matematico sarebbe negativo, ma i numeri senza segno non possono rappresentare valori negativi.
>
> Per esempio, con numeri senza segno:
>
> - `7 + 1` può generare overflow se non ci sono abbastanza bit per rappresentare 8;
> - `3 - 5` genera overflow perché il risultato sarebbe `-2`, non rappresentabile come numero senza segno.

---

## 8. Come viene gestito l’overflow dal punto di vista hardware/software?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il progettista dell’architettura deve decidere se e come l’overflow aritmetico viene segnalato al software.
>
> Alcune architetture generano un’eccezione quando si verifica overflow; altre invece lasciano che il programma continui e affidano al programmatore il compito di controllare il risultato.
>
> In linguaggi come C e Java, l’overflow dei numeri interi spesso non viene segnalato automaticamente nello stesso modo: il comportamento può dipendere dal linguaggio, dal tipo di dato e dall’ambiente di esecuzione.
>
> In generale, il software deve sapere se l’operazione aritmetica può produrre un valore fuori dall’intervallo rappresentabile e deve decidere come gestire il caso di overflow.

---

## 9. Qual è il ruolo dell’ALU nelle somme e sottrazioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’ALU, cioè Arithmetic-Logic Unit, è l’unità aritmetico-logica del processore.
>
> Essa esegue operazioni aritmetiche come addizione e sottrazione, ma anche operazioni logiche come AND e OR.
>
> Per la sottrazione, l’ALU può sfruttare la stessa struttura usata per la somma, trasformando la sottrazione in una somma con l’opposto del sottraendo.
>
> Per esempio:
>
> `A - B = A + (-B)`
>
> Nei numeri in complemento a 2, questa trasformazione è particolarmente efficiente perché il negativo di un numero può essere ottenuto invertendo i bit e aggiungendo 1.
>
> Questo permette di semplificare l’hardware: invece di avere circuiti completamente separati per somma e sottrazione, si può usare un’unica struttura aritmetica.

---

## 10. Che cos’è la saturazione e in cosa differisce dall’overflow tradizionale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La saturazione è una tecnica usata in alcune operazioni aritmetiche per evitare che, in caso di overflow, il risultato “riparta” da un valore errato.
>
> Con l’aritmetica tradizionale, se il risultato supera il massimo rappresentabile, i bit in eccesso vengono persi e il valore ottenuto può apparire completamente diverso da quello matematico.
>
> Con l’aritmetica con saturazione, invece, se il risultato supera il massimo rappresentabile, viene fissato al valore massimo. Se scende sotto il minimo rappresentabile, viene fissato al valore minimo.
>
> Per esempio, in applicazioni multimediali come audio e video, la saturazione è utile perché evita comportamenti visibili o udibili troppo anomali. Se il volume supera il massimo, viene semplicemente mantenuto al massimo invece di tornare improvvisamente a un valore basso.
>
> La saturazione non è tipica delle istruzioni aritmetiche generali dei microprocessori, ma può comparire in istruzioni specializzate, soprattutto per elaborazioni multimediali.

---

## 11. Perché l’anticipazione di riporto rende più veloce l’addizione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una somma binaria, ogni bit può produrre un riporto verso il bit successivo. Il problema è che, in un sommatore semplice, il calcolo di un bit può dipendere dal riporto generato dal bit precedente.
>
> Questo può rallentare l’operazione, perché nel caso peggiore il riporto deve propagarsi attraverso molti bit.
>
> L’anticipazione di riporto, chiamata anche carry lookahead, serve a velocizzare l’addizione prevedendo in anticipo quali riporti verranno generati.
>
> Invece di aspettare che il riporto si propaghi bit dopo bit, il circuito calcola più rapidamente i riporti necessari usando logica combinatoria aggiuntiva.
>
> Il vantaggio è una somma più veloce; lo svantaggio è che l’hardware diventa più complesso.

---

## 12. Qual è il concetto principale da ricordare su somme, sottrazioni e overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il concetto principale è che le operazioni aritmetiche nei calcolatori sono limitate dalla dimensione finita della parola.
>
> Anche se matematicamente una somma o una sottrazione ha sempre un risultato, il calcolatore può rappresentare solo un intervallo finito di valori.
>
> Quando il risultato esce da questo intervallo, si verifica overflow.
>
> Per i numeri con segno, l’overflow si riconosce soprattutto osservando il segno degli operandi e il segno del risultato.
>
> Per i numeri senza segno, l’overflow riguarda invece il superamento dell’intervallo rappresentabile.
>
> In ogni caso, l’hardware può eventualmente segnalare l’overflow, ma il software deve decidere come gestirlo.