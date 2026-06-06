/*
Scrivere una procedura chiamata equal(array, x, y) che restituisca 1 se il valore in array[x]è uguale al valore in array[y]. Altrimenti, la funzione deve restituire 0.
Il valore di ritorno deve essere inserito nel registro a0.


Il seguente codice in C implementa equal (convertilo in RISC-V):
// int (C) equivale a word (RISC-V)
int equal(int array[], int x, int y) {
    if (array[x] == array[y]) {
        return 1;
    } else {
        return 0;
    }
}
*/

    .globl _start
    .data        
         array: .word 1,5
    x:     .word 0
    y:     .word 1
        
    .text
    _start:
        # chiama equal
        la   a0, array
        la   a1, x
        lw   a1, 0(a1)
        la   a2, y
        lw   a2, 0(a2)
        jal  ra, equal
        
        #exit
        li   a7, 10
        ecall
    
    #***************************************************
    # completare la funzione equal nel campo di sotto

equal:

    li t0, 4
    mul t1, a1, t0
    mul t2, a2, t0

    add t1, a0, t1
    add t2, a0, t2

    lw t3, 0(t1)
    lw t4, 0(t2)

    beq t3, t4, SET_ONE
    addi a0, zero, 0
    
    ret

SET_ONE:
    addi a0, zero, 1
    ret
    