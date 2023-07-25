@isTest
public class FPAN_FutureInsertDocumentTest {
    @isTest
    public static void CredFPAInsertCDLTest(){
        ContentVersion cv=new ContentVersion(
        Title='Mountain_Master',
        PathOnClient = 'Mountain_Master.jpg',
        VersionData = Blob.valueOf('Test1 Content'),
        IsMajorVersion = true);
        insert cv;
        
        Set<Id> FPAIdSet = new Set<Id>();
        FPAIdSet.add(cv.Id);
        
        Test.startTest();
        FPAN_FutureInsertContentDocumentLink.CredFPAInsertCDL(FPAIdSet);
        Test.stopTest();
    }
    
    @isTest
    public static void CredFVCLInsertCDLTest(){
        ContentVersion cversion=new ContentVersion(
        Title='Mountain_Master1',
        PathOnClient = 'Mountain_Master1.jpg',
        VersionData = Blob.valueOf('Test2 Content'),
        IsMajorVersion = true);
        insert cversion;
        
        Set<Id> FVCLIdSet = new Set<Id>();
        FVCLIdSet.add(cversion.Id);
        
        Test.startTest();
        FPAN_FutureInsertContentDocumentLink.CredFVCLInsertCDL(FVCLIdSet);
        Test.stopTest();
    }
    
    @isTest
    public static void ReCredFPAInsertCDLTest(){
        ContentVersion contentV=new ContentVersion(
        Title='Mountain_Master2',
        PathOnClient = 'Mountain_Master2.jpg',
        VersionData = Blob.valueOf('Test3 Content'),
        IsMajorVersion = true);
        insert contentV;
        
        Set<Id> FPASet = new Set<Id>();
        FPASet.add(contentV.Id);
        
        Test.startTest();
        FPAN_FutureInsertContentDocumentLink.ReCredFPAInsertCDL(FPASet);
        Test.stopTest();
    }
    
    @isTest
    public static void ReCredFVCLInsertCDLTest(){
        ContentVersion contentVersion=new ContentVersion(
        Title='Mountain_Master3',
        PathOnClient = 'Mountain_Master3.jpg',
        VersionData = Blob.valueOf('Test4 Content'),
        IsMajorVersion = true);
        insert contentVersion;
        
        Set<Id> FVCLSet = new Set<Id>();
        FVCLSet.add(contentVersion.Id);
        
        Test.startTest();
        FPAN_FutureInsertContentDocumentLink.ReCredFVCLInsertCDL(FVCLSet);
        Test.stopTest();
    }
    
    
    
    
}