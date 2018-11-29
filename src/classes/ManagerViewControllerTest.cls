/**
 * Created by ConorOliver on 8/15/2017.
 */
@IsTest
private class ManagerViewControllerTest {


	@testSetup
	static void setupData(){

		Profile p = [SELECT Id FROM Profile WHERE Name = 'Shopping Platform User'];

		UserRole standardUser = [SELECT Id FROM UserRole WHERE Name = 'User'];
		UserRole managerUser = [SELECT Id FROM UserRole WHERE Name = 'Manager'];
		UserRole unitHeadUser = [SELECt Id FROM UserRole WHERE Name = 'Unit Head'];

		User unitHead = new User(LastName = 'unitHead', alias = 'uHead', email = 'uHead@testemail.com',
				UserRoleId = unitHeadUser.Id, ProfileId = p.Id, Username = 'test1@teasdfadsfasdst.com', CommunityNickname = 'test',
				TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US');
		insert unitHead;

		User manager1 = new User(LastName = 'manager1', alias = 'mang', email = 'manager@testemail.com',
				UserRoleId = managerUser.Id, ProfileId = p.Id, ManagerId = unitHead.Id, CommunityNickname = 'test1',
				TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Username = 'test2@teasdfadsfasdst.com');
		List<User> managers = new List<User>();
		managers.add(manager1);
		User manager2 = new User(LastName = 'manager2', alias = 'mang2', email = 'manager@testemail.com',
				UserRoleId = managerUser.Id, ProfileId = p.Id, ManagerId = unitHead.Id, CommunityNickname = 'test2',
				TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Username = 'test3@tasdfadsfasdest.com');
		managers.add(manager2);
		insert managers;

		User user1 = new User(LastName = 'user1', alias = 'usr', email = 'usr@testemail.com',
				UserRoleId = standardUser.Id, ProfileId = p.Id, ManagerId = manager1.Id, CommunityNickname = 'test3',
				TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Username = 'testasdfadsfasd4@test.com');

		User user2 = new User(LastName = 'user2', alias = 'usr', email = 'usr@testemail.com',
				UserRoleId = standardUser.Id, ProfileId = p.Id, ManagerId = manager1.Id, CommunityNickname = 'test4',
				TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Username = 'teasdfadsfasdst5@test.com');

		User user3 = new User(LastName = 'user3', alias = 'usr', email = 'usr@testemail.com',
				UserRoleId = standardUser.Id, ProfileId = p.Id, ManagerId = manager2.Id, CommunityNickname = 'test5',
				TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Username = 'test6@tasdfadsfasdest.com');

		User user4 = new User(LastName = 'user4', alias = 'usr', email = 'usr@testemail.com',
				UserRoleId = standardUser.Id, ProfileId = p.Id, ManagerId = manager2.Id, CommunityNickname = 'test6',
				TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Username = 'test7@teasdfadsfasdst.com');

		List<User> insertUsers = new List<User>();
		insertUsers.add(user1);
		insertUsers.add(user2);
		insertUsers.add(user3);
		insertUsers.add(user4);

		insert insertUsers;

		System.debug('test1' + [SELECT Id, ManagerId, Name FROM User]);
		User usr = [Select id from User where Id = :UserInfo.getUserId()];
		//Have to do this to get around MIXED_DML_EXCEPTION
		System.runAs(usr){
			Test.startTest();
			InsertTestUsers.insertRecordsForUsers();
			Test.stopTest();
		}


	}

	@isTest
	public static void testManagerViewController() {

		List<User> userList = [SELECT LastName FROM User];
		List<Budget__c> budgetList = [SELECT Id, User__c, Allocated_Budget__c, Budget_Spent__C FROM Budget__c];
		List<Transaction__c> transactionList = [SELECT Id, User__c FROM Transaction__c];


		//This map is used to populate a set of
		Map<String, User> users = new Map<String, User>();


		for(User u: userList){
			users.put(u.LastName, u);
		}


		//manager1's users
		Set<Id> m1Users = new Set<Id>();
		m1Users.add(users.get('user1').Id);
		m1Users.add(users.get('user2').Id);


		//manager 2's users
		Set<Id> m2Users = new Set<Id>();
		m2Users.add(users.get('manager2').Id);
		m2Users.add(users.get('user3').Id);
		m2Users.add(users.get('user4').Id);

		//set of all users
		Set<Id> allUsers = new Set<Id>();
		allUsers.add(users.get('user1').Id);
		allUsers.add(users.get('user2').Id);
		allUsers.add(users.get('user3').Id);
		allUsers.add(users.get('user4').Id);
		allUsers.add(users.get('unitHead').Id);
		allUsers.add(users.get('manager1').Id);
		allUsers.add(users.get('manager2').Id);





		TestHelper th = new TestHelper();

		//testing as unitHead, first on manager
		System.assert(userList.size() > 0);
		User unitHead = users.get('unitHead');
		User manager1 = users.get('manager1');
		List<Transaction__c> test1txns = [SELECT Id FROM Transaction__c WHERE User__c = :manager1.Id];
		System.assert(test1txns.size() > 0);
		System.debug([SELECT Id, Name FROM User WHERE ManagerId = :unitHead.Id]);

		Budget__c manager1Budget = [SELECT Id FROM Budget__c WHERE User__c = :manager1.Id].get(0);
		th.positiveTest(unitHead, manager1, test1txns, allUsers, manager1Budget);

		//testing as unitHead, on user1
		User user1 = [SELECT Id, LastName FROM User WHERE LastName = 'user1'];
		List<Transaction__c> test2txns = [SELECT Id FROM Transaction__c WHERE User__c = :user1.Id];
		Budget__c user1Budget = [SELECT Id FROM Budget__c WHERE User__c = :user1.Id];
		th.positiveTest(unitHead, user1, test2txns, allUsers, user1Budget);

		//testing as manager2, on user3
		User user3 = [SELECT Id, LastName FROM User WHERE LastName = 'user3'];
		User manager2 = [SELECT Id, LastName FROM User WHERE LastName = 'manager2'];
		List<Transaction__c> test3txns = [SELECT Id FROM Transaction__c WHERE User__c = :user3.Id];
		Budget__c user3Budget = [SELECT Id FROM Budget__c WHERE User__c = :user3.Id];
		th.positiveTest(manager2,user3, test3txns, m2Users, user3Budget);

		//testing as user1 (negative test, should not have any employees!
		th.noEmployeeTest(user1);

	}

}