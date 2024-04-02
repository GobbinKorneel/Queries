SELECT 
	UK1.UK_SOURCE_FK AS LL_ID, 
	t2.max_login AS [Laatste login],
	DATEDIFF(DAY, t2.max_login, GETDATE()) AS [Aantal dagen geleden],
	CASE 
		WHEN UK1.UK_ROL = 1 THEN 'Vader'
		WHEN UK1.UK_ROL = 2 THEN 'Moeder'
		WHEN UK1.UK_ROL = 3 THEN 'Voogd'
		WHEN UK1.UK_ROL = 4 THEN 'Pluspapa'
		WHEN UK1.UK_ROL = 5 THEN 'Plusmama'
		WHEN UK1.UK_ROL = 6 THEN 'Grootvader'
		WHEN UK1.UK_ROL = 7 THEN 'Grootmoeder'
		WHEN UK1.UK_ROL = 8 THEN 'Ander persoon'
		ELSE 'Niemand'
	END AS [Wie laatst ingelogd]

FROM Users U1 
left join UserKoppelingen UK1 ON U1.ID = UK1.UK_USER_FK
inner join (		
		SELECT 
			MAX(U2.U_LAATSTELOGIN) AS max_login, 
			UK2.UK_SOURCE_FK
		
		FROM Users U2
		left join UserKoppelingen UK2 on U2.Id = UK2.UK_USER_FK
		
		GROUP BY UK2.UK_SOURCE_FK			
		) t2 on t2.max_login = U1.U_LAATSTELOGIN and t2.UK_SOURCE_FK = UK1.UK_SOURCE_FK



-- de binnenste select heeft per LL_ID (UK_SOURCE_FK) de laatste login weer.
-- Daarna wordt per LL_ID het tijdstip van de laatste login, het verschil in dagen ten opzichte van vandaag en wie ingelogd heeft weergegegeven