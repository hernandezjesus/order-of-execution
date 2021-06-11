trigger CaseChangeEventTrigger on CaseChangeEvent (after insert) {

    Logger.info(System.Request.getCurrent().getQuiddity().name());
    Logger.saveLog();

    System.debug(Trigger.operationType);
    System.debug(JSON.serializePretty(Trigger.new));
    
    List<CaseChangeEvent> changes = Trigger.new;
     
    Set<Id> caseIds = new Set<Id>();

    for(CaseChangeEvent caseEvent : changes){

        System.debug(caseEvent.ChangeEventHeader.getChangedfields());
        System.debug(caseEvent.ChangeEventHeader.getChangeorigin());
        System.debug(caseEvent.ChangeEventHeader.getChangetype());
        System.debug(caseEvent.ChangeEventHeader.getCommitnumber());
        System.debug(caseEvent.ChangeEventHeader.getCommittimestamp());
        System.debug(caseEvent.ChangeEventHeader.getCommituser());
        System.debug(caseEvent.ChangeEventHeader.getDifffields());
        System.debug(caseEvent.ChangeEventHeader.getEntityname());
        System.debug(caseEvent.ChangeEventHeader.getNulledfields());
        System.debug(caseEvent.ChangeEventHeader.getRecordids());
        System.debug(caseEvent.ChangeEventHeader.getSequencenumber());
        System.debug(caseEvent.ChangeEventHeader.getTransactionkey());
    }
}