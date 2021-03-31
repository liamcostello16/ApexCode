trigger InvoiceTriggers on Invoice__c (after update) {

    CloningInvoice.Clone(trigger.new);

}