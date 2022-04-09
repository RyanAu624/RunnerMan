//
//  TchTrainingListTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 9/4/2022.
//

import UIKit
import FirebaseFirestore

class TchTrainingListTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var traning = [Training]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecord()
        self.tableView.reloadData()
    }
    
    func getRecord(){
        let db = Firestore.firestore()
        
        db.collection("Training").getDocuments() {(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                    self.traning = snapshot.documents.map { d in
                        return Training(trainingID: d.documentID,
                                        trainingMethod: d["Training Method"] as? String ?? "",
                                        trainingVideo: "" as? String ?? "",
                                        trainingDescription: d["description"] as? String ?? "",
                                        trainingDay: d["Train Day"] as? String ?? "",
                                        trainingStartTime: d["Start time"] as? String ?? "",
                                        trainingEndTime: d["End time"] as? String ?? "")
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
        return traning.count
    }

    // set table view height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordcell", for: indexPath) as! RecordTableViewCell

        cell.TrainingMethod.text = traning[indexPath.row].trainingMethod
        cell.TrainingDay.text = traning[indexPath.row].trainingDay
        // Configure the cell...

        return cell
    }
}
