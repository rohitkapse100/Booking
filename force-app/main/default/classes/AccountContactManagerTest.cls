@isTest
public class AccountContactManagerTest {
     @isTest
    static void testLinkContactToAccount() {
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
      
        Contact testContact = new Contact();
        testContact.LastName = 'Test Contact';
        insert testContact;
        
        AccountContactManager.linkContactToAccount(testContact.Id, testAccount.Id);
        Contact updatedContact = [SELECT Id, AccountId FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(testAccount.Id, updatedContact.AccountId, 'The contact should be linked to the account');
    }
}