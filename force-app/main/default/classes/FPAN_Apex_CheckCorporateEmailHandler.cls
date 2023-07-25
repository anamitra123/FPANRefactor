/************************************************************************
* Name : FPAN_Apex_CheckCorporateEmailHandler
* Author : Ravi Pothapi
* Date : 13/04/2023
* Desc : This is the Handler class of FPAN_Trigger_CheckCorporateEmailDup Trigger
*************************************************************************/
public class FPAN_Apex_CheckCorporateEmailHandler {
    public static void CheckEmailInsert(List<Contact> conList){
   
        Id RType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        List<String> ConEmailList = new List<String>();
         for(Contact conEmail : conList){
          if(conEmail.RecordTypeId == RType){
                {
                    ConEmailList.add(conEmail.Email);
                }
            }
            }

        List<User> UserEmail =[SELECT Id, Email FROM User WHERE email =: ConEmailList AND Profile.Name='FPAN Practice Community Plus Login User'];
        
        If(UserEmail.Size()>0){
        for(Contact con : conList){
         
            //if(ConEmailList.contains(use.Email)){
                con.adderror('Provided Corporate email is already existing with the one of the users. Please provide different email id. Thanks');
           // }
        }
       }         
    }  
    
    Public static void CheckEmailUpdate(List<Contact> conList, Map<Id,Contact> OldContacts){
    Id RType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Business').getRecordTypeId();
     List<String> ConEmailList = new List<String>();
         for(Contact conEmail : conList){
          if(conEmail.RecordTypeId == RType){
                {
                    ConEmailList.add(conEmail.Email);
                }
            }
            }
        List<User> UserEmail =[SELECT Id, Email FROM User WHERE email =: ConEmailList AND Profile.Name='FPAN Practice Community Plus Login User'];
                
        If(UserEmail.Size()>0){
        for(Contact con : conList){

            Contact oldContact = OldContacts.get(con.Id);
            if(con.Email != oldContact.Email){
            //if(ConEmailList.contains(con.Email)){
            //
               con.adderror('Provided Corporate email is already existing with the one of the users. Please provide different email id. Thanks');
           // }
        }
        } 
        }
    }  
    
}