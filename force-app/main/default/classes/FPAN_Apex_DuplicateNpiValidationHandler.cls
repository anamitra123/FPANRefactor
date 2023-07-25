/************************************************************************
* Name : FPAN_Apex_DuplicateNpiValidationHandler
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : This is a handler class of FPAN_CreateProviderContact Trigger , this class throws error if there is any duplicate npi
*************************************************************************/
public class FPAN_Apex_DuplicateNpiValidationHandler {
    Public static void DuplicateNpiValidation(List<Account> accList, Map<Id,Account> OldAccounts){
        List<Account> accNpiList =[SELECT Id, FPAN_Provider_NPI__c FROM Account WHERE FPAN_Provider_NPI__c != Null];
       
        List<String> NpiNumberList = new List<String>();
        for(Account accNpi : accNpiList)
        {
            NpiNumberList.add(accNpi.FPAN_Provider_NPI__c);
        }
        for(Account acc : accList){
            
            Account oldAccount = OldAccounts.get(acc.id);
            if(acc.FPAN_Provider_NPI__c != oldAccount.FPAN_Provider_NPI__c){
            if(NpiNumberList.contains(acc.FPAN_Provider_NPI__c)){
                acc.adderror('The Npi is already associated with another provider account');
            }
        }
        }
    }
    
    public static void DuplicateNpiValidationInsert(List<Account> accList){
        Id RType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        List<Account> accNpiList =[SELECT Id, FPAN_Provider_NPI__c FROM Account WHERE FPAN_Provider_NPI__c != Null];
        
        List<String> NpiNumberList = new List<String>();
        for(Account accNpi : accNpiList)
        {
            NpiNumberList.add(accNpi.FPAN_Provider_NPI__c);
        }
        for(Account acc : accList){
            if(acc.RecordTypeId != RType){
           
            
            if(NpiNumberList.contains(acc.FPAN_Provider_NPI__c)){
                acc.adderror('The Npi is already associated with another provider account');
            }
            if(acc.FPAN_Provider_NPI__c == NULL){
                acc.adderror('NPI is mandatory for the Provider Account');
            }
        }
        } 
    }
}