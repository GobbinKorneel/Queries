WITH VL as
(
SELECT SCHOLen.ID as SC_ID,
  Scholen.SC_NAAM,
  Scholen.SC_INSTELLINGSNUMMER,
  Gemeenten.GM_DEELGEMEENTE,
  Gemeenten.GM_POSTNUMMER as GM_POSTCODE,
  Klassen.ID as KL_ID,
  Klassen.KL_OMSCHRIJVING,
  Schooljaren.SJ_OMSCHRIJVING,
  Schooljaren.SJ_GELDIGVAN,
  Schooljaren.SJ_GELDIGTOT,
  Schooljaren.ID as SJ_ID,
  leerjaar.P_OMSCHRIJVING as leerjaar,
  Leerlingen.ID as LL_ID,
  Leerlingen.LL_NAAM,
  Leerlingen.LL_VOORNAAM,
  Loopbanen.LB_VAN,
  Loopbanen.LB_TOT
from Loopbanen
  LEFT JOIN INUIT ON INUIT.ID = Loopbanen.LB_INUIT_FK
  LEFT JOIN Leerlingen ON Leerlingen.ID = INUIT.IU_LEERLING_FK
  LEFT JOIN Scholen ON Scholen.ID = INUIT.IU_SCHOOL_FK
  LEFT JOIN Klasgroepen ON Klasgroepen.ID = Loopbanen.LB_KLASGROEP_FK
  LEFT JOIN Klassen ON Klassen.ID = Klasgroepen.KG_KLAS_FK
  LEFT JOIN Schooljaren ON Schooljaren.ID = Klassen.KL_SCHOOLJAAR_FK
  LEFT JOIN ParmTabs leerjaar ON leerjaar.ID = Loopbanen.LB_LEERJAAR_FKP
  LEFT JOIN Gemeenten ON Gemeenten.ID = Scholen.SC_GEMEENTE_FK
    where Loopbanen.LB_TOT <= inuit.IU_DATUMUITSCHRIJVING   
  and (Klassen.KL_OMSCHRIJVING <> 'Internaat' or Klassen.KL_OMSCHRIJVING is null)
  and Scholen.SC_NAAM not like 'Internaat 1 Tielt' 
  and Scholen.SC_NAAM not like 'Internaat 2 Tielt'  
),


VL1 as 
(SELECT vl.SC_ID,
  vl.SC_NAAM,
  vl.SC_INSTELLINGSNUMMER,
  vl.GM_DEELGEMEENTE,
  vl.GM_POSTCODE,
  vl.KL_ID,
  vl.KL_OMSCHRIJVING,
  vl.SJ_OMSCHRIJVING,
  vl.SJ_GELDIGVAN,
  vl.SJ_GELDIGTOT,
  vl.SJ_ID,
  vl.leerjaar,
  vl.LL_ID,
  vl.LL_NAAM,
  vl.LL_VOORNAAM,
  vl.LB_VAN,
  vl.LB_TOT,
  ROW_NUMBER() over (Partition by vl.LL_ID order by vl.LB_VAN asc) as [Index],
  ROW_NUMBER() over (Partition by vl.LL_ID order by vl.LB_VAN asc) -1 as [Index - 1]
FROM VL
  ),


VL2 as (
  select 
  *,
  CONVERT(nvarchar(50),VL1.LL_ID) + '_' + CONVERT(nvarchar(50),[Index]) as [Merge],
  CONVERT(nvarchar(50),VL1.LL_ID) + '_' + CONVERT(nvarchar(50),[Index - 1]) as [Merge - 1]
  from VL1
)

select 
	huidig.SC_ID,
--	vorig.SC_ID, --

	huidig.KL_ID,
--	vorig.KL_ID, --

	huidig.SJ_ID,
--	vorig.SJ_ID, --

--	huidig.SC_NAAM as [Huidige school], --
	vorig.SC_NAAM as [Vorige school],

--	huidig.KL_OMSCHRIJVING as [Huidige klas], --
	vorig.KL_OMSCHRIJVING as [Vorige klas],

	vorig.LB_TOT as [Vorige tot],

	lagere.SC_NAAM as [Lagere school],

	lagere.leerjaar as Lager,



	iif(huidig.SJ_ID = vorig.SJ_ID and huidig.SC_ID = vorig.SC_ID, 1, 0) as [Verandering klas tijdens schooljaar],
	iif(huidig.SJ_ID = vorig.SJ_ID and (huidig.SC_ID != vorig.SC_ID or vorig.SC_ID is null), 1, 0) as [Zij-instromer school tijdens schooljaar],
	iif(huidig.SJ_ID = vorig.SJ_ID or huidig.sC_ID = vorig.SC_ID, 0, 1) as [Instroom in school bij begin schooljaar]
	


from vl2 huidig
left join vl2 vorig on huidig.[Merge - 1] = vorig.[Merge]
left join vl2 lagere on huidig.LL_ID = lagere.LL_ID and (lagere.leerjaar = 'Zesde leerjaar' or lagere.leerjaar = 'Vijfde leerjaar' or lagere.leerjaar = 'Onbekend') and lagere.[Index] = 1
