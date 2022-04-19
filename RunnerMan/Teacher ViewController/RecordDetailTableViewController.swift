//
//  RecordDetailTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 18/4/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class RecordDetailTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var participant = [Participant]()
    var comment = [Comment]()
    let uID = Auth.auth().currentUser?.uid

    var trainingID : String!
    var trainingMethod : String!
    var trainingVideo : String!
    var trainingDescription : String!
    var trainingDay : String!
    var trainingStartTime : String!
    var trainingEndTime : String!
    
    var participantId : String!
    var participantDescription : String!
    var participantVideo : String!

    @IBOutlet weak var stuName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var commentTF: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStuData()
        descriptionLabel.text = participantDescription
        
        getCommentList()
        self.tableView.reloadData()
    }
    
    func getStuData() {
        let ref = db.collection("student").whereField("uid", isEqualTo: participantId!)
        
        ref.getDocuments {(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let studentName = document.data()["studentName"]
                        
                        self.stuName.text = (studentName as! String)
                    }
                }
            }
        }
    }
    
    @IBAction func uploadCommentBtn(_ sender: Any) {
        let ref = db.collection("Training").document(trainingID).collection("participant")
        let secRef = ref.document(participantId).collection("commentList")
        
        let postid = secRef.document().documentID
        
        if commentTF.text != "" {
            secRef.document(postid).setData(["reviewer": uID!,
                                             "description": commentTF.text!])
            
            getCommentList()
            commentTF.text = ""
        }
    }
    
    func getCommentList() {
        let ref = db.collection("Training").document(trainingID).collection("participant")
        let secRef = ref.document(participantId).collection("commentList")
        
        secRef.getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.comment = snapshot.documents.map { d in
                        return Comment(reviewer: d["reviewer"] as? String ?? "",
                                       commentDescription: d["description"] as? String ?? "")
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
        return comment.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cCell", for: indexPath) as! CommentTableViewCell
        cell.commentDescription.text = comment[indexPath.row].commentDescription
        cell.stuName.text = comment[indexPath.row].reviewer
        
        return cell
    }


}
