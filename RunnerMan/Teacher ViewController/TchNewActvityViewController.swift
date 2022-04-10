//
//  TchNewActvityViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/1/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import AVFoundation
import FirebaseStorage
import MobileCoreServices

class TchNewActvityViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var MethodText: UITextField!
    @IBOutlet weak var DescriText: UITextField!
    @IBOutlet weak var TrainDay: UITextField!
    @IBOutlet weak var StartTime: UITextField!
    @IBOutlet weak var EndTime: UITextField!
    let bar = UIToolbar()
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    let id = Auth.auth().currentUser?.uid
    var videoData : Data = Data()
    var fileurl : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        datePicker.frame = CGRect(x: 0, y: screenHeight - 216 - 44, width: screenWidth, height: 216)
        TrainDay.inputView = datePicker
        StartTime.inputView = datePicker
        EndTime.inputView = datePicker
        bar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datedone))
        bar.setItems([done], animated: true)
        TrainDay.inputAccessoryView = bar
        StartTime.inputAccessoryView = bar
        EndTime.inputAccessoryView = bar

        // Do any additional setup after loading the view.
    }
    
    func createData(_ textField: UITextField) {
        if textField == TrainDay {
            datePicker.datePickerMode = .date
        }
        if textField == StartTime {
            datePicker.datePickerMode = .time
        }
        if textField == EndTime{
            datePicker.datePickerMode = .time
        }
    }
    
    @objc func datedone(){
        if TrainDay.isFirstResponder {
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            TrainDay.text = formatter.string(from: datePicker.date)
        }
        if StartTime.isFirstResponder {
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
            StartTime.text = formatter.string(from: datePicker.date)
        }
        if EndTime.isFirstResponder {
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
            EndTime.text = formatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
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
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadbtn(_ sender: Any) {
        
        let metadata = StorageMetadata()
        let postid = db.collection("Training").document().documentID
        let storage2 = Storage.storage().reference().child("video")
        
        storage2.child(postid).putData(videoData, metadata: metadata) { (metaData, error) in
            guard error == nil else {
                print("ERROR HERE: \(error?.localizedDescription)")
                return
            }
            storage2.child(postid).downloadURL{ url, error in
                if let error = error {
                    print("HERERER(ERROR)")
                    print(error.localizedDescription)
                } else {
                    self.fileurl = url?.absoluteString
                    let data : [String: Any] = ["Postid" : postid,
                                "Training Method": self.MethodText.text!,
                                "Train Day": self.TrainDay.text!,
                                "Start time": self.StartTime.text!,
                                "End time": self.EndTime.text!,
                                "Video" : self.fileurl,
                                "description": self.DescriText.text!]
                    
                    
                    self.db.collection("Training").document(postid).setData(data)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
