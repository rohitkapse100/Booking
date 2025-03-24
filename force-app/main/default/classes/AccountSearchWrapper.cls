public class AccountSearchWrapper {
    @AuraEnabled
    public String accountName { get; set; }
    @AuraEnabled
    public String accountEmail { get; set; }
    @AuraEnabled
    public List<Account> searchResults { get; set; }
}