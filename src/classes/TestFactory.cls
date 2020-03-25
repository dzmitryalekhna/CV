@IsTest
public class TestFactory {
    public static List<SObject> createObjectsRequiredFields(String objectName, Integer objectNumber) {
        Map<String, Schema.SObjectType> objectsNameToSObjectTokens = Schema.getGlobalDescribe();
        Schema.SObjectType objectSchema = objectsNameToSObjectTokens.get(objectName);
        if (objectSchema != null) {
            Map<String, Schema.SObjectField> objFieldsToDescribe = objectSchema.getDescribe().fields.getMap();
            List<String> apiNamesRequiredFieldsOnObject = PropertiesFieldsObjects.getObjectRequiredFields(objectName);
            List<SObject> objects = new List<SObject>();
            for (Integer i = 1; i <= objectNumber; i++) {
                SObject newTestObject = Schema.getGlobalDescribe().get(objectName).newSObject();
                for (String requiredField : apiNamesRequiredFieldsOnObject) {
                    switch on objFieldsToDescribe.get(requiredField).getDescribe().getType() {
                        when STRING {
                            newTestObject.put(requiredField, requiredField + i);
                        } when INTEGER {
                            newTestObject.put(requiredField, i);
                        } when DATETIME {
                            newTestObject.put(requiredField, Datetime.now().addHours(i));
                        } when DATE {
                            newTestObject.put(requiredField, Date.today().addDays(i));
                        } when PICKLIST {
                            newTestObject.put(requiredField, requiredField + i);
                        }
                    }
                }
                objects.add(newTestObject);
            }
            if (objectName == 'Account') { //продумать как переделать
                for (SObject account : objects) {
                    account.put('BillingCountry', 'USA');
                    account.put('BillingStreet', '312 Constitution Place Austin, TX 78767 USA');
                    account.put('BillingCity', 'Austin');
                }
            }
            return objects;
        }
        return null;
    }

}