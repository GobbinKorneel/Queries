select Attest, count(distinct LL_ID)
from testvti
where Schooljaar = '2021-2022'
and 
(
	Attest = 'Ori�nteringsattest C' and MONTH(LB_TOT) = 6 and DAY(LB_TOT) > 26
	or
	Attest <> 'Ori�nteringsattest C'
)

group by Attest
