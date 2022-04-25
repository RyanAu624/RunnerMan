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
    
    let uID = Auth.auth().currentUser?.uid
    
    private var inputTrainingID: String = ""
    
    @IBOutlet weak var popUPView: UIView!
    @IBOutlet weak var activityListBtn: UIButton!
    
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var uploadVideoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUPView.layer.cornerRadius = 20.0
        popUPView.layer.shadowColor = UIColor.black.cgColor
        popUPView.layer.shadowOpacity = 0.5
        popUPView.layer.shadowOffset = .zero
        popUPView.layer.shadowRadius = 5

        let optionsClosure = { (action: UIAction) in
            self.findTrainID(title: action.title, findCompetion: { (result) in
                self.inputTrainingID = result
            })
        }
        
        getTrainingList(loadCompletion : {
            var actions = [UIAction]()
            for list in self.list {
                actions.append(UIAction(title: "\(list.trainingMethod)", handler: optionsClosure))
            }
            self.activityListBtn.menu = UIMenu(children: actions)
        })
        
        activityListBtn.showsMenuAsPrimaryAction = true
        activityListBtn.changesSelectionAsPrimaryAction = true
    }
    
    //******************
    func findTrainID(title: String, findCompetion: (_ result : String) -> Void) {
        
        var postID = ""
        
        let ref = db.collection("Training").whereField("Training Method", isEqualTo: title)

        ref.getDocuments {(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        postID = document.data()["Postid"] as! String
                        print("$$$\(postID)$$$")
                    }
                }
            }
        }
        print("***\(postID)***")
        findCompetion("\(postID)")
    }
    //******************
    
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
//        let activity = self.userInput
        let des = descriptionTF.text
        
//        let ref = db.collection("Training").whereField("Training Method", isEqualTo: activity)
//        let ref = db.collection("Training").document(list.trainingID)
//        let secRef = ref.firestore.collection("participant").document(uID!)
//
//        ref.updateData([""])
        
        
//        let stuNumber = studentNumberTF.text
//        let stuName = studentNameTF.text
//        let stuPhoneNum = studentPhoneNumTF.text
//        let stuClass = studentClassTF.text
//        let stuAge = studentAgeTF.text
//        let stuWeight = studentWeightTF.text
//        let stuHeight = studentHeightTF.text
//
//        let ref = db.collection("student").document(uID!)
//
//        ref.updateData(["studentId":stuNumber as Any,
//                        "studentName":stuName as Any,
//                        "studentContactNumber":stuPhoneNum as Any,
//                        "studentClass":stuClass as Any,
//                        "studentAge":stuAge as Any,
//                        "studentWeight":stuWeight as Any,
//                        "studentHeight":stuHeight as Any])
//    }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
