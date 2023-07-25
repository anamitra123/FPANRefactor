/**************************************************************************************************
* Name : FPAN_Acc_Fac_Spec_Controller
* Author : Gaana Shetty/Sreeni
* Date : 02/09/2022
* Desc : Apex class for FPAN_Account_Facility_Specialities component.
****************************************************************************************************/

public class FPAN_Acc_Fac_Spec_Controller{   
    @AuraEnabled
    public static list<productwrapper> findByName(String searchKey) {
        
        list<productwrapper> recordlist = new list<productwrapper>();
        String name = searchKey+'%';
        String pracName = '';
        system.debug('name------'+name);
        
        List<CareProviderFacilitySpecialty> acc = new List<CareProviderFacilitySpecialty>();
        List <String> AccName = new List<String>();
        
        if(searchKey.length() <=0 ) {
            acc = [Select AccountId, Account.Name, Account.FPAN_First_Name__c, Account.FPAN_Last_Name__c, Account.FPAN_MI__c, 
                   Account.FPAN_Title__c, Account.FPAN_Provider_NPI__r.Name, Account.FPAN_Provider_Business_Email__c, Account.Id, 
                   Account.FPAN_Provider_Status__c, Facility_Name__c, FPAN_Practice_Status__c, FPAN_Fed_ID__c, 
                   FPAN_Practice_Clinic_Network__c, FPAN_FPA_Status__c, PractitionerFacility.FPAN_FPA_Membership_Effective_Date__c, 
                   PractitionerFacility.FPAN_FPA_Membership_Term_Resign_Date__c, PractitionerFacility.FPAN_Shared_Savings_Included__c, 
                   PractitionerFacility.FPAN_PSA__c, PractitionerFacility.FPAN_Provider_Practice_Directory__c, Name, FPAN_FTE__c, 
                   FPAN_Primary_Facility__c, IsPrimarySpecialty, PractitionerFacilityId, PractitionerFacility.FPAN_Facility_Sibling_Id__c, IsActive 
                   From CareProviderFacilitySpecialty where PractitionerFacility.FPAN_Facility_Sibling_Id__c != '' and 
                   (Account.FPAN_Provider_Status__c = 'Active' or Account.FPAN_Provider_Status__c = 'Inactive' )];
            system.debug('acc--->' +acc);
        } else {
            acc = [Select AccountId, Account.Name, Account.FPAN_First_Name__c, Account.FPAN_Last_Name__c, Account.FPAN_MI__c, 
                   Account.FPAN_Title__c, Account.FPAN_Provider_NPI__r.Name, Account.FPAN_Provider_Business_Email__c, Account.Id, 
                   Account.FPAN_Provider_Status__c, Facility_Name__c, FPAN_Practice_Status__c, FPAN_Fed_ID__c, FPAN_Practice_Clinic_Network__c, 
                   FPAN_FPA_Status__c, PractitionerFacility.FPAN_FPA_Membership_Effective_Date__c, 
                   PractitionerFacility.FPAN_FPA_Membership_Term_Resign_Date__c, PractitionerFacility.FPAN_Shared_Savings_Included__c, 
                   PractitionerFacility.FPAN_PSA__c, PractitionerFacility.FPAN_Provider_Practice_Directory__c, Name, FPAN_FTE__c, 
                   FPAN_Primary_Facility__c, IsPrimarySpecialty, PractitionerFacilityId, PractitionerFacility.FPAN_Facility_Sibling_Id__c, IsActive 
                   From CareProviderFacilitySpecialty where PractitionerFacility.FPAN_Facility_Sibling_Id__c != '' and 
                   Account.FPAN_Provider_Status__c LIKE :name ];
            system.debug('acc--->' +acc);
        }
        for(CareProviderFacilitySpecialty acct: acc){
            AccName.add(acct.PractitionerFacility.FPAN_Facility_Sibling_Id__c);
            
        }
        system.debug('AccName--->'+AccName);
        
        //List<HealthcarePractitionerFacility> accRec = new List<HealthcarePractitionerFacility>();
        List<AssociatedLocationCloned__c> accLoc = new List<AssociatedLocationCloned__c>();
		Map<Id,AssociatedLocationCloned__c> MapOfaccLoc = new Map<Id,AssociatedLocationCloned__c>();
		
		
        
        //for(String act: AccName){
        if (AccName != null) {
            accLoc = [SELECT Id, FPAN_Provider_Facilities__c, FPAN_Address__c, FPAN_State__c, FPAN_City__c, FPAN_Phone__c, FPAN_Fax__c, 
                      FPAN_Suite_No__c, FPAN_County__c, FPAN_Site_NPI__c, FPAN_Provider_PCC__c, FPAN_FPA_Main_Site__c, 
					  FPAN_Provider_Mail_Site__c,  FPAN_Provider_Directory_Main__c, FPAN_Provider_Site_Directory__c 
                      FROM AssociatedLocationCloned__c where FPAN_Provider_Facilities__c IN: AccName and FPAN_Provider_Facilities__c != ''];
            system.debug('accLoc--->' +accLoc);
        }
		
		for(AssociatedLocationCloned__c al : accLoc){
			MapOfaccLoc.put(al.FPAN_Provider_Facilities__c,al);
		
		}
		
        // }
        try{
        if(!acc.isEmpty()){
            //Test Code-Start
            //list<productwrapper> recordlist = new list<productwrapper>();
            
            for(CareProviderFacilitySpecialty cps : acc){
                //for(AssociatedLocationCloned__c alc :accLoc){
				if(MapOfaccLoc.containskey(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c)){

                    //if(alc.FPAN_Provider_Facilities__c == cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c){
                        productwrapper pw = new productwrapper(cps.Account.Name,cps.Account.FPAN_First_Name__c,
                                                               cps.Account.FPAN_Last_Name__c, cps.Account.FPAN_MI__c, 
                                                               cps.Account.FPAN_Title__c, cps.Account.FPAN_Provider_NPI__r.Name,
                                                               cps.Account.FPAN_Provider_Business_Email__c, cps.Facility_Name__c, 
                                                               cps.FPAN_Practice_Status__c, cps.FPAN_Fed_ID__c, 
                                                               cps.FPAN_Practice_Clinic_Network__c, cps.FPAN_FPA_Status__c, 
                                                               cps.PractitionerFacility.FPAN_FPA_Membership_Effective_Date__c, 
                                                               cps.PractitionerFacility.FPAN_FPA_Membership_Term_Resign_Date__c, 
                                                               cps.PractitionerFacility.FPAN_Shared_Savings_Included__c,
                                                               cps.PractitionerFacility.FPAN_PSA__c,
                                                               cps.Name, cps.IsActive,
                                                               cps.FPAN_FTE__c, cps.IsPrimarySpecialty,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_Address__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_State__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_City__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_Phone__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_Suite_No__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_County__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_Site_NPI__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_Provider_Directory_Main__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_Provider_PCC__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_FPA_Main_Site__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_Provider_Mail_Site__c,
															   MapOfaccLoc.get(cps.PractitionerFacility.FPAN_Facility_Sibling_Id__c).FPAN_Provider_Site_Directory__c);
															   /* 
															   alc.FPAN_Address__c, 
                                                               alc.FPAN_State__c, alc.FPAN_City__c, alc.FPAN_Phone__c,
                                                               alc.FPAN_Suite_No__c, alc.FPAN_County__c, alc.FPAN_Site_NPI__c, 
                                                               alc.FPAN_Site_Closed_Formula__c, alc.FPAN_Site_Closed_Effective_Date__c, 
                                                               alc.FPAN_FPA_Main_Site__c,
                                                               alc.FPAN_Provider_Mail_Site__c,
                                                               alc.FPAN_Provider_Site_Directory__c);
															   */                
                        recordlist.add(pw);
                    }
                }
            //}
            System.debug('New Wrapper-->'+recordlist);
            ////Test Code-End
        }
        } catch(Exception e){
                System.debug('Exception occurred'+e.getMessage());
                FPAN_APEX_HandleSystemException.LogException(e);
        }
        return recordlist;
		
    }
    
    public class productwrapper{
        @AuraEnabled
        public string ProviderId { get; set;}
        @AuraEnabled
        public string ProviderName { get; set;}
        @AuraEnabled
        public string ProviderFirstName { get; set;}
        @AuraEnabled
        public string ProviderLastName { get; set;}
        @AuraEnabled
        public string ProviderMI { get; set;}
        @AuraEnabled
        public string ProviderTitle { get; set;}
        @AuraEnabled
        public string ProviderNPI { get; set;}
        @AuraEnabled
        public  string ProviderEmail  { get; set;}
        @AuraEnabled
        public  string PracticeName  { get; set;}
        @AuraEnabled
        public  string PracticeStatus  { get; set;}
        @AuraEnabled
        public  string FEDId  { get; set;}
        @AuraEnabled
        public  string ClinicNetwork  { get; set;}
        @AuraEnabled
        public  string FPAStatus  { get; set;}
        @AuraEnabled
        public  date FPAEffDate  { get; set;}
        @AuraEnabled
        public  date FPATermDate  { get; set;}
        @AuraEnabled
        public  boolean SharedSavingsIncluded  { get; set;}
        @AuraEnabled
        public  boolean PSA  { get; set;}
        @AuraEnabled
        public  string SpecialtyName  { get; set;}
        @AuraEnabled
        public  boolean Active  { get; set;}
        @AuraEnabled
        public  decimal FTE  { get; set;}
        @AuraEnabled
        public  boolean PrimarySpecialty  { get; set;}
        @AuraEnabled
        public  string Address  { get; set;}
        @AuraEnabled
        public  string State  { get; set;}
        @AuraEnabled
        public  string City  { get; set;}
        @AuraEnabled
        public  string Phone  { get; set;}
        @AuraEnabled
        public  string SuiteNo  { get; set;}
        @AuraEnabled
        public  string County  { get; set;}
        @AuraEnabled
        public  string SiteNPI  { get; set;}
        @AuraEnabled
        public  boolean ProvDirMain  { get; set;}
        @AuraEnabled
        public  boolean ProvPCC  { get; set;}
        @AuraEnabled
        public  boolean FPAMainSite  { get; set;}
        @AuraEnabled
        public  boolean ProviderMailSite  { get; set;}
        @AuraEnabled
        public  boolean ProviderSiteDir  { get; set;}
        public productwrapper(String provName, String provFirstName, String provLastName, String provMI, String provTitle, String provNPI,
                              String provEmail, String pracName, String pracStatus, String fedId, String clinicNw, 
                              String fpaStatus, Date fpaEffDate, Date fpaTermDate, Boolean sharedSavingsIncluded, Boolean psa,
                              String specName, Boolean active, Decimal FTE, Boolean primSpec, String locAddr, String State, 
                              String City, String Phone, String suiteNo, String County, String siteNpi, Boolean provDirMain, 
                              Boolean provPCC, Boolean fpaMain, Boolean provMail, Boolean provSiteDir){
                                  this.ProviderName = provName;
                                  this.ProviderFirstName = provFirstName;
                                  this.ProviderLastName = provLastName;
                                  this.ProviderMI = provMI;
                                  this.ProviderTitle = provTitle;
                                  this.ProviderNPI = provNPI;
                                  this.ProviderEmail = provEmail;
                                  this.PracticeName = pracName;
                                  this.PracticeStatus = pracStatus;
                                  this.FEDId = fedId;
                                  this.ClinicNetwork = clinicNw;
                                  this.FPAStatus = fpaStatus;
                                  this.FPAEffDate = fpaEffDate;
                                  this.FPATermDate = fpaTermDate;
                                  this.SharedSavingsIncluded = sharedSavingsIncluded;
                                  this.PSA = psa;
                                  this.SpecialtyName = specName;
                                  this.Active = active;
                                  this.FTE = FTE;
                                  this.PrimarySpecialty = primSpec;
                                  this.Address = locAddr;
                                  this.State = State;
                                  this.City = City;
                                  this.County = County;
                                  this.Phone = Phone;
                                  this.SuiteNo = suiteNo;
                                  this.SiteNPI = siteNpi;
                                  this.ProvDirMain = provDirMain;
                                  this.ProvPCC = provPCC; 
                                  this.FPAMainSite = fpaMain; 
                                  this.ProviderMailSite = provMail; 
                                  this.ProviderSiteDir = provSiteDir;
                              }
    }
}