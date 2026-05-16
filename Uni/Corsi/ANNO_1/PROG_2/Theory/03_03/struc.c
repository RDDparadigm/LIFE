#include <stdio.h>
#include <stdlib.h>

/*
	dichiarazione della forma di struct coord (coord = coordinate)
*/
struct coord {
   int x; // ascisse
   int y; // ordinate
};

/*
	funzione che visualizza i campi della struttura passata come argomento
*/
void stampa(struct coord p) {
	printf("\nx=%d\n", p.x); 
	printf("y=%d\n", p.y); 
}

int main() {
	struct coord sstatica; // vrb di tipo struct coord
	// di seguito dichiarazione di un puntatore a struct coord e allocazione
	// dinamica (nell heap) dello spazio necessario a contenere una struct di questo tipo
	struct coord *sdinamica = (struct coord *) malloc(sizeof(struct coord));

	sstatica.x = 10; // inizializzazione dei campi
	sstatica.y = 10; // idem
	stampa(sstatica);

	sdinamica->x =20; // quando la struct è allocata dinamicamente, si usa la notazione ->
	sdinamica->y =20; // invece della notazione . per accedere ai campi (lo vedremo)
	stampa(*sdinamica); // cosa succede se passo sdinamica invece di *sdinamica?

}
