/**************************************************************************************************
* Name : FPAN_Apex_Notification
* Author : Anamitra Majumdar
* Date : 29/Nov/2022
* Desc : This a test class of FPAN_Apex_Notification AND FPAN_Apex_EmailNotificationScheduler
****************************************************************************************************/

@isTest
public class FPAN_Apex_NotificationTest {
    
    public static testMethod void setupData(){
        // Setup test data
        // Create a unique UserName
        String uniqueUserName = 'FPANIntegration' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='FPAN Integration'];
        User u = new User(Alias = 'standt', Email='FpanIntegration@testorg.com',
        EmailEncodingKey='UTF-8', LastName='FPAN Integration', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName); 
		Insert u;
        User UserDetails = [SELECT id,name,firstname, profile.name from user where id=:u.id];
        System.debug('User Details-->'+UserDetails); 
       System.runAs(u) {
              system.debug('u-->'+u);
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
      
        Id accId = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        Id provFacId=FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.Provider_Facility_NAME_LABEL ,accId,AccIdPractice);
        Id provFacId2=FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.Provider_Facility_NAME_LABEL ,NULL,AccIdPractice);    
        System.debug('accId-->'+accId);
        System.debug('AccIdPractice-->'+AccIdPractice);
        System.debug('provFacId-->'+provFacId);
       
        Test.startTest();
        FPAN_Apex_EmailNotificationScheduler testsche = new FPAN_Apex_EmailNotificationScheduler();
        String sch = '0 0 23 * * ?';
       
        system.schedule('Email Scheduler',sch, testsche);
        Test.stopTest();
        }
    }
    }