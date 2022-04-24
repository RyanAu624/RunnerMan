//
//  TchTrainingDetailViewController.swift
//  RunnerMan
//
//  Created by Long Hei Au on 9/4/2022.
//

import UIKit
import AVFoundation

class TchTrainingDetailViewController: UIViewController {
    
    @IBOutlet weak var videolayer: UIView!
    var trainingID : String!
    var trainingMethod : String!
    var trainingVideo : String!
    var trainingDescription : String!
    var trainingDay : String!
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

        playVideo()
    }

    func playVideo(){
        if let Videourl = URL(string: trainingVideo) {
            print(Videourl)
            let player = AVPlayer(url: Videourl)
            let playerlayer = AVPlayerLayer(player: player)
            playerlayer.frame = videolayer.frame
            self.videolayer.layer.addSublayer(playerlayer)
            player.play()
        }
    }
    

}