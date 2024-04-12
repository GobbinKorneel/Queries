use WiseZonderFK

select 
	CONVERT(BINARY(64), hashbytes('SHA2_512', CONCAT(VP.LL_ID, '|', NL.Naam, '|', NL.Voornaam, ''))) as hashID,
	*
from [SJI - Vertrekpunt] VP -- 24225
inner join [SJI - Eigen aan leerling] EL on VP.LL_ID = EL.LL_ID -- 24261 --> 36 omhoog, waarom?
inner join [SJI - Eigen aan schooljaar] ES on VP.LL_ID = ES.LL_ID -- 200201
inner join [SJI - Namen Leerlingen] NL on NL.LL_ID = EL.LL_ID 
left join [SJI - Schoolse achterstand] SA on SA.LB_ID = ES.LB_ID -- 200201
left join [SJI - Laatst ingelogd] LI on VP.LL_ID = LI.LL_ID -- 200201
left join [SJI - Adressen] AD on AD.LL_ID = VP.LL_ID -- 200201
left join [SJI - Afwezigheid] AF on ES.LB_ID = AF.LB_ID -- 200201
left join [SJI - Instroom] INS on INS.LL_ID = vp.LL_ID AND INS.KL_ID = ES.KL_ID AND INS.SJ_ID = ES.SJ_ID -- 200776 --> 557 omhoog, waarom?
left join [SJI - Internaat] IT on IT.LL_ID = VP.LL_ID --> 218167 --> terug stijging
--left join [SJI - Leerkrachten_Diploma] LD on LD.KL_CODE = ES.KL_CODE AND LD.SJ_ID = ES.SJ_ID AND LD.IV_ID = ES.IV_ID AND LD.IS_ID = ES.IS_ID 


OPTION (MAXRECURSION 0)