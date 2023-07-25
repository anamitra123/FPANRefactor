/**************************************************************************************************************************************
* Name : BlankUpdateforContactMailingAddress
* Author : Sreeni
* Date : 28/April/2022
* Desc : This Batch class is to blank update the contact's Mailing Address based on its AssociatedLocation's AdminSite/Provider Mail Site
****************************************************************************************************************************************/
global class BlankUpdateforContactMailingAddress implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {        
        String query = 'SELECT Id, FPAN_Admin_Site__c, FPAN_Provider_Mail_Site__c,ParentRecordId,LocationId FROM AssociatedLocation';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<AssociatedLocation> records){
        system.debug('Records Count-->'+records.size());
       FPAN_AssociatedLocationCntlr.maintainconAddress(records);
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }     
    
}