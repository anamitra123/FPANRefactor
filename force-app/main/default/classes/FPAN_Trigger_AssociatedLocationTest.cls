/************************************************************************
* Name : FPAN_Trigger_AssociatedLocationTest
* Author : Sreeni
* Date : 28/Dec/2021
* Desc : Test class for FPAN_Trigger_AssociatedLocation
*************************************************************************/
@isTest
public class FPAN_Trigger_AssociatedLocationTest {
    
    private static testMethod void AssociatedLocation() {
    
        Id LocationId = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Name_Label);
        
        Id LocationId1 = FPAN_TestDataUtility_Test.CreateLocationRec(FPAN_TestDataUtility_Test.Loc_Name_Label);
        
        Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        Id AccIdPractice = FPAN_TestDataUtility_Test.CreatePracticeAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
        
        Id AccIdPrac = FPAN_TestDataUtility_Test.CreatePracticeAccount2(FPAN_TestDataUtility_Test.ACCOUNT_PRAC_NAME_LABEL);
        
        Id HPFProvId = FPAN_TestDataUtility_Test.CreateProviderFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
            
        Id HPFPracId = FPAN_TestDataUtility_Test.CreatePracticeFacility(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL,AccIdProvider,AccIdPractice);
        
        system.debug('LocationId1--->' +LocationId1);
        system.debug('AccIdPractice--->' +AccIdPractice);
        system.debug('HPFPracId--->' +HPFPracId);
        Id AssocationIdProv = FPAN_TestDataUtility_Test.CreateProvAssociatedLocRec(LocationId1,AccIdPractice,HPFPracId);
        
        Id AssocationIdPrac = FPAN_TestDataUtility_Test.CreatePracticeAssociatedLocRec(LocationId,AccIdPrac);
        
        Id AssocationIdPrac2 = FPAN_TestDataUtility_Test.CreatePracticeAssociatedLocRec2(LocationId1,AccIdPrac);
        
        Id AddressId = FPAN_TestDataUtility_Test.CreateAddressRec(LocationId);
        
        Id FPANAgentId = FPAN_TestDataUtility_Test.CreateFPANAgentUser();
        system.debug('@@@FPANAgentId-->'+FPANAgentId);
        
        
        Test.startTest();
        
            AssociatedLocation aloc01 = [SELECT Id,FPAN_Billing_Site__c,FPAN_FPA_Main_Site__c,FPAN_Admin_Site__c from AssociatedLocation where Id =: AssocationIdPrac2 limit 1];
            
            AssociatedLocation aloc = [SELECT Id,FPAN_Billing_Site__c,FPAN_FPA_Main_Site__c,FPAN_Admin_Site__c from AssociatedLocation where Id =: AssocationIdPrac limit 1];                       
        
         try{
         aloc.FPAN_Admin_Site__c = True;
         update aloc;
        }catch(Exception e){
            system.assertNotEquals(null, e.getMessage());
            System.debug('Exception occurred'+e.getMessage());
        }
        
        AssociatedLocation aloc2 = [SELECT Id,FPAN_Billing_Site__c,FPAN_FPA_Main_Site__c,FPAN_Admin_Site__c from AssociatedLocation where Id =: AssocationIdPrac limit 1];        
        
         try{
         aloc2.FPAN_Billing_Site__c = True;
         update aloc2;
        }catch(Exception e){
            system.assertNotEquals(null, e.getMessage());
            System.debug('Exception occurred'+e.getMessage());
        }
        
        AssociatedLocation aloc3 = [SELECT Id,FPAN_Billing_Site__c,FPAN_Admin_Site__c,FPAN_FPA_Main_Site__c from AssociatedLocation where Id =: AssocationIdPrac limit 1];        
        
         try{
         aloc3.FPAN_FPA_Main_Site__c = True;
         update aloc3;
        }catch(Exception e){
            system.assertNotEquals(null, e.getMessage());
            System.debug('Exception occurred'+e.getMessage());
        }
        
        AssociatedLocation aloc4 = [SELECT Id,FPAN_Billing_Site__c,FPAN_Admin_Site__c,FPAN_FPA_Main_Site__c,FPAN_Main_Practice_Site__c from AssociatedLocation where Id =: AssocationIdPrac limit 1];        
        
         try{
         aloc4.FPAN_Main_Practice_Site__c = True;
         update aloc4;
        }catch(Exception e){
            system.assertNotEquals(null, e.getMessage());
            System.debug('Exception occurred'+e.getMessage());
        }
        AssociatedLocation aloc5 = [SELECT Id,FPAN_Billing_Site__c,FPAN_Admin_Site__c,FPAN_FPA_Main_Site__c,FPAN_Main_Practice_Site__c,FPAN_Provider_Mail_Site__c from AssociatedLocation where Id =: AssocationIdPrac limit 1];        
        
         try{
         aloc4.FPAN_Provider_Mail_Site__c = True;
         update aloc4;
        }catch(Exception e){
            system.assertNotEquals(null, e.getMessage());
            System.debug('Exception occurred'+e.getMessage());
        }
        
        
        User Us = [SELECT Id from User where Id =: FPANAgentId limit 1];
        system.runAs(Us){
            try{
                delete aloc;
            }catch(Exception e){
                system.assert(e.getMessage().contains('You are not authorized to delete this Record!'));
            }
        }
        //delete aloc;
        Test.stopTest();          
    }
}