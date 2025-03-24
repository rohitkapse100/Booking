public with sharing class generateEMI {
    @AuraEnabled
    public static Decimal calculateEMI(Decimal amount, Integer tenure, Decimal interestRate) {
        // Convert annual interest rate to monthly interest rate in decimal form
        Decimal monthlyRate = (interestRate / 100) / 12;
        // to avoid divide by zero
        if (monthlyRate == 0 || tenure == 0) {
            return 0;
        }
        // Convert Decimal to Double before using Math.pow()
        Double base = (1 + monthlyRate);
        Double exponent = Double.valueOf(tenure); // Correct way to convert Integer to Double
        // Calculate (1 + R)^N using Math.pow()
        Double ratePower = Math.pow(base, exponent);
        // Convert back to Decimal
        Decimal emi = (amount * monthlyRate * Decimal.valueOf(ratePower)) /
                      (Decimal.valueOf(ratePower) - 1);
        // Return EMI rounded to two decimal places
        return emi.setScale(2);
    }
  //apply Loan
  @AuraEnabled
  public static void createLoanRecord(String loanDataJson) {
      try {
          LoanApplicationWrapper loanData = (LoanApplicationWrapper) JSON.deserialize(loanDataJson, LoanApplicationWrapper.class);
          System.debug('Deserialized Loan Data: ' + JSON.serialize(loanData));
          Loan_Application__c a = new Loan_Application__c();
          a.Applicant_Name__c = loanData.name;
          a.Loan_Amount__c = loanData.amount;
          a.Tenure_Months__c = loanData.tenure;
          a.Interest_Rate__c = loanData.interestRate;
          a.EMI__c = loanData.EMI;
          a.Status__c = 'Submitted';
          a.PAN_Number__c = loanData.panNumber;
          a.Degree__c = loanData.degree;
          a.Institute_Name__c = loanData.instituteName;
          a.Occupation__c = loanData.occupation;
          a.Annual_Income__c = loanData.annualIncome;
          if (loanData.currentAddress != null) {
              System.debug('Current Address: ' + JSON.serialize(loanData.currentAddress));
              a.Current_Address__Street__s = loanData.currentAddress.street;
              a.Current_Address__City__s = loanData.currentAddress.city;
              a.Current_Address__StateCode__s = loanData.currentAddress.province;
              a.Current_Address__PostalCode__s = loanData.currentAddress.postalCode;
              a.Current_Address__CountryCode__s = loanData.currentAddress.country;
          }
          if (loanData.permanentAddress != null) {
              System.debug('Permanent Address: ' + JSON.serialize(loanData.permanentAddress));
              a.Permanent_Address__Street__s = loanData.permanentAddress.street;
              a.Permanent_Address__City__s = loanData.permanentAddress.city;
              a.Permanent_Address__StateCode__s = loanData.permanentAddress.province;
              a.Permanent_Address__PostalCode__s = loanData.permanentAddress.postalCode;
              a.Permanent_Address__CountryCode__s = loanData.permanentAddress.country;
          }
          insert a;
          System.debug('Loan Application Inserted Successfully. ID: ' + a.Id);
          // Handling Document Attachment
          if (loanData.fileId != null && loanData.fileId != '') {
              System.debug('Attaching file to Loan Application. File ID: ' + loanData.fileId);
              ContentDocumentLink link = new ContentDocumentLink();
              link.LinkedEntityId = a.Id; // Loan Application ID
              link.ContentDocumentId = loanData.fileId;
              link.ShareType = 'V'; //view access
              link.Visibility = 'AllUsers';
              insert link;
              System.debug('Document Linked Successfully.');
          } else {
              System.debug('No document attached for this loan application.');
          }
      } catch (Exception e) {
          System.debug('Error while inserting Loan Application: ' + e.getMessage());
          throw new AuraHandledException('Loan Application Submission Failed: ' + e.getMessage());
      }
  }
  public class AddressWrapper {
    @AuraEnabled public String street {get; set;}
    @AuraEnabled public String city {get; set;}
    @AuraEnabled public String province {get; set;}
    @AuraEnabled public String postalCode {get; set;}
    @AuraEnabled public String country {get; set;}
}
public class LoanApplicationWrapper {
    @AuraEnabled public String name {get; set;}
    @AuraEnabled public Decimal amount {get; set;}
    @AuraEnabled public Integer tenure {get; set;}
    @AuraEnabled public Decimal interestRate {get; set;}
    @AuraEnabled public Decimal EMI {get; set;}
    @AuraEnabled public String panNumber {get; set;}
    @AuraEnabled public String degree {get; set;}
    @AuraEnabled public String instituteName {get; set;}
    @AuraEnabled public String occupation {get; set;}
    @AuraEnabled public Decimal annualIncome {get; set;}
    @AuraEnabled public AddressWrapper currentAddress {get; set;}
    @AuraEnabled public AddressWrapper permanentAddress {get; set;}
    @AuraEnabled public String fileId {get; set;}
}
}