.text

    li x21, -30 # non è linguaggio macchina, viene tradotto in addi x21, x0, 0xa in quanto devono sempre esistere 3 operandi. Se la costante > 2047 e < -2048, allora verrà creata un'altra istruzione in memoria

    addi x10, x21, 10 # questa viene tradotta esattamente così, perché è linguaggio macchina

