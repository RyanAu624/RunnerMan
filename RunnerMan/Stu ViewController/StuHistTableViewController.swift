//
//  StuHistTableViewController.swift
//  RunnerMan
//
//  Created by Hin on 16/4/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class StuHistTableViewController: UITableViewController {

    let db = Firestore.firestore()
    var training = [Training]()
    var list = [Training]()
    let uID = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecord()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getRecord(){
        let db = Firestore.firestore()
        
        db.collection("Training").getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.training = snapshot.documents.map { d in
                        let id = d["Postid"] as! String
                        let method = d["Training Method"] as! String
                        let video = d["Video"] as! String
                        let des = d["description"] as! String
                        let day = d["Train Day"] as! String
                        let Stime = d["Start time"] as! String
                        let Etime = d["End time"] as! String
                        let member = d["member"]
                        let member2 = d["member"] as! [String]
                        let uid = Auth.auth().currentUser?.uid
                        let len2 = member2.count - 1
                        if len2 >= 0 {
                            for index in 0...len2 {
                                if member2[index] == uid {
                                    self.list.append(Training(trainingID: id, trainingMethod: method, trainingVideo: video, trainingDescription: des, trainingDay: day, trainingStartTime: Stime, trainingEndTime: Etime, member: member as! [String] ))
                                }
                            }
                        }
                        return Training(trainingID: id, trainingMethod: method, trainingVideo: video, trainingDescription: des, trainingDay: day, trainingStartTime: Stime, trainingEndTime: Etime, member: [])

                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StuRecordDetailTableViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.trainingID = list[indexPath.row].trainingID
                destination.trainingMethod = list[indexPath.row].trainingMethod
                destination.trainingVideo = list[indexPath.row].trainingVideo
                destination.trainingDescription = list[indexPath.row].trainingDescription
                destination.trainingDay = list[indexPath.row].trainingDay
                destination.trainingStartTime = list[indexPath.row].trainingStartTime
                destination.trainingEndTime = list[indexPath.row].trainingEndTime
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StuHistcell

        cell.method.text = list[indexPath.row].trainingMethod
        cell.day.text = list[indexPath.row].trainingDay
        // Configure the cell...

        return cell
    }
    
}
