/************************************************************************
* Name : FPAN_Apex_QueableCreatePracticeCPOObj
* Author : Ravi Kumar
* Date : 28/July/2022
* Desc : Creating the Praactice CPO Objective Under Practice CPO 
*************************************************************************/
public class FPAN_Apex_QueableCreatePracticeCPOObj implements Queueable{
    List <FPAN_Practice_CPO__c> pcoList = new List <FPAN_Practice_CPO__c>();
    public FPAN_Apex_QueableCreatePracticeCPOObj(List<FPAN_Practice_CPO__c> listOfCPO){
        System.debug('listOfCPO Size'+ listOfCPO.Size());
        pcoList = listOfCPO;
    }
    
    public void execute(QueueableContext context) {
        
        Set<Id> setCPOId = New Set<Id>();
        for(FPAN_Practice_CPO__c PracticeCPO: pcoList ){
            setCPOId.add(PracticeCPO.FPAN_CPO__c);
        }                           
        
        List<FPAN_CPO_Objective__c> listCPOObj = [select Id, Name, FPAN_Objective_Type__c,FPAN_Definition__c,FPAN_CPO__c,FPAN_CPO__r.Id,FPAN_Status__c from FPAN_CPO_Objective__c where FPAN_CPO__c IN: setCPOId AND FPAN_Status__c = 'Active'];
        system.debug('@@@listCPOObj --->'+listCPOObj );
        system.debug('@@@listCPOObj  size--->'+listCPOObj .size());
       
        Map<Id, FPAN_Practice_CPO__c> mapPracCPO = New Map<Id, FPAN_Practice_CPO__c>();        
       
        for(FPAN_Practice_CPO__c PracticeCPO: pcoList ){
            mapPracCPO.put(PracticeCPO.Id,PracticeCPO);
        }
        
        system.debug('@@@mapPracCPO--->'+mapPracCPO);
        system.debug('@@@mapPracCPO size--->'+mapPracCPO.size());
        
        List<Practice_CPO_Objectives__c> practiceCPOObjList = new List<Practice_CPO_Objectives__c>();
        
       // if(listCPOObj.size()>0){
       if(mapPracCPO.size()>0){
           for(Id PCOPs : mapPracCPO.keyset()){
           system.debug('@@@Inside For loop 1');
            for(FPAN_CPO_Objective__c cpoOB : listCPOObj){
                 system.debug('Objective Type -->'+cpoOB.FPAN_Objective_Type__c);
                 system.debug('Account CPO Type -->'+mapPracCPO.get(PCOPs).FPAN_CPO_Type_Formula__c);
           If(cpoOB.FPAN_Objective_Type__c == mapPracCPO.get(PCOPs).FPAN_CPO_Type_Formula__c){
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
           }
       Insert practiceCPOObjList;
    }
}