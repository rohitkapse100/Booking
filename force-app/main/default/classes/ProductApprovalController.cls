public with sharing class ProductApprovalController {
    @AuraEnabled
    public static Product2 getProductDetails(Id productId) {
        try {
            return [
                SELECT Id, Name, ProductCode, Description, Approval_Status__c, Approver__c
                FROM Product2
                WHERE Id = :productId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching product details: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String approveOrRejectProduct(Id productId, String action, String comment) {
        try {
            Product2 product = [SELECT Id, Name, Approval_Status__c, Approver__c FROM Product2 WHERE Id = :productId LIMIT 1];

            // Update the approval status based on action
            if (action == 'Approve') {
                product.Approval_Status__c = 'Approved';
            } else if (action == 'Reject') {
                product.Approval_Status__c = 'Rejected';
            }
            update product;

            // Send email notification
            sendApprovalEmail(product, action, comment);

            return 'Product ' + action + ' successfully.';
        } catch (Exception e) {
            throw new AuraHandledException('Error updating product status: ' + e.getMessage());
        }
    }

    // Method to send an email notification
    private static void sendApprovalEmail(Product2 product, String action, String comment) {
        try {
            // Fetch the approver's email (assuming Approver__c is a User field)
            User approver = [SELECT Email FROM User WHERE Id = :product.Approver__c LIMIT 1];

            // Email content
            String subject = 'Product Approval Update: ' + product.Name;
            String body = 'The product "' + product.Name + '" has been ' + action.toLowerCase() + '.\n\n'
                + 'Comments: ' + comment + '\n\n'
                + 'Thank you,\nProduct Approval Team';

            // Create the email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { approver.Email });
            email.setSubject(subject);
            email.setPlainTextBody(body);

            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            System.debug('Email sent to: ' + approver.Email);
        } catch (Exception e) {
            // Log any errors in email sending
            System.debug('Error sending email: ' + e.getMessage());
        }
    }
}