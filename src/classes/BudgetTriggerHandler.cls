public with sharing class BudgetTriggerHandler {
	public static void beforeInsertFunction(List<Budget__c> newBudgets){
		List<Id> userIds = new List<Id>();
		for(Budget__c currentBudget:newBudgets){
			userIds.add(currentBudget.User__c);
		}
		List<Budget__Share> existingShares = [SELECT UserOrGroupId FROM Budget__Share WHERE UserOrGroupId IN :userIds];
		if(!existingShares.isEmpty()){
			Trigger.new[0].addError('One or more selected users already have budgets assigned. Please review your budgets and try again.');
		}
	}
	
    public static void afterInsertFunction(List<Budget__c> newBudgets){
    	Budget__Share newShare;
    	List<Budget__Share> lBudgetShares = new List<Budget__Share>();
    	for(Budget__c currentBudget:newBudgets){
    		newShare = new Budget__Share(
    									ParentId = currentBudget.Id,
    									UserOrGroupId = currentBudget.User__c,
    									AccessLevel = 'Read'
    									);
			lBudgetShares.add(newShare);
    	}
    	insert lBudgetShares;
    }
    /*
    public static void afterUpdateFunction(Map<Id, Budget__c> newBudgets, Map<Id, Budget__c> oldBudgets){
    	Budget__c newBudget, oldBudget;
    	Set<Id> changedBudgets = new Set<Id> ();
    	for(Id currentId:newBudgets.keyset()){
    		newBudget = newBudgets.get(currentId);
    		oldBudget = oldBudgets.get(currentId);
    		if(newBudget.User__c != oldBudget.User__c){
    			changedBudgets.add(currentId);
    		}
    	}
    	List<Budget__Share> changedShares = [SELECT UserOrGroupId, ParentId FROM Budget__Share WHERE UserOrGroupId IN :changedBudgets];
		for(Budget__Share currentShare:changedShares){
			currentShare.UserOrGroupId = newBudgets.get(currentShare.ParentId).User__c;
		}
		update changedShares;
    }*/
}