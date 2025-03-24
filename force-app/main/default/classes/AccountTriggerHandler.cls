public class AccountTriggerHandler {
    public static void AcCon(list<Account> newlist){
        list<Contact> conlist = new list<Contact>();
        for(Account ac : newlist){
            if(ac.Number_of_Contact__c != Null){
                Contact con = new Contact();
                con.FirstName = 'MZ';
                con.LastName = 'Fam';
                con.Email = 'rohitkapse100@gmail.com';
                conlist.add(con);
                }
            }
        insert conlist;
    }
    
    public static void SetAcc(list<Account> newlist){
        for(Account ac: newlist){
            if(ac.Industry =='Banking' || ac.Industry =='Healthcare'){
                ac.Rating ='Hot';
            }
        }
    }
    public static void ValidAnnualRevnue(list<Account> newlist){
        for(Account ac: newlist){
            if(ac.Industry =='Banking'){
                ac.AnnualRevenue = 5000000;
            }else if(ac.Industry =='Finance'){
                ac.AnnualRevenue = 4000000;
            }else if(ac.Industry =='Insurance'){
                ac.AnnualRevenue = 3500000;
            }else if(ac.Industry =='Healthcare'){
                ac.AnnualRevenue = 2500000;
            }else{
                ac.AnnualRevenue = 500000;
        }
    }
}
 public static void createNumberOfContacts(list<Account> newList, map<id,Account> oldMap,boolean isInsert){
        list<contact> contactList = new list<contact>();
        map<id,decimal> contactDelMap = new map<id,decimal>();
        for(Account ac: newList){
            decimal diff = 0;
            if(isInsert){
                diff = ac.Number_of_Contact__c;
            }else{
                diff =  ac.Number_of_Contact__c - oldMap.get(ac.id).Number_of_Contact__c ; // 1-5 = -4
            }
            
            // new - 4
            // old - 2
            if(diff > 0){
                for(integer i = 0; i<diff; i++){
                    contact con = new contact();
                    con.accountId = ac.Id;
                    con.LastName = ac.Name+' contact'+i;
                    contactList.add(con);
                }
            }else if(diff <0){
                diff = diff*-1;
                contactDelMap.put(ac.id,diff);
            }
        }
        
        if(contactList.size() >0)
            insert contactList;
        list<contact> delList = new list<contact>();
		map<id,list<contact>> accConMap = new map<id,list<contact>>();
        for(Account ac: [SELECT id,(SELECT id FROM Contacts) FROM Account WHERE id in: contactDelMap.keySet()]){
            decimal delCount = contactDelMap.get(ac.id);
            for(contact con: ac.contacts){
                if(delCount > 0){
                    delList.add(con);
                    delCount = delCount-1;
                }
                
            }
        }       
        
        if(delList.size()>0)
            delete delList;
    }
    public static void AccUpdateRating(list<Account> acclist,map<id,Account> oldmap){
        set<id> accids = new set<id>();
        for(Account ac : acclist){
            if(ac.Rating == 'Hot' && ac.Rating == oldmap.get(ac.id).Rating){
                accids.add(ac.id);
            }
        }
        list<Contact> conupdate = new list<Contact>();
        for(Contact con : [SELECT Accountid FROM Contact Where Accountid In : accids]){
            con.Description='Account Hot Update';
            conupdate.add(con);
        }
        update conupdate;
    }
    public static void accRating(list<Account> newlist,map<id,Account>oldmap){
        set<id> accids = new set<id>();
        for(Account ac : newlist){
            if(ac.Rating =='Hot'&& ac.Rating==oldmap.get(ac.id).Rating){
                accids.add(ac.id);
            }
        }
        list<Contact> colist = new list<Contact>();
        for(Contact conn : [SELECT Accountid FROM Contact Where Accountid In : accids]){
            conn.Description = 'Rating Is Change to Hot';
            colist.add(conn);
        }
        update colist;
    }
    public static void CretCon(list<Contact> newlist){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.AccountId!=null){
                accids.add(con.AccountId);
            }
        }
        map<id,Integer> accmap = new map<id,Integer>();
        list<AggregateResult> result = [SELECT Accountid,Count(id)ct FROM Contact Where Accountid In : accids Group by Accountid];
        for(Aggregateresult ag : result){
            accmap.put((Id)ag.get('Accountid'),(Integer)ag.get('ct'));
        }
        for(contact conn : newlist){
            if(conn.AccountId!=null && accmap.get(conn.AccountId)>=2){
                conn.adderror('More Than 2 Con');
            }
        }
    }
    public static void Updatedesc(list<Account> newlist,map<id,Account>oldmap){
        for(Account ac : newlist){
            if(oldmap!=null){
                ac.Description = 'Phone Is Updated';
            }
        }
    }
    public static void UpdatePhoneopp(list<Account> newlist,map<id,Account>oldmap){
        map<id,Account> acmap = new map<id,Account>();
        for(Account ac : newlist){
            if(oldmap!=null && ac.Phone != oldmap.get(ac.id).Phone){
                acmap.put(ac.id,ac);
            }
            list<Opportunity> oppl = new list<Opportunity>();
            for(opportunity op : [SELECT AccountId,Account_Phone__c FROM Opportunity Where Accountid In : acmap.keyset()]){
                Opportunity oplist = new Opportunity();
                if(acmap.containskey(op.Accountid)){
                    oplist.id=op.id;
                    oplist.Account_Phone__c = acmap.get(op.Accountid).Phone;
                    oppl.add(oplist);
                }
            }
            update oppl;
        }
    }
    public static void accupda(list<Account> newlist,map<id,Account> oldmap){
        list<Contact> conlist = new list<Contact>();
        for(Account ac : newlist){
            Account acold = oldmap.get(ac.id);
            if(acold.Status__c == 'New' && ac.Status__c == 'InProgress'){
                Contact con = new Contact();
                con.AccountId=ac.id;
                con.LastName= ac.Name;
                conlist.add(con);
            }
        }
        insert conlist;
    }
    public static void handleBeforeDelete(Map<Id, Account> oldMap) {
        Set<Id> accountIds = oldMap.keySet();

        // Query related Opportunities
        List<Account> accountsWithOpportunities = [
            SELECT Id, (SELECT Id FROM Opportunities)
            FROM Account
            WHERE Id IN :accountIds
        ];

        // Check for opportunities and add an error if any exist
        for (Account acc : accountsWithOpportunities) {
            if (acc.Opportunities != null && !acc.Opportunities.isEmpty()) {
                acc.addError('Accounts with related Opportunities cannot be deleted.');
            }
        }
    }
    public static void AccOppo(list<Account>newlist,map<id,Account>oldmap){
        set<id> accids = new set<id>();
        for(Account ac : newlist){
            Account acold = oldmap.get(ac.id);
            if(acold.Active__c=='Yes' && ac.Active__c == 'No'){
                accids.add(ac.id);
            }
            list<Opportunity> oplist = new list<Opportunity>();
            for(Opportunity op : [SELECT Accountid,StageName FROM Opportunity Where Accountid In : accids]){
                if(op.StageName !='Closed Won'){
                    op.StageName='Closed Lost';
                    oplist.add(op);
                }
            }
            update oplist;
        }
    }
    Public static void Arating(list<Account>newlist){
        for(Account ac : newlist){
            if(ac.Industry == 'Banking' || ac.Industry == 'Healthcare'){
                ac.Rating='Hot';
            }
        }
    }
    public static void emialPhoneDuplicate(list<Account> newlist){
        set<string> accset = new set<string>();
        for(Account ac : newlist){
            accset.add(ac.Email__c);
        }
        set<string> existacc = new set<string>();
        for(Account acm : [SELECT id,Email__c FROM Account Where Email__c In : accset]){
            existacc.add(acm.Email__c);
        }
        for(Account accm : newlist){
            if(existacc.contains(accm.Email__c)){
                accm.adderror('Email Dupli');
            }
        }
    }
}