/************************************************************************
* Name : FPAN_Apex_TextQueAnswerTest
* Author : Anamitra Majumdar
* Date : 31/03/2023
* Desc : This is a test class of FPAN_Trigger_TextQueAnswer and FPAN_Apex_TextQueAnswerHandler
*************************************************************************/
@isTest
public class FPAN_Apex_TextQueAnswerTest {
    private static testmethod void answerOptionValidationTest(){
        FPAN_Question__c fpanQues1=new FPAN_Question__c();
        fpanQues1.FPAN_Question_Name__c='Test question 2';
        fpanQues1.FPAN_Question_Type__c='Text';
        fpanQues1.FPAN_Mandatory__c=True;
        Insert fpanQues1;
        
        FPAN_Answer_Option__c fpanAnsOpt1=new FPAN_Answer_Option__c();
        fpanAnsOpt1.FPAN_Answer_Option_Name__c='Option Test1';
        Insert fpanAnsOpt1;
        
        FPAN_Question_Answer_Option__c fpanQuesAnsOpt = new FPAN_Question_Answer_Option__c();
        try{
            fpanQuesAnsOpt.FPAN_Answer_Option_Name__c='Option Test1';
            fpanQuesAnsOpt.FPAN_Question__c=fpanQues1.Id;
            fpanQuesAnsOpt.FPAN_Answer_Option__c=fpanAnsOpt1.Id;
            fpanQuesAnsOpt.FPAN_Option_Number__c=1;
            Insert fpanQuesAnsOpt;
        }
        catch(Exception e){
            Boolean message=(e.getMessage().contains('Answer Option cannot be created for questions which are having Question Type as Text')) ? true : false;
            System.assertEquals(true, message);
        }
        
        FPAN_Question__c fpanQues=new FPAN_Question__c();
        fpanQues.FPAN_Question_Name__c='Test question 1';
        fpanQues.FPAN_Question_Type__c='Single Select';
        fpanQues.FPAN_Mandatory__c=True;
        Insert fpanQues;
        
        FPAN_Answer_Option__c fpanAnsOpt2=new FPAN_Answer_Option__c();
        fpanAnsOpt2.FPAN_Answer_Option_Name__c='Option Test2';
        Insert fpanAnsOpt2;
        
        FPAN_Question_Answer_Option__c fpanQuesAnsOpt2 = new FPAN_Question_Answer_Option__c();
        fpanQuesAnsOpt2.FPAN_Answer_Option_Name__c='Option Test2';
        fpanQuesAnsOpt2.FPAN_Question__c=fpanQues.Id;
        fpanQuesAnsOpt2.FPAN_Answer_Option__c=fpanAnsOpt2.Id;
        fpanQuesAnsOpt2.FPAN_Option_Number__c=1;
        Insert fpanQuesAnsOpt2;
        
        FPAN_Question_Answer_Option__c quesAnsOp=[SELECT FPAN_Answer_Option_Name__c,FPAN_Question__c,FPAN_Answer_Option__c,FPAN_Option_Number__c
                                                  FROM FPAN_Question_Answer_Option__c WHERE Id =:fpanQuesAnsOpt2.Id];
        
        try {
            quesAnsOp.FPAN_Question__c=fpanQues1.Id;
            update quesAnsOp;
        }
        catch(Exception e){
            Boolean message=(e.getMessage().contains('Answer Option cannot be created for questions which are having Question Type as Text')) ? true : false;
            System.assertEquals(true, message);
        }
        
        
        
    }
}