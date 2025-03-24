public class OrderProcessingCallout {
    @future(callout=true)
    public static void sendData(String orderId, String customerName, Decimal totalAmount) {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://webhook-test.com/ff0a330ae89c4e8d94aeddad9e656af6');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');            
            Map<String, Object> Result = new Map<String, Object>();
            Result.put('Order_ID', orderId);
            Result.put('Order_Amount', totalAmount);
            Result.put('Customer_Name', customerName);           
            request.setBody(JSON.serialize(Result));
            HttpResponse response = http.send(request);
            System.debug('Response: ' + response.getBody());
        } catch (Exception e) {
            System.debug('Error in HTTP Callout: ' + e.getMessage());
        }
    }
}