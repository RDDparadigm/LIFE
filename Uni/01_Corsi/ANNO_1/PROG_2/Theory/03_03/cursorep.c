#include <stdio.h>
#include <stdlib.h>

#define N 10

/*
 * questo programmino mostra l'uso di puntatori come cursori che
 * permettono di percorrere un array. Nel main trovate un array
 * interi allocato staticamente e un puntatore ad array (il cursore).
 *
 * Al cursore viene assegnato un riferimento all'ultimo elemento dell'array.
 * Tramite un ciclo for l'array viene quindi percorso a ritroso assegnando
 * valore 1 alla cella di indice 9, 2 a quella di indice 8 ecc. fino alla 
 * prima che varrà 10. Attenzione: per come è controllato l'array l'ultimo
 * assegnamento avviene al di fuori del ciclo.
 *
 * Per completare il programma aggiungiamo due funzioni: una per inizializzare
 * un array a valori da 100 a 109 e l'altra per visualizzare il contenuto di 
 * un array. Si chiamano init e stampa.
 *
 * Il loro scopo è mostrare sempre come si possano dichiarare in maniera 
 * alternativa i parametri che riceveranno dal chiamante un array di dati.
 * Init usa un puntatore, stampa usa un array non dimensionato.
 *
 */


/*
 * il parametro a corrisponderà, nell'invocazione di init, a un array.
 * Si potrebbe accedere alle celle dell'array usando l'indice tramite
 * la notazione a[i]. In questo esempio usiamo invece direttamente il puntatore.
 * L'indice viene incrementato ma solo per calcolare il valore della cella.
 * Per far progredire il puntatore si utilizza la forma abbreviata a++.
 * NB: il parametro della funzione, nell'esempio, contiene una copia 
 * dell'indirizzo passato all'atto dell'invocazione e tale copia è il cursore
 * che andiamo a sfruttare.
 */
void init(int *a) {
	for (int i=0; i<N; i++, a++) {
		*a = 100+i;
	}
}

// il seguente è un altro modo per dire che il parametro corrisponderà
// all'indirizzo di un elemento che fa parte di un array. Non cambia molto
// rispetto alla funzione precedente, semplicemente si evidenzia la natura
// di array dei dati trattati. Il for è implementato nella maniera base, cioè
// usando un indice intero incrementato a ogni iterazione per accedere alle
// varie celle
void stampa(int a[]) { 
	int i=0;
	printf("\n");
	for (; i<N; i++) printf("%d ", a[i]);
	printf("\n");
}

/* il nostro main */
int main() {
   int prova[N]; // ecco l'array su cui lavoreremo
   int *cursore; // ecco il cursore
   int valore; // variabile che serve nell'ultimo for

   init(prova); // prova è un puntatore costante, si riferisce alla prima cella
		// dell'array dichiarato. L'indirizzo di tale punto di partenza
		// viene copiato nel parametro formale usato da init. Tale
		// funzione ne userà quindi una copia.

   stampa(prova); // vediamo cosa contiene prova

   // questo ciclo è gestito in maniera più complessa di come ho capito siete
   // abituati. Dettaglierò in poche slide il suo funzionamento
   for (cursore=prova+9, valore=10; cursore!=prova; cursore--,valore--) 
	   *cursore = valore;
   *cursore = valore;

   stampa(prova); // vediamo cosa contiene prova
}
