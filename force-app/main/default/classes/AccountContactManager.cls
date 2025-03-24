public class AccountContactManager {
    public static void linkContactToAccount(Id contactId, Id accountId) {
        Contact contact = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
        contact.AccountId = accountId;
        update contact;
    }
}