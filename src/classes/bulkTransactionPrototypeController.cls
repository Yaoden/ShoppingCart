public with sharing class bulkTransactionPrototypeController {
    public List<Transaction__c> newTransactions{get;set;}
    public List<Decimal> newTotals{get;set;}
    public List<String> chosenMaterialNames{get;set;}
    public List<Decimal> chosenMaterialPrice{get;set;}
    public Decimal totalCost{get;set;}
    
    private Map<Id, Material__c> allMaterials;
    
    public bulkTransactionPrototypeController(){
    	
    	newTransactions = new List<Transaction__c>{new Transaction__c(Quantity__c = 0,
    																	User__c = UserInfo.getUserId()
    																	)};
		allMaterials = new Map<Id, Material__c>([SELECT Name__c, Price__c FROM Material__c]);
    }
    
    public void addTransaction(){
    	newTransactions.add(new Transaction__c(Quantity__c = 0,
												User__c = UserInfo.getUserId()
												));
    }
    
    public void updateRow(){
    	totalCost = 0;
    	Decimal transactionCost = 0;
    	newTotals = new List<Decimal>();
    	chosenMaterialNames = new List<String>();
    	chosenMaterialPrice = new List<Decimal>();
    	for(Transaction__c curTransaction:newTransactions){
    		transactionCost = curTransaction.Quantity__c * allMaterials.get(curTransaction.Material__c).Price__c;
    		newTotals.add(transactionCost);
    		totalCost = totalCost + transactionCost;
    		chosenMaterialNames.add(allMaterials.get(curTransaction.Material__c).Name__c);
    		chosenMaterialPrice.add(allMaterials.get(curTransaction.Material__c).Price__c);
    	}
    }
    
    public pageReference saveTransactions(){
        insert newTransactions;
        return NULL;
    }
}