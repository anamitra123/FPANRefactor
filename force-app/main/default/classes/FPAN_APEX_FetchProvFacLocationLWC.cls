/************************************************************************
* Name : FPAN_APEX_FetchProvFacLocationLWC
* Author : Ravi Kumar
* Date : 28/Mar/2023
* Desc : This Apex class used for to return the Provider-Provider Location list to the LWC Component
* LWC : fpanGetProviderfacilities
* Test Class : FPAN_Apex_Portal_LWC_TestClass
*************************************************************************/

public with sharing class FPAN_APEX_FetchProvFacLocationLWC {
    @AuraEnabled(cacheable=true)
    public static List<AssociatedLocationCloned__c> GetProviderFacLocationRec(Id recordId) {
        system.debug('@@@recordId--->'+recordId);
        /*
        Set<Id> PracticeId = New Set<Id>();
        List<User> ListUser = [Select Id,Name,AccountId from User where Id =:recordId];
        for(User u : ListUser){
            PracticeId.add(u.AccountId);
        }
        system.debug('@@@PracticeId--->'+PracticeId);
		*/
        
        List<HealthcarePractitionerFacility> ListProvFac = [Select Id,Name,AccountId,Account.Name,
                                                            FPAN_Practice_Name__c,FPAN_Practice_Name__r.Name,FPAN_FPA_Status__c,
                                                            FPAN_Facility_Sibling_Id__c,FPAN_Provider_Name_Formula__c,FPAN_Practice_Name_Formula__c
                                                            from HealthcarePractitionerFacility where Id =: recordId];
		List<Id> PFId = New List<Id>();
        List<Id> SiblingId = New List<Id>();
        For(HealthcarePractitionerFacility HPF : ListProvFac){
			PFId.add(HPF.Id);
             SiblingId.add(HPF.FPAN_Facility_Sibling_Id__c);
        }
        system.debug('@@@PFId--->'+PFId);
		List<AssociatedLocationCloned__c> ListProvFacLocreturn = [Select Id,Name,FPAN_Provider_Facilities__c,Location__c,FPAN_Location_Name_Formula__c,FPAN_Provider_PCC__c,
                                                                    FPAN_FPA_Main_Site__c,FPAN_Provider_Mail_Site__c,FPAN_Provider_Site_Directory__c,FPAN_Location_Site_NPI__c,
                                                                    FPAN_Address_Suite_No__c,FPAN_Provider_Directory_Main__c,FPAN_Address__c,Address__c
                                                                    From AssociatedLocationCloned__c where FPAN_Provider_Facilities__c =: SiblingId];
		
        system.debug('@@@ListProvFacLocreturn--->'+ListProvFacLocreturn);
        return ListProvFacLocreturn;                  


    }
}