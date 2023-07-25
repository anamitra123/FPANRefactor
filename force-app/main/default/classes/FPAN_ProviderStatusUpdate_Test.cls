/************************************************************************
* Name : FPAN_ProviderStatusUpdate_Test
* Author : Ravi Kumar
* Date : 22/Dec/2021
* Desc : Test class for FPAN_ProviderStatusUpdate
*************************************************************************/
@isTest
public with sharing class FPAN_ProviderStatusUpdate_Test {
    
    private static testMethod void UpdateProviderStatus() {
    
    /*Id RecordtypeId = FPAN_TestDataUtility_Test.getRecordTypeIdByDeveloperName(FPAN_TestDataUtility_Test.Provider_Facility_API,FPAN_TestDataUtility_Test.Provider_Location_RT);   
    */  
    
    Id AccIdProvider= FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);  

	Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
	
    Id HPFId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.Provider_Facility_NAME_LABEL,AccIdProvider,AccIdPractice);
    
    test.startTest();

        HealthcarePractitionerFacility HPF = [SELECT Id,Name,AccountId,FPAN_FPA_Status__c from HealthcarePractitionerFacility where AccountId =: AccIdProvider limit 1];
        HPF.FPAN_FPA_Status__c = 'Member';
        Update HPF;
                    
    test.stopTest();    
    }
}