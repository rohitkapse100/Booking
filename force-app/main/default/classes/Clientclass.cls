public class Clientclass {
    public void createcontact(string fName,string lName, integer numofContact){
        
        list<contact> conList = new list<contact>();
        for(integer i=0;i<numofContact;i++){
            contact con = new contact();
            con.firstName=fName;
            con.lastname=lName;
            conList.add(con);
        }
        insert conList;
    } 
   
    public void deleteContact(string fName,string lName,string id){
        list<contact> deleteCon = new list<contact>();
        deleteCon = [ SELECT id FROM Contact WHERE id =: id AND firstName =: fName AND lastName =: lName];
        delete deleteCon;
    }


    public void sum(){
        integer no1=100;
        integer no2=200;
        integer add =no1+no2;
        system.debug(add);
    }
    public void add(integer no1,integer no2){
        system.debug('no1--'+no1);
         system.debug('no2--'+no2);
        integer sum=no1+no2;
        system.debug(sum);
        
    }
    public void fullName(string fName,string lName){
        string fullName= fName+lName;
        system.debug(fullName);
    }
    
    public integer sum (integer num1,Integer num2){
        integer add = num1+num2;
        return add;
        
    }
    public list<contact> FetchContact(string Name){
        list<contact> clist = new list<contact>();
        clist = [SELECT id, firstName,lastName FROM Contact WHERE lastName =: Name];
        return clist;
    }  
    public list<opportunity> getRecent(list<string> stageNames){
        List<Opportunity> recentOpportunity = new List<Opportunity>();
        recentOpportunity= [SELECT Id, Name, StageName, LastModifiedDate FROM Opportunity WHERE StageName =:stageNames ORDER BY LastModifiedDate DESC Limit 10];
        return recentOpportunity;
}
    public map<id,integer> CalculateCO(list<id> AccountIds){
        map<id,integer> result = new map<id,integer>();
        list<Account> AccWithCO = new list<Account>();
        AccWithCO = [SELECT Id, (SELECT Id FROM Contacts), (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :accountIds];
        for(Account ac:AccWithCO){
            Integer contactCount = ac.Contacts.size();
            Integer opportunityCount = ac.Opportunities.size();
            Integer totalCount = contactCount + opportunityCount;
            result.put(ac.Id, totalCount);
        }
        return result;
    }
    public integer getemailId(string Email){
        list<lead> getlead = new list<lead>();
        getlead = [SELECT Email, Id FROM Lead WHERE Email =: Email];
        return getlead.size();
    }
    public list<contact> getRecentContact(){
        list<contact> aclist = new list<contact>();
        aclist = [SELECT Id,Name,createddate FROM Contact ORDER BY createddate DESC LIMIT 5];
        return aclist;
    }
    public integer getc(id accountId){
        integer numOfContacts;
        list<Account> acc = [SELECT id,Active__c FROM Account WHERE id=:accountId];
        if (acc.Size()>0){
            for(Account ac: acc){
                if(ac.Active__c =='Yes'){
                    list<contact> cc =[SELECT id FROM Contact WHERE accountid=:ac.Id];
                    numOfContacts = cc.size();
                }
            }
    }
    return numOfContacts;
}
}