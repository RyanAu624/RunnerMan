//
//  ManageStuTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 26/1/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class ManageStuTableViewController: UITableViewController {
    
    var student = [Student]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getStu()
        self.tableView.reloadData()

    }
    
    func getStu() {
        
        let db = Firestore.firestore()
        
        db.collection("student").getDocuments() {(snapshot, err) in

            if err == nil {
                if let snapshot = snapshot {
                    self.student = snapshot.documents.map { d in
                        return Student(studentID: d["studentId"] as? String ?? "",
                                       studentName: d["studentName"] as? String ?? "",
                                       studentEmail: d["studentEmail"] as? String ?? "",
                                       studentContactNumber: d["studentContactNumber"] as? String ?? "",
                                       studentClass: d["studentClass"] as? String ?? "",
                                       studentAge: d["studentAge"] as? String ?? "",
                                       studentWeight: d["studentWeight"] as? String ?? "",
                                       studentHeight: d["studentHeight"] as? String ?? "",
                                       uid: d.documentID)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                print(self.student)
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
        return student.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mStuCell", for: indexPath) as! ManageStuCell
        cell.name.text = student[indexPath.row].studentName
        cell.stuId.text = student[indexPath.row].studentID
        
        return cell
    }

}
