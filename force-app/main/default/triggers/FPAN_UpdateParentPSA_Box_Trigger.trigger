/**************************************************************************************************
* Name : FPAN_UpdateParentPSA_Box_Trigger
* Author : Ravi Kumar
* Date : 10/Nov/2022
* Desc : This trigger is to check the field value Malpractice Insurance Co is FVHS Cayman or NOt, and If it's TRUE we are updating PSA Box is true in Provider Account.
****************************************************************************************************/

trigger FPAN_UpdateParentPSA_Box_Trigger on BusinessLicense (after insert,after update,after delete) {
if(trigger.isAfter){
   if(trigger.isInsert || trigger.isUpdate){
        Fpan_Apex_UpdateParentPSA_Box.updateParentPSA(Trigger.new);
        }    
    
    if(trigger.isDelete){
        Fpan_Apex_UpdateParentPSA_Box.updateParentPSAonDelete(Trigger.Old);
        }  
    }  
}