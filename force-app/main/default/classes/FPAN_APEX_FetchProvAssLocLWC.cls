/************************************************************************
* Name : FPAN_APEX_FetchProvAssLocLWC
* Author : Ravi Kumar
* Date : 31/Mar/2023
* Desc : This Apex class used for to return the Provider-Associated Location list to the LWC Component
* LWC : FpanlwcProvAssociatedLocDetailPage
* Test Class : FPAN_Apex_Portal_LWC_TestClass
*************************************************************************/


public with sharing class FPAN_APEX_FetchProvAssLocLWC {
    @AuraEnabled()
    public static List<AssociatedLocationCloned__c> GetAssociatedLocationRec(Id AssociatedlocationId) {

        List<AssociatedLocationCloned__c> ListProvAssociatedLocation = [Select Id,Name,FPAN_Provider_Facilities__c,Location__c,FPAN_Location_Name_Formula__c,FPAN_Provider_PCC__c,
                                                                    FPAN_FPA_Main_Site__c,FPAN_Provider_Mail_Site__c,FPAN_Provider_Site_Directory__c,FPAN_Location_Site_NPI__c,
                                                                    FPAN_Address_Suite_No__c,FPAN_Provider_Directory_Main__c,FPAN_Address__c,Address__c,ParentRecordId__r.Name,
                                                                    ParentRecordId__c,FPAN_Provider_FPA_Status__c,FPAN_Site_Closed__c
                                                                    From AssociatedLocationCloned__c where Id =: AssociatedlocationId];
		
        system.debug('@@@ListProvAssociatedLocation--->'+ListProvAssociatedLocation);
        return ListProvAssociatedLocation;                  
    }

    @AuraEnabled()
    public static String getObjectApiName(Id recordId){
        try {
            return recordId.getSObjectType().getDescribe().getName();
        } catch (Exception e) {
           
             throw new AuraHandledException(e.getMessage());
            
        }
    }

    @AuraEnabled()
    public static String getRecordTypeName(Id recordId, String objectName) {
        try {
            String query = 'SELECT Id, RecordTypeId FROM ' + objectName + ' WHERE Id = \'' + recordId + '\' LIMIT 1';
            sObject record = Database.query(query);
            Id recordTypeId = (Id)record.get('RecordTypeId');
            RecordType objRT = [SELECT Name FROM RecordType WHERE Id =: recordTypeId LIMIT 1];
            return objRT.Name;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}