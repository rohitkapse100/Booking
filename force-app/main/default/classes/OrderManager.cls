public with sharing class OrderManager {

    @AuraEnabled
    public static Id createOrder(Id accountId) {
        Orders__c newOrder = new Orders__c(
            Account__c = accountId,
            Status__c = 'New',
            Total_Amount__c = 0
        );
        insert newOrder;
        return newOrder.Id;
    }

    @AuraEnabled
    public static void addProductToOrder(Id orderId, Id productId, Integer quantity) {
        Products__c product = [SELECT Id, Price__c, Stock_Level__c FROM Products__c WHERE Id = :productId LIMIT 1];

        if (product.Stock_Level__c < quantity) {
            throw new CustomException('Insufficient stock for ' + product.Name);
        }

        Order_Line_Item__c lineItem = new Order_Line_Item__c(
            Orders__c = orderId,
            Products__c = product.Id,
            Quantity__c = quantity,
            Unit_Price__c = product.Price__c
        );
        insert lineItem;

        // Reduce stock
        product.Stock_Level__c -= quantity;
        update product;

        updateOrderTotal(orderId);
    }

    public static void updateOrderTotal(Id orderId) {
        Decimal totalAmount = 0;

        // Query all line items and calculate the total manually in Apex
        List<Order_Line_Item__c> lineItems = [SELECT Quantity__c, Unit_Price__c FROM Order_Line_Item__c WHERE Orders__c = :orderId];

        for (Order_Line_Item__c item : lineItems) {
            totalAmount += (item.Quantity__c * item.Unit_Price__c);
        }

        // Update the total amount on the order
        Orders__c orderToUpdate = new Orders__c(Id = orderId, Total_Amount__c = totalAmount);
        update orderToUpdate;
    }

    public class CustomException extends Exception {}
}