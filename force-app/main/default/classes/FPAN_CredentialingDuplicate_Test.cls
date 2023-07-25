/************************************************************************
* Name : FPAN_CredentialingDuplicate_Test
* Author : Ravi Kumar
* Date : 24/Dec/2021
* Desc : Test class for FPAN_CredentialingDuplicate
*************************************************************************/
@isTest
public with sharing class FPAN_CredentialingDuplicate_Test {
    
    private static testMethod void DuplicateCredentialing() {
    
    Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    system.debug('###AccIdProvider--->'+AccIdProvider);
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    system.debug('###AccIdPractice--->'+AccIdPractice);
    Id HPFId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    system.debug('###HPFId--->'+HPFId);
    Id CredId = FPAN_TestDataUtility_Test.CreateCredentialingRec(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,HPFId);
    system.debug('###CredId--->'+CredId);
    test.startTest();
        
        vlocity_ins__ProviderNetwork__c Cred = [SELECT Id,Name,FPAN_Practice_Account__c from vlocity_ins__ProviderNetwork__c where FPAN_Practice_Account__c =: HPFId limit 1];
        system.debug('###Cred--->'+Cred);
        Update Cred;
        
    test.stopTest();    
    }
}