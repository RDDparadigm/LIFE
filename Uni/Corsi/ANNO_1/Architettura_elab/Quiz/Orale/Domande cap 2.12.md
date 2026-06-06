# 2.12 Tradurre e avviare un programma

## Metodo di ripasso

Ripassa questa sezione seguendo la catena completa:

**programma sorgente → compilatore → assembler → linker → loader → esecuzione**

Per l’orale devi saper spiegare non solo “chi fa cosa”, ma anche **perché esistono questi passaggi**: separare compilazione, assemblaggio, collegamento e caricamento permette di tradurre il programma, riusare librerie, combinare moduli compilati separatamente e preparare correttamente la memoria prima dell’esecuzione.

---

## 1. Quali sono i passaggi principali per trasformare un programma C in un programma eseguibile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> I passaggi principali sono:
> 
> 1. **Compilazione**
>     
>     - il programma C viene tradotto in un programma in linguaggio assembler.
>         
> 2. **Assemblaggio**
>     
>     - il programma assembler viene tradotto in un file oggetto contenente codice macchina, dati, simboli e informazioni di rilocazione.
>         
> 3. **Linking**
>     
>     - il linker combina più file oggetto e librerie, risolvendo i riferimenti tra moduli.
>         
> 4. **Caricamento**
>     
>     - il loader carica il file eseguibile in memoria e prepara l’esecuzione.
>         
> 
> La sequenza generale è:
> 
> `programma C → compilatore → programma assembler → assembler → file oggetto → linker → eseguibile → loader → memoria`

---

## 2. Che cosa fa il compilatore nella traduzione di un programma?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il **compilatore** traduce un programma scritto in un linguaggio ad alto livello, come C, in un programma in **linguaggio assembler**.
> 
> Il linguaggio assembler è una forma simbolica del linguaggio macchina: usa nomi leggibili per rappresentare istruzioni, registri, etichette e indirizzi.
> 
> In passato, molti programmi venivano scritti direttamente in assembler perché i compilatori producevano codice inefficiente. Oggi, invece, i compilatori ottimizzanti sono in grado di generare codice molto efficiente, spesso paragonabile o migliore di quello scritto manualmente da un programmatore assembler esperto.
> 
> Il vantaggio del compilatore è che permette al programmatore di lavorare a un livello più alto, senza dover gestire direttamente tutte le istruzioni macchina.

---

## 3. Che cos’è il linguaggio assembler e perché non è ancora linguaggio macchina vero e proprio?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il **linguaggio assembler** è una rappresentazione simbolica del linguaggio macchina.
> 
> Non è ancora linguaggio macchina vero e proprio perché usa:
> 
> - nomi simbolici per le istruzioni;
>     
> - nomi dei registri;
>     
> - etichette per indicare posizioni nel codice o nei dati;
>     
> - pseudoinstruzioni;
>     
> - costanti e indirizzi ancora da risolvere.
>     
> 
> L’hardware non esegue direttamente il linguaggio assembler. Per essere eseguito, il programma assembler deve essere trasformato dall’**assembler** in istruzioni binarie comprensibili dal processore.
> 
> Quindi:
> 
> `assembler = forma simbolica leggibile`
> 
> `linguaggio macchina = forma binaria eseguibile dall’hardware`

---

## 4. Che cosa sono le pseudoinstruzioni in RISC-V?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Le **pseudoinstruzioni** sono istruzioni accettate dall’assembler, ma che non appartengono realmente al set di istruzioni macchina del processore.
> 
> Servono a rendere più semplice la scrittura dei programmi assembler.
> 
> L’assembler le traduce in una o più istruzioni reali.
> 
> Per esempio:
> 
> `li x9, 123`
> 
> non è una vera istruzione RISC-V. Significa “carica il valore immediato 123 nel registro x9”. L’assembler può tradurla in:
> 
> `addi x9, x0, 123`
> 
> perché in RISC-V il registro `x0` contiene sempre il valore 0.
> 
> Un altro esempio:
> 
> `mv x10, x11`
> 
> viene tradotta in:
> 
> `addi x10, x11, 0`
> 
> perché copiare un registro equivale ad aggiungere 0 al valore sorgente.
> 
> Le pseudoinstruzioni sono quindi comode per il programmatore, ma non corrispondono direttamente a istruzioni hardware.

---

## 5. Che cosa fa l’assembler e che cos’è un file oggetto?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> L’**assembler** traduce il programma scritto in linguaggio assembler in un **file oggetto**.
> 
> Il file oggetto contiene:
> 
> - istruzioni in linguaggio macchina;
>     
> - dati statici;
>     
> - informazioni sui simboli;
>     
> - informazioni di rilocazione;
>     
> - informazioni utili al debugger.
>     
> 
> Tuttavia, il file oggetto non è ancora necessariamente eseguibile, perché può contenere riferimenti non risolti ad altre procedure, variabili o librerie.
> 
> Per esempio, se un modulo chiama una procedura definita in un altro modulo, l’assembler non può conoscere l’indirizzo finale di quella procedura. Questo riferimento verrà risolto successivamente dal linker.
> 
> Quindi:
> 
> `assembler → file oggetto`
> 
> ma:
> 
> `file oggetto ≠ programma finale eseguibile`

---

## 6. Quali informazioni contiene tipicamente un file oggetto?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un file oggetto contiene diverse sezioni fondamentali:
> 
> - **Intestazione del file oggetto**
>     
>     - descrive la dimensione e la posizione delle varie parti del file.
>         
> - **Segmento di testo**
>     
>     - contiene il codice macchina, cioè le istruzioni tradotte.
>         
> - **Segmento dati**
>     
>     - contiene i dati statici allocati per tutta la durata dell’esecuzione.
>         
> - **Informazioni di rilocazione**
>     
>     - indicano quali istruzioni o dati devono essere aggiornati quando il programma viene caricato o collegato.
>         
> - **Tabella dei simboli**
>     
>     - contiene etichette e simboli usati nel programma, soprattutto quelli ancora da risolvere.
>         
> - **Informazioni per il debugger**
>     
>     - collegano il codice macchina al codice sorgente, rendendo possibile il debug.
>         
> 
> Queste informazioni permettono al linker di combinare correttamente più file oggetto.

---

## 7. Che cos’è la tabella dei simboli e a cosa serve?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La **tabella dei simboli** è una struttura contenuta nel file oggetto che associa nomi simbolici a indirizzi o riferimenti.
> 
> Può contenere, per esempio:
> 
> - etichette di procedure;
>     
> - nomi di variabili;
>     
> - riferimenti a simboli definiti in altri file;
>     
> - riferimenti a simboli ancora non risolti.
>     
> 
> Serve soprattutto durante il linking, perché il linker deve capire dove si trovano le procedure e i dati richiamati dai vari moduli.
> 
> Per esempio, se un file oggetto contiene una chiamata alla procedura `A`, ma `A` è definita in un altro file oggetto, il linker usa la tabella dei simboli per trovare l’indirizzo corretto e aggiornare il riferimento.

---

## 8. Che cosa sono le informazioni di rilocazione?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Le **informazioni di rilocazione** indicano quali parti del codice o dei dati devono essere modificate quando il programma viene collegato o caricato in memoria.
> 
> Sono necessarie perché, durante l’assemblaggio, l’assembler spesso non conosce ancora gli indirizzi definitivi di:
> 
> - istruzioni;
>     
> - procedure esterne;
>     
> - variabili globali;
>     
> - dati collocati in altri moduli.
>     
> 
> Quando il linker combina più file oggetto, deve aggiornare questi riferimenti con gli indirizzi reali.
> 
> Per esempio, una chiamata a una procedura esterna può inizialmente contenere un indirizzo provvisorio. Il linker, conoscendo la posizione finale della procedura, modifica l’istruzione inserendo l’indirizzo corretto.
> 
> La rilocazione permette quindi di compilare e assemblare moduli separatamente, senza conoscere subito la loro posizione finale in memoria.

---

## 9. Che cosa fa il linker?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il **linker** prende uno o più file oggetto e li combina per produrre un **file eseguibile**.
> 
> I suoi compiti principali sono:
> 
> 1. **Inserire in memoria simbolicamente codice e dati**
>     
>     - decide come disporre i moduli nel programma finale.
>         
> 2. **Determinare gli indirizzi delle etichette**
>     
>     - assegna indirizzi definitivi a procedure, variabili e simboli.
>         
> 3. **Correggere i riferimenti interni ed esterni**
>     
>     - aggiorna chiamate, salti e accessi ai dati che puntano a simboli di altri moduli.
>         
> 
> Il linker permette di compilare separatamente parti diverse di un programma e poi collegarle solo alla fine.
> 
> Questo è utile perché, se si modifica una sola procedura, non è necessario ricompilare tutto il programma: basta ricompilare quella procedura e rieseguire il linking.

---

## 10. Perché il linking è utile rispetto alla ricompilazione completa del programma?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il linking è utile perché consente la **compilazione separata**.
> 
> In un programma grande, le varie procedure possono essere compilate e assemblate in file oggetto indipendenti.
> 
> Se si modifica una sola procedura, non serve ricompilare tutto il programma:
> 
> - si ricompila solo il file modificato;
>     
> - si conserva il resto dei file oggetto;
>     
> - il linker ricombina tutto nel nuovo eseguibile.
>     
> 
> Questo rende lo sviluppo più veloce e modulare.
> 
> Inoltre, il linker permette di collegare il programma con librerie esterne, come le librerie standard, senza dover includere manualmente tutto il codice nel programma sorgente.

---

## 11. Che cos’è un file eseguibile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un **file eseguibile** è il risultato del lavoro del linker.
> 
> Contiene il programma in linguaggio macchina pronto per essere caricato in memoria ed eseguito.
> 
> A differenza di un file oggetto, il file eseguibile non dovrebbe contenere riferimenti non risolti per il normale caricamento statico.
> 
> Contiene:
> 
> - codice macchina;
>     
> - dati inizializzati;
>     
> - informazioni sulla disposizione dei segmenti;
>     
> - indicazioni per il loader.
>     
> 
> Il file eseguibile non viene eseguito direttamente dal disco: prima deve essere letto dal sistema operativo e caricato in memoria dal loader.

---

## 12. Che cosa fa il loader quando si avvia un programma?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il **loader** è il programma del sistema operativo che carica un file eseguibile in memoria e prepara l’esecuzione.
> 
> I suoi passaggi principali sono:
> 
> 1. legge l’intestazione del file eseguibile per conoscere la dimensione del segmento testo e del segmento dati;
>     
> 2. crea uno spazio di indirizzamento sufficientemente grande per codice e dati;
>     
> 3. copia le istruzioni e i dati del file eseguibile in memoria;
>     
> 4. copia nello stack eventuali parametri passati al programma;
>     
> 5. inizializza i registri, incluso lo stack pointer;
>     
> 6. salta alla routine di startup, che chiama la procedura principale del programma;
>     
> 7. quando il programma termina, restituisce il controllo al sistema operativo.
>     
> 
> Quindi il loader è il componente che rende concretamente possibile l’avvio del programma.

---

## 13. Qual è la differenza tra collegamento statico e caricamento dinamico delle librerie?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Nel **collegamento statico**, le librerie usate dal programma vengono incluse direttamente nel file eseguibile durante il linking.
> 
> Questo produce un eseguibile completo, ma ha alcuni svantaggi:
> 
> - il file eseguibile può diventare molto grande;
>     
> - ogni programma contiene una propria copia delle funzioni di libreria;
>     
> - se una libreria viene aggiornata, il programma deve essere ricollegato o ricompilato per usare la nuova versione;
>     
> - possono essere incluse anche funzioni di libreria non effettivamente usate.
>     
> 
> Nel **caricamento dinamico**, invece, le librerie non vengono collegate completamente prima dell’esecuzione.
> 
> Le librerie dinamiche vengono caricate quando servono, durante l’esecuzione del programma.
> 
> Questo permette:
> 
> - di ridurre la dimensione degli eseguibili;
>     
> - di condividere una stessa libreria tra più programmi;
>     
> - di aggiornare una libreria senza ricompilare tutti i programmi che la usano.
>     
> 
> Lo svantaggio è che la prima chiamata a una funzione di libreria dinamica richiede lavoro aggiuntivo per trovare e collegare la funzione.

---

## 14. Come funziona il caricamento dinamico di una libreria?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Nel caricamento dinamico, una funzione di libreria non viene collegata completamente prima dell’avvio del programma.
> 
> Al posto dell’indirizzo definitivo della funzione, il programma contiene un piccolo codice di collegamento, chiamato spesso **stub**.
> 
> Quando la funzione viene chiamata per la prima volta:
> 
> 1. il programma salta allo stub;
>     
> 2. lo stub chiama il linker-loader dinamico;
>     
> 3. il linker-loader dinamico trova la funzione nella libreria dinamica;
>     
> 4. aggiorna il riferimento con l’indirizzo reale della funzione;
>     
> 5. esegue la funzione richiesta.
>     
> 
> Dopo la prima chiamata, le chiamate successive possono andare direttamente alla funzione già risolta, senza ripetere tutto il processo.
> 
> Questo meccanismo viene chiamato **collegamento lazy**, perché il collegamento viene fatto solo quando una funzione serve davvero.

---

## 15. Quali sono vantaggi e svantaggi delle librerie a caricamento dinamico?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Le librerie a caricamento dinamico hanno diversi vantaggi:
> 
> - riducono la dimensione degli eseguibili;
>     
> - permettono a più programmi di condividere la stessa libreria;
>     
> - consentono di aggiornare una libreria senza ricompilare tutti i programmi;
>     
> - caricano solo le funzioni effettivamente usate.
>     
> 
> Tuttavia hanno anche alcuni svantaggi:
> 
> - richiedono informazioni aggiuntive per il collegamento dinamico;
>     
> - la prima chiamata a una funzione può essere più lenta;
>     
> - il sistema deve gestire la presenza e la compatibilità delle librerie;
>     
> - una libreria mancante o incompatibile può impedire l’esecuzione del programma.
>     
> 
> In sintesi, il caricamento dinamico migliora flessibilità e uso della memoria, ma introduce complessità aggiuntiva durante l’esecuzione.

---

## 16. Come viene avviato ed eseguito un programma Java rispetto a un programma C?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Un programma C viene normalmente compilato in codice macchina specifico per una certa architettura.
> 
> Un programma Java segue invece un modello diverso:
> 
> 1. il codice sorgente Java viene compilato in **bytecode Java**;
>     
> 2. il bytecode viene memorizzato nei file `.class`;
>     
> 3. il bytecode viene eseguito dalla **Java Virtual Machine**, o JVM;
>     
> 4. durante l’esecuzione, alcune parti del bytecode possono essere compilate in linguaggio macchina dal compilatore **Just In Time**, o JIT.
>     
> 
> Il bytecode Java è una rappresentazione intermedia: non è codice macchina per un processore reale specifico, ma codice per una macchina virtuale.
> 
> Questo rende Java più portabile, perché lo stesso bytecode può essere eseguito su piattaforme diverse, purché sia presente una JVM compatibile.

---

## 17. Che cos’è il bytecode Java?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Il **bytecode Java** è il linguaggio intermedio prodotto dalla compilazione di un programma Java.
> 
> Non è linguaggio macchina di un processore fisico specifico, ma è il linguaggio della **Java Virtual Machine**.
> 
> Il bytecode viene memorizzato nei file delle classi, cioè nei file `.class`.
> 
> La JVM può poi:
> 
> - interpretare direttamente il bytecode;
>     
> - oppure tradurre in codice macchina alcune parti del programma durante l’esecuzione.
>     
> 
> Il vantaggio principale è la portabilità:
> 
> lo stesso bytecode può essere eseguito su sistemi diversi, a condizione che esista una JVM per quei sistemi.

---

## 18. Che cos’è la Java Virtual Machine?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La **Java Virtual Machine**, o **JVM**, è un interprete software che esegue programmi Java compilati in bytecode.
> 
> La JVM nasconde i dettagli dell’architettura hardware sottostante.
> 
> Questo significa che un programma Java non deve essere ricompilato per ogni processore o sistema operativo: basta che sulla macchina sia disponibile una JVM compatibile.
> 
> La JVM può eseguire il bytecode in due modi:
> 
> - interpretandolo istruzione per istruzione;
>     
> - compilando dinamicamente le parti più usate tramite compilazione JIT.
>     
> 
> Il vantaggio principale della JVM è la **portabilità**.
> 
> Lo svantaggio tradizionale è che l’interpretazione pura è più lenta rispetto all’esecuzione di codice macchina nativo.

---

## 19. Che cos’è la compilazione Just In Time in Java?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> La compilazione **Just In Time**, o **JIT**, è una tecnica usata dalla JVM per migliorare le prestazioni dei programmi Java.
> 
> Invece di interpretare sempre il bytecode, la JVM osserva l’esecuzione del programma e individua le parti più usate, dette spesso parti “calde”.
> 
> Queste parti vengono tradotte durante l’esecuzione in codice macchina nativo.
> 
> Il codice macchina prodotto viene poi riutilizzato nelle esecuzioni successive della stessa parte del programma.
> 
> Questo migliora la velocità rispetto all’interpretazione pura.
> 
> Il compromesso è che la compilazione JIT richiede tempo e memoria durante l’esecuzione, quindi non tutto il codice viene compilato subito.

---

## 20. Qual è il compromesso principale tra portabilità e prestazioni nei programmi Java?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**

> [!answer]- Risposta  
> Java privilegia la **portabilità** grazie al bytecode e alla JVM.
> 
> Un programma Java può essere compilato una sola volta in bytecode ed eseguito su piattaforme diverse, purché abbiano una JVM.
> 
> Questo però introduce un livello software aggiuntivo tra il programma e l’hardware.
> 
> L’interpretazione del bytecode è generalmente più lenta rispetto all’esecuzione diretta di codice macchina nativo.
> 
> Per ridurre questo svantaggio si usa la compilazione **Just In Time**, che traduce in codice macchina le parti del programma più eseguite.
> 
> Quindi il compromesso è:
> 
> - **maggiore portabilità**, perché il bytecode è indipendente dall’architettura;
>     
> - **possibile perdita di prestazioni**, perché serve interpretazione o compilazione dinamica;
>     
> - **recupero parziale delle prestazioni** grazie al compilatore JIT.
>     
> 
> In sintesi, Java sacrifica parte della semplicità dell’esecuzione nativa per ottenere portabilità, compensando con tecniche dinamiche come il JIT.

---