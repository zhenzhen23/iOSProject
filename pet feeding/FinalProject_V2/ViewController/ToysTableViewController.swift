//
//  ToysTableViewController.swift
//  FinalProject_V2
//
//  Created by Weijie Zheng
//  Description: A table view Controller to show the user that kind of toy user has in the bag
//

import UIKit

class ToysTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.bagInfo.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BagCell ?? BagCell(style: .default, reuseIdentifier: "cell")
        let rowNum = indexPath.row
        
        //only show the typy 2 itme in the bag, which is toys.
        if (mainDelegate.bagInfo[rowNum].type == 2){
            
            tableCell.nameLabel.text = mainDelegate.bagInfo[rowNum].name
            tableCell.pointLabel.text = "\(mainDelegate.bagInfo[rowNum].point!) Experience"
            tableCell.qtyLabel.text = "Qty: \(mainDelegate.bagInfo[rowNum].qty!)"
            
            let imgName = UIImage(named : "\(mainDelegate.bagInfo[rowNum].name!).png")
            
            
            tableCell.myImageView.image = imgName
        }
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNum = indexPath.row
        
        if(mainDelegate.bagInfo[rowNum].qty! < 1){
            
            //pop out a alert box to tell user that you dont have enough items.
            let alertController = UIAlertController(title: "Warning", message: "You don't have enough \(mainDelegate.bagInfo[rowNum].name!)", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            
        }else{
            //pop out a alert box to tell user that your pet is hungry.
            if(mainDelegate.petInfo[0].foodBar == 0){
                let alertController = UIAlertController(title: "Warning", message: "Please feed you pet", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .default, handler:nil)
                alertController.addAction((cancelAction))
                present(alertController,animated: true)
            }
            else
            {
                
                // pop out a alert box to let user double check his action
                let alertController = UIAlertController(title: "Confirm", message: "Are you sure eat a \(mainDelegate.bagInfo[rowNum].name!) ?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                let yesAction = UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                    
                    // when level bar is full level up
                    if((self.mainDelegate.petInfo[0].levelBar + self.mainDelegate.bagInfo[rowNum].point!) >= 100 ){
                        
                        self.mainDelegate.updateDataToPetInfo(type: "LevelBar", num: 0)
                        self.mainDelegate.updateDataToPetInfo(type: "Level", num: self.mainDelegate.petInfo[0].level + 1)
                        
                        
                        self.mainDelegate.updateDataToBag(itemId: self.mainDelegate.bagInfo[rowNum].id!, qty: -1)
                        self.mainDelegate.levelPoint = 10
                        self.performSegue(withIdentifier: "LevelToPlayPage", sender: nil)
                        
                    }else{
                        
                        self.mainDelegate.updateDataToBag(itemId: self.mainDelegate.bagInfo[rowNum].id!, qty: -1)
                        self.mainDelegate.levelPoint = 10
                        self.performSegue(withIdentifier: "LevelToPlayPage", sender: nil)
                    }
                })
                
                alertController.addAction(yesAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate.readDataFromBag()
    }
}
