public class MEAVfController {
    
    // Constructor - this only really matters if the autoRun function doesn't work right
    private final Opportunity o;
    public Blob fileBody {get;set;}
    public String var1 {get;set;}
    public transient  String fileBodyStr {get;set;}
    public transient  String fileBodyStr2 {get; set;}

    

    
    public MEAVfController(ApexPages.StandardController stdController) {
        this.o = (Opportunity)stdController.getRecord();
    }
     
    // Code we will invoke on page load.
    public PageReference doSomething() {
 
        String theId = ApexPages.currentPage().getParameters().get('id');
 
        if (theId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }
 
        for (Opportunity o:[select id, name from Opportunity where id = :theId]) {
            // Do all the dirty work we need the code to do
        }
        
 		MEAOpportunity.insertattachement();
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void getattachementbody() {
        var1 = 'Test controler variable';
        fileBody = MEAOpportunity.getattachementbody();
        //fileBodyStr = fileBody.tostring();
		//fileBodyStr = EncodingUtil.base64Decode(EncodingUtil.base64Encode(fileBody)).toString();
        fileBodyStr = EncodingUtil.base64Encode(fileBody);
        //MEAOpportunity.insertattachement();
    }
  
    
    public PageReference insertattachement2() {
		
        // MAJ avec le nouveau body depuis un param ds la page VF
        // fileBodyStr2 = apexpages.currentPage().getParameters().get('sbody');
                       
 		System.debug('insertattachement2 fileBodyStr2: ' + fileBodyStr2);
        
        // Recupere l ID en cours
        String theId = apexPages.currentPage().getParameters().get('id');
        if (theId == null) {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }        
       
       // Appel a la classe d insertion.
       if (fileBodyStr2.length()>0 || true) {
           System.debug('insertattachement21 fileBodyStr2: ' + fileBodyStr2);
           Blob fileBody2 = EncodingUtil.base64Decode(fileBodyStr2);
           MEAOpportunity.insertattachement2(fileBody2);
           }
                  
        // Renvoie page Origine
		PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;        
        //return null;
    }
    
}