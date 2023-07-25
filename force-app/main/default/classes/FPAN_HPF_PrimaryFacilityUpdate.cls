public class FPAN_HPF_PrimaryFacilityUpdate {

    public static void OnAfterInsert(Map <Id, AssociatedLocation> newMap){
        Set <Id> FacilityId = new Set <Id>();
        Set <Id> PracticeName = new Set <Id>();
        Set <Id> AccountId = new Set <Id>();
        
        List <HealthcarePractitionerFacility> InitialPFlist = new List <HealthcarePractitionerFacility>();
        List <HealthcarePractitionerFacility> FinalPFlist = new List <HealthcarePractitionerFacility>();
        Map <Id, HealthcarePractitionerFacility> HpfMap = new Map <Id, HealthcarePractitionerFacility>();
        
        for(AssociatedLocation Ass : newMap.Values()){
            if(Ass.FPAN_FPA_Main_Site__c == true && Ass.FPAN_Provider_Facilities__c != null){
                FacilityId.add(Ass.FPAN_Provider_Facilities__c);
            }
        }
        system.debug('FacilityId@@'+ FacilityId);
        
        InitialPFlist = [select Id, FPAN_Practice_Name__c, AccountId from HealthcarePractitionerFacility WHERE ID IN :FacilityId];
        if (InitialPFlist.Size()>0){
        for(HealthcarePractitionerFacility PractiePFList: InitialPFlist){            
            PracticeName.add(PractiePFList.FPAN_Practice_Name__c);
            AccountId.add(PractiePFList.AccountId);
        }           
        system.debug('PracticeName@@'+PracticeName);
        system.debug('AccountId@@'+AccountId);
        }       
        FinalPFlist = [SELECT id,IsPrimaryFacility from HealthcarePractitionerFacility WHERE AccountId IN :PracticeName and FPAN_Practice_Name__c IN :AccountId];
        
        system.debug('FinalPFlist@@@'+FinalPFlist);        
        for(HealthcarePractitionerFacility ParentPF: FinalPFlist){ 
            System.debug('insideForLoop@@@');        
            ParentPF.IsPrimaryFacility = true;            
        }  
        try{
            If(FinalPFlist.Size()>0){
            update FinalPFlist;
        } 
        }catch(Exception e){
             FPAN_APEX_HandleSystemException.LogException(e);
        }
               
    }
    
    public static void OnAfterUpdateUncheck(Map <Id, AssociatedLocation> oldMap, Map <Id, AssociatedLocation> newMap){       
        Set <Id> FacilityId = new Set <Id>();
        Set <Id> PracticeName = new Set <Id>();
        Set <Id> AccountId = new Set <Id>();
        
        List <HealthcarePractitionerFacility> InitialPFlist = new List <HealthcarePractitionerFacility>();
        List <HealthcarePractitionerFacility> FinalPFlist = new List <HealthcarePractitionerFacility>();
        Map <Id, HealthcarePractitionerFacility> HpfMap = new Map <Id, HealthcarePractitionerFacility>();
        
        for(AssociatedLocation Ass : newMap.Values()){
            if(Ass.FPAN_FPA_Main_Site__c == false && Ass.FPAN_Provider_Facilities__c != null){
                FacilityId.add(Ass.FPAN_Provider_Facilities__c);
            }
        }
        system.debug('FacilityId@@'+ FacilityId);
        
        InitialPFlist = [select Id, FPAN_Practice_Name__c, AccountId from HealthcarePractitionerFacility WHERE ID IN :FacilityId];
        if (InitialPFlist.Size()>0){
        for(HealthcarePractitionerFacility PractiePFList: InitialPFlist){            
            PracticeName.add(PractiePFList.FPAN_Practice_Name__c);
            AccountId.add(PractiePFList.AccountId);
        }           
        system.debug('PracticeName@@'+PracticeName);
        system.debug('AccountId@@'+AccountId);
        }       
        FinalPFlist = [SELECT id,IsPrimaryFacility from HealthcarePractitionerFacility WHERE AccountId IN :PracticeName and FPAN_Practice_Name__c IN :AccountId];
        
        system.debug('FinalPFlist@@@'+FinalPFlist);        
        for(HealthcarePractitionerFacility ParentPF: FinalPFlist){ 
            System.debug('insideForLoop@@@');        
            ParentPF.IsPrimaryFacility = false;            
        } 
        try{
            If(FinalPFlist.Size()>0){
            update FinalPFlist;
        }
        }catch(Exception e){
            FPAN_APEX_HandleSystemException.LogException(e);
        }
        
    }
   
    public static void OnAfterUpdateCheck(Map <Id, AssociatedLocation> oldMap, Map <Id, AssociatedLocation> newMap){       
        Set <Id> FacilityId = new Set <Id>();
        Set <Id> PracticeName = new Set <Id>();
        Set <Id> AccountId = new Set <Id>();
        
        List <HealthcarePractitionerFacility> InitialPFlist = new List <HealthcarePractitionerFacility>();
        List <HealthcarePractitionerFacility> FinalPFlist = new List <HealthcarePractitionerFacility>();
        Map <Id, HealthcarePractitionerFacility> HpfMap = new Map <Id, HealthcarePractitionerFacility>();
        
        for(AssociatedLocation Ass : newMap.Values()){
            if(Ass.FPAN_FPA_Main_Site__c == true && Ass.FPAN_Provider_Facilities__c != null){
                FacilityId.add(Ass.FPAN_Provider_Facilities__c);
            }
        }
        system.debug('FacilityId@@'+ FacilityId);
        
        InitialPFlist = [select Id, FPAN_Practice_Name__c, AccountId from HealthcarePractitionerFacility WHERE ID IN :FacilityId];
        if (InitialPFlist.Size()>0){
        for(HealthcarePractitionerFacility PractiePFList: InitialPFlist){            
            PracticeName.add(PractiePFList.FPAN_Practice_Name__c);
            AccountId.add(PractiePFList.AccountId);
        }           
        system.debug('PracticeName@@'+PracticeName);
        system.debug('AccountId@@'+AccountId);
        }       
        FinalPFlist = [SELECT id,IsPrimaryFacility from HealthcarePractitionerFacility WHERE AccountId IN :PracticeName and FPAN_Practice_Name__c IN :AccountId];
        
        system.debug('FinalPFlist@@@'+FinalPFlist);        
        for(HealthcarePractitionerFacility ParentPF: FinalPFlist){ 
            System.debug('insideForLoop@@@');        
            ParentPF.IsPrimaryFacility = true;            
        }        
        try{
            If(FinalPFlist.Size()>0){
                update FinalPFlist;
            }
        }
        catch(exception e){
            system.debug('Exception -->'+e);
            FPAN_APEX_HandleSystemException.LogException(e);
        }
        
    }
    
    public static void OnAfterDelete(Map <Id, AssociatedLocation> oldMap){       
        Set <Id> FacilityId = new Set <Id>();
        Set <Id> PracticeName = new Set <Id>();
        Set <Id> AccountId = new Set <Id>();
        
        List <HealthcarePractitionerFacility> InitialPFlist = new List <HealthcarePractitionerFacility>();
        List <HealthcarePractitionerFacility> FinalPFlist = new List <HealthcarePractitionerFacility>();
        Map <Id, HealthcarePractitionerFacility> HpfMap = new Map <Id, HealthcarePractitionerFacility>();
        
        for(AssociatedLocation Ass : oldMap.Values()){
            if(Ass.FPAN_FPA_Main_Site__c == true && Ass.FPAN_Provider_Facilities__c != null){
                FacilityId.add(Ass.FPAN_Provider_Facilities__c);
            }
        }
        system.debug('FacilityId@@'+ FacilityId);
        
        InitialPFlist = [select Id, FPAN_Practice_Name__c, AccountId from HealthcarePractitionerFacility WHERE ID IN :FacilityId];
        if (InitialPFlist.Size()>0){
        for(HealthcarePractitionerFacility PractiePFList: InitialPFlist){            
            PracticeName.add(PractiePFList.FPAN_Practice_Name__c);
            AccountId.add(PractiePFList.AccountId);
        }           
        system.debug('PracticeName@@'+PracticeName);
        system.debug('AccountId@@'+AccountId);
        }       
        FinalPFlist = [SELECT id,IsPrimaryFacility from HealthcarePractitionerFacility WHERE AccountId IN :PracticeName and FPAN_Practice_Name__c IN :AccountId];
        
        system.debug('FinalPFlist@@@'+FinalPFlist);        
        for(HealthcarePractitionerFacility ParentPF: FinalPFlist){ 
            System.debug('insideForLoop@@@');        
            ParentPF.IsPrimaryFacility = false;            
        } 
        try{
            If(FinalPFlist.Size()>0){
                update FinalPFlist;
            }
        }
        catch(exception e){
            system.debug('Exception -->'+e);
            FPAN_APEX_HandleSystemException.LogException(e);
        }
        
    }
}