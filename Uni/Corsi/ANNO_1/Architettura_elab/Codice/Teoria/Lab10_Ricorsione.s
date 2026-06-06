.globl _start
.text

_start:
    # Call fact(n)
    addi a0, zero, 5
    jal fact


    li a7, 10
    ecall

fact:

    # riserviamo lo spazio per lo stack pointer (prologo)
    addi sp, sp, -8

    sw ra, 4(sp) # salvo il ritorno
    sw a0, 0(sp) # salvo n

    # check per caso base
    beq a0, zero, fbase

    # chiamata ricorsiva
    addi a0, a0, -1 # n=n-1
    jal ra, fact

    lw a1, 0(sp) # recuperiamo n
    mul a0, a0, a1

    beq zero, zero, fexit # saltiamo all'uscita del metodo
    
    
fbase: # caso base
    addi a0, zero, 1

fexit:
    # epilogo
    lw ra, 4(sp)
    addi sp, sp, 8
    
    ret

/*
int fact(int n) {
    if (i == 0) {
        return 1;
    } else {
        return n * fact(n - 1);
    }
}