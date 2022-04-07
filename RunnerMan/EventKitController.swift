//
//  EventKitController.swift
//  RunnerMan
//
//  Created by TonyKong on 3/4/2022.
//

import UIKit
import EventKit
import EventKitUI

class EventKitController: UIViewController, EKEventViewDelegate {
    
    let store = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didTapAdd()
        
        // Do any additional setup after loading the view.
    }
    func didTapAdd(){
        store.requestAccess(to: .event) {[weak self] success, error in
            if success, error == nil {
                DispatchQueue.main.async {
                    guard let store = self?.store else {return}
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
        
        func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
