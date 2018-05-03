/* 1. Išveskite asmenis užsisakiusius daugiausiai papildomų paslaugų. */

Select Abonentas.asmensID, COUNT(a.abonentoID) as suma,Asmuo.vardas, Asmuo.pavarde from Abonentas
inner join Asmuo on Asmuo.asmensID = Abonentas.asmensID
inner join UzsakytaPapildomaPaslauga as a on Abonentas.abonentoID = a.abonentoID
group by Abonentas.asmensID, Asmuo.vardas, Asmuo.pavarde
order by suma desc

 /* 2. Išveskite procentine išraiška abonentų pasiskirstymą tarp operatorių. */
 Select Operatorius.operatoriausID,
 COUNT(Abonentas.planoID) * 100.0 / (select COUNT(Abonentas.planoID) from Planas inner join Abonentas on Planas.planoID = Abonentas.planoID ) as Kiekis  
 from Planas
 inner join Abonentas on Planas.planoID = Abonentas.planoID
 inner join Operatorius on Planas.operatoriausID=Operatorius.operatoriausID
 Group by Operatorius.operatoriausID
/* Išveskite 3 populiariausius tarp abonentų mobiliojo ryšio planus. Jei yra daugiau nei 3 planai
 turintys tą patį kiekį abonentų, išvesti visus tokius planus. Užklausa turi išvesti plano pavadinimą ir abonentų kiekį.*/
Select  COUNT(*) as 'Count', planoPavadinimas  from Planas
inner join Abonentas
on Planas.planoID=Abonentas.planoID
group by planoPavadinimas
Having COUNT(*) in (
	Select  top(3) * From (
	Select  distinct COUNT(*) as 'Count'  from Planas
	inner join Abonentas
	on Planas.planoID=Abonentas.planoID
	group by planoPavadinimas
	)t
	order by t.Count desc --denserank galima naudot
)
order by  'Count' desc
/*4. Išveskite šiuo metu aktyvius abonentus (sutartis dar nepasibaigus) iš Vilniaus. Užklausa turi išvesti asmens pilną vardą
 (vardas + pavardė), plano pavadinimas, numeris. */
Select Asmuo.vardas, Asmuo.pavarde, m.miestoPavadinimas, Planas.planoPavadinimas, Abonentas.numeris from Abonentas
inner join Asmuo on Abonentas.asmensID = Asmuo.asmensID
inner join Miestas as m on Asmuo.miestoID = m.miestoID
inner join Planas on Abonentas.planoID = Planas.planoID
where Abonentas.sutartiesPabaiga > '20171010' or Abonentas.sutartiesPabaiga is null and
 m.miestoPavadinimas='Vilnius'
