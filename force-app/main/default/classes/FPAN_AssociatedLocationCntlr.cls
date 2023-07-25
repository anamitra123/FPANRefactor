/**************************************************************************************************
* Name : FPAN_AssociatedLocationCntlr
* Author : Sreeni B
* Date : 14/Mar/2022
* Desc : This apex class is for mapping associated location address into contact's address
****************************************************************************************************/
public class FPAN_AssociatedLocationCntlr {  
    public static void maintainconAddress(List<AssociatedLocation> aslList){  
        SET<Id> accntIds = new SET<Id>();
        SET<Id> locIds = new SET<Id>();
        List<AssociatedLocation> aslRecs = new List<AssociatedLocation>();
        List<Schema.Address> adrsList = new List<Schema.Address>();
        List<Contact> conList = new List<Contact>();
        List<Contact> updateConAddress = new List<Contact>();
        Map<id,id> locAccMap = new Map<id,id>();
        
        for(AssociatedLocation asl : aslList){ 
            if(asl.FPAN_Admin_Site__c == true || asl.FPAN_Provider_Mail_Site__c == true){
                accntIds.add(asl.ParentRecordId);
                locIds.add(asl.LocationId);
                locAccMap.put(asl.LocationId, asl.ParentRecordId);
            }
        }
        adrsList = [SELECT id,ParentId,Address.street,Address.city,Address.state,Address.country,Address.postalCode from Address where ParentId IN :locIds];        
        conList = [SELECT id,accountid,FPAN_Contact_Type__c,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,MailingAddress from contact where AccountId IN :accntIds];
        if(adrsList.size()>0 && conList.size()>0){
            for(Schema.Address adrs: adrsList){
              //  if(conList.size()==1){
                    for(contact con: conList){
                        if(locAccMap.get(adrs.ParentId) == con.AccountId){
                            con.MailingStreet = adrs.street;
                            con.MailingCity = adrs.city;
                            con.MailingState = adrs.state;
                            con.MailingCountry = adrs.country;
                            con.MailingPostalCode = adrs.postalcode;
                            updateConAddress.add(con);
                        }
                    }  
            
            }
            try{
                update updateConAddress;
            }catch(exception e){
                system.debug('Exception-->'+e);
                FPAN_APEX_HandleSystemException.LogException(e);
            }
        }
    }
}