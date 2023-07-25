/**************************************************************************************************
* Name : FPANCheckDuplicateLocation
* Author : Gaana Shetty
* Date : 07/17/2022
* Desc : Apex class for FPAN_Trigger_AssociatedLocation
****************************************************************************************************/

public class FPANCheckDuplicateLocation {
    
    public static void CheckDuplicateForProvider(List <AssociatedLocation> AslocDupProv){
        Set <Id> LocId = new Set<Id>();
        Set <Id> ProvId = new Set<Id>();
        Id RecordType = Schema.SObjectType.AssociatedLocation.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        
        for(AssociatedLocation Asloc: AslocDupProv){
            if(Asloc.LocationId != null && Asloc.ParentRecordId != null)
            {
                LocId.add(Asloc.LocationId);
                ProvId.add(Asloc.ParentRecordId);
                system.debug('LocID---> ' +LocId);
                system.debug('ProvId--->' +ProvId);
            }
        }
        list<AssociatedLocation> AslocList = [select id, RecordtypeID, ParentRecordId, LocationId from AssociatedLocation];
        System.debug('AslocList--'+AslocList);
        
        if(AslocList.Size() > 0) {
            For(AssociatedLocation AsL : AslocList){
                For(AssociatedLocation AsLID : AslocDupProv){ 
                    //When a Duplicate location is associated to a Provider
                    if(AsLID.LocationId == AsL.LocationId && AsLID.ParentRecordId == AsL.ParentRecordId && AsLID.RecordtypeID == RecordType && AsL.RecordtypeID == RecordType) {
                        AsLID.addError(Label.FPAN_Dup_Loc_Provider);
                    } 
                    //When a Duplicate location is associated to a Practice
                    else if(AsLID.LocationId == AsL.LocationId && AsLID.ParentRecordId == AsL.ParentRecordId && AsLID.RecordtypeID != RecordType && AsL.RecordtypeID != RecordType) {
                        AsLID.addError(Label.FPAN_Dup_Loc_Practice);
                    } 
                    //When a same location is associated to multiple Practice
                    else if(AsLID.LocationId == AsL.LocationId && AsLID.ParentRecordId != AsL.ParentRecordId && AsLID.RecordtypeID != RecordType && AsL.RecordtypeID != RecordType) {
                        AsLID.addError(Label.FPAN_Error_Prac_Loc);
                    } 
                }
            }
        }
        
    }
    
}