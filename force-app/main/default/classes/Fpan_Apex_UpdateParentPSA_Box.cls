/**************************************************************************************************
* Name : Fpan_Apex_UpdateParentPSA_Box
* Author : Ravi Kumar
* Date : 10/Nov/2022
* Test Class : Fpan_UpdateParentPSA_Box_Test
* Desc : This Apex handler class is to check the field value Malpractice Insurance Co is FVHS Cayman or NOt, and If it's TRUE we are updating PSA Box is true in Provider Account.
****************************************************************************************************/

Public Class Fpan_Apex_UpdateParentPSA_Box{
    public static MAP<Id,Account> UpdatePSACheckboxFalse = New MAP<Id,Account>();
    public static MAP<Id,Account> UpdatePSACheckboxTrue  = New MAP<Id,Account>();    
    public Static String CheckMalPracInsuCo = System.Label.FPAN_UMPACO;//Custom Label
    public static Set<Id> AccId = New Set<Id>();
    public static String MalPracIns;
    public static List<Account> updateTrueAcounts = new List<Account>();
    public static List<Account> updateFalseAcounts = new List<Account>();
    
    public static void updateParentPSA(List<BusinessLicense> blList){
        For(BusinessLicense bl : blList){
            AccId.add(bl.AccountId);
            MalPracIns = bl.FPAN_Malpractice_Insurance_Co__c;
        }
        List<BusinessLicense> bLlistRecs = [Select Id,Name,FPAN_Malpractice_Insurance_Co__c,AccountId,Account.FPAN_PSA_Box__c From BusinessLicense Where FPAN_Malpractice_Insurance_Co__c = :CheckMalPracInsuCo AND AccountId IN:AccId];
        if(bLlistRecs.size()>0 || MalPracIns == CheckMalPracInsuCo){
            for(BusinessLicense blrec : bLlistRecs){
                blrec.Account.FPAN_PSA_Box__c = TRUE;
                UpdatePSACheckboxFalse.put(blrec.AccountId,blrec.Account);
            }
            for(Id acRecId : AccId){
                if(acRecId != null){
                    updateFalseAcounts.add(UpdatePSACheckboxFalse.get(acRecId));
                }
            }
            if(updateFalseAcounts.size()>0){
                try{
                    update updateFalseAcounts;
                }catch(exception e){
                    System.debug('Exception-->'+e);
                    FPAN_APEX_HandleSystemException.LogException(e);
                }
                
            }
        }else{
            List<BusinessLicense> bLlistRecsTrue = [Select Id,Name,FPAN_Malpractice_Insurance_Co__c,AccountId,Account.FPAN_PSA_Box__c From BusinessLicense Where AccountId IN:AccId];
            
            for(BusinessLicense blrec : bLlistRecsTrue){
                blrec.Account.FPAN_PSA_Box__c = FALSE;
                UpdatePSACheckboxTrue.put(blrec.AccountId,blrec.Account);
            }
            
            for(Id acRecId : AccId){
                if(acRecId != null){
                    updateTrueAcounts.add(UpdatePSACheckboxTrue.get(acRecId));}
            }
            // Updating the PSA Box Vlaue
            if(updateTrueAcounts.size()>0){
                try{
                    Update updateTrueAcounts;                 
                }catch(exception e){
                    System.debug('Exception-->'+e);
                    FPAN_APEX_HandleSystemException.LogException(e);
                }
            }
            
        }
    }
    // After delete the Provider Business, updating the PSA BOX value in Provider Account
    public static void updateParentPSAonDelete(List<BusinessLicense> blList){
        
        For(BusinessLicense bl : blList){
            AccId.add(bl.AccountId);
            MalPracIns = bl.FPAN_Malpractice_Insurance_Co__c;
        }
        List<BusinessLicense> bLlistRecs = [Select Id,Name,FPAN_Malpractice_Insurance_Co__c,AccountId,Account.FPAN_PSA_Box__c From BusinessLicense Where FPAN_Malpractice_Insurance_Co__c = :CheckMalPracInsuCo AND AccountId IN:AccId];
        if(bLlistRecs.size()==0 && MalPracIns == CheckMalPracInsuCo){
            List<Account> toupdateAcc = [SELECT id,FPAN_PSA_Box__c from account where id IN :AccId];
            for(Account accRec : toupdateAcc){
                accRec.FPAN_PSA_Box__c = FALSE;
                updateTrueAcounts.add(accRec);
            }
            if(updateTrueAcounts.size()>0){
                try{
                    update updateTrueAcounts;
                }catch(exception e){
                    System.debug('Exception-->'+e);
                    FPAN_APEX_HandleSystemException.LogException(e);
                }
            }
            
        }
    }
}