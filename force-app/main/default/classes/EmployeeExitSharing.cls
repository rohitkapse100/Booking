public with sharing class EmployeeExitSharing {
    public static void shareRecord(Employee_Exit__c exitRecord, Id userId) {
        // Create a new sharing record
        Employee_Exit__Share share = new Employee_Exit__Share();
        share.ParentId = exitRecord.Id;
        share.UserOrGroupId = userId;
        share.AccessLevel = 'Edit';
        share.RowCause = Schema.Employee_Exit__Share.RowCause.Manual;
        insert share;
    }
}