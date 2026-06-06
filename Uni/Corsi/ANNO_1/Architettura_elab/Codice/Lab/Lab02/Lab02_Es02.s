/*Si scriva un programma RISC-V che legga due numeri interi pari dalla memoria (num1 e num2) e calcoli la loro media aritmetica. Il risultato va salvato nella variabile di memoria result. In questo esercizio, utilizzare soltanto il set delle istruzioni intere di base rv32i (usare un'operazione di shift per eseguire la divisione per 2).*/

.globl _start
.data
    num1:   .word -4    # primo intero pari
    num2:   .word -8   # secondo intero pari
    result: .word 0    # spazio per il risultato

.text
_start:

    # completare il codice qui

    # carichiamo l'indirizzo per num1
    la t0, num1
    
    lw t1, 0(t0) # carichiamo num1
    lw t2, 4(t0) # carichiamo num2
    lw t3, 8(t0) # carichiamo result

    add t4, t2, t1 # somma dei due numeri

    srai t3, t4, 1 # media tramite shifting dei bit, qua utilizzo sra perché ho necessità di mantenere il segno e poi con la 'i' utilizzo una costante
    
    sw t3, 8(t0) # conservo il risultato

    # uscita dal programma
    li a7, 10
    ecall