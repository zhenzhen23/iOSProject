//
//  RecordCell.swift
//  Stream
//
//  Created by Xcode User on 2019-11-19.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
