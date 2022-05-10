//
//  AddStuUserViewController.swift
//  RunnerMan
//
//  Created by TonyKong on 10/5/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AddStuUserViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // check that all fields are filled in
    func vaildatefields() -> String? {
        if nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func studentSignUp(_ sender: Any) {
        
        let error = vaildatefields()
        
        if error == "Please fill in all fields." {
            showErrorMessage(0)
        } else {
            // get textfield data
            let name = nameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = ""
            let clss = ""
            let stuId = ""
            let age = ""
            let weight = ""
            let height = ""
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    //Error to create student
                    self.showErrorMessage(1)
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
                            self.showErrorMessage(1)
                        }
                    }
                    self.showSuccessMessage()
                    
                }
            }
        }
    }
    
    // back to home page
    func transitionToHome() {
        //Transition to home page
        dismiss(animated: true, completion: nil)
    }
    
    // show alert message
    func showErrorMessage(_ number:Int) {
        var message = ""
        
        switch number {
        case 0:
            message = "Please fill in all fields."
        case 1:
            message = "There have some error, Please try again later."
            self.passwordTF.text? = ""
        default:
            break
        }
        
        let alertController = UIAlertController(title: "System Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    

    // show alert message when create user successful
    func showSuccessMessage() {
        let message = "User create successful!"
        
        let alertController = UIAlertController(title: "System Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            self.transitionToHome()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
