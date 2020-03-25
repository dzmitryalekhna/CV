public class AccountTriggerHelper {
    public static void insertNewPrimaryContactByAccountWithSameValueRequiredFields(List<Account> listOfNewAccounts) {
        List<Contact> listOfPrimaryContactsByAccount = new List<Contact>();
        Id idPrimaryRecordTypeByContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Primary').getRecordTypeId();
        for (Account accountTemp : listOfNewAccounts) {
            Contact newContact = new Contact(LastName = accountTemp.Name, AccountId = accountTemp.Id, RecordTypeId = idPrimaryRecordTypeByContact);
            for (String field : PropertiesFieldsObjects.getListOfApiSameRequiredFields('Account', 'Contact')) {
                newContact.put((String) field, (String) accountTemp.get(field));
            }
            listOfPrimaryContactsByAccount.add(newContact);
        }
        insert listOfPrimaryContactsByAccount;
    }

    public static void updatePrimaryContactRequiresFields(Map<Id, Account> accIdToAccountAfterUpdate,
            Map<Id, Account> accIdToAccountBeforeUpdate) {
        Map<Id, List<String>> accIdToListApiNameUpdatedField =
                PropertiesFieldsObjects.getUpdatedRequiredFieldsOnObjects(accIdToAccountAfterUpdate, accIdToAccountBeforeUpdate);
        if (!accIdToListApiNameUpdatedField.isEmpty()) {
            List<Contact> listOfPrimaryContactsToUpdate = getListOfPrimaryContactsRequiredFieldsByAccountBeforeUpdate(accIdToAccountBeforeUpdate);
            for (Contact contactTemp : listOfPrimaryContactsToUpdate) {
                for (String fieldNameContact : PropertiesFieldsObjects.getListOfApiSameRequiredFields('Account', 'Contact')) {
                    if (contactTemp.get(fieldNameContact) != accIdToAccountAfterUpdate.get(contactTemp.AccountId).get(fieldNameContact))
                        contactTemp.put(fieldNameContact, accIdToAccountAfterUpdate.get(contactTemp.AccountId).get(fieldNameContact));
                }
                contactTemp.put('Lastname', accIdToAccountAfterUpdate.get(contactTemp.AccountId).get('Name'));
            }
            update listOfPrimaryContactsToUpdate;
        }
    }

    private static List<Contact> getListOfPrimaryContactsRequiredFieldsByAccountBeforeUpdate(Map<Id, Account> accIdToAccountBeforeUpdate) {
        Set<Id> setOfAccIdsBeforeUpdate = new Set<Id>(accIdToAccountBeforeUpdate.keySet());
        String requiredFieldsContact = String.join(PropertiesFieldsObjects.getListOfApiSameRequiredFields('Account', 'Contact'), ',');
        return (List<Contact>) Database.query(
                'SELECT AccountId, Lastname, ' + String.escapeSingleQuotes(requiredFieldsContact) +
                        ' FROM Contact ' +
                        ' WHERE AccountId IN : setOfAccIdsBeforeUpdate ' +
                        ' AND RecordType.Name = \'Primary\' '
        );
    }
}