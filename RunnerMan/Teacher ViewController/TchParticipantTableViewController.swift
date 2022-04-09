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
    var training_Day : String!

    override func viewWillAppear(_ animated: Bool) {
        getFirebaseData()
        self.tableView.reloadData()
    }
    
    func getFirebaseData() {
        let ref = db.collection("Training").document(trainingID)
        
        ref.collection("participant").getDocuments() {(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                    self.participant = snapshot.documents.map { d in
                        return Participant(participantId: d.documentID,
                                           participantUid: d["uid"] as? String ?? "",
                                           participantName: d["stuName"] as? String ?? "",
                                           participantDescription: d["description"] as? String ?? "",
                                           participantVideo: d["videoUrl"] as? String ?? "")
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
        return participant.count
    }

    // set table view height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partCell", for: indexPath) as! ParticipantTableViewCell
        
        cell.ParticipantName.text = participant[indexPath.row].participantName
        // Configure the cell...

        return cell
    }

}
