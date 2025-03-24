public class RetriveAccountData {
    public static List<Account> retrieveRelatedAccData(String accountName) {
        List<Account> relatedAcc = new List<Account>();
        relatedAcc = [SELECT Id,Name FROM Account WHERE Name = :accountName];
        return relatedAcc;
    }
}