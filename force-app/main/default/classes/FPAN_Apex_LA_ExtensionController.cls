/************************************************************************
* Name : FPAN_Apex_LA_ExtensionController
* Author : K.Khalid
* Date : 24/Dec/2021
* Desc : Functionality to call Edit AssociatedLocation Address Omniscript.
*************************************************************************/
public class FPAN_Apex_LA_ExtensionController {
    
    public FPAN_Apex_LA_ExtensionController(ApexPages.StandardController stdController) {              
     
    }
    
    public PageReference redirect(){
       Id recordId = ApexPages.currentPage().getParameters().get('id');
       PageReference pr = new PageReference(label.FPAN_LBL_EditAssociatedLocationAddress+recordId);
       pr.setRedirect(true);
       return pr;
    }
}