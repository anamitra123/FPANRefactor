/**************************************************************************************************
* Name : FPAN_Acc_Fac_Spec_ControllerTest
* Author : Gaana Shetty
* Date : 02/09/2022
* Desc : Test class for FPAN_Account_Facility_Specialities.
****************************************************************************************************/

@isTest
public class FPAN_Acc_Fac_Spec_ControllerTest {
    static testMethod void testReport() {
        Id ProviderFacilityLoc_RecordTypeId = FPAN_TestDataUtility_Test.getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider_Location');
        Id AccIdProvider= FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        Id SpecilityID = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label);
        Id HPFPracId = FPAN_TestDataUtility_Test.CreatePracticeFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdPractice,AccIdProvider);
        HealthcarePractitionerFacility HPFObj = new HealthcarePractitionerFacility();
        
        HPFObj = new HealthcarePractitionerFacility (
            Name = 'name',
            RecordTypeId = ProviderFacilityLoc_RecordTypeId, // Provider Location
            FPAN_FPA_Status__c = 'Member',
            AccountId = AccIdProvider,
            FPAN_Practice_Name__c = AccIdPractice,
            IsPrimaryFacility = TRUE,
            IsActive = TRUE,
            FPAN_Facility_Sibling_Id__c = HPFPracId
        );
        
        INSERT HPFObj;

        HealthcarePractitionerFacility HPF = [SELECT Id,Name,AccountId,FPAN_FPA_Status__c, FPAN_Facility_Sibling_Id__c from HealthcarePractitionerFacility where Id =: HPFObj.Id  limit 1];
        Test.startTest();
        Id ProviderFacilitySpeId = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label,HPF.id,0.00,SpecilityID,false);

        FPAN_Acc_Fac_Spec_Controller.findByName('Inactive');
        FPAN_Acc_Fac_Spec_Controller.findByName('');
        Id LocationId =  FPAN_TestDataUtility_Test.CreateLocationRec('Bangalore City');
        Id ProvAssociatedLocId = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,AccIdProvider,HPFObj.Id);
		CareProviderFacilitySpecialty acc = [Select Id,Account.FPAN_Provider_Status__c,PractitionerFacility.FPAN_Facility_Sibling_Id__c From CareProviderFacilitySpecialty where Id =: ProviderFacilitySpeId]; 

        String ProviderStatus = acc.Account.FPAN_Provider_Status__c;
        Id Sibling_Id = acc.PractitionerFacility.FPAN_Facility_Sibling_Id__c; 
        AssociatedLocationCloned__c AssoLocCloned = New AssociatedLocationCloned__c();
            AssoLocCloned = new AssociatedLocationCloned__c (
            Name = 'AssLocClonedtest',
            FPAN_Provider_Facilities__c = Sibling_Id,
            ParentRecordId__c = AccIdProvider
        );
        
        INSERT AssoLocCloned;
        
        AssociatedLocationCloned__c loc = [Select Id, FPAN_Provider_Facilities__c From AssociatedLocationCloned__c where FPAN_Provider_Facilities__c =: Sibling_Id AND Id =:AssoLocCloned.Id];
        system.debug('@@@Sibling_Id'+Sibling_Id);
        List<FPAN_Acc_Fac_Spec_Controller.productwrapper> wrapperList = FPAN_Acc_Fac_Spec_Controller.findByName(ProviderStatus);
        
        
        Test.stopTest();
    }

}