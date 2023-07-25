trigger FTERollUpOnAccount on HealthcarePractitionerFacility (after delete,after update,after insert,after undelete,before delete) {    
    if(trigger.isAfter){ 
        if(trigger.isInsert || trigger.isUndelete){
            FTEFacilityHandler.afterinsert(Trigger.newMap);
            FPAN_ProviderStatusTriggerHandler.StatusUpdate(Trigger.New);
        }
        if(trigger.isUpdate){
            FTEFacilityHandler.afterupdate(Trigger.newMap, Trigger.oldMap);
            FPAN_ProviderStatusTriggerHandler.StatusUpdate(Trigger.New);
        } 
        if(trigger.isDelete){
            FTEFacilityHandler.afterdelete(Trigger.oldMap);
            //CheckProviderFacilitySpecialities()
        }
    }   
    
    //Gaana/Mayank added below code for M3 US
    if(trigger.isBefore && trigger.isDelete){  
           CheckProviderFacilitySpecialities.checkProviderFacSpe(Trigger.Old);
           FPAN_Remove_Practice_Frm_Provider.RemovePracticefromProvider(Trigger.Old);
    }  
}