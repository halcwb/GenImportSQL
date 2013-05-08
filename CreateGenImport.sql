USE GenImport

IF (OBJECT_ID(N'dbo.GStandDb', N'U') IS NOT NULL)
BEGIN
	DROP TABLE dbo.GStandDb
END
GO

IF (OBJECT_ID(N'dbo.GenericProduct', N'U') IS NOT NULL)
BEGIN
	DROP TABLE dbo.GenericProduct
END
GO

IF OBJECT_ID(N'dbo.GetTerm', N'FN') IS NOT NULL
	DROP FUNCTION dbo.GetTerm
GO

IF OBJECT_ID(N'dbo.GetRoute', N'FN') IS NOT NULL
	DROP FUNCTION dbo.GetRoute
GO

IF OBJECT_ID(N'dbo.GetShape', N'FN') IS NOT NULL
	DROP FUNCTION dbo.GetShape
GO

IF OBJECT_ID(N'dbo.GetUnit', N'FN') IS NOT NULL
	DROP FUNCTION dbo.GetUnit
GO

IF (OBJECT_ID(N'dbo.GetName', N'FN') IS NOT NULL)
BEGIN
	DROP FUNCTION dbo.GetName
END
GO


CREATE FUNCTION dbo.GetTerm (@Code varchar(3), @Type varchar(3))
RETURNS nvarchar(50)
AS
BEGIN
	DECLARE @Term nvarchar(MAX)
	SELECT TOP 1
		@Term = bttt.Naam_item_50_posities_THNM50
	FROM GStandDb.dbo.BST902T_Thesauri_totaal bttt
	WHERE SUBSTRING(bttt.Thesaurus_itemnummer_in_nieuwe_thesauri_TSITNR, 4, 3) = @Code AND
	SUBSTRING(bttt.Thesaurusnummer_in_nieuwe_thesauri_TSNR, 2, 3) = @Type

	RETURN @Term
END
GO

CREATE FUNCTION dbo.GetName (@NMNR varchar(7))
RETURNS nvarchar(50)
AS
BEGIN
	DECLARE @Name nvarchar(MAX)
	SELECT TOP 1
		@Name = btn.Naam_volledig_NMNAAM
	FROM GStandDb.dbo.BST020T_Namen btn
	WHERE btn.Naamnummer_NMNR = @NMNR

	RETURN @Name
END
GO


CREATE FUNCTION dbo.GetRoute (@RouteCode varchar(3))
RETURNS nvarchar(50)
AS
BEGIN
	RETURN dbo.GetTerm(@RouteCode, '007')
END
GO

CREATE FUNCTION dbo.GetShape (@ShapeCode varchar(3))
RETURNS nvarchar(50)
AS
BEGIN
	RETURN dbo.GetTerm(@ShapeCode, '006')
END
GO

CREATE FUNCTION dbo.GetUnit (@UnitCode varchar(3))
RETURNS nvarchar(50)
AS
BEGIN
	RETURN dbo.GetTerm(@UnitCode, '001')
END
GO

-- Create table with generic products
SELECT DISTINCT
	btig.Groepkode_GRPINP GroupCode,
	btig.Groepnaam_GRPNAM GroupName,
	btgn.GeneriekeNaamKode_GNK_GNGNK GNK,
	btgn.Generieke_naam_GNGNAM GenericLong,
	(SELECT TOP 1
		btgn1.Generieke_naam_GNGNAM
	FROM GStandDb.dbo.BST750T_Generieke_namen btgn1
	WHERE btgn.Stamnaamcode_SNK_GNSTAM = btgn1.GeneriekeNaamKode_GNK_GNGNK)
	GenericShort,
	CAST(btis.Hoeveelheid_werkzame_stof_GNMINH AS float) / 1000 GenericQty,
	dbo.GetUnit(btis.Eenhhoeveelheid_werkzame_stof_kode_XNMINE) GenericUnit,
	dbo.GetUnit(btgs.Basiseenheid_product_kode_XPEHHV) ShapeUnit,
	btgp.Ingegeven_sterkte_stofnamen_GPINST GenericConc,
	btgp.Generiekeproductcode_GPK_GPKODE GPK,
	dbo.GetName(btgp.Naamnummer_volledige_GPK_naam_GPNMNR) GenericProductName,
	btgp.Farmaceutische_vorm_code_GPKTVR ShapeId,
	dbo.GetShape(btgp.Farmaceutische_vorm_code_GPKTVR) Shape,
	btgp.Toedieningsweg_code_GPKTWG RouteId,
	dbo.GetRoute(btgp.Toedieningsweg_code_GPKTWG) [Route],
	btvgi.PRK_code_PRKODE PRK,
	CAST(btvgi.HPK_grootte_algemeen_HPGALG AS float) / 100 PrescriptionQty,
	dbo.GetName(btvp.Naamnummer_prescriptie_product_PRNMNR) PrescriptionName

INTO dbo.GStandDb
FROM GStandDb.dbo.BST711T_Generieke_producten btgp
JOIN GStandDb.dbo.BST715T_Generieke_samenstellingen btgs
	ON btgs.GSK_code_GSKODE = btgp.GSK_code_GSKODE AND btgs.Aanduiding_werkzaamhulpstof_WH_GNMWHS = 'W'
JOIN GStandDb.dbo.BST051T_Voorschrijfpr_geneesmiddel_identific btvgi
	ON btgp.Generiekeproductcode_GPK_GPKODE = btvgi.Generiekeproductcode_GPK_GPKODE
JOIN GStandDb.dbo.BST050T_Voorschrijfproducten_PRK btvp
	ON btvgi.PRK_code_PRKODE = btvp.PRK_code_PRKODE
JOIN GStandDb.dbo.BST031T_Handelsproducten bth
	ON bth.PRK_code_PRKODE = btvp.PRK_code_PRKODE
JOIN GStandDb.dbo.BST701T_Ingegeven_samenstellingen btis
	ON bth.HandelsProduktKode_HPK_HPKODE = btis.HandelsProduktKode_HPK_HPKODE AND btis.Aanduiding_werkzaamhulpstof_WH_GNMWHS = 'W'
JOIN GStandDb.dbo.BST750T_Generieke_namen btgn
	ON btis.GeneriekeNaamKode_GNK_GNGNK = btgn.GeneriekeNaamKode_GNK_GNGNK
JOIN GStandDb.dbo.BST500T_Informatorium_groepen btig
	ON (bth.FTK_1_GRP001 = btig.Groepkode_GRPINP OR
	bth.FTK_2_GRP002 = btig.Groepkode_GRPINP OR
	bth.FTK_3_GRP003 = btig.Groepkode_GRPINP OR
	bth.FTK_4_GRP004 = btig.Groepkode_GRPINP OR
	bth.FTK_5_GRP005 = btig.Groepkode_GRPINP)

WHERE btgp.Mutatiekode_MUTKOD != '1' AND
btis.Mutatiekode_MUTKOD != '1' AND
btgn.Mutatiekode_MUTKOD != '1' AND
btvp.Mutatiekode_MUTKOD != '1' AND
btig.Mutatiekode_MUTKOD != '1' AND
bth.Mutatiekode_MUTKOD != '1'
AND NOT dbo.GetShape(btgp.Farmaceutische_vorm_code_GPKTVR) = 'NIET VAN TOEPASSING'
ORDER BY GPK




--ALTER TABLE dbo.GenericProduct
--ALTER COLUMN ID varchar(8) NOT NULL

--ALTER TABLE dbo.GenericProduct WITH CHECK ADD CONSTRAINT PK__GenericProduct_ID
--PRIMARY KEY (ID)

--SELECT
--	*
--FROM dbo.GenericProduct gp