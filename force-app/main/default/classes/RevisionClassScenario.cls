public class RevisionClassScenario {
    //When we are trying to insert new record into object. If there is any record existing with 
    //same account name it should prevent duplicate record.
    public static void CreteCon(list<Account> newlist){
        set<string> accstring = new set<string>();
        for(Account acc : newlist){
            if(acc.Name==null){
                accstring.add(acc.Name);
            }
            set<string> duplicateString = new set<string>();
            for(Account ac : [SELECT id,Name From Account where Name In :accstring ]){
                duplicateString.add(ac.Name);
            }
            for(Account acm : newlist){
                if(duplicateString.contains(acm.Name)){
                    acm.Adderror('Duplicate Acccount Name');
                }
            }
        }
    }
    //Write a trigger to prefix Account Name with ‘Mr’ when new record is inserted
    public static void prefixAccount(list<Account> newlist){
        list<Account> acclist = new list<Account>();
        for(Account ac : newlist){
            if(ac.Name == null){
                Account acc = new Account();
                acc.Name = ac.Name+'Mr';
                acc.id=ac.id;
                acclist.add(acc);
            }
        }
        insert acclist;
    }
   // Whenever a new record is created into account object . Before this new record is 
//inserted into Account, delete all the contacts records with this account name.
   public static void DelAccount(list<Account> newlist){
    set<id> accids = new set<id>();
    for(Account ac : newlist){
            accids.add(ac.id);
        }
    list<contact> conlist = [SELECT id,Name From contact Where Name in : accids];
    delete conlist;
    }
   //Write a trigger that will prevent a user from creating a lead that already exists as a 
//contact. We will use the lead /contact email address to detect duplicates.
    public static void PreventLeadDuplicate(list<contact> newlist){
        set<string> Emailset = new set<string>();
        for(contact con : newlist){
            if(con.Email == null){
                Emailset.add(con.Email);
            }
            set<string> duplicateLead = new set<string>();
            for(lead lc : [SELECT id,Email FROM Lead Where Email In : Emailset]){
                duplicateLead.add(lc.Email);
            }
            for(contact coon : newlist){
                if(duplicateLead.contains(coon.Email)){
                    coon.adderror('Duplicate Email Exist');
                }
            }
        }
    }
    //Whenever a new contact is created for account update the corresponding account 
//phone with the new contact phone field
public static void UpdatePhone(list<contact> newlist){
    set<id> accids = new set<id>();
    for(contact con : newlist){
        if(con.Accountid == null && con.Phone==null){
            accids.add(con.id);
        }
        map<id,string> accmap = new map<id,String>();
        for(Account ac : [SELECT id,Phone FROM Account Where Phone In : accids]){
            accmap.put(ac.id,ac.Phone);
        }
        for(contact c : newlist){
            if(c.Accountid == null && c.Phone==null){
                c.Phone=accmap.get(c.Accountid);
            }
        }
    }
}
    //When we create the opportunity with probability =50% then the opportunity owner will 
//be automatically added to Account Team of the associated account for the opportunity.
public static void validateOpp(list<opportunity> newlist){
    list<Account> acclist = new list<Account>();
    for(opportunity opp : newlist){
        if(opp.probability == 50){
            Account ac = new Account();
            ac.Name = opp.Name;
            ac.id = opp.Accountid;
            acclist.add(ac);
        }
    }
    insert acclist;
}
}