/**********************************************************************************************************************
* Name : FPAN_Apex_CredExtensionController
* Author : Sreeni
* Date : 24/Mar/2021
* Desc : Generate Credentialing Letters button calls this controller to create credentialing letters
* Modified By: Santosh, 28-June-2022 ---> Updated Signature Values as part of SR - RITM1011970
**********************************************************************************************************************/
public class FPAN_Apex_CredExtensionController {
    
    @AuraEnabled
    public static boolean createCredRecs(String startDate, String endDate) {
        
        Date myStartDate = Date.valueOf(startDate);
        Date myEndDate = Date.valueOf(endDate);
        List<vlocity_ins__ProviderNetwork__c> credList  = new List<vlocity_ins__ProviderNetwork__c>();
        String CredFPAId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN Credentialing FPA' LIMIT 1].Id;
        String CredFVCLId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN Credentialing FPA&FVCL' LIMIT 1].Id;
        List<ContentDocument> deleteFPAOldRecs = [SELECT Id, ParentId FROM ContentDocument where ParentId = :CredFPAId];
        List<ContentDocument> deleteFVCLOldRecs = [SELECT Id, ParentId FROM ContentDocument where ParentId = :CredFVCLId];
        credList = [Select id,FPAN_FPA__c,FPA_Member_Effective_Date__c,FPAN_FVCL__c,FPAN_Practice_Account__r.Name,FPAN_Provider_Account__c,
                    FPAN_Practice_Account__c,FPAN_FPA_C_C_A_D__c,
                    FPAN_Provider_Account__r.Name,
                    FPAN_Provider_Account__r.FPAN_Last_Name__c,
                    FPAN_Provider_Account__r.FPAN_First_Name__c,
                    FPAN_Provider_Account__r.FPAN_MI__c,
                    FPAN_Provider_Account__r.FPAN_Title__c,
                    FPAN_Provider_NPI__c,
                    FPAN_Provider_Account__r.BillingAddress, FPAN_FVCL_C_C_A_D__c,FPAN_Practice_Account__r.FPAN_FPA_Membership_Effective_Date__c from vlocity_ins__ProviderNetwork__c where 
                    (FPAN_FPA_C_C_A_D__c >= :myStartDate and FPAN_FPA_C_C_A_D__c <= :myEndDate) OR (FPAN_FVCL_C_C_A_D__c >= :myStartDate  
                                                                                                    AND FPAN_FVCL_C_C_A_D__c <= :myEndDate)];
        
        system.debug('credList size---->'+credList.size());
        
        if(credList.size()>0){
            try{
                if(deleteFPAOldRecs.size()>0){
                    system.debug('deleteFPAOldRecs-->'+deleteFPAOldRecs.size());
                    delete deleteFPAOldRecs;
                    
                }
                if(deleteFVCLOldRecs.size()>0){
                    system.debug('deleteFVCLOldRecs-->'+deleteFVCLOldRecs.size());
                    delete deleteFVCLOldRecs;
                    
                }
                
            }
            catch(exception e){
                System.debug('Exception -->'+e);
                //result = false;
            }
            
        }
        else if(credList.size()==0){
            try{
                //result = false;
                if(deleteFPAOldRecs.size()>0){
                    system.debug('deleteFPAOldRecs-->'+deleteFPAOldRecs.size());
                    delete deleteFPAOldRecs;
                    
                }
                if(deleteFVCLOldRecs.size()>0){
                    system.debug('deleteFVCLOldRecs-->'+deleteFVCLOldRecs.size());
                    delete deleteFVCLOldRecs;
                    
                }
                
            }catch(exception e){
                system.debug('Exception -->'+e);
            }
        }
        
        //System.enqueueJob(new FPAN_Apex_CredExtensionControllerQueable(myStartDate,myEndDate));
		
        FPAN_Apex_CredExtensionController_Batch CredBatch = new FPAN_Apex_CredExtensionController_Batch(myStartDate,myEndDate); 
        database.executeBatch(CredBatch, 200); 
        return TRUE;
        
        
    }
    
    @AuraEnabled 
    public static boolean fetchUser(){
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        boolean res;
        if(PROFILE[0].Name == 'FPAN Agent'){res = true;}else{res= false;}
        System.debug('Res---->' +res);
        return res;
    }    
}