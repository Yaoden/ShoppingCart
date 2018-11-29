public with sharing class transactionOrderExt {
    public Transaction__c newTransaction{get;set;}
    private Map<Id, Material__c> allMaterials;
    
    public transactionOrderExt(ApexPages.StandardController stdController){
        newTransaction = new Transaction__c(Quantity__c = 1,
                                            User__c = UserInfo.getUserId(),
                                            Transaction_Date__c = date.today()
                                            );
        allMaterials = new Map<Id, Material__c>([SELECT Price__c FROM Material__c]);
        
    }
    
    public Decimal getTotal(){
        Decimal materialPrice = 0;
        if(newTransaction.Material__c!=NULL){
            materialPrice = allMaterials.get(newTransaction.Material__c).Price__c;
        }
        return newTransaction.Quantity__c * materialPrice;
    }
    
    public Decimal getPrice(){
        Decimal price = 0;
        if(newTransaction.Material__c != NULL){
            price = allMaterials.get(newTransaction.Material__c).Price__c;
        }
        return price;
    }
    
    public pageReference saveTransaction(){
        try{
        	insert newTransaction;
        	return new pageReference('/' + newTransaction.Id);
    	}catch(TransactionTriggerHandlerException e){
    		//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'The transaction was not saved. The current user has no budget available. Error: ' + e.getMessage()));
    	}catch(Exception e){
    		//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'There was an error saving the transaction: ' + e.getMessage()));
    	}
        return NULL;
    }
}