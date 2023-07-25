/*****************************************************************************************************************
* Name : FPAN_Apex_EvtMeetingNotificationHandler
* Author : Anamitra Majumdar
* Date : 08/06/2023
* Desc : This a handler class of FPAN_Trigger_EventMeetingNotification trigger
********************************************************************************************************************/
public class FPAN_Apex_EvtMeetingNotificationHandler {
    
    public static void EvtMeetingNotificationHandler(List<Event> evList){
        
        if(evList[0].Subject == 'Meeting'){
        List<EventRelation> ERLST = new List<EventRelation>();
        List<Contact> conList = new List<Contact>();
        List<Lead> leadList = new List<Lead>();
        SET<ID> contIds = new SET<ID>();
        SET<ID> leadIds = new SET<ID>();
        LIST<String> toAddrssEmails = new List<String>();
        
        ERLST = [SELECT Id, EventId, RelationId, IsParent, IsWhat, IsInvitee, Status, CreatedDate FROM EventRelation WHERE EventId = :evList[0].Id];
        for(EventRelation ER: ERLST){
            String relatedObj = string.valueOf(ER.RelationId);
            if(relatedObj.startsWith('003')){
                contIds.add(ER.RelationId);
            }
            if(relatedObj.startsWith('00Q')){
                leadIds.add(ER.RelationId); 
            }
        }
        if(contIds != null){
            conList = [Select id,name,email from contact where id= :contIds];
            for(Contact con : conList){        
                toAddrssEmails.add(con.email);
            }
        }
        if(leadIds != null){
            leadList = [Select id,name,email from lead where id= :leadIds];
            for(Lead ld : leadList){        
                toAddrssEmails.add(ld.email);
            }
        }
        
        
        //Send Email Notification to Contacts/Leads
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddrssEmails);
        mail.setSubject('Meeting Details'); 
        mail.setSenderDisplayName('Fairview Organization');
        String template = ' <b>Subject -</b> Meeting  <br/>';        
        template+= '<b>Start Date & Time - </b>'+evList[0].StartDateTime+ '<br/>';
        template+= '<b>End Date & Time - </b>'+evList[0].EndDateTime+'<br/>';
        template+= '<b>Duration (Mins) - </b>'+evList[0].DurationInMinutes+'<br/>';
        template+= '<b>Description - </b>'+evList[0].Description+'<br/>';
        
        mail.setHtmlBody(template);
       	Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
        
    }

}