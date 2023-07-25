/*****************************************************************************************************************
* Name : FPAN_Apex_DeleteFile
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This class is developed to delete the uploaded file in salesforce , 
this is the controller class of FpanLwcStartSurvey cmp
********************************************************************************************************************/
public without sharing class FPAN_Apex_DeleteFile {
    
    @AuraEnabled
    public static void delFile( List<String> recordId){
        list<ContentDocument> lstCntDocsToDelete = new list<ContentDocument>();
        
        for(ContentDocumentLink iterator : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE Id IN:recordId]) {
            lstCntDocsToDelete.add(new ContentDocument(Id = iterator.ContentDocumentId));
        }
        
        if(!lstCntDocsToDelete.isEmpty() && lstCntDocsToDelete != null) {
            Database.delete(lstCntDocsToDelete, false);
            Database.emptyRecycleBin(lstCntDocsToDelete);
        }
    }
    
}