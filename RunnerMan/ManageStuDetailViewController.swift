//
//  ManageStuDetailViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 5/2/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class ManageStuDetailViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var studentNumber : String!
    var studentName : String!
    var studentEmail : String!
    var studentPhoneNum : String!
    var studentClass : String!
    var studentAge : String!
    var studentWeight : String!
    var studentHeight : String!
    var studentUid : String!

    @IBOutlet weak var studentNumberTF: UITextField!
    @IBOutlet weak var studentNameTF: UITextField!
    @IBOutlet weak var studentEmailTF: UITextField!
    @IBOutlet weak var studentPhoneNumTF: UITextField!
    @IBOutlet weak var studentClassTF: UITextField!
    @IBOutlet weak var studentAgeTF: UITextField!
    @IBOutlet weak var studentWeightTF: UITextField!
    @IBOutlet weak var studentHeightTF: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        studentNumberTF.text = studentNumber
        studentNameTF.text = studentName
        studentEmailTF.text = studentEmail
        studentPhoneNumTF.text = studentPhoneNum
        studentClassTF.text = studentClass
        studentAgeTF.text = studentAge
        studentWeightTF.text = studentWeight
        studentHeightTF.text = studentHeight
    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        
        let stuNum = studentNumberTF.text
        let stuName = studentNameTF.text
        let stuEmail = studentEmailTF.text
        let stuPhoneNum = studentPhoneNumTF.text
        let stuClass = studentClassTF.text
        let stuAge = studentAgeTF.text
        let stuWeight = studentWeightTF.text
        let stuHeight = studentHeightTF.text
        
        let ref = db.collection("student").document(studentUid)
        
        ref.updateData(["studentEmail":stuEmail as Any,
                        "studentName":stuName as Any,
                        "studentContactNumber":stuPhoneNum as Any,
                        "studentId":stuNum as Any,
                        "studentClass":stuClass as Any,
                        "studentAge":stuAge as Any,
                        "studentWeight":stuWeight as Any,
                        "studentHeight": stuHeight as Any])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
