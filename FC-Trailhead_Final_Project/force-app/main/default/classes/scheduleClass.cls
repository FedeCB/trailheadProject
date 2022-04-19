public class scheduleClass implements Schedulable {
    
    public static void execute(SchedulableContext ctx) {
        
        List<ucl_LegalAdvisors> legalAdvisorsList = ucl_ControllerList.convertJsonToList();
        List<String> listLegalAdvAccNmbr = new List<String>();
        Map<String, ucl_LegalAdvisors> mapLegAdvAPI = new Map<String, ucl_LegalAdvisors>();
        

        for(ucl_LegalAdvisors LegalAdv: legalAdvisorsList) {
            
            listLegalAdvAccNmbr.add(LegalAdv.AccountNumber);
            mapLegAdvAPI.put(LegalAdv.AccountNumber, LegalAdv);    
        }

        List<Legal_Advisor__c> listLegalAdvExistInOrg = ucl_LegalAdvisorsController.selectLegalAdvisorsInSF(listLegalAdvAccNmbr);

        ucl_LegalAdvisorsController.updateLegalAdvisorsList(listLegalAdvExistInOrg, legalAdvisorsList, listLegalAdvAccNmbr, mapLegAdvAPI);
        ucl_LegalAdvisorsController.updateClientInSF(listLegalAdvExistInOrg, legalAdvisorsList);        

    }
}