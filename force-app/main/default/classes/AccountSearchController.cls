public with sharing class AccountSearchController {
    @AuraEnabled(cacheable=true)
    public static AccountSearchWrapper searchAccounts(AccountSearchWrapper wrapper) {
        List<Account> searchResults = [SELECT Id, Name, Email__c FROM Account WHERE Name = :wrapper.accountName AND Email__c = :wrapper.accountEmail];
        wrapper.searchResults = searchResults;
        return wrapper;
    }
}