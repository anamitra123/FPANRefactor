/**************************************************************************************************
* Name : FPAN_Apex_EmailNotificationScheduler
* Author : Anamitra Majumdar
* Date : 29/Nov/2022
* Desc : This a schedule apex class which calls the FPAN_Apex_Notification class
****************************************************************************************************/
global class FPAN_Apex_EmailNotificationScheduler implements Schedulable{
   global void execute(SchedulableContext sc)
   {
       
       FPAN_Apex_Notification.sendEmailNotification();
   }

}