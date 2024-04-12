use WiseZonderFK

select 

ll.ID as LL_ID,
kl.KL_SCHOOLJAAR_FK as SJ_ID,
1 as [Intern],
MAX(INS.IS_NAAMGEBRUIKER) as [Internaat]



from InUit iu
left join Leerlingen ll on ll.ID = iu.IU_LEERLING_FK
left join Loopbanen lb on iu.ID = lb.LB_INUIT_FK
left join Klasgroepen kg on kg.id = lb.LB_KLASGROEP_FK
left join Klassen kl on kl.ID = kg.KG_KLAS_FK
left join Instellingen ins on ins.ID = kl.KL_INSTELLING_FK
left join Scholen sc on sc.id = iu.IU_SCHOOL_FK

where ins.IS_NAAMGEBRUIKER like '%internaat%'

group by ll.ID, kl.KL_SCHOOLJAAR_FK


-- koppelen op SJ_ID en LL_ID

-- Er wordt gekeken of er een instelling is die een internaat is. 
-- Let op: Er blijft ook nog een tweede instelling gekoppeld die de school is.
-- Dit gebeurt via de instelling die gekoppeld is aan de loopbaan
-- Opgelet: Voor het internaat bertreft het een apart LB_ID!!
