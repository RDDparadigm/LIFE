.data
    y: .word 1
    x: .word 0
    z: .word -10

.globl _start
.text
    
_start:
    la t4, y
    lw t0, 0(t4)
    lw t1, 4(t4)
    lw t2, 8(t4)

    blt t1, t0, CHECKT0ANDT2

    blt t2, t1, T1ISBIGGEST

    CHECKT0ANDT2:
        blt t0, t2, T2ISBIGGEST
        addi t3, t0, 0
        beq x0, x0, EXIT

    T1ISBIGGEST:
        addi t3, t1,0 
        beq x0, x0, EXIT

    T2ISBIGGEST:
        addi t3, t2, 0
        beq x0, x0, EXIT

    T0ISBIGGEST:
        addi t3, t0, 0

    EXIT:

    li a7, 10
    ecall