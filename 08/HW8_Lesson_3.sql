/*
3. В таблице стран есть поля с кодом страны цифровым и буквенным
сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
Пример выдачи

CountryId	CountryName	Code
1	Afghanistan	AFG
1	Afghanistan	4
3	Albania	ALB
3	Albania	8

*/
-- Первый вариант
SELECT [CountryName],Codes.IsoAlpha3Code AS Code
FROM [Application].[Countries] AS C
CROSS APPLY (
				SELECT [IsoAlpha3Code] FROM [Application].[Countries] AS C1 WHERE C1.CountryID = C.CountryID
				UNION ALL
				SELECT CAST([IsoNumericCode] as varchar(3)) FROM [Application].[Countries] AS C2 WHERE C2.CountryID = C.CountryID
			) AS COdes
ORDER BY [CountryName]--, Code

-- Вариант с UNPIVOT

;WITH ForUnPivot (CountryName, AlphaCode, NumericCode)
AS
(
	SELECT CountryName, [IsoAlpha3Code], CAST(IsoNumericCode AS nvarchar(3))
	FROM [Application].[Countries]
)
SELECT CountryName, Code 
FROM ForUnPivot
UNPIVOT (Code FOR ValueSelect IN (AlphaCode, NumericCode) ) AS Unp
