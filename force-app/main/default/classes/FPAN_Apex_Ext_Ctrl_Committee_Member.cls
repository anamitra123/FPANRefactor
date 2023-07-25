/************************************************************************
* Name : FPAN_Apex_Ext_Ctrl_Committee_Member
* Author : Ravi
* Date : 20/July/2022
* Desc : Functionality to call Edit Committee Member Omniscript.
*************************************************************************/
public class FPAN_Apex_Ext_Ctrl_Committee_Member {
    
    public FPAN_Apex_Ext_Ctrl_Committee_Member(ApexPages.StandardController stdController) {              
        
    }
    
    public PageReference redirect(){
        Id recordId = ApexPages.currentPage().getParameters().get('id');
        PageReference pr = new PageReference(label.FPAN_LBL_EditCommitteeMember+recordId);
        pr.setRedirect(true);
        return pr;
    }
}