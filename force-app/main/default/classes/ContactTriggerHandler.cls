public class ContactTriggerHandler {
    public static void ValidEmailId(list<contact> emaillist){
        set<string> EmailSet = new set<string>();
        set<string> existingSet = new set<string>();
        for(contact co : emaillist){
            if(co.Email != null){
                EmailSet.add(co.Email);
            }
            list<Contact> val = [SELECT id,Email FROM Contact WHERE Email IN : EmailSet];
            if(val.size()>0){
                for(Contact Exits : val){
                    existingSet.add(Exits.Email);
                }
                for(contact ValidateEmail : emaillist){
                    if(EmailSet.Contains(ValidateEmail.Email)){
                        ValidateEmail.addError('Email Already Exist');
                    }
                }
            }
        }
    }
    public static void valEmail(list<contact> newlist){
        set<String> emailSet = new set<String>();
        for(contact c:newlist){
            emailSet.add(c.Email);
        }
        set<String> DupliemailSet = new  set<String>();
        for(Lead c: [SELECT id,email FROM lead WHERE email in: emailSet]){
            DupliemailSet.add(c.Email);
        }
        for(contact c : newlist){
            if(DupliemailSet.contains(c.Email)){
                c.AddError('Duplicate Contact');
            }
        }
    }
    public static void ValidAcc(list<Contact> acclist){
        for(Contact Valac : acclist){
            if(Valac.AccountId == Null){
                Valac.AddError('AccountID is Mandatory');
            }
        }
    }
    public static void creatrAccount(list<contact> newlist){
        list<Account> aclist = new list<Account>();
        for(Contact con : newlist){
            if(con.AccountId == Null){
                Account ac = new Account();
                ac.Name = con.LastName+ 'Account';
                aclist.add(ac);
            }
        }
        insert aclist;
        map<string,id> acmap = new map<string,id>();
        for(Account ac : aclist){
            acmap.put(ac.Name,ac.Id);
        }
        for(Contact con : newlist){
            if(con.AccountId == Null){
                con.AccountId = acmap.get(con.LastName+ 'Account');
            }
        }
    }
    public static void updateBalance(list<contact> newList){
        set<id> accIds = new set<id>();
        for(contact c: newList){
            if(c.AccountId != null)
                accIds.add(c.AccountId);
        }
        list<Account> accList = new list<Account>();
        accList = [SELECT id, (SELECT id,Transaction_Type__c, Amount__c FROM Contacts WHERE Amount__c != null ) FROM Account WHERE id in:accIds];
        
        for(Account ac: accList){
            decimal bal=0;
            for(contact c: ac.contacts){
                if(c.Transaction_Type__c == 'Deposit'){
                    bal = bal+ c.Amount__c;
                }else if(c.Transaction_Type__c =='Withdraw'){
                    bal = bal- c.Amount__c;
                }   
            }
            ac.Balance__c = bal;
        }
        
        update accList;
    }
    public static void CreateCon(list<Contact> newlist){
        list<Account> acclist = new list<Account>();
        for(Contact con: newlist){
            if(con.AccountId == null){
                Account ac = new Account();
                ac.Name =con.LastName;
                ac.Phone = con.Phone;
                acclist.add(ac);
            }
        }
        insert acclist;
    }
    public static void ValidField(list<Contact> newlist){
        for(contact con : newlist){
            if(con.Email == null || con.Email ==''){
                con.Email.addError('Email is Mandatory');
            }if(con.Phone == null || con.Phone ==''){
                con.Phone.addError('Phone is Mandatory');
            }
        }
    }
    public static void AccAssocaite(list<Contact> newlist){
        for(Contact con: newlist){
            if(con.AccountId == null){
                con.AddError('Account Name is Mandtory to crete new Contact');
            }
        }
    }
    public static void ConInsert(list<contact> newlist){
        for(contact con: newlist){
            if(con.Languages__c == 'English' && con.Level__c == null){
                con.Level__c = 'Secondary';
            }
        }
    }
    public static void Coinsert(list<Contact> newlist){
        set<id> accIds = new set<id>();
        for(Contact co : newlist){
            if(co.AccountId == null && co.Phone == null){
                accIds.add(co.id);
                map<id,String> acMap = new map<id,String>();
                for(Account ac : [SELECT id,phone FROM Account WHERE id in : accIds]){
                    acMap.put(ac.id,ac.Phone);   
                }
                for(Contact con : newlist){
                    if(con.AccountId == null && con.Phone == null){
                        con.Phone = acMap.get(con.AccountId);
                    }
                }
            }
        }
    }
    public static void rollupCon(list<contact> newlist,map<id,decimal> oldmap){
        set<id> accids = new set<id>();
        map<id,decimal> rollMap = new map<id,decimal>();
        for(Contact con : newlist){
            accids.add(con.Accountid);   
        }
        for(Contact co : [SELECT id, Accountid, Amount__c FROM Contact WHERE id in: accids]){
            accids.add(co.AccountId);
        }
    }
    public static void Creatacm(list<Contact> newlist){
        set<id> accid = new set<id>();
        For(Contact c : newlist){
            if(c.AccountId == null && c.Phone == null){
                accid.add(c.id);
            }
        }
        map<id,String> accmap = new map<id,String>();
        for(Account ac : [SELECT id,Phone FROM Account Where id in : accid]){
            accmap.put(ac.id,ac.Phone);
        }
        for(Contact conn : newlist){
            if(conn.AccountId == null && conn.Phone == null){
                conn.Phone = accmap.get(conn.AccountId);
            }
        }  
    }
    public static void creacc(list<Contact> newlist){
        set<string> Strset = new set<string>();
        set<string> ExistSet = new set<string>();
        for(Contact con : newlist){
            if(con.Email == null){
                Strset.add(con.Email);
            }
            list<Contact> colist = [Select id,Email FROM Contact WHERE Email In : Strset];
            for(Contact co: colist){
                ExistSet.add(co.Email);
            }
            For(Contact coon : newlist){
                if(Strset.Contains(coon.Email)){
                    coon.adderror('Email Is Exist');
                }
            }
        }   
    }
    public static void cereCon(list<Contact> newlist){
        set<id> acids = new set<id>();
        for(Contact con: newlist){
            if(con.AccountId == null && con.Phone == null ){
                acids.add(con.Accountid);
            }
            map<id,String> Mapids = new Map<id,String>();
            for(Account ac : [SELECT id,Phone FROM Account WHERE id In:acids]){
                Mapids.put(ac.id,ac.Phone);
            }
            for(Contact coon : newlist){
                if(acids.Contains(coon.id)){
                    coon.Adderror('Contains Infromation');
                }
            }
        }
    }
    public static void Crea(List<Account> newlist){
        for(Account acc : newlist){
            if(acc.Name == null){
                Account ac = new Account ();
                ac.Name = acc.Name +'Mr';
            }
        }
    }
    public static void CreACC (list<Account> newlist){
        Set<string> Accaname = new Set<String>();
        for(Account ac : newlist){
            if(ac.Name== null){
                Accaname.add(ac.Name);
            }
            list<Contact> conde = [SELECT id,Name FROM contact Where Name IN : Accaname];
            delete conde;
        }
    }
    public static void CreCon(list<Contact> newlist){
        set<string> setstr = new set<string>();
        for(Contact con : newlist){
            if(con.Name==null){
                setstr.add(con.Name);
            }
            set<string> dupliset = new set<string>();
            for(Account ac : [Select id,Name From Account Where id In:setstr]){
                dupliset.add(ac.Name);
            }
            for(Contact co : newlist){
                if(dupliset.Contains(co.Name)){
                    co.addError('Conatcts conatin Information');
                }
            }
        }
    }
    public static void creinsert(list<Account> newlist){
        for(Account ac : newlist){
            if(ac.Name== null){
                Account acc = new Account();
                acc.Name = ac.Name+'Mr';
                insert acc;
            }
        }
    }
    public static void delc (list<Account> acclist){
        set<string> accName = new set<string>();
        for(Account acc : acclist){
            if(acc.Name== null){
                accName.add(acc.Name);
            }
            list<contact> conlist = [select id,Name from Contact where Name In:accName];
            delete conlist;
        }
    }
    public static void crcon(list<Contact> newlist){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.Accountid == null){
                accids.add(con.Accountid);
            }
            list<Account> acclist = [SELECT id,Phone,(SELECT id,Phone From Contacts Where Id In :newlist)from Account Where id In :accids];
            for(Account ac : acclist){
                if(ac.Contacts.Size()==1){
                    Contact co = new Contact();
                    co.Phone = ac.Phone;
                }
            }
            update acclist;
        }
    }
    public static void diplime(list<Account> newlist){
        set<string> accstr = new set<string>();
        for(Account ac : newlist){
            if(ac.Name ==null){
                accstr.add(ac.Name);
            }
            set<string>duplicate = new set<string>();
            for(Account acm: [select id,Name From Account Where Name in : accstr]){
                duplicate.add(acm.Name);
            }
            for(Account acc : newlist){
                if(duplicate.contains(acc.Name)){
                    acc.adderror('Duplicate');
                }
            }
            
        }
        
    }
    public static void PopulatePhone(list<Account> newlist,map<id,Account> oldmap){
        list<Account> acclist = new list<Account>();
        map<id,string> accupdatephone = new map<id,string>();
        for(Account ac : newlist){
            if(oldmap.get(ac.id).Phone !=ac.Phone){
                accupdatephone.put(ac.id,ac.Phone);
            }
        }
    }
    //When we are trying to insert new record into object. If there is any record existing with 
    //same account name it should prevent duplicate record.
    public static void dupliRecord(list<Contact> newlist){
        set<string> Acstring = new set<string>();
        for(Contact con : newlist){
            if(con.Accountid == null){
                Acstring.add(con.Accountid);
            }
            set<String> ExitString = new set<string>();
            for(Account ac : [SELECT id,Name From Account Where Name In :Acstring]){
                ExitString.add(ac.Name);
            }
            for(contact coon : newlist){
                if(ExitString.Contains(coon.Name)){
                    coon.adderror('Duplicate Name Already Exist');
                }
            }
        }  
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
    
    public static void creteconUp(list<contact>newlist,map<id,Contact> oldmap){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.Accountid != null && con.Phone!=oldmap.get(con.id).Phone || con.Email !=oldmap.get(con.id).Email){
                accids.add(con.Accountid); 
            }
            list<Account> acclist = [select id,Phone,Email__c FROM Account Where Id In :accids];
            map<id,Account> accmap =  new map<id,Account>();
            for(Account ac:acclist){
                accmap.put(ac.id,ac); 
            }
            list<Account> acctoupdate = new list<Account>();
            for(contact cons : newlist){
                if(accmap.containskey(cons.Accountid)){
                    accmap.get(cons.Accountid).Phone = cons.Phone;
                    accmap.get(cons.Accountid).Email__c = cons.Email;
                }
                acctoupdate.add(accmap.get(con.Accountid));
                
            }
            update acctoupdate;
        }
    }
    public static void accDesc(list<Contact> newlist,map<id,Contact>oldmap){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.Accountid != null && con.Description !=oldmap.get(con.Accountid).Description){
                accids.add(con.Accountid);
                
            }
            map<id,Account> newmap = new map<id,Account>([select id,Description FROM Account Where Id IN : accids]);
            list<Account> acclist = new list<Account>();
            for(Contact coon : newlist){
                Account ac = newmap.get(coon.Accountid);
                ac.Description=coon.Description;
                acclist.add(ac);
            }
            update acclist;
        }
    }
    public static void ConDe(List<Contact>newlist,map<id,contact>oldmap){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.Accountid!=null &&con.Description != oldmap.get(con.AccountId).Description){
                accids.add(con.Accountid);
            }
            map<id,Account> accmap = new map<id,Account>([SELECT id,Description FROM Account Where Id In : accids]);
            list<Account> acclist = new list<Account>();
            for(Contact conn : newlist){
                Account ac = accmap.get(conn.Accountid);
                ac.Description=conn.Description;
                acclist.add(ac);
            }
            update acclist;
        }
    }
    public static void Customroll(list<Contact>newlist){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.AccountId != null){
                accids.add(con.AccountId);
            }
            list<Account> acclist = new list<Account>();
            for(Account ac : [SELECT id,(Select Accountid FROM Contacts)FROM Account Where Id In : accids]){
                ac.Count__c=ac.contacts.size();
                acclist.add(ac);
            }
            update acclist;
        }
    }
    public static void con2Account(list<Contact>newlist){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.Accountid != null){
                accids.add(con.AccountId);
            }
            map<id,Integer> accmap = new map<id,Integer>();
            list<AggregateResult> acccount = [SELECT Accountid,Count(id)ct FROM Contact Where Accountid In : accids Group by Accountid];
            for(AggregateResult ar : acccount){
                accmap.put((id)ar.get('Accountid'),(integer)ar.get('ct'));
            }
            for(Contact conn : newlist){
                if(conn.AccountId!= null && accmap.get(conn.AccountId)>=2){
                    conn.adderror('2 contact not');
                }
            }
        }
    }
    public static void Atleast2(list<contact>newlist){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.Accountid!=null){
                accids.add(con.AccountId);
            }
            map<id,Integer> accmap = new map<id,Integer>();
            list<AggregateResult> accm = [SELECT Accountid,Count(id)ct FROM Contact Where Accountid In: accids Group by Accountid];
            for(AggregateResult ag : accm){
                accmap.put((Id)ag.get('Accountid'),(Integer)ag.get('ct'));
            }
            for(Contact conn : newlist){
                if(conn.AccountId!=null && accmap.get(conn.AccountId)>=2){
                    conn.adderror('2 con');
                }
            }
        }
    }
    public static void curoll(list<Contact> newlist){
        set<id> accids = new set<id>();
        for(Contact conn : newlist){
            if(conn.AccountId !=null){
                accids.add(conn.AccountId);
            }
            list<Account> acclist = new list<Account>();
            for(AggregateResult ag : [Select Accountid,Count(id)ct FROM Contact Where Accountid In :accids Group by Accountid]){
                Account ac = new Account();
                ac.id = (id)ag.get('Accountid');
                ac.Count__c=(Decimal)ag.get('ct');
                acclist.add(ac);
            }
            update acclist;
        }
    }
    public static void creteCon(list<Contact>newlist){
        set<id> accids= new set<id>();
        for(Contact con : newlist){
            if(con.Phone !=null){
                accids.add(con.AccountId);
            }
            map<id,Account> accmap = new map<id,Account>();
            for(Account ac : [SELECT id,Phone FROM Account Where Id In : accids And Phone !=null]){
                accmap.put(ac.id,ac);
            }
            for(Contact conn : newlist){
                if(conn.Phone==null && accmap.containskey(conn.AccountId)){
                    con.Phone = accmap.get(conn.AccountId).Phone;
                }
            }
        }
    }
    public static void ValidFirstName(list<Contact>newlist){
        for(Contact con : newlist){
            if(con.FirstName ==null){
                con.adderror('Mandatory');
            }
        }
    }
    public static void scam(list<Contact> newlist){
        set<string> accstring = new set<String>();
        for(contact con : newlist){
            if(con.FirstName !=null){
                accstring.add(con.FirstName);
            }
            set<string> exist = new set<string>();
            for(Contact coon :[SELECT Accountid,FirstName FROM Contact Where FirstName In : accstring]){
                exist.add(coon.FirstName);
            }
            for(Contact conn : newlist){
                if(exist.contains(conn.FirstName)){
                    conn.adderror('exist field');
                }
            }
        }
    }
    public static void Roolup(list<Contact> newlist){
        set<id> accids = new set<id>();
        for(contact con : newlist){
            if(con.AccountId!=null){
                accids.add(con.AccountId);
            }
        }
        list<Account> acclist = new list<Account>();
        for(AggregateResult ag : [SELECT Accountid,Count(id)ct FROM Contact Where Accountid In : accids Group by Accountid]){
            Account ac = new Account();
            ac.id = (id)ag.get('Accountid');
            ac.Count__c=(Decimal)ag.get('ct');
            acclist.add(ac);
        }
        update acclist;
    }
    public static void ConPhoneMatch(list<Contact> newlist){
        set<id> accids = new set<id>();
        for(contact con : newlist){
            if(con.Phone!=null){
                accids.add(con.AccountId);
            }
        }
        map<id,Account> accmap = new map<id,Account>();
        for(Account ac : [SELECT Id,Phone FROM Account Where Id In : accids And Phone !=null]){
            accmap.put(ac.id,ac);
        }
        list<Contact> conlist = new list<Contact>();
        for(Contact conn : newlist){
            if(conn.Phone !=null){
                conn.Phone = accmap.get(conn.AccountId).Phone;
                conlist.add(conn);
            }
        }
        update conlist;
    }
    public static void updatephone(list<Contact> newlist){
        set<id> accids = new set<id>();
        for(contact con : newlist){
            if(con.Accountid != null){
                accids.add(con.Accountid);
            }
            map<id,Account> accmap = new map<id,Account>();
            For(Account ac : [SELEct Id,Phone FROM Account Where Id In : accids And Phone !=null]){
                accmap.put(ac.id,ac);
            }
            for(Contact coon : newlist){
                if(coon.Phone == null && accmap.containsKey(coon.AccountId)){
                    coon.Phone = accmap.get(coon.AccountId).Phone;
                }
            }
        }
    }
    public static void matchConPhoen(list<Contact> newlist){
        set<id> accids = new set<id>();
        for(Contact con : newlist){
            if(con.AccountId !=null){
                accids.add(con.AccountId);
            }
            map<id,Account> accmap = new map<id,Account>();
            for(Account ac : [SELECT Id,Phone FROM Account Where Phone !=null And Id in : accids]){
                accmap.put(ac.id,ac);
            }
            For(Contact coon : newlist){
                if(coon.Phone ==null && accmap.containskey(coon.AccountId)){
                    coon.Phone = accmap.get(coon.AccountId).Phone;
                }
            }
        }
    }
    public static void CustomRollu(List<Contact> newlist) {
        // Collect Account IDs from the Contact list
        Set<Id> accIds = new Set<Id>();
        for (Contact con : newlist) {
            if (con.AccountId != null) {
                accIds.add(con.AccountId);
            }
        }
        
        // Perform the aggregation query if there are valid Account IDs
        if (!accIds.isEmpty()) {
            List<Account> accList = new List<Account>();
            
            for (AggregateResult ag : [
                SELECT AccountId, COUNT(Id) ct 
                FROM Contact 
                WHERE AccountId IN :accIds 
                GROUP BY AccountId
            ]) {
                Account acc = new Account();
                acc.Id = (Id) ag.get('AccountId');
                acc.Number_of_Contact__c = (Integer)ag.get('ct'); // Assuming Count__c is a custom field
                accList.add(acc);
            }
            
            // Update Accounts with the new Contact counts
            if (!accList.isEmpty()) {
                update accList;
            }
        }
    }
    public static void accPhone(list<Contact>newlist){
        set<id> accids = new set<id>();
        for(contact con : newlist){
            if(con.Accountid !=null){
                accids.add(con.Accountid);
            }
            map<id,Account> accmap = new map<id,Account>();
            for(Account ac : [SELECT Id,Phone FROM Account Where Id in : accids And Phone !=null]){
                accmap.put(ac.id,ac);
            }
            for(Contact coon : newlist){
                if(coon.Phone == null && accmap.containsKey(coon.AccountId)){
                    coon.Phone = accmap.get(coon.AccountId).Phone;
                }
            }
        }
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
    public static void CretConns(list<Contact>newlist){
        List<Account> acclist = new List<Account>();
        for(Contact con : newlist){
            if(con.Accountid == null){
                Account ac = new Account();
                ac.Name = con.LastName;
                ac.Phone = con.Phone;
                acclist.add(ac);
            }
        }
        Insert acclist;
    }
    public static Void ContactLis(list<Contact>newlist){
        for(Contact con : newlist){
            if(con.AccountId == null){
                con.adderror('Account Should be Mandataory');
            }
        }
    }
    public static void createCon(){
        try{
            Contact con = new Contact();
            con.FirstName = 'MZ';
            con.Email = 'rohitkapse100@gmail.com';
            insert con;
        }catch(Exception e){
           ErrorLogClass.geterrorLogMethod(e,'ContactTriggerHandler','createCon'); 
        }
}
}