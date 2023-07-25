/************************************************************************
* Name : FPAN_Apex_Attestation_CasePracticeUpdate
* Author : Ravi Kumar
* Date : 15/Mar/2023
* Desc : This Apex Class used for Auto Update the Practice Account Mapped fields once case status is Approved
* Apex Trigger : FPAN_Trigger_CommunityCase
* Test Class : FPAN_Apex_Portal_LWC_TestClass
*************************************************************************/

public class FPAN_Apex_Attestation_CasePracticeUpdate {
    
    public static void GetCaseRec(Id CaseId){
        System.debug('@@@CaseId---->'+CaseId);
        Set<Id> AccountId = New Set<Id>();
        Map<Id,Case> MapCaseRec = New Map<Id,Case>();
        List<Case> CaseList = [select id,AccountId,FPAN_New_Account_Name__c,FPAN_New_Billing_Name__c,FPAN_New_Corporate_Name__c,FPAN_New_Practice_Specialty__c,
                               FPAN_New_Clinic_Fed_ID__c,FPAN_Website_New__c,FPAN_New_EMR_System_Vendor__c,FPAN_New_EMR_System_Version__c,
                               FPAN_New_Prac_Mang_Vendor__c,FPAN_New_Prac_Mang_Version__c,FPAN_New_Clearinghouse__c,FPAN_New_URL__c,FPAN_New_LIS__c,FPAN_New_RIS__c,
                               FPAN_New_Patient_Portal__c,FPAN_New_Practice_HISP_Address__c,FPAN_New_Practice_HISP_Vendor__c,FPAN_New_Health_Care_Home_Check__c,
                               FPAN_New_Health_Care_Home_Cert_Date__c,FPAN_New_Beh_Health_Home_Cert_Check__c,FPAN_New_Beh_Health_Home_Cert_Date__c
                               From Case where Id =: CaseId];
        for (Case cs : CaseList){
            AccountId.add(cs.AccountId);
            MapCaseRec.put(cs.AccountId,cs);
        }
        
        List<Account> AccList = [Select Id,Name,FPAN_Billing_Name__c,ParentId,Parent.Name,
                                 FPAN_Practice_Speciality__c,FPAN_Clinic_Fed_Id__c,Website,FPAN_EMR_System_Vendor__c,FPAN_EMR_System_Version__c,
                                 FPAN_Practice_Management_Vendor__c,FPAN_Practice_Management_Version__c,FPAN_Clearinghouse__c,FPAN_URL__c,
                                 FPAN_LIS__c,FPAN_RIS__c,FPAN_Patient_Portal__c,FPAN_Practice_HISP_Address__c,FPAN_Practice_HISP_Vendor__c,FPAN_Med_Home_Cert__c,
                                 FPAN_Med_Home_Cert_Date__c,FPAN_Behavioral_Health_Home_Cert__c,FPAN_Behavioral_Health_Home_Cert_Date__c
                                 From Account where ID IN: MapCaseRec.Keyset()];
        
        Map<Id,Account> AccMapUpdate = New Map<Id,Account>();
        for(Account acc : AccList){
            If(MapCaseRec.get(acc.id).FPAN_New_Account_Name__c != NULL){
               
                acc.name = MapCaseRec.get(acc.id).FPAN_New_Account_Name__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Billing Name
            If(MapCaseRec.get(acc.id).FPAN_New_Billing_Name__c != NULL){
              
                acc.FPAN_Billing_Name__c = MapCaseRec.get(acc.id).FPAN_New_Billing_Name__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Corporate Name
            If(MapCaseRec.get(acc.id).FPAN_New_Corporate_Name__c != NULL){
              
                acc.Parent.name = MapCaseRec.get(acc.id).FPAN_New_Corporate_Name__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Practice Specialty
            If(MapCaseRec.get(acc.id).FPAN_New_Practice_Specialty__c != NULL){
              
                acc.FPAN_Practice_Speciality__c = MapCaseRec.get(acc.id).FPAN_New_Practice_Specialty__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Clinic Fed ID
            If(MapCaseRec.get(acc.id).FPAN_New_Clinic_Fed_ID__c != NULL){
           
                acc.FPAN_Clinic_Fed_Id__c = MapCaseRec.get(acc.id).FPAN_New_Clinic_Fed_ID__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Website
            If(MapCaseRec.get(acc.id).FPAN_Website_New__c != NULL){
          
                acc.Website = MapCaseRec.get(acc.id).FPAN_Website_New__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update EMR System Vendor
            If(MapCaseRec.get(acc.id).FPAN_New_EMR_System_Vendor__c != NULL){
       
                acc.FPAN_EMR_System_Vendor__c = MapCaseRec.get(acc.id).FPAN_New_EMR_System_Vendor__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update EMR System Version
            If(MapCaseRec.get(acc.id).FPAN_New_EMR_System_Version__c != NULL){
      
                acc.FPAN_EMR_System_Version__c = MapCaseRec.get(acc.id).FPAN_New_EMR_System_Version__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Practice Management Vendor
            If(MapCaseRec.get(acc.id).FPAN_New_Prac_Mang_Vendor__c != NULL){
   
                acc.FPAN_Practice_Management_Vendor__c = MapCaseRec.get(acc.id).FPAN_New_Prac_Mang_Vendor__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Practice Management Version
            If(MapCaseRec.get(acc.id).FPAN_New_Prac_Mang_Version__c != NULL){
        
                acc.FPAN_Practice_Management_Version__c = MapCaseRec.get(acc.id).FPAN_New_Prac_Mang_Version__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Clearinghouse
            If(MapCaseRec.get(acc.id).FPAN_New_Clearinghouse__c != NULL){
          
                acc.FPAN_Clearinghouse__c = MapCaseRec.get(acc.id).FPAN_New_Clearinghouse__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update URL
            If(MapCaseRec.get(acc.id).FPAN_New_URL__c != NULL){
     
                acc.FPAN_URL__c = MapCaseRec.get(acc.id).FPAN_New_URL__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update LIS
            If(MapCaseRec.get(acc.id).FPAN_New_LIS__c != NULL){
 
                acc.FPAN_LIS__c = MapCaseRec.get(acc.id).FPAN_New_LIS__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update RIS
            If(MapCaseRec.get(acc.id).FPAN_New_RIS__c != NULL){

                acc.FPAN_RIS__c = MapCaseRec.get(acc.id).FPAN_New_RIS__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Patient Portal
            If(MapCaseRec.get(acc.id).FPAN_New_Patient_Portal__c != NULL){

                acc.FPAN_Patient_Portal__c = MapCaseRec.get(acc.id).FPAN_New_Patient_Portal__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Practice HISP Address
            If(MapCaseRec.get(acc.id).FPAN_New_Practice_HISP_Address__c != NULL){

                acc.FPAN_Practice_HISP_Address__c = MapCaseRec.get(acc.id).FPAN_New_Practice_HISP_Address__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Practice HISP Vendor
            If(MapCaseRec.get(acc.id).FPAN_New_Practice_HISP_Vendor__c != NULL){
                acc.FPAN_Practice_HISP_Vendor__c = MapCaseRec.get(acc.id).FPAN_New_Practice_HISP_Vendor__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Health Care Home 
            If(MapCaseRec.get(acc.id).FPAN_New_Health_Care_Home_Check__c != acc.FPAN_Med_Home_Cert__c){
                acc.FPAN_Med_Home_Cert__c = MapCaseRec.get(acc.id).FPAN_New_Health_Care_Home_Check__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Health Care Home Cert Date
            If(MapCaseRec.get(acc.id).FPAN_New_Health_Care_Home_Cert_Date__c != NULL){
                  acc.FPAN_Med_Home_Cert_Date__c = MapCaseRec.get(acc.id).FPAN_New_Health_Care_Home_Cert_Date__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Behavioral Health Home Cert
            If(MapCaseRec.get(acc.id).FPAN_New_Beh_Health_Home_Cert_Check__c != acc.FPAN_Behavioral_Health_Home_Cert__c){
                 acc.FPAN_Behavioral_Health_Home_Cert__c = MapCaseRec.get(acc.id).FPAN_New_Beh_Health_Home_Cert_Check__c;
                AccMapUpdate.put(acc.Id,acc);
            }
            // Update Behavioral Health Home Cert Date
            If(MapCaseRec.get(acc.id).FPAN_New_Beh_Health_Home_Cert_Date__c != NULL){
                 acc.FPAN_Behavioral_Health_Home_Cert_Date__c = MapCaseRec.get(acc.id).FPAN_New_Beh_Health_Home_Cert_Date__c;
                AccMapUpdate.put(acc.Id,acc);
            }           
        }   
        System.debug('@@@AccMapUpdate outside---->'+AccMapUpdate);
        If(AccMapUpdate.size()>0){
            Update AccMapUpdate.values();
        }
    }
    
    public static void updateAssocLocation(Id CaseId){
        Set<Id> AssocLocId = New Set<Id>();
        Map<Id,Case> MapAssocLoc = New Map<Id,Case>();
        
        Set<Id> LocId = New Set<Id>();
        Map<Id,Case> MapLoc = New Map<Id,Case>();
        
        Set<Id> AddressId =New Set<Id>();
        Map<Id,Case> MapAddress = New Map<Id,Case>();
        
        List<Case> caseListAssoc = [SELECT Id, FPAN_Address_Street__c, FPAN_Address_City__c, FPAN_Address_State__c, 
                                    FPAN_Address_Postal_Code__c, FPAN_Address_Phone__c, FPAN_Address_Suite_No__c, FPAN_Location_Site_NPI__c, 
                                    FPAN_Location_MNCM_Clinic_ID__c, FPAN_Location_MNCM_Group_ID__c, FPAN_Admin_Site__c, FPAN_Billing_Site__c, 
                                    FPAN_Associated_Location_Name__c, FPAN_Location__c,FPAN_Site_Closed__c,FPAN_Site_Closed_Effective_Date__c FROM Case where Id =: CaseId] ;
         
        for(Case caseAssoc : caseListAssoc){
            AssocLocId.add(caseAssoc.FPAN_Associated_Location_Name__c);
            MapAssocLoc.put(caseAssoc.FPAN_Associated_Location_Name__c,caseAssoc);
        }
        
        for(Case caseLoc : caseListAssoc){
            LocId.add(caseLoc.FPAN_Location__c);
            MapLoc.put(caseLoc.FPAN_Location__c,caseLoc);
        }
        
        for(Case caseAd : caseListAssoc){
            if(caseAd.FPAN_Location__c != null){
                Id addId = [SELECT Id, FPAN_Address_Name__c  FROM Location where Id =: caseAd.FPAN_Location__c].FPAN_Address_Name__c ;
                AddressId.add(addId);
                MapAddress.put(addId,caseAd);
            }
        }
        
        List<AssociatedLocation> assLocList =[SELECT Id, FPAN_Admin_Site__c, FPAN_Billing_Site__c FROM AssociatedLocation Where Id IN: MapAssocLoc.Keyset()];
         List<Schema.Location> locationList= [SELECT Id, FPAN_Address_Name__r.Street,FPAN_Address_Name__r.City, FPAN_Address_Name__r.State, 
                                             FPAN_Address_Name__r.PostalCode,FPAN_Address_Name__r.FPAN_Suite_No__c,  FPAN_Phone__c,
                                             FPAN_Site_NPI__c, FPAN_MNCM_Group_ID__c, FPAN_MNCM_Clinic_ID__c,FPAN_Site_Closed__c,FPAN_Site_Closed_Effective_Date__c
                                             FROM Location Where Id IN: MapLoc.Keyset()];  
        
        List<Schema.Address> adList = [SELECT Id, Street, City, State, PostalCode, FPAN_Suite_No__c FROM Address WHERE Id IN: MapAddress.Keyset()]; 
         
        Map<Id,Schema.Address> adUpdate= new Map<Id,Schema.Address>();
        Map<Id,AssociatedLocation> assocLocUpdate= new Map<Id,AssociatedLocation>();
        Map<Id,Schema.Location> LocUpdate= new Map<Id,Schema.Location>();
        
        for(Schema.Address ad :adList){
            if(MapAddress.get(ad.Id).FPAN_Address_Street__c != null){
                ad.Street=MapAddress.get(ad.Id).FPAN_Address_Street__c;
                adUpdate.put(ad.Id,ad);
            }
            if(MapAddress.get(ad.Id).FPAN_Address_City__c != null){
                ad.City=MapAddress.get(ad.Id).FPAN_Address_City__c;
                adUpdate.put(ad.Id,ad);
            }
            if(MapAddress.get(ad.Id).FPAN_Address_State__c != null){
                ad.State=MapAddress.get(ad.Id).FPAN_Address_State__c;
                adUpdate.put(ad.Id,ad);
            }
            if(MapAddress.get(ad.Id).FPAN_Address_Postal_Code__c != null){
 
                ad.PostalCode=MapAddress.get(ad.Id).FPAN_Address_Postal_Code__c;
                adUpdate.put(ad.Id,ad);
            }
            if(MapAddress.get(ad.Id).FPAN_Address_Suite_No__c != null){
 
                ad.FPAN_Suite_No__c=MapAddress.get(ad.Id).FPAN_Address_Suite_No__c;
                adUpdate.put(ad.Id,ad);
            }
        }
        
        System.debug('adUpdate-->'+adUpdate);
        if(adUpdate.size()>0){
            update adUpdate.values();
        }
        
        for(AssociatedLocation ac: assLocList)  {
            
            if(MapAssocLoc.get(ac.Id).FPAN_Admin_Site__c != ac.FPAN_Admin_Site__c){
  
                ac.FPAN_Admin_Site__c = MapAssocLoc.get(ac.Id).FPAN_Admin_Site__c ;
                assocLocUpdate.put(ac.Id , ac);
            }
            
            if(MapAssocLoc.get(ac.Id).FPAN_Billing_Site__c != ac.FPAN_Billing_Site__c){
  
                ac.FPAN_Billing_Site__c = MapAssocLoc.get(ac.Id).FPAN_Billing_Site__c ;
                assocLocUpdate.put(ac.Id , ac);
            }
        }
        
        System.debug('assocLocUpdate-->'+assocLocUpdate);
        if(assocLocUpdate.size()>0){
            update assocLocUpdate.values();
        }
        for(Schema.Location lo : locationList){
            
            if(MapLoc.get(lo.Id).FPAN_Site_Closed__c != lo.FPAN_Site_Closed__c){
 
                lo.FPAN_Site_Closed__c= MapLoc.get(lo.Id).FPAN_Site_Closed__c;
                LocUpdate.put(lo.Id,lo);
            }
            
            if(MapLoc.get(lo.Id).FPAN_Site_Closed_Effective_Date__c != lo.FPAN_Site_Closed_Effective_Date__c ){

                lo.FPAN_Site_Closed_Effective_Date__c= MapLoc.get(lo.Id).FPAN_Site_Closed_Effective_Date__c;
                LocUpdate.put(lo.Id,lo);
            }
            
            if(MapLoc.get(lo.Id).FPAN_Address_Phone__c != null){
               lo.FPAN_Phone__c= MapLoc.get(lo.Id).FPAN_Address_Phone__c;
                LocUpdate.put(lo.Id,lo);
            }
            
            if(MapLoc.get(lo.Id).FPAN_Location_Site_NPI__c != null){
                lo.FPAN_Site_NPI__c= MapLoc.get(lo.Id).FPAN_Location_Site_NPI__c;
                LocUpdate.put(lo.Id,lo);
            }
            
            if(MapLoc.get(lo.Id).FPAN_Location_MNCM_Clinic_ID__c != null){

                lo.FPAN_MNCM_Clinic_ID__c= MapLoc.get(lo.Id).FPAN_Location_MNCM_Clinic_ID__c;
                LocUpdate.put(lo.Id,lo);
            }
            
            if(MapLoc.get(lo.Id).FPAN_Location_MNCM_Group_ID__c != null){

                lo.FPAN_MNCM_Group_ID__c= MapLoc.get(lo.Id).FPAN_Location_MNCM_Group_ID__c;
                LocUpdate.put(lo.Id,lo);
            }
        }
        
        System.debug('LocUpdate-->'+LocUpdate);
        if(LocUpdate.size()>0){
            update LocUpdate.values();
        }
        
    }
    public static void getContactCaseId(Id CaseId){
        Set<Id> ContactId = New Set<Id>();
        Map<Id,Case> MapCaseRec = New Map<Id,Case>();
        List<Case> CaseList = [select id,FPAN_Contact__c,FPAN_Contact_Firstname__c,FPAN_Contact_Lastname__c,ContactId,FPAN_Contact_Office_Phone__c,FPAN_Contact_Corporate_Email__c,FPAN_Contact_Name__c,FPAN_Contact_Cell_Phone__c,
                               FPAN_Contact_Title__c,Fpan_Contact_Type__c,FPAN_Contact_Status__c From Case where Id =: CaseId];
        System.debug('@@@CaseList --->'+CaseList);
        for (Case cs : CaseList){
 
            ContactId.add(cs.FPAN_Contact__c);
            MapCaseRec.put(cs.FPAN_Contact__c,cs);
        }
        List<Contact> conList=[Select id,phone,FirstName,LastName,	Email,Name,	MobilePhone,Title,FPAN_Contact_Type__c,vlocity_ins__Status__c  From Contact where ID IN: MapCaseRec.Keyset()];
        Map<Id,Contact> ConMapUpdate = New Map<Id,Contact>();
        for(Contact con :conList){
            //FirstName
            If(MapCaseRec.get(con.id).FPAN_Contact_Firstname__c != NULL){

                con.FirstName=MapCaseRec.get(con.id).FPAN_Contact_Firstname__c;
                ConMapUpdate.put(con.Id,con);
            }
            //LastName
            If(MapCaseRec.get(con.id).FPAN_Contact_Lastname__c != NULL){

                con.LastName=MapCaseRec.get(con.id).FPAN_Contact_Lastname__c;
                ConMapUpdate.put(con.Id,con);
            }
            //office Phone
            If(MapCaseRec.get(con.id).FPAN_Contact_Office_Phone__c != NULL){

                con.phone=MapCaseRec.get(con.id).FPAN_Contact_Office_Phone__c;
                ConMapUpdate.put(con.Id,con);
            }
            //Email
            If(MapCaseRec.get(con.id).FPAN_Contact_Corporate_Email__c != NULL){
 
                con.Email=MapCaseRec.get(con.id).FPAN_Contact_Corporate_Email__c;
                ConMapUpdate.put(con.Id,con);
            }
            //MobilePhone
            If(MapCaseRec.get(con.id).FPAN_Contact_Cell_Phone__c != NULL){

                con.MobilePhone=MapCaseRec.get(con.id).FPAN_Contact_Cell_Phone__c;
                ConMapUpdate.put(con.Id,con);
            }
            //Title
            If(MapCaseRec.get(con.id).FPAN_Contact_Title__c != NULL){
 
                con.Title=MapCaseRec.get(con.id).FPAN_Contact_Title__c;
                ConMapUpdate.put(con.Id,con);
            }
            //Status
            If(MapCaseRec.get(con.id).FPAN_Contact_Status__c != NULL && MapCaseRec.get(con.id).FPAN_Contact_Status__c != con.vlocity_ins__Status__c){
 
                con.vlocity_ins__Status__c=MapCaseRec.get(con.id).FPAN_Contact_Status__c;
                 If(MapCaseRec.get(con.id).FPAN_Contact_Status__c == 'Inactive'){
                con.FPAN_Portal_Status__c='	Portal Inactive';
                }
                ConMapUpdate.put(con.Id,con);
            }
            //Contact Type
            If(MapCaseRec.get(con.id).Fpan_Contact_Type__c != NULL && MapCaseRec.get(con.id).Fpan_Contact_Type__c != con.FPAN_Contact_Type__c){

                con.FPAN_Contact_Type__c=MapCaseRec.get(con.id).Fpan_Contact_Type__c;
                ConMapUpdate.put(con.Id,con);
            }
        }
        System.debug('@@@ConMapUpdate outside---->'+ConMapUpdate);
        If(ConMapUpdate.size()>0){
            Update ConMapUpdate.values();
        }
    }
}