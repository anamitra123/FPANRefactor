/************************************************************************
* Name : FPAN_Apex_QueableCPOObj_Test
* Author : Ravi Kumar
* Date : 1/Feb/2022
* Desc : Test class for FPAN_Apex_QueableCreatePracticeCPOObj
*************************************************************************/
@isTest
public with sharing class FPAN_Apex_QueableCPOObj_Test {
    
    private static testMethod void QueableCPOObj() {
     
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);    
    Id CPOId = FPAN_TestDataUtility_Test.CreateCPO('CPO 2022');
    
    Id ObjId = FPAN_TestDataUtility_Test.CreateObjective('Patient Survey');
    Id CPOObjId = FPAN_TestDataUtility_Test.CreateCPOObjective('Patient Survey',ObjId,CPOId);
    Id PracticeCPOId = FPAN_TestDataUtility_Test.CreatePracticeCPO('Test Prac CPO',AccIdPractice,CPOId);
    Id PracticeCPOObjId = FPAN_TestDataUtility_Test.CreatePracticeCPOObjective('Test Prac CPO Obj',CPOObjId,PracticeCPOId);
    
    
    
    Test.startTest();
    

    Practice_CPO_Objectives__c PraCPOUpdate = [SELECT Id,Name,FPAN_Practice_CPO__c,FPAN_CPO_Objective__c,FPAN_Definition__c,FPAN_Not_Met__c from Practice_CPO_Objectives__c where Id =: PracticeCPOObjId];
    //PraCPOUpdate.FPAN_Agreement_Approved__c = TRUE;
    //Update PraCPOUpdate;
    

    
    Test.stopTest();
    
    
    
    }
}