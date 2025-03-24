public class Ciapex {
public static void fullName(String firstName, String lastName) {
        String fullName = firstName + ' ' + lastName;
        System.debug('Full Name: ' + fullName);
    }
    public Void FetchAccount(string AccountID,integer numofAccount){
    list<Contact> acclist = new list<Contact>();
    acclist = [SELECT id FROM Contact];
    system.debug(acclist);
}
    public Void FetchAccount(string contactName){
        list<Contact> acclist = new list<Contact>();
        acclist=[SELECT Id, AccountId FROM Contact];
        system.debug(acclist);
}
    public void fetchOp(string accId){
        list<opportunity> oplist = new list<opportunity>();
        oplist = [ SELECT id,Name From opportunity WHERE AccountId =: accId];
        system.debug(oplist);
    }
    public void relateAccount(contact conObj){
        if(conObj.AccountId == null){
            Account ac = new Account();
            ac.Name = conObj.lastName + 'Acc';
            insert ac;
            conObj.AccountId = ac.Id;
            update conObj;
            
        }
        
    }
    
}