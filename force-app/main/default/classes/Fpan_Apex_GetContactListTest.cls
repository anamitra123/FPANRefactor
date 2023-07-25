/************************************************************************
* Name : Fpan_Apex_GetContactList
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This the test class of FPAN_Apex_GetContactList main class
*************************************************************************/
@isTest
public class Fpan_Apex_GetContactListTest {
    private static testmethod void getContactTest(){
        Id ProviderLocationRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        Account accObj = new Account();
        accObj = new Account (
            Name = 'FPAN',
            FPAN_First_Name__c = 'Test First Name',
            FPAN_Last_Name__c = 'Name', 
            RecordTypeId =ProviderLocationRecordType, //Provider Location
            FPAN_Practice_Speciality__c = 'Dermatology',
            Website = 'www.FairviewTest.Org',
            FPAN_Clinic_Fed_Id__c = '1234567890',
            FPAN_Practice_Status__c = 'Affiliate',
            FPAN_CPO_Type__c='Primary Care'
            
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
        co.vlocity_ins__Status__c='Active';
        
        Insert co;  
        List<Contact> conListActual=[SELECT Id, Name,LastName, AccountId, Phone, Email, vlocity_ins__Status__c,FPAN_Contact_Type__c FROM Contact WHERE Id =:co.Id];
        List<Contact> conList=Fpan_Apex_GetContactList.getContact(accObj.Id);
        System.assertEquals(conListActual,conList);
    }
    
}