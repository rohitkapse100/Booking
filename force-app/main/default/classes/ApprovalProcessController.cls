public class ApprovalProcessController {
    // Static variable to track recursion
    private static Boolean isProcessing = false;
    
    // Method to approve the record
    public static void approveRecord(Id recordId) {
        if (isProcessing) {
            return; // Prevent recursion
        }
        
        try {
            isProcessing = true;  // Set flag to true to prevent recursion

            Approval_Process__c record = [SELECT Id, Approval_Status__c, Step_Number__c FROM Approval_Process__c WHERE Id = :recordId LIMIT 1];
        
            if (record.Approval_Status__c == 'Pending') {
                record.Approval_Status__c = 'Approved';
                // Increment step if multi-step logic applies
                record.Step_Number__c = (record.Step_Number__c != null) ? record.Step_Number__c + 1 : 1;
                update record;
            } else {
                throw new CustomException('Record is not in Pending status and cannot be approved.');
            }
        } catch (Exception e) {
            throw e; // Handle any exceptions that occur
        } finally {
            isProcessing = false;  // Reset the flag after processing
        }
    }

    // Method to reject the record
    public static void rejectRecord(Id recordId) {
        if (isProcessing) {
            return; // Prevent recursion
        }

        try {
            isProcessing = true;  // Set flag to true to prevent recursion

            Approval_Process__c record = [SELECT Id, Approval_Status__c FROM Approval_Process__c WHERE Id = :recordId LIMIT 1];
        
            if (record.Approval_Status__c == 'Pending') {
                record.Approval_Status__c = 'Rejected';
                update record;
            } else {
                throw new CustomException('Record is not in Pending status and cannot be rejected.');
            }
        } catch (Exception e) {
            throw e; // Handle any exceptions that occur
        } finally {
            isProcessing = false;  // Reset the flag after processing
        }
    }

    // Custom exception class for handling errors
    public class CustomException extends Exception {}
}