WITH Adressen AS (
	SELECT 
		LA.LA_LEERLING_FK as LL_ID, 		
		count(*) as [Verschillende adressen],
		MAX(IIF(LA.LA_TYPEADRES_FKP = 994, LA.LA_GEMEENTE_FK, NULL)) as [Officieel adres]
		
	FROM LeerlingAdressen LA

	GROUP BY LA.LA_LEERLING_FK
)

SELECT
	AD.LL_ID,
	AD.[Verschillende adressen],
	GM.GM_DEELGEMEENTE AS [Deelgemeente officieel adres],
	GM.GM_FUSIEGEMEENTE AS [Hoofdgemeente officeel adres],
	GM.GM_POSTNUMMER AS [Postcode officieel adres]	

FROM Adressen AD
left join Gemeenten GM on GM.ID = AD.[Officieel adres] 


-- Link: LL_ID
--
-- Toont het aantal adressen en de officiële woonplaats van de leerling
--
-- ERROR: Bij leerlingen die onterecht meerdere officiële woonplaatsen hebben, wordt enkel diegene weergegeven met de grootste ID van de Gemeenten

