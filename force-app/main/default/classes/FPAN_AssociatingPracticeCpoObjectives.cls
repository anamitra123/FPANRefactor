/************************************************************************
* Name : FPAN_AssociatingPracticeCpoObjectives
* Author : Anamitra Majumdar
* Date : 29/August/2022
* Desc : Associating new objective to existing practice CPO
*************************************************************************/
public class FPAN_AssociatingPracticeCpoObjectives {
    
     Public static Integer associatingObjecvtives(List<FPAN_Practice_CPO__c> listOfCPO){
         
         List <FPAN_Practice_CPO__c> pcoList = new List <FPAN_Practice_CPO__c>();
         System.debug('listOfCPO Size'+ listOfCPO.Size());
         pcoList = listOfCPO;
         
         List<Practice_CPO_Objectives__c> practiceCPOObjList = new List<Practice_CPO_Objectives__c>();
         
         
         If(pcoList.Size()>0){
            Set<Id> setCPOId = New Set<Id>();
            for(FPAN_Practice_CPO__c PracticeCPO: pcoList ){
                setCPOId.add(PracticeCPO.FPAN_CPO__c);
            }  
        System.debug('###pcoList---->'+ pcoList);
        System.debug('###pcoList Size--->'+ pcoList.Size());    
        List<Practice_CPO_Objectives__c> pracCPOobj=  [SELECT FPAN_CPO_Objective__c FROM Practice_CPO_Objectives__c ];
        Set<Id> pracCpoSet=new Set<Id>();    
            for(Practice_CPO_Objectives__c pcpoobj :pracCPOobj){
                pracCpoSet.add(pcpoobj.FPAN_CPO_Objective__c);
            }
        
        List<FPAN_CPO_Objective__c> listCPOObj = [select Id, Name, FPAN_Objective_Type__c,FPAN_Definition__c,FPAN_CPO__c,FPAN_CPO__r.Id,FPAN_Status__c from FPAN_CPO_Objective__c where FPAN_CPO__c IN: setCPOId AND Id NOT IN: pracCpoSet AND FPAN_Status__c = 'Active'];
        system.debug('@@@listCPOObj --->'+listCPOObj );
        system.debug('@@@listCPOObj  size--->'+listCPOObj .size());
       
        Map<Id, FPAN_Practice_CPO__c> mapPracCPO = New Map<Id, FPAN_Practice_CPO__c>();        
       
        for(FPAN_Practice_CPO__c PracticeCPO: pcoList ){
            mapPracCPO.put(PracticeCPO.Id,PracticeCPO);
        }
        
        system.debug('@@@mapPracCPO--->'+mapPracCPO);
        system.debug('@@@mapPracCPO size--->'+mapPracCPO.size());
        
        
          
        
       // if(listCPOObj.size()>0){
       if(mapPracCPO.size()>0){
           for(Id PCOPs : mapPracCPO.keyset()){
           system.debug('@@@Inside For loop 1');
            for(FPAN_CPO_Objective__c cpoOB : listCPOObj){
                 system.debug('Objective Type -->'+cpoOB.FPAN_Objective_Type__c);
                
              //one if condition for checking whether  Practice_CPO_Objectives__c is existing cpoOB.id 
                 system.debug('Account CPO Type -->'+mapPracCPO.get(PCOPs).FPAN_CPO_Type_Formula__c);
                If(cpoOB.FPAN_Objective_Type__c == mapPracCPO.get(PCOPs).FPAN_CPO_Type_Formula__c ){
                  // system.debug('Objective Type -->'+cpoOB.FPAN_Objective_Type__c);
                 //  system.debug('Account CPO Type -->'+mapPracCPO.get(PCOPs).FPAN_CPO_Type_Formula__c);
                    system.debug('@@@Inside For loop 2');     
                    Practice_CPO_Objectives__c newPCPO = new Practice_CPO_Objectives__c();
                    newPCPO.FPAN_CPO_Objective__c = cpoOB.id;
                    newPCPO.FPAN_Definition__c = cpoOB.FPAN_Definition__c;
                    newPCPO.Name = cpoOB.Name;
                    newPCPO.FPAN_Practice_CPO__c = PCOPs;
                    newPCPO.FPAN_Status__c = cpoOB.FPAN_Status__c;
                    practiceCPOObjList.add(newPCPO);
                }
                }            
              }  
            If(practiceCPOObjList.Size()>0){
            try{
                Upsert practiceCPOObjList;
            }
            catch(Exception ex){
                 System.debug('The following exception has occurred: ' + ex.getMessage());
            }
            
            }
            
           }
      
    }
         return practiceCPOObjList.Size();

     }
}