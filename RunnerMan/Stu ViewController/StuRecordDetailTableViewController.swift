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
import AVFoundation

class StuRecordDetailTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var participant = [Participant]()
    var comment = [Comment]()
    let uID = Auth.auth().currentUser?.uid

    var looper : AVPlayerLooper?
    var trainingID : String!
    var trainingMethod : String!
    var trainingVideo : String!
    var trainingDescription : String!
    var trainingDay : String!
    var trainingStartTime : String!
    var trainingEndTime : String!
    let bar = UIToolbar()
    
    @IBOutlet weak var videolay: UIView!
    @IBOutlet weak var stuName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var commentTF: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStuData()
        getParticipantDetail()
        getCommentList()
        guard let des = trainingDescription else {return}
        descriptionLabel.text = des
        descriptionLabel.sizeToFit()
        playvideo()
        let btndone = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(done))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([space, btndone], animated: false)
        bar.sizeToFit()
        commentTF.inputAccessoryView = bar
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
    
    @objc func done(){
        view.endEditing(true)
    }
    
    func playvideo(){
        if let Videourl = URL(string: trainingVideo) {
            let player = AVQueuePlayer()
            looper = AVPlayerLooper(player: player, templateItem: AVPlayerItem(asset: AVAsset(url: Videourl)))
            let playerlayer = AVPlayerLayer(player: player)
            playerlayer.frame = videolay.frame
            self.videolay.layer.addSublayer(playerlayer)
            player.play()
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
        let ref2 = db.collection("student").whereField("uid", isEqualTo: uID!)
        let postid = secRef.document().documentID
        ref2.getDocuments {(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        let Name = document.data()["studentName"]
                        guard let Tname = Name else {return}
                        if self.commentTF.text != "" {
                            secRef.document(postid).setData(["reviewer": self.uID!,
                                                             "description": self.commentTF.text!,
                                                             "name": Tname])
                            
                            self.getCommentList()
                            self.commentTF.text = ""
                        }
                    }
                }
            }
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
                                       commentDescription: d["description"] as? String ?? "",
                                       name : d["name"] as? String ?? "")
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
        cell.stuName.font = UIFont.systemFont(ofSize: 22)
        cell.commentDescription.text = comment[indexPath.row].commentDescription
        cell.stuName.text = comment[indexPath.row].name
        
        return cell
    }

}
