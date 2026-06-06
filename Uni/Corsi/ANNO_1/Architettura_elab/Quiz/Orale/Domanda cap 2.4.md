
# 2.4 Numeri con e senza segno

## Metodo di ripasso

Per ripassare questa sezione concentrati su tre idee principali:  
1. capire come un numero binario viene interpretato tramite il peso posizionale dei bit;  
2. distinguere numeri **unsigned** e numeri **signed**;  
3. saper spiegare perché il complemento a 2 è la rappresentazione più usata per i numeri con segno.

Quando ripassi, prova sempre a fare un esempio numerico piccolo, perché all’orale spesso è più convincente mostrare il ragionamento su pochi bit invece che recitare solo la definizione.

---

## 1. Come vengono rappresentati i numeri binari e qual è il ruolo della base?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I numeri possono essere rappresentati in qualunque base. Nei calcolatori digitali si usa la **base 2**, perché l’hardware lavora naturalmente con due soli stati elettrici, che vengono interpretati come **0** e **1**.
>
> Una cifra binaria prende il nome di **bit**. Ogni bit ha un peso che dipende dalla sua posizione: il valore della cifra in posizione `i` è:
>
> `cifra × base^i`
>
> Nel caso binario, la base è 2. Quindi un numero binario si interpreta come somma di potenze di 2.
>
> Esempio:
>
> `1011₂ = 1×2³ + 0×2² + 1×2¹ + 1×2⁰`
>
> quindi:
>
> `1011₂ = 8 + 0 + 2 + 1 = 11₁₀`
>
> I bit si numerano da destra verso sinistra: il bit più a destra ha posizione 0, poi 1, 2, 3 e così via.

---

## 2. Cosa si intende per bit meno significativo e bit più significativo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **bit meno significativo**, o **least significant bit** `LSB`, è il bit più a destra di una parola binaria.
>
> È detto “meno significativo” perché ha il peso minore, cioè `2⁰`.
>
> Il **bit più significativo**, o **most significant bit** `MSB`, è invece il bit più a sinistra.
>
> In una parola RISC-V da 32 bit:
>
> - il bit 0 è il bit meno significativo;
> - il bit 31 è il bit più significativo.
>
> Il bit più significativo è importante perché, nei numeri con segno rappresentati in complemento a 2, indica anche se il numero è positivo o negativo.

---

## 3. Che cosa sono i numeri unsigned e quale intervallo rappresentano su 32 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I numeri **unsigned**, cioè senza segno, sono numeri binari interpretati solo come quantità non negative.
>
> In una parola da 32 bit ci sono `2³²` combinazioni possibili. Se tutte queste combinazioni vengono usate per rappresentare numeri senza segno, l’intervallo rappresentabile è:
>
> `0` fino a `2³² - 1`
>
> cioè:
>
> `0` fino a `4 294 967 295`
>
> La formula generale per interpretare un numero unsigned a 32 bit è:
>
> `x₃₁×2³¹ + x₃₀×2³⁰ + ... + x₁×2¹ + x₀×2⁰`
>
> dove ogni `xᵢ` vale 0 oppure 1.
>
> Quindi nei numeri unsigned tutti i bit contribuiscono positivamente al valore del numero.

---

## 4. Che cos’è un overflow e perché può verificarsi nei calcolatori?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Si verifica un **overflow** quando il risultato di un’operazione non può essere rappresentato con il numero di bit disponibili.
>
> Il motivo è che una parola di memoria o un registro ha dimensione finita. Per esempio, con 32 bit si possono rappresentare solo `2³²` combinazioni.
>
> Se un’operazione produce un risultato fuori dall’intervallo rappresentabile, il calcolatore non può memorizzarlo correttamente.
>
> Per esempio, con numeri unsigned a 32 bit il massimo valore rappresentabile è:
>
> `4 294 967 295`
>
> Se si prova a rappresentare un valore maggiore, il risultato eccede la capacità del registro e si ha overflow.
>
> L’overflow dipende quindi sia dal numero di bit disponibili sia dal tipo di interpretazione usata: unsigned oppure con segno.

---

## 5. Perché serve rappresentare anche numeri con segno e quali problemi ha la rappresentazione in modulo e segno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I programmi non lavorano solo con quantità positive: spesso servono anche numeri negativi. Per questo è necessario avere una rappresentazione dei numeri **signed**, cioè con segno.
>
> Una prima idea è la rappresentazione in **modulo e segno**:
>
> - un bit rappresenta il segno;
> - gli altri bit rappresentano il valore assoluto del numero.
>
> Per esempio, il bit più significativo può indicare il segno:
>
> - `0` per positivo;
> - `1` per negativo.
>
> Questa rappresentazione però ha vari problemi:
>
> - esistono due rappresentazioni dello zero, cioè `+0` e `-0`;
> - le operazioni aritmetiche diventano più complicate;
> - il calcolatore deve trattare separatamente il segno e il valore assoluto.
>
> Per questi motivi la rappresentazione in modulo e segno è stata abbandonata nella maggior parte dei calcolatori.

---

## 6. Che cos’è il complemento a 2 e perché è la rappresentazione più usata per i numeri con segno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **complemento a 2** è la rappresentazione più usata per i numeri interi con segno.
>
> In questa rappresentazione, il bit più significativo ha peso negativo, mentre tutti gli altri bit mantengono il loro peso positivo.
>
> Su 32 bit, il valore di una parola in complemento a 2 è:
>
> `x₃₁×(-2³¹) + x₃₀×2³⁰ + x₂₉×2²⁹ + ... + x₁×2¹ + x₀×2⁰`
>
> Il bit più significativo viene spesso chiamato **bit di segno**:
>
> - se vale `0`, il numero è non negativo;
> - se vale `1`, il numero è negativo.
>
> Il complemento a 2 è molto usato perché permette di eseguire somme e sottrazioni con gli stessi circuiti usati per i numeri senza segno. Inoltre ha una sola rappresentazione dello zero, evitando il problema del doppio zero presente nel modulo e segno.

---

## 7. Qual è l’intervallo dei numeri rappresentabili in complemento a 2 su 32 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Con 32 bit in complemento a 2 si rappresentano `2³²` combinazioni totali, ma divise tra numeri negativi, zero e numeri positivi.
>
> L’intervallo rappresentabile è:
>
> `-2³¹` fino a `2³¹ - 1`
>
> cioè:
>
> `-2 147 483 648` fino a `2 147 483 647`
>
> La parte positiva va da:
>
> `0` a `2 147 483 647`
>
> La parte negativa va da:
>
> `-2 147 483 648` a `-1`
>
> L’intervallo non è simmetrico: esiste un numero negativo in più rispetto ai positivi. Questo accade perché lo zero occupa una delle combinazioni con bit di segno 0.

---

## 8. Come si cambia segno a un numero rappresentato in complemento a 2?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per cambiare segno a un numero in complemento a 2 si usa una scorciatoia molto importante:
>
> 1. si invertono tutti i bit;
> 2. si somma 1 al risultato.
>
> Questa procedura permette di ottenere l’opposto del numero.
>
> Esempio su 32 bit: partendo da `2₁₀`
>
> `00000000 00000000 00000000 00000010`
>
> invertendo i bit si ottiene:
>
> `11111111 11111111 11111111 11111101`
>
> sommando 1:
>
> `11111111 11111111 11111111 11111110`
>
> Questo rappresenta `-2₁₀` in complemento a 2.
>
> La stessa procedura funziona anche al contrario: applicandola a `-2`, si torna a `+2`.

---

## 9. Come si converte un numero binario in complemento a 2 in decimale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per convertire un numero in complemento a 2 in decimale bisogna ricordare che il bit più significativo ha peso negativo.
>
> Su 32 bit, il peso del bit più significativo è:
>
> `-2³¹`
>
> mentre gli altri bit hanno i pesi positivi normali:
>
> `2³⁰, 2²⁹, ..., 2¹, 2⁰`
>
> Esempio:
>
> `11111111 11111111 11111111 11111100`
>
> Il bit più significativo vale 1, quindi il numero è negativo.
>
> Applicando la formula:
>
> `-2³¹ + 2³⁰ + 2²⁹ + ... + 2²`
>
> Il risultato è:
>
> `-4`
>
> Quindi:
>
> `11111111 11111111 11111111 11111100₂ = -4₁₀`
>
> In pratica, per numeri negativi può essere più rapido cambiare segno con la regola “inverti i bit e somma 1”, calcolare il valore positivo ottenuto e poi mettere il segno meno.

---

## 10. Come si riconosce l’overflow nelle operazioni in complemento a 2?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In complemento a 2 l’overflow si verifica quando il risultato di un’operazione supera l’intervallo rappresentabile.
>
> Nel caso della somma, una regola utile è:
>
> - se si sommano due numeri positivi e il risultato appare negativo, c’è overflow;
> - se si sommano due numeri negativi e il risultato appare positivo, c’è overflow;
> - se gli operandi hanno segno diverso, la somma non genera overflow di questo tipo.
>
> In termini di bit, il testo evidenzia che l’overflow si riconosce quando il bit più a sinistra del risultato non è coerente con gli infiniti bit di segno che sarebbero presenti nella rappresentazione ideale del numero.
>
> Questo accade perché in un registro reale il numero di bit è limitato, quindi il risultato può “uscire” dall’intervallo rappresentabile.

---

## 11. Che cos’è l’estensione del segno e perché è necessaria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’**estensione del segno** serve per convertire un numero rappresentato con meno bit in una rappresentazione con più bit, mantenendo lo stesso valore.
>
> La regola è:
>
> - si prende il bit più significativo della rappresentazione originale;
> - lo si copia nelle nuove posizioni aggiunte a sinistra.
>
> Se il numero è positivo, il bit di segno è `0`, quindi si aggiungono zeri.
>
> Se il numero è negativo, il bit di segno è `1`, quindi si aggiungono uni.
>
> Esempio: `2` su 16 bit è:
>
> `00000000 00000010`
>
> Esteso a 32 bit diventa:
>
> `00000000 00000000 00000000 00000010`
>
> Invece `-2` su 16 bit è:
>
> `11111111 11111110`
>
> Esteso a 32 bit diventa:
>
> `11111111 11111111 11111111 11111110`
>
> L’estensione del segno funziona perché i numeri positivi hanno infiniti zeri a sinistra, mentre i negativi in complemento a 2 hanno infiniti uni a sinistra.

---

## 12. Qual è la differenza tra istruzioni RISC-V per caricare byte con segno e senza segno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In RISC-V esistono istruzioni diverse per caricare valori con segno e senza segno dalla memoria.
>
> Quando si carica un valore più piccolo della parola del registro, per esempio un byte, bisogna decidere come riempire i bit più a sinistra.
>
> L’istruzione:
>
> `lb`
>
> cioè **load byte**, interpreta il byte come numero con segno. Quindi copia il bit più significativo del byte nei bit superiori del registro: fa estensione del segno.
>
> L’istruzione:
>
> `lbu`
>
> cioè **load byte unsigned**, interpreta il byte come numero senza segno. Quindi riempie i bit superiori con zeri.
>
> La differenza è importante perché lo stesso byte può rappresentare valori diversi se interpretato come signed o unsigned.
>
> In genere, `lbu` è usata spesso per caricare caratteri, perché i caratteri non sono numeri negativi.

---

## 13. Perché nei linguaggi di programmazione esistono tipi signed e unsigned?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei linguaggi di programmazione si distingue tra numeri **signed** e **unsigned** perché lo stesso insieme di bit può essere interpretato in modi diversi.
>
> Un intero signed può rappresentare sia numeri positivi sia numeri negativi.
>
> Un intero unsigned rappresenta solo numeri non negativi, ma può arrivare a un massimo positivo più grande.
>
> Per esempio, su 32 bit:
>
> - un unsigned va da `0` a `4 294 967 295`;
> - un signed in complemento a 2 va da `-2 147 483 648` a `2 147 483 647`.
>
> Alcuni linguaggi, come C, distinguono esplicitamente tra `int` e `unsigned int`. Tuttavia questa distinzione può creare confusione, soprattutto quando si confrontano o combinano numeri signed e unsigned.
>
> Per questo in molti casi conviene usare numeri con segno, a meno che non serva esplicitamente rappresentare solo quantità non negative.

---

## 14. Che cos’è il complemento a 1 e perché è meno usato del complemento a 2?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **complemento a 1** è un’altra rappresentazione dei numeri con segno.
>
> In questa rappresentazione, un numero negativo si ottiene invertendo tutti i bit del corrispondente numero positivo.
>
> Per esempio, se il positivo è:
>
> `000...0010`
>
> il negativo corrispondente in complemento a 1 è:
>
> `111...1101`
>
> Il problema principale è che anche il complemento a 1 ha due rappresentazioni dello zero:
>
> - `000...0000` per `+0`;
> - `111...1111` per `-0`.
>
> Inoltre le operazioni aritmetiche sono meno semplici rispetto al complemento a 2.
>
> Per questo il complemento a 1 è stato storicamente usato in alcuni calcolatori, ma oggi il complemento a 2 è la rappresentazione dominante.

---

## 15. Che cos’è la notazione polarizzata e a cosa serve?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La **notazione polarizzata** è una rappresentazione alternativa dei numeri con segno.
>
> Invece di usare direttamente un bit di segno o il complemento a 2, si sceglie una costante detta **polarizzazione** o **bias**.
>
> Il valore reale si ottiene sottraendo questa polarizzazione dal valore rappresentato dai bit.
>
> Per esempio, se la polarizzazione è `127`, una certa configurazione di bit viene interpretata come:
>
> `valore unsigned - 127`
>
> Questa rappresentazione è utile soprattutto nei numeri in virgola mobile, in particolare per rappresentare gli esponenti.
>
> L’idea è che, scegliendo opportunamente il bias, si possono rappresentare sia esponenti positivi sia esponenti negativi usando una codifica che, a livello di bit, assomiglia a un numero unsigned.