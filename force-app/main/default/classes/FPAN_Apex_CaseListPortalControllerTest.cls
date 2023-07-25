/**
 * Fairview Physician Associates Network
 * M4 Practice Portal 
 * 
 * AUTHOR: Rishabh Gupta
 * DATE: 3/29/2023
 * DESCRIPTION: Test Class Of FPAN_Apex_CaseListPortalController.
 */

@isTest
private class FPAN_Apex_CaseListPortalControllerTest {

    @isTest
    static void testGetCasesByUserId() {
        
        Case testCase1 = new Case(Status = 'Pending');
        insert testCase1;

        Case testCase2 = new Case(Status = 'Closed');
        insert testCase2;

        // Call the method being tested
        Test.startTest();
        List<Case> cases = FPAN_Apex_CaseListPortalController.getCasesByUserId();
        FPAN_Apex_CaseListPortalController.getRecords(10,0);
        Test.stopTest();

        // Verify the results
        System.assertEquals(2, cases.size());
        //System.assertEquals('Pending', cases[0].Status);
        //System.assertEquals('Closed', cases[1].Status);
    }
}