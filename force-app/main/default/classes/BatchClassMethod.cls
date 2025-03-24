public class BatchClassMethod implements database.Batchable<sobject> {
    public database.QueryLocator start( database.BatchableContext bc){
        string Query = 'SELECT id,Name FROM Contact Where AccountId = null';
        return database.getQueryLocator(Query);
    }
    public Void execute(database.BatchableContext bc,List<Contact> Data){
        Account acc = new Account();
        acc.Name = 'Batch Account';
        insert acc;
        For(Contact con : Data){
            con.AccountId = acc.id;
        }
        update acc;
    }
    public void finish(database.BatchableContext bc){
        
    }

}