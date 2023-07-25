/*------------------------------------------------------------
Author:              Ravi Pothapi
Company:             ITC
Description:         Utility Class for Test Data creation
createAccountInputs: None
Test Class:          Not Applicable
History
<Date>          <Authors Name>     <Brief Description of Change>
7-June-2022     Ravi Pothapi       New TestData Utility Class 
------------------------------------------------------------*/
public without sharing  class FPAN_TestDataUtility_Test {
    
    public static Map<String,Id> recordTypeNameToId = new Map<String,Id>();
    public static FINAL string ACCOUNT_NAME_LABEL = 'TestAccountOne';
    public static FINAL string ACCOUNT_PRAC_NAME_LABEL = 'TestAccountTwo';
    public static FINAL string ACCOUNT_FIRSTNAME_LABEL = 'TestFN';
    public static FINAL string ACCOUNT_LASTNAME_LABEL = 'TestLN';
    public static FINAL string ACCOUNT_MINAME_LABEL = 'TestMI';
    public static FINAL string ACCOUNT_Email_LABEL = 'Fairview.test@gmail.com';
    public static FINAL string ACCOUNT_Phone_LABEL = '9876543210';
    public static FINAL string ACCOUNT_Website_LABEL = 'www.FairviewTest.Org';
    public static FINAL string ACCOUNT_Clinic_Fed_LABEL = '1234567890';
    public static FINAL string ACCOUNT_CPO_TYPE = 'Primary Care';
    public static FINAL string Name_Label = 'Fpan test Rec';
    public static FINAL string Specialty_Name_Label = 'Dermatology';
    public static FINAL string Loc_Name_Label = 'Fpan test Loc';
    public static FINAL string Loc2_Name_Label = 'Fpan test prac Loc';
    public static FINAL string First_Name_Label = 'FPAN';
    public static FINAL string Last_Name_Label = 'Fairview';
    public static FINAL string email = 'FPAN.test@gmail.com';
    public static FINAL Id Contact_RecordTypeId = getRecordTypeIdByDeveloperName('Contact','IndustriesBusiness');
    public static FINAL Id Contact_Asst_RecordTypeId = getRecordTypeIdByDeveloperName('Contact','Assistant');
    public static FINAL string Provider_Facility_NAME_LABEL = 'TestProviderfacilityOne';
    public static FINAL Id Provider_AccRecordTypeId = getRecordTypeIdByDeveloperName('Account','Provider');
    public static FINAL Id Practice_AccRecordTypeId = getRecordTypeIdByDeveloperName('Account','ProviderLocation');
    public static FINAL Id Committee_AccRecordTypeId = getRecordTypeIdByDeveloperName('Account','Committee');
    public static FINAL string Provider_Status = 'Inactive';    
    public static FINAL Date Date_of_Birth = Date.newInstance(1987, 06, 20);
    public static FINAL string Provider_Title = 'CNM';
    public static FINAL string FPA_Status = 'Resigned';
    public static FINAL string FPA_Status_Member = 'Member';
    public static FINAL date System_Today = System.Today();
    public static FINAL date StartDate_System_Today = System.Today() - 10;
    public static FINAL Id ProviderFacilityLoc_RecordTypeId = getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider_Location');
    public static FINAL Id PracticeFacilityLoc_RecordTypeId = getRecordTypeIdByDeveloperName('HealthcarePractitionerFacility','Provider');
    public static FINAL Id AssociatedLocProvider_RecordTypeId = getRecordTypeIdByDeveloperName('AssociatedLocation','Provider_Location');
    public static FINAL Id AssociatedLocPractice_RecordTypeId = getRecordTypeIdByDeveloperName('AssociatedLocation','Practice_Location');
    public static FINAL string phone = '9876543210';
    public static FINAL string fax = '9876543211';
    public static FINAL string city = 'TN';
    public static FINAL string state = 'JKKJ';
    public static FINAL string country = 'India';
    public static FINAL Id Credentialing_RecordTypeId = getRecordTypeIdByDeveloperName('vlocity_ins__ProviderNetwork__c','Credentialing');
    
    public static FINAL Id Membership_RecordTypeId = getRecordTypeIdByDeveloperName('vlocity_ins__ProviderNetwork__c','Membership');
    
    //public static FINAL string Provider_Facility_API = 'HealthcarePractitionerFacility';
    //public static FINAL string Provider_Location_RT = 'Provider_Location';
    public static FINAL string Specialty_NAME = 'Neurology- Vascular';  
     
    public static Id getRecordTypeIdByDeveloperName(String objectName, String recordTypeDeveloperName){
        Map<String,Id> recordTypeNameToId = new Map<String,Id>();
        if(recordTypeNameToId.isEmpty()){
            for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE sobjecttype =: objectName]){
                recordTypeNameToId.put(rt.DeveloperName,rt.Id);
            }
        }
        System.debug('Account Record type Name' + recordTypeNameToId);
        System.debug('Account Record type Id' + recordTypeNameToId.get(recordTypeDeveloperName));
        if(recordTypeNameToId.containsKey(recordTypeDeveloperName)){
            return recordTypeNameToId.get(recordTypeDeveloperName);
        }
        else{
            return NULL;
            
        }
    }
    public static Id CreateNPI(Boolean npi) {

        HealthcareProviderNpi npiObj = new HealthcareProviderNpi();
        npiObj = new HealthcareProviderNpi (
            Name = '5673452222',
            Npi = '5673452222',
        	IsActive = True);
            
        INSERT npiObj;
        return npiObj.Id;
    }
    public static Id CreateNPI2(Boolean npi) {

        HealthcareProviderNpi npiObj = new HealthcareProviderNpi();
        npiObj = new HealthcareProviderNpi (
            Name = '5673452223',
            Npi = '5673452223',
        	IsActive = True);
            
        INSERT npiObj;
        return npiObj.Id;
    }
    
    public static Id CreateProviderAccount(String name) {
		Id npi = FPAN_TestDataUtility_Test.CreateNPI(TRUE);
        Account accObj = new Account();
        accObj = new Account (
            Name = name,
            RecordTypeId = Provider_AccRecordTypeId, //Provider
            FPAN_First_Name__c = ACCOUNT_FIRSTNAME_LABEL,
            FPAN_Last_Name__c = ACCOUNT_LASTNAME_LABEL,
            FPAN_MI__c = ACCOUNT_MINAME_LABEL,
            FPAN_Title__c = Provider_Title,
            FPAN_Provider_Business_Email__c = ACCOUNT_Email_LABEL,
            FPAN_DOB__c = Date_of_Birth,
            Phone = ACCOUNT_Phone_LABEL,
            FPAN_CPO_Type__c = ACCOUNT_CPO_TYPE,
            FPAN_Provider_NPI__c = npi,
            FPAN_Provider_Status__c = Provider_Status);
            
        INSERT accObj;
        return accObj.Id;
    }
    
    public static Id CreatePracticeAccount(String Accname) {

        Account accObj = new Account();
        accObj = new Account (
            Name = 'FPAN',
            FPAN_First_Name__c = 'Test First Name',
            //FPAN_Last_Name__c = 'name', 
            RecordTypeId = Practice_AccRecordTypeId, //Provider Location
            FPAN_Practice_Speciality__c = 'Dermatology',
            Website = ACCOUNT_Website_LABEL,
            FPAN_Clinic_Fed_Id__c = ACCOUNT_Clinic_Fed_LABEL,
            FPAN_Practice_Status__c = 'Affiliate',
            FPAN_CPO_Type__c='Primary Care'
            );
            System.debug('accObj-->'+accObj);
        try{ 
            INSERT accObj;
            return accObj.Id;
        }catch(exception e){
            return null;
            
        }
        
        
    }
    
    public static Id CreateCommitteeMember(String name) {
		Id npi = FPAN_TestDataUtility_Test.CreateNPI2(TRUE);
        Account accObj = new Account();
        accObj = new Account (
            Name = name,
            RecordTypeId = Committee_AccRecordTypeId, //Committee Member
            Description = 'Test Committee Member',
            FPAN_Provider_NPI__c = npi
            );
            
        INSERT accObj;
        
        return accObj.Id;
    }
    
    public static Id CreatePracticeAccount2(String name) {

        Account accObj = new Account();
        accObj = new Account (
            Name = name,
            RecordTypeId = Practice_AccRecordTypeId, //Provider Location
            FPAN_Practice_Speciality__c = 'Radiology',
            Website = ACCOUNT_Website_LABEL,
            FPAN_Clinic_Fed_Id__c = ACCOUNT_Clinic_Fed_LABEL,
            FPAN_Practice_Status__c = 'Member'
            );
            
        INSERT accObj;
        
        return accObj.Id;
    }
    
    public static Id CreateContactRec(Id AccId) {

        Contact conObj = new Contact();
        conObj = new Contact (
            LastName = Last_Name_Label,
            FirstName = First_Name_Label,
            AccountId = AccId,
            Email = email,
            RecordTypeId =  Contact_RecordTypeId // Business            
            );
            
        INSERT conObj;
        
        return conObj.Id;
    }
    
    public static Id CreateAsstContactRec(Id AccId) {

        Contact conObj = new Contact();
        conObj = new Contact (
            LastName = Last_Name_Label,
            FirstName = First_Name_Label,
            AccountId = AccId,
            Email = email,
            RecordTypeId =  Contact_Asst_RecordTypeId // Assistant            
            );
            
        INSERT conObj;
        
        return conObj.Id;
    }
    
    public static Id CreateProviderFacility(String name,Id accId,Id accId2) {

        HealthcarePractitionerFacility HPFObj = new HealthcarePractitionerFacility();
        HPFObj = new HealthcarePractitionerFacility (
            Name = name,
            RecordTypeId = ProviderFacilityLoc_RecordTypeId, // Provider Location
            FPAN_FPA_Status__c = FPA_Status_Member,
            AccountId = accId,
            FPAN_Practice_Name__c = accId2,
            IsPrimaryFacility = TRUE,
            IsActive = TRUE,
            FPAN_Facility_Sibling_Id__c = ''
            );
            
        INSERT HPFObj;       
           
        return HPFObj.Id;
    }
    
    public static Id CreatePracticeFacility(String name,Id accId,Id accId2) {

        HealthcarePractitionerFacility HPFObj = new HealthcarePractitionerFacility();
        HPFObj = new HealthcarePractitionerFacility (
            Name = name,
            RecordTypeId = PracticeFacilityLoc_RecordTypeId, // Provider
            FPAN_FPA_Status__c = FPA_Status,
            AccountId = accId,      
            IsPrimaryFacility = TRUE,
            FPAN_Practice_Name__c = accId2,
            IsActive = TRUE,
            FPAN_Facility_Sibling_Id__c = ''
            );
            
        INSERT HPFObj;        
        
        return HPFObj.Id;
    }
    
    
    public static Id CreateCredentialingRec(String name,ID AccId, Id ProviderPFID) {

        vlocity_ins__ProviderNetwork__c CredObj = new vlocity_ins__ProviderNetwork__c();
        CredObj = new vlocity_ins__ProviderNetwork__c (
            Name = name,
            FPAN_Practice_Account__c = ProviderPFID,
            FPAN_Provider_Account__c = AccId,
            FPAN_FPA__c = TRUE,
            FPAN_FPA_C_C_A_S__c = 'Approved',
            FPAN_FPA_C_C_A_D__c = System_Today,
            FPAN_FPA_Sent_as_Standard_Date__c = System_Today,
            FPAN_FVCL__c = TRUE,
            FPAN_FVCL_C_C_A_S__c = 'Approved',
            FPAN_FVCL_C_C_A_D__c = System_Today,
            FPAN_FVCL_Sent_as_Standard_Date__c = System_Today,
            RecordTypeId = Credentialing_RecordTypeId // Credentialing
            );
            
        INSERT CredObj;        
        
        return CredObj.Id;
    }
    
    public static Id CreateCredentialingFVCLRec(String name,ID AccId, Id ProviderPFID) {
        
        vlocity_ins__ProviderNetwork__c CredObj = new vlocity_ins__ProviderNetwork__c();
        CredObj = new vlocity_ins__ProviderNetwork__c (
            Name = name,
            FPAN_Practice_Account__c = ProviderPFID,
            FPAN_Provider_Account__c = AccId,
            FPAN_FPA__c = TRUE,
            FPAN_FPA_C_C_A_S__c = 'Approved',
            FPAN_FPA_C_C_A_D__c = System_Today,
            FPAN_FPA_Sent_as_Standard_Date__c = System_Today,
            FPAN_FVCL__c = FALSE,
            RecordTypeId = Credentialing_RecordTypeId // Credentialing
            );
            
        INSERT CredObj;        
        
        return CredObj.Id;
    }
    
    public static Id CreateReCredentialingRec(String name,Id CredId) {

        vlocity_ins__ProviderNetworkMember__c RecCredObj = new vlocity_ins__ProviderNetworkMember__c();
        RecCredObj = new vlocity_ins__ProviderNetworkMember__c (
            Name = name,
            vlocity_ins__ProviderNetworkId__c = CredId,
            //FPAN_Provider_Account__c = AccId,
            FPAN_FPA__c = TRUE,
            FPAN_FPA_R_C_C_A_Status__c = 'Approved',
            FPAN_FPA_R_C_C_A_Date__c = System_Today,
            //FPAN_FPA_Sent_as_Standard_Date__c = System_Today,
            FPAN_FVCL__c = TRUE,
            FPAN_FVCL_R_C_C_A_Status__c = 'Approved',
            FPAN_FVCL_R_C_C_A_Date__c = System_Today
            //FPAN_FVCL_Sent_as_Standard_Date__c = System_Today
            );
            
        INSERT RecCredObj;        
        
        return RecCredObj.Id;
    }
    
    public static Id CreateReCredentialingFVCLRec(String name,Id CredId) {

        vlocity_ins__ProviderNetworkMember__c RecCredObj = new vlocity_ins__ProviderNetworkMember__c();
        RecCredObj = new vlocity_ins__ProviderNetworkMember__c (
            Name = name,
            vlocity_ins__ProviderNetworkId__c = CredId,
            //FPAN_Provider_Account__c = AccId,
            FPAN_FPA__c = TRUE,
            FPAN_FPA_R_C_C_A_Status__c = 'Approved',
            FPAN_FPA_R_C_C_A_Date__c = System_Today,
            //FPAN_FPA_Sent_as_Standard_Date__c = System_Today,
            FPAN_FVCL__c = FALSE
            );
            
        INSERT RecCredObj;        
        
        return RecCredObj.Id;
    }
    
    public static Id CreateMembershipRec(String name, Id ProviderPFID) {

        vlocity_ins__ProviderNetwork__c CredObj = new vlocity_ins__ProviderNetwork__c();
        CredObj = new vlocity_ins__ProviderNetwork__c (
            Name = name,
            FPAN_Practice_Account__c = ProviderPFID,
            FPAN_FPA_Status__c = FPA_Status_Member,
            RecordTypeId = Membership_RecordTypeId // Membership
           
            );
             
        INSERT CredObj;        
        
        return CredObj.Id;
    }
    
    public static Id CreateSpecialtyRec(String name) {

        CareSpecialty SpecObj = new CareSpecialty();
        SpecObj = new CareSpecialty (
            Name = name 
            );
            
        INSERT SpecObj;        
        
        return SpecObj.Id;
    }
    
    public static Id CreateCareSpecialtyRec(String name, Id ProviderPFID, Decimal FTE, Id SpecId,Boolean PrimarySpec) {
         system.debug('****Inside CreateCareSpecialtyRec');
        system.debug('****--->name'+name);
        system.debug('****--->ProviderPFID'+ProviderPFID);
        system.debug('****---->SpecId'+SpecId);
        system.debug('****---> FTE'+FTE);
        system.debug('****---> PrimarySpec'+PrimarySpec);
        CareProviderFacilitySpecialty CareSpecObj = new CareProviderFacilitySpecialty();
        CareSpecObj = new CareProviderFacilitySpecialty (
            Name = name,
            PractitionerFacilityId = ProviderPFID,
            IsPrimarySpecialty = PrimarySpec,
            IsActive = TRUE,
            FPAN_FTE__c = FTE,
            SpecialtyId = SpecId
            );
        //INSERT CareSpecObj;
        try{   
        INSERT CareSpecObj;         
        return CareSpecObj.Id;
        }catch(exception e){
            System.debug('Exception e-->'+e);
            //System.assertEquals(true,e.getMessage().contains('FTE') ? true : false);
        } 
        return null;
        //return CareSpecObj.Id;
    }
    
    public static Id CreateLocationRec(String name) {

        schema.Location LocObj = new schema.Location();
        LocObj = new schema.Location (
            Name = name,
            locationtype = 'New'
            );
            
        INSERT LocObj;        
        
        return LocObj.Id;
    }
    
    public static Id CreateAddressRec(Id LocId) {

        Schema.Address AddsObj = new Schema.Address();
        AddsObj = new Schema.Address (
            City = city,
            State = state,
            Country = country,
            FPAN_Fax__c = fax,
            FPAN_Phone__c = phone,
            ParentId = LocId
            );
            
        INSERT AddsObj;        
        
        return AddsObj.Id;
    } 
    
    public static Id CreateProvAssociatedLocRec(Id LocId, Id AccId, Id HPFId) {

        AssociatedLocation LocObj = new AssociatedLocation();
        LocObj = new AssociatedLocation (
            LocationId = LocId,
            ParentRecordId = AccId,
            FPAN_Provider_Facilities__c =  HPFId,
            FPAN_FPA_Main_Site__c = True,
            FPAN_Provider_Site_Directory__c = True,
            FPAN_Provider_Mail_Site__c = TRUE,
            FPAN_Admin_Site__c = True,
            FPAN_Billing_Site__c = True,
            FPAN_Practice_Site__c = True,
            FPAN_Main_Practice_Site__c = True,
            RecordTypeId = AssociatedLocProvider_RecordTypeId //Provider Location
            );
            
        INSERT LocObj;        
        
        return LocObj.Id;
    }
    
    public static Id CreatePracticeAssociatedLocRec(Id LocId, Id AccId) {

        AssociatedLocation LocObj = new AssociatedLocation();
        LocObj = new AssociatedLocation (
            LocationId = LocId,
            ParentRecordId = AccId,
            FPAN_Practice_Site__c = False,
            FPAN_Admin_Site__c = False,
            FPAN_Billing_Site__c = False,
            FPAN_Directory_Print__c = False,
            FPAN_Main_Practice_Site__c = False,
            RecordTypeId = AssociatedLocPractice_RecordTypeId //Practice Location
            );
            
        INSERT LocObj;        
        
        return LocObj.Id;
    }
    public static Id CreatePracticeAssociatedLocRec2(Id LocId, Id AccId) {

        AssociatedLocation LocObj = new AssociatedLocation();
        LocObj = new AssociatedLocation (
            LocationId = LocId,
            ParentRecordId = AccId,
            FPAN_Practice_Site__c = True,
            FPAN_Admin_Site__c = False,
            FPAN_Billing_Site__c = False,
            FPAN_Directory_Print__c = True,
            FPAN_Main_Practice_Site__c = False,
            RecordTypeId = AssociatedLocPractice_RecordTypeId //Practice Location
            );
            
        INSERT LocObj;        
        
        return LocObj.Id;
    }

    public static Id CreateEventRec(Id AccId,Id ConId) {

        Event eventObj = new Event();
        eventObj = new Event (
            Subject = 'Meeting',
            StartDateTime = System.today(),
            EndDateTime = System.today()+1,
            WhatId = AccId,
            whoId = ConId
            );
            
        INSERT eventObj;
        
        return eventObj.Id;
    }
    public static Id CreateEventRecInLead(Id LeadId) {

        Event eventObj = new Event();
        eventObj = new Event (
            Subject = 'Meeting',
            StartDateTime = System.today(),
            EndDateTime = System.today()+1,
            whoId = LeadId
            );
            
        INSERT eventObj;
        
        return eventObj.Id;
    }
    public static Id CreateLeadRec(String name) {

        Lead leadObj = new Lead();
        leadObj = new Lead (
            LastName = name,
            Email = email,
            Company = Name_Label,
            Status = 'Inquiry'
            );
            
        INSERT leadObj;
        
        return leadObj.Id;
    }
    
    public static Id CreatePurchaserPlanAssnRec(Id AccId) {

        PurchaserPlanAssn PPAObj = new PurchaserPlanAssn();
        PPAObj = new PurchaserPlanAssn (
            FPAN_In_Network__c = True,
            PurchaserId = AccId
            );
            
        INSERT PPAObj;
        
        return PPAObj.Id;
    }
    
    public static Id CreateFPANAgentUser() {
    
    Id profileId = UserInfo.getProfileId();
    Profile p =[Select id from Profile where id =: profileId Limit 1];
    User usr = new User(Alias = 'Test', Email='standarduser@xyz.edu',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles',
                            UserName='standarduser@xyz.edu');
        INSERT usr;
        
        return usr.Id;
    }
    
    public static Id insertContentVersion(){
        ContentVersion cv=new ContentVersion(
        Title='Mountain_Master_Sc',
        PathOnClient = 'Mountain_Master_Sc.jpg',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert cv;
        
        return cv.Id;
    }
    
    public static Id CreateCPO(String name) {

        FPAN_CPO__c Cpo = new FPAN_CPO__c();
        Cpo = new FPAN_CPO__c (
            Name = name,
            FPAN_Year__c = '2022'         
            );
            
        INSERT Cpo;        
        
        return Cpo.Id;
    }
    
    public static Id CreateObjective(String name) {

        FPAN_Objective__c CreateObj = new FPAN_Objective__c();
        CreateObj = new FPAN_Objective__c (
            Name = name,
            FPAN_Definition__c = 'FPAN'    
            );
            
        INSERT CreateObj;        
        
        return CreateObj.Id;
    }
    
    public static Id CreateCPOObjective(String name, Id ObjId, Id CpoId) {

        FPAN_CPO_Objective__c CpoObj = new FPAN_CPO_Objective__c();
        CpoObj = new FPAN_CPO_Objective__c (
            Name = name,
            FPAN_CPO__c = CpoId,
            FPAN_Objective_Type__c = 'Primary Care',
            FPAN_Objective__c = ObjId ,
            FPAN_Status__c = 'Active'
            );
            
        INSERT CpoObj;        
        
        return CpoObj.Id;
    }
    
    public static Id CreatePracticeCPO(String name, Id AccId, Id CpoId) {

        FPAN_Practice_CPO__c PraCpo = new FPAN_Practice_CPO__c();
        PraCpo = new FPAN_Practice_CPO__c (
            Name = name,
            FPAN_Year__c='2022' ,
            FPAN_CPO__c = CpoId,
            FPAN_Practice_Account__c = AccId,
            FPAN_Annual_CPO_Status__c = 'CPO Compliant'
          
            );
            
        INSERT PraCpo;        
        
        return PraCpo.Id;
    }
    
    public static Id CreatePracticeCPOObjective(String name, Id CPOObjId, Id PracCpoId) {

        Practice_CPO_Objectives__c PraCpoObj = new Practice_CPO_Objectives__c();
        PraCpoObj = new Practice_CPO_Objectives__c (
            Name = name,
            FPAN_Practice_CPO__c = PracCpoId,
            FPAN_CPO_Objective__c = CPOObjId,
            FPAN_Definition__c = 'FPAN',
            FPAN_Not_Met__c = FALSE,
            FPAN_Variance_Status__c = 'Approved',
            FPAN_Variance_Reason__c = 'Approved Rec'
            );
            
        INSERT PraCpoObj;        
        
        return PraCpoObj.Id;
    }
    
    public static Id CreateCommitteeMember(Id AccId, Id Con, Id Assistant) {

        Committee_Member__c InsertCM = new Committee_Member__c();
        InsertCM = new Committee_Member__c (
            FPAN_Committee_Name__c = AccId,
            FPAN_Assistant_Name__c = Assistant,
            FPAN_Active__c = TRUE,
            FPAN_Contact__c = Con,
            FPAN_Contact_Group_Type__c = 'Committee-Admin Council'            
            );
            
        INSERT InsertCM;        
        
        return InsertCM.Id;
    }
    
     public static Id CreatePracticeAccountForCOP(String name) {

        Account accObj = new Account();
        accObj = new Account (
           
            Name = name,
            RecordTypeId = Practice_AccRecordTypeId, //Provider Location
            FPAN_Practice_Speciality__c = 'Dermatology',
            Website = ACCOUNT_Website_LABEL,
            FPAN_Clinic_Fed_Id__c = ACCOUNT_Clinic_Fed_LABEL,
            FPAN_Practice_Status__c = 'Member',
            FPAN_Clinic_Network__c = 'Independent',
            FPAN_CPO_Type__c='Primary Care'
            );
            
        INSERT accObj;
        
        return accObj.Id;
    }
    
    public static Id CreateSurvey(String name,Id cpoId){
        FPAN_Survey__c surveyObj=new FPAN_Survey__c();
        surveyObj=new FPAN_Survey__c(
            Name = name,
            FPAN_CPO__c=cpoId,
            FPAN_CPO_Type__c='Primary Care'
            
           );
        INSERT surveyObj;
        
        return surveyObj.id;
    }
    //FPAN_Associate_Survey_Practice_CPO__c Name FPAN_Practice_CPO__c FPAN_Survey__c
    public static Id createAssociateSurveyPracsObj(String name, Id copId,Id surveyId){
        FPAN_Associate_Survey_Practice_CPO__c assoSurveyPracsCopObj=new FPAN_Associate_Survey_Practice_CPO__c();
        assoSurveyPracsCopObj=new FPAN_Associate_Survey_Practice_CPO__c(
            Name =name,
            FPAN_Survey__c=surveyId
             );
        INSERT assoSurveyPracsCopObj;
        
        return assoSurveyPracsCopObj.id;
    }
    
        public static Id createAssociateSurveyQuestions(String name,Id pracCPOObj,Id QuestionId){
        FPAN_Associate_Survey_Question__c fpanAssoSurveyQues =new FPAN_Associate_Survey_Question__c();
        
        fpanAssoSurveyQues =new FPAN_Associate_Survey_Question__c(
        Name=name,
        FPAN_Practice_CPO_Objective__c=   pracCPOObj,
        FPAN_Survey_Question__c= QuestionId
            );
        INSERT fpanAssoSurveyQues;
        return fpanAssoSurveyQues.id;
    }
    
    public static Id createSurveyQuestions(String name, Id surveyId,Id ObjId){
        FPAN_Survey_Question__c surveyQuesObj=new FPAN_Survey_Question__c();
        
        surveyQuesObj=new FPAN_Survey_Question__c(
        //Name = name,
        FPAN_Survey__c = surveyId,  
        FPAN_Objective_Definition__c = ObjId,
        FPAN_Status__c = 'Active'            
        );
        INSERT surveyQuesObj;
        return surveyQuesObj.id;
        
    }   
        
    public static Id CreateAssoSurveyCPO(Id cpoId,Id surveyId){ 
        FPAN_Associate_Survey_CPO__c AssoSurveyCpo = new FPAN_Associate_Survey_CPO__c();    
            
        AssoSurveyCpo = new FPAN_Associate_Survey_CPO__c(   
        FPAN_Survey__c = surveyId,  
        FPAN_CPO__c =  cpoId    
        );  
        INSERT AssoSurveyCpo;   
        return AssoSurveyCpo.id;
    }
    public static Id CreateAccountHistory(Id accountId){
        AccountHistory aacoutHistory=new AccountHistory();
        
        aacoutHistory=new AccountHistory(
          	AccountId=accountId,
          	Field='Test Field'
        	//NewValue='Test New Value',
        	//OldValue='Test Old Value'
         
        );
        INSERT aacoutHistory;
        return aacoutHistory.id;
        
    }
    
   public static Id UpdateProviderAccount(Id accountId) {
       Account acc=null;
		List<Account> accountList=[select Name,FPAN_First_Name__c from Account where Id=:accountId];
       if(accountList.size()>0){
            acc=accountList[0];
           acc.FPAN_First_Name__c='Test';
           update acc;
       }
        
        
        return acc.Id;
    }
    
    public static Id CreateBusinessLicense(Id AccountId){ 
        BusinessLicense CreateBLRec = new BusinessLicense();    
            
        CreateBLRec = new BusinessLicense(   
        AccountId = AccountId,  
        FPAN_Malpractice_Insurance_Co__c = 'ABC Insurence',
        FPAN_License_State__c = 'DE',
        Name = 'TestLicense'
        );  
        INSERT CreateBLRec;   
        return CreateBLRec.id;
    }
    public static Id CreateCase(Id AccountId, Id RecordTypeId, Id LocationId,Id ConId,Id AssLocId){ 
        Case Caserec = new Case();    
            
        Caserec = new Case(   
        AccountId = AccountId,  
        recordtypeId = RecordTypeId,
        Origin = 'Practice Portal',
        Status = 'New',
        FPAN_New_Account_Name__c = 'TestEditPracticeName',
        FPAN_New_Billing_Name__c = 'TestBillingName',
        //FPAN_New_Corporate_Name__c = 'TestCorporateName',
        FPAN_New_Practice_Specialty__c = 'Allergy',
        FPAN_New_Clinic_Fed_ID__c = '9871232345',
        FPAN_Website_New__c = 'www.NewWebsite.com',
        FPAN_New_EMR_System_Vendor__c = 'TestEMRVendor',
        FPAN_New_EMR_System_Version__c = 'TesEMRVersion',
        FPAN_New_Prac_Mang_Vendor__c = 'TesPracVendor',
        FPAN_New_Prac_Mang_Version__c  = 'TesPracVersion',
        FPAN_New_Clearinghouse__c  = 'TestCrear',
        FPAN_New_URL__c = 'TestURL',
        FPAN_New_LIS__c = 'TestLIS',
        FPAN_New_RIS__c = 'TestRIS',
        FPAN_New_Patient_Portal__c = 'TestPatientPortal',
        FPAN_New_Practice_HISP_Address__c = 'TestHISPAdd',
        FPAN_New_Practice_HISP_Vendor__c = 'TestHISPVendor',
        FPAN_New_Health_Care_Home_Check__c = TRUE,
        FPAN_New_Health_Care_Home_Cert_Date__c = System.today(),
        FPAN_New_Beh_Health_Home_Cert_Check__c = TRUE,
        FPAN_New_Beh_Health_Home_Cert_Date__c = System.today(),
        FPAN_Location__c = LocationId,
        FPAN_Contact_Firstname__c = First_Name_Label,
        FPAN_Contact_Lastname__c = Last_Name_Label,
        FPAN_Contact_Office_Phone__c = '5673456678',
        FPAN_Contact_Corporate_Email__c = 'testcorporate@test.com',
        FPAN_Contact_Cell_Phone__c = '5673456677',
        FPAN_Contact_Title__c = 'MD',
        FPAN_Contact_Status__c = 'Active',
        Fpan_Contact_Type__c = 'Credentialing',
        FPAN_Contact__c = ConId,      
        FPAN_Address_Street__c = 'TestStreet', 
        FPAN_Address_City__c ='TestCity',
        FPAN_Address_State__c  ='TestState',
        FPAN_Address_Postal_Code__c  ='TestPCode',
        FPAN_Address_Phone__c ='5674562222',
        FPAN_Address_Suite_No__c ='43434',
        FPAN_Location_Site_NPI__c ='67555',
        FPAN_Location_MNCM_Clinic_ID__c ='TestClinicId',
        FPAN_Location_MNCM_Group_ID__c ='TestGroupId',
        FPAN_Admin_Site__c = TRUE,
        FPAN_Billing_Site__c = TRUE,
        FPAN_Associated_Location_Name__c = AssLocId,
        FPAN_Site_Closed__c = TRUE,
        FPAN_Site_Closed_Effective_Date__c = System.today(),
        FPAN_Associated_Location_Number__c='AL-27109'
        //FPAN_Associated_Location_Practioner_Note__c='note'
            
        );  
        INSERT Caserec;   
        return Caserec.id;
    }
    
    
}