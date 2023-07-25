/************************************************************************
* Name : FPAN_InitiateCPOButton
* Author : Ravi Kumar
* Date : 11/Aug/2022
* Desc : Apex class for FPAN_InitiateCPOButton
*************************************************************************/
Public class FPAN_InitiateCPOButton{
   
    @AuraEnabled()
    public static list<FPAN_CPO_Objective__c> getCpoObjRec(String recordId)
    {
        System.debug('I am Main method');
        return [Select id,FPAN_CPO__c from FPAN_CPO_Objective__c where FPAN_CPO__c =: recordId limit 10];
         
    }
    @AuraEnabled()
    //Public static void InitiateCPO(Id CPOrecordId){
    Public static Integer InitiateCPO(Id CPOrecordId){
        List<Id> CPOrecordIds = new List<Id>(); 
        System.debug('CPOrecordId -->>' +CPOrecordId);
        CPOrecordIds.add(CPOrecordId);
        
        Integer pracCpoObj;
        Integer pracCpoSize;
        Integer pracCpoObjSize;
        
        List<FPAN_CPO__c> ListCPO = [Select Id,Name,FPAN_Year__c From FPAN_CPO__c where Id IN: CPOrecordIds];
        System.debug('ListCPO -->' +ListCPO);
        
        
        
        List<FPAN_Practice_CPO__c> ListPracCPOobj = [Select Id,FPAN_CPO__c,FPAN_Practice_Account__c,FPAN_CPO_Type_Formula__c From FPAN_Practice_CPO__c where FPAN_CPO__c IN: CPOrecordIds];
       System.debug('ListPracCPOobj--> ' +ListPracCPOobj);
        Set<Id> AccId = New Set<Id>();
        If(ListPracCPOobj.size()>0){
           
            for(FPAN_Practice_CPO__c PracCPo : ListPracCPOobj){
                    AccId.add(PracCPo.FPAN_Practice_Account__c);
            
            }
            System.debug('AccId ->>' +AccId);
           

        }
         List<Account> ListPracAcc = [Select Id,Name,FPAN_Practice_Status__c,FPAN_Clinic_Network__c,FPAN_CPO_Type__c From Account Where FPAN_Practice_Status__c = 'Member' AND FPAN_Clinic_Network__c = 'Independent' AND FPAN_CPO_Type__c != '' AND RecordType.Name = 'Provider Location' AND ID NOT IN: AccId ];
         List<Account> ListPracAcc2 = [Select Id,Name,FPAN_Practice_Status__c,FPAN_Clinic_Network__c,FPAN_CPO_Type__c From Account Where FPAN_Practice_Status__c = 'Member' AND FPAN_Clinic_Network__c = 'Independent' AND FPAN_CPO_Type__c != '' AND RecordType.Name = 'Provider Location' AND ID IN: AccId ];   
                
        List<FPAN_Practice_CPO__c> InsertPracticeCPo = New List<FPAN_Practice_CPO__c>();
        System.debug('ListPracAcc-->' +ListPracAcc.size());
        System.debug('ListPracCPOobj---->' +ListPracCPOobj);
        System.debug('ListPracCPOobj---->' +ListPracCPOobj.size());
        System.debug('ListPracAcc2---->' +ListPracAcc2.size());
        System.debug('List prac acc --->' +ListPracAcc);
       // If(ListPracAcc.size()>0){
          
        If(ListCPO.size()>0 && ListPracAcc.size()>0){
            pracCpoObj =FPAN_AssociatingPracticeCpoObjectives.associatingObjecvtives(ListPracCPOobj);
            System.debug('pracCpoObj list--->'+pracCpoObj);
            System.debug('ListPracCPOobj -->' +ListPracCPOobj);
            System.debug('ListPracCPOobj -->' +ListPracCPOobj.size());
            System.debug('ListPracAcc -->' +ListPracAcc.size());
            For(FPAN_CPO__c cpo : ListCPO){
                For(Account acc : ListPracAcc){
                    FPAN_Practice_CPO__c PraCPO = New FPAN_Practice_CPO__c();
                    PraCPO.FPAN_CPO__c = cpo.Id;
                    PraCPO.FPAN_Practice_Account__c = acc.Id;
                    PraCPO.Name = cpo.Name;
                    PraCPO.FPAN_Year__c = cpo.FPAN_Year__c;
                    InsertPracticeCPo.add(PraCPO);
                }
           }             
        }else{
            If(ListPracCPOobj.size() == ListPracAcc2.size() && ListPracAcc2.size()>0){
                System.debug('Inside if' +ListPracCPOobj.size());
                System.debug('Inside if ListPracAcc2--->' +ListPracAcc2.size());
                //System.enqueuejob(new FPAN_Apex_QueableCreatePracticeCPOObj(ListPracCPOobj));
                pracCpoObj =FPAN_AssociatingPracticeCpoObjectives.associatingObjecvtives(ListPracCPOobj);
            System.debug('Size of pracCpoObj-->' +pracCpoObj);
        } 
        }
        
            If(InsertPracticeCPo.Size()>0){
            try{
                Insert InsertPracticeCPo;
            }
            catch(Exception ex){
                 System.debug('The following exception has occurred: ' + ex.getMessage());
            }
                
            
            }
        //return InsertPracticeCPo.Size();
        If(InsertPracticeCPo.Size()>0){
           pracCpoSize = InsertPracticeCPo.Size();
        }
        else if(pracCpoObj > 0){
            pracCpoSize=pracCpoObj;
        }
        return pracCpoSize;
         
        
        
        
        
        
    }
}