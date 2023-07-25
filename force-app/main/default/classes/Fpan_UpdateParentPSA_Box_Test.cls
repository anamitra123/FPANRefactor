/************************************************************************
* Name : Fpan_UpdateParentPSA_Box_Test
* Author : Ravi Kumar
* Date : 11/Nov/2022
* Desc : Test class for Fpan_Apex_UpdateParentPSA_Box
*************************************************************************/
@isTest
public with sharing class Fpan_UpdateParentPSA_Box_Test {
    
    private static testMethod void UpdatePSABox() {
    
    Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    Id BusinessLicenseId = FPAN_TestDataUtility_Test.CreateBusinessLicense(AccIdProvider); 
        
    test.startTest();
  
        BusinessLicense BL = [Select Id,Name,FPAN_Malpractice_Insurance_Co__c,AccountId From BusinessLicense where Id =: BusinessLicenseId limit 1];
        BL.FPAN_Malpractice_Insurance_Co__c = 'University of Minnesota Physicians Assurance Co';           
        Update BL;
      	test.stopTest();      
        
        BusinessLicense BL1 = [Select Id,Name,FPAN_Malpractice_Insurance_Co__c,AccountId From BusinessLicense where Id =: BusinessLicenseId limit 1];
     try{
     Delete BL1;
        } catch (DmlException ex) {
            System.debug('Exception-->'+ex);
        }  
    }
}