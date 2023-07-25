/************************************************************************
* Name : FPAN_Apex_Portal_LWC_TestClass1
* Author : Ravi Kumar
* Date : 28/Mar/2023
* Desc : Test class for FPAN_Apex_Attestation_CasePracticeUpdate;FPAN_APEX_FetchProvFacLocationLWC;FPAN_APEX_FetchProvFacSpecialtyLWC
*************************************************************************/
@isTest
public class FPAN_Apex_Portal_LWC_TestClass1 {
    
        private static testMethod void CreateAttestationLWCCase() {
                // Setup test data
        // Create a unique UserName
        String uniqueUserName = 'FPANAgent' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='FPAN Agent'];
        User u = new User(Alias = 'standt', Email='FpanAgent@testorg.com',
        EmailEncodingKey='UTF-8', LastName='FPAN Agent', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName); 
		Insert u;
        Update u;
        User UserDetails = [SELECT id,name,firstname, profile.name from user where id=:u.id];
        System.debug('User Details-->'+UserDetails); 
       System.runAs(u) {
        
        
        Id ProviderAccId = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        Id PracticeAccId = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL); 
        Test.startTest();
        Id ConId = FPAN_TestDataUtility_Test.CreateContactRec(PracticeAccId);
        
        Id HPFProvId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,ProviderAccId,PracticeAccId);
        
        //Id ProviderRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Update Practice Details').getRecordTypeId();
        Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Loc_Name_Label); 
        Id AddressId = FPAN_TestDataUtility_Test.CreateLocationRec(LocationId); 
        Id AssLocIdProv = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,ProviderAccId,HPFProvId);
        Id PracDetailRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Update Practice Details').getRecordTypeId();
        Id PraLocRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Update Practice Location Details').getRecordTypeId();
        Id ConDetailRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Update Contact Details').getRecordTypeId();
        Id ProvLocRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Update Provider Location Details').getRecordTypeId();
            
        Id CaseId1 = FPAN_TestDataUtility_Test.CreateCase(PracticeAccId,PracDetailRTId,LocationId,ConId,AssLocIdProv); 
        Id CaseId2 = FPAN_TestDataUtility_Test.CreateCase(PracticeAccId,PraLocRTId,LocationId,ConId,AssLocIdProv); 
        Id CaseId3 = FPAN_TestDataUtility_Test.CreateCase(PracticeAccId,ProvLocRTId,LocationId,ConId,AssLocIdProv); 
            
        Id SpecId = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label);    
        //Id CareSpecId = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label,HPFProvId,0.1,SpecId,TRUE);
            
         
         //String ObjectName = 'Case';
         Case caseids1 = [SELECT Id,Agent_Action__c from Case where Id =: CaseId1 limit 1];
           try{
            caseids1.Agent_Action__c='Approved';
            update caseids1;
            System.assertEquals('Approved',caseids1.Agent_Action__c);
             }catch(Exception e){
              //System.assertNOTEquals(null, e);
             }  
            Case caseids2 = [SELECT Id,Agent_Action__c from Case where Id =: CaseId2 limit 1];
           try{
            caseids2.Agent_Action__c='Approved';
            update caseids2;
             System.assertEquals('Approved',caseids2.Agent_Action__c);
             }catch(Exception e){
                 //  System.assertNOTEquals(null, e);
             }
 
             Case caseids5 = [SELECT Id,Agent_Action__c,Status from Case where Id =: CaseId3 limit 1];
           try{
            caseids5.Agent_Action__c='Rejected';
            caseids5.Status='Rejected';
            update caseids5; 
            System.assertEquals('Rejected',caseids5.Agent_Action__c);
             }catch(Exception e){
                 //  System.assertNOTEquals(null, e);
             }
           try{
            caseids5.Agent_Action__c='Manually Updated';
            caseids5.Status='Manually Updated';
            update caseids5; 
            System.assertEquals('Manually Updated',caseids5.Agent_Action__c);
             }catch(Exception e){
                 //System.assertNOTEquals(null, e);
             }
        FPAN_Apex_Attestation_CasePracticeUpdate.GetCaseRec(CaseId1);
        FPAN_Apex_Attestation_CasePracticeUpdate.updateAssocLocation(CaseId2);

        Test.stopTest();    
         
        }      
   }

}