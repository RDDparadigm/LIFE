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
> Dove:
>
> ```text
> frequenza = cicli al secondo
> Tclock = durata di un ciclo
> ```
>
> Se la frequenza è in Hz, il periodo viene in secondi.
>
> Esempio:
>
> ```text
> f = 2 GHz
> ```
>
> Prima converto:
>
> ```text
> 2 GHz = 2 × 10^9 Hz
> ```
>
> Poi:
>
> ```text
> Tclock = 1 / (2 × 10^9) s
> ```
>
> Separando:
>
> ```text
> Tclock = 0,5 × 10^-9 s
> ```
>
> Poiché:
>
> ```text
> 1 ns = 10^-9 s
> ```
>
> allora:
>
> ```text
> Tclock = 0,5 ns
> ```
>
> Scorciatoia utile:
>
> ```text
> Tclock in ns = 1 / frequenza in GHz
> ```
>
> Quindi:
>
> ```text
> 2 GHz → 1/2 ns = 0,5 ns
> ```

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
> Siccome:
>
> ```text
> Tclock = 1 / frequenza
> ```
>
> allora puoi anche usare:
>
> ```text
> CPU time = (IC × CPI) / frequenza
> ```
>
> Esempio:
>
> ```text
> IC = 6 × 10^9 istruzioni
> CPI = 2
> frequenza = 1,5 GHz = 1,5 × 10^9 Hz
> ```
>
> Sostituisco:
>
> ```text
> CPU time = (6 × 10^9 × 2) / (1,5 × 10^9)
> ```
>
> Calcolo:
>
> ```text
> CPU time = (12 × 10^9) / (1,5 × 10^9)
> ```
>
> I `10^9` si semplificano:
>
> ```text
> CPU time = 12 / 1,5 = 8 s
> ```
>
> Quindi il tempo di esecuzione è:
>
> ```text
> 8 secondi
> ```

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
> Poi, se vuoi il tempo:
>
> ```text
> tempo = cicli totali / frequenza
> ```
>
> oppure:
>
> ```text
> tempo = cicli totali × Tclock
> ```
>
> Esempio:
>
> ```text
> IC = 5 × 10^9 istruzioni
> CPI = 3
> frequenza = 2 GHz
> ```
>
> Prima calcolo i cicli totali:
>
> ```text
> cicli totali = 5 × 10^9 × 3
> cicli totali = 15 × 10^9 cicli
> ```
>
> Poi calcolo il tempo:
>
> ```text
> tempo = (15 × 10^9) / (2 × 10^9)
> ```
>
> Semplifico:
>
> ```text
> tempo = 15 / 2 = 7,5 s
> ```
>
> Quindi:
>
> ```text
> cicli totali = 15 × 10^9
> tempo = 7,5 secondi
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
> Le percentuali vanno convertite in numeri decimali.
>
> Esempio:
>
> ```text
> 50% istruzioni ALU, CPI = 1
> 30% istruzioni load/store, CPI = 2
> 20% istruzioni branch, CPI = 3
> ```
>
> Converto le percentuali:
>
> ```text
> 50% = 0,5
> 30% = 0,3
> 20% = 0,2
> ```
>
> Applico la formula:
>
> ```text
> CPI medio = 0,5 × 1 + 0,3 × 2 + 0,2 × 3
> ```
>
> Calcolo:
>
> ```text
> CPI medio = 0,5 + 0,6 + 0,6
> CPI medio = 1,7
> ```
>
> Quindi il CPI medio del programma è:
>
> ```text
> 1,7
> ```

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
> Esempio:
>
> ```text
> 2 × 10^9 istruzioni ALU, CPI = 1
> 1 × 10^9 istruzioni load/store, CPI = 3
> 1 × 10^9 istruzioni branch, CPI = 2
> ```
>
> Prima calcolo il totale delle istruzioni:
>
> ```text
> IC_totale = 2 × 10^9 + 1 × 10^9 + 1 × 10^9
> IC_totale = 4 × 10^9
> ```
>
> Poi calcolo i cicli totali pesati:
>
> ```text
> cicli ALU = 2 × 10^9 × 1 = 2 × 10^9
> cicli load/store = 1 × 10^9 × 3 = 3 × 10^9
> cicli branch = 1 × 10^9 × 2 = 2 × 10^9
> ```
>
> Sommo:
>
> ```text
> cicli totali = 2 × 10^9 + 3 × 10^9 + 2 × 10^9
> cicli totali = 7 × 10^9
> ```
>
> Ora:
>
> ```text
> CPI medio = (7 × 10^9) / (4 × 10^9)
> CPI medio = 7 / 4 = 1,75
> ```
>
> Quindi:
>
> ```text
> CPI medio = 1,75
> ```

---

## 6. Come si calcola il tempo di esecuzione conoscendo istruzioni, CPI e GHz?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Quando il testo dà:
>
> ```text
> numero di istruzioni
> CPI
> frequenza in GHz
> ```
>
> devi usare:
>
> ```text
> CPU time = (IC × CPI) / frequenza
> ```
>
> Ricordati di convertire i GHz in Hz:
>
> ```text
> 1 GHz = 10^9 Hz
> ```
>
> Esempio:
>
> ```text
> Un programma ha 8 × 10^9 istruzioni.
> Il processore ha CPI = 2,5.
> La frequenza è 5 GHz.
> Quanto tempo impiega?
> ```
>
> Dati:
>
> ```text
> IC = 8 × 10^9
> CPI = 2,5
> frequenza = 5 GHz = 5 × 10^9 Hz
> ```
>
> Formula:
>
> ```text
> tempo = (IC × CPI) / frequenza
> ```
>
> Sostituisco:
>
> ```text
> tempo = (8 × 10^9 × 2,5) / (5 × 10^9)
> ```
>
> Calcolo il numeratore:
>
> ```text
> 8 × 2,5 = 20
> ```
>
> Quindi:
>
> ```text
> tempo = (20 × 10^9) / (5 × 10^9)
> ```
>
> Semplifico:
>
> ```text
> tempo = 20 / 5 = 4 s
> ```
>
> Risposta:
>
> ```text
> 4 secondi
> ```
>
> Se il quiz chiede solo il numero, scrivi:
>
> ```text
> 4
> ```

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

## 82. Qual è il vantaggio principale di un’architettura a 64 bit rispetto a una a 32 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il vantaggio principale di un’architettura a 64 bit è la possibilità di indirizzare una quantità di memoria molto più grande.
>
> Con `n` bit di indirizzo, lo spazio indirizzabile è:
>
> ```text
> 2^n byte
> ```
>
> Quindi:
>
> ```text
> 32 bit → 2^32 byte = 4 GiB
> ```
>
> ```text
> 64 bit → 2^64 byte
> ```
>
> Una CPU a 64 bit può quindi gestire uno spazio di indirizzamento enormemente più grande rispetto a una CPU a 32 bit.
>
> Non è corretto dire che il vantaggio principale sia:
>
> - consumare meno energia;
> - ridurre la dimensione degli eseguibili;
> - essere più compatibile con software vecchio.

---

## 83. Perché un’architettura a 64 bit può gestire più memoria di una a 32 bit?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Perché gli indirizzi sono rappresentati con più bit.
>
> Se gli indirizzi sono lunghi 32 bit:
>
> ```text
> numero indirizzi = 2^32
> ```
>
> Se gli indirizzi sono lunghi 64 bit:
>
> ```text
> numero indirizzi = 2^64
> ```
>
> In una memoria indirizzabile a byte, ogni indirizzo identifica un byte.
>
> Quindi aumentando il numero di bit degli indirizzi aumenta enormemente la memoria indirizzabile.

---

## 84. Che cosa significa endianness?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’endianness indica l’ordine con cui i byte di una parola multi-byte vengono memorizzati in memoria.
>
> Riguarda valori più grandi di un byte, ad esempio:
>
> ```text
> halfword = 2 byte
> word = 4 byte
> doubleword = 8 byte
> ```
>
> Non cambia il valore logico del dato, ma cambia l’ordine dei byte in memoria.
>
> I due formati principali sono:
>
> ```text
> big-endian
> little-endian
> ```

---

## 85. Come funziona il formato little-endian?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nel formato little-endian, il byte meno significativo viene memorizzato all’indirizzo di memoria più basso.
>
> Esempio:
>
> ```text
> dato = 0x11223344
> ```
>
> Se viene salvato a partire dall’indirizzo `0`, in little-endian avremo:
>
> ```text
> indirizzo 0 → 0x44
> indirizzo 1 → 0x33
> indirizzo 2 → 0x22
> indirizzo 3 → 0x11
> ```
>
> Quindi:
>
> ```text
> indirizzo più basso → byte meno significativo
> ```
>
> Questa è una trappola classica negli esercizi con `lb`, `lbu`, `lh`, `lhu`, `lw`, `sb`, `sh`, `sw`.

---

## 86. Come funziona il formato big-endian?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nel formato big-endian, il byte più significativo viene memorizzato all’indirizzo di memoria più basso.
>
> Esempio:
>
> ```text
> dato = 0x11223344
> ```
>
> Se viene salvato a partire dall’indirizzo `0`, in big-endian avremo:
>
> ```text
> indirizzo 0 → 0x11
> indirizzo 1 → 0x22
> indirizzo 2 → 0x33
> indirizzo 3 → 0x44
> ```
>
> Quindi:
>
> ```text
> indirizzo più basso → byte più significativo
> ```

---

## 87. Qual è la differenza principale tra big-endian e little-endian?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La differenza è l’ordine con cui i byte di un dato multi-byte vengono salvati in memoria.
>
> In big-endian:
>
> ```text
> il byte più significativo va all’indirizzo più basso
> ```
>
> In little-endian:
>
> ```text
> il byte meno significativo va all’indirizzo più basso
> ```
>
> Esempio con:
>
> ```text
> 0x11223344
> ```
>
> Big-endian:
>
> ```text
> indirizzo 0 → 0x11
> indirizzo 1 → 0x22
> indirizzo 2 → 0x33
> indirizzo 3 → 0x44
> ```
>
> Little-endian:
>
> ```text
> indirizzo 0 → 0x44
> indirizzo 1 → 0x33
> indirizzo 2 → 0x22
> indirizzo 3 → 0x11
> ```

---

## 88. Perché la risposta “in little-endian il byte più significativo viene memorizzato all’indirizzo più basso” è falsa?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> È falsa perché quella è la definizione di big-endian, non di little-endian.
>
> In little-endian:
>
> ```text
> indirizzo più basso → byte meno significativo
> ```
>
> In big-endian:
>
> ```text
> indirizzo più basso → byte più significativo
> ```
>
> Quindi, se una domanda dice:
>
> ```text
> nel formato little-endian, il byte più significativo viene memorizzato all’indirizzo più basso
> ```
>
> bisogna marcarla come falsa.

---

## 89. Gli interrupt sono sincroni o asincroni rispetto al programma in esecuzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Gli interrupt sono asincroni rispetto al programma in esecuzione.
>
> Significa che possono arrivare in momenti non prevedibili dal programma.
>
> Esempio:
>
> ```text
> il programma sta eseguendo delle istruzioni
> un dispositivo I/O richiede attenzione
> arriva un interrupt
> la CPU sospende temporaneamente il flusso normale
> viene eseguito il gestore dell’interrupt
> poi si torna al programma
> ```
>
> Sono asincroni perché non dipendono direttamente dall’istruzione attualmente eseguita dal programma.

---

## 90. Che differenza c’è tra interrupt ed eccezione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un interrupt è solitamente asincrono rispetto al programma.
>
> Esempio:
>
> ```text
> un dispositivo I/O segnala che ha terminato un’operazione
> ```
>
> Una eccezione è solitamente sincrona, perché è causata dall’esecuzione di una specifica istruzione.
>
> Esempi:
>
> ```text
> divisione per zero
> accesso non valido alla memoria
> istruzione illegale
> syscall/ecall
> ```
>
> Riassunto:
>
> ```text
> interrupt → causato da eventi esterni, asincrono
> eccezione → causata dal programma, sincrona
> ```

---

## 91. Chi genera gli interrupt: la CPU o i dispositivi I/O?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Normalmente sono i dispositivi I/O a generare interrupt verso la CPU.
>
> La CPU non invia interrupt ai dispositivi quando ha bisogno dei loro servizi.
>
> Il flusso corretto è:
>
> ```text
> dispositivo I/O → interrupt → CPU
> ```
>
> L’interrupt serve ad avvisare la CPU che un evento richiede attenzione, ad esempio:
>
> - un trasferimento è terminato;
> - un dato è pronto;
> - si è verificato un errore;
> - un dispositivo richiede servizio.

---

## 92. Che cosa deve fare un gestore di interrupt con i registri?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un gestore di interrupt deve preservare lo stato del programma interrotto.
>
> In generale deve salvare i registri che modifica e poi ripristinarli prima di tornare al programma interrotto.
>
> Non è corretto dire che deve salvare solo i registri di tipo `s`.
>
> Il punto non è il nome del registro, ma il fatto che il programma interrotto deve poter riprendere come se nulla fosse successo.
>
> Schema:
>
> ```text
> arriva interrupt
> salvo lo stato necessario
> eseguo il gestore
> ripristino lo stato
> ritorno al programma interrotto
> ```

---

## 93. Perché la gestione degli interrupt non richiede sempre polling?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Polling e interrupt sono due tecniche diverse.
>
> Nel polling:
>
> ```text
> la CPU controlla continuamente lo stato del dispositivo
> ```
>
> Con interrupt:
>
> ```text
> il dispositivo avvisa la CPU quando ha bisogno di attenzione
> ```
>
> Quindi la gestione degli interrupt non richiede sempre polling.
>
> Anzi, uno dei vantaggi degli interrupt è proprio evitare che la CPU sprechi tempo controllando continuamente i registri di stato del dispositivo.

---

## 94. Qual è la differenza tra polling e interrupt?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nel polling, la CPU interroga ripetutamente il dispositivo per sapere se è pronto.
>
> Esempio:
>
> ```text
> while dispositivo non pronto:
>     controlla registro di stato
> ```
>
> Vantaggio:
>
> ```text
> semplice da implementare
> ```
>
> Svantaggio:
>
> ```text
> spreca tempo CPU
> ```
>
> Con interrupt, invece, è il dispositivo ad avvisare la CPU.
>
> Vantaggio:
>
> ```text
> la CPU può fare altro mentre aspetta
> ```
>
> Svantaggio:
>
> ```text
> gestione più complessa
> ```

---

## 95. Che cos’è il DMA e perché è utile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> DMA significa Direct Memory Access.
>
> Permette a un dispositivo di trasferire dati direttamente da o verso la memoria principale senza coinvolgere la CPU per ogni singolo byte o word.
>
> Schema:
>
> ```text
> CPU configura il DMA
> DMA trasferisce il blocco di dati
> DMA avvisa la CPU al termine
> ```
>
> È utile perché riduce il carico sulla CPU nei trasferimenti grandi.
>
> Senza DMA, la CPU dovrebbe occuparsi direttamente di molti piccoli trasferimenti tra dispositivo e memoria.

---

## 96. Quali sono i passaggi tipici nella gestione di un interrupt?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I passaggi tipici sono:
>
> 1. Un dispositivo o evento genera un interrupt.
> 2. La CPU completa o sospende in modo controllato l’esecuzione corrente.
> 3. Viene salvato lo stato necessario del programma.
> 4. La CPU salta alla routine di servizio dell’interrupt, detta interrupt handler.
> 5. L’handler gestisce l’evento.
> 6. Lo stato salvato viene ripristinato.
> 7. La CPU ritorna al programma interrotto.
>
> L’obiettivo è fare in modo che il programma possa continuare correttamente dopo la gestione dell’interrupt.

---

## 97. Quali sono i principali tranelli sulle domande teoriche di I/O e interrupt?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I tranelli più comuni sono:
>
> ```text
> “La CPU invia interrupt ai dispositivi”
> ```
>
> Falso: normalmente sono i dispositivi che inviano interrupt alla CPU.
>
> ```text
> “Gli interrupt sono sincroni rispetto al programma”
> ```
>
> Falso: gli interrupt sono tipicamente asincroni.
>
> ```text
> “Gli interrupt richiedono sempre polling”
> ```
>
> Falso: polling e interrupt sono due tecniche diverse.
>
> ```text
> “Il gestore deve salvare solo i registri s”
> ```
>
> Falso: deve preservare lo stato necessario, cioè i registri che rischia di modificare e che servono al programma interrotto.
>
> Formula mentale:
>
> ```text
> polling → CPU controlla
> interrupt → dispositivo avvisa
> DMA → trasferimento diretto memoria-dispositivo
> ```

---

## 98. Che cosa significa memoria indirizzabile a byte?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una memoria indirizzabile a byte significa che ogni indirizzo identifica un singolo byte.
>
> Quindi:
>
> ```text
> indirizzo 0 → 1 byte
> indirizzo 1 → 1 byte
> indirizzo 2 → 1 byte
> indirizzo 3 → 1 byte
> ```
>
> Una word da 32 bit occupa 4 byte, quindi 4 indirizzi consecutivi.
>
> Esempio:
>
> ```text
> word a indirizzo 0 → usa indirizzi 0, 1, 2, 3
> word a indirizzo 4 → usa indirizzi 4, 5, 6, 7
> ```
>
> Questo è importante per capire sia l’endianess sia l’allineamento.

---

## 99. Che cos’è l’allineamento in memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’allineamento indica se un dato è memorizzato a un indirizzo compatibile con la sua dimensione.
>
> Regole tipiche:
>
> ```text
> byte → può stare a qualunque indirizzo
> halfword da 2 byte → indirizzo multiplo di 2
> word da 4 byte → indirizzo multiplo di 4
> doubleword da 8 byte → indirizzo multiplo di 8
> ```
>
> Esempi:
>
> ```text
> word a indirizzo 0 → allineata
> word a indirizzo 4 → allineata
> word a indirizzo 2 → non allineata
> ```
>
> L’allineamento è importante perché alcuni processori richiedono accessi allineati o li gestiscono più efficientemente.

---

## 100. Quali domande teoriche conviene aspettarsi oltre alle formule?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Oltre alle formule, conviene aspettarsi domande teoriche su:
>
> ```text
> 32 bit vs 64 bit
> endianness
> memoria indirizzabile a byte
> allineamento
> load/store signed e unsigned
> polling
> interrupt
> DMA
> pipeline
> cache
> segnali di controllo
> ALU operation
> overflow
> signed vs unsigned
> ```
>
> Per rispondere bene, spesso basta riconoscere la parola chiave:
>
> ```text
> 64 bit → più memoria indirizzabile
> little-endian → byte meno significativo all’indirizzo più basso
> big-endian → byte più significativo all’indirizzo più basso
> interrupt → asincrono, dispositivo avvisa CPU
> polling → CPU controlla dispositivo
> DMA → trasferimento diretto memoria-dispositivo
> ```


## 101. Che differenza c’è tra linguaggio assembly e linguaggio macchina?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il linguaggio macchina è il linguaggio effettivamente eseguito dal processore, formato da sequenze di bit.
>
> Il linguaggio assembly è una rappresentazione simbolica e leggibile delle istruzioni macchina.
>
> Esempio:
>
> ```text
> linguaggio macchina → 0000000 01011 01010 000 01111 0110011
> assembly           → add x15, x10, x11
> ```
>
> L’assembly è vicino al linguaggio macchina perché spesso c’è una corrispondenza quasi uno-a-uno tra istruzione assembly e istruzione ISA.
>
> Però l’assembly aggiunge comodità come:
>
> ```text
> etichette
> direttive
> costanti
> macro
> pseudo-istruzioni
> ```

---

## 102. Che cosa fa l’assemblatore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’assemblatore traduce un programma scritto in linguaggio assembly in un programma oggetto in linguaggio macchina.
>
> In particolare:
>
> ```text
> legge il programma assembly
> traduce i codici mnemonici in codici binari
> risolve etichette e simboli
> controlla la correttezza sintattica
> produce un file oggetto
> ```
>
> Attenzione alla nomenclatura:
>
> - **assembly** = linguaggio;
> - **assembler / assemblatore** = programma traduttore.

---

## 103. Che cosa sono le pseudo-istruzioni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le pseudo-istruzioni sono istruzioni comode per il programmatore, ma non fanno parte direttamente dell’ISA.
>
> L’assemblatore le traduce in una o più istruzioni reali.
>
> Esempi tipici:
>
> ```asm
> mv rd, rs
> ```
>
> viene tradotta come:
>
> ```asm
> addi rd, rs, 0
> ```
>
> Oppure:
>
> ```asm
> nop
> ```
>
> può essere tradotta come:
>
> ```asm
> addi x0, x0, 0
> ```
>
> Quindi una pseudo-istruzione non compare come tale nel programma oggetto finale.

---

## 104. Che cosa sono le direttive assembler?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le direttive assembler non sono istruzioni eseguite dalla CPU.
>
> Servono a dare informazioni all’assemblatore su come organizzare il programma.
>
> Esempi:
>
> ```asm
> .data
> .text
> .globl
> .word
> .byte
> .string
> .align
> ```
>
> Per esempio:
>
> ```asm
> .data
> val: .word 10
> ```
>
> dice all’assemblatore di riservare una word in memoria dati e inizializzarla a 10.
>
> La CPU non esegue `.data` o `.word`: sono comandi per l’assemblatore.

---

## 105. Che differenza c’è tra macro e procedura?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una macro è una sequenza di istruzioni a cui viene dato un nome.
>
> Quando uso la macro, l’assemblatore sostituisce il nome della macro con il suo corpo.
>
> Quindi:
>
> ```text
> macro → espansa durante l’assemblaggio
> procedura → chiamata durante l’esecuzione
> ```
>
> Differenza fondamentale:
>
> ```text
> macro: il codice viene copiato ogni volta
> procedura: il codice esiste una volta sola e viene chiamato con jal
> ```
>
> Una macro non richiede `jal` e `ret`, ma può aumentare la dimensione del programma oggetto.
>
> Una procedura richiede gestione di `ra`, stack e convenzioni di chiamata, ma evita di duplicare codice.

---

## 106. Che cos’è una forward reference?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una forward reference è un riferimento a un’etichetta che compare più avanti nel programma.
>
> Esempio:
>
> ```asm
> beq t0, t1, fine
> ...
> fine:
> ```
>
> Quando l’assemblatore legge `beq t0, t1, fine`, non ha ancora incontrato l’etichetta `fine`.
>
> Per questo l’assemblatore deve ricordarsi il riferimento e risolverlo dopo.
>
> È uno dei motivi per cui spesso si parla di assemblatore a due passi.

---

## 107. Perché un assemblatore può usare due passi?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un assemblatore a due passi serve soprattutto per risolvere correttamente le etichette, specialmente le forward reference.
>
> Nel primo passo:
>
> ```text
> individua tutte le etichette
> costruisce la symbol table
> associa ogni etichetta a una posizione nel programma
> ```
>
> Nel secondo passo:
>
> ```text
> traduce le istruzioni
> sostituisce le etichette con gli indirizzi corretti
> genera il codice oggetto
> ```
>
> Quindi la symbol table è fondamentale per tradurre correttamente salti e riferimenti simbolici.

---

## 108. Che cos’è la symbol table?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La symbol table è una tabella usata dall’assemblatore o dal linker per associare simboli a indirizzi o posizioni.
>
> Contiene informazioni come:
>
> ```text
> nome dell’etichetta
> posizione nel codice
> indirizzo relativo
> eventuali simboli esterni
> ```
>
> Esempio:
>
> ```text
> .L18 → 0x432
> .L20 → 0x462
> ```
>
> Serve per tradurre istruzioni che usano etichette simboliche, come branch e jump.

---

## 109. Che cosa fa il linker?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il linker combina più file oggetto in un unico file eseguibile.
>
> Il suo lavoro principale è:
>
> ```text
> unire moduli oggetto diversi
> risolvere riferimenti a simboli esterni
> aggiornare gli indirizzi
> collegare codice e librerie
> ```
>
> Esempio:
>
> se una procedura A chiama una procedura B che si trova in un altro modulo, il linker deve sostituire il riferimento simbolico a B con l’indirizzo corretto.

---

## 110. Che cosa fa il loader?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il loader carica il programma eseguibile in memoria per permetterne l’esecuzione.
>
> Schema:
>
> ```text
> file eseguibile → loader → memoria
> ```
>
> Il loader prepara il programma all’esecuzione, caricando codice e dati nelle zone opportune della memoria.
>
> Nella sequenza completa:
>
> ```text
> sorgente C
> compilatore
> assembly
> assemblatore
> file oggetto
> linker
> eseguibile
> loader
> memoria
> ```

---

## 111. Che cos’è un bus?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un bus è un insieme di linee elettriche che collegano i moduli di un elaboratore.
>
> Può collegare:
>
> ```text
> CPU
> memoria
> dispositivi I/O
> controller
> ```
>
> Le linee principali sono:
>
> ```text
> linee dati
> linee indirizzi
> linee controllo
> ```
>
> Il protocollo del bus stabilisce le regole con cui i dispositivi comunicano.

---

## 112. Che differenza c’è tra linee dati, linee indirizzi e linee di controllo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le linee dati trasportano i bit del dato trasferito.
>
> ```text
> più linee dati → più bit trasferiti in una singola operazione
> ```
>
> Le linee indirizzi indicano la sorgente o destinazione del trasferimento.
>
> ```text
> n linee indirizzo → 2^n locazioni indirizzabili
> ```
>
> Le linee di controllo regolano il funzionamento del bus.
>
> Esempi:
>
> ```text
> read/write
> richiesta bus
> grant
> interrupt
> wait
> clock
> ```

---

## 113. Come si collega la larghezza del bus alla memoria indirizzabile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Se il bus indirizzi ha `n` linee, posso rappresentare:
>
> ```text
> 2^n indirizzi
> ```
>
> Se la memoria è indirizzabile a byte:
>
> ```text
> capacità = 2^n byte
> ```
>
> Esempio:
>
> ```text
> 32 linee indirizzo → 2^32 byte = 4 GiB
> ```
>
> Il bus dati invece non determina direttamente la quantità massima di memoria, ma quanti bit posso trasferire alla volta.
>
> Esempio:
>
> ```text
> bus dati a 64 bit → trasferisce 64 bit per operazione
> ```

---

## 114. Che differenza c’è tra bus sincrono e bus asincrono?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un bus sincrono usa una linea di clock comune.
>
> Le operazioni avvengono in multipli interi del ciclo di clock.
>
> Vantaggio:
>
> ```text
> più semplice da coordinare
> ```
>
> Svantaggio:
>
> ```text
> deve adattarsi ai tempi dei dispositivi più lenti
> ```
>
> Un bus asincrono non usa un clock globale.
>
> Usa invece segnali di handshaking.
>
> Vantaggio:
>
> ```text
> più flessibile, perché ogni trasferimento dura quanto serve
> ```
>
> Svantaggio:
>
> ```text
> protocollo più complesso
> ```

---

## 115. Che cos’è l’handshaking in un bus asincrono?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’handshaking è un meccanismo di sincronizzazione tra due dispositivi senza usare un clock comune.
>
> Schema mentale:
>
> ```text
> il master mette indirizzo e segnali di controllo
> il master attiva un segnale di richiesta/sincronizzazione
> il dispositivo risponde quando è pronto
> i dati vengono trasferiti
> entrambi disattivano i segnali
> ```
>
> L’idea è:
>
> ```text
> non si assume una durata fissa
> si aspetta il segnale dell’altro dispositivo
> ```
>
> Per questo il bus asincrono si adatta meglio a dispositivi con tempi diversi.

---

## 116. Perché serve l’arbitraggio del bus?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’arbitraggio serve quando più dispositivi vogliono usare il bus contemporaneamente.
>
> Se due dispositivi scrivessero sul bus nello stesso momento, ci sarebbe ambiguità o conflitto.
>
> L’arbitraggio decide chi ottiene il bus.
>
> Meccanismo tipico:
>
> ```text
> richiesta del bus
> arbitro
> grant
> dispositivo autorizzato usa il bus
> ```
>
> Può essere:
>
> ```text
> centralizzato
> decentralizzato
> ```
>
> Nel daisy chaining, il grant passa lungo una catena di dispositivi: di solito vince quello più vicino all’arbitro.

---

## 117. Che differenza c’è tra dispositivo attivo e passivo su un bus?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un dispositivo attivo può iniziare un trasferimento sul bus.
>
> Esempi:
>
> ```text
> CPU
> DMA controller
> ```
>
> Un dispositivo passivo rimane in attesa di richieste.
>
> Esempi:
>
> ```text
> memoria
> alcune periferiche I/O
> ```
>
> La CPU spesso può comportarsi sia da dispositivo attivo sia da dispositivo passivo, quindi può usare un transceiver.

---

## 118. Che cos’è la località temporale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La località temporale dice che, se un programma accede a una certa locazione di memoria, è probabile che vi acceda di nuovo dopo poco tempo.
>
> Esempi:
>
> ```text
> variabili usate spesso
> istruzioni dentro un ciclo
> valori nello stack durante chiamate ricorsive
> ```
>
> La cache sfrutta questa proprietà tenendo vicini alla CPU i dati e le istruzioni usati di recente.

---

## 119. Che cos’è la località spaziale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La località spaziale dice che, se un programma accede a una locazione di memoria, è probabile che acceda presto anche alle locazioni vicine.
>
> Esempi:
>
> ```text
> array letti in ordine
> istruzioni consecutive
> stringhe percorse carattere per carattere
> ```
>
> Per questo la cache non carica solo una parola, ma un intero blocco.
>
> Caricando un blocco, è probabile che i prossimi accessi siano già in cache.

---

## 120. Perché la cache usa blocchi e non singole parole isolate?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La cache usa blocchi per sfruttare la località spaziale.
>
> Se accedo a una parola, è probabile che presto acceda anche alle parole vicine.
>
> Quindi quando avviene un miss:
>
> ```text
> non carico solo la parola richiesta
> carico il blocco che la contiene
> ```
>
> Questo aumenta la probabilità di hit nei prossimi accessi.
>
> Attenzione però:
>
> ```text
> aumentare troppo la dimensione del blocco non è sempre conveniente
> ```
>
> perché può aumentare la miss penalty e ridurre il numero di linee disponibili in cache.

---

## 121. Che cosa indicano valid bit e tag in una cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il valid bit indica se una linea della cache contiene un dato valido.
>
> ```text
> valid = 0 → linea vuota/non valida
> valid = 1 → linea utilizzabile
> ```
>
> Il tag serve a capire se il blocco presente in quella linea è proprio quello cercato.
>
> In una cache direct mapped:
>
> ```text
> l’index seleziona la linea
> il valid bit dice se la linea contiene qualcosa di valido
> il tag viene confrontato con il tag dell’indirizzo richiesto
> ```
>
> C’è hit solo se:
>
> ```text
> valid = 1
> tag memorizzato = tag richiesto
> ```

---

## 122. Che differenza c’è tra cache direct mapped, completamente associativa e set-associativa?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nella cache direct mapped, ogni blocco di memoria può andare in una sola linea della cache.
>
> ```text
> linea = numero blocco mod numero linee cache
> ```
>
> Vantaggio:
>
> ```text
> semplice e veloce
> ```
>
> Svantaggio:
>
> ```text
> più conflitti
> ```
>
> Nella cache completamente associativa, un blocco può andare in qualunque linea.
>
> Vantaggio:
>
> ```text
> meno conflitti
> ```
>
> Svantaggio:
>
> ```text
> ricerca più costosa, perché bisogna confrontare molti tag
> ```
>
> Nella cache set-associativa, un blocco può andare in un insieme limitato di linee, dette vie.
>
> È una soluzione intermedia tra direct mapped e completamente associativa.

---

## 123. Che cos’è la politica LRU nelle cache?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> LRU significa Least Recently Used.
>
> Quando bisogna rimpiazzare un blocco in cache, si elimina quello usato meno recentemente.
>
> Idea:
>
> ```text
> se un blocco non viene usato da molto tempo,
> è meno probabile che serva subito
> ```
>
> LRU è utile soprattutto nelle cache associative o set-associative, dove ci sono più candidati nello stesso set.

---

## 124. Che differenza c’è tra write-through e write-back?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Write-through:
>
> ```text
> ogni scrittura in cache aggiorna anche la memoria principale
> ```
>
> Vantaggio:
>
> ```text
> memoria sempre aggiornata
> ```
>
> Svantaggio:
>
> ```text
> più traffico verso la memoria
> ```
>
> Write-back:
>
> ```text
> si scrive solo in cache
> la memoria viene aggiornata quando il blocco viene rimpiazzato
> ```
>
> Vantaggio:
>
> ```text
> meno traffico verso la memoria
> ```
>
> Svantaggio:
>
> ```text
> implementazione più complessa
> ```
>
> In write-back serve sapere se un blocco è stato modificato, spesso con un dirty bit.

---

## 125. Che differenza c’è tra circuito combinatorio e circuito sequenziale?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un circuito combinatorio produce uscite che dipendono solo dagli ingressi attuali.
>
> Esempi:
>
> ```text
> AND
> OR
> NOT
> multiplexer
> decoder
> sommatore
> ALU combinatoria
> ```
>
> Un circuito sequenziale produce uscite che dipendono dagli ingressi e anche da uno stato interno.
>
> Esempi:
>
> ```text
> latch
> flip-flop
> registri
> memoria
> register file
> ```
>
> Quindi:
>
> ```text
> combinatorio → non ha memoria
> sequenziale → ha memoria/stato
> ```

---

## 126. Che cos’è un latch SR e qual è il caso vietato?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un latch SR è un circuito sequenziale capace di memorizzare 1 bit.
>
> Ha due ingressi principali:
>
> ```text
> S = set
> R = reset
> ```
>
> Comportamento:
>
> ```text
> S=1, R=0 → memorizza 1
> S=0, R=1 → memorizza 0
> S=0, R=0 → mantiene lo stato
> ```
>
> Il caso problematico è:
>
> ```text
> S=1, R=1
> ```
>
> perché può produrre uno stato non valido o instabile.
>
> Quindi:
>
> ```text
> S e R non devono essere attivi contemporaneamente
> ```

---

## 127. Che cos’è un latch D e perché evita il problema del latch SR?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un latch D memorizza il valore dell’ingresso `D` quando il clock/enable lo abilita.
>
> Se il clock è attivo:
>
> ```text
> Q segue D
> ```
>
> Se il clock non è attivo:
>
> ```text
> Q mantiene il valore precedente
> ```
>
> Il latch D evita il caso proibito del latch SR perché genera internamente i segnali set/reset a partire da un solo ingresso `D`.
>
> Quindi non può capitare di chiedere contemporaneamente:
>
> ```text
> set = 1
> reset = 1
> ```

---

## 128. Qual è il problema della trasparenza del latch D?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il latch D è trasparente quando il clock/enable è attivo.
>
> Significa che:
>
> ```text
> se D cambia mentre il latch è abilitato,
> anche Q può cambiare
> ```
>
> Questo può essere un problema nei circuiti con retroazione, perché un valore “sporco” o non ancora stabile può essere memorizzato.
>
> Per evitare questo problema si usano spesso flip-flop edge-triggered, che campionano il valore solo sul fronte del clock.

---

## 129. Che differenza c’è tra latch e flip-flop?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un latch è sensibile al livello del clock o dell’enable.
>
> Esempio:
>
> ```text
> clock = 1 → il latch può essere trasparente
> clock = 0 → mantiene il valore
> ```
>
> Un flip-flop è sensibile al fronte del clock.
>
> Esempi:
>
> ```text
> fronte di salita
> fronte di discesa
> ```
>
> Quindi:
>
> ```text
> latch → level-triggered
> flip-flop → edge-triggered
> ```
>
> Nei datapath sincroni si usano spesso flip-flop o elementi di stato aggiornati sul fronte del clock.

---

## 130. Che cosa sono setup time e hold time?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il setup time è il tempo minimo per cui l’ingresso deve essere stabile prima del fronte attivo del clock.
>
> L’hold time è il tempo minimo per cui l’ingresso deve rimanere stabile dopo il fronte attivo del clock.
>
> Schema:
>
> ```text
> prima del fronte → setup time
> dopo il fronte   → hold time
> ```
>
> Se questi vincoli non sono rispettati, l’elemento di memoria può memorizzare un valore sbagliato o instabile.

---

## 131. Come è fatto concettualmente un registro?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un registro è un insieme di flip-flop D raggruppati insieme.
>
> Se il registro è a 32 bit:
>
> ```text
> contiene 32 flip-flop D
> ```
>
> Tutti ricevono lo stesso clock.
>
> Ogni flip-flop memorizza un bit.
>
> Quindi:
>
> ```text
> registro da n bit → n flip-flop
> ```

---

## 132. Come è fatto concettualmente un register file?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un register file è un insieme di registri leggibili e scrivibili.
>
> Per funzionare usa:
>
> ```text
> registri basati su flip-flop D
> multiplexer per scegliere quale registro leggere
> decoder per scegliere quale registro scrivere
> segnali di controllo come RegWrite
> ```
>
> Nel RISC-V, il register file contiene 32 registri interi.
>
> Di solito ha:
>
> ```text
> due porte di lettura
> una porta di scrittura
> ```
>
> Questo permette alle istruzioni R-type di leggere due registri sorgente e scrivere un registro destinazione.

---

## 133. Che differenza c’è tra SRAM e DRAM?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> SRAM significa Static RAM.
>
> È realizzata con circuiti simili a flip-flop.
>
> Caratteristiche:
>
> ```text
> molto veloce
> più costosa
> usata per cache
> ```
>
> DRAM significa Dynamic RAM.
>
> È realizzata con condensatori che devono essere rinfrescati periodicamente.
>
> Caratteristiche:
>
> ```text
> più lenta della SRAM
> più economica
> più densa
> usata come memoria principale
> ```
>
> Schema mentale:
>
> ```text
> SRAM → cache
> DRAM → RAM principale
> ```

---

## 134. Perché il PC viene incrementato di 4 nel datapath RISC-V base?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nel RISC-V base, le istruzioni core sono lunghe 32 bit.
>
> 32 bit equivalgono a:
>
> ```text
> 4 byte
> ```
>
> Poiché la memoria è indirizzabile a byte, l’indirizzo dell’istruzione successiva si ottiene facendo:
>
> ```text
> PC = PC + 4
> ```
>
> Quindi nel datapath c’è un sommatore dedicato che calcola:
>
> ```text
> PC + 4
> ```
>
> Attenzione: con istruzioni compresse a 16 bit il discorso può cambiare, ma nel datapath didattico base si assume normalmente PC + 4.

---

## 135. Che ruolo ha l’unità di controllo nel datapath?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità di controllo decodifica l’istruzione e genera i segnali necessari a far funzionare il datapath.
>
> Genera segnali come:
>
> ```text
> RegWrite
> ALUSrc
> MemRead
> MemWrite
> MemToReg
> Branch
> ALUOp
> ```
>
> In pratica decide:
>
> ```text
> quali registri leggere
> se usare un immediato
> quale operazione deve fare la ALU
> se leggere o scrivere memoria
> se scrivere nel register file
> come aggiornare il PC
> ```
>
> Senza unità di controllo, il datapath avrebbe i componenti ma non saprebbe come coordinarli.

---

## 136. Che cos’è PCSrc e quando vale 1?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `PCSrc` è il segnale che decide quale sarà il prossimo valore del Program Counter.
>
> In un datapath semplice:
>
> ```text
> PCSrc = 0 → PC = PC + 4
> PCSrc = 1 → PC = indirizzo di branch
> ```
>
> Per una `beq`, il branch viene preso solo se:
>
> ```text
> Branch = 1
> Zero = 1
> ```
>
> Quindi:
>
> ```text
> PCSrc = Branch AND Zero
> ```
>
> Se `beq` confronta due registri uguali, la ALU produce zero e `Zero = 1`.
>
> A quel punto il PC viene aggiornato con l’indirizzo di salto.

---

## 137. Che cosa significa “don’t care” in una tabella di controllo?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un valore `X`, detto don’t care, indica che quel segnale può valere indifferentemente 0 o 1 senza cambiare il comportamento dell’istruzione.
>
> Esempio:
>
> ```text
> sw non scrive nel register file
> ```
>
> Quindi per `sw`:
>
> ```text
> RegWrite = 0
> MemToReg = X
> ```
>
> `MemToReg` non importa, perché non verrà scritto nessun registro.
>
> I don’t care sono utili perché permettono di semplificare la logica di controllo.

---

## 138. Perché ALUOp è usato insieme a funct3 e funct7?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> `ALUOp` è un controllo generale prodotto dall’unità di controllo principale.
>
> Dice alla logica della ALU che tipo di istruzione si sta eseguendo.
>
> Schema tipico:
>
> ```text
> ALUOp = 00 → load/store → la ALU fa somma
> ALUOp = 01 → beq → la ALU fa sottrazione
> ALUOp = 10 → R-type → guarda funct3 e funct7
> ```
>
> Per le R-type, infatti, l’opcode dice solo che è una istruzione registro-registro.
>
> L’operazione precisa, come `add`, `sub`, `and`, `or`, viene determinata dai campi:
>
> ```text
> funct3
> funct7
> ```

---

## 139. Quali campi dell’istruzione RISC-V sono sempre importanti da riconoscere?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nei formati RISC-V è importante riconoscere:
>
> ```text
> opcode / codop → bit 6:0
> rd             → bit 11:7
> funct3         → bit 14:12
> rs1            → bit 19:15
> rs2            → bit 24:20
> funct7         → bit 31:25
> ```
>
> Regole utili:
>
> ```text
> rs1 è spesso il primo registro sorgente
> rs2 è il secondo registro sorgente o dato da scrivere nelle store
> rd è il registro destinazione nelle R-type e nelle load
> opcode identifica il formato/tipo generale dell’istruzione
> funct3/funct7 specificano meglio l’operazione
> ```

---

## 140. Quali sono le risposte secche da ricordare su queste slide teoriche?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Risposte rapide:
>
> ```text
> assembler → traduce assembly in oggetto
> linker → collega moduli oggetto e risolve simboli esterni
> loader → carica l’eseguibile in memoria
> pseudo-istruzione → alias tradotto in istruzioni reali
> direttiva → comando per l’assemblatore, non per la CPU
> macro → espansa durante l’assemblaggio
> procedura → chiamata durante l’esecuzione
> forward reference → riferimento a etichetta definita dopo
> symbol table → associa simboli/etichette a indirizzi
> bus dati → trasferisce dati
> bus indirizzi → seleziona sorgente/destinazione
> bus controllo → coordina operazioni
> bus sincrono → usa clock comune
> bus asincrono → usa handshaking
> arbitraggio → decide chi usa il bus
> località temporale → riuso dello stesso dato a breve
> località spaziale → uso di dati vicini
> valid bit → dice se una linea cache è valida
> tag → verifica se il blocco è quello cercato
> SRAM → cache
> DRAM → memoria principale
> latch → sensibile al livello
> flip-flop → sensibile al fronte
> setup time → stabilità prima del fronte
> hold time → stabilità dopo il fronte
> PC + 4 → prossima istruzione RISC-V base
> PCSrc = Branch AND Zero → branch preso
> ```
```
---

## 141. Che cos’è l’architettura di Von Neumann?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’architettura di Von Neumann è un modello di calcolatore in cui **dati e istruzioni sono memorizzati nella stessa memoria principale**.
>
> La CPU legge dalla memoria sia:
>
> - le istruzioni da eseguire;
> - i dati su cui le istruzioni devono operare.
>
> La CPU è composta da:
>
> - unità di controllo;
> - unità aritmetico-logica, cioè ALU;
> - registri;
> - bus interni che collegano le varie parti.
>
> L’idea fondamentale è che il programma sia memorizzato in memoria come sequenza di bit, esattamente come i dati. La CPU esegue poi le istruzioni una alla volta seguendo il ciclo di fetch-decode-execute.

---

## 142. Quali sono le parti principali della CPU in una macchina di Von Neumann?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In una macchina di Von Neumann, la CPU è composta principalmente da:
>
> - **unità di controllo**, che coordina l’esecuzione delle istruzioni;
> - **ALU**, cioè unità aritmetico-logica, che esegue operazioni aritmetiche e logiche;
> - **registri**, cioè piccole memorie molto veloci interne alla CPU;
> - **bus interni**, che permettono ai dati di spostarsi tra registri, ALU e altre parti della CPU.
>
> I registri, l’ALU e i bus interni formano il **data path**, cioè il percorso lungo cui i dati si muovono durante l’esecuzione delle istruzioni.

---

## 143. Che cos’è il data path in una CPU di Von Neumann?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **data path** è l’organizzazione interna della CPU attraverso cui passano i dati durante l’esecuzione delle istruzioni.
>
> È formato principalmente da:
>
> - registri;
> - ALU;
> - bus interni.
>
> Il suo compito è far arrivare gli operandi all’ALU, eseguire l’operazione richiesta e salvare il risultato in un registro o, se necessario, in memoria.
>
> In modo semplice: il data path è la “strada interna” percorsa dai dati dentro la CPU.

---

## 144. Che cos’è un registro in una CPU di Von Neumann?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un registro è una piccola memoria molto veloce interna alla CPU.
>
> Serve a contenere dati temporanei durante l’esecuzione delle istruzioni.
>
> I registri sono importanti perché l’ALU non lavora direttamente su dati lontani in memoria, ma usa valori disponibili rapidamente nei registri.
>
> Per esempio, in un’istruzione aritmetica, due operandi possono essere letti dai registri, passare attraverso l’ALU e il risultato può essere scritto di nuovo in un registro.
>
> Quindi i registri rendono più veloce l’elaborazione perché evitano accessi continui alla memoria principale.

---

## 145. Quali sono i due registri importanti citati nell’organizzazione della CPU di Von Neumann?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Due registri fondamentali nella CPU di Von Neumann sono:
>
> - **Program Counter**, abbreviato **PC**;
> - **Instruction Register**, abbreviato **IR**.
>
> Il **PC** contiene l’indirizzo della prossima istruzione da eseguire.
>
> L’**IR** contiene l’istruzione appena prelevata dalla memoria.
>
> Durante il ciclo di esecuzione, la CPU usa il PC per sapere dove andare a leggere la prossima istruzione, poi mette quell’istruzione nell’IR per poterla decodificare ed eseguire.

---

## 146. Che cos’è il Program Counter?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **Program Counter**, o **PC**, è un registro che contiene l’indirizzo della prossima istruzione da eseguire.
>
> Durante la fase di fetch, la CPU usa il valore del PC per andare in memoria e leggere l’istruzione successiva.
>
> Dopo aver prelevato l’istruzione, il PC viene aggiornato per puntare all’istruzione seguente.
>
> Quindi il PC permette alla CPU di eseguire il programma in ordine, istruzione dopo istruzione.
>
> Nei salti o nelle branch, il PC può essere modificato per cambiare il flusso di esecuzione.

---

## 147. Che cos’è l’Instruction Register?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’**Instruction Register**, o **IR**, è il registro che contiene l’istruzione appena letta dalla memoria.
>
> Dopo la fase di fetch, l’istruzione viene copiata dalla memoria all’IR.
>
> A quel punto l’unità di controllo può analizzare l’istruzione, cioè fare la fase di decode, per capire:
>
> - che tipo di istruzione è;
> - quali registri usa;
> - se deve accedere alla memoria;
> - quale operazione deve far eseguire al data path.
>
> Quindi l’IR serve a conservare l’istruzione corrente mentre la CPU la decodifica ed esegue.

---

## 148. Che cos’è il ciclo fetch-decode-execute?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il ciclo **fetch-decode-execute** è il ciclo con cui la CPU esegue le istruzioni.
>
> È composto da tre fasi principali:
>
> 1. **Fetch**: la CPU preleva dalla memoria la prossima istruzione da eseguire.
> 2. **Decode**: la CPU interpreta l’istruzione e capisce che operazione deve svolgere.
> 3. **Execute**: la CPU esegue l’istruzione, usando ALU, registri e memoria se necessario.
>
> Dopo aver eseguito un’istruzione, la CPU torna alla fase di fetch e ripete il ciclo con l’istruzione successiva.
>
> Questo è il comportamento base di una CPU in una macchina di Von Neumann.

---

## 149. Quali sono i passi dettagliati del ciclo di esecuzione di un’istruzione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> La CPU esegue ogni istruzione seguendo una serie di passi elementari:
>
> 1. preleva l’istruzione successiva dalla memoria e la mette nell’Instruction Register;
> 2. aggiorna il Program Counter per indicare l’istruzione seguente;
> 3. determina il tipo dell’istruzione appena letta;
> 4. se l’istruzione usa una parola in memoria, determina dove si trova;
> 5. se necessario, carica quella parola in un registro della CPU;
> 6. esegue l’istruzione;
> 7. torna al primo passo per eseguire l’istruzione successiva.
>
> Questo ciclo viene ripetuto continuamente finché il programma è in esecuzione.

---

## 150. Qual è il ruolo dell’unità di controllo nel ciclo fetch-decode-execute?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’unità di controllo coordina l’esecuzione del ciclo di fetch-decode-execute.
>
> In particolare:
>
> - legge le istruzioni dalla memoria centrale, cioè fetch;
> - determina il tipo di istruzione, cioè decode;
> - imposta il data path per eseguire l’operazione richiesta, cioè execute.
>
> Si può vedere l’unità di controllo come la parte della CPU che “interpreta” le istruzioni e decide quali segnali attivare per muovere i dati nei registri, nell’ALU e nella memoria.
>
> Senza l’unità di controllo, il data path avrebbe i componenti fisici, ma non saprebbe quando usarli e in che ordine.

---

## 151. Che cosa significa dire che la memoria principale contiene sia istruzioni sia dati?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Significa che nella macchina di Von Neumann non esistono due memorie separate, una per le istruzioni e una per i dati.
>
> La **main memory** contiene entrambe le cose:
>
> - le istruzioni del programma;
> - i dati usati dal programma.
>
> Entrambi sono rappresentati come sequenze di bit.
>
> È la CPU, attraverso il ciclo fetch-decode-execute, a interpretare una certa sequenza di bit come istruzione oppure come dato, in base al momento e al modo in cui la sta usando.
>
> Questa è una delle caratteristiche fondamentali dell’architettura di Von Neumann.

---

## 152. Che cosa si intende per ciclo del data path?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il ciclo del data path è il processo con cui due operandi vengono fatti passare attraverso l’ALU e il risultato viene memorizzato.
>
> In modo semplificato:
>
> 1. due operandi vengono letti dai registri;
> 2. gli operandi arrivano all’ALU tramite i bus interni;
> 3. l’ALU esegue l’operazione richiesta;
> 4. il risultato viene scritto in un registro.
>
> Questo ciclo descrive il funzionamento interno della CPU durante molte istruzioni aritmetiche e logiche.

---

## 153. Che differenza c’è tra istruzioni registro-registro e registro-memoria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le istruzioni **registro-registro** lavorano solo su valori contenuti nei registri.
>
> Per esempio:
>
> ```asm
> add x5,x6,x7
> ```
>
> Qui la CPU legge `x6` e `x7`, li manda all’ALU e scrive il risultato in `x5`.
>
> Le istruzioni **registro-memoria**, invece, coinvolgono sia un registro sia la memoria.
>
> Per esempio, una load carica un dato dalla memoria in un registro:
>
> ```asm
> lw x5,0(x6)
> ```
>
> oppure una store salva in memoria un dato contenuto in un registro:
>
> ```asm
> sw x5,0(x6)
> ```
>
> Nella CPU di Von Neumann, memoria e registri collaborano continuamente, ma le operazioni dell’ALU avvengono nel data path interno della CPU.

---

## 154. Come spiegheresti all’orale il funzionamento generale di una CPU di Von Neumann?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Una CPU di Von Neumann funziona leggendo ed eseguendo istruzioni memorizzate nella memoria principale.
>
> La memoria contiene sia istruzioni sia dati, entrambi rappresentati come sequenze di bit.
>
> La CPU usa il **Program Counter** per sapere dove si trova la prossima istruzione. Durante la fase di fetch, l’istruzione viene letta dalla memoria e caricata nell’**Instruction Register**.
>
> Poi l’unità di controllo decodifica l’istruzione e imposta il data path. Il data path, formato da registri, ALU e bus interni, esegue concretamente l’operazione.
>
> Se servono dati dalla memoria, la CPU li carica nei registri. Se deve salvare un risultato, lo scrive in un registro o in memoria.
>
> Dopo l’esecuzione, il ciclo ricomincia con l’istruzione successiva.
>
> Quindi il funzionamento generale è:
>
> ```text
> fetch → decode → execute → fetch → decode → execute → ...
> ```
>
> Questa sequenza è il cuore dell’esecuzione dei programmi in una macchina di Von Neumann.

---
