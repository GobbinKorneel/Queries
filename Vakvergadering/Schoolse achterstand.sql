SELECT
	LB.ID AS LB_ID,
	Leerjaar.P_OMSCHRIJVING as LeerjaarTekst,
	LB.LB_LEERJAAR_FKP - 56 as LeerjaarCijfer,
	
	-- In onderstaande wordt het jaar van de geboortedatum afgetrokken van het jaar van het begin van het schooljaar.
	-- Wanneer iemand 12 wordt, dan zal hij in september van dat jaar normaal starten in het eerste jaar.
	-- De leerjaren zitten als een FKP in de loopbaan. Het eerste jaar wordt voorgesteld als 57. 

	IIF(LB_LEERJAAR_FKP = 56, NULL,
		CASE
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 21 THEN 10-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 20 THEN 9-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 19 THEN 8-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 18 THEN 7-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 17 THEN 6-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 16 THEN 5-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 15 THEN 4-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 14 THEN 3-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 13 THEN 2-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 12 THEN 1-(LB.LB_LEERJAAR_FKP - 56)
			WHEN DATEPART(year, SJ.SJ_GELDIGVAN) - DATEPART(year, LL.LL_GEBOORTEDATUM) = 11 THEN 0-(LB.LB_LEERJAAR_FKP - 56)
		END 
	)AS [Schoolse achterstand]


FROM INUIT IU
left join Loopbanen LB ON IU.ID = LB.LB_INUIT_FK
left join Leerlingen LL ON LL.ID = IU.IU_LEERLING_FK
left join Klasgroepen KG ON KG.ID = LB.LB_KLASGROEP_FK
left join Klassen KL ON KL.ID = KG.KG_KLAS_FK
inner join Schooljaren SJ ON SJ.ID = KL.KL_SCHOOLJAAR_FK  -- Soms is er geen link met een schooljaar, waardoor bovenstande case niet werkt
left join ParmTabs Leerjaar ON Leerjaar.ID = LB.LB_LEERJAAR_FKP

where lb.LB_LEERJAAR_FKP <> 56 --> 56 staat voor een leerjaar dat niet gekend is.


-- Link: LB_ID
-- Geeft de schoolse achter- of voorstand terug in jaren en het huidige leerjaar in text en cijfer.