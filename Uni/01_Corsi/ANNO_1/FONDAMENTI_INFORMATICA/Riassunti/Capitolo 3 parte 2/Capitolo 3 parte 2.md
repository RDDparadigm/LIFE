
## 3.1 Functions

==Funzione== > Subset del prodotto cartesiano di due insiemi X x Y, dove per ogni x appartenente ad X (dominio) c'è anche una y appartenente ad Y (codominio) con (x, y) appartenenti alla funzione f

Esempio di grafico di una funzione, il ==range== della funzione è {a, b}

![[Pasted image 20250524110532.png]]


Funzione ==iniettiva== > per ogni elemento X nel dominio esiste ==una ed una sola== Y nel codominio
![[Pasted image 20250524111534.png]]

Per le dimostrazioni: quando bisogna dimostrare se una funzione è iniettiva per tutti i valori, se è vero che f(x1) = f(x2) allora deve valere che x1 = x2


Funzione ==suriettiva== > per ogni elemento Y del codominio esiste almeno una X associata

![[Pasted image 20250524112250.png]]

Controesempio: per ogni x appartenente ad X, esiste f(x) != y, quindi nessuna funzione manda in Y


Funzione ==biiettiva== > Una funzione ==iniettiva== e ==suriettiva==
- |X| = |Y|


Funzione ==inversa==

![[Pasted image 20250524115922.png]]


Funzione ==composta==

![[Pasted image 20250524120729.png]]


## 3.2 Sequences and Strings

Una ==sequenza== è una funzione dove il dominio è un sottoinsieme di interi

Può dividersi nei seguenti sottotipi:
- ==Increasing== > per tutti gli i, j se i < j allora Si < Sj
- ==Decreasing== > per tutti gli i, j se i < j allora Si > Sj
- ==Nondecreasing== > per tutti gli i, j se i < j allora Si <= Sj
- ==Nonincreasing== > per tutti gli i, j se i < j allora Si >= Sj

es. 100 - 90 - 90 - 30 è Nonincreasing ma non è Decreasing, ad esempio S2 non è maggiore di S3


Una ==sottosequenza== è una sequenza ottenuta scegliendo alcuni termini di una sequenza s nello stesso ordine in cui appaiono (ma non necessariamente consecutivi come posizione)

Una sottosequenza è denotata Snk

Un esempio


![[Pasted image 20250523213622.png]]

Una ==stringa== è una sequenza finita di caratteri

==Superscript== > raggruppa le ripetizioni (es. abbbaccab si può scrivere ab<sup>3</sup>ac<sup>2</sup>ab)

Una ==sottostringa== è una sequenza di caratteri ==consecutivi== di una data stringa

## 3.3 Relations

Relazione ==binaria== -> x R y (x è in relazione con y)

Una ==funzione== è una relazione che associa ad una x esattamente una y

Un digrafo che rappresenta la relazione:

	R = {(1,1), (1,2), (1,3), (1,4), (2,2), (2,3), (2,4), (3,3), (3,4), (4,4)}

![[Pasted image 20250520204221.png]]

Relazione ==riflessiva== -> quando (x, x) appartiene alla relazione R per ogni x appartenente ad X


Relazione ==simmetrica== -> per ogni x, y appartenenti ad X valgono le relazioni xRy ed yRx


Un digrafo di relazione simmetrica

![[Pasted image 20250520204708.png]]


Relazione ==antisimmetrica== -> per ogni xRy vale yRx solo se x = y

Un digrafo di relazione simmetrica

![[Pasted image 20250520210237.png]]

Relazione ==transitiva== -> per ogni x, y, z vale che se xRy ed yRz allora xRz

Esplicitazione simbolica

![[Pasted image 20250520210835.png]]


Relazione in ==ordine parziale== -> quando è riflessiva, antisimmetrica e transitiva

==Ordine totale== -> tutti gli elementi della relazione sono confrontabili


Relazione ==inversa== -> se xRy allora yRx


Relazione composta -> 

![[Pasted image 20250523163523.png]]

## 3.4 Equivalence Relations


Una relazione si definisce d'==equivalenza== quando è riflessiva, transitiva e simmetrica



Non sono state spiegate le classi d'equivalenza