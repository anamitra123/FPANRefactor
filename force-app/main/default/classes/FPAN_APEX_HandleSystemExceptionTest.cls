@isTest
public class FPAN_APEX_HandleSystemExceptionTest {
     @isTest
    public static void CreateAccount() {
        try {
            Account m = new Account();
            insert m;
        } catch (Exception e) {
            FPAN_APEX_HandleSystemException.LogException(e);
        }    
    } 

}