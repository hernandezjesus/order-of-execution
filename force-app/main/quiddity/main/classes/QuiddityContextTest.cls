global with sharing class QuiddityContextTest implements Database.Batchable<sObject>, Schedulable{
    global QuiddityContextTest() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id FROM Log__c');
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        runQuiddityFlow();
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
    global void execute(SchedulableContext SC) {
        runQuiddityFlow();
    }
    
    global static void runQuiddityFlow(){
        Map<String, Object> inputs = new Map<String, Object>();
        Flow.Interview.Quiddity_Test myFlow = new Flow.Interview.Quiddity_Test(inputs);
        myFlow.start();
    }

    @future
    global static void runFuture(){
        runQuiddityFlow();
    }

    global static void runScheduler(){
        QuiddityContextTest scheduler = new QuiddityContextTest();
        DateTime now = DateTime.now().addSeconds(5);
        String cron = String.format('{0} {1} {2} {3} {4} ? {5}', new List<Object>{
            now.second(),
            now.minute(),
            now.hour(),
            now.day(),
            now.month(),
            now.year() });
        String jobID = system.schedule('Quiddity Test Scheduler: ' + now.getTime(), cron, scheduler);
    }

    global static void runJob(){
        Id batchInstanceId = Database.executeBatch(new QuiddityContextTest(), 1); 
    }

    global with sharing class QueueJob implements Queueable {
        global void execute(QueueableContext context) {
            runQuiddityFlow();
        }
    }

    global static void runQueueable(){
        ID jobID = System.enqueueJob(new QuiddityContextTest.QueueJob());
    }
}