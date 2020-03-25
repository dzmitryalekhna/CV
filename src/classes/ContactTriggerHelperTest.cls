@IsTest
private class ContactTriggerHelperTest {
    @IsTest
    static void insertNewPersonContactTest() {
        insert (List<Account>) TestFactory.createObjectsRequiredFields('Account', 10); //each account insert one contact(Primary)
        Id personRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Person').getRecordTypeId();

        if (!getListOfIdsAccounts().isEmpty()) {
            Id idAccFromTestDB = getListOfIdsAccounts().get(0).Id;
            List<Contact> listOfContactsBeforeTestInsert = new List<Contact>((List<Contact>) TestFactory.createObjectsRequiredFields('Contact', 10));
            for (Contact onOfTestContacts : listOfContactsBeforeTestInsert) {
                onOfTestContacts.AccountId = idAccFromTestDB;
            }
            Test.startTest();
            insert listOfContactsBeforeTestInsert;
            Test.stopTest();
        }

        if (!getListOfContactsPerson().isEmpty()) {
            List<Contact> listOfContactsAfterTestInsert = getListOfContactsPerson();
            for (Contact contactExam : listOfContactsAfterTestInsert) {
                System.assertEquals(personRecordTypeId, contactExam.RecordTypeId, 'insertContactTest is Failed');
            }
        }
    }
    @IsTest
    static void blockDeletePrimaryContactTest() {
        insert (List<Account>) TestFactory.createObjectsRequiredFields('Account', 10); //each account insert one contact(Primary)
        if (!getListOfContactsPrimary().isEmpty()) {
            List<Contact> listOfContactPrimary = getListOfContactsPrimary();
            Test.startTest();
            Database.DeleteResult[] result = Database.delete(listOfContactPrimary, false);
            Test.stopTest();

            for (Database.DeleteResult deleteResult : result) {
                System.assertEquals(false, deleteResult.isSuccess(), 'deletePrimaryContactTest is Failed');
            }
        }
    }
    @IsTest
    static void countContactsOnAccountTest() {
        insert (List<Account>) TestFactory.createObjectsRequiredFields('Account', 10); //each account insert one contact(Primary)

        if (!getListOfTotalContactsFieldInAccounts().isEmpty()) {
            Account accountBeforeDeleteContact = getListOfTotalContactsFieldInAccounts().get(0);
            Id idAccFromTestDB = accountBeforeDeleteContact.Id;
            List<Contact> listOfContactsFromTestDB = new List<Contact>((List<Contact>) TestFactory.createObjectsRequiredFields('Contact', 10));
            for (Contact oneOfTestContacts : listOfContactsFromTestDB) {
                oneOfTestContacts.AccountId = idAccFromTestDB;
            }

            insert listOfContactsFromTestDB;

            Test.startTest();
            delete listOfContactsFromTestDB;
            Test.stopTest();

            if (!getListOfTotalContactsFieldInAccountsById(idAccFromTestDB).isEmpty()) {
                Account accountAfterDeleteContact = getListOfTotalContactsFieldInAccountsById(idAccFromTestDB).get(0);
                System.assertEquals(accountBeforeDeleteContact.Total_Contacts__c,
                        accountAfterDeleteContact.Total_Contacts__c, 'deletePersonContactTest is Failed');
            }
        }
    }

    private static List<Contact> getListOfContactsPerson() {
        return [
                SELECT Id, RecordTypeId
                FROM Contact
                WHERE RecordType.Name = 'Person'
        ];
    }
    private static List<Contact> getListOfContactsPrimary() {
        return [
                SELECT Id, RecordTypeId
                FROM Contact
                WHERE RecordType.Name = 'Primary'
        ];
    }
    private static List<Account> getListOfIdsAccounts() {
        return [
                SELECT Id
                FROM Account
        ];
    }
    private static List<Account> getListOfTotalContactsFieldInAccounts() {
        return [
                SELECT Total_Contacts__c
                FROM Account
        ];
    }
    private static List<Account> getListOfTotalContactsFieldInAccountsById(Id idsAcc) {
        return [
                SELECT Total_Contacts__c
                FROM Account
                WHERE Id = :idsAcc
        ];
    }
}