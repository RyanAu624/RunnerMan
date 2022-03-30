//
//  CalendarVIewController.swift
//  RunnerMan
//
//  Created by TonyKong on 14/3/2022.
//

import UIKit
import CalendarKit
import EventKit

class CalendarVIewController: DayViewController{
    private let eventStore = EKEventStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "calendar"
        requestAccessToCalendar()
    }
    
    func requestAccessToCalendar(){
        eventStore.requestAccess(to: .event) {success, error in
            
        }
    }
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDay = DateComponents()
        oneDay.day = 1
        
        let endDate = calendar.date(byAdding: oneDay, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map(EKWrapper.init)
        return calendarKitEvents
    }
}
