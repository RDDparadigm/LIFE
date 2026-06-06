.globl _start
.text

_start:
    # 1) PRE-CHIAMATA
    addi a0, zero, 2      # a0 = 2 (parametro x)

    # 2) CHIAMATA FUNZIONE
    jal ra, square        # salva return address in ra e salta a square

    # 3) POST-CHIAMATA
    # a0 contiene il valore di ritorno (x*x)

    li a7, 10              # codice syscall (dipende dal simulatore)
    ecall                 # termina programma


/*
int square(int x) { 
    return x * x; 
}
*/
square:
    # 4) PROLOGO
    addi sp, sp, -12     # alloco 8 byte nello stack

    sw fp, 8(sp)          # salvo il vecchio frame pointer
    sw ra, 4(sp)          # salvo il return address

    sw a0, 0(sp) # salviamo il parametro x
    
    addi fp, sp, 8        # imposto il nuovo frame pointer
                          # fp punta a old fp
                          # layout:
                          # 0(fp)  = old fp
                          # -4(fp) = ra

    # 5) CORPO
    lw a0, -8(fp)

    mul a0, a0, a0

    # 6) EPILOGO
    lw ra, 4(sp)         # ripristino return address
    lw fp, 8(sp)          # ripristino vecchio frame pointer

    addi sp, sp, 12        # libero lo stack frame

    # 7) RITORNO
    ret      # ritorno al chiamante


/*
int sumSquare(int a, int b) {
    return square(a) + square(b);
}
*/

sumSquares:

    # prologo (definiamo tutto lo spazio che ci serve riservare per le variabili)
    addi sp, sp, -12 # (-16)

    # salviamo il frame pointer per primo (convenzione). Possiamo evitare di salvarlo se non viene modificato durante il corpo della funzione
    # sw fp, 12(sp) - commentato per ottimizzare

    # salviamo il return address
    sw ra, 8(sp)

    # per didattica, non serve ricordare il valore di 'a' e 'b'
    # sw a0, 4(sp)
    sw a1, 0(sp)

    # ottimizzazione
    # addi fp, sp, 12 spostiamo il frame pointer

    # corpo della funzione
    # square(a)
    jal square
    sw a0, 4(sp) # salvataggio valore di ritorno della chiamata

    # square(b), non possiamo utilizzare a1, perché potremmo aver perso il suo valore nella prima chiamata a square
    lw a0, 0(sp)
    jal square

    lw t3, 4(sp)

    add a0, a0, t3

    # epilogo (ripristiniamo le variabili salvate in precedenza

    # ottimizzazione - non ci serve il frame pointer
    # lw fp, 12(sp) ripristino il frame pointer

    lw ra, 8(sp) # ripristiniamo il return address

    
    addi sp, sp, 16 # ripristino dello stack pointer
    
    ret

    