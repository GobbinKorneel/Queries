select *



  from [VTI - Vertrekpunt] vp
  left join [VTI - Namen Leerlingen] ll on ll.LL_ID = vp.LL_ID
  left join [VTI - Eigen aan leerling] el on el.LL_ID = vp.LL_ID
  left join [VTI - Adressen] ad on ad.LL_ID = vp.LL_ID
  left join [VTI - Eigen aan loopbaanitem] lb on lb.LL_ID = vp.LL_ID
  left join [VTI - Schoolse achterstand] sa on sa.LB_ID = lb.LB_ID
  left join [VTI - Instroom] ins on ins.LB_ID = lb.LB_ID
  left join [VTI - Internaat] inter on inter.LL_ID = vp.LL_ID and lb.SJ_ID = inter.SJ_ID
  left join InUit iu on iu.IU_LEERLING_FK = ll.LL_ID

  where (lb.LB_ID is null
  or lb.Schooljaar = '2024-2025')
  and iu.IU_DATUMINSCHRIJVING > '20240101'
  and iu.IU_DATUMUITSCHRIJVING > GETDATE()

  option (maxrecursion 0)