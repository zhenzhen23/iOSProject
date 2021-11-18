//
//  PlatformCell.swift
//  Assignment3_WeijieZheng
//
//  Created by Xcode User on 2019-11-26.
//  Copyright © 2019 zhenzhen. All rights reserved.
//

import UIKit

class PlatformCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
