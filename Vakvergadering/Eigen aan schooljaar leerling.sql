USE WiseZonderFK;

SELECT 
	Leerlingen.ID AS LL_ID,
	Loopbanen.ID AS LB_ID,
	instellingen.ID AS IS_ID,
	klassen.KL_CODE,
	klassen.ID AS KL_ID,
	schooljaren.ID AS SJ_ID,
	IngVakken.ID AS IV_ID,
	LB_VAN AS [Loopbaan van],
	LB_TOT AS [Loopbaan tot],
	IU_DATUMUITSCHRIJVING AS [Datum uitschrijving],	
	KL_OMSCHRIJVING AS Klas,
	SJ_OMSCHRIJVINGKORT AS Schooljaar,
	SJ_GELDIGVAN AS [Begin Schooljaar],
	leerjaar.P_OMSCHRIJVING AS Leerjaar,
	graad.P_OMSCHRIJVING AS Graad,
	LB_ANDERSTALIGENIEUWKOMER AS [Andertalige nieuwkomer],
	Attesten.AT_NAAMOFFICIEEL AS [Attest],

	IIF(AT_NAAMOFFICIEEL = 'Oriënteringsattest C' AND Month(LB_TOT) <> 6, 'Wijziging studierichting', Attesten.AT_NAAMOFFICIEEL) AS [Attest aangepast],				--bijgekomen op vraag van SJI omdat voor de modernisering iemand die van klas veranderde een C-attest kreeg.
	
	Getuigschriften.GT_CLAUSULERING AS [Clausulering], 
	Getuigschriften.GT_DATUMUITGEREIKT AS [Datum uitreiking],
	BasisonderwijsNL.P_OMSCHRIJVING AS [Basisonderwijs NL],
	
	ROUND(BeoordelingWaardes.BW_NUMERIEK * 100, 2) AS Procent,
	
	IngVakken.IV_NAAMGEBRUIKER AS Vak,
	wat.P_OMSCHRIJVING AS [Omschrijving berekening],
	Instellingen.IS_NAAMGEBRUIKER AS Instelling,
	
	CASE 
		WHEN Evaluatieverwijzingen.EV_TYPE = 1 THEN 'Jaarevaluatie'
		WHEN Evaluatieverwijzingen.EV_TYPE = 2 THEN 'Periode evaluatie'
		WHEN Evaluatieverwijzingen.EV_TYPE = 3 THEN 'Dagelijks werk'
		WHEN Evaluatieverwijzingen.EV_TYPE = 4 THEN 'Examen'
	END AS [Type evaluatie],
	
	Jaarevaluaties.JE_AANTALPERIODES AS [Aantal periodes],
		
	ag.AG_OMSCHRIJVING AS [Administratieve groep kort],
	ag.AG_OMSCHRIJVINGVOLLEDIG [Administratieve groep volledig],
	Domein.P_OMSCHRIJVING AS Domein,
	Finaliteit.P_OMSCHRIJVING AS Finaliteit,
	LeerjaarInGraad.P_OMSCHRIJVING AS LeerjaarInGraad,
	Onderwijsvorm.P_OMSCHRIJVING AS Onderwijsvorm,
	Soortleerjaar.P_OMSCHRIJVING AS Soortleerjaar,
	Stemcategorie.P_OMSCHRIJVING AS Stemcategorie,
	Studiegebied.P_OMSCHRIJVING AS Studiegebied,
	Studierichting.P_OMSCHRIJVING AS Studierichting

FROM Leerlingen
left join InUit ON IU_LEERLING_FK = Leerlingen.ID
left join Loopbanen ON LB_INUIT_FK = InUit.ID
left join Scholen ON Scholen.Id = IU_SCHOOL_FK
left join Klasgroepen ON Klasgroepen.ID = LB_KLASGROEP_FK
left join Klassen ON Klassen.ID = KG_KLAS_FK
left join Schooljaren ON Schooljaren.ID = Klassen.KL_SCHOOLJAAR_FK
left join ParmTabs leerjaar ON leerjaar.ID = LB_LEERJAAR_FKP
left join ParmTabs graad ON graad.ID = LB_GRAAD_FKP

left join ParmTabs BasisonderwijsNL ON BasisonderwijsNL.ID = LB_BASISONDERWIJSNL_FKP
left join Getuigschriften ON Loopbanen.ID = GT_LOOPBAAN_FK
left join Attesten ON Attesten.ID = GT_ATTEST_FK

left join BeoordelingWaardes ON Loopbanen.ID = BeoordelingWaardes.BW_LOOPBAAN_FK
left join Beoordelingen ON Beoordelingen.ID = BeoordelingWaardes.BW_BEOORDELING_FK
left join BeoordelingBerekeningen ON BeoordelingBerekeningen.ID = Beoordelingen.BO_BEOORDELINGBEREKENING_FK
left join Puntenbladen ON Puntenbladen.ID = BeoordelingBerekeningen.BB_PUNTENBLAD_FK and Schooljaren.ID = Puntenbladen.PL_SCHOOLJAAR_FK
left join IngVakken ON IngVakken.ID = Puntenbladen.PL_INGVAK_FK
left join ParmTabs wat ON wat.ID = BeoordelingBerekeningen.BB_TYPE_FKP
left join Instellingen ON Instellingen.ID = IngVakken.IV_INSTELLING_FK

left join Evaluatieverwijzingen ON Evaluatieverwijzingen.ID = BeoordelingBerekeningen.BB_EVALUATIEVERWIJZING_FK
left join Jaarevaluaties ON Jaarevaluaties.ID = Evaluatieverwijzingen.EV_JAAREVALUATIE_FK and Evaluatieverwijzingen.EV_TYPE = 1
left join PeriodeEvaluaties ON PeriodeEvaluaties.id = Evaluatieverwijzingen.EV_PERIODEEVALUATIE_FK and Evaluatieverwijzingen.EV_TYPE = 2
left join Dagelijkswerken ON Dagelijkswerken.ID = Evaluatieverwijzingen.EV_DAGELIJKSWERK_FK and Evaluatieverwijzingen.EV_TYPE = 3
left join Examens ON Examens.id = Evaluatieverwijzingen.EV_EXAMEN_FK and Evaluatieverwijzingen.EV_TYPE = 4
left join PeriodeEvaluaties pe2 ON pe2.ID = Examens.EX_PERIODEEVALUATIE_FK  
left join PeriodeEvaluaties pe3 ON pe3.ID = Dagelijkswerken.DR_PERIODEEVALUATIE_FK  

left join AdmGroepen ag ON ag.ID = Loopbanen.LB_ADMGROEP_FK
left join ParmTabs Domein ON ag.AG_DOMEIN_FKP = Domein.ID
left join ParmTabs Finaliteit ON Ag.AG_FINALITEIT_FKP = Finaliteit.ID
left join ParmTabs LeerjaarInGraad ON ag.AG_LEERJAARINGRAAD_FKP = LeerjaarInGraad.ID
left join ParmTabs Onderwijsvorm ON ag.AG_ONDERWIJSVORM_FKP = Onderwijsvorm.ID
left join ParmTabs Soortleerjaar ON ag.AG_SOORTLEERJAAR_FKP = Soortleerjaar.ID
left join ParmTabs Stemcategorie ON ag.AG_STEMCATEGORIE_FKP = Stemcategorie.ID
left join ParmTabs Studiegebied ON ag.AG_STUDIEGEBIED_FKP = Studiegebied.ID
left join ParmTabs Studierichting ON ag.AG_STUDIERICHTING_FKP = Studierichting.ID

WHERE Attesten.AT_HOOFDATTEST = 1
AND BO_TYPE = 2 -- zorgt ervoor dat de toetsen/taken niet weergegeven worden
AND BB_TYPE_FKP <> 15237  -- zorgt ervoor dat de deelresultaten niet weergegeven worden
AND Evaluatieverwijzingen.EV_TYPE = 1 -- zorgt ervoor dat enkel jaartotalen zichtbaar zijn