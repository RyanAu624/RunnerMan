//
//  StuProfileViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 7/2/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class StuProfileViewController: UIViewController {
    
    let db = Firestore.firestore()
    let uID = Auth.auth().currentUser?.uid

    @IBOutlet weak var studentNumberTF: UITextField!
    @IBOutlet weak var studentNameTF: UITextField!
    @IBOutlet weak var studentEmailLabel: UILabel!
    @IBOutlet weak var studentPhoneNumTF: UITextField!
    @IBOutlet weak var studentClassTF: UITextField!
    @IBOutlet weak var studentAgeTF: UITextField!
    @IBOutlet weak var studentWeightTF: UITextField!
    @IBOutlet weak var studentHeightTF: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
    }
    
    func getUserData() {
        let ref = db.collection("student")
        
        ref.whereField("uid", isEqualTo: uID!).getDocuments {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let studentNumber = document.data()["studentId"]
                        let studentName = document.data()["studentName"]
                        let studentEmail = document.data()["studentEmail"]
                        let studentPhoneNum = document.data()["studentContactNumber"]
                        let studentClass = document.data()["studentClass"]
                        let studentAge = document.data()["studentAge"]
                        let studentWeight = document.data()["studentWeight"]
                        let studentHeight = document.data()["studentHeight"]
                        
                        self.studentNumberTF.text = (studentNumber as! String)
                        self.studentNameTF.text = (studentName as! String)
                        self.studentEmailLabel.text = (studentEmail as! String)
                        self.studentPhoneNumTF.text = (studentPhoneNum as! String)
                        self.studentClassTF.text = (studentClass as! String)
                        self.studentAgeTF.text = (studentAge as! String)
                        self.studentWeightTF.text = (studentWeight as! String)
                        self.studentHeightTF.text = (studentHeight as! String)
                    }
                }
            }
        }
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        let stuNumber = studentNumberTF.text
        let stuName = studentNameTF.text
        let stuPhoneNum = studentPhoneNumTF.text
        let stuClass = studentClassTF.text
        let stuAge = studentAgeTF.text
        let stuWeight = studentWeightTF.text
        let stuHeight = studentHeightTF.text
        
        let ref = db.collection("student").document(uID!)
        
        ref.updateData(["studentId":stuNumber as Any,
                        "studentName":stuName as Any,
                        "studentContactNumber":stuPhoneNum as Any,
                        "studentClass":stuClass as Any,
                        "studentAge":stuAge as Any,
                        "studentWeight":stuWeight as Any,
                        "studentHeight":stuHeight as Any])
        
        self.navigationController?.popViewController(animated: true)
    }
}
