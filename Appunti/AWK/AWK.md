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

#### 4. Operatori di Confronto e Pattern Matching
Oltre ai classici operatori matematici, AWK possiede operatori specifici per filtrare i record in base al contenuto dei campi.

| Operatore | Nome Tecnico | Comportamento Sotto il Cofano | Esempio |
| :--- | :--- | :--- | :--- |
| **`==`** | Uguaglianza Rigorosa | Verifica se l'intero campo è *esattamente* identico a una determinata stringa o numero. Falsi negativi frequenti se il dato varia leggermente. | `$7 == "/bin/bash"` |
| **`~`** | RegEx Match | Valuta se il campo rispetta una specifica Espressione Regolare (che in AWK va sempre racchiusa tra due slash `/.../`). | `$7 ~ /sh$/` |
| **`!~`** | RegEx Mismatch | L'inverso del precedente: valuta se il campo **non** rispetta l'Espressione Regolare fornita. Utile per escludere pattern. | `$1 !~ /^sys/` |

#### 5. Architettura a Blocchi (Flusso di Esecuzione)
AWK non elabora i dati semplicemente in modo lineare, ma gestisce il ciclo di vita del flusso I/O attraverso tre fasi logiche distinte, permettendo la costruzione di report completi.

| Blocco | Funzione Architetturale | Caso d'Uso Tipico |
| :--- | :--- | :--- |
| **`BEGIN {azione}`** | Eseguito **esattamente una volta**, *prima* che AWK legga anche solo un singolo byte del file di input. | Inizializzare variabili (es. contatori), stampare le intestazioni (Header) di una tabella, o definire variabili interne come `FS` e `OFS` da codice. |
| **`condizione {azione}`** | Il *Main Loop*. Eseguito ciclicamente per **ogni singola riga** del file di input, a patto che la condizione sia valutata come VERA (True). | Estrazione e formattazione dei dati centrali del record corrente (es. `print $1, $3`). |
| **`END {azione}`** | Eseguito **esattamente una volta**, *dopo* aver processato l'ultima riga del file (o aver ricevuto il segnale di fine file EOF). | Stampare i piè di pagina (Footer) di un report, oppure calcolare e stampare totali e medie raccolte durante il Main Loop. |
