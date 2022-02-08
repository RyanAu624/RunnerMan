//
//  TeacherSettingViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 6/2/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class TeacherSettingViewController: UIViewController {
    
    let db = Firestore.firestore()
    let uID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var teacherNameTF: UITextField!
    @IBOutlet weak var teacherEmailTF: UITextField!
    @IBOutlet weak var teacherPhoneNumTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()

        // Do any additional setup after loading the view.
    }
    
    func getUserData() {
        
        let ref = db.collection("teacher")
        
        ref.whereField("uid", isEqualTo: uID!).getDocuments {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let teacherName = document.data()["teacherName"]
                        let teacherEmail = document.data()["teacherEmail"]
                        let teacherPhoneNum = document.data()["teacherContactNumber"]
                        
                        self.teacherNameTF.text = (teacherName as! String)
                        self.teacherEmailTF.text = (teacherEmail as! String)
                        self.teacherPhoneNumTF.text = (teacherPhoneNum as! String)
                    }
                }
            }
        }
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        
        let teaName = teacherNameTF.text
        let teaEmail = teacherEmailTF.text
        let teaPhoneNum = teacherPhoneNumTF.text
        
        let ref = db.collection("teacher").document(uID!)
        
        ref.updateData(["teacherEmail":teaEmail as Any,
                        "teacherName":teaName as Any,
                        "teacherContactNumber":teaPhoneNum as Any])
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