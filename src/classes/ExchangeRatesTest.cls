@IsTest
private class ExchangeRatesTest {
    @isTest
    static void getExchangeRatesTest() {
        Test.setMock(HttpCalloutMock.class, new ExchangeRatesHTTPCalloutMock());
        String actualValue = ExchangeRates.getExchangeRates();
        String expectedValue = '{"USD_in":"2.5500","USD_out":"2.6700","EUR_in":"2.7600","EUR_out":"2.8700","RUB_in":"3.1000","RUB_out":"3.2800","GBP_in":"2.8590","GBP_out":"2.9680","CAD_in":"0.0000","CAD_out":"0.0000","PLN_in":"5.7910","PLN_out":"6.1270","UAH_in":"6.8000","UAH_out":"9.7000","SEK_in":"0.0000","SEK_out":"0.0000","CHF_in":"2.5350","CHF_out":"2.6410","USD_EUR_in":"0.8885","USD_EUR_out":"1.0337","USD_RUB_in":"77.7440","USD_RUB_out":"0.0116","RUB_EUR_in":"0.0108","RUB_EUR_out":"84.1460","JPY_in":"0.0000","JPY_out":"0.0000","CNY_in":"3.4620","CNY_out":"3.6590","CZK_in":"0.0000","CZK_out":"0.0000","NOK_in":"0.0000","NOK_out":"0.0000","filial_id":"2504","sap_id":"50033151","info_worktime":"Пн 9 00 19 00    |Вт 9 00 19 00    |Ср 9 00 19 00    |Чт 9 00 19 00    |Пт 9 00 18 00    |Сб        |Вс        |","street_type":"пр.","street":"Дзержинского","filials_text":"Центр банковских услуг 500/Операционная служба","home_number":"69/1","name":"Минск","name_type":"г."}';
        System.assertEquals(expectedValue, actualValue);
    }
}