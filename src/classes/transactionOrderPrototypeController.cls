public with sharing class transactionOrderPrototypeController {
    public Transaction__c newTransaction{get;set;}
    private Map<Id, Material__c> allMaterials;
    
    public transactionOrderPrototypeController(){
        newTransaction = new Transaction__c(Quantity__c = 1,
                                            User__c = UserInfo.getUserId()
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
        insert newTransaction;
        return new pageReference('/' + newTransaction.Id);
    }
}