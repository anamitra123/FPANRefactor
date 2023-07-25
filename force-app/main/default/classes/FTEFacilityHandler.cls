public class FTEFacilityHandler {
 public static void afterinsert(Map < Id, HealthcarePractitionerFacility > newMap) {
        RollUpFTEToAccount(newMap, null);
    }
    public static void afterupdate(Map < Id, HealthcarePractitionerFacility > newMap, Map < Id, HealthcarePractitionerFacility > oldMap) {
        RollUpFTEToAccount(newMap, oldMap);
    }
    public static void afterdelete(Map < Id, HealthcarePractitionerFacility > oldMap) {
        RollUpFTEToAccount(oldMap, null);
    }
    Public static void RollUpFTEToAccount(Map < Id, HealthcarePractitionerFacility > newMap, Map < Id, HealthcarePractitionerFacility > oldMap) {
        Set < Id > AccountID = new Set < Id > ();
        for (HealthcarePractitionerFacility hpf: newMap.values()) {
            system.debug('##inside for');
            if (hpf.AccountId != null) {
                AccountID.add(hpf.AccountId);
            }
            
        }
        if (AccountID.size() > 0) {
            map < id, double > ftemap = new map < id, double > ();

            for (aggregateresult ag: [SELECT AccountId, SUM(FPAN_FTE__c) FTESUM FROM HealthcarePractitionerFacility WHERE AccountId IN: AccountID AND isactive = true GROUP BY AccountId]) {
                ftemap.put((ID) ag.get('AccountId'), double.valueof(ag.get('FTESUM')));
                system.debug('##aggregate');
            }

            list < Account > accList = new list < Account > ();
            for (id iid: AccountID) {
                Account acc = new Account(id = iid);
                if (ftemap.containskey(iid)) {
                    acc.FPAN_Total_FTE__c = ftemap.get(iid);
                    //system.debug('@@@@@@@@@@acc.FPAN_Total_FTE__c'+acc.FPAN_Total_FTE__c);
                    //system.debug('@@@@@@@@@@ftemap.getiid'+ftemap.get(iid));
                    system.debug('##map equate');
                } else {
                    acc.FPAN_Total_FTE__c = 0;
                }
                accList.add(acc);
            }

            if (accList.size() > 0) {
                try {
                    update accList;

                } catch (exception ex) {
                    for (HealthcarePractitionerFacility hpf: newMap.values()) {
                        string x = ex.getMessage();
                        if (x.contains('FTE')) {
                            hpf.addError('Provider FTE should not exceed 1');
                        } else {
                            //System.debug('Hi@@@@@@' + ex.getMessage());
                            hpf.addError('There is error occured in trigger execution');
                        }
                    }
                }
            }
        }
        if (AccountID.size() > 0) {
            map < id, double > ftemap = new map < id, double > ();

            for (aggregateresult ag: [SELECT AccountId, SUM(FPAN_Overall_FTE__c) FTESUM FROM HealthcarePractitionerFacility WHERE AccountId IN: AccountID GROUP BY AccountId]) {
                ftemap.put((ID) ag.get('AccountId'), double.valueof(ag.get('FTESUM')));
                system.debug('##aggregate');
            }

            list < Account > accList = new list < Account > ();
            for (id iid: AccountID) {
                Account acc = new Account(id = iid);
                if (ftemap.containskey(iid)) {
                    acc.FPAN_Overall_FTE__c = ftemap.get(iid);
                    //system.debug('@@@@@@@@@@acc.FPAN_Overall_FTE__c'+acc.FPAN_Overall_FTE__c);
                    //system.debug('@@@@@@@@@@ftemap.getiid'+ftemap.get(iid));
                    system.debug('##map equate');
                } else {
                    acc.FPAN_Overall_FTE__c = 0;
                }
                accList.add(acc);
            }

            if (accList.size() > 0) {
                try {
                    update accList;

                } catch (exception ex) {
                    for (HealthcarePractitionerFacility hpf: newMap.values()) {
                        string x = ex.getMessage();
                        if (x.contains('FTE')) {
                            hpf.addError('Provider FTE should not exceed 1');
                        } else {
                            //System.debug('Hi@@@@@@' + ex.getMessage());
                            hpf.addError('There is error occured in trigger execution');
                        }
                    }
                }
            }
        }
    }
}