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
    var list = [Training]()
    
    @IBOutlet weak var popUPView: UIView!
    @IBOutlet weak var activityListBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUPView.layer.cornerRadius = 20.0
        popUPView.layer.shadowColor = UIColor.black.cgColor
        popUPView.layer.shadowOpacity = 0.5
        popUPView.layer.shadowOffset = .zero
        popUPView.layer.shadowRadius = 5

        let optionsClosure = { (action: UIAction) in
          print(action.title)
        }
        
        getTrainingList(loadCompletion : {
            var actions = [UIAction]()
            for training in self.training {
                actions.append(UIAction(title: "\(training.trainingMethod)", handler: optionsClosure))
            }
            self.activityListBtn.menu = UIMenu(children: actions)
        })
        
        activityListBtn.showsMenuAsPrimaryAction = true
        activityListBtn.changesSelectionAsPrimaryAction = true
    }
    
//    func getRecord(loadCompletion : @escaping ()->Void){
//        let db = Firestore.firestore()
//        
//        db.collection("Training").getDocuments() {(snapshot, err) in
//            
//            if err == nil {
//                if let snapshot = snapshot {
//                    self.training = snapshot.documents.map { d in
//                        return Training(trainingID: d["Postid"] as? String ?? "",
//                                        trainingMethod: d["Training Method"] as? String ?? "",
//                                        trainingVideo: d["Video"] as? String ?? "",
//                                        trainingDescription: d["description"] as? String ?? "",
//                                        trainingDay: d["Train Day"] as? String ?? "",
//                                        trainingStartTime: d["Start time"] as? String ?? "",
//                                        trainingEndTime: d["End time"] as? String ?? "",
//                        member: [])
//                    }
//                    loadCompletion()
//                }
//            }
//        }
//    }
    
    func getTrainingList(loadCompletion : @escaping ()->Void) {
        db.collection("Training").getDocuments() {(snapshot, err) in

            if err == nil {
                if let snapshot = snapshot {
                    self.training = snapshot.documents.map { d in
                        let id = d["Postid"] as! String
                        let method = d["Training Method"] as! String
                        let video = d["Video"] as! String
                        let des = d["description"] as! String
                        let day = d["Train Day"] as! String
                        let Stime = d["Start time"] as! String
                        let Etime = d["End time"] as! String
                        let member = d["member"]
                        let uid = Auth.auth().currentUser?.uid
                        let member2 = d["member"] as! [String]
                        let len2 = member2.count - 1
                        if len2 >= 0 {
                            for index in 0...len2 {
                                if member2[index] == uid {
                                    self.list.append(Training(trainingID: id, trainingMethod: method, trainingVideo: video, trainingDescription: des, trainingDay: day, trainingStartTime: Stime, trainingEndTime: Etime, member: member as! [String] ))
                                }
                            }
                        }
                        return Training(trainingID: id, trainingMethod: method, trainingVideo: video, trainingDescription: des, trainingDay: day, trainingStartTime: Stime, trainingEndTime: Etime, member: [])
                    }
                    loadCompletion()
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
