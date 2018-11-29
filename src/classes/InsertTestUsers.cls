/**
 * Created by ConorOliver on 8/16/2017.
 */
public class InsertTestUsers {
	@future
	public static void insertRecordsForUsers() {
		User unitHead = [SELECT Id FROM User WHERE Name = 'unitHead'];
		User manager1 = [SELECT Id FROM User WHERE Name = 'manager1'];
		User manager2 = [SELECT Id FROM User WHERE Name = 'manager2'];
		User user1 = [SELECT Id FROM User WHERE Name = 'user1'];
		User user2 = [SELECT Id FROM User WHERE Name = 'user2'];
		User user3 = [SELECT Id FROM User WHERE Name = 'user3'];
		User user4 = [SELECT Id FROM User WHERE Name = 'user4'];


		Material__c laptop = new Material__c(Category__c = 'Laptop', Name__C = 'newLaptop', Price__c = 1000);
		Material__c antiVirus = new Material__c(Category__c = 'Software', Name__C = 'newAV', Price__c = 350);

		List<Material__c> mats = new List<Material__c>();
		mats.add(laptop);
		mats.add(antiVirus);
		insert mats;

		//all user budgets
		Budget__c unitHeadBudget = new Budget__c(User__c = unitHead.Id, Allocated_Budget__c = 100398700, Budget_Spent__c = 20000);
		Budget__c manager1Budget = new Budget__c(User__c = manager1.Id, Allocated_Budget__c = 10000000, Budget_Spent__c = 2000);
		Budget__c manager2Budget = new Budget__c(User__c = manager2.Id, Allocated_Budget__c = 8000000, Budget_Spent__c = 5000);
		Budget__c user1Budget = new Budget__c(User__c = user1.Id, Allocated_Budget__c = 100000000, Budget_Spent__c = 100);
		Budget__c user2Budget = new Budget__c(User__c = user2.Id, Allocated_Budget__c = 10000000, Budget_Spent__c = 10);
		Budget__c user3Budget = new Budget__c(User__c = user3.Id, Allocated_Budget__c = 100000000, Budget_Spent__c = 567);
		Budget__c user4Budget = new Budget__c(User__c = user4.Id, Allocated_Budget__c = 100000000, Budget_Spent__c = 0);

		List<Budget__c> bdgts = new List<Budget__c>();
		bdgts.add(unitHeadBudget);
		bdgts.add(manager1Budget);
		bdgts.add(manager2Budget);
		bdgts.add(user1Budget);
		bdgts.add(user2Budget);
		bdgts.add(user3Budget);
		bdgts.add(user4Budget);

		insert bdgts;

		//unit head and manager1 have transactions too!
		System.runAs(unitHead){


			Transaction__c unitHeadTransaction =
					new Transaction__c(Material__c = laptop.Id, User__c = unitHead.Id, Quantity__c = 20);
			insert unitHeadTransaction;


		}
		System.runAs(manager1){
			Transaction__c managerTransaction =
					new Transaction__c(Material__c = antiVirus.Id, User__c = manager1.Id, Quantity__c = 3);
			insert managerTransaction;
		}

		//user 1's transactions
		System.runAs(user1){
		Transaction__c uTransaction1 = new Transaction__c(Material__c = laptop.Id, User__c = user1.Id, Quantity__c = 2);
		Transaction__c uTransaction2 =
				new Transaction__c(Material__c = antiVirus.Id, User__c = user1.Id, Quantity__c = 1);
			insert uTransaction1;
			insert uTransaction2;
		}
		//user 2's
		System.runAs(user2){
			Transaction__c uTransaction3 =
					new Transaction__c(Material__c = laptop.Id, User__c = user2.Id, Quantity__c = 2);
			insert uTransaction3;
		}
		//user 3's
		System.runAs(user3){
			Transaction__c uTransaction4 =
					new Transaction__c(Material__c = antiVirus.Id, User__c = user3.Id, Quantity__c = 1);
			Transaction__c uTransaction5 =
					new Transaction__c(Material__c = laptop.Id, User__c = user3.Id, Quantity__c = 2);
			insert uTransaction4;
			insert uTransaction5;
		}
		//user 4's
		SYstem.runAs(user4){
			Transaction__c uTransaction6 =
					new Transaction__c(Material__c = antiVirus.Id, User__c = user4.Id, Quantity__c = 1);
			insert uTransaction6;
		}

		/*
		List<Transaction__c> txns = new List<Transaction__c>();
		txns.add(unitHeadTransaction);
		txns.add(managerTransaction);
		txns.add(uTransaction1);
		txns.add(uTransaction2);
		txns.add(uTransaction3);
		txns.add(uTransaction4);
		txns.add(uTransaction5);
		txns.add(uTransaction6);

		insert txns;

	*/


	}
}