//
//  CustomAlertViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 14/4/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var popUPView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUPView.layer.cornerRadius = 20.0
        popUPView.layer.shadowColor = UIColor.black.cgColor
        popUPView.layer.shadowOpacity = 0.5
        popUPView.layer.shadowOffset = .zero
        popUPView.layer.shadowRadius = 5
    }

    @IBAction func uploadBtn(_ sender: Any) {
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
