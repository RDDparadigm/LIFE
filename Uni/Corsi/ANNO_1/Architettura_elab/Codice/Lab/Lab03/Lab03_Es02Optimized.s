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

    addi t3, t0, 0

    blt t1, t3, SKIP_T1
    addi t3, t1, 0

    SKIP_T1:
        blt t2, t3, EXIT
        addi t3, t2, 0

    
    EXIT:

    li a7, 10
    ecall