//
//  ShopCell.swift
//  FinalProject_V2
//
//  Created by Qian Wang.
//  Custom table cell in shopview and shop2view.
//

import UIKit

class ShopCell: UITableViewCell  {
    //define  labels and an image view for  custom cell
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let energyLabel = UILabel()
    let experienceLabel = UILabel()
    let myImageView = UIImageView()
    
    //override the following constructor
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        // configure Labels
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textColor = UIColor.black
        
       
        priceLabel.textAlignment = NSTextAlignment.left
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        priceLabel.backgroundColor = UIColor.clear
        priceLabel.textColor = UIColor.blue
        
        energyLabel.textAlignment = NSTextAlignment.left
        energyLabel.font = UIFont.boldSystemFont(ofSize: 20)
        energyLabel.backgroundColor = UIColor.clear
        energyLabel.textColor = UIColor.blue
        
        experienceLabel.textAlignment = NSTextAlignment.left
        experienceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        experienceLabel.backgroundColor = UIColor.clear
        experienceLabel.textColor = UIColor.blue
        
      
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(energyLabel)
        contentView.addSubview(experienceLabel)
        contentView.addSubview(myImageView)
        
        
    }
    
    // override base constructor to avoid compile error
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    // define size and location of all  items as below
    // return to ShopViewController.swift and Shop2ViewController.swift
    override func layoutSubviews() {
        
        var f = CGRect(x: 10, y: 5, width: 65, height: 65)
        myImageView.frame = f
        
        f = CGRect(x: 10, y: 75, width: 120, height: 30)
        nameLabel.frame = f
        
        f = CGRect(x: 150, y: 5, width: 200, height: 30)
        priceLabel.frame = f
        
        f = CGRect(x: 150, y: 40, width: 200, height: 30)
        energyLabel.frame = f
        
        f = CGRect(x: 150, y: 75, width: 200, height: 30)
        experienceLabel.frame = f
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }

}
