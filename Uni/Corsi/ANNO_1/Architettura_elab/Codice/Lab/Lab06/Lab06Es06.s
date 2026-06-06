/*Scrivere una procedura chiamata palindrome(array, size) che restituisca 1 se l'array di interi array di dimensione size è palindromo, 0 altrimenti.

Il valore di ritorno deve essere inserito nel registro a0.

Assumere che size sia maggiore di 1.


Il seguente codice in C implementa palindrome (convertilo in RISC-V):
// int (C) equivale a word (RISC-V)    
int palindrome(int array[], int size) {    
    int i = 0;
    int j = size - 1;
    int result = 1;    

    while (i < j) {   
        result = result & equal(array, i, j);
        i++;
        j--;
    }    
    return result;    
} */

.globl _start
.data
    array: .word 1,2,3,4,5,4,3,2,1
    size:  .word 9
    
.text
_start:
    # chiama palindrome
    la   a0, array
    la   a1, size
    lw   a1, 0(a1)
    jal  ra, palindrome
    
    #exit
    li   a7, 10
    ecall

#*********************************************************
# completare la funzione palindrome nel campo di sotto

palindrome:

    addi sp, sp, -20 # riservo spazio per lo stack

    sw ra, 0(sp) # salvo nello stack il return address
    sw s0, 4(sp) # salvo nello stack il parametro dell'array
    sw s1, 8(sp) # salvo nello stack il parametro dell'indice i
    sw s2, 12(sp) # salvo nello stack il parametro dell'indice j
    sw s3, 16(sp) # salvo nello stack il parametro del risultato

    li s1, 0 # indice del lato sinistro dell'array
    li s3, 1 # result
    addi s2, a1, -1 # indice del lato destro dell'array
    
    mv s0, a0 # sposto il parametro dell'array

    LOOP:

    bge s1, s2, EXIT # esci quando i >= j

    # recupero i parametri dallo stack per preparare la chiamata alla funzione equal(array, i, j)
    mv a0, s0 
    mv a1, s1
    mv a2, s2
    
    jal equal # chiamata a funzione equal

    and s3, s3, a0

    addi s1, s1, 1 # i++
    addi s2, s2, -1 # j--

    j LOOP # while

    EXIT:

    mv a0, s3

    # ripristino dei valori dello stack
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    
    addi sp, sp, 20
    
    ret
    
equal:

    li t0, 4 # importo costante 4

    # calcolo offset per puntamento elemento
    mul t1, a1, t0 
    mul t2, a2, t0

    # mi sposto all'elemento dell'array specificato 
    add t1, a0, t1 
    add t2, a0, t2

    # recupero i valori delle posizioni di memoria identificate
    lw t3, 0(t1)
    lw t4, 0(t2)

    # se i valori sono uguali, imposto uno chiamando la funzione SET_ONE
    beq t3, t4, SET_ONE
    
    addi a0, zero, 0 # imposto zero
    
    ret

SET_ONE:
    addi a0, zero, 1
    ret
    