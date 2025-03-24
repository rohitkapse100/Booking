public class bankDetailController {
    public class BankDeatilWrapper{
        @auraEnabled public String MICR;
        @auraEnabled public String BRANCH;
        @auraEnabled public String ADDRESS;
        @auraEnabled public String STATE;
        @auraEnabled public String CONTACT;
        @auraEnabled public boolean UPI;
        @auraEnabled public boolean RTGS;
        @auraEnabled public String CITY;
        @auraEnabled public String CENTRE;
        @auraEnabled public String DISTRICT;
        @auraEnabled public boolean NEFT;
        @auraEnabled public boolean IMPS;
        @auraEnabled public String ISO3166;
        @auraEnabled public String BANK;
        @auraEnabled public String BANKCODE;
        @auraEnabled public String IFSC;
    }
    @auraEnabled
    public static BankDeatilWrapper fetchbankdetail(String IFSCCode){
        String apiendpoint;
        BankDeatilWrapper bankDetail = new BankDeatilWrapper();
        Web_Service_Configuration__mdt apiPoint =[SELECT id, 	url__c FROM Web_Service_Configuration__mdt];
        map<string, string> mapData = new map<string, string>();
        if(apiPoint != null ){
            apiendpoint = apiPoint.URL__c +IFSCCode;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiendpoint);
            request.setMethod('GET');
            try{
                HttpResponse response = http.send(request);
                System.debug('Response body ' + response.getBody());
                if(response.getStatusCode() == 200) {
                    //JSONParser parser = JSON.createParser(response.getBody());
                    bankDetail= (BankDeatilWrapper)JSON.deserialize(response.getBody(), BankDeatilWrapper.class);
                    system.debug('data===>'+bankDetail);
                    // bankDetail.ADDRESS=
                    //  mapData.put(bankDetail.ADDRESS)
                    return bankDetail;
                }
            }catch(Exception e){
                System.debug('error msg'+e.getMessage()+'line no'+e.getLineNumber());
                return null;
            }
        }
        return bankDetail;
    }
    @AuraEnabled
    public static void CreateBankDetail( string ifsc , string BankName, string branch, string Address, string city, string state){
        Bank_Detail__c BD = new Bank_Detail__c();
        BD.ifsc__c=ifsc;
        BD.Bank_Name__c=BankName;
        BD.Branch__c=branch;
        BD.Address__c=Address;
        BD.City__c=city;
        BD.State__c=state;
        Insert BD;
    }
}