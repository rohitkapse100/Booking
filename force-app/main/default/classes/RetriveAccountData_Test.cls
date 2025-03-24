@isTest
private class RetriveAccountData_Test {
    @isTest
    public static void testRetrieveRelatedAccountData() {
        Account testAccount = new Account();
        testAccount.Name = ('Test1 Account');
        insert testAccount;
        List<Account> retrievedAccounts = RetriveAccountData.retrieveRelatedAccData('Test1 Account');
        System.assertEquals(1, retrievedAccounts.size());
        System.assertEquals('Test1 Account', retrievedAccounts[0].Name);
    }
}