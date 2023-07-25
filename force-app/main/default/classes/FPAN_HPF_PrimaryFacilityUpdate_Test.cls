@isTest
public class FPAN_HPF_PrimaryFacilityUpdate_Test {
   
    static testMethod void TestIsPrimaryFlag_Create(){ 
    
    Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
    Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
    Id HPFProvId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    
    Id HPFPracId = FPAN_TestDataUtility_Test.CreatePracticeFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    
    Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
    
    Id AssocationId = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,AccIdProvider,HPFPracId);
        
    
    
    
        test.startTest();  

        AssociatedLocation aloc = [SELECT Id,FPAN_Provider_Facilities__c,FPAN_FPA_Main_Site__c,FPAN_Admin_Site__c from AssociatedLocation where Id =: AssocationId limit 1];
        
        aloc.FPAN_FPA_Main_Site__c = false;
        update aloc;
        
        aloc.FPAN_FPA_Main_Site__c = true;
        update aloc;
        
        delete aloc;        
        system.debug('aloc@@FPAN_Provider_Facilities__c'+aloc.FPAN_Provider_Facilities__c);
        system.debug('aloc@@FPAN_Admin_Site__c'+aloc.FPAN_Admin_Site__c);
        test.stopTest(); 
    }
}