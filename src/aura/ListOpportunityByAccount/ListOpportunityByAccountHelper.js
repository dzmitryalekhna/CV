({
    doinit: function (component, event, helper) {
        var action = component.get("c.getListOfOpportunity");
        action.setParams({accountId: component.get("v.recordId")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountOpportunityParam = response.getReturnValue();
                component.set('v.accountOpportunity', accountOpportunityParam);
            }
        });
        $A.enqueueAction(action);
    }
})