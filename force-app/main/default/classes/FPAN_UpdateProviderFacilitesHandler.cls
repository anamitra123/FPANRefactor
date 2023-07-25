/************************************************************************
* Name :FPAN_UpdateProviderFacilitesHandler
* Author : Abhijeet Nagnath Ghodke
* Date : 04/03/2023
* Desc : This is the class for sharing the provider facilities records
* Test Class:FPAN_UpdateProviderFacilitesHandle_Test
*************************************************************************/


public class FPAN_UpdateProviderFacilitesHandler {
    
    public static List<Id> ContactIds = New List<Id>();
    public static Map<Id,Id> conUserIdMap = new Map<Id,Id>();
    public static Map<Id,Id> conAccIdMap = new Map<Id,Id>();
    public static Map<Id,Id> HPFRecord = new Map<Id,Id>();
    public static List<Id> HPFIdList=new List<Id>();
    public static List<HealthcarePractitionerFacility> PFList =[Select id,OwnerId,AccountId from HealthcarePractitionerFacility where AccountId != null];
    public static List<HealthcarePractitionerFacilityShare> HPFShareList = new List<HealthcarePractitionerFacilityShare>();   
    
    Public static void updateProviderFacilityHandler(List<User>userList){
        String AccountIdVal;
        for(User user:userList){
            conUserIdMap.put(user.ContactId,user.Id);
            conAccIdMap.put(user.ContactId,user.FPAN_AccountId__c);
            ContactIds.add(user.ContactId);
        }
        For(HealthcarePractitionerFacility HPFRec : PFList){
            HPFRecord.put(HPFRec.AccountId, HPFRec.Id);            
            
        }
        
        insertUserRole2(ContactIds);
        
    }
    
    public static void insertUserRole2(List<Id> conIds){
        for(Id conIdVal :conIds){
            String AccVal = conAccIdMap.get(conIdVal);
            
            String HPFIdVal = HPFRecord.get(AccVal);
          
            String userIdVal = conUserIdMap.get(conIdVal);
           
            updateHPF(userIdVal,AccVal);
        }
        
    }
    @Future
    public static void updateHPF(String userId, String accountIdVal){
        List<HealthcarePractitionerFacility> PFList =[Select id,OwnerId,FPAN_Facility_Sibling_Id__c,recordtypeId,recordtype.Name from HealthcarePractitionerFacility where AccountId = :accountIdVal];
        List<HealthcarePractitionerFacility> PFSiblingId = New List<HealthcarePractitionerFacility>();
        for(HealthcarePractitionerFacility HPFLocation : PFList){
            PFSiblingId.add(HPFLocation);            
        }
        
        for(HealthcarePractitionerFacility HPF : PFList){
            HealthcarePractitionerFacilityShare objHealthcarePractitionerFacilityShare= new HealthcarePractitionerFacilityShare();
            objHealthcarePractitionerFacilityShare.ParentId=HPF.Id;
            objHealthcarePractitionerFacilityShare.UserOrGroupId =userID;
            objHealthcarePractitionerFacilityShare.AccessLevel = 'Read';
           
            HPFShareList.add(objHealthcarePractitionerFacilityShare); 
        }
        for(HealthcarePractitionerFacility HPF1 : PFSiblingId){
            HealthcarePractitionerFacilityShare objHealthcarePractitionerFacilityShare= new HealthcarePractitionerFacilityShare();
            objHealthcarePractitionerFacilityShare.ParentId=HPF1.FPAN_Facility_Sibling_Id__c;
            objHealthcarePractitionerFacilityShare.UserOrGroupId =userID;
            objHealthcarePractitionerFacilityShare.AccessLevel = 'Read';
            
            HPFShareList.add(objHealthcarePractitionerFacilityShare); 
        }
        if(HPFShareList.size()>0){
            try{
                List<Database.SaveResult> sr = Database.insert(HPFShareList,false);
              
            }catch(exception e){
                System.debug('Exception-->'+e);
                
            }
        }    
    } 
    
   
}