With [Laatste leerlingkenmerken] AS
(
	SELECT L1.*
	FROM Leerlingkenmerken AS L1
	INNER JOIN (
		SELECT LLK_LEERLING_FK, MAX(LLK_formulierdatum) AS [LAATSTE Formulierdatum]
		FROM Leerlingkenmerken
		GROUP BY LLK_LEERLING_FK
	) AS L2 ON L1.LLK_LEERLING_FK = L2.LLK_LEERLING_FK AND L1.LLK_formulierdatum = L2.[LAATSTE Formulierdatum]
)

-- Soms zijn er bij een leerling meerdere records voor de leerlingkenmerken. Daarom wordt hier de laatste weergegeven.


SELECT 
	Leerlingen.ID AS LL_ID,

	CONVERT(BINARY(64), hashbytes('SHA2_512', CONCAT(Leerlingen.ID, '|', Leerlingen.LL_NAAM, '|', Leerlingen.LL_Voornaam, ''))) AS hashID,

	LL_GEBOORTEDATUM AS Geboortedatum,
	LL_GESLACHT AS Geslacht,
	herkomst.P_OMSCHRIJVING AS Herkomst,
	Nationaliteiten.NA_OMSCHRIJVING AS Nationaliteit,
	Thuistaal.P_OMSCHRIJVING AS Thuistaal,
	Moedertaal.P_OMSCHRIJVING AS Moedertaal,
	BeroepMoeder.P_OMSCHRIJVING AS [Beroep moeder],
	BeroepVader.P_OMSCHRIJVING AS [Beroep vader],
	OpleidingMoeder.P_OMSCHRIJVING AS [Opleiding moeder],
	MoederBurgelijkeStaat.P_OMSCHRIJVING AS [Burgelijke staat moeder],
	VaderBurgelijkeStaat.P_OMSCHRIJVING AS [Burgelijke staat vader],
	LL_MOEDEROVERLEDEN AS [Moeder overleden],
	LL_VADEROVERLEDEN AS [Vader overleden],
	MoederNationaliteit.NA_OMSCHRIJVING AS [Nationaliteit moeder],
	VaderNationaliteit.Na_OMSCHRIJVING AS [Nationaliteit vader],
	
	Leerlingkenmerken.isMoederNederlandsSet AS [Moeder - Nederlandstalig],
	Leerlingkenmerken.isMoederFransSet AS [Moeder - Franstalig],
	Leerlingkenmerken.isMoederAndersSet AS [Moeder - Anderstalig (niet N/F)],
	Leerlingkenmerken.isMoederKanNietAntwoordenSet AS [Moeder - Geen info over taal],
	Leerlingkenmerken.isVaderNederlandsSet AS [Vader - Nederlandstalig],
	Leerlingkenmerken.isVaderFransSet AS [Vader - Franstalig],
	Leerlingkenmerken.isVaderAndersSet AS [Vader - Anderstalig (niet N/F)],
	Leerlingkenmerken.isVaderKanNietAntwoordenSet AS [Vader - Geen info over taal],
	Leerlingkenmerken.isSiblingNederlandsSet AS [Broer/zus - Nederlandstalig],
	Leerlingkenmerken.isSiblingFransSet AS [Broer/zus - Franstalig],
	Leerlingkenmerken.isSiblingAndersSet AS [Broer/zus - Anderstalig (niet N/F)],
	Leerlingkenmerken.isSiblingKanNietAntwoordenSet AS [Broer/zus - Geen info over taal],
	Leerlingkenmerken.isVriendenNederlandsSet AS [Vrienden - Nederlandstalig],
	Leerlingkenmerken.isVriendenFransSet AS [Vrienden - Franstalig],
	Leerlingkenmerken.isVriendenAndersSet AS [Vrienden - Anderstalig (niet N/F)],
	Leerlingkenmerken.isVriendenKanNietAntwoordenSet AS [Vrienden - Geen info over taal],
	Leerlingkenmerken.isMoederNietLaagOnderwijsSet AS [Moeder - Lager onderwijs niet afgewerkt],
	Leerlingkenmerken.isMoederLaagOnderwijsSet AS [Moeder - Lager onderwijs afgewerkt],
	Leerlingkenmerken.isMoederMiddelbaarOnderwijsSet AS [Moeder - Lager secundair onderwijs afgewerkt],
	Leerlingkenmerken.isMoederHogerMiddelbaarOnderwijsSet AS [Moeder - Hoger secundair onderwijs afgewerkt],
	Leerlingkenmerken.isMoederHogerOnderwijsSet AS [Moeder - Hoger onderwijs afgewerkt],
	Leerlingkenmerken.isOpleidingsniveauMoederLaagSet AS [Moeder - Laag geschoold],
	Leerlingkenmerken.isSchooltoelageSet AS [Ontving ooit schooltoelage],
	Leerlingkenmerken.isTaalVanLeerlingNietNederlandsSet AS [Thuistaal niet-Nederlands]
		   
FROM Leerlingen
left join ParmTabs herkomst ON herkomst.ID = LL_HERKOMST_FKP
left join Nationaliteiten ON Nationaliteiten.ID = LL_NATIONALITEIT_FK
left join ParmTabs Thuistaal ON Thuistaal.ID = LL_THUISTAAL_FKP
left join ParmTabs Moedertaal ON Moedertaal.ID = LL_MOEDERTAAL_FKP
left join ParmTabs BeroepMoeder ON BeroepMoeder.ID = LL_MOEDERBEROEP_FKP
left join ParmTabs BeroepVader ON BeroepVader.ID = LL_VADERBEROEP_FKP
left join ParmTabs OpleidingMoeder ON OpleidingMoeder.ID = LL_MOEDEROPLEIDING_FKP
left join ParmTabs MoederBurgelijkeStaat ON MoederBurgelijkeStaat.ID = LL_MOEDERBURGERLIJKESTAAT_FKP
left join ParmTabs VaderBurgelijkeStaat ON VaderBurgelijkeStaat.ID = LL_VADERBURGERLIJKESTAAT_FKP
left join Nationaliteiten MoederNationaliteit ON MoederNationaliteit.ID = LL_MOEDERNATIONALITEIT_FK
left join Nationaliteiten VaderNationaliteit ON VaderNationaliteit.ID = LL_VADERNATIONALITEIT_FK
left join [Laatste leerlingkenmerken] Leerlingkenmerken ON Leerlingen.ID = Leerlingkenmerken.LLK_LEERLING_FK
