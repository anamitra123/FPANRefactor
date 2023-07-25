/************************************************************************
* Name : FPAN_Apex_ExtensionControllerTest
* Author : Sreeni
* Date : 20/Dec/2021
* Desc : Test class for FPAN_Apex_ExtensionController
*************************************************************************/
@isTest
public class FPAN_Apex_ExtensionControllerTest {
    
    private static testMethod void testRedirect() {
    
    Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
    Id HPFPracId = FPAN_TestDataUtility_Test.CreatePracticeFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    
    PageReference pageRef = Page.FPAN_PF_EDIT;
        
        test.startTest();
        
        HealthcarePractitionerFacility HPFId = [SELECT Id from HealthcarePractitionerFacility where Id =: HPFPracId limit 1];
        
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',HPFId.id);
        ApexPages.StandardController sc = new ApexPages.standardController(HPFId);
        FPAN_Apex_ExtensionController  controller = new FPAN_Apex_ExtensionController(sc);
        System.assertNotEquals(null,controller.redirect());
        test.stopTest();
    }
    
}