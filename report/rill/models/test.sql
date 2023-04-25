SELECT sum(finanziamento_pnrr) valore, COD_ISTAT_COMUNE PRO_COM_T,comune,missione FROM
localizzazione_model
where COD_ISTAT_COMUNE IS NOT NULL
group by ALL
order by valore desc