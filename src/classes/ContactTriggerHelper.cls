public class ContactTriggerHelper {
    public static void blockDeletePrimaryContact(List<Contact> listOfContactsToDelete) {
        if (!listOfContactsToDelete.isEmpty()) {
            for (Contact contactTemp : listOfContactsToDelete) {
                if (Schema.SObjectType.Contact.getRecordTypeInfosById().get(contactTemp.recordTypeId).getName() == 'Primary') {
                    contactTemp.addError('Can not Delete Primary Contact');
                }
            }
        }
    }

    public static void countContactsOnAccount(List <Contact> listOfContactsToDelete) {
        if (!listOfContactsToDelete.isEmpty()) {
            Set<Id> setOfIdsContactsToDelete = new Set<Id>();
            for (Contact cont : listOfContactsToDelete) {
                setOfIdsContactsToDelete.add(cont.AccountId);
            }
            List<Account> listOfAccountsWithRelatedContacts = getListOfAccountsWithRelatedContacts(setOfIdsContactsToDelete);
            if (!listOfAccountsWithRelatedContacts.isEmpty()) {
                for (Account accTemp : listOfAccountsWithRelatedContacts) {
                    List<Contact> listOfContactByAccount = accTemp.contacts;
                    accTemp.Total_Contacts__c = listOfContactByAccount.size();
                }
                update listOfAccountsWithRelatedContacts;
            }
        }
    }

    public static void insertNewPersonContact(List<Contact> listOfInsertNewPersonContact) {
        if (!listOfInsertNewPersonContact.isEmpty()) {
            Id personRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Person').getRecordTypeId();
            for (Contact contactTemp : listOfInsertNewPersonContact) {
                if (contactTemp.RecordTypeId == null) {
                    contactTemp.RecordTypeId = personRecordTypeId;
                }
            }
        }
    }

    private static List<Account> getListOfAccountsWithRelatedContacts(Set<Id> setOfIdsRelatedContacts) {
        return [
                SELECT Total_Contacts__c, (
                        SELECT Id
                        FROM contacts
                )
                FROM Account
                WHERE Id IN :setOfIdsRelatedContacts
        ];
    }
}