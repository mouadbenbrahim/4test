public class MEAOpportunity {

public static void insertattachement(){  
    ID optyID = '0062X00000typmOQAQ';
    String myString = 'TW91YWQ=';
    Blob myBlob = Blob.valueof(myString);    
    
    Attachment origineAttachement = [SELECT Attachment.Body
                              FROM Attachment
                              WHERE ID = '00P2X00001gkicjUAA'
                              LIMIT 1];
    
	Blob origineBlob = origineAttachement.Body;
    
    //Attachment a = new Attachment(Name='fichier.txt', OwnerId='005w0000003fva9AAA', ParentId=optyID,
    //                                 ContentType='text/plain', IsPrivate=false, Body=myBlob);
	Attachment a = new Attachment(Name='MEAdocx1.docx', OwnerId='005w0000003fva9AAA', ParentId=optyID,
                                     ContentType='application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
                                  IsPrivate=false, Body=origineBlob);    
    //application/vnd.openxmlformats-officedocument.wordprocessingml.document
    insert a; 
    //return null;
}

public static Blob getattachementbody(){  
    ID optyID = '0062X00000typmOQAQ';
    String myString = 'TW91YWQ=';
    Blob myBlob = Blob.valueof(myString);    
    
    Attachment origineAttachement = [SELECT Attachment.Body
                              FROM Attachment
                              WHERE Name = 'CONTRAT CADRE PBD 2018.docx'
                              //WHERE ID = '00P2X00001gknRmUAI'     
                              LIMIT 1];
    
	Blob origineBlob = origineAttachement.Body;   
    
    return origineBlob;
}    


    public static void insertattachement2(Blob nouveauBlob){  
    ID optyID = '0062X00000typmOQAQ';
   
	//Blob nouveauBlob = Blob.valueof(nouveauBody);
    
    //Attachment a = new Attachment(Name='fichier.txt', OwnerId='005w0000003fva9AAA', ParentId=optyID,
    //                                 ContentType='text/plain', IsPrivate=false, Body=myBlob);
	Attachment a = new Attachment(Name='CONTRAT CADRE PBD 2018-V1.docx', OwnerId='005w0000003fva9AAA', ParentId=optyID,
                                     ContentType='application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
                                  IsPrivate=false, Body=nouveauBlob);    
    //application/vnd.openxmlformats-officedocument.wordprocessingml.document
    insert a; 
    //return null;
}
 

}

//Attachment[] atts = new List<Attachment>();
    /*
// Verify that the billing city was updated to New York.
Attachment afterUpdate = 
    [SELECT BillingCity FROM Attachment WHERE Id=:attachmentToUpdate.Id];
System.assertEquals('New York', afterUpdate.BillingCity);
  */
/*    
    // Update account Acme2.
    attachmentToUpdate = 
        [SELECT BillingCity FROM Attachment 
         WHERE Name='Acme2' AND BillingCity='San Francisco'
         LIMIT 1];
    // Update the billing city.
    attachmentToUpdate.BillingCity = 'New York';
    // Make the update call.
    update attachmentToUpdate;

} catch(DmlException e) {
    System.debug('An unexpected error has occurred: ' + e.getMessage());
}
*/
//ID acctID = acct.ID;
////try {
    //insert atts;