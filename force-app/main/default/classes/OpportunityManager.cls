public class OpportunityManager {
    public static Opportunity createOpportunity(Id accountId, String opportunityName, Decimal amount) {
        Opportunity opp = new Opportunity(
            Name = opportunityName,
            AccountId = accountId,
            StageName = 'Prospecting',
            CloseDate = Date.today().addMonths(1),
            Amount = amount
        );
        insert opp;
        return opp;
    }

    public static void associateContactWithOpportunity(Id opportunityId, Id contactId) {
        OpportunityContactRole existingRole = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId = :opportunityId AND ContactId = :contactId LIMIT 1 ];
        if (existingRole == null) {
            OpportunityContactRole role = new OpportunityContactRole(
                OpportunityId = opportunityId,
                ContactId = contactId,
                Role = 'Decision Maker'
            );
            insert role;
        }
    }
    public static List<Opportunity> getOpportunitiesByContact(Id contactId) {
        List<OpportunityContactRole> roles = [SELECT OpportunityId FROM OpportunityContactRole WHERE ContactId = :contactId];
        
        List<Id> opportunityIds = new List<Id>();
        for (OpportunityContactRole role : roles) {
            opportunityIds.add(role.OpportunityId);
        }
        
        return [SELECT Id, Name, StageName, Amount FROM Opportunity WHERE Id IN :opportunityIds];
    }
}