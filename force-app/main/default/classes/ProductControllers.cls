public with sharing class ProductControllers {
    public class ProductOptionWrapper {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public ProductOptionWrapper(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ProductOptionWrapper> getProducts() {
        List<ProductOptionWrapper> options = new List<ProductOptionWrapper>();
        for (Products__c product : [SELECT Id, Name FROM Products__c WHERE Stock_Level__c > 0]) {
            options.add(new ProductOptionWrapper(product.Id, product.Name));
        }
        return options;
    }
}