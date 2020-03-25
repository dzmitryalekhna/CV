trigger AccountTrigger on Account (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggerHelper.insertNewPrimaryContactByAccountWithSameValueRequiredFields(Trigger.new);
        }
        if (Trigger.isUpdate) {
            AccountTriggerHelper.updatePrimaryContactRequiresFields(Trigger.newMap, Trigger.oldMap);
        }
    }
}