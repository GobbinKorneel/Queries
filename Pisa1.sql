use WiseZonderFK;

With tabel1 as (
	select 
		ll.ID,
		ll.LL_NAAM,
		ll.LL_VOORNAAM,
		kl.KL_CODE,
		IIF(Moedertaal.P_OMSCHRIJVING = 'Nederlands', 0, 1) as [Anders dan Nederlands moedertaal],
		IIF(Na.NA_OMSCHRIJVING = 'Belgische', 0, 1) as [Anders dan Belgische nationaliteit leerling],
		IIF(NaMama.NA_OMSCHRIJVING = 'Belgische', 0, 1) as [Anders dan Belgische nationaliteit moeder],
		IIF(NaPapa.NA_OMSCHRIJVING = 'Belgische', 0, 1) as [Anders dan Belgische nationaliteit vader],
		IIF(Na.Na_omschrijving like '%vluchteling%', 1, 0) as [Vluchteling]
			   
	from InUit IU

	inner join Leerlingen LL on LL.ID = IU.IU_LEERLING_FK
	inner join Loopbanen LB on IU.ID = LB.LB_INUIT_FK
	inner join Klasgroepen KG on KG.ID = LB.LB_KLASGROEP_FK
	inner join Klassen KL on KL.ID = KG.KG_KLAS_FK
	inner join Schooljaren SJ on SJ.ID = KL.KL_SCHOOLJAAR_FK
	inner join ParmTabs Leerjaren on Leerjaren.ID = lb.LB_LEERJAAR_FKP
	inner join Instellingen ins on ins.ID = kl.KL_INSTELLING_FK
	left join Leerlingkenmerken llk on ll.ID = llk.LLK_LEERLING_FK
	left join ParmTabs Moedertaal on Moedertaal.ID = ll.LL_MOEDERTAAL_FKP
	left join Nationaliteiten Na on Na.ID = ll.LL_NATIONALITEIT_FK
	left join Nationaliteiten NaMama on NaMama.ID = ll.LL_MOEDERNATIONALITEIT_FK
	left join Nationaliteiten NaPapa on NaPapa.ID = ll.LL_VADERNATIONALITEIT_FK


	where
		SJ_OMSCHRIJVINGKORT = '2023-2024'
		and Leerjaren.P_OMSCHRIJVING like '%vierde%'
		and ins.IS_NAAMGEBRUIKER like '%VTI%'
),
tabel2 as (
	
	select 
		ll.id,
		IIF(BeoordelingWaardes.BW_NUMERIEK < 0.5, 1, 0) as [Tekort],
		IngVakken.IV_NAAMGEBRUIKER
		
	from InUit IU

	inner join Leerlingen LL on LL.ID = IU.IU_LEERLING_FK
	inner join Loopbanen LB on IU.ID = LB.LB_INUIT_FK
	inner join Klasgroepen KG on KG.ID = LB.LB_KLASGROEP_FK
	inner join Klassen KL on KL.ID = KG.KG_KLAS_FK
	inner join Schooljaren SJ on SJ.ID = KL.KL_SCHOOLJAAR_FK
	inner join ParmTabs Leerjaren on Leerjaren.ID = lb.LB_LEERJAAR_FKP
	inner join Instellingen ins on ins.ID = kl.KL_INSTELLING_FK
	
	inner join BeoordelingWaardes ON LB.ID = BeoordelingWaardes.BW_LOOPBAAN_FK
	inner join Beoordelingen ON Beoordelingen.ID = BeoordelingWaardes.BW_BEOORDELING_FK
	inner join BeoordelingBerekeningen ON BeoordelingBerekeningen.ID = Beoordelingen.BO_BEOORDELINGBEREKENING_FK
	inner join Puntenbladen ON Puntenbladen.ID = BeoordelingBerekeningen.BB_PUNTENBLAD_FK and SJ.ID = Puntenbladen.PL_SCHOOLJAAR_FK

	inner join ParmTabs wat ON wat.ID = BeoordelingBerekeningen.BB_TYPE_FKP
	inner join Evaluatieverwijzingen ON Evaluatieverwijzingen.ID = BeoordelingBerekeningen.BB_EVALUATIEVERWIJZING_FK

	inner join IngVakken ON Puntenbladen.PL_INGVAK_FK = IngVakken.ID

	where
		SJ_OMSCHRIJVINGKORT = '2023-2024'
		and Leerjaren.P_OMSCHRIJVING like '%vierde%'
		and ins.IS_NAAMGEBRUIKER like '%VTI%'
		and Evaluatieverwijzingen.EV_TYPE = 1 
		and wat.P_OMSCHRIJVING = 'Punt berekening'
		and IngVakken.IV_NAAMGEBRUIKER in ('Aardrijkskunde', 'Chemie', 'Fysica elektriciteit', 'Fysica mechanica', 'Natuurwetenschappen')
)

select 
	tabel1.LL_NAAM,
	tabel1.LL_VOORNAAM,
	tabel1.KL_CODE,
	tabel1.[Anders dan Belgische nationaliteit leerling],
	tabel1.[Anders dan Belgische nationaliteit moeder],
	tabel1.[Anders dan Belgische nationaliteit vader],
	tabel1.[Anders dan Nederlands moedertaal],
	tabel1.Vluchteling,
	count(*) as [Aantal wetenschapsvakken],
	SUM(tekort) as [Aantal tekorten wetenschapsvakken]

from tabel1
left join tabel2 on tabel2.ID = tabel1.ID

group by
	tabel1.LL_NAAM,
	tabel1.LL_VOORNAAM,
	tabel1.KL_CODE,
	tabel1.[Anders dan Belgische nationaliteit leerling],
	tabel1.[Anders dan Belgische nationaliteit moeder],
	tabel1.[Anders dan Belgische nationaliteit vader],
	tabel1.[Anders dan Nederlands moedertaal],
	tabel1.Vluchteling


order by
KL_CODE, LL_NAAM, LL_VOORNAAM