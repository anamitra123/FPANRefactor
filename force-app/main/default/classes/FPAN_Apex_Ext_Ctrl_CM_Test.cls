/************************************************************************
* Name : FPAN_Apex_Ext_Ctrl_CM_Test
* Author : Ravi
* Date : 26/July/2022
* Desc : Test class for FPAN_Apex_Ext_Ctrl_Committee_Member
*************************************************************************/
@isTest
public class FPAN_Apex_Ext_Ctrl_CM_Test {
    
    private static testMethod void testRedirect() {
    
    
    Id AccIdCM = FPAN_TestDataUtility_Test.CreateCommitteeMember(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
    
    
    Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
    Id HPFPracId = FPAN_TestDataUtility_Test.CreatePracticeFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    
    Id ConId = FPAN_TestDataUtility_Test.CreateContactRec(AccIdPractice);
    
    Id AsstId = FPAN_TestDataUtility_Test.CreateAsstContactRec(AccIdPractice);
    
    Id CommitteeMemberId = FPAN_TestDataUtility_Test.CreateCommitteeMember(AccIdCM,ConId,AsstId);
    
    PageReference pageRef = Page.FPAN_Committee_Member_EDIT;
        
        test.startTest();
        
        Committee_Member__c CMId = [SELECT Id from Committee_Member__c where Id =: CommitteeMemberId limit 1];
        
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',CMId.id);
        ApexPages.StandardController sc = new ApexPages.standardController(CMId);
        FPAN_Apex_Ext_Ctrl_Committee_Member  controller = new FPAN_Apex_Ext_Ctrl_Committee_Member(sc);
        System.assertNotEquals(null,controller.redirect());
        test.stopTest();
    }
    
}