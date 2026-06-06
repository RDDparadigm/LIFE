
# ALU a 1 bit e ALU a 4 bit: AND, OR, ADD, SUB, SLT e Overflow

## Metodo di ripasso

Ripassa queste flashcard concentrandoti sul collegamento tra **circuito** e **spiegazione orale**.  
Per ogni domanda prova prima a rispondere senza guardare il callout, poi verifica se sai spiegare:

- quale segnale entra;
- quale blocco logico lo usa;
- quale uscita produce;
- perché serve nella ALU.

---

## 1. Qual è l’idea generale di una ALU a 1 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una ALU a 1 bit riceve due bit `a` e `b` e può eseguire diverse operazioni logiche o aritmetiche su quei bit.
>
> Le operazioni principali sono:
>
> ```text
> 00 → AND
> 01 → OR
> 10 → ADD/SUB
> 11 → LESS
> ```
>
> Internamente la ALU calcola più risultati in parallelo:
>
> ```text
> a AND b
> a OR b
> a + b + CarryIn
> Less
> ```
>
> Poi un multiplexer seleziona quale risultato mandare in uscita in base al segnale `Operation`.
>
> Frase da orale:
>
> > In una ALU le operazioni vengono calcolate in parallelo, e il segnale `Operation` seleziona tramite multiplexer quale risultato rendere disponibile in uscita.

---

## 2. A cosa serve il segnale `Operation` nella ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `Operation` serve a scegliere quale risultato deve uscire dalla ALU.
>
> Nella ALU a 1 bit viene usato come segnale di selezione del multiplexer.
>
> Tipicamente:
>
> ```text
> Operation = 00 → Result = a AND b
> Operation = 01 → Result = a OR b
> Operation = 10 → Result = somma/sottrazione
> Operation = 11 → Result = Less
> ```
>
> Quindi le porte logiche e il sommatore lavorano in parallelo, ma solo uno dei risultati viene scelto come uscita finale.

---

## 3. Perché nella ALU si usano `Ainvert` e `Binvert`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `Ainvert` e `Binvert` servono per decidere se usare gli ingressi originali `a` e `b` oppure i loro complementi.
>
> Si possono implementare con porte XOR:
>
> ```text
> a_eff = a XOR Ainvert
> b_eff = b XOR Binvert
> ```
>
> Questo funziona perché:
>
> ```text
> a XOR 0 = a
> a XOR 1 = NOT a
> ```
>
> Quindi:
>
> ```text
> Ainvert = 0 → uso a normale
> Ainvert = 1 → uso NOT a
> ```
>
> Lo stesso vale per `Binvert`.
>
> Frase da orale:
>
> > Gli ingressi `Ainvert` e `Binvert` permettono di scegliere se operare sui bit originali o sui loro complementi. Li implemento con XOR perché fare XOR con 0 lascia il bit invariato, mentre fare XOR con 1 lo inverte.

---

## 4. Come si realizza la sottrazione usando la stessa ALU che fa la somma?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La ALU non ha bisogno di un sottrattore separato. Per fare la sottrazione usa il full adder e il complemento a due.
>
> La sottrazione si riscrive così:
>
> ```text
> A - B = A + NOT(B) + 1
> ```
>
> Quindi per eseguire una sottrazione bisogna impostare:
>
> ```text
> Ainvert = 0
> Binvert = 1
> CarryIn iniziale = 1
> Operation = 10
> ```
>
> `Binvert = 1` trasforma `B` in `NOT(B)`.
>
> Il `CarryIn` iniziale a 1 aggiunge il `+1` necessario per il complemento a due.
>
> Frase da orale:
>
> > La sottrazione viene realizzata come somma in complemento a due: `A - B = A + NOT(B) + 1`. Per questo imposto `Binvert = 1` e il carry iniziale a 1.

---

## 5. Che ruolo ha il `CarryIn` nella ALU a più bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il `CarryIn` è il riporto che entra in una cella della ALU.
>
> In una ALU a più bit, ogni cella a 1 bit produce un `CarryOut`, che diventa il `CarryIn` della cella successiva.
>
> Quindi:
>
> ```text
> CarryOut bit 0 → CarryIn bit 1
> CarryOut bit 1 → CarryIn bit 2
> CarryOut bit 2 → CarryIn bit 3
> ```
>
> Nel caso della somma normale, il `CarryIn` iniziale del bit meno significativo è 0.
>
> Nel caso della sottrazione, invece, il `CarryIn` iniziale è 1, perché serve a realizzare:
>
> ```text
> A - B = A + NOT(B) + 1
> ```

---

## 6. Che cos’è il segnale `Less` nella ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `Less` è il quarto possibile ingresso del multiplexer della ALU a 1 bit.
>
> Serve per implementare l’operazione `set less than`, cioè:
>
> ```text
> slt(A, B) = 0001 se A < B
> slt(A, B) = 0000 se A >= B
> ```
>
> Quando:
>
> ```text
> Operation = 11
> ```
>
> il multiplexer della ALU seleziona il valore `Less`.
>
> Il punto importante è che `Less` non viene calcolato da ogni singolo bit. Il valore corretto viene prodotto dall’MSB tramite il segnale `Set` e poi riportato al bit meno significativo.

---

## 7. Che cosa produce l’operazione `set less than`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’operazione `set less than` non produce il risultato della sottrazione.
>
> Produce un valore booleano:
>
> ```text
> 0001 se A < B
> 0000 se A >= B
> ```
>
> Per esempio:
>
> ```text
> A = 3
> B = 5
> ```
>
> Siccome:
>
> ```text
> 3 < 5
> ```
>
> allora:
>
> ```text
> slt(A, B) = 0001
> ```
>
> Anche se internamente la ALU calcola:
>
> ```text
> A - B = 3 - 5 = -2
> ```
>
> il risultato finale dell’operazione `slt` non è `-2`, ma solo `0001`.
>
> Frase da orale:
>
> > L’operazione `set less than` non restituisce il risultato della sottrazione, ma un valore booleano: `0001` se `A < B`, altrimenti `0000`.

---

## 8. Come fa la ALU a capire se `A < B`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per capire se:
>
> ```text
> A < B
> ```
>
> la ALU calcola internamente:
>
> ```text
> A - B
> ```
>
> perché:
>
> ```text
> A < B ⇔ A - B < 0
> ```
>
> Se il risultato della sottrazione è negativo, allora `A` è minore di `B`.
>
> Nei numeri signed in complemento a due, il segno del risultato si trova nell’MSB.
>
> Quindi la ALU dell’MSB produce un segnale chiamato `Set`, che indica se il risultato della sottrazione deve essere interpretato come negativo.
>
> Frase da orale:
>
> > Per implementare `set less than`, la ALU calcola internamente `A - B`. Se il risultato è negativo, allora `A < B`. Questa informazione viene presa dall’MSB, cioè dal bit di segno.

---

## 9. Perché serve una ALU diversa per l’MSB?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una ALU a più bit, quasi tutte le celle a 1 bit sono uguali.
>
> Però la cella dell’MSB, cioè del bit più significativo, deve produrre informazioni aggiuntive.
>
> Le celle normali producono:
>
> ```text
> Result
> CarryOut
> ```
>
> La cella MSB produce anche:
>
> ```text
> Set
> Overflow
> ```
>
> Questo perché l’MSB è il bit di segno nei numeri signed in complemento a due.
>
> In una ALU a 4 bit, la struttura è:
>
> ```text
> bit 0 → ALU_1bit_v1
> bit 1 → ALU_1bit_v1
> bit 2 → ALU_1bit_v1
> bit 3 → ALU_1bit_v2, cioè MSB
> ```
>
> Frase da orale:
>
> > L’ultima cella della ALU, cioè quella dell’MSB, è speciale perché deve produrre il segnale `Set`, usato per `slt`, e il segnale `Overflow`, usato per rilevare errori nelle operazioni signed.

---

## 10. Come va collegato il segnale `Set` per implementare `slt`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il collegamento fondamentale è:
>
> ```text
> Set dell’MSB → Less del bit 0
> ```
>
> Gli altri ingressi `Less` devono essere collegati a zero:
>
> ```text
> Less bit 0 = Set dell’MSB
> Less bit 1 = 0
> Less bit 2 = 0
> Less bit 3 = 0
> ```
>
> Quando:
>
> ```text
> Operation = 11
> ```
>
> ogni multiplexer seleziona il proprio ingresso `Less`.
>
> Quindi il risultato finale diventa:
>
> ```text
> Result[0] = Set
> Result[1] = 0
> Result[2] = 0
> Result[3] = 0
> ```
>
> Perciò:
>
> ```text
> se Set = 1 → Result = 0001
> se Set = 0 → Result = 0000
> ```
>
> Frase da orale:
>
> > Il segnale `Set` prodotto dall’MSB viene riportato all’ingresso `Less` del bit meno significativo. Quando `Operation = 11`, tutti i multiplexer selezionano `Less`, quindi il risultato finale è `0001` se `A < B`, altrimenti `0000`.

---

## 11. Che cos’è l’overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’overflow segnala che il risultato di una somma o sottrazione signed non è rappresentabile con il numero di bit disponibili.
>
> Per esempio, con 4 bit signed in complemento a due si può rappresentare:
>
> ```text
> da -8 a +7
> ```
>
> Se faccio:
>
> ```text
> 3 - (-5) = 8
> ```
>
> il risultato matematico è 8, ma 8 non è rappresentabile su 4 bit signed.
>
> La ALU produce comunque una sequenza di bit, ma quella sequenza non rappresenta il valore matematico corretto.
>
> Questo caso si chiama overflow.
>
> Frase da orale:
>
> > L’overflow segnala che il risultato di una somma o sottrazione signed è fuori dal range rappresentabile con i bit disponibili.

---

## 12. Come si calcola l’overflow nella ALU MSB?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’overflow signed si calcola guardando il carry che entra e il carry che esce dall’MSB.
>
> La formula è:
>
> ```text
> Overflow = CarryIn_MSB XOR CarryOut_MSB
> ```
>
> Tabella:
>
> ```text
> CarryIn_MSB CarryOut_MSB | Overflow
>      0           0       |    0
>      1           1       |    0
>      0           1       |    1
>      1           0       |    1
> ```
>
> Quindi c’è overflow quando il carry che entra nel bit di segno è diverso dal carry che esce dal bit di segno.
>
> Attenzione:
>
> ```text
> Overflow ≠ CarryOut
> ```
>
> Il `CarryOut` può essere 1 anche quando non c’è overflow.
>
> Frase da orale:
>
> > L’overflow non coincide con il CarryOut. Per i numeri signed in complemento a due, l’overflow si rileva confrontando il carry che entra nell’MSB con il carry che esce dall’MSB. Se sono diversi, c’è overflow.

---

## 13. Perché `Set = Sum_MSB` non basta sempre?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nella versione semplice si potrebbe pensare:
>
> ```text
> Set = Sum_MSB
> ```
>
> cioè uso il bit di segno della sottrazione `A - B`.
>
> Però questo non basta quando la sottrazione genera overflow.
>
> In caso di overflow, il bit di segno può essere falsato.
>
> Esempio su 4 bit:
>
> ```text
> A = 0011 = 3
> B = 1011 = -5
> ```
>
> L’operazione `slt` chiede:
>
> ```text
> 3 < -5 ?
> ```
>
> La risposta corretta è falso, quindi:
>
> ```text
> Result = 0000
> ```
>
> Però internamente la ALU calcola:
>
> ```text
> A - B = 3 - (-5) = 8
> ```
>
> Ma 8 non è rappresentabile su 4 bit signed.
>
> La ALU produce un risultato con MSB uguale a 1, quindi se usassi solo:
>
> ```text
> Set = Sum_MSB
> ```
>
> otterrei erroneamente:
>
> ```text
> Set = 1
> Result = 0001
> ```
>
> cioè direi che `3 < -5`, ma è falso.
>
> Per correggere questo problema, il `Set` signed corretto è:
>
> ```text
> Set = Sum_MSB XOR Overflow
> ```

---

## 14. Perché per `slt` signed si usa `Set = Sum_MSB XOR Overflow`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per `slt`, la ALU calcola internamente:
>
> ```text
> A - B
> ```
>
> Se il risultato è negativo, allora `A < B`.
>
> Il segno della sottrazione si trova in:
>
> ```text
> Sum_MSB
> ```
>
> Però se c’è overflow, il segno è sbagliato.
>
> Per questo si corregge il segno con:
>
> ```text
> Set = Sum_MSB XOR Overflow
> ```
>
> Se non c’è overflow:
>
> ```text
> Overflow = 0
> Set = Sum_MSB XOR 0 = Sum_MSB
> ```
>
> quindi si usa normalmente il bit di segno.
>
> Se c’è overflow:
>
> ```text
> Overflow = 1
> Set = Sum_MSB XOR 1 = NOT Sum_MSB
> ```
>
> quindi il bit di segno viene invertito, correggendo il risultato.
>
> Frase da orale:
>
> > Per lo `slt` signed completo, il solo bit di segno della sottrazione non basta, perché in caso di overflow il segno può essere falsato. Per questo il segnale `Set` corretto si ottiene come `Sum_MSB XOR Overflow`.

---

## 15. Quali segnali bisogna impostare per fare `set less than`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per fare `set less than`, la ALU deve calcolare internamente:
>
> ```text
> A - B
> ```
>
> ma deve mostrare in uscita il risultato dell’ingresso `Less`.
>
> Quindi si imposta:
>
> ```text
> Ainvert = 0
> Binvert = 1
> CarryIn iniziale = 1
> Operation = 11
> ```
>
> Perché:
>
> ```text
> Binvert = 1 → B diventa NOT(B)
> CarryIn = 1 → aggiunge il +1 del complemento a due
> Operation = 11 → il mux seleziona Less
> ```
>
> La parte aritmetica calcola comunque `A - B`, così l’MSB può produrre il segnale `Set`.
>
> Poi:
>
> ```text
> Set dell’MSB → Less del bit 0
> Less degli altri bit → 0
> ```
>
> Risultato:
>
> ```text
> 0001 se A < B
> 0000 se A >= B
> ```

---

## 16. Che cosa deve succedere nel caso `A = 3`, `B = 5`, operazione `slt`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Su 4 bit:
>
> ```text
> A = 0011 = 3
> B = 0101 = 5
> ```
>
> L’operazione `slt` chiede:
>
> ```text
> 3 < 5 ?
> ```
>
> La risposta è vera.
>
> La ALU calcola internamente:
>
> ```text
> A - B = 3 - 5 = -2
> ```
>
> Su 4 bit:
>
> ```text
> -2 = 1110
> ```
>
> Il bit di segno è 1 e non c’è overflow.
>
> Quindi:
>
> ```text
> Set = 1
> Result = 0001
> ```
>
> Questo è corretto perché `3 < 5`.

---

## 17. Che cosa deve succedere nel caso `A = 3`, `B = -5`, operazione `slt`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Su 4 bit:
>
> ```text
> A = 0011 = 3
> B = 1011 = -5
> ```
>
> L’operazione `slt` chiede:
>
> ```text
> 3 < -5 ?
> ```
>
> La risposta è falsa.
>
> Quindi il risultato corretto è:
>
> ```text
> Result = 0000
> ```
>
> Internamente la ALU calcola:
>
> ```text
> A - B = 3 - (-5) = 8
> ```
>
> Ma 8 non è rappresentabile su 4 bit signed.
>
> Quindi c’è overflow.
>
> La sottrazione produce un bit di segno che sembrerebbe negativo, ma è un segno falsato dall’overflow.
>
> Per questo si deve usare:
>
> ```text
> Set = Sum_MSB XOR Overflow
> ```
>
> In questo caso il `Set` corretto diventa 0, quindi:
>
> ```text
> Result = 0000
> ```
>
> cioè correttamente `3 < -5` è falso.

---

## 18. Che cosa deve succedere nel caso `A = -5`, `B = 5`, operazione `slt`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Su 4 bit:
>
> ```text
> A = 1011 = -5
> B = 0101 = 5
> ```
>
> L’operazione `slt` chiede:
>
> ```text
> -5 < 5 ?
> ```
>
> La risposta è vera.
>
> Quindi il risultato corretto è:
>
> ```text
> Result = 0001
> ```
>
> Internamente la ALU calcola:
>
> ```text
> A - B = -5 - 5 = -10
> ```
>
> Ma -10 non è rappresentabile su 4 bit signed.
>
> Quindi c’è overflow.
>
> In questo caso il bit di segno prodotto dalla sottrazione può risultare positivo, ma è un segno falsato.
>
> Per correggere il `Set` si usa:
>
> ```text
> Set = Sum_MSB XOR Overflow
> ```
>
> Il `Set` corretto diventa 1, quindi:
>
> ```text
> Result = 0001
> ```
>
> cioè correttamente `-5 < 5` è vero.

---

## 19. Come si può spiegare tutto il funzionamento dello `slt` all’orale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una spiegazione completa potrebbe essere:
>
> > Nella ALU a 4 bit, l’operazione `set less than` viene realizzata eseguendo internamente la sottrazione `A - B`. Se il risultato è negativo, allora `A < B`.
> >
> > Questa informazione viene prodotta dall’MSB tramite il segnale `Set`.
> >
> > Il segnale `Set` viene poi riportato all’ingresso `Less` del bit meno significativo, mentre i `Less` degli altri bit sono collegati a zero.
> >
> > Quando `Operation = 11`, i multiplexer delle celle selezionano `Less`, quindi il risultato finale è `0001` se `A < B`, altrimenti `0000`.
> >
> > Per i numeri signed, il `Set` corretto non è sempre solo il bit di segno della sottrazione, perché in caso di overflow il segno può essere falsato.
> >
> > Per questo si calcola `Overflow = CarryIn_MSB XOR CarryOut_MSB` e poi `Set = Sum_MSB XOR Overflow`.

---

## 20. Quali sono gli errori più comuni nella costruzione dello `slt`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli errori più comuni sono:
>
> 1. Collegare `Less` a tutti i bit invece che solo al bit meno significativo.
>
> Corretto:
>
> ```text
> Less bit 0 = Set dell’MSB
> Less bit 1 = 0
> Less bit 2 = 0
> Less bit 3 = 0
> ```
>
> 2. Usare `Set = Sum_MSB` anche nei casi signed con overflow.
>
> Corretto:
>
> ```text
> Set = Sum_MSB XOR Overflow
> ```
>
> 3. Pensare che `slt` debba restituire il risultato della sottrazione.
>
> Corretto:
>
> ```text
> slt restituisce 0001 oppure 0000
> ```
>
> 4. Confondere `CarryOut` con `Overflow`.
>
> Corretto:
>
> ```text
> Overflow = CarryIn_MSB XOR CarryOut_MSB
> ```
>
> 5. Dimenticare che `slt` deve impostare la ALU come una sottrazione interna:
>
> ```text
> Ainvert = 0
> Binvert = 1
> CarryIn iniziale = 1
> Operation = 11
> ```