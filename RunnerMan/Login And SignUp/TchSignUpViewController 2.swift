//
//  TchSignUpViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 22/1/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class TchSignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var CpasswdTextField: UITextField!
    
    func validateFields() -> String? {
        //Check that all fields are filled in
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
            phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
            passwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
            CpasswdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" {
            
            return "Please fill in all fields."
        }
        
        //Comfirm password == password
        if CpasswdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != passwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            return "Make sure your password is correct."
        }
            
        return nil
    }
    
    @IBAction func teacherSignUp(_ sender: Any) {
        let error = validateFields()
        
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
            let password = passwdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the teacher
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
                if err != nil {
                    //Error to create teacher
                    self.showAlertMessage(2)
                } else {
                    
                    //Teacher created successfully
                    let db = Firestore.firestore()
                    
                    db.collection("teacher").document(result!.user.uid).setData(["teacherEmail":email,
                                                                                    "teacherName":name,
                                                                                    "teacherContactNumber":phoneNumber,
                                                                                 "Code": "",
                                                                                    "uid":result!.user.uid]) { (error) in
                        if error != nil {
                            //Error to create teacher
                            self.showAlertMessage(2)
                        }
                    }
                    
                    //Transition to teacher sign in page
                    self.transitionToSignIn()
                }
            }
            
        }
    }
    
    func transitionToSignIn() {
        //Transition to sign in page
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
}
