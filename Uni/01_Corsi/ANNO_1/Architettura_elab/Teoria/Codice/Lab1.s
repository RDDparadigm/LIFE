# definisco una etichetta globale
.globl _start

# qui ci saranno le porzioni di programma
.text 

_start:
    # addi = load immediata in memoria, istruzione a 12 bit, sarebbe stato valido anche l'istruzione 
    # li t1, 41
    addi t1, zero, 41 # il registro t1 equiv. a x6

    # li t2, 43
    addi t2, zero, 43 # il registro t2 equiv. a x7

    # li t3, 47
    addi t3, zero, 47 # il registro t3 equiv. a x8

    add t4, t1, t2
    add t4, t4, t3

# usciamo dal programma
exit:
    # istruzione necessariamente da indicare in questo modo per uscire dal programma
    addi a7, zero, 10
    ecall