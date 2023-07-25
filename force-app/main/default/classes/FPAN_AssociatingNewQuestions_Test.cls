@isTest
public class FPAN_AssociatingNewQuestions_Test {
    private static testMethod void FPAN_AssociatingNewQuestions(){
    Id AccIdPracticeForCOP=FPAN_TestDataUtility_Test.CreatePracticeAccountForCOP(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);    
    Id CPOId = FPAN_TestDataUtility_Test.CreateCPO('CPO 2022');
    Id CPOId2 = FPAN_TestDataUtility_Test.CreateCPO('CPO 2021');
    
    Id ObjId = FPAN_TestDataUtility_Test.CreateObjective('Patient Survey');
    Id CPOObjId = FPAN_TestDataUtility_Test.CreateCPOObjective('Patient Survey',ObjId,CPOId);
   
    Id PracticeCPOId = FPAN_TestDataUtility_Test.CreatePracticeCPO('Test Prac CPO',AccIdPractice,CPOId);
    Id PracticeCPOId2 = FPAN_TestDataUtility_Test.CreatePracticeCPO('Test Prac CPO',AccIdPracticeForCOP,CPOId);
    Id PracticeCPOObjId = FPAN_TestDataUtility_Test.CreatePracticeCPOObjective('Test Prac CPO Obj',CPOObjId,PracticeCPOId);
    Id CPOObjId2 = FPAN_TestDataUtility_Test.CreateCPOObjective('Patient Survey',ObjId,CPOId);
    
    Id SurveyId=FPAN_TestDataUtility_Test.CreateSurvey('Test Survey' ,CPOId);
    Id SurveyQuestionId=FPAN_TestDataUtility_Test.createSurveyQuestions('Test Question',SurveyId,ObjId);    
    Id AssociateSurveyQuestionId=FPAN_TestDataUtility_Test.createAssociateSurveyQuestions('Test Associate Question',PracticeCPOObjId,SurveyQuestionId);
    Id AssSurveyCPOId = FPAN_TestDataUtility_Test.CreateAssoSurveyCPO(CPOId,SurveyId);
    Id SurveyQuestionId2 = FPAN_TestDataUtility_Test.createSurveyQuestions('Test Question',SurveyId,ObjId);    
    
     // Public static Integer newQuestionAssocation(Set<Id> PracCPOId2,List<Id> CPOrecordIds)
         //PracticeCPOId        
        Set<Id>practiceCpoIdList=new Set<Id>();
        practiceCpoIdList.add(PracticeCPOId);
        practiceCpoIdList.add(PracticeCPOId2);
        
        List<Id>CPOIdSet=new List<Id>();
        CPOIdSet.add(CPOId);
        CPOIdSet.add(CPOId2);
        
        FPAN_AssociatingNewQuestions.newQuestionAssocation(practiceCpoIdList,CPOIdSet);
        
        
    }
}