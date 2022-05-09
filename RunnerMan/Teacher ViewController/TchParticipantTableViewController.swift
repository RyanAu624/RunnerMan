//
//  TchParticipantTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 9/4/2022.
//

import UIKit
import FirebaseFirestore

class TchParticipantTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var participant = [Participant]()
    
    var trainingID : String!
    var trainingMethod : String!
    var trainingVideo : String!
    var trainingDay : String!
    var trainingDescription : String!
    var trainingStartTime : String!
    var trainingEndTime : String!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPartList()
    }
    
    func getPartList() {
        let ref = db.collection("Training").document(trainingID)
        
        ref.collection("participant").getDocuments() {(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                    self.participant = snapshot.documents.map { d in
                        return Participant(participantId: d.documentID,
                                           participantDescription: d["des"] as? String ?? "",
                                           participantVideo: d["Videourl"] as? String ?? "")
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TchTrainingDetailViewController {
            destination.trainingID = self.trainingID
            destination.trainingMethod = self.trainingMethod
            destination.trainingVideo = self.trainingVideo
            destination.trainingDescription = self.trainingDescription
            destination.trainingDay = self.trainingDay
            destination.trainingStartTime = self.trainingStartTime
            destination.trainingEndTime = self.trainingEndTime
            
        }
        
        if let destination = segue.destination as? RecordDetailTableViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                destination.trainingID = self.trainingID
                destination.trainingMethod = self.trainingMethod
                destination.trainingVideo = participant[indexPath.row].participantVideo
                destination.trainingDescription = participant[indexPath.row].participantDescription
                destination.trainingDay = self.trainingDay
                destination.trainingStartTime = self.trainingStartTime
                destination.trainingEndTime = self.trainingEndTime
            }
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.participantId = participant[indexPath.row].participantId
                destination.participantDescription = participant[indexPath.row].participantDescription
                destination.participantVideo = participant[indexPath.row].participantVideo
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
        return participant.count
    }

    // set table view height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partCell", for: indexPath) as! ParticipantTableViewCell

        
        let ref = db.collection("student").whereField("uid", isEqualTo: participant[indexPath.row].participantId)
        
        ref.getDocuments {(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let studentName = document.data()["studentName"]
                        
                        cell.ParticipantName.text = (studentName as! String)
                    }
                }
            }
        }
        // Configure the cell...

        return cell
    }

}
