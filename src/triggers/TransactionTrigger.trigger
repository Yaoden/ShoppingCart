trigger TransactionTrigger on Transaction__c (before insert,after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            try{
            	TransactionTriggerHandler.handleAfterInsert(Trigger.new);
            }catch(TransactionTriggerHandlerException e){
                throw e;
            }
        }
    }else if(Trigger.isBefore){
        if(Trigger.isInsert){
            TransactionTriggerHandler.handleBeforeInsert(Trigger.new);
        }
    }
}