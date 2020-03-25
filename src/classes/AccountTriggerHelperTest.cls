@IsTest
private class AccountTriggerHelperTest {

    @IsTest
    static void insertNewPrimaryContactByAccountWithSameValueRequiredFieldsTest() {
        insert TestFactory.createObjectsRequiredFields('Account', 10); //each account insert one contact(Primary)
        List<Account> listOfAccountsFromDB = getListOfAccountsFromDB();

        if (!listOfAccountsFromDB.isEmpty()) {
            Set<Id> listAccountsIds = new Set<Id>();

            for (Account oneOfListAccounts : listOfAccountsFromDB) {
                listAccountsIds.add(oneOfListAccounts.Id);
            }

            Test.startTest();
            AccountTriggerHelper.insertNewPrimaryContactByAccountWithSameValueRequiredFields(listOfAccountsFromDB);
            Test.stopTest();

            List<Contact> listOfPrimaryContactsFromTestDB = getListOfPrimaryContactsFromTestDB(listAccountsIds);

            if (!listOfPrimaryContactsFromTestDB.isEmpty()) {
                for (Contact primaryContactFromTestDB : listOfPrimaryContactsFromTestDB) {
                    System.assertEquals(true, listAccountsIds.contains(primaryContactFromTestDB.AccountId),
                            'insertNewPrimaryContactByAccountWithSameValueRequiredFieldsTest is Failed');
                }

            }
        }
    }

    @IsTest
    static void updatePrimaryContactRequiresFieldsTest() {
        insert TestFactory.createObjectsRequiredFields('Account', 10); //each account insert one contact(Primary)
        if (!getMapAccIdToAccRequiredFieldsBeforeUpdate().isEmpty()) {
            List<String> requiredSameFieldsAccAndCont = PropertiesFieldsObjects.getListOfApiSameRequiredFields('Account', 'Contact');
            Map<Id, Account> mapAccIdToAccountAfterUpdate = getAccIdToUpdateAccounts(getMapAccIdToAccRequiredFieldsBeforeUpdate().deepClone());
            Set<Id> setOfIdsAccIdsAfterUpdate = mapAccIdToAccountAfterUpdate.keySet();

            Test.startTest();
            AccountTriggerHelper.updatePrimaryContactRequiresFields(mapAccIdToAccountAfterUpdate,
                    getMapAccIdToAccRequiredFieldsBeforeUpdate());
            Test.stopTest();

            List<Contact> contactsAfterTestUpdate = getListOfContactsAfterTestUpdateFromTestDB(setOfIdsAccIdsAfterUpdate);
            if (!contactsAfterTestUpdate.isEmpty()) {
                for (Contact contactExam : contactsAfterTestUpdate) {
                    for (String fieldName : requiredSameFieldsAccAndCont) {
                        System.assertEquals(contactExam.get(fieldName),
                                mapAccIdToAccountAfterUpdate.get(contactExam.AccountId).get(fieldName),
                                'updatePrimaryContactRequiresFieldsTest is Failed');
                    }
                }
            }
        }
    }
    private static Map<Id, Account> getMapAccIdToAccRequiredFieldsBeforeUpdate() {
        String requiredFieldsAccount = String.join(PropertiesFieldsObjects.getObjectRequiredFields('Account'), ',');
        return new Map<Id, Account> ((List<Account>) Database.query(
                'SELECT id,' + String.escapeSingleQuotes(requiredFieldsAccount) +
                        ' FROM Account LIMIT 5'
        ));
    }
    private static Map<Id, Account> getAccIdToUpdateAccounts(Map<Id, Account> objIdToAccount) {
        List<String> requiredFieldsName = PropertiesFieldsObjects.getObjectRequiredFields('Account');
        String requiredFields = String.join(requiredFieldsName, ',');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Account');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        for (SObject updatedObject : objIdToAccount.values()) {
            for (String fieldName : requiredFieldsName) {
                switch on fieldMap.get(fieldName).getDescribe().getType() {
                    when STRING {
                        updatedObject.put(fieldName, (STRING) updatedObject.get(fieldName) + 'i');
                    } when INTEGER {
                        updatedObject.put(fieldName, (INTEGER) updatedObject.get(fieldName) + 1);
                    } when DATETIME {
                        updatedObject.put(fieldName, Datetime.valueOf(updatedObject.get(fieldName)).addHours(1));
                    } when DATE {
                        updatedObject.put(fieldName, Date.valueOf(updatedObject.get(fieldName)).addDays(1));
                    } when PICKLIST {
                        updatedObject.put(fieldName, updatedObject.get(fieldName) + 'i');
                    }
                }
            }
        }
        return objIdToAccount;
    }
    private static List<Account> getListOfAccountsFromDB() {
        return Database.query(
                'SELECT ' + String.escapeSingleQuotes(
                        String.join(PropertiesFieldsObjects.getObjectRequiredFields('Account'), ',')) +
                        ' FROM Account ');
    }
    private static List<Contact> getListOfPrimaryContactsFromTestDB(Set<Id> listAccountsIds) {
        return Database.query(
                'SELECT AccountId' +
                        ' FROM Contact ' +
                        'WHERE AccountId IN : listAccountsIds' +
                        ' AND RecordType.Name = \'Primary\' ');
    }
    private static List<Contact> getListOfContactsAfterTestUpdateFromTestDB(Set<Id> setOfIdsAccIdsAfterUpdate) {
        return Database.query(
                'SELECT AccountId, ' + String.escapeSingleQuotes(
                        String.join(PropertiesFieldsObjects.getObjectRequiredFields('Contact'), ',')) +
                        ' FROM Contact WHERE AccountId IN : setOfIdsAccIdsAfterUpdate' +
                        ' AND RecordType.Name = \'Primary\' ');
    }
}