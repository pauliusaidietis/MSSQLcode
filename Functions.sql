--1. Sukurkite funkciją, kuri išveda abonentus daugiausiai išsiuntusius/atsisiuntusius duomenų internetu (po vieną kiekvieno operatoriaus).
Create function dbo.daugPglOper()
returns table as return
(with cte as(
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
--2.Sukurkite funkciją, kuri išveda abonentus, kurie tarpusavyje bendravo tam tikrą mėnesį, t.y. abonentas1 skambino ar rašė SMS abonentui2 ir atvirkščiai.
Create function dbo.bendravoMen(@menuo int)
returns table as return
(
Select RysysP2P.abonentoID as id,Abonentas.numeris as abNr, RysysP2P.adresatoNumeris as adrNr,RysysP2P.rysioPradzia as rysioPr,RysysP2P.rysioPabaiga as rysioPab,
 Abonentas.abonentoID as adrId,Abonentas.numeris as adrNr2 from RysysP2P
inner join Abonentas on RysysP2P.adresatoNumeris = Abonentas.numeris and Abonentas.numeris=RysysP2P.adresatoNumeris
where month(rysioPradzia) =@menuo and month(rysioPabaiga)=@menuo
)
--3.Sukurkite funkciją, kuri apskaičiuoja mokestį abonentui už SMS tam tikrą mėnesį. 
--Skaičiuojant mokestį įvertinti ir tai, kad galbūt yra užsakytas lengvatinis planas.
Create function dbo.KiekMoket (@menuo int,@metai int, @abonentas int)
returns table
as return(
with cte as (
select UzsakomaLengvata.kiekis as a,PlanoRinkinys.kaina as smsKaina, UzsakomaLengvata.kaina as b, UzsakytaLengvata.abonentoID as c, UzsakytaLengvata.uzsakymoData as d, UzsakytaLengvata.atsisakymoData as e,
 Day((UzsakytaLengvata.atsisakymoData-UzsakytaLengvata.uzsakymoData)) as trukme from PlanoRinkinys
inner join Lengvata on PlanoRinkinys.rinkinioID=Lengvata.rinkinioID
inner join UzsakomaLengvata on PlanoRinkinys.rinkinioID=UzsakomaLengvata.rinkinioID
inner join UzsakytaLengvata on UzsakomaLengvata.komplektoID = UzsakytaLengvata.komplektoID
where (PlanoRinkinys.paslaugosID = 2 or PlanoRinkinys.paslaugosID=5) and (abonentoID=@abonentas and month(UzsakytaLengvata.uzsakymoData)=@menuo and year(UzsakytaLengvata.uzsakymoData)=@metai)
),
cte3 as (
Select Count(RysysP2P.abonentoID) as a from Abonentas inner join RysysP2P on Abonentas.abonentoID=RysysP2P.abonentoID 
where Abonentas.abonentoID = @abonentas and month (RysysP2P.rysioPradzia) = @menuo and year(RysysP2P.rysioPradzia)=@metai
),
cte4 as (
Select PlanoRinkinys.kaina as v from Abonentas inner join Planas on Abonentas.planoID=Planas.planoID
inner join PlanoRinkinys on Planas.planoID=PlanoRinkinys.planoID
where Abonentas.abonentoID=@abonentas and ( PlanoRinkinys.paslaugosID = 2 or PlanoRinkinys.paslaugosID=5) and PlanoRinkinys.kaina != 0.00
),
cte2 as (
Select Count(abonentoID) as issiunteMen from RysysP2P 
where (RysysP2P.paslaugosID=2 or RysysP2P.paslaugosID=5) and month(rysioPradzia)=@menuo and year(rysioPradzia)=@metai and RysysP2P.abonentoID=1
) 
Select case when not exists(select cte.a from cte) then (select (a*v) from cte3,cte4)
when (select cte.a from cte)>0 then (select b from cte)
end as kk)
