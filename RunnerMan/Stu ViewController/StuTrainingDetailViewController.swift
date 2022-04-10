//
//  StuTrainingDetailViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 10/4/2022.
//

import UIKit

class StuTrainingDetailViewController: UIViewController {
    
    var trainingID : String!
    var trainingMethod : String!
    var trainingVideo : String!
    var trainingDay : String!
    var trainingDescription : String!
    var trainingStartTime : String!
    var trainingEndTime : String!
    
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
    }
    
    
}
