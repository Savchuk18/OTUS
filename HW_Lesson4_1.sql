/*

*/
-- ��������� ������ � WHERE, ������ 0, �.�., ��� �����������, � ������� ��� ������...
   SELECT DISTINCT P.FullName
  FROM [Application].[People] AS P
  WHERE P.IsSalesperson=1 AND  NOT Exists  (SELECT 1 from [Sales].[Orders] AS O WHERE O.SalespersonPersonID = P.PersonID   )


-- � WITH �� �� �����  
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

  
  

  -- ��������, ������ �� ���� 0? �.�., � ���� �� ����������� ���� �������?
    SELECT DISTINCT 
	P.IsSalesperson
	,P.FullName
  FROM [Sales].[Orders] AS O
  JOIN [Application].[People] AS P ON P.PersonID = O.SalespersonPersonID
-- ��������� 10 ����� (�����, �������, ���� ������ ���������, ��� � ��������� �������), �.�., 10 ������� ���������, � ������� �����������?  
  SELECT COUNT(*)
  FROM [Application].[People]
  WHERE IsSalesperson=1
  -- ��������� 10, ������, ����� ����������� 10, �, ������ �����, ��������� ���������� (���� � ��������� �� ������)
