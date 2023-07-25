/**************************************************************************************************************************************
* Name : BlankUpdateforContactMailingAddressTest
* Author : Sreeni
* Date : 28/April/2022
* Desc : Test Class for BlankUpdateforContactMailingAddress
****************************************************************************************************************************************/
@isTest
public class BlankUpdateforContactMailingAddressTest {
	  
    private static testMethod void testbatch() {
        Test.startTest();
        List<schema.Location> locLst = new List<schema.Location>();
        Schema.Location loc = new Schema.location();
        loc.name = 'Temp Location';
        loc.locationtype = 'New';
        Insert Loc;
            
    	Id RecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Provider Location').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.FPAN_Practice_Speciality__c = 'Acupuncturist';
        acc.Website = 'WWW.FAIRVIEW.ORG';
        acc.FPAN_Clinic_Fed_Id__c = '456231';
        acc.FPAN_NCC__c = TRUE;
        acc.RecordTypeId = RecordType;           
        acc.FPAN_Practice_Status__c = 'Affiliate';                     
        Insert acc; 
    
        AssociatedLocation ala = new AssociatedLocation();
        ala.LocationId = Loc.Id;
        ala.ParentRecordId = acc.Id;
        ala.FPAN_Admin_Site__c = TRUE;
        Insert ala;
        
        Contact con = new contact();
        con.firstname = 'FN';
        con.LastName = 'LN';
        con.AccountId = acc.id;        
        Insert con;
        
        Schema.Address add = new Schema.Address();
        add.city = 'TN';
        add.state = 'JKKJ';
        add.country = 'India';
        add.FPAN_Fax__c = '1234876541';
        add.FPAN_Phone__c = '1029384756';
        add.ParentId =Loc.id;
        insert add;
        
        BlankUpdateforContactMailingAddress myBatchObj = new BlankUpdateforContactMailingAddress(); 
		Id batchId = Database.executeBatch(myBatchObj);
    }
}