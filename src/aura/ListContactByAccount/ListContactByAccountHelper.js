({
    doInit: function (component, event, helper) {
        var action = component.get("c.getListOfContact");
        action.setParams({accountId: component.get("v.recordId")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountContactParam = response.getReturnValue();
                component.set('v.accountContacts', accountContactParam);
            }
        });
        $A.enqueueAction(action);
    },
})