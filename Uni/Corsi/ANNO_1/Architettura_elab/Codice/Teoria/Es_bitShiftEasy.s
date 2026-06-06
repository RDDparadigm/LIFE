// traduzione del seguente codice C in linguaggio assemblativo
# int i,j;
# int v[10];
# ...
# v[i] = v[j]
# immaginando di avere i -> x9, j -> x21, v -> x19

# partiamo da v[j]
slli x17, x21, 2 // moltiplica j per 4, perché ogni int occupa 4 byte, quindi x17 = j*4

# v[i] in assembly diventa sempre base + i * dimensione

add x17, x19, x17 // calcola l'indirizzo di v[j]
lw x17, 0(x17)

# ora v[i]
slli x18, x9, 2

add x18, x18, x19 // sommiamo lo scostamento

sw x17, 0(x18)