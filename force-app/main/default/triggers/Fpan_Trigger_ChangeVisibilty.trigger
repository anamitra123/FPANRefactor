/*****************************************************************************************************************
* Name : Fpan_Trigger_ChangeVisibilty
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This a trigger on ContentDocumentLink object, 
this trigger is used to change the visibility of a file whenever it is uploaded so that community user can view the files in the community portal
********************************************************************************************************************/
trigger Fpan_Trigger_ChangeVisibilty on ContentDocumentLink (before insert) {
   
 for (ContentDocumentLink cdl : Trigger.new) {
           
             cdl.Visibility = 'AllUsers';
        }
}