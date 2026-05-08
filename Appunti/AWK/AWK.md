### AWK: Flag e Variabili Interne

#### 1. Opzioni da Riga di Comando (Flags)
| Flag | Funzione | Esempio di utilizzo |
| :--- | :--- | :--- |
| **`-F`** | *Field Separator*: Imposta il carattere usato per separare i campi in input. | `awk -F':' '{print $1}'` |
| **`-v`** | *Variable*: Assegna un valore a una variabile personalizzata prima che lo script inizi l'esecuzione. | `awk -v limite=1000 '$3 > limite'` |
| **`-f`** | *File*: Legge il blocco di istruzioni AWK da un file esterno (per script lunghi e complessi). | `awk -f script.awk /etc/passwd` |

#### 2. Variabili Interne Fondamentali (Built-in Variables)
Queste variabili gestiscono l'architettura dei dati e possono essere usate liberamente dentro il blocco `{azione}` o nella `condizione`.

| Variabile | Nome Tecnico | Comportamento Sotto il Cofano |
| :--- | :--- | :--- |
| **`FS`** | *Field Separator* | Equivalente interno del flag `-F`. (Default: spazio/tab). |
| **`OFS`** | *Output Field Separator* | Il carattere che AWK inserisce in output quando si usa la virgola `,` nel comando `print`. (Default: spazio). |
| **`NR`** | *Number of Records* | Un contatore globale che indica il numero della riga (record) attualmente in elaborazione. Ottimo per numerare le righe in output. |
| **`NF`** | *Number of Fields* | Quanti campi contiene esattamente la riga corrente. **Tip da Pro:** `$NF` (con il dollaro) stampa *l'ultimo campo* della riga, qualunque sia la sua lunghezza. |
| **`RS`** | *Record Separator* | Come AWK capisce quando finisce una riga in input. (Default: carattere di andata a capo `\n`). |
| **`ORS`** | *Output Record Separator* | Cosa stampa AWK alla fine di ogni istruzione `print`. (Default: carattere di andata a capo `\n`). |

#### 3. Variabili Posizionali
| Variabile | Significato |
| :--- | :--- |
| **`$0`** | L'intero record corrente (la riga completa, non modificata). |
| **`$1`, `$2`...**| Il campo numero 1, 2, ecc., definito dal separatore `FS`. |