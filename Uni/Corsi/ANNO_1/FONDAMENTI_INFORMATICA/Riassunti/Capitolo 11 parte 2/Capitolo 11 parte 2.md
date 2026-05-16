

Un ==circuito combinatorio== è sempre definito da un output


Esempio di un circuito combinatorio

![[Pasted image 20250524123948.png]]


Circuiti combinatori possono essere connessi tra loro

![[Pasted image 20250524124254.png]]


Un circuito combinatorio può essere rappresentato tramite un ==espressione booleana==

![[Pasted image 20250524124412.png]]

Come regola vale che l'AND è valorizzato prima dell'OR in assenza di parentesi


## 11.2 Properties of combinatorial circuits


Valgono le seguenti proprietà


==Associativa==

![[Pasted image 20250524131057.png]]


==Commutativa==

![[Pasted image 20250524131119.png]]



==Distributiva==

![[Pasted image 20250524131141.png]]



==Identità==

![[Pasted image 20250524131202.png]]



==Complemento==

![[Pasted image 20250524131222.png]]



Due espressioni booleane sono ==uguali== quando, prese le loro tabelle di verità, ogni coppia di input restituisce lo ==stesso output== su tutte le espressioni prese in oggetto

![[Pasted image 20250524131837.png]]



Due circuiti combinatori si dicono ==equivalenti== quando, dati gli stessi input, entrambi producono lo ==stesso output==



## 11.3 Boolean Algebra


Leggi dell'algebra Booleana


==Associativa==

![[Pasted image 20250524132709.png]]



==Commutativa==

![[Pasted image 20250524132733.png]]



==Distributive==

![[Pasted image 20250524132753.png]]



==Identità==

![[Pasted image 20250524132816.png]]



==Complemento==

![[Pasted image 20250524132834.png]]



==Idempotenza==

![[Pasted image 20250524133040.png]]



==Legame==

![[Pasted image 20250524133059.png]]



==Assorbente==

![[Pasted image 20250524133135.png]]



==Involuzione==

![[Pasted image 20250524133158.png]]



==Legge dello 0 ed 1==

![[Pasted image 20250524133222.png]]



==De Morgan==

![[Pasted image 20250524133248.png]]


Il ==duale== di un espressione Booleana si può ottenere sostituendo 0 con 1, 1 con 0, + con * e * con + (vedi De Morgan)


## 11.4 Boolean functions and Synthesis of Circuits


Tabella ==exclusive-OR==

![[Pasted image 20250524151348.png]]



==Funzioni booleane ==> funzioni rappresentabili data un espressione booleana


Definite come

![[Pasted image 20250524151538.png]]


==Miniterm== > è un espressione booleana nella forma y1 AND y2 AND yn dove ogni yi è xi o cmpl(x)i


DNF (==Disjunctive Normal Form==) > Modalità per rappresentare una funzione booleana, è un "OR di AND"

Alcune regole da rispettare per una DNF:
- Tutte le variabili della tabella di verità sono incluse
- Ogni variabile appare una sola volta per ogni espressione

Esempio con lo ==XOR==, abbiamo messo tra parentesi, e separati da AND, tutte le variabili booleane per cui la tabella di verità restituisce 1, mentre separiamo ogni espressione con l'OR

![[Pasted image 20250524152748.png]]


## 11.5 Applications


Un ==gate== è una funzione da Z<sup>n</sup><sub>2</sub> a Z<sub>2</sub> (che corrisponde ad un singolo bit di output)


Un set di gate è ==funzionalmente completo== quando consente un circuito che calcola una funzione f


Circuito combinatorio per rappresentare x OR y utilizzando il set funzionalmente completo {AND, NOT}

![[Pasted image 20250524160815.png]]



Gate NAND

![[Pasted image 20250524160947.png]]


Un paio di regole per semplificare delle espressioni booleane

![[Pasted image 20250524161533.png]]

![[Pasted image 20250524161546.png]]


Tabella che rappresenta un ==half adder==, dove la colonna c rappresenta il carry, ovvero il bit di risporto, ed s la somma dei bit x ed y


![[Pasted image 20250524164856.png]]

Circuito ==half adder==

![[Pasted image 20250524165539.png]]



Tabella che rappresenta un ==full adder==, con c che rappresenta il bit carry ed s che rappresenta la somma dei bit x, y e z

![[Pasted image 20250524165627.png]]

Circuito ==full adder==

![[Pasted image 20250524165659.png]]