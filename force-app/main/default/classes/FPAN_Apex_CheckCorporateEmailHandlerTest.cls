/************************************************************************
* Name : FPAN_Apex_CheckCorporateEmailHandlerTest
* Author : Masud Ahmed
* Date : 13/04/2023
* Desc : This is the test class of FPAN_Apex_CheckCorporateEmailHandler and trigger FPAN_Trigger_CheckCorporateEmailDup
*************************************************************************/


@isTest
public class FPAN_Apex_CheckCorporateEmailHandlerTest {
    private static testmethod void testCheckEmailUpdate(){
        Id Rt = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        
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
        co.RecordTypeId = rt;
        
        try{
            Insert co;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Provided Corporate email is already existing with the one of the users. Please provide different email id. Thanks') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        
        
        User user1 = new User();
        //'00e04000000YMOuAAO'
        System.runAs(thisUser){
            
            user1.UserName = uniqueName+'tes@gmail.com'+ System.now().millisecond();
            user1.FirstName = 'Portal User';
            user1.LastName = 'TestComm';
            user1.Alias = 'test123';
            user1.Email = 'ananitra.majumdar@itcinfotech.com';
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
        
        Contact co2=new Contact();
        co2.FirstName ='TestFirst';
        co2.LastName='TestLast';
        co2.Email='ananitra.majumdar@itcinfotech.com';
        co2.Phone='8910013063';
        co2.AccountId=accObj.Id;
        co2.RecordTypeId = rt;
        
        try{
            Insert co2;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Provided Corporate email is already existing with the one of the users. Please provide different email id. Thanks') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        
        Contact co3=new Contact();
        co3.FirstName ='TestFirst';
        co3.LastName='TestLast';
        co3.Email='test123@itcinfotech.com';
        co3.Phone='8910013063';
        co3.AccountId=accObj.Id;
        co3.RecordTypeId = rt;
        
        try{
            Insert co3;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Provided Corporate email is already existing with the one of the users. Please provide different email id. Thanks') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        
        co3.Email='ananitra.majumdar@itcinfotech.com';
        
        try{
            Update co3;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Provided Corporate email is already existing with the one of the users. Please provide different email id. Thanks') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        
        
    }
    
    
    
}