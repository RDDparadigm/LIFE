
1. Cos'è un circuito combinatorio
2. Cos'è un circuito sequenziale
3. Cos'è un invertitore
4. Qual è la tabella logica di un circuito combinatorio
5. Legge identità per AND e OR
6. Quando due espressioni booleane sono uguali
7. Quando due circuiti combinatori sono uguali
8. Qual è la relazione tra le espressioni combinatorie e le espressioni booleane che le rappresentano
9. Definisci algebra booleana
10. Legge d'idempotenza
11. Legge legame
12. Legge dell'assorbimento
13. Legge dell'involuzione
14. Legge dello 0/1
15. Legge di De Morgan
16. Come si ottiene il duale di un espressione booleana
17. Definisci l'exclusive-OR
18. Cos'è una funzione Booleana
19. Cos'è un minitermine
20. Cos'è la DNF
21. Come si ottiene la DNF
22. Cos'è un maxitermine
23. Cos'è la CNF
24. Cos'è un gate
25. Cos'è un gate funzionalmente completo
26. Esempi di gate funzionalmente completi
27. Gate NAND
28. Il set {NAND} è funzionalmente completo?
29. Cos'è il problema della minimizzazione
30. Descrivi il circuito half-adder
31. Descrivi il circuito full-adder





# Risposte

1. Un circuito che ha un output sempre definito. Il circuito non ha memoria dei precedenti stati
2. Un circuito in cui l'output è una funzione
3. Il gate NOT
4. Una tabella che mostra tutti i gli input e gli output possibili
5. a OR 0 = a; a AND 1 = a
6. Quando le loro tabelle di verità sono uguali
7. Quando dati degli stessi input, producono gli stessi output
8. I circuiti combinatori sono rappresentabili dalle espressioni booleane. Quando due espressioni booleane sono uguali possiamo dire che lo sono anche i circuiti ad esse associati
9. E' un set del tipo B = {S, +, -, ', 0, 1}
10. x + x = x; xx = x
11. x + 1 = x; x0 = 0
12. x + xy = x; x (x + y) = x
13. (x')' = x
14. 0' = 1; 1' = 0
15. (x + y)' = x'y'; (xy)' = x' + y'
16. Sostituendo 0 con 1 e + con *
17. 0 quando 1 ed 1 e 0 e 0, altrimenti 1
18. f(x1, .. ,xn) = X(x1, .. xn)
19. E' una sequenza di termini all'interno di un espressione separati dall'AND
20. E' la rappresentazione di una funzione Booleana
21. Si combinano tutte le variabili che nella tabella di verità hanno restituito 1. In tutte le espressioni devono essere contenute tutte le variabili, scritte con x o NON(x)
22. E' una combinazione di termini all'interno di un espressione separati dall'OR
23. E' l'opposto di una DNF
24. E' una funziona da Z<sup>n</sup><sub>2</sub> a Z<sub>2</sub>
25. E' un gate che può costruire un circuito combinatorio che computa una funzione f utilizzando solo i gate definiti
26. {AND, NOT} {OR, NOT}, {AND, OR, NOT}
27. 0 quando 1 ed 1, altrimenti 1
28. Si
29. La riduzione del numero di gate di un circuito combinatorio tramite la semplificazione della sua espressione booleana in disjunctive normal form
30. E' un circuito con due input, x ed y, e due output, c ed s, dove s rappresenta la somma degli input e c il carry, ovvero il bit in eccesso
31. E' un circuito con tre input, x y e z, e due output, c ed s, dove s rappresenta la somma degli input e c il carry, ovvero il bit in eccesso. L'unica situazione dove carry e somma sono entrambi valorizzati ad 1 è quando tutte le variabili hanno valore 1