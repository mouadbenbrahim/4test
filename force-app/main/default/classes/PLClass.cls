public class PLClass {

public static void CreateDefaultTeam(List <Product_Line__c> PLs) {

    System.Debug('CreateDefaultTeam: start');
    string ownername;
    
    User ownerLKP = new User();
    
    List <Product_Line_Team__c> PLTEAMs = new list <Product_Line_Team__c>();
    map<Id,User> ownerMap = new map<Id,User>();
    
   
    for (Product_Line__c PL:PLs) {
       ownerMap.put(PL.OwnerId, null);
    }
    
    ownerMap.remove(null);
    ownerMap.putAll([Select Id, Name, Alias From User Where Id In : ownerMap.keyset()]);
    
    for (Product_Line__c PL:PLs) {
    
    //    ownername = PL.Name; //OK
          ownername = ownerMap.get(PL.OwnerId).Name; //OK

    
    /*    ownerLKP = [Select Id, Name, Alias From User Where Id = :PL.OwnerId]; //OK: but not to use because of governorlimit: select inside loop
        ownername = ownerLKP.Name;
    */
            
        Product_Line_Team__c PLTEAM = new Product_Line_Team__c(Product_Line__c = PL.id, Name = ownername, Member2__c = PL.CreatedByID, Primary__c = true); 
        PLTEAMs.add(PLTEAM );
    }
    
    insert PLTEAMs;

}


public static void PLInsertDefault(List <Product_Line__c> PLs) {
    
    string usergbu = [select GBU__c from User where id = :UserInfo.getUserId()].GBU__c;
        
    for (Product_Line__c PL:PLs){
        PL.GBU__c = usergbu; // set default user GBU
        PL.Free_field_1__c = 'Update from trigger'; // set sample
        PL.UniqueKey1__c = PL.Business_Line__c + PL.Name + PL.Product_Line_Family__c; // set UnikeyField1
    }    
    
}

}