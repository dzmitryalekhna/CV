({
    doClose: function (component, event, helper) {
        component.set('v.showSpinner', false);
        component.find("FormEditAccountModal").notifyClose();
    },
    doGetAccountFieldsEdit: function (component, event, helper) {
        var action = component.get("c.getApiNameFieldSets");
        action.setParams({fieldSetName: 'Account_Edit', objectName: 'Account'});
        action.setCallback(this, function (response) {
                var status = response.getState();
                if (status === "SUCCESS") {
                    var fieldsList = response.getReturnValue();
                    if (!$A.util.isUndefinedOrNull(fieldsList)) {
                        component.set("v.listOfAccountFieldSet", fieldsList);
                    }
                } else {
                    component.find("FormEditAccountModal").notifyClose();
                    helper.showToastDisplayed("error", "error", 'Failed Response getApiNameFieldSets for Account');
                }
            }
        );
        $A.enqueueAction(action);
    },
    showToastDisplayed: function (type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
})