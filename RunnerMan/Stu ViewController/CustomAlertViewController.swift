//
//  CustomAlertViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 14/4/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import MobileCoreServices

class CustomAlertViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    var training = [Training]()
    var list = [Training]()
    var videoData : Data = Data()
    let uID = Auth.auth().currentUser?.uid
    let toolbar = UIToolbar()
    
    private var inputTrainingID: String = ""
    private var titlename: String = ""
    
    @IBOutlet weak var popUPView: UIView!
    @IBOutlet weak var activityListBtn: UIButton!
    
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var uploadVideoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUPView.layer.cornerRadius = 20.0
        popUPView.layer.shadowColor = UIColor.black.cgColor
        popUPView.layer.shadowOpacity = 0.5
        popUPView.layer.shadowOffset = .zero
        popUPView.layer.shadowRadius = 5
        let btndone = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(done))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, btndone], animated: false)
        toolbar.sizeToFit()
        descriptionTF.inputAccessoryView = toolbar
        
        let optionsClosure = { (action: UIAction) in
            self.titlename = action.title
            self.findTrainID(title: action.title, findCompetion: { (result) in
                self.inputTrainingID = result
            })
        }
        
        getTrainingList(loadCompletion : {
            var actions = [UIAction]()
            for list in self.list {
                actions.append(UIAction(title: "\(list.trainingMethod)", handler: optionsClosure))
            }
            self.activityListBtn.menu = UIMenu(children: actions)
        })
        
        activityListBtn.showsMenuAsPrimaryAction = true
        activityListBtn.changesSelectionAsPrimaryAction = true
        
    }
    
    @objc func done(){
        view.endEditing(true)
    }
    
    func findTrainID(title: String, findCompetion : @escaping ((String) -> Void)) {
        
        var postID = ""
        
        let ref = db.collection("Training").whereField("Training Method", isEqualTo: title)

        ref.getDocuments {(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        postID = document.data()["Postid"] as! String
                        findCompetion("\(postID)")
                    }
                }
            }
        }
    }
    
    func getTrainingList(loadCompletion : @escaping ()->Void) {
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
                        let uid = Auth.auth().currentUser?.uid
                        let member2 = d["member"] as! [String]
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
                    loadCompletion()
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videourl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            do{
                videoData = try Data(contentsOf: videourl as URL)
            } catch {
                print(error.localizedDescription)
                return
            }
            
                
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectVideo(_ sender: Any) {
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeMovie as String]
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        let activity = self.inputTrainingID
        let des = descriptionTF.text
        let metadata = StorageMetadata()
        guard let postid = Auth.auth().currentUser?.uid else {return}
        let storage2 = Storage.storage().reference().child("\(titlename)")
        let ref = db.collection("Training").document(activity)
        let secRef = ref.collection("participant").document(uID!)

        storage2.child("\(postid).mov").putData(videoData, metadata: metadata) { (metaData, error) in
            guard error == nil else {
                print("ERROR HERE: \(error?.localizedDescription)")
                return
            }
            storage2.child("\(postid).mov").downloadURL{ url, error in
                if let error = error {
                    print("HERERER(ERROR)")
                    print(error.localizedDescription)
                } else {
                    guard let testurl = url?.absoluteString else {return}
                    secRef.updateData(["Videourl": testurl,
                                    "des": des as Any])
                    

                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

        

    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
