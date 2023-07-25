/**********************************************************************************************************************
* Name : FPAN_Apex_ReCredExtensionController
* Author : Sreeni
* Date : 28/Mar/2021
* Desc : Generate ReCredentialing Letters button calls this controller to create credentialing letters  
**********************************************************************************************************************/
public class FPAN_Apex_ReCredExtensionController {
    
    @AuraEnabled
    public static boolean createRecredRecs(String startDate, String endDate) {
        //Variables Declaration
        Date myStartDate = Date.valueOf(startDate);
        Date myEndDate = Date.valueOf(endDate);
        List<vlocity_ins__ProviderNetworkMember__c> RecredList  = new List<vlocity_ins__ProviderNetworkMember__c>();
        
        String ReCredFPAId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN ReCredentialing FPA' LIMIT 1].Id;
        String ReCredFVCLId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN ReCredentialing FVCL' LIMIT 1].Id; 
        List<ContentDocument> deleteFPAOldRecs = [SELECT Id, ParentId FROM ContentDocument where ParentId = :ReCredFPAId];
        List<ContentDocument> deleteFVCLOldRecs = [SELECT Id, ParentId FROM ContentDocument where ParentId = :ReCredFVCLId];                
        
        
        RecredList = [Select id,FPAN_FPA__c,FPAN_Board_Cert_Waived__c,FPAN_FVCL__c,FPAN_FPA_R_C_C_A_Date__c,vlocity_ins__ProviderAccountId__c,vlocity_ins__ProviderNetworkId__r.FPAN_Provider_NPI__c,vlocity_ins__ProviderNetworkId__r.FPAN_Practice_Account__r.Name,
                      vlocity_ins__ProviderNetworkId__r.FPAN_Practice_Account__r.Account.FPAN_Last_Name__c,vlocity_ins__ProviderAccountId__r.BillingCountry,
                      vlocity_ins__ProviderAccountId__r.Name,
                      vlocity_ins__ProviderAccountId__r.FPAN_Last_Name__c,
                      vlocity_ins__ProviderAccountId__r.FPAN_First_Name__c,
                      vlocity_ins__ProviderAccountId__r.FPAN_MI__c,
                      vlocity_ins__ProviderAccountId__r.FPAN_Title__c,
                      vlocity_ins__ProviderAccountId__r.BillingStreet,vlocity_ins__ProviderAccountId__r.BillingCity,vlocity_ins__ProviderAccountId__r.BillingState,vlocity_ins__ProviderAccountId__r.BillingPostalCode,
                      vlocity_ins__ProviderNetworkId__r.FPAN_Practice_Account__c,FPAN_FVCL_R_C_C_A_Date__c
                      from vlocity_ins__ProviderNetworkMember__c where (FPAN_FPA_R_C_C_A_Date__c >= :myStartDate AND FPAN_FPA_R_C_C_A_Date__c  <= :myEndDate) OR (FPAN_FVCL_R_C_C_A_Date__c >= :myStartDate AND FPAN_FVCL_R_C_C_A_Date__c <= :myEndDate)];
        system.debug('@@@@RecredList'+RecredList);
        
        
        if(RecredList.size()>0){
            
            
            try{ 
                if(deleteFPAOldRecs.size()>0){
                    system.debug('deleteFPAOldRecs-->'+deleteFPAOldRecs.size());
                    delete deleteFPAOldRecs;                    
                }
                if(deleteFVCLOldRecs.size()>0){
                    system.debug('deleteFVCLOldRecs-->'+deleteFVCLOldRecs.size());
                    delete deleteFVCLOldRecs;                    
                }
      
            }catch(exception e){
                System.debug('Exception -->'+e);
                
            }
      }
        else if(RecredList.size()==0){
            try{
                
                if(deleteFPAOldRecs.size()>0){
                    system.debug('deleteFPAOldRecs-->'+deleteFPAOldRecs.size());
                    delete deleteFPAOldRecs;
              }
                if(deleteFVCLOldRecs.size()>0){
                    system.debug('deleteFVCLOldRecs-->'+deleteFVCLOldRecs.size());
                    delete deleteFVCLOldRecs;
                  }
           }catch(exception e){
                System.debug('Exception-->'+e);
          }
        }
        FPAN_Apex_ReCredExtensionControllerBatch ReCredBatch = new FPAN_Apex_ReCredExtensionControllerBatch(myStartDate,myEndDate); 
        database.executeBatch(ReCredBatch, 200); 
        return  TRUE;
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