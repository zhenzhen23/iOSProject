//
//  ShopViewController.swift
//  FinalProject_V2
//
//  Created by Qian Wang.
//  Tabel view controller to show food in shop
//

import UIKit

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var moneyLabel : UILabel!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.shopItems.count
    }
    
    // height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //each cell display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "cell") as? ShopCell ?? ShopCell(style: .default, reuseIdentifier: "cell")
        let rowNum = indexPath.row
        
        tableCell.nameLabel.text = mainDelegate.shopItems[rowNum].name
        tableCell.priceLabel.text = "Price: \(mainDelegate.shopItems[rowNum].price!)"
        tableCell.experienceLabel.text = "Experience: \(mainDelegate.shopItems[rowNum].experience!)"
        tableCell.energyLabel.text = "Energy: \(mainDelegate.shopItems[rowNum].energy!)"
        let imgName = UIImage(named:mainDelegate.shopItems[rowNum].path!)
        tableCell.myImageView.image = imgName
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    //user can buy a kind of food by selecting a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNum = indexPath.row
        if mainDelegate.money<mainDelegate.shopItems[rowNum].price!{
            let alertController = UIAlertController(title: "Error", message: "Cannot affort.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        else{
            let alertController = UIAlertController(title: "Purchase", message: "Buy a \(mainDelegate.shopItems[rowNum].name!) ?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let yesAction = UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                
                self.mainDelegate.setMoney(price: self.mainDelegate.shopItems[rowNum].price!)
                self.mainDelegate.updateDataToBag(itemId: (rowNum+1),qty:1)
                self.moneyLabel.text="Money: \(self.mainDelegate.money)"
                
                
            })
            
            alertController.addAction(yesAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyLabel.text="Money: \(mainDelegate.money)"
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
