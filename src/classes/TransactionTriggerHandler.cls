public class TransactionTriggerHandler {
    

    public static void handleBeforeInsert(List<Transaction__c> lstTrns){
       /**
         * Maps the budget to the user
         */
        Map<Id,Budget__c> userBudgets = new Map<Id,Budget__c>();
		List<Budget__c> lstBdgt = [SELECT Id,Name,Allocated_Budget__c,Budget_Spent__c,User__c FROM Budget__c];
        for(Budget__c b: lstBdgt){
        	userBudgets.put(b.User__c,b);
        }
        
        for(Transaction__c t: lstTrns){
            if(!userBudgets.containsKey(t.User__c)){
                t.addError('User does not have a budget');
            }
        }
        
    }    
    
    public static void handleAfterInsert(List<Transaction__c> lstTrns){
        
        

        
        
       /**
         * Key: Id of User
         * Value: A double variable showing the amount the user spent
         * 
         * Iterate through the list of transactions and calculate the total amount spent based on the user
         * 
         */
        map<Id,Double> mapTrans = new Map<Id,Double>();
        for(Transaction__c transitem: lstTrns){
            if(mapTrans.containsKey(transitem.User__c)){
                mapTrans.put(transitem.User__c,mapTrans.get(transitem.User__c)+transitem.Total_Price__c);
            }else{
                mapTrans.put(transitem.User__c,transitem.Total_Price__c);
            }
        }
       

        List<Budget__c> lstBdgt = [SELECT Id,Name,Allocated_Budget__c,Budget_Spent__c,User__c FROM Budget__c where User__c in :mapTrans.keySet()];
        /*
        //This means that one of the users making a transaction does not have a budget
        if(lstBdgt.size() != mapTrans.keySet().size()){
            //throw new TransactionTriggerHandlerException('User does not have a budget');
            //lstTrns[0].addError('User does not have a budget');
        }
		*/
        for(Budget__c budgitem: lstBdgt){
            budgitem.Budget_Spent__c += mapTrans.get(budgitem.User__c);
        }
        
        update lstBdgt;
    }
}