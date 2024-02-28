use WiseZonderFK

select Leerlingen.ID as LL_ID,

	LB_VAN,
	LB_TOT,
	IU_DATUMUITSCHRIJVING,
	LL_NAAM,
	LL_VOORNAAM,
	--LL_GOK, 
	KL_OMSCHRIJVING as Klas,
	SJ_OMSCHRIJVINGKORT as Schooljaar,
	leerjaar.P_OMSCHRIJVING as Leerjaar,
	graad.P_OMSCHRIJVING as Graad,
	LL_GESLACHT AS Geslacht,
	herkomst.P_OMSCHRIJVING as Herkomst,
	Nationaliteiten.NA_OMSCHRIJVING as Nationaliteit,
	Thuistaal.P_OMSCHRIJVING as Thuistaal,
	Moedertaal.P_OMSCHRIJVING as Moedertaal,
	BeroepMoeder.P_OMSCHRIJVING as [Beroep moeder],
	BeroepVader.P_OMSCHRIJVING as [Beroep vader],
	OpleidingMoeder.P_OMSCHRIJVING as [Opleiding moeder],
	MoederBurgelijkeStaat.P_OMSCHRIJVING as [Burgelijke staat moeder],
	VaderBurgelijkeStaat.P_OMSCHRIJVING as [Burgelijke staat vader],
	LL_MOEDEROVERLEDEN as [Moeder overleden],
	LL_VADEROVERLEDEN as [Vader overleden],
	MoederNationaliteit.NA_OMSCHRIJVING as [Nationaliteit moeder],
	VaderNationaliteit.Na_OMSCHRIJVING as [Nationaliteit vader],
	LB_ANDERSTALIGENIEUWKOMER as [Andertalige nieuwkomer],
	Attesten.AT_NAAMOFFICIEEL as [Attest],
	Getuigschriften.GT_CLAUSULERING as [Clausulering], 
	Getuigschriften.GT_DATUMUITGEREIKT as [Datum uitreiking],
	BasisonderwijsNL.P_OMSCHRIJVING as [Basisonderwijs NL],
	GetuigschriftBB.P_OMSCHRIJVING as [Getuigschrift Bedrijfsbeheer?],
	Leerlingkenmerken.isMoederNederlandsSet as [Moeder - Nederlandstalig],
	Leerlingkenmerken.isMoederFransSet as [Moeder - Franstalig],
	Leerlingkenmerken.isMoederAndersSet as [Moeder - Anderstalig (niet N/F)],
	Leerlingkenmerken.isMoederKanNietAntwoordenSet as [Moeder - Geen info over taal],
	Leerlingkenmerken.isVaderNederlandsSet as [Vader - Nederlandstalig],
	Leerlingkenmerken.isVaderFransSet as [Vader - Franstalig],
	Leerlingkenmerken.isVaderAndersSet as [Vader - Anderstalig (niet N/F)],
	Leerlingkenmerken.isVaderKanNietAntwoordenSet as [Vader - Geen info over taal],
	Leerlingkenmerken.isSiblingNederlandsSet as [Broer/zus - Nederlandstalig],
	Leerlingkenmerken.isSiblingFransSet as [Broer/zus - Franstalig],
	Leerlingkenmerken.isSiblingAndersSet as [Broer/zus - Anderstalig (niet N/F)],
	Leerlingkenmerken.isSiblingKanNietAntwoordenSet as [Broer/zus - Geen info over taal],
	Leerlingkenmerken.isVriendenNederlandsSet as [Vrienden - Nederlandstalig],
	Leerlingkenmerken.isVriendenFransSet as [Vrienden - Franstalig],
	Leerlingkenmerken.isVriendenAndersSet as [Vrienden - Anderstalig (niet N/F)],
	Leerlingkenmerken.isVriendenKanNietAntwoordenSet as [Vrienden - Geen info over taal],
	Leerlingkenmerken.isMoederNietLaagOnderwijsSet as [Moeder - Lager onderwijs niet afgewerkt],
	Leerlingkenmerken.isMoederLaagOnderwijsSet as [Moeder - Lager onderwijs afgewerkt],
	Leerlingkenmerken.isMoederMiddelbaarOnderwijsSet as [Moeder - Lager secundair onderwijs afgewerkt],
	Leerlingkenmerken.isMoederHogerMiddelbaarOnderwijsSet as [Moeder - Hoger secundair onderwijs afgewerkt],
	Leerlingkenmerken.isMoederHogerOnderwijsSet as [Moeder - Hoger onderwijs afgewerkt],
	Leerlingkenmerken.isOpleidingsniveauMoederLaagSet as [Moeder - Laag geschoold],
	Leerlingkenmerken.isSchooltoelageSet as [Ontving ooit schooltoelage],
	Leerlingkenmerken.isTaalVanLeerlingNietNederlandsSet as [Thuistaal niet-Nederlands]
	
	





from Leerlingen
left join InUit on IU_LEERLING_FK = Leerlingen.ID
left join Loopbanen on LB_INUIT_FK = InUit.ID
left join Scholen on Scholen.Id = IU_SCHOOL_FK
left join Klasgroepen on Klasgroepen.ID = LB_KLASGROEP_FK
left join Klassen on Klassen.ID = KG_KLAS_FK
left join Schooljaren on Schooljaren.ID = Klassen.KL_SCHOOLJAAR_FK
left join ParmTabs leerjaar on leerjaar.ID = LB_LEERJAAR_FKP
left join ParmTabs graad on graad.ID = LB_GRAAD_FKP
left join ParmTabs herkomst on herkomst.ID = LL_HERKOMST_FKP
left join Nationaliteiten on Nationaliteiten.ID = LL_NATIONALITEIT_FK
left join ParmTabs Thuistaal on Thuistaal.ID = LL_THUISTAAL_FKP
left join ParmTabs Moedertaal on Moedertaal.ID = LL_MOEDERTAAL_FKP
left join ParmTabs BeroepMoeder on BeroepMoeder.ID = LL_MOEDERBEROEP_FKP
left join ParmTabs BeroepVader on BeroepVader.ID = LL_VADERBEROEP_FKP
left join ParmTabs OpleidingMoeder on OpleidingMoeder.ID = LL_MOEDEROPLEIDING_FKP
left join ParmTabs MoederBurgelijkeStaat on MoederBurgelijkeStaat.ID = LL_MOEDERBURGERLIJKESTAAT_FKP
left join ParmTabs VaderBurgelijkeStaat on VaderBurgelijkeStaat.ID = LL_VADERBURGERLIJKESTAAT_FKP
left join Nationaliteiten MoederNationaliteit on MoederNationaliteit.ID = LL_MOEDERNATIONALITEIT_FK
left join Nationaliteiten VaderNationaliteit on VaderNationaliteit.ID = LL_VADERNATIONALITEIT_FK
left join ParmTabs BasisonderwijsNL on BasisonderwijsNL.ID = LB_BASISONDERWIJSNL_FKP
left join ParmTabs GetuigschriftBB on GetuigschriftBB.ID = LB_GETUIGSCHRIFTBB_FKP
left join Leerlingkenmerken on Leerlingen.ID = Leerlingkenmerken.LLK_LEERLING_FK
left join Getuigschriften on Loopbanen.ID = GT_LOOPBAAN_FK
left join Attesten on Attesten.ID = GT_ATTEST_FK

where Scholen.SC_INSTELLINGSNUMMER = '035584' 
and Leerlingkenmerken.isAltijdSet is not null
and Attesten.AT_HOOFDATTEST = 1


order by LL_NAAM, LL_VOORNAAM, [Datum uitreiking]

--SJI 035527
--VTI 035584




-- internaat
-- zij-instromer
-- hoeveel adressen



