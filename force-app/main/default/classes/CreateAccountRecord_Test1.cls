@isTest
public class CreateAccountRecord_Test1 {
    @isTest
    static void testUpdateAccountBalance_LastDayOfMonth() {
        Account testAccounts = new Account();
            testAccounts.Name = 'Test Account';
            testAccounts.Balance__c = 50000;
        insert testAccounts;
        Date lastDayOfMonth = Date.newInstance(Date.today().year(), Date.today().month(), Date.daysInMonth(Date.today().year(), Date.today().month()));
        CreateAccountRecord1.updateAccountBalance();
        List<Account> updatedAccounts = [SELECT Id, Balance__c FROM Account];
        for (Account acc : updatedAccounts) {
            System.assertEquals(50000, acc.Balance__c);
        }
    }
}