/************************************************************************
* Name : FPAN_Apex_GetSurveyAnswerTest
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This is the test class of FPAN_Apex_GetSurveyAnswer main class
*************************************************************************/
@isTest
public class FPAN_Apex_GetSurveyAnswerTest {
    private static testmethod void getSurveyAnswersTest(){
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
            //'00E04000000YqsPEAS'
            //'00e4x000002IbWXAA0'
            
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
        System.debug('accObj-->'+accObj);
        
        INSERT accObj;
        System.debug('accObj Id-->'+accObj.Id);
        
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
            System.Debug('user1 id-->'+user1.Id);
        }
        
        User testUser=[Select Id From User Where Id = :user1.Id];
        String user=user1.Id;
        FPAN_Survey_Results__c sresult=new FPAN_Survey_Results__c();
        System.runAs(testUser){
            
            sresult.FPAN_Comments__c='Test';
            insert sresult;
        }
        
        FPAN_Question__c fpanQues1=new FPAN_Question__c();
        fpanQues1.FPAN_Question_Name__c='Test question 2';
        fpanQues1.FPAN_Question_Type__c='Text';
        fpanQues1.FPAN_Mandatory__c=True;
        Insert fpanQues1;
        
        FPAN_QuestionAnswerResults__c qar=new FPAN_QuestionAnswerResults__c();
        qar.FPAN_Survey_User__c= sresult.Id;
        qar.FPAN_Provided_Answer__c='test';
        qar.Question__c=fpanQues1.Id;
        
        Insert qar;
        List<FPAN_QuestionAnswerResults__c> qaRes = [SELECT Id, FPAN_Provided_Answer__c, Question__r.Name,Question__r.FPAN_Question_Name__c, 
                                                     FPAN_Survey_User__c FROM FPAN_QuestionAnswerResults__c WHERE Id = :qar.Id];
        Map<String, String> qaMap = new Map<String, String>();
        
        for(FPAN_QuestionAnswerResults__c qans : qaRes){
            qaMap.put(qans.Question__r.FPAN_Question_Name__c,qans.FPAN_Provided_Answer__c);
        }
        System.assertEquals(qaMap,FPAN_Apex_GetSurveyAnswer.getSurveyAnswers(user));
        System.assertEquals('Test',FPAN_Apex_GetSurveyAnswer.getSurveyConern(user));
        
        List<FPAN_Survey_Results__c> suvResult=[SELECT Id, Name,FPAN_Comments__c FROM FPAN_Survey_Results__c WHERE Id =:sresult.Id];
        System.assertEquals(suvResult,FPAN_Apex_GetSurveyAnswer.getSurveyDetails(user));
    }
}