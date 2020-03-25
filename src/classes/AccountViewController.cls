public class AccountViewController {
    @AuraEnabled
    public static List<String> getApiNameFieldSets(String fieldSetName, String objectName) {
        return PropertiesFieldsObjects.getApiNameFieldSets(fieldSetName, objectName);
    }
    @AuraEnabled
    public static Account getAccountBillingAddress(Id accountId) {
        return getListOfAccountBillingAddressById(accountId).get(0);
    }
    @AuraEnabled
    public static List<Contact> getListOfContact(Id accountId) {
        return getListOfContactByAccountID(accountId);
    }
    @AuraEnabled
    public static List<Opportunity> getListOfOpportunity(Id accountId) {
        return getListOfOpportunityByAccountID(accountId);
    }

    private static List<Opportunity> getListOfOpportunityByAccountID(Id accountId) {
        return [
                SELECT Id
                FROM Opportunity
                WHERE AccountId = :accountId
        ];
    }

    private static List<Contact> getListOfContactByAccountID(Id accountId) {
        return [
                SELECT Id
                FROM Contact
                WHERE AccountId = :accountId
                ORDER BY CreatedDate ASC
        ];
    }

    private static List<Account> getListOfAccountBillingAddressById(Id accountId) {
        return [
                SELECT BillingStreet, BillingCity, BillingCountry
                FROM Account
                WHERE Id = :accountId
        ];
    }
}