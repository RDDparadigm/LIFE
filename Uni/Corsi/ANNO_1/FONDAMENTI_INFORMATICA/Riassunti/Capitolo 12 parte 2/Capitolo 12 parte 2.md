
==Decoder== > prende in input n bit e seleziona una tra le 2<sup>n</sup> uscite disponibili

![[Pasted image 20250524175019.png]]


==Multiplexer== > prevede un'uscita e degli ingressi di controllo (s0, s1) che determinano quale ingresso deve essere selezionato per l'uscita

![[Pasted image 20250524175414.png]]


==Unit time delay==

![[Pasted image 20250524172947.png]]


==Macchina a stati finiti==

![[Pasted image 20250525170608.png]]

Viene definita ==deterministica== in quanto ad un input corrisponde sempre un output

Rappresentiamo una macchina a stati in ==forma tabellare==

![[Pasted image 20250525171421.png]]


Rappresentazione a ==digrafo==

![[Pasted image 20250525171440.png]]



## 12.2 Automa a stati finiti


Un' ==automa a stati finiti== è una macchina in cui il set di stati è =={0, 1}== e lo stato corrente definisce l'output. Gli stati dove gli output corrispondono ad 1 sono definiti ==stati accettanti==


Tabella di un'automa a stati finiti

![[Pasted image 20250525174000.png]]


Digrafo di un'automa a stati finiti, con gli stati finiti doppiamente cerchiati e gli output rimossi dalle etichette

![[Pasted image 20250525174024.png]]


In definitiva, possiamo definire un'automa a stati finiti come

![[Pasted image 20250525174211.png]]


Due automi a stati finiti sono ==equivalenti== quando hanno gli stessi stati accettanti


## 12.3 Languages and grammar


Definizione di una grammatica

![[Pasted image 20250525193819.png]]



Tipologie di grammatiche:

- ==Context sensitive== > dipendono dal contesto

![[Pasted image 20250525195016.png]]


- ==Context-free== > non dipendono dal contesto, con A che può essere sostituita in maniera indipendente sia con terminali che con non terminali

![[Pasted image 20250525195046.png]]


- ==Grammatica regolare==

![[Pasted image 20250525195133.png]]

 I linguaggi context-free (escluso il null) sono un subset dei context-sensitive

I linguaggi regolari sono un subset dei context-free


## 12.4 Non-deterministic finite state automat


Il seguente teorema definisce come ==ogni grammatica può essere trasformata in un'automa== e come il set delle stringhe accettate da A equivale al ==linguaggio della grammatica== (L(G))

![[Pasted image 20250526145441.png]]

Se A è un'automa a stati finiti allora Ac (A) è un ==linguaggio regolare==


Definiamo un'automa non deterministico a stati finiti in questo modo. La funzione f manda da S ad I nel powerset degli stati (questo torna utile quando bisogna convertire un'automa da non-deterministico a deterministico)

![[Pasted image 20250526150801.png]]


La differenza risiede negli stati. In un'automa di questo tipo, possiamo ricadere in più stati

![[Pasted image 20250526151003.png]]


## 12.5 Relationships between languages and automata


Digrafo di un'automa a stati finiti non-deterministico convertito in deterministico

Definiamo come stati il ==powerset degli stati==


![[Pasted image 20250526154302.png]]


==SR flip-flop== (set-reset flip-flop). Ricorda i valori di S ed R che risulteranno in Q

![[Pasted image 20250530144629.png]]