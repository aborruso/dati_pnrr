COPY aggiudicatari_validati FROM '/home/aborruso/lavagna/ondata/opendata-pnrr/report/script/../dati/parquet/aggiudicatari_validati.parquet' (FORMAT 'parquet');
COPY progetti_universo FROM '/home/aborruso/lavagna/ondata/opendata-pnrr/report/script/../dati/parquet/progetti_universo.parquet' (FORMAT 'parquet');
COPY progetti_validati FROM '/home/aborruso/lavagna/ondata/opendata-pnrr/report/script/../dati/parquet/progetti_validati.parquet' (FORMAT 'parquet');
COPY aggiudicatari_universo FROM '/home/aborruso/lavagna/ondata/opendata-pnrr/report/script/../dati/parquet/aggiudicatari_universo.parquet' (FORMAT 'parquet');
COPY localizzazioni_validate FROM '/home/aborruso/lavagna/ondata/opendata-pnrr/report/script/../dati/parquet/localizzazioni_validate.parquet' (FORMAT 'parquet');
COPY soggetti_validati FROM '/home/aborruso/lavagna/ondata/opendata-pnrr/report/script/../dati/parquet/soggetti_validati.parquet' (FORMAT 'parquet');
COPY localizzazioni_universo FROM '/home/aborruso/lavagna/ondata/opendata-pnrr/report/script/../dati/parquet/localizzazioni_universo.parquet' (FORMAT 'parquet');
