/**
 * Fairview Physician Associates Network
 * M4 Practice Portal 
 * 
 * AUTHOR: Rishabh Gupta
 * DATE: 3/29/2023
 * DESCRIPTION: Retreives the List Of Cases for the Current User.
 */

 public with sharing class FPAN_Apex_CaseListPortalController {
    
    @AuraEnabled(cacheable=true)
    public static List<Case> getCasesByUserId() {
     return [SELECT Id, Status, Agent_Comments__c, Subject, Agent_Action__c, CreatedDate, CaseNumber FROM Case WHERE FPAN_Is_Archived__c = False ORDER BY CreatedDate DESC];
    }
    @AuraEnabled(cacheable = true)
    public static CaseListInfo getRecords(Integer queryLimit, Integer queryOffset) {
        System.debug('@@@@queryLimit===>'+queryLimit);
        System.debug('@@@@queryOffset===>'+queryOffset);
        return new CaseListInfo([SELECT count() FROM Case WHERE FPAN_Is_Archived__c = False],
        			[SELECT Id, Status, Agent_Comments__c, Subject, Agent_Action__c, CreatedDate, CaseNumber 
                    FROM Case WHERE FPAN_Is_Archived__c = False
                    ORDER BY CreatedDate DESC 
                	LIMIT :queryLimit 
                	OFFSET :queryOffset]);
        
    }
    
    public class CaseListInfo{

        @AuraEnabled
        public Integer totalRecordCount {get;set;}

        @AuraEnabled
        public List<Case> caseRecords{get;set;}

        public CaseListInfo(Integer totalRecordCount, List<Case> caseRecords){
            this.totalRecordCount = totalRecordCount;
            this.caseRecords = caseRecords;
            System.debug('@@@@totalRecordCount===>'+totalRecordCount);
            System.debug('@@@@caseRecords===>'+caseRecords);
        }
    }
}