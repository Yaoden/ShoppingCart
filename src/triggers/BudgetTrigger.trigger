trigger BudgetTrigger on Budget__c (before insert, after insert) {
	if(trigger.isbefore){
		if(trigger.isinsert){
			BudgetTriggerHandler.beforeInsertFunction(trigger.new);
		}
	}else if(trigger.isafter){
	    if(trigger.isinsert){
	    	BudgetTriggerHandler.afterInsertFunction(trigger.new);
	    }/*else if(trigger.isupdate){
	    	BudgetTriggerhandler.afterUpdateFunction(trigger.newmap, trigger.oldmap);
	    }*/
    }
}