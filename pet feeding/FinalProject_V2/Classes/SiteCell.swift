//
//  SiteCell.swift
//  FinalProject_V2
//
//  Created by Wenzhuo Zhao
//  Custom table cell in Mission table
//reference: Jawaad Sheikh on 2018-03-14.

import UIKit

class SiteCell: UITableViewCell {
    
    let primaryLabel = UILabel()
    let secondaryLabel = UILabel()
    let myImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        //configure primaryLabel
        primaryLabel.textAlignment = NSTextAlignment.left
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 20)
        primaryLabel.backgroundColor = UIColor.clear
        primaryLabel.textColor = UIColor.black
        
        //configure secondaryLabel
        secondaryLabel.textAlignment = NSTextAlignment.left
        secondaryLabel.font = UIFont.boldSystemFont(ofSize: 20)
        secondaryLabel.backgroundColor = UIColor.clear
        secondaryLabel.textColor = UIColor.blue
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(myImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        
        var f = CGRect(x: 5, y: 5, width: 460, height: 30)
        primaryLabel.frame = f
        
        f = CGRect(x: 220, y: 5, width: 460, height: 30)
        secondaryLabel.frame = f
        
        f = CGRect(x: 300, y: 5, width: 45, height: 45)
        myImageView.frame = f
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
