Public class FPAN_CreateProvideContactHandler{
    Public static Boolean firstcall=true;
    Public static Boolean beforeupdatecall=true; 
    Public static void createprovidercontact(List<Account> accounts){
        List<Contact> ContactList = New List<Contact>();
        List<Account> AccountList = New List<Account>();
        Id RecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        System.debug('@@@@RecordType'+RecordType);
        System.debug('@@@@accounts'+accounts);
        for(Account acc : accounts){
            //if(acc.RecordTypeId <> '0124x000000A5oKAAS'){ // if no RecordTypeId is found present error message
            if(acc.RecordTypeId <> RecordType){               
                continue;
            } //closes if statement
            
            // Changed Code to match Account Name format. - 20/Apr/2022 - Ravi Kumar
            contact con = new contact();
            con.AccountID = acc.ID;
            con.FirstName = acc.FPAN_First_Name__c; 
            //con.MiddleName = acc.FPAN_Title__c +' '+ acc.FPAN_First_Name__c;
            con.MiddleName = acc.FPAN_MI__c;
            con.Title = acc.FPAN_Title__c;
            con.Email = acc.FPAN_Provider_Business_Email__c;
            con.Birthdate = acc.FPAN_DOB__c;
            con.FPAN_Primary__c = TRUE;
            con.phone = acc.phone;
            con.vlocity_ins__IsActive__c = TRUE;
            con.LastName = acc.FPAN_Last_Name__c +' '+acc.FPAN_Title__c;     
            con.vlocity_ins__Status__c = acc.FPAN_Provider_Status__c;
            ContactList.add(con); 
            
        }
        IF(ContactList.size()>0){
            try{
                Insert ContactList;
            }catch(Exception e){
                FPAN_APEX_HandleSystemException.LogException(e);
            }
            
        }
        
        List<Contact> ConList = New List<Contact>([Select ID,Name,AccountID,Account.RecordTypeId From Contact Where ID IN: ContactList]); 
        
        System.debug('@@@ConList'+ConList);
        List<Account> aclist = New List<Account>([Select ID,Name,RecordTypeId,vlocity_ins__PersonContactId__c,FPAN_ProviderContactCount__c From Account Where Id IN: accounts]);
        //if(aclist[0].RecordTypeId == '0124x000000A5oKAAS'){
        if(aclist.size()>0){
            if(aclist[0].RecordTypeId == RecordType){
                for(Account a : aclist){
                    for(Contact c : ConList)
                        if(c.AccountID == a.ID){
                            a.vlocity_ins__PersonContactId__c = c.ID;
                            a.FPAN_ProviderContactCount__c = 1;
                            AccountList.add(a);
                        }
                }
                try{
                    Update AccountList;
                }catch(Exception e){
                    System.debug('@@@AccountList'+AccountList); 
                    FPAN_APEX_HandleSystemException.LogException(e);
                }
                
            }
        }
    }
    
    // This method is for updating the contacts whenever Account details get changed/modified.
    Public static void updateprovidercontact(List<Account> accounts,map<id,account> oldmap){
        
        System.debug('Inside Updateaccount-->'+accounts);
        List<Contact> ContactList = new List<Contact>(); 
        Id AccountId;
        String firstname;
        String MName;
        String lastname;
        String middlename;
        String title;
        String email;
        Date dob;
        String phone;
        String Status;
        //set<id> accountIds=new set<id>();
        for(Account accRec: accounts){
            
            account accountOld=oldmap.get(accRec.id);
            if(accRec.FPAN_First_Name__c!=accountOld.FPAN_First_Name__c || accRec.FPAN_Last_Name__c!=accountOld.FPAN_Last_Name__c || 
               accRec.FPAN_MI__c!=accountOld.FPAN_MI__c || accRec.FPAN_Title__c!=accountOld.FPAN_Title__c || accRec.FPAN_Provider_Business_Email__c!=accountOld.FPAN_Provider_Business_Email__c ||
               accRec.FPAN_DOB__c!=accountOld.FPAN_DOB__c || accRec.phone!=accountOld.phone 
               || accRec.FPAN_Provider_Status__c!=accountOld.FPAN_Provider_Status__c               )
            {
                //accountIds.add(accRec.Id);
                AccountId = accRec.Id; 
                firstname = accRec.FPAN_First_Name__c; 
                //MName = accRec.FPAN_MI__c;    
                lastname = accRec.FPAN_Last_Name__c;
                middlename = accRec.FPAN_MI__c;
                title = accRec.FPAN_Title__c;
                email = accRec.FPAN_Provider_Business_Email__c;
                dob = accRec.FPAN_DOB__c;
                phone = accRec.phone;
                Status = accRec.FPAN_Provider_Status__c;
            }
        }
        System.debug('AccountId==>'+AccountId);
        if(AccountId<>null){
            list<Contact> ContactRecs = [Select id,name,accountid,firstname,lastname,middlename,title,email,phone,vlocity_ins__Status__c from Contact where AccountId = :AccountId and account.recordtype.Name = 'Provider'];
            
            for(Contact con : ContactRecs){
                con.FirstName = firstname;
                con.MiddleName = middlename;
                con.Lastname = lastname +' '+title;
                con.Title = title;
                con.Email = email;
                con.Birthdate = dob;
                con.phone = phone;
                con.vlocity_ins__Status__c = Status;
                
                //  con.LastName =  lastname ; 
                
                ContactList.add(con); 
                
            }
            If(ContactList.size()>0){
                try{
                    update ContactList;
                }catch(exception e){
                    FPAN_APEX_HandleSystemException.LogException(e);
                    System.debug('Exception==>'+e);
                    
                }
            }
            
        }
        
    }
    
    //US 1575: Updating the account name to its related objects- Sreeni
    public static void updatedAccountName(List<Account> accList){
        
        Map<Id,String> accMap = new Map<Id,String>();
        SET<Id> accIds = new SET<Id>();
        for(Account accRec: accList){
            accMap.put(accRec.Id,accRec.Name);
            accIds.add(accRec.id);
        }
        
        List<vlocity_ins__ProviderNetwork__c> credentialingList = [Select id,name,FPAN_Provider_Account__c,FPAN_Provider_Account__r.name,FPAN_Provider_Account__r.FPAN_First_Name__c,FPAN_Provider_Account__r.FPAN_Last_Name__c from vlocity_ins__ProviderNetwork__c where FPAN_Provider_Account__c IN :accIds];
        List<vlocity_ins__ProviderNetwork__c> toupdatecredentialingList = new List<vlocity_ins__ProviderNetwork__c>(); 
        if(credentialingList.size()>0){
            for(vlocity_ins__ProviderNetwork__c cred: credentialingList){
                //cred.Name = cred.FPAN_Provider_Account__r.name;
                cred.Name = cred.FPAN_Provider_Account__r.FPAN_First_Name__c+' '+cred.FPAN_Provider_Account__r.FPAN_Last_Name__c;                
                toupdatecredentialingList.add(cred);                
            }
            
                update toupdatecredentialingList;
            
            
            
        }
        List<vlocity_ins__ProviderNetworkMember__c> recredList = [Select Id,name,vlocity_ins__ProviderNetworkId__r.FPAN_Provider_Account__r.Name from vlocity_ins__ProviderNetworkMember__c where vlocity_ins__ProviderNetworkId__r.FPAN_Provider_Account__c IN :accIds];
        List<vlocity_ins__ProviderNetworkMember__c> toUpdaterecredList = new List<vlocity_ins__ProviderNetworkMember__c>();
        if(recredList.size()>0){
            for(vlocity_ins__ProviderNetworkMember__c recred : recredList){
                recred.name = recred.vlocity_ins__ProviderNetworkId__r.FPAN_Provider_Account__r.Name;
                toUpdaterecredList.add(recred);
            }
            
            Update toUpdaterecredList; 
            
            
        }
        
        List<HealthcarePractitionerFacility> toUpdatePF = new List<HealthcarePractitionerFacility>();
        List<HealthcarePractitionerFacility> pflist =[Select id,Name, FPAN_Practice_Name__c from HealthcarePractitionerFacility where FPAN_Practice_Name__c IN :accIds];
        system.debug('@@@@pflist'+ pflist);
        for(HealthcarePractitionerFacility pfRec: pflist){
            pfRec.Name = accMap.get(pfRec.FPAN_Practice_Name__c);
            system.debug('@@@@FPAN Practice Name'+ accMap.get(pfRec.FPAN_Practice_Name__c));
            toUpdatePF.add(pfRec);
        }
        
            if(toUpdatePF.size()>0){ 
                Update toUpdatePF;
            }
        
        
    }
    
    //SR: RITM1084550 - Provider Facility Name update under Provider Account - Santosh
    public static void updatedProviderFacilityName(List<Account> accIdSet){
        
        Map<Id,String> accMap = new Map<Id,String>();
        SET<Id> accIds = new SET<Id>();
        for(Account accRec: accIdSet){
            accMap.put(accRec.Id,accRec.Name);
            accIds.add(accRec.id);
        }
        List<HealthcarePractitionerFacility> toUpdatePF = new List<HealthcarePractitionerFacility>();
        List<HealthcarePractitionerFacility> pflist =[Select id,Name, FPAN_Practice_Name__c from HealthcarePractitionerFacility where FPAN_Practice_Name__c IN :accIds];
        
        for(HealthcarePractitionerFacility pfRec: pflist){
            pfRec.Name = accMap.get(pfRec.FPAN_Practice_Name__c);
           
            toUpdatePF.add(pfRec);
        }
        
            if(toUpdatePF.size()>0){ 
                Update toUpdatePF;
            }
        
    }
    
    
    
    //Process Builder - PrePopulateAccountName- ProviderNew--->Replacement- Sreeni
    public static void beforeAccountName(List<Account> accList){    
        system.debug('Inside beforeAccountName-->'+accList);
        beforeupdatecall = false;
        Id ProviderRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        Id PracticeRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        
        for(Account acc : accList){
            if(acc.RecordTypeId == ProviderRTId){
                String firstname='';
                String miname='';
                String LastName='';
                String title='';
                if(acc.FPAN_First_Name__c !=null){
                    firstname = acc.FPAN_First_Name__c;
                }
                if(acc.FPAN_MI__c !=null){
                    miname = acc.FPAN_MI__c;
                }
                if(acc.FPAN_Last_Name__c !=null){
                    LastName = acc.FPAN_Last_Name__c;
                }
                if(acc.FPAN_Title__c !=null){
                    title = acc.FPAN_Title__c;
                }
                
                acc.name = firstname+' '+miname +' '+LastName +' '+title;
                system.debug('Account Name-->'+acc.name);
                
            }
            if(acc.RecordTypeId == PracticeRTId){
                if(acc.FPAN_Billing_Name__c == NULL){
                    acc.FPAN_Billing_Name__c = acc.Name;
                }
            }
        }
    }
}