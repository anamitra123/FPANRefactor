/************************************************************************
* Name : FPAN_APEX_FetchProvFacLWC
* Author : Ravi Kumar
* Date : 28/Mar/2023
* Desc : This Apex class used for to return the Provider-Provider Facility list to the LWC Component
* LWC : fpanGetProviderfacilities
* Test Class : FPAN_Apex_Portal_LWC_TestClass
*************************************************************************/

public without sharing class FPAN_APEX_FetchProvFacLWC {
    @AuraEnabled()
    public static List<HealthcarePractitionerFacility> GetProviderFacRec(Id accountId) {
        
        List<HealthcarePractitionerFacility> ListProvFac = [Select Id,Name,AccountId,Account.Name,
                                                            FPAN_Practice_Name__c,FPAN_Practice_Name__r.Name,FPAN_FPA_Status__c,
                                                            FPAN_Facility_Sibling_Id__c,FPAN_Provider_Name_Formula__c,FPAN_Practice_Name_Formula__c
                                                            from HealthcarePractitionerFacility where AccountId =: accountId];
        system.debug('@@@ListProvFac--->'+ListProvFac);
        system.debug('@@@ListProvFac Size--->'+ListProvFac.size());
        List<Id> ProviderId = New List<Id>();
        List<Id> SiblingId = New List<Id>();
        For(HealthcarePractitionerFacility HPF : ListProvFac){
            ProviderId.add(HPF.FPAN_Practice_Name__c);
            SiblingId.add(HPF.FPAN_Facility_Sibling_Id__c);
        }
        system.debug('@@@SiblingId--->'+SiblingId);
        List<HealthcarePractitionerFacility> ListProvFacreturn = [Select Id,Name,AccountId,Account.Name,
                                                            FPAN_Practice_Name__c,FPAN_Practice_Name__r.Name,FPAN_FPA_Status__c,
                                                            FPAN_Facility_Sibling_Id__c,FPAN_Provider_Name_Formula__c,FPAN_Practice_Name_Formula__c,
                                                            FPAN_FTE__c,FPAN_Specialty_Name__c,FPAN_FPA_Membership_Effective_Date__c,FPAN_Last_Name_Portal__c,
                                                            FPAN_Business_Email__c
                                                            from HealthcarePractitionerFacility where ID =: SiblingId and FPAN_FPA_Status__c != NULL and (FPAN_FPA_Status__c =: Label.FPAN_FPA_Status_Member OR FPAN_FPA_Status__c =: Label.FPAN_FPA_Status_AHP_Member)];
        system.debug('@@@ListProvFacreturn--->'+ListProvFacreturn);
        return ListProvFacreturn;                  


    }
}