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

.globl _start
.text
    
_start:

    li t2, 1 # carico l'indice con partenza ad uno
li t1, 0

Ciclo:
    bgt t2, t0, Esci # verifico se l'indice è maggiore di N, allora è condizione sufficiente per uscire dal ciclo
    mul t4, t2, t2 # salvo in t4 il risultato di i*i
    add t1, t1, t4
    addi t2, t2, 1
    j Ciclo
    
Esci: