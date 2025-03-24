@isTest
public class InventoryManagementTest {
    @isTest
    static void testUpdateStockLevels() {
        // Step 1: Create a Product record (assuming Product__c is a lookup to Product2 or similar)
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        // Step 2: Create a Product_Inventory__c record linked to the product
        Product_Inventory__c inventory = new Product_Inventory__c(
            Product__c = testProduct.Id, // Use the valid Product Id here
            Quantity_Available__c = 50,
            Reorder_Level__c = 20
        );
        insert inventory;

        // Step 3: Create Stock_Transactions__c records linked to the same product
        List<Stock_Transactions__c> transactions = new List<Stock_Transactions__c>{
            new Stock_Transactions__c(Product__c = testProduct.Id, Transaction_Type__c = 'Restock', Quantity__c = 30),
            new Stock_Transactions__c(Product__c = testProduct.Id, Transaction_Type__c = 'Sale', Quantity__c = 40)
        };
        insert transactions;

        // Step 4: Verify stock levels after transactions
        inventory = [SELECT Quantity_Available__c, Low_Stock__c FROM Product_Inventory__c WHERE Id = :inventory.Id];
        System.assertEquals(40, inventory.Quantity_Available__c); // 50 + 30 - 40
        System.assertEquals(false, inventory.Low_Stock__c); // Still above reorder level
    }
}