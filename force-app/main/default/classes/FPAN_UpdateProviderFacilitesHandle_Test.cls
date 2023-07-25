/************************************************************************
* Name :FPAN_UpdateProviderFacilitesHandle_Test
* Author : Abhijeet Nagnath Ghodke
* Date : 04/03/2023
* Desc : This is the Test class for FPAN_UpdateProviderFacilitesHandler
*************************************************************************/
@isTest
public class FPAN_UpdateProviderFacilitesHandle_Test {
    public static testMethod void updateProviderFacility(){
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
        Update u;
        User UserDetails = [SELECT id,name,firstname, profile.name from user where id=:u.id];
       
        Id provFacId;
       System.runAs(u) {
           
      
        Id accId = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        provFacId=FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.Provider_Facility_NAME_LABEL ,accId,AccIdPractice);
        Id provFacId2=FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.Provider_Facility_NAME_LABEL ,NULL,AccIdPractice);    
        List<HealthcarePractitionerFacility> PFList =[Select id,OwnerId,FPAN_Facility_Sibling_Id__c from HealthcarePractitionerFacility where Id = :provFacId];
         System.assertEquals(1, PFList.size());
     

        }
        
    }
}