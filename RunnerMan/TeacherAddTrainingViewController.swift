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
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        datePicker.frame = CGRect(x: 0, y: screenHeight - 216 - 44, width: screenWidth, height: 216)
        createData()

        // Do any additional setup after loading the view.
    }
    
    func createData() {
        let bar = UIToolbar()
        bar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donepress))
        bar.setItems([done], animated: true)
        TrainDay.inputAccessoryView = bar
        TrainDay.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func donepress(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        TrainDay.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        print(TrainDay.text)
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
