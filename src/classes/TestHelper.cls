/**
 * Created by ConorOliver on 8/16/2017.
 */
public class TestHelper {
	ManagerViewController mvc;
	public TestHelper(){

	}
	public void positiveTest(User currUser, User targetEmployee, List<Transaction__c> expectedTransactions, Set<Id> expectedEmployees, Budget__c budget) {
		System.runAs(currUser){
			this.mvc = new ManagerViewController();

			mvc.selectedEmployee = targetEmployee.LastName;
			System.assert(!mvc.renderTable);
			System.debug(mvc.displayEmployees);
			System.assert(mvc.displayEmployees);

			System.assertEquals(mvc.selectedEmployee, targetEmployee.LastName);

			System.debug('mvc' + mvc.employees);
			System.debug('expected:' + expectedEmployees);
			for (User u : mvc.employees) {
				System.assert(expectedEmployees.contains(u.Id));
			}



			mvc.populateTable();
			//System.assert(mvc.renderTable);

			//add all transaction id's from controller to a set so we can more easily check they exist(avoides order of list elements issue)
			Set<Id> txnActualIdSet = new Set<Id>();
			for(Transaction__c t : mvc.employeeTransactions){
				txnActualIdSet.add(t.Id);
			}

			//checking the correct budget has been loaded for the employee
			System.assertEquals(budget.Id, mvc.employeeBudget.get(0).Id);


			System.assertEquals(expectedTransactions.size(), mvc.employeeTransactions.size());
			for(Transaction__c t : expectedTransactions) {
				System.assert(txnActualIdSet.contains(t.Id));
			}
		}
	}
	public void noEmployeeTest(User currUser){
		mvc = new ManagerViewController();
		System.runAs(currUser){
			//Should have 1 employee (yourself!)
			System.assert(mvc.employees.size() == 1);
		}
	}

}