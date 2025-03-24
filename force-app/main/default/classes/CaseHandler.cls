public class CaseHandler {
    // Handle after insert
    public static void handleAfterInsert(List<Case> newCases) {
        Set<Id> contactIds = new Set<Id>();
        for (Case c : newCases) {
            if (c.ContactId != null) {
                contactIds.add(c.ContactId);
            }
        }
        if (!contactIds.isEmpty()) {
            updateContactFields(contactIds);
        }
    }

    // Handle after update
    public static void handleAfterUpdate(List<Case> newCases, Map<Id, Case> oldCaseMap) {
        Set<Id> contactIds = new Set<Id>();
        for (Case c : newCases) {
            if (c.ContactId != null) {
                contactIds.add(c.ContactId);
            }
            if (oldCaseMap.get(c.Id).ContactId != null) {
                contactIds.add(oldCaseMap.get(c.Id).ContactId);
            }
        }
        if (!contactIds.isEmpty()) {
            updateContactFields(contactIds);
        }
    }

    // Handle after delete
    public static void handleAfterDelete(List<Case> oldCases) {
        Set<Id> contactIds = new Set<Id>();
        for (Case c : oldCases) {
            if (c.ContactId != null) {
                contactIds.add(c.ContactId);
            }
        }
        if (!contactIds.isEmpty()) {
            updateContactFields(contactIds);
        }
    }

    // Handle after undelete
    public static void handleAfterUndelete(List<Case> newCases) {
        Set<Id> contactIds = new Set<Id>();
        for (Case c : newCases) {
            if (c.ContactId != null) {
                contactIds.add(c.ContactId);
            }
        }
        if (!contactIds.isEmpty()) {
            updateContactFields(contactIds);
        }
    }

    // Common method to update Contact fields
    private static void updateContactFields(Set<Id> contactIds) {
        // Query all related Cases for the affected Contacts
        Map<Id, List<Case>> contactCaseMap = new Map<Id, List<Case>>();

        for (Case c : [
            SELECT Id, Subject, Status, Priority, CreatedDate, ContactId
            FROM Case
            WHERE ContactId IN :contactIds
            ORDER BY CreatedDate DESC
        ]) {
            if (!contactCaseMap.containsKey(c.ContactId)) {
                contactCaseMap.put(c.ContactId, new List<Case>());
            }
            contactCaseMap.get(c.ContactId).add(c);
        }

        // Prepare updates for Contacts
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Id contactId : contactCaseMap.keySet()) {
            List<Case> cases = contactCaseMap.get(contactId);

            // Calculate fields
            Integer openCaseCount = 0;
            String latestCaseSubject = null;
            Boolean hasHighPriorityCase = false;

            for (Case c : cases) {
                if (c.Status == 'Low') {
                    openCaseCount++;
                }
                if (c.Priority == 'High') {
                    hasHighPriorityCase = true;
                }
            }

            // The most recent Case Subject is the first in the list (already sorted by SOQL)
            if (!cases.isEmpty()) {
                latestCaseSubject = cases[0].Subject;
            }

            // Prepare the Contact for update
            Contact con = new Contact(
                Id = contactId,
                Open_Case_Count__c = openCaseCount,
                Last_Case_Subject__c = latestCaseSubject,
                Has_High_Priority_Cases__c = hasHighPriorityCase
            );
            contactsToUpdate.add(con);
        }

        // Update Contacts
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}