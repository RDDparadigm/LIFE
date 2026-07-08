# Programmazione 2 — Allenamento quiz teorici C

> File pensato per i quiz a risposta chiusa/menu a tendina: “questa espressione è lecita?”, “che output produce?”, “può andare in segmentation fault?”, “termina sempre?”, “quale tipo ha questa espressione?”.
>
> Obiettivo: allenare l’occhio sui trabocchetti tipici di C: dichiarazioni, `typedef`, puntatori, struct, union, array, stringhe, `NULL`, `malloc/free`, tipi opachi, `void *`, puntatori a funzione, ADT, output e terminazione.

---

## 0. Come usare questo file

Per ogni blocco:

1. leggi il codice;
2. prova a rispondere senza guardare la soluzione;
3. chiediti sempre: **compila?**; se compila, chiediti: **è definito a runtime?**; se è definito, chiediti: **che valore/output produce?**;
4. solo dopo guarda la soluzione.

La distinzione più importante nei quiz è questa:

| Categoria | Significato |
|---|---|
| **Errore statico / non compila** | Il compilatore ha già abbastanza informazioni per rifiutare l’espressione. |
| **Compila ma comportamento indefinito** | Il codice è sintatticamente valido, ma a runtime può succedere qualsiasi cosa. |
| **Compila ma può andare in segmentation fault** | Caso specifico di comportamento non sicuro: stai dereferenziando memoria non valida, `NULL`, memoria liberata, fuori array, ecc. |
| **Compila e risultato determinato** | L’espressione è lecita e il valore/output è prevedibile. |
| **Compila ma valore non determinato / dipendente** | Il codice è lecito, ma il valore dipende da indirizzi, stato della memoria, input, rappresentazione, ecc. |

---

# 1. Metodo universale per risolvere un quiz teorico in C

Quando vedi una domanda infida, non partire “a sentimento”. Fai sempre questi passaggi.

## 1.1 Espandi i `typedef`

Esempio:

```c
typedef int *IntPtr;
IntPtr p, q;
```

Non significa:

```c
int *p, *q;
```

Sì, in questo caso il risultato pratico è quello, ma perché `IntPtr` è già un tipo “puntatore a int”. Quindi sia `p` sia `q` sono `int *`.

Diverso:

```c
int *p, q;
```

Qui `p` è `int *`, mentre `q` è `int`.

**Regola mentale:** il `typedef` crea un nome di tipo nuovo. Dopo, ogni variabile dichiarata con quel nome ha quel tipo intero.

---

## 1.2 Conta le stelle, ma conta anche il tipo puntato

```c
int x;
int *p;
int **pp;
```

| Espressione | Tipo | Note |
|---|---|---|
| `x` | `int` | valore intero |
| `&x` | `int *` | indirizzo di un int |
| `p` | `int *` | puntatore a int |
| `*p` | `int` | oggetto puntato da p, se p è valido |
| `&p` | `int **` | indirizzo della variabile puntatore |
| `pp` | `int **` | puntatore a puntatore a int |
| `*pp` | `int *` | puntatore a int |
| `**pp` | `int` | int finale |

**Trappola:** `*p` può avere tipo giusto ma essere comunque pericoloso se `p == NULL` o non inizializzato.

---

## 1.3 Prima chiediti: “è un accesso a memoria?”

Queste espressioni **non leggono il valore puntato**:

```c
p;
&p;
p == NULL;
p + 1;
```

Queste invece leggono/scrivono memoria puntata:

```c
*p;
p[0];
p->field;
(*p).field;
```

Quindi un puntatore `NULL` può essere confrontato:

```c
if (p == NULL) { }
```

ma non può essere dereferenziato:

```c
*p;       // comportamento indefinito se p == NULL
p->x;     // comportamento indefinito se p == NULL
p[0];     // comportamento indefinito se p == NULL
```

---

## 1.4 Distingui sempre tre livelli

Esempio:

```c
typedef struct {
    int a;
} Tipo;

Tipo x;
Tipo *p;
```

| Voglio… | Uso |
|---|---|
| il campo `a` della variabile struct `x` | `x.a` |
| il campo `a` della struct puntata da `p` | `p->a` oppure `(*p).a` |
| l’indirizzo del campo `a` di `x` | `&x.a` |
| l’indirizzo del campo `a` dell’oggetto puntato da `p` | `&p->a` oppure `&((*p).a)` |

`p.a` è sbagliato: `p` è un puntatore, non una struct.

`x->a` è sbagliato: `x` è una struct, non un puntatore.

---

## 1.5 Se ci sono struct annidate, devi attraversare tutti i nomi

```c
typedef struct {
    int tag;
    struct {
        int value;
    } inner;
} Box;

Box b;
Box *p;
```

Corretto:

```c
b.inner.value;
p->inner.value;
(*p).inner.value;
```

Sbagliato:

```c
b.value;       // Box non ha campo value
p->value;      // Box non ha campo value
```

---

## 1.6 `.` e `->` hanno priorità alta; `*p.campo` non è quello che sembra

```c
*p.x
```

viene letto come:

```c
*(p.x)
```

non come:

```c
(*p).x
```

Quindi, se vuoi accedere al campo di una struct puntata da `p`, devi scrivere:

```c
p->x
(*p).x
```

---

## 1.7 Prima il compilatore, poi il runtime

Domanda tipica:

```c
int *p = NULL;
printf("%d", *p);
```

Risposta corretta:

- **staticamente corretta**: il compilatore accetta `*p` perché `p` è `int *`;
- **a runtime comportamento indefinito**: dereferenziare `NULL` non è lecito;
- **può produrre segmentation fault**: sì.

---

# 2. Tipi composti: `struct`, `union`, `enum`, `typedef`

## 2.1 `struct`: accesso ai membri

```c
typedef struct {
    int id;
    char c;
} Record;

Record r;
Record *p;
```

### Quiz 2.1

Indica se le espressioni sono corrette.

| Espressione | Risposta |
|---|---|
| `r.id` | corretta |
| `p->id` | corretta se `p` punta a un `Record` valido |
| `(*p).id` | corretta se `p` punta a un `Record` valido |
| `p.id` | errore statico |
| `r->id` | errore statico |
| `&r.id` | corretta, tipo `int *` |
| `&(p->id)` | corretta se `p` valido, tipo `int *` |

**Spiegazione:** `.` si usa su oggetti struct; `->` su puntatori a struct.

---

## 2.2 `typedef struct _s { ... } Nome;`

```c
typedef struct _s {
    int x;
} MioTipo;

MioTipo a;
struct _s b;
MioTipo *p;
```

Qui `MioTipo` e `struct _s` indicano lo stesso tipo.

Corretto:

```c
a.x;
b.x;
p->x;
```

---

## 2.3 Struct anonima senza tag

```c
typedef struct {
    int x;
} MioTipo;
```

Qui puoi usare `MioTipo`, ma non puoi scrivere:

```c
struct MioTipo v;     // sbagliato
struct _s v;          // sbagliato, non esiste un tag _s
```

---

## 2.4 `union`: i membri condividono la stessa memoria

```c
typedef union {
    int i;
    char c;
} U;

U u;
```

Accessi sintatticamente corretti:

```c
u.i;
u.c;
```

Ma attenzione: `i` e `c` occupano la stessa zona di memoria. Se scrivi:

```c
u.i = 65;
printf("%c", u.c);
```

il codice può compilare, ma l’interpretazione dipende dalla rappresentazione in memoria. Nei quiz base, spesso vogliono farti dire che **l’accesso è sintatticamente lecito**, non necessariamente che il valore sia semanticamente “pulito”.

---

## 2.5 Struct con union annidata: devi nominare anche la union

Esempio simile allo screenshot:

```c
#define N 10

typedef struct _s {
    int caso;
    union {
        int num[N];
        char car[N];
    } dati;
} mieidati;

mieidati X, *Y;
```

### Quiz 2.5

| Espressione | Risposta | Perché |
|---|---|---|
| `Y->num[0]` | **errata** | `num` non è campo diretto della struct; è dentro `dati` |
| `Y->dati.num[0]` | corretta se `Y` valido | accedo a struct puntata, poi union, poi array |
| `X->car[0]` | **errata** | `X` non è un puntatore |
| `X.dati.car[0]` | corretta | `X` è struct, uso `.`, poi `dati`, poi `car` |
| `Y = *X` | **errata** | `X` non è puntatore, quindi `*X` non ha senso |
| `*Y = X` | sintatticamente corretta se `Y` valido | assegna la struct `X` all’oggetto puntato da `Y` |
| `Y = &X` | corretta | `Y` è `mieidati *`, `&X` è `mieidati *` |
| `Y->dati.car` | corretta se `Y` valido | in espressione decade spesso a `char *` |
| `Y->dati.car[0] = 'a'` | corretta se `Y` valido | scrive nel primo elemento dell’array `car` |

**Pattern da ricordare:**

```c
puntatore_a_struct->campo_union.campo_array[indice]
variabile_struct.campo_union.campo_array[indice]
```

---

## 2.6 `enum`

```c
enum Stato {VUOTO, PIENO, ERRORE};

enum Stato s = VUOTO;
```

Gli identificatori assumono valori interi progressivi:

```c
VUOTO  // 0
PIENO  // 1
ERRORE // 2
```

Quindi:

```c
if (s == VUOTO) { }
```

è corretto.

Attenzione: in C un `enum` è compatibile con valori interi più di quanto ci si aspetterebbe. Questo spesso compila:

```c
s = 17;
```

ma semanticamente può non avere senso.

---

# 3. Puntatori: `*`, `&`, `NULL`, assegnamenti

## 3.1 Regola base

```c
int x = 10;
int *p = &x;
```

| Espressione | Tipo | Valore/effetto |
|---|---|---|
| `x` | `int` | 10 |
| `&x` | `int *` | indirizzo di `x` |
| `p` | `int *` | indirizzo di `x` |
| `*p` | `int` | 10 |
| `&p` | `int **` | indirizzo della variabile `p` |

---

## 3.2 Quiz su assegnamenti

```c
int x = 3;
int y = 4;
int *p = &x;
int *q = NULL;
```

| Istruzione | Corretta? | Effetto |
|---|---|---|
| `p = &y;` | sì | `p` punta a `y` |
| `*p = y;` | sì | modifica `x`, perché `p` punta a `x` inizialmente |
| `q = p;` | sì | `q` punta dove punta `p` |
| `*q = 7;` | dipende | se `q == NULL`, comportamento indefinito; dopo `q = p`, sì |
| `p = x;` | errore/warning grave | assegna un `int` a un puntatore |
| `x = p;` | errore/warning grave | assegna un puntatore a un `int` |
| `p = NULL;` | sì | `p` non punta a nessun oggetto valido |
| `*p = 8;` dopo `p = NULL` | compila ma UB | possibile segmentation fault |

---

## 3.3 Puntatore non inizializzato

```c
int *p;
*p = 10;
```

Compila, ma è comportamento indefinito: `p` contiene un valore indeterminato.

Nei quiz:

- “la scrittura è sintatticamente corretta?” → sì;
- “il programma è corretto?” → no;
- “può produrre segmentation fault?” → sì.

---

## 3.4 `NULL` come argomento

```c
void f(int *p);
```

Questa chiamata è staticamente corretta:

```c
f(NULL);
```

Però il corpo di `f` deve gestirla. Se fa:

```c
void f(int *p) {
    *p = 10;
}
```

allora `f(NULL)` compila, ma a runtime ha comportamento indefinito.

---

## 3.5 Puntatore a puntatore

```c
int x = 5;
int *p = &x;
int **pp = &p;
```

| Espressione | Tipo | Valore |
|---|---|---|
| `pp` | `int **` | indirizzo di `p` |
| `*pp` | `int *` | valore di `p`, cioè `&x` |
| `**pp` | `int` | valore di `x`, cioè 5 |
| `&pp` | `int ***` | indirizzo di `pp` |

---

# 4. `typedef` infidi e chiamate di funzione

## 4.1 Esempio tipico da quiz

```c
typedef ... miotipo, *punt;

int funzione(miotipo *param);

miotipo x;
punt y;
```

Qui:

```c
punt y;
```

significa:

```c
miotipo *y;
```

Quindi la funzione vuole un parametro di tipo:

```c
miotipo *
```

### Quiz 4.1

| Chiamata | Corretta staticamente? | Perché |
|---|---|---|
| `funzione(&x);` | sì | `&x` ha tipo `miotipo *` |
| `funzione(NULL);` | sì | `NULL` può essere passato a un parametro puntatore |
| `funzione(&y);` | no | `&y` ha tipo `miotipo **` |
| `funzione(x);` | no | `x` ha tipo `miotipo`, non `miotipo *` |
| `funzione(y);` | sì | `y` ha tipo `miotipo *` |

---

## 4.2 Alias di puntatore: trappola con `const`

```c
typedef int *IntPtr;
const IntPtr p;
```

`p` è un **puntatore costante a int**, non un puntatore a `const int`.

Equivale a:

```c
int * const p;
```

non a:

```c
const int *p;
```

Questa è una trappola molto cattiva.

---

## 4.3 Quiz su typedef

```c
typedef int *P;
int x = 1;
const int c = 2;
P p = &x;
const P q = &x;
```

| Istruzione | Corretta? | Perché |
|---|---|---|
| `*p = 5;` | sì | `p` punta a int modificabile |
| `p = &c;` | warning/errore concettuale | perdi `const`, `&c` è `const int *` |
| `*q = 7;` | sì | `q` è puntatore costante a int, ma l’int puntato è modificabile |
| `q = &x;` | no | `q` è const come puntatore |

---

# 5. Array, puntatori e `sizeof`

## 5.1 Array e puntatori non sono la stessa cosa

```c
int a[5];
int *p = a;
```

In molte espressioni, `a` decade a puntatore al primo elemento, quindi:

```c
p = a;
p = &a[0];
```

sono equivalenti.

Ma `sizeof(a)` e `sizeof(p)` sono diversi:

```c
sizeof(a)  // 5 * sizeof(int)
sizeof(p)  // sizeof(int *)
```

---

## 5.2 Quiz `sizeof`

```c
void f(int a[]) {
    printf("%zu\n", sizeof(a));
}

int main(void) {
    int v[10];
    printf("%zu\n", sizeof(v));
    f(v);
}
```

Nel `main`, `v` è un array vero.

Dentro `f`, il parametro `int a[]` è in realtà `int *a`.

Quindi:

- `sizeof(v)` vale `10 * sizeof(int)`;
- `sizeof(a)` dentro `f` vale `sizeof(int *)`.

---

## 5.3 Accesso con indice

```c
int a[3] = {10, 20, 30};
int *p = a;
```

Sono equivalenti:

```c
a[0]
*(a + 0)
p[0]
*(p + 0)
```

Sono equivalenti:

```c
a[2]
*(a + 2)
p[2]
*(p + 2)
```

Trappola divertente ma lecita:

```c
2[a]
```

è equivalente a:

```c
*(2 + a)
```

quindi è uguale ad `a[2]`. Compila, ma è pessimo stile.

---

## 5.4 Fuori dai limiti

```c
int a[3] = {1, 2, 3};
a[3] = 9;
```

Compila, ma è comportamento indefinito. Gli indici validi sono `0, 1, 2`.

---

## 5.5 Array dentro struct

```c
typedef struct {
    int v[5];
} S;

S s;
S *p = &s;
```

| Espressione | Corretta? |
|---|---|
| `s.v[0]` | sì |
| `p->v[0]` | sì |
| `(*p).v[0]` | sì |
| `p.v[0]` | no |
| `s->v[0]` | no |
| `&s.v[0]` | sì, tipo `int *` |
| `s.v` | sì, spesso decade a `int *` |

---

# 6. Stringhe C: `\0`, `\n`, buffer e terminazione

## 6.1 Una stringa C non è un generico `char *`

Una stringa C è una sequenza di `char` terminata da `\0`.

```c
char *s;
```

è solo un puntatore a char. Diventa “stringa” solo se punta a una sequenza valida terminata da `\0`.

---

## 6.2 Esempio da screenshot

```c
void funz(char *s) {
    while (*s != '\n')
        s = s + 1;
}
```

### Domande

| Affermazione | Risposta | Perché |
|---|---|---|
| la funzione terminerà sempre | no | se non trova `\n`, continua oltre i dati validi |
| la funzione può produrre segmentation fault | sì | può dereferenziare memoria non valida |
| la funzione riceve in input una stringa | non necessariamente | riceve `char *`; non controlla `\0` |
| la funzione può ricevere `NULL` come argomento | staticamente sì | ma poi dereferenzia `*s`, quindi `funz(NULL)` è UB |

Versione più sicura se vuoi cercare `\n` in una stringa C:

```c
void funz_safe(const char *s) {
    if (s == NULL) return;

    while (*s != '\0' && *s != '\n') {
        s++;
    }
}
```

---

## 6.3 `\0` vs `\n`

```c
'\0'   // terminatore di stringa
'\n'   // carattere newline
```

Trappola:

```c
while (*s != '\n')
```

non si ferma alla fine della stringa, a meno che prima non trovi newline.

Questa è più tipica per attraversare una stringa:

```c
while (*s != '\0')
```

oppure semplicemente:

```c
while (*s)
```

---

## 6.4 Modificare string literal

```c
char *s = "ciao";
s[0] = 'C';
```

Compila spesso, ma modificare una string literal è comportamento indefinito.

Meglio:

```c
char s[] = "ciao";
s[0] = 'C';
```

Qui `s` è un array modificabile.

---

## 6.5 Quiz stringhe

```c
char a[] = "abc";
char *p = "abc";
```

| Espressione/Istruzione | Risposta |
|---|---|
| `sizeof(a)` | 4, perché include `\0` |
| `strlen(a)` | 3 |
| `sizeof(p)` | dimensione di un puntatore |
| `strlen(p)` | 3 |
| `a[0] = 'A';` | ok |
| `p[0] = 'A';` | comportamento indefinito |
| `a = p;` | errore statico: un array non è assegnabile |
| `p = a;` | ok: `a` decade a `char *` |

---

# 7. Funzioni: passaggio per valore, per indirizzo e side effect

## 7.1 Passaggio per valore

```c
void f(int x) {
    x = 10;
}

int main(void) {
    int a = 5;
    f(a);
    printf("%d", a);
}
```

Output:

```text
5
```

`f` modifica solo la copia locale.

---

## 7.2 Passaggio tramite puntatore

```c
void f(int *p) {
    *p = 10;
}

int main(void) {
    int a = 5;
    f(&a);
    printf("%d", a);
}
```

Output:

```text
10
```

Perché `f` accede alla memoria di `a`.

---

## 7.3 Modificare il puntatore locale non modifica il chiamante

```c
void f(int *p) {
    p = NULL;
}

int main(void) {
    int a = 5;
    int *q = &a;
    f(q);
    printf("%d", *q);
}
```

Output:

```text
5
```

`p` è una copia di `q`. Cambiare `p` non cambia `q`.

---

## 7.4 Per modificare il puntatore del chiamante serve puntatore a puntatore

```c
void f(int **pp) {
    *pp = NULL;
}

int main(void) {
    int a = 5;
    int *q = &a;
    f(&q);

    if (q == NULL) {
        printf("NULL");
    }
}
```

Output:

```text
NULL
```

---

## 7.5 Quiz su firme

```c
void g(int *p);
int x;
int *p;
int **pp;
```

| Chiamata | Corretta? |
|---|---|
| `g(x);` | no |
| `g(&x);` | sì |
| `g(p);` | sì, ma `p` deve essere valido se `g` dereferenzia |
| `g(&p);` | no, tipo `int **` |
| `g(*pp);` | sì, tipo `int *`, ma `pp` deve essere valido per valutare `*pp` |
| `g(NULL);` | sì staticamente |

---

# 8. `malloc`, `free`, memoria dinamica

## 8.1 Pattern corretto

```c
int *p = malloc(sizeof *p);
if (p == NULL) {
    // errore allocazione
}
*p = 10;
free(p);
p = NULL;
```

`sizeof *p` è preferibile perché resta corretto anche se cambi il tipo di `p`.

---

## 8.2 `malloc` restituisce `void *`

In C, il valore restituito da `malloc` può essere assegnato a qualunque puntatore a oggetto:

```c
int *p = malloc(sizeof *p);
```

Il cast non serve in C:

```c
int *p = (int *) malloc(sizeof *p);  // non necessario in C
```

---

## 8.3 `free(NULL)` è lecito

```c
int *p = NULL;
free(p);   // ok
```

Non fa nulla.

---

## 8.4 Double free

```c
int *p = malloc(sizeof *p);
free(p);
free(p);
```

Compila, ma è comportamento indefinito.

Meglio:

```c
free(p);
p = NULL;
free(p);   // ok, perché free(NULL) è lecito
```

---

## 8.5 Use after free

```c
int *p = malloc(sizeof *p);
*p = 5;
free(p);
printf("%d", *p);
```

Compila, ma è comportamento indefinito. Dopo `free`, non puoi più dereferenziare `p`.

---

## 8.6 Quiz memoria dinamica

| Codice | Valutazione |
|---|---|
| `int *p = malloc(sizeof(int)); *p = 3;` | compila, ma manca controllo `p == NULL` |
| `int *p = malloc(sizeof p);` | compila, ma alloca dimensione del puntatore, non dell’int |
| `int *p = malloc(sizeof *p);` | corretto |
| `free(p); p = NULL;` | ottimo pattern |
| `free(*p);` se `p` è `int *` | errore/assurdo: `*p` è int, non puntatore |
| `free(&x);` con `int x;` | comportamento indefinito: `x` non viene da malloc |

---

# 9. `const` e principio del privilegio minimo

## 9.1 Le quattro combinazioni principali

```c
char *p;                 // posso modificare p e *p
const char *p;           // posso modificare p, non posso modificare *p tramite p
char * const p;          // non posso modificare p, posso modificare *p
const char * const p;    // non posso modificare né p né *p tramite p
```

---

## 9.2 Come leggere `const`

Leggi da destra verso sinistra, oppure separa puntatore e dato.

```c
const char *p;
```

`p` è un puntatore a `char` costante.

```c
char * const p = buffer;
```

`p` è un puntatore costante a `char` modificabile.

---

## 9.3 Quiz `const`

```c
char a[] = "ciao";
char b[] = "test";
const char *p = a;
char * const q = a;
const char * const r = a;
```

| Istruzione | Corretta? |
|---|---|
| `p = b;` | sì |
| `p[0] = 'C';` | no, tramite `p` il dato è const |
| `q = b;` | no, `q` è puntatore const |
| `q[0] = 'C';` | sì, il dato puntato da `q` non è const |
| `r = b;` | no |
| `r[0] = 'C';` | no |

---

## 9.4 Passare parametri `const`

```c
size_t my_strlen(const char *s);
```

Questa firma dice: “la funzione può leggere la stringa, ma non deve modificarla”.

Se una funzione non deve modificare dati puntati, usa `const`.

---

# 10. `void *` e ADT generici

## 10.1 Che cosa puoi fare con `void *`

```c
void *p;
int x = 5;
p = &x;
```

Puoi assegnare un indirizzo a `void *`.

Per usare il valore puntato, devi convertire:

```c
int *ip = p;
printf("%d", *ip);
```

oppure:

```c
printf("%d", *(int *)p);
```

---

## 10.2 Che cosa non puoi fare con `void *`

```c
void *p;
*p;       // errore: non posso dereferenziare void *
p[0];     // errore concettuale: tipo puntato sconosciuto
```

Il compilatore non sa quanti byte leggere.

In C standard, anche l’aritmetica su `void *` non è ammessa:

```c
p + 1;    // non standard, estensione di alcuni compilatori
```

Devi prima convertire:

```c
((char *)p) + 1;
((int *)p) + 1;
```

---

## 10.3 Quiz `void *`

```c
int x = 42;
void *vp = &x;
int *ip = vp;
```

| Espressione | Risposta |
|---|---|
| `vp = &x;` | corretta |
| `ip = vp;` | corretta in C |
| `*vp` | errore statico |
| `*(int *)vp` | corretta, se `vp` punta davvero a int |
| `vp == NULL` | corretta |
| `free(vp)` | corretta solo se `vp` è un puntatore ottenuto da malloc, oppure NULL |

---

# 11. Puntatori a funzione

## 11.1 Sintassi base

```c
int somma(int a, int b) {
    return a + b;
}

int (*pf)(int, int) = somma;
```

Chiamate equivalenti:

```c
pf(2, 3);
(*pf)(2, 3);
```

---

## 11.2 Quiz puntatori a funzione

```c
int f(int x) { return x + 1; }
int g(int x) { return x * 2; }
int (*pf)(int) = f;
```

| Espressione | Risposta |
|---|---|
| `pf(3)` | 4 |
| `(*pf)(3)` | 4 |
| `pf = g;` | corretta |
| `pf = &g;` | corretta |
| `pf == f` | corretta, confronto tra puntatori a funzione |
| `int (*p2)(double) = f;` | no, firma incompatibile |
| `int *p = f;` | no, puntatore a oggetto ≠ puntatore a funzione |

---

## 11.3 Funzione che riceve un puntatore a funzione

```c
int apply(int x, int (*fun)(int)) {
    return fun(x);
}
```

Chiamata corretta:

```c
apply(10, f);
```

Se `fun == NULL`, questa funzione compila ma a runtime fallisce quando chiama `fun(x)`.

Versione difensiva:

```c
int apply(int x, int (*fun)(int)) {
    if (fun == NULL) return x;
    return fun(x);
}
```

---

# 12. Tipi opachi, ADT, `.h` e `.c`

## 12.1 Tipo opaco

Nel file `.h`:

```c
typedef struct stack *StackADT;

StackADT mkStack(void);
void dsStack(StackADT *sPtr);
_Bool push(StackADT s, int value);
_Bool pop(StackADT s, int *result);
```

Nel file `.c`:

```c
struct stack {
    NodePtr top;
    int size;
};
```

Il client conosce solo `StackADT`, cioè un puntatore a `struct stack`, ma non conosce i campi.

---

## 12.2 Cosa può fare il client con un tipo opaco

Se nel `.h` c’è solo:

```c
typedef struct stack *StackADT;
```

il client può scrivere:

```c
StackADT s;
s = mkStack();
push(s, 10);
```

ma non può scrivere:

```c
s->top;          // errore: struct stack incompleta nel client
sizeof(*s);      // errore: dimensione di tipo incompleto ignota
```

Può invece fare:

```c
sizeof(s);       // ok: s è un puntatore
s == NULL;       // ok
```

---

## 12.3 Quiz tipo opaco

```c
typedef struct hidden *Hidden;
Hidden h;
```

Nel file corrente non è visibile la definizione di `struct hidden`.

| Espressione | Risposta |
|---|---|
| `h == NULL` | corretta |
| `h = NULL` | corretta |
| `sizeof(h)` | corretta |
| `sizeof(*h)` | errore: tipo incompleto |
| `h->campo` | errore: campo non noto |
| `Hidden *hp;` | corretta: puntatore a puntatore a tipo incompleto |

---

# 13. Liste linkate: quiz teorici tipici

## 13.1 Definizione base

```c
typedef struct node Node, *NodePtr;

struct node {
    int data;
    NodePtr next;
};

NodePtr list;
Node n;
NodePtr p;
```

### Quiz 13.1

| Espressione | Risposta |
|---|---|
| `n.data` | corretta |
| `n.next` | corretta, tipo `NodePtr` |
| `p->data` | corretta se `p` valido |
| `p->next` | corretta se `p` valido |
| `p.next` | errore |
| `list->next->data` | corretta se `list` e `list->next` validi |
| `list->next.data` | errore: `next` è puntatore, serve `->` |
| `(*list).data` | corretta se `list` valido |
| `&list` | corretta, tipo `NodePtr *`, cioè `Node **` |

---

## 13.2 Riconoscere possibili segmentation fault

```c
int first(NodePtr list) {
    return list->data;
}
```

- Compila? sì.
- Termina sempre? no, se `list == NULL` può fare segmentation fault.
- È corretta per lista vuota? no.

Versione sicura:

```c
_Bool first(NodePtr list, int *out) {
    if (list == NULL || out == NULL) return 0;
    *out = list->data;
    return 1;
}
```

---

## 13.3 Passaggio per valore o per riferimento

```c
void f(NodePtr list) {
    list = list->next;
}
```

Questa funzione non modifica il puntatore del chiamante. Modifica solo la copia locale `list`.

Per modificare la testa:

```c
void f(NodePtr *listPtr) {
    *listPtr = (*listPtr)->next;
}
```

Ma attenzione: se `listPtr == NULL` o `*listPtr == NULL`, la funzione dereferenzia invalidamente.

Versione più sicura:

```c
void f(NodePtr *listPtr) {
    if (listPtr == NULL || *listPtr == NULL) return;
    *listPtr = (*listPtr)->next;
}
```

---

# 14. Stack e queue: domande concettuali

## 14.1 Stack

Stack = LIFO: Last In, First Out.

Se faccio:

```c
push(s, 'a');
push(s, 'b');
push(s, 'c');
```

allora i `pop` restituiscono:

```text
c b a
```

---

## 14.2 Queue

Queue = FIFO: First In, First Out.

Se faccio:

```c
enqueue(q, 'a');
enqueue(q, 'b');
enqueue(q, 'c');
```

allora i `dequeue` restituiscono:

```text
a b c
```

---

## 14.3 Caso critico della coda

Quando rimuovi l’ultimo nodo:

```c
q->front = q->front->next;
```

se la coda diventa vuota, devi anche fare:

```c
if (q->front == NULL) {
    q->rear = NULL;
}
```

Domanda tipica: “la coda resta consistente?”

Se `front == NULL` ma `rear` punta ancora al vecchio nodo liberato, hai un dangling pointer.

---

# 15. Alberi binari e BST: quiz teorici

## 15.1 Definizione base

```c
typedef struct node Node, *Tree;

struct node {
    int data;
    Tree left;
    Tree right;
};

Tree t;
Node n;
```

| Espressione | Risposta |
|---|---|
| `n.data` | corretta |
| `t->data` | corretta se `t` valido |
| `t->left` | corretta se `t` valido |
| `t.left` | errore |
| `t->left->data` | corretta se `t` e `t->left` validi |
| `&t` | tipo `Tree *`, cioè `Node **` |

---

## 15.2 Ricorsione su albero

```c
int count(Tree t) {
    if (t == NULL) return 0;
    return 1 + count(t->left) + count(t->right);
}
```

Domande tipiche:

| Domanda | Risposta |
|---|---|
| Termina sempre? | se l’albero è finito e aciclico, sì |
| Può accedere a `t->left` quando `t == NULL`? | no, perché prima c’è il caso base |
| Complessità? | `O(n)`, visita tutti i nodi |

---

## 15.3 BST

In un Binary Search Tree, per ogni nodo:

```text
valori nel sottoalbero sinistro < nodo < valori nel sottoalbero destro
```

oppure, in alcune specifiche, duplicati ammessi da una parte. Devi sempre leggere la specifica.

Ricerca:

```c
_Bool search(Tree t, int x) {
    if (t == NULL) return 0;
    if (x == t->data) return 1;
    if (x < t->data) return search(t->left, x);
    return search(t->right, x);
}
```

Caso peggiore:

- albero bilanciato: `O(log n)`;
- albero degenerato: `O(n)`.

---

# 16. Ricorsione, terminazione e output

## 16.1 Funzione ricorsiva corretta

```c
int fact(int n) {
    if (n <= 1) return 1;
    return n * fact(n - 1);
}
```

Per `n >= 0` termina.

Per `n` molto grande può causare stack overflow.

---

## 16.2 Ricorsione senza caso base raggiungibile

```c
int f(int n) {
    return f(n + 1);
}
```

Compila, ma non termina normalmente. Prima o poi probabilmente stack overflow.

---

## 16.3 Quiz output con side effect

```c
int f(int x) {
    x++;
    return x;
}

int main(void) {
    int a = 3;
    printf("%d %d", f(a), a);
}
```

Output:

```text
4 3
```

Perché `x` è copia locale.

---

## 16.4 Attenzione all’ordine di valutazione

```c
int i = 1;
printf("%d %d", i++, i++);
```

Da evitare. L’ordine di valutazione degli argomenti di funzione non è quello che vuoi assumere. In molti casi simili il comportamento può essere non definito o comunque non portabile a seconda dell’espressione.

Per i quiz, diffida sempre di espressioni con più modifiche della stessa variabile nella stessa istruzione.

Esempio classico di comportamento indefinito:

```c
i = i++ + 1;
```

---

# 17. File I/O: quiz tipici

## 17.1 `fopen`

```c
FILE *fp = fopen("dati.txt", "r");
```

Se il file non può essere aperto, `fopen` restituisce `NULL`.

Prima di usare `fp`, devi controllare:

```c
if (fp == NULL) {
    // errore
}
```

---

## 17.2 `fclose`

Se hai aperto un file con successo, devi chiuderlo:

```c
fclose(fp);
```

Usare `fp` dopo `fclose(fp)` è analogo a usare memoria dopo `free`: non devi farlo.

---

## 17.3 `EOF` è un `int`

Funzione tipica:

```c
int c;
while ((c = fgetc(fp)) != EOF) {
    putchar(c);
}
```

Non usare `char c` per confrontare con `EOF`: `EOF` deve poter essere rappresentato da un valore distinto da ogni carattere valido.

---

## 17.4 Trappola `feof`

Pattern sbagliato:

```c
while (!feof(fp)) {
    fscanf(fp, "%d", &x);
    // usa x
}
```

Meglio:

```c
while (fscanf(fp, "%d", &x) == 1) {
    // usa x
}
```

Perché devi controllare se la lettura è riuscita, non se sei già arrivato a EOF prima di leggere.

---

# 18. Complessità: quiz rapidi

## 18.1 Cicli semplici

```c
for (int i = 0; i < n; i++) {
    // O(1)
}
```

Complessità: `O(n)`.

---

## 18.2 Cicli annidati

```c
for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
        // O(1)
    }
}
```

Complessità: `O(n^2)`.

---

## 18.3 Ciclo dimezzante

```c
while (n > 0) {
    n = n / 2;
}
```

Complessità: `O(log n)`.

---

## 18.4 Due cicli consecutivi

```c
for (int i = 0; i < n; i++) { }
for (int j = 0; j < n; j++) { }
```

Complessità: `O(n)`, non `O(2n)`.

---

## 18.5 Lista vs BST

Ricerca in lista linkata:

```text
O(n)
```

Ricerca in BST bilanciato:

```text
O(log n)
```

Ricerca in BST degenerato:

```text
O(n)
```

---

# 19. Mega-sezione quiz: “scegli dal menu”

## Quiz 19.1 — Struct e puntatori

```c
typedef struct {
    int a;
    int b;
} Pair;

Pair x;
Pair *p = &x;
```

Classifica:

1. `x.a`
2. `p.a`
3. `p->a`
4. `(*p).a`
5. `&p->a`
6. `*p.a`

### Soluzione

1. corretta;
2. errata, `p` è puntatore;
3. corretta;
4. corretta;
5. corretta, tipo `int *`;
6. errata: viene interpretata come `*(p.a)`, ma `p.a` è già errata.

---

## Quiz 19.2 — Typedef puntatore

```c
typedef struct node *List;
struct node {
    int data;
    List next;
};

List l;
List *lp;
```

Classifica:

1. `l->data`
2. `(*lp)->data`
3. `lp->data`
4. `&l`
5. `*l`

### Soluzione

1. corretta se `l` valido;
2. corretta se `lp` e `*lp` validi;
3. errata: `lp` è puntatore a `List`, cioè `struct node **`; non punta direttamente a struct node;
4. corretta, tipo `List *`, cioè `struct node **`;
5. corretta sintatticamente se `l` valido: `*l` è una `struct node`.

---

## Quiz 19.3 — Array in struct

```c
typedef struct {
    char nome[20];
} Persona;

Persona p;
Persona *q = &p;
```

Classifica:

1. `p.nome[0]`
2. `q->nome[0]`
3. `q.nome[0]`
4. `p->nome[0]`
5. `q->nome`
6. `&q->nome[0]`

### Soluzione

1. corretta;
2. corretta;
3. errata;
4. errata;
5. corretta, array che in molte espressioni decade a `char *`;
6. corretta, tipo `char *`.

---

## Quiz 19.4 — Union annidata

```c
#define N 4

typedef struct {
    int tipo;
    union {
        int i[N];
        char c[N];
    } u;
} Dato;

Dato d;
Dato *p = &d;
```

Classifica:

1. `d.u.i[2]`
2. `p->u.c[1]`
3. `p->c[1]`
4. `d.i[0]`
5. `(*p).u.i[0]`

### Soluzione

1. corretta;
2. corretta;
3. errata: `c` è dentro `u`;
4. errata: `i` è dentro `u`;
5. corretta.

---

## Quiz 19.5 — Chiamate funzione

```c
void f(double *p);

double x;
double *p;
double **pp;
```

Classifica:

1. `f(x);`
2. `f(&x);`
3. `f(p);`
4. `f(&p);`
5. `f(*pp);`
6. `f(NULL);`

### Soluzione

1. errata;
2. corretta;
3. corretta staticamente;
4. errata, tipo `double **`;
5. corretta staticamente se `pp` è valutabile;
6. corretta staticamente, ma pericolosa se `f` dereferenzia.

---

## Quiz 19.6 — Output passaggio per valore

```c
void f(int x) {
    x = x + 10;
}

int main(void) {
    int a = 1;
    f(a);
    printf("%d", a);
}
```

### Soluzione

Output:

```text
1
```

---

## Quiz 19.7 — Output puntatore

```c
void f(int *x) {
    *x = *x + 10;
}

int main(void) {
    int a = 1;
    f(&a);
    printf("%d", a);
}
```

### Soluzione

Output:

```text
11
```

---

## Quiz 19.8 — Puntatore locale

```c
void f(int *p) {
    p = NULL;
}

int main(void) {
    int a = 3;
    int *q = &a;
    f(q);
    printf("%d", *q);
}
```

### Soluzione

Output:

```text
3
```

La funzione modifica solo la copia locale del puntatore.

---

## Quiz 19.9 — Puntatore a puntatore

```c
void f(int **p) {
    *p = NULL;
}

int main(void) {
    int a = 3;
    int *q = &a;
    f(&q);
    printf("%d", q == NULL);
}
```

### Soluzione

Output:

```text
1
```

---

## Quiz 19.10 — Stringa senza terminatore controllato

```c
int conta(char *s) {
    int n = 0;
    while (*s != 'x') {
        n++;
        s++;
    }
    return n;
}
```

Affermazioni:

1. termina sempre;
2. può produrre segmentation fault;
3. con `"abcx"` restituisce 3;
4. con `NULL` è staticamente invocabile.

### Soluzione

1. falso;
2. vero;
3. vero;
4. vero, ma a runtime dereferenzia `NULL`.

---

## Quiz 19.11 — `sizeof`

```c
void f(int a[]) {
    printf("%zu", sizeof(a));
}

int main(void) {
    int v[5];
    printf("%zu ", sizeof(v));
    f(v);
}
```

### Soluzione

Stampa:

```text
5 * sizeof(int)   sizeof(int *)
```

I valori numerici dipendono dalla piattaforma.

---

## Quiz 19.12 — `malloc` sbagliata ma compilabile

```c
int *p = malloc(sizeof(p));
```

### Soluzione

Compila, ma alloca `sizeof(int *)`, non `sizeof(int)`. Su alcune piattaforme può essere più grande di `int` e quindi non esplodere subito, ma il pattern è concettualmente sbagliato.

Meglio:

```c
int *p = malloc(sizeof *p);
```

---

## Quiz 19.13 — Tipo opaco

Nel `.h`:

```c
typedef struct queue *Queue;
Queue mkQueue(void);
```

Nel client:

```c
Queue q = mkQueue();
```

Classifica:

1. `q == NULL`
2. `q->front`
3. `sizeof(q)`
4. `sizeof(*q)`

### Soluzione

1. corretta;
2. errata, tipo incompleto;
3. corretta, dimensione del puntatore;
4. errata, dimensione della struct opaca non nota.

---

## Quiz 19.14 — `void *`

```c
void *p;
int x = 7;
p = &x;
```

Classifica:

1. `*p`
2. `*(int *)p`
3. `(int *)p`
4. `p == NULL`

### Soluzione

1. errata: non puoi dereferenziare `void *`;
2. corretta se `p` punta davvero a int;
3. corretta: cast;
4. corretta.

---

## Quiz 19.15 — Precedenza operatori

```c
typedef struct {
    int x;
} S;

S s;
S *p = &s;
```

Classifica:

1. `*p.x`
2. `(*p).x`
3. `p->x`

### Soluzione

1. errata: viene letta come `*(p.x)`;
2. corretta;
3. corretta.

---

## Quiz 19.16 — Free

```c
int x;
int *p = &x;
free(p);
```

### Soluzione

Compila, ma è comportamento indefinito: puoi fare `free` solo di puntatori ottenuti da `malloc/calloc/realloc`, oppure `NULL`.

---

## Quiz 19.17 — `free(NULL)`

```c
int *p = NULL;
free(p);
```

### Soluzione

Corretto. Non fa nulla.

---

## Quiz 19.18 — Modificare string literal

```c
char *s = "abc";
s[0] = 'A';
```

### Soluzione

Compila spesso, ma comportamento indefinito.

---

## Quiz 19.19 — Array modificabile

```c
char s[] = "abc";
s[0] = 'A';
printf("%s", s);
```

### Soluzione

Output:

```text
Abc
```

---

## Quiz 19.20 — Ricorsione

```c
int f(int n) {
    if (n == 0) return 0;
    return 1 + f(n - 1);
}
```

Affermazioni:

1. `f(3)` restituisce 3;
2. `f(0)` restituisce 0;
3. `f(-1)` termina;
4. per valori grandi può causare stack overflow.

### Soluzione

1. vero;
2. vero;
3. falso in condizioni normali: va verso numeri sempre più negativi;
4. vero.

---

## Quiz 19.21 — BST search

```c
_Bool search(Tree t, int x) {
    if (t == NULL) return 0;
    if (x == t->data) return 1;
    if (x < t->data) return search(t->left, x);
    return search(t->right, x);
}
```

Affermazioni:

1. su albero vuoto restituisce 0;
2. può dereferenziare `NULL` nel caso base;
3. visita sempre tutti i nodi;
4. in un BST bilanciato è `O(log n)`.

### Soluzione

1. vero;
2. falso;
3. falso;
4. vero.

---

## Quiz 19.22 — Puntatore a funzione

```c
int inc(int x) { return x + 1; }
int (*pf)(int) = inc;
```

Classifica:

1. `pf(4)`
2. `(*pf)(4)`
3. `pf = NULL; pf(4);`

### Soluzione

1. restituisce 5;
2. restituisce 5;
3. compila, ma chiamare un puntatore a funzione `NULL` è comportamento indefinito.

---

## Quiz 19.23 — `const char *`

```c
char a[] = "abc";
const char *p = a;
```

Classifica:

1. `p = p + 1;`
2. `*p = 'A';`
3. `a[0] = 'A';`

### Soluzione

1. corretta: il puntatore non è const;
2. errata: tramite `p` il dato è const;
3. corretta: `a` è array modificabile.

---

## Quiz 19.24 — `char * const`

```c
char a[] = "abc";
char b[] = "def";
char * const p = a;
```

Classifica:

1. `p = b;`
2. `p[0] = 'A';`

### Soluzione

1. errata: puntatore const;
2. corretta: dato modificabile.

---

## Quiz 19.25 — Output con queue concettuale

Operazioni:

```text
enqueue 1
enqueue 2
dequeue
enqueue 3
dequeue
dequeue
```

### Soluzione

I valori estratti sono:

```text
1 2 3
```

FIFO.

---

# 20. Checklist finale anti-trabocchetto

Prima di scegliere una risposta in un menu a tendina, controlla:

- `.` su struct, `->` su puntatore a struct;
- campi annidati: non saltare il nome della struct/union interna;
- `*p.campo` quasi sempre è sbagliato: probabilmente volevi `(*p).campo`;
- `typedef ... *Nome;` significa che `Nome` è già un tipo puntatore;
- `&x` aumenta di un livello di puntatore;
- `*p` diminuisce di un livello, ma solo se `p` è valido;
- `NULL` è passabile a parametri puntatore, ma non dereferenziabile;
- un `char *` non è automaticamente una stringa valida;
- una stringa C termina con `\0`, non con `\n`;
- `sizeof(array)` funziona solo dove l’array è davvero array, non parametro di funzione;
- `free(NULL)` è ok;
- `free` su memoria non dinamica è UB;
- usare memoria dopo `free` è UB;
- modificare string literal è UB;
- `void *` non si dereferenzia senza cast;
- tipo opaco: puoi maneggiare il puntatore, non i campi;
- funzione che riceve puntatore può ricevere `NULL` staticamente;
- funzione che dereferenzia senza controllo può fare segmentation fault;
- se una funzione modifica solo un parametro passato per valore, il chiamante non cambia;
- per modificare il puntatore del chiamante serve puntatore a puntatore;
- se una funzione non ha caso base raggiungibile, non termina normalmente;
- in una coda, quando togli l’ultimo elemento devi aggiornare anche `rear`;
- negli output, diffida di espressioni con `i++` usato più volte nella stessa istruzione.

---

# 21. Mini-simulazione finale

## Blocco A

```c
typedef struct {
    int n;
    char *s;
} A;

A a;
A *p = &a;
```

Rispondi:

1. `a.n`
2. `p.n`
3. `p->s[0]`
4. `(*p).s`
5. `&p->n`

### Soluzione A

1. corretta;
2. errata;
3. corretta sintatticamente, ma `p` deve essere valido e `s` deve puntare a memoria valida;
4. corretta;
5. corretta, tipo `int *`.

---

## Blocco B

```c
void f(char *s) {
    while (*s != '\0') {
        s++;
    }
}
```

Affermazioni:

1. termina per ogni `char *`;
2. termina per ogni stringa C valida finita;
3. può ricevere `NULL` staticamente;
4. con `NULL` è sicura.

### Soluzione B

1. falso;
2. vero;
3. vero;
4. falso.

---

## Blocco C

```c
typedef int *P;
P x;
int y;
```

Classifica:

1. `x = &y;`
2. `*x = 3;`
3. `y = x;`
4. `x = y;`

### Soluzione C

1. corretta;
2. corretta solo se `x` punta a int valido;
3. errata/warning grave: assegna puntatore a int;
4. errata/warning grave: assegna int a puntatore.

---

## Blocco D

```c
typedef struct nodo *Lista;
struct nodo {
    int dato;
    Lista next;
};

void g(Lista l) {
    l = l->next;
}
```

Affermazioni:

1. `g(NULL)` è staticamente corretta;
2. `g(NULL)` è sicura;
3. `g(l)` modifica la testa della lista del chiamante;
4. `l->next` richiede che `l` sia valido.

### Soluzione D

1. vero;
2. falso;
3. falso;
4. vero.

---

# 22. Cosa devi saper dire a voce all’esame

Se ti chiedono “perché?”, devi rispondere così:

- **“Non compila perché sto usando `->` su una variabile che non è puntatore.”**
- **“Non compila perché il campo non appartiene direttamente alla struct, ma alla union interna.”**
- **“Compila, però può produrre segmentation fault perché il puntatore può essere `NULL` e viene dereferenziato.”**
- **“La funzione riceve un `char *`, ma non necessariamente una stringa C valida.”**
- **“`NULL` è un valore lecito per un puntatore a livello statico, ma va controllato prima della dereferenziazione.”**
- **“Il parametro è passato per valore, quindi modificare il parametro non modifica la variabile del chiamante.”**
- **“Per modificare il puntatore del chiamante serve passare il suo indirizzo, quindi un puntatore a puntatore.”**
- **“Con tipo opaco posso usare il puntatore e le funzioni pubbliche, ma non accedere ai campi.”**
- **“`void *` può contenere l’indirizzo di un oggetto di tipo sconosciuto, ma non posso dereferenziarlo senza cast.”**
- **“`sizeof` su un array parametro restituisce la dimensione del puntatore, non dell’array originale.”**

---

# 23. Allenamento consigliato

Per diventare molto rapido nei quiz, fai così:

1. prendi 10 righe di dichiarazioni;
2. sotto scrivi il tipo esatto di ogni variabile;
3. inventa 20 espressioni;
4. per ognuna scrivi una tra:
   - non compila;
   - compila e accede correttamente;
   - compila ma UB;
   - compila ma può fare segmentation fault;
   - output determinato;
   - output non determinabile;
5. poi verifica con `gcc -Wall -Wextra -pedantic -std=c17`.

Il punto non è memorizzare le risposte, ma allenare l’occhio a vedere subito:

```text
livello di puntatore + operatore usato + campo esistente + validità runtime
```

Quando questa catena diventa automatica, i quiz teorici diventano molto meno spaventosi.
