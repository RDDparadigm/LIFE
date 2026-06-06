    # completare il codice qui
    # load address (la) è una pseudo-istruzione carica il valore sul registro t0 per poterlo leggere (quindi da memoria a registro)
    la t0, a
    # OTTIMIZZATO - la t1, b

    # portiamo il valore di 0xAAAAAAA, vedremo questo valore in compilatore
    lw t2, 0(t0)

    # portiamo il valore di 0x12345678
    lw t3, 4(t0)

    and t4, t2, t3
    
    # il comando sw (save word) è necessario per salvare da registro a memoria
    sw  t4, 8(t0) # IMPORTANTISSIMO!! si può fare perché le variabili definite in .data sono sequenziali

    or t4, t2, t3
    sw t4, 12(t0)

    xor t4, t2, t3
    sw t4, 16(t0)
