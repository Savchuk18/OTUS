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

  
  

  -- Проверки, должен ли быть 0? Т.е., у всех ли продажников есть продажи?
    SELECT DISTINCT 
	P.IsSalesperson
	,P.FullName
  FROM [Sales].[Orders] AS O
  JOIN [Application].[People] AS P ON P.PersonID = O.SalespersonPersonID
-- Вернулось 10 строк (можно, конечно, было просто посчитать, как в следующем примере), т.е., 10 человек продавали, а сколько продажников?  
  SELECT COUNT(*)
  FROM [Application].[People]
  WHERE IsSalesperson=1
  -- Вернулось 10, значит, всего продажников 10, и, скорее всего, результат правильный (если я правильно всё сделал)
