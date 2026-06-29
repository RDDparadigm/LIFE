# Modulo `contact.c` — spiegazione e codice commentato

Questo modulo implementa alcune funzioni di utilità per lavorare con il tipo `Contact`.

La struct è definita così nel file `contact.h`:

```c
typedef struct contact {
   char* name;   
   char* surname;
   char* mobile;
   char* url;
} Contact, *ContactPtr;
```

Le funzioni richieste confrontano i contatti usando solo:

```c
name
surname
```

I campi:

```c
mobile
url
```

non vengono considerati nei confronti.

---

# Regola importante: maiuscole e minuscole non contano

La specifica dice che le differenze tra maiuscole e minuscole non contano.

Quindi questi due contatti devono risultare uguali:

```c
Contact c1 = {"Mario", "Rossi", "111", "url1"};
Contact c2 = {"mario", "rossi", "222", "url2"};
```

Anche se `mobile` e `url` sono diversi, i contatti sono considerati uguali perché hanno stesso nome e cognome ignorando maiuscole/minuscole.

---

# Funzione ausiliaria `compareIgnoreCase`

In C standard non possiamo usare funzioni non standard come `strcasecmp`.

Quindi costruiamo una funzione nostra che confronta due stringhe ignorando maiuscole e minuscole.

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "contact.h"

int compareIgnoreCase(char *s1, char *s2) {
    int i = 0;

    /*
     * Scorriamo entrambe le stringhe carattere per carattere.
     *
     * Il ciclo continua finché nessuna delle due stringhe è finita.
     */
    while (s1[i] != '\0' && s2[i] != '\0') {
        /*
         * Convertiamo entrambi i caratteri in minuscolo.
         *
         * In questo modo:
         * 'A' e 'a' vengono considerati uguali
         * 'R' e 'r' vengono considerati uguali
         */
        char c1 = tolower((unsigned char)s1[i]);
        char c2 = tolower((unsigned char)s2[i]);

        /*
         * Se il carattere della prima stringa è minore,
         * allora s1 viene prima di s2 in ordine lessicografico.
         */
        if (c1 < c2) {
            return -1;
        }

        /*
         * Se il carattere della prima stringa è maggiore,
         * allora s1 viene dopo s2.
         */
        if (c1 > c2) {
            return 1;
        }

        /*
         * Se i caratteri sono uguali, passiamo alla posizione successiva.
         */
        i++;
    }

    /*
     * Se entrambe le stringhe sono finite nello stesso momento,
     * allora sono uguali.
     *
     * Esempio:
     * "Mario"
     * "mario"
     */
    if (s1[i] == '\0' && s2[i] == '\0') {
        return 0;
    }

    /*
     * Se è finita prima s1, allora s1 è minore.
     *
     * Esempio:
     * "Ann"
     * "Anna"
     */
    if (s1[i] == '\0') {
        return -1;
    }

    /*
     * Altrimenti è finita prima s2, quindi s1 è maggiore.
     *
     * Esempio:
     * "Anna"
     * "Ann"
     */
    return 1;
}
```

---

# Funzione `contactEq`

Controlla se due contatti hanno lo stesso nome e cognome.

Restituisce:

|Caso|Valore restituito|
|---|--:|
|stesso nome e stesso cognome|`1`|
|nome o cognome diverso|`0`|
|qualche `name` o `surname` è `NULL`|`-99`|

```c
int contactEq(Contact c1, Contact c2) {
    /*
     * Prima cosa da controllare:
     * name e surname devono esistere.
     *
     * Se anche solo uno tra questi campi è NULL,
     * la funzione deve restituire -99.
     */
    if (c1.name == NULL || c1.surname == NULL || c2.name == NULL || c2.surname == NULL) {
        return -99;
    }

    /*
     * Due contatti sono uguali se:
     * - i nomi sono uguali ignorando maiuscole/minuscole
     * - i cognomi sono uguali ignorando maiuscole/minuscole
     *
     * mobile e url non vengono confrontati.
     */
    if (compareIgnoreCase(c1.name, c2.name) == 0 &&
        compareIgnoreCase(c1.surname, c2.surname) == 0) {
        return 1;
    }

    /*
     * Se almeno uno tra nome e cognome è diverso,
     * i contatti non sono uguali.
     */
    return 0;
}
```

---

# Test per `contactEq`

I test devono verificare che la funzione riconosca:

- contatti uguali ignorando maiuscole/minuscole
    
- contatti diversi per cognome
    
- contatti diversi per nome
    
- campi `name` o `surname` a `NULL`
    

```c
int test_contactEq() {
    int ok = 1;

    Contact c1 = {"Mario", "Rossi", "111", "url1"};
    Contact c2 = {"mario", "rossi", "222", "url2"};
    Contact c3 = {"Mario", "Bianchi", "111", "url1"};
    Contact c4 = {"Luigi", "Rossi", "111", "url1"};
    Contact c5 = {NULL, "Rossi", "111", "url1"};
    Contact c6 = {"Mario", NULL, "111", "url1"};

    /*
     * Stesso nome e stesso cognome, anche se scritti con maiuscole diverse.
     * Deve restituire 1.
     */
    if (contactEq(c1, c2) != 1) {
        ok = 0;
    }

    /*
     * Stesso nome, cognome diverso.
     * Deve restituire 0.
     */
    if (contactEq(c1, c3) != 0) {
        ok = 0;
    }

    /*
     * Stesso cognome, nome diverso.
     * Deve restituire 0.
     */
    if (contactEq(c1, c4) != 0) {
        ok = 0;
    }

    /*
     * Il primo contatto ha name == NULL.
     * Deve restituire -99.
     */
    if (contactEq(c1, c5) != -99) {
        ok = 0;
    }

    /*
     * Il primo contatto ha surname == NULL.
     * Deve restituire -99.
     */
    if (contactEq(c6, c1) != -99) {
        ok = 0;
    }

    if (ok) {
        printf("TEST PASSED\n");
    } else {
        printf("TEST FAILED\n");
    }

    return 0;
}
```

---

# Funzione `contactEqEff`

Questa funzione fa la stessa cosa di `contactEq`, ma riceve puntatori a `Contact`.

La differenza è questa:

```c
contactEq(c1, c2);
```

passa i contatti per valore, mentre:

```c
contactEqEff(&c1, &c2);
```

passa gli indirizzi dei contatti.

Dato che i parametri sono puntatori, per accedere ai campi si usa `->`.

```c
int contactEqEff(const Contact *pc1, const Contact *pc2) {
    /*
     * pc1 e pc2 sono puntatori a Contact.
     *
     * La specifica dice che possiamo assumere pc1 e pc2 non NULL.
     * Quindi controlliamo solo i campi name e surname.
     */
    if (pc1->name == NULL || pc1->surname == NULL || pc2->name == NULL || pc2->surname == NULL) {
        return -99;
    }

    /*
     * Confrontiamo nome e cognome ignorando maiuscole/minuscole.
     */
    if (compareIgnoreCase(pc1->name, pc2->name) == 0 &&
        compareIgnoreCase(pc1->surname, pc2->surname) == 0) {
        return 1;
    }

    return 0;
}
```

---

# Test per `contactEqEff`

Sono molto simili ai test di `contactEq`, ma le chiamate avvengono passando gli indirizzi dei contatti.

```c
int test_contactEqEff() {
    int ok = 1;

    Contact c1 = {"Mario", "Rossi", "111", "url1"};
    Contact c2 = {"mario", "rossi", "222", "url2"};
    Contact c3 = {"Mario", "Bianchi", "111", "url1"};
    Contact c4 = {"Luigi", "Rossi", "111", "url1"};
    Contact c5 = {NULL, "Rossi", "111", "url1"};
    Contact c6 = {"Mario", NULL, "111", "url1"};

    if (contactEqEff(&c1, &c2) != 1) {
        ok = 0;
    }

    if (contactEqEff(&c1, &c3) != 0) {
        ok = 0;
    }

    if (contactEqEff(&c1, &c4) != 0) {
        ok = 0;
    }

    if (contactEqEff(&c1, &c5) != -99) {
        ok = 0;
    }

    if (contactEqEff(&c6, &c1) != -99) {
        ok = 0;
    }

    if (ok) {
        printf("TEST PASSED\n");
    } else {
        printf("TEST FAILED\n");
    }

    return 0;
}
```

---

# Funzione `contactCmp`

Confronta due contatti in ordine lessicografico.

L'ordinamento funziona così:

1. prima si confronta il cognome
    
2. se il cognome è uguale, si confronta il nome
    

Restituisce:

|Caso|Valore|
|---|--:|
|`c1` viene prima di `c2`|`-1`|
|`c1` è uguale a `c2`|`0`|
|`c1` viene dopo `c2`|`1`|
|qualche `name` o `surname` è `NULL`|`-99`|

```c
int contactCmp(Contact c1, Contact c2) {
    int cmpSurname;
    int cmpName;

    /*
     * Anche qui, se qualche name o surname è NULL,
     * bisogna restituire -99.
     */
    if (c1.name == NULL || c1.surname == NULL || c2.name == NULL || c2.surname == NULL) {
        return -99;
    }

    /*
     * Prima confrontiamo i cognomi.
     */
    cmpSurname = compareIgnoreCase(c1.surname, c2.surname);

    /*
     * Se il cognome di c1 viene prima del cognome di c2,
     * allora tutto il contatto c1 viene prima di c2.
     */
    if (cmpSurname < 0) {
        return -1;
    }

    /*
     * Se il cognome di c1 viene dopo il cognome di c2,
     * allora tutto il contatto c1 viene dopo c2.
     */
    if (cmpSurname > 0) {
        return 1;
    }

    /*
     * Se siamo arrivati qui, significa che i cognomi sono uguali.
     * Quindi dobbiamo confrontare i nomi.
     */
    cmpName = compareIgnoreCase(c1.name, c2.name);

    if (cmpName < 0) {
        return -1;
    }

    if (cmpName > 0) {
        return 1;
    }

    /*
     * Se anche i nomi sono uguali, i contatti sono uguali
     * rispetto all'ordinamento richiesto.
     */
    return 0;
}
```

---

# Test per `contactCmp`

I test devono verificare:

- contatti uguali
    
- stesso cognome ma nome minore
    
- stesso cognome ma nome maggiore
    
- cognome minore
    
- cognome maggiore
    
- campi `NULL`
    

```c
int test_contactCmp() {
    int ok = 1;

    Contact c1 = {"Mario", "Rossi", "111", "url1"};
    Contact c2 = {"mario", "rossi", "222", "url2"};
    Contact c3 = {"Anna", "Rossi", "111", "url1"};
    Contact c4 = {"Luigi", "Bianchi", "111", "url1"};
    Contact c5 = {"Luigi", "Verdi", "111", "url1"};
    Contact c6 = {NULL, "Rossi", "111", "url1"};
    Contact c7 = {"Mario", NULL, "111", "url1"};

    /*
     * Mario Rossi e mario rossi sono uguali ignorando maiuscole/minuscole.
     */
    if (contactCmp(c1, c2) != 0) {
        ok = 0;
    }

    /*
     * Anna Rossi viene prima di Mario Rossi,
     * perché il cognome è uguale ma Anna < Mario.
     */
    if (contactCmp(c3, c1) != -1) {
        ok = 0;
    }

    /*
     * Mario Rossi viene dopo Anna Rossi.
     */
    if (contactCmp(c1, c3) != 1) {
        ok = 0;
    }

    /*
     * Bianchi viene prima di Rossi.
     * Quindi Luigi Bianchi viene prima di Mario Rossi.
     */
    if (contactCmp(c4, c1) != -1) {
        ok = 0;
    }

    /*
     * Verdi viene dopo Rossi.
     * Quindi Luigi Verdi viene dopo Mario Rossi.
     */
    if (contactCmp(c5, c1) != 1) {
        ok = 0;
    }

    /*
     * name NULL.
     */
    if (contactCmp(c1, c6) != -99) {
        ok = 0;
    }

    /*
     * surname NULL.
     */
    if (contactCmp(c7, c1) != -99) {
        ok = 0;
    }

    if (ok) {
        printf("TEST PASSED\n");
    } else {
        printf("TEST FAILED\n");
    }

    return 0;
}
```

---

# Funzione `contactCmpEff`

È la versione efficiente di `contactCmp`.

Riceve puntatori invece che copie dei contatti.

```c
int contactCmpEff(const Contact *pc1, const Contact *pc2) {
    int cmpSurname;
    int cmpName;

    /*
     * pc1 e pc2 sono assunti non NULL dalla specifica.
     * Controlliamo quindi solo i campi interni name e surname.
     */
    if (pc1->name == NULL || pc1->surname == NULL || pc2->name == NULL || pc2->surname == NULL) {
        return -99;
    }

    /*
     * Prima si confronta il cognome.
     */
    cmpSurname = compareIgnoreCase(pc1->surname, pc2->surname);

    if (cmpSurname < 0) {
        return -1;
    }

    if (cmpSurname > 0) {
        return 1;
    }

    /*
     * Se i cognomi sono uguali, si confronta il nome.
     */
    cmpName = compareIgnoreCase(pc1->name, pc2->name);

    if (cmpName < 0) {
        return -1;
    }

    if (cmpName > 0) {
        return 1;
    }

    return 0;
}
```

---

# Test per `contactCmpEff`

```c
int test_contactCmpEff() {
    int ok = 1;

    Contact c1 = {"Mario", "Rossi", "111", "url1"};
    Contact c2 = {"mario", "rossi", "222", "url2"};
    Contact c3 = {"Anna", "Rossi", "111", "url1"};
    Contact c4 = {"Luigi", "Bianchi", "111", "url1"};
    Contact c5 = {"Luigi", "Verdi", "111", "url1"};
    Contact c6 = {NULL, "Rossi", "111", "url1"};
    Contact c7 = {"Mario", NULL, "111", "url1"};

    if (contactCmpEff(&c1, &c2) != 0) {
        ok = 0;
    }

    if (contactCmpEff(&c3, &c1) != -1) {
        ok = 0;
    }

    if (contactCmpEff(&c1, &c3) != 1) {
        ok = 0;
    }

    if (contactCmpEff(&c4, &c1) != -1) {
        ok = 0;
    }

    if (contactCmpEff(&c5, &c1) != 1) {
        ok = 0;
    }

    if (contactCmpEff(&c1, &c6) != -99) {
        ok = 0;
    }

    if (contactCmpEff(&c7, &c1) != -99) {
        ok = 0;
    }

    if (ok) {
        printf("TEST PASSED\n");
    } else {
        printf("TEST FAILED\n");
    }

    return 0;
}
```

---

# Codice completo commentato

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "contact.h"

int compareIgnoreCase(char *s1, char *s2) {
    int i = 0;

    while (s1[i] != '\0' && s2[i] != '\0') {
        char c1 = tolower((unsigned char)s1[i]);
        char c2 = tolower((unsigned char)s2[i]);

        if (c1 < c2) {
            return -1;
        }

        if (c1 > c2) {
            return 1;
        }

        i++;
    }

    if (s1[i] == '\0' && s2[i] == '\0') {
        return 0;
    }

    if (s1[i] == '\0') {
        return -1;
    }

    return 1;
}

int contactEq(Contact c1, Contact c2) {
    if (c1.name == NULL || c1.surname == NULL || c2.name == NULL || c2.surname == NULL) {
        return -99;
    }

    if (compareIgnoreCase(c1.name, c2.name) == 0 &&
        compareIgnoreCase(c1.surname, c2.surname) == 0) {
        return 1;
    }

    return 0;
}

int test_contactEq() {
    int ok = 1;

    Contact c1 = {"Mario", "Rossi", "111", "url1"};
    Contact c2 = {"mario", "rossi", "222", "url2"};
    Contact c3 = {"Mario", "Bianchi", "111", "url1"};
    Contact c4 = {"Luigi", "Rossi", "111", "url1"};
    Contact c5 = {NULL, "Rossi", "111", "url1"};
    Contact c6 = {"Mario", NULL, "111", "url1"};

    if (contactEq(c1, c2) != 1) {
        ok = 0;
    }

    if (contactEq(c1, c3) != 0) {
        ok = 0;
    }

    if (contactEq(c1, c4) != 0) {
        ok = 0;
    }

    if (contactEq(c1, c5) != -99) {
        ok = 0;
    }

    if (contactEq(c6, c1) != -99) {
        ok = 0;
    }

    if (ok) {
        printf("TEST PASSED\n");
    } else {
        printf("TEST FAILED\n");
    }

    return 0;
}

int contactEqEff(const Contact *pc1, const Contact *pc2) {
    if (pc1->name == NULL || pc1->surname == NULL || pc2->name == NULL || pc2->surname == NULL) {
        return -99;
    }

    if (compareIgnoreCase(pc1->name, pc2->name) == 0 &&
        compareIgnoreCase(pc1->surname, pc2->surname) == 0) {
        return 1;
    }

    return 0;
}

int test_contactEqEff() {
    int ok = 1;

    Contact c1 = {"Mario", "Rossi", "111", "url1"};
    Contact c2 = {"mario", "rossi", "222", "url2"};
    Contact c3 = {"Mario", "Bianchi", "111", "url1"};
    Contact c4 = {"Luigi", "Rossi", "111", "url1"};
    Contact c5 = {NULL, "Rossi", "111", "url1"};
    Contact c6 = {"Mario", NULL, "111", "url1"};

    if (contactEqEff(&c1, &c2) != 1) {
        ok = 0;
    }

    if (contactEqEff(&c1, &c3) != 0) {
        ok = 0;
    }

    if (contactEqEff(&c1, &c4) != 0) {
        ok = 0;
    }

    if (contactEqEff(&c1, &c5) != -99) {
        ok = 0;
    }

    if (contactEqEff(&c6, &c1) != -99) {
        ok = 0;
    }

    if (ok) {
        printf("TEST PASSED\n");
    } else {
        printf("TEST FAILED\n");
    }

    return 0;
}

int contactCmp(Contact c1, Contact c2) {
    int cmpSurname;
    int cmpName;

    if (c1.name == NULL || c1.surname == NULL || c2.name == NULL || c2.surname == NULL) {
        return -99;
    }

    cmpSurname = compareIgnoreCase(c1.surname, c2.surname);

    if (cmpSurname < 0) {
        return -1;
    }

    if (cmpSurname > 0) {
        return 1;
    }

    cmpName = compareIgnoreCase(c1.name, c2.name);

    if (cmpName < 0) {
        return -1;
    }

    if (cmpName > 0) {
        return 1;
    }

    return 0;
}

int test_contactCmp() {
    int ok = 1;

    Contact c1 = {"Mario", "Rossi", "111", "url1"};
    Contact c2 = {"mario", "rossi", "222", "url2"};
    Contact c3 = {"Anna", "Rossi", "111", "url1"};
    Contact c4 = {"Luigi", "Bianchi", "111", "url1"};
    Contact c5 = {"Luigi", "Verdi", "111", "url1"};
    Contact c6 = {NULL, "Rossi", "111", "url1"};
    Contact c7 = {"Mario", NULL, "111", "url1"};

    if (contactCmp(c1, c2) != 0) {
        ok = 0;
    }

    if (contactCmp(c3, c1) != -1) {
        ok = 0;
    }

    if (contactCmp(c1, c3) != 1) {
        ok = 0;
    }

    if (contactCmp(c4, c1) != -1) {
        ok = 0;
    }

    if (contactCmp(c5, c1) != 1) {
        ok = 0;
    }

    if (contactCmp(c1, c6) != -99) {
        ok = 0;
    }

    if (contactCmp(c7, c1) != -99) {
        ok = 0;
    }

    if (ok) {
        printf("TEST PASSED\n");
    } else {
        printf("TEST FAILED\n");
    }

    return 0;
}

int contactCmpEff(const Contact *pc1, const Contact *pc2) {
    int cmpSurname;
    int cmpName;

    if (pc1->name == NULL || pc1->surname == NULL || pc2->name == NULL || pc2->surname == NULL) {
        return -99;
    }

    cmpSurname = compareIgnoreCase(pc1->surname, pc2->surname);

    if (cmpSurname < 0) {
        return -1;
    }

    if (cmpSurname > 0) {
        return 1;
    }

    cmpName = compareIgnoreCase(pc1->name, pc2->name);

    if (cmpName < 0) {
        return -1;
    }

    if (cmpName > 0) {
        return 1;
    }

    return 0;
}

int test_contactCmpEff() {
    int ok = 1;

    Contact c1 = {"Mario", "Rossi", "111", "url1"};
    Contact c2 = {"mario", "rossi", "222", "url2"};
    Contact c3 = {"Anna", "Rossi", "111", "url1"};
    Contact c4 = {"Luigi", "Bianchi", "111", "url1"};
    Contact c5 = {"Luigi", "Verdi", "111", "url1"};
    Contact c6 = {NULL, "Rossi", "111", "url1"};
    Contact c7 = {"Mario", NULL, "111", "url1"};

    if (contactCmpEff(&c1, &c2) != 0) {
        ok = 0;
    }

    if (contactCmpEff(&c3, &c1) != -1) {
        ok = 0;
    }

    if (contactCmpEff(&c1, &c3) != 1) {
        ok = 0;
    }

    if (contactCmpEff(&c4, &c1) != -1) {
        ok = 0;
    }

    if (contactCmpEff(&c5, &c1) != 1) {
        ok = 0;
    }

    if (contactCmpEff(&c1, &c6) != -99) {
        ok = 0;
    }

    if (contactCmpEff(&c7, &c1) != -99) {
        ok = 0;
    }

    if (ok) {
        printf("TEST PASSED\n");
    } else {
        printf("TEST FAILED\n");
    }

    return 0;
}
```

---

# Concetti da ricordare bene

## 1. Differenza tra passaggio per valore e passaggio per puntatore

Con:

```c
int contactEq(Contact c1, Contact c2)
```

i contatti vengono passati per valore.

Con:

```c
int contactEqEff(const Contact *pc1, const Contact *pc2)
```

vengono passati gli indirizzi dei contatti.

Quindi nella versione con puntatori si usa:

```c
pc1->name
```

che equivale a:

```c
(*pc1).name
```

---

## 2. `const Contact *pc1`

La scrittura:

```c
const Contact *pc1
```

significa che attraverso `pc1` non vogliamo modificare il contatto.

Quindi la funzione può leggere i campi, ma non dovrebbe cambiarli.

---

## 3. Perché usare `tolower`

Per ignorare le differenze tra maiuscole e minuscole, convertiamo ogni carattere in minuscolo:

```c
tolower((unsigned char)c)
```

Così:

```c
'M' == 'm'
'R' == 'r'
```

dal punto di vista del confronto.

---

## 4. Perché non usiamo `strcmp`

La funzione `strcmp` distingue maiuscole e minuscole.

Quindi:

```c
strcmp("Mario", "mario")
```

non restituisce `0`.

Per questo motivo abbiamo scritto `compareIgnoreCase`.

---

## 5. Ordinamento dei contatti

La funzione `contactCmp` confronta prima il cognome:

```c
cmpSurname = compareIgnoreCase(c1.surname, c2.surname);
```

Solo se i cognomi sono uguali confronta il nome:

```c
cmpName = compareIgnoreCase(c1.name, c2.name);
```

Questo è lo stesso criterio usato spesso nelle rubriche:

```text
Cognome, Nome
```

---

# Complessità

Sia:

```text
n = lunghezza del nome
m = lunghezza del cognome
```

Le funzioni hanno questa complessità:

|Funzione|Complessità|
|---|--:|
|`compareIgnoreCase`|O(k), dove k è la lunghezza della stringa più corta o fino alla prima differenza|
|`contactEq`|O(n + m)|
|`contactEqEff`|O(n + m)|
|`contactCmp`|O(n + m)|
|`contactCmpEff`|O(n + m)|

Il costo dipende dalla lunghezza delle stringhe, non dai campi `mobile` e `url`.