select "Descrizione Missione" missione,count(*) numero,SUM("Finanziamento PNRR") valore
from progetti_universo 
group by "Descrizione Missione"
order by valore desc