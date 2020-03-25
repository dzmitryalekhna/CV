({
    init: function (component, event, helper) {
        helper.doInit(component, event, helper);
    },
    modalFormNewContact: function (component, event, helper) {
        $A.createComponent("c:FormNewContactModal",
            {
                "objectId": component.get("v.recordId"),
            },
            function (content, status) {
                if (status === "SUCCESS") {
                    component.set('v.showSpinner', true);
                    component.find('ListContactByAccount').showCustomModal({
                        header: "New Contact",
                        body: content
                    });
                    component.set('v.showSpinner', false);
                }
            });
    }
});