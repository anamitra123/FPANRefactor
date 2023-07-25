/************************************************************************
* Name :FPAN_Trigger_ProviderFacility
* Author : Abhijeet Nagnath Ghodke
* Date : 04/03/2023
* Desc : This is the Trigger for sharing the provider facilities records
* Test Class:FPAN_UpdateProviderFacilitesHandle_Test
*************************************************************************/
trigger FPAN_Trigger_ProviderFacility on User (before insert,before update,after insert,after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert ){
           
            FPAN_UpdateProviderFacilitesHandler.updateProviderFacilityHandler(trigger.new); 
            
        }else if(Trigger.isUpdate){
            
            FPAN_UpdateProviderFacilitesHandler.updateProviderFacilityHandler(trigger.new);
        }
    }
    //This trigger is used to display username in Portal maintaining this format (First Name & Last Name over the User Info)
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){            
            MAP<Id,String> ContactMap = new Map<Id,String>();
            List<Contact> conList = [SELECT id,FirstName,LastName from Contact];
            for(Contact cont : conList){
                String FLName = cont.FirstName + ' ' + cont.LastName;
                ContactMap.put(cont.Id, FLName);        
            }
            
            for (User u : Trigger.new) {
                if (u.ContactId != null) {
                    u.CommunityNickname = ContactMap.get(u.ContactId);
                }
            }
        }
        
    }
}