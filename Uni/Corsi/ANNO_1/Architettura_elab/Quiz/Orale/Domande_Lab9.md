
# Laboratorio 8/9 — ALU, latch, flip-flop, registro e register file

## Metodo di ripasso

Ripassa questi circuiti partendo sempre dalla domanda: **che cosa entra, che cosa esce, e quale segnale decide il comportamento?**  
Per ogni blocco devi saper dire:

- qual è la sua funzione;
    
- quali sono i segnali di controllo;
    
- cosa succede nei casi limite, come `reset = 1`, `enable = 0`, `RegWrite = 0`;
    
- perché servono decoder, mux e registri.
    

---

## 1. Che cosa fa un half adder?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un half adder somma due bit `A` e `B` senza considerare un riporto in ingresso.
> 
> Produce due uscite:
> 
> ```text
> Sum = A XOR B
> Carry = A AND B
> ```
> 
> `Sum` vale 1 quando uno solo tra `A` e `B` vale 1.  
> `Carry` vale 1 solo quando entrambi valgono 1.
> 
> Il limite dell’half adder è che non può essere collegato direttamente in cascata per sommare numeri a più bit, perché non ha un `CarryIn`.

---

## 2. Che cosa fa un full adder e perché serve?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un full adder somma tre bit:
> 
> ```text
> a
> b
> CarryIn
> ```
> 
> e produce:
> 
> ```text
> Sum
> CarryOut
> ```
> 
> Serve perché nelle somme a più bit ogni colonna deve considerare anche il riporto proveniente dal bit meno significativo precedente.
> 
> Si può costruire usando due half adder:
> 
> ```text
> primo half adder:  a + b
> secondo half adder: risultato + CarryIn
> CarryOut = Carry1 OR Carry2
> ```
> 
> In una ALU multi-bit, il `CarryOut` di un bit diventa il `CarryIn` del bit successivo.

---

## 3. Che cosa fa la ALU a 1 bit v0?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La `ALU_1bit_v0` è una ALU semplice a 1 bit che può scegliere tra più operazioni usando un multiplexer.
> 
> Le operazioni principali sono:
> 
> ```text
> Operation = 00 → AND
> Operation = 01 → OR
> Operation = 10 → ADD
> Operation = 11 → di solito 0 o ingresso non usato
> ```
> 
> Il circuito calcola in parallelo:
> 
> ```text
> a AND b
> a OR b
> a + b + CarryIn
> ```
> 
> Poi un multiplexer seleziona quale risultato mandare in uscita in base a `Operation`.

---

## 4. A cosa servono `Ainvert` e `Binvert` nella ALU a 1 bit v1?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> `Ainvert` e `Binvert` servono per invertire eventualmente gli ingressi prima di usarli nella ALU.
> 
> Si usano due XOR:
> 
> ```text
> a_eff = a XOR Ainvert
> b_eff = b XOR Binvert
> ```
> 
> Se `Ainvert = 0`, allora `a_eff = a`.  
> Se `Ainvert = 1`, allora `a_eff = NOT a`.
> 
> Stessa cosa per `b`:
> 
> ```text
> Binvert = 0 → b_eff = b
> Binvert = 1 → b_eff = NOT b
> ```
> 
> Questa tecnica è utile perché con lo stesso circuito posso fare operazioni normali, operazioni invertite e sottrazioni.

---

## 5. Come si fa la sottrazione nella ALU usando il complemento a due?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La sottrazione viene trasformata in una somma usando il complemento a due:
> 
> ```text
> a - b = a + NOT(b) + 1
> ```
> 
> Quindi nella ALU:
> 
> ```text
> Binvert = 1
> CarryIn iniziale = 1
> ```
> 
> In questo modo `b` viene invertito e il `+1` viene fornito dal carry iniziale.
> 
> Per questo spesso il segnale `Binvert` coincide con il `CarryIn` del bit meno significativo quando si vuole fare una sottrazione.

---

## 6. A cosa serve l’ingresso `Less` nella ALU a 1 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> L’ingresso `Less` serve per implementare l’operazione `set less than`, cioè:
> 
> ```text
> a < b
> ```
> 
> Nelle ALU multi-bit, il confronto viene fatto tramite una sottrazione:
> 
> ```text
> a - b
> ```
> 
> Se il risultato è negativo, allora `a < b`.
> 
> Il bit più significativo calcola il segnale `Set`, che indica il risultato del confronto. Questo `Set` viene poi mandato come `Less` al bit meno significativo.
> 
> Così il risultato finale della `SLT` diventa:
> 
> ```text
> 0001 se a < b
> 0000 se a >= b
> ```

---

## 7. Perché nella ALU a 1 bit v2 si calcola l’overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Nella `ALU_1bit_v2`, usata per il bit più significativo, si calcola l’overflow perché il bit più significativo determina il segno del risultato.
> 
> Per una somma o sottrazione in complemento a due, l’overflow si può calcolare come:
> 
> ```text
> Overflow = CarryIn_MSB XOR CarryOut_MSB
> ```
> 
> Se i due carry sono diversi, significa che il risultato ha superato l’intervallo rappresentabile.
> 
> Nell’operazione `set less than`, l’overflow è importante perché il solo bit di segno potrebbe essere sbagliato in caso di overflow. Per questo il segnale `Set` corretto viene calcolato tenendo conto dell’overflow.

---

## 8. Come è costruita la ALU a 4 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La ALU a 4 bit è costruita mettendo in cascata quattro ALU a 1 bit.
> 
> Ogni ALU gestisce un bit degli operandi:
> 
> ```text
> bit 0 → ALU_1bit_v1
> bit 1 → ALU_1bit_v1
> bit 2 → ALU_1bit_v1
> bit 3 → ALU_1bit_v2
> ```
> 
> Il bit più significativo usa `ALU_1bit_v2` perché deve calcolare anche:
> 
> ```text
> Set
> Overflow
> ```
> 
> I carry sono collegati in cascata:
> 
> ```text
> CarryOut bit 0 → CarryIn bit 1
> CarryOut bit 1 → CarryIn bit 2
> CarryOut bit 2 → CarryIn bit 3
> ```
> 
> Il risultato finale è formato concatenando i risultati dei quattro bit:
> 
> ```text
> Result = {r3, r2, r1, r0}
> ```

---

## 9. Come viene calcolato il segnale `Zero` nella ALU a 4 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il segnale `Zero` indica se il risultato della ALU è uguale a zero.
> 
> Per una ALU a 4 bit:
> 
> ```text
> Zero = 1 se Result = 0000
> ```
> 
> Si può calcolare con una NOR di tutti i bit del risultato:
> 
> ```text
> Zero = NOT(Result[0] OR Result[1] OR Result[2] OR Result[3])
> ```
> 
> Se almeno un bit del risultato vale 1, allora `Zero = 0`.  
> Se tutti i bit sono 0, allora `Zero = 1`.

---

## 10. Che cos’è un latch SR e quali sono i suoi casi principali?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un latch SR è un circuito sequenziale elementare che memorizza un bit.
> 
> Ha due ingressi:
> 
> ```text
> S = Set
> R = Reset
> ```
> 
> e due uscite:
> 
> ```text
> Q
> NQ
> ```
> 
> I casi principali sono:
> 
> ```text
> S = 1, R = 0 → Q diventa 1
> S = 0, R = 1 → Q diventa 0
> S = 0, R = 0 → mantiene il valore precedente
> S = 1, R = 1 → caso vietato/non desiderato
> ```
> 
> È importante perché è la base per costruire latch D, flip-flop e registri.

---

## 11. Come si costruisce un latch D a partire da un latch SR?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il latch D serve per memorizzare direttamente un dato `D`, evitando il caso vietato del latch SR.
> 
> Si costruisce generando:
> 
> ```text
> S = C AND D
> R = C AND NOT(D)
> ```
> 
> Dove `C` è il segnale di controllo.
> 
> Se `C = 1`, il latch è trasparente:
> 
> ```text
> Q segue D
> ```
> 
> Se `C = 0`, entrambi gli ingressi del latch SR valgono 0:
> 
> ```text
> S = 0
> R = 0
> ```
> 
> quindi il circuito mantiene il valore precedente.
> 
> Il vantaggio è che `S` e `R` non possono mai essere entrambi 1, perché derivano da `D` e `NOT(D)`.

---

## 12. Come funziona il reset nel latch/flip-flop D?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il reset deve avere priorità sul normale funzionamento del circuito.
> 
> Se il testo dice:
> 
> ```text
> reset = 1 → memorizza 0 indipendentemente da C e D
> ```
> 
> allora significa che il reset non deve dipendere dal clock o dal dato.
> 
> Per ottenere questo comportamento, nel latch basato su SR si può usare:
> 
> ```text
> S = NOT(reset) AND C AND D
> R = reset OR (C AND NOT(D))
> ```
> 
> Così:
> 
> ```text
> reset = 1 → S = 0, R = 1 → Q = 0
> ```
> 
> Il reset forza quindi l’uscita a zero anche se `C = 0` o se `D = 1`.

---

## 13. Che differenza c’è tra latch e flip-flop?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un latch è sensibile al livello del segnale di controllo.
> 
> Per esempio, in un latch D:
> 
> ```text
> C = 1 → Q segue D
> C = 0 → Q mantiene il valore
> ```
> 
> Un flip-flop invece dovrebbe aggiornarsi solo in corrispondenza di un fronte di clock, per esempio sul fronte di salita:
> 
> ```text
> clock: 0 → 1
> ```
> 
> In pratica:
> 
> ```text
> latch → sensibile al livello
> flip-flop → sensibile al fronte
> ```
> 
> Il flip-flop è più adatto per costruire registri sincroni, perché tutti i bit vengono aggiornati nello stesso istante di clock.

---

## 14. Come funziona un registro a 8 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un registro a 8 bit memorizza un valore di 8 bit.
> 
> È costruito mettendo 8 flip-flop D in parallelo:
> 
> ```text
> in[0] → flip-flop 0 → out[0]
> in[1] → flip-flop 1 → out[1]
> ...
> in[7] → flip-flop 7 → out[7]
> ```
> 
> Tutti condividono:
> 
> ```text
> clock
> enable
> reset
> ```
> 
> Se `enable = 1`, al fronte di clock il registro carica il valore di `in`.
> 
> Se `enable = 0`, il registro mantiene il valore precedente.
> 
> Se `reset = 1`, il registro viene azzerato:
> 
> ```text
> out = 00000000
> ```

---

## 15. Perché nel registro a 8 bit uso `Q` e non `NQ`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In un registro voglio leggere il valore memorizzato normalmente, quindi uso:
> 
> ```text
> Q → out[i]
> ```
> 
> `NQ` è solo il complemento di `Q`:
> 
> ```text
> NQ = NOT(Q)
> ```
> 
> Potrebbe servire in altri circuiti se volessi direttamente il valore negato, ma nel registro normale non serve.
> 
> Quindi per ogni bit:
> 
> ```text
> flip-flop.Q → out[i]
> ```
> 
> e non:
> 
> ```text
> flip-flop.NQ → out[i]
> ```
> 
> Se usassi `NQ`, leggerei il complemento del dato memorizzato.

---

## 16. Come è fatto un register file 8x8?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un register file 8x8 contiene:
> 
> ```text
> 8 registri
> ciascuno da 8 bit
> ```
> 
> Quindi può memorizzare 8 parole da 8 bit.
> 
> Ha una porta di scrittura:
> 
> ```text
> rd
> rd_data
> RegWrite
> clock
> reset
> ```
> 
> e due porte di lettura:
> 
> ```text
> rs1 → rs1_data
> rs2 → rs2_data
> ```
> 
> `rd` sceglie quale registro scrivere.  
> `rs1` e `rs2` scelgono quali registri leggere.
> 
> La scrittura avviene solo se:
> 
> ```text
> RegWrite = 1
> ```
> 
> e arriva il fronte di clock.

---

## 17. Perché nel register file serve un decoder?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il decoder serve nella fase di scrittura.
> 
> L’ingresso `rd` indica quale registro deve essere scritto:
> 
> ```text
> rd = 000 → x0
> rd = 001 → x1
> rd = 010 → x2
> ...
> rd = 111 → x7
> ```
> 
> Un decoder 3→8 trasforma questi 3 bit in 8 segnali separati:
> 
> ```text
> rd = 101 → decoder_out5 = 1
> ```
> 
> Poi ogni uscita del decoder viene combinata con `RegWrite`:
> 
> ```text
> enable_i = RegWrite AND decoder_out_i
> ```
> 
> Così solo il registro selezionato viene abilitato alla scrittura.

---

## 18. Perché nel register file servono due multiplexer?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Servono due multiplexer perché il register file ha due porte di lettura indipendenti:
> 
> ```text
> rs1_data
> rs2_data
> ```
> 
> Il primo mux sceglie quale registro mandare su `rs1_data`:
> 
> ```text
> select = rs1
> ```
> 
> Il secondo mux sceglie quale registro mandare su `rs2_data`:
> 
> ```text
> select = rs2
> ```
> 
> Entrambi i mux ricevono come ingressi le uscite degli 8 registri:
> 
> ```text
> x0, x1, x2, x3, x4, x5, x6, x7
> ```
> 
> ma possono selezionare registri diversi nello stesso momento.

---

## 19. Che differenza c’è tra `rd`, `rs1` e `rs2`?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Nel register file:
> 
> ```text
> rd  → registro destinazione da scrivere
> rs1 → primo registro sorgente da leggere
> rs2 → secondo registro sorgente da leggere
> ```
> 
> Quindi:
> 
> ```text
> rd decide DOVE scrivo
> rs1 decide DA DOVE leggo sulla prima porta
> rs2 decide DA DOVE leggo sulla seconda porta
> ```
> 
> Esempio:
> 
> ```text
> RegWrite = 1
> rd = 001
> rd_data = 01010101
> ```
> 
> Al clock viene scritto `01010101` dentro `x1`.
> 
> Per leggerlo devo mettere:
> 
> ```text
> rs1 = 001
> ```
> 
> oppure:
> 
> ```text
> rs2 = 001
> ```

---

## 20. Perché `x0` deve rimanere sempre zero?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In stile RISC-V, il registro `x0` è speciale:
> 
> ```text
> x0 = 00000000 sempre
> ```
> 
> Anche se provo a scriverci dentro, il valore letto da `x0` deve restare zero.
> 
> Per ottenere questo comportamento posso:
> 
> ```text
> non rendere scrivibile x0
> ```
> 
> oppure forzare l’ingresso 0 dei mux di lettura a:
> 
> ```text
> 00000000
> ```
> 
> In questo modo, quando `rs1 = 000` o `rs2 = 000`, il register file restituisce sempre zero.
> 
> Questo è importante perché molti circuiti RISC-V si aspettano che `x0` sia una costante zero.

---

## 21. Cosa succede se `RegWrite = 0` nel register file?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Se `RegWrite = 0`, nessun registro deve essere scritto.
> 
> Anche se `rd` seleziona un registro e anche se `rd_data` cambia, gli enable dei registri restano a zero:
> 
> ```text
> enable_i = RegWrite AND decoder_out_i
> ```
> 
> quindi:
> 
> ```text
> enable_i = 0
> ```
> 
> Il register file continua però a leggere normalmente tramite `rs1` e `rs2`.
> 
> Quindi:
> 
> ```text
> RegWrite controlla la scrittura
> rs1 e rs2 controllano la lettura
> ```

---

## 22. Cosa succede con `reset = 1` nel registro e nel register file?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Se `reset = 1`, i registri devono essere azzerati.
> 
> Nel registro a 8 bit:
> 
> ```text
> reset = 1 → out = 00000000
> ```
> 
> Nel register file:
> 
> ```text
> reset = 1 → tutti i registri vengono azzerati
> ```
> 
> Però, appena `reset` torna a 0, il circuito riprende a funzionare normalmente.
> 
> Quindi se dopo il reset lascio:
> 
> ```text
> RegWrite = 1
> rd = un registro valido
> rd_data = un valore
> ```
> 
> al successivo fronte di clock quel registro può essere scritto di nuovo.
> 
> Il reset non “blocca per sempre” il circuito: lo azzera e poi il circuito riparte.

---

## 23. Qual è il ruolo del clock nei registri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il clock stabilisce quando il registro aggiorna il proprio contenuto.
> 
> In un registro sincrono, il dato non deve cambiare immediatamente appena cambia l’ingresso.
> 
> Il dato viene memorizzato solo quando arriva il fronte di clock previsto, per esempio:
> 
> ```text
> clock: 0 → 1
> ```
> 
> Quindi:
> 
> ```text
> enable = 1
> fronte di clock
> ```
> 
> significa:
> 
> ```text
> carica il nuovo dato
> ```
> 
> Se invece `enable = 0`, anche con il clock il registro mantiene il vecchio valore.

---

## 24. Perché è importante rispettare esattamente i nomi delle porte nel Verilog esportato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il Verilog è case-sensitive, quindi distingue maiuscole e minuscole.
> 
> Per esempio:
> 
> ```text
> Out ≠ out
> Clock ≠ clock
> Enable ≠ enable
> Reset ≠ reset
> ```
> 
> Se il grader si aspetta un modulo:
> 
> ```verilog
> module \8bit-register (out, in, enable, clock, reset);
> ```
> 
> ma io lo esporto come:
> 
> ```verilog
> module \8bit-register (Out, Clock, Enable, In, Reset);
> ```
> 
> il grader non trova le porte richieste.
> 
> Per questo i nomi delle porte devono combaciare esattamente con quelli richiesti dal testbench.

---

## 25. Che errore causa un collegamento sbagliato tra x4 e x5 nel register file?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Se il registro `x5` è collegato per errore allo stesso filo di `x4`, il register file non riesce a leggere correttamente `x5`.
> 
> Il sintomo tipico è:
> 
> ```text
> leggo x5 ma ottengo X, oppure leggo il valore di x4
> ```
> 
> Questo succede perché due registri possono finire a pilotare lo stesso bus, oppure perché il mux riceve due volte lo stesso ingresso.
> 
> La struttura corretta deve essere:
> 
> ```text
> mux input 4 → x4_out
> mux input 5 → x5_out
> mux input 6 → x6_out
> mux input 7 → x7_out
> ```
> 
> e non:
> 
> ```text
> mux input 4 → x4_out
> mux input 5 → x4_out
> ```
> 
> Ogni registro deve avere la propria uscita separata.

---

## 26. Come spiegherei all’orale tutto il register file in poche frasi?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il register file 8x8 contiene 8 registri da 8 bit. La scrittura è controllata da `RegWrite`, `rd`, `rd_data` e dal clock.
> 
> `rd` entra in un decoder 3→8, che abilita uno solo degli 8 registri. Ogni uscita del decoder viene messa in AND con `RegWrite`, così se `RegWrite = 0` nessun registro viene scritto.
> 
> Il dato `rd_data` arriva a tutti i registri, ma solo quello abilitato lo memorizza al fronte di clock.
> 
> La lettura è combinatoria: due mux 8→1 scelgono quale registro mandare su `rs1_data` e quale su `rs2_data`, usando rispettivamente `rs1` e `rs2`.
> 
> Il registro `x0` deve restare sempre zero, quindi la lettura di `x0` restituisce sempre `00000000`.

---