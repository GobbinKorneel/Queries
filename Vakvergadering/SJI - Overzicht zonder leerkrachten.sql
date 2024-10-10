SELECT        CONVERT(BINARY(64), hashbytes('SHA2_512', { fn CONCAT('Korneel', CAST(EL.LL_ID AS VARCHAR(15))) })) AS hashID, MONTH(EL.Geboortedatum) AS Geboortemaand, YEAR(EL.Geboortedatum) AS Geboortejaar, EL.Geslacht, 
                         EL.Herkomst, EL.Nationaliteit, EL.[Leerling Belgische nationaliteit], EL.Autochtoon, EL.Thuistaal, EL.Moedertaal, EL.[Beroep moeder], EL.[Beroep vader], EL.[Opleiding moeder], EL.[Burgelijke staat moeder], 
                         EL.[Burgelijke staat vader], EL.[Moeder overleden], EL.[Vader overleden], EL.[Nationaliteit moeder], EL.[Moeder Belgische nationaliteit], EL.[Nationaliteit vader], EL.[Vader Belgische nationaliteit], EL.[Moeder - Nederlandstalig], 
                         EL.[Moeder - Franstalig], EL.[Moeder - Anderstalig (niet N/F)], EL.[Moeder - Geen info over taal], EL.[Vader - Nederlandstalig], EL.[Vader - Franstalig], EL.[Vader - Anderstalig (niet N/F)], EL.[Vader - Geen info over taal], 
                         EL.[Broer/zus - Nederlandstalig], EL.[Broer/zus - Franstalig], EL.[Broer/zus - Anderstalig (niet N/F)], EL.[Broer/zus - Geen info over taal], EL.[Vrienden - Nederlandstalig], EL.[Vrienden - Franstalig], 
                         EL.[Vrienden - Anderstalig (niet N/F)], EL.[Vrienden - Geen info over taal], EL.[Moeder - Lager onderwijs niet afgewerkt], EL.[Moeder - Lager onderwijs afgewerkt], EL.[Moeder - Lager secundair onderwijs afgewerkt], 
                         EL.[Moeder - Hoger secundair onderwijs afgewerkt], EL.[Moeder - Hoger onderwijs afgewerkt], EL.[Moeder - Laag geschoold], EL.[Thuistaal niet-Nederlands], ES.[Loopbaan van], ES.[Loopbaan tot], ES.[Datum uitschrijving], 
                         ES.Klas, ES.Schooljaar, ES.[Begin Schooljaar], ES.Leerjaar, ES.Graad, ES.[Andertalige nieuwkomer], ES.Attest, ES.[Attest aangepast], ES.Clausulering, ES.[Datum uitreiking], ES.[Basisonderwijs NL], ES.Procent, ES.Vak, 
                         ES.[Omschrijving berekening], ES.Instelling, ES.[Type evaluatie], ES.[Aantal periodes], ES.[Administratieve groep kort], ES.[Administratieve groep volledig], ES.Domein, ES.Finaliteit, ES.LeerjaarInGraad, ES.Onderwijsvorm, 
                         ES.Soortleerjaar, ES.Stemcategorie, ES.Studiegebied, ES.Studierichting, SA.LeerjaarCijfer, SA.[Schoolse achterstand], LI.[Laatste login], LI.[Aantal dagen geleden], LI.[Wie laatst ingelogd], AD.[Verschillende adressen], 
                         AD.[Deelgemeente officieel adres], AD.[Hoofdgemeente officeel adres], AD.[Postcode officieel adres], AF.['] AS [AF.'], AF.[-] AS [AF.-], AF.[#] AS [AF.#], AF.[.] AS [AF..], AF.[?] AS [AF.?], AF.[+] AS [AF.+], AF.[°] AS [AF.°], AF.[1] AS [AF.1], 
                         AF.[2] AS [AF.2], AF.[3] AS [AF.3], AF.[4] AS [AF.4], AF.[5] AS [AF.5], AF.[6] AS [AF.6], AF.[7] AS [AF.7], AF.[8] AS [AF.8], AF.[9] AS [AF.9], AF.[0] AS [AF.0], AF.A AS [AF.A], AF.B AS [AF.B], AF.C AS [AF.C], AF.D AS [AF.D], AF.E AS [AF.E], 
                         AF.F AS [AF.F], AF.G AS [AF.G], AF.H AS [AF.H], AF.I AS [AF.I], AF.J AS [AF.J], AF.K AS [AF.K], AF.L AS [AF.L], AF.M AS [AF.M], AF.N AS [AF.N], AF.O AS [AF.O], AF.P AS [AF.P], AF.Q AS [AF.Q], AF.R AS [AF.R], AF.S AS [AF.S], 
                         AF.T AS [AF.T], AF.U AS [AF.U], AF.V AS [AF.V], AF.W AS [AF.W], AF.X AS [AF.X], AF.Y AS [AF.Y], AF.Z AS [AF.Z], AF.WE AS [AF.WE], AF.VA AS [AF.VA], AF.SV AS [AF.SV], AF.ST AS [AF.ST], AF.OL AS [AF.OL], AF.KR AS [AF.KR], 
                         AF.HL AS [AF.HL], AF.H1 AS [AF.H1], AF.EX AS [AF.EX], AF.WO AS [AF.WO], AF.[Totaal aantal halve dagen afwezig of laat] AS [AF.Totaal], INS.[Vorige school], INS.[Vorige klas], INS.[Vorige loopbaan tot], INS.[Lagere school], 
                         INS.[Laaste leerjaar in lagere school], INS.[Verandering klas tijdens schooljaar], INS.[Zij-instromer school tijdens schooljaar], INS.[Instroom in school bij begin schooljaar], IT.Intern, IT.Internaat, 
                         ES.KL_CODE + '-' + CAST(ES.SJ_ID AS varchar(15)) + '-' + CAST(ES.IV_ID AS varchar(15)) + '-' + CAST(ES.IS_ID AS varchar(15)) AS [koppeling leerkrachten], EL.LL_ID, AV.[onder 50%], AV.[tussen 50% en 60%], AV.[boven 60%], AV.[Totaal aantal vakken]
						  
FROM            dbo.[SJI - Vertrekpunt] AS VP INNER JOIN
                         dbo.[SJI - Eigen aan leerling] AS EL ON VP.LL_ID = EL.LL_ID INNER JOIN
                         dbo.[SJI - Eigen aan loopbaanitem] AS ES ON VP.LL_ID = ES.LL_ID INNER JOIN
                         dbo.[SJI - Namen Leerlingen] AS NL ON NL.LL_ID = EL.LL_ID LEFT OUTER JOIN
                         dbo.[SJI - Schoolse achterstand] AS SA ON SA.LB_ID = ES.LB_ID LEFT OUTER JOIN
                         dbo.[SJI - Laatst ingelogd] AS LI ON VP.LL_ID = LI.LL_ID LEFT OUTER JOIN
                         dbo.[SJI - Adressen] AS AD ON AD.LL_ID = VP.LL_ID LEFT OUTER JOIN
                         dbo.[SJI - Afwezigheid] AS AF ON ES.LB_ID = AF.LB_ID LEFT OUTER JOIN
                         dbo.[SJI - Instroom] AS INS ON ES.LB_ID = INS.LB_ID LEFT OUTER JOIN
                         dbo.[SJI - Internaat] AS IT ON IT.LL_ID = VP.LL_ID AND IT.SJ_ID = ES.SJ_ID LEFT OUTER JOIN
						 dbo.[SJI - Aantal vakken] AS AV on AV.LB_ID = ES.LB_ID
						 