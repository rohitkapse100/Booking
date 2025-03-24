public class BatchC10Class implements database.Batchable<sobject> {
    public database.QueryLocator start( database.BatchableContext bc){
        string Query = 'SELECT id,Name FROM Account';
        return database.getQueryLocator(Query);
    }
    public Void execute(database.BatchableContext bc,List<Account> listOfData){
        for(Account ac : listOfData){
            ac.Name = ac.Name + 'SFDC';
        }
        update listOfData;
}
    public void finish(database.BatchableContext bc){
        
    }
}