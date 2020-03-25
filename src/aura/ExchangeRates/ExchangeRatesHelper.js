({
    doInit: function (component, event, helper) {
        var callApexToGetExchangeRates = component.get("c.getExchangeRates");
        callApexToGetExchangeRates.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var jsonFromCallback = response.getReturnValue();
                var arrayExchangeRates = JSON.parse(jsonFromCallback);
                component.set("v.exchangeRatesInfo", arrayExchangeRates[0]);
            } else {
                helper.showToastDisplayed("error", "ERROR", 'Failed Response getExchangeRates');
            }
        })
        $A.enqueueAction(callApexToGetExchangeRates);
    },
    dateDetected: function (component, event, helper) {
        var today = new Date();
        var monthDigit = today.getMonth() + 1;
        if (monthDigit <= 9) {
            monthDigit = '0' + monthDigit;
        }
        component.set('v.today', today.getFullYear() + "-" + monthDigit + "-" + today.getDate());
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