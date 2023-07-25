/************************************************************************
* Name : FPAN_Apex_ReCredExtensionControllerTest
* Author : Ravi Kumar
* Date : 22/Dec/2021
* Desc : Test class for FPAN_Apex_ReCredExtensionController
*************************************************************************/
@isTest
public with sharing class FPAN_Apex_ReCredExtensionControllerTest {
    
    private static testMethod void ReCredExtensionControllerTest() {
    test.startTest();
     String myStartDate= String.valueOf(System.Today()-10) ;
    String myEndDate = String.valueof(System.Today()-6);    
    String startDate = String.valueof(System.Today() - 2);
    String endDate = String.valueof(System.Today());
    Id ProviderRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
    Id ProviderLocationRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
         HealthcareProviderNpi npiObj = new HealthcareProviderNpi();
        npiObj = new HealthcareProviderNpi (
            Name = '5673452223',
            Npi = '5673452223',
        	IsActive = True);
            
        INSERT npiObj;
        Account acc= new Account();
            acc.Name = 'TestAcc';
            acc.FPAN_First_Name__c = 'FPAN';
            acc.FPAN_Last_Name__c = 'FAIRVIEW';
            acc.FPAN_MI__c = 'M1Dev';
            acc.FPAN_Title__c = 'CNM';
            acc.FPAN_Provider_Business_Email__c = 'fpanm1dev@fairview.org';
            acc.FPAN_DOB__c = Date.newInstance(1987, 06, 20);
            acc.phone = '9876543210';
            acc.FPAN_Provider_Status__c = 'Inactive';  
            acc.RecordTypeId = ProviderRecordType;
            acc.FPAN_Provider_NPI__c=npiObj.Id;
        Insert acc;
        
         Account acc2 = new Account();
            acc2.Name = 'TestAcc';
            acc2.RecordTypeId = ProviderLocationRecordType;   
            acc2.FPAN_Clinic_Fed_Id__c = '1234567890';
            acc2.FPAN_Practice_Speciality__c = 'Dermatology';
            acc2.Website = 'www.google.com';    
        Insert acc2;
        
        Id RecordType = Schema.SObjectType.HealthcarePractitionerFacility.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        HealthcarePractitionerFacility HPF = New HealthcarePractitionerFacility();
            HPF.Name = 'Mercy Medical Centre';
            HPF.FPAN_FPA_Status__c = 'Member';
            HPF.FPAN_Practice_Name__c = acc2.id;
            HPF.AccountId = acc.id;
            HPF.RecordtypeID = RecordType;
        Insert HPF;
        
        /*HealthcarePractitionerFacility HPF2 = New HealthcarePractitionerFacility();
            HPF2.Name = 'Mercy Medical Centre';
            HPF2.FPAN_FPA_Status__c = 'Member';
            HPF2.FPAN_Practice_Name__c = acc2.id;
            HPF2.AccountId = acc.id;
            HPF2.RecordtypeID = RecordType;
            HPF2.FPAN_FPA_Membership_Effective_Date__c = System.Today();
        Insert HPF2;*/
        
        Schema.Location loc = new Schema.location();
            loc.name = 'LocationName';
            loc.locationtype = 'New';
        Insert Loc;
        
       Schema.Address add = new Schema.Address();
            add.city = 'TN';
            add.state = 'JKKJ';
            add.country = 'India';
            add.FPAN_Fax__c = '1234876541';
            add.FPAN_Phone__c = '1029384756';
            add.ParentId =Loc.id;
        insert add;
        
        AssociatedLocation aloc = new AssociatedLocation();
            aloc.LocationId = Loc.Id;
            aloc.ParentRecordId = acc.Id;
            aloc.FPAN_Provider_Mail_Site__c = TRUE;
        Insert aloc;
        
        vlocity_ins__ProviderNetwork__c Cred = New vlocity_ins__ProviderNetwork__c();
            Cred.FPAN_Practice_Account__c = HPF.ID;
            Cred.FPAN_Provider_Account__c = acc.Id;
            Cred.FPAN_FPA__c = TRUE;
            Cred.FPAN_FPA_C_C_A_S__c = 'Approved';
            Cred.FPAN_FPA_C_C_A_D__c = System.Today();
            Cred.FPAN_FPA_Sent_as_Standard_Date__c = System.Today();
            
        Insert Cred;
        
       /* vlocity_ins__ProviderNetwork__c Cred2 = New vlocity_ins__ProviderNetwork__c();
            Cred2.FPAN_Practice_Account__c = HPF2.ID;
            Cred2.FPAN_Provider_Account__c = acc.Id;
            Cred2.FPAN_FPA__c = TRUE;
            Cred2.FPAN_FPA_C_C_A_S__c = 'Approved';
            Cred2.FPAN_FPA_C_C_A_D__c = System.Today();
            Cred2.FPAN_FPA_Sent_as_Standard_Date__c = System.Today();
            Cred2.FPAN_FVCL__c = TRUE;
            Cred2.FPAN_FVCL_C_C_A_S__c = 'Approved';
            Cred2.FPAN_FVCL_C_C_A_D__c = System.Today();
            Cred2.FPAN_FVCL_Sent_as_Standard_Date__c = System.Today();
        Insert Cred2;*/
        
        
       /* vlocity_ins__ProviderNetworkMember__c ReCred = New vlocity_ins__ProviderNetworkMember__c();
            ReCred.vlocity_ins__ProviderNetworkId__c = Cred.ID;
            ReCred.vlocity_ins__ProviderAccountId__c = acc.Id;
            ReCred.FPAN_FPA__c = TRUE;
            ReCred.FPAN_FPA_R_C_C_A_Status__c = 'Approved';
            ReCred.FPAN_FPA_Reappointment_Due_Date__c = System.Today();
            ReCred.FPAN_FPA_R_C_C_A_Date__c = System.Today();
        Insert ReCred;*/
        
        vlocity_ins__ProviderNetworkMember__c ReCred2 = New vlocity_ins__ProviderNetworkMember__c();
             ReCred2.vlocity_ins__ProviderNetworkId__c = Cred.ID;
             ReCred2.vlocity_ins__ProviderAccountId__c = acc.Id;
             ReCred2.FPAN_FPA__c = TRUE;
             ReCred2.FPAN_FPA_R_C_C_A_Status__c = 'Approved';
             ReCred2.FPAN_FPA_Reappointment_Due_Date__c = System.Today();
             ReCred2.FPAN_FPA_R_C_C_A_Date__c = System.Today();
             ReCred2.FPAN_FVCL__c = TRUE;
             ReCred2.FPAN_FVCL_R_C_C_A_Status__c = 'Approved';
             ReCred2.FPAN_FVCL_Reappointment_Due_Date__c = System.Today();
             ReCred2.FPAN_FVCL_R_C_C_A_Date__c = System.Today();
        Insert ReCred2;
             
        
        //FPAN_Apex_ReCredExtensionController RecCred = New FPAN_Apex_ReCredExtensionController();
         
        
    test.stopTest();    
        FPAN_Apex_ReCredExtensionController.createRecredRecs(startDate,endDate);
        FPAN_Apex_ReCredExtensionController.createRecredRecs(myStartDate,myEndDate);
         FPAN_Apex_ReCredExtensionController.fetchUser();
    }
}