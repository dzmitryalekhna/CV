({
    closeModal: function (component, event, helper) {
        helper.openModalFalse(component, event, helper);
    },
    handleSuccess: function (component, event, helper) {
        helper.openModalFalse(component, event, helper);
        helper.showToastDisplayed("success", "Success!", "Successfully.");
        component.set('v.onSuccess', !component.get('v.onSuccess'));
    },
    handleLoad: function (component, event, helper) {
        component.set('v.showSpinner', false);
    },

    handleSubmit: function (component, event, helper) {
        component.set('v.showSpinner', true);
    },

    handleError: function (component, event, helper) {
        component.set('v.showSpinner', false);
    }
})