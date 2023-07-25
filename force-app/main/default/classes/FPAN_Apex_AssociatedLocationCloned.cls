/**************************************************************************************
* Name : FPAN_Apex_AssociatedLocationCloned
* Author : Sreeni B
* Date : 19/May/2022
* Desc : This apex class is for maintaining the cloned associatedLocation records
***************************************************************************************/
public class FPAN_Apex_AssociatedLocationCloned{
    //Create new cloned associated locations
    public static void createCloneALocation(List<AssociatedLocation> aslList){         
        List<AssociatedLocationCloned__c> aslclone= new List<AssociatedLocationCloned__c>();        
        for(AssociatedLocation asl:aslList){
            AssociatedLocationCloned__c clnAl = new AssociatedLocationCloned__c();
            clnAl.Name = asl.AssociatedLocationNumber;
            clnAl.ActiveFrom__c = asl.ActiveFrom;
            clnAl.ActiveTo__c   = asl.ActiveTo;
            clnAl.AssociatedLocationNumber__c   = asl.AssociatedLocationNumber;
            clnAl.FPAN_Admin_Site__c    = asl.FPAN_Admin_Site__c;
            clnAl.FPAN_Billing_Site__c  = asl.FPAN_Billing_Site__c;
            clnAl.FPAN_Directory_Print__c   = asl.FPAN_Directory_Print__c;
            clnAl.FPAN_FPA_Main_Site__c = asl.FPAN_FPA_Main_Site__c;
            clnAl.FPAN_Main_Practice_Site__c    = asl.FPAN_Main_Practice_Site__c;
            clnAl.FPAN_MDPRACSITEID__c  = asl.FPAN_MDPRACSITEID__c;
            clnAl.FPAN_MDPRACTID__c = asl.FPAN_MDPRACTID__c;
            clnAl.FPAN_PHYSICIANID__c   = asl.FPAN_PHYSICIANID__c;
            clnAl.FPAN_PRACTICE_ID__c   = asl.FPAN_PRACTICE_ID__c;
            clnAl.FPAN_Practice_Site__c = asl.FPAN_Practice_Site__c;
            clnAl.FPAN_Provider_Facilities__c   = asl.FPAN_Provider_Facilities__c;
            clnAl.FPAN_Provider_Mail_Site__c    = asl.FPAN_Provider_Mail_Site__c;
            clnAl.FPAN_Provider_PCC__c  = asl.FPAN_Provider_PCC__c;
            clnAl.FPAN_Provider_Site_Directory__c   = asl.FPAN_Provider_Site_Directory__c;
          //  clnAl.FPAN_Site_Closed__c   = asl.FPAN_Site_Closed__c;
            clnAl.FPAN_SITE_ID__c   = asl.FPAN_SITE_ID__c;
            clnAl.Location__c   = asl.LocationId;
            clnAl.ParentRecordId__c = asl.ParentRecordId;
            clnAl.Provider_Association_Location__c  = asl.Provider_Association_Location__c;
            clnAl.Type__c   = asl.Type;
            clnAl.AssociatedLocId__c = asl.Id;  
            clnAl.FPAN_RecordType_Name__c = asl.FPAN_RecordType_Name__c;
            clnAl.FPAN_Provider_Directory_Main__c = asl.FPAN_Provider_Directory_Main__c;
            clnAl.Address__c = asl.FPAN_Address_Name__c;//Address
            //Location Details
            clnAl.Location__c = asl.LocationId;
            clnAl.FPAN_Location_MNCM_Clinic_ID__c = asl.FPAN_Location_MNCM_Clinic_ID__c;
            clnAl.FPAN_Location_MNCM_Group_ID__c = asl.FPAN_Location_MNCM_Group_ID__c;
            clnAl.FPAN_Location_Site_Open_Effective_Date__c = asl.FPAN_Location_Site_Open_Effective_Date__c;
            clnAl.FPAN_Location_Site_Closed_Effective_Date__c = asl.FPAN_Location_Site_Closed_Effective_Date__c;
            clnAl.FPAN_Location_Site_NPI__c = asl.FPAN_Location_Site_NPI__c;  
            aslclone.add(clnAl);
        }
        if(aslclone.size()>0){
            try{
                insert aslclone;
            }catch(Exception e){
                System.debug('Exception at Insertion-->'+e);
                FPAN_APEX_HandleSystemException.LogException(e);
            }
        }
        
    }
    
    //Upsert cloned associated locations
    public static void updateCloneALocation(List<AssociatedLocation> aslList){
        
        SET<ID> updateClonedASL= new SET<ID>();
        SET<ID> toUpdateCloneRecs= new SET<ID>();
        List<AssociatedLocation> toInsertCloneRecsLst = new LIST<AssociatedLocation>();
        List<AssociatedLocation> toUpdateCloneRecsLst= new List<AssociatedLocation>();
        List<AssociatedLocationCloned__c> toOpdateClonedAsls = new List<AssociatedLocationCloned__c>();
        List<AssociatedLocationCloned__c> existingClonedASls = [SELECT id, AssociatedLocId__c, ActiveFrom__c, ActiveTo__c, AssociatedLocationNumber__c, CreatedDate__c, FPAN_Admin_Site__c, FPAN_Billing_Site__c, FPAN_Directory_Print__c, FPAN_FPA_Main_Site__c, FPAN_Main_Practice_Site__c, FPAN_Provider_FPA_Status__c, FPAN_Practice_Site__c, FPAN_Provider_Facilities__c,Location__c, ParentRecordId__c, Provider_Association_Location__c  from AssociatedLocationCloned__c];
        
        for(AssociatedLocationCloned__c casl : existingClonedASls){
            updateClonedASL.add(casl.AssociatedLocId__c);
        }        
        for(AssociatedLocation asloc :aslList){
            if(updateClonedASL.contains(asloc.Id)){
                toUpdateCloneRecsLst.add(asloc);
            }else{
                toInsertCloneRecsLst.add(asloc);
            }
        }
        
        if(toInsertCloneRecsLst.size()>0){
            createCloneALocation(toInsertCloneRecsLst); //Create new Clone ASLs: Reusability
        }
        
        for(AssociatedLocation existingASL : toUpdateCloneRecsLst){
            for(AssociatedLocationCloned__c exCloneALs: existingClonedASls){
                if(exCloneALs.AssociatedLocId__c == existingASL.id){
                    exCloneALs.Name = existingASL.AssociatedLocationNumber;
                    exCloneALs.ActiveFrom__c    = existingASL.ActiveFrom;
                    exCloneALs.ActiveTo__c  = existingASL.ActiveTo;
                    exCloneALs.AssociatedLocationNumber__c  = existingASL.AssociatedLocationNumber;
                    exCloneALs.FPAN_Admin_Site__c   = existingASL.FPAN_Admin_Site__c;
                    exCloneALs.FPAN_Billing_Site__c = existingASL.FPAN_Billing_Site__c;
                    exCloneALs.FPAN_Directory_Print__c  = existingASL.FPAN_Directory_Print__c;
                    exCloneALs.FPAN_FPA_Main_Site__c    = existingASL.FPAN_FPA_Main_Site__c;
                    exCloneALs.FPAN_Main_Practice_Site__c   = existingASL.FPAN_Main_Practice_Site__c;
                    exCloneALs.FPAN_MDPRACSITEID__c = existingASL.FPAN_MDPRACSITEID__c;
                    exCloneALs.FPAN_MDPRACTID__c    = existingASL.FPAN_MDPRACTID__c;
                    exCloneALs.FPAN_PHYSICIANID__c  = existingASL.FPAN_PHYSICIANID__c;
                    exCloneALs.FPAN_PRACTICE_ID__c  = existingASL.FPAN_PRACTICE_ID__c;
                    exCloneALs.FPAN_Practice_Site__c    = existingASL.FPAN_Practice_Site__c;
                    exCloneALs.FPAN_Provider_Facilities__c  = existingASL.FPAN_Provider_Facilities__c;
                    exCloneALs.FPAN_Provider_Mail_Site__c   = existingASL.FPAN_Provider_Mail_Site__c;
                    exCloneALs.FPAN_Provider_PCC__c = existingASL.FPAN_Provider_PCC__c;
                    exCloneALs.FPAN_Provider_Site_Directory__c  = existingASL.FPAN_Provider_Site_Directory__c;
                  //  exCloneALs.FPAN_Site_Closed__c  = existingASL.FPAN_Site_Closed__c;
                    exCloneALs.FPAN_SITE_ID__c  = existingASL.FPAN_SITE_ID__c;
                    exCloneALs.Location__c  = existingASL.LocationId;
                  //  exCloneALs.ParentRecordId__c  = existingASL.ParentRecordId;
                    exCloneALs.Provider_Association_Location__c = existingASL.Provider_Association_Location__c;
                    exCloneALs.Type__c  = existingASL.Type;
                    exCloneALs.AssociatedLocId__c = existingASL.Id;    
                    exCloneALs.FPAN_RecordType_Name__c = existingASL.FPAN_RecordType_Name__c;
                    exCloneALs.FPAN_Provider_Directory_Main__c = existingASL.FPAN_Provider_Directory_Main__c;
                    exCloneALs.Address__c = existingASL.FPAN_Address_Name__c;
                    //Location Details
                    exCloneALs.Location__c = existingASL.LocationId;
                    exCloneALs.FPAN_Location_MNCM_Clinic_ID__c = existingASL.FPAN_Location_MNCM_Clinic_ID__c;
                    exCloneALs.FPAN_Location_MNCM_Group_ID__c = existingASL.FPAN_Location_MNCM_Group_ID__c;
                    exCloneALs.FPAN_Location_Site_Open_Effective_Date__c = existingASL.FPAN_Location_Site_Open_Effective_Date__c;
                    exCloneALs.FPAN_Location_Site_Closed_Effective_Date__c = existingASL.FPAN_Location_Site_Closed_Effective_Date__c;
                    exCloneALs.FPAN_Location_Site_NPI__c = existingASL.FPAN_Location_Site_NPI__c;
                    
                    toOpdateClonedAsls.add(exCloneALs);
                }
            }
            
        }
        if(toOpdateClonedAsls.size()>0){
            try{        
                Update toOpdateClonedAsls;// Updating the existing cloned ASLs
            }catch(exception e){
                system.debug('Exception e');
                FPAN_APEX_HandleSystemException.LogException(e);
            }
        }
    }
    
    //Delete existing cloned ASLs whenever original ASLs deleted.
    public static void deleteClonedALocation(List<AssociatedLocation> aslList){  
        SET<ID> deleteClonedasl= new SET<ID>();
        for(AssociatedLocation asl:aslList){
            deleteClonedasl.add(asl.id);
        }
        List<AssociatedLocationCloned__c> toDelClonedASLs = [SELECT id,AssociatedLocId__c from AssociatedLocationCloned__c where AssociatedLocId__c IN : deleteClonedasl];
        if(toDelClonedASLs.size()>0){
            try{
                delete toDelClonedASLs;
            }catch(Exception e){
                System.debug('Exception at deletion-->'+e);
                FPAN_APEX_HandleSystemException.LogException(e);
            }
            
        } 
    }
    
}