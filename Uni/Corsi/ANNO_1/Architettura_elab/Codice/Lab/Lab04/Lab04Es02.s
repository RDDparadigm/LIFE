/*

Data una word in memoria (variabile size), seguita da "size" numeri interi in word contigue (array di word), scrivere un programma RISC-V che salva la somma degli elementi dell'array in una variabile identificata con l'etichetta result.

*/

.data 
  a:     .word 3
  b:     .word 4
  R:     .word 3

.globl _start
.data        
    size:   .word 16
    array:  .word 12, 2, 1, 3, 5, 1, 7, 1, -1, 4, -2, -3, 1, 9, -6, 10
    result: .word 0
    
.text
_start:
    # completare con il codice assembly RISC-V nel campo sottostante

    la t0, size
    la t4, array
    
    li t2, 0
    li t3, 0

    lw t1, 0(t0)

FOR:
    bge t2, t1, ENDFOR

    slli t5, t2, 2 # offset = i * 2^2

    add t5, t5, t4 # indirizzo di array[i]
    # array + i*4

    lw t5, 0(t5)

    add t3, t3, t5
    addi t2, t2, 1
    j FOR # oppure beq zero, zero, FOR

ENDFOR:
    la t5, result
    sw t3, 0(t5) # salvataggio in memoria
    
Esci:

li a7, 10

ecall
