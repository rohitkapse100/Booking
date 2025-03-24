global class LoanApprovalBatch implements Database.Batchable<SObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id FROM Loan_Application__c WHERE Status__c = 'Submitted' AND Loan_Amount__c < 500000 
            AND Tenure_Months__c <= 36]);
    }
    global void execute(Database.BatchableContext BC, List<Loan_Application__c> scope) {
        for (Loan_Application__c loan : scope) {
            loan.Status__c = 'Approved';
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch Processing Completed');
    }
}