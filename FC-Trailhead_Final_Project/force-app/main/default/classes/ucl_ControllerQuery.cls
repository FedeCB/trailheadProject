public with sharing class ucl_ControllerQuery {

    public static List<Legal_Advisor__c> querySelectLegalAdv(List<String> auxListLA) {
         
        List<Legal_Advisor__c> qListLegalAdvisors = [SELECT Id, Account_Number__c
                                                    FROM Legal_Advisor__c
                                                    WHERE Account_Number__c IN : auxListLA];

        return qListLegalAdvisors;                                                
    }

    public static List<Client__c> querySelectClientsFromLegalAdvisors(List<String> auxListC){
        
         List<Client__c> qListClients = [SELECT Client_Number__c
                                         FROM  Client__c 
                                         WHERE  Client_Number__c NOT IN :auxListC ];
        
        return qListClients;
        
    } 

}