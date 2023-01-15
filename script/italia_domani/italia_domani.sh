#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

URLbase="https://www.italiadomani.gov.it/content/sogei-ng/it/it/catalogo-open-data/jcr:content/root/container/opendatasearch.searchResults.html?orderby=%40jcr%3Acontent%2FobservationDateInEvidence&sort=desc&resultsOffset="

# sfoglia i risultati di 8 in 8 (al momento sono meno di 24)
for i in {0..80..8}; do
  echo "$i"
  # donwload della pagina
  curl -kL "$URLbase$i" >"$folder/tmp.html"
  # se non ci sono risultati esci dal ciclo
  if grep <"$folder/tmp.html" 'Non sono presenti risultati'; then
    echo "NON SONO PRESENTI RISULTATI"
    break
  fi
  # estrai i link ai csv
  cat "$folder/tmp.html" | grep -oP '/content/dam/sogei-ng/open-data/.+?.csv' | while read -r path; do
    url="https://www.italiadomani.gov.it$path"

    filename=$(basename "$path" .csv)
    # scarica i csv
  curl -kL "$url" -o "$folder/../data/$filename.csv"
  done
done

echo "sono fuori dal ciclo"
