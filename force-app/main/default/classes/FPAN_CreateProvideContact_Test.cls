/************************************************************************
* Name : FPAN_CreateProvideContact_Test
* Author : Ravi Kumar
* Date : 22/Dec/2021
* Desc : Test class for FPAN_CreateProvideContact
*************************************************************************/
@isTest
public with sharing class FPAN_CreateProvideContact_Test {
    
    private static testMethod void CreateProviderContact() {
        
        Id AccId = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);   
        
        test.startTest();          
        Account acc12 = [SELECT Id,Name,FPAN_First_Name__c from Account where Id =: AccId limit 1];
        
        acc12.FPAN_First_Name__c = 'FPANTest';
        Update acc12;       
        
        test.stopTest();    
    }
    
    private static testmethod void DuplicateNpiTest()
    {
        //test.startTest();        
        HealthcareProviderNpi hcpn=new HealthcareProviderNpi();
        hcpn.Name = '9830255564';
        insert hcpn;
        System.debug('hcpn--> '+hcpn.Id);
        
        HealthcareProviderNpi hcpn2=new HealthcareProviderNpi();
        hcpn2.Name = '1230256584';
        insert hcpn2;
        System.debug('hcpn2--> '+hcpn2.Id);

     Account acc= new Account();
        acc.RecordTypeId='0124x000000A5oKAAS';
        acc.FPAN_Provider_NPI__c=hcpn.Id;
        acc.FPAN_First_Name__c = 'Parker1';
        acc.FPAN_Last_Name__c = 'Hanson1';
        acc.FPAN_Gender__c = 'Male';
        acc.FPAN_Title__c = 'MD';
        acc.FPAN_Provider_Business_Email__c = 'peter1@gmail.com';
        acc.FPAN_DOB__c = Date.newInstance(1987, 09, 20);
      try{
            insert acc;
         
        }
        catch(Exception e){
  
            //System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            //System.assert(e.getMessage().contains('The Npi is already associated with another provider account'));
            Boolean expectedExceptionThrown =  e.getMessage().contains('The Npi is already associated with another provider account') ? true : false;
            System.AssertEquals(expectedExceptionThrown, false);
        }

    
        
         Account acc1= new Account();
        acc1.RecordTypeId='0124x000000A5oKAAS';
        acc1.FPAN_Provider_NPI__c=hcpn.Id;
        acc1.FPAN_First_Name__c = 'Park';
        acc1.FPAN_Last_Name__c = 'Han';
        acc1.FPAN_Gender__c = 'Male';
        acc1.FPAN_Title__c = 'MD';
        acc1.FPAN_Provider_Business_Email__c = 'peter1@gmail.com';
        acc1.FPAN_DOB__c = Date.newInstance(1988, 03, 23);
      try{
            insert acc1;
            System.debug('acc--->'+acc);
        }
        catch(Exception e){
           //System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            //System.assert(e.getMessage().contains('The Npi is already associated with another provider account'));
            Boolean expectedExceptionThrown =  e.getMessage().contains('The Npi is already associated with another provider account') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
       
        
        Account acc2= new Account();
        acc2.RecordTypeId='0124x000000A5oKAAS';
        acc2.FPAN_Provider_NPI__c=hcpn2.Id;
        acc2.FPAN_First_Name__c = 'Park';
        acc2.FPAN_Last_Name__c = 'Han';
        acc2.FPAN_Gender__c = 'Male';
        acc2.FPAN_Title__c = 'MD';
        acc2.FPAN_Provider_Business_Email__c = 'peter1@gmail.com';
        acc2.FPAN_DOB__c = Date.newInstance(1988, 03, 23);
      try{
            insert acc2;
            System.debug('acc2--->'+acc2);
        }
        catch(Exception e){
           //System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            //System.assert(e.getMessage().contains('The Npi is already associated with another provider account'));
            Boolean expectedExceptionThrown =  e.getMessage().contains('The Npi is already associated with another provider account') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
     
       
        Account accToUpdate =[Select Id , RecordTypeId , FPAN_Provider_NPI__c , FPAN_First_Name__c,FPAN_Last_Name__c, 
                             FPAN_Gender__c, FPAN_Title__c, FPAN_Provider_Business_Email__c,FPAN_DOB__c From Account Where
                             Id = : acc2.Id];
       
        accToUpdate.FPAN_Provider_NPI__c = hcpn.Id;
        
        
        try{
        Update accToUpdate;
            
        }
        catch(Exception e) {
             Boolean expectedExceptionThrown =  e.getMessage().contains('The Npi is already associated with another provider account') ? true : false;
          System.AssertEquals(expectedExceptionThrown, true);
        }
        //test.stopTest();
      
           }
    
    
    
}