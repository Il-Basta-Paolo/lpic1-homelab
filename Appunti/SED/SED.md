### I Flag del Comando di Sostituzione di `sed`

| Flag | Nome Tecnico | Comportamento Sotto il Cofano |
| :--- | :--- | :--- |
| **`g`** | *Global* | Forza `sed` a processare l'intera riga (Pattern Space), sostituendo **tutte** le occorrenze trovate, non fermandosi alla prima. |
| **`n`** | *N-th occurrence* | Sostituisce **solo** l'n-esima occorrenza del pattern nella riga (es. `2`, `3`). Utile per saltare i primi match in strutture ripetitive. |
| **`p`** | *Print* | Se la sostituzione ha successo, stampa il risultato (Pattern Space corrente) sullo Standard Output. Spesso si usa con `sed -n`. |
| **`i`** o **`I`** | *Case Insensitive* | Ignora la differenza tra maiuscole e minuscole durante la fase di *matching* del pattern. (Disponibile in GNU `sed`). |
| **`w file`** | *Write* | Se la sostituzione ha successo, scrive la riga modificata direttamente nel file specificato (es. `w output.txt`). |
| **`e`** | *Execute* | (Avanzato) Esegue il risultato della sostituzione come comando shell e inserisce l'output nel flusso. Potente ma pericoloso. |