//
//  FoodsTableViewController.swift
//  FinalProject_V2
//
//  Created by Weijie Zheng
//  Description: A table view Controller to show the user that kind of food user has in the bag
//

import UIKit

class FoodsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.bagInfo.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //set height of cell to 120
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BagCell ?? BagCell(style: .default, reuseIdentifier: "cell")
        let rowNum = indexPath.row
        
        // only display type 1, which is foods
        if (mainDelegate.bagInfo[rowNum].type == 1){
            
            tableCell.nameLabel.text = mainDelegate.bagInfo[rowNum].name
            tableCell.pointLabel.text = "\(mainDelegate.bagInfo[rowNum].point!) Energy"
            tableCell.qtyLabel.text = "Qty: \(mainDelegate.bagInfo[rowNum].qty!)"
            
            let imgName = UIImage(named : "\(mainDelegate.bagInfo[rowNum].name!).png")
            
            
            tableCell.myImageView.image = imgName
        }
        tableCell.accessoryType = .disclosureIndicator
        
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
            
            // tell user that pet is full
            if(mainDelegate.petInfo[0].foodBar + mainDelegate.bagInfo[rowNum].point! >= 100){
                let alertController = UIAlertController(title: "Warning", message: "Your pet can not complete the \(mainDelegate.bagInfo[rowNum].name)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .default, handler:nil)
                alertController.addAction((cancelAction))
                present(alertController,animated: true)
            }else{
                // pop out a alert box to let user double check his action
                let alertController = UIAlertController(title: "Confirm", message: "Are you sure eat a \(mainDelegate.bagInfo[rowNum].name!) ?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                let yesAction = UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                    
                    //item in bag table -1
                    self.mainDelegate.updateDataToBag(itemId: self.mainDelegate.bagInfo[rowNum].id!, qty: -1)
                    
                    // back to main page
                    self.mainDelegate.foodPoint = self.mainDelegate.bagInfo[rowNum].point!
                    self.performSegue(withIdentifier: "BackToPlay", sender: nil)
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
        mainDelegate.readDataFromPetInfo()
    }
}
