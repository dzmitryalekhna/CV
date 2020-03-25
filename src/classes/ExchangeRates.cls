public class ExchangeRates {
    @AuraEnabled
    public static String getExchangeRates() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://belarusbank.by/api/kursExchange?city=Минск');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        String exchangeRatesInfo = null;
        if (response.getStatusCode() == 200) {
            exchangeRatesInfo = response.getBody();
        }
        return exchangeRatesInfo;
    }
}