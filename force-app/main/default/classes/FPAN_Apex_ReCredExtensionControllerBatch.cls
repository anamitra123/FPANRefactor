global class FPAN_Apex_ReCredExtensionControllerBatch implements Database.Batchable<sObject>{
    Public Date myStartDate;
    public Date myEndDate;
    public String FirstName = UserInfo.getFirstName();
    public String EmailId=UserInfo.getUserEmail();
    public FPAN_Apex_ReCredExtensionControllerBatch(Date strDate,Date endDate) {
        myStartDate = strDate;
        myEndDate = endDate;
        system.debug('@@@@check strDate--->'+strDate);  
        system.debug('@@@@endDate---->'+endDate);
    }
    
    global database.querylocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([Select id,FPAN_FPA__c,FPAN_Board_Cert_Waived__c,FPAN_FVCL__c,FPAN_FPA_R_C_C_A_Date__c,vlocity_ins__ProviderAccountId__c,vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c,vlocity_ins__ProviderNetworkId__r.FPAN_Practice_Account__r.Name,
                      vlocity_ins__ProviderNetworkId__r.FPAN_Practice_Account__r.Account.FPAN_Last_Name__c,vlocity_ins__ProviderAccountId__r.BillingCountry,
                      vlocity_ins__ProviderAccountId__r.Name,
                      vlocity_ins__ProviderAccountId__r.FPAN_Last_Name__c,
                      vlocity_ins__ProviderAccountId__r.FPAN_First_Name__c,
                      vlocity_ins__ProviderAccountId__r.FPAN_MI__c,
                      vlocity_ins__ProviderAccountId__r.FPAN_Title__c,
                      vlocity_ins__ProviderAccountId__r.BillingStreet,vlocity_ins__ProviderAccountId__r.BillingCity,vlocity_ins__ProviderAccountId__r.BillingState,vlocity_ins__ProviderAccountId__r.BillingPostalCode,
                      vlocity_ins__ProviderNetworkId__r.FPAN_Practice_Account__c,FPAN_FVCL_R_C_C_A_Date__c
                      from vlocity_ins__ProviderNetworkMember__c where (FPAN_FPA_R_C_C_A_Date__c >= :myStartDate AND FPAN_FPA_R_C_C_A_Date__c  <= :myEndDate) OR (FPAN_FVCL_R_C_C_A_Date__c >= :myStartDate AND FPAN_FVCL_R_C_C_A_Date__c <= :myEndDate)]);
    }
    
    global void execute(Database.BatchableContext BC,List<vlocity_ins__ProviderNetworkMember__c> scope) {
        List<vlocity_ins__ProviderNetworkMember__c> RecredList  = new List<vlocity_ins__ProviderNetworkMember__c>();
        RecredList=scope;
        List<AssociatedLocation> AsstLocation  = new List<AssociatedLocation>();
        List<Schema.Address> AddressList  = new List<Schema.Address>();
        Set<ID> Providerfacilities  = new Set<ID>();
        Set<ID> LocationIds  = new Set<ID>();
        SET<Id> accountIds = new Set<ID>();
        Boolean result;       
        List<ContentVersion> cvlist = new List<ContentVersion>();
        List<ContentVersion> cvFPAlist = new List<ContentVersion>();
        List<ContentVersion> cvFVCLlist = new List<ContentVersion>();
        List<ContentDocumentLink> insertCDLinks = new List<ContentDocumentLink>();
        String ReCredFPAId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN ReCredentialing FPA' LIMIT 1].Id;
        String ReCredFVCLId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN ReCredentialing FVCL' LIMIT 1].Id; 
        List<ContentDocument> deleteFPAOldRecs = [SELECT Id, ParentId FROM ContentDocument where ParentId = :ReCredFPAId];
        List<ContentDocument> deleteFVCLOldRecs = [SELECT Id, ParentId FROM ContentDocument where ParentId = :ReCredFVCLId];                
        EmailTemplate FPAemailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='Recredential Letters FPA']; 
        EmailTemplate FVCLemailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name ='Recredential Letters FVCL']; 
        for(vlocity_ins__ProviderNetworkMember__c ReCred: RecredList){            
            accountIds.add(ReCred.vlocity_ins__ProviderAccountId__c);
            system.debug('###Account1'+ReCred.vlocity_ins__ProviderAccountId__c);
        }  
        system.debug('###Account2'+accountIDs);
        Map<Id, AssociatedLocation> mapAsstLocation = new Map<Id, AssociatedLocation>();
        //Associated Location Records 
        AsstLocation = [Select ID,FPAN_Provider_Facilities__c,LocationId,Location.Name,FPAN_Provider_Facilities__r.name,FPAN_Provider_Mail_Site__c,ParentRecordId From AssociatedLocation Where ParentRecordId IN: accountIDs AND FPAN_Provider_Mail_Site__c = true];
        //Associated Location Records Map
        system.debug('@@@@AsstLocation'+AsstLocation);
        system.debug('@@@@AsstLocation Size'+AsstLocation.Size());
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
        
        if(RecredList.size()>0){
            for(vlocity_ins__ProviderNetworkMember__c RecredRec : RecredList){
                //for(AssociatedLocation aLoc : AsstLocation){
                if(mapAsstLocation.containsKey(RecredRec.vlocity_ins__ProviderAccountId__c)){
                    //System.Debug('Map Parent Id'+mapAsstLocation.containsKey(RecredRec.vlocity_ins__ProviderAccountId__c));
                  
                    // if(RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Practice_Account__c == aLoc.FPAN_Provider_Facilities__c){
                     //if(RecredRec.vlocity_ins__ProviderAccountId__c == aLoc.ParentRecordId){   
                        ContentVersion cv = new ContentVersion();
                        String CVName = ' '; 
                        Datetime myDT = Datetime.now();  
                        String myDate = myDT.formatGMT('MM/dd/yyyy'); 
                        Datetime FPADate;
                        Datetime FVCLDate;
                        String FPADatefmt;
                        String FVCLAppDate;
                        String ProviderName = '';
                        IF(RecredRec.FPAN_FPA_R_C_C_A_Date__c != NULL){   
                            FPADate = RecredRec.FPAN_FPA_R_C_C_A_Date__c;                       
                            FPADatefmt = FPADate.formatGMT('MM/dd/yyyy'); 
                        }
                        IF(RecredRec.FPAN_FVCL_R_C_C_A_Date__c != NULL){   
                            FVCLDate = RecredRec.FPAN_FVCL_R_C_C_A_Date__c;                       
                            FVCLAppDate = FVCLDate.formatGMT('MM/dd/yyyy'); 
                        } 
                        IF(RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_MI__c != NULL){   
                            ProviderName = RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_Last_Name__c + ' ' + 
                                RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_MI__c + ' ' + 
                                RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_First_Name__c + ', ' + 
                                RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_Title__c; 
                        }
                        else IF(RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_MI__c == NULL){   
                            ProviderName = RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_Last_Name__c + ' ' +                         
                                RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_First_Name__c + ', ' + 
                                RecredRec.vlocity_ins__ProviderAccountId__r.FPAN_Title__c; 
                        }  
                        
                        String PracticeName = RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Practice_Account__r.Name;
                        //String LocationName = aLoc.Location.Name;
                        String LocationName =mapAsstLocation.get(RecredRec.vlocity_ins__ProviderAccountId__c).Location.Name;
                        Id locationid = mapAsstLocation.get(RecredRec.vlocity_ins__ProviderAccountId__c).Location.Id;
                        //Id locationid = aLoc.Location.Id;
                        System.debug('Location Name'+LocationName);
                        System.debug('Location Id'+locationid);                       
                        String htmlBody = '';
                        //open table..
                        //  htmlBody = '<table border="0"></table>';
                        String fpanlogo = '<img width="500" height="250" src="'+Label.FPANLogo+'"/>';
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
                        if(RecredRec.FPAN_FPA_R_C_C_A_Date__c != NULL && RecredRec.FPAN_FVCL_R_C_C_A_Date__c == NULL){ // FPA Template - Start
                            
                            String htmlBody1  = '<img width="100" height="100" src="'+Label.FPANSignature+'"/>';
   
                            htmlBody = FPAemailTemplate.HTMLValue;                                                     
                            htmlBody = htmlBody.replace('Date',myDate+'<br/><br/>');
                            htmlBody = htmlBody.replace('Provider Name',ProviderName+'<br/>');                           
                            htmlBody = htmlBody.replace('Practice Name',PracticeName+'<br/>');
                            htmlBody = htmlBody.replace('drprovidername',ProviderName+':<br/><br/>');
                            htmlBody = htmlBody.replace('ReCCAD',FPADatefmt);
                            htmlBody = htmlBody.replace('Address',fulladdress+'<br/>');
                            htmlBody = htmlBody.replace('countrydetails',fulladdress2+'<br/>');                          
                            htmlBody = htmlBody.replace('linebreak','<br/>');                            
                            htmlBody = htmlBody.replace('Imageurl','<br/><br/>'+htmlBody1);  
                            /*-----Updated Signature Values as part of SR-RITM1011970-----*/
                            htmlBody = htmlBody.replace('signName','Christopher Restad, DO, MBA'+'<br/>');
                           // htmlBody = htmlBody.replace('signrole','Medical Officer of Networking and Credentialing, FPAN '+'<br/><br/><br/>');
                            htmlBody = htmlBody.replace('signrole','Medical Officer, Network & Credentialing ');
                            htmlBody = htmlBody.replace('sr1','Fairview Physician Associates Network ');
                            htmlBody = htmlBody.replace('Logo','<br/><br/><br/>'+fpanlogo);
                            System.debug('htmlBody-->'+htmlBody);
                            Blob letterBody = blob.toPdf(htmlBody);    
                            System.debug('ProviderName-->'+ProviderName);
                            System.debug('RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c-->'+RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c);
                            cv.Title = ProviderName+ ' '+RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c;
                            cv.PathOnClient = ProviderName+ ' '+RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c+'.pdf';
                            cv.VersionData = letterBody;
                            cv.IsMajorVersion = true;
                            cvlist.add(cv);
                            cvFPAlist.add(cv);
                            
                        }    // FPA Template - End
                        
                        if(RecredRec.FPAN_FPA__c == TRUE && RecredRec.FPAN_FVCL_R_C_C_A_Date__c != NULL){ // FVCL Template - Start 
                            
                            String htmlBody1  = '<img width="100" height="100" src="'+Label.FPANSignature+'"/>';
                            //htmlBody = FVCLemailTemplate.Body; 
                            htmlBody = FVCLemailTemplate.HTMLValue;
                            htmlBody = htmlBody.replace('Date',myDate+'<br/><br/>');
                            htmlBody = htmlBody.replace('Provider Name',ProviderName+'<br/>');
                            htmlBody = htmlBody.replace('Practice Name',PracticeName+'<br/>');
                            htmlBody = htmlBody.replace('drprovidername',ProviderName+':<br/><br/>');
                            htmlBody = htmlBody.replace('Address',fulladdress+'<br/>');
                            htmlBody = htmlBody.replace('countrydetails',fulladdress2+'<br/><br/>');
                            htmlBody = htmlBody.replace('FVCLD',FVCLAppDate);
                            htmlBody = htmlBody.replace('linebreak','<br/>');                            
                            htmlBody = htmlBody.replace('Imageurl','<br/><br/>'+htmlBody1);  
                            /*-----Updated Signature Values as part of SR-RITM1011970-----*/
                            htmlBody = htmlBody.replace('signName','Christopher Restad, DO, MBA'+'<br/>');
                           // htmlBody = htmlBody.replace('signrole','Medical Officer of Networking and Credentialing, FPAN '+'<br/><br/><br/>');
                            htmlBody = htmlBody.replace('signrole','Medical Officer, Network & Credentialing ');
                            htmlBody = htmlBody.replace('sr1','Fairview Physician Associates Network ');
                            htmlBody = htmlBody.replace('Logo','<br/><br/><br/>'+fpanlogo);
                            
                            Blob letterBody = blob.toPdf(htmlBody);
                            
                            //System.debug('RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c-->'+RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c);
                            cv.Title = ProviderName+ ' '+RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c;
                            cv.PathOnClient = ProviderName+ ' '+RecredRec.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c+'.pdf';
                            cv.VersionData = letterBody;
                            cv.IsMajorVersion = true;
                            cvlist.add(cv);
                            cvFVCLlist.add(cv);
                            
                        }    // FVCL Template - End
                    }
                //} 
            }
            
            try{ 
         //Insert FPA Records
                insert cvFPAlist;
                SET<ID> cvFPAids = new SET<ID>();
                for(ContentVersion fpaId : cvFPAlist){
                    cvFPAids.add(fpaId.id);
                }
                FPAN_FutureInsertContentDocumentLink.ReCredFPAInsertCDL(cvFPAids);
                //Insert FVCL Records
                insert cvFVCLlist;
                SET<ID> cvFVCLids = new SET<ID>();
                for(ContentVersion fvclId : cvFVCLlist){
                    cvFVCLids.add(fvclId.id);
                }
             FPAN_FutureInsertContentDocumentLink.ReCredFVCLInsertCDL(cvFVCLids);
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
                
                'ReCredentialing letters were generated in accordance with your request. Please use the URL provided below.<br/><br/>'+
                '<html><a href="https://mhealthfairviewfpan.my.salesforce.com/sfc/#search">CLICK HERE</a><html><br/><br/>'+
            'Thank you!  <br/><br/>';
            email.setHtmlBody(content);
            email.setToAddresses(getMailAddresses());
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        System.debug('Messaging.SendEmailResult-->'+r);
        
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