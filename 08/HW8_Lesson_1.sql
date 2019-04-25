/* Это для получения правильных имён, динамическим SQL пока не овладел
SELECT DISTINCT
	 (SUBSTRING(CAST([CustomerName] as varchar(100)),CHARINDEX(N'(',[CustomerName],1)+1,CHARINDEX(N')',[CustomerName],1)-CHARINDEX(N'(',[CustomerName],1)-1)) AS [ShortName]
  FROM [WideWorldImporters].[Sales].[Customers] AS C
  WHERE C.CustomerID in (2,3,4,5,6)

  */

  /* Это для проверки
  SELECT 
	  SUBSTRING(CAST([CustomerName] as varchar(100)),CHARINDEX(N'(',[CustomerName],1)+1,CHARINDEX(N')',[CustomerName],1)-CHARINDEX(N'(',[CustomerName],1)-1) AS [ShortName]
	  ,CAST(DATEADD(mm, DATEDIFF(mm,0,O.OrderDate) ,0) as date) AS FirsDayPeriod
	  ,CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm,0,O.OrderDate) ,0),104) AS InvoiceMonth
	  --,1 AS [ForCount]
	  --,COUNT(O.[OrderID]) OVER(PARTITION BY C.CustomerID,CAST(DATEADD(mm, DATEDIFF(mm,0,O.OrderDate) ,0) as date))
  FROM [WideWorldImporters].[Sales].[Customers] AS C
  JOIN [Sales].[Orders] AS O ON O.CustomerID = C.CustomerID
  WHERE C.CustomerID in (2,3,4,5,6)
  ORDER BY [ShortName]

  */


SELECT * 
FROM
(
SELECT 
	  SUBSTRING(CAST([CustomerName] as varchar(100)),CHARINDEX(N'(',[CustomerName],1)+1,CHARINDEX(N')',[CustomerName],1)-CHARINDEX(N'(',[CustomerName],1)-1) AS [ShortName]
	  ,CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm,0,O.OrderDate) ,0),104) AS InvoiceMonth
	  ,1 AS [ForCount]
  FROM [WideWorldImporters].[Sales].[Customers] AS C
  JOIN [Sales].[Orders] AS O ON O.CustomerID = C.CustomerID
  WHERE C.CustomerID in (2,3,4,5,6)
  ) AS SourcePivot
  PIVOT
  (
  COUNT(ForCount)
  FOR ShortName in ([Gasport, NY] , [Jessie, ND], [Medicine Lodge, KS], [Peeples Valley, AZ], [Sylvanite, MT])
  ) AS pvt


SELECT * 
FROM
(
SELECT 
	  SUBSTRING(CAST([CustomerName] as varchar(100)),CHARINDEX(N'(',[CustomerName],1)+1,CHARINDEX(N')',[CustomerName],1)-CHARINDEX(N'(',[CustomerName],1)-1) AS [ShortName]
	  ,CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm,0,O.OrderDate) ,0),104) AS InvoiceMonth
	  ,1 AS [ForCount]
  FROM [WideWorldImporters].[Sales].[Customers] AS C
  JOIN [Sales].[Orders] AS O ON O.CustomerID = C.CustomerID
  WHERE C.CustomerID in (2,3,4,5,6)
  ) AS SourcePivot
  PIVOT
  (
  SUM(ForCount)
  FOR ShortName in ([Gasport, NY] , [Jessie, ND], [Medicine Lodge, KS], [Peeples Valley, AZ], [Sylvanite, MT])
  ) AS pvt