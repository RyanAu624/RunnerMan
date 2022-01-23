//
//  StudentSignUpViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/1/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class StudentSignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var CpasswdTextField: UITextField!
    @IBOutlet weak var inviteCodeTextField: UITextField!
    
    func vaildateFields() -> String? {
        
        //Check that all fields are filled in
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            CpasswdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            inviteCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //Check Comfirm password == password
        if CpasswdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != passwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            return "Make sure your password is correct."
        }
        
        let db = Firestore.firestore()
        
//        db.collection("inviteCode").document("code").getDocument{ (document, error) in
//
//            if error == nil {
//
//                //Get invite code from firestore
//                if document != nil && document!.exists {
//                    let inviteCode = document!.data()
//                }
//            }
//        }
        
        //Check inviteCode == user input inviteCode
//        if inviteCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != inviteCode {
//
//        }
        
        return nil
    }
    
    @IBAction func studentSignUp(_ sender: Any) {
        
        let error = vaildateFields()
        
        if error == "Please fill in all fields." {
            showAlertMessage(0)
        } else if error == "Make sure your password is correct." {
            showAlertMessage(1)
            self.passwdTextField.text? = ""
            self.CpasswdTextField.text? = ""
        } else {
            
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneNumTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = ageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let weight = ""
            let height = ""
            let password = passwdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the student
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    //Error to create student
                    self.showAlertMessage(2)
                } else {
                    
                    //Student created successfully
                    let db = Firestore.firestore()
                    
                    db.collection("student").addDocument(data: ["email":email,
                                                                "name":name,
                                                                "phoneNumber":phoneNumber,
                                                                "age":age,
                                                                "weight":weight,
                                                                "height":height,
                                                                "uid":result!.user.uid]) { (error) in
                        if error != nil {
                            //Error to create student
                            self.showAlertMessage(2)
                        }
                    }
                    
                    //Transition to student sign in page
                    self.transitionToSignIn()
                }
                
            }
            
        }
    }
    
    func transitionToSignIn() {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlertMessage(_ number:Int) {
        
        var message = ""
        
        switch number {
        case 0:
            message = "Please fill in all fields."
        case 1:
            message = "Make sure your password is correct."
        case 2:
            message = "There have some error, Please try again later."
        default:
            break
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
