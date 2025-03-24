public class CampaignMetricsHelper {
    public static void updateCampaignMetrics(List<CampaignMember> members) {
        // Collect Campaign IDs and related Lead IDs
        Set<Id> campaignIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();

        for (CampaignMember cm : members) {
            if (cm.CampaignId != null) {
                campaignIds.add(cm.CampaignId);
            }
            if (cm.LeadId != null) {
                leadIds.add(cm.LeadId);
            }
        }

        // Query Leads to check their IsConverted status
        Map<Id, Lead> leadMap = new Map<Id, Lead>([
            SELECT Id, IsConverted
            FROM Lead
            WHERE Id IN :leadIds
        ]);

        // Aggregate data for affected Campaigns
        Map<Id, Campaign> campaignMap = new Map<Id, Campaign>();
        for (CampaignMember cm : members) {
            if (cm.CampaignId == null) continue;

            if (!campaignMap.containsKey(cm.CampaignId)) {
                campaignMap.put(cm.CampaignId, new Campaign(
                    Id = cm.CampaignId,
                    Total_Leads__c = 0,
                    Total_Contacts__c = 0,
                    Converted_Leads__c = 0
                ));
            }

            Campaign campaign = campaignMap.get(cm.CampaignId);

            if (cm.Status == 'Active') { // Exclude inactive members
                if (cm.LeadId != null) {
                    campaign.Total_Leads__c++;
                    if (leadMap.containsKey(cm.LeadId) && leadMap.get(cm.LeadId).IsConverted) {
                        campaign.Converted_Leads__c++;
                    }
                } else if (cm.ContactId != null) {
                    campaign.Total_Contacts__c++;
                }
            }
        }

        // Update Campaigns
        update campaignMap.values();
    }
}