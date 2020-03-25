public with sharing class PropertiesFieldsObjects {

    public static List<String> getApiNameFieldSets(String fieldSetName, String objectName) {
        Map<String, Schema.SObjectType> mapOfSObjectTokensByObjectsName = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = mapOfSObjectTokensByObjectsName.get(ObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        List<String> listOfAPINameFieldSets = new List<String>();
        if (fieldSetObj != null) {
            for (Schema.FieldSetMember apiNameField : fieldSetObj.getFields()) {
                listOfAPINameFieldSets.add(apiNameField.getFieldPath());
            }
            return listOfAPINameFieldSets;
        } else {
            return listOfAPINameFieldSets;
        }

    }

    public static List<String> getObjectRequiredFields(String objName) {
        Map<String, Schema.SObjectType> mapOfSObjectTokensByObjectsName = Schema.getGlobalDescribe();
        Schema.SObjectType objType = mapOfSObjectTokensByObjectsName.get(objName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> mapOfDescribeByObjFields = objDescribe.fields.getMap();
        List<String> listOfObjectRequiredField = new List<String>();    //getAllField
        if (!mapOfDescribeByObjFields.isEmpty()) {
            for (String obj : mapOfDescribeByObjFields.keyset()) {                  //select required
                Schema.DescribeFieldResult describeField = mapOfDescribeByObjFields.get(obj).getDescribe();
                if (describeField.isCreateable() && !describeField.isNillable() && !describeField.isDefaultedOnCreate()) {
                    listOfObjectRequiredField.add(obj);
                }
            }
            return listOfObjectRequiredField;
        } else {
            return listOfObjectRequiredField;
        }

    }

    public static List<String> getListOfApiSameRequiredFields(String objName1, String objName2) {
        List<String> listOfSameRequiredFields = new List<String>();
        List <String> listOfAPINamesReqFieldsForObj1 = getObjectRequiredFields(objName1);
        List <String> listOfAPINamesReqFieldsForObj2 = getObjectRequiredFields(objName2);
        if (!listOfAPINamesReqFieldsForObj1.isEmpty() && !listOfAPINamesReqFieldsForObj2.isEmpty()) {
            for (String fieldName : listOfAPINamesReqFieldsForObj1) {
                if (listOfAPINamesReqFieldsForObj2.contains(fieldName))
                    listOfSameRequiredFields.add(fieldName);
            }
        }
        return listOfSameRequiredFields;
    }

    public static Map<Id, List<String>> getUpdatedRequiredFieldsOnObjects(Map<Id, SObject> mapOfObjectAfterUpdateByObjId,
            Map<Id, SObject> mapOfObjectBeforeUpdateByObjId) { //only same objects
        Map<Id, List<String>> mapOfListAPINameUpdateFieldByObjId = new Map<Id, List<String>>();
        if (!mapOfObjectAfterUpdateByObjId.isEmpty() && !mapOfObjectBeforeUpdateByObjId.isEmpty()) {
            if (mapOfObjectAfterUpdateByObjId.keySet().equals(mapOfObjectBeforeUpdateByObjId.keySet())) {
                List<Id> listOfIdsObjectBeforeUpdate = new List<Id>(mapOfObjectBeforeUpdateByObjId.keySet());
                SObjectType sObjectType = mapOfObjectBeforeUpdateByObjId.get(listOfIdsObjectBeforeUpdate.get(0)).getSObjectType();
                String objectName = String.valueOf(sObjectType);  //detected Object Type
                List<String> listOfAPINameRequiredFieldsOnObjectType = new List<String>(getObjectRequiredFields(objectName));
                for (SObject objectBeforeUpdate : mapOfObjectBeforeUpdateByObjId.values()) {
                    List<String> listOfAPINameUpdatedFieldsOnObject = new List<String>();
                    if (!listOfAPINameRequiredFieldsOnObjectType.isEmpty()) {
                        for (String fieldName : listOfAPINameRequiredFieldsOnObjectType) {
                            if (objectBeforeUpdate.get(fieldName) != mapOfObjectAfterUpdateByObjId.get(objectBeforeUpdate.Id).get(fieldName)) {
                                listOfAPINameUpdatedFieldsOnObject.add(fieldName);
                                mapOfListAPINameUpdateFieldByObjId.put(objectBeforeUpdate.Id, listOfAPINameUpdatedFieldsOnObject);
                            }
                        }
                    }
                }
            }
            return mapOfListAPINameUpdateFieldByObjId;
        } else {
            return mapOfListAPINameUpdateFieldByObjId;
        }
    }
}