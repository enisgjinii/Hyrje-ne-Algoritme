-- Perdorimi i databazes
USE Invertari2

-- 1. Listoni minimumin e sasis� s� produkteve t� porositura
SELECT MIN(p.Sasia) [Min_i_porosive]FROM Produkti p

-- 2.
SELECT AVG(p.CmimiPerNjesi) [Mesatarja_e_cmimit]FROM Produkti p

-- 3. Shfaqni vendbanimin e klient�ve (pa p�rs�ritjen e tyre)
SELECT DISTINCT Vendbanimi FROM Klienti;

/* 4. Selektoni të gjithë klientët të cilët kanë porositur produkte të caktuara. Selektimi të bëhet
në bazë të id-së së porosisë, emrit dhe mbiemrit të klientit, emrit të produktit dhe sasisë së 
porosisë */
SELECT DISTINCT
    po.PorosiaID,
    (SELECT k.Emri FROM Klienti k WHERE k.ID = po.Klienti) AS Emri,
    (SELECT k.Mbiemri FROM Klienti k WHERE k.ID = po.Klienti) AS Mbiemri,
    (SELECT prod.EmriProduktit FROM Produkti prod WHERE prod.ID = po.Produkti) AS EmriProduktit,
    (SELECT prod.sasia FROM Produkti prod WHERE prod.ID = po.Produkti) AS Sasia
FROM Porosia po;

/* 5. Selektoni të gjitha porositë e bëra nga klienti Gresa Gashi duke përfshirë, emrin dhe 
mbiemrin e klientit, datën e porosisë si dhe emrin dhe sasinë e produkteve të porositura. */

SELECT
    (SELECT k.Emri FROM Klienti k WHERE k.ID = po.Klienti) AS EmriKlientit,
    (SELECT k.Mbiemri FROM Klienti k WHERE k.ID = po.Klienti) AS MbiemriKlientit,
    po.Data,
    (SELECT prod.EmriProduktit FROM Produkti prod WHERE prod.ID = po.Produkti) AS EmriProduktit,
    (SELECT prod.sasia FROM Produkti prod WHERE prod.ID = po.Produkti) AS Sasia
FROM Porosia po
WHERE po.Klienti = (SELECT ID FROM Klienti WHERE Emri = 'Gresa' AND Mbiemri = 'Gashi');


/* 6. Numëroni produktet në bazë të prodhuesve të tyre */
SELECT prod.Prodhuesi AS Prodhuesi, COUNT(*) AS Nr_i_produkteve
FROM Produkti prod
GROUP BY prod.Prodhuesi;

/* 7. Shfaqni shumën e sasive të porosive të bëra për secilin klient */
SELECT 
    k.Emri AS EmriKlientit, 
    k.Mbiemri AS MbiemriKlientit, 
    k.ID AS klienti,
    (SELECT SUM(p.Sasia) FROM Porosia p WHERE p.Klienti = k.ID) AS ShumaPorosive
FROM Klienti k
WHERE (SELECT SUM(p.Sasia) FROM Porosia p WHERE p.Klienti = k.ID) IS NOT NULL;

/* 8. Shfaqni të gjitha porositë të bëra për ‘PC’ si dhe të shfaqet emri i prodhuesit të tyre. */
SELECT  po.PorosiaID,p.EmriProduktit AS EmriProduktit,k.ID AS Klienti,po.Sasia, p.prodhuesi AS prodhuesi
FROM Produkti p, Porosia po ,Klienti k
WHERE p.ID = po.Produkti AND k.ID = po.Klienti
AND p.EmriProduktit = 'PC';



/* 9. Të tregoni numrin e porosive të bëra për secilin klient */
SELECT
    k.Emri AS Emri,
    k.Mbiemri AS Mbiemri,
    k.ID AS klienti,
    (
        SELECT COUNT(*)
        FROM Porosia p
        WHERE p.Klienti = k.ID
    ) AS Nr_porosive
FROM Klienti k
WHERE (
    SELECT COUNT(*)
    FROM Porosia p
    WHERE p.Klienti = k.ID
) > 0;

/* 10. Shfaqni shumën e produkteve të porositura nga klienti Albin Krasniqi */
SELECT
    k.Emri AS Emri,
    k.Mbiemri AS Mbiemri,
    (
        SELECT SUM(p.Sasia)
        FROM Porosia p
        WHERE p.Klienti = k.ID
    ) AS shuma_e_porosive
FROM Klienti k
WHERE k.Emri = 'Albin' AND k.Mbiemri = 'Krasniqi';

/* 11. Shfaqni të gjitha produktet që janë porositur në sasi mes 5 dhe 10 si dhe porosia është 
bërë në datat ‘2020-10-14’ dhe ‘2020-10-10’. */

SELECT
    po.PorosiaID AS PorosiaID,
    k.Emri AS Emri,
    k.Mbiemri AS Mbiemri,
    (SELECT p.EmriProduktit FROM Produkti p WHERE p.ID = po.Produkti) AS prodhuesi,
    po.Sasia,
    po.data
FROM Porosia po, Klienti k
WHERE po.Klienti = k.ID
    AND po.Sasia BETWEEN 5 AND 10
    AND po.data BETWEEN '2020-10-10' AND '2020-10-14';



/* 12. Shfaqni vetëm klientët të cilët kanë bërë më shumë se 1 porosi dhe bëni renditjen e tyre 
në bazë të numrit të porosive (nga me e madhja tek me e vogla.) */
/* 
Ky query merr klientët që kanë kryer më shumë se një porosi dhe i rendit sipas numrit të porosive pa përdorur JOIN.
Në nënselektimin (subquery), zgjedhim ID, Emrin dhe Mbiemrin e klientëve nga tabela Klienti
dhe numërojmë numrin e porosive për çdo klient duke përdorur një nënselektim.
*/

SELECT Emri, Mbiemri, NumriPorosive
FROM (
    SELECT k.ID AS klienti, k.Emri, k.Mbiemri, 
           (SELECT COUNT(*) FROM Porosia p WHERE p.Klienti = k.ID) AS NumriPorosive
    FROM Klienti k
) AS Subquery

/* Filtron klientët që kanë më shumë se një porosi (NumriPorosive > 1). */
WHERE NumriPorosive > 1

/* Rendit klientët sipas numrit të porosive në rend zbritës (nga më e madhja tek më e vogla). */
ORDER BY NumriPorosive DESC;

-- Opsionale
-- 1. Të shfaqni moshën mesatare të klientëve, emri i të cilëve fillon me ‘G’ dhe kane bere porosi të  produkteve që kane çmimin mes 50 dhe 150.
-- Kjo query shfaq moshën mesatare të klientëve të cilët fillon emri me 'G' dhe kanë bërë porosi të produkteve 
-- që kanë çmimin mes 50 dhe 150.

SELECT 
    k.Emri, 
    k.Mbiemri, 
    AVG(DATEDIFF(YEAR, k.Datelindja, GETDATE())) AS mosha
FROM Klienti k
WHERE k.Emri LIKE 'G%'
    AND k.ID IN (
        SELECT DISTINCT p.Klienti
        FROM Porosia p
        JOIN Produkti pr ON p.Produkti = pr.ID
        WHERE pr.CmimiPerNjesi BETWEEN 50 AND 150
    )
GROUP BY k.Emri, k.Mbiemri;


-- 2. Të tregoni të numrin e produkteve që nuk janë porositur asnjëherë.

-- Ky query përdor COUNT(*) për të numëruar produktet që nuk janë porositur asnjëherë.

-- Tabela "Produkti" është aliasuar si "pr".

-- Përdorimi i nënselektimit (subquery) identifikon produktet që janë të lidhura me porosi (po.Produkti).

-- Nënvizohet çdo produkt që gjendet në nënselektim (pr.ID NOT IN (SELECT DISTINCT po.Produkti FROM Porosia po)).

SELECT COUNT(*) AS Nr_i_produkteve
FROM Produkti pr
WHERE pr.ID NOT IN (
    SELECT DISTINCT po.Produkti
    FROM Porosia po
);

-- 3. Të sa klient nuk kanë bërë asnjë porosi.

-- Ky query përdor COUNT(*) për të numëruar klientët që nuk kanë bërë asnjë porosi.

-- Tabela "Klienti" është aliasuar si "k".

-- Nënvizohet çdo klient që nuk gjendet në nënselektimin (k.ID NOT IN (SELECT DISTINCT p.Klienti FROM Porosia p)).

SELECT COUNT(*) AS Nr_i_klienteve
FROM Klienti k
WHERE k.ID NOT IN (
    SELECT DISTINCT p.Klienti
    FROM Porosia p
);



