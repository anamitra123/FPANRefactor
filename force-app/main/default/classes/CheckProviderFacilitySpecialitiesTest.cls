/**************************************************************************************************
* Name : CheckProviderFacilitySpecialitiesTest
* Author : Mayank Verma/Gaana Shetty
* Date : 07/17/2022
* Desc : Test class for CheckProviderFacilitySpecialities and FPANCheckDuplicationLocation
****************************************************************************************************/

@isTest(SeeAllData=true)
public class CheckProviderFacilitySpecialitiesTest {
    private static testMethod void CheckProviderFac(){
        Profile UserProfile = [Select Id, name from profile where name = 'FPAN Agent SuperBusinessAdmin' limit 1];
        
        Id AccIdProvider= FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        //Id ProviderFacilityId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.Provider_Facility_NAME_LABEL,AccIdProvider,AccIdPractice);
        
        Id ProviderFacilityLoc_RecordTypeId = FPAN_TestDataUtility_Test.getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider_Location');
        
        Id SpecilityID = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label);
        
        Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
        
        // Id LocationId1 = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
        
        
        HealthcarePractitionerFacility HPFObj = new HealthcarePractitionerFacility();
        HPFObj = new HealthcarePractitionerFacility (
            Name = 'name',
            RecordTypeId = ProviderFacilityLoc_RecordTypeId, // Provider Location
            FPAN_FPA_Status__c = 'Member',
            AccountId = AccIdProvider,
            FPAN_Practice_Name__c = AccIdPractice,
            IsPrimaryFacility = TRUE,
            IsActive = TRUE
        );
        
        INSERT HPFObj;
        
        HealthcarePractitionerFacility HPF = [SELECT Id,Name,AccountId,FPAN_FPA_Status__c from HealthcarePractitionerFacility where Id =: HPFObj.Id  limit 1];
        
        Test.startTest(); 
        Id ProviderFacilitySpeId = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label,HPF.id,1.0,SpecilityID,True);
        system.debug('!!!!ProviderFacilitySpeId'+ProviderFacilitySpeId);
        Id ProviderFacilitySpeId1 = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label,HPFObj.id,1.0,SpecilityID,False);
        Id AssocationIdProv = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,AccIdPractice,HPFObj.id);
        
        //Id CredId = FPAN_TestDataUtility_Test.CreateCredentialingRec(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,HPFObj.id);
        
        List<HealthcarePractitionerFacility> HPFList = New List<HealthcarePractitionerFacility>();
        HPFList.add(HPFObj);
        //Test.startTest();   
        CheckProviderFacilitySpecialities.checkProviderFacSpe(HPFList);
        Test.stopTest();
    }
    
    
    private static testMethod void CheckAssociateLocation(){
        Id ProviderFacilityLoc_RecordTypeId = FPAN_TestDataUtility_Test.getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider_Location');
        Id ProviderFacilityProv_RecordTypeId = FPAN_TestDataUtility_Test.getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider');
        Id AccIdProvider= FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        HealthcarePractitionerFacility HPFObj = new HealthcarePractitionerFacility();
        HPFObj = new HealthcarePractitionerFacility (
            Name = 'name',
            RecordTypeId = ProviderFacilityLoc_RecordTypeId, // Practice Location
            FPAN_FPA_Status__c = 'Member',
            AccountId = AccIdProvider,
            FPAN_Practice_Name__c = AccIdPractice,
            IsPrimaryFacility = TRUE,
            IsActive = TRUE
        );
        INSERT HPFObj;
        
        HealthcarePractitionerFacility HPFObj1 = new HealthcarePractitionerFacility();
        HPFObj1 = new HealthcarePractitionerFacility (
            Name = 'name',
            RecordTypeId = ProviderFacilityProv_RecordTypeId, // Provider Location
            FPAN_FPA_Status__c = 'Member',
            AccountId = AccIdProvider,
            FPAN_Practice_Name__c = AccIdPractice,
            IsPrimaryFacility = TRUE,
            IsActive = TRUE
        );
        INSERT HPFObj1;
        
        Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
        
        Id LocationId1 = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Loc_Name_Label);
        
        //Id LocationId2 = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Loc2_Name_Label);
        
        Id AssocationIdProv = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,AccIdPractice,HPFObj.id);
        
        Id AssocationIdPrac = FPAN_TestDataUtility_Test.CreatePracticeAssociatedLocRec(LocationId1,AccIdPractice);
        
        List<HealthcarePractitionerFacility> HPFList = New List<HealthcarePractitionerFacility>();
        List<HealthcarePractitionerFacility> HPFList1 = New List<HealthcarePractitionerFacility>();
        HPFList.add(HPFObj);
        HPFList1.add(HPFObj1);
        Test.startTest();   
        CheckProviderFacilitySpecialities.checkProviderFacSpe(HPFList);
        CheckProviderFacilitySpecialities.checkProviderFacSpe(HPFList1);
        Test.stopTest();     
    }
    
    private static testMethod void CheckCreds(){
        Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        system.debug('###AccIdProvider--->'+AccIdProvider);
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        system.debug('###AccIdPractice--->'+AccIdPractice);
        //Id HPFId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
        //system.debug('###HPFId--->'+HPFId);
        Id ProviderFacilityLoc_RecordTypeId = FPAN_TestDataUtility_Test.getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider_Location');
        
        HealthcarePractitionerFacility HPFObj = new HealthcarePractitionerFacility();
        HPFObj = new HealthcarePractitionerFacility (
            Name = 'name',
            RecordTypeId = ProviderFacilityLoc_RecordTypeId, // Provider Location
            FPAN_FPA_Status__c = 'Member',
            AccountId = AccIdProvider,
            FPAN_Practice_Name__c = AccIdPractice,
            IsPrimaryFacility = TRUE,
            IsActive = TRUE
        );
        INSERT HPFObj;
        
        Id CredId = FPAN_TestDataUtility_Test.CreateCredentialingRec(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,HPFObj.Id);
        system.debug('###CredId--->'+CredId);        
        List<HealthcarePractitionerFacility> HPFList = New List<HealthcarePractitionerFacility>();
        HPFList.add(HPFObj);
        Test.startTest();   
        CheckProviderFacilitySpecialities.checkProviderFacSpe(HPFList);
        Test.stopTest();
    }
}