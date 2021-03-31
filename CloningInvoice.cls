public with sharing class CloningInvoice {
    public static void Clone(List<Invoice__c> InvClone) {
        Invoice__c inv = new Invoice__c();
        
        for (Invoice__c obj : InvClone) {
            if (obj.Cloning__c == 'True') {
             inv = obj;  
            }
        }

        Invoice__c clonedInv = inv.clone();
        insert clonedInv;
    }
}
