/*
Scrivere una procedura RISC-V per calcolare la lunghezza di una stringa di caratteri in C, escluso il carattere terminatore. Le stringhe di caratteri in C sono memorizzate come un array di byte in memoria, dove il byte '\0' (0x00) rappresenta la fine della stringa.

Il seguente codice in C realizza strlen (convertilo in RISC-V):
unsigned int strlen(char *str) {
    unsigned int i;
    for (i = 0; str[i] != '\0'; i++);
    return i;
}
Il valore di ritorno deve essere lasciato sul registro a0.
*/

.globl _start
.data
    str: .string  "My string"
.text
_start:
    # call strlen
    la   a0, str
    jal  ra, strlen

    #exit
    li   a7, 10
    ecall

#****************************************************
# completare la funzione strlen nel campo di sotto



strlen:
    li t0, 0

    loop:
    
        add a1, a0, t0
        lbu a2, 0(a1)

        beq a2, zero, exit
        
        addi t0, t0, 1

        j loop

exit:
    mv a0, t0
    ret
        
    