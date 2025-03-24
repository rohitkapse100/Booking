public class revisionClass {
    public static void getMultipleCon(){
        //Create a map where accountId against accountName
    Map<Id, String> accMap = new Map<Id, String>();
    List<Account> accountList = [SELECT Id, Name FROM Account];
    for(Account acc : accountList){
    accMap.put(acc.Id, acc.Name);
    system.debug(accMap);
}
    }
    
}