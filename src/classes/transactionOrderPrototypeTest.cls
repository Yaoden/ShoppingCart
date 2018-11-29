@isTest
private class transactionOrderPrototypeTest {
	
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
    	transactionOrderPrototypeController testController = new transactionOrderPrototypeController();
    	Material__c dummyMaterial = [SELECT Name__c, Category__c, Price__c, Id FROM Material__c WHERE Name__c = 'Dummy'];
    	testController.newTransaction.Material__c = dummymaterial.Id;
    	testController.newTransaction.Quantity__c = 3;
    	Decimal testTotal = testController.getTotal();
    	Decimal testPrice = testController.getPrice();
    	testController.saveTransaction();
    	System.AssertEquals(15, testPrice);
    	System.AssertEquals(15*3, testTotal);
    	Transaction__c insertedTransaction = [SELECT Material__c FROM Transaction__c WHERE Material__c = :dummyMaterial.Id];
    	System.Assert(insertedTransaction != NULL);
    }
}