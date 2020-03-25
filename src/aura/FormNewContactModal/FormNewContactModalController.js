({
    handleSuccess: function (component, event, helper) {
        component.set('v.showSpinner', false);
        component.set('v.saved', true);
        $A.get("e.c:EventForUpdateContactList").fire();
        component.find('formNewContactModal').notifyClose();
        helper.showToastDisplayed("success", "Success!", "Successfully.");
    },
    handleLoad: function (component, event, helper) {
        component.set('v.showSpinner', false);
    },

    handleSubmit: function (component, event, helper) {
        component.set('v.disabled', true);
        component.set('v.showSpinner', true);
    },

    handleError: function (component, event, helper) {
        component.set('v.showSpinner', false);
    },
})