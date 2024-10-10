use WiseZonderFK;

With tabel1 as (

select 
	ll.LL_NAAM,
	ll.LL_VOORNAAM,
	kl.KL_CODE,
	IIF(Moedertaal.P_OMSCHRIJVING = 'Nederlands', 0, 1) as [Anders dan Nederlands moedertaal],
	IIF(Na.NA_OMSCHRIJVING = 'Belgische', 0, 1) as [Anders dan Belgische nationaliteit leerling],
	IIF(NaMama.NA_OMSCHRIJVING = 'Belgische', 0, 1) as [Anders dan Belgische nationaliteit moeder],
	IIF(NaPapa.NA_OMSCHRIJVING = 'Belgische', 0, 1) as [Anders dan Belgische nationaliteit vader],
	IIF(Na.Na_omschrijving like '%vluchteling%', 1, 0) as [Vluchteling],

	IIF(BeoordelingWaardes.BW_NUMERIEK < 0.5, 1, 0) as [Tekort]




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

left join BeoordelingWaardes ON LB.ID = BeoordelingWaardes.BW_LOOPBAAN_FK
left join Beoordelingen ON Beoordelingen.ID = BeoordelingWaardes.BW_BEOORDELING_FK
left join BeoordelingBerekeningen ON BeoordelingBerekeningen.ID = Beoordelingen.BO_BEOORDELINGBEREKENING_FK
left join Puntenbladen ON Puntenbladen.ID = BeoordelingBerekeningen.BB_PUNTENBLAD_FK and SJ.ID = Puntenbladen.PL_SCHOOLJAAR_FK

left join ParmTabs wat ON wat.ID = BeoordelingBerekeningen.BB_TYPE_FKP
left join Evaluatieverwijzingen ON Evaluatieverwijzingen.ID = BeoordelingBerekeningen.BB_EVALUATIEVERWIJZING_FK

left join IngVakken ON Puntenbladen.PL_INGVAK_FK = IngVakken.ID

where
	SJ_OMSCHRIJVINGKORT = '2023-2024'
	and Leerjaren.P_OMSCHRIJVING like '%vierde%'
	and ins.IS_NAAMGEBRUIKER like '%VTI%'
	and Evaluatieverwijzingen.EV_TYPE = 1 
	and wat.P_OMSCHRIJVING = 'Punt berekening'
	and IngVakken.IV_NAAMGEBRUIKER in ('Aardrijkskunde', 'Chemie', 'Fysica elektriciteit', 'Fysica mechanica', 'Natuurwetenschappen')
)

select 
	LL_NAAM, 
	LL_VOORNAAM,
	KL_CODE,
	[Anders dan Belgische nationaliteit leerling],
	[Anders dan Belgische nationaliteit moeder],
	[Anders dan Belgische nationaliteit vader],
	[Anders dan Nederlands moedertaal],
	vluchteling,
	count(*) as [Aantal wetenschapsvakken],
	SUM(tekort) as [Aantal tekorten wetenschapsvakken]
from tabel1

group by 
	LL_NAAM, 
	LL_VOORNAAM, 
	KL_CODE, 
	[Anders dan Belgische nationaliteit leerling], 
	[Anders dan Belgische nationaliteit moeder], 
	[Anders dan Belgische nationaliteit vader], 
	[Anders dan Nederlands moedertaal], 
	Vluchteling

order by
KL_CODE, LL_NAAM, LL_VOORNAAM
