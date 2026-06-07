# Cheat sheet formule — Architettura degli Elaboratori

## Metodo di ripasso

Ripassa queste flashcard concentrandoti su tre cose:

1. **Riconoscere la formula giusta dal testo dell’esercizio**
    
2. **Controllare sempre le unità di misura**
    
3. **Capire se il dato è signed/unsigned, byte/word, hit/miss, tempo/prestazione**
    

Quando vedi esercizi con CPU, GHz, numero di istruzioni o CPI, parti quasi sempre da:

```text
CPU time = IC × CPI × Tclock
```

oppure:

```text
CPU time = (IC × CPI) / frequenza
```

---

## 1. Come si calcola il periodo di clock a partire dalla frequenza?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il periodo di clock è la durata di un singolo ciclo.
> 
> Formula:
> 
> ```text
> Tclock = 1 / frequenza
> ```
> 
> Se la frequenza è in Hz, il periodo viene in secondi.
> 
> Esempio:
> 
> ```text
> f = 2 GHz = 2 × 10^9 Hz
> Tclock = 1 / (2 × 10^9) = 0,5 ns
> ```
> 
> Quindi un processore a 2 GHz ha un ciclo di clock lungo 0,5 ns.

---

## 2. Come si calcola il tempo di esecuzione della CPU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La formula fondamentale è:
> 
> ```text
> CPU time = IC × CPI × Tclock
> ```
> 
> Dove:
> 
> ```text
> IC = Instruction Count, cioè numero di istruzioni eseguite
> CPI = cicli medi per istruzione
> Tclock = periodo di clock
> ```
> 
> Poiché:
> 
> ```text
> Tclock = 1 / frequenza
> ```
> 
> si può anche scrivere:
> 
> ```text
> CPU time = (IC × CPI) / frequenza
> ```
> 
> Questa è una delle formule più importanti per gli esercizi.

---

## 3. Come si calcola il numero totale di cicli di clock eseguiti da un programma?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il numero totale di cicli si calcola così:
> 
> ```text
> cicli totali = IC × CPI
> ```
> 
> Dove:
> 
> ```text
> IC = numero di istruzioni
> CPI = cicli medi per istruzione
> ```
> 
> Una volta trovati i cicli totali, il tempo si calcola con:
> 
> ```text
> tempo = cicli totali × Tclock
> ```
> 
> oppure:
> 
> ```text
> tempo = cicli totali / frequenza
> ```

---

## 4. Come si calcola il CPI medio quando ci sono più classi di istruzioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Se il programma contiene più tipi di istruzioni, il CPI medio si calcola con una media pesata:
> 
> ```text
> CPI medio = Σ(percentuale_i × CPI_i)
> ```
> 
> Esempio:
> 
> ```text
> 50% istruzioni ALU, CPI = 1
> 30% load/store, CPI = 2
> 20% branch, CPI = 3
> ```
> 
> Allora:
> 
> ```text
> CPI medio = 0,5×1 + 0,3×2 + 0,2×3
> CPI medio = 0,5 + 0,6 + 0,6 = 1,7
> ```
> 
> Attenzione: le percentuali vanno trasformate in numeri decimali.

---

## 5. Come si calcola il CPI medio se vengono dati i numeri assoluti delle istruzioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Se non hai le percentuali ma il numero di istruzioni per ogni classe, usa:
> 
> ```text
> CPI medio = Σ(IC_i × CPI_i) / IC_totale
> ```
> 
> Dove:
> 
> ```text
> IC_i = numero di istruzioni della classe i
> CPI_i = CPI della classe i
> IC_totale = numero totale di istruzioni
> ```
> 
> Prima si calcolano i cicli totali prodotti da ogni classe, poi si divide per il numero totale di istruzioni.

---

## 6. Come si calcola il tempo di esecuzione conoscendo istruzioni, CPI e GHz?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Si usa:
> 
> ```text
> CPU time = (IC × CPI) / frequenza
> ```
> 
> Esempio:
> 
> ```text
> IC = 10^9 istruzioni
> CPI = 2
> frequenza = 4 GHz = 4 × 10^9 Hz
> ```
> 
> Allora:
> 
> ```text
> CPU time = (10^9 × 2) / (4 × 10^9)
> CPU time = 2 / 4 = 0,5 s
> ```
> 
> Attenzione a convertire sempre i GHz in Hz.

---

## 7. Come si calcolano i MIPS?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> MIPS significa Millions of Instructions Per Second.
> 
> Formula:
> 
> ```text
> MIPS = numero istruzioni / (tempo × 10^6)
> ```
> 
> Oppure:
> 
> ```text
> MIPS = frequenza / (CPI × 10^6)
> ```
> 
> Se la frequenza è già in MHz:
> 
> ```text
> MIPS = frequenza in MHz / CPI
> ```
> 
> Attenzione: i MIPS possono essere ingannevoli, perché non dicono quanto sono complesse o utili le istruzioni.

---

## 8. Perché i MIPS possono essere una misura ingannevole?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> I MIPS misurano quante istruzioni vengono eseguite al secondo, ma non dicono quanto lavoro utile svolga ogni istruzione.
> 
> Due processori possono avere MIPS diversi, ma:
> 
> - avere ISA diverse;
>     
> - usare numeri diversi di istruzioni per lo stesso programma;
>     
> - avere istruzioni più o meno complesse;
>     
> - avere CPI diversi.
>     
> 
> Per confrontare davvero due processori, la misura migliore è il tempo di esecuzione dello stesso programma.

---

## 9. Come si calcola lo speedup?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Lo speedup misura quanto un sistema nuovo è più veloce rispetto a uno vecchio.
> 
> Formula:
> 
> ```text
> speedup = tempo vecchio / tempo nuovo
> ```
> 
> Esempio:
> 
> ```text
> tempo vecchio = 10 s
> tempo nuovo = 4 s
> ```
> 
> Allora:
> 
> ```text
> speedup = 10 / 4 = 2,5
> ```
> 
> Il sistema nuovo è 2,5 volte più veloce.
> 
> Attenzione: non invertire la formula.

---

## 10. Qual è la relazione tra prestazione e tempo di esecuzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La prestazione è inversamente proporzionale al tempo.
> 
> Formula:
> 
> ```text
> prestazione = 1 / tempo
> ```
> 
> Quindi:
> 
> ```text
> prestazione A / prestazione B = tempo B / tempo A
> ```
> 
> Il processore con prestazioni migliori è quello che impiega meno tempo, non necessariamente quello con frequenza più alta.

---

## 11. Cosa dice la legge di Amdahl?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La legge di Amdahl dice che il miglioramento totale di un sistema è limitato dalla parte che non viene migliorata.
> 
> Formula:
> 
> ```text
> speedup totale = 1 / [(1 - f) + f/S]
> ```
> 
> Dove:
> 
> ```text
> f = frazione del programma migliorata
> S = speedup della parte migliorata
> ```
> 
> Se migliori solo una parte del programma, il resto continua comunque a pesare sul tempo totale.

---

## 12. Qual è il limite massimo di speedup secondo Amdahl?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Se una frazione `f` del programma viene resa infinitamente veloce, il tempo della parte migliorata tende a zero.
> 
> Lo speedup massimo diventa:
> 
> ```text
> speedup massimo = 1 / (1 - f)
> ```
> 
> Esempio:
> 
> ```text
> f = 0,4
> ```
> 
> Allora:
> 
> ```text
> speedup massimo = 1 / (1 - 0,4)
> speedup massimo = 1 / 0,6 = 1,67
> ```
> 
> Anche migliorando infinitamente il 40% del programma, non puoi superare 1,67 volte di speedup.

---

## 13. Che differenza c’è tra latenza e throughput?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La latenza è il tempo necessario per completare una singola operazione.
> 
> ```text
> latenza = tempo per completare un task
> ```
> 
> Il throughput è il numero di operazioni completate nell’unità di tempo.
> 
> ```text
> throughput = operazioni / secondo
> ```
> 
> Una pipeline migliora soprattutto il throughput, perché permette di completare più istruzioni nel tempo, ma non necessariamente riduce la latenza della singola istruzione.

---

## 14. Come si calcolano i cicli necessari in una pipeline ideale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In una pipeline ideale con `k` stadi e `n` istruzioni:
> 
> ```text
> cicli totali = k + n - 1
> ```
> 
> Dove:
> 
> ```text
> k = numero di stadi della pipeline
> n = numero di istruzioni
> ```
> 
> I primi `k` cicli servono per riempire la pipeline. Dopo il riempimento, idealmente viene completata una istruzione per ciclo.

---

## 15. Qual è lo speedup ideale di una pipeline?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Lo speedup ideale di una pipeline tende al numero di stadi della pipeline.
> 
> Se la pipeline ha 5 stadi:
> 
> ```text
> speedup ideale ≈ 5
> ```
> 
> Questo però vale solo in condizioni ideali.
> 
> Nella realtà lo speedup è minore a causa di:
> 
> - hazard sui dati;
>     
> - hazard di controllo;
>     
> - stall;
>     
> - branch;
>     
> - accessi lenti alla memoria.
>     

---

## 16. Come si calcola l’hit rate e il miss rate di una cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> L’hit rate è la percentuale di accessi trovati in cache.
> 
> Il miss rate è la percentuale di accessi non trovati in cache.
> 
> Formula:
> 
> ```text
> hit rate + miss rate = 1
> ```
> 
> Quindi:
> 
> ```text
> miss rate = 1 - hit rate
> ```
> 
> e:
> 
> ```text
> hit rate = 1 - miss rate
> ```
> 
> Attenzione: se il miss rate è dato in percentuale, bisogna convertirlo in decimale.
> 
> ```text
> 5% = 0,05
> ```

---

## 17. Come si calcola il tempo medio di accesso alla memoria, cioè AMAT?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> AMAT significa Average Memory Access Time.
> 
> Formula:
> 
> ```text
> AMAT = hit time + miss rate × miss penalty
> ```
> 
> Dove:
> 
> ```text
> hit time = tempo di accesso in caso di hit
> miss rate = probabilità di miss
> miss penalty = penalità aggiuntiva in caso di miss
> ```
> 
> Esempio:
> 
> ```text
> hit time = 1 ciclo
> miss rate = 5% = 0,05
> miss penalty = 100 cicli
> ```
> 
> Allora:
> 
> ```text
> AMAT = 1 + 0,05 × 100 = 6 cicli
> ```

---

## 18. Come si tiene conto dei miss di cache nel CPI reale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il CPI reale può essere visto come:
> 
> ```text
> CPI reale = CPI base + cicli di stall per istruzione
> ```
> 
> Nel caso dei miss:
> 
> ```text
> cicli di stall = accessi memoria per istruzione × miss rate × miss penalty
> ```
> 
> Quindi:
> 
> ```text
> CPI reale = CPI base + accessi_memoria_per_istruzione × miss_rate × miss_penalty
> ```
> 
> Questa formula serve quando gli accessi in memoria rallentano l’esecuzione del programma.

---

## 19. Come si calcola il numero di blocchi in una cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il numero di blocchi della cache si calcola così:
> 
> ```text
> numero blocchi = dimensione cache / dimensione blocco
> ```
> 
> Esempio:
> 
> ```text
> cache = 1024 byte
> blocco = 16 byte
> ```
> 
> Allora:
> 
> ```text
> numero blocchi = 1024 / 16 = 64
> ```
> 
> Questo valore è importante per calcolare i bit di index.

---

## 20. Come si divide un indirizzo in tag, index e offset in una cache direct mapped?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In una cache direct mapped, l’indirizzo viene diviso in:
> 
> ```text
> tag | index | offset
> ```
> 
> Le formule sono:
> 
> ```text
> bit offset = log2(dimensione blocco in byte)
> ```
> 
> ```text
> bit index = log2(numero di linee della cache)
> ```
> 
> ```text
> bit tag = bit indirizzo - bit index - bit offset
> ```
> 
> L’offset seleziona il byte dentro il blocco.
> 
> L’index seleziona la linea della cache.
> 
> Il tag serve a verificare se il blocco presente è quello richiesto.

---

## 21. Come si calcolano i set in una cache set-associative?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In una cache set-associative:
> 
> ```text
> numero set = numero linee cache / associatività
> ```
> 
> Esempio:
> 
> ```text
> cache con 16 linee
> associatività = 4-way
> ```
> 
> Allora:
> 
> ```text
> numero set = 16 / 4 = 4 set
> ```
> 
> I bit di index diventano:
> 
> ```text
> bit index = log2(numero set)
> ```
> 
> Non si usa il numero totale di linee, ma il numero di set.

---

## 22. Come si calcola la capacità massima indirizzabile di una memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Se una memoria ha `n` bit di indirizzo ed è indirizzabile a byte:
> 
> ```text
> capacità = 2^n byte
> ```
> 
> Esempio:
> 
> ```text
> 32 bit di indirizzo → 2^32 byte = 4 GiB
> ```
> 
> Il bus indirizzi determina quanti indirizzi diversi posso generare.
> 
> Il bus dati determina invece quanti bit posso trasferire per singola operazione.

---

## 23. Quali sono le dimensioni di byte, halfword e word in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> In RISC-V:
> 
> ```text
> byte = 8 bit = 1 byte
> halfword = 16 bit = 2 byte
> word = 32 bit = 4 byte
> ```
> 
> Quindi:
> 
> - un carattere occupa 1 byte;
>     
> - una halfword occupa 2 byte;
>     
> - un intero word occupa 4 byte.
>     
> 
> Questo è fondamentale per calcolare gli indirizzi negli array.

---

## 24. Come si calcola l’indirizzo di un elemento in un array di word?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Se l’array contiene word da 4 byte:
> 
> ```text
> indirizzo array[i] = base + i × 4
> ```
> 
> In assembly RISC-V:
> 
> ```asm
> slli t0, i, 2      # i × 4
> add  t0, base, t0
> lw   t1, 0(t0)
> ```
> 
> Lo shift a sinistra di 2 equivale a moltiplicare per 4.
> 
> Attenzione: per array di byte o stringhe non bisogna moltiplicare per 4.

---

## 25. Come si calcola l’indirizzo di un carattere in una stringa?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Una stringa è un array di byte.
> 
> Ogni carattere occupa 1 byte.
> 
> Quindi:
> 
> ```text
> indirizzo str[i] = base + i
> ```
> 
> Non bisogna moltiplicare `i` per 4.
> 
> Per leggere un carattere si usa tipicamente:
> 
> ```asm
> lbu t0, 0(a0)
> ```
> 
> Le stringhe terminano con:
> 
> ```text
> '\0' = 0
> ```

---

## 26. Che differenza c’è tra lb, lbu, lh, lhu e lw?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Le istruzioni di load principali sono:
> 
> ```asm
> lb   # load byte signed
> lbu  # load byte unsigned
> lh   # load halfword signed
> lhu  # load halfword unsigned
> lw   # load word
> ```
> 
> La differenza importante è tra signed e unsigned:
> 
> - `lb` e `lh` fanno estensione del segno;
>     
> - `lbu` e `lhu` fanno estensione con zeri.
>     
> 
> Esempio:
> 
> ```text
> byte letto = 0xFF
> ```
> 
> Con `lb` diventa:
> 
> ```text
> 0xFFFFFFFF
> ```
> 
> Con `lbu` diventa:
> 
> ```text
> 0x000000FF
> ```

---

## 27. Che differenza c’è tra sb, sh e sw?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Le istruzioni di store principali sono:
> 
> ```asm
> sb = store byte
> sh = store halfword
> sw = store word
> ```
> 
> Significato:
> 
> - `sb` salva solo 1 byte;
>     
> - `sh` salva 2 byte;
>     
> - `sw` salva 4 byte.
>     
> 
> Attenzione: quando fai uno store parziale, non stai salvando tutto il registro, ma solo i byte meno significativi richiesti dall’istruzione.

---

## 28. Cosa significa little endian?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Little endian significa che il byte meno significativo viene salvato all’indirizzo più basso.
> 
> Esempio:
> 
> ```text
> word = 0x11223344
> ```
> 
> Se viene salvata a partire dall’indirizzo 0:
> 
> ```text
> indirizzo 0 → 0x44
> indirizzo 1 → 0x33
> indirizzo 2 → 0x22
> indirizzo 3 → 0x11
> ```
> 
> Questo è uno dei tranelli più comuni negli esercizi con `lw`, `lh`, `lhu`, `lb`, `lbu`, `sw`, `sh`, `sb`.

---

## 29. Qual è il range dei numeri unsigned con n bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Con `n` bit unsigned il range è:
> 
> ```text
> minimo = 0
> massimo = 2^n - 1
> ```
> 
> Esempio con 8 bit:
> 
> ```text
> 0 ... 255
> ```
> 
> Esempio con 32 bit:
> 
> ```text
> 0 ... 4294967295
> ```
> 
> Nei numeri unsigned non esistono valori negativi.

---

## 30. Qual è il range dei numeri signed in complemento a 2 con n bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Con `n` bit signed in complemento a 2:
> 
> ```text
> minimo = -2^(n-1)
> massimo = 2^(n-1) - 1
> ```
> 
> Esempio con 8 bit:
> 
> ```text
> -128 ... +127
> ```
> 
> Esempio con 32 bit:
> 
> ```text
> -2^31 ... 2^31 - 1
> ```
> 
> Quindi:
> 
> ```text
> 0x80000000 = -2147483648
> 0x7FFFFFFF = +2147483647
> ```

---

## 31. Come si interpreta 0xFFFFFFFF come signed e unsigned?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Lo stesso insieme di bit può rappresentare valori diversi a seconda dell’interpretazione.
> 
> Con 32 bit:
> 
> ```text
> 0xFFFFFFFF unsigned = 4294967295
> 0xFFFFFFFF signed = -1
> ```
> 
> Questo perché in complemento a 2 tutti i bit a 1 rappresentano `-1`.
> 
> È fondamentale capire se l’esercizio chiede un confronto signed o unsigned.

---

## 32. Quando si verifica overflow nella somma signed?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Nell’addizione signed, l’overflow si verifica quando sommi due numeri con lo stesso segno e ottieni un risultato con segno diverso.
> 
> Casi:
> 
> ```text
> positivo + positivo = negativo → overflow
> negativo + negativo = positivo → overflow
> ```
> 
> Se i due operandi hanno segno diverso, nell’addizione signed non può esserci overflow.
> 
> Attenzione: in RISC-V `add` non segnala eccezioni di overflow, ma conserva semplicemente i 32 bit bassi del risultato.

---

## 33. Che differenza c’è tra carry e overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Carry e overflow non sono la stessa cosa.
> 
> Il carry riguarda soprattutto l’aritmetica unsigned.
> 
> ```text
> carry = riporto fuori dal bit più significativo
> ```
> 
> L’overflow riguarda l’aritmetica signed in complemento a 2.
> 
> Un’operazione può avere:
> 
> - carry senza overflow;
>     
> - overflow senza carry;
>     
> - entrambi;
>     
> - nessuno dei due.
>     
> 
> Quando l’esercizio parla di signed, bisogna ragionare sull’overflow, non solo sul carry.

---

## 34. Come funziona lo shift logico sinistro?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Lo shift logico sinistro in RISC-V si fa con:
> 
> ```asm
> sll
> ```
> 
> oppure, con immediato:
> 
> ```asm
> slli
> ```
> 
> Concettualmente:
> 
> ```text
> x << n = x × 2^n
> ```
> 
> se non si considera l’overflow.
> 
> Esempio:
> 
> ```text
> x << 2 = x × 4
> ```
> 
> Per questo negli array di word si usa spesso `slli indice, indice, 2`.

---

## 35. Che differenza c’è tra shift logico destro e shift aritmetico destro?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Lo shift logico destro si fa con:
> 
> ```asm
> srl
> ```
> 
> Inserisce zeri da sinistra.
> 
> È adatto ai numeri unsigned.
> 
> Lo shift aritmetico destro si fa con:
> 
> ```asm
> sra
> ```
> 
> Replica il bit di segno.
> 
> È adatto ai numeri signed.
> 
> Quindi:
> 
> - `srl` non conserva il segno;
>     
> - `sra` conserva il segno.
>     

---

## 36. Come si estrae un bit da un numero?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Per estrarre il bit `k`:
> 
> ```text
> bit = (x >> k) & 1
> ```
> 
> In RISC-V:
> 
> ```asm
> srli t0, x, k
> andi t0, t0, 1
> ```
> 
> Prima sposti il bit desiderato in posizione 0, poi mascheri tutto il resto con `andi`.

---

## 37. Come si mette a 1, a 0 o si inverte un bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Per mettere a 1 il bit `k`:
> 
> ```text
> x = x | (1 << k)
> ```
> 
> Per mettere a 0 il bit `k`:
> 
> ```text
> x = x & ~(1 << k)
> ```
> 
> Per invertire il bit `k`:
> 
> ```text
> x = x ^ (1 << k)
> ```
> 
> Operazioni utili:
> 
> - AND per azzerare bit;
>     
> - OR per mettere bit a 1;
>     
> - XOR per invertire bit.
>     

---

## 38. Quali registri RISC-V sono usati per argomenti e valori di ritorno?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> I registri per argomenti e valori di ritorno sono:
> 
> ```asm
> a0-a7
> ```
> 
> In particolare:
> 
> - `a0` contiene il primo argomento;
>     
> - `a1` contiene il secondo argomento;
>     
> - `a0` contiene anche il valore di ritorno;
>     
> - `a1` può contenere un secondo valore di ritorno in alcuni casi.
>     
> 
> Attenzione: dopo una chiamata a funzione, i registri `a` possono essere sovrascritti.

---

## 39. Che differenza c’è tra registri t e registri s in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> I registri `t0-t6` sono temporanei.
> 
> Sono caller-saved:
> 
> ```text
> chi chiama deve salvarli se vuole conservarli
> ```
> 
> I registri `s0-s11` sono registri salvati.
> 
> Sono callee-saved:
> 
> ```text
> la funzione chiamata deve salvarli e ripristinarli se li modifica
> ```
> 
> Regola pratica:
> 
> se un valore deve sopravvivere a una `jal`, conviene salvarlo in un registro `s` oppure nello stack.

---

## 40. Quando bisogna salvare ra nello stack?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Bisogna salvare `ra` quando una funzione chiama un’altra funzione con `jal`.
> 
> Questo perché `jal` sovrascrive `ra` con il nuovo indirizzo di ritorno.
> 
> Se non salvi `ra`, perdi l’indirizzo corretto per tornare al chiamante originale.
> 
> Prologo tipico:
> 
> ```asm
> addi sp, sp, -16
> sw ra, 0(sp)
> sw s0, 4(sp)
> sw s1, 8(sp)
> sw s2, 12(sp)
> ```
> 
> Epilogo tipico:
> 
> ```asm
> lw ra, 0(sp)
> lw s0, 4(sp)
> lw s1, 8(sp)
> lw s2, 12(sp)
> addi sp, sp, 16
> ret
> ```

---

## 41. Come funziona lo stack in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Lo stack cresce verso indirizzi più bassi.
> 
> Per allocare spazio:
> 
> ```asm
> addi sp, sp, -N
> ```
> 
> Per liberare spazio:
> 
> ```asm
> addi sp, sp, N
> ```
> 
> Se devo salvare 4 registri word:
> 
> ```text
> 4 registri × 4 byte = 16 byte
> ```
> 
> quindi:
> 
> ```asm
> addi sp, sp, -16
> ```
> 
> Alla fine devo sempre ripristinare `sp`, altrimenti lo stack rimane corrotto.

---

## 42. Come funzionano i branch signed e unsigned in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> I branch signed sono:
> 
> ```asm
> blt rs1, rs2, label
> bge rs1, rs2, label
> ```
> 
> Interpretano i valori come signed.
> 
> I branch unsigned sono:
> 
> ```asm
> bltu rs1, rs2, label
> bgeu rs1, rs2, label
> ```
> 
> Interpretano i valori come unsigned.
> 
> Uguaglianza e disuguaglianza:
> 
> ```asm
> beq rs1, rs2, label
> bne rs1, rs2, label
> ```
> 
> Per `beq` e `bne` non cambia signed/unsigned, perché confrontano solo se i bit sono uguali o diversi.

---

## 43. Che differenza c’è tra slt e sltu?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> `slt` fa un confronto signed:
> 
> ```asm
> slt rd, rs1, rs2
> ```
> 
> Mette:
> 
> ```text
> rd = 1 se rs1 < rs2 signed
> rd = 0 altrimenti
> ```
> 
> `sltu` fa un confronto unsigned:
> 
> ```asm
> sltu rd, rs1, rs2
> ```
> 
> Mette:
> 
> ```text
> rd = 1 se rs1 < rs2 unsigned
> rd = 0 altrimenti
> ```
> 
> Tranello:
> 
> ```text
> 0xFFFFFFFF signed = -1
> 0xFFFFFFFF unsigned = 4294967295
> ```
> 
> Quindi `-1 < 1` è vero signed, ma falso unsigned.

---

## 44. Come si realizza la sottrazione in una ALU usando l’addizione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La sottrazione si può realizzare usando l’addizione in complemento a 2:
> 
> ```text
> A - B = A + NOT(B) + 1
> ```
> 
> In hardware:
> 
> - si inverte B;
>     
> - si mette il carry-in iniziale a 1;
>     
> - si usa lo stesso sommatore dell’addizione.
>     
> 
> Per questo in molte ALU il segnale di controllo della sottrazione attiva sia l’inversione di B sia il carry-in a 1.

---

## 45. Come si implementa correttamente SLT signed in una ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Per implementare `slt` signed, l’ALU calcola concettualmente:
> 
> ```text
> A - B
> ```
> 
> Poi deve capire se:
> 
> ```text
> A < B
> ```
> 
> Però non basta guardare sempre il bit di segno del risultato, perché può esserci overflow.
> 
> La regola corretta è:
> 
> ```text
> less = sign_result XOR overflow
> ```
> 
> Dove:
> 
> ```text
> sign_result = bit di segno del risultato A - B
> overflow = overflow della sottrazione signed
> ```
> 
> Questo evita errori nei casi in cui la sottrazione va in overflow.

---

## 46. Che differenza c’è tra polling, interrupt e DMA?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Nel polling, la CPU controlla continuamente se il dispositivo è pronto.
> 
> ```text
> CPU → controlla dispositivo → controlla dispositivo → controlla dispositivo
> ```
> 
> Svantaggio: spreca tempo CPU.
> 
> Con interrupt, il dispositivo avvisa la CPU quando ha bisogno di attenzione.
> 
> ```text
> dispositivo → interrupt → CPU
> ```
> 
> Con DMA, un dispositivo trasferisce direttamente blocchi di dati da/per memoria senza coinvolgere la CPU per ogni word.
> 
> Schema:
> 
> ```text
> CPU configura DMA
> DMA trasferisce dati
> DMA avvisa la CPU quando ha finito
> ```

---

## 47. Come si calcola il tempo di trasferimento di dati in I/O?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La formula generale è:
> 
> ```text
> tempo = quantità dati / bandwidth
> ```
> 
> Dove:
> 
> ```text
> quantità dati = dimensione del trasferimento
> bandwidth = velocità di trasferimento
> ```
> 
> Esempio:
> 
> ```text
> dati = 100 MB
> bandwidth = 50 MB/s
> ```
> 
> Allora:
> 
> ```text
> tempo = 100 / 50 = 2 s
> ```

---

## 48. Come si calcola un tempo totale composto da latenza e trasferimento?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Spesso il tempo totale è:
> 
> ```text
> tempo totale = latenza + tempo di trasferimento
> ```
> 
> Poiché:
> 
> ```text
> tempo di trasferimento = quantità dati / bandwidth
> ```
> 
> allora:
> 
> ```text
> tempo totale = latenza + quantità dati / bandwidth
> ```
> 
> Questa formula è utile per I/O, dischi, bus e trasferimenti in memoria.

---

## 49. Come si calcola il numero di bit necessari per rappresentare N valori?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Per rappresentare `N` valori diversi servono:
> 
> ```text
> bit = ceil(log2(N))
> ```
> 
> Esempi:
> 
> ```text
> N = 8 valori → log2(8) = 3 bit
> N = 9 valori → ceil(log2(9)) = 4 bit
> ```
> 
> Se il numero di valori non è una potenza di 2, bisogna arrotondare per eccesso.

---

## 50. Quali sono le formule più importanti da ricordare per l’esame?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Le formule fondamentali sono:
> 
> ```text
> Tclock = 1 / frequenza
> ```
> 
> ```text
> cicli totali = IC × CPI
> ```
> 
> ```text
> CPU time = IC × CPI × Tclock
> ```
> 
> ```text
> CPU time = (IC × CPI) / frequenza
> ```
> 
> ```text
> CPI medio = Σ(percentuale_i × CPI_i)
> ```
> 
> ```text
> MIPS = frequenza / (CPI × 10^6)
> ```
> 
> ```text
> speedup = tempo vecchio / tempo nuovo
> ```
> 
> ```text
> speedup Amdahl = 1 / [(1 - f) + f/S]
> ```
> 
> ```text
> AMAT = hit time + miss rate × miss penalty
> ```
> 
> ```text
> CPI reale = CPI base + accessi_memoria_per_istruzione × miss_rate × miss_penalty
> ```
> 
> ```text
> bit offset = log2(dimensione blocco)
> ```
> 
> ```text
> bit index = log2(numero linee o numero set)
> ```
> 
> ```text
> bit tag = bit indirizzo - bit index - bit offset
> ```
> 
> ```text
> capacità memoria = 2^(bit indirizzo) byte
> ```
> 
> ```text
> range unsigned = 0 ... 2^n - 1
> ```
> 
> ```text
> range signed = -2^(n-1) ... 2^(n-1)-1
> ```

---

## 51. Qual è la checklist anti-fregatura per gli esercizi?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Prima di rispondere, controlla:
> 
> 1. La frequenza è in Hz, MHz o GHz?
>     
> 2. Il tempo richiesto è in secondi, millisecondi o nanosecondi?
>     
> 3. Il CPI è già medio o va calcolato?
>     
> 4. Le percentuali sono state convertite in decimali?
>     
> 5. Sto confrontando tempi o prestazioni?
>     
> 6. Lo speedup è `tempo vecchio / tempo nuovo`?
>     
> 7. Il numero è signed o unsigned?
>     
> 8. Sto usando `lb/lh` o `lbu/lhu`?
>     
> 9. La memoria è little endian?
>     
> 10. L’array è di byte o word?
>     
> 11. Devo moltiplicare l’indice per 4?
>     
> 12. La cache è direct mapped o set-associative?
>     
> 13. L’index usa il numero di linee o il numero di set?
>     
> 14. Il miss rate è percentuale o decimale?
>     
> 15. Il risultato richiesto è in decimale, binario o esadecimale?


## 52. Quali sono i segnali di controllo principali nel datapath RISC-V monociclo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I segnali di controllo principali sono:
>
> ```text
> RegWrite  = abilita la scrittura nel register file
> ALUSrc    = sceglie il secondo operando della ALU
> MemRead   = abilita la lettura dalla memoria dati
> MemWrite  = abilita la scrittura nella memoria dati
> MemToReg  = sceglie cosa scrivere nel registro destinazione
> Branch    = indica che l’istruzione è un branch
> ALUOp     = dice alla ALU che tipo generale di operazione fare
> ```
>
> Significato pratico:
>
> - `RegWrite = 1` quando l’istruzione scrive un registro;
> - `ALUSrc = 1` quando il secondo operando ALU viene dall’immediato;
> - `MemRead = 1` per le load;
> - `MemWrite = 1` per le store;
> - `MemToReg = 1` quando nel registro va scritto il dato letto dalla memoria;
> - `Branch = 1` per i salti condizionati;
> - `ALUOp` viene poi combinato con `funct3/funct7` per decidere l’operazione precisa della ALU.

---

## 53. Quali sono i segnali di controllo per un’istruzione R-type?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni R-type fanno operazioni tra due registri e scrivono il risultato in un registro.
>
> Esempi:
>
> ```asm
> add rd, rs1, rs2
> sub rd, rs1, rs2
> and rd, rs1, rs2
> or  rd, rs1, rs2
> slt rd, rs1, rs2
> ```
>
> Segnali tipici:
>
> ```text
> RegWrite = 1
> ALUSrc   = 0
> MemRead  = 0
> MemWrite = 0
> MemToReg = 0
> Branch   = 0
> ALUOp    = 10
> ```
>
> Spiegazione:
>
> - scrive un registro, quindi `RegWrite = 1`;
> - il secondo operando ALU viene da `rs2`, quindi `ALUSrc = 0`;
> - non legge né scrive memoria dati;
> - il valore scritto nel registro viene dalla ALU, quindi `MemToReg = 0`;
> - non è un branch;
> - `ALUOp = 10` indica che l’operazione precisa dipende da `funct3/funct7`.

---

## 54. Quali sono i segnali di controllo per una load, ad esempio lw?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una load legge dalla memoria e scrive il dato letto in un registro.
>
> Esempio:
>
> ```asm
> lw rd, offset(rs1)
> ```
>
> Segnali tipici:
>
> ```text
> RegWrite = 1
> ALUSrc   = 1
> MemRead  = 1
> MemWrite = 0
> MemToReg = 1
> Branch   = 0
> ALUOp    = 00
> ```
>
> Spiegazione:
>
> - scrive in `rd`, quindi `RegWrite = 1`;
> - la ALU calcola l’indirizzo `rs1 + offset`, quindi usa l’immediato: `ALUSrc = 1`;
> - legge dalla memoria: `MemRead = 1`;
> - non scrive in memoria: `MemWrite = 0`;
> - nel registro va scritto il dato letto dalla memoria: `MemToReg = 1`;
> - non è un branch;
> - la ALU deve fare una somma, quindi `ALUOp = 00`.

---

## 55. Quali sono i segnali di controllo per una store, ad esempio sw?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una store scrive in memoria un valore preso da un registro.
>
> Esempio:
>
> ```asm
> sw rs2, offset(rs1)
> ```
>
> Segnali tipici:
>
> ```text
> RegWrite = 0
> ALUSrc   = 1
> MemRead  = 0
> MemWrite = 1
> MemToReg = X
> Branch   = 0
> ALUOp    = 00
> ```
>
> Spiegazione:
>
> - non scrive nessun registro, quindi `RegWrite = 0`;
> - la ALU calcola l’indirizzo `rs1 + offset`, quindi `ALUSrc = 1`;
> - non legge dalla memoria dati;
> - scrive nella memoria dati: `MemWrite = 1`;
> - `MemToReg` è indifferente perché non si scrive nel register file;
> - non è un branch;
> - la ALU deve fare una somma, quindi `ALUOp = 00`.

---

## 56. Quali sono i segnali di controllo per un branch, ad esempio beq?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un branch confronta due registri e, se la condizione è vera, aggiorna il PC con l’indirizzo di salto.
>
> Esempio:
>
> ```asm
> beq rs1, rs2, label
> ```
>
> Segnali tipici:
>
> ```text
> RegWrite = 0
> ALUSrc   = 0
> MemRead  = 0
> MemWrite = 0
> MemToReg = X
> Branch   = 1
> ALUOp    = 01
> ```
>
> Spiegazione:
>
> - non scrive registri;
> - confronta due registri, quindi `ALUSrc = 0`;
> - non legge né scrive memoria dati;
> - `MemToReg` è indifferente;
> - è un branch, quindi `Branch = 1`;
> - la ALU viene usata per confrontare, spesso facendo `rs1 - rs2`, quindi `ALUOp = 01`.

---

## 57. Quali sono i segnali di controllo per un’I-type aritmetico, ad esempio addi?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un’I-type aritmetico usa un registro e un immediato, poi scrive il risultato in un registro.
>
> Esempio:
>
> ```asm
> addi rd, rs1, imm
> ```
>
> Segnali tipici:
>
> ```text
> RegWrite = 1
> ALUSrc   = 1
> MemRead  = 0
> MemWrite = 0
> MemToReg = 0
> Branch   = 0
> ALUOp    = 10 oppure codice dedicato, dipende dal datapath
> ```
>
> Spiegazione:
>
> - scrive in `rd`, quindi `RegWrite = 1`;
> - il secondo operando ALU è l’immediato, quindi `ALUSrc = 1`;
> - non accede alla memoria dati;
> - il valore scritto viene dalla ALU, quindi `MemToReg = 0`;
> - non è un branch.
>
> Nota importante: nei datapath didattici base spesso `ALUOp = 10` indica “guarda funct3/funct7”. Per gli I-type aritmetici può servire una logica di controllo leggermente estesa rispetto alla tabella base `R-type/lw/sw/beq`.

---

## 58. Tabella riassuntiva dei segnali di controllo principali

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Tabella tipica per datapath monociclo:
>
> ```text
> Istruzione | RegWrite | ALUSrc | MemRead | MemWrite | MemToReg | Branch | ALUOp
> ----------|----------|--------|---------|----------|----------|--------|------
> R-type    |    1     |   0    |    0    |    0     |    0     |   0    |  10
> lw        |    1     |   1    |    1    |    0     |    1     |   0    |  00
> sw        |    0     |   1    |    0    |    1     |    X     |   0    |  00
> beq       |    0     |   0    |    0    |    0     |    X     |   1    |  01
> addi      |    1     |   1    |    0    |    0     |    0     |   0    |  10*
> ```
>
> Dove:
>
> ```text
> X = don't care, cioè il valore non importa
> ```
>
> Nota su `addi`:
>
> ```text
> ALUOp = 10* dipende dal datapath didattico usato.
> ```
>
> Nei datapath più completi, gli I-type aritmetici hanno una gestione specifica tramite opcode e funct3.

---

## 59. Perché per lw e sw ALUSrc vale 1?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Per `lw` e `sw`, la ALU serve a calcolare l’indirizzo effettivo di memoria.
>
> L’indirizzo si calcola così:
>
> ```text
> indirizzo = contenuto di rs1 + immediato
> ```
>
> Esempio:
>
> ```asm
> lw t0, 8(s1)
> ```
>
> Qui l’indirizzo è:
>
> ```text
> s1 + 8
> ```
>
> Quindi il secondo operando della ALU non viene da `rs2`, ma dall’immediato.
>
> Per questo:
>
> ```text
> ALUSrc = 1
> ```

---

## 60. Perché per R-type ALUSrc vale 0?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni R-type usano due registri come operandi.
>
> Esempio:
>
> ```asm
> add rd, rs1, rs2
> ```
>
> La ALU riceve:
>
> ```text
> primo operando = rs1
> secondo operando = rs2
> ```
>
> Quindi il secondo operando non è un immediato.
>
> Per questo:
>
> ```text
> ALUSrc = 0
> ```

---

## 61. Perché per lw MemToReg vale 1, mentre per R-type vale 0?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `MemToReg` controlla il mux che sceglie cosa scrivere nel registro destinazione.
>
> Per una `lw`:
>
> ```asm
> lw rd, offset(rs1)
> ```
>
> il valore da scrivere in `rd` arriva dalla memoria dati.
>
> Quindi:
>
> ```text
> MemToReg = 1
> ```
>
> Per una R-type:
>
> ```asm
> add rd, rs1, rs2
> ```
>
> il valore da scrivere in `rd` arriva dalla ALU.
>
> Quindi:
>
> ```text
> MemToReg = 0
> ```

---

## 62. Perché per sw RegWrite vale 0 e MemWrite vale 1?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una `sw` scrive un valore in memoria, non in un registro.
>
> Esempio:
>
> ```asm
> sw rs2, offset(rs1)
> ```
>
> Significa:
>
> ```text
> memoria[rs1 + offset] = rs2
> ```
>
> Quindi:
>
> ```text
> RegWrite = 0
> ```
>
> perché nessun registro viene scritto.
>
> ```text
> MemWrite = 1
> ```
>
> perché viene scritta la memoria dati.

---

## 63. Perché per beq Branch vale 1 e RegWrite vale 0?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `beq` è un salto condizionato.
>
> Esempio:
>
> ```asm
> beq rs1, rs2, label
> ```
>
> Significa:
>
> ```text
> se rs1 == rs2, allora PC = indirizzo del branch
> ```
>
> Non scrive nessun registro, quindi:
>
> ```text
> RegWrite = 0
> ```
>
> È un branch, quindi:
>
> ```text
> Branch = 1
> ```
>
> La ALU viene spesso usata per sottrarre:
>
> ```text
> rs1 - rs2
> ```
>
> Se il risultato è zero, il branch viene preso.


## 64. Come si interpreta un circuito ALU a più bit come quello dello screenshot?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un’ALU a più bit è costruita collegando più ALU a 1 bit in cascata.
>
> Ogni blocco ALU a 1 bit calcola un bit del risultato.
>
> Per una ALU a 4 bit:
>
> ```text
> ALU bit 0 → produce Result[0]
> ALU bit 1 → produce Result[1]
> ALU bit 2 → produce Result[2]
> ALU bit 3 → produce Result[3]
> ```
>
> I segnali di controllo come `Ainvert`, `Binvert`, `CarryIn` e `Operation` decidono quale operazione viene eseguita.
>
> Il `CarryOut` di un bit entra come `CarryIn` del bit successivo.
>
> Esempio:
>
> ```text
> CarryOut bit 0 → CarryIn bit 1
> CarryOut bit 1 → CarryIn bit 2
> CarryOut bit 2 → CarryIn bit 3
> ```
>
> Questa struttura serve per fare somme, sottrazioni e confronti bit per bit.

---

## 65. Come si legge il valore di Result in una ALU a 4 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `Result` è il risultato prodotto dalla ALU.
>
> In una ALU a 4 bit, ogni ALU a 1 bit produce un singolo bit:
>
> ```text
> Result[0]
> Result[1]
> Result[2]
> Result[3]
> ```
>
> Il risultato finale è la concatenazione di questi bit:
>
> ```text
> Result = Result[3] Result[2] Result[1] Result[0]
> ```
>
> Attenzione all’ordine:
>
> - il bit 0 è il meno significativo;
> - il bit 3 è il più significativo;
> - quando scrivi il numero in binario, il bit più significativo va a sinistra.
>
> Quindi se:
>
> ```text
> Result[3] = 0
> Result[2] = 1
> Result[1] = 0
> Result[0] = 1
> ```
>
> allora:
>
> ```text
> Result = 0101
> ```

---

## 66. Come si calcola il segnale Zero in una ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il segnale `Zero` vale 1 quando tutti i bit di `Result` sono 0.
>
> Cioè:
>
> ```text
> Result = 0000 → Zero = 1
> ```
>
> Se anche un solo bit del risultato vale 1:
>
> ```text
> Result ≠ 0000 → Zero = 0
> ```
>
> In hardware spesso si fa con una OR di tutti i bit del risultato seguita da una NOT.
>
> Formula logica:
>
> ```text
> Zero = NOT(Result[0] OR Result[1] OR Result[2] OR Result[3])
> ```
>
> Esempi:
>
> ```text
> Result = 0000 → Zero = 1
> Result = 0001 → Zero = 0
> Result = 0100 → Zero = 0
> Result = 1111 → Zero = 0
> ```

---

## 67. Come si calcola Overflow in una somma signed?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nell’addizione signed, overflow avviene quando sommi due numeri con lo stesso segno e ottieni un risultato con segno diverso.
>
> Casi di overflow:
>
> ```text
> positivo + positivo = negativo
> negativo + negativo = positivo
> ```
>
> Casi senza overflow:
>
> ```text
> positivo + negativo → mai overflow
> negativo + positivo → mai overflow
> ```
>
> Formula pratica con i bit di segno:
>
> ```text
> Overflow = 1 se A e B hanno stesso segno e Result ha segno diverso
> ```
>
> In una ALU a 4 bit, il bit di segno è il bit 3:
>
> ```text
> A[3], B[3], Result[3]
> ```

---

## 68. Come si calcola Overflow usando i carry nella ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una somma signed in complemento a 2:
>
> ```text
> Overflow = CarryIn del bit più significativo XOR CarryOut del bit più significativo
> ```
>
> In una ALU a 4 bit, il bit più significativo è il bit 3.
>
> Quindi:
>
> ```text
> Overflow = CarryIn_bit3 XOR CarryOut_bit3
> ```
>
> Se i due carry sono uguali:
>
> ```text
> 0 XOR 0 = 0
> 1 XOR 1 = 0
> ```
>
> non c’è overflow.
>
> Se sono diversi:
>
> ```text
> 0 XOR 1 = 1
> 1 XOR 0 = 1
> ```
>
> allora c’è overflow.

---

## 69. Come si interpreta ALU operation = 000 nel circuito ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei datapath didattici, spesso `ALU operation = 000` indica l’operazione AND.
>
> Quindi:
>
> ```text
> Result = A AND B
> ```
>
> L’AND lavora bit per bit.
>
> Esempio:
>
> ```text
> A = 1010
> B = 1100
> ```
>
> Allora:
>
> ```text
> Result = 1000
> ```
>
> Per ogni bit:
>
> ```text
> 1 AND 1 = 1
> 1 AND 0 = 0
> 0 AND 1 = 0
> 0 AND 0 = 0
> ```
>
> In questo caso `Overflow` normalmente vale 0, perché l’overflow riguarda operazioni aritmetiche signed come somma e sottrazione, non AND.
>
> `Zero` vale 1 solo se il risultato è `0000`.

---

## 70. Come si interpreta ALU operation = 001 nel circuito ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei datapath didattici, spesso `ALU operation = 001` indica l’operazione OR.
>
> Quindi:
>
> ```text
> Result = A OR B
> ```
>
> L’OR lavora bit per bit.
>
> Esempio:
>
> ```text
> A = 1010
> B = 1100
> ```
>
> Allora:
>
> ```text
> Result = 1110
> ```
>
> Per ogni bit:
>
> ```text
> 1 OR 1 = 1
> 1 OR 0 = 1
> 0 OR 1 = 1
> 0 OR 0 = 0
> ```
>
> Anche qui `Overflow` normalmente vale 0.
>
> `Zero` vale 1 solo se il risultato finale è `0000`.

---

## 71. Come si interpreta ALU operation = 010 nel circuito ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei datapath didattici, spesso `ALU operation = 010` indica l’addizione.
>
> Quindi:
>
> ```text
> Result = A + B
> ```
>
> La somma viene fatta bit per bit propagando il carry:
>
> ```text
> CarryOut bit 0 → CarryIn bit 1
> CarryOut bit 1 → CarryIn bit 2
> CarryOut bit 2 → CarryIn bit 3
> ```
>
> Per determinare le uscite:
>
> 1. Calcoli la somma binaria.
> 2. Tieni solo i bit disponibili, ad esempio 4 bit.
> 3. `Result` è il risultato troncato a 4 bit.
> 4. `Zero = 1` se `Result = 0000`.
> 5. `Overflow = 1` solo se c’è overflow signed.
>
> Esempio a 4 bit:
>
> ```text
> A = 0111 = +7
> B = 0001 = +1
> ```
>
> Somma:
>
> ```text
> 0111 + 0001 = 1000
> ```
>
> Interpretato signed a 4 bit:
>
> ```text
> +7 + +1 = -8
> ```
>
> Quindi:
>
> ```text
> Result = 1000
> Zero = 0
> Overflow = 1
> ```

---

## 72. Come si interpreta ALU operation = 110 nel circuito ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei datapath didattici, spesso `ALU operation = 110` indica la sottrazione.
>
> Quindi:
>
> ```text
> Result = A - B
> ```
>
> La sottrazione viene realizzata come:
>
> ```text
> A - B = A + NOT(B) + 1
> ```
>
> In hardware:
>
> - `Binvert = 1`;
> - il carry-in iniziale vale 1;
> - si usa lo stesso sommatore dell’addizione.
>
> Per determinare le uscite:
>
> 1. Calcoli `A - B`.
> 2. Scrivi il risultato in complemento a 2 usando i bit disponibili.
> 3. `Zero = 1` se il risultato è `0000`.
> 4. `Overflow = 1` se c’è overflow signed nella sottrazione.
>
> Esempio:
>
> ```text
> A = 0011 = +3
> B = 0011 = +3
> ```
>
> ```text
> A - B = 0
> ```
>
> Quindi:
>
> ```text
> Result = 0000
> Zero = 1
> Overflow = 0
> ```

---

## 73. Come si interpreta ALU operation = 111 nel circuito ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei datapath didattici, spesso `ALU operation = 111` indica `slt`, cioè set less than.
>
> Significa:
>
> ```text
> Result = 0001 se A < B
> Result = 0000 altrimenti
> ```
>
> Per `slt` signed, il confronto va fatto interpretando A e B come numeri signed in complemento a 2.
>
> L’ALU di solito calcola:
>
> ```text
> A - B
> ```
>
> Poi usa il segnale `less` per mettere a 1 solo il bit meno significativo del risultato.
>
> Esempio signed a 4 bit:
>
> ```text
> A = 1111 = -1
> B = 0001 = +1
> ```
>
> Poiché:
>
> ```text
> -1 < +1
> ```
>
> allora:
>
> ```text
> Result = 0001
> Zero = 0
> ```
>
> Se invece:
>
> ```text
> A = 0011 = +3
> B = 1011 = -5
> ```
>
> allora:
>
> ```text
> +3 < -5 è falso
> ```
>
> quindi:
>
> ```text
> Result = 0000
> Zero = 1
> ```

---

## 74. Come si determina Result, Zero e Overflow dato un opcode della ALU?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Procedura da seguire:
>
> 1. Capisci quale operazione indica il codice ALU.
>
> ```text
> 000 → AND
> 001 → OR
> 010 → ADD
> 110 → SUB
> 111 → SLT
> ```
>
> 2. Applica l’operazione agli ingressi `A` e `B`.
>
> 3. Scrivi il risultato sui bit disponibili, ad esempio 4 bit.
>
> 4. Calcola `Zero`:
>
> ```text
> Zero = 1 se Result = 0000
> Zero = 0 se Result ≠ 0000
> ```
>
> 5. Calcola `Overflow` solo per operazioni aritmetiche signed:
>
> ```text
> ADD
> SUB
> SLT, se internamente usa A - B
> ```
>
> Per AND e OR, normalmente:
>
> ```text
> Overflow = 0
> ```

---

## 75. Esempio: se A = 0000, B = 0000 e ALU operation = 000, quali sono Result, Zero e Overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `ALU operation = 000` indica normalmente AND.
>
> Quindi:
>
> ```text
> Result = A AND B
> ```
>
> Con:
>
> ```text
> A = 0000
> B = 0000
> ```
>
> ottieni:
>
> ```text
> Result = 0000
> ```
>
> Siccome il risultato è tutto zero:
>
> ```text
> Zero = 1
> ```
>
> L’AND non è un’operazione aritmetica signed, quindi:
>
> ```text
> Overflow = 0
> ```
>
> Risultato finale:
>
> ```text
> Result = 0000
> Zero = 1
> Overflow = 0
> ```

---

## 76. Esempio: se A = 0011, B = 0101 e ALU operation = 010, quali sono Result, Zero e Overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `ALU operation = 010` indica normalmente ADD.
>
> Quindi:
>
> ```text
> Result = A + B
> ```
>
> Con:
>
> ```text
> A = 0011 = +3
> B = 0101 = +5
> ```
>
> Somma:
>
> ```text
> 0011 + 0101 = 1000
> ```
>
> A 4 bit:
>
> ```text
> Result = 1000
> ```
>
> Siccome il risultato non è zero:
>
> ```text
> Zero = 0
> ```
>
> Interpretando signed:
>
> ```text
> +3 + +5 = +8
> ```
>
> Ma a 4 bit signed il massimo è:
>
> ```text
> +7
> ```
>
> quindi c’è overflow:
>
> ```text
> Overflow = 1
> ```
>
> Risultato finale:
>
> ```text
> Result = 1000
> Zero = 0
> Overflow = 1
> ```

---

## 77. Esempio: se A = 0100, B = 0100 e ALU operation = 110, quali sono Result, Zero e Overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `ALU operation = 110` indica normalmente SUB.
>
> Quindi:
>
> ```text
> Result = A - B
> ```
>
> Con:
>
> ```text
> A = 0100 = +4
> B = 0100 = +4
> ```
>
> Sottrazione:
>
> ```text
> +4 - +4 = 0
> ```
>
> Quindi:
>
> ```text
> Result = 0000
> ```
>
> Siccome il risultato è zero:
>
> ```text
> Zero = 1
> ```
>
> Non c’è overflow:
>
> ```text
> Overflow = 0
> ```
>
> Risultato finale:
>
> ```text
> Result = 0000
> Zero = 1
> Overflow = 0
> ```

---

## 78. Esempio: se A = 0111, B = 1111 e ALU operation = 010, quali sono Result, Zero e Overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `ALU operation = 010` indica ADD.
>
> Quindi:
>
> ```text
> Result = A + B
> ```
>
> Interpretando signed a 4 bit:
>
> ```text
> A = 0111 = +7
> B = 1111 = -1
> ```
>
> Somma:
>
> ```text
> +7 + (-1) = +6
> ```
>
> In binario:
>
> ```text
> 0111 + 1111 = 0110
> ```
>
> il carry finale viene scartato perché il risultato è a 4 bit.
>
> Quindi:
>
> ```text
> Result = 0110
> Zero = 0
> Overflow = 0
> ```
>
> Non c’è overflow perché stai sommando numeri di segno diverso.

---

## 79. Esempio: se A = 0111, B = 1111 e ALU operation = 110, quali sono Result, Zero e Overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `ALU operation = 110` indica SUB.
>
> Quindi:
>
> ```text
> Result = A - B
> ```
>
> Interpretando signed a 4 bit:
>
> ```text
> A = 0111 = +7
> B = 1111 = -1
> ```
>
> Quindi:
>
> ```text
> A - B = +7 - (-1) = +8
> ```
>
> Però a 4 bit signed il massimo rappresentabile è:
>
> ```text
> +7
> ```
>
> quindi il risultato va in overflow.
>
> A 4 bit il risultato diventa:
>
> ```text
> Result = 1000
> ```
>
> Quindi:
>
> ```text
> Result = 1000
> Zero = 0
> Overflow = 1
> ```

---

## 80. Esempio: se A = 0011, B = 1011 e ALU operation = 111, quali sono Result, Zero e Overflow?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `ALU operation = 111` indica normalmente `slt`.
>
> Quindi:
>
> ```text
> Result = 0001 se A < B
> Result = 0000 altrimenti
> ```
>
> Interpretando signed a 4 bit:
>
> ```text
> A = 0011 = +3
> B = 1011 = -5
> ```
>
> La domanda è:
>
> ```text
> +3 < -5 ?
> ```
>
> La risposta è no.
>
> Quindi:
>
> ```text
> Result = 0000
> ```
>
> Siccome il risultato è zero:
>
> ```text
> Zero = 1
> ```
>
> Per `slt`, l’overflow dipende dall’implementazione interna, perché spesso viene calcolato facendo `A - B`.
>
> Però l’uscita principale da ricordare è:
>
> ```text
> Result = 0000
> Zero = 1
> ```
>
> Se il circuito espone anche l’overflow della sottrazione interna, va calcolato su:
>
> ```text
> A - B
> ```

---

## 81. Qual è la tabella rapida delle operazioni ALU più comuni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei circuiti didattici basati sull’ALU del Patterson-Hennessy, la tabella tipica è:
>
> ```text
> ALU operation | Operazione | Significato
> --------------|------------|----------------
> 000           | AND        | A AND B
> 001           | OR         | A OR B
> 010           | ADD        | A + B
> 110           | SUB        | A - B
> 111           | SLT        | set less than
> ```
>
> Da questa tabella si ricavano poi:
>
> ```text
> Result = risultato dell’operazione
> Zero = 1 se Result è tutto zero
> Overflow = 1 solo se c’è overflow signed aritmetico
> ```
>
> Per AND e OR:
>
> ```text
> Overflow = 0
> ```
>
> Per ADD e SUB bisogna controllare l’overflow signed.