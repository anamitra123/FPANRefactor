@isTest
public class FPAN_SpecialityName_Test {
    
   private static testMethod void SpecialtyNames() {
    test.startTest();
       
         Id ProviderRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
         Id PracticeRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        
        CareSpecialty CS = New CareSpecialty();
            CS.Name = 'Neurology- Vascular';
            insert CS;
        HealthcareProviderNpi npiObj = new HealthcareProviderNpi();
        npiObj = new HealthcareProviderNpi (
            Name = '5673452222',
            Npi = '5673452222',
          IsActive = True);
            
        INSERT npiObj;
       
        Account acc= new Account();
            acc.name = 'TestAcc';       
            acc.FPAN_First_Name__c = 'FPAN';
            acc.FPAN_Last_Name__c = 'FAIRVIEW';
            acc.FPAN_MI__c = 'M1Dev';
            acc.FPAN_Title__c = 'CNM';
            acc.FPAN_Provider_Business_Email__c = 'fpanm1dev@fairview.org';
            acc.FPAN_DOB__c = Date.newInstance(1987, 06, 20);
            acc.phone = '9876543210';
            acc.RecordTypeId = ProviderRecordType;  
           acc.FPAN_Provider_NPI__c = npiObj.Id;
        Insert acc;
        
        Account acc1 = new Account();
            acc1.Name = 'TestAcc';
            acc1.FPAN_Practice_Speciality__c = 'Acupuncturist';
            acc1.Website = 'WWW.FAIRVIEW.ORG';
            acc1.FPAN_Clinic_Fed_Id__c = '456231';
            acc1.FPAN_NCC__c = TRUE;
            acc1.RecordTypeId = PracticeRecordType;           
            acc1.FPAN_Practice_Status__c = 'Affiliate';                     
        Insert acc1;
        
        HealthcarePractitionerFacility HPF = New HealthcarePractitionerFacility();
            HPF.Name = 'Memory Clinic';
            HPF.AccountId = acc.ID;
            HPF.FPAN_Practice_Name__c = acc1.ID;
            HPF.IsActive = TRUE;    
           HPF.FPAN_Specialty_Name__c ='Spec1';
            HPF.FPAN_Specialty_Name2__c ='Spec2';
            //HPF.FPAN_FTE__c = 0.2;   
        Insert HPF;
       
       CareProviderFacilitySpecialty CPFS = New CareProviderFacilitySpecialty();
            CPFS.IsPrimarySpecialty = FALSE;
            CPFS.Name = 'Edina Eye Clinic PA';
            CPFS.PractitionerFacilityId = HPF.Id;
            CPFS.IsActive = TRUE; 
            CPFS.FPAN_FTE__c = 0.1;
            CPFS.SpecialtyId = CS.id;
       Insert CPFS;
      
            List<CareProviderFacilitySpecialty> CPFSList = new List<CareProviderFacilitySpecialty>();
            CPFSList.add(CPFS);
            FPAN_CheckPrimarySpeciality.updatePFfacility(CPFSList);
       
      test.stopTest();  
   }
}