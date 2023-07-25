/************************************************************************
* Name : FPAN_CheckPrimarySpeciality_Test
* Author : Ravi Kumar
* Date : 1/Feb/2022
* Desc : Test class for FPAN_CheckPrimarySpeciality
*************************************************************************/
@isTest
public with sharing class FPAN_CheckPrimarySpeciality_Test {
    
    private static testMethod void CheckPrimarySpeciality() {
    
    Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    System.debug('&&&AccIdProvider -->>' +AccIdProvider);
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    System.debug('&&&AccIdPractice -->>' +AccIdPractice);
    //test.startTest();
    Id HPFId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    System.debug('&&&HPFId -->>' +HPFId);
    Id SpecId = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Specialty_Name_Label);
    System.debug('&&&SpecId -->>' +SpecId);
    Id SpecId2 = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Specialty_Name_Label);
    //test.startTest();
    Id CareSpecId = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Specialty_Name_Label,HPFId,0.50,SpecId,TRUE);
    System.debug('&&&CareSpecId -->>' +CareSpecId);
          
  //Id CareSpecId2 = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Specialty_Name_Label,HPFId,0.50,SpecId,FALSE);
    //test.startTest();
    //Id CareSpecId2 = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label,HPFId,1,SpecId,TRUE);
   // system.debug('@@@CareSpecId---->'+CareSpecId2);
    //system.debug('@@@CareSpecId2---->'+CareSpecId2);
   
   
    
  CareProviderFacilitySpecialty acc12 = [SELECT Id,Name,FPAN_FTE__c from CareProviderFacilitySpecialty where PractitionerFacilityId =: HPFId AND Id =:CareSpecId limit 1];
       
           try {
                acc12.FPAN_FTE__c = 1.5;
                Update acc12;
               List<CareProviderFacilitySpecialty> CPFSList = new List<CareProviderFacilitySpecialty>();             
               FPAN_CheckPrimarySpeciality.updatefacility(CPFSList);
               FPAN_CheckPrimarySpeciality.afterinsert(CPFSList);
               //FPAN_CheckPrimarySpeciality.updatePFfacility(CPFSList);
                } catch(exception ex) {
                    System.assertEquals(true,ex.getMessage().contains('FTE') ? true : false);
                }   
        
         CareProviderFacilitySpecialty CPFS = New CareProviderFacilitySpecialty();
            CPFS.IsPrimarySpecialty = FALSE;
            CPFS.Name = 'Edina Eye Clinic PA';
            CPFS.PractitionerFacilityId = HPFId;
            CPFS.IsActive = TRUE; 
            CPFS.FPAN_FTE__c = 0.1;
            CPFS.SpecialtyId = SpecId;
       Insert CPFS;
      
            List<CareProviderFacilitySpecialty> CPFSList = new List<CareProviderFacilitySpecialty>();
            CPFSList.add(CPFS);
            FPAN_CheckPrimarySpeciality.updatePFfacility(CPFSList);
        
     // test.stopTest();  
    }
}