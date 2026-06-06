/*

Data una word in memoria (size), seguita da "size" numeri interi in word contigue (array di word), scrivere un programma RISC-V che salva il maggiore valore presente nell'array in una variabile identificata con l'etichetta result. Assumere che la dimensione dell'array sia sempre maggiore di 0.

*/

.globl _start
.data        
    size:   .word 5
    array:  .word 5, 4, 3, 2, 1
    result: .word -1
    
.text
_start:

la t0, size # carico l'indirizzo di size
la t2, array

li t3, 0 # index

lw t6, 0(t0) # carico il valore di size
lw t5, 0(t2)

LOOP:
    addi t3, t3, 1 # index++
    beq t6, t3, EXIT # condizione d'uscita del loop
    slli t0, t3, 2 # calcolo dell'offset
    add t0, t0, t2
    lw t4, 0(t0) # carico l'elemento dell'array
    blt t5, t4, UPDATERES
    j LOOP
    
UPDATERES:
    mv t5, t4 
    j LOOP

EXIT:
    la t1, result 
    sw t5, 0(t1)

li a7, 10

ecall
