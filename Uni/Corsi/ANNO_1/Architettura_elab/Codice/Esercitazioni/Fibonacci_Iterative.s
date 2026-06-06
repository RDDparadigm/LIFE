/*int fib(int n) {
    if (n == 0) {
        return 0;
    }

    if (n == 1) {
        return 1;
    }

    int a = 0;
    int b = 1;

    for (int i = 2; i <= n; i++) {
        int c = a + b;
        a = b;
        b = c;
    }

    return b;
}*/

.globl _start
.data

    N:  .word 9
    
.text
_start:

    la   a0, N
    lw   a0, 0(a0)
    jal  ra, fib
    
    #exit
    li   a7, 10
    ecall

fib:

    li t0, 0
    li t1, 1
    li t2, 2

    beq a0, t0, RET_0
    beq a0, t1, RET_1

    LOOP:
    
        bgt t2, a0, EXIT
        add t4, t0, t1
        mv t0, t1
        mv t1, t4

        addi t2, t2, 1

        j LOOP
    
RET_0:
    mv a0, t0
    ret

RET_1:
    mv a0, t1
    ret

EXIT:
    mv a0, t1
    ret