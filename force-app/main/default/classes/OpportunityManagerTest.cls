@isTest
public class OpportunityManagerTest {
    @isTest
    static void testCreateOpportunity() {
        // Create test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Call the method to create an opportunity
        Opportunity opp = OpportunityManager.createOpportunity(testAccount.Id, 'Test Opportunity', 1000);
        
        // Verify the opportunity was created
        Opportunity retrievedOpp = [SELECT Id, Name, StageName, Amount, AccountId FROM Opportunity WHERE Id = :opp.Id];
        System.assert(retrievedOpp != null, 'The opportunity should be created.');
        System.assertEquals('Test Opportunity', retrievedOpp.Name, 'The opportunity name should match.');
        System.assertEquals('Prospecting', retrievedOpp.StageName, 'The opportunity stage should be Prospecting.');
        System.assertEquals(1000, retrievedOpp.Amount, 'The opportunity amount should match.');
        System.assertEquals(testAccount.Id, retrievedOpp.AccountId, 'The account ID should match.');
    }

    @isTest
    static void testAssociateContactWithOpportunity() {
        // Create test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Create test contact
        Contact testContact = new Contact(LastName = 'Test Contact');
        insert testContact;
        
        // Create test opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testAccount.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addMonths(1),
            Amount = 1000
        );
        insert testOpportunity;
        
        // Call the method to associate the contact with the opportunity
        OpportunityManager.associateContactWithOpportunity(testOpportunity.Id, testContact.Id);
        
        // Verify the contact was associated with the opportunity
        OpportunityContactRole retrievedRole = [
            SELECT Id, OpportunityId, ContactId, Role FROM OpportunityContactRole 
            WHERE OpportunityId = :testOpportunity.Id AND ContactId = :testContact.Id
        ];
        System.assert(retrievedRole != null, 'The contact should be associated with the opportunity.');
        System.assertEquals(testOpportunity.Id, retrievedRole.OpportunityId, 'The opportunity ID should match.');
        System.assertEquals(testContact.Id, retrievedRole.ContactId, 'The contact ID should match.');
        System.assertEquals('Decision Maker', retrievedRole.Role, 'The role should be Decision Maker.');
    }

    @isTest
    static void testGetOpportunitiesByContact() {
        // Create test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Create test contact
        Contact testContact = new Contact(LastName = 'Test Contact');
        insert testContact;
        
        // Create test opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testAccount.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addMonths(1),
            Amount = 1000
        );
        insert testOpportunity;
        
        // Associate contact with opportunity
        OpportunityContactRole testRole = new OpportunityContactRole(
            OpportunityId = testOpportunity.Id,
            ContactId = testContact.Id,
            Role = 'Decision Maker'
        );
        insert testRole;
        
        // Call the method to get opportunities by contact
        List<Opportunity> opportunities = OpportunityManager.getOpportunitiesByContact(testContact.Id);
        
        // Verify the opportunities were retrieved
        System.assert(opportunities != null, 'The list of opportunities should not be null.');
        System.assertEquals(1, opportunities.size(), 'There should be one opportunity retrieved.');
        Opportunity retrievedOpp = opportunities[0];
        System.assertEquals(testOpportunity.Id, retrievedOpp.Id, 'The opportunity ID should match.');
        System.assertEquals('Test Opportunity', retrievedOpp.Name, 'The opportunity name should match.');
        System.assertEquals('Prospecting', retrievedOpp.StageName, 'The opportunity stage should match.');
        System.assertEquals(1000, retrievedOpp.Amount, 'The opportunity amount should match.');
    }
}