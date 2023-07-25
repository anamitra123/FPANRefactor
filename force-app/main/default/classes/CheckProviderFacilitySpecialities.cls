/**************************************************************************************************
* Name : CheckProviderFacilitySpecialities
* Author : Mayank Verma/Gaana Shetty
* Date : 07/17/2022
* Desc : Apex class for FTERollUpOnAccount
****************************************************************************************************/

public class CheckProviderFacilitySpecialities {
    Public Static void checkProviderFacSpe(List<HealthcarePractitionerFacility> Ids){
        
        Id RecordType = Schema.SObjectType.HealthcarePractitionerFacility.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        Id profileId = UserInfo.getProfileId();       
        String pfname = '';
        List<Profile> pfnameList = [Select id,name from Profile where id = :profileId limit 1];
        For(Profile p : pfnameList){
            pfname = p.Name;
        }
        
        IF(pfname!=NULL && (pfname == 'FPAN Agent SuperBusinessAdmin' || pfname == 'System Administrator')){
            
            //Map<String,HealthcarePractitionerFacility> SibId = New Map<String,HealthcarePractitionerFacility>();
            Set<Id> HPFSiblingID = New Set<Id>();
            
            Set<Id> HPFID = New Set<Id>();
            For(HealthcarePractitionerFacility HPF : Ids){
                HPFID.add(HPF.Id); 
                If(HPF.FPAN_Facility_Sibling_Id__c != Null){
                    HPFSiblingID.add(HPF.FPAN_Facility_Sibling_Id__c);
                    System.debug('HPFSiblingID---->'+HPFSiblingID);
                }
                /*SibId.put(HPF.FPAN_Facility_Sibling_Id__c,HPF);
System.debug('SibId----->' +SibId);*/
            }
            
            //To get list of Provider Facility Specialities records related to a Provider Facility
            list<CareProviderFacilitySpecialty> CPFSList = [select id, name,Facility_Name__c,PractitionerFacilityId from CareProviderFacilitySpecialty where PractitionerFacilityId IN: HPFID OR PractitionerFacilityId IN: HPFSiblingID];
            System.debug('CPFSList--'+CPFSList);
            //To get list of Credentialing/Membership records related to a Provider Facility
            list<vlocity_ins__ProviderNetwork__c> CMlist = [select id, FPAN_Practice_Account__c from vlocity_ins__ProviderNetwork__c where FPAN_Practice_Account__c IN: HPFID OR FPAN_Practice_Account__c IN: HPFSiblingID];
            System.debug('CMlist--'+CMlist);
            //To get list of Associated Location records related to a Provider Facility
            list<AssociatedLocation> ALlist = [select id, FPAN_Provider_Facilities__c from AssociatedLocation where FPAN_Provider_Facilities__c IN: HPFSiblingID OR FPAN_Provider_Facilities__c IN: HPFID];
            System.debug('ALlist--'+ALlist);
            
            Map<Id,HealthcarePractitionerFacility> HPFsError = New Map<Id,HealthcarePractitionerFacility>(Ids);
            
            if(CPFSList.Size() > 0){
                For(HealthcarePractitionerFacility HPF1 : Ids){
                    For(CareProviderFacilitySpecialty CPFS : CPFSList){
                        If(CPFS.PractitionerFacilityId == HPF1.ID || CPFS.PractitionerFacilityId == HPF1.FPAN_Facility_Sibling_Id__c){
                            HPFsError.get(HPF1.Id).addError(Label.FPAN_Specialty_Delete);
                        }
                    }
                    
                }
            } else if(CMlist.Size() > 0){
                For(HealthcarePractitionerFacility HPF1 : Ids){
                    For(vlocity_ins__ProviderNetwork__c CM : CMlist){
                        If(CM.FPAN_Practice_Account__c == HPF1.ID || CM.FPAN_Practice_Account__c == HPF1.FPAN_Facility_Sibling_Id__c){
                            HPFsError.get(HPF1.Id).addError(Label.FPAN_C_M_Delete);
                        }
                    }
                }
            } else if(ALlist.Size() > 0){
                For(HealthcarePractitionerFacility HPF1 : Ids){
                    if(HPF1.FPAN_Facility_Sibling_Id__c != Null) {
                        For(AssociatedLocation AL : ALlist){
                            If(AL.FPAN_Provider_Facilities__c == HPF1.FPAN_Facility_Sibling_Id__c || AL.FPAN_Provider_Facilities__c == HPF1.ID){
                                HPFsError.get(HPF1.Id).addError(Label.FPAN_A_L_Delete_for_Provider);
                            }
                            
                        }
                    }
                } 
            }
        }
    }
}