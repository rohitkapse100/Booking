public class QueueableExe implements Queueable {
    
    public void execute(QueueableContext qc){
   
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