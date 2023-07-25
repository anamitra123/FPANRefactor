/************************************************************************
* Name : FPAN_Apex_CredExtensionControllerTest
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : Test class for FPAN_Apex_FileUploaderClass,Fpan_Trigger_ChangeVisibilty
*************************************************************************/
@isTest
public class FPAN_Apex_FileUploaderClassTest {
    private static testmethod void uploadFileTest(){
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
        String user =user1.Id;
        
        FPAN_CPO__c cpo=new FPAN_CPO__c(
            Name='Cpo Test',
            FPAN_Year__c='2021'
        );
        insert cpo;
        System.Debug('cpo Id-->'+cpo.Id);
        
        FPAN_Practice_CPO__c pracCpo=new FPAN_Practice_CPO__c(
            Name='Practice CPO test',
            FPAN_Practice_Account__c=accObj.Id,
            FPAN_CPO__c=cpo.Id);
        Insert pracCpo;
        System.debug('pracCpo Id-->'+pracCpo.Id);
        
        FPAN_Survey__c su=new FPAN_Survey__c();
        su.FPAN_CPO_Type__c='Primary Care';
        su.Name='Survey Test';
        Insert su;
        System.debug('su Id-->'+su.Id);
        
        String suvId = su.Id;
        String surveyName=su.Name;
        FPAN_Associate_Survey_Practice_CPO__c assocSuvPracCpo=new FPAN_Associate_Survey_Practice_CPO__c(
            Name='Associate Suv Cpo Test',
            FPAN_CPO_Type__c='Primary Care',
            FPAN_Practice_CPO__c=pracCpo.Id,
            FPAN_Survey__c=su.Id,
            FPAN_Agreement_Status__c='Not Started'
        );
        insert assocSuvPracCpo;
        System.debug('assocSuvPracCpo Id-->'+assocSuvPracCpo.Id);
        
        blob file=  Blob.valueOf('sample text');
        String cdlId=FPAN_Apex_FileUploaderClass.uploadFile(file.toString(),'testAttachment',user,surveyName);
        
        ContentDocumentLink cdl=[Select ContentDocumentId from ContentDocumentLink where Id=:cdlId];
        Id contentId = cdl.ContentDocumentId;
        ContentVersion cvName=[Select Title from ContentVersion where ContentDocumentId =:contentId];
        System.assertEquals('testAttachment', cvName.Title);
        
    }
}