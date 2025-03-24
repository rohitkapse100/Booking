public class BatchErrorLogClass implements database.batchable<sobject>{
    public database.QueryLocator start(database.BatchableContext bc){
        string Que = 'Select id,error_Message__c, Class_Name__c, Method_Name__c from  errorLog__c';
        return database.getQueryLocator(Que);
    }
    public Void execute(database.BatchableContext bc,List<errorLog__c> Data){
        
        
    }
    public void finish(database.BatchableContext bc){
        
    }
    

}