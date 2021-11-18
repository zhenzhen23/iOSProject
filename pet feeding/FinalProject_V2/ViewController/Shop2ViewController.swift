//
//  Shop2ViewController.swift
//  FinalProject_V2
//
//  Created by Qian Wang
//  Tabel view controller to show music in shop
//

import UIKit

class Shop2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet var moneyLabel : UILabel!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.musics.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "cell") as? ShopCell ?? ShopCell(style: .default, reuseIdentifier: "cell")
        let rowNum = indexPath.row
        
        tableCell.nameLabel.text = mainDelegate.musics[rowNum].name
        tableCell.priceLabel.text = "Price: \(mainDelegate.musics[rowNum].price!)"
        
        //set the second bgm can be selected at level2
        if rowNum == 1 && mainDelegate.petInfo[0].level<2 {
            tableCell.experienceLabel.text = "Unblock at level2"
            tableCell.isUserInteractionEnabled = false;
        }
            
            //set the third bgm can be selected at level4
        else if rowNum == 2 && mainDelegate.petInfo[0].level<4 {
            tableCell.experienceLabel.text = "Unblock at level4"
            tableCell.isUserInteractionEnabled = false;
        }
        else{
            tableCell.experienceLabel.text = ""
            tableCell.isUserInteractionEnabled = true;
        }
        
        tableCell.energyLabel.text = ""
        let imgName = UIImage(named:"music.png")
        tableCell.myImageView.image = imgName
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    //buy a bgm by selecting a row. if the bgm is already bought, it cannot be bought.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNum = indexPath.row
        let existed:Bool = mainDelegate.checkFromBGM(name: mainDelegate.musics[rowNum].name!)
        if existed == true{
            let alertController = UIAlertController(title: "Error", message: "You already had this bgm", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        else if mainDelegate.money<mainDelegate.musics[rowNum].price!{
            let alertController = UIAlertController(title: "Error", message: "Cannot affort.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        else{
            let alertController = UIAlertController(title: "Purchase", message: "Buy the \(mainDelegate.musics[rowNum].name!) ?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let yesAction = UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                self.mainDelegate.insertDataToBGM(music: self.mainDelegate.musics[rowNum])
                self.mainDelegate.setMoney(price: self.mainDelegate.musics[rowNum].price!)
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
