public with sharing class CalendarEvent {



    public static void ManageCourseEvents(list<Opportunity> oppsIn, Map<Id,Opportunity> oldOppsIn){
        
        List<Event> lstNewEvents = new List<Event>();
 
        List<Opportunity> oppsToInsert = new List<Opportunity>();
     
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
     
        List<Opportunity> oppsToDelete = new List<Opportunity>();

        List<Opportunity> oppsToComplete = new List<Opportunity>();
    
        Set<Id> OppSet = new Set<Id>();
   
    for(Opportunity opp: OppsIn){
        
        OppSet.Add(opp.Id);
        if (opp.StageName == 'Cancelled')
        {
            oppsToDelete.add(opp);
        }
        else if (opp.Update__c == 'False') {
            oppsToInsert = oppsIn;
        } 
        else if (opp.StageName == 'Completed')
        {
            oppsToComplete.add(opp);   
        }
        else{
            oppsToUpdate.add(opp);
        }
    }
 
    Map<Id,Opportunity> InstructorMap = new Map<Id,Opportunity>([SELECT Id, Course_Rate__r.User__c FROM Opportunity WHERE Id IN : OppSet]);

    if (oppsToInsert.size()>0)
    {
    for(Opportunity eve: oppsToInsert)
    {
        Event e = new Event();
 
        e.StartDateTime = eve.Start_Date__c;
        e.EndDateTime = eve.Close_Date__c;
        e.Subject = eve.Type + ' - ' + eve.Start_Date__c.format();
        e.Location = eve.Location__c;
        e.OwnerId = InstructorMap.get(eve.Id).Course_Rate__r.User__c;
        e.WhatId = eve.Id;
        lstNewEvents.add(e);
        
    }
    System.debug(lstNewEvents);
    insert lstNewEvents;

    List<contact> lstcon=[Select id, Email from contact];
            List<Id> lstids= new List<Id>();
            for(Contact c:lstcon) {
                if (c.Email == 'liamc674@gmail.com')
                {
                    lstids.add(c.id);
                }

            }
            EmailTemplate et=[Select id from EmailTemplate where name = 'new_Course' limit 1];
            
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(lstIds);
            mail.setSenderDisplayName('System Admin');
            mail.setTemplateId(et.id);
            Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });

    }
    
    if (oppsToDelete.size()>0)
    {
        Set<Id> OppSetDelete = new Set<Id>();

        for(Opportunity eve: oppsToDelete)
        {
            OppSetDelete.add(eve.Id);
    
        }

        List<Event> events = [SELECT id from Event where whatId IN:OppSetDelete];
        delete events;

            List<contact> lstcon=[Select id, Email from contact];
            List<Id> lstids= new List<Id>();
            for(Contact c:lstcon) {
                if (c.Email == 'liamc674@gmail.com')
                {
                    lstids.add(c.id);
                }

            }
            EmailTemplate et=[Select id from EmailTemplate where name = 'Cancelled' limit 1];
            
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(lstIds);
            mail.setSenderDisplayName('System Admin');
            mail.setTemplateId(et.id);
            Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
    }

    if (oppsToUpdate.size()>0)
    {
        Set<Id> OppSetUpdate = new Set<Id>();

        for(Opportunity eve: oppsToUpdate)
        {
            OppSetUpdate.add(eve.Id);
        }

        List<Event> so = [SELECT id from Event where whatId IN:OppSetUpdate limit 1];
        List<Event> EventUpdate = new List<Event>();
        
        Integer count = 0;


        for (Event eve : so)
        {
            eve.StartDateTime = oppsToUpdate[count].Start_Date__c;
            eve.EndDateTime = oppsToUpdate[count].Close_Date__c;
            eve.Location = oppsToUpdate[count].Location__c;
            
            EventUpdate.add(eve);
            count++;
        }

       
        update EventUpdate;
}

if (oppsToComplete.size()>0)
{


    Set<Id> OppSetUpdate = new Set<Id>();

	    List<Invoice__c> lstObj  = new List<Invoice__c>();
        
	    for(Opportunity opps : oppsToComplete){

			Invoice__c obj = new Invoice__c();

            obj.RecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
			obj.Name = 'Draft6';
            obj.Invoice_Date__c = opps.CloseDate;
            obj.Courses__c = opps.Id;
			lstObj.add(obj);

		}
		
		insert lstObj; 
		
}

    lstNewEvents.clear();

    }

}


