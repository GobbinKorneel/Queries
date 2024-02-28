use WiseZonderFK;

WITH tijdelijk as (
	select ltd.LTD_GROEPNAAM,
	ltd.LTD_GROEP_FK,
	ltd.LTD_GROEPTYPE,
	IV_NAAMGEBRUIKER,
	iv.ID as IV_ID,
	PS_NAAM,
	PS_VOORNAAM,
	COALESCE(lsd.LSD_KLASCODE, kl.KL_CODE, kl1.KL_CODE) as Klascode,
	SJ.ID as SJ_ID,
	PS.ID as PS_ID

	from Lesverdelingen lt
	left join Schooljaren sj on sj.ID = lt.LT_SCHOOLJAAR_FK
	left join Instellingen ins on ins.ID = lt.LT_INSTELLING_FK
	left join Lesverdelingdetails ltd on lt.ID = ltd.LTD_LESVERDELING_FK
	left join IngVakken iv on iv.ID = LTD_VAK_FK
	left join Personeel ps on ps.id = LTD_PERSONEEL_FK
	left join Lesgroepen lg on lg.ID = ltd.LTD_GROEP_FK and ltd.LTD_GROEPTYPE = 3
	left join Lesgroepdetails lsd on lg.ID = lsd.LSD_LESGROEP_FK and ltd.LTD_GROEPTYPE = 3
	left join Klassen kl on kl.ID = ltd.LTD_GROEP_FK and ltd.LTD_GROEPTYPE = 0
	left join Leseenheden le on le.ID = ltd.LTD_GROEP_FK and ltd.LTD_GROEPTYPE = 2
	left join Klassen kl1 on kl1.ID = le.LE_KLAS_FK and ltd.LTD_GROEPTYPE = 2
)
,
tijdelijk2 as (
		select distinct 
		bw.ID as BW_ID,
		ll.LL_NAAM as Naam,
		ll.LL_VOORNAAM as Voornaam,
		kl.KL_OMSCHRIJVING as Klas, 
		sj.SJ_OMSCHRIJVINGKORT as Schooljaar,
		ins.IS_NAAMGEBRUIKER as School,
		--bw.BW_NUMERIEK as [Punten op 1],
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
		iv.IV_NAAMGEBRUIKER as Vak,
		--STRING_AGG(td.PS_NAAM  + ' ' + td.PS_VOORNAAM, ', ') as [Leerkracht(en) gekoppeld aan vak],
		td.PS_NAAM + ' ' + td.PS_VOORNAAM as [Leerkracht(en) gekoppeld aan vak],
		ps.PS_NAAM + ' ' + ps.PS_VOORNAAM as [Punten ingegeven door]
	

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
	left join tijdelijk td on td.IV_ID = iv.ID and td.Klascode = kl.KL_CODE and td.SJ_ID = sj.ID 
	left join Personeel ps on ps.PS_USER_FK = bm.VERANDERDDOOR

	where bo.BO_TYPE = 0

)


select 
Naam,
Voornaam,
Klas, 
Schooljaar,
School,
[Punten],
[ op maximum],
Gewicht,
Commentaar,
Afwezig,	
Omschrijving,
[type],
Datum,
[tussenresultaat van],
[op maximum tussenresultaat],
[gewicht tussenresultaat],
Vak,
STRING_AGG([Leerkracht(en) gekoppeld aan vak], ', ') as [Leerkracht(en) gekoppeld aan vak],
[Punten ingegeven door]



from tijdelijk2 td



group by
BW_ID,
Naam,
Voornaam,
Klas, 
Schooljaar,
School,
[Punten],
[ op maximum],
Gewicht,
Commentaar,
Afwezig,	
Omschrijving,
[type],
Datum,
[tussenresultaat van],
[op maximum tussenresultaat],
[gewicht tussenresultaat],
Vak,
[Punten ingegeven door]
