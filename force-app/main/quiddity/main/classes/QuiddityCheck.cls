public without sharing class QuiddityCheck {
    public QuiddityCheck() {

    }

    @InvocableMethod(label='Check Quiddity' description='Allows to specify specific safe contexts to validate against the current quiddity.' category= 'Quiddity')
    public static List<QuiddityCheck.Response> checkQuiddity(List<QuiddityCheck.Request> requests) {
        Quiddity context = System.Request.getCurrent().getQuiddity();
        System.debug(context);
        System.debug(requests);
        System.debug(JSON.serialize(requests));
        List<QuiddityCheck.Response> responses = new List<QuiddityCheck.Response>();
        for(QuiddityCheck.Request req : requests){
            responses.add(new QuiddityCheck.Response(isContextAllowed(context, req), context.name()));
        }
        return responses;
    }

    public static Boolean isContextAllowed(Quiddity context, QuiddityCheck.Request req) {
        Boolean isAllowed = false;
        switch on context {
            when ANONYMOUS {
                isAllowed = req.isAnonymous;
            }
            when AURA, VF {
                isAllowed = req.isComponent;
            }
            when BATCH_ACS, BATCH_APEX, BATCH_CHUNK_PARALLEL, BATCH_CHUNK_SERIAL {
                isAllowed = req.isBatch;
            }
            when INVOCABLE_ACTION {
                isAllowed = req.isInvocableAction;
            }
            when QUEUEABLE {
                isAllowed = req.isQueueable;
            }
            when FUTURE {
                isAllowed = req.isFuture;
            }
            when REST {
                isAllowed = req.isRest;
            }
            when SOAP {
                isAllowed = req.isSoap;
            }
            when SCHEDULED {
                isAllowed = req.isScheduled;
            }
            when SYNCHRONOUS {
                isAllowed = req.isSynchronous;
            }
        }

        return isAllowed == true;
    }

    public class Request {

        @InvocableVariable(label='0 - Anonymous Apex' required=true description='Execution event is an anonymous Apex block.')
        public Boolean isAnonymous;

        @InvocableVariable(label='1 - Apex Synchronous DML' required=true description='Execution event is a synchronous Apex operation.')
        public Boolean isSynchronous;

        @InvocableVariable(label='2 - Flow Invocation' required=true description='Execution event is an invocable action.')
        public Boolean isInvocableAction;

        @InvocableVariable(label='3 - Aura / Lightning / Visualforce' required=false description='Execution event is triggered by a Aura / Lightning / Visualforce page.')
        public Boolean isComponent;

        @InvocableVariable(label='4 - Apex SOAP Callout' required=false description='Execution event is an Apex SOAP Web service.')
        public Boolean isSoap;

        @InvocableVariable(label='5 - Apex REST Callout' required=false description='Execution event is an Apex RESTful Web service.')
        public Boolean isRest;

        @InvocableVariable(label='6 - Apex Future Job' required=false description='Execution event is a future method.')
        public Boolean isFuture;

        @InvocableVariable(label='7 - Apex Batch Job' required=false description='Execution event is a batch Apex job.')
        public Boolean isBatch;

        @InvocableVariable(label='8 - Apex Queueable Job' required=false description='Execution event is a queueable Apex operation.')
        public Boolean isQueueable;

        @InvocableVariable(label='9 - Scheduled Job' required=false description='Execution event is a scheduled Apex job.')
        public Boolean isScheduled;
    }

    public class Response {

        public Response (Boolean IsContextAllowed, String CurrentContext){
            this.IsContextAllowed = IsContextAllowed;
            this.CurrentContext = CurrentContext;
        }

        @InvocableVariable(label='Is Context Allowed' description='Specify if the current context is allowed or not.')
        public Boolean IsContextAllowed;

        @InvocableVariable(label='Current Context ' description='Shows the context from which the transaction started.')
        public String CurrentContext;
    }
}