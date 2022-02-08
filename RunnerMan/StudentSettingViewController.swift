//
//  StudentSettingViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 7/2/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class StudentSettingViewController: UIViewController {
    
    let db = Firestore.firestore()
    let uID = Auth.auth().currentUser?.uid

    @IBOutlet weak var studentNumberTF: UITextField!
    @IBOutlet weak var studentNameTF: UITextField!
    @IBOutlet weak var studentEmailTF: UITextField!
    @IBOutlet weak var studentPhoneNumTF: UITextField!
    @IBOutlet weak var studentClassTF: UITextField!
    @IBOutlet weak var studentAgeTF: UITextField!
    @IBOutlet weak var studentWeightTF: UITextField!
    @IBOutlet weak var studentHeightTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        
        // Do any additional setup after loading the view.
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
                        self.studentEmailTF.text = (studentEmail as! String)
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
        let stuEmail = studentEmailTF.text
        let stuPhoneNum = studentPhoneNumTF.text
        let stuClass = studentClassTF.text
        let stuAge = studentAgeTF.text
        let stuWeight = studentWeightTF.text
        let stuHeight = studentHeightTF.text
        
        let ref = db.collection("student").document(uID!)
        
        ref.updateData(["studentId":stuNumber as Any,
                        "studentName":stuName as Any,
                        "studentEmail":stuEmail as Any,
                        "studentContactNumber":stuPhoneNum as Any,
                        "studentClass":stuClass as Any,
                        "studentAge":stuAge as Any,
                        "studentWeight":stuWeight as Any,
                        "studentHeight":stuHeight as Any])
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}