/**
 * Created by conor on 2/14/2018.
 */
/*
****************************************************************************************************************************
@Name::     CV_CreateUpdateCPRCompnayBatch
@author: Bhanu(Emp#N040595)
@Date: 20 Jan 2018
@Description: This Batch class for SFDCCOMMB-191 PR Customer View: Create PR Company from CPR Company Monthly Load.

************************************************************************************************************
*/
global with sharing class CV_CreateUpdateCPRCompanyBatch implements Database.Batchable<sObject>,Database.stateful, Database.AllowsCallouts{
	global final Set<string> strParentId;    //String holds current file id is processing.

	/************************************************************************************************
	Method Name            : CV_CreateUpdateCPRCompnayBatch
	Input Parameters       : Set<Id> strParentId
	Return Type            : N\A
	Method Description     : Constructor for batch class.
	***********************************************************************************************/
	global CV_CreateUpdateCPRCompanyBatch (List<CPR_Company__c> cprList){

		//batch class doesn't deal in ParentId's anymore
		//get parent Id's from cprList
		Set<String> setProfileId = new Set<String>();
		for(CPR_Company__c  varAcc : cprList)
			{

				if(varAcc.Parent_Id__c!=null && varAcc.Parent_Id__c!='' )
				{
					if(varAcc.Parent_Id__c.length()==5)
					{
						if(!setProfileId.contains(varAcc.Parent_Id__c))
						{
							setProfileId.add(varAcc.Parent_Id__c);
						}
					}

				}
			}
		strParentId = setProfileId;
		System.debug('------------------------------con-'+strParentId );
	}

	/************************************************************************************************
	Method Name            : start
	Input Parameters       : Database.BatchableContext BC
	Return Type            : Database.QueryLocator - Returns resultset for batch to execute.
	Method Description     : This function performs query for batch, which returns result set for batch.
	***********************************************************************************************/
	global Database.QueryLocator start(Database.BatchableContext BC){
		String strQuery;            //string holds query for batch.
		strQuery = 'SELECT Id,profitability_Relationship_Name__c, Parent_Id__c, legal_entity__c FROM CPR_Company__c Where Parent_Id__c IN ';
		strQuery+=':strParentId Order By Id asc ';
		// System.debug('------------------------------111111111111111111111-'+Database.query(strQuery));

		return Database.getQueryLocator(strQuery);    //executing query.
	}

	/************************************************************************************************
	Method Name            : execute
	Input Parameters       : Database.BatchableContext BC, List<CPR_Company__c> scope
	Return Type            : void
	Method Description     : This method execute in scope context and iterate by batch size - 1
	***********************************************************************************************/
	global void execute(Database.BatchableContext BC, List<CPR_Company__c> scope){

		List<Account> updActList=new List<Account>();
		List<Account> addActList=new List<Account>();

		Savepoint spScope = Database.setSavepoint();    //instantiated Save point for current transaction.

		try
		{
			//GET CPR company Record Type
			List<RecordType> PR_RecordType = [Select Id From RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'PR_Company' AND isActive = true];
			Map<String,CPR_Company__c> ItemProcessed= new Map<String,CPR_Company__c>();
			System.debug(scope);
			for(CPR_Company__c objS : scope)
				{
					string PRName='';

					if(objS.profitability_Relationship_Name__c!=null && objS.profitability_Relationship_Name__c!='')
					{
						PRName=objS.profitability_Relationship_Name__c;
					}
					else{
						PRName='PR Name Missing';
					}

					if(!ItemProcessed.containsKey(objS.Parent_Id__c))
					{
						ItemProcessed.put(objS.Parent_Id__c,objS);

						System.debug('------------------------------test1111-');

						List<Account> AccList=[select Id,Name from Account where CPR_Parent_ID__c=:objS.Parent_Id__c];

						if(AccList.size()>0)
						{
							AccList[0].name=PRName;
							updActList.add(AccList[0]);
						}

						else
						{

							Account act= new Account();
							act.CPR_Parent_ID__c=objS.Parent_Id__c;

							act.RecordTypeId__c=PR_RecordType[0].Id;
							act.Name=PRName;
							addActList.add(act);
						}

					}


				}

		}
		Catch(Exception e)
		{    //Catch all runtime exception
			// Database.rollback(spScope);    //Roll Back transaction

		}

		System.debug('------------------------------updActList-'+updActList);
		System.debug('------------------------------addActList-'+addActList);
		If(updActList.size()>0)
		{
			update updActList;
		}
		If(addActList.size()>0)
		{
			insert addActList;
		}
	}

	/************************************************************************************************
	Method Name            : finish
	Input Parameters       : Database.BatchableContext BC
	Return Type            : void
	Method Description     :
	***********************************************************************************************/
	global void finish(Database.BatchableContext BC){
		try{

		}Catch(Exception e){    //Catch Runtime Exception
			//Add Error to Error Log

		}
	}

}