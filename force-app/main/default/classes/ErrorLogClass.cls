public class ErrorLogClass {
    public static void geterrorLogMethod(Exception exe,string className,string methodName){
        try{
            errorLog__c erl = new errorLog__c();
            erl.Class_Name__c = className;
            erl.Method_Name__c = methodName;
            erl.error_Message__c = exe.getmessage();
            erl.Stack_Trace__c = exe.getStackTraceString();
            insert erl;            
        }catch(Exception e){
            system.debug('error while exception'+e.getmessage());
        }
        
    }

}