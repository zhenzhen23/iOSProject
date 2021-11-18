//
//  AnalysisCell.swift
//  Stream
//
//  Created by Phoenix Ge on 2019-11-09.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit

class AnalysisCell: UITableViewCell {

    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
