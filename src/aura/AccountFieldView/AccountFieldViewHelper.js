({
    getAccountFields: function (component, event, helper) {
        var action = component.get("c.getApiNameFieldSets");
        action.setParams({fieldSetName: 'Account_View', objectName: 'Account'});
        action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var fieldsList = response.getReturnValue();
                    if (!$A.util.isUndefinedOrNull(fieldsList)) {
                        component.set("v.listOfAccountFieldSet", fieldsList);
                    }
                } else {
                    helper.showToastDisplayed("error", "ERROR", 'Failed Response getApiNameFieldSets for Account');
                }
            }
        );
        $A.enqueueAction(action);
    },

    doNewAccountButtonHandler: function (component, event, helper) {
        $A.createComponent("c:FormEditAccountModal", {},
            function (content, status) {
                if (status === "SUCCESS") {
                    helper.spinnerTurnON(component, event, helper);
                    component.find('accountFieldView').showCustomModal({
                        header: "New Account",
                        body: content,
                    })
                    helper.spinnerTurnOFF(component, event, helper);
                } else {
                    if (status === "ERROR") {
                        helper.showToastDisplayed("error", "ERROR", 'Failed showCustomModal for create new Account');
                    }
                }
            });
    },

    doEditAccountButtonHandler: function (component, event, helper) {
        $A.createComponent("c:FormEditAccountModal",
            {
                "objectId": component.get("v.recordId"),
            },
            function (content, status) {
                if (status === "SUCCESS") {
                    helper.spinnerTurnON(component, event, helper);
                    component.find('accountFieldView').showCustomModal({
                        header: "Edit Account",
                        body: content
                    });
                    helper.spinnerTurnOFF(component, event, helper);
                } else if (status === "ERROR") {
                    helper.showToastDisplayed("error", "ERROR", 'Failed showCustomModal for edit Account');
                }
            });
        $A.get('e.force:ContactForm').fire();
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
    spinnerTurnOFF: function (component, event, helper) {
        component.set('v.loaded', false);
    },
    spinnerTurnON: function (component, event, helper) {
        component.set('v.loaded', true);
    }
})