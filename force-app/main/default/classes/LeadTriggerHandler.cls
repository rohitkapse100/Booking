public class LeadTriggerHandler {
    public static void LeadPre(list<Lead> newlist){
        set<string> leSet = new set<string>();
        for(Lead lc : newlist){
            if(lc.Email != null){
                LeSet.add(lc.Email);
            }
            Map<String, Contact> contactEmails = new Map<String, Contact>([SELECT Email FROM Contact WHERE Email IN :LeSet]);
            for(Lead lcm : newlist){
                if(lcm.Email != Null && contactEmails.Containskey(lcm.Email)){
                    lcm.addError('Lead Already Exist Contact');
                }
                
            }
        }
    }
    public static void leadacc(list<Lead> Leadlist){
        for(Lead lc : Leadlist){
            if(lc.LeadSource == 'Web'){
                lc.Rating = 'Cold';
            }else {
                lc.Rating = 'Hot';
            }
            
        }
    }
}