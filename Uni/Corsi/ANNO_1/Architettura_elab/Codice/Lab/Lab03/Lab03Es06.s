/*

Si scriva un programma RISC-V che calcoli la somma dei primi N quadrati perfetti. Il programma deve assumere che N sia nel registro t0 e lasciare il risultato sul registro t1.

Soluzione possible in C:
    // N -- è già caricato su t0
    int S=0;
    int i;
    for (i=1; i <= N; ++i){
        S = S + i*i;
    }

*/

.data 
  a:     .word 3
  b:     .word 4
  R:     .word 3

.globl _start
.text
    
_start:

li t3, 0
li t4, 0

ifor:

    beq t3, t0, Esci
    mv t4, zero

    j jfor

jfor:

    beq t4, t1, end_jfor
    
    slli t2, t2, 1
    
    add t2, t2, t3
    add t2, t2, t4
    
    addi t4, t4, 1

    j jfor
    
end_jfor:
    addi t3, t3, 1
    j ifor
    
Esci:

li a7, 10

ecall
