
IF(OBJECT_ID('InformatoriumGroep') IS NOT NULL) 
BEGIN
  DROP VIEW InformatoriumGroep
END
GO
CREATE VIEW InformatoriumGroep AS
SELECT IG.Groepnaam_GRPNAM Naam, Groepkode_GRPINP
FROM BST500T_Informatorium_groepen IG
WHERE IG.Mutatiekode_MUTKOD != 1

GO

IF(OBJECT_ID('Generiek') IS NOT NULL) 
BEGIN
  DROP FUNCTION Generiek
END
GO

CREATE FUNCTION Generiek (@GroepKode nvarchar(4)) 
RETURNS TABLE
AS 
RETURN (SELECT Generieke_naam_GNGNAM Naam, GeneriekeNaamKode_GNK_GNGNK Code
FROM BST750T_Generieke_namen GNGNK
JOIN BST715T_Generieke_samenstellingen GSK ON GSK.Volledige_generieke_naam_kode_GNNKPK = GNGNK.GeneriekeNaamKode_GNK_GNGNK AND GSK.Mutatiekode_MUTKOD != '1' 
JOIN BST711T_Generieke_producten GPK ON GPK.GSK_code_GSKODE = GSK.GSK_code_GSKODE AND Aanduiding_werkzaamhulpstof_WH_GNMWHS = 'W' AND GPK.Mutatiekode_MUTKOD != '1' 

JOIN BST051T_Voorschrijfpr_geneesmiddel_identific PRK ON PRK.Generiekeproductcode_GPK_GPKODE = GPK.Generiekeproductcode_GPK_GPKODE AND PRK.Mutatiekode_MUTKOD != '1' 
JOIN BST031T_Handelsproducten HPK on HPK.PRK_code_PRKODE = PRK.PRK_code_PRKODE AND HPK.Mutatiekode_MUTKOD != '1' 
JOIN BST004T_Artikelen ATK ON ATK.HandelsProduktKode_HPK_HPKODE = HPK.HandelsProduktKode_HPK_HPKODE AND ATK.Mutatiekode_MUTKOD != '1' 

JOIN BST020T_Namen Namen ON ATK.Artikelnaamnummer_ATNMNR = Namen.Naamnummer_NMNR AND Namen.Mutatiekode_MUTKOD != '1' 
WHERE
GNGNK.Mutatiekode_MUTKOD != '1' 

AND (
HPK.FTK_1_GRP001 = @GroepKode OR
HPK.FTK_2_GRP002 = @GroepKode OR
HPK.FTK_3_GRP003 = @GroepKode OR
HPK.FTK_4_GRP004 = @GroepKode OR
HPK.FTK_5_GRP005 = @GroepKode))
GO
IF(OBJECT_ID('ShapeRoute') IS NOT NULL) 
BEGIN
  DROP FUNCTION ShapeRoute
END
GO
CREATE FUNCTION ShapeRoute (@GeneriekCode nvarchar(6)) 
RETURNS TABLE
AS 
RETURN (
SELECT 

	DISTINCT 
		bsttt.Naam_item_50_posities_THNM50 RouteNaam, GPKVorm.Generiekeproductcode_GPK_GPKODE GPKCode,

		(SELECT top 1 bsttt.Naam_item_50_posities_THNM50 VormNaam
			FROM BST902T_Thesauri_totaal bsttt
			JOIN BST711T_Generieke_producten GPKRoute ON SUBSTRING(bsttt.Thesaurus_itemnummer_in_nieuwe_thesauri_TSITNR, 4 ,3) = GPKVorm.Toedieningsweg_code_GPKTWG AND GPKVorm.Generiekeproductcode_GPK_GPKODE=GPKRoute.Generiekeproductcode_GPK_GPKODE AND SUBSTRING(bsttt.Thesaurusnummer_in_nieuwe_thesauri_TSNR, 2, 3) = '007'
		) AS ShapeNaam

FROM 
BST902T_Thesauri_totaal bsttt
JOIN BST711T_Generieke_producten GPKVorm ON SUBSTRING(bsttt.Thesaurus_itemnummer_in_nieuwe_thesauri_TSITNR, 4 ,3) = GPKVorm.Farmaceutische_vorm_code_GPKTVR AND SUBSTRING(bsttt.Thesaurusnummer_in_nieuwe_thesauri_TSNR, 2, 3) = '006'
JOIN BST715T_Generieke_samenstellingen GSK ON GPKVorm.GSK_code_GSKODE = GSK.GSK_code_GSKODE AND Aanduiding_werkzaamhulpstof_WH_GNMWHS = 'W'
JOIN BST750T_Generieke_namen GNGNK ON GSK.Volledige_generieke_naam_kode_GNNKPK = GNGNK.GeneriekeNaamKode_GNK_GNGNK AND GNGNK.GeneriekeNaamKode_GNK_GNGNK = @GeneriekCode
WHERE bsttt.Mutatiekode_MUTKOD != '1' AND GSK.Mutatiekode_MUTKOD != '1' AND GNGNK.Mutatiekode_MUTKOD != '1'
)
GO
IF(OBJECT_ID('Products') IS NOT NULL) 
BEGIN
  DROP FUNCTION Products
END
GO
CREATE FUNCTION Products (@GPKCode nvarchar(6)) 
RETURNS TABLE
AS 
RETURN (
SELECT DISTINCT Namen.Naam_volledig_NMNAAM FROM 
BST020T_Namen Namen
JOIN BST051T_Voorschrijfpr_geneesmiddel_identific PRK ON PRK.Generiekeproductcode_GPK_GPKODE = @GPKCode AND PRK.Mutatiekode_MUTKOD != '1' 
JOIN BST031T_Handelsproducten HPK on HPK.PRK_code_PRKODE = PRK.PRK_code_PRKODE AND HPK.Mutatiekode_MUTKOD != '1' 
JOIN BST004T_Artikelen ATK ON ATK.HandelsProduktKode_HPK_HPKODE = HPK.HandelsProduktKode_HPK_HPKODE AND ATK.Mutatiekode_MUTKOD != '1' 
)
GO
--CREATE INDEX PRK_code_PRKODE ON BST031T_Handelsproducten (PRK_code_PRKODE)
--CREATE INDEX Generiekeproductcode_GPK_GPKODE ON BST051T_Voorschrijfpr_geneesmiddel_identific (Generiekeproductcode_GPK_GPKODE)
--CREATE INDEX PRK_code_PRKODE ON BST031T_Handelsproducten (PRK_code_PRKODE)
--CREATE INDEX HandelsProduktKode_HPK_HPKODE ON BST004T_Artikelen (HandelsProduktKode_HPK_HPKODE)
