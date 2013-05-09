USE GenImport

IF (OBJECT_ID(N'dbo.GenericProduct', N'U') IS NOT NULL)
BEGIN
	DROP TABLE dbo.GenericProduct
END
GO

IF (OBJECT_ID(N'dbo.GenericShapeRoute', N'U') IS NOT NULL)
BEGIN
	DROP TABLE dbo.GenericShapeRoute
END
GO

IF (OBJECT_ID(N'dbo.GroupGenericProduct', N'U') IS NOT NULL)
BEGIN
	DROP TABLE dbo.GroupGenericProduct
END
GO

IF (OBJECT_ID(N'dbo.TherapyGroup', N'U') IS NOT NULL)
BEGIN
	DROP TABLE dbo.TherapyGroup
END
GO

IF (OBJECT_ID(N'dbo.GenericSubstance', N'U') IS NOT NULL)
BEGIN
	DROP TABLE dbo.GenericSubstance
END
GO

IF (OBJECT_ID(N'dbo.ShapeRoute', N'U') IS NOT NULL)
BEGIN
	DROP TABLE dbo.ShapeRoute
END
GO


SELECT DISTINCT
	gd.GroupCode,
	gd.GroupName INTO dbo.TherapyGroup
FROM dbo.GStandDb gd

ALTER TABLE dbo.TherapyGroup ALTER COLUMN
GroupCode varchar(4) NOT NULL
GO

ALTER TABLE dbo.TherapyGroup
ADD CONSTRAINT PK_TherapyGroup PRIMARY KEY (GroupCode)
GO

SELECT
	*
FROM dbo.TherapyGroup tg

SELECT DISTINCT
	gd.GNK,
	gd.GenericLong,
	gd.GenericShort INTO GenericSubstance
FROM GStandDb gd

ALTER TABLE dbo.GenericSubstance ALTER COLUMN
GNK varchar(6) NOT NULL
GO

ALTER TABLE dbo.GenericSubstance
ADD CONSTRAINT PK_GenericSubstance PRIMARY KEY (GNK)
GO

SELECT
	*
FROM GenericSubstance gs



SELECT DISTINCT
	gd.ShapeId,
	gd.Shape,
	gd.RouteId,
	gd.[Route] INTO ShapeRoute
FROM GStandDb gd

ALTER TABLE dbo.ShapeRoute ALTER COLUMN
ShapeId varchar(3) NOT NULL
GO

ALTER TABLE dbo.ShapeRoute ALTER COLUMN
RouteId varchar(3) NOT NULL
GO

ALTER TABLE dbo.ShapeRoute
ADD CONSTRAINT PK_ShapeRoute PRIMARY KEY (ShapeId, RouteId)
GO


SELECT DISTINCT
	gd.GNK,
	gd.ShapeId,
	gd.RouteId INTO GenericShapeRoute
FROM GStandDb gd

ALTER TABLE dbo.GenericShapeRoute ALTER COLUMN
ShapeId varchar(3) NOT NULL
GO

ALTER TABLE dbo.GenericShapeRoute ALTER COLUMN
RouteId varchar(3) NOT NULL
GO

ALTER TABLE dbo.GenericShapeRoute ALTER COLUMN
GNK varchar(6) NOT NULL
GO

ALTER TABLE dbo.GenericShapeRoute
ADD CONSTRAINT PK_GenericShapeRoute PRIMARY KEY (GNK,ShapeId, RouteId)
GO

ALTER TABLE dbo.GenericShapeRoute
ADD CONSTRAINT FK_ShapeRoute FOREIGN KEY (ShapeId, RouteId) REFERENCES ShapeRoute (ShapeId, RouteId)
GO

ALTER TABLE dbo.GenericShapeRoute
ADD CONSTRAINT FK_GenericSubstance FOREIGN KEY (GNK) REFERENCES GenericSubstance (GNK)
GO

SELECT DISTINCT
	gd.GPK,
	gd.GNK,
	gd.ShapeId,
	gd.RouteId,
	gd.GenericProductName
INTO GenericProduct
FROM GStandDb gd

ALTER TABLE dbo.GenericProduct ALTER COLUMN
GPK varchar(8) NOT NULL
GO
ALTER TABLE dbo.GenericProduct ALTER COLUMN
GNK varchar(6) NOT NULL
GO

ALTER TABLE dbo.GenericProduct
ADD CONSTRAINT PK_GenericProduct PRIMARY KEY (GPK, GNK)
GO

ALTER TABLE dbo.GenericProduct
ADD CONSTRAINT FK_GenericShapeRoute FOREIGN KEY (GNK, ShapeId, RouteId) REFERENCES GenericShapeRoute (GNK, ShapeId, RouteId)
GO

SELECT DISTINCT
	gd.GPK,
	gd.GNK,
	gd.GroupCode INTO GroupGenericProduct
FROM GStandDb gd

ALTER TABLE dbo.GroupGenericProduct ALTER COLUMN
GPK varchar(8) NOT NULL
GO

ALTER TABLE dbo.GroupGenericProduct ALTER COLUMN
GNK varchar(6) NOT NULL
GO

ALTER TABLE dbo.GroupGenericProduct ALTER COLUMN
GroupCode varchar(4) NOT NULL
GO

ALTER TABLE dbo.GroupGenericProduct
ADD CONSTRAINT PK_GroupGeneric PRIMARY KEY (GPK, GNK, GroupCode)
GO

ALTER TABLE dbo.GroupGenericProduct
ADD CONSTRAINT FK_Group FOREIGN KEY (GroupCode) REFERENCES TherapyGroup (GroupCode)
GO

ALTER TABLE dbo.GroupGenericProduct
ADD CONSTRAINT FK_GenericProduct FOREIGN KEY (GPK, GNK) REFERENCES GenericProduct (GPK, GNK)
GO

SELECT
	*
FROM GroupGenericProduct ggp

