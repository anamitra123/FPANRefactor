/*****************************************************************************************************************
* Name : FPAN_Trigger_EventMeetingNotification
* Author : Anamitra Majumdar
* Date : 08/06/2023
* Desc : This a trigger on event object, this trigger is created to send email notification when a event is created 
with subject as 'Meeting'. The notification is send to respective contacts and leads
********************************************************************************************************************/
trigger FPAN_Trigger_EventMeetingNotification on Event (after insert,after update) {
    
     if(Trigger.isAfter){
        
        
        if(trigger.isInsert || trigger.isUpdate){
            FPAN_Apex_EvtMeetingNotificationHandler.EvtMeetingNotificationHandler(Trigger.New);
        }
         
    }
}