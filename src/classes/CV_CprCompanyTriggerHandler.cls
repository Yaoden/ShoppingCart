/*
****************************************************************************************************************************
@Name::  CV_CprCompanyTriggerHandler
@author: Bhanu(Emp# N040595)
@Date:   24 Jan 2018
@Description:This Class is used as a Handler Class for CPR Company Trigger

*****************************************************************************************************************************
*/

public class CV_CprCompanyTriggerHandler{

	public static void createUpdateCPRCompany(List<CPR_Company__c> cprList)
		{
			// Insert Batch Name here
			//removed from if -> all processing should be done in batch class
			CV_CreateUpdateCPRCompanyBatch CopyCPRCompany =
					new CV_CreateUpdateCPRCompanyBatch(cprList);
			Database.executeBatch(CopyCPRCompany,200);
		}

}