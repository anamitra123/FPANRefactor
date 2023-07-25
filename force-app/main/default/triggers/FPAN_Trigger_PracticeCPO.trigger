trigger FPAN_Trigger_PracticeCPO on FPAN_Practice_CPO__c (before Insert, after insert, before update) {
    List <FPAN_Practice_CPO__c> listFPCO = new List <FPAN_Practice_CPO__c>();
    if(trigger.isAfter && trigger.isInsert ){
        for(FPAN_Practice_CPO__c FPCO: Trigger.New){
             listFPCO.add(FPCO);
        }
        System.enqueuejob(new FPAN_Apex_QueableCreatePracticeCPOObj(listFPCO));
    }
    
}