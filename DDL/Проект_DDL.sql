﻿/*
Модель реализации нефтепродуктов.
Конечно же упрощённо.
Есть н/б, которая с которой происходит реализация наливных н/п(фасовку не рассматриваем). 

Справочник н/п.
справочник резервуаров.
Справочник клиентов/Своих АЗС
Справочник бензовозов.
Приход нефтепродуктов ж/д цистернами.
Отгрузка н/п клиентам и на АЗС бензовозами. - Накладные (Orders ) по отпуску н/п

Справочник сотрудников.
Смены по датам и сотрудники

*/

CREATE TABLE dbo.refNP
(NPID int IDENTITY(1,1) PRIMARY KEY,
CodeNP int NOT NULL, -- Код н/п пользоватеьский. можно, есс-но пользовать id, но для связки с дргими системами, думается, так лучше.
NameNP Varchar(50)
) -- Вроде в реале есть ещё код вида н/п - масла, светлые(лёгкие) бензины, тёмные(тяжёлые) (д/т летнее, д/т зимнее) и пр...
GO
-- Чувство, что или NPID или CodeNP лишний, присутствует (


-- DROP TABLE dbo.refNP
-- Предполагается, что программа создаёт номер смены, и вручную проставляется дата начала и дата завершения смены. На всякий случай есть default 

CREATE TABLE dbo.Shifts
(
ShiftID int IDENTITY(1,1) PRIMARY KEY,
BeginDate datetime NOT NULL DEFAULT getdate(),
EndDate datetime NOT NULL DEFAULT DATEADD(hh,12,GETDATE()) 
) 
GO
-- DROP TABLE dbo.Shifts

-- Справочник резервуаров.
CREATE TABLE dbo.refReservoir
(
refResID int IDENTITY (1,1) PRIMARY KEY
,MinVolume int -- минимальный объём заполнения, меньше нельзя. В реале - отметка в см(мм), ниже которой н/п уже не берётся, но тогда надо ещё и градуировочные таблицы цеплять.
,MaxVolume int -- максимальный объём заполнения. 
--,[Status] tinyint NOT NULL Default 0 -- . bit недостаточно  - для учёта может быть несколько состояний, пусть 1 - в работе
)
-- DROP TABLE  dbo.refReservoir

-- По идее, код н/п обсуждаем, в любой резервуар можно наливать любой н/п, если резервуар пока пустой.
-- Но после того, как в р-ре появился н/п, смешивать нельзя, кроме того, после того, как р-р освободится, необходимо проводить 
-- некоторые регламентные процедуры, прежде чем заливать другой н/п, поэтому темпоральная таблица.
-- RO - плотность
-- MarkTime - время замера плотности
-- Ранее (может и сейчас) была такая проблема учёта н/п: Легко можно замерить уровень н/п в резервуаре, цистерне, бензовозе(ну, не совсем точно))), 
-- по градуирвочной таблице узнать объём, 
-- измерить плотность и высчитать массу. Хитрость в том, что всегда бензовозы отпускали в объёмах, цистерны принимались тоже в объёмах - на основании 
-- измеренной плотности вычислялась масса и именно масса являлась основанием для денежных расчётов. И тут такая была масса вариантов ))))
-- Плотность ведь зависит от температуры.... А у измерений всегда есть погрешность...
-- А вот массу н/п, которая не зависит от температуры, измерить нельзя(тогда, не знаю, как сейчас, думаю, так и осталось).


CREATE TABLE dbo.Reservoir
(
ResevoirId int IDENTITY(1,1) PRIMARY KEY
NpID int
--,MinVolume int -- минимальный объём заполнения, меньше нельзя. В реале - отметка в см(мм), ниже которой н/п уже не берётся, но тогда надо ещё и градуировочные таблицы цеплять.
,CurrenVolume decimal(22,2) -- максимальный объём заполнения. 
,[Status] tinyint NOT NULL Default 0 -- . bit недостаточно  - для учёта может быть несколько состояний, пусть 1 - в работе
, SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL  
, SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL  
, RO decimal(10,6)
, MarkTime datetime 
, PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)     
)
WITH
(
	SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ReservoirHistory)
)
-- DROP TABLE dbo.Reservoir
ALTER TABLE  dbo.Reservoir
ADD CONSTRAINT FK_Reservoir_NpID FOREIGN KEY (NpID)
	REFERENCES dbo.RefNP (NpID) 



