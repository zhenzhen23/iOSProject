//
//  AchievementCell.swift
//  Stream
//
//  Created by Phoenix Ge on 2019-11-09.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit

class AchievementCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
