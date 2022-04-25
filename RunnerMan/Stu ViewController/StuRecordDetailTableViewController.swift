//
//  StuRecordDetailTableViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 24/4/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class StuRecordDetailTableViewController: UITableViewController {
    
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
    
    @IBOutlet weak var stuName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var commentTF: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStuData()
        getParticipantDetail()
        
        getCommentList()
    }
    
    func getParticipantDetail() {
        let ref = db.collection("Training").document(trainingID).collection("participant")
        

        ref.document(uID!).getDocument {(document, err) in
            if let document = document, document.exists {
                let des = document.data()!["des"]
            
                self.descriptionLabel.text = (des as! String)
            }
        }
    }
    
    //Get inviteCode from firebase
//        let ref = db.collection("inviteCode").document("code")
//
//        ref.getDocument{(document, err) in
//            if let document = document, document.exists {
//                let code = document.data()!["code"]
//                print(code!)
//            }
//        }
    
    func getStuData() {
        let ref = db.collection("student").whereField("uid", isEqualTo: uID!)
        
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
        let secRef = ref.document(uID!).collection("commentList")

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
        let secRef = ref.document(uID!).collection("commentList")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "comCell", for: indexPath) as! CommentTableViewCell
        cell.commentDescription.text = comment[indexPath.row].commentDescription
        cell.stuName.text = comment[indexPath.row].reviewer
        
        return cell
    }

}