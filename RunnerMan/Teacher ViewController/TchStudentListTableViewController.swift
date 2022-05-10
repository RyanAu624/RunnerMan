//
//  TchStudentListTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 26/1/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class TchStudentListTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var student = [Student]()
    var otherlist = [Student]()
    let db = Firestore.firestore()
    let searchController : UISearchController! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStu(loadCompletion: {

        })
        tableView.delegate = self
        tableView.dataSource = self
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
    }
    
    func getStu(loadCompletion : @escaping ()->Void) {
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
                        self.otherlist = self.student
                        loadCompletion()
                    }
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let word = searchController.searchBar.text, word.isEmpty == false {
            student = otherlist.filter({ stu in
                stu.studentName.localizedStandardContains(word) || stu.studentClass.localizedStandardContains(word)
            })
        } else {
            student = otherlist
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TchStuProfileDetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.studentNumber = student[indexPath.row].studentID
                destination.studentName = student[indexPath.row].studentName
                destination.studentEmail = student[indexPath.row].studentEmail
                destination.studentPhoneNum = student[indexPath.row].studentContactNumber
                destination.studentClass = student[indexPath.row].studentClass
                destination.studentAge = student[indexPath.row].studentAge
                destination.studentWeight = student[indexPath.row].studentWeight
                destination.studentHeight = student[indexPath.row].studentHeight
                destination.studentUid = student[indexPath.row].uid
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
        cell.stuId.text = student[indexPath.row].studentClass
        
        return cell
    }
    
    // delete the student profile by teacher press delete button
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedStudentProfile = student.remove(at: indexPath.row)
            
            let ref = db.collection("student").document(removedStudentProfile.uid)
            ref.delete()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // set table view height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
