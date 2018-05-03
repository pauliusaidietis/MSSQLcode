/* 1 Parašykite užklausą patikrinančią ar visų asmenų (lentelė Asmuo) elektroninis paštas korektiškai įvestas. */
Select Asmuo.elPastas from Asmuo where elPastas  LIKE '% %' or elPastas like '%..%' 
Select Count(elpastas) from Asmuo

/* 2. Parašykite užklausą, kuri išveda suvestinę apie elektroninio pašto paslaugų teikėjų paklausą tarp asmenų (lentelė Asmuo).*/
Declare @g varchar(10), @v varchar(10), @h varchar(10) , @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
Set @g =(Select Count(elPastas) from Asmuo where elPastas like '%gmail%')
Set @v =(Select Count(elPastas) from Asmuo where elPastas like '%viko%')
Set @h =(Select Count(elPastas) from Asmuo where elPastas like '%hotmail%')
Print 'Gmail: ' + @g  + @NewLineChar + 'Viko: ' + @v + @NewLineChar+ 'Hotmail: ' + @h



/* 3. Parašykite užklausą išvedančią TOP 5 abonentus pagal skambučių Lietuvos teritorijoje kiekį 2013 metų spalio mėnesį. */

Select top 5 Abonentas.abonentoID, COUNT(Abonentas.abonentoID)  from Abonentas
inner join RysysP2P on Abonentas.abonentoID = RysysP2P.abonentoID
where rysioPradzia between '20131001' and '20131031' and RysysP2P.rysioInicializavimoVieta is Null
 and RysysP2P.adresatoSalis is Null 
and RysysP2P.paslaugosID = 1
Group by Abonentas.abonentoID 
Order by COUNT(Abonentas.abonentoID) desc


/* 4.Parašykite užklausą išvedančią visus abonentus (vardas, pavardė, operatorius), skambinusius į užsienio šalis.*/

Select  Asmuo.vardas, Asmuo.pavarde, Operatorius.operatoriausPavadinimas from Asmuo
inner join Abonentas on Asmuo.asmensID = Abonentas.asmensID
inner join Planas on Abonentas.planoID = Planas.planoID
inner join Operatorius on Planas.operatoriausID = Operatorius.operatoriausID
inner join RysysP2P on Abonentas.abonentoID = RysysP2P.abonentoID
inner join Salis on RysysP2P.rysioInicializavimoVieta=Salis.saliesKodas
where Salis.saliesPavadinimas Not like 'Lietuva'

/* 5. Parašykite užklausą, nustatančią populiariausią užsienio šalį pagal skambučių kiekį į ją. Jei yra kelios vienodai populiarios šalys, išvesti jas visas.*/
SELECT Salis.saliesPavadinimas, Count(rysioPradzia) as 'Skambuciu kiekis' from Salis
inner join RysysP2P on Salis.saliesKodas = RysysP2P.adresatoSalis
where RysysP2P.adresatoSalis is not NULL and RysysP2P.paslaugosID = 4
group by Salis.saliesPavadinimas
Having COUNT(*) in (
	Select  top(1) * From (
		Select  distinct COUNT(rysioPradzia) as 'Count'  from RysysP2P
		where RysysP2P.adresatoSalis is not NULL and RysysP2P.paslaugosID = 4
		group by RysysP2P.adresatoSalis
		)t
	order by t.Count desc
	)
	



