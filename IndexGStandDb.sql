USE GStandDb

IF (OBJECT_ID(N'dbo.CreateIndexForTableField', N'P') IS NOT NULL)
BEGIN
	DROP PROC dbo.CreateIndexForTableField
END
GO

CREATE PROC dbo.CreateIndexForTableField (@Table AS nvarchar(MAX),
@Field AS nvarchar(MAX))
AS
BEGIN
	DECLARE @create nvarchar(max) = '
	IF NOT EXISTS (SELECT
			*
		FROM sys.indexes
		WHERE OBJECT_ID = OBJECT_ID(''@table'') AND sys.indexes.name = ''@index'')
	BEGIN
		CREATE INDEX @index ON @table (@field)
	END'
	DECLARE @index nvarchar(max) = 'IX_' + '_'  + @Field
	
	SET @create = REPLACE(@create, '@index', @index)
	SET @create = REPLACE(@create, '@table', @table)
	SET @create = REPLACE(@create, '@field', @field)
		
	EXEC sp_executesql @create

END
GO

EXEC dbo.CreateIndexForTableField 'BST020T_Namen', 'Naamnummer_NMNR'
EXEC dbo.CreateIndexForTableField 'BST902T_Thesauri_totaal', 'Thesaurus_itemnummer_in_nieuwe_thesauri_TSITNR'
EXEC dbo.CreateIndexForTableField 'BST750T_Generieke_namen', 'GeneriekeNaamKode_GNK_GNGNK'
EXEC dbo.CreateIndexForTableField 'BST711T_Generieke_producten', 'Generiekeproductcode_GPK_GPKODE'
EXEC dbo.CreateIndexForTableField 'BST050T_Voorschrijfproducten_PRK', 'PRK_code_PRKODE'
EXEC dbo.CreateIndexForTableField 'BST701T_Ingegeven_samenstellingen', 'HandelsProduktKode_HPK_HPKODE'
EXEC dbo.CreateIndexForTableField 'BST715T_Generieke_samenstellingen', 'GSK_code_GSKODE'
EXEC dbo.CreateIndexForTableField 'BST500T_Informatorium_groepen', 'Groepkode_GRPINP'
EXEC dbo.CreateIndexForTableField 'BST800T_ATCDDD_gegevens', 'ATC_code_ATCODE'

SELECT * FROM sys.indexes i WHERE SUBSTRING(i.name, 1, 3) = 'IX_'