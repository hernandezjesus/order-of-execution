public with sharing class CaseTriggerHandler extends TriggerHandler{

    List<Case> newList = Trigger.new;
    List<Case> oldList = Trigger.old;
    Map<Id,Case> newMap = (Map<Id, Case>) Trigger.newMap;
    Map<Id,Case> oldMap = (Map<Id, Case>) Trigger.oldMap;

    public CaseTriggerHandler() {

    }

    public override void beforeInsert(){
        for (Case casex : newList) {
            // Logger.info(System.Request.getCurrent().getQuiddity().name(), casex);
        }
        System.debug(Trigger.new);
        System.debug(Trigger.old);
        // Logger.saveLog();
    }
    public override void beforeUpdate(){
        for (Case casex : newList) {
            // Logger.info(System.Request.getCurrent().getQuiddity().name(), casex);
        }
        System.debug(Trigger.new);
        System.debug(Trigger.old);
        // Logger.saveLog();
    }
    public override void beforeDelete(){
        for (Case casex : newList) {
            // Logger.info(System.Request.getCurrent().getQuiddity().name(), casex);
        }
        System.debug(Trigger.new);
        System.debug(Trigger.old);
        // Logger.saveLog();
    }
    public override void afterInsert(){
        for (Case casex : newList) {
            // Logger.info(System.Request.getCurrent().getQuiddity().name(), casex);
        }
        System.debug(Trigger.new);
        System.debug(Trigger.old);
        // Logger.saveLog();
    }
    public override void afterUpdate(){
        for (Case casex : newList) {
            // Logger.info(System.Request.getCurrent().getQuiddity().name(), casex);
        }
        System.debug(Trigger.new);
        System.debug(Trigger.old);
        // Logger.saveLog();
    }
    public override void afterDelete(){
        for (Case casex : newList) {
            // Logger.info(System.Request.getCurrent().getQuiddity().name(), casex);
        }
        System.debug(Trigger.new);
        System.debug(Trigger.old);
        // Logger.saveLog();
    }
    public override void afterUndelete(){
        for (Case casex : newList) {
            // Logger.info(System.Request.getCurrent().getQuiddity().name(), casex);
        }
        System.debug(Trigger.new);
        System.debug(Trigger.old);
        // Logger.saveLog();
    }
}
