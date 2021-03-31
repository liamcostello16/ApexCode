public with sharing class PDFcreator {

    ApexPages.StandardController sc;

    public list <Line_items__c> lines {get;set;}
    public list <Line_items__c> l = new list <Line_items__c>();

    public PDFcreator(ApexPages.StandardController sc) {
        this.sc = sc; 
        lines = [Select Name, Amount__c, RecordTypeId From Line_items__c Limit 10];

        for(Line_items__c lin : lines)
        {
            if(lin.Id == sc.getRecord().Id)
            {
                l.add(lin);
            }
        }

    }
}
