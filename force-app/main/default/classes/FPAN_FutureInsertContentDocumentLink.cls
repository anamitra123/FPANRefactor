global class FPAN_FutureInsertContentDocumentLink {
    
    
    public static void CredFPAInsertCDL(Set<Id> FPArecordIds){ 
        List<ContentDocumentLink> insertCDLinks = new List<ContentDocumentLink>();
        String CredFPAId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN Credentialing FPA' LIMIT 1].Id;
        List<ContentVersion> createdFPARecs = [Select id,ContentDocumentId from ContentVersion where id IN : FPArecordIds];
        System.debug('createdFVCLRecs-->'+createdFPARecs.size());
        for(ContentVersion cvFPARec : createdFPARecs ){
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = CredFPAId;
            cdl.ContentDocumentId = cvFPARec.ContentDocumentId;
            insertCDLinks.add(cdl);
        }
        Insert insertCDLinks;
        System.debug('insertCDLinks--->'+insertCDLinks.size());
    }
    
    
    public static void CredFVCLInsertCDL(Set<Id> FVCLrecordIds){ 
        List<ContentDocumentLink> insertCDLinks = new List<ContentDocumentLink>();
        String CredFVCLId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN Credentialing FPA&FVCL' LIMIT 1].Id;
        List<ContentVersion> createdFVCLRecs = [Select id,ContentDocumentId from ContentVersion where id IN : FVCLrecordIds];
        System.debug('createdFVCLRecs-->'+createdFVCLRecs.size());
        for(ContentVersion cvFVCLRec : createdFVCLRecs ){
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = CredFVCLId;
            cdl.ContentDocumentId = cvFVCLRec.ContentDocumentId;
            insertCDLinks.add(cdl);
        }
        Insert insertCDLinks;
        System.debug('insertCDLinks--->'+insertCDLinks.size());
    }
    
    
    public static void ReCredFPAInsertCDL(Set<Id> FPArecordIds){ 
        List<ContentDocumentLink> insertCDLinks = new List<ContentDocumentLink>();
        String ReCredFPAId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN ReCredentialing FPA' LIMIT 1].Id;     
        List<ContentVersion> createdFVCLRecs = [Select id,ContentDocumentId from ContentVersion where id IN : FPArecordIds];
        
        for(ContentVersion cvFVCLRec : createdFVCLRecs ){
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = ReCredFPAId;
            cdl.ContentDocumentId = cvFVCLRec.ContentDocumentId;
            insertCDLinks.add(cdl);
        }
        Insert insertCDLinks;
    }
    
    public static void ReCredFVCLInsertCDL(Set<Id> FVCLrecordIds){  
        List<ContentDocumentLink> insertCDLinks = new List<ContentDocumentLink>();
        String ReCredFVCLId = [SELECT Id, Name FROM ContentWorkspace where name ='FPAN ReCredentialing FVCL' LIMIT 1].Id;      
        List<ContentVersion> createdFVCLRecs = [Select id,ContentDocumentId from ContentVersion where id IN : FVCLrecordIds];
        
        for(ContentVersion cvFVCLRec : createdFVCLRecs ){
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = ReCredFVCLId;
            cdl.ContentDocumentId = cvFVCLRec.ContentDocumentId;
            insertCDLinks.add(cdl);
        }
        Insert insertCDLinks;
    }
}