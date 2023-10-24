-- 1. Te listohen të gjitha produktet.
SELECT * FROM Produkti

-- 2. Të listohen të gjithë emrat e produkteve dhe çmimi për njësi i tyre
SELECT EmriProduktit,CmimiPerNjesi FROM Produkti 

-- 3. Të listohen të gjithë emrat prodhuesve (pa përsëritjen e tyre). 
SELECT prodhuesi FROM Produkti GROUP BY prodhuesi;

-- 4. Të listohen të gjitha produktet e prodhuesit “Dell”.
SELECT prodhuesi FROM Produkti WHERE prodhuesi = 'Dell'

-- 5. Të listohen të gjitha produktet e prodhuesit “Lenovo” ose “Hp”.
SELECT prodhuesi FROM Produkti WHERE prodhuesi IN ('Lenovo', 'HP');

-- 6. Të listohen të gjithë monitorët që nuk kane prodhues të specifikuar
SELECT * FROM Produkti WHERE prodhuesi IS NULL;

-- 7. Të listohen të gjithë Laptop-ët që kane çmimin me të vogël se 750. 
 SELECT * FROM Produkti WHERE CmimiPerNjesi < 750;

 -- 8. Të listohen të gjitha produktet të cilat kane prodhuesin “Hp” dhe kanë ne sasi mes 10 dhe 40 njesi. 
SELECT * FROM Produkti WHERE prodhuesi = 'HP' AND Sasia BETWEEN 10 AND 40;

-- 9. Të listohen të gjithë produktet që janë nga prodhuesi “Hp” ose “Lenovo” dhe të cilët kanë  çmimin me të lartë se 150.
SELECT * FROM Produkti WHERE prodhuesi IN ('Lenovo', 'HP') AND CmimiPerNjesi > 150;

-- 10. Të listohen të gjitha produktet e “Acer”, “Hp” , “Lenovo” dhe “Samsung” 
SELECT * FROM Produkti WHERE prodhuesi IN ('Acer', 'HP', 'Lenovo', 'Samsung');

-- 11. Të renditen të gjitha produktet e prodhuesit ‘HP’ me vlere me te vogël se 500 duke i renditur sipas sasisë, nga me e madhja tek me e vogla.
SELECT * FROM Produkti WHERE prodhuesi = 'HP' AND CmimiPerNjesi < 500 ORDER by Sasia DESC
