.globl _start
.text

_start:
    # =========================
    # 1) PRE-CHIAMATA
    # =========================
    addi a0, zero, 2      # a0 = 2 (parametro x)

    # =========================
    # 2) CHIAMATA FUNZIONE
    # =========================
    jal ra, square        # salva return address in ra e salta a square

    # =========================
    # 3) POST-CHIAMATA
    # =========================
    # a0 contiene il valore di ritorno (x*x)

    li a7, 0              # codice syscall (dipende dal simulatore)
    ecall                 # termina programma


# =========================================
# int square(int x) { return x * x; }
# =========================================
square:
    # =========================
    # 4) PROLOGO
    # =========================
    addi sp, sp, -8       # alloco 8 byte nello stack

    sw fp, 4(sp)          # salvo il vecchio frame pointer
    sw ra, 0(sp)          # salvo il return address

    addi fp, sp, 4        # imposto il nuovo frame pointer
                          # fp punta a old fp
                          # layout:
                          # 0(fp)  = old fp
                          # -4(fp) = ra

    # =========================
    # 5) CORPO
    # =========================
    mul a0, a0, a0        # a0 = x * x (risultato)

    # =========================
    # 6) EPILOGO
    # =========================
    lw ra, -4(fp)         # ripristino return address
    lw fp, 0(fp)          # ripristino vecchio frame pointer

    addi sp, sp, 8        # libero lo stack frame

    # =========================
    # 7) RITORNO
    # =========================
    jalr x0, 0(ra)        # ritorno al chiamante