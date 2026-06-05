\## 1. Podstawy i Uwierzytelnianie



\* Zalogowanie się do Azure (w Cloud Shell dzieje się to automatycznie, przydatne na lokalnym komputerze):

&#x20; `az login`

\* Wyświetlenie obecnej, aktywnej subskrypcji:

&#x20; `az account show --output table`

\* Wyświetlenie wszystkich dostępnych subskrypcji:

&#x20; `az account list --output table`

\* Zmiana aktywnej subskrypcji:

&#x20; `az account set --subscription "<Twoje-ID-Subskrypcji>"`



\---



\## 2. Grupy Zasobów (Resource Groups)



\* Utworzenie nowej grupy zasobów:

&#x20; `az group create --name <Nazwa> --location <Region>`

\* Wylistowanie wszystkich grup zasobów w subskrypcji:

&#x20; `az group list --output table`

\* Usunięcie grupy zasobów (UWAGA: Usuwa bezpowrotnie wszystko, co znajduje się w środku!):

&#x20; `az group delete --name <Nazwa> --yes --no-wait`



\---



\## 3. Eksploracja i Wyszukiwanie Zasobów



\* Wylistowanie wszystkich zasobów w konkretnej grupie:

&#x20; `az resource list --resource-group <Nazwa-Grupy> --output table`

\* Wyszukanie konkretnego typu zasobu (np. obszarów Log Analytics):

&#x20; `az resource list --resource-type Microsoft.OperationalInsights/workspaces --output table`



\---



\## 4. Formatowanie Wyników (Dobra praktyka)

Azure CLI domyślnie zwraca długi i trudny do szybkiego czytania format JSON. Aby ułatwić pracę w terminalu, na końcu komendy dodawaj parametr `--output` (lub w skrócie `-o`).



\* `... --output table` - Zwraca czytelną tabelę.

\* `... --output tsv` - Zwraca same wartości oddzielone tabulatorem, bez nagłówków (idealne do przekazywania wyników do innych narzędzi w Bashu, np. `grep`).

\* `... --output jsonc` - Zwraca kolorowy, sformatowany JSON (przydatne przy analizie szczegółów technicznych i uprawnień).



\---



\## 5. System Ratunkowy



\* Wyświetlenie pomocy i dostępnych parametrów dla konkretnej komendy:

&#x20; `az group create --help`

\* Inteligentne wyszukiwanie przykładów użycia w dokumentacji Microsoftu:

&#x20; `az find "create log analytics workspace"`

