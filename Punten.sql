use WiseZonderFK

select 
	ll.LL_NAAM as Naam,
	ll.LL_VOORNAAM as Voornaam,
	kl.KL_OMSCHRIJVING as Klas, 
	sj.SJ_OMSCHRIJVINGKORT as Schooljaar,
	ins.IS_NAAMGEBRUIKER as School,
	bw.BW_NUMERIEK as [Punten op 1],
	ROUND(bw.BW_NUMERIEK * bm.BM_NOEMER, 2) as [Punten],
	bm.BM_NOEMER as [ op maximum],
	bm.BM_GEWICHT as Gewicht,
	bw.BW_COMMENTAAR as Commentaar,
	bw.BW_AFWEZIG as Afwezig,	
	bm.BM_OMSCHRIJVING as Omschrijving,
	bo.BO_TYPE as [type],
	bm.BM_DATUM as Datum,
	tussenresultaat.BM_OMSCHRIJVING as [tussenresultaat van],
	tussenresultaat.BM_NOEMER as [op maximum tussenresultaat],
	tussenresultaat.BM_GEWICHT as [gewicht tussenresultaat],
	iv.IV_NAAMGEBRUIKER as Vak

from Loopbanen lb
left join inuit iu on iu.ID = lb.LB_INUIT_FK 
left join Leerlingen ll on ll.ID = iu.IU_LEERLING_FK
left join Klasgroepen kg on kg.ID = lb.LB_KLASGROEP_FK
left join Klassen kl on kl.ID = kg.KG_KLAS_FK
left join Schooljaren sj on sj.ID = kl.KL_SCHOOLJAAR_FK
left join Instellingen ins on ins.ID = kl.KL_INSTELLING_FK
left join BeoordelingWaardes bw on lb.ID = bw.BW_LOOPBAAN_FK
left join Beoordelingen bo on bo.ID = bw.BW_BEOORDELING_FK
left join BeoordelingBerekeningen bb on bb.ID = bo.BO_BEOORDELINGBEREKENING_FK
left join BeoordelingMomenten bm on bm.ID = bo.BO_BEOORDELINGMOMENT_FK
left join BeoordelingMomenten tussenresultaat on tussenresultaat.ID = bm.BM_VOORTUSSENTOTAAL_FK
left join Puntenbladen pb on pb.ID = bm.BM_PUNTENBLAD_FK
left join IngVakken iv on iv.ID = pb.PL_INGVAK_FK

where sj.SJ_OMSCHRIJVINGKORT = '2023-2024'
and kl.KL_CODE = '6EE'
and bo.Bo_TYPE = 0




