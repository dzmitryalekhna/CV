({
    doInit: function (component, event, helper) {
        var action = component.get("c.getAccountBillingAddress");
        action.setParams({accountId: component.get("v.recordId")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountBillingAdress = response.getReturnValue();
                component.set('v.mapMarkers', [
                        {
                            location: {
                                Street: accountBillingAdress.BillingStreet,
                                City: accountBillingAdress.BillingCity,
                                State: accountBillingAdress.BillingState
                            },
                        }
                    ]
                )
            } else {
                helper.showToastDisplayed("ERROR", "ERROR!", 'Failed Response getAccountBillingAddress for Account');
            }
        });
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