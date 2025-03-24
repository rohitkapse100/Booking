@isTest
private class CreateAccountRecord_Test {
    @isTest
     public static void testInsertAccountRecord() {
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Account testAccount = new Account();
         testAccount.Name = 'Test Account';
     {
            CreateAccountRecord.insertAccountRecord(testAccount);
        }
        Account insertedAccount = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(null, insertedAccount);
        System.assertEquals('Test Account', insertedAccount.Name);
    }
}