DECLARE @StartDate DATE = '2000-01-01', @EndDate DATE = '2024-12-31';

WITH Calendar AS (
    SELECT @StartDate AS TheDate
    UNION ALL
    SELECT DATEADD(DAY, 1, TheDate) FROM Calendar WHERE TheDate < @EndDate
),

tussenresultaat as(
	SELECT 
		TheDate = CAST(CONCAT(TheDate, ' 00:00:00.000') AS DATETIME)

	FROM Calendar

	WHERE DATEPART(dw, TheDate) BETWEEN 2 AND 6

	UNION ALL

	SELECT 
		CAST(CONCAT(TheDate, ' 12:00:00.000') AS DATETIME)

	FROM Calendar

	WHERE DATEPART(dw, TheDate) BETWEEN 2 AND 6
	),

eindresultaat as(
	select 
	TheDate,
	DATEPART(dw, TheDate) as [dag van week]

	from tussenresultaat
	where (DATEPART(dw, TheDate) <> 4 or DATEPART(hour, TheDate) <> 12)
	)


	select *
	from eindresultaat

	

OPTION (MAXRECURSION 0)
