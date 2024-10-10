use WiseZonderFK

select kl.KL_CODE, ll.LL_VOORNAAM, ll.LL_NAAM, oid.OFF_USERNAME + '@' + oid.OFF_DOMAIN
from Leerlingen ll

left join InUit iu on ll.ID =  iu.IU_LEERLING_FK 
left join Loopbanen lb on iu.id = lb.LB_INUIT_FK
left join Klasgroepen kg on kg.ID = lb.LB_KLASGROEP_FK
left join Klassen kl on kl.ID = kg.KG_KLAS_FK
left join Instellingen ins on ins.ID = kl.KL_INSTELLING_FK
left join Schooljaren sj on sj.id = kl.KL_SCHOOLJAAR_FK
left join OfficeIDs oid on ll.id = oid.OFF_SOURCE_FK

where sj.SJ_OMSCHRIJVINGKORT = '2024-2025'
and ins.IS_NAAMGEBRUIKER like '%vti%'
and (kl.KL_code like '%4%' or kl.KL_CODE like '%3%')

order by kl.KL_CODE