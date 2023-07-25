/************************************************************************
* Name : FPAN_Apex_CaseNotification
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : This class is developed to send email notifications after case record is inserted 
*************************************************************************/
public class FPAN_Apex_CaseNotification {
    public static void sendEmailToPortalUser(Id recordId){
      
        Case cs=[SELECT Id, CaseNumber, Account.name, Contact.Name FROM Case WHERE Id = :recordId];
        EmailTemplate csTemplate=[SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='CaseTemplate']; 
        String subject = 'Case Number :'+cs.CaseNumber+'has been assigned';
        String htmlBody = '';  
        String caseNumber=cs.CaseNumber;
        String accName=cs.Account.name;
        String conName=cs.Contact.Name;
        Id recId=cs.Id;
        
        String url= System.Label.FPAN_LBL_DomainName+recId;
        String htmlBody1='<a href='+url+'>CLICK HERE</a>';
        htmlBody = csTemplate.HTMLValue; 
        htmlBody = htmlBody.replace('AccountName',accName+'<br/>');
        htmlBody = htmlBody.replace('ContactName',conName+'<br/>');
        htmlBody = htmlBody.replace('CaseNumber',caseNumber+'<br/>');
        htmlBody = htmlBody.replace('CaseLink',htmlBody1+'<br/>');
        
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            mail.setToAddresses(getMailAddresses());
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            
            mails.add(mail);
          
            Messaging.sendEmail(mails);
    }
    
     //Get Email Addresses
     public static List<String> getMailAddresses(){
        List<String> idList = new List<String>();
        List<String> mailToAddresses = new List<String>(); 
        //FPAN_NotificationGroup
        //FPAN_EmailGroup
        Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name = : System.Label.FPAN_EmailGroup ];
        
        for (GroupMember gm : gp.GroupMembers) {
            idList.add(gm.UserOrGroupId);
           
        }
        List<User> userList = [SELECT Email FROM User WHERE Id IN :idList];
        
        for(User u : userList) {
            mailToAddresses.add(u.email);
        }
        
        return mailToAddresses;
    }

}