public class Firstclass {

    public firstclass(){
        system.debug('I am First Class');
        list<Account> acclist = new list<Account>();
        acclist = [SELECT id,Name,Phone FROM Account];
        system.debug(acclist);
    }
}