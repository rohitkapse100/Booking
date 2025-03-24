public class apexApprovalProcessClass {
    public static void processBeforeInsertOrUpdate(List<Apex_Approval_Process__c> approvalRecords) {
        if(approvalRecords.isEmpty()) return;       
        User hrCoordinator = getApprover('HR Coordinator');
        User hrManager = getApprover('HR Manager');        
        for (Apex_Approval_Process__c record : approvalRecords) {
            try {
                if (Trigger.isInsert) {
                    record.Current_Approver__c = hrCoordinator.Id;
                    record.For_Apporval_Manager_Only__c = 'Pending';
                    record.Approval_Status__c = 'In Progress';
                }
                if (record.Approver_1__c == true) { 
                    record.For_Apporval_Manager_Only__c = 'Approved';
                    record.Current_Approver__c = hrManager.Id;
                } else if (record.Rejected_1__c == true) {
                    record.Approval_Status__c = 'Rejected';
                    record.Current_Approver__c = null;
                }
                if (record.Approver_2__c == true && record.For_Apporval_Manager_Only__c == 'Approved') {
                    record.For_Lead_Approver_Only__c = 'Approved';
                    record.Approval_Status__c = 'Approved by Both';
                    record.Current_Approver__c = null;
                } else if (record.Rejected_2__c == true) { 
                    record.Approval_Status__c = 'Rejected';
                    record.Current_Approver__c = null;
                }                
            } catch (Exception e) {
                record.addError('Error in approval process: ' + e.getMessage());
            }
        }
    }
    public static void processAfterInsertOrUpdate(List<Apex_Approval_Process__c> approvalRecords, Map<Id, Apex_Approval_Process__c> oldRecords) {
        if (approvalRecords.isEmpty()) return;
        List<Apex_Approval_Process__c> notifyCoordinator = new List<Apex_Approval_Process__c>();
        List<Apex_Approval_Process__c> notifyManager = new List<Apex_Approval_Process__c>();
        List<Apex_Approval_Process__c> notifyRejection = new List<Apex_Approval_Process__c>();
        for (Apex_Approval_Process__c record : approvalRecords) {
            Apex_Approval_Process__c oldRecord = (oldRecords != null) ? oldRecords.get(record.Id) : null;
            if (oldRecord == null) {
                notifyCoordinator.add(record);
            }
            if (oldRecord != null && record.For_Apporval_Manager_Only__c == 'Approved' 
                && oldRecord.For_Apporval_Manager_Only__c != 'Approved') {
                    notifyManager.add(record);
                }
            if (record.Approval_Status__c == 'Rejected' && (oldRecord == null || oldRecord.Approval_Status__c != 'Rejected')) {
                notifyRejection.add(record);
            }
        }
        if (!notifyCoordinator.isEmpty()) sendApprovalNotification(notifyCoordinator, 'HR Coordinator');
        if (!notifyManager.isEmpty()) sendApprovalNotification(notifyManager, 'HR Manager');
        if (!notifyRejection.isEmpty()) sendRejectionNotification(notifyRejection);
    }
    private static User getApprover(String profileName) {
        try {
            return [SELECT Id, Email, Profile.Name FROM User WHERE Profile.Name = :profileName AND IsActive = TRUE LIMIT 1];
        } catch (Exception e) {
            throw new QueryException('No approver found with Profile Name "' + profileName + '". Please check the configuration.');
        }
    }
    private static void sendApprovalNotification(List<Apex_Approval_Process__c> approvalRecords, String approverType) {
        if (approvalRecords.isEmpty()) return;       
        User approver = getApprover(approverType);
        System.debug('Sending email to ' + approverType + ' - ' + approver.Email);
        String subject = 'Record Approval Required';
        String body = 'The following approvals require your attention:\n\n';
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();
        for (Apex_Approval_Process__c record : approvalRecords) {
            String recordLink = baseUrl + '/' + record.Id;
            body += '- ' + record.Name__c + ' (' + recordLink + ')\n';
        }
        sendEmail(approver.Email, subject, body);
    }
    private static void sendRejectionNotification(List<Apex_Approval_Process__c> approvalRecords) {
        if (approvalRecords.isEmpty()) return;
        String subject = 'Record Rejection Notification';
        String body = 'The following projects have been rejected:\n\n';
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();
        for (Apex_Approval_Process__c record : approvalRecords) {
            String recordLink = baseUrl + '/' + record.Id;
            body += '- ' + record.Name__c + ' (' + recordLink + ')\n';
        }
        for (Apex_Approval_Process__c record : approvalRecords) {
            User recordOwner = [SELECT Email FROM User WHERE Id = :record.OwnerId LIMIT 1];
            sendEmail(recordOwner.Email, subject, body);
        }
    }
    private static void sendEmail(String toEmail, String subject, String body) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { toEmail });
        email.setSubject(subject);
        email.setPlainTextBody(body);
        try {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { email });
            System.debug('Email sent successfully to: ' + toEmail);
        } catch (Exception e) {
            System.debug('Error sending email: ' + e.getMessage());
        }
    }
}