/************************************************************************************************************************
* Name : FPAN_Apex_GetQuestionAnswer
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : This class is developed to fetch question and answer for survey object , and also developed to save survey result record
*************************************************************************************************************************/
public without sharing class FPAN_Apex_GetQuestionAnswer {
    
    @AuraEnabled(cacheable=true)
    public static List<FPAN_Question__c> getAnswers(String surveyName)
    {
        String sName=surveyName;
        List<String> survey= new List<String>();
        Set<Id> sid =new Set<Id>();
        List<FPAN_Survey_Question__c> surveyQuestion =[SELECT  FPAN_Question__c  FROM FPAN_Survey_Question__c where FPAN_Survey__r.Name= :sName];
        for(FPAN_Survey_Question__c sq : surveyQuestion){
            sid.add(sq.FPAN_Question__c);
        }
        //system.debug('Set Id'+sid);
        List<FPAN_Question__c> lstQues = [SELECT Id, Name,FPAN_Question_Name__c, FPAN_Question_No__c,FPAN_Question_Type__c, FPAN_Mandatory__c,(SELECT Id ,Name,FPAN_Answer_Option_Name__c, FPAN_Answer_Option__c,FPAN_Option_Number__c FROM Question_Answer_Options__r ORDER BY FPAN_Option_Number__c) FROM FPAN_Question__c WHERE Id IN  :sid] ;
        return lstQues;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<FPAN_Associate_Survey_Practice_CPO__c> getSurveyName(String user){
        
        User userId=   [SELECT Id,ContactId FROM User WHERE Id= :user LIMIT 1];
        Contact accId=[SELECT AccountId, Id FROM Contact WHERE Id = :userId.ContactId LIMIT 1];
        List<FPAN_Associate_Survey_Practice_CPO__c> surName=[SELECT  FPAN_Survey__c , FPAN_Survey__r.Name 
                                                             FROM FPAN_Associate_Survey_Practice_CPO__c WHERE  (FPAN_Agreement_Status__c ='Not Started' OR FPAN_Agreement_Status__c='In Progress' ) AND FPAN_Practice_CPO__r.FPAN_Practice_Account__c=:accId.AccountId ];
        
        return surName;
    }
    
    @AuraEnabled
    public static List<ID> saveRecord(Map<Id ,Id> options ,Map<Id , String> otherOptions, String suvId ,Map<Id ,String> textQuesAns,Map<Id ,String> checkMap, String user, String conernValue){
        
        
        User userId=   [SELECT Id,ContactId FROM User WHERE Id= :user LIMIT 1];
        Contact accId=[SELECT AccountId, Id FROM Contact WHERE Id = :userId.ContactId LIMIT 1];
        
        LIST<FPAN_Associate_Survey_Practice_CPO__c> pracCpoList=[select id,FPAN_Survey__c, FPAN_Practice_AccountId__c,FPAN_Practice_CPO__c  from FPAN_Associate_Survey_Practice_CPO__c 
                                                                 where FPAN_Survey__c = :suvId];
        
        ID practiceCPOId;
        List<FPAN_Survey_Results__c> suList = new List<FPAN_Survey_Results__c>();
        for(FPAN_Associate_Survey_Practice_CPO__c pracCpo: pracCpoList){
            if(pracCpo.FPAN_Practice_AccountId__c == accId.AccountId){
                
                FPAN_Survey_Results__c su = new FPAN_Survey_Results__c();
                su.FPAN_Comments__c=conernValue;
                su.FPAN_Survey__c=pracCpo.FPAN_Survey__c;
                su.FPAN_Practice_Account__c=pracCpo.FPAN_Practice_AccountId__c; 
                su.FPAN_Practice_CPO__c=pracCpo.FPAN_Practice_CPO__c; 
                su.FPAN_Agreement_Status__c = 'Completed';                
                suList.add(su);
                
                practiceCPOId = pracCpo.FPAN_Practice_CPO__c;
            }
        }
        
        try{
            
            insert suList;
            
        }catch(Exception e){
            
            FPAN_APEX_HandleSystemException.LogException(e);
            
        }
        
        Set<ID> SUIDs = new Set<ID>();
        for(FPAN_Survey_Results__c surec: suList){
            SUIDs.add(surec.id);
            
        }
        
        List<ID> suvIdList=new List<ID>();
        suvIdList.addAll(SUIDs);
        
        FPAN_Associate_Survey_Practice_CPO__c assocSurveyPracCpo=[SELECT Id, FPAN_Agreement_Status__c, 	FPAN_Practice_CPO__c,FPAN_Survey__c FROM FPAN_Associate_Survey_Practice_CPO__c WHERE 
                                                                  FPAN_Survey__c = :suvId  AND FPAN_Practice_CPO__c =:practiceCPOId LIMIT 1];
        assocSurveyPracCpo.FPAN_Agreement_Status__c='Completed';
        update assocSurveyPracCpo;
        
        Id srId = [Select id from FPAN_Survey_Results__c where id IN :SUIDs limit 1].id;
        
        List<String> mapvaluesRadio=new List<String>();
        mapvaluesRadio=options.values();
        List<FPAN_Question_Answer_Option__c> qaos= [SELECT Id,Name, FPAN_Answer_Option__c,FPAN_Question__c FROM FPAN_Question_Answer_Option__c where Id IN :mapvaluesRadio];
        List<FPAN_QuestionAnswerResults__c> bulkQNSinsert = new List<FPAN_QuestionAnswerResults__c>();
        for(FPAN_Question_Answer_Option__c qao : qaos){
            FPAN_QuestionAnswerResults__c qns = new FPAN_QuestionAnswerResults__c();
            qns.Question__c = qao.FPAN_Question__c;           
            System.debug('other option value '+otherOptions.get(qao.Id));
            qns.FPAN_Provided_Answer__c = otherOptions.get(qao.Id);
            qns.FPAN_Survey_User__c = srId;         
            bulkQNSinsert.add(qns);
        }
        
        
        try{
            
            insert bulkQNSinsert;
            
        }catch(Exception e){
            
            FPAN_APEX_HandleSystemException.LogException(e);
            
        }
        
        List<FPAN_QuestionAnswerResults__c> bulkQNATextInsert = new List<FPAN_QuestionAnswerResults__c>();
        for (Id quesId : textQuesAns.keySet() ) {
            
            
            FPAN_QuestionAnswerResults__c qar = new FPAN_QuestionAnswerResults__c();
            qar.Question__c = quesId;
            
            qar.FPAN_Provided_Answer__c=textQuesAns.get(quesId);//answer option id
            
            qar.FPAN_Survey_User__c = srId;
            bulkQNATextInsert.add(qar);
            
            
        }
        
        try{
            
            insert bulkQNATextInsert;
            
        }catch(Exception e){
            
            FPAN_APEX_HandleSystemException.LogException(e);
            
        }
        
        
        if(checkMap.size()>0)
        {
            Set<Id> mapCheckBoxOptionId=new Set<Id>();
            mapCheckBoxOptionId=checkMap.keySet();
            Id questId;
            for(Id quesId : mapCheckBoxOptionId){
                questId = quesId;
            }
            
            List<FPAN_QuestionAnswerResults__c> bulkCheckBoxValueInsert = new List<FPAN_QuestionAnswerResults__c>();
            
            FPAN_QuestionAnswerResults__c qans = new FPAN_QuestionAnswerResults__c();
            qans.Question__c= questId;
            
            
            qans.FPAN_Provided_Answer__c=checkMap.get(questId);
            qans.FPAN_Survey_User__c=srId;
            bulkCheckBoxValueInsert.add(qans);
            
            
            try{
                
                insert bulkCheckBoxValueInsert;
                
            }catch(Exception e){
                
                FPAN_APEX_HandleSystemException.LogException(e);
                
            }
            
        }
        
        
        sendEmailToFpanAgent(SUIDs,user);
        
        return suvIdList;
        
    } 
    
    public static void sendEmailToFpanAgent(Set<ID> SUIDs, string user)
    {
        
        User userId=   [SELECT Id,ContactId,Name FROM User WHERE Id= :user LIMIT 1];
        String userName = userId.Name;
        
        Contact accId=[SELECT AccountId, Id, Email FROM Contact WHERE Id = :userId.ContactId LIMIT 1];
        String sendToEmail= accId.Email;
        Id recordId = accId.AccountId;
        
        Account accRec = [SELECT Name, Parent.Name FROM Account WHERE Id =:accId.AccountId];
        
        List<FPAN_QuestionAnswerResults__c> qaList =[SELECT Id, FPAN_Provided_Answer__c, Question__r.Name, Question__r.FPAN_Question_Name__c, FPAN_Survey_User__c 
                                                     FROM FPAN_QuestionAnswerResults__c WHERE FPAN_Survey_User__c IN :SUIDs AND Question__c!= NULL];
        
        Map<String, String> qaMap = new Map<String, String>();
        
        String subject = 'Justification';
        String surveyAnswerJustification='';
        if(qaList.size() > 0)
        {
            for(FPAN_QuestionAnswerResults__c qares : qaList)
                
            {
                if(qares.FPAN_Provided_Answer__c.contains('Justification-->')){
                    qaMap.put(qares.Question__r.FPAN_Question_Name__c,qares.FPAN_Provided_Answer__c);
                }
            }
            
            for(String qaKey : qaMap.keySet()){
                surveyAnswerJustification=surveyAnswerJustification+qaKey+':'+qaMap.get(qaKey)+'<br/><br/>';
            }
            if(surveyAnswerJustification != ''){
            string accountContent=surveyAnswerJustification+'Business Admin: '+ userName +'<br/><br/>'+
                'Account Name: '+accRec.Name+'<br/><br/>';
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            mail.setToAddresses(getMailAddresses());
            mail.setSubject(subject);
            mail.setHtmlBody(accountContent);
            
            mails.add(mail);
            
            Messaging.sendEmail(mails);
            }
            
        }
        sendEmailToPortalUser(user);
        
    }
    
    public static void sendEmailToPortalUser(String user)
        
    {
        User userPracId=[SELECT Id,ContactId,Name FROM User WHERE Id= :user LIMIT 1];
        
        Contact accountPracId=[SELECT AccountId, Id, Email FROM Contact WHERE Id = :userPracId.ContactId LIMIT 1];
        String sendToEmail2= accountPracId.Email;
        //String sendToEmail2='Anamitra.Majumdar@itcinfotech.com';
        
        List<String> mailToAddresses2 = new List<String>(); 
        
        mailToAddresses2.add(sendToEmail2);
        String contentEmail2 = 'Thank you for submitting your FPA Network CPO';
        String subject2 = 'Generated Cpo agreement';
        List<Messaging.SingleEmailMessage> mails2 = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
        
        mail2.setToAddresses(mailToAddresses2);
        mail2.setSubject(subject2);
        mail2.setHtmlBody(contentEmail2);
        
        mails2.add(mail2);
        
        Messaging.sendEmail(mails2);
    }
    
    
    //Get Email Addresses
    public static List<String> getMailAddresses(){
        List<String> idList = new List<String>();
        List<String> mailToAddresses = new List<String>(); 
        
        Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name = : System.Label.FPAN_EmailGroup ];
        for (GroupMember gm : gp.GroupMembers) {
            idList.add(gm.UserOrGroupId);
        }
        List<User> userList = [SELECT Email FROM User WHERE Id IN :idList];
        for(User u : userList) {
            mailToAddresses.add(u.email);
        } 
        return mailToAddresses;
    }
    
}