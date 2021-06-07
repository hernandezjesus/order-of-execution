@isTest
public class QuiddityCheckTest {

    @IsTest
    static void quiddity_validation_for_test_environment(){
        new QuiddityCheck();
        
        QuiddityCheck.Request req =  new QuiddityCheck.Request();
        req.isAnonymous = true;
        req.isSynchronous = true;
        req.isInvocableAction = true;
        req.isComponent = true;
        req.isSoap = true;
        req.isRest = true;
        req.isFuture = true;
        req.isBatch = true;
        req.isQueueable = true;
        req.isScheduled = true;

        List<QuiddityCheck.Response> responses = QuiddityCheck.checkQuiddity(new List<QuiddityCheck.Request>{req});
        QuiddityCheck.Response res = responses[0];
        System.assert(!res.IsContextAllowed, 'Test context are not supported on the quiddity check');
        // System.assertEquals('RUNTEST_ASYNC', res.CurrentContext, 'Test context should match');

        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.ANONYMOUS, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.AURA, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.BATCH_ACS, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.INVOCABLE_ACTION, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.QUEUEABLE, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.FUTURE, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.REST, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.SOAP, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.SCHEDULED, req));
        System.assert(QuiddityCheck.isContextAllowed(System.Quiddity.SYNCHRONOUS, req));
    }
}