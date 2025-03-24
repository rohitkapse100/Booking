@Restresource(urlMapping = '/leadAPI/')
global with Sharing class LeadCreateAPI {
    @HttpPost
    global static ResponseWrapper CreatLead(){
        ResponseWrapper response = new ResponseWrapper();
        string requestbody = RestContext.request.requestbody.toString();
        system.debug('Raw Request==>'+requestbody);
        try{
            map<String,Object> requestmap = (map<String,Object>)JSON.deserializeUntyped(requestbody);
            RequestWrapper req = (RequestWrapper)JSON.deserializeStrict(requestbody,RequestWrapper.class);
            ValidateRequest (req);
            Account existingAccount = FindExistAccount(req.PanNumber);
            Lead newLead = CreatLeadRecord(req,existingAccount);
            insert newLead;
            sendResponse(response,newLead,existingAccount);
            
        }catch(ValidationException ve){
            return ValidateResponse(ve.getMessage());
        }
        return response; 
    }
    global static void ValidateRequest(RequestWrapper req){
        if(string.isBlank(req.PanNumber))throw New ValidationException('PanNumber is required');
    }
    global static ResponseWrapper ValidateResponse(string Message){
        ResponseWrapper error = new ResponseWrapper();
        error.Status = 'error';
        error.Message = Message;
        return error;
    } 
  global class ValidationException extends Exception {      
  }
    public static Account FindExistAccount(string PanNumber){
        list<Account> acclist = [SELECT Id,Pan_Number__c FROM Account Where Pan_Number__c =:PanNumber limit 1];
        return acclist.isEmpty() ? null : acclist[0];        
    }
    public static Lead CreatLeadRecord(RequestWrapper req,Account acc){
        Lead ls = new Lead();
        if(acc!=null){
            ls.Account__c = acc.id;
        }
        ls.Description = req.PanNumber;
        ls.FirstName = req.FirstName;
        ls.LastName = req.LastName;
        ls.Company = req.Company;
        ls.MobilePhone = req.Mobile;
        return ls;
    }
    public static void sendResponse(ResponseWrapper reswr,Lead ld,Account acc){
        if(acc!=null){
            reswr.Status = 'Success';
            reswr.Message = 'Lead Created with The Existing Account';
            reswr.LeadNumber = ld.LeadNumber__c;
            reswr.LeadId = ld.id;
        }
        else{
            reswr.Status = 'Success';
            reswr.Message = ' New Lead Created without Account';
            reswr.LeadNumber = ld.LeadNumber__c;
            reswr.LeadId = ld.id;
        }
    }
    //Wrapper class
    global class RequestWrapper{
        public string PanNumber;
        public string FirstName;
        public string LastName;
        public string Company;
        public string Mobile;
    }
     global class ResponseWrapper{
        public string Status;
        public string Message;
        public string LeadNumber;
        public string LeadId;
    }

}