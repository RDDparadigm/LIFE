.globl _start

.text
_start:

    # la jal ha bisogno, come tutte le altre istruzioni, dei 7 bit del codop per comprendere il tipo di operazione

    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0

    jal x1, somma # dal disassemblatore avremo jal x1, 28 perché vengono calcolate le 7 istruzioni di scostamento da 4 byte ciascuna per raggiungere la chiamata alla funzione somma. Inoltre, verrà aggiornato il program counter

    add x0, x0, x0
    add x0, x0, x0
    add x0, x0, x0

    jal x1, somma # jal x1, 12 (come spiegato precedentemente)

    # in alternativa
    # jal somma
    # call somma

    addi x17, x0, 10

    ecall

somma: 
    add x0, x0, x0
    add x0, x0, x0
    jalr x0, 0(x1) # x1 porterà dietro l'indirizzo della prima istruzione dopo la chiamata alla funzione

    # sostituibile con le seguenti pseudoistruzioni
    ret
    jr ra