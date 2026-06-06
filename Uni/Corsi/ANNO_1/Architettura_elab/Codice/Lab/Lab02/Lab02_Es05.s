.globl _start

.data
    # Array di 3 byte
    # I valori 130, 150 e 200 stanno in 1 byte ciascuno
    array:   .byte 130, 150, 200

    # Variabili dove salvare i risultati
    result1: .word 0      # somma considerando i byte come signed
    result2: .word 0      # somma considerando i byte come unsigned


.text
_start:

    # t0 conterrà l'indirizzo base dell'array
    la t0, array


    ##################################################
    # PARTE 1: somma dei 3 elementi come SIGNED BYTE #
    ##################################################

    # lb = load byte signed
    # legge 1 byte e lo estende a 32 bit mantenendo il segno
    # quindi:
    # 130 diventa -126
    # 150 diventa -106
    # 200 diventa -56

    lb t1, 0(t0)          # t1 = primo elemento dell'array
    lb t2, 1(t0)          # t2 = secondo elemento
    lb t3, 2(t0)          # t3 = terzo elemento

    # Somma i tre valori
    add t4, t1, t2        # t4 = t1 + t2
    add t4, t4, t3        # t4 = t4 + t3

    # Salva il risultato nella variabile result1
    la t5, result1        # t5 = indirizzo di result1
    sw t4, 0(t5)          # mem[result1] = t4


    ####################################################
    # PARTE 2: somma dei 3 elementi come UNSIGNED BYTE #
    ####################################################

    # lbu = load byte unsigned
    # legge 1 byte e lo estende a 32 bit riempiendo con zeri
    # quindi:
    # 130 resta 130
    # 150 resta 150
    # 200 resta 200

    lbu t1, 0(t0)         # t1 = primo elemento dell'array
    lbu t2, 1(t0)         # t2 = secondo elemento
    lbu t3, 2(t0)         # t3 = terzo elemento

    # Somma i tre valori
    add t4, t1, t2        # t4 = t1 + t2
    add t4, t4, t3        # t4 = t4 + t3

    # Salva il risultato nella variabile result2
    la t5, result2        # t5 = indirizzo di result2
    sw t4, 0(t5)          # mem[result2] = t4


    ########################
    # USCITA DAL PROGRAMMA #
    ########################

    li a7, 10             # codice ecall per terminare
    ecall