# Cheat Sheet RISC-V Assembly — Pattern Completi da Esame

## Metodo d’uso

Questa cheat sheet serve per riconoscere rapidamente i pattern tipici negli esercizi scritti di Assembly RISC-V.

Per ogni caso trovi:

1. **Quando lo vedi**
    
2. **Idea**
    
3. **Pseudocodice C**
    
4. **Assembly RISC-V**
    

> [!tip]  
> Negli esempi uso RISC-V semplice, evitando pseudo-istruzioni troppo “furbe” quando possibile.  
> Alcune pseudo-istruzioni comuni come `li`, `mv`, `j`, `ret` sono spiegate alla fine.

---

# 1. Registri fondamentali

|Registro|Uso|
|---|---|
|`zero`|vale sempre `0`|
|`a0`|primo parametro e valore di ritorno|
|`a1`|secondo parametro|
|`a2`|terzo parametro|
|`a3`|quarto parametro|
|`t0-t6`|registri temporanei|
|`s0-s11`|registri salvati|
|`ra`|return address|
|`sp`|stack pointer|

> [!warning]  
> Il valore di ritorno di una funzione deve stare in `a0`.

---

# 2. Passaggio dei parametri

## Quando lo vedi

```c
f(x, y, z);
```

## Idea

I parametri si passano nei registri `a`.

|Parametro|Registro|
|---|---|
|primo|`a0`|
|secondo|`a1`|
|terzo|`a2`|
|quarto|`a3`|

## Assembly

```asm
add a0, t0, zero      # primo parametro
add a1, t1, zero      # secondo parametro
add a2, t2, zero      # terzo parametro

jal ra, f
```

---

# 3. Return di una funzione

## Quando lo vedi

```c
return x;
```

## Idea

Il risultato va messo in `a0`.

## Assembly

```asm
add a0, t0, zero
ret
```

Oppure:

```asm
mv a0, t0
ret
```

## Return costante

```c
return 0;
```

```asm
addi a0, zero, 0
ret
```

```c
return 1;
```

```asm
addi a0, zero, 1
ret
```

---

# 4. Indirizzo vs valore

## Quando lo vedi

```asm
.data
    size: .word 10
```

## Idea

`size` è una variabile in memoria.

- `la` carica l’indirizzo;
    
- `lw` carica il valore contenuto a quell’indirizzo.
    

## Assembly

```asm
la a1, size      # a1 = indirizzo di size
lw a1, 0(a1)     # a1 = valore contenuto in size
```

> [!warning]  
> Errore tipico: usare `la a1, size` pensando che `a1` valga `10`.  
> In realtà `a1` contiene l’indirizzo della variabile.

---

# 5. Scheletro base di un programma

## Pseudocodice

```c
int main() {
    risultato = funzione(parametri);
    exit();
}
```

## Assembly

```asm
.globl _start

.data
    array: .word 1,2,3,4,5
    size:  .word 5

.text
_start:
    la a0, array          # primo parametro: indirizzo array
    la a1, size
    lw a1, 0(a1)          # secondo parametro: valore size

    jal ra, funzione

    li a7, 10
    ecall
```

---

# 6. Array di interi: leggere `array[i]`

## Quando lo vedi

```c
x = array[i];
```

## Idea

Un intero occupa 4 byte.

```c
indirizzo array[i] = base_array + i * 4;
```

## Assembly

```asm
slli t1, t0, 2        # t1 = i * 4
add t2, a0, t1        # t2 = indirizzo array[i]
lw t3, 0(t2)          # t3 = array[i]
```

Dove:

|Registro|Significato|
|---|---|
|`a0`|base array|
|`t0`|indice `i`|
|`t3`|valore `array[i]`|

> [!tip]  
> `slli t1, t0, 2` equivale a `t1 = t0 * 4`.

---

# 7. Array di interi: scrivere `array[i]`

## Quando lo vedi

```c
array[i] = value;
```

## Idea

Calcoli l’indirizzo e poi usi `sw`.

## Assembly

```asm
slli t1, t0, 2        # offset = i * 4
add t2, a0, t1        # indirizzo array[i]
sw t3, 0(t2)          # array[i] = value
```

---

# 8. Stringhe: leggere `str[i]`

## Quando lo vedi

```c
c = str[i];
```

## Idea

Una stringa è un array di byte.

Non devi moltiplicare l’indice per 4.

## Assembly

```asm
add t1, a0, t0        # indirizzo str[i]
lbu t2, 0(t1)         # t2 = str[i]
```

> [!warning]  
> Per array di `int`: `lw` e `sw`.  
> Per stringhe/caratteri: `lbu` e `sb`.

---

# 9. Funzione `charAt`

## C

```c
char charAt(char *str, int n) {
    return str[n];
}
```

## Assembly

```asm
charAt:
    add t0, a0, a1        # indirizzo str[n]
    lbu a0, 0(t0)         # a0 = str[n]
    ret
```

---

# 10. Ciclo `for`

## Quando lo vedi

```c
for (int i = 0; i < size; i++) {
    corpo;
}
```

## Idea

Lo trasformi in un `while`.

## Pseudocodice

```c
i = 0;

while (i < size) {
    corpo;
    i++;
}
```

## Assembly

```asm
addi t0, zero, 0      # i = 0

LOOP:
    bge t0, a1, EXIT  # se i >= size, esci

    # corpo

    addi t0, t0, 1    # i++
    beq zero, zero, LOOP

EXIT:
```

---

# 11. Ciclo `while`

## Quando lo vedi

```c
while (i < j) {
    corpo;
}
```

## Idea

Se la condizione è `i < j`, esci quando `i >= j`.

## Assembly

```asm
LOOP:
    bge t0, t1, EXIT      # se i >= j, esci

    # corpo

    beq zero, zero, LOOP

EXIT:
```

---

# 12. If / else

## Quando lo vedi

```c
if (x == y) {
    return 1;
} else {
    return 0;
}
```

## Assembly

```asm
beq t0, t1, TRUE

addi a0, zero, 0
ret

TRUE:
    addi a0, zero, 1
    ret
```

---

# 13. Branch principali

## Uguaglianza

```asm
beq t0, t1, LABEL
```

```c
if (t0 == t1) goto LABEL;
```

## Diversità

```asm
bne t0, t1, LABEL
```

```c
if (t0 != t1) goto LABEL;
```

## Minore

```asm
blt t0, t1, LABEL
```

```c
if (t0 < t1) goto LABEL;
```

## Maggiore o uguale

```asm
bge t0, t1, LABEL
```

```c
if (t0 >= t1) goto LABEL;
```

## Salto incondizionato

```asm
beq zero, zero, LABEL
```

Equivalente a:

```asm
j LABEL
```

---

# 14. Somma iterativa di un array

## Quando lo vedi

```c
int sumarray(int array[], int size) {
    int sum = 0;

    for (int i = 0; i < size; i++) {
        sum += array[i];
    }

    return sum;
}
```

## Assembly

```asm
sumarray:
    addi t0, zero, 0      # i = 0
    addi t1, zero, 0      # sum = 0

LOOP:
    bge t0, a1, EXIT      # se i >= size, esci

    slli t2, t0, 2        # offset = i * 4
    add t3, a0, t2        # indirizzo array[i]
    lw t4, 0(t3)          # t4 = array[i]

    add t1, t1, t4        # sum += array[i]

    addi t0, t0, 1        # i++
    beq zero, zero, LOOP

EXIT:
    add a0, t1, zero      # return sum
    ret
```

---

# 15. Somma array con puntatore

## Quando lo vedi

```c
int sumarray(int array[], int size) {
    int sum = 0;

    while (size > 0) {
        sum += *array;
        array++;
        size--;
    }

    return sum;
}
```

## Idea

Invece di usare `i`, sposti direttamente il puntatore.

## Assembly

```asm
sumarray_ptr:
    addi t0, zero, 0      # sum = 0

LOOP:
    beq a1, zero, EXIT    # se size == 0, esci

    lw t1, 0(a0)          # t1 = *array
    add t0, t0, t1        # sum += *array

    addi a0, a0, 4        # array++
    addi a1, a1, -1       # size--

    beq zero, zero, LOOP

EXIT:
    add a0, t0, zero
    ret
```

> [!tip]  
> Con array di interi, `array++` significa `array = array + 4`.

---

# 16. `strlen`

## Quando lo vedi

```c
int strlen(char *str) {
    int i = 0;

    while (str[i] != '\0') {
        i++;
    }

    return i;
}
```

## Assembly

```asm
strlen:
    addi t0, zero, 0      # i = 0

LOOP:
    add t1, a0, t0        # indirizzo str[i]
    lbu t2, 0(t1)         # t2 = str[i]

    beq t2, zero, EXIT    # se str[i] == '\0', esci

    addi t0, t0, 1        # i++
    beq zero, zero, LOOP

EXIT:
    add a0, t0, zero      # return i
    ret
```

---

# 17. `strcmp`

## Quando lo vedi

```c
int strcmp(char *str1, char *str2) {
    int i = 0;

    while (1) {
        if (str1[i] != str2[i]) {
            return 1;
        }

        if (str1[i] == '\0') {
            return 0;
        }

        i++;
    }
}
```

## Assembly

```asm
strcmp:
    addi t0, zero, 0      # i = 0

LOOP:
    add t1, a0, t0        # indirizzo str1[i]
    add t2, a1, t0        # indirizzo str2[i]

    lbu t3, 0(t1)         # t3 = str1[i]
    lbu t4, 0(t2)         # t4 = str2[i]

    bne t3, t4, NOT_EQUAL # se diversi, return 1

    beq t3, zero, EQUAL   # se sono uguali e '\0', return 0

    addi t0, t0, 1
    beq zero, zero, LOOP

NOT_EQUAL:
    addi a0, zero, 1
    ret

EQUAL:
    addi a0, zero, 0
    ret
```

---

# 18. `strcpy`

## Quando lo vedi

```c
void strcpy(char *src, char *dst) {
    int i = 0;

    while (src[i] != '\0') {
        dst[i] = src[i];
        i++;
    }

    dst[i] = '\0';
}
```

## Idea

Devi copiare anche il terminatore `'\0'`.

## Assembly

```asm
strcpy:
    addi t0, zero, 0      # i = 0

LOOP:
    add t1, a0, t0        # indirizzo src[i]
    lbu t2, 0(t1)         # t2 = src[i]

    add t3, a1, t0        # indirizzo dst[i]
    sb t2, 0(t3)          # dst[i] = src[i]

    beq t2, zero, EXIT    # se ho copiato '\0', fine

    addi t0, t0, 1
    beq zero, zero, LOOP

EXIT:
    ret
```

---

# 19. Confrontare due elementi di array

## Quando lo vedi

```c
int equal(int array[], int x, int y) {
    if (array[x] == array[y]) {
        return 1;
    } else {
        return 0;
    }
}
```

## Assembly

```asm
equal:
    slli t1, a1, 2        # offset x = x * 4
    slli t2, a2, 2        # offset y = y * 4

    add t1, a0, t1        # indirizzo array[x]
    add t2, a0, t2        # indirizzo array[y]

    lw t3, 0(t1)          # t3 = array[x]
    lw t4, 0(t2)          # t4 = array[y]

    beq t3, t4, TRUE

    addi a0, zero, 0
    ret

TRUE:
    addi a0, zero, 1
    ret
```

---

# 20. Ricerca lineare

## Quando lo vedi

```c
int contains(int array[], int size, int value) {
    for (int i = 0; i < size; i++) {
        if (array[i] == value) {
            return 1;
        }
    }

    return 0;
}
```

## Assembly

```asm
contains:
    addi t0, zero, 0      # i = 0

LOOP:
    bge t0, a1, NOT_FOUND

    slli t1, t0, 2
    add t2, a0, t1
    lw t3, 0(t2)          # t3 = array[i]

    beq t3, a2, FOUND

    addi t0, t0, 1
    beq zero, zero, LOOP

FOUND:
    addi a0, zero, 1
    ret

NOT_FOUND:
    addi a0, zero, 0
    ret
```

---

# 21. Contare occorrenze

## Quando lo vedi

```c
int count(int array[], int size, int value) {
    int c = 0;

    for (int i = 0; i < size; i++) {
        if (array[i] == value) {
            c++;
        }
    }

    return c;
}
```

## Assembly

```asm
count:
    addi t0, zero, 0      # i = 0
    addi t1, zero, 0      # c = 0

LOOP:
    bge t0, a1, EXIT

    slli t2, t0, 2
    add t3, a0, t2
    lw t4, 0(t3)          # array[i]

    beq t4, a2, INC

CONTINUE:
    addi t0, t0, 1
    beq zero, zero, LOOP

INC:
    addi t1, t1, 1
    beq zero, zero, CONTINUE

EXIT:
    add a0, t1, zero
    ret
```

---

# 22. Massimo di un array

## Quando lo vedi

```c
int maxarray(int array[], int size) {
    int max = array[0];

    for (int i = 1; i < size; i++) {
        if (array[i] > max) {
            max = array[i];
        }
    }

    return max;
}
```

## Assembly

```asm
maxarray:
    lw t1, 0(a0)          # max = array[0]
    addi t0, zero, 1      # i = 1

LOOP:
    bge t0, a1, EXIT

    slli t2, t0, 2
    add t3, a0, t2
    lw t4, 0(t3)          # t4 = array[i]

    blt t1, t4, UPDATE    # if max < array[i]

CONTINUE:
    addi t0, t0, 1
    beq zero, zero, LOOP

UPDATE:
    add t1, t4, zero      # max = array[i]
    beq zero, zero, CONTINUE

EXIT:
    add a0, t1, zero
    ret
```

---

# 23. Minimo di un array

## Quando lo vedi

```c
int minarray(int array[], int size) {
    int min = array[0];

    for (int i = 1; i < size; i++) {
        if (array[i] < min) {
            min = array[i];
        }
    }

    return min;
}
```

## Assembly

```asm
minarray:
    lw t1, 0(a0)          # min = array[0]
    addi t0, zero, 1      # i = 1

LOOP:
    bge t0, a1, EXIT

    slli t2, t0, 2
    add t3, a0, t2
    lw t4, 0(t3)

    blt t4, t1, UPDATE    # if array[i] < min

CONTINUE:
    addi t0, t0, 1
    beq zero, zero, LOOP

UPDATE:
    add t1, t4, zero
    beq zero, zero, CONTINUE

EXIT:
    add a0, t1, zero
    ret
```

---

# 24. Swap di due elementi array

## Quando lo vedi

```c
void swap(int array[], int i, int j) {
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
}
```

## Assembly

```asm
swap:
    slli t0, a1, 2
    add t1, a0, t0        # indirizzo array[i]

    slli t2, a2, 2
    add t3, a0, t2        # indirizzo array[j]

    lw t4, 0(t1)          # temp = array[i]
    lw t5, 0(t3)          # t5 = array[j]

    sw t5, 0(t1)          # array[i] = array[j]
    sw t4, 0(t3)          # array[j] = temp

    ret
```

---

# 25. Copiare un array

## Quando lo vedi

```c
void copy(int src[], int dst[], int size) {
    for (int i = 0; i < size; i++) {
        dst[i] = src[i];
    }
}
```

## Assembly

```asm
copy:
    addi t0, zero, 0      # i = 0

LOOP:
    bge t0, a2, EXIT

    slli t1, t0, 2

    add t2, a0, t1        # indirizzo src[i]
    lw t3, 0(t2)          # t3 = src[i]

    add t4, a1, t1        # indirizzo dst[i]
    sw t3, 0(t4)          # dst[i] = src[i]

    addi t0, t0, 1
    beq zero, zero, LOOP

EXIT:
    ret
```

---

# 26. Sommare solo elementi pari

## Quando lo vedi

```c
int sum_even(int array[], int size) {
    int sum = 0;

    for (int i = 0; i < size; i++) {
        if (array[i] % 2 == 0) {
            sum += array[i];
        }
    }

    return sum;
}
```

## Idea

Un numero è pari se il bit meno significativo è `0`.

```c
array[i] & 1
```

## Assembly

```asm
sum_even:
    addi t0, zero, 0      # i = 0
    addi t1, zero, 0      # sum = 0

LOOP:
    bge t0, a1, EXIT

    slli t2, t0, 2
    add t3, a0, t2
    lw t4, 0(t3)          # t4 = array[i]

    andi t5, t4, 1
    beq t5, zero, ADD_IT  # se pari, aggiungi

CONTINUE:
    addi t0, t0, 1
    beq zero, zero, LOOP

ADD_IT:
    add t1, t1, t4
    beq zero, zero, CONTINUE

EXIT:
    add a0, t1, zero
    ret
```

---

# 27. Procedura foglia

## Quando lo vedi

```c
int square(int x) {
    return x * x;
}
```

## Idea

La funzione non chiama altre funzioni.

Quindi non serve salvare `ra`.

## Assembly

```asm
square:
    mul a0, a0, a0
    ret
```

---

# 28. Procedura non foglia

## Quando lo vedi

```c
int f(int x) {
    return g(x) + 1;
}
```

## Idea

`f` chiama `g`.

Quindi `f` deve salvare `ra`.

## Assembly

```asm
f:
    addi sp, sp, -4
    sw ra, 0(sp)

    jal ra, g             # a0 = g(x)

    addi a0, a0, 1        # return g(x) + 1

    lw ra, 0(sp)
    addi sp, sp, 4
    ret
```

---

# 29. Stack: prologo ed epilogo

## Quando lo vedi

Una funzione deve salvare registri.

## Prologo

```asm
addi sp, sp, -8
sw ra, 4(sp)
sw s0, 0(sp)
```

## Epilogo

```asm
lw s0, 0(sp)
lw ra, 4(sp)
addi sp, sp, 8
ret
```

> [!warning]  
> Se fai `addi sp, sp, -8`, alla fine devi fare `addi sp, sp, 8`.

---

# 30. Quando usare registri `s`

## Quando lo vedi

```c
int f(int x, int y) {
    int z = x + y;
    int k = g(x);
    return z + k;
}
```

## Idea

`z` serve anche dopo la chiamata a `g`.

Quindi lo salvo in `s0`.

## Assembly

```asm
f:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)

    add s0, a0, a1        # z = x + y

    jal ra, g             # a0 = g(x)

    add a0, s0, a0        # return z + g(x)

    lw s0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    ret
```

> [!warning]  
> Se usi un registro `s`, devi salvarlo e ripristinarlo.

---

# 31. MCM con chiamata a MCD

## Quando lo vedi

```c
int mcm(int a, int b) {
    return (a * b) / mcd(a, b);
}
```

## Idea

La funzione chiama `mcd`, quindi devi salvare `ra`.

Inoltre devi conservare `a * b` mentre chiami `mcd`.

## Assembly con stack

```asm
mcm:
    addi sp, sp, -8
    sw ra, 4(sp)

    mul t0, a0, a1        # t0 = a * b
    sw t0, 0(sp)          # salvo a*b

    jal ra, mcd           # a0 = mcd(a, b)

    lw t0, 0(sp)          # recupero a*b
    div a0, t0, a0        # return (a*b) / mcd(a,b)

    lw ra, 4(sp)
    addi sp, sp, 8
    ret
```

## Assembly con registro `s`

```asm
mcm:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)

    mul s0, a0, a1        # s0 = a * b

    jal ra, mcd

    div a0, s0, a0

    lw s0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    ret
```

---

# 32. Palindromo su array

## Quando lo vedi

```c
int palindrome(int array[], int size) {
    int i = 0;
    int j = size - 1;
    int result = 1;

    while (i < j) {
        result = result & equal(array, i, j);
        i++;
        j--;
    }

    return result;
}
```

## Idea

Questa funzione chiama `equal`, quindi è non foglia.

Le variabili principali devono sopravvivere alla chiamata a `equal`.

## Mappa registri

|Variabile C|Registro|
|---|---|
|`array`|`s0`|
|`i`|`s1`|
|`j`|`s2`|
|`result`|`s3`|

## Assembly

```asm
palindrome:
    addi sp, sp, -20

    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    add s0, a0, zero      # s0 = array
    addi s1, zero, 0      # i = 0
    addi s2, a1, -1       # j = size - 1
    addi s3, zero, 1      # result = 1

LOOP:
    bge s1, s2, EXIT

    add a0, s0, zero      # parametro array
    add a1, s1, zero      # parametro i
    add a2, s2, zero      # parametro j

    jal ra, equal

    and s3, s3, a0        # result = result & equal(...)

    addi s1, s1, 1
    addi s2, s2, -1

    beq zero, zero, LOOP

EXIT:
    add a0, s3, zero

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)

    addi sp, sp, 20
    ret
```

---

# 33. Ricorsione: schema generale

## Quando lo vedi

```c
int f(int n) {
    if (n == 0) {
        return base;
    } else {
        return combinazione(n, f(n - 1));
    }
}
```

## Idea

Una funzione ricorsiva chiama sé stessa.

Quindi devi salvare:

- `ra`;
    
- i parametri che ti servono dopo la chiamata ricorsiva.
    

## Assembly schema

```asm
f:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)

    beq a0, zero, BASE

    addi a0, a0, -1
    jal ra, f

    lw t0, 0(sp)

    # combina t0 con il risultato ricorsivo in a0

    beq zero, zero, EXIT

BASE:
    addi a0, zero, valore_base

EXIT:
    lw ra, 4(sp)
    addi sp, sp, 8
    ret
```

---

# 34. Fattoriale ricorsivo

## Quando lo vedi

```c
int fact(int n) {
    if (n == 0) {
        return 1;
    } else {
        return n * fact(n - 1);
    }
}
```

## Assembly

```asm
fact:
    addi sp, sp, -8

    sw ra, 4(sp)
    sw a0, 0(sp)

    beq a0, zero, BASE

    addi a0, a0, -1       # n - 1
    jal ra, fact          # fact(n - 1)

    lw t0, 0(sp)          # recupero n
    mul a0, t0, a0        # n * fact(n - 1)

    beq zero, zero, EXIT

BASE:
    addi a0, zero, 1

EXIT:
    lw ra, 4(sp)
    addi sp, sp, 8
    ret
```

---

# 35. Somma ricorsiva di array

## Quando lo vedi

```c
int sumarray(int array[], int size) {
    if (size == 0) {
        return 0;
    } else {
        return array[0] + sumarray(array + 1, size - 1);
    }
}
```

## Assembly

```asm
sumarray:
    beq a1, zero, RET0

    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)

    lw s0, 0(a0)          # s0 = array[0]

    addi a0, a0, 4        # array + 1
    addi a1, a1, -1       # size - 1

    jal ra, sumarray

    add a0, s0, a0

    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

RET0:
    addi a0, zero, 0
    ret
```

---

# 36. Fibonacci iterativo

## Quando lo vedi

```c
int fib(int n) {
    if (n == 0) {
        return 0;
    }

    if (n == 1) {
        return 1;
    }

    int a = 0;
    int b = 1;

    for (int i = 2; i <= n; i++) {
        int c = a + b;
        a = b;
        b = c;
    }

    return b;
}
```

## Idea

Mantieni due valori:

- `a = fib(i-2)`
    
- `b = fib(i-1)`
    
- `c = a + b`
    

## Mappa registri

|Variabile|Registro|
|---|---|
|`n`|`a0`|
|`i`|`t0`|
|`a`|`t1`|
|`b`|`t2`|
|`c`|`t3`|

## Assembly

```asm
fib_iter:
    beq a0, zero, RET0

    addi t6, zero, 1
    beq a0, t6, RET1

    addi t1, zero, 0      # a = 0
    addi t2, zero, 1      # b = 1
    addi t0, zero, 2      # i = 2

LOOP:
    blt a0, t0, EXIT      # se n < i, esci

    add t3, t1, t2        # c = a + b
    add t1, t2, zero      # a = b
    add t2, t3, zero      # b = c

    addi t0, t0, 1        # i++
    beq zero, zero, LOOP

EXIT:
    add a0, t2, zero
    ret

RET0:
    addi a0, zero, 0
    ret

RET1:
    addi a0, zero, 1
    ret
```

> [!tip]  
> Per implementare `i <= n`, spesso conviene uscire quando `n < i`.

---

# 37. Fibonacci ricorsivo

## Quando lo vedi

```c
int fib(int n) {
    if (n == 0) {
        return 0;
    }

    if (n == 1) {
        return 1;
    }

    return fib(n - 1) + fib(n - 2);
}
```

## Idea

Questa funzione fa due chiamate ricorsive.

Devi salvare:

- `ra`;
    
- il valore originale di `n`;
    
- il risultato di `fib(n - 1)` mentre calcoli `fib(n - 2)`.
    

## Assembly

```asm
fib:
    addi t0, zero, 1

    beq a0, zero, RET0
    beq a0, t0, RET1

    addi sp, sp, -12
    sw ra, 8(sp)
    sw a0, 4(sp)          # salvo n

    addi a0, a0, -1
    jal ra, fib           # a0 = fib(n - 1)

    sw a0, 0(sp)          # salvo fib(n - 1)

    lw a0, 4(sp)          # recupero n
    addi a0, a0, -2
    jal ra, fib           # a0 = fib(n - 2)

    lw t1, 0(sp)          # t1 = fib(n - 1)
    add a0, t1, a0        # fib(n-1) + fib(n-2)

    lw ra, 8(sp)
    addi sp, sp, 12
    ret

RET0:
    addi a0, zero, 0
    ret

RET1:
    addi a0, zero, 1
    ret
```

> [!warning]  
> Fibonacci ricorsivo è un ottimo esercizio per capire lo stack: devi salvare il risultato della prima chiamata prima di fare la seconda.

---

# 38. Binary search iterativa

## Quando lo vedi

```c
int binary_search(int array[], int size, int target) {
    int left = 0;
    int right = size - 1;

    while (left <= right) {
        int mid = (left + right) / 2;

        if (array[mid] == target) {
            return mid;
        }

        if (array[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1;
}
```

## Idea

Mantieni due estremi:

- `left`
    
- `right`
    

Calcoli:

```c
mid = (left + right) / 2;
```

Poi confronti `array[mid]` con `target`.

## Mappa registri

|Variabile|Registro|
|---|---|
|`array`|`a0`|
|`size`|`a1`|
|`target`|`a2`|
|`left`|`t0`|
|`right`|`t1`|
|`mid`|`t2`|
|`array[mid]`|`t5`|

## Assembly

```asm
binary_search:
    addi t0, zero, 0      # left = 0
    addi t1, a1, -1       # right = size - 1

LOOP:
    blt t1, t0, NOT_FOUND # se right < left, esci

    add t2, t0, t1        # mid = left + right
    srli t2, t2, 1        # mid = mid / 2

    slli t3, t2, 2        # offset = mid * 4
    add t4, a0, t3        # indirizzo array[mid]
    lw t5, 0(t4)          # t5 = array[mid]

    beq t5, a2, FOUND

    blt t5, a2, GO_RIGHT  # se array[mid] < target

    addi t1, t2, -1       # right = mid - 1
    beq zero, zero, LOOP

GO_RIGHT:
    addi t0, t2, 1        # left = mid + 1
    beq zero, zero, LOOP

FOUND:
    add a0, t2, zero      # return mid
    ret

NOT_FOUND:
    addi a0, zero, -1
    ret
```

> [!tip]  
> La binary search funziona solo se l’array è ordinato.

---

# 39. Bubble sort

## Quando lo vedi

```c
void bubble_sort(int array[], int size) {
    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size - 1 - i; j++) {
            if (array[j] > array[j + 1]) {
                swap(array[j], array[j + 1]);
            }
        }
    }
}
```

## Idea

Doppio ciclo.

Confronti elementi adiacenti:

```c
array[j] > array[j + 1]
```

Se sono nell’ordine sbagliato, li scambi.

## Mappa registri

|Variabile|Registro|
|---|---|
|`array`|`a0`|
|`size`|`a1`|
|`i`|`t0`|
|`j`|`t1`|
|limite interno|`t2`|

## Assembly

```asm
bubble_sort:
    addi t0, zero, 0          # i = 0
    addi t6, a1, -1           # size - 1

OUTER:
    bge t0, t6, EXIT          # se i >= size-1, fine

    addi t1, zero, 0          # j = 0
    sub t2, t6, t0            # limite = size - 1 - i

INNER:
    bge t1, t2, NEXT_I        # se j >= limite, prossimo i

    slli t3, t1, 2
    add t4, a0, t3            # indirizzo array[j]

    lw t5, 0(t4)              # t5 = array[j]
    lw t3, 4(t4)              # t3 = array[j+1]

    blt t3, t5, SWAP          # se array[j+1] < array[j], scambia

CONTINUE:
    addi t1, t1, 1            # j++
    beq zero, zero, INNER

SWAP:
    sw t3, 0(t4)              # array[j] = array[j+1]
    sw t5, 4(t4)              # array[j+1] = vecchio array[j]
    beq zero, zero, CONTINUE

NEXT_I:
    addi t0, t0, 1            # i++
    beq zero, zero, OUTER

EXIT:
    ret
```

> [!warning]  
> Qui `array[j+1]` si trova a `4(t4)` perché `t4` è già l’indirizzo di `array[j]`.

---

# 40. Selection sort

## Quando lo vedi

```c
void selection_sort(int array[], int size) {
    for (int i = 0; i < size - 1; i++) {
        int min = i;

        for (int j = i + 1; j < size; j++) {
            if (array[j] < array[min]) {
                min = j;
            }
        }

        swap(array[i], array[min]);
    }
}
```

## Idea

Per ogni posizione `i`, cerchi l’indice del minimo nella parte destra dell’array.

Poi scambi `array[i]` con `array[min]`.

## Mappa registri

|Variabile|Registro|
|---|---|
|`array`|`a0`|
|`size`|`a1`|
|`i`|`t0`|
|`j`|`t1`|
|`min`|`t2`|

## Assembly

```asm
selection_sort:
    addi t0, zero, 0          # i = 0
    addi t6, a1, -1           # size - 1

OUTER:
    bge t0, t6, EXIT          # se i >= size-1, fine

    add t2, t0, zero          # min = i
    addi t1, t0, 1            # j = i + 1

INNER:
    bge t1, a1, DO_SWAP       # se j >= size, scambia

    slli t3, t1, 2
    add t4, a0, t3            # indirizzo array[j]
    lw t5, 0(t4)              # t5 = array[j]

    slli t3, t2, 2
    add t4, a0, t3            # indirizzo array[min]
    lw t3, 0(t4)              # t3 = array[min]

    blt t5, t3, UPDATE_MIN

CONTINUE_INNER:
    addi t1, t1, 1
    beq zero, zero, INNER

UPDATE_MIN:
    add t2, t1, zero          # min = j
    beq zero, zero, CONTINUE_INNER

DO_SWAP:
    slli t3, t0, 2
    add t4, a0, t3            # indirizzo array[i]

    slli t3, t2, 2
    add t5, a0, t3            # indirizzo array[min]

    lw t3, 0(t4)              # temp = array[i]
    lw t6, 0(t5)              # t6 = array[min]

    sw t6, 0(t4)              # array[i] = array[min]
    sw t3, 0(t5)              # array[min] = temp

    addi t0, t0, 1
    addi t6, a1, -1           # ripristino size - 1 in t6
    beq zero, zero, OUTER

EXIT:
    ret
```

> [!warning]  
> In questo esempio `t6` viene usato sia come `size - 1` sia temporaneamente nello swap.  
> Per sicurezza, dopo lo swap viene ricalcolato `t6 = size - 1`.

---

# 41. Insertion sort

## Quando lo vedi

```c
void insertion_sort(int array[], int size) {
    for (int i = 1; i < size; i++) {
        int key = array[i];
        int j = i - 1;

        while (j >= 0 && array[j] > key) {
            array[j + 1] = array[j];
            j--;
        }

        array[j + 1] = key;
    }
}
```

## Idea

Prendi `key = array[i]` e sposti a destra gli elementi maggiori di `key`.

## Assembly

```asm
insertion_sort:
    addi t0, zero, 1          # i = 1

OUTER:
    bge t0, a1, EXIT          # se i >= size, fine

    slli t2, t0, 2
    add t3, a0, t2
    lw t4, 0(t3)              # key = array[i]

    addi t1, t0, -1           # j = i - 1

INNER:
    blt t1, zero, INSERT      # se j < 0, inserisci key

    slli t2, t1, 2
    add t3, a0, t2
    lw t5, 0(t3)              # t5 = array[j]

    bge t4, t5, INSERT        # se key >= array[j], inserisci

    sw t5, 4(t3)              # array[j+1] = array[j]
    addi t1, t1, -1           # j--

    beq zero, zero, INNER

INSERT:
    addi t2, t1, 1            # j + 1
    slli t2, t2, 2
    add t3, a0, t2
    sw t4, 0(t3)              # array[j+1] = key

    addi t0, t0, 1            # i++
    beq zero, zero, OUTER

EXIT:
    ret
```

---

# 42. Ricerca del secondo massimo

## Quando lo vedi

```c
int second_max(int array[], int size) {
    int max1 = array[0];
    int max2 = array[1];

    if (max2 > max1) {
        int tmp = max1;
        max1 = max2;
        max2 = tmp;
    }

    for (int i = 2; i < size; i++) {
        if (array[i] > max1) {
            max2 = max1;
            max1 = array[i];
        } else if (array[i] > max2) {
            max2 = array[i];
        }
    }

    return max2;
}
```

## Idea

Mantieni due massimi:

- `max1`
    
- `max2`
    

## Assembly

```asm
second_max:
    lw t1, 0(a0)          # max1 = array[0]
    lw t2, 4(a0)          # max2 = array[1]

    blt t1, t2, SWAP_INIT

AFTER_INIT:
    addi t0, zero, 2      # i = 2

LOOP:
    bge t0, a1, EXIT

    slli t3, t0, 2
    add t4, a0, t3
    lw t5, 0(t4)          # x = array[i]

    blt t1, t5, NEW_MAX1  # if max1 < x
    blt t2, t5, NEW_MAX2  # else if max2 < x

CONTINUE:
    addi t0, t0, 1
    beq zero, zero, LOOP

SWAP_INIT:
    add t6, t1, zero
    add t1, t2, zero
    add t2, t6, zero
    beq zero, zero, AFTER_INIT

NEW_MAX1:
    add t2, t1, zero      # max2 = max1
    add t1, t5, zero      # max1 = x
    beq zero, zero, CONTINUE

NEW_MAX2:
    add t2, t5, zero      # max2 = x
    beq zero, zero, CONTINUE

EXIT:
    add a0, t2, zero
    ret
```

---

# 43. Invertire un array

## Quando lo vedi

```c
void reverse(int array[], int size) {
    int i = 0;
    int j = size - 1;

    while (i < j) {
        swap(array[i], array[j]);
        i++;
        j--;
    }
}
```

## Assembly

```asm
reverse:
    addi t0, zero, 0      # i = 0
    addi t1, a1, -1       # j = size - 1

LOOP:
    bge t0, t1, EXIT

    slli t2, t0, 2
    add t3, a0, t2        # indirizzo array[i]

    slli t2, t1, 2
    add t4, a0, t2        # indirizzo array[j]

    lw t5, 0(t3)          # temp = array[i]
    lw t6, 0(t4)          # t6 = array[j]

    sw t6, 0(t3)
    sw t5, 0(t4)

    addi t0, t0, 1
    addi t1, t1, -1

    beq zero, zero, LOOP

EXIT:
    ret
```

---

# 44. Verificare se array è ordinato

## Quando lo vedi

```c
int is_sorted(int array[], int size) {
    for (int i = 0; i < size - 1; i++) {
        if (array[i] > array[i + 1]) {
            return 0;
        }
    }

    return 1;
}
```

## Assembly

```asm
is_sorted:
    addi t0, zero, 0      # i = 0
    addi t1, a1, -1       # size - 1

LOOP:
    bge t0, t1, SORTED

    slli t2, t0, 2
    add t3, a0, t2        # indirizzo array[i]

    lw t4, 0(t3)          # array[i]
    lw t5, 4(t3)          # array[i+1]

    blt t5, t4, NOT_SORTED

    addi t0, t0, 1
    beq zero, zero, LOOP

NOT_SORTED:
    addi a0, zero, 0
    ret

SORTED:
    addi a0, zero, 1
    ret
```

---

# 45. Conta caratteri uguali a un certo carattere

## Quando lo vedi

```c
int count_char(char *str, char c) {
    int count = 0;
    int i = 0;

    while (str[i] != '\0') {
        if (str[i] == c) {
            count++;
        }

        i++;
    }

    return count;
}
```

## Assembly

```asm
count_char:
    addi t0, zero, 0      # i = 0
    addi t1, zero, 0      # count = 0

LOOP:
    add t2, a0, t0
    lbu t3, 0(t2)         # str[i]

    beq t3, zero, EXIT

    beq t3, a1, INC

CONTINUE:
    addi t0, t0, 1
    beq zero, zero, LOOP

INC:
    addi t1, t1, 1
    beq zero, zero, CONTINUE

EXIT:
    add a0, t1, zero
    ret
```

---

# 46. Convertire stringa in maiuscolo

## Quando lo vedi

```c
void to_upper(char *str) {
    int i = 0;

    while (str[i] != '\0') {
        if (str[i] >= 'a' && str[i] <= 'z') {
            str[i] = str[i] - 32;
        }

        i++;
    }
}
```

## Idea

In ASCII:

- `'a' = 97`
    
- `'z' = 122`
    
- `'A' = 65`
    

Differenza:

```c
'a' - 'A' = 32
```

## Assembly

```asm
to_upper:
    addi t0, zero, 0      # i = 0
    addi t5, zero, 97     # 'a'
    addi t6, zero, 122    # 'z'

LOOP:
    add t1, a0, t0
    lbu t2, 0(t1)         # str[i]

    beq t2, zero, EXIT

    blt t2, t5, CONTINUE  # se str[i] < 'a', continua
    blt t6, t2, CONTINUE  # se 'z' < str[i], continua

    addi t2, t2, -32      # str[i] -= 32
    sb t2, 0(t1)

CONTINUE:
    addi t0, t0, 1
    beq zero, zero, LOOP

EXIT:
    ret
```

---

# 47. Ricorsione su stringa: lunghezza ricorsiva

## Quando lo vedi

```c
int strlen_rec(char *str) {
    if (str[0] == '\0') {
        return 0;
    } else {
        return 1 + strlen_rec(str + 1);
    }
}
```

## Idea

Caso base:

```c
str[0] == '\0'
```

Caso ricorsivo:

```c
1 + strlen_rec(str + 1)
```

Con stringhe, `str + 1` significa `a0 + 1`.

## Assembly

```asm
strlen_rec:
    lbu t0, 0(a0)
    beq t0, zero, BASE

    addi sp, sp, -4
    sw ra, 0(sp)

    addi a0, a0, 1
    jal ra, strlen_rec

    addi a0, a0, 1

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

BASE:
    addi a0, zero, 0
    ret
```

---

# 48. Ricorsione: potenza

## Quando lo vedi

```c
int pow(int base, int exp) {
    if (exp == 0) {
        return 1;
    } else {
        return base * pow(base, exp - 1);
    }
}
```

## Idea

- `a0` = base
    
- `a1` = exp
    

Devi salvare `base`, perché dopo la chiamata ricorsiva `a0` conterrà il risultato.

## Assembly

```asm
pow:
    beq a1, zero, BASE_CASE

    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)          # salvo base

    addi a1, a1, -1
    jal ra, pow

    lw t0, 0(sp)          # recupero base
    mul a0, t0, a0        # base * pow(base, exp-1)

    lw ra, 4(sp)
    addi sp, sp, 8
    ret

BASE_CASE:
    addi a0, zero, 1
    ret
```

---

# 49. Ricorsione: somma da 1 a n

## Quando lo vedi

```c
int sum_to_n(int n) {
    if (n == 0) {
        return 0;
    } else {
        return n + sum_to_n(n - 1);
    }
}
```

## Assembly

```asm
sum_to_n:
    beq a0, zero, BASE

    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)

    addi a0, a0, -1
    jal ra, sum_to_n

    lw t0, 0(sp)
    add a0, t0, a0

    lw ra, 4(sp)
    addi sp, sp, 8
    ret

BASE:
    addi a0, zero, 0
    ret
```

---

# 50. Matrice lineare: accesso a `matrix[i][j]`

## Quando lo vedi

```c
x = matrix[i][j];
```

con matrice salvata in memoria riga per riga.

## Formula

```c
indice = i * cols + j;
indirizzo = base + indice * 4;
```

## Assembly

Assumiamo:

|Parametro|Registro|
|---|---|
|`matrix`|`a0`|
|`i`|`a1`|
|`j`|`a2`|
|`cols`|`a3`|

```asm
get_matrix:
    mul t0, a1, a3        # i * cols
    add t0, t0, a2        # i * cols + j

    slli t1, t0, 2        # offset in byte
    add t2, a0, t1        # indirizzo matrix[i][j]

    lw a0, 0(t2)
    ret
```

---

# 51. Somma elementi matrice

## Quando lo vedi

```c
int sum_matrix(int matrix[], int rows, int cols) {
    int sum = 0;

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            sum += matrix[i * cols + j];
        }
    }

    return sum;
}
```

## Assembly

```asm
sum_matrix:
    addi t0, zero, 0      # i = 0
    addi t1, zero, 0      # sum = 0

OUTER:
    bge t0, a1, EXIT

    addi t2, zero, 0      # j = 0

INNER:
    bge t2, a2, NEXT_I

    mul t3, t0, a2        # i * cols
    add t3, t3, t2        # i * cols + j
    slli t3, t3, 2        # offset byte

    add t4, a0, t3
    lw t5, 0(t4)

    add t1, t1, t5        # sum += matrix[...]

    addi t2, t2, 1
    beq zero, zero, INNER

NEXT_I:
    addi t0, t0, 1
    beq zero, zero, OUTER

EXIT:
    add a0, t1, zero
    ret
```

---

# 52. Mini-dizionario C → RISC-V

## Assegnamento

```c
int i = 0;
```

```asm
addi t0, zero, 0
```

## Incremento

```c
i++;
```

```asm
addi t0, t0, 1
```

## Decremento

```c
j--;
```

```asm
addi t1, t1, -1
```

## Somma

```c
sum += x;
```

```asm
add t0, t0, t1
```

## Return

```c
return x;
```

```asm
add a0, t0, zero
ret
```

## `array[i]`

```c
x = array[i];
```

```asm
slli t1, t0, 2
add t2, a0, t1
lw t3, 0(t2)
```

## `str[i]`

```c
c = str[i];
```

```asm
add t1, a0, t0
lbu t2, 0(t1)
```

## `array[i] = x`

```c
array[i] = x;
```

```asm
slli t1, t0, 2
add t2, a0, t1
sw t3, 0(t2)
```

## `str[i] = c`

```c
str[i] = c;
```

```asm
add t1, a0, t0
sb t2, 0(t1)
```

---

# 53. Pseudo-istruzioni utili

## `li`

```asm
li t0, 5
```

Equivale spesso a:

```asm
addi t0, zero, 5
```

## `mv`

```asm
mv t0, a0
```

Equivale a:

```asm
add t0, a0, zero
```

## `j`

```asm
j LOOP
```

Equivale a:

```asm
beq zero, zero, LOOP
```

## `ret`

```asm
ret
```

Equivale a:

```asm
jalr zero, 0(ra)
```

## `beqz`

```asm
beqz a1, EXIT
```

Equivale a:

```asm
beq a1, zero, EXIT
```

---

# 54. Errori classici da evitare

## Errore 1: confondere indirizzo e valore

Sbagliato:

```asm
la a1, size
```

Corretto:

```asm
la a1, size
lw a1, 0(a1)
```

---

## Errore 2: non moltiplicare per 4 negli array di int

Sbagliato:

```asm
add t1, a0, t0
lw t2, 0(t1)
```

Corretto:

```asm
slli t1, t0, 2
add t1, a0, t1
lw t2, 0(t1)
```

---

## Errore 3: moltiplicare per 4 nelle stringhe

Sbagliato:

```asm
slli t1, t0, 2
add t1, a0, t1
lbu t2, 0(t1)
```

Corretto:

```asm
add t1, a0, t0
lbu t2, 0(t1)
```

---

## Errore 4: non salvare `ra`

Sbagliato:

```asm
f:
    jal ra, g
    ret
```

Corretto:

```asm
f:
    addi sp, sp, -4
    sw ra, 0(sp)

    jal ra, g

    lw ra, 0(sp)
    addi sp, sp, 4
    ret
```

---

## Errore 5: usare un registro `s` senza salvarlo

Sbagliato:

```asm
f:
    add s0, a0, a1
    ret
```

Corretto:

```asm
f:
    addi sp, sp, -4
    sw s0, 0(sp)

    add s0, a0, a1

    lw s0, 0(sp)
    addi sp, sp, 4
    ret
```

---

## Errore 6: usare `t0` dopo una `jal` pensando che sia ancora valido

Sbagliato:

```asm
mul t0, a0, a1
jal ra, g
add a0, t0, a0
```

Corretto:

```asm
addi sp, sp, -8
sw ra, 4(sp)

mul t0, a0, a1
sw t0, 0(sp)

jal ra, g

lw t0, 0(sp)
add a0, t0, a0

lw ra, 4(sp)
addi sp, sp, 8
ret
```

---

# 55. Schema mentale finale

## Se vedi un array di int

```asm
slli offset, i, 2
add indirizzo, base, offset
lw valore, 0(indirizzo)
```

## Se devi scrivere in array

```asm
slli offset, i, 2
add indirizzo, base, offset
sw valore, 0(indirizzo)
```

## Se vedi una stringa

```asm
add indirizzo, base, i
lbu carattere, 0(indirizzo)
```

## Se devi scrivere un carattere

```asm
add indirizzo, base, i
sb carattere, 0(indirizzo)
```

## Se vedi un `for`

```asm
addi i, zero, 0

LOOP:
    bge i, size, EXIT

    # corpo

    addi i, i, 1
    beq zero, zero, LOOP

EXIT:
```

## Se vedi un `while (i < j)`

```asm
LOOP:
    bge i, j, EXIT

    # corpo

    beq zero, zero, LOOP

EXIT:
```

## Se vedi una funzione foglia

```asm
f:
    # calcolo risultato
    add a0, risultato, zero
    ret
```

## Se vedi una funzione non foglia

```asm
f:
    addi sp, sp, -N
    sw ra, offset(sp)

    jal ra, altra_funzione

    lw ra, offset(sp)
    addi sp, sp, N
    ret
```

## Se vedi ricorsione

```asm
f:
    addi sp, sp, -N
    sw ra, offset(sp)
    sw parametro, offset(sp)

    # caso base

    # preparo chiamata ricorsiva
    jal ra, f

    # combino risultato

    lw ra, offset(sp)
    addi sp, sp, N
    ret
```

---

# 56. Frasi pronte per l’orale

## Array

Per accedere a un elemento di un array di interi devo calcolare l’indirizzo `base + indice * 4`, perché ogni intero occupa 4 byte.

## Stringhe

Una stringa è un array di byte terminato da `'\0'`, quindi la scorro con `lbu` e controllo quando il carattere letto è zero.

## Funzioni

I parametri vengono passati nei registri `a0`, `a1`, `a2`, mentre il valore di ritorno viene lasciato in `a0`.

## Procedure foglia

Una procedura foglia non chiama altre procedure, quindi normalmente non deve salvare `ra`.

## Procedure non foglia

Una procedura non foglia chiama almeno un’altra funzione, quindi deve salvare `ra`, perché ogni `jal` sovrascrive il return address.

## Stack

Lo stack serve per salvare registri che devono essere recuperati dopo una chiamata, come `ra`, registri `s` o valori temporanei importanti.

## Ricorsione

Una funzione ricorsiva è una procedura non foglia che chiama sé stessa, quindi deve salvare `ra` e i parametri necessari prima della chiamata ricorsiva.

## Bubble sort

Nel bubble sort confronto elementi adiacenti `array[j]` e `array[j+1]`. Se sono nell’ordine sbagliato, li scambio. Ogni iterazione esterna porta un elemento nella posizione corretta.

## Selection sort

Nel selection sort cerco l’indice del minimo nella parte non ordinata dell’array e poi lo scambio con l’elemento in posizione `i`.

## Binary search

La binary search mantiene due estremi, `left` e `right`, calcola `mid = (left + right) / 2` e dimezza l’intervallo a ogni iterazione. Funziona solo su array ordinati.

## Fibonacci ricorsivo

Fibonacci ricorsivo richiede due chiamate ricorsive, quindi devo salvare sia `ra`, sia il valore originale di `n`, sia il risultato della prima chiamata mentre eseguo la seconda.