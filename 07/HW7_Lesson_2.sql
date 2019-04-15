/*
2. Написать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную
Дано :
CREATE TABLE dbo.MyEmployees 
( 
EmployeeID smallint NOT NULL, 
FirstName nvarchar(30) NOT NULL, 
LastName nvarchar(40) NOT NULL, 
Title nvarchar(50) NOT NULL, 
DeptID smallint NOT NULL, 
ManagerID int NULL, 
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
); 
INSERT INTO dbo.MyEmployees VALUES 
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL) 
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1) 
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273) 
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274) 
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274) 
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273) 
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285) 
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273) 
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16); 

Результат вывода рекурсивного CTE:
EmployeeID Name Title EmployeeLevel
1	Ken Sánchez	Chief Executive Officer	1
273	| Brian Welcker	Vice President of Sales	2
16	| | David Bradley	Marketing Manager	3
23	| | | Mary Gibson	Marketing Specialist	4
274	| | Stephen Jiang	North American Sales Manager	3
276	| | | Linda Mitchell	Sales Representative	4
275	| | | Michael Blythe	Sales Representative	4
285	| | Syed Abbas	Pacific Sales Manager	3
286	| | | Lynn Tsoflias	Sales Representative	4
*/


-- Демонстрация рекурсивного вывода дерева
;WITH EmpN (EmployeedID, EmployeedName, Title, DeptID, ManagerID, LevelRank)
AS
	(
	SELECT
		[EmployeeID]
		,CONCAT([FirstName], ' ',  [LastName]) AS EmployeedName
		,[Title]
		,[DeptID]
		,ManagerID
		,ROW_NUMBER() OVER(PARTITION BY ManagerID ORDER BY CONCAT([FirstName], ' ',  [LastName])) AS LevelRank
	FROM [dbo].[MyEmployees]
	)
	,
	EmpTree 
	AS
		(
		SELECT [EmployeeID]
			,CONCAT([FirstName], ' ',  [LastName]) AS EmployeedName
			,[Title]
			,[DeptID]
			, 0 AS Level
			,CAST(0x AS VARBINARY(MAX)) AS treesort
		FROM  [dbo].[MyEmployees] WHERE ManagerID is Null
	UNION ALL

	SELECT E.EmployeedID
		,E.EmployeedName
		,E.Title
		,E.DeptID
		,T.[Level] + 1
		,T.treesort + CAST(LevelRank AS VARBINARY(MAX))
	FROM EmpTree AS T
	JOIN EmpN AS E ON E.ManagerID = T.EmployeeID
)
SELECT EmployeeID, -- Результат рекурсивного запроса
	REPLICATE(' | ',[Level]) +' ' + EmployeedName  AS [Name] -- [Tree]
	,Title
	,[Level] + 1 AS EmployeeLevel  -- Не думаю, что принципиально + 1
	--,ROW_Number() OVER(order by treesort) AS RN
	FROM EmpTree order by treesort

-- Заполнение табличной переменной и временной таблицей результатом CTE запроса
DECLARE @EmpEmployeedTree TABLE (EmployedId int, [Name]varchar(256), Title varchar(256), EmployeeLevel int,EmployeeLevelTree int );

;WITH EmpN (EmployeedID, EmployeedName, Title, DeptID, ManagerID, LevelRank)
AS
	(
	SELECT
		[EmployeeID]
		,CONCAT([FirstName], ' ',  [LastName]) AS EmployeedName
		,[Title]
		,[DeptID]
		,ManagerID
		,ROW_NUMBER() OVER(PARTITION BY ManagerID ORDER BY CONCAT([FirstName], ' ',  [LastName])) AS LevelRank
	FROM [dbo].[MyEmployees]
	)
	,
	EmpTree 
	AS
	(
	SELECT [EmployeeID]
		,CONCAT([FirstName], ' ',  [LastName]) AS EmployeedName
		,[Title]
		,[DeptID]
		,0 AS Level
		,CAST(0x AS VARBINARY(MAX)) AS treesort
	FROM  [dbo].[MyEmployees] WHERE ManagerID is Null
	UNION ALL

	SELECT E.EmployeedID
		,E.EmployeedName
		,E.Title
		,E.DeptID
		,T.[Level] + 1
		,T.treesort + CAST(LevelRank AS VARBINARY(MAX))
	FROM EmpTree AS T
	JOIN EmpN AS E ON E.ManagerID = T.EmployeeID
)

INSERT INTO @EmpEmployeedTree
	(EmployedId
	,[Name]
	,Title
	,EmployeeLevel,
	EmployeeLevelTree 
	)
	SELECT EmployeeID,
		REPLICATE(' | ',[Level]) +' ' + EmployeedName  AS [Name] -- [Tree]
		,Title
		,[Level] + 1 AS EmployeeLevel  -- Не думаю, что принципиально + 1
		,ROW_Number() OVER(order by treesort) AS RN -- вывод же в любом случае недетерминирован, чтобы "ветки не перепутались" 
	FROM EmpTree

	SELECT * FROM @EmpEmployeedTree ORDER BY EmployeeLevelTree -- Демонстрация табличной переменной

-- Чтобы не гонять 2-ой раз тот же запрос, перенесём данные из табличной переменной во временную таблицу.
IF OBJECT_ID('tempdb..#EmpEmployeedTree') IS NOT NULL
    DROP TABLE #EmpEmployeedTree
CREATE TABLE #EmpEmployeedTree  (EmployedId int, [Name]varchar(256), Title varchar(256), EmployeeLevel int,EmployeeLevelTree int );

INSERT INTO	#EmpEmployeedTree  
	(EmployedId
	,[Name]
	,Title
	,EmployeeLevel
	,EmployeeLevelTree
	)
	SELECT 
		EmployedId
		,[Name]
		,Title
		,EmployeeLevel,
		EmployeeLevelTree 
	FROM  @EmpEmployeedTree
	
	SELECT * FROM #EmpEmployeedTree   ORDER BY EmployeeLevelTree -- Демонстрация временной таблицы