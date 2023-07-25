trigger FPAN_ProviderStatusUpdate on HealthcarePractitionerFacility (after insert,after update) {

    If(trigger.Isinsert || trigger.IsUpdate){
        FPAN_ProviderStatusTriggerHandler.StatusUpdate(Trigger.New);
    }

}