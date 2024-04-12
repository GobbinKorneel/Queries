Use WiseZonderFK

SELECT 
	IU.IU_LEERLING_FK as LL_ID

FROM InUit IU
left join Loopbanen LB on IU.ID = LB.LB_INUIT_FK
left join Klasgroepen KG ON KG.ID = lb.LB_KLASGROEP_FK
left join Klassen KL on KL.ID = KG.KG_KLAS_FK
left join Instellingen IIS on IIS.ID = KL.KL_INSTELLING_FK
left join Scholen SC on SC.ID = IIS.IS_SCHOOL_FK

WHERE SC.SC_INSTELLINGSNUMMER = '035527' 

Group by IU.IU_LEERLING_FK



--SJI 035527
--VTI 035584
--DBR 112011
--RP  035535









