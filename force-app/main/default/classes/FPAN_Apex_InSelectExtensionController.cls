/**********************************************************************************************************************
* Name : FPAN_Apex_InSelectExtensionController
* Author : Sreeni
* Date : 16/Mar/2021
* Desc : Deselect In Network button calls this vf page and controller to deselect "In Network" for all payor products. 
**********************************************************************************************************************/
public class FPAN_Apex_InSelectExtensionController {
    public id recordId;
    public List<PurchaserPlanAssn> ppaList  = new List<PurchaserPlanAssn>();
    public List<PurchaserPlanAssn> updateppaList = new List<PurchaserPlanAssn>();
    
    public void redirect(){
        recordId = ApexPages.currentPage().getParameters().get('id');
        ppaList = [Select id,FPAN_In_Network__c,PurchaserId from PurchaserPlanAssn where PurchaserId = :recordId and FPAN_In_Network__c = true];
        if(ppaList.size()>0){
            for(PurchaserPlanAssn ppaRec : ppaList){
                ppaRec.FPAN_In_Network__c = false;
                updateppaList.add(ppaRec);
            }
            try{
                 update updateppaList;
            }catch(Exception e){
                 FPAN_APEX_HandleSystemException.LogException(e);
            }
            
        }
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Deselction of In Network for Payor Products are processed successfully'));
    }
    
    public PageReference goBack(){
        PageReference pr = new PageReference('/'+recordId);
        pr.setRedirect(true);
        return pr;
    }
    
}