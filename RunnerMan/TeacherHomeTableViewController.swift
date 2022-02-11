//
//  TeacherHomeTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/2/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TeacherHomeTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    let id = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @IBAction func createStu(_ sender: Any) {
        
        let inviteCode = Int.random(in: 123009...987654)
        showAlertMessage(inviteCode)
        
        let ref = db.collection("inviteCode").document("code")
        
        ref.updateData(["code":String(inviteCode)])
    }
    
    func showAlertMessage(_ inviteCode:Int) {
        
        let alertController = UIAlertController(title: String(inviteCode), message: "InviteCode...", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
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
