/************************************************************************
* Name : FPAN_InitiateCPOButton_Test
* Author : Ravi Kumar
* Date : 16/Aug/2022
* Desc : Test class for FPAN_InitiateCPOButton
*************************************************************************/
@isTest
public class FPAN_InitiateCPOButton_Test {
    
    private static testMethod void InitiateCPOButton_Test() {
     
    Id AccIdPracticeForCOP=FPAN_TestDataUtility_Test.CreatePracticeAccountForCOP(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    Id CreateCPO = FPAN_TestDataUtility_Test.CreateCPO('CPO 2022');
    Id ObjId = FPAN_TestDataUtility_Test.CreateObjective('Patient Survey');
    Id CPOObjId = FPAN_TestDataUtility_Test.CreateCPOObjective('Patient Survey',ObjId,CreateCPO);
    Id PracticeCPO = FPAN_TestDataUtility_Test.CreatePracticeCPO('Test CPO',AccIdPractice,CreateCPO);
   
    Id AccIdPractice2 = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    System.debug('AccIdPractice2' + AccIdPractice2);
    System.debug('CreateCPO-->' + CreateCPO);
        
    Test.startTest();
    System.debug('I am Test class');
    FPAN_CPO__c GetCPOId = [SELECT Id from FPAN_CPO__c where Id =: CreateCPO];
    FPAN_InitiateCPOButton.getCpoObjRec(GetCPOId.Id);
    FPAN_InitiateCPOButton.InitiateCPO(GetCPOId.Id);
    
    
    Id PracticeCPO2 = FPAN_TestDataUtility_Test.CreatePracticeCPO('Test CPO',AccIdPractice,CreateCPO);
        
    Test.stopTest(); 
    }
}