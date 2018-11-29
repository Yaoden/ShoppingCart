/*
****************************************************************************************************************************
@Name::  CV_CreateUpdateCPRCompnayBatch_Test
@author: Bhanu(Emp#N040595)
@Date: 20 Jan 2018
@Description:Test class for the 'CV_CreateUpdateCPRCompnayBatch' class.

************************************************************************************************************
*/

@isTest
public class CV_CreateUpdateCPRCompanyBatch_Test{

	public static testMethod void PRCompanyCreation()
		{

			list<CPR_Company__c> lstPRCom = new list<CPR_Company__c>();
			CPR_Company__c PR1= new CPR_Company__c();
			PR1.Name = 'test1'; //so we can get this record back without referring to any of the fields to be tested
			PR1.Parent_Id__c='12345';
			PR1.profitability_Relationship_Name__c='AA';
			PR1.legal_entity__c='AA';
			lstPRCom.add(PR1);

			CPR_Company__c PR11= new CPR_Company__c();
			PR11.Name = 'test2';
			PR11.Parent_Id__c='11a';
			PR11.profitability_Relationship_Name__c='AAa';
			PR11.legal_entity__c='AAa';
			lstPRCom.add(PR11);
			insert lstPRCom;
			CPR_Company__c com=[SELECT Id,profitability_Relationship_Name__c, Parent_Id__c, legal_entity__c FROM CPR_Company__c where profitability_Relationship_Name__c='AA' ];
			com.profitability_Relationship_Name__c='Test';
			update com;

/*
			CPR_Company__c com1 = [SELECT Id,profitability_Relationship_Name__c, Parent_Id__c, legal_entity__c FROM CPR_Company__c where Name='test1' ];
			CPR_Company__c com2 = [SELECT Id,profitability_Relationship_Name__c, Parent_Id__c, legal_entity__c FROM CPR_Company__c where Name='test2' ];

			System.debug(com1);
			System.debug(com2);

			//get corresponding account (com2 acct should not exist), as ID is not 5 characters)
			List<Account> com1Acct=[select Id,Name from Account where CPR_Parent_ID__c=:com1.Parent_Id__c];
			List<Account> com2Acct=[select Id,Name from Account where CPR_Parent_ID__c=:com2.Parent_Id__c];
			System.assert(com2Acct.size() == 0);


			System.assertEquals(com1Acct.get(0).CPR_Parent_ID__c, '12345');
			System.assertEquals(com1Acct.get(0).Name, 'AA');
			*/
		}
}