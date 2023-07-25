/**************************************************************************************************
* Name : FPAN_Trigger_AssociatedLocation
* Author : Sreeni B
* Date : 28/Dec/2021
* Desc : This trigger is to check existing records for validating any primary records for Practice
****************************************************************************************************/
trigger FPAN_Trigger_AssociatedLocation on AssociatedLocation (before insert,before update,before delete,after insert,after update,after delete) {
    If(trigger.IsBefore){ 
        if(trigger.IsInsert || trigger.IsUpdate) {
            SET<ID> accountid = new SET<ID>();
            SET<String> loadMainsites = new SET<String>();
            SET<String> loadAdminsites = new SET<String>();
            SET<String> loadbillingsite = new SET<String>();
            SET<String> loadadminpracticesite = new SET<String>();
            SET<String> loadProviderMailsite = new SET<String>();
            
            Boolean mainsite = false;
            Boolean adminSite = false;
            Boolean billingsite = false;
            Boolean adminpracticesite = false;
            Boolean providermailsite = false;
            Boolean dupLoc = false;
            
            String mainsiteErr = 'Main Site is already available for this Account ';
            String adminSiteErr = 'Admin Site is already available for this Account ';
            String billingsiteErr = 'Billing Site is already available for this Account ';
            String adminpracticesiteErr = 'Main Practice Site is already available for this Account ';
            String providermailsiteErr = 'Provider Mail Site is already available for this Account ';
            
            for(AssociatedLocation al : Trigger.new){
                accountid.add(al.ParentRecordId);
            }
            List<AssociatedLocation> accrelatedALs = [Select id,ParentRecordId,LocationId,FPAN_Admin_Site__c,FPAN_FPA_Main_Site__c,FPAN_Provider_Mail_Site__c,FPAN_Billing_Site__c,FPAN_Provider_PCC__c,FPAN_Directory_Print__c,FPAN_Main_Practice_Site__c,FPAN_Practice_Site__c,FPAN_Provider_Site_Directory__c from AssociatedLocation where ParentRecordId IN :accountid];
            system.debug('accrelatedALs--->' +accrelatedALs);	
            
            If(trigger.IsInsert){ 
                if(accrelatedALs.size()>0){
                    for(AssociatedLocation Aal : accrelatedALs){ // Checking if there is an existing true value for the record's fields
                        if(Aal.FPAN_FPA_Main_Site__c == true ){
                            mainsite = true;
                        }     
                        if(Aal.FPAN_Admin_Site__c == true ){
                            adminSite = true;
                        }
                        if(Aal.FPAN_Billing_Site__c == true ){
                            billingsite = true;
                        } 
                        if(Aal.FPAN_Main_Practice_Site__c == true ){
                            adminpracticesite = true;
                        } 
                        if(Aal.FPAN_Provider_Mail_Site__c == true ){
                            providermailsite = true;
                        } 
                    }
                    for(AssociatedLocation aslcn : Trigger.new){ //Comparing the old records with new records fields.
                        
                        if(mainsite == true && aslcn.FPAN_FPA_Main_Site__c == true){
                            aslcn.addError(mainsiteErr);
                            
                        }
                        if(adminSite == true && aslcn.FPAN_Admin_Site__c == true){
                            aslcn.addError(adminSiteErr);
                            
                        }
                        if(billingsite == true && aslcn.FPAN_Billing_Site__c == true){
                            aslcn.addError(billingsiteErr);
                            
                        }
                        if(adminpracticesite == true && aslcn.FPAN_Main_Practice_Site__c == true){
                            aslcn.addError(adminpracticesiteErr);
                            
                        }
                        if(providermailsite == true && aslcn.FPAN_Provider_Mail_Site__c == true){
                            aslcn.addError(providermailsiteErr);
                            
                        }
                    }
                }else{
                    for(AssociatedLocation aslc : Trigger.new){
                        if(aslc.FPAN_FPA_Main_Site__c == true){
                            String fma = String.valueOf(aslc.FPAN_FPA_Main_Site__c)+String.valueOf(aslc.ParentRecordId);                        
                            if(loadMainsites.contains(fma)){
                                aslc.addError(mainsiteErr);
                                
                            }else{
                                loadMainsites.add(fma);
                            }
                        }   
                        if(aslc.FPAN_Admin_Site__c == true){
                            String fma = String.valueOf(aslc.FPAN_Admin_Site__c)+String.valueOf(aslc.ParentRecordId);                        
                            if(loadAdminsites.contains(fma)){
                                aslc.addError(adminSiteErr);
                                
                            }else{
                                loadAdminsites.add(fma);
                            }
                        } 
                        
                        if(aslc.FPAN_Billing_Site__c == true){
                            String fma = String.valueOf(aslc.FPAN_Billing_Site__c)+String.valueOf(aslc.ParentRecordId);                        
                            if(loadbillingsite.contains(fma)){
                                aslc.addError(billingsiteErr);
                                
                            }else{
                                loadbillingsite.add(fma);
                            }
                        }
                        if(aslc.FPAN_Main_Practice_Site__c == true){
                            String fma = String.valueOf(aslc.FPAN_Main_Practice_Site__c)+String.valueOf(aslc.ParentRecordId);                        
                            if(loadadminpracticesite.contains(fma)){
                                aslc.addError(adminpracticesiteErr);
                                
                            }else{
                                loadadminpracticesite.add(fma);
                            }
                        }
                        if(aslc.FPAN_Provider_Mail_Site__c == true){
                            String fma = String.valueOf(aslc.FPAN_Provider_Mail_Site__c)+String.valueOf(aslc.ParentRecordId);                        
                            if(loadProviderMailsite.contains(fma)){
                                aslc.addError(providermailsiteErr);
                                
                            }else{
                                loadProviderMailsite.add(fma);
                            }
                        }
                    }
                }
                
                //Before Insert to check for any duplicate location association for both provider and practice
        		//Gaana: Added below code for M3 Module - US 2344 & 2345
                FPANCheckDuplicateLocation.CheckDuplicateForProvider(trigger.new);
            }
            If(trigger.IsUpdate){
                for(AssociatedLocation Aal : accrelatedALs){
                    AssociatedLocation oldAL = Trigger.oldMap.get(trigger.new[0].ID);
                    if(!oldAL.FPAN_FPA_Main_Site__c == true && Aal.FPAN_FPA_Main_Site__c == true ){
                        mainsite = true;
                    }
                    if(!oldAL.FPAN_Admin_Site__c == true && Aal.FPAN_Admin_Site__c == true ){
                        adminSite = true;
                    }
                    if(!oldAL.FPAN_Billing_Site__c == true && Aal.FPAN_Billing_Site__c == true ){
                        billingsite = true;
                    }
                    if(!oldAL.FPAN_Main_Practice_Site__c == true && Aal.FPAN_Main_Practice_Site__c == true ){
                        adminpracticesite = true;
                    }
                    if(!oldAL.FPAN_Provider_Mail_Site__c == true && Aal.FPAN_Provider_Mail_Site__c == true ){
                        providermailsite = true;
                    }
                }
                for(AssociatedLocation asloc : Trigger.new){
                    if(mainsite == true && asloc.FPAN_FPA_Main_Site__c == true){
                        asloc.addError(mainsiteErr);
                    }
                    if(adminsite == true && asloc.FPAN_Admin_Site__c == true){
                        asloc.addError(adminSiteErr);
                    }
                    if(billingsite == true && asloc.FPAN_Billing_Site__c == true){
                        asloc.addError(billingsiteErr);
                    }
                    if(adminpracticesite == true && asloc.FPAN_Main_Practice_Site__c == true){
                        asloc.addError(adminpracticesiteErr);
                    } 
                    if(providermailsite == true && asloc.FPAN_Provider_Mail_Site__c == true){
                        asloc.addError(providermailsiteErr);
                    }
                    
                    //Before Update to check for any duplicate location association for both provider and practice
        			//Gaana: Added below code for M3 Module - US 2344 & 2345
                    AssociatedLocation oldAssLoc = Trigger.oldMap.get(asloc.ID);
                    if(asloc.LocationId != oldAssLoc.LocationId) {
                        FPANCheckDuplicateLocation.CheckDuplicateForProvider(trigger.new);
                    }
                }  
            }
        }
		   If(trigger.IsDelete){
        Id profileId = UserInfo.getProfileId();
        //String pfname = [Select id,name from Profile where id = :profileId].Name;        
		String pfname = '';
        List<Profile> pfnameList = [Select id,name from Profile where id = :profileId limit 1];
        system.debug('@@@pfname'+pfname);
        For(Profile p : pfnameList){
            pfname = p.Name;
        }
        IF(pfname!=NULL){
        for(AssociatedLocation acc : trigger.old){            
            if(pfname == 'FPAN Agent' || pfname == 'FPAN Agent Credentialing'){
                acc.addError('You are not authorized to delete this Record!');
            }
           
          }
        }
	  }
    }
    //After Insert and Update for mapping location address to contact address 
    if(trigger.IsAfter){
        
        //Bheema: Added below code for M2 Module - US 1562:
        if(trigger.isInsert){
            //FPANUpdatePFParentPrimaryFlag.OnAfterInsert(Trigger.new);
            FPAN_HPF_PrimaryFacilityUpdate.OnAfterInsert(Trigger.newMap);
            FPAN_AssociatedLocationCntlr.maintainconAddress(trigger.new);
            FPANCheckIfPracticeLocIsAssociated.OnAfterInsert(Trigger.new);  
            FPAN_Apex_AssociatedLocationCloned.createCloneALocation(Trigger.new);
        }
        
        else if(trigger.isUpdate){
            //FPANUpdatePFParentPrimaryFlag.OnAfterUpdate(Trigger.new);
            FPAN_HPF_PrimaryFacilityUpdate.OnAfterUpdateUncheck(Trigger.oldMap, Trigger.newMap);
            FPAN_HPF_PrimaryFacilityUpdate.OnAfterUpdateCheck(Trigger.oldMap, Trigger.newMap);     
            FPAN_AssociatedLocationCntlr.maintainconAddress(trigger.new);
            FPANCheckIfPracticeLocIsAssociated.OnAfterUpdate(Trigger.new);
            FPAN_Apex_AssociatedLocationCloned.updateCloneALocation(Trigger.new);
        }
        
        else if(trigger.isDelete){
            //FPANUpdatePFParentPrimaryFlag.OnAfterDelete(Trigger.old);
            FPAN_HPF_PrimaryFacilityUpdate.OnAfterDelete(Trigger.oldMap); 
            FPAN_Apex_AssociatedLocationCloned.deleteClonedALocation(Trigger.old);
        }
    }
      
}