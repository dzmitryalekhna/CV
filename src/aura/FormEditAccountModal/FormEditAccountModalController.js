({
    handleSuccess: function (component, event, helper) {
        $A.get("e.c:EventForUpdateContactList").fire();
        helper.doClose(component, event, helper);
        helper.showToastDisplayed("success", "Success!", "Successfully.");
    },
    getAccountFieldsEdit: function (component, event, helper) {
        helper.doGetAccountFieldsEdit(component, event, helper);
    },
    handleLoad: function (component, event, helper) {
        component.set('v.showSpinner', false);
    },
    handleSubmit: function (component, event, helper) {
        component.set('v.showSpinner', true);
    },
    handleError: function (component, event, helper) {
        component.set('v.showSpinner', false);
    },
});