//
//  TeacherAddTrainingViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 11/1/2022.
//

import UIKit

class TeacherAddTrainingViewController: UIViewController {
    

    @IBOutlet weak var TrainDay: UITextField!
    @IBOutlet weak var StartTime: UITextField!
    @IBOutlet weak var EndTime: UITextField!
    let bar = UIToolbar()
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()

    
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
