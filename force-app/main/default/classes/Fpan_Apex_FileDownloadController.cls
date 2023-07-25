/************************************************************************
* Name : Fpan_Apex_FileDownloadController
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : This class is the controller class of  FpanLwcCpoAgreementPreview
, it's used to preview and download the uploaded file
*************************************************************************/
public with sharing class Fpan_Apex_FileDownloadController {
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {

    String IdRecord =recordId;
        // Get record file IDs        
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :IdRecord];
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }
 
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
            FROM ContentVersion WHERE ContentDocumentId IN : fileIDs ];
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (ContentVersion docLink : docs) {
            mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
        }
       
        return mapIdTitle;
    }
    
    @AuraEnabled(cacheable=true)
    public static string getBaseUrl(){
        return URL.getSalesforceBaseUrl().toExternalForm();

    }
}