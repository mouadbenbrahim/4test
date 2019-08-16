global class MEAGlobal {

//Format Libelle__c / NomObjetSF__c    
public static Map<String, MEATemplateMapping__c> loadtemplatemapping(){
    Map<String, MEATemplateMapping__c> mappingtable = new Map<String, MEATemplateMapping__c>();
        for (MEATemplateMapping__c o:[SELECT Libelle__c, NomObjetSF__c FROM MEATemplateMapping__c]) {
        	mappingtable.put(o.Libelle__c, o);
            system.debug('New update from IntelliJ 2');
	     }
	return mappingtable;
}

//Format: NomObjetSF__c / Libelle__c    
public static Map<String, MEATemplateMapping__c> loadtemplatemapping2(){
    Map<String, MEATemplateMapping__c> mappingtable = new Map<String, MEATemplateMapping__c>();
        for (MEATemplateMapping__c o:[SELECT NomObjetSF__c, Libelle__c FROM MEATemplateMapping__c]) {
        	mappingtable.put(o.NomObjetSF__c, o);

	     }

	return mappingtable;
}
    
webService static String getattachementbodyStr(ID optyID){
    // retour sur JS: tableau[0] et non pas un strin	g
    //Blob myBlob = Blob.valueof(myString);        
    Attachment origineAttachement = [SELECT Attachment.Body
                              FROM Attachment
                              WHERE ParentId = :optyID and  Name = 'CONTRAT CADRE PBD 2018.docx'
                              //WHERE ID = '00P2X00001gknRmUAI'     
                              LIMIT 1];
    
	Blob origineBlob = origineAttachement.Body; 
    String myString = EncodingUtil.base64Encode(origineBlob);

    
    //MEAUtils.wait(10000);    
    system.debug('...MEA debugging getatt');
    return myString;
}       

webservice static String GetTemplate(String TemplateName){      
    // retour sur JS: tableau[0] et non pas un string
    //Blob myBlob = Blob.valueof(myString);        
    MailmergeTemplate origineAttachement = [SELECT MailmergeTemplate.Body
                              FROM MailmergeTemplate
                              WHERE Name = :TemplateName                                
                              LIMIT 1];
    
	Blob origineBlob = origineAttachement.Body; 
    String myString = EncodingUtil.base64Encode(origineBlob);

    
    //MEAUtils.wait(10000);    
    system.debug('...MEA debugging getatt');
    return myString;
}    

    
webservice static void insertattachement(ID optyID, Blob bBody, String sBody){  
    
    // if ((sBody != null) && (bBody == null)) {bBody = EncodingUtil.base64Decode(sBody);}
    
    bBody = EncodingUtil.base64Decode(sBody);
	Attachment a = new Attachment(Name='CONTRAT CADRE PBD 2018-V1.docx', OwnerId='005w0000003fva9AAA', ParentId=optyID,
                                     ContentType='application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
                                  IsPrivate=false, Body=bBody);        
    insert a; 
    //return null;
}

    
//to be read as array in JS
webservice static List<Attachment> getoppattlist(ID optyID) {
        return [SELECT Id, Name, OwnerId, ContentType, Body
                    FROM Attachment where ParentId = :optyID];    
}

// using key/value map
webService static String getlist(ID optyID) {
   
   String JsonMap;
      
   Map<Id, Opportunity> opps = new Map<Id, Opportunity>([SELECT Id, Name, OwnerId, Type FROM Opportunity limit 3]); 
   Map<Id, Attachment> atts = new Map<Id, Attachment>([SELECT Id, Name, OwnerId, ContentType FROM Attachment where ID = :optyID limit 3]); 
   JsonMap=JSON.serialize(opps);
   return JsonMap;
       
}


webservice static  String getchampsvalues(ID optyID, List<String> listchamps) {
    
    String JsonMap;
	List<String> newlistchamps = new List<String>();
    Map<String, String> champsvalues = new Map<String, String>();    
    String tempchamp;
    String slibelle;
    String svaleur;
    
    
    system.debug('...MEA getchampsvalues');
    
    // Load custom setting object
    Map<String, MEATemplateMapping__c> mappingtable = loadtemplatemapping();
    Map<String, MEATemplateMapping__c> mappingtable2 = loadtemplatemapping2();

    // Remove duplicate from listchamps
    listchamps = MEAUtils.removelistduplicate(listchamps);
    
   for (String key:mappingtable.keySet())
   {	
      system.debug( '...MEA loop: key: ' + key + ' - valeur: ' + mappingtable.get(key).Libelle__c + ' -- ' + mappingtable.get(key).NomObjetSF__c); 
   }
    
   JsonMap=JSON.serialize(mappingtable);
   System.debug('...MEA mappingtable JsonMap: ' + JsonMap);
       JsonMap=JSON.serialize(mappingtable2);
   System.debug('...MEA mappingtable2 JsonMap: ' + JsonMap);
    
    String champ1 = '';
    
    //translation du libelle vers le nom d objet sf
    for (Integer i=0; i<listchamps.size(); i++ ) {        
        //system.debug('...MEA getchampsvalues - : listchamps.get(i): ' + i + ' -' + champ1);  
        champ1 = listchamps.get(i);        
        system.debug('...MEA getchampsvalues - : ' + i + ' -' + champ1);  
        if (mappingtable.containsKey(champ1)) {
        	tempchamp = String.valueof(mappingtable.get(champ1).NomObjetSF__c);
        	system.debug('...MEA tempchamp: ' + tempchamp);
       		newlistchamps.add(tempchamp);
        }
    }
    
    String listcols = string.join(newlistchamps,',');
    system.debug('...listlibelle recu: ' + string.join(listchamps,','));
    system.debug('...listcols trouves: ' + listcols);
       
    String sqlquery = 'SELECT ' + string.join(newlistchamps,',') + ' FROM Opportunity where ID = :optyID limit 1';
	system.debug('...MEA sql: ' + sqlquery); 
    
    Opportunity opp = Database.query(sqlquery); 
    Account acc= opp.Account;
    
    for (String fieldname:newlistchamps) {
        system.debug('...fieldname: ' + fieldname);
        if (fieldname.startsWith('Account.')) {
            slibelle = String.valueof(mappingtable2.get(fieldname).Libelle__c);
            svaleur = String.valueof(acc.get(fieldname.substringAfter('.')));                                    
        }
        else{
            slibelle = String.valueof(mappingtable2.get(fieldname).Libelle__c);
            svaleur = String.valueof(opp.get(fieldname));            
        }
        system.debug('...fieldname: ' + fieldname + ' slibelle: ' + slibelle + 'Value: ' + svaleur);            
        champsvalues.put(slibelle,svaleur);
    }
    
    //Map<String, Object> fieldValues = opp.getPopulatedFieldsAsMap();
       
    
/*        
    for (String fieldname:fieldvalues.keySet() )
    {
        if (fieldname != 'Id' and  fieldname != 'AccountId' and ) {
        	system.debug('...fieldname: ' + fieldname + ' Value: ' + fieldvalues.get(fieldname));
	        slibelle = String.valueof(mappingtable2.get(fieldname).Libelle__c);        
    	    //champsvalues.put(slibelle,String.valueof(fieldvalues.get(fieldname)));         
        	//System.debug('...Field: ' + fieldname + ' Value: ' + fieldvalues.get(fieldname));
        }
    }
*/
    
   JsonMap=JSON.serialize(champsvalues);
   System.debug('...JsonMap: ' + JsonMap);
   return JsonMap;
       
}


}
    
    
    
/*
public static void testfields {
    
    Schema.DescribeSObjectResult a_desc = Account.sObjectType.getDescribe(); //for the Account object, you can replact that with any object you have, standard or custom
Map<String, Schema.SObjectField> a_fields = a_desc.fields.getMap();

for(Schema.sObjectField fld:a_fields.values()){ 
               system.debug(fld);
}
    
}
*/

    
/*
webservice static Map<String, String> getoppdata(ID optyID) {        
    
    return [SELECT Id, Name, OwnerId
                    FROM Opportunity where ID = :optyID];

    //resultsMap = new Map<ID, Contact>([SELECT Id, LastName FROM Contact limit 3]);

      //  JsonMap=JSON.serialize(resultsMap);

    
}
*/