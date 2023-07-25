/************************************************************************
* Name : FPAN_InitiateSurveyButton_Test
* Author : Abhijeet Ghodke
* Date : 22/Aug/2022
* Desc : Test class for FPAN_InitiateSurveyButton
*************************************************************************/
@isTest
public class FPAN_InitiateSurveyButton_Test {
    private static testMethod void InitiateSurveyButton_Test(){
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        Id CreateCPO = FPAN_TestDataUtility_Test.CreateCPO('CPO 2022');
    	Id ObjId = FPAN_TestDataUtility_Test.CreateObjective('Patient Survey');
   	 	Id CPOObjId = FPAN_TestDataUtility_Test.CreateCPOObjective('Patient Survey',ObjId,CreateCPO);
    	Id PracticeCPO = FPAN_TestDataUtility_Test.CreatePracticeCPO('Test CPO',AccIdPractice,CreateCPO);
    	Id AccIdPracticeForCOP=FPAN_TestDataUtility_Test.CreatePracticeAccountForCOP(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);             
        Id surveyId=FPAN_TestDataUtility_Test.CreateSurvey('Test Survey',CreateCPO);
        Id AssoSurveyCPOId = FPAN_TestDataUtility_Test.CreateAssoSurveyCPO(CreateCPO,surveyId); 
        Id practiceCopObj=FPAN_TestDataUtility_Test.CreatePracticeCPOObjective('Practice Cop Obj',CPOObjId,PracticeCPO);
        Id associateSurveyPracticeCPOId=FPAN_TestDataUtility_Test.createAssociateSurveyPracsObj('associateSurveyPracticeCPO',CreateCPO,surveyId);
        
        Id QuestionId=FPAN_TestDataUtility_Test.createSurveyQuestions('Test Question',surveyId,ObjId);
        Id createAssociateSurveyQuestionsId=FPAN_TestDataUtility_Test.createAssociateSurveyQuestions('Test Associate Ques', practiceCopObj, QuestionId);
     
        Test.startTest();
        System.debug('I am Survey Test class');
    	FPAN_CPO_Objective__c GetCPOObjId = [SELECT Id from FPAN_CPO_Objective__c where Id =: CPOObjId];
    	FPAN_InitiateSurveyButton.getCpoObjRec(GetCPOObjId.Id);
        
        FPAN_CPO__c GetCPOId = [SELECT Id from FPAN_CPO__c where Id =: CreateCPO];
        FPAN_InitiateSurveyButton.InitiateSurvey(GetCPOId.Id);
        //Survey
        FPAN_InitiateSurveyButton.getSurveyRec(surveyId);
        
        FPAN_InitiateSurveyButton.getCPOObjRecs(CreateCPO);
        Test.stopTest();
    }
    
    
}