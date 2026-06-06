/*
Scrivere una procedura RISC-V per il calcolo del minimo comune multiplo di due numeri interi positivi a e b, mcm(a,b), da richiamare nel main, utilizzando la seguente relazione:

mcm(a,b) = (a*b) / mcd(a,b)
Il valore di ritorno deve essere lasciato sul registro a0.
*/

.globl _start
.data
    num1: .word 5
    num2: .word 6
.text
_start:
    # call mcm
    la    a0, num1
    la    a1, num2
    lw    a0, 0(a0)
    lw    a1, 0(a1)     
    jal   ra, mcm

    #exit
    li    a7, 10
    ecall

#****************************************************
# completare la funzione mcm nel campo di sotto

mcm:

    # prologo - aprire il frame di attivazione
    addi sp, sp, -8
    sw ra, 4(sp) # registro salvato (sono quelli che vanno ripristinati)

    sw s1, 0(sp)

    mul s1, a0, a1
    jal mcd # non abbiamo bisogno di caricare i parametri perché sono già stati posizionati precedentemente (nel main)

    div a0, t0, a0

    # epilogo - chiudere il frame di attivazione
    lw s1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret 

mcd: # non ci interessa implementarlo