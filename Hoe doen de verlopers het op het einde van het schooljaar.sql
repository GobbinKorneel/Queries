select distinct LL_ID, LL_NAAM, LL_VOORNAAM, Attest
from testvti
where LL_ID in 
	(
		select LL_ID
		from testVTI
		where Schooljaar = '2021-2022'
		--and Attest <> 'Attest van uitschrijving tijdens het schooljaar'
		group by LL_ID, LL_NAAM, LL_VOORNAAM
		having Count(distinct Attest) > 1
	)
and Schooljaar = '2021-2022'
and MONTH(LB_TOT) = 6 
and DAY(LB_TOT) > 26






