WITH LL_KL_SJ_SC_INDEX AS
(
	SELECT 
		SC.ID AS SC_ID,
		SC.SC_NAAM,
		SC.SC_INSTELLINGSNUMMER,
		GM.GM_DEELGEMEENTE,
		GM.GM_POSTNUMMER AS GM_POSTCODE,
		KL.ID AS KL_ID,
		KL.KL_OMSCHRIJVING,
		SJ.SJ_OMSCHRIJVING,
		SJ.SJ_GELDIGVAN,
		SJ.SJ_GELDIGTOT,
		SJ.ID AS SJ_ID,
		Leerjaar.P_OMSCHRIJVING as leerjaar,
		LL.ID AS LL_ID,
		LB.LB_VAN,
		LB.LB_TOT,
		ROW_NUMBER() over (Partition by LL.ID order by LB.LB_VAN asc) AS Huidig,
		ROW_NUMBER() over (Partition by LL.ID order by LB.LB_VAN asc) -1 AS Vorig

	FROM Loopbanen LB
	LEFT JOIN Inuit IU ON IU.ID = LB.LB_INUIT_FK
	LEFT JOIN Leerlingen LL ON LL.ID = IU.IU_LEERLING_FK
	LEFT JOIN Scholen SC ON SC.ID = IU.IU_SCHOOL_FK
	LEFT JOIN Klasgroepen KG ON KG.ID = LB.LB_KLASGROEP_FK
	LEFT JOIN Klassen KL ON KL.ID = KG.KG_KLAS_FK
	LEFT JOIN Schooljaren SJ ON SJ.ID = KL.KL_SCHOOLJAAR_FK
	LEFT JOIN ParmTabs Leerjaar ON Leerjaar.ID = LB.LB_LEERJAAR_FKP
	LEFT JOIN Gemeenten GM ON GM.ID = SC.SC_GEMEENTE_FK
    
	WHERE LB.LB_TOT <= IU.IU_DATUMUITSCHRIJVING   
	AND (KL.KL_OMSCHRIJVING <> 'Internaat' OR KL.KL_OMSCHRIJVING IS NULL)
	AND SC.SC_NAAM NOT LIKE '%Internaat%' 
),

LL_ID_EN_INDEX AS (
	SELECT 
		*,
		CONVERT(nvarchar(50),A.LL_ID) + '_' + CONVERT(nvarchar(50),A.[Huidig]) AS [Merge],
		CONVERT(nvarchar(50),A.LL_ID) + '_' + CONVERT(nvarchar(50),A.[Vorig]) AS [Merge - 1]
	FROM LL_KL_SJ_SC_INDEX A
)

SELECT 
	huidig.LL_ID,
	huidig.KL_ID,
	huidig.SJ_ID,
	vorig.SC_NAAM as [Vorige school],
	vorig.KL_OMSCHRIJVING as [Vorige klas],
	vorig.LB_TOT as [Vorige loopbaan tot],
	lagere.SC_NAAM as [Lagere school],
	lagere.leerjaar as [Laaste leerjaar in lagere school],
	IIF(huidig.SJ_ID = vorig.SJ_ID and huidig.SC_ID = vorig.SC_ID, 1, 0) AS [Verandering klas tijdens schooljaar],
	IIF(huidig.SJ_ID = vorig.SJ_ID and (huidig.SC_ID != vorig.SC_ID or vorig.SC_ID is null), 1, 0) AS [Zij-instromer school tijdens schooljaar],
	IIF(huidig.SJ_ID = vorig.SJ_ID or huidig.sC_ID = vorig.SC_ID, 0, 1) AS [Instroom in school bij begin schooljaar]

FROM LL_ID_EN_INDEX huidig
left join LL_ID_EN_INDEX vorig on huidig.[Merge - 1] = vorig.[Merge]
left join LL_ID_EN_INDEX lagere on huidig.LL_ID = lagere.LL_ID and (lagere.leerjaar = 'Zesde leerjaar' or lagere.leerjaar = 'Vijfde leerjaar' or lagere.leerjaar = 'Onbekend') and lagere.Huidig = 1






