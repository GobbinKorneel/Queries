select 
bw.ID as BW_ID,
bb.BB_CODE,
bb.BB_OMSCHRIJVING,
bb.bb_code,
ROUND(bw.BW_NUMERIEK * 100, 2),
ll.LL_NAAM,
ll.LL_VOORNAAM,
pb.PL_NAAM,
iv.IV_NAAMGEBRUIKER,
sj.SJ_OMSCHRIJVINGKORT,
p.P_OMSCHRIJVING,
lj.P_OMSCHRIJVING,
ins.IS_NAAMGEBRUIKER,
ev.EV_TYPE,
case 
	when ev.EV_TYPE = 1 then 'Jaarevaluatie'
	when ev.EV_TYPE = 2 then 'Periode evaluatie'
	when ev.EV_TYPE = 3 then 'Dagelijks werk'
	when ev.EV_TYPE = 4 then 'Examen'
End as [Type evaluatie],
COALESCE(ex.EX_CODE, dw.DR_CODE) as Code,
coalesce(ex.EX_OMSCHRIJVING, dw.DR_OMSCHRIJVING) as Omschrijving,
coalesce(pe.PEV_CODE, PE2.PEV_CODE, pe3.PEV_CODE) as [Code periode],
coalesce(pe.PEV_OMSCHRIJVING, pe2.PEV_OMSCHRIJVING, pe3.PEV_OMSCHRIJVING) as [Omschrijving periode],
je.JE_AANTALPERIODES as [Aantal periodes],
pe.PEV_AANTALDW as [Aantal DW],
pe.PEV_AANTALEX as [Aantal EX]


from Beoordelingen bo
inner join BeoordelingBerekeningen bb on bb.ID = bo.BO_BEOORDELINGBEREKENING_FK
inner join BeoordelingWaardes bw on bo.id = bw.BW_BEOORDELING_FK
inner join Loopbanen lb on lb.ID = bw.BW_LOOPBAAN_FK
inner join InUit iu on iu.ID = lb.LB_INUIT_FK
inner join Leerlingen ll on ll.ID = iu.IU_LEERLING_FK
inner join Puntenbladen pb on pb.Id = BB_PUNTENBLAD_FK
inner join IngVakken iv on iv.ID = PL_INGVAK_FK
inner join Schooljaren sj on sj.Id = PL_SCHOOLJAAR_FK
inner join ParmTabs p on p.ID = BB_TYPE_FKP
inner join ParmTabs lj on lj.Id = PL_LEERJAAR_FKP
inner join Instellingen ins on ins.id = iv.IV_INSTELLING_FK
left join Evaluatieverwijzingen ev on ev.ID = bb.BB_EVALUATIEVERWIJZING_FK
left join Jaarevaluaties je on je.ID = ev.EV_JAAREVALUATIE_FK and ev.EV_TYPE = 1
left join PeriodeEvaluaties pe on pe.id = ev.EV_PERIODEEVALUATIE_FK and ev.EV_TYPE = 2
left join Dagelijkswerken dw on dw.ID = ev.EV_DAGELIJKSWERK_FK and ev.EV_TYPE = 3
left join Examens ex on ex.id = ev.EV_EXAMEN_FK and ev.EV_TYPE = 4
left join PeriodeEvaluaties pe2 on pe2.ID = ex.EX_PERIODEEVALUATIE_FK  
left join PeriodeEvaluaties pe3 on pe3.ID = dw.DR_PERIODEEVALUATIE_FK  


