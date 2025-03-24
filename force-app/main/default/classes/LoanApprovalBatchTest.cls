@isTest
public class LoanApprovalBatchTest {
    @testSetup static void setupTestData() {
        List<Loan_Application__c> loans = new List<Loan_Application__c>();
        loans.add(new Loan_Application__c(Loan_Amount__c = 500000, Tenure_Months__c = 24, Status__c = 'Submitted'));
        loans.add(new Loan_Application__c(Loan_Amount__c = 700000, Tenure_Months__c = 24, Status__c = 'Submitted'));
        loans.add(new Loan_Application__c(Loan_Amount__c = 400000, Tenure_Months__c = 48, Status__c = 'Submitted'));
        insert loans;}
    @isTest static void testLoanApprovalBatch() {
        Test.startTest();
        LoanApprovalBatch batch = new LoanApprovalBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        List<Loan_Application__c> approvedLoans = [SELECT Id, Status__c FROM Loan_Application__c WHERE Loan_Amount__c < 500000 AND Tenure_Months__c <= 36];
        System.assertEquals(1, approvedLoans.size(), 'Only one loan should be approved.');
        System.assertEquals('Approved', approvedLoans[0].Status__c, 'Loan should be approved.');
    }
}