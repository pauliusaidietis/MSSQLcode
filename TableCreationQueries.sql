-- 1. Lentelėje Abonentas pridėkite papildomą atributą "nuolaida" Decimal(3,2) tipo NOT NULL Default 0,00 reikšmė.
Alter table Abonentas
add nuolaida Decimal(3,2) Not Null Default 0.00
--2. Lentelėje Asmuo pridėkite atributą "elPastas" varchar(50) tipo NULL reikšmė.
Alter table Asmuo
add elPastas varchar(50) Null
--3. Sukurkite lentelę Domenas su atributu "pavadinimas" varchar(15) tipo.
--4. Į lentelę Domenas įveskite įrašus: "gmail.com", "yahoo.com", "hotmail.com", "viko.lt".
Create table Domenas (
 Pavadinimas varchar(15),
)

Insert into Domenas(Pavadinimas) Values ('gmail.com'), ('yahoo.com'), ('hotmail.com'), ('viko.lt');
--5. Atnaujinkite lentelės Asmuo įrašus įvedant el pašto adresą. Kiekvienam asmeniui el. pašto adresas formuojamas taip: vardas.pavarde@domenas. domenas atsitiktinai parenkamas iš lentelės Domenas
Declare @VP varchar(100), @Pastas varchar(100), @Pilnas varchar(100), @Count int, @MaxCount int
Set @Count = 1
Set @MaxCount = (Select Max(asmensID) From Asmuo)
While @Count<=@MaxCount
Begin
Set @VP  = (Select vardas from Asmuo where asmensID=@Count) + '.' + (Select pavarde from Asmuo where asmensID=@Count)
Select Top 1 @Pastas = (Pavadinimas) From Domenas ORDER BY NEWID()
Update Asmuo
Set elPastas = @VP + '@' + @Pastas
where asmensId = @Count
set @Count=@Count+1
End
select * from Asmuo
--6. Sukurkite lentelę VipAbonentai. Jos struktūra turėtų būti tokia: abonentoID, asmensID, planoID, numeris, sutartiesPradzia, sutartiesPabaiga. 
--Atributas abonentoID turi būti pirminis raktas, atributas sutartiesPradzia turi turėti numatytąją reikšmę (šiandienos data), visi atributai turi turėti not null nustatymą išskyrus atributą sutartiesPabaiga. Lentelę užpildykite tokiais duomenimis:
--7. Sukurtą lentelę papildykite abonentais iš Vilniaus. Perduodant abonentoID jis turi išlikti toks pats kaip ir lentelėje Abonentas.

Create table VipAbonentai (
abonentoID int not Null,
 asmensID int not Null,
  planoID int not Null,
   numeris bigint not Null,
    sutartiesPradzia date default getdate() not null,
	 sutartiesPabaiga date, 
	 primary key (abonentoID)
)
Insert into VipAbonentai(abonentoID,asmensID, planoID, numeris,sutartiesPradzia, sutartiesPabaiga)
 Values (1, 2, 5, 861234567,default,null),
   (2, 3, 2, 861764567,getDate()+1,'20191010'),
    (3, 10, 5, 8677055663,default,'20190101');

Select Abonentas.abonentoID, Abonentas.asmensID, Planas.planoID, Abonentas.numeris,
  Abonentas.sutartiesPradzia, Abonentas.sutartiesPabaiga, Miestas.miestoPavadinimas
 from Abonentas
 inner join Asmuo on Abonentas.asmensID=Asmuo.asmensID 
 inner join Planas on Abonentas.planoID =Planas.planoID
 inner join Miestas on Asmuo.miestoID = Miestas.miestoID 
 where miestoPavadinimas = 'Vilnius'


 Insert into VipAbonentai (abonentoID,asmensID, planoID, numeris,sutartiesPradzia, sutartiesPabaiga)
 Select Abonentas.abonentoID, Abonentas.asmensID, Planas.planoID, Abonentas.numeris,
  Abonentas.sutartiesPradzia, Abonentas.sutartiesPabaiga FROM Abonentas
inner join Asmuo on Abonentas.asmensID=Asmuo.asmensID 
 inner join Planas on Abonentas.planoID =Planas.planoID
 inner join Miestas on Asmuo.miestoID = Miestas.miestoID 
 where miestoPavadinimas = 'Vilnius'

 Select * from VipAbonentai