#include <stdio.h>
#include <stdlib.h>

#define N 3

/*
 * Struct che contiene direttamente un array statico.
 *
 * L'array "a" è fisicamente dentro la struct.
 * Quindi, se copio una variabile di tipo struct sa,
 * viene copiato anche tutto l'array.
 */
struct sa {
    int a[N];
};

/*
 * Struct che contiene un puntatore.
 *
 * Qui la struct NON contiene direttamente l'array.
 * Contiene solo un puntatore a int.
 * L'array vero e proprio verrà creato separatamente con malloc.
 */
struct sp {
    int* p;
};

/*
 * test0 riceve una struct sa PER VALORE.
 *
 * Questo significa che "str" è una copia di mystr1.
 * Siccome struct sa contiene direttamente l'array,
 * viene copiato anche l'array.
 *
 * Quindi questa modifica riguarda solo la copia locale "str",
 * non la struct originale presente nel main.
 */
void test0(struct sa str) {
    str.a[0] = 7;
}

/*
 * test1 riceve un puntatore a int.
 *
 * Quando passiamo mystr1.a a una funzione,
 * l'array decade a puntatore al suo primo elemento.
 *
 * Quindi arr punta all'array originale dentro mystr1.
 * Modificare arr[1] significa modificare davvero mystr1.a[1].
 */
void test1(int *arr) {
    arr[1] = 8;
}

/*
 * Anche se qui scriviamo int arr[3],
 * nei parametri di una funzione in C questa forma
 * è equivalente a scrivere:
 *
 *     void test2(int *arr)
 *
 * Quindi anche qui arr è un puntatore all'array originale.
 */
void test2(int arr[3]) {
    arr[2] = 9;
}

/*
 * test3 riceve una struct sp PER VALORE.
 *
 * Quindi "str" è una copia di mystr2.
 *
 * Però struct sp contiene solo un puntatore.
 * Quando la struct viene copiata, viene copiato il puntatore,
 * non la memoria dinamica a cui il puntatore punta.
 *
 * Risultato:
 *
 *     mystr2.p  ----\
 *                    ---> stesso array dinamico
 *     str.p    ----/
 *
 * Quindi modificare str.p[0] modifica la stessa memoria
 * puntata anche da mystr2.p.
 */
void test3(struct sp str) {
    str.p[0] = 11;
}

int main(void)
{
    struct sa mystr1;
    struct sp mystr2;

    /*
     * Allochiamo dinamicamente un array di N interi.
     *
     * mystr2.p conterrà l'indirizzo del primo elemento
     * di questo array dinamico.
     */
    mystr2.p = malloc(sizeof(int) * N);

    /*
     * Controlliamo che malloc sia andata a buon fine.
     * Se malloc fallisce, restituisce NULL.
     */
    if (mystr2.p == NULL) {
        printf("Errore: malloc fallita\n");
        return 1;
    }

    /*
     * Inizializziamo tutti gli elementi dei due array a -1.
     *
     * mystr1.a è l'array statico dentro la struct.
     * mystr2.p[i] accede all'array dinamico puntato da p.
     */
    for (int i = 0; i < N; i++) {
        mystr1.a[i] = -1;
        mystr2.p[i] = -1;
    }

    /*
     * mystr1 viene passato per valore.
     * test0 modifica solo una copia della struct.
     * Quindi mystr1.a[0] rimane -1.
     */
    test0(mystr1);
    printf("Hello0 : %d\n", mystr1.a[0]); // stampa -1

    /*
     * Passiamo mystr1.a.
     * L'array decade a puntatore al primo elemento.
     * test1 modifica direttamente l'array originale.
     */
    test1(mystr1.a);
    printf("Hello1 : %d\n", mystr1.a[1]); // stampa 8

    /*
     * Anche qui passiamo mystr1.a.
     * Anche se test2 dichiara int arr[3],
     * in realtà riceve un int*.
     * Quindi modifica l'array originale.
     */
    test2(mystr1.a);
    printf("Hello2 : %d\n", mystr1.a[2]); // stampa 9

    /*
     * mystr2 viene passato per valore.
     * Però la struct contiene solo un puntatore.
     *
     * La copia "str" dentro test3 contiene lo stesso indirizzo
     * contenuto in mystr2.p.
     *
     * Quindi test3 modifica l'array dinamico originale.
     */
    test3(mystr2);
    printf("Hello3 : %d\n", mystr2.p[0]); // stampa 11

    /*
     * La memoria allocata con malloc deve essere liberata
     * quando non serve più.
     */
    free(mystr2.p);

    return 0;
}