/*

*/
-- Вложенный запрос с WHERE, вернул 0, т.е., нет продажников, у которых нет продаж...
   SELECT DISTINCT P.FullName
  FROM [Application].[People] AS P
  WHERE P.IsSalesperson=1 AND  NOT Exists  (SELECT 1 from [Sales].[Orders] AS O WHERE O.SalespersonPersonID = P.PersonID   )


-- с WITH то же самое  
;
WITH PeopleGR (Seller)
  AS
  (
  SELECT DISTINCT [SalespersonPersonID]
  FROM [Sales].[Orders]
  )
SELECT [FullName]
FROM [Application].[People]
WHERE IsSalesperson=1 AND [PersonID] NOT IN (SELECT Seller FROM PeopleGR)

