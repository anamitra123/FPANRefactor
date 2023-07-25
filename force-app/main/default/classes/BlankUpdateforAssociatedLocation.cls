/**************************************************************************************************************************************
* Name : BlankUpdateforAssociatedLocation
* Author : Sreeni
* Date : 23/May/2022
* Desc : This Batch class is to blank update the AssociatedLocation for clone functionality
****************************************************************************************************************************************/
global class BlankUpdateforAssociatedLocation implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {        
        String query = 'select id,ActiveFrom,ActiveTo,FPAN_Address_Name__c,AssociatedLocationNumber,FPAN_Admin_Site__c,FPAN_Billing_Site__c,FPAN_Directory_Print__c,FPAN_FPA_Main_Site__c,FPAN_Main_Practice_Site__c,FPAN_MDPRACSITEID__c,FPAN_MDPRACTID__c,FPAN_PHYSICIANID__c,FPAN_PRACTICE_ID__c,FPAN_Practice_Site__c,FPAN_Provider_Facilities__c,FPAN_Provider_Mail_Site__c,FPAN_Provider_PCC__c,FPAN_Provider_Site_Directory__c,FPAN_SITE_ID__c,LocationId,Provider_Association_Location__c,Type,FPAN_RecordType_Name__c,FPAN_Provider_Directory_Main__c,FPAN_Location_MNCM_Clinic_ID__c,FPAN_Location_MNCM_Group_ID__c,FPAN_Location_Site_Open_Effective_Date__c,FPAN_Location_Site_Closed_Effective_Date__c,FPAN_Location_Site_NPI__c from AssociatedLocation';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<AssociatedLocation> records){
        FPAN_Apex_AssociatedLocationCloned.updateCloneALocation(records);
      // update records;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }     
    
}