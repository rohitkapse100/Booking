public class employeeTriggerHandler {
    public static void handleAfter(List<Employee__c> newlist) {
        Set<Id> accountIds = new Set<Id>();
        for (Employee__c emp : newlist) {
            if (emp.Account__c != null) {
                accountIds.add(emp.Account__c);
            }
        }
        List<Account> accountsToUpdate = [SELECT Id, Left_Employee_Count__c FROM Account WHERE Id IN :accountIds];
        for (Account acc : accountsToUpdate) {
            Decimal leftEmployeeCount = 0;
            if (acc.Left_Employee_Count__c != null) {
                leftEmployeeCount = acc.Left_Employee_Count__c;
            }
            Integer numDeletedEmployees = 0;
            for (Employee__c emp : newlist) {
                if (emp.Account__c == acc.Id) {
                    numDeletedEmployees++;
                }
            }
            acc.Left_Employee_Count__c = leftEmployeeCount + numDeletedEmployees;
        }
        update accountsToUpdate;
    }
}