/*
Si scriva un programma in linguaggio RISC-V che dati tre numeri interi su t0, t1 e t2, inserisca il valore massimo tra i tre nel registro t3. Assumere che t0, t1 e t2 siano già stati inizializzati.
*/

.globl _start
.data
     x: .word  2
     y: .word  1

.text

_start:



li a7, 10

ecall