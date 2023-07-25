/************************************************************************
* Name : FPAN_Apex_TextQueAnswerHandler
* Author : Anamitra Majumdar
* Date : 31/03/2023
* Desc : This is a handler class of FPAN_Trigger_TextQueAnswer
*************************************************************************/
public class FPAN_Apex_TextQueAnswerHandler {
    public static void answerOptionValidation(List<FPAN_Question_Answer_Option__c> QuesAnsOptList){
        Set<Id> queId=new Set<Id>();
        List<FPAN_Question__c> Ques=[SELECT Id, FPAN_Question_Name__c, FPAN_Question_Type__c FROM FPAN_Question__c WHERE FPAN_Question_Type__c  ='Text'];
        for(FPAN_Question__c quelist : Ques){
            queId.add(quelist.Id);
        }
        
        for(FPAN_Question_Answer_Option__c queAns : QuesAnsOptList){
            
            if(queId.contains(queAns.FPAN_Question__c)){
                
                queAns.addError('Answer Option cannot be created for questions which are having Question Type as Text');
            }
        }
        
    }

}