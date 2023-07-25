/************************************************************************
* Name : FPAN_ProviderStatusTriggerHandler
* Author : Ravi Kumar
* Date : 22/Dec/2021
* Desc : Apex class for FPAN_ProviderStatusUpdate
*************************************************************************/
Public class FPAN_ProviderStatusTriggerHandler{
    Public static void StatusUpdate(List<HealthcarePractitionerFacility> Hpfs){
        Map<ID,HealthcarePractitionerFacility> MapHPF = New Map<Id,HealthcarePractitionerFacility>();
        
        Set<Id> SetIds = New Set<Id>();
        Id RecordType = Schema.SObjectType.HealthcarePractitionerFacility.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        for(HealthcarePractitionerFacility HPF : Hpfs){
            if(HPF.FPAN_FPA_Status__c != NULL && HPF.RecordtypeID == RecordType){
                MapHPF.Put(HPF.ID,HPF);
                SetIds.add(HPF.AccountId);
            }
        }    
        
        List<Account> UpdateAccList = New List<Account>();  
        
        
        List<HealthcarePractitionerFacility> NewList = New List<HealthcarePractitionerFacility>([Select ID,Name,FPAN_FPA_Status__c,AccountId,Account.FPAN_Provider_Status__c from HealthcarePractitionerFacility where AccountID IN: SetIds]);
        system.debug('****NewList'+NewList);
        system.debug('****NewList-->Size'+NewList.Size());
        
        Map<String,HealthcarePractitionerFacility> NewMap = New Map<String,HealthcarePractitionerFacility>();
        Map<Account,HealthcarePractitionerFacility> NewAccMap = New Map<Account,HealthcarePractitionerFacility>();
        IF(NewList.size()>0){
            for(HealthcarePractitionerFacility HPF : NewList){
                IF(HPF.FPAN_FPA_Status__c != NULL){
                    NewMap.put(HPF.FPAN_FPA_Status__c,HPF);
                    NewAccMap.put(HPF.Account,HPF);
                }
            }
        }
        system.debug('****NewAccMap1'+NewAccMap);
        system.debug('****NewAccMap2'+NewAccMap.Keyset());
        IF(NewAccMap.size()>0){
            system.debug('****NewAccMap3'+NewAccMap);
            system.debug('****NewAccMap4'+NewAccMap.Keyset());
            List<Account> AccountList = [Select ID,Name,FPAN_Provider_Status__c from Account where ID IN: NewAccMap.Keyset()];
            //for(HealthcarePractitionerFacility h : NewList){
            system.debug('****AccountList'+AccountList);
            If(AccountList.size()>0){
                for(Account a : AccountList){
                    //IF(a.ID == h.AccountID){
                    If((NewMap.containsKey('Affiliate')) || (NewMap.containsKey('Member')) || (NewMap.containsKey('AHP Member')) ){
                        a.FPAN_Provider_Status__c = 'Active';
                        UpdateAccList.add(a);
                    }
                    
                    else{
                        if((!NewMap.containsKey('Affiliate')) && (!NewMap.containsKey('Member')) && (!NewMap.containsKey('AHP Member'))) {
                            
                            a.FPAN_Provider_Status__c = 'Inactive';
                            UpdateAccList.add(a);
                        }
                    }         
                }
            }
        }
        if(UpdateAccList.size()>0){
            try{
                Update UpdateAccList;
            }catch(Exception e){
                System.debug('Exception occurred'+e.getMessage());
                FPAN_APEX_HandleSystemException.LogException(e);
            }
        }
    } 
}