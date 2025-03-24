public class OrderProcessingPublisher {
    public static void publishOrder(String orderId, String customerName, Date orderDate, 
                                    String productName, Integer quantity) {
        Order_Processing__e eventMsg = new Order_Processing__e(
            OrderId__c = orderId,
            CustomerName__c = customerName,
            Order_Date__c = orderDate,
            Product_Name__c = productName,
            Quantity__c = quantity
        );

        EventBus.publish(eventMsg);
    }
}