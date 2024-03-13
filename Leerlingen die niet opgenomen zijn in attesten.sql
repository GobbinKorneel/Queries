
select distinct LL_NAAM, LL_VOORNAAM
from testVTI 
where Schooljaar = '2021-2022'
and LL_ID not in (
	select LL_ID
	from testvti
	where Schooljaar = '2021-2022'
	and 
	(
		Attest = 'Ori�nteringsattest C' and MONTH(LB_TOT) = 6 and DAY(LB_TOT) > 26
		or
		Attest <> 'Ori�nteringsattest C'
	)
	group by LL_ID
)