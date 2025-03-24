public class Programs {
    public void createContact(string fName,string lName){
        list<contact> conlist =new list<contact>();
        contact var =new contact();
        var.FirstName =fName;
        var.LastName =lName;
        conlist.add(var);  
    insert conlist ;   
    }
    public list<contact> fetchContact(){
        list<contact> conlist =new list<contact>();
        conlist =[SELECT Id,FirstName, LastName, Email FROM Contact];
        return conlist;
    } 
    public void fetchContact1(string Accountid){
        list<contact> colist =new list<contact>();
        colist=[SELECT Id,AccountId, FirstName, LastName, Email FROM Contact where AccountId =:Accountid];
        System.debug(colist);
        
    }
}