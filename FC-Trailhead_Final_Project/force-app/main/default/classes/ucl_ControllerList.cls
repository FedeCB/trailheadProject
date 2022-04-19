public with sharing class ucl_ControllerList {
    
    // Convierto el JSON a una List
    public static List<ucl_LegalAdvisors> convertJsonToList() {

        ControllerAPI conAPI = new ControllerAPI();
        HttpResponse auxResponse = conAPI.callApi();
        List<ucl_LegalAdvisors> listLegalAdvisors;
        
        // If the request is successful, parse the JSON response.
        if(auxResponse.getStatusCode() == 200) {
            // Deserialize the JSON string 
            listLegalAdvisors = (List<ucl_LegalAdvisors>) JSON.deserialize(auxResponse.getBody(), List<ucl_LegalAdvisors>.class);
             
            
        } 	

        
        return listLegalAdvisors;
        
    }

    

}