@isTest
public class FPAN_Apex_InSelectExtensionConTest {
    public static testMethod void testInNetwork() {
    
    Id AccIdProvider = FPAN_TestDataUtility_Test.CreateProviderAccount(FPAN_TestDataUtility_Test.ACCOUNT_NAME_LABEL);
    
    Id PPAId = FPAN_TestDataUtility_Test.CreatePurchaserPlanAssnRec(AccIdProvider);
            
    PageReference pageRef = Page.FPAN_VF_DeselctInNetwork;
    
        
        test.startTest();
        
        Account acc = [SELECT Id from Account where Id =: AccIdProvider limit 1];
        
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',acc.id);
        FPAN_Apex_InSelectExtensionController cont = new FPAN_Apex_InSelectExtensionController();
        cont.redirect();
        cont.goBack();
            
        test.stopTest();
    }
    
}