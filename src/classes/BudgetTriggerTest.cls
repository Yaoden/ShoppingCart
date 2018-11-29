@isTest
private class BudgetTriggerTest {
	@testSetup
	private static void setupForTest(){
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User testUser1 = new User(Alias = 'bTest', Email='testuser1@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='bTest', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='test1xyz@test.com');
        insert testUser1;
	}
	
    @isTest
    private static void testBudgetTrigger(){
    	User test = [SELECT Id, Name FROM User WHERE LastName='bTest' LIMIT 1];
    	Budget__c testBudget1 = new Budget__c(
    										User__c = test.Id, 
    										Allocated_Budget__c = 1
    										);
    										
		Budget__c testBudget2 = new Budget__c(
    										User__c = test.Id, 
    										Allocated_Budget__c = 2
    										);
		insert testBudget1;
		Budget__Share retrivedBudget = [SELECT Id, UserOrGroupId FROM Budget__Share WHERE UserOrGroupId = :test.Id LIMIT 1];
		System.Assert(retrivedBudget != NULL);
		
		Database.SaveResult secondInsert = Database.insert(testBudget2, false);
		String secondBudgetErrorMsg = secondInsert.getErrors()[0].getMessage();
		System.AssertEquals('One or more selected users already have budgets assigned. Please review your budgets and try again.',secondBudgetErrorMsg);
    }
}