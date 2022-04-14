//
//  ForgetPasswordViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 14/4/2022.
//

import UIKit
import Firebase

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var popUPView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUPView.layer.cornerRadius = 20.0
        popUPView.layer.shadowColor = UIColor.black.cgColor
        popUPView.layer.shadowOpacity = 0.5
        popUPView.layer.shadowOffset = .zero
        popUPView.layer.shadowRadius = 5
    }
    
    @IBAction func forgetPasswdBtn(_ sender: Any) {
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: emailTF.text!) { (error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
