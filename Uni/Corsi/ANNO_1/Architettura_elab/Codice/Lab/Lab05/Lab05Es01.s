/*
Usando il linguaggio assemblativo del RISC-V, scrivere una funzione charAt che riceva:

sul registro a0, l'indirizzo in memoria di una stringa (array di byte)
sul registro a1, un numero intero n

charAt ritorna il carattere nella posizione n della stringa str.
Il seguente codice in C realizza charAt (convertilo in RISC-V):
char charAt(char *str, int n) {
    return str[n];
}
*/

.globl _start
.data
    str: .string "Hello World!"
    n:   .word   6

.text
_start:
    # call charAt
    la  a0, str
    la  a1, n
    lw  a1, 0(a1)
    jal ra, charAt

    #exit
    li   a7, 10
    ecall

#******************************************
# completare la funzione nel campo di sotto

charAt:
    add t0, a0, a1
    lbu a0, 0(t0)
    ret