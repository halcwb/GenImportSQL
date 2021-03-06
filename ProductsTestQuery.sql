

SELECT 
      IG.Groepnaam_GRPNAM,
	  Etiketnaam_NMETIK,
      Merkstamnaam_MSNAAM,
	  GN.Generieke_naam_GNGNAM
	  
  FROM [testdb2].[dbo].[Namen] 
  JOIN Artikelen A ON A.Artikelnaamnummer_ATNMNR = Namen.Naamnummer_NMNR
  JOIN Handelsproducten HP ON A.HandelsProduktKode_HPK_HPKODE = HP.HandelsProduktKode_HPK_HPKODE
  JOIN 
	Informatorium_groepen IG ON 
		IG.Groepkode_GRPINP = HP.FTK_1_GRP001 OR
		IG.Groepkode_GRPINP = HP.FTK_2_GRP002 OR
		IG.Groepkode_GRPINP = HP.FTK_3_GRP003 OR
		IG.Groepkode_GRPINP = HP.FTK_4_GRP004 OR
		IG.Groepkode_GRPINP = HP.FTK_5_GRP005
  JOIN Ingegeven_samenstellingen ingsamenst ON ingsamenst.HandelsProduktKode_HPK_HPKODE = HP.HandelsProduktKode_HPK_HPKODE 
  JOIN Generieke_namen GN on GN.GeneriekeNaamKode_GNK_GNGNK =  ingsamenst.GeneriekeNaamKode_GNK_GNGNK
	 WHERE HP.Merkstamnaam_MSNAAM LIKE '%Paracetamol%' AND ingsamenst.Hoeveelheid_werkzame_stof_GNMINH != '000000000000'
	 ORDER BY IG.Groepnaam_GRPNAM, Etiketnaam_NMETIK, Merkstamnaam_MSNAAM
	 
  