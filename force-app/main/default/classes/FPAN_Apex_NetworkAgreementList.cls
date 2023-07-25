/************************************************************************
* Name : FPAN_Apex_NetworkAgreementList
* Author : Masud Ahmed
* Date : 29/03/2023
* Desc : This class is used to fetch contract records, controller class for networkAgreementList lwc cmp
*************************************************************************/
public with sharing class FPAN_Apex_NetworkAgreementList {
    @AuraEnabled(cacheable=true)
    public static List<Contract> getNetworkAgreementList(Id accountId) {
        return [ SELECT Id, Status,ContractNumber, FPAN_Contract_Type__c,StartDate,EndDate 
                FROM Contract WHERE Status='Activated' AND AccountId =:accountId
               ];
        
        
    }
}