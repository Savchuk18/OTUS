DECLARE @t varchar(500);
SET @t = N'Массовая доля белка, %:10 | Массовая доля сырой клейковины, %:18 | Число падения, секунды:220 | Стекловидность, %:38 | Влажность, %:12,5 | Сорная примесь, %:2 | Натура, грамм/литр:745 | Зерновая примесь, %:3 | Класс:4 | Тип пшеницы:Y яровая | Год урожая:2016 | Регион произрастания:22. Алтайский край | Качество сырой клейковины, единицы прибора ИДК, единицы:80';
SET @t = @t + '|'

;WITH SpiTable (Cli,Ass,Attr,Value,NewT)
AS
(
	SELECT 1,2,SUBSTRING(@t,1,CHARINDEX(':',@t)-1), SUBSTRING(@t,CHARINDEX(':',@t)+1,CHARINDEX('|',@t)-CHARINDEX(':',@t)-1),
			SUBSTRING(@t,CHARINDEX('|',@t)+1,LEN(@t) - CHARINDEX('|',@t)) AS NewT
	UNION ALL
	SELECT 1,2,SUBSTRING(NewT,1,CHARINDEX(':',NewT)-1), SUBSTRING(NewT,CHARINDEX(':',NewT)+1,CHARINDEX('|',NewT)-CHARINDEX(':',NewT)-1),
			SUBSTRING(NewT,CHARINDEX('|',NewT)+1,LEN(NewT) - CHARINDEX('|',NewT)) AS NewT FROM SpiTable
	WHERE LEN(NEWT) > 1
)
SELECT * FROM SpiTable
