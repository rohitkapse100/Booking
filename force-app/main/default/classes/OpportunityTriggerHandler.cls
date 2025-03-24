public class OpportunityTriggerHandler {
    public static void AccountUpdate(List<Opportunity> newlist){
        list<Account> acclist = new list<Account>();
        for(Opportunity opp : newlist){
            if(opp.Probability > 50){
                Account ac = new Account();
                ac.id = opp.AccountId;
                ac.Vip__c =true;
                acclist.add(ac);
            }
        }
        if(acclist.Size()>0){
            update acclist;
        }
    }
    public static void checkOppstage(List<Opportunity> newlist,Map<id,Opportunity> oldMap){
        for(Opportunity opp : newlist){
            if(opp.stageName == 'Closed Lost' && oldMap.get(opp.Id).stageName == 'Closed Won'){
                opp.AddError('Cannot Change Stage to Closed Lost');
            }
        }
    }
    public static void OppProb(list<Opportunity> newlist){
        set<id> accIds = new set<id>();
        for(Opportunity opp : newlist){
            if(opp.AccountId == null){
                accIds.add(opp.id);
            }
        }
        for(Opportunity opp : newlist){
            if(opp.Probability > 50 ){
                opp.StageName = 'Needs Analysis';
            }
        }
    }
    public static void ans(List<Opportunity> oppList){
        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp: oppList){
            if(opp.Amount != null && opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
            list<Account> acclist = new list<Account>();
            for(AggregateResult ar : [Select Accountid,Sum(Amount)ct FROM Opportunity Where Accountid In : accIds Group by Accountid]){
                Account ac = new Account();
                ac.Id = (id)ar.get('Accountid');
                ac.TotalSum__c = (Decimal)ar.get('ct');
                acclist.add(ac);
            }
        update acclist;
}
    }
    public static void OppSum(List<Opportunity>newlist){
        set<id> accids = new set<id>();
        for(Opportunity op : newlist){
            if(op.Accountid!= null){
                accids.add(op.Accountid);
                
            }
            list<Account> acclist = new list<Account>();
            for(AggregateResult ag : [SELECT Accountid,Sum(Amount)ct FROM Opportunity Where Accountid In : accids Group By Accountid]){
                Account ac = new Account();
                ac.Id = (id)ag.get('Accountid');
                ac.TotalSum__c = (Decimal)ag.get('ct');
                acclist.add(ac);
            }
            update acclist;
        }
    }
    public static void Oppsumer(List<Opportunity>newlist){
        set<id> accids = new set<id>();
        for(Opportunity op : newlist){
            if(op.Account!=null){
                accids.add(op.Accountid);
            }
            list<Account> acclist = new list<Account>();
            for(AggregateResult ar : [SELECT Accountid,Sum(Amount)ct FROM Opportunity Where AccountId IN : accids Group by Accountid]){
                Account ac = new Account();
                ac.Id = (id)ar.get('Accountid');
                ac.Total_Amount__c = (Decimal)ar.get('ct');
                acclist.add(ac);
            }
            update acclist;
        }
    }
    public static void addnotPrevent(list<Contact> newlist){
        set<id> accids = new set<id>();
        for(contact con : newlist){
            if(con.Accountid!=null){
                accids.add(con.Accountid);
            }
            map<id,Integer> accmap = new map<id,Integer>();
            list<AggregateResult> result = [SELECT Accountid,Count(id)ct FROM Contact Where Accountid In : accids Group by Accountid];
            for(AggregateResult ag : result){
                accmap.put((id)ag.get('Accountid'),(Integer)ag.get('ct'));
            }
            for(Contact coon : newlist){
                if(coon.Accountid!=null && accmap.get(coon.Accountid)>=2){
                    coon.adderror('Sorry');
                }
            }
        }
    }
    public static void CustomRoll(list<Opportunity>newlist,map<id,Opportunity>oldmap){
        set<id> accids = new set<id>();
        if(newlist !=null){
        for(Opportunity op : newlist){
            if(op.Accountid !=null){
                accids.add(op.AccountId);
            }
        }
        }
        if(oldmap !=null){
        for(Opportunity op : oldmap.Values()){
            if(op.Accountid !=null){
                accids.add(op.AccountId);
            }
        }
        }
        list<Account> acclist = new list<Account>();
        for(AggregateResult ag : [SELECT Accountid,Count(id)ct FROM Opportunity Where Accountid In : accids group by Accountid]){
            Account ac = new Account();
            ac.id=(id)ag.get('Accountid');
            ac.Count__c = (Integer)ag.get('ct');
            acclist.add(ac);
        }
        update acclist;
    }
    public static void accphone(list<Opportunity>newlist,map<id,Opportunity>oldmap){
        set<id> accids = new set<id>();
        if(newlist !=null){
        for(Opportunity op : newlist){
            if(op.Accountid !=null){
                accids.add(op.AccountId);
            }
        }
        }
        if(oldmap !=null){
            for(Opportunity op : oldmap.values()){
                if(op.Accountid!=null){
                    accids.add(op.AccountId);
                }
            }
        }
    }
    public static void CustomRoll(List<Opportunity> opportunities) {
        // Step 1: Collect Account IDs from the Opportunity list
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : opportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        // Step 2: Query related Opportunities and aggregate picklist values
        if (!accountIds.isEmpty()) {
            Map<Id, Set<String>> accountPicklistValuesMap = new Map<Id, Set<String>>();

            // Query all related Opportunities for these Accounts
            List<Opportunity> relatedOpps = [
                SELECT AccountId, Picklist_Field__c
                FROM Opportunity
                WHERE AccountId IN :accountIds
            ];

            // Aggregate picklist values for each Account
            for (Opportunity opp : relatedOpps) {
                if (opp.Picklist_Field__c != null) {
                    if (!accountPicklistValuesMap.containsKey(opp.AccountId)) {
                        accountPicklistValuesMap.put(opp.AccountId, new Set<String>());
                    }
                    accountPicklistValuesMap.get(opp.AccountId).addAll(opp.Picklist_Field__c.split(';'));
                }
            }

            // Step 3: Prepare Accounts for update
            List<Account> accountsToUpdate = new List<Account>();
            for (Id accountId : accountPicklistValuesMap.keySet()) {
                Account acc = new Account(
                    Id = accountId,
                    Picklist_Field__c = String.join(new List<String>(accountPicklistValuesMap.get(accountId)), ';')
                );
                accountsToUpdate.add(acc);
            }

            // Step 4: Update Accounts
            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }
     // Method to process the Opportunities based on trigger events (insert, update, delete)
    public static void processOpportunities(List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities) {
        
        // Set to store the unique parent Account Ids
        Set<Id> parentAccountIds = new Set<Id>();

        // Add parent AccountId from the new and old Opportunities to the set
        for (Opportunity opp : newOpportunities) {
            if (opp.AccountId != null) {
                parentAccountIds.add(opp.AccountId);
            }
        }
        for (Opportunity opp : oldOpportunities) {
            if (opp.AccountId != null) {
                parentAccountIds.add(opp.AccountId);
            }
        }

        // Query parent accounts to get the necessary data
        Map<Id, Account> parentAccounts = new Map<Id, Account>(
            [SELECT Id, Total_Revenue__c, Opportunities_This_Year__c
             FROM Account
             WHERE Id IN :parentAccountIds]
        );

        // Initialize maps for aggregating values
        Map<Id, Decimal> totalRevenueMap = new Map<Id, Decimal>();
        Map<Id, Integer> oppsThisYearMap = new Map<Id, Integer>();

        Date startOfFiscalYear = Date.newInstance(Date.today().year(), 1, 1); // Start of the current fiscal year

        // Aggregate Opportunity data (Total Revenue and Opportunities This Year)
        for (Opportunity opp : newOpportunities) {
            if (opp.StageName == 'Closed Won' && opp.AccountId != null) {
                // Total Revenue
                if (!totalRevenueMap.containsKey(opp.AccountId)) {
                    totalRevenueMap.put(opp.AccountId, 0);
                }
                totalRevenueMap.put(opp.AccountId, totalRevenueMap.get(opp.AccountId) + opp.Amount);

                // Opportunities This Year
                if (opp.CloseDate >= startOfFiscalYear) {
                    if (!oppsThisYearMap.containsKey(opp.AccountId)) {
                        oppsThisYearMap.put(opp.AccountId, 0);
                    }
                    oppsThisYearMap.put(opp.AccountId, oppsThisYearMap.get(opp.AccountId) + 1);
                }
            }
        }

        // Handle Opportunity deletion and update of existing Opportunities
        for (Opportunity opp : oldOpportunities) {
            if (opp.StageName == 'Closed Won' && opp.AccountId != null) {
                // Total Revenue (subtract the deleted Opportunity's Amount)
                if (totalRevenueMap.containsKey(opp.AccountId)) {
                    totalRevenueMap.put(opp.AccountId, totalRevenueMap.get(opp.AccountId) - opp.Amount);
                }

                // Opportunities This Year (decrease the count for the deleted Opportunity)
                if (opp.CloseDate >= startOfFiscalYear) {
                    if (oppsThisYearMap.containsKey(opp.AccountId)) {
                        oppsThisYearMap.put(opp.AccountId, oppsThisYearMap.get(opp.AccountId) - 1);
                    }
                }
            }
        }

        // Prepare a list to update parent accounts
        List<Account> accountsToUpdate = new List<Account>();

        for (Id parentAccountId : parentAccountIds) {
            Account acc = parentAccounts.get(parentAccountId);
            if (acc != null) {
                // Update the Total Revenue and Opportunities This Year fields
                acc.Total_Revenue__c = totalRevenueMap.get(parentAccountId);
                acc.Opportunities_This_Year__c = oppsThisYearMap.get(parentAccountId);
                accountsToUpdate.add(acc);
            }
        }

        // Update the parent accounts with the aggregated data
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}