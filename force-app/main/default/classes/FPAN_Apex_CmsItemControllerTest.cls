/**
 * Fairview Physician Associates Network
 * M4 Practice Portal 
 * 
 * AUTHOR: Rishabh Gupta
 * DATE: 3/29/2023
 * DESCRIPTION: Test Class Of FPAN_Apex_CmsItemController.
 */

@isTest
private class FPAN_Apex_CmsItemControllerTest {
    
    @isTest
    static void testGetContent() {
        // Test method
        Test.startTest();
        Map<String, ConnectApi.ManagedContentNodeValue> result = FPAN_Apex_CmsItemController.getContent('TestContentId');
        Test.stopTest();
    }

    @isTest
    static void testGetCollection() {
        // Test method
        Test.startTest();
        //Quality_ACO_Reach_Historical
        List<Map<String, ConnectApi.ManagedContentNodeValue>> result = FPAN_Apex_CmsItemController.getCollection('Quality_ACC_Historical');
        Test.stopTest();
    }

    @isTest
    static void testGetSubFolders() {
        // Test method
        Test.startTest();
        //Quality_ACO_Reach
        FPAN_Apex_CmsItemController.folderWrapper result = FPAN_Apex_CmsItemController.getSubFolders('Quality_Ambulatory_care_composite');
        Test.stopTest();

        // Assertion
        //System.assertEquals('ACO Reach', result.Header);
        System.assertEquals(2, result.subFolders.size());
    }
}