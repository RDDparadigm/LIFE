
1. Cos'è un unit time delay
2. Cos'è un serial adder
3. Definisci una macchina a stati finiti
4. Cos'è un diagramma di transizione
5. Cos'è il flip-flop S ed R
6. Definisci un'automa a stati finiti
7. Cosa significa che una stringa è accettata da un'automa a stati finiti
8. Quando due automi sono equivalenti
9. Differenza tra linguaggio naturale e formale
10. Definire una grammatica 
11. Cose la Backus normal form
12. Dato un'automa a stati finiti A, come si costruisce la grammatica regolare G in modo che il set di stringhe accettate da A siano anche L(G)
13. Definisci un'automa a stati finiti non-deterministico
14. Cosa significa che una stringa è accettata da un'automa a stati finiti non-deterministico
15. Quando due automi non-deterministici sono uguali
16. Data una grammatica regolare G, come si può costruire l'automa a stati finiti non-deterministico A in modo tale che il linguaggio generato da G sia uguale alle stringhe accettate da A
17. Dato un'automa a stati finiti non-deterministico, come si traduce nell'automa a stati finiti deterministico


---


1. Accetta un bit x al tempo t e restituisce xt-1. Vale solo per i circuiti sequenziali
2. Accetta due binari e ne ritorna la somma
3. E' un modello astratto di una macchina primitiva. Definita come
	1. Un I che rappresenta gli input
	2. Un O che rappresenta gli output
	3. Un S che rappresenta gli stati
	4. Una funzione f che manda da S x I in S
	5. Una funzione g che manda da S x I in O
	6. Uno stato iniziale che appartiene ad S
4. E' un diagramma che rappresenta la macchina a stati finiti
5. E' definibile tramite una macchina a stati finiti (vedi tabella negli appunti)
6. E' una macchina dove il set di output sono {0, 1} e lo stato attuale determina il prossimo output
	1. Un I che rappresenta gli input
	2. Un set di stati S
	3. Una funzione f che manda da S x I in S
	4. Un set A che rappresenta gli stati accettanti
	5. Uno stato iniziale che appartiene ad S
7. Quando termina in uno stato accettante
8. Quando hanno gli stessi stati S accettanti
9. Linguaggio naturale è il sistema di comunicazione umano. Il linguaggio formale sono modelli di linguaggio naturale usati per comunicare con i computer
10. Un set finito N di non terminali
	Un set finito T di terminali con N intersezione T uguale all'insieme vuoto
	Un sottoset finito P di produzioni
	Un simbolo di partenza omega appartenente ai non terminali
11. E' una forma dove i simboli non terminali sono circondati da < > mentre le produzioni sono separate da | e scritte S ::= T1 | T2 | Tn
12. Si costruiscono le produzioni per ogni freccia dell'automa, con le produzioni per gli stati accettanti della forma S -> lambda
13. Un'automa a stati finiti non-deterministico è definito come
	1. Un set I di input
	2. Un set S di stati finiti
	3. Una funzione f da S x I in P(S) con P che rappresenta il power-set degli stati
	4. Un sottoset A di stati accettanti
	5. Uno stato iniziale che appartiene ad S
14. Quando termina in uno stato accettante
15. Quando hanno gli stessi stati accettatni
16. Il set di input = set dei terminali, set degli stati = set dei non terminali; le produzioni corrispondono alle frecce che mandano alle transizioni
17. Gli stati sono tutti i subset del set S. Gli stati accettanti sono tutti i subset che contengono almeno uno stato accettante