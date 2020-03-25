({
    init: function (component, event, helper) {
        helper.getAccountFields(component, event, helper);
    },

    newAccountButtonHandler: function (component, event, helper) {
        helper.doNewAccountButtonHandler(component, event, helper);
    },

    editAccountButtonHandler: function (component, event, helper) {
        helper.doEditAccountButtonHandler(component, event, helper);
    }
})