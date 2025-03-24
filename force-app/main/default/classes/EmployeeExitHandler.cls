public class EmployeeExitHandler {
    public static void handleExitStatusUpdate(List<Employee_Exit__c>newRecords,Map<Id, Employee_Exit__c>oldMap) {
        Set<Id> employeeIds = new Set<Id>();
        for (Employee_Exit__c exitRecord : newRecords) {
            Employee_Exit__c oldRecord = oldMap.get(exitRecord.Id);
            if (oldRecord != null && exitRecord.Exit_Status__c == 'Complete' && oldRecord.Exit_Status__c != 'Complete') {
                if (exitRecord.Employee_Name__c != null) {
                    employeeIds.add(exitRecord.Employee_Name__c);
                }
            }
        }
        if (!employeeIds.isEmpty()) {
            List<Employee__c> eTu = [SELECT Id, Status__c FROM Employee__c WHERE Id IN :employeeIds];
            for (Employee__c emp : eTu) {
                emp.Status__c = 'Terminated';
            }
            if (!eTu.isEmpty()) {
                update eTu;
            }
        }
    }
}