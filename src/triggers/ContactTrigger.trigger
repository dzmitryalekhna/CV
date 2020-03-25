trigger ContactTrigger on Contact (before insert, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isDelete) {
            ContactTriggerHelper.blockDeletePrimaryContact(Trigger.old);
            ContactTriggerHelper.countContactsOnAccount(Trigger.old);
        }
    }
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ContactTriggerHelper.insertNewPersonContact(Trigger.new);
        }
    }
}