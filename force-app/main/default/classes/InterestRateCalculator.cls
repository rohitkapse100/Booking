public class InterestRateCalculator {
    @AuraEnabled
    public static Decimal getInterestRate(Decimal loanAmount) {
    List<Interest_Rate_Slabs__mdt> slabs = [SELECT Min_Loan_Amount__c, Max_Loan_Amount__c, Interest_Rate__c
                                            FROM Interest_Rate_Slabs__mdt];
    for (Interest_Rate_Slabs__mdt slab : slabs) {
        if (loanAmount >= slab.Min_Loan_Amount__c && loanAmount <= slab.Max_Loan_Amount__c) {
            return slab.Interest_Rate__c;
        }
    }
    return 0; // Default if no slab is found
}
}