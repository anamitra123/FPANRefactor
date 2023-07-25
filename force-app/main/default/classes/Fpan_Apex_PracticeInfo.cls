/*****************************************************************************************************************
* Name : Fpan_Apex_PracticeInfo
* Author : Anamitra Majumdar
* Date : 04/03/2023
* Desc : This the controller class of FpanLwcStartSurvey cmp, this class is used to retreive the practice account details
********************************************************************************************************************/
public without sharing class Fpan_Apex_PracticeInfo {
    @AuraEnabled(cacheable=true)
    public static List<Account> getPracticeAccountDetails(String user){
      User userId=   [SELECT Id,ContactId FROM User WHERE Id= :user LIMIT 1];
        Contact accId=[SELECT AccountId, Id FROM Contact WHERE Id = :userId.ContactId LIMIT 1];
        List<Account> accRec = [SELECT Name, Parent.Name FROM Account WHERE Id =:accId.AccountId];
        return accRec;
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getUserName(String user){
      List<User> userName=   [SELECT Id,Name FROM User WHERE Id= :user ];
      return userName;
    }
}