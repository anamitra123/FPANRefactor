/************************************************************************
* Name : FPAN_APEX_FetchProvFacSpecialtyLWC
* Author : Ravi Kumar
* Date : 28/Mar/2023
* Desc : This Apex class used for to return the Provider-Provider Speciality list to the LWC Component
* LWC : fpanGetProviderfacilities
* Test Class : FPAN_Apex_Portal_LWC_TestClass
*************************************************************************/

public with sharing class FPAN_APEX_FetchProvFacSpecialtyLWC {
    @AuraEnabled(cacheable=true)
    public static List<CareProviderFacilitySpecialty> GetProviderFacSpecialtyRec(Id recordId) {
    
    List<HealthcarePractitionerFacility> ListProvFac = [Select Id,Name,AccountId,Account.Name,
                                                        FPAN_Practice_Name__c,FPAN_Practice_Name__r.Name,FPAN_FPA_Status__c,
                                                        FPAN_Facility_Sibling_Id__c,FPAN_Provider_Name_Formula__c,FPAN_Practice_Name_Formula__c
                                                        from HealthcarePractitionerFacility where Id =: recordId];

    List<Id> SiblingId = New List<Id>();
    List<Id> PFId = New List<Id>();
        For(HealthcarePractitionerFacility HPF : ListProvFac){
            SiblingId.add(HPF.FPAN_Facility_Sibling_Id__c);
            PFId.add(HPF.Id);
        }
    List<CareProviderFacilitySpecialty> ListProvFacSpecreturn = [Select Id,Name,PractitionerFacilityId,FPAN_FTE__c,IsActive,IsPrimarySpecialty
                                                                    From CareProviderFacilitySpecialty where PractitionerFacilityId =: PFId and IsActive = TRUE];
		
        
        return ListProvFacSpecreturn; 

    }
}