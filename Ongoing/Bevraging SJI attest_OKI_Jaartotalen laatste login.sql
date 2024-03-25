use WiseZonderFK;


with tijdelijk as (
SELECT 
	UK1.UK_SOURCE_FK, 
	t2.max_login as [Laatste login],
	datediff(day, t2.max_login, GETDATE()) as [Aantal dagen geleden],
	case 
		when uk1.UK_ROL = 1  then 'Vader'
		when uk1.UK_ROL = 2 then 'Moeder'
		when uk1.UK_ROL = 3 then 'Voogd'
		when uk1.UK_ROL = 4 then 'Pluspapa'
		when uk1.UK_ROL = 5 then 'Plusmama'
		when uk1.UK_ROL = 6 then 'Grootvader'
		when uk1.UK_ROL = 7 then 'Grootmoeder'
		when uk1.UK_ROL = 8 then 'Ander persoon'
		else 'Niemand'
	end as [Wie laatst ingelogd]
from Users U1 
left join UserKoppelingen UK1 on U1.Id = UK1.UK_USER_FK
inner join (
		select MAX(U2.U_LAATSTELOGIN) as max_login, UK2.UK_SOURCE_FK
		from Users U2
		left join UserKoppelingen UK2 on U2.Id = UK2.UK_USER_FK
		group by UK2.UK_SOURCE_FK	
		) t2 on t2.max_login = U1.U_LAATSTELOGIN and t2.UK_SOURCE_FK = uk1.UK_SOURCE_FK
)


select 
	Leerlingen.ID as LL_ID,
	CONVERT(BINARY(64), hashbytes('SHA2_512', CONCAT(Leerlingen.ID, '|', Leerlingen.LL_NAAM, '|', Leerlingen.LL_Voornaam, ''))) as hashID,
	LB_VAN as [Loopbaan van],
	LB_TOT as [Loopbaan tot],
	IU_DATUMUITSCHRIJVING as [Datum uitschrijving],
	LL_NAAM,				-- moet weg
	LL_VOORNAAM,			-- moet weg
	--LL_GOK, 
	KL_OMSCHRIJVING as Klas,
	SJ_OMSCHRIJVINGKORT as Schooljaar,
	leerjaar.P_OMSCHRIJVING as Leerjaar,
	graad.P_OMSCHRIJVING as Graad,
	LL_GESLACHT AS Geslacht,
	herkomst.P_OMSCHRIJVING as Herkomst,
	Nationaliteiten.NA_OMSCHRIJVING as Nationaliteit,
	Thuistaal.P_OMSCHRIJVING as Thuistaal,
	Moedertaal.P_OMSCHRIJVING as Moedertaal,
	BeroepMoeder.P_OMSCHRIJVING as [Beroep moeder],
	BeroepVader.P_OMSCHRIJVING as [Beroep vader],
	OpleidingMoeder.P_OMSCHRIJVING as [Opleiding moeder],
	MoederBurgelijkeStaat.P_OMSCHRIJVING as [Burgelijke staat moeder],
	VaderBurgelijkeStaat.P_OMSCHRIJVING as [Burgelijke staat vader],
	LL_MOEDEROVERLEDEN as [Moeder overleden],
	LL_VADEROVERLEDEN as [Vader overleden],
	MoederNationaliteit.NA_OMSCHRIJVING as [Nationaliteit moeder],
	VaderNationaliteit.Na_OMSCHRIJVING as [Nationaliteit vader],
	LB_ANDERSTALIGENIEUWKOMER as [Andertalige nieuwkomer],
	
	Attesten.AT_NAAMOFFICIEEL as [Attest],

	IIF(AT_NAAMOFFICIEEL = 'Oriënteringsattest C' AND Month(LB_TOT) <> 6, 'Wijziging studierichting', Attesten.AT_NAAMOFFICIEEL) as [Attest aangepast], 


	Getuigschriften.GT_CLAUSULERING as [Clausulering], 
	Getuigschriften.GT_DATUMUITGEREIKT as [Datum uitreiking],
	BasisonderwijsNL.P_OMSCHRIJVING as [Basisonderwijs NL],
	--GetuigschriftBB.P_OMSCHRIJVING as [Getuigschrift Bedrijfsbeheer?],
	Leerlingkenmerken.isMoederNederlandsSet as [Moeder - Nederlandstalig],
	Leerlingkenmerken.isMoederFransSet as [Moeder - Franstalig],
	Leerlingkenmerken.isMoederAndersSet as [Moeder - Anderstalig (niet N/F)],
	Leerlingkenmerken.isMoederKanNietAntwoordenSet as [Moeder - Geen info over taal],
	Leerlingkenmerken.isVaderNederlandsSet as [Vader - Nederlandstalig],
	Leerlingkenmerken.isVaderFransSet as [Vader - Franstalig],
	Leerlingkenmerken.isVaderAndersSet as [Vader - Anderstalig (niet N/F)],
	Leerlingkenmerken.isVaderKanNietAntwoordenSet as [Vader - Geen info over taal],
	Leerlingkenmerken.isSiblingNederlandsSet as [Broer/zus - Nederlandstalig],
	Leerlingkenmerken.isSiblingFransSet as [Broer/zus - Franstalig],
	Leerlingkenmerken.isSiblingAndersSet as [Broer/zus - Anderstalig (niet N/F)],
	Leerlingkenmerken.isSiblingKanNietAntwoordenSet as [Broer/zus - Geen info over taal],
	Leerlingkenmerken.isVriendenNederlandsSet as [Vrienden - Nederlandstalig],
	Leerlingkenmerken.isVriendenFransSet as [Vrienden - Franstalig],
	Leerlingkenmerken.isVriendenAndersSet as [Vrienden - Anderstalig (niet N/F)],
	Leerlingkenmerken.isVriendenKanNietAntwoordenSet as [Vrienden - Geen info over taal],
	Leerlingkenmerken.isMoederNietLaagOnderwijsSet as [Moeder - Lager onderwijs niet afgewerkt],
	Leerlingkenmerken.isMoederLaagOnderwijsSet as [Moeder - Lager onderwijs afgewerkt],
	Leerlingkenmerken.isMoederMiddelbaarOnderwijsSet as [Moeder - Lager secundair onderwijs afgewerkt],
	Leerlingkenmerken.isMoederHogerMiddelbaarOnderwijsSet as [Moeder - Hoger secundair onderwijs afgewerkt],
	Leerlingkenmerken.isMoederHogerOnderwijsSet as [Moeder - Hoger onderwijs afgewerkt],
	Leerlingkenmerken.isOpleidingsniveauMoederLaagSet as [Moeder - Laag geschoold],
	Leerlingkenmerken.isSchooltoelageSet as [Ontving ooit schooltoelage],
	Leerlingkenmerken.isTaalVanLeerlingNietNederlandsSet as [Thuistaal niet-Nederlands],


	--BeoordelingWaardes.ID as [ID Beoordelingswaarde],
	--BeoordelingBerekeningen.BB_CODE as [Code beoordelingsberekening],
	--BeoordelingBerekeningen.BB_OMSCHRIJVING as [Omschrijving beoordelingsberekening],
	ROUND(BeoordelingWaardes.BW_NUMERIEK * 100, 2) as Procent,
	--Puntenbladen.PL_NAAM as [Puntenblad],
	IngVakken.IV_NAAMGEBRUIKER as Vak,
	wat.P_OMSCHRIJVING as [Omschrijving berekening],
	Instellingen.IS_NAAMGEBRUIKER as Instelling,
	--Evaluatieverwijzingen.EV_TYPE as [Evaluatiesoort],
	case 
		when Evaluatieverwijzingen.EV_TYPE = 1 then 'Jaarevaluatie'
		when Evaluatieverwijzingen.EV_TYPE = 2 then 'Periode evaluatie'
		when Evaluatieverwijzingen.EV_TYPE = 3 then 'Dagelijks werk'
		when Evaluatieverwijzingen.EV_TYPE = 4 then 'Examen'
	End as [Type evaluatie],
	--COALESCE(Examens.EX_CODE, Dagelijkswerken.DR_CODE) as [Code],
	--coalesce(Examens.EX_OMSCHRIJVING, Dagelijkswerken.DR_OMSCHRIJVING) as Omschrijving,
	--coalesce(PeriodeEvaluaties.PEV_CODE, PE2.PEV_CODE, pe3.PEV_CODE) as [Code periode],
	--coalesce(PeriodeEvaluaties.PEV_OMSCHRIJVING, pe2.PEV_OMSCHRIJVING, pe3.PEV_OMSCHRIJVING) as [Omschrijving periode],
	Jaarevaluaties.JE_AANTALPERIODES as [Aantal periodes],
	--PeriodeEvaluaties.PEV_AANTALDW as [Aantal DW],
	--PeriodeEvaluaties.PEV_AANTALEX as [Aantal EX],
	--BB_TYPE_FKP
	tijdelijk.[Laatste login],
	tijdelijk.[Aantal dagen geleden],
	tijdelijk.[Wie laatst ingelogd]
	





from Leerlingen
left join InUit on IU_LEERLING_FK = Leerlingen.ID
left join Loopbanen on LB_INUIT_FK = InUit.ID
left join Scholen on Scholen.Id = IU_SCHOOL_FK
left join Klasgroepen on Klasgroepen.ID = LB_KLASGROEP_FK
left join Klassen on Klassen.ID = KG_KLAS_FK
left join Schooljaren on Schooljaren.ID = Klassen.KL_SCHOOLJAAR_FK
left join ParmTabs leerjaar on leerjaar.ID = LB_LEERJAAR_FKP
left join ParmTabs graad on graad.ID = LB_GRAAD_FKP
left join ParmTabs herkomst on herkomst.ID = LL_HERKOMST_FKP
left join Nationaliteiten on Nationaliteiten.ID = LL_NATIONALITEIT_FK
left join ParmTabs Thuistaal on Thuistaal.ID = LL_THUISTAAL_FKP
left join ParmTabs Moedertaal on Moedertaal.ID = LL_MOEDERTAAL_FKP
left join ParmTabs BeroepMoeder on BeroepMoeder.ID = LL_MOEDERBEROEP_FKP
left join ParmTabs BeroepVader on BeroepVader.ID = LL_VADERBEROEP_FKP
left join ParmTabs OpleidingMoeder on OpleidingMoeder.ID = LL_MOEDEROPLEIDING_FKP
left join ParmTabs MoederBurgelijkeStaat on MoederBurgelijkeStaat.ID = LL_MOEDERBURGERLIJKESTAAT_FKP
left join ParmTabs VaderBurgelijkeStaat on VaderBurgelijkeStaat.ID = LL_VADERBURGERLIJKESTAAT_FKP
left join Nationaliteiten MoederNationaliteit on MoederNationaliteit.ID = LL_MOEDERNATIONALITEIT_FK
left join Nationaliteiten VaderNationaliteit on VaderNationaliteit.ID = LL_VADERNATIONALITEIT_FK
left join ParmTabs BasisonderwijsNL on BasisonderwijsNL.ID = LB_BASISONDERWIJSNL_FKP
left join ParmTabs GetuigschriftBB on GetuigschriftBB.ID = LB_GETUIGSCHRIFTBB_FKP
left join Leerlingkenmerken on Leerlingen.ID = Leerlingkenmerken.LLK_LEERLING_FK
left join Getuigschriften on Loopbanen.ID = GT_LOOPBAAN_FK
left join Attesten on Attesten.ID = GT_ATTEST_FK


left join BeoordelingWaardes on Loopbanen.ID = BeoordelingWaardes.BW_LOOPBAAN_FK
left join Beoordelingen on Beoordelingen.ID = BeoordelingWaardes.BW_BEOORDELING_FK
left join BeoordelingBerekeningen on BeoordelingBerekeningen.ID = Beoordelingen.BO_BEOORDELINGBEREKENING_FK
left join Puntenbladen on Puntenbladen.ID = BeoordelingBerekeningen.BB_PUNTENBLAD_FK and Schooljaren.ID = Puntenbladen.PL_SCHOOLJAAR_FK
left join IngVakken on IngVakken.ID = Puntenbladen.PL_INGVAK_FK
left join ParmTabs wat on wat.ID = BeoordelingBerekeningen.BB_TYPE_FKP
left join Instellingen on Instellingen.ID = IngVakken.IV_INSTELLING_FK


left join Evaluatieverwijzingen on Evaluatieverwijzingen.ID = BeoordelingBerekeningen.BB_EVALUATIEVERWIJZING_FK
left join Jaarevaluaties on Jaarevaluaties.ID = Evaluatieverwijzingen.EV_JAAREVALUATIE_FK and Evaluatieverwijzingen.EV_TYPE = 1
left join PeriodeEvaluaties on PeriodeEvaluaties.id = Evaluatieverwijzingen.EV_PERIODEEVALUATIE_FK and Evaluatieverwijzingen.EV_TYPE = 2
left join Dagelijkswerken on Dagelijkswerken.ID = Evaluatieverwijzingen.EV_DAGELIJKSWERK_FK and Evaluatieverwijzingen.EV_TYPE = 3
left join Examens on Examens.id = Evaluatieverwijzingen.EV_EXAMEN_FK and Evaluatieverwijzingen.EV_TYPE = 4
left join PeriodeEvaluaties pe2 on pe2.ID = Examens.EX_PERIODEEVALUATIE_FK  
left join PeriodeEvaluaties pe3 on pe3.ID = Dagelijkswerken.DR_PERIODEEVALUATIE_FK  
left join tijdelijk on tijdelijk.UK_SOURCE_FK = Leerlingen.ID





where Scholen.SC_INSTELLINGSNUMMER = '035584' 
and Leerlingkenmerken.isAltijdSet is not null
and Attesten.AT_HOOFDATTEST = 1
and BO_TYPE = 2 -- zorgt ervoor dat de toetsen/taken niet weergegeven worden
and BB_TYPE_FKP <> 15237  -- zorgt ervoor dat de deelresultaten niet weergegeven worden
and Evaluatieverwijzingen.EV_TYPE = 1 -- zorgt ervoor dat enkel jaartotalen zichtbaar zijn

--and ll_naam = 'Roobroeck'


order by LL_NAAM, LL_VOORNAAM, [Datum uitreiking]


--SJI 035527
--VTI 035584


-- graad
-- richting
-- finaliteit
-- schoolse achterstand
-- punten van vakken
-- afwezigenheden (gewoon, problematisch)
-- laatkomers
-- zij-instromers, en vanuit welke school
-- klaswijziging, en vanuit welke klas
-- leerkrachten
-- diploma leerkrachten
-- welke leerkracht
-- lagere school





-- internaat
-- zij-instromer
-- hoeveel adressen




