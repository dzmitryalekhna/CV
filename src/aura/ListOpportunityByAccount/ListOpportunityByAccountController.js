({
    init: function (component, event, helper) {
        helper.doinit(component, event, helper);
    },
    isOpenModalWindow: function (component, event, helper) {
        component.set('v.showSpinner', true);
        component.set('v.isOpenModalWindow', true);
        component.set('v.showSpinner', false);
    }
});