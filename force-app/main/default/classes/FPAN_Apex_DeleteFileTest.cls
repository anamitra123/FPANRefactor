/*****************************************************************************************************************
* Name : FPAN_Apex_DeleteFileTest
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This the test class of FPAN_Apex_DeleteFile main class
********************************************************************************************************************/
@isTest
public class FPAN_Apex_DeleteFileTest {
    
    private static testmethod void delFileTest(){
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
            FPAN_CPO_Type__c='Primary Care'
           
        );
        System.debug('accObj-->'+accObj);
        
        INSERT accObj;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = accObj.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        List<String> cdlId=new List<String>();
        cdlId.add(cdl.Id);
        
        FPAN_Apex_DeleteFile.delFile(cdlId);
        
        List<ContentDocument> docContent = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument WHERE Id =:cdl.ContentDocumentId
        ];
        
        System.assertEquals(0,docContent.size());
        
        

    }
}