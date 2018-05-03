--1. Sukurkite funkciją, kuri išveda abonentus daugiausiai išsiuntusius/atsisiuntusius duomenų internetu (po vieną kiekvieno operatoriaus).
with main as
( select * from
with cte as(
Select Sum(kiekisMB)as a, abonentoID as b from RysysInternetu
group by abonentoID
), cte2 as (
select Abonentas.abonentoID as c, Operatorius.operatoriausPavadinimas as d from Abonentas
inner join Planas on Abonentas.planoID=Planas.planoID
inner join Operatorius on Planas.operatoriausID = Operatorius.operatoriausID
)
select  d as Oper, Max(a) as MBrekordininkai from cte2
inner join cte on cte2.c = cte.b
group by d
)
select * from main

--2.Sukurkite funkciją, kuri išveda abonentus, kurie tarpusavyje bendravo tam tikrą mėnesį, t.y. abonentas1 skambino ar rašė SMS abonentui2 ir atvirkščiai.

with cte1 as (
Select Abonentas.abonentoID as abId1, Abonentas.numeris as abNr1, RysysP2P.abonentoID as ab1, RysysP2P.adresatoNumeris as adNr1 from Abonentas
inner join RysysP2P on Abonentas.abonentoID = RysysP2P.abonentoID
where (month(rysioPradzia) =7 and month(rysioPabaiga)=7)
),
cte2 as (
Select  RysysP2P.abonentoID as ab2, RysysP2P.adresatoNumeris as adNr2,Abonentas.abonentoID as abId2, Abonentas.numeris as abNr2 from RysysP2P
inner join Abonentas on RysysP2P.abonentoID=Abonentas.abonentoID 
where (month(rysioPradzia) =6 and month(rysioPabaiga)=6)
), cte3 as(
Select * from cte1
intersect
Select* from cte2
)
Select * from cte2

,cte4 as(
Select * from cte2
intersect
Select* from cte1
)
select * from cte3,cte4




REPLACE(abNr1+adNr1, ' ', '')
Select REPLACE('864646085'+'8  631fdvd18', ' ', '')
where REPLACE('864646085'+'8  6322118', ' ', '') = REPLACE('864646085'+'8  6322118', ' ', '')






cte2 as (
Select RysysP2P.abonentoID as adId,RysysP2P.adresatoNumeris as adNr, Abonentas.abonentoID , Abonentas.numeris as abNr from RysysP2P
inner join Abonentas on RysysP2P.abonentoID=Abonentas.abonentoID
where (month(rysioPradzia)=6 and month(rysioPabaiga)=6) 
)
Select cte1.*, cte2.* from  cte1,cte2
where cte1.abNr1+cte1.adNr1=cte1.adNr1
--inner join cte2 on (cte1.abNr1=cte2.adNr and (cte1.adNr1=cte2.abNr and cte1.abNr1=cte2.adNr))
--where (cte1.abNr1 in (cte2.adNr) and cte1.adNr1 in (cte2.abNr))
order by  abId1, cte2.abonentoID asc

select Abonentas.abonentoID, numeris, RysysP2P.abonentoID, adresatoNumeris from Abonentas
inner join RysysP2P on Abonentas.abonentoID = RysysP2P.abonentoID
where (Abonentas.abonentoID = 103 and RysysP2P.adresatoNumeris='865252834860000420' and month(rysioPradzia) =6) 
or (Abonentas.abonentoID =1856 and RysysP2P.adresatoNumeris='860000420865252834' and month(rysioPradzia) =6) 



Select * from bendravoMen(6)

Select * from Abonentas
where numeris=4338878297
--3.Sukurkite funkciją, kuri apskaičiuoja mokestį abonentui už SMS tam tikrą mėnesį. 
--Skaičiuojant mokestį įvertinti ir tai, kad galbūt yra užsakytas lengvatinis planas.
go
declare @menuo int
set @menuo=2;
with cte as (
select UzsakomaLengvata.kiekis as a,PlanoRinkinys.kaina as smsKaina, UzsakomaLengvata.kaina as b, UzsakytaLengvata.abonentoID as c, UzsakytaLengvata.uzsakymoData as d, UzsakytaLengvata.atsisakymoData as e,
 Day((UzsakytaLengvata.atsisakymoData-UzsakytaLengvata.uzsakymoData)) as trukme from PlanoRinkinys
inner join Lengvata on PlanoRinkinys.rinkinioID=Lengvata.rinkinioID
inner join UzsakomaLengvata on PlanoRinkinys.rinkinioID=UzsakomaLengvata.rinkinioID
inner join UzsakytaLengvata on UzsakomaLengvata.komplektoID = UzsakytaLengvata.komplektoID
where (PlanoRinkinys.paslaugosID = 2 or PlanoRinkinys.paslaugosID=5) and (abonentoID=1 and month(UzsakytaLengvata.uzsakymoData)=2)
),
cte3 as (
Select Count(RysysP2P.abonentoID) as a from Abonentas inner join RysysP2P on Abonentas.abonentoID=RysysP2P.abonentoID 
where Abonentas.abonentoID = 1 and month (RysysP2P.rysioPradzia) = 2
),
cte4 as (
Select PlanoRinkinys.kaina as v from Abonentas inner join Planas on Abonentas.planoID=Planas.planoID
inner join PlanoRinkinys on Planas.planoID=PlanoRinkinys.planoID
where Abonentas.abonentoID=1 and (PlanoRinkinys.paslaugosID = 2 or PlanoRinkinys.paslaugosID=5) and PlanoRinkinys.kaina != 0.00
),
cte2 as (
Select Count(abonentoID) as issiunteMen from RysysP2P 
where (RysysP2P.paslaugosID=2 or RysysP2P.paslaugosID=5) and month(rysioPradzia)=2 and RysysP2P.abonentoID=1
) Select case when not exists(select cte.a from cte) then (select (a*v) from cte3,cte4)
when (select cte.a from cte)>0 then (select b from cte)
end

select * from kiekMoket(3,2014,1)


--4. Sukurkite procedūrą, kuri automatiškai pratęsia sutartį abonentui
 --tomis pačiomis sąlygomis, kokios buvo anksčiau (trukmė, papildomos paslaugos ir t.t.).

 Select * from Abonentas




select * from UzsakytaLengvata

Select * from RysysP2P 
where paslaugosID=2
where (RysysP2P.rysioPradzia  between '2013-06-14 00:00:00.000' and '2014-06-25 00:00:00.000') 
and RysysP2P.abonentoID = 2 and(RysysP2P.paslaugosID=2 or RysysP2P.paslaugosID=5)






declare @ats decimal, @a int, @b int, @c int
if (Select  a from cte)

-321 pirma arba antra


set @a=(select a from cte)
set @ats = Case @ when 1000 then 500 end
print @ats


select * from PlanoRinkinys
inner join Lengvata on PlanoRinkinys.rinkinioID=Lengvata.rinkinioID
inner join UzsakomaLengvata on PlanoRinkinys.rinkinioID=UzsakomaLengvata.rinkinioID
inner join UzsakytaLengvata on UzsakomaLengvata.komplektoID = UzsakytaLengvata.komplektoID
where (PlanoRinkinys.paslaugosID = 2 or PlanoRinkinys.paslaugosID=5) and abonentoID=2

Select Count(abonentoID) from RysysP2P 
where (RysysP2P.paslaugosID=2 or RysysP2P.paslaugosID=5) and month(rysioPradzia)=6 and RysysP2P.abonentoID=2


select * from UzsakomaLengvata
select * from Lengvata


--5. Sukurkite procedūrą, kuri automatiškai pratęsia sutartį abonentui tomis pačiomis sąlygomis, kokios buvo anksčiau (trukmė, papildomos paslaugos ir t.t.).
--6. Sukurkite funkciją, pasiūlančią abonentui geriausiai jam tinkantį mokėjimo planą, įvertinant paskutinių trijų mėnesių naudojimosi paslaugomis tendencijas.