/**************************************************************************************************************************************
* Name : BlankUpdateforSpecialityTest
* Author : Sreeni
* Date : 22/April/2022
* Desc : Test Class for BlankUpdateforSpeciality
****************************************************************************************************************************************/
@isTest
public class BlankUpdateforSpecialityTest {
    
    private static testMethod void CheckPrimarySpeciality() {
    test.startTest();
         Id ProviderRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider').getRecordTypeId();
         Id PracticeRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        
        CareSpecialty CS = New CareSpecialty();
            CS.Name = 'Neurology- Vascular';
            insert CS;
        
         HealthcareProviderNpi npiObj = new HealthcareProviderNpi();
        npiObj = new HealthcareProviderNpi (
            Name = '5673452223',
            Npi = '5673452223',
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
            acc.FPAN_Provider_NPI__c=npiObj.Id;
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
            //HPF.FPAN_FTE__c = 0.2;   
        Insert HPF;
       
       CareProviderFacilitySpecialty CPFS = New CareProviderFacilitySpecialty();
            CPFS.IsPrimarySpecialty = TRUE;
            CPFS.Name = 'Edina Eye Clinic PA';
            CPFS.PractitionerFacilityId = HPF.Id;
            CPFS.IsActive = TRUE; 
            CPFS.FPAN_FTE__c = 0.1;
            CPFS.SpecialtyId = CS.id;
      // Insert CPFS;
       CareProviderFacilitySpecialty CPFS1 = New CareProviderFacilitySpecialty();
            CPFS1.IsPrimarySpecialty = TRUE;
            CPFS1.Name = 'Edina Eye Clinic PA1';
            CPFS1.PractitionerFacilityId = HPF.Id;
            CPFS1.IsActive = TRUE; 
            CPFS1.FPAN_FTE__c = 1;
            CPFS1.SpecialtyId = CS.id;

         //  Insert CPFS1;
       
            try {
                Insert CPFS1;
                } catch(exception ex) {
                    System.assertEquals(true,ex.getMessage().contains('FTE') ? true : false);
                }

        BlankUpdateforSpeciality myBatchObj = new BlankUpdateforSpeciality(); 
		Id batchId = Database.executeBatch(myBatchObj);
 
    test.stopTest();    
    }
}