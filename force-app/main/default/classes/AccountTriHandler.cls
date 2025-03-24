public class AccountTriHandler {
    public static void cretecon(list<Account> newlist){
        list<Contact> conlist = new list<Contact>();
        for(Account ac: newlist){
            contact con = new contact();
            con.AccountId = ac.id;
            con.lastName = ac.Name+'Contact';
            conlist.add(con);
        }
    if(conlist.size()>0){
        insert conlist;
    }
}
    public static void CreteAcc(list<Account> newlist,Map<id,Account> oldMap){
        for(Account ac: newlist){
            if(oldMap!=null && ac.Phone !=oldMap.get(ac.Id).Phone){
                ac.Description = 'Phone is modified';
            }
        }
    }
    public static void cretacc(list<Account> acclist){
        list<Contact> conlist = new list<Contact>();
        for(Account acc : acclist){
            if(acc.id == null){
                Contact con = new Contact();
                con.LastName =acc.Name +'mr';
                con.Accountid = acc.id;
                conlist.add(con);
            }
        }
        insert conlist;
    }
    public static void emailModify(list<Contact> conlist,map<id,Contact> mapid){
        for(contact con : conlist){
            if(mapid != null && con.Email !=mapid.get(con.id).Email){
                Con.Description = 'Email Is Modified';
            }
        }
    }
    public static void cretelocation(list<Account> newlist){
        list<Contact> conlist = new list<Contact>();
        map<id,decimal> mapAcc = new map<id,decimal>();
        for(Account acc : newlist){
            mapAcc.put(acc.id,acc.Number_of_Contact__c);
        }
        if(mapAcc.size()>0 && mapAcc != null){
        for(Id accId:mapAcc.keyset()){
          for(integer i=0;i<mapAcc.get(accId);i++){
            contact con = new contact();
            con.lastName ='Contact'+i;
            con.Accountid = accId;
            conlist.add(con);
        }
        insert conlist;
    }
}
    }
    public static void crecase(List<Case> newlist){
        for(Case cn : newlist){
            if(cn.Origin == 'Email'){
                cn.Status = 'new';
                cn.Priority = 'Medium';
            }
        }
    }
    public static void CreteLead(List<Lead> newlist){
        for(Lead lc : newlist){
            if(lc.LeadSource == 'Web'){
                lc.Rating = 'Cold';
            }else{
                lc.Rating = 'Hot';
            }
        }
    }
    public static void creteAccc(List<Account> newlist){
        list<Contact> conlist = new list<Contact>();
        Map<id,Decimal> MapAccc =  new Map<id,Decimal>();
        for(Account ac : newlist){
            MapAccc.put(ac.id,ac.NumberofLocations__c);
        }
        if(MapAccc.Size()>0 && MapAccc != null){
            for(id AccId :MapAccc.keyset()){
                for(Integer i =0;i<MapAccc.get(accId);i++){
                    
                }
                
            }
        }
    }
    public static void CreteHot(list<Account> newlist){
        for(Account ac : newlist){
            if(ac.Industry == 'Banking'){
                ac.Rating='Hot';
            }
        }
    }
     public static void CreteNumberOfContact(list<Account>newlist){
        list<Contact> conlist = new list<Contact>();
        for(Account ac : newlist){
            if(ac.NumberofLocations__c != null){
                for(integer i=0;i<ac.NumberofLocations__c;i++){
                    Contact con = new Contact();
                    con.Accountid = ac.id;
                    con.LastName = ''+(i+1);
                    conlist.add(con);
                     
                }
            }
        }
         insert conlist;
}
    public static void creteconUpdate(list<contact>newlist){
        set<id> accids = new set<id>();
        for(contact con : newlist){
            accids.add(con.Accountid);
        }
        list<Account> acclist = new list<Account>();
        for(Account ac : [SELECT id,Count__c,(SELECT id FROM contacts) FROM Account Where Id In : accids]){
            ac.count__c = ac.contacts.size();
            acclist.add(ac);
        }
        update acclist;
    }
    public static void AccPhone(List<Account> newlist,map<id,Account>oldmap){
        map<id,Account> accmap = new map<id,Account>();
        for(Account ac : newlist){
            if(ac.Phone!= null && ac.Phone!=oldmap.get(ac.id).Phone){
                accmap.put(ac.id,ac);
            }
            list<Contact> conllist = new list<Contact>();
            list<contact> conlist = [Select Accountid,Phone FROM Contact Where Accountid IN : accmap.keyset()];
            for(Contact con : conlist){
                con.Phone = accmap.get(con.Accountid).Phone;
                conllist.add(con);
            }
            update conllist;
        }
    }
    public static void AccPhoneee(List<Account> newlist,map<id,Account>oldmap){
        map<id,Account> Accmap = new Map<id,Account>();
        for(Account ac : newlist){
            if(ac.Phone!= null && ac.Phone!=oldmap.get(ac.id).Phone){
                Accmap.put(ac.Id,ac);
            }
            list<Contact> conlist = [SELECT Accountid,Phone FROM Contact Where AccountId In :Accmap.keyset()];
            for(Contact con : conlist){
                con.Phone = Accmap.get(con.Accountid).Phone;
                conlist.add(con);
            }
            update conlist;
        } 
    }
    public static void AccNameMatch(list<Account> newlist){
        Set<string> accstringm = new Set<String>();
        for(Account ac : newlist){
            if(ac.Name != null){
                accstringm.add(ac.Name);
            }
            list<Account> acclist = [SELECT id,Name FROM Account Where Name IN : accstringm];
            set<string> accs = new set<string>();
            for(Account acm :acclist){
                accs.add(acm.Name);
            }
            for(Account acmio : newlist){
                if(accs.Contains(acmio.Name)){
                    acmio.adderror('Duplicate');
                }
            }
        }
    }
    public static void Day30code(list<Account>newlist){
        set<id> accids = new set<id>();
        for(Account ac : newlist){
            accids.add(ac.id);
        }
        list<Opportunity> opplist = new list<Opportunity>();
        Date days30 = date.today()-30;
        list<Opportunity> acoplist = [SELECT Id,StageName FROM Opportunity Where Accountid In : accids];
        for(Opportunity opp :acoplist){
            if(opp.CreatedDate < days30 && opp.StageName != 'Closed Won'){
                opp.StageName = 'Closed Lost';
                opp.CloseDate = date.today();
                opplist.add(opp);
            }
            update opplist;
        }
        
    }
}