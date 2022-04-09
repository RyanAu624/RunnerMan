//
//  StuSignUpViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/1/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class StuSignUpViewController: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var CpasswdTextField: UITextField!
    @IBOutlet weak var inviteCodeTextField: UITextField!
    
    func vaildateFields() -> String? {
        //Check that all fields are filled in
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            classTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            CpasswdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            inviteCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //Check Comfirm password == password
        if CpasswdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != passwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            return "Make sure your password is correct."
        }
        
        //Get inviteCode from firebase
        let ref = db.collection("inviteCode").document("code")
        
        ref.getDocument{(document, err) in
            if let document = document, document.exists {
                let code = document.data()!["code"]
                print(code!)
            }
        }
        
        return nil
    }
    
    @IBAction func studentSignUp(_ sender: Any) {
        let error = vaildateFields()
        checkCode()
        
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
            let clss = classTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let stuId = ""
            let age = ""
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
                    self.db.collection("student").document(result!.user.uid).setData(["studentEmail":email,
                                                                                 "studentName":name,
                                                                                 "studentContactNumber":phoneNumber,
                                                                                 "studentId":stuId,
                                                                                 "studentClass":clss,
                                                                                 "studentAge":age,
                                                                                 "studentWeight":weight,
                                                                                 "studentHeight":height,
                                                                                 "uid":result!.user.uid]){ (error) in
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
        //Transition to sign in page
        dismiss(animated: true, completion: nil)
    }
    
    func checkCode(){
        let ref = db.collection("teacher").getDocuments(){ data, error in
            print(data)
        }
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
}
