select COUNT(*) OVER (PARTITION BY codice_locale, CUP) AS count,* REPLACE ((finanziamento_pnrr/count) as finanziamento_pnrr,(finanziamento_totale/count) as finanziamento_totale) FROM 
(select progetti_universo."Codice Locale Progetto" codice_locale, progetti_universo.CUP CUP,progetti_universo."Finanziamento PNRR" finanziamento_pnrr,
progetti_universo."Finanziamento Totale Pubblico" finanziamento_totale,
progetti_universo."Descrizione Missione" missione,progetti_universo."Descrizione Componente" componente,progetti_universo."Descrizione Misura" misura,progetti_universo."Descrizione Submisura" submisura,progetti_universo."Codice identificativo Procedura di Attivazione" identificativo_attivazione,
localizzazioni_universo."Descrizione Regione" regione,localizzazioni_universo."Descrizione Provincia" provincia,localizzazioni_universo."Descrizione Comune" comune,localizzazioni_universo.COD_ISTAT_COMUNE
from progetti_universo
LEFT join localizzazioni_universo
ON progetti_universo."Codice Locale Progetto"=localizzazioni_universo."Codice Locale Progetto"
AND progetti_universo."CUP"=localizzazioni_universo."CUP")
ORDER by count desc
