//
//  CalendarVIewController.swift
//  RunnerMan
//
//  Created by TonyKong on 14/3/2022.
//

import UIKit
import CalendarKit
import EventKit
import EventKitUI

class CalendarVIewController: DayViewController, EKEventEditViewDelegate{
    
    private let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAccessToCalendar()
        setNotification()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    // ask the premission of calendar
    func requestAccessToCalendar(){
        eventStore.requestAccess(to: .event) {success, error in
            
        }
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)), name: .EKEventStoreChanged, object: eventStore)
    }
    
    @objc func storeChanged(_ notification: Notification) {
        reloadData()
    }
    
    // convert events to calendarKit's format
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
    
    //show event details
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        print("Event Clicked")
        guard let ckEvent = eventView.descriptor as? EKWrapper else {
            return
        }
        
        let ekEvent = ckEvent.ekEvent
        let eventViewController = EKEventViewController()
        eventViewController.event = ekEvent
        eventViewController.allowsCalendarPreview = true
        eventViewController.allowsEditing = true
        navigationController?.pushViewController(eventViewController, animated: true)
    }
    
    @objc func didTapAdd(){
        eventStore.requestAccess(to: .event) {[weak self] success, error in
            if success, error == nil {
                DispatchQueue.main.async {
                    guard let store = self?.eventStore else {return}
                    let newEvent = EKEvent(eventStore: store)
                    newEvent.title = "Event"
                    newEvent.startDate = Date()
                    newEvent.endDate = Date()
                    let otherVc = EKEventEditViewController()
                    otherVc.eventStore = store
                    otherVc.event = newEvent
                    self?.present(otherVc, animated: true, completion: nil)
                }
            }
        }
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
