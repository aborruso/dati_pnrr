#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/processing

# if file exist delete it
if [ -f "$folder"/../dati/italia-domani.duckdb ]; then
  rm "$folder"/../dati/italia-domani.duckdb
fi

iconv -f windows-1252 -t utf-8 "$folder"/../../data/italia_domani/PNRR_Localizzazione-Dati_Validati.csv > "$folder"/../dati/tmp.csv

mv "$folder"/../dati/tmp.csv "$folder"/../dati/PNRR_Localizzazione-Dati_Validati.csv

mlr -I --csv --ifs ";" cat "$folder"/../dati/PNRR_Localizzazione-Dati_Validati.csv

iconv -f windows-1252 -t utf-8 "$folder"/../../data/italia_domani/PNRR_Localizzazione-Universo_REGIS.csv > "$folder"/../dati/tmp.csv

mv "$folder"/../dati/tmp.csv "$folder"/../dati/PNRR_Localizzazione-Universo_REGIS.csv

mlr -I --csv --ifs ";" cat "$folder"/../dati/PNRR_Localizzazione-Universo_REGIS.csv


duckdb -c "select 2*3" "$folder"/../dati/italia-domani.duckdb

## progetti

duckdb -c "CREATE TABLE progetti_validati AS SELECT * FROM read_csv_auto('"$folder"/../dati/PNRR_Progetti_Dati_Validati.csv',SEP=',',dateformat='%d/%m/%Y',types={'Codice CID':'VARCHAR','Codice fiscale soggetto attuatore':'VARCHAR','Codice identificativo Procedura di Attivazione':'VARCHAR','Codice Locale Progetto':'VARCHAR','Codice Univoco Misura':'VARCHAR','Codice Univoco Submisura':'VARCHAR','Componente':'VARCHAR','CUP':'VARCHAR','CUP Codice Categoria':'VARCHAR','CUP Codice Natura':'VARCHAR','CUP Codice Settore':'VARCHAR','CUP Codice Sottosettore':'VARCHAR','CUP Codice Tipologia':'VARCHAR','CUP Descrizione Categoria':'VARCHAR','CUP Descrizione Natura':'VARCHAR','CUP Descrizione Settore':'VARCHAR','CUP Descrizione Sottosettore':'VARCHAR','CUP Descrizione Tipologia':'VARCHAR','Descrizione Tipo Aiuto':'VARCHAR','Flag progetti in essere':'VARCHAR','ID Misura':'VARCHAR','ID Submisura':'VARCHAR','Missione':'VARCHAR','Programma':'VARCHAR','Sintesi progetto':'VARCHAR','Stato CUP':'VARCHAR','Tipologia procedura di attivazione':'VARCHAR','Titolo procedura':'VARCHAR','Titolo progetto':'VARCHAR','Data aggiornamento':'DATE','Altri fondi':'FLOAT','Finanziamento - Stato':'FLOAT','Finanziamento Altro Pubblico':'FLOAT','Finanziamento Comune':'FLOAT','Finanziamento Da Reperire':'FLOAT','Finanziamento PNC':'FLOAT','Finanziamento PNRR':'FLOAT','Finanziamento Privato':'FLOAT','Finanziamento Provincia':'FLOAT','Finanziamento Regione':'FLOAT','Finanziamento Totale':'FLOAT','Finanziamento Totale Pubblico':'FLOAT','Finanziamento Totale Pubblico Netto':'FLOAT','Finanziamento UE (diverso da PNRR)':'FLOAT','Amministrazione Titolare':'VARCHAR','Descrizione Componente':'VARCHAR','Descrizione Missione':'VARCHAR','Descrizione Submisura':'VARCHAR','Soggetto attuatore':'VARCHAR','Descrizione Misura':'VARCHAR'},decimal_separator=',');" "$folder"/../dati/italia-domani.duckdb

duckdb -c "CREATE TABLE progetti_universo AS SELECT * FROM read_csv_auto('"$folder"/../dati/PNRR_Progetti-Universo_REGIS.csv',SEP=',',dateformat='%d/%m/%Y',types={'Codice CID':'VARCHAR','Codice fiscale soggetto attuatore':'VARCHAR','Codice identificativo Procedura di Attivazione':'VARCHAR','Codice Locale Progetto':'VARCHAR','Codice Univoco Misura':'VARCHAR','Codice Univoco Submisura':'VARCHAR','Componente':'VARCHAR','CUP':'VARCHAR','CUP Codice Categoria':'VARCHAR','CUP Codice Natura':'VARCHAR','CUP Codice Settore':'VARCHAR','CUP Codice Sottosettore':'VARCHAR','CUP Codice Tipologia':'VARCHAR','CUP Descrizione Categoria':'VARCHAR','CUP Descrizione Natura':'VARCHAR','CUP Descrizione Settore':'VARCHAR','CUP Descrizione Sottosettore':'VARCHAR','CUP Descrizione Tipologia':'VARCHAR','Descrizione Tipo Aiuto':'VARCHAR','Flag progetti in essere':'VARCHAR','ID Misura':'VARCHAR','ID Submisura':'VARCHAR','Missione':'VARCHAR','Programma':'VARCHAR','Sintesi progetto':'VARCHAR','Stato CUP':'VARCHAR','Tipologia procedura di attivazione':'VARCHAR','Titolo procedura':'VARCHAR','Titolo progetto':'VARCHAR','Altri fondi':'FLOAT','Finanziamento - Stato':'FLOAT','Finanziamento Altro Pubblico':'FLOAT','Finanziamento Comune':'FLOAT','Finanziamento Da Reperire':'FLOAT','Finanziamento PNC':'FLOAT','Finanziamento PNRR':'FLOAT','Finanziamento Privato':'FLOAT','Finanziamento Provincia':'FLOAT','Finanziamento Regione':'FLOAT','Finanziamento Totale':'FLOAT','Finanziamento Totale Pubblico':'FLOAT','Finanziamento Totale Pubblico Netto':'FLOAT','Finanziamento UE (diverso da PNRR)':'FLOAT','Amministrazione Titolare':'VARCHAR','Descrizione Componente':'VARCHAR','Descrizione Missione':'VARCHAR','Descrizione Submisura':'VARCHAR','Soggetto attuatore':'VARCHAR','Descrizione Misura':'VARCHAR'},decimal_separator=',');" "$folder"/../dati/italia-domani.duckdb

## localizzazioni

mlrgo --csv put 'if(${Codice Comune}!="0"){$COD_ISTAT_COMUNE=fmtnum(${Codice Provincia},"%03d").fmtnum(${Codice Comune},"%03d")}else{$COD_ISTAT_COMUNE=""}' "$folder"/../dati/PNRR_Localizzazione-Dati_Validati.csv >"$folder"/processing/tmp.csv

duckdb -c "CREATE TABLE localizzazioni_validate AS SELECT * FROM read_csv_auto('"$folder"/processing/tmp.csv',SEP=',',dateformat='%d/%m/%Y',decimal_separator=',');" "$folder"/../dati/italia-domani.duckdb

mlrgo --csv put 'if(${Comune}!="0"){$COD_ISTAT_COMUNE=fmtnum(${Provincia},"%03d").fmtnum(${Comune},"%03d")}else{$COD_ISTAT_COMUNE=""}' "$folder"/../dati/PNRR_Localizzazione-Universo_REGIS.csv >"$folder"/processing/tmp.csv

duckdb -c "CREATE TABLE localizzazioni_universo AS SELECT * FROM read_csv_auto('"$folder"/processing/tmp.csv',SEP=',',dateformat='%d/%m/%Y',decimal_separator=',');" "$folder"/../dati/italia-domani.duckdb

# if file exist delete it
if [ -f "$folder"/processing/tmp.csv ]; then
  rm "$folder"/processing/tmp.csv
fi

## soggetti

duckdb -c "CREATE TABLE soggetti_validati AS SELECT * FROM read_csv_auto('"$folder"/../dati/PNRR_Soggetti-Dati_Validati.csv',SEP=',',dateformat='%d/%m/%Y',decimal_separator=',');" "$folder"/../dati/italia-domani.duckdb

## aggiudicatari

duckdb -c "CREATE TABLE aggiudicatari_validati AS SELECT * FROM read_csv_auto('"$folder"/../dati/PNRR_Gare_Aggiudicatari-Dati_Validati.csv',SEP=',',dateformat='%d/%m/%Y',types={'Data pubblicazione del CIG':'DATE','Importo complessivo gara':'FLOAT','Importo aggiudicazione':'FLOAT','Data aggiudicazione definitiva':'DATE','Data di aggiornamento':'DATE','Codice interno PDA':'VARCHAR'},decimal_separator=',');" "$folder"/../dati/italia-domani.duckdb

duckdb -c "CREATE TABLE aggiudicatari_universo AS SELECT * FROM read_csv_auto('"$folder"/../dati/PNRR_Gare_Aggiudicatari-Universo_REGIS.csv',SEP=',',dateformat='%d/%m/%Y',types={'Data pubblicazione del CIG':'DATE','Importo complessivo gara':'FLOAT','Importo aggiudicazione':'FLOAT','Data aggiudicazione definitiva':'DATE','Codice interno PDA':'VARCHAR'},decimal_separator=',');" "$folder"/../dati/italia-domani.duckdb


# export to parquet
duckdb -c "EXPORT DATABASE '"$folder"/../dati/parquet' (FORMAT PARQUET);" "$folder"/../dati/italia-domani.duckdb




