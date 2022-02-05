//
//  ManageStuDetailViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 5/2/2022.
//

import UIKit

class ManageStuDetailViewController: UIViewController {
    
    var studentNumber : String!
    var studentName : String!
    var studentEmail : String!
    var studentPhoneNum : String!
    var studentClass : String!
    var studentAge : String!
    var studentWeight : String!
    var studentHeight : String!
    

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
