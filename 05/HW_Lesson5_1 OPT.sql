
/*
Опционально:
Написать все эти же запросы, но, если за какой-то месяц не было продаж, то этот месяц тоже должен быть в результате и там должны быть нули.
*/


/*
Посчитать среднюю цену товара, общую сумму продажи по месяцам
*/


-- Сначала создадим табличную переменную, в которую запишем возможные даты продажи - год и месяц
DECLARE @YMin int, @Ymax int;
DECLARE @RangaDate TABLE(InvoiceYear int, InvoiceMonth int);

SET @YMin = (SELECT YEAR(min([InvoiceDate])) FROM [Sales].[Invoices]) -- начало диапазона года
SET @Ymax = (SELECT YEAR(MAX([InvoiceDate])) FROM [Sales].[Invoices]) -- конец диапазона года

;WITH Num_seq(Num) AS		--диапазон месяцев
(
	SELECT 1 AS Start_num
	UNION ALL
	SELECT Num+1 FROM Num_seq WHERE Num < 12
)
,
YeNum (Ye) AS	-- диапазон лет
(
	SELECT @YMin As StartYear
	UNION ALL
	SELECT Ye+1 FROM YeNum WHERE Ye < @Ymax
)
INSERT INTO @RangaDate -- заполним таблицу год-месяц
	(
	InvoiceYear
	,InvoiceMonth
	)
SELECT 
	Ye
	,Num
FROM YeNum
CROSS JOIN Num_seq

--SELECT * FROM @RangaDate ORDER BY InvoiceYear, InvoiceMonth

-- Здесь никаких огрничений нет, поэтому должно работать просто
SELECT 
	RD.InvoiceYear --([InvoiceDate]) AS 'Год'
	 ,RD.InvoiceMonth --MONTH([InvoiceDate]) AS 'Месяц'
	 ,ISNULL(AVG(IL.UnitPrice),0) AS 'Средняя цена'
	 ,ISNULL(SUM(IL.UnitPrice*[Quantity]),0)	AS 'Сумма за месяц'
FROM [Sales].[InvoiceLines] AS IL
JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
RIGHT JOIN @RangaDate AS RD ON RD.InvoiceYear = YEAR([InvoiceDate]) AND RD.InvoiceMonth = MONTH([InvoiceDate])
GROUP BY RD.InvoiceYear, RD.InvoiceMonth--YEAR([InvoiceDate]), MONTH([InvoiceDate])
ORDER BY RD.InvoiceYear, RD.InvoiceMonth -- Про сортировку ничего не было сказано, но удобнее смотреть.



/*
Отобразить все месяцы, где общая сумма продаж превысила 10 000 

Здесь есть ограничения, поэтому, так, как в первом случае, работать не будет, надо по другому, вроде )))
*/
SELECT 
     RD.InvoiceYear AS 'Год'
	 ,RD.InvoiceMonth AS 'Месяц'
	 ,ISNULL(AA.IL_Sum,0)	AS 'Сумма за месяц > 10000'
FROM  @RangaDate AS RD
LEFT JOIN 
		(SELECT 
			YEAR(I.InvoiceDate) AS I_Year
			,MONTH(I.InvoiceDate) AS I_Month
			,SUM(IL.UnitPrice*[Quantity]) AS IL_Sum
			FROM [Sales].[InvoiceLines] AS IL
		JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
		GROUP BY YEAR(I.InvoiceDate),MONTH(I.InvoiceDate)
		HAVING SUM(IL.UnitPrice*[Quantity]) > 10000
		) AS AA ON AA.I_Year = RD.InvoiceYear AND AA.I_Month = RD.InvoiceMonth
ORDER BY RD.InvoiceYear,RD.InvoiceMonth -- Про сортировку ничего не было сказано, но удобнее смотреть.



/*
Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи которых менее 50 ед в месяц. 
*/


SELECT 
     RD.InvoiceYear AS 'Год'
	 ,RD.InvoiceMonth AS 'Месяц'
	 ,ISNULL(AA.Item,'') AS 'Товар'
	 ,ISNULL(AA.MonthAmount,0)	AS 'Количество за месяц'
	 ,AA.FirstSaleDate AS 'Дата первой продажи'
	 ,ISNULL(AA.AllAmount,0) 'Сумма продаж'
FROM @RangaDate AS RD
LEFT JOIN (
			SELECT 
				[StockItemID] As Item
				 ,SUM([Quantity])	AS MonthAmount
				 ,MIN([InvoiceDate]) AS FirstSaleDate
				 ,SUM([Quantity] * [UnitPrice]) AS AllAmount
				 ,YEAR(I.InvoiceDate) AS SelYear
				 ,MONTH(I.InvoiceDate) AS SelMonth
			 FROM 
			[Sales].[InvoiceLines] AS IL
			JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID 
			GROUP BY YEAR(I.InvoiceDate), MONTH(I.InvoiceDate), [StockItemID]
			HAVING SUM([Quantity]) < 50
			) AS AA ON RD.InvoiceYear = AA.SelYear AND RD.InvoiceMonth = SelMonth
ORDER BY RD.InvoiceYear,RD.InvoiceMonth -- Про сортировку ничего не было сказано, но удобнее смотреть.

