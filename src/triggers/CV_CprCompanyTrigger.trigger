trigger CV_CprCompanyTrigger on CPR_Company__c (after insert, after update)
{
    if (Trigger.isInsert)
    {

        CV_CprCompanyTriggerHandler.createUpdateCPRCompany(Trigger.new);
    }

    if (Trigger.isUpdate)
    {
        CV_CprCompanyTriggerHandler.createUpdateCPRCompany(Trigger.new);
    }


}