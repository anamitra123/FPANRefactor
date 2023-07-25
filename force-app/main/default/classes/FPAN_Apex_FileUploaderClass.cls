/*****************************************************************************************************************
* Name : FPAN_Apex_CredExtensionControllerTest
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : This class is developed to upload file in salesforce , this is the controller class of FpanLwcSurveyFileUploadlwc cmp
********************************************************************************************************************/
public without sharing class FPAN_Apex_FileUploaderClass {
    /*
* @method uploadFile() 
* @desc Creates a content version from a given file's base64 and name
* 
* @param {String} base64 - base64 string that represents the file
* @param {String} filename - full file name with extension, i.e. 'products.csv'
* @param {String} recordId - Id of the record you want to attach this file to
* 
* @return {ContentVersion} - returns the created ContentDocumentLink Id if the
*   upload was successful, otherwise returns null
*/
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId,String surveyName) {
       
        Id sName=  [Select Id , Name From FPAN_Survey__c Where Name =:surveyName].Id;
        User userId=   [SELECT Id,ContactId FROM User WHERE Id= :recordId LIMIT 1];
        Contact accId=[SELECT AccountId, Id FROM Contact WHERE Id = :userId.ContactId LIMIT 1];
        String IdRec = accId.AccountId;
        //Id suvId= FPAN_Survey__c.Id;
        String idSub= IdRec.substring(IdRec.length()-3, IdRec.length());
        String remo=IdRec.remove(idSub);
  
        FPAN_Associate_Survey_Practice_CPO__c pracCpoId=[SELECT Id, FPAN_Survey__c, FPAN_Practice_CPO__c, Name, FPAN_Practice_AccountId__c FROM FPAN_Associate_Survey_Practice_CPO__c
                                                         Where FPAN_Survey__c = :sName AND FPAN_Practice_AccountId__c  = :remo  LIMIT 1];
        String IdRecord= pracCpoId.FPAN_Practice_CPO__c;
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, IdRecord);
        if (cv == null || cdl == null) { return null; }
        return cdl.Id;
    }
    /*
* @method createContentVersion() [private]
* @desc Creates a content version from a given file's base64 and name
* 
* @param {String} base64 - base64 string that represents the file
* @param {String} filename - full file name with extension, i.e. 'products.csv'
* 
* @return {ContentVersion} - returns the newly created ContentVersion, or null
*   if there was an error inserting the record
*/
    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            
            FPAN_APEX_HandleSystemException.LogException(e);
            return null;
        }
    }
    
    /*
* @method createContentLink() [private]
* @desc Creates a content link for a given ContentVersion and record
* 
* @param {String} contentVersionId - Id of the ContentVersion of the file
* @param {String} IdRecord - Id of the record you want to attach this file to
* 
* @return {ContentDocumentLink} - returns the newly created ContentDocumentLink, 
*   or null if there was an error inserting the record
*/
    private static ContentDocumentLink createContentLink(String contentVersionId, String IdRecord) {
        
        if (contentVersionId == null || IdRecord == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = IdRecord;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
           
            FPAN_APEX_HandleSystemException.LogException(e);
            return null;
        }
    }
    
    
}