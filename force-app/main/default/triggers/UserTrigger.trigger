trigger UserTrigger on User (After insert, After update) {

    string Operation;
    if (Trigger.isInsert) Operation = 'INSERT';
    if (Trigger.isUpdate) Operation = 'UPDATE';
    if (Trigger.isDelete) Operation = 'DELETE';
    
    if (Trigger.isBefore && Trigger.isUpdate){
        
    }

    if (Trigger.isBefore && Trigger.isInsert){
    }

    if (Trigger.isBefore && Trigger.isDelete){
    }

	if (Trigger.isAfter && Trigger.isUpdate){
        if (run.firstRun) {
            run.firstRun = false;           
            
        }        
        // Assign/unassign Permset based on user Role
        UserClass.AssgnPermSet(Trigger.newMap, Trigger.oldMap, Operation);        
        
    }

    if (Trigger.isAfter && Trigger.isInsert){
        if (run.firstRun) {
            run.firstRun = false;            
        }        
    }

    if (Trigger.isAfter && Trigger.isDelete){
        
    }

    
    if (Trigger.isAfter && Trigger.isUndelete){
        
    }
    
}