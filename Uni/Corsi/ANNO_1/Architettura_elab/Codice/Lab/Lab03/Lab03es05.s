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

.data N: .word 0

.globl _start
.text
    
_start:

la t1, N              # t1 = indirizzo di memoria dove si trova N
li t2, 0              # t2 = contatore dei bit a 1, inizializzato a 0
lw t0, 0(t1)          # t0 = valore di N caricato dalla memoria

Ciclo:
    beq t0, zero, Esci    # se t0 == 0, non ci sono più bit da controllare: esci

    andi t1, t0, 1        # t1 = ultimo bit di t0
                           # se t0 finisce con 0 -> t1 = 0
                           # se t0 finisce con 1 -> t1 = 1

    add t2, t2, t1        # aggiungo quel bit al contatore
                           # se t1 = 0, t2 non cambia
                           # se t1 = 1, t2 aumenta di 1

    srli t0, t0, 1        # sposto t0 a destra di 1 bit
                           # così il prossimo bit diventa l'ultimo

    j Ciclo               # ripeto il controllo sul nuovo ultimo bit

Esci:
                           # alla fine t2 contiene il numero di bit a 1 in N