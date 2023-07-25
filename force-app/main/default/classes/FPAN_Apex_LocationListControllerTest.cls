/**
 * Fairview Physician Associates Network
 * M4 Practice Portal 
 * 
 * AUTHOR: Rishabh Gupta
 * DATE: 4/3/2023
 * DESCRIPTION: Test Class Of FPAN_Apex_LocationListController.
 */

@isTest
public class FPAN_Apex_LocationListControllerTest {

    @testSetup
    static void setup() {
        HealthcareProviderNpi HPN = new HealthcareProviderNpi(Name='019283094');
        insert HPN;
        
        Account acc = new Account (
            Name = 'Test Account',
            FPAN_Provider_NPI__c = HPN.Id,
            FPAN_First_Name__c = 'ACCOUNT_FIRSTNAME_LABEL',
            FPAN_Last_Name__c = 'ACCOUNT_LASTNAME_LABEL',
            FPAN_MI__c = 'ACCOUNT_MINAME_LABEL',
            FPAN_Title__c = 'Provider_Title',
            FPAN_Provider_Business_Email__c = 'ACCOUNTEmailLABEL@gamil.com',
            FPAN_DOB__c = Date.newInstance(1987, 06, 20),
            Phone = '9876543210',
            FPAN_CPO_Type__c = 'Primary Care',
            FPAN_Provider_Status__c = 'Active');
        
        insert acc;
    }

    @isTest
    static void testGetAssociatedLocList() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        List<AssociatedLocation> locs = FPAN_Apex_LocationListController.getAssociatedLocList(acc.Id);
        Test.stopTest();

        System.assertEquals(0, locs.size());
    }
}