//  Name: Wenzhuo Zhao
//  email: zhaowenz@sheridancollege.ca
//  Created Data: 11-07, 2019
//  Last Updated Date: Dec.11, 2019
//  short description: The custom table cell for table.
//  CategoryTableViewCell.swift
//  Stream
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
