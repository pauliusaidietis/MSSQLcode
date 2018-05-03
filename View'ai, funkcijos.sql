--1. Sukurkite view'ą, kuris išveda kiekvieno abonento bendrą pokalbio laiką.
Create view v1(Valandoss, Minutess, sekundes)
as
With divide as(
Select abonentoID,
DATEDiFF(SECOND, rysioPradzia, rysioPabaiga ) as a
  from RysysP2P 
  where (abonentoID = 567) and not (paslaugosID = 3 or paslaugosID =2 or paslaugosID=5)
),
sumofseconds as(
Select Sum(a) as seconds from divide 
),
sumofmin as (
Select (seconds/CONVERT(decimal(4,2), 60)) as minutess from sumofseconds
),
sumofhours as (
Select (minutess/CONVERT(decimal(4,2), 60)) as hourss from sumofmin
),precisionhour as (
Select (hourss - convert(int,hourss)) as pre, convert(int,hourss) as Valandoss from sumofhours
),precisionminute as (
Select ( pre*60 - convert(int,(pre*60))) as sekundes,convert(int,(pre*60)) as Minutess from precisionhour
)
Select Valandoss, Minutess, sekundes*60 
from precisionminute, precisionhour

Select Valandoss from v1

--2.Sukurkite view'ą, kuris išveda kiekvieno asmens ilgiausio pokalbio trukmę ir kam skambinta.
create view v3(asmensID,Vardas, Pavarde,ID, Numeris, IlgiausiaTrukme)
as
	with cte as(
	Select  abonentoID as n, max(rysioPabaiga - rysioPradzia) as m from RysysP2P
	group by abonentoID
	)
	Select distinct Asmuo.asmensID,Asmuo.vardas,Asmuo.pavarde, RysysP2P.abonentoID,RysysP2P.adresatoNumeris, convert(varchar, (rysioPabaiga - rysioPradzia), 108) from RysysP2P
	inner join cte on RysysP2P.abonentoID=cte.n
	inner join Abonentas on RysysP2P.abonentoID=Abonentas.abonentoID
	inner join Asmuo on Abonentas.asmensID=Asmuo.asmensID
	where (rysioPabaiga - rysioPradzia) = cte.m

	Select * from v3
	order by ID asc

--3.Sukurkite funkciją, kuri apskaičiuoja bendrą tam tikro mėnesio abonento pokalbio trukmę,
 --kiekvieno atskiro pokalbio trukmę suapvalinant į didesnę pusę iki sveiko minučių kiekio. Funkcijos parametrai: abonentoID, metai, mėnuo.
	 Create function dbo.pokalbiuTrukmePerMen2( @abonentoID int, @metai int, @menuo int)
		returns table
		as return (
		Select sum(datediff(Minute,rysioPradzia,rysioPabaiga)) as minutesPerMen from RysysP2P
			 where month(rysioPradzia) = @menuo and year(rysioPradzia) = @metai
		and abonentoID=@abonentoID
		)
			 
		select*from pokalbiuTrukmePerMen2 (8, 2013, 6)

	--4.Sukurkite funkciją, kuri apskaičiuoja mokėtiną sumą už tam tikro mėnesio vietinius skambučius. Funkcijos parametrai: abonentoID, metai, mënuo.
Create function dbo.pokalbiuSumaPerMen( @abonentoID int, @metai int, @menuo int)
returns table
as
return	( 
		 with cte2 as (select PlanoRinkinys.kaina as b from  Abonentas
		 inner join Planas on Abonentas.abonentoID = Planas.planoID
		 inner join PlanoRinkinys on Planas.planoID=PlanoRinkinys.planoID
		  where Abonentas.abonentoID=@abonentoID and PlanoRinkinys.paslaugosID = 1),

		  cte as (
		 select Count(rysioPradzia) as a from RysysP2P
		  where  RysysP2P.abonentoID=@abonentoID and year(rysioPradzia) = @metai and MONTH(rysioPradzia) = @menuo 
		 and RysysP2P.paslaugosID = 1
		 )
		select a*b as 'pokalbiai' from cte, cte2
		)
		

		select*from pokalbiuSumaPerMen (1, 2013, 6) 
