public class SchedulableClass implements Schedulable {
    public void Execute (SchedulableContext sc){
        Account ac = new Account();
        ac.Name = 'SBI20';
        insert ac;
    }

}