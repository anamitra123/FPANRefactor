public class FPAN_Remove_Practice_Frm_Provider {
    
     Public Static void RemovePracticefromProvider(List<HealthcarePractitionerFacility> ListHPF){
        Id PrcRecordType = Schema.SObjectType.HealthcarePractitionerFacility.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        System.debug('PrcRecordType Test---->'+PrcRecordType);
        Id ProRecordType = Schema.SObjectType.HealthcarePractitionerFacility.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
        System.debug('ProRecordType---->'+ProRecordType);
        Id profileId = UserInfo.getProfileId();       
        String pfname = '';
        List<Profile> pfnameList = [Select id,name from Profile where id = :profileId limit 1];
        For(Profile p : pfnameList){
            pfname = p.Name;
        }
        
        Set<Id> HPFID = New Set<Id>();
        Set<Id> HPFSiblingID = New Set<Id>();
        IF(pfname!=NULL && (pfname == 'FPAN Agent SuperBusinessAdmin' || pfname == 'System Administrator')){
            For(HealthcarePractitionerFacility HPF : ListHPF){
                HPFID.add(HPF.Id);
                system.debug('HPFID Test----->' +HPFID);
                if(HPF.RecordtypeID == PrcRecordType){
                    List<HealthcarePractitionerFacility> PraHPFList = [Select Id,name,RecordtypeID, FPAN_Facility_Sibling_Id__c from HealthcarePractitionerFacility where Id IN: HPFID And RecordtypeID =: PrcRecordType];
                    System.debug('PraHPFList Test----->'+PraHPFList);
                    For(HealthcarePractitionerFacility HPF1:PraHPFList){
                        If(HPF1.FPAN_Facility_Sibling_Id__c != Null){
                            System.debug('SiblingID Test---->'+HPF1.FPAN_Facility_Sibling_Id__c);
                            HPFSiblingID.add(HPF1.FPAN_Facility_Sibling_Id__c);
                            // System.debug('HPFSiblingID@@@'+HPFSiblingID);
                        }
                        
                    }
                    
                }
                else if(HPF.RecordtypeID == ProRecordType){
                    List<HealthcarePractitionerFacility> ProHPFList = [Select Id,name,RecordtypeID, FPAN_Facility_Sibling_Id__c from HealthcarePractitionerFacility where Id IN: HPFID And RecordtypeID =: ProRecordType];
                    System.debug('ProHPFList Test----->'+ProHPFList);
                    For(HealthcarePractitionerFacility HPF1:ProHPFList){
                        If(HPF1.FPAN_Facility_Sibling_Id__c != Null){
                            System.debug('SiblingID TestPro---->'+HPF1.FPAN_Facility_Sibling_Id__c);
                            HPFSiblingID.add(HPF1.FPAN_Facility_Sibling_Id__c);
                            
                        }
                        
                    }                    
                }   
                List<HealthcarePractitionerFacility> DelHPFSib = [Select Id,name, FPAN_Facility_Sibling_Id__c from HealthcarePractitionerFacility where Id IN: HPFSiblingID];
                system.debug('DelHPFSib Test--->' +DelHPFSib);
                try{ 
                    delete DelHPFSib;
                   }catch(exception e){
                       System.debug('Exception-->'+e);
                        FPAN_APEX_HandleSystemException.LogException(e);
                   }
            }
        }
    }
}