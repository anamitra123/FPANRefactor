public class FTESpecialityHandler {

    public static void afterinsert(Map < Id, CareProviderFacilitySpecialty > newMap) {
        RollUpFTEToFacility(newMap, null);
    }
    public static void afterupdate(Map < Id, CareProviderFacilitySpecialty > newMap, Map < Id, CareProviderFacilitySpecialty > oldMap) {
        RollUpFTEToFacility(newMap, oldMap);
    }
    public static void afterdelete(Map < Id, CareProviderFacilitySpecialty > oldMap) {
        RollUpFTEToFacility(oldMap, null);
    }

    Public static void RollUpFTEToFacility(Map < Id, CareProviderFacilitySpecialty > newMap, Map < Id, CareProviderFacilitySpecialty > oldMap) {
        Set < Id > FacilityId = new Set < Id > ();
        for (CareProviderFacilitySpecialty cpf: newMap.values()) {
            system.debug('##inside for');
            if (cpf.PractitionerFacilityId != null) {
                FacilityId.add(cpf.PractitionerFacilityId);
            }
        }
        if (FacilityId.size() > 0) {
            map < id, double > ftemap = new map < id, double > ();

            for (aggregateresult ag: [SELECT PractitionerFacilityId, SUM(FPAN_FTE__c) FTESUM FROM CareProviderFacilitySpecialty WHERE PractitionerFacilityId IN: FacilityId AND isactive = true GROUP BY PractitionerFacilityId]) {
                ftemap.put((ID) ag.get('PractitionerFacilityId'), double.valueof(ag.get('FTESUM')));
                system.debug('##aggregate');
            }

            list < HealthcarePractitionerFacility > hpflst = new list < HealthcarePractitionerFacility > ();
            for (id iid: FacilityId) {
                HealthcarePractitionerFacility hpf = new HealthcarePractitionerFacility(id = iid);
                if (ftemap.containskey(iid)) {
                    hpf.FPAN_FTE__c = ftemap.get(iid);
                    //system.debug('@@@@@@@@@@hpf.FPAN_FTE__c'+hpf.FPAN_FTE__c);
                    //system.debug('@@@@@@@@@@ftemap.getiid'+ftemap.get(iid));
                    system.debug('##map equate');
                } else {
                    hpf.FPAN_FTE__c = 0;
                }
                hpflst.add(hpf);
            }

            if (hpflst.size() > 0) {
                try {
                    update hpflst;

                } catch (exception ex) {
                    for (CareProviderFacilitySpecialty cpf: newMap.values()) {
                        string x = ex.getMessage();
                        if (x.contains('FTE')) {
                            cpf.addError('Provider FTE should not exceed 1');
                        } else {
                            //System.debug('Hi@@@@@@' + ex.getMessage());
                            cpf.addError('There is error occured in trigger execution');
                        }
                    }
                }
            }
        }
        if (FacilityId.size() > 0) {
            map < id, double > ftemap = new map < id, double > ();

            for (aggregateresult ag: [SELECT PractitionerFacilityId, SUM(FPAN_FTE__c) FTESUM FROM CareProviderFacilitySpecialty WHERE PractitionerFacilityId IN: FacilityId GROUP BY PractitionerFacilityId]) {
                ftemap.put((ID) ag.get('PractitionerFacilityId'), double.valueof(ag.get('FTESUM')));
                system.debug('##aggregate');
            }

            list < HealthcarePractitionerFacility > hpflst = new list < HealthcarePractitionerFacility > ();
            for (id iid: FacilityId) {
                HealthcarePractitionerFacility hpf = new HealthcarePractitionerFacility(id = iid);
                if (ftemap.containskey(iid)) {
                    hpf.FPAN_Overall_FTE__c = ftemap.get(iid);
                    //system.debug('@@@@@@@@@@hpf.FPAN_Overall_FTE__c'+hpf.FPAN_Overall_FTE__c);
                    //system.debug('@@@@@@@@@@ftemap.getiid'+ftemap.get(iid));
                    system.debug('##map equate');
                } else {
                    hpf.FPAN_Overall_FTE__c = 0;
                }
                hpflst.add(hpf);
            }

            if (hpflst.size() > 0) {
                try {
                    update hpflst;

                } catch (exception ex) {
                    for (CareProviderFacilitySpecialty cpf: newMap.values()) {
                        string x = ex.getMessage();
                        if (x.contains('FTE')) {
                            cpf.addError('Provider FTE should not exceed 1');
                        } else {
                            //System.debug('Hi@@@@@@' + ex.getMessage());
                            cpf.addError('There is error occured in trigger execution');
                        }
                    }
                }
            }
        }
    }
}