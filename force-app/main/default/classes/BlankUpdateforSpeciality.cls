/**************************************************************************************************************************************
* Name : BlankUpdateforSpeciality
* Author : Sreeni
* Date : 22/April/2022
* Desc : This Batch class is to blank update the provider facility to populate FPAN_Specialty_Name__c in HealthcarePractitionerFacility
****************************************************************************************************************************************/
global class BlankUpdateforSpeciality implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
    String query = 'SELECT id,name,IsPrimarySpecialty,PractitionerFacilityId,FPAN_Account_Practice_ID__c,AccountId from CareProviderFacilitySpecialty where IsPrimarySpecialty = true';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<CareProviderFacilitySpecialty> records){
        system.debug('Records Count-->'+records.size());
        FPAN_CheckPrimarySpeciality.updatefacility(records);
    
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }     
   
}