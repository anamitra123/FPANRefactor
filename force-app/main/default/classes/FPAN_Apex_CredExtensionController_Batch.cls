global class FPAN_Apex_CredExtensionController_Batch implements Database.Batchable<sObject> {
    
    Public Date myStartDate;
    public Date myEndDate;
    public String FirstName = UserInfo.getFirstName();
    
    public FPAN_Apex_CredExtensionController_Batch(Date strDate,Date endDate) {
        myStartDate = strDate;
        myEndDate = endDate;
        system.debug('@@@@check strDate--->'+strDate);  
        system.debug('@@@@endDate---->'+endDate);
    }
    
    
    global database.querylocator start(Database.BatchableContext BC) {
        // String query = 'Select id,FPAN_FPA__c,FPA_Member_Effective_Date__c,FPAN_FVCL__c,FPAN_Practice_Account__r.Name,FPAN_Provider_Account__c,FPAN_Practice_Account__c,FPAN_FPA_C_C_A_D__c,FPAN_Provider_Account__r.Name,FPAN_Provider_Account__r.FPAN_Last_Name__c,FPAN_Provider_Account__r.FPAN_First_Name__c,FPAN_Provider_Account__r.FPAN_MI__c,FPAN_Provider_Account__r.FPAN_Title__c,FPAN_Provider_NPI__c,FPAN_Provider_NPI__c,FPAN_Provider_Account__r.BillingAddress, FPAN_FVCL_C_C_A_D__c,FPAN_Practice_Account__r.FPAN_FPA_Membership_Effective_Date__c from vlocity_ins__ProviderNetwork__c where(FPAN_FPA_C_C_A_D__c >= :'+ myStartDate+ 'and FPAN_FPA_C_C_A_D__c <= :'+myEndDate+') OR (FPAN_FVCL_C_C_A_D__c >= :'+myStartDate+'AND FPAN_FVCL_C_C_A_D__c <= :'+myEndDate+')';
        
        return Database.getQueryLocator([Select id,FPAN_FPA__c,FPA_Member_Effective_Date__c,FPAN_FVCL__c,FPAN_Practice_Account__r.Name,FPAN_Provider_Account__c,
                                         FPAN_Practice_Account__c,FPAN_FPA_C_C_A_D__c,
                                         FPAN_Provider_Account__r.Name,
                                         FPAN_Provider_Account__r.FPAN_Last_Name__c,
                                         FPAN_Provider_Account__r.FPAN_First_Name__c,
                                         FPAN_Provider_Account__r.FPAN_MI__c,
                                         FPAN_Provider_Account__r.FPAN_Title__c,
                                         FPAN_Provider_NPI__c,
                                         FPAN_Provider_Account__r.BillingAddress, FPAN_FVCL_C_C_A_D__c,FPAN_Practice_Account__r.FPAN_FPA_Membership_Effective_Date__c from vlocity_ins__ProviderNetwork__c where recordtype.Name = 'Credentialing' 
                                         AND ((FPAN_FPA_C_C_A_D__c >= :myStartDate and FPAN_FPA_C_C_A_D__c <= :myEndDate) OR (FPAN_FVCL_C_C_A_D__c >= :myStartDate  
                                                                                                                              AND FPAN_FVCL_C_C_A_D__c <= :myEndDate))
                                        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<vlocity_ins__ProviderNetwork__c> scope) {
        List<vlocity_ins__ProviderNetwork__c> credList  = new List<vlocity_ins__ProviderNetwork__c>();
        //List<vlocity_ins__ProviderNetwork__c> credList  = new List<vlocity_ins__ProviderNetwork__c>();
        Boolean result;  
        List<ContentVersion> cvFPAlist = new List<ContentVersion>();
        List<ContentVersion> cvFVCLlist = new List<ContentVersion>();
        List<ContentDocumentLink> insertCDLinks = new List<ContentDocumentLink>();
        String CredFPAId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN Credentialing FPA' LIMIT 1].Id;
        String CredFVCLId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN Credentialing FPA&FVCL' LIMIT 1].Id;
        List<ContentDocument> deleteFPAOldRecs = [SELECT Id, ParentId FROM ContentDocument where ParentId = :CredFPAId];
        List<ContentDocument> deleteFVCLOldRecs = [SELECT Id, ParentId FROM ContentDocument where ParentId = :CredFVCLId];
        credList = scope;
        List<AssociatedLocation> AsstLocation  = new List<AssociatedLocation>();
        List<Schema.Address> AddressList  = new List<Schema.Address>();
        Set<ID> Providerfacilities  = new Set<ID>();
        Set<ID> LocationIds  = new Set<ID>();
        
        system.debug('credList Batch size---->'+credList.size());
        
        List<ContentVersion> cvlist = new List<ContentVersion>();
        
        
        EmailTemplate FPAemailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='Credential Letters FPA']; 
        EmailTemplate FVCLemailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='Credential Letters FVCL']; 
        
        SET<Id> accountIds = new Set<ID>();
        for(vlocity_ins__ProviderNetwork__c Cred : credList){            
            accountIds.add(Cred.FPAN_Provider_Account__c);
        } 
        Map<Id, AssociatedLocation> mapAsstLocation = new Map<Id, AssociatedLocation>();  
        //Associated Location Records 
        AsstLocation = [Select ID,FPAN_Provider_Facilities__c,LocationId,Location.Name,FPAN_Provider_Facilities__r.name,FPAN_Provider_Mail_Site__c,ParentRecordId From AssociatedLocation Where ParentRecordId IN: accountIDs AND FPAN_Provider_Mail_Site__c = true];
        
        for(AssociatedLocation loc : AsstLocation){            
            LocationIds.add(loc.LocationId);
            mapAsstLocation.put(loc.ParentRecordId,loc);
        } 
        
        AddressList = [Select ID,ParentID,Address,FPAN_Suite_No__c From Address where ParentID IN: LocationIds];
        Map<id,address> addressMap = new Map<id,address>();
        Map<id,String> suiteNoMap = new Map<id,String>();
        for(Schema.Address add : AddressList ){
            addressMap.put(add.ParentID,add.address);
            suiteNoMap.put(add.ParentID,add.FPAN_Suite_No__c);
        }
        
        if(credList.size()>0)
        {
            for(vlocity_ins__ProviderNetwork__c credRec : credList){
                //for(AssociatedLocation aLoc : AsstLocation){ 
                if(mapAsstLocation.containsKey(credRec.FPAN_Provider_Account__c)){
                    //credRec2.add(credRec);
                    // if(credRec.FPAN_Provider_Account__c == aLoc.ParentRecordId ){
                    ContentVersion cv = new ContentVersion();
                    String CVName = ' '; 
                    Datetime myDT = Datetime.now();  
                    String myDate = myDT.formatGMT('MM/dd/yyyy'); 
                    Datetime FPADate;
                    Datetime MbrEffDt;
                    String FPANCCAD;
                    String FPANMed;
                    if(credRec.FPAN_FPA_C_C_A_D__c != NULL){
                        FPADate = credRec.FPAN_FPA_C_C_A_D__c;
                        FPANCCAD = FPADate.formatGMT('MM/dd/yyyy');
                    }
                    if(credRec.FPAN_Practice_Account__r.FPAN_FPA_Membership_Effective_Date__c != NULL){
                        MbrEffDt = credRec.FPAN_Practice_Account__r.FPAN_FPA_Membership_Effective_Date__c;
                        FPANMed = MbrEffDt.formatGMT('MM/dd/yyyy'); 
                    }
                    String fpanlogo = '<img width="500" height="250" src="'+Label.FPANLogo+'"/>';
                    String htmlBody = '';  
                    //String LocationName = aLoc.Location.Name; 
                    //Id locationid = aLoc.Location.Id;                        
                    String LocationName =mapAsstLocation.get(credRec.FPAN_Provider_Account__c).Location.Name;
                    Id locationid = mapAsstLocation.get(credRec.FPAN_Provider_Account__c).Location.Id;
                    
                    //String ProviderName = credRec.FPAN_Provider_Account__r.Name;
                    String ProviderName = '';
                    IF(credRec.FPAN_Provider_Account__r.FPAN_MI__c != NULL){   
                        ProviderName = credRec.FPAN_Provider_Account__r.FPAN_Last_Name__c + ' ' + 
                            credRec.FPAN_Provider_Account__r.FPAN_MI__c + ' ' + 
                            credRec.FPAN_Provider_Account__r.FPAN_First_Name__c + ', ' + 
                            credRec.FPAN_Provider_Account__r.FPAN_Title__c; 
                    }
                    else IF(credRec.FPAN_Provider_Account__r.FPAN_MI__c == NULL){   
                        ProviderName = credRec.FPAN_Provider_Account__r.FPAN_Last_Name__c + ' ' +                         
                            credRec.FPAN_Provider_Account__r.FPAN_First_Name__c + ', ' + 
                            credRec.FPAN_Provider_Account__r.FPAN_Title__c; 
                    }  
                    String PracticeName = credRec.FPAN_Practice_Account__r.Name;   
                    String SuiteNo='';
                    if(suiteNoMap.get(locationid) != null){
                        SuiteNo = ', '+suiteNoMap.get(locationid);
                    }                        
                    String Street='';
                    if(addressMap.get(locationid).getStreet() != null){
                        Street = addressMap.get(locationid).getStreet();
                    }  
                    String City='';
                    if(addressMap.get(locationid).getCity() != null){
                        City = addressMap.get(locationid).getCity();
                    }
                    String state='';
                    if(addressMap.get(locationid).getState() != null){
                        state = ', '+addressMap.get(locationid).getState();
                    }
                    String pincode='';
                    if(addressMap.get(locationid).getPostalCode() != null){
                        pincode = ', '+addressMap.get(locationid).getPostalCode();
                    }
                    String fulladdress = Street+SuiteNo;
                    String fulladdress2 = City+state+pincode;
                    
                    if(credRec.FPAN_FPA__c == TRUE && credRec.FPAN_FVCL__c == FALSE){ // FPA Template Start
                        String htmlBody1  = '<img width="100" height="100" src="'+Label.FPANSignature+'"/>';
                        //htmlBody = FPAemailTemplate.Body;  
                        htmlBody = FPAemailTemplate.HTMLValue;                          
                        htmlBody = htmlBody.replace('MyDate',myDate+'<br/><br/>');
                        htmlBody = htmlBody.replace('Provider Name',ProviderName+'<br/>');
                        htmlBody = htmlBody.replace('Practice Name',PracticeName+'<br/>');
                        htmlBody = htmlBody.replace('drprovidername',ProviderName+':<br/>');
                        htmlBody = htmlBody.replace('Address',fulladdress+'<br/>');
                        htmlBody = htmlBody.replace('countrydetails',fulladdress2+'<br/>');
                        htmlBody = htmlBody.replace('linebreak','<br/>');
                        htmlBody = htmlBody.replace('Logo','<br/><br/><br/>'+fpanlogo);
                        if(credRec.FPAN_FPA_C_C_A_D__c != NULL){
                            htmlBody = htmlBody.replace('CCADate',FPANCCAD);
                        }
                        if(credRec.FPAN_Practice_Account__r.FPAN_FPA_Membership_Effective_Date__c != NULL){
                            htmlBody = htmlBody.replace('MbrEffDt',FPANMed);
                        }
                        htmlBody = htmlBody.replace('Imageurl', '<br/><br/>'+htmlBody1);  
                        /*-----Updated Signature Values as part of SR-RITM1011970-----*/
                        htmlBody = htmlBody.replace('signName','Christopher Restad, DO, MBA '+'<br/>');
                        //htmlBody = htmlBody.replace('signrole','Medical Officer of Networking and Credentialing, FPAN ');    
                        htmlBody = htmlBody.replace('signrole','Medical Officer, Network & Credentialing ');
                        htmlBody = htmlBody.replace('sr1','Fairview Physician Associates Network ');                        
                        System.debug('htmlBody-->'+htmlBody);
                        Blob letterBody = blob.toPdf(htmlBody);                            
                        cv.Title = ProviderName+ ' '+credRec.FPAN_Provider_NPI__c;
                        cv.PathOnClient = ProviderName+ ' '+credRec.FPAN_Provider_NPI__c+'.pdf';
                        cv.VersionData = letterBody;
                        cv.IsMajorVersion = true;
                        cvlist.add(cv);
                        cvFPAlist.add(cv);
                        
                    } // FPA Template End
                    
                    if(credRec.FPAN_FPA__c == TRUE && credRec.FPAN_FVCL__c == TRUE){ // FVCL Template Start
                        String htmlBody1  = '<img width="100" height="100" src="'+Label.FPANSignature+'"/>';
                        htmlBody = FVCLemailTemplate.HTMLValue;
                        htmlBody = htmlBody.replace('MyDate', myDate+'<br/><br/>');
                        htmlBody = htmlBody.replace('Provider Name',ProviderName+'<br/>');
                        htmlBody = htmlBody.replace('Practice Name',PracticeName+'<br/>');
                        htmlBody = htmlBody.replace('drprovidername',ProviderName+':<br/>');
                        htmlBody = htmlBody.replace('Address',fulladdress+'<br/>');
                        htmlBody = htmlBody.replace('countrydetails',fulladdress2+'<br/>');
                        htmlBody = htmlBody.replace('linebreak',' <br/>');
                        htmlBody = htmlBody.replace('Logo','<br/><br/>'+fpanlogo);
                        if(credRec.FPAN_FPA_C_C_A_D__c != NULL){
                            htmlBody = htmlBody.replace('MbrEffDt',FPANCCAD);
                        }
                      
                        htmlBody = htmlBody.replace('Imageurl','<br/>'+htmlBody1);  
                        /*-----Updated Signature Values as part of SR-RITM1011970-----*/
                        htmlBody = htmlBody.replace('signName','Christopher Restad, DO, MBA '+'<br/>');
                        // htmlBody = htmlBody.replace('signrole','Medical Officer of Networking and Credentialing, FPAN ');
                        htmlBody = htmlBody.replace('signrole','Medical Officer, Network & Credentialing ');
                        htmlBody = htmlBody.replace('sr1','Fairview Physician Associates Network ');
                        
                        Blob letterBody = blob.toPdf(htmlBody);
                        cv.Title = ProviderName+ ' '+credRec.FPAN_Provider_NPI__c;
                        cv.PathOnClient = ProviderName+ ' '+credRec.FPAN_Provider_NPI__c+'.pdf';
                        cv.VersionData = letterBody;
                        cv.IsMajorVersion = true;
                        cvlist.add(cv);
                        cvFVCLlist.add(cv);
                        
                    } // FVCL Template End
                }               
            }
            try{
                
                
                insert cvFPAlist;
                SET<ID> cvFPAids = new SET<ID>();
                for(ContentVersion fpaId : cvFPAlist){
                    cvFPAids.add(fpaId.id);
                }
                
                FPAN_FutureInsertContentDocumentLink.CredFPAInsertCDL(cvFPAids);
                
                insert cvFVCLlist;
                SET<ID> cvFVCLids = new SET<ID>();
                for(ContentVersion fvclId : cvFVCLlist){
                    cvFVCLids.add(fvclId.id);
                }
                FPAN_FutureInsertContentDocumentLink.CredFVCLInsertCDL(cvFVCLids);
                
                system.debug('cvFVCLids-->'+cvFVCLids.size());
                if(cvFPAids.size()>0 || cvFVCLids.size()>0){
                    result = true;
                }else{
                    result = false;                
                } 
            }catch(exception e){
                System.debug('Exception -->'+e);
                result = false;
            }
            
            
            
        }
        
      
    }   
    
    global void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            //String[] toAddresses = new list<string>{System.label.FPAN_Email};
            String subject ='Download letters';
            email.setSubject(subject);
            String content = 'Hi '+FirstName+'<br/><br/>'+
                
                'Credentialing letters were generated in accordance with your request. Please use the Uovided below.<br/><br/>'+
                '<html><a href="https://mhealthfairviewfpan.my.salesforce.com/sfc/#search">CLICK HERE</a><html><br/><br/>'+
                 //'<html><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+someid+'">CLICK HERE</a></html><br/><br/>';                    
                'Thank you!  <br/><br/>';
            email.setHtmlBody(content);
            email.setToAddresses(getMailAddresses());
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
    }
    
     //Get Email Addresses
    public static List<String> getMailAddresses(){
        List<String> idList = new List<String>();
        List<String> mailToAddresses = new List<String>(); 
        
        Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name = : System.Label.FPAN_NotificationGroup ];
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