trigger ProduitTrigger on Produit__c (before insert, before update) {
    
            if (Trigger.isBefore ) {
            // set Produit:Product Line Family(picklist) from PL: Product Line Family(Picklist)
            ProduitClass.InsertDefault(Trigger.new);                
        }
        
}