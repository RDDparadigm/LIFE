.data
    myvar1: .byte 0xFF # rappresenta il -1. Con la visualizzazione in byte lo vediamo

    myvar2: .byte 0x7F # rappresenta il 127

    myvar3: .word 0xAABBCCDD # 

.text
    li x21, 0x10000000 # abbiamo bisogno dell'indirizzo per caricare 0xFF
    
    lb x10, 0(x21) 
    # come viene caricato sul registro? x21 avrà come valore 0x10000000
    # con l'istruzione lb il valore di x10 sarà 0xffffffff perché avviene l'estensione di segno per rispettare i 32 byte dell'architettura

    li x22, 0x10000001 # vogliamo caricare un byte, quindi ci spostiamo di 8 bit, non di 4!!

    lb x11, 0(x22) # con il numero positivo verrà quindi caricato come 0x000000ff

    lbu x12, 1(x22) # carichiamo in memoria senza l'estensione di segno (u rappresenta l'unsigned), avremo in registro il valore 0x000000ff invece di 0xffffffff

    li x23, 0x10000002
    lw x13, 0(x23) # carichiamo la word

    // lwu x13, 0(x21) # non possiamo caricare la word con l'unsigned in un'architettura a 32bit!!

    # Possiamo però caricarla come half e a quel punto richiamare l'unsigned
    lh x14, 0(x23) # risulterà 0xffffccdd
    lhu x15, 0(x23) # risulterà 0x0000ccdd

    lh x14, 1(x23) # posso passare anche bbcc, risc-v è permissivo
    