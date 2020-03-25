({
    openModalFalse: function (component, event, helper) {
        component.set('v.isOpenModalWindow', false);
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