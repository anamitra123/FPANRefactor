/************************************************************************
* Name : FPAN_CheckPrimarySpeciality
* Author : Ravi Kumar
* Date : 21/JAN/2021
* Desc : Test class for FPAN_CheckPrimarySpeciality
*************************************************************************/

public class FPAN_CheckPrimarySpeciality {
    
    public static void afterinsert(List <CareProviderFacilitySpecialty > CPFSListInsert) {
        Set<ID> SETID = New Set<ID>(); 
        Set<ID> PFID = New Set<ID>();
        for(CareProviderFacilitySpecialty CPFS : CPFSListInsert){
            If(CPFS.IsPrimarySpecialty == TRUE){
                SETID.add(CPFS.Id);
                PFID.add(CPFS.PractitionerFacilityId);
            }            
        }
        
        lIST<CareProviderFacilitySpecialty> lISTcpfs = New lIST<CareProviderFacilitySpecialty>();
        lISTcpfs = [Select Id,Name,IsPrimarySpecialty,PractitionerFacilityId From CareProviderFacilitySpecialty Where PractitionerFacilityId IN:PFID AND IsPrimarySpecialty = TRUE AND Id NOT IN:SETID];
        
        for(CareProviderFacilitySpecialty CP : lISTcpfs){
            CP.IsPrimarySpecialty = False;
            
            //Update lISTcpfs;
            //CP.addError('Primary Checkbox should be One'); 
            try {
                Update lISTcpfs;
                
            } catch (exception ex) {
                for (CareProviderFacilitySpecialty cpf: CPFSListInsert) {
                    string x = ex.getMessage();
                    if (x.contains('FTE')) {
                        cpf.addError('Provider FTE should not exceed 1');
                    } else {
                        //System.debug('Hi@@@@@@' + ex.getMessage());
                        cpf.addError('There is error occured in trigger execution');
                    }
                }
            }
            
            
        }
    }
    
    //updatefacility method is for updating the providerfacility's Speciality Name with PFSpeciality Name --Sreeni
    public static void updatefacility(List<CareProviderFacilitySpecialty> CPFSList){
        SET<Id> pfIds = new SET<Id>();
        SET<Id> pfIds2 = new SET<Id>();
        SET<Id> pfVVIds = new SET<Id>();
        SET<Id> pfVVAccIds = new SET<Id>();
        Map<Id,String> pfMap = new Map<Id,String>();
        Map<Id,String> pfMap2 = new Map<Id,String>();
        Map<Id,String> pfVVMap = new Map<Id,String>();
        LIST<HealthcarePractitionerFacility> pfList = new List<HealthcarePractitionerFacility>();
        LIST<HealthcarePractitionerFacility> pfList2 = new List<HealthcarePractitionerFacility>();
        LIST<HealthcarePractitionerFacility> pfListviceversa = new List<HealthcarePractitionerFacility>();
        List<HealthcarePractitionerFacility> updatepfRecs = new List<HealthcarePractitionerFacility>();
        
        for(CareProviderFacilitySpecialty CPFS : CPFSList){
            If(CPFS.IsPrimarySpecialty == TRUE){
                pfIds.add(CPFS.PractitionerFacilityId);
                pfMap.put(CPFS.PractitionerFacilityId, CPFS.Name);
                pfVVIds.add(CPFS.FPAN_Account_Practice_ID__c);
                pfVVAccIds.add(CPFS.AccountId);
                pfVVMap.put(CPFS.AccountId, CPFS.Name);
            }   
            If(CPFS.IsPrimarySpecialty == FALSE){
                pfIds2.add(CPFS.PractitionerFacilityId);
                pfMap2.put(CPFS.PractitionerFacilityId, CPFS.Name);
            }         
        }
        pfList = [SELECT id,FPAN_Specialty_Name__c from HealthcarePractitionerFacility where id IN :pfIds];
        for(HealthcarePractitionerFacility pfRec : pfList){
            pfRec.FPAN_Specialty_Name__c = pfMap.get(pfRec.id);           
            updatepfRecs.add(pfRec);
        }
        pfList2 = [SELECT id,FPAN_Specialty_Name__c from HealthcarePractitionerFacility where id IN :pfIds2];
        for(HealthcarePractitionerFacility pfRec2 : pfList2){
            pfRec2.FPAN_Specialty_Name2__c = pfMap2.get(pfRec2.id);            
            updatepfRecs.add(pfRec2);
        }
        
        pfListviceversa = [SELECT id,FPAN_Specialty_Name__c,AccountId,FPAN_Practice_Name__c from HealthcarePractitionerFacility where FPAN_Practice_Name__c IN :pfVVAccIds AND AccountId IN :pfVVIds];
        if(pfListviceversa.size()>0){
            for(HealthcarePractitionerFacility pfVVRec : pfListviceversa){
                pfVVRec.FPAN_Specialty_Name__c = pfVVMap.get(pfVVRec.FPAN_Practice_Name__c);
                updatepfRecs.add(pfVVRec);
            } 
        }
        
        try{
            update updatepfRecs;
        }catch(exception e){
            System.debug('Exception-->'+e);
            FPAN_APEX_HandleSystemException.LogException(e);
        }
    }
    
    /// after Delete update the Provider Facility Speciality Names
    
     public static void updatePFfacility(List<CareProviderFacilitySpecialty> PFSpecOld) {
     
           set<Id> PfId = new set<Id>();
           String SpecName = '';
            for(CareProviderFacilitySpecialty Spec :PFSpecOld){
                PfId.add(Spec.PractitionerFacilityId);
                SpecName = Spec.Name;
            }
            
           list<HealthcarePractitionerFacility> lstPf = [select id,FPAN_Specialty_Name__c,FPAN_Specialty_Name2__c From HealthcarePractitionerFacility Where Id IN :PfId];
           
            for(HealthcarePractitionerFacility pf :lstPf){
                If(pf.FPAN_Specialty_Name__c == SpecName){
                    pf.FPAN_Specialty_Name__c = '';
                }
                If(pf.FPAN_Specialty_Name2__c == SpecName){
                    pf.FPAN_Specialty_Name2__c = '';
                }
            }
            update lstPf; 
     
     }
}