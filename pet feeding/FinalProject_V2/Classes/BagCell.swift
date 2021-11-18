//
//  BagCell.swift
//  FinalProject_V2
//
//  Created by Weijie Zheng
//  reference: Jawaad Sheikh
//  Description: a class that make design of cells for bag
//

import UIKit

class BagCell: UITableViewCell {

    let nameLabel = UILabel()
    let pointLabel = UILabel()
    let qtyLabel = UILabel()
    let typeLabel = UILabel()
    let myImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
      
        // cell for item's name
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textColor = UIColor.black
        
        // cell for item's point
        pointLabel.textAlignment = NSTextAlignment.left
        pointLabel.font = UIFont.boldSystemFont(ofSize: 20)
        pointLabel.backgroundColor = UIColor.clear
        pointLabel.textColor = UIColor.blue
        
        //cell for itme qty
        qtyLabel.textAlignment = NSTextAlignment.left
        qtyLabel.font = UIFont.boldSystemFont(ofSize: 20)
        qtyLabel.backgroundColor = UIColor.clear
        qtyLabel.textColor = UIColor.blue
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(myImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(pointLabel)
        contentView.addSubview(qtyLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // set up layout
    override func layoutSubviews() {
        
        var f = CGRect(x: 10, y: 5, width: 65, height: 65)
        myImageView.frame = f
        
        f = CGRect(x: 10, y: 75, width: 120, height: 30)
        typeLabel.frame = f
        
        f = CGRect(x: 150, y: 5, width: 200, height: 30)
        nameLabel.frame = f
        
        f = CGRect(x: 150, y: 40, width: 200, height: 30)
        pointLabel.frame = f
        
        f = CGRect(x: 150, y: 75, width: 200, height: 30)
        qtyLabel.frame = f

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
