use WiseZonderFK;

DECLARE @StartDate DATE = '2020-01-01', @EndDate DATE = '2024-12-31';

WITH Calendar AS (
    SELECT @StartDate AS TheDate
    UNION ALL
    SELECT DATEADD(DAY, 1, TheDate) FROM Calendar WHERE TheDate < @EndDate
),

tussenresultaat as(
	SELECT 
		TheDate = CAST(CONCAT(TheDate, ' 00:00:00.000') AS DATETIME)

	FROM Calendar

	WHERE DATEPART(dw, TheDate) BETWEEN 2 AND 6

	UNION ALL

	SELECT 
		CAST(CONCAT(TheDate, ' 12:00:00.000') AS DATETIME)

	FROM Calendar

	WHERE DATEPART(dw, TheDate) BETWEEN 2 AND 6
	),

eindresultaat as(
	select 
	TheDate,
	DATEPART(dw, TheDate) as [dag van week]

	from tussenresultaat
	where (DATEPART(dw, TheDate) <> 4 or DATEPART(hour, TheDate) <> 12)
	),

datums as(
	select *
	from eindresultaat
),
tussen as (	
	SELECT 
		ll.ID as LL_ID,
		ll.LL_NAAM,
		ll.LL_VOORNAAM,		
		AC.AC_OMSCHRIJVING,
	
		
		IIF(af.AF_VANUUR = 1, DATEADD(hour,0, af.AF_VAN), DATEADD(hour,12, af.AF_VAN)) as VAN,  
		IIF(af.AF_totuur = 1, DATEADD(hour,12, af.AF_TOT), DATEADD(hour,24, af.af_TOT)) as TOT,

		AC.AC_CODE,
		sj.SJ_OMSCHRIJVINGKORT as Schooljaar

	FROM INUIT IU
	  INNER JOIN Loopbanen LB ON LB.LB_INUIT_FK = IU.ID
	  LEFT JOIN Klasgroepen KG ON KG.ID = LB.LB_KLASGROEP_FK
	  LEFT JOIN Klassen KL ON KL.ID = KG.KG_KLAS_FK
	  LEFT JOIN Schooljaren SJ ON SJ.ID = KL.KL_SCHOOLJAAR_FK
	  LEFT JOIN Afwezigheden AF ON IU.ID = AF.AF_INUIT_FK AND AF.AF_VAN >= SJ.SJ_GELDIGVAN AND AF.AF_TOT <= SJ.SJ_GELDIGTOT
	  LEFT JOIN Afwezigheidscodes AC ON AC.ID = AF.AF_CODE_FKP
	  left join Leerlingen ll on ll.id = iu.IU_LEERLING_FK

	where AC_OMSCHRIJVING is not null
	--and ll.LL_VOORNAAM = 'Dawid'
	--and ll.LL_NAAM = 'Czyrski'
),

lengte as (
select 
	tussen.LL_ID, AC_CODE, 
	Schooljaar, 	
	COUNT(*) as [Aantal halve dagen]
from tussen
left join datums on datums.TheDate >= VAN and datums.TheDate < TOT

group by LL_ID, AC_CODE, Schooljaar
),

afwe as 
(
select 
LL_ID,
Schooljaar,
  	SUM(CASE WHEN AC_CODE = '''' THEN [Aantal halve dagen] ELSE 0 END) AS ['],
	SUM(CASE WHEN AC_CODE = '-' THEN [Aantal halve dagen] ELSE 0 END) AS [-],
	SUM(CASE WHEN AC_CODE = '#' THEN [Aantal halve dagen] ELSE 0 END) AS [#],
	SUM(CASE WHEN AC_CODE = '*' THEN [Aantal halve dagen] ELSE 0 END) AS [*],
	SUM(CASE WHEN AC_CODE = '.' THEN [Aantal halve dagen] ELSE 0 END) AS [.],
	SUM(CASE WHEN AC_CODE = '?' THEN [Aantal halve dagen] ELSE 0 END) AS [?],
	SUM(CASE WHEN AC_CODE = '+' THEN [Aantal halve dagen] ELSE 0 END) AS [+],
	SUM(CASE WHEN AC_CODE = '°' THEN [Aantal halve dagen] ELSE 0 END) AS [°],
	SUM(CASE WHEN AC_CODE = '1' THEN [Aantal halve dagen] ELSE 0 END) AS [1],
	SUM(CASE WHEN AC_CODE = '2' THEN [Aantal halve dagen] ELSE 0 END) AS [2],
	SUM(CASE WHEN AC_CODE = '3' THEN [Aantal halve dagen] ELSE 0 END) AS [3],
	SUM(CASE WHEN AC_CODE = '4' THEN [Aantal halve dagen] ELSE 0 END) AS [4],
	SUM(CASE WHEN AC_CODE = '5' THEN [Aantal halve dagen] ELSE 0 END) AS [5],
	SUM(CASE WHEN AC_CODE = '6' THEN [Aantal halve dagen] ELSE 0 END) AS [6],
	SUM(CASE WHEN AC_CODE = '7' THEN [Aantal halve dagen] ELSE 0 END) AS [7],
	SUM(CASE WHEN AC_CODE = '8' THEN [Aantal halve dagen] ELSE 0 END) AS [8],
	SUM(CASE WHEN AC_CODE = '9' THEN [Aantal halve dagen] ELSE 0 END) AS [9],
	SUM(CASE WHEN AC_CODE = '0' THEN [Aantal halve dagen] ELSE 0 END) AS [0],
	SUM(CASE WHEN AC_CODE = 'A' THEN [Aantal halve dagen] ELSE 0 END) AS [A],
	SUM(CASE WHEN AC_CODE = 'B' THEN [Aantal halve dagen] ELSE 0 END) AS [B],
	SUM(CASE WHEN AC_CODE = 'C' THEN [Aantal halve dagen] ELSE 0 END) AS [C],
	SUM(CASE WHEN AC_CODE = 'D' THEN [Aantal halve dagen] ELSE 0 END) AS [D],
	SUM(CASE WHEN AC_CODE = 'E' THEN [Aantal halve dagen] ELSE 0 END) AS [E],
	SUM(CASE WHEN AC_CODE = 'F' THEN [Aantal halve dagen] ELSE 0 END) AS [F],
	SUM(CASE WHEN AC_CODE = 'G' THEN [Aantal halve dagen] ELSE 0 END) AS [G],
	SUM(CASE WHEN AC_CODE = 'H' THEN [Aantal halve dagen] ELSE 0 END) AS [H],
	SUM(CASE WHEN AC_CODE = 'I' THEN [Aantal halve dagen] ELSE 0 END) AS [I],
	SUM(CASE WHEN AC_CODE = 'J' THEN [Aantal halve dagen] ELSE 0 END) AS [J],
	SUM(CASE WHEN AC_CODE = 'K' THEN [Aantal halve dagen] ELSE 0 END) AS [K],
	SUM(CASE WHEN AC_CODE = 'L' THEN [Aantal halve dagen] ELSE 0 END) AS [L],
	SUM(CASE WHEN AC_CODE = 'M' THEN [Aantal halve dagen] ELSE 0 END) AS [M],
	SUM(CASE WHEN AC_CODE = 'N' THEN [Aantal halve dagen] ELSE 0 END) AS [N],
	SUM(CASE WHEN AC_CODE = 'O' THEN [Aantal halve dagen] ELSE 0 END) AS [O],
	SUM(CASE WHEN AC_CODE = 'P' THEN [Aantal halve dagen] ELSE 0 END) AS [P],
	SUM(CASE WHEN AC_CODE = 'Q' THEN [Aantal halve dagen] ELSE 0 END) AS [Q],
	SUM(CASE WHEN AC_CODE = 'R' THEN [Aantal halve dagen] ELSE 0 END) AS [R],
	SUM(CASE WHEN AC_CODE = 'S' THEN [Aantal halve dagen] ELSE 0 END) AS [S],
	SUM(CASE WHEN AC_CODE = 'T' THEN [Aantal halve dagen] ELSE 0 END) AS [T],
	SUM(CASE WHEN AC_CODE = 'U' THEN [Aantal halve dagen] ELSE 0 END) AS [U],
	SUM(CASE WHEN AC_CODE = 'V' THEN [Aantal halve dagen] ELSE 0 END) AS [V],
	SUM(CASE WHEN AC_CODE = 'W' THEN [Aantal halve dagen] ELSE 0 END) AS [W],
	SUM(CASE WHEN AC_CODE = 'X' THEN [Aantal halve dagen] ELSE 0 END) AS [X],
	SUM(CASE WHEN AC_CODE = 'Y' THEN [Aantal halve dagen] ELSE 0 END) AS [Y],
	SUM(CASE WHEN AC_CODE = 'Z' THEN [Aantal halve dagen] ELSE 0 END) AS [Z],
	SUM(CASE WHEN AC_CODE = 'WE' THEN [Aantal halve dagen] ELSE 0 END) AS [WE],
	SUM(CASE WHEN AC_CODE = 'VA' THEN [Aantal halve dagen] ELSE 0 END) AS [VA],
	SUM(CASE WHEN AC_CODE = 'SV' THEN [Aantal halve dagen] ELSE 0 END) AS [SV],
	SUM(CASE WHEN AC_CODE = 'ST' THEN [Aantal halve dagen] ELSE 0 END) AS [ST],
	SUM(CASE WHEN AC_CODE = 'OL' THEN [Aantal halve dagen] ELSE 0 END) AS [OL],
	SUM(CASE WHEN AC_CODE = 'KR' THEN [Aantal halve dagen] ELSE 0 END) AS [KR],
	SUM(CASE WHEN AC_CODE = 'HL' THEN [Aantal halve dagen] ELSE 0 END) AS [HL],
	SUM(CASE WHEN AC_CODE = 'H1' THEN [Aantal halve dagen] ELSE 0 END) AS [H1],
	SUM(CASE WHEN AC_CODE = 'EX' THEN [Aantal halve dagen] ELSE 0 END) AS [EX],
	SUM(CASE WHEN AC_CODE = 'WO' THEN [Aantal halve dagen] ELSE 0 END) AS [WO],
    SUM([Aantal halve dagen]) AS Totaal_aantal_halve_dagen

from lengte
group by LL_ID, Schooljaar
),


 tijdelijk as (
SELECT 
	UK1.UK_SOURCE_FK, 
	t2.max_login as [Laatste login],
	datediff(day, t2.max_login, GETDATE()) as [Aantal dagen geleden],
	case 
		when uk1.UK_ROL = 1 then 'Vader'
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
),

verder as(
select 
	Leerlingen.ID as LL_ID2,
	CONVERT(BINARY(64), hashbytes('SHA2_512', CONCAT(Leerlingen.ID, '|', Leerlingen.LL_NAAM, '|', Leerlingen.LL_Voornaam, ''))) as hashID,
	LB_VAN as [Loopbaan van],
	LB_TOT as [Loopbaan tot],
	IU_DATUMUITSCHRIJVING as [Datum uitschrijving],	
	LL_NAAM,				-- moet weg
	LL_VOORNAAM,			-- moet weg
	--LL_GOK, 
	KL_OMSCHRIJVING as Klas,
	SJ_OMSCHRIJVINGKORT as Schooljaar2,
	leerjaar.P_OMSCHRIJVING as Leerjaar,
	case 
		when leerjaar.P_OMSCHRIJVING = 'Eerste leerjaar' then 1
		when leerjaar.P_OMSCHRIJVING = 'Tweede leerjaar' then 2
		when leerjaar.P_OMSCHRIJVING = 'Derde leerjaar' then 3
		when leerjaar.P_OMSCHRIJVING = 'Vierde leerjaar' then 4
		when leerjaar.P_OMSCHRIJVING = 'Vijfde leerjaar' then 5
		when leerjaar.P_OMSCHRIJVING = 'Zesde leerjaar' then 6
		when leerjaar.P_OMSCHRIJVING = 'Zevende leerjaar' then 7
		else 0
	end as [Nummer leerjaar],		   	 
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

	IIF(AT_NAAMOFFICIEEL = 'Oriënteringsattest C' AND Month(LB_TOT) <> 6, 'Wijziging studierichting', Attesten.AT_NAAMOFFICIEEL) as [Attest aangepast],				--bijgekomen op vraag van SJI omdat voor de modernisering iemand die van klas veranderde een C-attest kreeg.


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
	tijdelijk.[Wie laatst ingelogd],
	
	ag.AG_OMSCHRIJVING as [Administratieve groep kort],
	ag.AG_OMSCHRIJVINGVOLLEDIG [Administratieve groep volledig],
	Domein.P_OMSCHRIJVING as Domein,
	Finaliteit.P_OMSCHRIJVING as Finaliteit,
	LeerjaarInGraad.P_OMSCHRIJVING as LeerjaarInGraad,
	Onderwijsvorm.P_OMSCHRIJVING as Onderwijsvorm,
	Soortleerjaar.P_OMSCHRIJVING as Soortleerjaar,
	Stemcategorie.P_OMSCHRIJVING as Stemcategorie,
	Studiegebied.P_OMSCHRIJVING as Studiegebied,
	Studierichting.P_OMSCHRIJVING as Studierichting,

	afwe.*






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

left join AdmGroepen ag on ag.ID = Loopbanen.LB_ADMGROEP_FK
left join ParmTabs Domein on ag.AG_DOMEIN_FKP = Domein.ID
left join ParmTabs Finaliteit on Ag.AG_FINALITEIT_FKP = Finaliteit.ID
left join ParmTabs LeerjaarInGraad on ag.AG_LEERJAARINGRAAD_FKP = LeerjaarInGraad.ID
left join ParmTabs Onderwijsvorm on ag.AG_ONDERWIJSVORM_FKP = Onderwijsvorm.ID
left join ParmTabs Soortleerjaar on ag.AG_SOORTLEERJAAR_FKP = Soortleerjaar.ID
left join ParmTabs Stemcategorie on ag.AG_STEMCATEGORIE_FKP = Stemcategorie.ID
left join ParmTabs Studiegebied on ag.AG_STUDIEGEBIED_FKP = Studiegebied.ID
left join ParmTabs Studierichting on ag.AG_STUDIERICHTING_FKP = Studierichting.ID

left join afwe on Leerlingen.ID = Afwe.LL_ID and Schooljaren.SJ_OMSCHRIJVINGKORT = afwe.Schooljaar





where Scholen.SC_INSTELLINGSNUMMER = '035584' 
and Leerlingkenmerken.isAltijdSet is not null
and Attesten.AT_HOOFDATTEST = 1
and BO_TYPE = 2 -- zorgt ervoor dat de toetsen/taken niet weergegeven worden
and BB_TYPE_FKP <> 15237  -- zorgt ervoor dat de deelresultaten niet weergegeven worden
and Evaluatieverwijzingen.EV_TYPE = 1 -- zorgt ervoor dat enkel jaartotalen zichtbaar zijn

--and ll_naam = 'Roobroeck'
)

select *
from verder


order by LL_NAAM, LL_VOORNAAM, [Datum uitreiking]


OPTION (MAXRECURSION 0)

--SJI 035527
--VTI 035584



-- schoolse achterstand
-- zij-instromers, en vanuit welke school
-- klaswijziging, en vanuit welke klas
-- leerkrachten
-- diploma leerkrachten
-- welke leerkracht
-- lagere school
-- internaat
-- hoeveel adressen




