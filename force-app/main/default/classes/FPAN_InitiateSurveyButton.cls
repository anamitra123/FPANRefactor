/************************************************************************
* Name : FPAN_InitiateSurveyButton
* Author : Ravi Kumar
* Date : 18/Aug/2022
* Desc : Apex class for FPAN_InitiateSurveyButton    
*************************************************************************/
Public class FPAN_InitiateSurveyButton{
    
    @AuraEnabled()
    public static list<FPAN_CPO_Objective__c> getCpoObjRec(String recordId)
    {
        return [Select id,FPAN_CPO__c from FPAN_CPO_Objective__c where FPAN_CPO__c =: recordId];
        
    }
    
    @AuraEnabled()
    public static list<FPAN_Survey__c> getSurveyRec(String recordId)
    {
        return [Select id,FPAN_CPO__c from FPAN_Survey__c where FPAN_CPO__c =: recordId];
        
    }
    
    @AuraEnabled()
    public static list<FPAN_Associate_Survey_CPO__c> getAssSurveyCPORec(String recordId)
    {
        return [Select id,FPAN_CPO__c from FPAN_Associate_Survey_CPO__c where FPAN_CPO__c =: recordId];
        
    }

    @AuraEnabled()
    public static list<FPAN_CPO_Objective__c> getCPOObjRecs(String recordId)
    {
        return [Select id,FPAN_CPO__c from FPAN_CPO_Objective__c where FPAN_CPO__c =: recordId];
        
    }
    @AuraEnabled()
    //Public static void InitiateSurvey(Id CPOrecordId){
    Public static Integer InitiateSurvey(Id CPOrecordId){
        Integer returnSize;
         Integer assocNewQuestions;
        List<Id> CPOrecordIds = new List<Id>();  
        CPOrecordIds.add(CPOrecordId);
        
        List<FPAN_CPO__c> ListCPO = [Select Id,Name,FPAN_Year__c From FPAN_CPO__c where Id IN: CPOrecordIds];
        System.debug('ListCPO-->' +ListCPO.size());
        
        List<FPAN_CPO_Objective__c> ListCPOObj = [Select Id,Name,FPAN_CPO__c,FPAN_Objective_Type__c From FPAN_CPO_Objective__c where FPAN_CPO__c IN: CPOrecordIds];
        System.debug('ListCPOObj-->' +ListCPOObj.size());
        
        List<FPAN_Practice_CPO__c> ListPracCPOobj = [Select Id,Name,FPAN_CPO__c,FPAN_Practice_Account__c,FPAN_CPO_Type__c From FPAN_Practice_CPO__c where FPAN_CPO__c IN: CPOrecordIds];
        Set<Id> AccId = New Set<Id>();
        Set<Id> PracCPOId = New Set<Id>();
        If(ListPracCPOobj.size()>0){
            for(FPAN_Practice_CPO__c PracCPo : ListPracCPOobj){
                    AccId.add(PracCPo.FPAN_Practice_Account__c);
                    PracCPOId.add(PracCPo.Id);
            
            }
        }
        
        Set<Id> PracCPOId2 = New Set<Id>();
        
        List<Practice_CPO_Objectives__c> PracCPOObjList = [Select Id,Name,FPAN_Practice_CPO__c From Practice_CPO_Objectives__c where FPAN_Practice_CPO__c IN: PracCPOId];
        System.debug('PracCPOId-->' +PracCPOId.size());
        for(Practice_CPO_Objectives__c PCpoObj : PracCPOObjList){
            PracCPOId2.add(PCpoObj.FPAN_Practice_CPO__c);
        }
        
        System.debug('PracCPOId2-->' +PracCPOId2.size()); // 3 rec
        
        List<FPAN_Practice_CPO__c> ListPracCPOobj2 = [Select Id,Name,FPAN_CPO__c,FPAN_Practice_Account__c,FPAN_CPO_Type_Formula__c From FPAN_Practice_CPO__c where Id IN: PracCPOId2];
        System.debug('ListPracCPOobj2-->' +ListPracCPOobj2.size());
        
        Set<FPAN_Practice_CPO__c> SetOfPracCPO = New Set<FPAN_Practice_CPO__c>();
        Set<Id> SetOfPracCPOId = New Set<Id>();
        for(FPAN_Practice_CPO__c PracticeCPO: ListPracCPOobj2){
            SetOfPracCPO.add(PracticeCPO);
            SetOfPracCPOId.add(PracticeCPO.Id);
        }
        System.debug('SetOfPracCPO-->' +SetOfPracCPO.size());
        System.debug('SetOfPracCPOId-->' +SetOfPracCPOId.size());
        
        List<FPAN_Associate_Survey_CPO__c> AssSurveyCPOId = [Select Id,Name,FPAN_CPO__c,FPAN_Survey__c,FPAN_Survey__r.FPAN_CPO_Type__c From FPAN_Associate_Survey_CPO__c Where FPAN_CPO__c IN: CPOrecordIds];
        System.debug('AssSurveyCPOId-->' +AssSurveyCPOId.size());
        Set<Id> ASOId = New Set<Id>();
        for(FPAN_Associate_Survey_CPO__c ASO : AssSurveyCPOId){
                ASOId.add(ASO.Id);
        }
        System.debug('ASOId-->' +ASOId.size());
        
        List<FPAN_Associate_Survey_Practice_CPO__c> ListAssoSurvey = [Select Id,FPAN_Practice_CPO__c,FPAN_Survey__c,FPAN_CPO_Type__c,FPAN_Associate_Survey_CPO__c From FPAN_Associate_Survey_Practice_CPO__c where FPAN_Practice_CPO__c IN: SetOfPracCPOId];
        System.debug('ListAssoSurvey-->' +ListAssoSurvey.size());
        
        Set<Id> SurveyId = New Set<Id>();
        Set<Id> PracCPOIdSet = New Set<Id>();
        If(ListAssoSurvey.size()>0){
            for(FPAN_Associate_Survey_Practice_CPO__c PracCPoSurvey : ListAssoSurvey){
                    SurveyId.add(PracCPoSurvey.FPAN_Survey__c);
                    PracCPOIdSet.add(PracCPoSurvey.FPAN_Practice_CPO__c);
            
            }
        }
            
        /*
        List<FPAN_Survey__c> ListSurvey = [Select Id,Name,FPAN_CPO_Type__c From FPAN_Survey__c Where FPAN_CPO__c IN: CPOrecordIds AND ID NOT IN: SurveyId];
        Set<Id> SurveyId2 = New Set<Id>();
        for( FPAN_Survey__c surveys: ListSurvey){
            SurveyId2.add(surveys.Id);
        }
        */
        //List<FPAN_Associate_Survey_CPO__c> ListAssSurveyCPO = [Select Id,Name,FPAN_CPO__c,FPAN_Survey__c,FPAN_Survey__r.FPAN_CPO_Type__c From FPAN_Associate_Survey_CPO__c Where FPAN_CPO__c IN: CPOrecordIds AND FPAN_Survey__c  NOT IN: SurveyId];
        
        System.debug('CPOrecordIds-->' +CPOrecordIds.size());
        List<FPAN_Associate_Survey_CPO__c> ListAssSurveyCPO = [Select Id,Name,FPAN_CPO__c,FPAN_Survey__c,FPAN_Survey__r.FPAN_CPO_Type__c From FPAN_Associate_Survey_CPO__c Where FPAN_CPO__c IN: CPOrecordIds];
        System.debug('ListAssSurveyCPO-->' +ListAssSurveyCPO.size());
        
        Set<Id> SurveyId3 = New Set<Id>();
        for( FPAN_Associate_Survey_CPO__c surveyIds: ListAssSurveyCPO){
            SurveyId3.add(surveyIds.FPAN_Survey__c);
        }
        List<Practice_CPO_Objectives__c> FINALPracCPOObjLists = New List<Practice_CPO_Objectives__c>();
        If(ListAssoSurvey.size()>0){
            List<Practice_CPO_Objectives__c> FINALPracCPOObjList = [Select Id,Name,FPAN_Practice_CPO__c From Practice_CPO_Objectives__c where FPAN_Practice_CPO__c NOT IN: PracCPOIdSet];
                For(Practice_CPO_Objectives__c PCPOOBJ1 : FINALPracCPOObjList){
                    FINALPracCPOObjLists.add(PCPOOBJ1);
                }
            System.debug('Inside IF-->');
            System.debug('FINALPracCPOObjList-->' +FINALPracCPOObjList.size());
            System.debug('PracCPOIdSet-->' +PracCPOIdSet.size());
            
        }
        else{
        
            List<Practice_CPO_Objectives__c> FINALPracCPOObjList = [Select Id,Name,FPAN_Practice_CPO__c From Practice_CPO_Objectives__c where FPAN_Practice_CPO__c IN: SetOfPracCPO];
            For(Practice_CPO_Objectives__c PCPOOBJ2 : FINALPracCPOObjList){
                    FINALPracCPOObjLists.add(PCPOOBJ2);
                }
            System.debug('Inside ELSE-->');
        }
        Set<Id> PracCPOIdFINAL = New Set<Id>();
        for(Practice_CPO_Objectives__c PCpoObjId : FINALPracCPOObjLists){
            PracCPOIdFINAL.add(PCpoObjId.FPAN_Practice_CPO__c);
        }
        System.debug('FINALPracCPOObjLists-->' +FINALPracCPOObjLists.size());
        List<FPAN_Practice_CPO__c> FINALListPracCPOobj = [Select Id,Name,FPAN_CPO__c,FPAN_Practice_Account__c,FPAN_CPO_Type_Formula__c From FPAN_Practice_CPO__c where Id IN: PracCPOIdFINAL AND FPAN_CPO__c IN: CPOrecordIds];
        System.debug('FINALListPracCPOobj-->' +FINALListPracCPOobj.size());

        List<FPAN_Associate_Survey_Practice_CPO__c> InsertPracticeCPoSurvey = New List<FPAN_Associate_Survey_Practice_CPO__c>();

            If(PracCPOObjList.size()>0){
            System.debug('PracCPOObjList-->' +PracCPOObjList.size());
            For(FPAN_Practice_CPO__c PracCpo : FINALListPracCPOobj){
            System.debug('ListPracCPOobj-->' +ListPracCPOobj.size());
            //System.debug('ListPracCPOobj2-->' +ListPracCPOobj2.size());
            
                For(FPAN_Associate_Survey_CPO__c Survey : ListAssSurveyCPO){
                System.debug('PracCpo.FPAN_CPO_Type_Formula__c-->' +PracCpo.FPAN_CPO_Type_Formula__c);
                System.debug('Survey.FPAN_Survey__r.FPAN_CPO_Type__c-->' +Survey.FPAN_Survey__r.FPAN_CPO_Type__c);
                    If(Survey.FPAN_Survey__r.FPAN_CPO_Type__c == PracCpo.FPAN_CPO_Type_Formula__c){
                    System.debug('@@@InsideIf@@@');
                        FPAN_Associate_Survey_Practice_CPO__c PraCPOSurvey = New FPAN_Associate_Survey_Practice_CPO__c();
                        PraCPOSurvey.FPAN_Practice_CPO__c = PracCpo.Id;
                        PraCPOSurvey.FPAN_Associate_Survey_CPO__c = Survey.Id;
                        PraCPOSurvey.FPAN_Survey__c = Survey.FPAN_Survey__c;
                        PraCPOSurvey.Name = PracCpo.Name+'-'+Survey.Name;
                        PraCPOSurvey.FPAN_CPO_Type__c = Survey.FPAN_Survey__r.FPAN_CPO_Type__c;                 
                        InsertPracticeCPoSurvey.add(PraCPOSurvey);
                    }
                }
           }             
        }        
        
        If(InsertPracticeCPoSurvey.Size()>0){
            try{
                Insert InsertPracticeCPoSurvey;             
            }
            catch(Exception ex){
                 System.debug('The following exception has occurred: ' + ex.getMessage());
               //  FPAN_APEX_HandleSystemException.LogException(ex);
            }
            
        }
        
        
        // Insert Associate Survey Question //SetOfPracCPO
        If(SurveyId3.Size()>0 && InsertPracticeCPoSurvey.Size()>0)
		{
        List<FPAN_Survey_Question__c> ListOfSurveyQues = [Select Id,Name,FPAN_Survey__c,FPAN_Survey__r.FPAN_CPO_Type__c,FPAN_Objective_Definition__c,FPAN_Status__c From FPAN_Survey_Question__c Where FPAN_Survey__c =: SurveyId3 AND FPAN_Status__c = 'Active'];
        System.debug('ListOfSurveyQues-->' +ListOfSurveyQues.size());
        
        List<Practice_CPO_Objectives__c> ListOfPracCPOObj = [Select Id,Name,FPAN_Practice_CPO__c,FPAN_Practice_CPO__r.FPAN_CPO_Type_Formula__c,FPAN_CPO_Objective__c,FPAN_CPO_Objective__r.FPAN_Objective__c From Practice_CPO_Objectives__c where FPAN_Practice_CPO__c IN: PracCPOIdFINAL];
        System.debug('PracCPOIdFINAL-->' +PracCPOIdFINAL.size());
        System.debug('ListOfPracCPOObj-->' +ListOfPracCPOObj.size());
        
        List<FPAN_Associate_Survey_Question__c> InsertAssSurveyQues = New List<FPAN_Associate_Survey_Question__c>();
        If(ListOfPracCPOObj.Size()>0 && ListOfSurveyQues.Size()>0){
        for( Practice_CPO_Objectives__c PCPOObjs : ListOfPracCPOObj){
            For(FPAN_Survey_Question__c SurveyQues: ListOfSurveyQues){
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
       
       }
	   
	   else{
               assocNewQuestions=FPAN_AssociatingNewQuestions.newQuestionAssocation(PracCPOId2,CPOrecordIds);
              System.debug('assocNewQuestions---->' +assocNewQuestions);
            }
       System.debug('InsertPracticeCPoSurvey-->' +InsertPracticeCPoSurvey.size());
       IF(InsertPracticeCPoSurvey.Size()>0){
         returnSize=InsertPracticeCPoSurvey.Size();
        return returnSize;   
       }
       else {
          returnSize= assocNewQuestions;
           System.debug('assocNewQuestions---->' +assocNewQuestions);
           return returnSize;
       }
    }
}