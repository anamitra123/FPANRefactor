/************************************************************************
* Name : FPAN_Trigger_CommunityCase
* Author : Anamitra Majumdar
* Date : 29/03/2023
* Desc : This Trigger is developed to send email notifications after case record is inserted and called the attestation handler class
*************************************************************************/
trigger FPAN_Trigger_CommunityCase on Case (before update,after update,after insert) {
    Id CaseId;
    String AdminAction;
    if(Trigger.IsInsert && Trigger.IsAfter){
       
        for(Case caseRecord: Trigger.new){
            FPAN_Apex_CaseNotification.sendEmailToPortalUser(caseRecord.Id);
        }
    }
    
    if(Trigger.IsUpdate && Trigger.IsBefore){
        //String userProfileId = UserInfo.getProfileId();
       // String ProfileId = [Select id,name from Profile where Name ='FPAN Agent'].Id;      
        List<AssociatedLocation> assLoclis = [SELECT Id, AssociatedLocationNumber FROM AssociatedLocation where AssociatedLocationNumber != null];
        Map<String,Id>  alIdMap = new Map<String,Id>(); 
        for(AssociatedLocation alctn : assLoclis){
            alIdMap.put(alctn.AssociatedLocationNumber,alctn.Id);
        }
        for(Case caseRec: Trigger.new){
            //if(userProfileId == ProfileId){    
                Case oldCase = Trigger.oldMap.get(caseRec.ID);
                /*if(oldCase.Agent_Action__c == caseRec.Agent_Action__c && oldCase.FPAN_Is_Archived__c == caseRec.FPAN_Is_Archived__c)
                {
                    caseRec.addError('Case is already in the status:---> '+caseRec.Agent_Action__c);
                    
                }else */
                    if(caseRec.Agent_Action__c=='Approved'){
                    caseRec.Status='Approved';
                    if(caseRec.Agent_Action__c == 'Approved' && caseRec.FPAN_Associated_Location_Number__c != null){
                       
                        caseRec.FPAN_Associated_Location_Name__c = alIdMap.get(caseRec.FPAN_Associated_Location_Number__c);
                        
                        
                    }
                    CaseId = caseRec.ID;
                    AdminAction = caseRec.Agent_Action__c;
                }  else if(caseRec.Agent_Action__c=='Rejected') {
                    caseRec.Status='Rejected';
                    CaseId = caseRec.ID;
                    AdminAction = caseRec.Agent_Action__c;
                } 
                else  {
                    caseRec.Status='Manually Updated';
                    CaseId = caseRec.ID;
                    AdminAction = caseRec.Agent_Action__c;
                } 
            //}
            /*
            else{
                caseRec.addError('You are not authorized to do this action.');
            } 
			*/
        }
    }
    
    if(Trigger.IsUpdate && Trigger.IsAfter){
        
        for(Case caseRec: Trigger.new){
            Case oldCase = Trigger.oldMap.get(caseRec.ID);
            if(oldCase.Agent_Action__c != caseRec.Agent_Action__c ){
                if(caseRec.Agent_Action__c == 'Approved'){ 
                 
                    
                    //Update Practice Details --> RT
                    if(caseRec.FPAN_RecordType_Name__c == 'Update Practice Details'){
                        FPAN_Apex_Attestation_CasePracticeUpdate.GetCaseRec(caseRec.Id);
                    }                    
                    //Update Practice Location Details --> RT
                    if(caseRec.FPAN_RecordType_Name__c == 'Update Practice Location Details'){
                        FPAN_Apex_Attestation_CasePracticeUpdate.updateAssocLocation(caseRec.Id);
                    }
                    //Update Contact Details --> RT
                    if(caseRec.FPAN_RecordType_Name__c == 'Update Contact Details'){
                        FPAN_Apex_Attestation_CasePracticeUpdate.getContactCaseId(caseRec.Id);
                    }
                }
            }    
        } 
        
    }
}