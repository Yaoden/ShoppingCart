@isTest
private class transactionOrderExtTest {
	
	@testSetup
	private static void addDummyMaterial(){
		Material__c dummyMaterial = new Material__c(
										Name__c = 'Dummy',
										Category__c = 'Laptop',
										Price__c = 15
										);
		insert dummyMaterial;
	}
	
    @isTest
    private static void testFunctions(){
    	Transaction__c temp = new Transaction__c(User__c = UserInfo.getUserId());
    	ApexPages.StandardController stdController = new ApexPages.StandardController(temp);
    	transactionOrderExt test = new transactionOrderExt(stdController);
    	Material__c dummyMaterial = [SELECT Name__c, Category__c, Price__c, Id FROM Material__c WHERE Name__c = 'Dummy'];
    	test.newTransaction.Material__c = dummymaterial.Id;
    	test.newTransaction.Quantity__c = 3;
    	Decimal testTotal = test.getTotal();
    	Decimal testPrice = test.getPrice();
    	test.saveTransaction();
    	System.AssertEquals(15, testPrice);
    	System.AssertEquals(15*3, testTotal);
    	Transaction__c insertedTransaction = [SELECT Material__c FROM Transaction__c WHERE Material__c = :dummyMaterial.Id];
    	System.Assert(insertedTransaction != NULL);
    }
}