/*****************************************************************************************************************
* Name : FPAN_Trigger_EventMtingNotificationTest
* Author : Anamitra Majumdar
* Date : 08/06/2023
* Desc : This a test class of FPAN_Trigger_EventMeetingNotification trigger and FPAN_Apex_EvtMeetingNotificationHandler
********************************************************************************************************************/
@isTest
public class FPAN_Trigger_EventMtingNotificationTest {
    private static testmethod void testEventMeeting(){
    
    Id AccId = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
    Id ConId = FPAN_TestDataUtility_Test.CreateContactRec(AccId);
    
    Id LeadId = FPAN_TestDataUtility_Test.CreateLeadRec(FPAN_TestDataUtility_Test.Name_Label);
    
    Id EveId = FPAN_TestDataUtility_Test.CreateEventRec(AccId,ConId);
    
    Id EveId2 = FPAN_TestDataUtility_Test.CreateEventRecInLead(LeadId);
        
    
        Contact Con = [SELECT Id,LastName,FirstName,AccountId,Email from Contact where Id =: ConId limit 1];
        System.assertEquals('fpan.test@gmail.com', Con.Email);
               
        Event Eve_Con = [SELECT Id,Subject from Event where Id =: EveId limit 1];
        System.assertEquals('Meeting', Eve_Con.Subject);
        
        Event Eve_Lead = [SELECT Id,Subject from Event where Id =: EveId2 limit 1];
        System.assertEquals('Meeting', Eve_Lead.Subject);
        
   
        
    }    
}