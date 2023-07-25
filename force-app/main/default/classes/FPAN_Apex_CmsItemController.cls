/**
 * Fairview Physician Associates Network
 * M4 Practice Portal 
 * 
 * AUTHOR: Rishabh Gupta
 * DATE: 2/13/2023
 * DESCRIPTION: Returns the content nodes for the given contentId or folderId.
 */

 public without sharing class FPAN_Apex_CmsItemController {

    @AuraEnabled(cacheable=true)
    public static Map<String, ConnectApi.ManagedContentNodeValue> getContent(String contentId) {
        try {
            String networkId = Network.getNetworkId();
            ConnectApi.ManagedContentVersionCollection cmsCollection = ConnectApi.ManagedContent.getManagedContentByContentKeys(
                networkId,
                new List<String>{ contentId },
                0,
                1,
                null,
                null,
                false
                );
            return cmsCollection.items[0].contentNodes;
        } catch (Exception e) {
            System.debug('Error: '+e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, ConnectApi.ManagedContentNodeValue>> getCollection(String folderName){
        try {
            String networkId = Network.getNetworkId();
            FPAN_CMS_Folder__mdt folder = [SELECT Id FROM FPAN_CMS_Folder__mdt WHERE DeveloperName =: folderName LIMIT 1];
            List<Map<String, ConnectApi.ManagedContentNodeValue>> contents = new List<Map<String, ConnectApi.ManagedContentNodeValue>>();
            for(FPAN_CMS_Key__mdt key : [SELECT ID, Content_key__c FROM FPAN_CMS_Key__mdt WHERE FPAN_CMS_Folder__c =:folder.Id]) {
                if(Key.Content_key__c != null) {
                    List<String> keys = new List<String>();
                    keys.add(Key.Content_key__c);
                    try {
                        ConnectApi.ManagedContentVersionCollection cms = ConnectApi.ManagedContent.getManagedContentByContentKeys(networkId, keys,0,1,null,null,false);
                        if(cms.total > 0) {
                            contents.add(cms.items[0].contentNodes);
                        }
                    } catch(Exception e) {
                        System.debug('ContentKey: '+Key.Content_key__c+' is Not a Valid Key');
                        System.debug(e.getMessage());
                    }
                }
            }
            return contents;

        } catch (Exception e) {
            System.debug('Error: '+e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static folderWrapper getSubFolders(String folderName){
        try {
            folderWrapper folderObj = new folderWrapper();
            folderObj.subFolders = new List<folderWrapper>();

            FPAN_CMS_MasterFolder__mdt folder = [SELECT Id, MasterLabel FROM FPAN_CMS_MasterFolder__mdt WHERE DeveloperName =: folderName LIMIT 1];
            folderObj.Header = folder.MasterLabel;
            
            List<FPAN_CMS_Folder__mdt> subFolders = [SELECT Id, MasterLabel, DeveloperName FROM FPAN_CMS_Folder__mdt WHERE FPAN_CMS_MasterFolder__c =: folder.Id ORDER BY MasterLabel];
            for(FPAN_CMS_Folder__mdt subFolder : subFolders) {
                folderWrapper subfolderObj = new folderWrapper();
                subfolderObj.Header = subFolder.MasterLabel;
                subfolderObj.DeveloperName = subFolder.DeveloperName;
                folderObj.subFolders.add(subfolderObj);
            }

            return folderObj;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class folderWrapper {
        @AuraEnabled public String Header {get;set;}
        @AuraEnabled public String DeveloperName {get;set;}
        @AuraEnabled public List<folderWrapper> subFolders {get;set;} 
    }
}