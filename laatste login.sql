

SELECT 
	UK1.UK_SOURCE_FK, 
	t2.max_login,
	datediff(day, t2.max_login, GETDATE()) as [Verschil],
	case 
		when uk1.UK_ROL = 1  then 'Vader'
		when uk1.UK_ROL = 2 then 'Moeder'
		when uk1.UK_ROL = 3 then 'Voogd'
		when uk1.UK_ROL = 4 then 'Pluspapa'
		when uk1.UK_ROL = 5 then 'Plusmama'
		when uk1.UK_ROL = 6 then 'Grootvader'
		when uk1.UK_ROL = 7 then 'Grootmoeder'
		when uk1.UK_ROL = 8 then 'Ander persoon'
		else 'Niemand'
	end as Rol
from Users U1 
left join UserKoppelingen UK1 on U1.Id = UK1.UK_USER_FK
inner join (
		select MAX(U2.U_LAATSTELOGIN) as max_login, UK2.UK_SOURCE_FK
		from Users U2
		left join UserKoppelingen UK2 on U2.Id = UK2.UK_USER_FK
		group by UK2.UK_SOURCE_FK	
		) t2 on t2.max_login = U1.U_LAATSTELOGIN and t2.UK_SOURCE_FK = uk1.UK_SOURCE_FK
			   		 	   




