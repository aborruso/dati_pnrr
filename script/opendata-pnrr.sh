#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

URLbase="https://www.italiadomani.gov.it/content/sogei-ng/it/it/catalogo-open-data/jcr:content/root/container/opendatasearch.searchResults.html?orderby=%40jcr%3Acontent%2FobservationDateInEvidence&sort=desc&resultsOffset="

for i in {0..16..8}; do
  echo "$i"
  curl -kL "$URLbase$i" >"$folder/tmp.html"
  #if grep <"$folder/tmp.html" 'Non sono presenti risultati'; then
  #  echo "NON SONO PRESENTI RISULTATI"
  #  break
  #fi
  grep <"$folder/tmp.html" -oP '/content/dam/sogei-ng/open-data/.*.csv' || true | while read -r path; do
    url="https://www.italiadomani.gov.it$path"
    echo $url
    curl -kL "$url" -o "$folder/../data/$(basename "$url")"
  done
done

echo "sono fuori dal ciclo"
