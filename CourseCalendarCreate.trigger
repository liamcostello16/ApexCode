trigger CourseCalendarCreate on Opportunity (before insert, after insert, after delete, after update, before update) {

    CalendarEvent.ManageCourseEvents(trigger.new, trigger.oldMap);
    
}