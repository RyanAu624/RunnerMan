//
//  TchProfileViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 6/2/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class TchProfileViewController: UIViewController {
    
    let db = Firestore.firestore()
    let uID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var teacherNameTF: UITextField!
    @IBOutlet weak var teacherEmailLabel: UILabel!
    @IBOutlet weak var teacherPhoneNumTF: UITextField!
    
    @IBOutlet weak var teacherPasswdTF: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
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
                        self.teacherEmailLabel.text = (teacherEmail as! String)
                        self.teacherPhoneNumTF.text = (teacherPhoneNum as! String)
                    }
                }
            }
        }
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        
        let teaName = teacherNameTF.text
        let teaPhoneNum = teacherPhoneNumTF.text
        
        let ref = db.collection("teacher").document(uID!)
        
        ref.updateData(["teacherName":teaName as Any,
                        "teacherContactNumber":teaPhoneNum as Any])
    }
    
    @IBAction func updatePasswdClicked(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()

                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "teacherLoginPage") {
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }

            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
