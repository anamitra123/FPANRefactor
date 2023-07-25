/************************************************************************
* Name : FPAN_AssociatingPracticeCpoObjectives
* Author : Abhijeet Ghodke
* Date : 30/August/2022
* Desc : FPAN_AssociatingPracticeCpoObj_Test For FPAN_AssociatingPracticeCpoObjectives class
*************************************************************************/
@isTest
public class FPAN_AssociatingPracticeCpoObj_Test {
    
    private static testMethod void FPAN_AssociatingPracticeCpoObj(){
    Id AccIdPracticeForCOP=FPAN_TestDataUtility_Test.CreatePracticeAccountForCOP(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);    
    Id CPOId = FPAN_TestDataUtility_Test.CreateCPO('CPO 2022');
    
    Id ObjId = FPAN_TestDataUtility_Test.CreateObjective('Patient Survey');
    Id CPOObjId = FPAN_TestDataUtility_Test.CreateCPOObjective('Patient Survey',ObjId,CPOId);
    Id PracticeCPOId = FPAN_TestDataUtility_Test.CreatePracticeCPO('Test Prac CPO',AccIdPractice,CPOId);
    Id PracticeCPOId2 = FPAN_TestDataUtility_Test.CreatePracticeCPO('Test Prac CPO',AccIdPracticeForCOP,CPOId);
    Id PracticeCPOObjId = FPAN_TestDataUtility_Test.CreatePracticeCPOObjective('Test Prac CPO Obj',CPOObjId,PracticeCPOId);
    Id CPOObjId2 = FPAN_TestDataUtility_Test.CreateCPOObjective('Patient Survey',ObjId,CPOId);
    
    Test.startTest();
    List<FPAN_Practice_CPO__c> ListPracCPO = [Select Id,FPAN_CPO__c,FPAN_Practice_Account__c,FPAN_CPO_Type_Formula__c From FPAN_Practice_CPO__c where Id =:PracticeCPOId ];
    System.debug('I am In FPAN_AssociatingPracticeCpoObj_Test class');
    FPAN_AssociatingPracticeCpoObjectives.associatingObjecvtives(ListPracCPO);
   
    Test.stopTest();
    }
   
}