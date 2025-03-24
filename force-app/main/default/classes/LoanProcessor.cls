public class LoanProcessor {
    @AuraEnabled
    public static Decimal getInterestRate(Decimal loanAmount) {
        list<Interest_Rate_Slabs__mdt> slabs = [select Min_Loan_Amount__c, Max_Loan_Amount__c, Interest_Rate__c  from Interest_Rate_Slabs__mdt
                where Min_Loan_Amount__c <= :loanAmount And Max_Loan_Amount__c >= :loanAmount limit 1 ];
        //system.debug('slabs---->'+slabs);
        return slabs[0].Interest_Rate__c;
    }
public static Decimal calculateEMI(Decimal loanAmount, Decimal interestRate, Integer tenure) {
    Double monthlyRate = (interestRate / 12 / 100).doubleValue();
    Double tenureDouble = Double.valueOf(tenure);
    Double numerator = loanAmount.doubleValue() * monthlyRate * Math.pow(1 + monthlyRate, tenureDouble);
    Double denominator = Math.pow(1 + monthlyRate, tenureDouble) - 1;
    Double emi = numerator / denominator;
    System.debug('Corrected EMI--->: ' + Decimal.valueOf(emi));
    return Decimal.valueOf(emi);
}
   @AuraEnabled
   public static void createLoanApplication(Decimal loanAmount, Integer tenure , String loanName, List<String> fileIds ) {
        Decimal interestRate = getInterestRate(loanAmount);
        System.debug('Calculated Interest Rate-->: ' + interestRate);
        Decimal emi = calculateEMI(loanAmount, interestRate, tenure);
        System.debug('Calculated EMI-->: ' + emi);
        Loan_Application__c loanApp = new Loan_Application__c();
            loanApp.Applicant_Name__c = loanName;
            loanApp.Loan_Amount__c = loanAmount;
            loanApp.Tenure_Months__c = tenure;
            loanApp.Interest_Rate__c = interestRate;
            loanApp.EMI__c = emi;
            loanApp.Status__c = 'Submitted';
         // loanApp.panNo__c = panNo ;
        insert loanApp;
        List<ContentDocumentLink> contentLinks = new List<ContentDocumentLink>();
        for (String fileId : fileIds) {
            ContentDocumentLink link = new ContentDocumentLink();
            link.LinkedEntityId = loanApp.Id;           //jis record k sath link hai
            link.ContentDocumentId = fileId;
            link.ShareType = 'V'; // Viewer access
            link.Visibility = 'AllUsers';
            contentLinks.add(link);
        }
        insert contentLinks;
   }
    @AuraEnabled
    public static Integer fetchCibilScore(String panNo) {
        // Generating a random CIBIL score in a balanced way
        Integer cibilScore;
        // 60% chance of being eligible (750 - 900), 40% chance of ineligible (500 - 749)
        if (Math.random() > 0.4) {
            cibilScore = (Integer) (Math.random() * 151) + 750; // 750 to 900
        } else {
            cibilScore = (Integer) (Math.random() * 250) + 500; // 500 to 749
        }
        System.debug('Fetched CIBIL Score for PAN ' + panNo + ' : ' + cibilScore);
        return cibilScore;
    }
}