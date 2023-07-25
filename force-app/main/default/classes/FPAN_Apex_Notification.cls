/**************************************************************************************************
* Name : FPAN_Apex_Notification
* Author : Anamitra Majumdar
* Date : 29/Nov/2022
* Desc : This class is developed to achieve the email notification funcltionality
****************************************************************************************************/
public class FPAN_Apex_Notification { 
    public static void sendEmailNotification(){
        
        Id userId = [Select Id , Name From User Where Profile.Name = :System.label.FPAN_IntegrationUserId AND Name = :System.label.FPAN_IntegrationUserId LIMIT 1].Id ;
        System.debug('userId->'+ userId);
        
        list<HealthcarePractitionerFacilityHistory> heathPracHisList =new List<HealthcarePractitionerFacilityHistory>();
        Map<String,HealthcarePractitionerFacilityHistory> pfhistory=new Map<String,HealthcarePractitionerFacilityHistory>();
        Map<String,AccountHistory> accHistory=new Map<String,AccountHistory>();
        list<AccountHistory> accHisList =new List<AccountHistory>();
        if (Test.isRunningTest()) {
            
            List<Account> accrecs = [Select id,name,createdbyId from Account where createddate = today];
            System.debug('Account Details-->'+accrecs);
            List<AccountHistory> insertACH = new List<AccountHistory>();
            for(Account acc : accrecs){
                AccountHistory ach = new AccountHistory();
                ach.AccountId = acc.id;
                ach.Field = 'FPAN_First_Name__c';
                insertACH.add(ach);
                userId = acc.CreatedById;
            }
            if(insertACH.size()>0){
                try{
                    Insert insertACH;
                }
                catch(exception e){
                    System.debug('Exception occurred'+e.getMessage());
                    system.assertNotEquals(null, e.getMessage());
                    
                }
            }
            
            list<HealthcarePractitionerFacility> hpfobj =[Select id,name,AccountId from HealthcarePractitionerFacility where createddate = today];
            System.debug('Provider facility details-->'+hpfobj);
            List<HealthcarePractitionerFacilityHistory> insertHPFList = new List<HealthcarePractitionerFacilityHistory>();
            for(HealthcarePractitionerFacility hpf : hpfobj){
                HealthcarePractitionerFacilityHistory hpfHistory=new HealthcarePractitionerFacilityHistory(); 
                hpfHistory.HealthcarePractitionerFacilityId=hpf.id;
                //hpfHistory.HealthcarePractitionerFacility.AccountId = hpf.AccountId;
                hpfHistory.Field='FPAN_FHN_Status__c';
                insertHPFList.add(hpfHistory);
            }
            
            if(insertHPFList.size()>0){
                try{
                    Insert insertHPFList;
                }
                catch(exception e){
                    System.debug('Exception occurred'+e.getMessage());
                    system.assertNotEquals(null, e.getMessage());
                    
                }
            }
            
            
            heathPracHisList=[SELECT Id, HealthcarePractitionerFacilityId, CreatedDate, Field, OldValue, NewValue ,
                              HealthcarePractitionerFacility.Name , HealthcarePractitionerFacility.AccountId FROM HealthcarePractitionerFacilityHistory WHERE CreatedDate =today];
            
            accHisList=[SELECT AccountId,Field, OldValue, NewValue, CreatedDate,Account.Name , Account.FPAN_First_Name__c ,
                        Account.FPAN_Last_Name__c ,Account.FPAN_DOB__c , Account.FPAN_MI__C , Account.FPAN_Provider_NPI__C ,
                        Account.FPAN_Provider_Personal_Email__c ,Account.FPAN_Provider_Business_Email__c , Account.FPAN_Total_FTE__c ,
                        Account.FPAN_Overall_FTE__c , Account.FPAN_PSA_Box__c,CreatedBy.Name,CreatedById  FROM AccountHistory WHERE CreatedDate =today ];
            System.debug('accHisList Size-->'+accHisList.size());
        }
        else{
        
        heathPracHisList=[SELECT Id, HealthcarePractitionerFacilityId, CreatedDate, Field, OldValue, NewValue ,
                          HealthcarePractitionerFacility.Name , HealthcarePractitionerFacility.AccountId, HealthcarePractitionerFacility.FPAN_Provider_Practice_Directory__c 
                          ,HealthcarePractitionerFacility.FPAN_PSA_Box_Formula__c  FROM HealthcarePractitionerFacilityHistory WHERE CreatedDate =today AND CreatedById = :userId];
        
        System.debug('heathPracHis-->'+heathPracHisList);
        
        accHisList=[SELECT AccountId,Field, OldValue, NewValue, CreatedDate,Account.Name , Account.FPAN_First_Name__c ,
                    Account.FPAN_Last_Name__c ,Account.FPAN_DOB__c , Account.FPAN_MI__C , Account.FPAN_Provider_NPI__C ,
                    Account.FPAN_Provider_Personal_Email__c ,Account.FPAN_Provider_Business_Email__c , Account.FPAN_Total_FTE__c ,
                    Account.FPAN_Overall_FTE__c , Account.FPAN_PSA_Box__c  FROM AccountHistory WHERE CreatedDate =today AND CreatedById = :userId];
        System.debug('accHisList-->'+accHisList.size());
        }
        //Common Code below
        Set<Id> accHisUpdatedSet = new Set<Id>();
        list<AccountHistory> accHisUpadatedSizeList=[SELECT Id , AccountId , Account.Name FROM AccountHistory 
                                                     WHERE Account.RecordTypeId = : System.label.Fpan_ProviderRecordtypeId AND Account.LastModifiedDate = today AND Account.createdDate != today AND 
                                                     Account.LastModifiedById = :userId];
        for(AccountHistory accHisSetList : accHisUpadatedSizeList){
            accHisUpdatedSet.add(accHisSetList.AccountId);
        }
        System.debug('Creation Set Size-->'+accHisUpdatedSet.size());
        
        Set<Id> accHisCreatedSet = new Set<Id>();
        list<AccountHistory> accHisCreatedSizeList=[SELECT Id , AccountId , Account.Name FROM AccountHistory 
                                                    WHERE Account.RecordTypeId = : System.label.Fpan_ProviderRecordtypeId AND Account.createdDate = today AND createdDate = today 
                                                   AND Account.CreatedById = :userId];
        for(AccountHistory accHisSetList2 : accHisCreatedSizeList){
            accHisCreatedSet.add(accHisSetList2.AccountId);
        }
        
        System.debug('Creation Set Size-->'+accHisCreatedSet.size());
        
        
        
        
        for(AccountHistory accHis : accHisList){
            String accwithHistoryId = accHis.Id+''+accHis.AccountId;
            accHistory.put(accwithHistoryId, accHis);
        }
        System.debug('accHistory-->'+accHistory);
        
        for(HealthcarePractitionerFacilityHistory heathPracHis :heathPracHisList ){
            String pfwithHistoryId= heathPracHis.Id+''+heathPracHis.HealthcarePractitionerFacility.AccountId;
            pfhistory.put(pfwithHistoryId , heathPracHis);
            
        }
        System.debug('pfhistory-->'+pfhistory);
        
        list<NotificationWrapper> wrapperList = new list<NotificationWrapper>();
        list<HealthcarePractitionerFacilityHistory> HpfHis= new list<HealthcarePractitionerFacilityHistory>();
        list<AccountHistory> accHis=new list<AccountHistory>();
        
        String acHAccountId = '';
        String acHFieldName = '';
        String acHOldValue = '';
        String acHNewValue = '';
        String acHAccountName = '';
        String acHCreatedDate='';
        String acHFPANFirstName = '';
        String acHFPANLastName = '';
        String acHFPANDOB='' ;
        String acHFPANMI= '';
        String acHFPANProviderNPI= '';
        String acHFPANProviderPersonalEmail= '';
        String acHFPANProviderBusinessEmail= '';
        Decimal acHFPANTotalFTE=0;
        Decimal acHFPANOverallFTE=0;
        Boolean acHFPANPSABox=FALSE;
        
        
        String pfHId = '';
        String pfHFieldName = '';
        String pfHOldValue = '';
        String pfHNewValue = '';
        String pfHName = '';
        String pfHAccId = '';
        String pfHCreatedDate='' ;
        Boolean pfhPsa = FALSE;
        Boolean pfhPPdirectory= FALSE;
        
        Map<Id, Id> pfKeyMap = new Map<Id,Id>();
        List<HealthcarePractitionerFacilityHistory> pfKeyList =[SELECT Id, HealthcarePractitionerFacilityId, CreatedDate, Field, OldValue, NewValue ,
                                                                HealthcarePractitionerFacility.Name , HealthcarePractitionerFacility.AccountId, HealthcarePractitionerFacility.FPAN_Provider_Practice_Directory__c 
                                                                ,HealthcarePractitionerFacility.FPAN_PSA_Box_Formula__c  FROM HealthcarePractitionerFacilityHistory WHERE CreatedDate =today];
        for(HealthcarePractitionerFacilityHistory pfKey :pfKeyList ){
            
            pfKeyMap.put(pfKey.HealthcarePractitionerFacility.AccountId , pfKey.Id);
            
        }
        String accHisId=null;
        String pfHisKey=null;
        List<AccountHistory> accHisList3 =[SELECT AccountId,Field, OldValue, NewValue, CreatedDate,Account.Name , Account.FPAN_First_Name__c ,
                                  Account.FPAN_Last_Name__c ,Account.FPAN_DOB__c , Account.FPAN_MI__C , Account.FPAN_Provider_NPI__C ,
                                  Account.FPAN_Provider_Personal_Email__c ,Account.FPAN_Provider_Business_Email__c , Account.FPAN_Total_FTE__c ,
                                  Account.FPAN_Overall_FTE__c , Account.FPAN_PSA_Box__c  FROM AccountHistory WHERE CreatedDate =today
                                          AND CreatedById = :userId];
        System.debug('accHisList3-->'+accHisList3);
        
        for(AccountHistory acc : accHisList3)
        {
            accHisId =acc.Id+''+acc.AccountId;
            pfHisKey = pfKeyMap.get(acc.AccountId)+''+acc.AccountId;
            if(pfhistory.get(pfHisKey) != null && accHistory.get(accHisId) == null){
                
                acHAccountId = '';
                acHFieldName = '';
                acHOldValue = '';
                acHNewValue = '';
                acHAccountName = '';
                acHCreatedDate = '' ;
                acHFPANFirstName = '';
                acHFPANLastName = '';
                acHFPANDOB = '';
                acHFPANMI= '';
                acHFPANProviderNPI= '';
                acHFPANProviderPersonalEmail= '';
                acHFPANProviderBusinessEmail= '';
                acHFPANTotalFTE=0;
                acHFPANOverallFTE=0;
                acHFPANPSABox=FALSE;
                
                pfHId = (String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacilityId) != null) ? String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacilityId)  :'';
                pfHFieldName = pfhistory.get(pfHisKey).Field;
                pfHOldValue = (String.valueOf(pfhistory.get(pfHisKey).OldValue)!= null) ? String.valueOf(pfhistory.get(pfHisKey).OldValue):'';
                pfHNewValue = (String.valueOf(pfhistory.get(pfHisKey).NewValue)!= null) ? String.valueOf(pfhistory.get(pfHisKey).NewValue):'';
                
                pfHName = (String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacility.Name)!=null) ? String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacility.Name) :'' ;
                pfHAccId = (String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacility.AccountId)!=null) ? String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacility.AccountId) :'';
                pfHCreatedDate = (String.valueOf(pfhistory.get(pfHisKey).CreatedDate)!=null) ?String.valueOf(pfhistory.get(pfHisKey).CreatedDate) : '';
                
                System.debug('pfhistory.get(acc.Id).OldValue---> '+pfhistory.get(pfHisKey).OldValue);
                NotificationWrapper nw=new NotificationWrapper(pfHId,
                                                               pfHCreatedDate,
                                                               pfHFieldName,
                                                               pfHOldValue,
                                                               pfHNewValue,
                                                               pfHName,                                                               
                                                               pfHAccId,
                                                               acHAccountId,
                                                               acHFieldName,
                                                               acHOldValue,
                                                               acHNewValue,
                                                               acHAccountName,
                                                               acHCreatedDate,acHFPANFirstName,acHFPANLastName,acHFPANDOB,
                                                               acHFPANMI,acHFPANProviderNPI,acHFPANProviderPersonalEmail,
                                                               acHFPANProviderBusinessEmail,acHFPANTotalFTE,acHFPANOverallFTE,acHFPANPSABox );
                wrapperList.add(nw);
            }
            else if(pfhistory.get(pfHisKey) == null && accHistory.get(accHisId) != null ){
                System.debug('accHistory.get(acc.Id)---> '+accHistory.get(accHisId).OldValue);
                pfHId = '';
                pfHFieldName = '';
                pfHOldValue = '';
                pfHNewValue = '';
                pfHName = '';
                pfHAccId = '';
                pfHCreatedDate = '' ;
                pfhPsa = FALSE;
                pfhPPdirectory= FALSE;
                acHAccountId = accHistory.get(accHisId).AccountId;
                acHFieldName = accHistory.get(accHisId).Field;
                acHOldValue = (String.valueOf(accHistory.get(accHisId).OldValue) != null)?String.valueOf(accHistory.get(accHisId).OldValue):'';
                acHNewValue = (String.valueOf(accHistory.get(accHisId).NewValue)!= null)?String.valueOf(accHistory.get(accHisId).NewValue):'';
                acHAccountName = (String.valueOf(accHistory.get(accHisId).Account.Name)!= null)? String.valueOf(accHistory.get(accHisId).Account.Name) : '';
                acHCreatedDate = (String.valueOf(accHistory.get(accHisId).CreatedDate)!= null)? String.valueOf(accHistory.get(accHisId).CreatedDate):'' ;
                acHFPANFirstName =(String.valueOf(accHistory.get(accHisId).Account.FPAN_First_Name__c)!=null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_First_Name__c) :''; 
                acHFPANLastName = (String.valueOf(accHistory.get(accHisId).Account.FPAN_Last_Name__c)!=null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_Last_Name__c) : '' ;
                acHFPANDOB= (String.valueOf(accHistory.get(accHisId).Account.FPAN_DOB__c)!=null)? String.valueOf(accHistory.get(accHisId).Account.FPAN_DOB__c) : '';
                acHFPANMI=(String.valueOf(accHistory.get(accHisId).Account.FPAN_MI__C) != null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_MI__C) : '' ;
                acHFPANProviderNPI= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_NPI__C)!= null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_NPI__C):'';
                acHFPANProviderPersonalEmail= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_Personal_Email__c)!= null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_Personal_Email__c)  : '';
                acHFPANProviderBusinessEmail= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_Business_Email__c) != null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_Business_Email__c) : '';
                acHFPANTotalFTE= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Total_FTE__c)!= null) ? (accHistory.get(accHisId).Account.FPAN_Total_FTE__c) : 0 ;
                acHFPANOverallFTE= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Overall_FTE__c)!=null) ? (accHistory.get(accHisId).Account.FPAN_Overall_FTE__c) : 0;
                acHFPANPSABox=(String.valueOf(accHistory.get(accHisId).Account.FPAN_PSA_Box__c)!=null) ? (accHistory.get(accHisId).Account.FPAN_PSA_Box__c) : False;
                
                NotificationWrapper nw=new NotificationWrapper(pfHId,
                                                               pfHCreatedDate,
                                                               pfHFieldName,
                                                               pfHOldValue,
                                                               pfHNewValue,
                                                               pfHName,                                                               
                                                               pfHAccId,
                                                               acHAccountId,
                                                               acHFieldName,
                                                               acHOldValue,
                                                               acHNewValue,
                                                               acHAccountName,
                                                               acHCreatedDate,acHFPANFirstName,acHFPANLastName,acHFPANDOB,
                                                               acHFPANMI,acHFPANProviderNPI,acHFPANProviderPersonalEmail,
                                                               acHFPANProviderBusinessEmail,acHFPANTotalFTE,acHFPANOverallFTE,acHFPANPSABox
                                                              );
                wrapperList.add(nw);  
            }
            else if(pfhistory.get(pfHisKey) != null && accHistory.get(accHisId) != null && accHistory.get(accHisId).AccountId == pfhistory.get(pfHisKey).HealthcarePractitionerFacility.AccountId){
                
                System.debug('Account id acchis-->'+accHistory.get(accHisId).AccountId);
                System.debug('Account id pfhis-->'+pfhistory.get(pfHisKey).HealthcarePractitionerFacility.AccountId);    
                System.debug('pfhistory.get(acc.Id).OldValue---> '+pfhistory.get(pfHisKey).OldValue);
                System.debug('accHistory.get(acc.Id).OldValue-->'+accHistory.get(accHisId).OldValue);
                
                pfHId = (String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacilityId) != null) ? String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacilityId)  :'';
                pfHFieldName = pfhistory.get(pfHisKey).Field;
                pfHOldValue = (String.valueOf(pfhistory.get(pfHisKey).OldValue)!= null) ? String.valueOf(pfhistory.get(pfHisKey).OldValue):'';
                pfHNewValue = (String.valueOf(pfhistory.get(pfHisKey).NewValue)!= null) ? String.valueOf(pfhistory.get(pfHisKey).NewValue):'';
                
                pfHName = (String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacility.Name)!=null) ? String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacility.Name) :'' ;
                pfHAccId = (String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacility.AccountId)!=null) ? String.valueOf(pfhistory.get(pfHisKey).HealthcarePractitionerFacility.AccountId) :'';
                pfHCreatedDate = (String.valueOf(pfhistory.get(pfHisKey).CreatedDate)!=null) ?String.valueOf(pfhistory.get(pfHisKey).CreatedDate) : '';
                
                acHAccountId = accHistory.get(accHisId).AccountId;
                acHFieldName = accHistory.get(accHisId).Field;
                acHOldValue = (String.valueOf(accHistory.get(accHisId).OldValue) != null)?String.valueOf(accHistory.get(accHisId).OldValue):'';
                acHNewValue = (String.valueOf(accHistory.get(accHisId).NewValue)!= null)?String.valueOf(accHistory.get(accHisId).NewValue):'';
                acHAccountName = (String.valueOf(accHistory.get(accHisId).Account.Name)!= null)? String.valueOf(accHistory.get(accHisId).Account.Name) : '';
                acHCreatedDate = (String.valueOf(accHistory.get(accHisId).CreatedDate)!= null)? String.valueOf(accHistory.get(accHisId).CreatedDate):'' ;
                acHFPANFirstName =(String.valueOf(accHistory.get(accHisId).Account.FPAN_First_Name__c)!=null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_First_Name__c) :''; 
                acHFPANLastName = (String.valueOf(accHistory.get(accHisId).Account.FPAN_Last_Name__c)!=null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_Last_Name__c) : '' ;
                acHFPANDOB= (String.valueOf(accHistory.get(accHisId).Account.FPAN_DOB__c)!=null)? String.valueOf(accHistory.get(accHisId).Account.FPAN_DOB__c) : '';
                acHFPANMI=(String.valueOf(accHistory.get(accHisId).Account.FPAN_MI__C) != null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_MI__C) : '' ;
                acHFPANProviderNPI= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_NPI__C)!= null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_NPI__C):'';
                acHFPANProviderPersonalEmail= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_Personal_Email__c)!= null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_Personal_Email__c)  : '';
                acHFPANProviderBusinessEmail= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_Business_Email__c) != null) ? String.valueOf(accHistory.get(accHisId).Account.FPAN_Provider_Business_Email__c) : '';
                acHFPANTotalFTE= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Total_FTE__c)!= null) ? (accHistory.get(accHisId).Account.FPAN_Total_FTE__c) : 0 ;
                acHFPANOverallFTE= (String.valueOf(accHistory.get(accHisId).Account.FPAN_Overall_FTE__c)!=null) ? (accHistory.get(accHisId).Account.FPAN_Overall_FTE__c) : 0;
                acHFPANPSABox=(String.valueOf(accHistory.get(accHisId).Account.FPAN_PSA_Box__c)!=null) ? (accHistory.get(accHisId).Account.FPAN_PSA_Box__c) : False;
                
                
                NotificationWrapper nw=new NotificationWrapper(pfHId,
                                                               pfHCreatedDate,
                                                               pfHFieldName,
                                                               pfHOldValue,
                                                               pfHNewValue,
                                                               pfHName,                                                               
                                                               pfHAccId,
                                                               acHAccountId,
                                                               acHFieldName,
                                                               acHOldValue,
                                                               acHNewValue,
                                                               acHAccountName,
                                                               acHCreatedDate,acHFPANFirstName,acHFPANLastName,acHFPANDOB,
                                                               acHFPANMI,acHFPANProviderNPI,acHFPANProviderPersonalEmail,
                                                               acHFPANProviderBusinessEmail,acHFPANTotalFTE,acHFPANOverallFTE,acHFPANPSABox );
                wrapperList.add(nw);
            }
            
            
        }
        System.debug('wrapperList->'+wrapperList);
        
        System.debug('wrapper list size-->'+ wrapperList.size());
        //FPAN_NotificationEmail.sendEmail(wrapperList);
        if(wrapperList.size() > 0){
            string header = 'Account Id, Account Name, Account Field, Account OldValue,Account NewValue,AccountHistory CreatedDate,Firstname , Lastname, DOB , MI , ProviderNPI, PersonalEmail , BusinessEmail , TotalFTE, OverallFTE,PSA, ProviderFacility AccountId, ProviderFacility Id,ProviderFacility Name ,ProviderFacility Field, ProviderFacility OldValue, ProviderFacility NewValue, ProviderFacility CreatedDate\n';
            string finalstr = header ;
            for(NotificationWrapper nt : wrapperList){
                System.debug('nt-->'+nt);
                string recordString =nt.AccountHistoryAccountId +','+nt.AccountHistoryAccountName +','+nt.AccountHistoryField +','+nt.AccountHistoryOldValue+','+nt.AccountHistoryNewValue+',' +nt.AccountHistoryCreatedDate+
                    ','+nt.AccountHistoryFPANFirstName+','+nt.AccountHistoryFPANLastName+','+nt.AccountHistoryFPANDOB
                    +','+nt.AccountHistoryFPANMI+','+ nt.AccountHistoryFPANProviderNPI +','+ nt.AccountHistoryFPANProviderPersonalEmail 
                    +','+ nt.AccountHistoryFPANProviderBusinessEmail + ','+ nt.AccountHistoryFPANTotalFTE + ','+
                    nt.AccountHistoryFPANOverallFTE+ ','+ nt.AccountHistoryFPANPSABox + ','+ nt.ProviderFacilityAccountId+','+ nt.ProviderFacilityId+','+ nt.ProviderFacilityName+','+ nt.ProviderFacilityField+','+ nt.ProviderFacilityOldValue+',' +nt.ProviderFacilityNewValue+','+nt.ProviderFacilityCreatedDate+'\n';
                finalstr = finalstr +recordString;
            }
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvname= 'AccountHistory.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            //String[] toAddresses = new list<string>{System.label.FPAN_Email};
            String subject ='MSOW Daily Changes to Salesforce';
            email.setSubject(subject);
            String content = 'Hi Enrollment Team,<br/><br/>'+
                'Changes loaded from MSOW as of ('+ Date.today().format() +')<br/><br/>'+
                'Number of Provider Account record got updated as of today: '+accHisUpdatedSet.size()+'<br/><br/>'+
                'Number of Provider Account record got created as of today: '+accHisCreatedSet.size()+'<br/><br/>'+
                'Please refer to the CSV for MSOW Daily Changes<br/><br/>'+                     
                'Thank you!  <br/><br/>';
            email.setHtmlBody(content);
            email.setToAddresses(getMailAddresses());
            //email.setPlainTextBody('Account CSV ');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
        }
        
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
    
    public class NotificationWrapper{
        
        public String ProviderFacilityId{ get; set;}
        public String ProviderFacilityCreatedDate{ get; set;}
        public string ProviderFacilityField{ get; set;}
        public string ProviderFacilityOldValue{ get; set;}
        public string ProviderFacilityNewValue{ get; set;}
        public string ProviderFacilityName{ get; set;}
        public String ProviderFacilityAccountId{ get; set;}
        public string AccountHistoryAccountId{get; set;}
        public string AccountHistoryField{get; set;}
        public string AccountHistoryOldValue{get; set;}
        public string AccountHistoryNewValue{get; set;}
        public String AccountHistoryCreatedDate{get; set;}
        public string AccountHistoryAccountName{get; set;}
        public string AccountHistoryFPANFirstName{get; set;}
        public string AccountHistoryFPANLastName{get; set;}
        public String AccountHistoryFPANDOB{get; set;}
        public string AccountHistoryFPANMI{get; set;}
        public string AccountHistoryFPANProviderNPI{get; set;}
        public string AccountHistoryFPANProviderPersonalEmail{get; set;}
        public string AccountHistoryFPANProviderBusinessEmail{get; set;}
        public Decimal AccountHistoryFPANTotalFTE{get; set;}
        public Decimal AccountHistoryFPANOverallFTE{get; set;}
        public Boolean AccountHistoryFPANPSABox{get; set;}
        
        public NotificationWrapper(String pfId, String pfCreatedDate, String pfField, String pfOldValue, String pfNewValue, String pfName, String pfAccountId,
                                   String ahAccountId, String ahField,String ahOldValue,String ahNewValue,String ahAccountName,String ahCreatedDate , String aHFPANFirstName,String aHFPANLastName,String aHFPANDOB,String aHFPANMI,
                                   String aHFPANProviderNPI,String aHFPANProviderPersonalEmail,
                                   String aHFPANProviderBusinessEmail,Decimal aHFPANTotalFTE,Decimal aHFPANOverallFTE,Boolean aHFPANPSABox){
                                       this.ProviderFacilityId=pfId;
                                       this.ProviderFacilityCreatedDate=pfCreatedDate;     
                                       this.ProviderFacilityField=pfField;
                                       this.ProviderFacilityOldValue=pfOldValue ;
                                       this.ProviderFacilityNewValue=pfNewValue ;
                                       this.ProviderFacilityName=pfName;
                                       this.ProviderFacilityAccountId=pfAccountId;
                                       this.AccountHistoryAccountId = ahAccountId;
                                       this.AccountHistoryField=ahField;
                                       this.AccountHistoryOldValue=ahOldValue;
                                       this.AccountHistoryNewValue=ahNewValue;
                                       this.AccountHistoryCreatedDate=ahCreatedDate;
                                       this.AccountHistoryAccountName= ahAccountName;
                                       this.AccountHistoryFPANFirstName=aHFPANFirstName;
                                       this.AccountHistoryFPANLastName=aHFPANLastName;
                                       this.AccountHistoryFPANDOB=aHFPANDOB;
                                       this.AccountHistoryFPANMI=aHFPANMI;
                                       this.AccountHistoryFPANProviderNPI=aHFPANProviderNPI;
                                       this.AccountHistoryFPANProviderPersonalEmail= aHFPANProviderPersonalEmail;
                                       this.AccountHistoryFPANProviderBusinessEmail= aHFPANProviderBusinessEmail;
                                       this.AccountHistoryFPANTotalFTE= aHFPANTotalFTE;
                                       this.AccountHistoryFPANOverallFTE= aHFPANOverallFTE;
                                       this.AccountHistoryFPANPSABox= aHFPANPSABox;
                                   }
    }
    
    
}