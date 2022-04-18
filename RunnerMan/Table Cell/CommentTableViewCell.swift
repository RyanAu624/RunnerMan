//
//  CommentTableViewCell.swift
//  RunnerMan
//
//  Created by Long Hei Au on 18/4/2022.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var stuName: UILabel!
    @IBOutlet weak var commentDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
