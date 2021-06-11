trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {

    System.debug(Trigger.operationType);
    System.debug(JSON.serializePretty(Trigger.new));
    
    List<AccountChangeEvent> changes = Trigger.new;
     
    Set<Id> caseIds = new Set<Id>();

    for(AccountChangeEvent event : changes){

        System.debug(event.ChangeEventHeader.getChangedfields());
        System.debug(event.ChangeEventHeader.getChangeorigin());
        System.debug(event.ChangeEventHeader.getChangetype());
        System.debug(event.ChangeEventHeader.getCommitnumber());
        System.debug(event.ChangeEventHeader.getCommittimestamp());
        System.debug(event.ChangeEventHeader.getCommituser());
        System.debug(event.ChangeEventHeader.getDifffields());
        System.debug(event.ChangeEventHeader.getEntityname());
        System.debug(event.ChangeEventHeader.getNulledfields());
        System.debug(event.ChangeEventHeader.getRecordids());
        System.debug(event.ChangeEventHeader.getSequencenumber());
        System.debug(event.ChangeEventHeader.getTransactionkey());
    }
}