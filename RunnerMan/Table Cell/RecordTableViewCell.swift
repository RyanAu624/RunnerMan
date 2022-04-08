//
//  RecordTableViewCell.swift
//  RunnerMan
//
//  Created by Hin on 21/3/2022.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var StdName: UILabel!
    @IBOutlet weak var TrainingMethod: UILabel!
    @IBOutlet weak var TrainingDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
