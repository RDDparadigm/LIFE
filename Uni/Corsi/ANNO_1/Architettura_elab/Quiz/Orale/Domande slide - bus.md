# Il Bus

## Metodo di ripasso

Ripassa questa sezione concentrandoti su tre livelli:

1. **Struttura del bus:** cosa collega, quali linee contiene e cosa cambia tra architetture classiche e moderne.
2. **Funzionamento del trasferimento:** differenza tra bus sincrono e asincrono, con particolare attenzione al ciclo di lettura.
3. **Gestione del conflitto:** perché serve l’arbitraggio e quali sono le principali tecniche.

Per l’orale prova a rispondere sempre seguendo questo schema: definizione → problema → soluzione → vantaggi/svantaggi.

---

## 1. Che cos’è un bus e qual è il suo ruolo in un elaboratore?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un bus è l’insieme di linee elettriche che collegano tra loro i moduli di un elaboratore, permettendo lo scambio di informazioni.
>
> In un’architettura classica il bus può collegare CPU, memoria e dispositivi di I/O.  
> Esistono bus di tipo diverso:
>
> - **bus di sistema**, che interconnette CPU, memoria e schede di I/O;
> - **bus interni al chip**, che collegano i moduli interni della CPU.
>
> Il funzionamento del bus non dipende solo dai fili fisici, ma anche da un insieme di regole chiamato **protocollo del bus**, che stabilisce come avvengono le comunicazioni.

---

## 2. Quali sono le principali linee di un bus e a cosa servono?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Le linee principali di un bus sono:
>
> - **linee dati**, che trasportano i dati veri e propri;
> - **linee indirizzi**, che indicano la sorgente o la destinazione dei dati;
> - **linee di controllo**, che regolano l’accesso e l’uso delle linee dati e indirizzi.
>
> La larghezza del bus dati determina quanti bit possono essere trasferiti in una singola operazione, quindi influenza le prestazioni.  
> La larghezza del bus indirizzi determina invece quante celle di memoria possono essere indirizzate.

---

## 3. Che relazione c’è tra numero di linee di indirizzo, numero di linee dati e capacità del bus?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Se una CPU ha **n linee di indirizzo**, può indirizzare:
>
> `2^n`
>
> celle di memoria diverse.
>
> Se invece ha **m linee dati**, può trasferire **m bit alla volta** in una singola operazione.
>
> Quindi:
>
> - più linee di indirizzo significano maggiore spazio di memoria indirizzabile;
> - più linee dati significano maggiore quantità di informazione trasferibile per operazione.
>
> Ad esempio, un bus con 32 linee dati può trasferire 32 bit alla volta.

---

## 4. Che differenza c’è tra dispositivi attivi e passivi collegati a un bus?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I dispositivi collegati a un bus possono essere:
>
> - **attivi**, se possono iniziare autonomamente un trasferimento;
> - **passivi**, se rimangono in attesa di richieste da parte di altri dispositivi.
>
> I dispositivi attivi sono collegati tramite un **bus driver**, mentre quelli passivi tramite un **bus receiver**.
>
> Alcuni dispositivi, come la CPU, possono comportarsi sia da attivi sia da passivi. In questo caso usano un componente combinato chiamato **bus transceiver**.

---

## 5. Quali sono i principali problemi nella progettazione di un bus?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I principali problemi nella progettazione di un bus sono:
>
> - **larghezza del bus**, cioè il numero di linee disponibili per dati e indirizzi;
> - **arbitraggio**, cioè il modo in cui si decide quale dispositivo può usare il bus quando più dispositivi lo richiedono contemporaneamente;
> - **funzionamento del bus**, cioè il protocollo con cui avviene il trasferimento dei bit.
>
> Questi aspetti influenzano prestazioni, complessità hardware, costi e flessibilità del sistema.

---

## 6. Che cos’è un bus sincrono e come funziona?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **bus sincrono** usa una linea di clock comune, generata da un oscillatore.
>
> Tutte le attività avvengono in multipli interi del ciclo di clock. Questo significa che le fasi della comunicazione hanno una durata nota ai dispositivi coinvolti.
>
> Il vantaggio è che il protocollo è relativamente semplice da realizzare, perché i dispositivi sanno quando devono eseguire le varie operazioni.
>
> Lo svantaggio è che la durata di una comunicazione deve essere pari a un numero intero di cicli di clock e spesso il bus deve adattarsi al dispositivo più lento.

---

## 7. Come avviene un ciclo di lettura su un bus sincrono?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> In un ciclo di lettura su bus sincrono:
>
> 1. La CPU mette l’indirizzo sul bus.
> 2. Dopo un certo tempo di stabilizzazione, indicato come **TAD**, l’indirizzo diventa valido.
> 3. La CPU attiva i segnali di richiesta di comunicazione e il segnale di lettura.
> 4. Se la memoria non è pronta, può attivare un segnale di attesa, come **WAIT**.
> 5. Quando i dati sono pronti, la memoria li mette sul bus dati.
> 6. La CPU legge i dati.
> 7. Dopo la lettura, la CPU disattiva i segnali di richiesta e di lettura.
>
> Questo meccanismo è scandito dal clock, quindi le varie fasi devono rispettare i cicli temporali previsti.

---

## 8. Che cos’è un bus asincrono e perché può essere utile?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Un **bus asincrono** non usa un clock globale.
>
> Ogni comunicazione può durare un tempo diverso e viene coordinata tramite segnali di sincronizzazione, cioè tramite un meccanismo di **handshaking**.
>
> È utile quando i dispositivi collegati al bus hanno velocità molto diverse, perché non obbliga tutti ad adattarsi a un unico clock o al dispositivo più lento.
>
> La durata dell’operazione dipende quindi dalla velocità effettiva della coppia di dispositivi che sta comunicando.

---

## 9. Come funziona il full handshake in un bus asincrono?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nel bus asincrono la comunicazione avviene tramite segnali di sincronizzazione tra chi richiede il trasferimento e il dispositivo che risponde.
>
> Il meccanismo può essere riassunto così:
>
> 1. Il master attiva i segnali di accesso, ad esempio richiesta memoria e lettura.
> 2. Il master attiva il proprio segnale di sincronizzazione.
> 3. Il dispositivo slave esegue l’operazione richiesta.
> 4. Quando ha terminato, lo slave attiva il proprio segnale di sincronizzazione.
> 5. Il master acquisisce i dati e poi nega i segnali di richiesta.
> 6. Lo slave, dopo aver visto la negazione del segnale, nega a sua volta il proprio segnale.
>
> Si parla di **full handshake** perché la comunicazione richiede una sequenza completa di richiesta, risposta e conferma di chiusura.

---

## 10. Quali sono vantaggi e svantaggi di bus sincrono e bus asincrono?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Il **bus sincrono** ha il vantaggio di essere più semplice da realizzare, perché tutti i dispositivi seguono un clock comune. Inoltre, se la durata delle operazioni è fissa, non serve necessariamente una linea di attesa.
>
> Lo svantaggio è che ogni operazione deve durare un numero intero di cicli di clock e il sistema può essere penalizzato dai dispositivi più lenti.
>
> Il **bus asincrono** è più flessibile, perché la durata dell’operazione dipende dalla velocità dei dispositivi coinvolti.
>
> Lo svantaggio è che richiede più segnali e una logica di controllo più complessa: per completare una comunicazione sono necessarie più azioni di handshaking.

---

## 11. Perché serve l’arbitraggio del bus?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> L’arbitraggio del bus serve quando più dispositivi vogliono usare il bus contemporaneamente.
>
> Se due dispositivi trasmettessero nello stesso momento, le informazioni presenti sul bus diventerebbero ambigue o errate.
>
> Per evitare conflitti, serve un meccanismo che stabilisca quale dispositivo ottiene il controllo del bus.
>
> Le principali soluzioni sono:
>
> - **arbitraggio centralizzato**, con un arbitro che assegna il bus;
> - **arbitraggio decentralizzato**, in cui i dispositivi partecipano direttamente alla decisione.

---

## 12. Come funziona l’arbitraggio centralizzato con daisy chaining?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nell’arbitraggio centralizzato esiste un **arbitro** che riceve le richieste di utilizzo del bus.
>
> Quando vede una richiesta attiva, l’arbitro attiva una linea di **bus grant**, cioè di concessione del bus.
>
> Nel meccanismo di **daisy chaining**, il grant viene propagato lungo una catena di dispositivi. Il primo dispositivo che ha richiesto il bus intercetta il grant e ottiene il controllo.
>
> Questo sistema dà priorità ai dispositivi più vicini all’arbitro.  
> Per questo motivo è semplice, ma può essere poco equo se alcuni dispositivi sono sempre più favoriti di altri.

---

## 13. Che cosa cambia nell’arbitraggio con più livelli di priorità?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nell’arbitraggio con più livelli di priorità esistono diverse linee di richiesta e concessione, associate a livelli di priorità differenti.
>
> Il meccanismo di assegnamento può essere simile al daisy chaining, ma i dispositivi con priorità più alta vengono serviti prima.
>
> È importante scegliere attentamente le priorità, perché una cattiva scelta può causare situazioni in cui alcuni dispositivi ottengono spesso il bus e altri rimangono penalizzati.
>
> In questi sistemi può essere usata anche una linea di **acknowledge**, per confermare l’assegnazione del bus.

---

## 14. Che cos’è l’arbitraggio decentralizzato del bus?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nell’arbitraggio decentralizzato non esiste un arbitro unico.
>
> Una possibile soluzione usa tante linee quanti sono i dispositivi: ogni dispositivo osserva le linee degli altri prima di effettuare la richiesta.
>
> Questa soluzione elimina il costo dell’arbitro centralizzato, ma è poco flessibile.
>
> Un’altra soluzione usa tre linee principali:
>
> - **bus request**;
> - **busy**;
> - **linea di arbitraggio**.
>
> Questa soluzione può essere più economica e più veloce del daisy chaining centralizzato.

---

## 15. Perché nei sistemi moderni si è passati dai bus paralleli ai bus seriali ad alta velocità?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> I bus tradizionali, come ISA, EISA e PCI, usavano trasmissione parallela: più linee trasmettevano simultaneamente i bit di una parola.
>
> In teoria questo sembrava più veloce, ma nella pratica presenta diversi limiti:
>
> - interferenza tra linee, detta **crosstalk**;
> - problemi di sincronizzazione;
> - costi elevati;
> - distanze limitate.
>
> I bus seriali moderni, come USB, PCI Express, SATA e Thunderbolt, trasmettono i dati un bit alla volta, ma raggiungono velocità molto elevate grazie a tecniche di codifica, serializzazione e trasmissione ad alta frequenza.
>
> Inoltre riducono interferenze, costi e problemi sulle lunghe distanze.

---

## 16. Come si è evoluta l’architettura dei bus nei sistemi moderni?

**Stato:** 🔴  
**Ultimo ripasso:**  
**Note mie:**  

> [!answer]- Risposta
> Nelle architetture classiche si usava un bus condiviso tra CPU, memoria e periferiche.
>
> Successivamente si è passati ad architetture con componenti come **Northbridge** e **Southbridge**, poi a soluzioni come il **Platform Controller Hub**.
>
> Nei sistemi moderni il bus condiviso è stato in gran parte sostituito da:
>
> - bus seriali ad alta velocità, come PCIe, USB, SATA e NVMe;
> - connessioni **point-to-point**, ad esempio tra CPU e RAM o tra CPU e GPU;
> - sistemi SoC con interconnessioni avanzate, come AMBA, AXI e NoC.
>
> L’evoluzione va quindi verso collegamenti dedicati, più veloci e più scalabili rispetto al vecchio bus condiviso.