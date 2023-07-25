/************************************************************************
* Name : FPAN_Apex_ExtensionController
* Author : Sreeni
* Date : 19/Dec/2021
* Desc : Functionality to call Edit Provider Facility Omniscript.
*************************************************************************/
public class FPAN_Apex_ExtensionController {
    
    public FPAN_Apex_ExtensionController(ApexPages.StandardController stdController) {              
        
    }
    
    public PageReference redirect(){
        Id recordId = ApexPages.currentPage().getParameters().get('id');
        PageReference pr = new PageReference(label.FPAN_LBL_EditProviderfacility+recordId);
        pr.setRedirect(true);
        return pr;
    }
}