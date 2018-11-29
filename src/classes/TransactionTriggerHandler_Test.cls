@isTest
public class TransactionTriggerHandler_Test {
    
    
    @TestSetup static void setup(){
        
        //create new users 
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        List<User> lstUser = new List<User>{
            new User(Alias = 'tester1', Email='testuser1@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Tester1', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='test1xyz@test.com'),
         	new User(Alias = 'tester2', Email='testuser2@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Tester2', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='test2xyz@test.com'),
            new User(Alias = 'tester3', Email='testuser3@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Tester3', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='test3xyz@test.com')
            };
        insert lstUser;

        //create budget items for each user
        List<Budget__c> lstBdgt = new List<Budget__c>{new Budget__c(Allocated_Budget__c =20000,Budget_Spent__c=0,User__c=lstUser[0].id),new Budget__c(Allocated_Budget__c=10000,Budget_Spent__c=0,User__c=lstUser[1].id)};        insert lstBdgt;
        
        //create material
        Material__c testMaterial = new Material__c(Category__c = 'Laptop', Name__c='Test Laptop', Price__c=100.00);
        insert testMaterial;
        
    }
    
    @isTest
    public static void testAfterInsertHandler(){
        
        //Query for the testusers and material used for the transaction
        //List<User> lstUser = [select id,name from User];
        User testuser1 = [select id,name from User where LastName = 'Tester1'];
        User testuser2 = [select id,name from User where LastName = 'Tester2'];
        User testuser3 = [select id,name from User where LastName = 'Tester3'];
        List<Id> testList = new List<Id>{testuser1.id,testuser2.id,testuser3.id};
            
            
            
        Material__c testMaterial = [select id,name,Name__c,Price__c,Category__c from Material__c limit 1];
        
        
        double testuser1amt = 0;	//the expected amount spent by user 1
        double testuser2amt = 0;	//the expected amount spent by user 2
        double testuser3amt = 0;	//the expected amount spent by user 3
        List<Transaction__c> lstTrans = new List<Transaction__c>();
        
        /**
         * Creates ten transactions for testuser1 and testuser2
         * Control how many transaction each user gets by user the lim variable above
         * 
         */
        for(integer i = 0; i < 10;i++){
			Transaction__c testTrns = new Transaction__c(Material__c = testMaterial.id,Quantity__c = 10,Transaction_Date__c=System.today());
            //first 5 transactions are assigned to tester1
            if(i<3){
                testTrns.User__c = testuser1.id;
                testuser1amt += testTrns.Quantity__c * testMaterial.Price__c;
            //last 5 transactions are assigned to tester2
            }else{
                testTrns.User__c = testuser2.id;
                testuser2amt += testTrns.Quantity__c * testMaterial.Price__c;
            }
            lstTrans.add(testTrns);
        }
        insert lstTrans;
        
        
        
        test.startTest();
        Budget__c testuser1BudgetAfter = [select id,name,Allocated_Budget__c,Remaining_Budget__c,Budget_Spent__c,User__c from Budget__c where User__c =: testuser1.id];
        Budget__c testuser2BudgetAfter = [select id,name,Allocated_Budget__c,Remaining_Budget__c,Budget_Spent__c,User__c from Budget__c where User__c =: testuser2.id];
		List<Budget__c> testLstBudget = [select id,name,User__c from Budget__c where User__c in :testList];
        System.assertEquals(2,testLstBudget.size());
        System.assertEquals(testuser1amt, testuser1BudgetAfter.Budget_Spent__c);
        System.assertEquals(testuser2amt, testuser2BudgetAfter.Budget_Spent__c);
        System.assertEquals(testuser1BudgetAfter.Allocated_Budget__c-testuser1amt, testuser1BudgetAfter.Remaining_Budget__c);
        System.assertEquals(testuser2BudgetAfter.Allocated_Budget__c-testuser2amt, testuser2BudgetAfter.Remaining_Budget__c);
        test.stopTest();
        
        
    }
    
    
}