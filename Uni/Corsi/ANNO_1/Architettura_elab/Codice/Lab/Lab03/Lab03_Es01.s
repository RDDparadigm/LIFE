/*Scrivere le sequenze di istruzioni RISC-V corrispondente al seguente frammento di pseudocodice. Si supponga che le variabili x, y siano contenute rispettivamente nei registri t0, t1.

x = (x - 2) + y
if (x < y)
    x = x + 1
else
    y = y + 1
    */

.globl _start
.data
     x: .word  2
     y: .word  1

.text

_start:

la t3, x
lw t0, 0(t3) # x
lw t1, 4(t3) # y
    
li t2, -2

addi t2, t0, -2
add t0, t2, t1

blt t0, t1, THEN
addi t1, t1, 1

beq x0, x0, ESCI

THEN: addi t0, t0, 1

ESCI:

li a7, 10

ecall
