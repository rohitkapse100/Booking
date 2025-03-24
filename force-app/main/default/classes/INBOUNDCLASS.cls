@restresource(urlMapping='/cic10class/*')
global class INBOUNDCLASS{
    @httpGet
    global static List<Account> getAccounts(){
        return [SELECT Id, Name FROM Account];
    }
    @httpPost
    global static String createAccount(){
        String response = '';
        try{
            String requestBody = RestContext.request.requestBody.toString();
            Map<String , Object> responseMap = (Map<String , Object>) JSON.deserializeUntyped(requestBody);
            System.debug('responseMap: '+responseMap);
            
            Account account = new Account();
            account.Name = (String) responseMap.get('FirstName') + ' ' + (String) responseMap.get('LastName');
            account.Phone = (String) responseMap.get('Phone');
            account.Website = (String) responseMap.get('Website');
            account.YearStarted = (String) responseMap.get('Year');
            insert account;
            
            response = 'Created';
        }
        catch(Exception ex){
            response = 'Not Created';
        }
        return response;
    }
}