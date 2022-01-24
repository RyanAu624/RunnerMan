//
//  TeacherHomeViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/1/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TeacherHomeViewController: UIViewController {
    
    let db = Firestore.firestore()
    let id = Auth.auth().currentUser?.uid
    
    @IBAction func createStu(_ sender: Any) {
        
        let inviteCode = Int.random(in: 123009...987654)
        showAlertMessage(inviteCode)
        
        let ref = db.collection("teacher").document(id!)
        
        ref.updateData((["code":inviteCode]), completion: nil)
    }
    
    func showAlertMessage(_ inviteCode:Int) {
        
        let alertController = UIAlertController(title: String(inviteCode), message: "InviteCode...", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
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
