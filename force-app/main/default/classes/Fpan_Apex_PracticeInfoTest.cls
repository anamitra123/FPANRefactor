/*****************************************************************************************************************
* Name : Fpan_Apex_PracticeInfoTest
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This the test class of Fpan_Apex_PracticeInfo main class
********************************************************************************************************************/
@isTest
public class Fpan_Apex_PracticeInfoTest {
    private static testmethod void getPracticeAccountDetailsTest(){
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
        
            List<Account> accRecord = [SELECT Name FROM Account WHERE Id =:accObj.Id];
            
            String user=user1.Id;
            System.assertEquals(accRecord,Fpan_Apex_PracticeInfo.getPracticeAccountDetails(user));
            List<User> userName=   [SELECT Id,Name FROM User WHERE Id= :user1.Id ];
            System.assertEquals(userName,Fpan_Apex_PracticeInfo.getUserName(user));
        }
        

    }

}