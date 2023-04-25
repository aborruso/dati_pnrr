select progetti_universo."Codice Locale Progetto", progetti_universo.CUP ,progetti_universo."Finanziamento PNRR" finanziamento_pnrr,progetti_universo."Finanziamento Totale Pubblico" finanziamento_totale,
progetti_universo."Descrizione Missione",progetti_universo."Descrizione Componente",
localizzazioni_universo."Descrizione Regione",localizzazioni_universo."Descrizione Provincia",localizzazioni_universo."Descrizione Comune",localizzazioni_universo.COD_ISTAT_COMUNE
from progetti_universo
LEFT join localizzazioni_universo
ON progetti_universo."Codice Locale Progetto"=localizzazioni_universo."Codice Locale Progetto"
AND progetti_universo."CUP"=localizzazioni_universo."CUP"
