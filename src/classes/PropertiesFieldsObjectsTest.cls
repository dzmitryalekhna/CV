@IsTest
private class PropertiesFieldsObjectsTest {

    private static Map<Id, SObject> updatedDataInMap(Map<Id, SObject> objIdToObject) {

        List<String> requiredFieldsName = PropertiesFieldsObjects.getObjectRequiredFields('Account');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Account');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        for (SObject updatedObject : objIdToObject.values()) {
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
        return objIdToObject;
    }

    @IsTest
    static void getApiNameFieldSetsTest() {
        String objName = 'Account';
        String fieldSetName = 'Account_Edit';
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        List<String> listOfApiNameFieldSetsOnObject = new List<String>();
        for (Schema.FieldSetMember fieldInfo : fieldSetObj.getFields()) {
            listOfApiNameFieldSetsOnObject.add(fieldInfo.getFieldPath());
        }

        Test.startTest();
        List<String> listOfApiNameFieldSetsOnObjectTest = PropertiesFieldsObjects.getApiNameFieldSets(fieldSetName, objName);
        Test.stopTest();

        System.assertEquals(listOfApiNameFieldSetsOnObject, listOfApiNameFieldSetsOnObjectTest, 'getApiNameFieldSetsTest is Failed');
    }
    @IsTest
    static void getObjectRequiredFieldsTest() {
        String testObjName = 'Account';
        Map<String, Schema.SObjectType> mapOfObj = Schema.getGlobalDescribe();
        Schema.SObjectType objType = mapOfObj.get(testObjName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribe.fields.getMap();
        List<String> listOfRequiredFieldsOnObject = new List<String>();    //getAllField
        for (String keyFieldDescribe : mapFields.keyset()) {  //select required
            Schema.DescribeFieldResult describeField = mapFields.get(keyFieldDescribe).getDescribe();
            if (describeField.isCreateable() && !describeField.isNillable() && !describeField.isDefaultedOnCreate()) {
                listOfRequiredFieldsOnObject.add(keyFieldDescribe);
            }
        }

        Test.startTest();
        List<String> listOfRequiredFieldsOnObjectTest = PropertiesFieldsObjects.getObjectRequiredFields('Account');
        Test.stopTest();
        System.assertEquals(listOfRequiredFieldsOnObject, listOfRequiredFieldsOnObjectTest, 'getObjectRequiredFieldsTest is Failed');
    }
    
    @IsTest
    static void getListOfApiSameRequiredFieldsTest() {
        String objName1 = 'Account';
        String objName2 = 'Contact';
        List<String> listOfSameRequiredFieldsOnTwoObjectsTest = new List<String>();
        for (String obj1ReqFields : PropertiesFieldsObjects.getObjectRequiredFields(objName1)) {
            for (String obj2ReqFields : PropertiesFieldsObjects.getObjectRequiredFields(objName2)) {
                if (obj1ReqFields == obj2ReqFields) {
                    listOfSameRequiredFieldsOnTwoObjectsTest.add(obj1ReqFields);
                }
            }
        }

        Test.startTest();
        List<String> listOfSameRequiredFieldsOnTwoObjects = PropertiesFieldsObjects.getListOfApiSameRequiredFields(objName1, objName2);
        Test.stopTest();

        System.assertEquals(listOfSameRequiredFieldsOnTwoObjectsTest, listOfSameRequiredFieldsOnTwoObjects, 'sameRequiredFieldsTest is Failed');
    }

    private static Map<Id, SObject> mapObjectBeforeUpdateToObjIdFromTestDB(String objectName) {
        List<String> listOfRequiredFieldsNameOnObject = PropertiesFieldsObjects.getObjectRequiredFields(objectName);
        String fieldsList = String.join(listOfRequiredFieldsNameOnObject, ',');
        return new Map<ID, SObject>(Database.query(
                ' SELECT id,' + String.escapeSingleQuotes(fieldsList) +
                        ' FROM Account'
        ));
    }
    @IsTest
    static void getUpdatedRequiredFieldsOnObjectsTest() {
        List<Account> listOfaccountsForPushTestDB = (List<Account>) TestFactory.createObjectsRequiredFields('Account', 10); //with each account insert one contact(Primary)
        insert listOfaccountsForPushTestDB;

        String objectName = 'Account';
        List<String> requiredFieldsName = PropertiesFieldsObjects.getObjectRequiredFields(objectName);
        String fieldsList = String.join(requiredFieldsName, ',');

        Map<Id, SObject> mapOfOtherObjectByObjIds = new Map<ID, SObject>();
        Map<Id, SObject> mapObjectBeforeUpdateToObjId = mapObjectBeforeUpdateToObjIdFromTestDB(objectName);
        if (!mapObjectBeforeUpdateToObjId.isEmpty()) {
            Map<Id, SObject> mapOfObjectAfterUpdateByObjId = updatedDataInMap(mapObjectBeforeUpdateToObjId.deepClone());

            Test.startTest();
            Map<Id, List<String>> mapOfUpdatedRequiredFieldsByObjId = PropertiesFieldsObjects.getUpdatedRequiredFieldsOnObjects(mapOfObjectAfterUpdateByObjId, mapObjectBeforeUpdateToObjId);
            Map<Id, List<String>> nullCheck = PropertiesFieldsObjects.getUpdatedRequiredFieldsOnObjects(mapOfOtherObjectByObjIds, mapObjectBeforeUpdateToObjId);
            Test.stopTest();

            if (mapOfObjectAfterUpdateByObjId.keySet().equals(mapObjectBeforeUpdateToObjId.keySet())) {
                for (Id ids : mapObjectBeforeUpdateToObjId.keySet()) {
                    System.assertEquals(mapOfUpdatedRequiredFieldsByObjId.get(ids), requiredFieldsName, 'getUpdatedRequiredFieldsOnObjectsTest is Failed');
                }
            } else {
                System.assertEquals(null, nullCheck, 'getUpdatedRequiredFieldsOnObjectsTest is Failed');
            }
        }

    }
}