SELECT TOP 10
  RTRIM(IG.Groepnaam_GRPNAM) GroepNaam,

  (SELECT TOP 5 RTRIM(GN.Generieke_naam_GNGNAM)
	
	FROM Namen
	JOIN Artikelen A ON A.Artikelnaamnummer_ATNMNR = Namen.Naamnummer_NMNR
	JOIN Handelsproducten HP ON A.HandelsProduktKode_HPK_HPKODE = HP.HandelsProduktKode_HPK_HPKODE
	JOIN Ingegeven_samenstellingen ingsamenst ON ingsamenst.HandelsProduktKode_HPK_HPKODE = HP.HandelsProduktKode_HPK_HPKODE 
	JOIN Generieke_namen GN on GN.GeneriekeNaamKode_GNK_GNGNK =  ingsamenst.GeneriekeNaamKode_GNK_GNGNK
	WHERE 
		 HP.FTK_1_GRP001 = IG.Groepkode_GRPINP OR
		 HP.FTK_2_GRP002 = IG.Groepkode_GRPINP OR
		 HP.FTK_3_GRP003 = IG.Groepkode_GRPINP OR
		 HP.FTK_4_GRP004 = IG.Groepkode_GRPINP OR
		 HP.FTK_5_GRP005 = IG.Groepkode_GRPINP 
    FOR XML PATH('Generieken'), TYPE)

  FROM  Informatorium_groepen IG 

  FOR XML PATH('InformatoriumGroepen'), ROOT('XMLFormularium')