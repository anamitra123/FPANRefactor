/************************************************************************
* Name : FPAN_Apex_GetSurveyAnswer
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This is the controller class of FpanLwcStartSurvey cmp,
this class is used to retreive the executed survey question and provided answers
*************************************************************************/
public without sharing class FPAN_Apex_GetSurveyAnswer {

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getSurveyAnswers(String user){
        User userId=   [SELECT Id,ContactId FROM User WHERE Id= :user];
        FPAN_Survey_Results__c sresult=[SELECT Id, Name FROM FPAN_Survey_Results__c WHERE CreatedById =:userId.Id ORDER BY Name DESC LIMIT 1];
        List<FPAN_QuestionAnswerResults__c> qaList =[SELECT Id, FPAN_Provided_Answer__c, Question__r.Name,Question__r.FPAN_Question_Name__c, FPAN_Survey_User__c FROM FPAN_QuestionAnswerResults__c WHERE FPAN_Survey_User__c =:sresult.Id AND Question__c!= NULL];
        
        Map<String, String> qaMap = new Map<String, String>();
        for(FPAN_QuestionAnswerResults__c qares : qaList){
           qaMap.put(qares.Question__r.FPAN_Question_Name__c,qares.FPAN_Provided_Answer__c);
        }
        
        return qaMap;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getSurveyConern(String user){

    User userId=   [SELECT Id,ContactId FROM User WHERE Id= :user];
    FPAN_Survey_Results__c sresult=[SELECT Id, Name,FPAN_Comments__c FROM FPAN_Survey_Results__c 
    WHERE CreatedById =:userId.Id ORDER BY Name DESC LIMIT 1];
    String conern=sresult.FPAN_Comments__c;
    return conern;
    }
 
    @AuraEnabled(cacheable=true)
    public static List<FPAN_Survey_Results__c> getSurveyDetails(String user){

    User userId=   [SELECT Id,ContactId FROM User WHERE Id= :user];
    List<FPAN_Survey_Results__c> sresult=[SELECT Id, Name,FPAN_Comments__c ,FPAN_Practice_CPO__r.Fpan_CpoYear__c,FPAN_Practice_CPO__r.Name,	FPAN_Survey__r.Name FROM FPAN_Survey_Results__c 
    WHERE CreatedById =:userId.Id ORDER BY Name DESC LIMIT 1];
    //String conern=sresult.FPAN_Comments__c;
    return sresult;
    }
    
    
}