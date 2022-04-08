//
//  ManageStuCell.swift
//  RunnerMan
//
//  Created by Long Hei Au on 26/1/2022.
//

import UIKit

class ManageStuCell : UITableViewCell {
    
    @IBOutlet weak var name:  UILabel!
    @IBOutlet weak var stuId: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

