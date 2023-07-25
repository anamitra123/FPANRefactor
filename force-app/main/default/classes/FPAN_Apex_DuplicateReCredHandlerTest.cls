/*****************************************************************************************************************
* Name : FPAN_Apex_DuplicateReCredHandlerTest
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This the test class of Fpan_Trigger_DuplicateRecredentialing trigger and FPAN_Apex_DuplicateReCredHandler
********************************************************************************************************************/
@isTest
public class FPAN_Apex_DuplicateReCredHandlerTest {
    private static testMethod void DuplicateReCredHandlerTest(){
        Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    system.debug('###AccIdProvider--->'+AccIdProvider);
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    system.debug('###AccIdPractice--->'+AccIdPractice);
    Id HPFId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    system.debug('###HPFId--->'+HPFId);
    Id CredId = FPAN_TestDataUtility_Test.CreateCredentialingRec(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,HPFId);
    system.debug('###CredId--->'+CredId);
        vlocity_ins__ProviderNetworkMember__c ReCredObj =new vlocity_ins__ProviderNetworkMember__c();
        ReCredObj.Name='Test';
        ReCredObj.vlocity_ins__ProviderNetworkId__c=CredId;
        Insert ReCredObj;
        System.debug('ReCredObj Id-->'+ReCredObj.Id);
        
        Test.startTest();
        vlocity_ins__ProviderNetworkMember__c ReCredObj2 =new vlocity_ins__ProviderNetworkMember__c();
        ReCredObj2.Name='Test2';
        ReCredObj2.vlocity_ins__ProviderNetworkId__c=CredId;
        try{
        Insert ReCredObj2;
        System.debug('ReCredObj Id-->'+ReCredObj2.Id);
        }
        catch(Exception e){
           //System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            //System.assert(e.getMessage().contains('The Npi is already associated with another provider account'));
            Boolean expectedExceptionThrown =  e.getMessage().contains('We found Duplicate ReCredentialing Record, A credentialing record should have only one Recredentialing record') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }
}