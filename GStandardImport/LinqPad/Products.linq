<Query Kind="Statements">
  <Connection>
    <ID>2d2999d2-2313-4d9a-bf8e-cfdb5ff9d517</ID>
    <Server>hal-windows7</Server>
    <Database>GStandDb</Database>
    <NoPluralization>true</NoPluralization>
  </Connection>
</Query>

var products = from gpk in BST711T_Generieke_producten 
			   join gst in BST715T_Generieke_samenstellingen.Where (bsttg => bsttg.Aanduiding_werkzaamhulpstof_WH_GNMWHS == "W") on new { gpk.GSK_code_GSKODE } equals new { gst.GSK_code_GSKODE } 
			   join gnn in BST750T_Generieke_namen on new { gst.Volledige_generieke_naam_kode_GNNKPK } equals new { gnn.Volledige_generieke_naam_kode_GNNKPK } 
			   
			   where gpk.Mutatiekode_MUTKOD != "1" && gst.Mutatiekode_MUTKOD != "1" && gnn.Mutatiekode_MUTKOD != "1"
			   group gnn by new { gpk.Generiekeproductcode_GPK_GPKODE, gnn.Generieke_naam_GNGNAM, gpk.Farmaceutische_vorm_code_GPKTVR, gpk.Toedieningsweg_code_GPKTWG } into generic
			   select new { 
					Generic = generic.Key.Generieke_naam_GNGNAM, 
					Shape = BST902T_Thesauri_totaal.Where(bsttt => bsttt.Thesaurus_itemnummer_in_nieuwe_thesauri_TSITNR.Substring(3,3) == generic.Key.Farmaceutische_vorm_code_GPKTVR && 
					                                      bsttt.Thesaurusnummer_in_nieuwe_thesauri_TSNR.Substring(1,3) == "006")
						    .Select (bsttt => bsttt.Naam_item_50_posities_THNM50.Trim()),
					Route = BST902T_Thesauri_totaal.Where(bsttt => bsttt.Thesaurus_itemnummer_in_nieuwe_thesauri_TSITNR.Substring(3,3) == generic.Key.Toedieningsweg_code_GPKTWG && 
					                                      bsttt.Thesaurusnummer_in_nieuwe_thesauri_TSNR.Substring(1,3) == "007")
						    .Select (bsttt => bsttt.Naam_item_50_posities_THNM50.Trim()),
					Products = (from zi in BST004T_Artikelen
			   				    join lbl in BST020T_Namen on new { Naamnummer_NMNR = zi.Artikelnaamnummer_ATNMNR } equals new { lbl.Naamnummer_NMNR }
								join hpk in BST031T_Handelsproducten on new { zi.HandelsProduktKode_HPK_HPKODE } equals new { hpk.HandelsProduktKode_HPK_HPKODE } 
			   					join prk in BST051T_Voorschrijfpr_geneesmiddel_identific on new { hpk.PRK_code_PRKODE } equals new { prk.PRK_code_PRKODE }  
								where generic.Key.Generiekeproductcode_GPK_GPKODE == prk.Generiekeproductcode_GPK_GPKODE
							    select lbl.Naam_volledig_NMNAAM).Distinct()
					};

products.Where (p => p.Generic == "PARACETAMOL").Take(100).Dump();