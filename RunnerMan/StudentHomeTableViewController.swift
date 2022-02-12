//
//  StudentHomeTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/2/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class StudentHomeTableViewController: UITableViewController {
    
    var target = [Target]()
    
    let db = Firestore.firestore()
    let uID = Auth.auth().currentUser?.uid

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStuTarget()
        self.tableView.reloadData()
        self.tableView.separatorStyle = .none
    }
    
    @IBAction func addTargetClicked(_ sender: Any) {
        showAlertController()
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: "Post", message: "Let's setup a new task.", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.keyboardType = UIKeyboardType.phonePad
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController] _ in
            let targetInput = alertController.textFields?[0].text
            //Check user input
            //If user input equal to null the data will not save to firestore
            if targetInput != "" {
                self.saveTargetDataToFirestore(targetInput!)
            }
         }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveTargetDataToFirestore(_ targetInput:String) {
        let ref = db.collection("student").document(uID!).collection("targetList")
                
        ref.document(targetInput).setData(["target":targetInput,
                                "mark":false])
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
    
    func getStuTarget() {
        let ref = db.collection("student").document(uID!).collection("targetList")
        
        ref.getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.target = snapshot.documents.map{ d in
                        return Target(target: d["target"] as? String ?? "",
                                      mark: d["mark"] as! Bool)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return target.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell", for: indexPath) as! TargetCell
        cell.taskLabel.text = target[indexPath.row].target
        if target[indexPath.row].mark == false {
            cell.markCheck.image = UIImage(named: "unmark")
        } else {
            cell.markCheck.image = UIImage(named: "marked")
        }
        
        return cell
    }
    
    // set table view height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TargetCell else { return }
        
        if target[indexPath.row].mark == false {
            //Update target condition
            let ref = db.collection("student").document(uID!).collection("targetList")
            ref.document(target[indexPath.row].target).updateData(["mark":true])
            
            cell.markCheck.image = UIImage(named: "marked")
        } else {
            let ref = db.collection("student").document(uID!).collection("targetList")
            ref.document(target[indexPath.row].target).updateData(["mark":false])
            
            cell.markCheck.image = UIImage(named: "unmark")
        }
    }
}
