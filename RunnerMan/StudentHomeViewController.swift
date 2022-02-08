//
//  StudentHomeViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/1/2022.
//

import UIKit
import FirebaseAuth

class StudentHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "studentLoginPage") {
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
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
