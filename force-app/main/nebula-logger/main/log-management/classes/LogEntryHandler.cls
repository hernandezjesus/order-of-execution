//------------------------------------------------------------------------------------------------//
// This file is part of the Nebula Logger project, released under the MIT License.                //
// See LICENSE file or go to https://github.com/jongpie/NebulaLogger for full license details.    //
//------------------------------------------------------------------------------------------------//

/**
 * @group log-management
 * @description Manages setting fields on `LogEntry__c` before insert & before update
 */
public without sharing class LogEntryHandler {
    /**
     * @description Runs the trigger handler's logic
     */
    public void execute() {
        List<LogEntry__c> logEntries = (List<LogEntry__c>) Trigger.new;

        switch on Trigger.operationType {
            when BEFORE_INSERT {
                this.setBooleanCheckFields(logEntries);

                // Only set the record names on initial insert - the RecordName__c field is then...
                // a snapshot of the record's name at the time that the log entry was created
                this.setRecordNames(logEntries);
            }
            when BEFORE_UPDATE {
                this.setBooleanCheckFields(logEntries);
            }
        }
    }

    private void setBooleanCheckFields(List<LogEntry__c> logEntries) {
        // Maintain the checkbox fields on insert & update
        // Some admins & devs might decide to update/append data in some of the fields...
        // ...and it conceptually feels weird for these fields to not always be accurate, so keep them up to date

        // A formula field can't be used for checking if a long text area field is set/null
        // So, this code handles maintaing some checkbox fields via Apex instead
        for (LogEntry__c logEntry : logEntries) {
            logEntry.HasExceptionStackTrace__c = logEntry.ExceptionStackTrace__c != null;
            logEntry.HasRecordJson__c = logEntry.RecordJson__c != null;
            logEntry.HasStackTrace__c = logEntry.StackTrace__c != null;
        }
    }

    private void setRecordNames(List<LogEntry__c> logEntries) {
        // Assumption - only valid record IDs will be populated in LogEntry__c.RecordId__c
        // If that changes, then extra checks may be needed before casting to Id, using getSObjectType(), etc.

        // 1. Figure out which SObjects & record IDs to query
        Map<Schema.SObjectType, List<Id>> sobjectTypeToRecords = new Map<Schema.SObjectType, List<Id>>();
        for (LogEntry__c logEntry : logEntries) {
            // Skip the log entry if there's no related record ID
            if (logEntry.RecordId__c == null) {
                continue;
            }

            // Based on the related record ID, get the SObject Type
            Id recordId = (Id) logEntry.RecordId__c;
            Schema.SObjectType sobjectType = recordId.getSObjectType();

            List<Id> sobjectTypeRecordIds = sobjectTypeToRecords.get(sobjectType);
            if (sobjectTypeRecordIds == null) {
                sobjectTypeRecordIds = new List<Id>();
            }
            sobjectTypeRecordIds.add(recordId);
            sobjectTypeToRecords.put(sobjectType, sobjectTypeRecordIds);
        }

        // 2. Run the queries and store the results in the map
        Map<Id, SObject> recordIdToRecord = new Map<Id, SObject>();
        for (Schema.SObjectType sobjectType : sobjectTypeToRecords.keySet()) {
            // Stop if we've used up all the queries
            if (Limits.getQueries() == Limits.getLimitQueries()) {
                return;
            }
            List<Id> sobjectTypeRecordIds = sobjectTypeToRecords.get(sobjectType);
            String sobjectDisplayFieldName = this.getDisplayFieldApiName(sobjectType);

            if (sobjectDisplayFieldName == null) {
                continue;
            }

            String query = String.format(
                'SELECT Id, {0} FROM {1} WHERE Id IN :sobjectTypeRecordIds',
                new List<Object>{ sobjectDisplayFieldName, sobjectType, sobjectTypeRecordIds }
            );

            List<SObject> results = Database.query(query);
            recordIdToRecord.putAll(results);
        }

        // 3. Finally, save the record name on the log entry
        for (LogEntry__c logEntry : logEntries) {
            // Skip the log entry if there's no related record ID
            if (logEntry.RecordId__c == null) {
                continue;
            }

            Id recordId = (Id) logEntry.RecordId__c;
            Schema.SObjectType sobjectType = recordId.getSObjectType();

            String sobjectDisplayFieldName = this.getDisplayFieldApiName(sobjectType);
            if (sobjectDisplayFieldName != null) {
                if (recordIdToRecord.containsKey(logEntry.RecordId__c)) {
                    String recordName = (String) recordIdToRecord.get(logEntry.RecordId__c).get(sobjectDisplayFieldName);
                    logEntry.RecordName__c = recordName;
                }
            }
        }
    }

    private String getDisplayFieldApiName(Schema.SObjectType sobjectType) {
        // Use username instead of name for user
        if (sobjectType == Schema.User.SObjectType) {
            return Schema.User.Username.getDescribe().getName();
        }

        // There are several commonly used names for the display field name - typically, Name
        // The order of the field names has been sorted based on number of objects in a dev org with that field
        List<String> educatedGuesses = new List<String>{
            'Name',
            'DeveloperName',
            'ApiName',
            'Title',
            'Subject',
            'AssetRelationshipNumber',
            'CaseNumber',
            'ContractNumber',
            'Domain',
            'FriendlyName',
            'FunctionName',
            'Label',
            'LocalPart',
            'OrderItemNumber',
            'OrderNumber',
            'SolutionName',
            'TestSuiteName'
        };

        String displayFieldApiName;
        for (String fieldName : educatedGuesses) {
            Schema.SObjectField field = sobjectType.getDescribe().fields.getMap().get(fieldName);

            if (field == null) {
                continue;
            }

            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (fieldDescribe.isNameField()) {
                displayFieldApiName = fieldDescribe.getName();
                break;
            }
        }

        return displayFieldApiName;
    }
}
