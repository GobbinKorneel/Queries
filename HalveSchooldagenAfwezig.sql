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
)

select *
from afwe

OPTION (MAXRECURSION 0)

-- Hier worden de halve dagen geteld (2 op ma, 2 op di, 1 op woe, 2 op do en 2 op vr. Let op: Vrije dagen en vakanties binnen de ziekteperiode tikken bij)