public class Selfcode {
    public void createClient(string fName,string lName,integer numofClient){
        list<Client__c> clientList = new list<Client__c>();
        for(integer i=0;i<numofClient;i++){
        Client__c cl = new Client__c();
        cl.First_Name__c = fName;
        cl.Last_Name__c = lName;
        update cl;
        }
    }
    public void deleteclient(string fName, string lName,integer numofClient){
        list<Client__c> clList = new list<Client__c>();
        clList = [SELECT id FROM Client__c WHERE First_Name__c =: fName AND Last_Name__c =: lName ];
        delete clList;
    }
    
    public void updateClient(string fName, string lName,string ID){
        list<Client__c> cl = new list<Client__c>();
        cl = [SELECT id FROM Client__c WHERE First_Name__c =: fName AND Last_Name__c =: lName ];
        update cl;
    }
    public void getContact(string accountId){
        list<contact> clList = new list<contact>();
        clList = [SELECT id,AccountId,firstName,lastName FROM Contact WHERE AccountId =: accountId];
        system.debug(clList);
    }
    public list<contact> getCon(string Name){
        list<contact> getcc = new list<contact>();
        getcc = [SELECT id,firstName,lastName FROM contact WHERE lastName Like : '%'+Name+'%' OR firstName like : '%'+Name+'%'];
        return getcc;
    }
    public list<account> fetchAcc(){
        list<Account> acclist = new list<Account>();
        acclist = [SELECT id, Name FROM Account];
        return acclist;
    }
    public list<Client__c> getClient(list<Address__c> adList){
        set<id> clientIds = new set<id>();
        for(Address__c ad:adList){
            if(ad.Client__c != null){
                clientIds.add(ad.Client__c);
            }
        }
        list<Client__c> getcl = new list<Client__c>();
        getcl = [SELECT id, first_Name__c FROM Client__c WHERE id in :clientIds];
        return getcl;
        
    }
    public map<id,Account> getAccMap(list<Account> acList){
         map<id,Account> accMap = new Map<id,Account>();
        for(Account ac:acList){
            accMap.put(ac.id,ac);
        }
        return accMap;
    }
    public void getMultipleContact(set<string> accountids){
        list<contact> aclist = new list<contact>();
        aclist = [SELECT id, AccountId,FirstName,lastName FROM Contact WHERE AccountId IN :accountids];
        system.debug(aclist);
    }
    public void createCont(string fName,string lName,integer NumOfContact){
        list<contact> colist = new list<contact> ();
        for(integer i=0;i<NumOfContact;i++){
            contact con = new contact();
            con.firstName = fName;
            con.lastName = lName;
            colist.add(con);
        }
         insert colist;        
    }
    public integer add(integer num1,integer num2){
        integer add = num1+num2;
        return add;
    }
    public void insertcontact(string fName,string lName){
        list<contact> clist = new list<contact>();
        contact con = new contact();
        con.firstName = fName;
        con.lastName = lName;
        clist.add(con);
        insert clist;
    }
    public static list<Contact> getCon(list<string> lastNamelist){
        list<Contact> conlist = new list<Contact>();
        conlist = [SELECT id,firstName,LastName FROM Contact WHERE LastName In : lastNamelist];
        return conlist;
    }
    public static list<Contact> getMultipleCon(Set<string> accountids){
        list<Contact> conlist = new list<Contact>();
        conlist = [SELECT id, AccountId,FirstName,lastName FROM Contact WHERE AccountId IN :accountids];
        return conlist;
    }
}