/************************************************************************
* Name : FPAN_CreateProvideContact
* Author : Ravi Kumar
* Date : 22/Dec/2021
* Desc : Contact to be created automatically for Provider Account Records
*************************************************************************/
trigger FPAN_CreateProvideContact on Account (before insert, before update,after insert, after Update) {
    Id ProviderRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId(); 
    Id PracticeRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();   

    Id userId = UserInfo.getUserId();  
    //if(!Test.isRunningTest()){
    /*String currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId].name; 
    system.debug('@@@currentUser----->'+currentUser);
    String UserName = Label.FPAN_IntegrationUserId;*/
    String currentUser;
    if(!Test.isRunningTest()){
        currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId Limit 1].name; 
        String UserName = Label.FPAN_IntegrationUserId;
    if(currentUser == UserName ){
        If(trigger.isInsert && trigger.isbefore){
            for(Account acc:Trigger.New){  
                acc.RecordtypeId = ProviderRTId ;      
                
            }
        }
    }
    }else{
    currentUser = Label.FPAN_IntegrationUserId;
        String UserName = Label.FPAN_IntegrationUserId;
    if(currentUser == UserName ){
        If(trigger.isInsert && trigger.isbefore){
            for(Account acc:Trigger.New){  
                      
                System.debug(acc.RecordtypeId+'==>'+ProviderRTId);
            }
        }
    }
    }
       
        
    If(trigger.isBefore){ //Process Builder - PrePopulateAccountName- ProviderNew--->Replacement
        //if(FPAN_CreateProvideContactHandler.beforeupdatecall){
            FPAN_CreateProvideContactHandler.beforeAccountName(Trigger.New);
       // }       
    }
    If(trigger.isInsert && trigger.isAfter){
        FPAN_CreateProvideContactHandler.CreateProviderContact(Trigger.New);
    }
    If(trigger.isUpdate && trigger.isAfter){
        FPAN_CreateProvideContactHandler.updateprovidercontact(trigger.new,trigger.oldmap);
        //Start--US 1575: Updating the account name to its related objects- Sreeni
        List<Account> accnts = new List<Account>();
        List<Account> PracticeAccnts = new List<Account>();
        Set<Id> accIdSet = new SET<ID>();
               for (Account acc: Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(acc.ID);
            if(acc.RecordTypeId == ProviderRTId){
                if(acc.name != oldAccount.name){               
                    accnts.add(acc);
                    accIdSet.add(acc.id);
                }
            }
            else{
                if(acc.name != oldAccount.name && acc.RecordTypeId == PracticeRTId){               
                    PracticeAccnts.add(acc);
                }            
            }
        }
        if(accnts.size()>0){
            if(FPAN_CreateProvideContactHandler.firstcall){   
                FPAN_CreateProvideContactHandler.updatedAccountName(accnts);  
                FPAN_CreateProvideContactHandler.firstcall = false;
            }
        }
        if(PracticeAccnts.size()>0){
            if(FPAN_CreateProvideContactHandler.firstcall){      
                FPAN_CreateProvideContactHandler.updatedProviderFacilityName(PracticeAccnts);   
                FPAN_CreateProvideContactHandler.firstcall = false;
            }
        }
        //End--US 1575: Updating the account name to its related objects- Sreeni
    }
    //Below trigger is to validate duplicate npi
    if(Trigger.isBefore){
        if(trigger.IsUpdate){
            for(Account acc : Trigger.New) { 
               
                Account oldAccount = Trigger.OldMap.get(acc.id);
                
                if(acc.FPAN_Provider_NPI__c != oldAccount.FPAN_Provider_NPI__c)
                {
                    
                    FPAN_Apex_DuplicateNpiValidationHandler.DuplicateNpiValidation(Trigger.New , Trigger.OldMap);
                }
            }
        }
        
        if(trigger.Isinsert){
            FPAN_Apex_DuplicateNpiValidationHandler.DuplicateNpiValidationInsert(Trigger.New);
        }
    }
}