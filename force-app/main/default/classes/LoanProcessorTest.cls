@isTest
public with sharing class LoanProcessorTest {    
    @testSetup
    static void setupTestData() {
        Loan_Application__c loan = new Loan_Application__c(
            Applicant_Name__c = 'Rohit',
            Loan_Amount__c = 25000,
            Tenure_Months__c = 12,
            Interest_Rate__c = 7.5,
            Status__c = 'Submitted'
        );
        insert loan;
    }
    @isTest
    static void testGetInterestRate() {
        Test.startTest();
        Decimal rate = LoanProcessor.getInterestRate(25000);
        Test.stopTest();
    }
    @isTest
    static void testCalculateEMI() {
        Decimal loanAmount = 20000;
        Decimal interestRate = 7.5;
        Integer tenure = 12;
        Test.startTest();
        Decimal emi = LoanProcessor.calculateEMI(loanAmount, interestRate, tenure);
        Test.stopTest();        
        System.assert(emi > 0, 'EMI should be calculated correctly.');
    }
    @isTest
    static void testCalculateEMIWithZeroValues() {
        Test.startTest();
        Decimal emi = LoanProcessor.calculateEMI(0, 0, 0);
        Test.stopTest();        
        System.assertEquals(0, emi, 'EMI should be 0 for invalid inputs.');
    }
    @isTest
    static void testCreateLoanApplication() {
        Test.startTest();
        Loan_Application__c loan = LoanProcessor.createLoanApplication('Rohit Kapse', 20000, 12);
        Test.stopTest();
        System.assertNotEquals(null, loan.Id, 'Loan application should be created.');
        System.assertEquals('Rohit Kapse', loan.Applicant_Name__c, 'Applicant name should match.');
        System.assertEquals(20000, loan.Loan_Amount__c, 'Loan amount should match.');
        System.assertEquals(12, loan.Tenure_Months__c, 'Tenure should match.');
        System.assertEquals('Submitted', loan.Status__c, 'Status should be set to Submitted.');
    }
}