//
//  StuTrainingDetailViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 10/4/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class StuTrainingDetailViewController: UIViewController {
    
    var trainingID : String!
    var trainingMethod : String!
    var trainingVideo : String!
    var trainingDay : String!
    var trainingDescription : String!
    var trainingStartTime : String!
    var trainingEndTime : String!
    @IBOutlet weak var btnjoin: UIBarButtonItem!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    
    @IBOutlet weak var trainingMethodLabel: UILabel!
    @IBOutlet weak var trainingDescriptionLabel: UILabel!
    @IBOutlet weak var trainingDayLabel: UILabel!
    @IBOutlet weak var trainingStartTimeLabel: UILabel!
    @IBOutlet weak var trainingEndTimeLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trainingMethodLabel.text = trainingMethod
        trainingDescriptionLabel.text = trainingDescription
        trainingDayLabel.text = trainingDay
        trainingStartTimeLabel.text = trainingStartTime
        trainingEndTimeLabel.text = trainingEndTime
        let ref = db.collection("Training").document(trainingID).collection("participant")
        let doc = ref.document(uid!)
        
        doc.getDocument{ (result, error) in
            if let result = result {
                if result.exists {
                    self.btnjoin.title = "cancel"
                }else {
                    self.btnjoin.title = "join"
                }
            }
        }
        
    }
    
    @IBAction func joinbtn(_ sender: Any) {
        let ref = db.collection("Training").document(trainingID).collection("participant")

        if self.btnjoin.title == "join" {
            let data : [String: Any] = [ "Videourl" : "",
                                         "des" : ""]
            ref.document(uid!).setData(data)
            self.btnjoin.title = "cancel"
        } else if self.btnjoin.title == "cancel"{
            ref.document(uid!).delete()
            self.btnjoin.title = "join"
        }

        }

    
}
