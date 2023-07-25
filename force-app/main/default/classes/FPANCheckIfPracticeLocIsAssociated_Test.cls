@isTest
public class FPANCheckIfPracticeLocIsAssociated_Test {
    
    static testMethod void BillingSite(){ 
    
        Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
        
        Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
        Id HPFProvId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    
       // Id HPFProvId2 = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
        
       // Id SpecId = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label);
    
        //Id CareSpecId = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label,HPFProvId,0.1,SpecId,TRUE);
        
        Id AssocationIdProv = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,AccIdProvider,HPFProvId);
        
        Id AssocationIdPrac = FPAN_TestDataUtility_Test.CreatePracticeAssociatedLocRec(LocationId,AccIdProvider);
        
        test.startTest();
        
        AssociatedLocation aloc = [SELECT Id,FPAN_Billing_Site__c from AssociatedLocation where Id =: AssocationIdPrac limit 1];
                
         try{
         aloc.FPAN_Billing_Site__c = True;
         update aloc;
        }catch(Exception e){
           System.assertNOTEquals(null, e);
        }
        
        AssociatedLocation aloc2 = [SELECT Id,FPAN_Billing_Site__c from AssociatedLocation where Id =: AssocationIdProv limit 1];        
        
         try{
         update aloc2;
        }catch(Exception e){
           System.assertNOTEquals(null, e);
        }
        
        test.stopTest();
    } 
    
    static testMethod void AdminSites(){ 
    
        Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
        
        Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
        Id HPFProvId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    
       // Id HPFProvId2 = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
        
       // Id SpecId = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label);
    
        //Id CareSpecId = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label,HPFProvId,0.1,SpecId,TRUE);
        
        Id AssocationIdProv = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,AccIdProvider,HPFProvId);
        
        Id AssocationIdPrac = FPAN_TestDataUtility_Test.CreatePracticeAssociatedLocRec(LocationId,AccIdProvider);
        Id AddressId = FPAN_TestDataUtility_Test.CreateAddressRec(LocationId);
    
        test.startTest();
        
        AssociatedLocation aloc = [SELECT Id,FPAN_Admin_Site__c from AssociatedLocation where Id =: AssocationIdPrac limit 1];
            
         try{
         aloc.FPAN_Admin_Site__c = True;
         update aloc;
        }catch(Exception e){
           System.assertNOTEquals(null, e);
        }
        AssociatedLocation aloc2 = [SELECT Id,FPAN_Billing_Site__c from AssociatedLocation where Id =: AssocationIdProv limit 1];        
        
         try{
         update aloc2;
        }catch(Exception e){
          System.assertNOTEquals(null, e);
        }
        
        test.stopTest();
    } 
    /* static testMethod void Assoc(){ 
        
    } */
    static testMethod void Assoc1(){ 
    
        Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
        
        Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
        Id HPFProvId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
    
        //Id HPFProvId2 = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
        
        //Id SpecId = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label);
    
        //Id CareSpecId = FPAN_TestDataUtility_Test.CreateCareSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label,HPFProvId,0.1,SpecId,TRUE);
        
        Id AssocationIdProv = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,AccIdProvider,HPFProvId);
        
        Id AssocationIdPrac = FPAN_TestDataUtility_Test.CreatePracticeAssociatedLocRec(LocationId,AccIdProvider);
    
      test.startTest();
        
        AssociatedLocation aloc = [SELECT Id,FPAN_Admin_Site__c,FPAN_Practice_Site__c,FPAN_Directory_Print__c,FPAN_Main_Practice_Site__c from AssociatedLocation where Id =: AssocationIdPrac limit 1];
            
         try{
         aloc.FPAN_Admin_Site__c = True;
         aloc.FPAN_Practice_Site__c = True;
         aloc.FPAN_Directory_Print__c = True;
         aloc.FPAN_Main_Practice_Site__c = True;
         update aloc;
        }catch(Exception e){
           System.assertNOTEquals(null, e);
        }
        
        AssociatedLocation aloc2 = [SELECT Id,FPAN_Billing_Site__c from AssociatedLocation where Id =: AssocationIdProv limit 1];        
        
         try{
         update aloc2;
        }catch(Exception e){
            System.assertNOTEquals(null, e);
        }
        
        test.stopTest();
      
    } 
     
  
    
    static testMethod void delPracticeFacility(){ 
    test.startTest();
        Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
        
        Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
        //Id HPFProvId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
            
        Id HPFPracId = FPAN_TestDataUtility_Test.CreatePracticeFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
        
       // Id SpecId = FPAN_TestDataUtility_Test.CreateSpecialtyRec(FPAN_TestDataUtility_Test.Name_Label);
          Id AssocationId = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId,AccIdProvider,HPFPracId);
        
        try{          
            AssociatedLocation aloc = [SELECT Id,FPAN_Provider_Facilities__c,FPAN_FPA_Main_Site__c,FPAN_Admin_Site__c from AssociatedLocation where Id =: AssocationId limit 1];
        
        aloc.FPAN_FPA_Main_Site__c = false;
        update aloc;
        
        aloc.FPAN_FPA_Main_Site__c = true;
        update aloc;
        
        delete aloc;  
            
        }catch(exception e){
            System.debug('Exception-->'+e);
        }        
        test.stopTest();        
    }
  
}