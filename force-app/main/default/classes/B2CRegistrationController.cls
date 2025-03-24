public with sharing class B2CRegistrationController {
    @AuraEnabled
    public static String registerContact(String firstName, String lastName, String email, String phone) {
        try {
            // Check if Contact already exists
            List<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email = :email LIMIT 1];
            if (!existingContacts.isEmpty()) {
                return 'Error: A user with this email already exists.';
            }

            // Create new Contact
            Contact newContact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Phone = phone
            );

            insert newContact;
            return 'Success: Registration completed!';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}