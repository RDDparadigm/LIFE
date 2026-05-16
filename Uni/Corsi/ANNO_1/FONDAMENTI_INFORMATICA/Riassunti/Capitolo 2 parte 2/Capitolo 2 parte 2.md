
## 2.2 More methods of proofs


#### Dimostrazione per contraddizione


Nella forma ==r AND NOT(r)==


Tabella di verità

![[Pasted image 20250527135319.png]]


Definita l'ipotesi e la conclusione, andiamo a ==negare la conclusione==. Se la negazione della conclusione va' in conflitto con la conclusione, allora l'ipotesi e la conclusione fatti inizialmente sono veri



#### Dimostrazione per contrapposizione


Nella forma ==p -> q e NOT(p) -> NOT(q)== sono equivalenti


#### Dimostrazione per casi (dimostrazione esaustiva)


![[Pasted image 20250527140751.png]]


#### Dimostrazione per equivalenza


![[Pasted image 20250527141240.png]]



#### Dimostrazione d'esistenza


![[Pasted image 20250527143937.png]]


## 2.3 Resolution Proofs


![[Pasted image 20250528141417.png]]

==Clausola== > termini (singoli) separati dall'OR 
- clausola p OR NOT(q) OR z
- non è clausola xz OR p OR NOT(A) perché xz sono due variabili



## 2.4 Mathematical induction

![[Pasted image 20250528150022.png]]


Definiamo S(n) ==caso base== e S(n+1) ==passo induttivo==


==Invariante di ciclo== > dichiarazione che è vera prima di un ciclo ed è vera dopo ogni iterazione del ciclo

Lo step base dell'invariante di ciclo prova che l'invariante è vera prima che il controllo entri nel ciclo

Lo step induttivo assume che l'invariante sia vera e prova che se la condizione che controlla il ciclo è vera allora l'invariante è vera dopo che il corpo del ciclo è stato eseguito


## 2.5 Strong form of Induction and the well-ordering property


Nell'induzione forte prendiamo in considerazione:

- P(n0)
- Per ogni k >= n0

Se per ogni i <= k vale P(i), allora vale P(k  + 1)
