#!/bin/bash

set -x
set -e
set -u
set -o pipefail

nome="italia_domani"

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

URLbase="https://www.italiadomani.gov.it/content/sogei-ng/it/it/catalogo-open-data/jcr:content/root/container/opendatasearch.searchResults.html?orderby=%40jcr%3Acontent%2FobservationDateInEvidence&sort=desc&resultsOffset="

# sfoglia i risultati di 8 in 8 (al momento sono meno di 24)
for i in {0..80..8}; do
  echo "$i"
  # donwload della pagina
  curl -kL "$URLbase$i" -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' --compressed>"$folder/tmp.html"
  # se non ci sono risultati esci dal ciclo
  if grep <"$folder/tmp.html" 'Non sono presenti risultati'; then
    echo "Non ci sono più pagine con dati"
    break
  fi
  # estrai i link ai csv
  cat "$folder/tmp.html" | grep -oP '/content/dam/sogei-ng/open-data/.+?.csv' | while read -r path; do
    url=$(echo "https://www.italiadomani.gov.it$path" | sed 's/ /%20/g')

    filename=$(basename "$path" .csv)
    # scarica i csv
    curl -kL "$url" -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' --compressed -o "$folder/../../data/$nome/$filename.csv"
  done
done

echo "sono fuori dal ciclo"

find "$folder"/../../data/"$nome" -type f -size +100M -print0 | while IFS= read -r -d '' file;do
  basename=$(basename "$file" .csv)
  gzip -c "$file" > "$folder"/../../data/"$nome"/"$basename".csv.gz
  rm -f "$file"
done
