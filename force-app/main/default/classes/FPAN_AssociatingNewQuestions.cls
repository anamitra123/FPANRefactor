public class FPAN_AssociatingNewQuestions {
    Public static Integer newQuestionAssocation(Set<Id> PracCPOId2,List<Id> CPOrecordIds){
    List<FPAN_Associate_Survey_Question__c> InsertAssSurveyQues = New List<FPAN_Associate_Survey_Question__c>();
    List<Practice_CPO_Objectives__c> ListOfPracCPOobj = [Select Id,Name,FPAN_Practice_CPO__c,FPAN_Practice_CPO__r.FPAN_CPO_Type_Formula__c,FPAN_CPO_Objective__c,FPAN_CPO_Objective__r.FPAN_Objective__c From Practice_CPO_Objectives__c where FPAN_Practice_CPO__c IN: PracCPOId2];
    
    System.debug('ListOfPracCPOobj----->'+ListOfPracCPOobj);
    System.debug('ListOfPracCPOobj Size----->'+ListOfPracCPOobj.Size());
    
    Set<Id> SetOfPracCPOObjId = New Set<Id>();
    for(Practice_CPO_Objectives__c PracCpoObj : ListOfPracCPOobj){
        SetOfPracCPOObjId.add(PracCpoObj.Id);
    }
    
    
    List<FPAN_Associate_Survey_Question__c> ListOfAssSurveyQues = [Select Id,Name,FPAN_Practice_CPO_Objective__c,FPAN_Survey_Question__c From FPAN_Associate_Survey_Question__c Where FPAN_Practice_CPO_Objective__c IN: SetOfPracCPOObjId];
    
    System.debug('ListOfAssSurveyQues----->'+ListOfAssSurveyQues);
    System.debug('ListOfAssSurveyQues Size----->'+ListOfAssSurveyQues.Size());
    
    Set<Id> SetOfAssSurveyQues = New Set<Id>();
    for(FPAN_Associate_Survey_Question__c AssSurveyQues : ListOfAssSurveyQues){
        SetOfAssSurveyQues.add(AssSurveyQues.FPAN_Survey_Question__c);
    }
    
    System.debug('SetOfAssSurveyQues----->'+SetOfAssSurveyQues);
    System.debug('SetOfAssSurveyQues Size----->'+SetOfAssSurveyQues.Size());
        
    List<FPAN_Associate_Survey_CPO__c> listAssocSuvCpo =[SELECT FPAN_CPO__c ,FPAN_Survey__c FROM FPAN_Associate_Survey_CPO__c WHERE FPAN_CPO__c IN :CPOrecordIds];  
    
    Set<Id> SetAssocSuvId=New Set<Id>();
        for(FPAN_Associate_Survey_CPO__c assocSuvId : listAssocSuvCpo)  {
            SetAssocSuvId.add(assocSuvId.FPAN_Survey__c);
        }
        
        List<FPAN_Survey_Question__c> suvQuestionList=[SELECT Id,Name,FPAN_Survey__c,FPAN_Survey__r.FPAN_CPO_Type__c,FPAN_Objective_Definition__c,FPAN_Status__c 
                                                       FROM FPAN_Survey_Question__c WHERE Id NOT IN :SetOfAssSurveyQues AND FPAN_Survey__c IN :SetAssocSuvId AND FPAN_Status__c = 'Active'];
    
        System.debug('suvQuestionList--->'+suvQuestionList);
        System.debug('suvQuestionList size--->'+suvQuestionList.size());
        
    //List<FPAN_Survey_Question__c> ListOfSurveyQues = [Select Id,Name,FPAN_Survey__c,FPAN_Survey__r.FPAN_CPO_Type__c,FPAN_Objective_Definition__c,FPAN_Status__c From FPAN_Survey_Question__c Where ];
     
    If(ListOfPracCPOobj.Size()>0 && suvQuestionList.Size()>0){
        for( Practice_CPO_Objectives__c PCPOObjs : ListOfPracCPOobj){
            For(FPAN_Survey_Question__c SurveyQues: suvQuestionList){
                System.debug('###InsideFORQuestion###');
                    If(SurveyQues.FPAN_Survey__r.FPAN_CPO_Type__c == PCPOObjs.FPAN_Practice_CPO__r.FPAN_CPO_Type_Formula__c && SurveyQues.FPAN_Objective_Definition__c == PCPOObjs.FPAN_CPO_Objective__r.FPAN_Objective__c){
                    System.debug('###InsideIFQuestion###');
                    FPAN_Associate_Survey_Question__c ASQ = New FPAN_Associate_Survey_Question__c();
                    ASQ.FPAN_Practice_CPO_Objective__c = PCPOObjs.Id;
                    ASQ.FPAN_Survey_Question__c = SurveyQues.Id;
                    ASQ.Name = SurveyQues.Name;
                    InsertAssSurveyQues.add(ASQ);
                    }
                }       
            }
        }
        System.debug('InsertAssSurveyQues Size-->' +InsertAssSurveyQues);
        System.debug('InsertAssSurveyQues-->' +InsertAssSurveyQues.size());
        If(InsertAssSurveyQues.Size()>0){
            try{
                Insert InsertAssSurveyQues;
            }
            catch(Exception ex){
                 System.debug('The following exception has occurred: ' + ex.getMessage());
               //  FPAN_APEX_HandleSystemException.LogException(ex);
            }
           
        }     
    
        System.debug('InsertAssSurveyQues-->' +InsertAssSurveyQues.Size());
    return InsertAssSurveyQues.Size(); 
    }
}