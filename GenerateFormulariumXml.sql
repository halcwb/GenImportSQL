SELECT  top 3 IG.Naam,

  (SELECT 
	Naam,
	
	(SELECT 
		*/*,
		(SELECT * FROM Products(SR.GPKCode) FOR XML PATH('Products'), TYPE)*/
		
		FROM ShapeRoute(G.Code) SR FOR XML PATH('ShapeRoute'), TYPE)
	
	FROM Generiek(IG.Groepkode_GRPINP) G
    FOR XML PATH('Generiek'), ROOT('Generieken'), TYPE)

  FROM  InformatoriumGroep IG 

  FOR XML PATH('InformatoriumGroep'), ROOT('XMLFormularium')