/**
 * Fairview Physician Associates Network
 * M4 Practice Portal 
 * 
 * AUTHOR: Rishabh Gupta
 * DATE: 3/21/2023
 * DESCRIPTION: Retrieves a hierarchical list of accounts and updates a contact's associated account.
 */

public without sharing class FPAN_Apex_MASController {
    
    @AuraEnabled
    public static List<Account> getAccountHierarchy(String accountId) {
        
        if (accountId == null) {
        return null;
        }

        List<Account> accountList = new List<Account>();
        Map<Id, List<Account>> accountMap = createAccountMap();

        Account parentAccount = queryParentAccount(accountId);
        accountList.add(parentAccount);

        List<Account> childAccounts = getChildAccounts(accountMap, parentAccount.Id);

        while (!childAccounts.isEmpty()) {
            accountList.addAll(childAccounts);
            childAccounts = getNextLevelChildAccounts(accountMap, childAccounts);
        }

        return accountList;
    }

    private static Map<Id, List<Account>> createAccountMap() {
        Map<Id, List<Account>> accountMap = new Map<Id, List<Account>>();
        List<Account> childAccounts = [
            SELECT Id, Name, ParentId, 
            FPAN_Clinic_Fed_Id__c, FPAN_Practice_Speciality__c, FPAN_Practice_Status__c 
            FROM Account WHERE ParentId != null LIMIT 50000];

        for (Account childAccount : childAccounts) {
            if (!accountMap.containsKey(childAccount.ParentId)) {
                accountMap.put(childAccount.ParentId, new List<Account>());
            }
            accountMap.get(childAccount.ParentId).add(childAccount);
        }

        return accountMap;
    }

    private static Account queryParentAccount(String accountId) {
        return [
            SELECT Id, Name, ParentId, 
            FPAN_Clinic_Fed_Id__c, FPAN_Practice_Speciality__c, FPAN_Practice_Status__c 
            FROM Account WHERE Id = :accountId LIMIT 1];
    }

    private static List<Account> getChildAccounts(Map<Id, List<Account>> accountMap, Id parentId) {
        return accountMap.containsKey(parentId) ? accountMap.get(parentId) : new List<Account>();
    }

    private static List<Account> getNextLevelChildAccounts(Map<Id, List<Account>> accountMap, List<Account> parentAccounts) {
        List<Account> childAccounts = new List<Account>();
        for (Account pa : parentAccounts) {
            childAccounts.addAll(getChildAccounts(accountMap, pa.Id));
        }
        return childAccounts;
    }

    @AuraEnabled
    public static void updateContact(String accountId, String contactId) {
        try {
            Contact con = new Contact(Id = contactId, FPAN_Child_Account__c = accountId);
            update con;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}