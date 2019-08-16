public class PLteamClass {

public static boolean firstRun = true;
   
    
// Prevent PLteam Delete if it is the only team member on the PL    
public static void PreventDelete(List <Product_Line_Team__c> os){
    
    // Query lookup data(PL) into Map
    Map<Id,Product_Line__c> plMap = new Map<Id,Product_Line__c>();   
    for (Product_Line_Team__c o:os){
            plMap.put(o.Product_Line__c,null);            
        }
    plMap.remove(null);
    plMap.putAll([select Id,TeamCount__c from Product_Line__c where Id in :plMap.keySet()]);
    // end query lookup
    
    for (Product_Line_Team__c o:os){
        if(plMap.get(o.Product_Line__c).TeamCount__c < 2) {
           System.debug('THA-ERROR: you can not delete the record'); 
           o.adderror('THA-ERROR (trigger script): tu ne peux pas supprimer: une team est obligatoire');
        }
                
        }    
}

    
public static void InsertDefault(List <Product_Line_Team__c> os) {
//    string usergbu = [select GBU__c from User where id = :UserInfo.getUserId()].GBU__c;

string member;

    for (Product_Line_Team__c o:os){
        //member =        
        o.Name = [Select Id, Name, Alias From User Where Id = :o.Member2__c].Name; //a faire: sortir les select dans une map/boucle pour governorlimit
        //Member2__c = PL.CreatedByID 
        //Primary__c = true
    }
    
    // update os;     
}

// public static void UnsetPrimary(List <Product_Line_Team__c> news, List <Product_Line_Team__c> olds) {
public static void UnsetPrimary(Map<Id, Product_Line_Team__c> news, Map<Id, Product_Line_Team__c> olds, boolean isupdate) {

    for (Id o:news.keySet()){
        //member =
        //if ( (olds.size() > 0 && (news.get(o).Primary__c != olds.get(o).Primary__c)) || (olds.size() == 0 ) ) // existing record OR newrecord
        if ( (isupdate && (news.get(o).Primary__c != olds.get(o).Primary__c)) || ( ! isupdate ) ) // existing record OR newrecord
        {

        if (isupdate) System.Debug('THA0 ---: ' +  'OLD: ' + olds.get(o).Primary__c + '  NEW: ' + news.get(o).Primary__c);                      
        if (isupdate) System.Debug('THA ---: ' +  'OLD: ' + olds.get(o).Primary__c + '  NEW: ' + news.get(o).Primary__c);
            
            List <Product_Line_Team__c> os1 = [Select Id, Name, Primary__c from Product_Line_Team__c where Product_Line__c = :news.get(o).Product_Line__c AND Id != :o];
            for (Product_Line_Team__c o1:os1)
            {            
                System.Debug('THA ---: OTHER RECORDS: ' +  o1.Primary__c);
                if (o1.Primary__c == true) {
                System.Debug('THA ---: OTHER RECORDS to uncheck: ' +  o1.Primary__c + ' ' + o1.Name);
                    o1.Primary__c = false;
                    //update o1;
                }
            }
            update os1;
            
        }
        

    }

}

public static void ShareTeamMember(Map<Id, Product_Line_Team__c> news, Map<Id, Product_Line_Team__c> olds, string Operation){
	
    List<Product_Line__Share> plShares = new List <Product_Line__Share>();
    List<Product_Line__Share> plSharesToDel = new List <Product_Line__Share>();
    Map<Id,Id> MapplSharesToDel = new Map <Id,Id>();
    
    for (Id id:news.keySet()){ 		
        
        //Add sharing
        if ( Operation == 'INSERT' || (Operation == 'UPDATE' && news.get(id).Member2__c != olds.get(id).Member2__c) ) 
        {	
			Product_Line__Share plShare = new Product_Line__Share(parentId = news.get(id).Product_Line__c                
                                                 , userOrGroupId = news.get(id).Member2__c
                                                 , rowCause = 'THA_Team_Share_Reason__c'
                                             	, accesslevel = 'Edit');
            plShares.add(plShare);
        } 
        
        System.debug('THA-INFO: DELETE 0');
        
        //Remove sharing
        if ( ( Operation == 'UPDATE' && news.get(id).Member2__c != olds.get(id).Member2__c  && olds.get(id).Member2__c != null) ||
           	 ( Operation == 'DELETE' ) )           
        {		
            System.debug('THA-INFO: DELETE 1' + olds.get(id).Member2__c + '--' + olds.get(id).Product_Line__c);
            //MapplSharesToDel.put(olds.get(id).Product_Line__c, olds.get(id).Member2__c);
			Product_Line__Share o = [select UserOrGroupId, RowCause, ParentId, Id, AccessLevel 
                                from Product_Line__Share 
                                where parentId = :olds.get(id).Product_Line__c and UserOrGroupId = :olds.get(id).Member2__c ];  //and RowCause = 'THA_Team_Share_Reason__c'];
			plSharesToDel.add(o);            
        }        
    }
    
/* Ne fonctionnera pas : il faut pouvoir faire un sql qui filtre sur UserOrGroupId and ParentId (en couple)
 * si differente Pl et differentes usergroup, on est oblige de faire le select dand la boucle ci-dessus., la keyset ne prend que le parentid.
 * 
     for (Product_Line__Share o:[select UserOrGroupId, RowCause, ParentId, Id, AccessLevel 
                                from Product_Line__Share 
                                where parentId in :MapplSharesToDel.keySet() ])  //and RowCause = 'THA_Team_Share_Reason__c'] )
    {
        plSharesToDel.add(o);
    }
*/        
    
    
    if (!plSharesToDel.isEmpty()) Database.delete(plSharesToDel);
    
    if (!plShares.isEmpty()) Database.insert(plShares);
            
}

}