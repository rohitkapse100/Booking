public class futureExample {
    public static void futureExe(){
        Account ac = new Account();
        ac.Name = 'SBI1';
        insert ac;
        Contact con = new Contact();
        con.lastName = 'CIC10';
        insert con;
        QueueableExe que = new QueueableExe();
        string JobId = system.enqueueJob(que);
        system.debug('JobId-----'+JobId);
    }
    @future
    public static void FutureMethod(string lastName,string username,string email){
        Profile p = [SELECT id FROM Profile Where Name = 'Standard User'];
        UserRole r = [SELECT id FROM userRole Where Name = 'CEO'];
        User usr = new User(alias = 'apexs',email = 'apex@apexhours.com',emailencodingkey='UTF-8',lastName='Hours',
                           languagelocalekey='en_US',
                           localesidkey ='en_US',profileid = p.id,userroleid = r.id,
                           timezonesidkey='America/Los_Angeles',
                           username = 'usernamerohit@gmail.com');
        insert usr;
    }

}