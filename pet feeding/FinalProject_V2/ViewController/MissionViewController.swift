//
//  MissionViewController.swift
//  FinalProject_V2
//
//  Created by Wenzhuo Zhao
//  This controller is used to load mission data from db and display them
//

import UIKit

class MissionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.missions.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style: .default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        
        //load the different quests into the table view
        if(rowNum == 0){
            tableCell.primaryLabel.text = mainDelegate.missions[rowNum].missionDescription
            tableCell.secondaryLabel.text = mainDelegate.missions[rowNum].missionGoal! + "/10"
            var image = mainDelegate.missions[rowNum].badgeImage!
            let imgName = UIImage(named: image)
            tableCell.myImageView.image = imgName
        }
        
        if(rowNum == 1){
            tableCell.primaryLabel.text = mainDelegate.missions[rowNum].missionDescription
            tableCell.secondaryLabel.text = mainDelegate.missions[rowNum].missionGoal! + "/15"
            var image = mainDelegate.missions[rowNum].badgeImage!
            let imgName = UIImage(named: image)
            tableCell.myImageView.image = imgName
        }
        
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //read data from db through appdelegate
        mainDelegate.readDataFromMission()
    }
}
