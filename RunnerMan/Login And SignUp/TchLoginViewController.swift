//
//  TchLoginViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/1/2022.
//

import UIKit
import FirebaseAuth

class TchLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    
    func vaildateFields() -> String? {
        //Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
            passwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func teacherLogin(_ sender: Any) {
        let error = vaildateFields()
        
        if error == "Please fill in all fields." {
            showAlertMessage(0)
        } else {
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Sign in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    //Couldn't sign in
                    self.showAlertMessage(1)
                    self.emailTextField.text? = ""
                    self.passwdTextField.text? = ""
                    
                } else {
                    
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "teacherHomePage") {
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func showAlertMessage(_ number:Int) {
        var message = ""
        
        switch number {
        case 0:
            message = "Please fill in all fields."
        case 1:
            message = "Make sure your Email and Password correct."
        default:
            break
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func forgetPasswdPageBtn(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let alertView = sb.instantiateViewController(withIdentifier: "ForgetPassAlertViewController") as! ForgetPasswordViewController
        alertView.modalPresentationStyle = .overCurrentContext
        present(alertView, animated: true, completion: nil)
    }
}
