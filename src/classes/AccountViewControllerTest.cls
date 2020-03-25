@IsTest
public class AccountViewControllerTest {

    @IsTest
    static void getListOfOpportunityTest() {
        insert (List<Account>) TestFactory.createObjectsRequiredFields('Account', 10); //with each account insert one contact(Primary)
        Map<Id, Account> mapAccIdToAccountsFromTestDB = new Map<Id, Account> ([
                SELECT Id
                FROM Account
        ]);
        Set<Id> setOfAccIdFromTestDB = new Set<Id>(mapAccIdToAccountsFromTestDB.keySet());
        if (!setOfAccIdFromTestDB.isEmpty()) {
            List<Opportunity> listOfOpportunitiesByAccount = new List<Opportunity>();
            for (Id accountId : setOfAccIdFromTestDB) {
                for (Opportunity opportunityTemp : (List<Opportunity>) TestFactory.createObjectsRequiredFields('Opportunity', 10)) {
                    opportunityTemp.AccountId = accountId;
                    listOfOpportunitiesByAccount.add(opportunityTemp);
                }
            }
            insert listOfOpportunitiesByAccount;
        }


        Id randomAccountId = getRandomAccountIdFromTestDB();
        if (randomAccountId != null) {
            Test.startTest();
            List<Opportunity> listOfOpportunitiesFromTestMethod = AccountViewController.getListOfOpportunity(randomAccountId);
            Test.stopTest();
            List<Opportunity> listOfOpportunitiesFromTestDB = getListOfOpportunitiesFromTestDBByAccId(randomAccountId);
            if (!listOfOpportunitiesFromTestDB.isEmpty()) {
                for (Integer i = 0; i < listOfOpportunitiesFromTestMethod.size(); i++) {
                    System.assertEquals(listOfOpportunitiesFromTestDB[i].id, listOfOpportunitiesFromTestMethod[i].id, 'Failed getListOfOpportunityByAccountIDTest');
                }
            }
        }

    }
    @IsTest
    static void getAccountBillingAddressTest() {
        insert (List<Account>) TestFactory.createObjectsRequiredFields('Account', 10); //with each account insert one contact(Primary)
        Id accountId = getRandomAccountIdFromTestDB();
        if (accountId != null) {
            Test.startTest();
            Account accBillingAddress = AccountViewController.getAccountBillingAddress(accountId);
            Test.stopTest();
            if (!getListAccBillingAddressFromTestDBByAccId(accountId).isEmpty()) {
                Account accBillingAddressFromTestDB = getListAccBillingAddressFromTestDBByAccId(accountId).get(0);
                System.assertEquals(accBillingAddressFromTestDB, accBillingAddress, 'Failed getAccountBillingAddressTest');
            }
        }
    }
    @IsTest
    static void getListOfContactTest() {
        insert (List<Account>) TestFactory.createObjectsRequiredFields('Account', 10); //with each account insert one contact(Primary)
        Id accountId = getRandomAccountIdFromTestDB();
        if (accountId != null) {
            Test.startTest();
            List<Contact> listOfContacts = AccountViewController.getListOfContact(accountId);
            Test.stopTest();
            List<Contact> listOfContactsFromTestDB = getListOfContactsFromTestDBByAccId(accountId);
            if (!listOfContactsFromTestDB.isEmpty()) {
                for (Integer i = 0; i < listOfContacts.size(); i++) {
                    System.assertEquals(listOfContactsFromTestDB[i].id, listOfContacts[i].id, 'Failed getListOfContactByAccountIDTest');
                }
            }
        }
    }
    @IsTest
    static void getApiNameFieldSetsTest() {
        String objName = 'Account';
        String fieldSetName = 'Account_Edit';
        Map<String, Schema.SObjectType> objectsNameToSObjectTokens = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = objectsNameToSObjectTokens.get(objName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        List<String> listOfApiNameFieldSetsTest = new List<String>();
        for (Schema.FieldSetMember fieldInfo : fieldSetObj.getFields()) {
            listOfApiNameFieldSetsTest.add(fieldInfo.getFieldPath());
        }

        Test.startTest();
        List<String> listOfApiNameFieldSets = AccountViewController.getApiNameFieldSets(fieldSetName, objName);
        Test.stopTest();

        System.assertEquals(listOfApiNameFieldSets, listOfApiNameFieldSetsTest, 'getApiNameFieldSetsTest is Failed');
    }

    private static Id getRandomAccountIdFromTestDB() {
        return [
                SELECT Id
                FROM Account
                LIMIT 1
        ].Id;
    }
    private static List<Contact> getListOfContactsFromTestDBByAccId(Id accountId) {
        return [
                SELECT Id
                FROM Contact
                WHERE AccountId = :accountId
                ORDER BY CreatedDate ASC
        ];
    }
    private static List<Account> getListAccBillingAddressFromTestDBByAccId(Id accountId) {
        return [
                SELECT BillingStreet, BillingCity, BillingCountry
                FROM Account
                WHERE id = :accountId
        ];
    }
    private static List<Opportunity> getListOfOpportunitiesFromTestDBByAccId(Id accountId) {
        return [
                SELECT Id
                FROM Opportunity
                WHERE AccountId = :accountId
        ];
    }
}