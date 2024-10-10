SELECT LB_ID
      ,SUM(CASE WHEN procent < 50 THEN 1 ELSE 0 END) AS [onder 50%]
	  ,SUM(CASE WHEN procent >= 50 AND procent < 60 THEN 1 ELSE 0 END) AS [tussen 50% en 60%]
      ,SUM(CASE WHEN procent >= 60 THEN 1 ELSE 0 END) AS [boven 60%]
	  ,Count(*) as [Totaal aantal vakken]
	  
  FROM [WiseZonderFK].[dbo].[SJI - Eigen aan loopbaanitem]

  GROUP BY 
	LB_ID