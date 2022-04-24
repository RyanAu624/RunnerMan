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
    var training = [Training]()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecord()
    }
    
    func getRecord(){
        db.collection("Training").getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.training = snapshot.documents.map { d in
                        return Training(trainingID: d["Postid"] as? String ?? "",
                                        trainingMethod: d["Training Method"] as? String ?? "",
                                        trainingVideo: d["Video"] as? String ?? "",
                                        trainingDescription: d["description"] as? String ?? "",
                                        trainingDay: d["Train Day"] as? String ?? "",
                                        trainingStartTime: d["Start time"] as? String ?? "",
                                        trainingEndTime: d["End time"] as? String ?? "",
                        member: [])
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TchParticipantTableViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.trainingID = training[indexPath.row].trainingID
                destination.trainingMethod = training[indexPath.row].trainingMethod
                destination.trainingVideo = training[indexPath.row].trainingVideo
                destination.trainingDescription = training[indexPath.row].trainingDescription
                destination.trainingDay = training[indexPath.row].trainingDay
                destination.trainingStartTime = training[indexPath.row].trainingStartTime
                destination.trainingEndTime = training[indexPath.row].trainingEndTime
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
        return training.count
    }

    // set table view height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordcell", for: indexPath) as! RecordTableViewCell

        cell.TrainingMethod.text = training[indexPath.row].trainingMethod
        cell.TrainingDay.text = training[indexPath.row].trainingDay
        // Configure the cell...

        return cell
    }
}
