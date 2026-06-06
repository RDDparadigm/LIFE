/*
Implementa un programma in linguaggio RISC-V che prenda in input due numeri interi da memoria e calcoli la somma dei quadrati di entrambi i numeri. Il risultato deve essere salvato in un'ulteriore posizione di memoria contigua.
*/

.globl _start
.data
    num1:    .word 5        # primo numero
    num2:    .word 7        # secondo numero
    result:  .word 0        # spazio per il risultato
    
.text
    _start:
    

    # completare il codice qui

    la t0, num1

    lw t1, 0(t0)
    lw t2, 4(t0)
    lw t3, 8(t0)

    mul t1, t1, t1 # funzione di moltiplicazione 
    mul t2, t2, t2

    add t3, t1, t2

    sw t3, 8(t0) # nell'istruzione sw (store word), il primo parametro rappresenta la variabile che vogliamo salvare, il secondo il registro in questione

    # uscita dal programma
    li a7, 10   # codice di uscita
    ecall