/************************************************************************
* Name : FPAN_CredentialingDuplicate
* Author : Ravi Kumar
* Date : 22/Dec/2021
* Desc : Credentialing record should be ONE record for Provider Location facility under Provider Account.
* Testclass : FPAN_CredentialingDuplicate_Test
*************************************************************************/
trigger FPAN_CredentialingDuplicate on vlocity_ins__ProviderNetwork__c( before insert , before update)
{
    
    Id RecordType = Schema.SObjectType.vlocity_ins__ProviderNetwork__c.getRecordTypeInfosByName().get('Credentialing').getRecordTypeId();
    Map<ID,Schema.RecordTypeInfo> rt_Map = vlocity_ins__ProviderNetwork__c.sObjectType.getDescribe().getRecordTypeInfosById();
    
    set<ID> idPrac= new set<ID>();
    set<ID> idProv= new set<ID>();
    String recordtypeName = '';
    for(vlocity_ins__ProviderNetwork__c c:trigger.new)
    {	            
        //if(c.FPAN_Practice_Account__c!=null && c.RecordtypeID == RecordType)
        if(c.FPAN_Practice_Account__c!=null && c.RecordtypeID ==RecordType ){
            idPrac.add(c.FPAN_Practice_Account__c);
        idProv.add(c.FPAN_Provider_Account__c);
        recordtypeName = rt_map.get(c.RecordTypeId).getName();
        }
    }

    List<vlocity_ins__ProviderNetwork__c> cred = [select id,name,FPAN_Provider_Account__c,FPAN_Practice_Account__c,FPAN_Provider_Account__r.FPAN_Last_Name__c,FPAN_Provider_Account__r.FPAN_First_Name__c,RecordtypeID,Recordtype.Name from vlocity_ins__ProviderNetwork__c where ( FPAN_Practice_Account__c in :idPrac OR FPAN_Provider_Account__c in :idProv) AND Recordtype.Name =: recordtypeName];
    
    System.debug('Credentialing are ======>'+cred);
    
    for(vlocity_ins__ProviderNetwork__c PN : trigger.new){
        string recordtypeName = rt_map.get(PN.RecordTypeId).getName();
        if((Trigger.isInsert &&cred.size()>0)||(Trigger.isUpdate &&cred.size()>1))
        {
             PN.addError('We found Duplicate '+recordtypeName+' '+' '+'Record, Please select the right Practice or Provider Account Record');
  
        }
        
    }

}