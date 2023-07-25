/**************************************************************************************************************************************HealthcarePractitionerFacility
* Name : BlankUpdateforProviderFacility
* Author : Sreeni
* Date : 23/May/2022
* Desc : This Batch class is to blank update the provider facility
****************************************************************************************************************************************/
global class BlankUpdateforProviderFacility implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {        
        String query = 'SELECT id,FPAN_Specialty_Name__c,AccountId,FPAN_Practice_Name__c from HealthcarePractitionerFacility';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<HealthcarePractitionerFacility> records){
        system.debug('Records Count-->'+records.size());
       update records;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }     
    
}