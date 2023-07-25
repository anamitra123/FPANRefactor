/************************************************************************
* Name : FPAN_Apex_NetworkAgreementList
* Author : Masud Ahmed
* Date : 29/03/2023
* Desc : This is the test class of FPAN_Apex_NetworkAgreementList 
*************************************************************************/
@isTest
public class FPAN_Apex_NetworkAgreementListTest {
    private static testmethod void getNetworkAgreementListTest(){
        
        Id ProviderLocationRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        Account accObj = new Account();
        accObj = new Account (
            Name = 'FPAN',
            FPAN_First_Name__c = 'Test First Name',
            FPAN_Last_Name__c = 'Name', 
            RecordTypeId = ProviderLocationRecordType, //Provider Location
            FPAN_Practice_Speciality__c = 'Dermatology',
            Website = 'www.FairviewTest.Org',
            FPAN_Clinic_Fed_Id__c = '1234567890',
            FPAN_Practice_Status__c = 'Affiliate',
            FPAN_CPO_Type__c='Primary Care'
            
        );
        INSERT accObj;
        
        Contract con=new Contract();
        con.StartDate=System.today();
        con.AccountId=accObj.Id;
        con.Status='Draft';
        Insert con;
        
        Contract con1= [Select StartDate,AccountId,Status From Contract Where Id=:con.Id];
        con1.Status='Activated';
        Update con1;
        
        List<Contract> res=FPAN_Apex_NetworkAgreementList.getNetworkAgreementList(accObj.Id);
        System.assertEquals(1,res.size());
        System.assertEquals('Activated',res[0].Status);
    }
    
}