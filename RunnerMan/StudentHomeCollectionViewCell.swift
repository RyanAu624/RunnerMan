//
//  StudentHomeCollectionViewCell.swift
//  RunnerMan
//
//  Created by Long Hei Au on 18/3/2022.
//

import UIKit

class StudentHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var heroBanner: HeroBanner! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let heroBanner = heroBanner {
            featuredImageView.image = heroBanner.featuredImage
            tempLabel.text = heroBanner.temperature
        } else {
            featuredImageView.image = nil
            tempLabel.text = nil
        }
    }
}
