SELECT 
	SJ.ID AS SJ_ID,
	IT.ID AS IS_ID,
	IV.ID AS IV_ID,
	COALESCE(LSD.LSD_KLASCODE, KL.KL_CODE, KL1.KL_CODE) as KL_CODE,

	PS.PS_NAAM AS [Naam Leerkracht],
	PS.PS_VOORNAAM AS [Voornaam Leerkracht],
	DP.DP_GETUIGSCHRIFT AS [Getuigschrift],
	DP_PLAATSUITREIKING AS [Plaats uitreiking],
	DP_DATUMUITGEREIKT AS [Datum Uitreiking],
	Niveau.P_OMSCHRIJVING AS [Niveau]

FROM Lesverdelingen LT
left join Lesverdelingdetails LTD ON LT.ID = LTD.LTD_LESVERDELING_FK
left join Schooljaren SJ ON SJ.ID = LT.LT_SCHOOLJAAR_FK
left join Instellingen IT ON IT.ID = LT.LT_INSTELLING_FK
left join IngVakken IV ON IV.ID = LTD.LTD_VAK_FK
left join Personeel PS ON PS.ID = LTD.LTD_PERSONEEL_FK
left join PersoneelDiplomas DP ON PS.ID = DP.DP_PERSONEEL_FK
left join ParmTabs Niveau ON Niveau.ID = DP.DP_NIVEAU_FKP

-- LTD_GROEPTYPE
-- 0: klas
-- 1: ?
-- 2: Leseenheden --> een klas wordt gesplitst in meerdere leseenheden
-- 3: Lesgroepen  --> 2 klassen worden samengezet en vormen een klasgroep
--
-- Onderstaande zorgt dat we terug de klas kunnen distilleren

left join Lesgroepen LG on LTD.LTD_GROEPTYPE = 3 AND LG.ID = LTD.LTD_GROEP_FK 
left join Lesgroepdetails LSD on LTD.LTD_GROEPTYPE = 3 AND LG.ID = LSD.LSD_LESGROEP_FK
left join Klassen KL on LTD.LTD_GROEPTYPE = 0 AND KL.ID = LTD.LTD_GROEP_FK
left join Leseenheden LE on LTD.LTD_GROEPTYPE = 2 AND LE.ID = LTD.LTD_GROEP_FK
left join Klassen KL1 on LTD.LTD_GROEPTYPE = 2 AND KL1.ID = LE.LE_KLAS_FK 


-- Link: KL_CODE, SJ_ID, IV_ID, IS_ID
--
-- Toont de vakken, leerkrachten toegewezen aan dat vak, diploma's van de leerkrachten en andere informatie
--
-- LET OP: Er zijn voor sommige vakken meerdere leerkrachten toegewezen aan één vak. Dit kan zorgen dat bij joinen een vak meerdere keren wordt weergegeven.
-- LET OP: Er zijn voor sommige leerkrachten meerdere diploma's. Dit kan zorgen dat bij joinen een vak meerdere keren wordt weergegeven.