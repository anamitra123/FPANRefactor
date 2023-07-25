/*****************************************************************************************************************
* Name : FPAN_Apex_DuplicateReCredHandler
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This a handler class of Fpan_Trigger_DuplicateRecredentialing Trigger, this class will throw an error
whenever a duplicate re-cerdentialing record is inserted for a single credentialing record
********************************************************************************************************************/
public class FPAN_Apex_DuplicateReCredHandler {
    
    public static void DuplicateReCredentialingRecordInsert(List<vlocity_ins__ProviderNetworkMember__c> RedCred){
        set<ID> ids= new set<ID>();
        for(vlocity_ins__ProviderNetworkMember__c rc : RedCred){
            ids.add(rc.vlocity_ins__ProviderNetworkId__c); 
        }
        
        List<vlocity_ins__ProviderNetworkMember__c> rcList=[Select Id , vlocity_ins__ProviderNetworkId__c ,Name FROM vlocity_ins__ProviderNetworkMember__c
                                                            WHERE vlocity_ins__ProviderNetworkId__c IN :ids];
        for(vlocity_ins__ProviderNetworkMember__c rec : RedCred){
            if(Trigger.isInsert && rcList.size()>0){
                rec.addError('We found Duplicate ReCredentialing Record, A credentialing record should have only one Recredentialing record');
            }
        }
        
        
        
    }
    
}