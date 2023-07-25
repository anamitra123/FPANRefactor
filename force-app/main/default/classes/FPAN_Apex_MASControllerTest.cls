/**
 * Fairview Physician Associates Network
 * M4 Practice Portal 
 * 
 * AUTHOR: Rishabh Gupta
 * DATE: 3/29/2023
 * DESCRIPTION: Test Class Of FPAN_Apex_MASController.
 */

@isTest
public class FPAN_Apex_MASControllerTest {
    @isTest
    static void testGetAccountHierarchy() {
        // Create test accounts
        HealthcareProviderNpi HPN1 = new HealthcareProviderNpi(Name='019283094');
        insert HPN1;
        HealthcareProviderNpi HPN2 = new HealthcareProviderNpi(Name='019283095');
        insert HPN2;
        HealthcareProviderNpi HPN3 = new HealthcareProviderNpi(Name='019283096');
        insert HPN3;

        Account parentAccount = new Account(
            Name='Parent Account',
            FPAN_Provider_NPI__c = HPN1.Id,
            FPAN_First_Name__c = 'ACCOUNT_FIRSTNAME_LABEL',
            FPAN_Last_Name__c = 'ACCOUNT_LASTNAME_LABEL',
            FPAN_MI__c = 'ACCOUNT_MINAME_LABEL',
            FPAN_Title__c = 'Provider_Title',
            FPAN_Provider_Business_Email__c = 'ACCOUNTEmailLABEL@gamil.com',
            FPAN_DOB__c = Date.newInstance(1987, 06, 20),
            Phone = '9876543210',
            FPAN_CPO_Type__c = 'Primary Care',
            FPAN_Provider_Status__c = 'Inactive'
            );
        insert parentAccount;
        Account childAccount1 = new Account(
            Name='Child Account 1',
            FPAN_Provider_NPI__c = HPN2.Id,
            ParentId=parentAccount.Id,
            FPAN_First_Name__c = 'ACCOUNT_FIRSTNAME_LABEL',
            FPAN_Last_Name__c = 'ACCOUNT_LASTNAME_LABEL',
            FPAN_MI__c = 'ACCOUNT_MINAME_LABEL',
            FPAN_Title__c = 'Provider_Title',
            FPAN_Provider_Business_Email__c = 'ACCOUNTEmailLABEL@gamil.com',
            FPAN_DOB__c = Date.newInstance(1987, 06, 20),
            Phone = '9876543210',
            FPAN_CPO_Type__c = 'Primary Care',
            FPAN_Provider_Status__c = 'Inactive'
            );
        insert childAccount1;
        Account childAccount2 = new Account(
            Name='Child Account 2',
            FPAN_Provider_NPI__c = HPN3.Id,
            ParentId=childAccount1.Id,
            FPAN_First_Name__c = 'ACCOUNT_FIRSTNAME_LABEL',
            FPAN_Last_Name__c = 'ACCOUNT_LASTNAME_LABEL',
            FPAN_MI__c = 'ACCOUNT_MINAME_LABEL',
            FPAN_Title__c = 'Provider_Title',
            FPAN_Provider_Business_Email__c = 'ACCOUNTEmailLABEL@gamil.com',
            FPAN_DOB__c = Date.newInstance(1987, 06, 20),
            Phone = '9876543210',
            FPAN_CPO_Type__c = 'Primary Care',
            FPAN_Provider_Status__c = 'Inactive'
            );
        insert childAccount2;

        // Call the method being tested
        List<Account> accountList =     FPAN_Apex_MASController.getAccountHierarchy(parentAccount.Id);

        // Verify the results
        System.assertEquals(3, accountList.size());
        System.assertEquals(parentAccount.Id, accountList[0].Id);
        System.assertEquals(childAccount1.Id, accountList[1].Id);
        System.assertEquals(childAccount2.Id, accountList[2].Id);
    }

    @isTest
    static void testUpdateContact() {
        // Create test account and contact
        HealthcareProviderNpi HPN = new HealthcareProviderNpi(Name='019283097');
        insert HPN;

        Account testAccount = new Account(
            Name='Test Account',
            FPAN_Provider_NPI__c = HPN.Id,
            FPAN_First_Name__c = 'ACCOUNT_FIRSTNAME_LABEL',
            FPAN_Last_Name__c = 'ACCOUNT_LASTNAME_LABEL',
            FPAN_MI__c = 'ACCOUNT_MINAME_LABEL',
            FPAN_Title__c = 'Provider_Title',
            FPAN_Provider_Business_Email__c = 'ACCOUNTEmailLABEL@gamil.com',
            FPAN_DOB__c = Date.newInstance(1987, 06, 20),
            Phone = '9876543210',
            FPAN_CPO_Type__c = 'Primary Care',
            FPAN_Provider_Status__c = 'Inactive'
            );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName='Test',
            LastName='Contact',
            AccountId=testAccount.Id,
            FPAN_Child_Account__c=null);
        insert testContact;

        // Call the method being tested
            FPAN_Apex_MASController.updateContact(testAccount.Id, testContact.Id);

        // Retrieve the updated contact
        Contact updatedContact = [SELECT Id, FPAN_Child_Account__c FROM Contact WHERE Id = :testContact.Id];

        // Verify the results
        System.assertEquals(testAccount.Id, updatedContact.FPAN_Child_Account__c);
    }
}