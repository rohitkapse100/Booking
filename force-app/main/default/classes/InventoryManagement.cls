public class InventoryManagement {
    public static void processStockTransactions(List<Stock_Transactions__c> transactions) {
        Map<Id, Decimal> stockChanges = new Map<Id, Decimal>();

        // Calculate stock changes from transactions
        for (Stock_Transactions__c txn : transactions) {
            if (!stockChanges.containsKey(txn.Product__c)) {
                stockChanges.put(txn.Product__c, 0);
            }
            if (txn.Transaction_Type__c == 'Restock') {
                stockChanges.put(txn.Product__c, stockChanges.get(txn.Product__c) + txn.Quantity__c);
            } else if (txn.Transaction_Type__c == 'Sale') {
                stockChanges.put(txn.Product__c, stockChanges.get(txn.Product__c) - txn.Quantity__c);
            }
        }

        // Query inventory records to update
        List<Product_Inventory__c> inventoryList = [
            SELECT Id, Product__c, Quantity_Available__c, Reorder_Level__c, Low_Stock__c
            FROM Product_Inventory__c
            WHERE Product__c IN :stockChanges.keySet()
        ];

        // Update stock levels and low-stock flags
        for (Product_Inventory__c inventory : inventoryList) {
            if (stockChanges.containsKey(inventory.Product__c)) {
                inventory.Quantity_Available__c += stockChanges.get(inventory.Product__c);
                inventory.Low_Stock__c = inventory.Quantity_Available__c <= inventory.Reorder_Level__c;
            }
        }

        // Save the updated inventory records
        if (!inventoryList.isEmpty()) {
            update inventoryList;
        }
    }
}