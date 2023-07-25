/************************************************************************
* Name : Fpan_Apex_GetContactList
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This class is the controller class of  FpanLwcContactList
, it's used retreive contact whose status is Active
*************************************************************************/
public without sharing class Fpan_Apex_GetContactList {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContact(Id accountId) {
        return [
            SELECT Id, Name,LastName, AccountId, Phone, Email, vlocity_ins__Status__c,FPAN_Contact_Type__c FROM Contact WHERE AccountId =:accountId 
            AND vlocity_ins__Status__c='Active'
        ];
    }
}