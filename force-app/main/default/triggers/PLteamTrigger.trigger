trigger PLteamTrigger on Product_Line_Team__c (after insert, before insert, before update, after update, before delete) {

	string Operation;
    if (Trigger.isInsert) Operation = 'INSERT';
    if (Trigger.isUpdate) Operation = 'UPDATE';
    if (Trigger.isDelete) Operation = 'DELETE';
  
    
    if (Trigger.isBefore && Trigger.isUpdate){
        // set plteam name from member2 lookup
        PLteamClass.InsertDefault(Trigger.new);
        
    }

    if (Trigger.isBefore && Trigger.isInsert){
        // set plteam name from member2 lookup
        PLteamClass.InsertDefault(Trigger.new);             
    }

    if (Trigger.isBefore && Trigger.isDelete){
        // prevent to delete the last teammember for a product line (Mandatory team member)
        PLteamClass.PreventDelete(Trigger.old);        
    }

	if (Trigger.isAfter && Trigger.isUpdate){
        if (run.firstRun) {
            run.firstRun = false;
            
            // unset primary for all records if primary is set on current
            PLteamClass.UnsetPrimary(Trigger.newMap, Trigger.oldMap, Trigger.isUpdate);                                
        }   
            // Set Team sharing 
            PLteamClass.ShareTeamMember(Trigger.newMap, Trigger.oldMap, Operation);        
        
    }

    if (Trigger.isAfter && Trigger.isInsert){
        if (run.firstRun) {
            run.firstRun = false;
            
            // unset primary for all records if primary is set on current
            PLteamClass.UnsetPrimary(Trigger.newMap, Trigger.oldMap, Trigger.isUpdate);                    
        }        
            // Set Team sharing 
            PLteamClass.ShareTeamMember(Trigger.newMap, Trigger.oldMap, Operation);
        
    }

    if (Trigger.isAfter && Trigger.isDelete){
            // Set Team sharing 
            System.debug('THA-INFO: Trigger After DELETE');
            PLteamClass.ShareTeamMember(Trigger.newMap, Trigger.oldMap, Operation);        
    }

    
    if (Trigger.isAfter && Trigger.isUndelete){
        
    }
    

}