/**
 * Created by ConorOliver on 8/14/2017.
 */
public with sharing class ManagerViewController {

    public String selectedEmployee{ get;set; }
    public List<User> employees{ get;set; }

    public List<Budget__c> employeeBudget{ get; set; }
    public List<Transaction__c> employeeTransactions{ get; set; }

    public Id userId;
    public Boolean displayEmployees{ get; set; }
    public Boolean noEmployees { get; set; }

    public Boolean renderTable{ get; set; }




    /***
    Gets the current user id and selects all users that have current user as manager
    **/
    public ManagerViewController() {
        //In order to get every user in the hierarchy below the current user, we need to use a queue
        //All users with current user as manager are added to the queue, then their children are, and so forth
        List<User> employeeSearchQueue = new List<User>();
        userId = UserInfo.getUserId();
        User pageUser = [Select id, Name from User where Id = :userId];
        employeeSearchQueue.add(pageUser);
        employees = new List<User>();
        while(employeeSearchQueue.size() != 0) {
            employees.add(employeeSearchQueue.get(0));
            List<User> managedEmployees = [SELECT Id, Name FROM User WHERE ManagerId = :employeeSearchQueue.get(0).Id];
            employeeSearchQueue.remove(0);
            if(managedEmployees != null) {
                for (User u : managedEmployees) {
                    employeeSearchQueue.add(u);
                }
            }
        }
        noEmployees = False;
        renderTable = False;
        displayEmployees = True;
        if (employees == null || employees.size() == 0) {
            displayEmployees = False;
            noEmployees = True;
        }
    }

    /***
    This is called when the user clicks on an employee. It sets the current budget to display as well as
    the transaction history for that user.
    **/
    public void populateTable() {
        renderTable = True;
        employeeBudget = [SELECT Id, Name, Allocated_Budget__c, Budget_Spent__c, Remaining_Budget__c FROM
        Budget__c WHERE User__r.Name = :selectedEmployee];

        employeeTransactions = [SELECT Id, Total_Price__c, Transaction_Date__c, Material__c, Material_Name__c,
                Quantity__c FROM Transaction__c WHERE User__r.Name = :selectedEmployee];

    }
}