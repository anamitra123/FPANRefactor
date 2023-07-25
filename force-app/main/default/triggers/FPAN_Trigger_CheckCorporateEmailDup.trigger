/************************************************************************
* Name : FPAN_Trigger_CheckCorporateEmailDup
* Author : Ravi Pothapi
* Date : 13/04/2023
* Desc : Trigger is to validate the Portal User already exist or Not based on the Contact Corporate Email Address.
*************************************************************************/
trigger FPAN_Trigger_CheckCorporateEmailDup on Contact (before insert, before update) {


//Trigger is to validate the Portal User already exist or Not based on the Contact Corporate Email Address.
    if(Trigger.isBefore){
        if(trigger.IsUpdate){
            for(Contact con : Trigger.New) { 
                
                Contact oldContact = Trigger.OldMap.get(con.id);
               
                if(con.Email != oldContact.Email)
                {                    
                   FPAN_Apex_CheckCorporateEmailHandler.CheckEmailUpdate(Trigger.New , Trigger.OldMap);
                }
            }
        }
        
        if(trigger.Isinsert){
          FPAN_Apex_CheckCorporateEmailHandler.CheckEmailInsert(Trigger.New);
        }
    }
}