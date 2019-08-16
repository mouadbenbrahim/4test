public class ProduitClass {

    public static void InsertDefault(List <Produit__c> os) {
	//    string usergbu = [select GBU__c from User where id = :UserInfo.getUserId()].GBU__c;
	
	//Query lookup Product_Line__c
	Map<Id,Product_Line__c> pMap = new Map<Id,Product_Line__c>();        
    for (Produit__c o:os){
        pMap.put(o.Product_Line__c, null);
    }
	pMap.remove(null);
	pMap.putAll([select Id, Product_Line_Family__c from Product_Line__c where Id in :pMap.keySet()]);        
        
	// update field
    for (Produit__c o:os){    
        o.Product_Line_Family__c = pMap.get(o.Product_Line__c).Product_Line_Family__c;    
    }
    
    // update os;     
}
}