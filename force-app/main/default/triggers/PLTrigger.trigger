trigger PLTrigger on Product_Line__c (after insert, before insert) {

    if (Trigger.isBefore) {
    PLClass.PLInsertDefault(Trigger.new); }
    
    if (Trigger.isAfter) {
    PLClass.CreateDefaultTeam(Trigger.new); }

}