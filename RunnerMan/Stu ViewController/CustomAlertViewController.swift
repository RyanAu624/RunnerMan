//
//  CustomAlertViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 14/4/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CustomAlertViewController: UIViewController {
    
    let db = Firestore.firestore()
    var training = [Training]()
    
    @IBOutlet weak var popUPView: UIView!
    @IBOutlet weak var activityListBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUPView.layer.cornerRadius = 20.0
        popUPView.layer.shadowColor = UIColor.black.cgColor
        popUPView.layer.shadowOpacity = 0.5
        popUPView.layer.shadowOffset = .zero
        popUPView.layer.shadowRadius = 5
        
        getTrainingList()
        
        activityListBtn.showsMenuAsPrimaryAction = true
        activityListBtn.changesSelectionAsPrimaryAction = true
        
        let optionsClosure = { (action: UIAction) in
          print(action.title)
        }
        
        activityListBtn.menu = UIMenu(children: [
            UIAction(title: "Option 1", state: .on, handler: optionsClosure),
            UIAction(title: "Option 2", handler: optionsClosure),
            UIAction(title: "Option 3", handler: optionsClosure)
        ])
    }
    
    func getTrainingList() {
        db.collection("Training").getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.training = snapshot.documents.map { d in
                        return Training(trainingID: d["Psotid"] as? String ?? "",
                                        trainingMethod: d["Training Method"] as? String ?? "",
                                        trainingVideo: d["Video"] as? String ?? "",
                                        trainingDescription: d["description"] as? String ?? "",
                                        trainingDay: d["Train Day"] as? String ?? "",
                                        trainingStartTime: d["Start time"] as? String ?? "",
                                        trainingEndTime: d["End time"] as? String ?? "",
                                        member: [])
                    }
                }
            }
        }
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
