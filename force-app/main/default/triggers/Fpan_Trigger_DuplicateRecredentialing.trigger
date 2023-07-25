/*****************************************************************************************************************
* Name : Fpan_Trigger_DuplicateRecredentialing
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This a before insert trigger on vlocity_ins__ProviderNetworkMember__c object, this trigger will throw an error
whenever a duplicate re-cerdentialing record is inserted for a single credentialing record
********************************************************************************************************************/
trigger Fpan_Trigger_DuplicateRecredentialing on vlocity_ins__ProviderNetworkMember__c (before insert) {
    if(Trigger.isBefore){
        
        
        if(trigger.isInsert){
            FPAN_Apex_DuplicateReCredHandler.DuplicateReCredentialingRecordInsert(Trigger.New);
        }
    }
}