/************************************************************************
* Name : FPAN_Apex_CredExtensionControllerTest
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : Test class for FPAN_Apex_GetQuestionAnswer
*************************************************************************/
@isTest
public class FPAN_Apex_GetQuestionAnswer_Test {
    private static testmethod void getAnswersTest()
    {
        FPAN_Survey__c su=new FPAN_Survey__c();
        su.FPAN_CPO_Type__c='Primary Care';
        su.Name='Survey Test';
        Insert su;
     
        FPAN_Objective__c fpanObj =new FPAN_Objective__c();
        fpanObj.Name='Objective Test';
        Insert fpanObj;
        
        System.Debug('fpanObj-->'+fpanObj);
        FPAN_Question__c fpanQues=new FPAN_Question__c();
        fpanQues.FPAN_Question_Name__c='Test question 1';
        fpanQues.FPAN_Question_Type__c='Single Select';
        fpanQues.FPAN_Mandatory__c=True;
        Insert fpanQues;
        
        FPAN_Answer_Option__c fpanAnsOpt2=new FPAN_Answer_Option__c();
        fpanAnsOpt2.FPAN_Answer_Option_Name__c='Option Test2';
        Insert fpanAnsOpt2;
        
        FPAN_Answer_Option__c fpanAnsOpt1=new FPAN_Answer_Option__c();
        fpanAnsOpt1.FPAN_Answer_Option_Name__c='Option Test1';
        Insert fpanAnsOpt1;
        
        FPAN_Question_Answer_Option__c fpanQuesAnsOpt = new FPAN_Question_Answer_Option__c();
        fpanQuesAnsOpt.FPAN_Answer_Option_Name__c='Option Test1';
        fpanQuesAnsOpt.FPAN_Question__c=fpanQues.Id;
        fpanQuesAnsOpt.FPAN_Answer_Option__c=fpanAnsOpt1.Id;
        fpanQuesAnsOpt.FPAN_Option_Number__c=1;
        Insert fpanQuesAnsOpt;
        
        FPAN_Question_Answer_Option__c fpanQuesAnsOpt1 = new FPAN_Question_Answer_Option__c();
        fpanQuesAnsOpt1.FPAN_Answer_Option_Name__c='Option Test2';
        fpanQuesAnsOpt1.FPAN_Question__c=fpanQues.Id;
        fpanQuesAnsOpt1.FPAN_Answer_Option__c=fpanAnsOpt2.Id;
        fpanQuesAnsOpt1.FPAN_Option_Number__c=1;
        Insert fpanQuesAnsOpt1;
        
        FPAN_Question__c fpanQues1=new FPAN_Question__c();
        fpanQues1.FPAN_Question_Name__c='Test question 2';
        fpanQues1.FPAN_Question_Type__c='Text';
        fpanQues1.FPAN_Mandatory__c=True;
        Insert fpanQues1;
        
        FPAN_Survey_Question__c fpanSuvQues=new FPAN_Survey_Question__c();
        fpanSuvQues.FPAN_Objective_Definition__c=fpanObj.Id;
        fpanSuvQues.FPAN_Question__c=fpanQues.Id;
        fpanSuvQues.FPAN_Survey__c=su.Id;
        fpanSuvQues.FPAN_Question_Name__c='Test question 1';
        fpanSuvQues.FPAN_Status__c='Active';
        Insert fpanSuvQues;
        
        FPAN_Survey_Question__c fpanSuvQues1=new FPAN_Survey_Question__c();
        fpanSuvQues1.FPAN_Objective_Definition__c=fpanObj.Id;
        fpanSuvQues1.FPAN_Question__c=fpanQues1.Id;
        fpanSuvQues1.FPAN_Survey__c=su.Id;
        fpanSuvQues1.FPAN_Question_Name__c='Test question 2';
        fpanSuvQues1.FPAN_Status__c='Active';
        Insert fpanSuvQues1;
        
        Set<Id> quesId =new Set<Id>();
        quesId.add(fpanQues.Id);
        quesId.add(fpanQues1.Id);
        
        List<FPAN_Question__c> lstQuesExpected = [SELECT Id, Name,FPAN_Question_Name__c, FPAN_Question_No__c,FPAN_Question_Type__c,
                                          FPAN_Mandatory__c,(SELECT Id ,Name,FPAN_Answer_Option_Name__c, FPAN_Answer_Option__c,
                                                             FPAN_Option_Number__c FROM Question_Answer_Options__r ORDER BY FPAN_Option_Number__c) 
                                          FROM FPAN_Question__c WHERE Id IN  :quesId] ;
      
        System.assertEquals(lstQuesExpected, FPAN_Apex_GetQuestionAnswer.getAnswers(su.Name));
    }
    
    private static testmethod void saveRecordTest(){
        
        Profile prof=[SELECT Id,Name From Profile Where Name = 'System Administrator'];
        Profile prof1=[SELECT Id,Name From Profile Where Name = 'FPAN Practice Community Plus Login User'];
        User thisUser=[Select Id From User Where Id = :UserInfo.getUserId()];
        User portalAccountOwner1 = new User();
        
        UserRole obj=new UserRole();
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        System.runAs(thisUser){
           
            obj.Name='ABC';
            //insert obj; 
            Database.insert(obj);
            portalAccountOwner1.UserRoleId = obj.Id;
            portalAccountOwner1.ProfileId =prof.Id ;
            portalAccountOwner1.Username = uniqueName + '@test' + orgId + '.org' ;
            portalAccountOwner1.Alias = 'sfdc';
            portalAccountOwner1.Email='ananitra.majumdar@itcinfotech.com';
            portalAccountOwner1.EmailEncodingKey='UTF-8';
            portalAccountOwner1.Firstname='Dhanik';
            portalAccountOwner1.Lastname='Sahni';
            portalAccountOwner1.LanguageLocaleKey='en_US';
            portalAccountOwner1.LocaleSidKey='en_US';
            portalAccountOwner1.TimeZoneSidKey='America/Chicago';
            
            Database.insert(portalAccountOwner1);
        }
        
        Id ProviderLocationRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        Account accObj = new Account();
        accObj = new Account (
            Name = 'FPAN',
            FPAN_First_Name__c = 'Test First Name',
            FPAN_Last_Name__c = 'Name', 
            RecordTypeId = ProviderLocationRecordType, //Provider Location
            FPAN_Practice_Speciality__c = 'Dermatology',
            Website = 'www.FairviewTest.Org',
            FPAN_Clinic_Fed_Id__c = '1234567890',
            FPAN_Practice_Status__c = 'Affiliate',
            FPAN_CPO_Type__c='Primary Care',
            OwnerId = portalAccountOwner1.id
        );

        INSERT accObj;
     
        Contact co=new Contact();
        co.FirstName ='TestFirst';
        co.LastName='TestLast';
        co.Email='ananitra.majumdar@itcinfotech.com';
        co.Phone='8910013063';
        co.AccountId=accObj.Id;
        
        Insert co;
        
        User user1 = new User();
        //'00e04000000YMOuAAO'
        System.runAs(thisUser){
            
            user1.UserName = uniqueName+'tes@gmail.com'+ System.now().millisecond();
            user1.FirstName = 'Portal User';
            user1.LastName = 'TestComm';
            user1.Alias = 'test123';
            user1.Email = 'test@gmail.com';
            user1.ContactId = co.Id;
            user1.ProfileId = prof1.Id;
            user1.EmailEncodingKey = 'UTF-8';
            user1.CommunityNickname = 'test12345';
            user1.TimeZoneSidKey = 'America/Los_Angeles';
            user1.LocaleSidKey = 'en_US';
            user1.LanguageLocaleKey = 'en_US';
            
            Database.insert(user1);
            
        }
        
        String user =user1.Id;
        
        FPAN_CPO__c cpo=new FPAN_CPO__c(
            Name='Cpo Test',
            FPAN_Year__c='2021'
        );
        insert cpo;
 
        FPAN_Practice_CPO__c pracCpo=new FPAN_Practice_CPO__c(
            Name='Practice CPO test',
            FPAN_Practice_Account__c=accObj.Id,
            FPAN_CPO__c=cpo.Id);
        Insert pracCpo;
   
        FPAN_Survey__c su=new FPAN_Survey__c();
        su.FPAN_CPO_Type__c='Primary Care';
        su.Name='Survey Test';
        Insert su;
     
        String suvId = su.Id;
        
        FPAN_Associate_Survey_Practice_CPO__c assocSuvPracCpo=new FPAN_Associate_Survey_Practice_CPO__c(
            Name='Associate Suv Cpo Test',
            FPAN_CPO_Type__c='Primary Care',
            FPAN_Practice_CPO__c=pracCpo.Id,
            FPAN_Survey__c=su.Id,
            FPAN_Agreement_Status__c='Not Started'
        );
        insert assocSuvPracCpo;
   
        FPAN_Question__c fpanQues=new FPAN_Question__c();
        fpanQues.FPAN_Question_Name__c='Test question 1';
        fpanQues.FPAN_Question_Type__c='Single Select';
        fpanQues.FPAN_Mandatory__c=True;
        Insert fpanQues;
        
        FPAN_Answer_Option__c fpanAnsOpt1=new FPAN_Answer_Option__c();
        fpanAnsOpt1.FPAN_Answer_Option_Name__c='Option Test1';
        Insert fpanAnsOpt1;
        
        FPAN_Question_Answer_Option__c fpanQuesAnsOpt = new FPAN_Question_Answer_Option__c();
        fpanQuesAnsOpt.FPAN_Answer_Option_Name__c='Option Test1';
        fpanQuesAnsOpt.FPAN_Question__c=fpanQues.Id;
        fpanQuesAnsOpt.FPAN_Answer_Option__c=fpanAnsOpt1.Id;
        fpanQuesAnsOpt.FPAN_Option_Number__c=1;
        Insert fpanQuesAnsOpt;
        
        FPAN_Question__c fpanQues1=new FPAN_Question__c();
        fpanQues1.FPAN_Question_Name__c='Test question 2';
        fpanQues1.FPAN_Question_Type__c='Text';
        fpanQues1.FPAN_Mandatory__c=True;
        Insert fpanQues1;
        
        FPAN_Question__c QuesMultiSelect=new FPAN_Question__c();
        QuesMultiSelect.FPAN_Question_Name__c='Multi Select question 1';
        QuesMultiSelect.FPAN_Question_Type__c='Multi Select';
        QuesMultiSelect.FPAN_Mandatory__c=True;
        Insert QuesMultiSelect;
        
        String multiSelectAns='Test';
        
        Map<Id ,String> checkMap=new Map<Id ,String>();
        checkMap.put(QuesMultiSelect.Id, multiSelectAns);
   
        Map<Id ,Id> options = new Map<Id ,Id>();
        options.put(fpanQues.Id , fpanQuesAnsOpt.Id);
   
        String providedAnswer='Justification-->Test';
        
        Map<Id ,String> otherOptions = new Map<Id ,String>();
        otherOptions.put(fpanQuesAnsOpt.Id,providedAnswer);
    
        String textAnswer='Test';
        
        Map<Id ,String> textQuesAns= new Map<Id ,String>();
        textQuesAns.put(fpanQues1.Id,textAnswer);
        
        String conernValue='Test';
        
        FPAN_Apex_GetQuestionAnswer.saveRecord(options,otherOptions,suvId,textQuesAns,checkMap,user,conernValue);
       
        List<FPAN_Associate_Survey_Practice_CPO__c> assocSuvPracExpected=[SELECT  FPAN_Survey__c , FPAN_Survey__r.Name 
                                                             FROM FPAN_Associate_Survey_Practice_CPO__c WHERE  
                                                             (FPAN_Agreement_Status__c ='Not Started' OR FPAN_Agreement_Status__c='In Progress' ) 
                                                             AND FPAN_Practice_CPO__r.FPAN_Practice_Account__c= :accObj.Id ];
        
        System.assertEquals(assocSuvPracExpected,FPAN_Apex_GetQuestionAnswer.getSurveyName(user));
    }
    
}