.globl _start
.text

_start:
    # 1) PRE-CHIAMATA
    addi a0, zero, 2      # a0 = 2 (parametro x)

    # 2) CHIAMATA FUNZIONE
    jal ra, square        # salva return address in ra e salta a square

    # 3) POST-CHIAMATA
    # a0 contiene il valore di ritorno (x*x)

    li a7, 0              # codice syscall (dipende dal simulatore)
    ecall                 # termina programma


/*
int square(int x) { 
    return x * x; 
}
*/
square:

    mul a0, a0, a0

    ret # ritorno al chiamante




    