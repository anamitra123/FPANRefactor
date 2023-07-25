/************************************************************************
* Name : FPAN_Trigger_TextQueAnswer
* Author : Anamitra Majumdar
* Date : 31/03/2023
* Desc : This trigger is used to restrict FPAN agent to insert or update question answer option 
for question which are having type as Text
*************************************************************************/
trigger FPAN_Trigger_TextQueAnswer on FPAN_Question_Answer_Option__c (before insert,before update) {
    if(Trigger.IsInsert && Trigger.IsBefore){
        
        FPAN_Apex_TextQueAnswerHandler.answerOptionValidation(Trigger.new);
    }
    
    if(Trigger.IsUpdate && Trigger.IsBefore){
        
        for(FPAN_Question_Answer_Option__c quesAlist : Trigger.new){
            FPAN_Question_Answer_Option__c  oldQueAnsRec = Trigger.oldMap.get(quesAlist.ID);    
            if(oldQueAnsRec.FPAN_Question__c != quesAlist.FPAN_Question__c)  {  
                FPAN_Apex_TextQueAnswerHandler.answerOptionValidation(Trigger.new);
            }
        }
    }
}