/*

Considerando il seguente frammento di codice che ritorna l'N-esimo numero della sequenza di Fibonacci - Fib(n) - scrivere l'equivalente in RISC-V. Assumere che la variabile N sia memorizzata nel registro t0. Il risultato finale (variabile R) va lasciato nel registro t1. Si utilizzino altri registri temporanei per le variabili A e B, e il minor numero possibile di istruzioni.

// N ->è già caricato su t0
int R = 1;
int A = 0; int B = 1;
while (N > 0) {
    R = A + B;
    A = B;
    B = R;
    N = N - 1;
}

*/

.data
    N: .word 4
    r: .word 0
    a: .word 0
    b: .word 0

.globl _start
.text
    
_start:

    la t5, N
    lw t0, 0(t5) 
    lw t1, 4(t5) 
    lw t2, 8(t5) 
    lw t3, 12(t5) 
    
    addi t3, t3, 1 # forzato per far partire B ad 1
    
    Ciclo:
        beq t0, x0, Esci
    
        add t1, t2, t3
    
        mv t2, t3 # A = B usando il comando move
    
        mv t3, t1 # B = R usando il comando move
    
        addi t0, t0, -1 # N = N - 1 usando l'addi
        
    bne t0, zero, Ciclo # itera finché N è diverso da 0
    
    Esci:

    li a7, 10
    ecall