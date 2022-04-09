//
//  ParticipantTableViewCell.swift
//  RunnerMan
//
//  Created by Long Hei Au on 9/4/2022.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ParticipantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
