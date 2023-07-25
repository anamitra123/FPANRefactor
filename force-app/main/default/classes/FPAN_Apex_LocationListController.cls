/**
 * Fairview Physician Associates Network
 * M4 Practice Portal 
 * 
 * AUTHOR: Rishabh Gupta
 * DATE: 3/14/2023
 * DESCRIPTION: Gets the List of Practice Location for the current User based on the accountId and RecordType.
 */

public with sharing class FPAN_Apex_LocationListController {

    @AuraEnabled(cacheable=true)
    public static List<AssociatedLocation> getAssociatedLocList(Id accountId) {
        return [
            SELECT Id, FPAN_Location_Name_Formula__c, FPAN_Address_City__c, FPAN_Practice_Site__c, FPAN_Directory_Print__c, FPAN_Main_Practice_Site__c
            FROM AssociatedLocation
            WHERE ParentRecordId = :accountId AND RecordType.Name = 'Practice Location'AND FPAN_Practice_Site__c = true
        ];
    }
    
}