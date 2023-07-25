trigger FPAN_PF_Specialities on CareProviderFacilitySpecialty (before insert,before update,after delete,after update,after insert,after undelete) {
    
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
             FPAN_CheckPrimarySpeciality.updatePFfacility(Trigger.old);
        }
        if(trigger.isInsert || trigger.isUpdate){
            FPAN_CheckPrimarySpeciality.updatefacility(Trigger.new);
        }
    }
    if(trigger.isBefore){
    if(trigger.isUpdate || trigger.isInsert){        
            for(CareProviderFacilitySpecialty c:trigger.new){
                if(c.FPAN_Specialityname__c != c.Name){
                    c.Name=c.FPAN_Specialityname__c;
                    
                }
                if(c.PractitionerFacilityId!=null){
                   Id s=c.PractitionerFacilityId;
                    HealthcarePractitionerFacility k=[SELECT id, AccountId FROM HealthcarePractitionerFacility WHERE Id=:s];
                    c.AccountId=k.AccountId;
                    
               }
            }
        }
    }
}