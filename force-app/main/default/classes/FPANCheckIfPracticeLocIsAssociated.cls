public class FPANCheckIfPracticeLocIsAssociated {

    public static void OnAfterInsert(List <AssociatedLocation> AslocListInsert){
        Set <Id> InitialPFId = new Set <Id>();
        Set <Id> PracticeId = new Set<Id>();
        Set <Id> LocId = new Set<Id>();
        List <HealthcarePractitionerFacility> InitialPFlist = new List <HealthcarePractitionerFacility>();
        List <AssociatedLocation> PracAssocList = new List <AssociatedLocation>();
        for(AssociatedLocation Asloc: AslocListInsert){
            system.debug('chkAsloc.LocationId@@'+Asloc.LocationId);
            system.debug('chkAsloc.FPAN_Provider_Facilities__c@@'+Asloc.FPAN_Provider_Facilities__c);
            if(Asloc.LocationId != null && Asloc.FPAN_Provider_Facilities__c != null)
            {
                InitialPFId.add(Asloc.FPAN_Provider_Facilities__c);
                LocId.add(Asloc.LocationId);
            }
            system.debug('chlInitialPFId@@'+InitialPFId);
            system.debug('LocId@@'+LocId);
            }
            InitialPFlist = [select Id, FPAN_Practice_Name__c, AccountId from HealthcarePractitionerFacility WHERE ID IN :InitialPFId];
            system.debug('chkInitialPFlist@@'+InitialPFlist);
            if (InitialPFlist.Size()>0){
                for(HealthcarePractitionerFacility PracHPF: InitialPFlist){                    
                    PracticeId.add(PracHPF.AccountId);                    
                }
                system.debug('PracticeId@@@@'+PracticeId);
                PracAssocList = [select Id,FPAN_Billing_Site__c,FPAN_Admin_Site__c,FPAN_Practice_Site__c,FPAN_Directory_Print__c,FPAN_Main_Practice_Site__c from AssociatedLocation WHERE ParentRecordId IN :PracticeId AND recordtype.name = 'Practice Location' AND LocationId IN :LocId];
                system.debug('CheckPracAssocList@@'+ PracAssocList);
                for(AssociatedLocation Asloc: AslocListInsert){
                for(AssociatedLocation PracAssocLoc : PracAssocList){                    
                    if(PracAssocLoc.FPAN_Billing_Site__c == true && PracAssocLoc.FPAN_Admin_Site__c == true && PracAssocLoc.FPAN_Practice_Site__c == false && PracAssocLoc.FPAN_Directory_Print__c == false && PracAssocLoc.FPAN_Main_Practice_Site__c == false){
                        system.debug('Both@@');
                        Asloc.addError('The associated Location is already associated as Billing and Admin Sites for practice');
                    }else if(PracAssocLoc.FPAN_Billing_Site__c == true && PracAssocLoc.FPAN_Practice_Site__c == false && PracAssocLoc.FPAN_Directory_Print__c == false && PracAssocLoc.FPAN_Main_Practice_Site__c == false){
                        system.debug('Billing@@');
                        Asloc.addError('The associated Location is already associated as Billing Site for practice');
                    }else if(PracAssocLoc.FPAN_Admin_Site__c == true && PracAssocLoc.FPAN_Practice_Site__c == false && PracAssocLoc.FPAN_Directory_Print__c == false && PracAssocLoc.FPAN_Main_Practice_Site__c == false){
                         system.debug('Admin@@');
                        Asloc.addError('The associated Location is already associated as Admin Site for practice');
                    } else{}
                }
                }
            }
        //}
    }
    public static void OnAfterUpdate(List <AssociatedLocation> AslocListUpdate){
        
        Set <Id> InitialPFId = new Set <Id>();
        Set <Id> PracticeId = new Set<Id>();
        Set <Id> LocId = new Set<Id>();
        List <HealthcarePractitionerFacility> InitialPFlist = new List <HealthcarePractitionerFacility>();
        List <AssociatedLocation> PracAssocList = new List <AssociatedLocation>();
        for(AssociatedLocation Asloc: AslocListUpdate){
            system.debug('UPchkAsloc.LocationId@@'+Asloc.LocationId);
            system.debug('UPchkAsloc.FPAN_Provider_Facilities__c@@'+Asloc.FPAN_Provider_Facilities__c);
            if(Asloc.LocationId != null && Asloc.FPAN_Provider_Facilities__c != null)
            {
                InitialPFId.add(Asloc.FPAN_Provider_Facilities__c);
                LocId.add(Asloc.LocationId);
            }
            system.debug('upchlInitialPFId@@'+InitialPFId);
            system.debug('upLocId@@'+LocId);
            }
            InitialPFlist = [select Id, FPAN_Practice_Name__c, AccountId from HealthcarePractitionerFacility WHERE ID IN :InitialPFId];
            system.debug('upchkInitialPFlist@@'+InitialPFlist);
            if (InitialPFlist.Size()>0){
                for(HealthcarePractitionerFacility PracHPF: InitialPFlist){                    
                    PracticeId.add(PracHPF.AccountId);                    
                }
                system.debug('upPracticeId@@@@'+PracticeId);
                PracAssocList = [select Id,FPAN_Billing_Site__c,FPAN_Admin_Site__c,FPAN_Practice_Site__c,FPAN_Directory_Print__c,FPAN_Main_Practice_Site__c from AssociatedLocation WHERE ParentRecordId IN :PracticeId AND recordtype.name = 'Practice Location' AND LocationId IN :LocId];
                system.debug('upCheckPracAssocList@@'+ PracAssocList);
                for(AssociatedLocation Asloc: AslocListUpdate){
                for(AssociatedLocation PracAssocLoc : PracAssocList){                    
                    if(PracAssocLoc.FPAN_Billing_Site__c == true && PracAssocLoc.FPAN_Admin_Site__c == true && PracAssocLoc.FPAN_Practice_Site__c == false && PracAssocLoc.FPAN_Directory_Print__c == false && PracAssocLoc.FPAN_Main_Practice_Site__c == false){
                        system.debug('upBoth@@');
                        Asloc.addError('The associated Location is already associated as Billing and Admin Sites for practice');
                    }else if(PracAssocLoc.FPAN_Billing_Site__c == true && PracAssocLoc.FPAN_Practice_Site__c == false && PracAssocLoc.FPAN_Directory_Print__c == false && PracAssocLoc.FPAN_Main_Practice_Site__c == false){
                        system.debug('Billing@@');
                        Asloc.addError('The associated Location is already associated as Billing Site for practice');
                    }else if(PracAssocLoc.FPAN_Admin_Site__c == true && PracAssocLoc.FPAN_Practice_Site__c == false && PracAssocLoc.FPAN_Directory_Print__c == false && PracAssocLoc.FPAN_Main_Practice_Site__c == false){
                         system.debug('Admin@@');
                        Asloc.addError('The associated Location is already associated as Admin Site for practice');
                    } else{}
                }
                }
            }
        //}
    }
    
}