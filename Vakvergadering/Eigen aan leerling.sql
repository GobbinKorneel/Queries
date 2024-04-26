WITH [Laatste leerlingkenmerken] AS (

	SELECT      L1.ID, L1.LLK_LEERLING_FK, 
				L1.LLK_SCHOOL_FK, 
				L1.LLK_FORMULIERDATUM, 
				L1.isMoederNederlandsSet, 
				L1.isMoederFransSet, 
				L1.isMoederAndersSet, 
				L1.isMoederKanNietAntwoordenSet, 
				L1.isVaderNederlandsSet, 
				L1.isVaderFransSet, 
				L1.isVaderAndersSet, 
				L1.isVaderKanNietAntwoordenSet, 
				L1.isSiblingNederlandsSet, 
				L1.isSiblingFransSet, 
				L1.isSiblingAndersSet, 
				L1.isSiblingKanNietAntwoordenSet, 
				L1.isVriendenNederlandsSet, 
				L1.isVriendenFransSet, 
				L1.isVriendenAndersSet, 
				L1.isVriendenKanNietAntwoordenSet, 
				L1.isMoederNietLaagOnderwijsSet, 
				L1.isMoederLaagOnderwijsSet, 
				L1.isMoederMiddelbaarOnderwijsSet, 
				L1.isMoederHogerMiddelbaarOnderwijsSet,
				L1.isMoederHogerOnderwijsSet, 
				L1.isAfkomstigUitDiscimusSet, 
				L1.isSchooltoelageSet, 
				L1.isOpleidingsniveauMoederLaagSet, 
				L1.isTaalVanLeerlingNietNederlandsSet, 
				L1.isAltijdSet, 
				L1.VERANDERDOP, 
				L1.VERANDERDDOOR, 
				L1.DeletedOp

	FROM        dbo.Leerlingkenmerken AS L1 
	INNER JOIN (
		SELECT		LLK_LEERLING_FK, 
					MAX(LLK_FORMULIERDATUM) AS [LAATSTE Formulierdatum]

		FROM        dbo.Leerlingkenmerken AS Leerlingkenmerken_1

		GROUP BY	LLK_LEERLING_FK) AS L2 ON L1.LLK_LEERLING_FK = L2.LLK_LEERLING_FK AND L1.LLK_FORMULIERDATUM = L2.[LAATSTE Formulierdatum]
)

	SELECT		dbo.Leerlingen.ID AS LL_ID, 
				dbo.Leerlingen.LL_GEBOORTEDATUM AS Geboortedatum, 
				dbo.Leerlingen.LL_GESLACHT AS Geslacht, 
				herkomst.P_OMSCHRIJVING AS Herkomst, 
				IIF(herkomst.P_OMSCHRIJVING like '%autochtoon%', 1, 0) as [Autochtoon],
				dbo.Nationaliteiten.NA_OMSCHRIJVING AS Nationaliteit, 
				IIF(dbo.Nationaliteiten.NA_OMSCHRIJVING = 'Belgische', 1, 0) as [Leerling Belgische nationaliteit],
				Thuistaal.P_OMSCHRIJVING AS Thuistaal, 
				Moedertaal.P_OMSCHRIJVING AS Moedertaal, 
				BeroepMoeder.P_OMSCHRIJVING AS [Beroep moeder], 
				BeroepVader.P_OMSCHRIJVING AS [Beroep vader], 
				OpleidingMoeder.P_OMSCHRIJVING AS [Opleiding moeder], 
				MoederBurgelijkeStaat.P_OMSCHRIJVING AS [Burgelijke staat moeder], 
                VaderBurgelijkeStaat.P_OMSCHRIJVING AS [Burgelijke staat vader], 
				dbo.Leerlingen.LL_MOEDEROVERLEDEN AS [Moeder overleden], 
				dbo.Leerlingen.LL_VADEROVERLEDEN AS [Vader overleden], 
				MoederNationaliteit.NA_OMSCHRIJVING AS [Nationaliteit moeder], 
				IIF(Moedernationaliteit.NA_OMSCHRIJVING = 'Belgische', 1, 0) as [Moeder Belgische nationaliteit],

				VaderNationaliteit.NA_OMSCHRIJVING AS [Nationaliteit vader], 
				IIF(VaderNationaliteit.NA_OMSCHRIJVING = 'Belgische', 1, 0) as [Vader Belgische nationaliteit],

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


     FROM       dbo.Leerlingen 
				LEFT OUTER JOIN dbo.ParmTabs AS herkomst ON herkomst.ID = dbo.Leerlingen.LL_HERKOMST_FKP 
				LEFT OUTER JOIN dbo.Nationaliteiten ON dbo.Nationaliteiten.ID = dbo.Leerlingen.LL_NATIONALITEIT_FK 
				LEFT OUTER JOIN dbo.ParmTabs AS Thuistaal ON Thuistaal.ID = dbo.Leerlingen.LL_THUISTAAL_FKP 
				LEFT OUTER JOIN dbo.ParmTabs AS Moedertaal ON Moedertaal.ID = dbo.Leerlingen.LL_MOEDERTAAL_FKP 
				LEFT OUTER JOIN dbo.ParmTabs AS BeroepMoeder ON BeroepMoeder.ID = dbo.Leerlingen.LL_MOEDERBEROEP_FKP 
				LEFT OUTER JOIN dbo.ParmTabs AS BeroepVader ON BeroepVader.ID = dbo.Leerlingen.LL_VADERBEROEP_FKP 
				LEFT OUTER JOIN dbo.ParmTabs AS OpleidingMoeder ON OpleidingMoeder.ID = dbo.Leerlingen.LL_MOEDEROPLEIDING_FKP 
				LEFT OUTER JOIN dbo.ParmTabs AS MoederBurgelijkeStaat ON MoederBurgelijkeStaat.ID = dbo.Leerlingen.LL_MOEDERBURGERLIJKESTAAT_FKP 
				LEFT OUTER JOIN dbo.ParmTabs AS VaderBurgelijkeStaat ON VaderBurgelijkeStaat.ID = dbo.Leerlingen.LL_VADERBURGERLIJKESTAAT_FKP 
				LEFT OUTER JOIN dbo.Nationaliteiten AS MoederNationaliteit ON MoederNationaliteit.ID = dbo.Leerlingen.LL_MOEDERNATIONALITEIT_FK 
				LEFT OUTER JOIN dbo.Nationaliteiten AS VaderNationaliteit ON VaderNationaliteit.ID = dbo.Leerlingen.LL_VADERNATIONALITEIT_FK 
				LEFT OUTER JOIN [Laatste leerlingkenmerken] AS Leerlingkenmerken ON dbo.Leerlingen.ID = Leerlingkenmerken.LLK_LEERLING_FK
     WHERE (
				dbo.Leerlingen.ID IN (
				
				SELECT        LL_ID
				FROM          dbo.[SJI - Vertrekpunt]
				)
			)