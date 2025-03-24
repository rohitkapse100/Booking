public with sharing class AccountManager {
    @AuraEnabled
    public static void createAccount(Map<String, Object> accountData) {
        try {
            System.debug('Account Data: ' + accountData);

            Account newAccount = new Account();
            newAccount.Name = (String) accountData.get('Name');
            newAccount.Phone = (String) accountData.get('Phone');
            newAccount.Industry = (String) accountData.get('Industry');

            // Validation to ensure Account Name is not empty
            if (String.isBlank(newAccount.Name)) {
                throw new AuraHandledException('Account Name is required.');
            }

            insert newAccount;
        } catch (Exception ex) {
            throw new AuraHandledException('Error: ' + ex.getMessage());
        }
    }
}