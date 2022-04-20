public with sharing class ucl_LegalAdvisorsController {

    public static List<Legal_Advisor__c> selectLegalAdvisorsInSF(List<String> listAccNmbr){

        List<Legal_Advisor__c> qLegalAdvisors = ucl_ControllerQuery.querySelectLegalAdv(listAccNmbr);
        
        return qLegalAdvisors;
    }

    public void updateLegalAdvisorsList(List<Legal_Advisor__c> listLegAdvOrg, List<ucl_LegalAdvisors> listLegAdvAPI, List<String> listLegAdAccNmbrAPI, Map<String,ucl_LegalAdvisors> mapLegAdv ){

        List<Legal_Advisor__c> auxLegalAdvisorsInsert = new List<Legal_Advisor__c>();
        List<Id> auxLegalAdvisorsUpdate = new List<Id>();
        List<Client__c> temporaryClientList = new List<Client__c>();
        //List<Legal_Advisor__c> legAdvInOrg = new ucl_ControllerQuery.querySelectLegalAdv();

        for (Legal_Advisor__c legalAdv : listLegAdvOrg) {
            
            if(!listLegAdAccNmbrAPI.contains(legalAdv.Account_Number__c)) {
                
                //not contained in SF, must create the Legal Advisor
                ucl_LegalAdvisors legalAdvisorInMap = mapLegAdv.get(legalAdv.Account_Number__c);
                Legal_Advisor__c newLegalAdvisor = new Legal_Advisor__c();
                newLegalAdvisor.Account_Name__c = legalAdvisorInMap.AccountName;
                newLegalAdvisor.Account_Number__c = legalAdvisorInMap.AccountNumber;
                newLegalAdvisor.Account_Status__c = legalAdvisorInMap.AccountStatus;
                newLegalAdvisor.As_of_Date__c = date.parse(legalAdvisorInMap.AsOfDate);
                
                for(ucl_Client clientsInMap : legalAdvisorInMap.Clients){

                    Client__c newClient = new Client__c();
                    newClient.Email__c = clientsInMap.Email;
                    newClient.First_Name__c = clientsInMap.FirstName;
                    newClient.Last_Name__c = clientsInMap.LastName;
                    newClient.Phone__c = clientsInMap.Phone;
                    newClient.Address_Text__c = clientsInMap.Address;
                    newClient.Client_Number__c = clientsInMap.ClientNumber;
                    newClient.Account_Number__c = legalAdvisorInMap.AccountNumber;
                    
                    temporaryClientList.add(newClient);
                }
                auxLegalAdvisorsInsert.add(newLegalAdvisor);
            } 
            else{
                // legal advisors to be updated
                auxLegalAdvisorsUpdate.add(legalAdv.Id);
            }
        }

        if(auxLegalAdvisorsInsert.size() > 0) {
            insert auxLegalAdvisorsInsert;
            List<Legal_Advisor__c> insertedLegalAdvisors = [SELECT Id, Account_Number__c
                                                            FROM Legal_Advisor__c
                                                            WHERE Account_Number__c IN :listLegAdAccNmbrAPI];     
            
            Map<String, Id> accountNumberAndIds = new Map<String, Id>();
            for(Legal_Advisor__c ladv : insertedLegalAdvisors) {
                accountNumberAndIds.put(ladv.Account_Number__c, ladv.Id);
            }

            for(Client__c cli: temporaryClientList) {
                cli.Legal_Advisor__c = accountNumberAndIds.get(cli.Account_Number__c);
            }
            //clients insert with Legal Advisor related
            insert temporaryClientList;
        }

        if(auxLegalAdvisorsUpdate.size() > 0) {

            List<Legal_Advisor__c> advisorsToUpdate = [SELECT Id
                                                       ,Account_Number__c
                                                       ,Account_Name__c
                                                       ,Account_Status__c
                                                       ,As_of_Date__c
                                                       ,(SELECT Id, Account_Number__c FROM Clients__r)
                                                       FROM Legal_Advisor__c
                                                       WHERE Id IN :auxLegalAdvisorsUpdate];
            
            
           Map<String, List<Client__c>> accountNumberList = new Map<String, List<Client__c>>();

            for(Legal_Advisor__c ladv : advisorsToUpdate) {
                ucl_LegalAdvisors uclNewInfo = mapLegAdv.get(ladv.Account_Number__c);
                ladv.Account_Name__c = uclNewInfo.AccountName;
                ladv.Account_Number__c = uclNewInfo.AccountNumber;
                ladv.Account_Status__c = uclNewInfo.AccountStatus;
                ladv.As_of_Date__c = date.parse(uclNewInfo.AsOfDate);
                accountNumberList.put(ladv.Account_Number__c, ladv.Clients__r);
                
                
            }                                                       
            update advisorsToUpdate;

        }
        

    }


    public void updateClientInSF(List<Legal_Advisor__c> listLegAdvOrg, List<ucl_LegalAdvisors> listLegAdvAPI, List<String> listLegAdAccNmbrAPI, Map<String,ucl_LegalAdvisors> mapLegAdv ){
        
            // insert or delete clients
            //> genero lista de clientes Client__c para Legal Advisor AccNmbre           
            //> genero lista de ucl_Clients
            //> recorro listas y genero listas de ClientId
            //> comparo listas
            //> si lista de Client__c contien ClientId lista ucl_Clients => update
            //> si lista de Client__c !contiene ClientId lista ucl_Clients => delete Client__c
           List<Account_Number__c> auxLegal_Advisors__cInOrgList = [SELECT Account_Number__c FROM Legal_Advisor__c];

            List<ClientId__c> auxClient__cIdInOrgList = [SELECT ClientId__c 
                                                        ,(SELECT Account_Number__c FROM Legal_Advisor__c)
                                                        FROM Client__c
                                                        WHERE Account_Number__c IN :auxLegal_Advisors__cInOrgList];

            List<ClientId> auxUcl_ClientsIdInAPIList = new List<ClientId>();
            List<ucl_Client> uclClientsToCheck = new List<ucl_Client>();

            Map<String, List<ucl_Client>> accountNumberList = new Map<String, List<ucl_Client>>();

            for(ucl_LegalAdvisors legAdv : listLegAdvAPI) {
                ucl_LegalAdvisors uclLegAdv= mapLegAdv.get(legAdv.Clients);
                legAdv.Clients = uclLegAdv.Clients;
                
                accountNumberList.put(legAdv.AccountNumber, legAdv.Clients__r);

            }
            
            accountNumberList.putAll(uclClientsToCheck);

            for (ucl_Client uclCli : uclClientsToCheck){

                auxUcl_ClientsIdInAPIList.add(uclCli.setClientId(clientId));
            }

            for (ClientId__c cliId__c : auxClient__cIdInOrgList) {

                for(ClientId cliIdAPI : auxUcl_ClientsIdInAPIList){

                    if(!auxClient__cIdInOrgList.contains(cliIdAPI)){


                        //delete  
                    }

                    else if(cliIdAPI == cliId__c){


                        //update 
                    }
                }
            }
    }
}