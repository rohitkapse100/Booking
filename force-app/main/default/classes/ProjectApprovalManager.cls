public class ProjectApprovalManager {
    
    // Handle before insert or update
    public static void handleBeforeInsertOrUpdate(List<Project__c> projects) {
        if (projects.isEmpty()) return;
        
        User hrCoordinator = getApprover('HR Coordinator');
        User hrManager = getApprover('HR Manager');
        
        for (Project__c project : projects) {
            try {
                // Step 1: Assign First Approver (HR Coordinator) on creation
                if (Trigger.isInsert) {
                    project.Current_Approver__c = hrCoordinator.Id;
                    project.For_Apporval_Manager_Use_Only__c = 'Pending'; // Default status for HR Coordinator
                }

                // Step 2: HR Coordinator Approval
                if (project.Approver_1__c == true) { // If approved
                    project.For_Apporval_Manager_Use_Only__c = 'Approved';
                    project.Current_Approver__c = hrManager.Id; // Move to HR Manager
                } else if (project.Rejected_1__c == true) { // If rejected
                    project.Approval_Status__c = 'Rejected';
                    project.Current_Approver__c = null;
                }

                // Step 3: HR Manager Approval (only if HR Coordinator approved)
                if (project.Approver_2__c == true && project.For_Apporval_Manager_Use_Only__c == 'Approved') {
                    project.For_VP_Approver_Only__c = 'Approved';
                    project.Approval_Status__c = 'Approved by Both';
                    project.Current_Approver__c = null; // No further approvals
                } else if (project.Rejected_2__c == true) { // If rejected by HR Manager
                    project.Approval_Status__c = 'Rejected';
                    project.Current_Approver__c = null;
                }
                
            } catch (Exception e) {
                project.addError('Error in approval process: ' + e.getMessage());
            }
        }
    }

    // Handle after insert/update to send email notifications
    public static void handleAfterInsertOrUpdate(List<Project__c> projects, Map<Id, Project__c> oldProjects) {
        if (projects.isEmpty()) return;

        List<Project__c> notifyCoordinator = new List<Project__c>();
        List<Project__c> notifyManager = new List<Project__c>();
        List<Project__c> notifyRejection = new List<Project__c>();

        for (Project__c project : projects) {
            Project__c oldProject = (oldProjects != null) ? oldProjects.get(project.Id) : null;

            // Send email when HR Coordinator is assigned (first email)
            if (oldProject == null) { // New record
                notifyCoordinator.add(project);
            }

            // Notify HR Manager when Coordinator approves
            if (oldProject != null && project.For_Apporval_Manager_Use_Only__c == 'Approved' 
                && oldProject.For_Apporval_Manager_Use_Only__c != 'Approved') {
                notifyManager.add(project);
            }

            // Send rejection email
            if (project.Approval_Status__c == 'Rejected' && (oldProject == null || oldProject.Approval_Status__c != 'Rejected')) {
                notifyRejection.add(project);
            }
        }

        // Send notifications
        if (!notifyCoordinator.isEmpty()) sendApprovalNotification(notifyCoordinator, 'HR Coordinator');
        if (!notifyManager.isEmpty()) sendApprovalNotification(notifyManager, 'HR Manager');
        if (!notifyRejection.isEmpty()) sendRejectionNotification(notifyRejection);
    }

    // Get approver by profile name
    private static User getApprover(String profileName) {
        try {
            return [
                SELECT Id, Email, Profile.Name 
                FROM User 
                WHERE Profile.Name = :profileName AND IsActive = TRUE 
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new QueryException('No approver found with Profile Name "' + profileName + '". Please check the configuration.');
        }
    }

    // Send approval notification email
    private static void sendApprovalNotification(List<Project__c> projects, String approverType) {
        if (projects.isEmpty()) return;
        
        User approver = getApprover(approverType);
        System.debug('Sending email to ' + approverType + ' - ' + approver.Email);
        
        String subject = 'Project Approval Required';
        String body = 'The following projects require your approval:\n\n';
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm(); // Convert Url to String

        for (Project__c project : projects) {
            String recordLink = baseUrl + '/' + project.Id;
            body += '- ' + project.Name + ' (' + recordLink + ')\n';
        }

        sendEmail(approver.Email, subject, body);
    }

    // Send rejection notification email
    private static void sendRejectionNotification(List<Project__c> projects) {
        if (projects.isEmpty()) return;

        String subject = 'Project Rejected Notification';
        String body = 'The following projects have been rejected:\n\n';
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm(); // Convert Url to String

        for (Project__c project : projects) {
            String recordLink = baseUrl + '/' + project.Id;
            body += '- ' + project.Name + ' (' + recordLink + ')\n';
        }

        // Send email to record owners
        for (Project__c project : projects) {
            User projectOwner = [SELECT Email FROM User WHERE Id = :project.OwnerId LIMIT 1];
            sendEmail(projectOwner.Email, subject, body);
        }
    }

    // Generic method to send email
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