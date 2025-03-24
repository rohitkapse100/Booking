public class getDetails {
    public static void getuserDetails(){
        user udata = [SELECT id,name, MobilePhone,Email,Username From user limit 1];
        system.debug('Value Of'+ udata);
    }
    public static Account_Wrapper getAccDetails(){
        Account acc = [SELECT id,name,AccountNumber,Phone,type From Account limit 1];
        Account_Wrapper acclist = new Account_Wrapper();
        acclist.name = acc.name;
        acclist.Phone = acc.Phone;
        list<Contact> con = [SELECT id FROM Contact Where accountid =:acc.id];
        acclist.Conlist=con;
        system.debug('value Of Contact'+ con);
        system.debug('Value Of Account Details'+acclist);
        return acclist; 
    }
}