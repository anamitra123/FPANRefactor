public class FPAN_APEX_HandleSystemException extends Exception {
    
    public static void LogException(Exception e){
        LogException(e,'');
    } 
    public static void LogException(Exception e,string relatedToId){     
        String stackTrace = e.getStackTraceString().substringBefore('\n');
        String className = stackTrace.substringAfter('.').substringBefore('.'); 
        String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
        
        FPAN_System_Exceptions__c exc = new FPAN_System_Exceptions__c();
        //exc.Fair_View__Related_To_Number__c=relatedToId;
        //exc.Fair_View__Govt_Limit_in_Executing_Code__c = String.format('{0}\n{1}\n{2}\n{3}',new List<string>{QueryLimit+' '+DMLLimit+' '+DMLStat+' '+CPUT});
        String message = e.getMessage();
        Integer msgLength= message.length();
        System.debug( 'msgLength-->' + msgLength );
        
        String stackTracestr = e.getStackTraceString();
        Integer stackLength= stackTracestr.length();
        System.debug( 'stackLength-->' + stackLength);
        
        if(msgLength <= 131071){  
        System.debug( 'msgLength in IF-->' + msgLength+'---'+message );      
        exc.FPAN_Error_Details__c = message;
        exc.FPAN_Exception_Message__c = message.substringAfter(':');
        }
        if(stackLength <= 131071){
        System.debug( 'stackLength in IF-->' + stackLength+'---'+stackTracestr);
        exc.FPAN_Stack_Trace__c = stackTracestr;
        }
        exc.FPAN_ExceptionType__c = e.getTypeName();
        exc.FPAN_Line_Number__c = e.getLineNumber();        
        exc.FPAN_Method_Name__c =methodName;
        exc.FPAN_Class_Name__c = className;
        exc.Name=e.getTypeName();
        try{
        insert exc; 
        System.debug('New Exception is created-->'+exc.id);
        
        FPAN_System_Exceptions__c err = [SELECT id,CreatedBy.Name,CreatedBy.Email,CreatedDate FROM FPAN_System_Exceptions__c WHERE id = :exc.id limit 1];
        
        String UserName= err.CreatedBy.Name;
        String UserEmail = err.CreatedBy.Email;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(new String[] {UserEmail,'sreenivas.binkam@gmail.com'});
        mail.setSenderDisplayName('FPAN Salesforce Team');
        
        mail.setSubject('System Exception has been generated');
        String body = 'Dear ' + UserName + ', ';
        body += 'System Exception has been generated. Please find the details below for the same.';
        body += 'Exception Type: '+ exc.FPAN_ExceptionType__c;
        body += 'Exception Message: '+ exc.FPAN_Exception_Message__c;
        body += 'Class Name:'+ exc.FPAN_Class_Name__c;
        body += 'Method Name:'+ exc.FPAN_Method_Name__c;
        body += 'Line Number:'+ exc.FPAN_Line_Number__c;
        body += 'Date:'+ err.CreatedDate;
        body += 'Thank You!';
        mail.setHtmlBody(body);
        
        Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(exception excep){
            system.debug('Exception-->'+excep);
        }
    } 
    /*
//Governer Limit of executingQuery 
String QueryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
String DMLimit = '2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
String DMLStat = '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
String CPUT = '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();

*/
    
}