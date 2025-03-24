public class getAccountCon {
    public static Contact_Wrapper ConAcc(string accountid){
        list<Account> acclist = [SELECT id,Account.Name FROM Account];
        list<Contact> contactlist = [SELECT id,Name,Account.Name,Accountid From Contact Where Accountid =:accountid];
        Contact_Wrapper ConWrapper = new Contact_Wrapper();
        ConWrapper.accountName = contactlist[0].Account.Name;
        ConWrapper.Count = contactlist.Size();
        system.debug('Value of Count of Contact'+ConWrapper);
        return ConWrapper;
    }
}