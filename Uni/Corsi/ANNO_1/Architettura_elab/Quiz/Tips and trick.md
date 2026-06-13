
1) Quando capita la domanda sull'==overflow== (hex/signed)
	1) Scrivere i numeri su ARES e vederli in formato ==signed==, dopodiché calcolare la somma e la sottrazione e ricavarne il valore esadecimale
	2) Per determinare l'overflow fare il calcolo dei numeri, non guardare l'esadecimale
2) Quando capita la domanda sulle ==celle e la memoria==
	1) Quando chiede il load word devo segnare i byte che vedo in memoria considerando il little endian e lo scostamento 
	2) Quando chiede il save word devo guardare solo l'esadecimale (non più la memoria)
	3) Se c'è l'==unsigned== bisogna ricordare che si deve riempire i byte restanti con gli zero
	4) Se c'è una store e viene chiesto il byte a un indirizzo che sfora, bisogna guardare il valore che c'è in memoria, perché significa che quella porzione di memoria è rimasta invariata
3) Quando capita la domanda sul circuito
	1) Mapping delle operazioni

| ALU operation | Operazione | Cosa fa        | Result                          | Overflow                           |     |
| ------------- | ---------- | -------------- | ------------------------------- | ---------------------------------- | --- |
| `0000`        | AND        | `a AND b`      | risultato bit a bit             | `0`                                |     |
| `0001`        | OR         | `a OR b`       | risultato bit a bit             | `0`                                |     |
| `0010`        | ADD        | `a + b`        | somma a 4 bit                   | controllare overflow signed        |     |
| `0110`        | SUB        | `a - b`        | sottrazione a 4 bit             | controllare overflow signed        |     |
| `0111`        | SLT        | `a < b` signed | `0001` se vero, `0000` se falso | overflow della sottrazione `a - b` |     |
Per l'ADD, considerando l'architettura a 4 bit, dopo la somma dobbiamo verificare se il range fuoriesce da -8...+7 (in quel caso overflow = 1)

|a|b|Operazione signed|Result|Overflow|
|---|---|---|---|---|
|`0111`|`0001`|`+7 + +1`|`1000`|`1`|
|`0010`|`1110`|`+2 + -2`|`0000`|`0`|
|`1000`|`1111`|`-8 + -1`|`0111`|`1`|

Trucchetto


>overflow = 1 solo se sommo due numeri con lo stesso segno
   e il risultato ha segno diverso.

Per SUB, la condizione è simile, basta fare una somma di A + complementoA2(B)

Trucchetto


> overflow = 1 solo se a e b hanno segno diverso
> e il risultato ha segno diverso da a.


| a      | b      | Operazione signed | Result | Overflow |
| ------ | ------ | ----------------- | ------ | -------- |
| `0010` | `1000` | `+2 - (-8)`       | `1010` | `1`      |
| `0011` | `0001` | `+3 - +1`         | `0010` | `0`      |
| `1000` | `0001` | `-8 - +1`         | `0111` | `1`      |
