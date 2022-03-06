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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.separatorStyle = .none
    }
    
    @IBAction func createStu(_ sender: Any) {
        
        let inviteCode = Int.random(in: 123009...987654)
        showAlertMessage(inviteCode)
        
        let id = Auth.auth().currentUser?.uid
        let ref = db.collection("teacher").document(id!)
        
        ref.updateData(["Code":String(inviteCode)])
    }
    
    func showAlertMessage(_ inviteCode:Int) {
        let alertController = UIAlertController(title: String(inviteCode), message: "InviteCode...", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    // set table view height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
