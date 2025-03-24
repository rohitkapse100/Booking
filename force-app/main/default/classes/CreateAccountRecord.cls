public class CreateAccountRecord {
    public static void insertAccountRecord(Account acc) {
        if (UserInfo.getProfileId() == [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id) {
            insert acc;
    }
}
}