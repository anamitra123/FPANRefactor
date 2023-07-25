trigger FTERollUp on CareProviderFacilitySpecialty (after delete,after update,after insert,after undelete) {
    
    if(trigger.isAfter){ 
        if(trigger.isInsert || trigger.isUndelete){
            FTESpecialityHandler.afterinsert(Trigger.newMap);
            FPAN_CheckPrimarySpeciality.afterinsert(Trigger.new);
        }
        if(trigger.isUpdate){
            FTESpecialityHandler.afterupdate(Trigger.newMap, Trigger.oldMap);
            FPAN_CheckPrimarySpeciality.afterinsert(Trigger.new);
        }
        if(trigger.isDelete){
            FTESpecialityHandler.afterdelete(Trigger.oldMap);
        }
        if(trigger.isInsert || trigger.isUpdate){
                FPAN_CheckPrimarySpeciality.updatefacility(Trigger.new);
            }
    }
    }