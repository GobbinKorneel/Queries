use WiseZonderFK

select 
	--CONVERT(BINARY(64), hashbytes('SHA2_512', CONCAT('Korneel', CAST(EL.LL_ID AS VARCHAR(15))))) as hashID,
	--MONTH(EL.GeboorteDatum) as Geboortemaand,
	--YEAR(EL.GeboorteDatum) as Geboortejaar,
	*--,
	--ES.KL_CODE + '-' + CAST(ES.SJ_ID as varchar(15)) + '-' + CAST(ES.IV_ID as varchar(15)) + '-' + CAST(ES.IS_ID as varchar(15)) AS [koppeling leerkrachten]	
from [VTI - Vertrekpunt] VP -- 4928
inner join [VTI - Eigen aan leerling] EL on VP.LL_ID = EL.LL_ID -- 4928 
inner join [VTI - Namen Leerlingen] NL on NL.LL_ID = EL.LL_ID --4928
inner join [VTI - Eigen aan loopbaanitem] ES on VP.LL_ID = ES.LL_ID -- 42439
left join [VTI - Schoolse achterstand] SA on SA.LB_ID = ES.LB_ID -- 42439
left join [VTI - Laatst ingelogd] LI on VP.LL_ID = LI.LL_ID -- 42439
left join [VTI - Adressen] AD on AD.LL_ID = VP.LL_ID -- 42439
left join [VTI - Afwezigheid] AF on ES.LB_ID = AF.LB_ID -- 
--left join [VTI - Instroom] INS on ES.LB_ID = INS.LB_ID -- 
--left join [VTI - Internaat] IT on IT.LL_ID = VP.LL_ID AND IT.SJ_ID = ES.SJ_ID  -- 
--left join [VTI - Leerkrachten_Diploma] LD on LD.KL_CODE = ES.KL_CODE AND LD.SJ_ID = ES.SJ_ID AND LD.IV_ID = ES.IV_ID AND LD.IS_ID = ES.IS_ID 


OPTION (MAXRECURSION 0)