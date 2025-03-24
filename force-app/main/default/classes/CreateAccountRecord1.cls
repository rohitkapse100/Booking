public class CreateAccountRecord1 {
    public static void updateAccountBalance() {
        Date currentDate = Date.today();
        Integer dayOfMonth = currentDate.day();
        Integer daysInMonth = Date.daysInMonth(currentDate.year(), currentDate.month());
        if (dayOfMonth == daysInMonth) {
            List<Account> accountsToUpdate = [SELECT Id, Balance__c FROM Account];
            for (Account acc : accountsToUpdate) {
                acc.Balance__c = 50000;
            }
            update accountsToUpdate;
        }
    }
}