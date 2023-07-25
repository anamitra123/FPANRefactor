/************************************************************************
* Name : FPAN_Remove_Practice_Frm_Provider_Test
* Author : Mayank Verma
* Date : 26/July/2022
* Desc : Test class for FPAN_Remove_Practice_Frm_Provider
*************************************************************************/
@isTest
public class FPAN_Remove_Practice_Frm_Provider_Test {
    private static testMethod void RemoveProviderFac(){
        Profile UserProfile = [Select Id, name from profile where name = 'FPAN Agent SuperBusinessAdmin' limit 1];
        
        Id AccIdProvider= FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        Id Practice_AccRecordTypeId = FPAN_TestDataUtility_Test.getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider_Location');
        
        HealthcarePractitionerFacility HPFObj = new HealthcarePractitionerFacility();
        HPFObj = new HealthcarePractitionerFacility (
            Name = 'name',
            RecordTypeId =  Practice_AccRecordTypeId, // Provider Location
            FPAN_FPA_Status__c = 'Member',
            AccountId = AccIdProvider,
            FPAN_Practice_Name__c = AccIdPractice,
            IsPrimaryFacility = TRUE,
            IsActive = TRUE
        );
        
        INSERT HPFObj;
        
        List<HealthcarePractitionerFacility> HPFList = New List<HealthcarePractitionerFacility>();
        HPFList.add(HPFObj);
        
        Test.startTest();   
        FPAN_Remove_Practice_Frm_Provider.RemovePracticefromProvider(HPFList);
        Test.stopTest();
    }
     private static testMethod void RemoveProviderFac1(){
        Profile UserProfile = [Select Id, name from profile where name = 'FPAN Agent SuperBusinessAdmin' limit 1];
        
        Id AccIdProvider= FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        Id Provider_AccRecordTypeId = FPAN_TestDataUtility_Test.getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider');
        
        HealthcarePractitionerFacility HPFObj = new HealthcarePractitionerFacility();
        HPFObj = new HealthcarePractitionerFacility (
            Name = 'name',
            RecordTypeId = Provider_AccRecordTypeId, // Provider
            FPAN_FPA_Status__c = 'Member',
            AccountId = AccIdProvider,
            FPAN_Practice_Name__c = AccIdPractice,
            IsPrimaryFacility = TRUE,
            IsActive = TRUE
        );
        
        INSERT HPFObj;
         
        List<HealthcarePractitionerFacility> HPFList = New List<HealthcarePractitionerFacility>();
        HPFList.add(HPFObj);
         
        Test.startTest();   
        FPAN_Remove_Practice_Frm_Provider.RemovePracticefromProvider(HPFList);
        Test.stopTest();
    }
}