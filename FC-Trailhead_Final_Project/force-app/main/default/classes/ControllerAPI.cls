public with sharing class ControllerAPI {
    // Llamo a la API
    public HttpResponse callApi(){
        Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            
            return response;
    }

    

}