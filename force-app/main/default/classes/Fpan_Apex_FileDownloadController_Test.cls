/************************************************************************
* Name : Fpan_Apex_FileDownloadController_Test
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : This is the test class of Fpan_Apex_FileDownloadController_Test
*************************************************************************/
@isTest
public class Fpan_Apex_FileDownloadController_Test {
    
    private static testmethod void getRelatedFilesByRecordIdTest(){
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
        System.debug('accObj Id-->'+accObj.Id);
        
        String recordId=accObj.Id;
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = accObj.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        List<ContentVersion> docCd = [SELECT ContentDocumentId, FileExtension, Title 
            FROM ContentVersion WHERE ContentDocumentId =:cdl.ContentDocumentId];
        Map<ID, String> mapIdTitle1 = new Map<ID, String>();
        for (ContentVersion docLink1 : docCd) {
            mapIdTitle1.put(docLink1.ContentDocumentId, docLink1.Title);
        }
        
        System.assertEquals(mapIdTitle1,Fpan_Apex_FileDownloadController.getRelatedFilesByRecordId(recordId));
    }
}