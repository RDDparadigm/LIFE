/*
Si scriva un programma in linguaggio RISC-V che carichi 4 numeri interi presente nella memoria in word contigue e calcoli il valore intero della loro media aritmetica (arrotondamento per difetto). Il valore calcolato va salvato in un'ulteriore posizione della memoria contigua a quelle usate per il calcolo. In questo esercizio, utilizzare soltanto il set delle istruzioni intere di base rv32i
*/

.globl _start
.data
    numbers: .word 12, 16, 20, 24  # numeri di esempio
    result:  .word 0               # spazio per il risultato

.text
_start:
    
    # completare il codice qui

    # load address di numbers
    la t0, numbers
    la t5, result

    # carichiamo sui registri i numeri e il result
    lw t1, 0(t0)
    lw t2, 4(t0)
    lw t3, 8(t0)
    lw t4, 12(t0)
    lw t5, 16(t0)

    add t1, t1, t2 # facciamo la somma dei primi 2
    add t3, t3, t4 # facciamo la somma degli ultimi 2

    add t4, t1, t3 # facciamo la somma di tutti

    srai t5, t4, 2 # dividiamo per 4, divisione per 2^n con lo shifting dei bit

    sw t5, 16(t0) # conserviamo il risultato

    # uscita
    li a7, 10   # codice di uscita
    ecall