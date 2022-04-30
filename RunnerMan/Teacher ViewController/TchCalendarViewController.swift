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

class TchCalendarViewController: DayViewController, EKEventEditViewDelegate{
    
    private var eventStore = EKEventStore()
    let appear = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appear.configureWithOpaqueBackground()
        self.navigationItem.standardAppearance = appear
        self.navigationItem.scrollEdgeAppearance = appear
        self.title = "Calendar"
        requestAccessToCalendar()
        setNotification()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    // ask the premission of calendar
    func requestAccessToCalendar(){
        eventStore.requestAccess(to: .event) { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.initializeStore()
                self.setNotification()
                self.reloadData()
            }
        }
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)), name: .EKEventStoreChanged, object: eventStore)
    }
    
    private func initializeStore() {
        eventStore = EKEventStore()
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
        guard let ckEvent = eventView.descriptor as? EKWrapper else {
            return
        }
        let ekEvent = ckEvent.ekEvent
        presentDetailView(ekEvent)
    }
    
    private func presentDetailView(_ ekEvent: EKEvent){
        
        let eventViewController = EKEventViewController()
        eventViewController.event = ekEvent
        eventViewController.allowsCalendarPreview = true
        eventViewController.allowsEditing = true
        navigationController?.pushViewController(eventViewController, animated: true)
        
    }
    
    // press long time to edit event quickly
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        endEventEditing()
        guard let ckEvent = eventView.descriptor as? EKWrapper else {
            return
        }
        beginEditing(event: ckEvent, animated: true)
    }
    
    // save change event data
    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        guard let editingEvent = event as? EKWrapper else {
            return
        }
        if let orignEvent = event.editedEvent {
            editingEvent.commitEditing()
            
            if orignEvent === editingEvent {
                presentEditingView(editingEvent.ekEvent)
            } else {
                try! eventStore.save(editingEvent.ekEvent, span: .thisEvent)
                reloadData()
            }
            
            
        }
    }
    
    
    // show edit event view
    func presentEditingView(_ ekEvent: EKEvent) {
        let editVC = EKEventEditViewController()
        editVC.event = ekEvent
        editVC.eventStore = eventStore
        editVC.editViewDelegate = self
        present(editVC, animated: true, completion: nil)
    }
    
    // exit editing
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
    }
    // exit editing
    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
    }
    
    // create new event
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        var oneHRComponents = DateComponents()
        oneHRComponents.hour = 1
        
        let endDate = calendar.date(byAdding: oneHRComponents, to: date)
        
        newEvent.startDate = date
        newEvent.endDate = endDate
        newEvent.title = "Event"
        
        
        let newEKWrapper = EKWrapper(eventKitEvent: newEvent)
        newEKWrapper.editedEvent = newEKWrapper
        create(event: newEKWrapper, animated: true)
    }
    
    
    // add new event
    @objc func didTapAdd(){
        DispatchQueue.main.async {
            let store = self.eventStore
            let newEvent = EKEvent(eventStore: store)
            
            newEvent.title = "Event"
            
            self.presentEditingView(newEvent)
            
        }
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
