/*
Scrivere una procedura sumarray che calcoli la somma di un array di size word in memoria.


Il seguente codice in C realizza sumarray (convertilo in RISC-V):
int sumarray(int[] array, int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += array[i];
    }
    return sum;
}

Come esercizio alternativo, preparare una soluzione ricorsiva seguendo il codice riportato di seguito:
int sumarray(int[] array, int size) {
    if (size == 0) {
        return 0;
    } else {
        return array[0] + sumarray(array+1, size-1);
    }
}
*/

.globl _start
.data
    array: .word  1,2,3,4,5,6,7,8,9,10
    size:  .word  10
    
.text
_start:
    # chiama sumarray
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  ra, sumarray
    
    #exit
    li   a7, 10
    ecall

#****************************************************
# completare la funzione sumarray nel campo di sotto

sumarray:
    
    beqz a1, RET0

    # preparo il frame di attivazione per la chiamata ricorsiva
    # (prologo)
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp) # dobbiamo salvarlo per recuperarlo poi dopo, non basta fare la lw

    # carico il primo elemento dell'array
    lw s0, 0(a0)

    # imposto i parametri per la chiamata ricorsiva
    # qui non avrei potuto utilizzare slli, si utilizza nel caso iterativo!!! 
    addi a0, a0, 4 # prossimo elemento (array+1)
    addi a1, a1, -1 # riduco la size
    jal sumarray # chiamata ricorsiva
    # sumarray(array+1, size-1)

    add a0, s0, a0

    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret
    
RET0:
    addi a0, zero, 0
    ret    