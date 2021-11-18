//  Name: Qing Ge
//  email: geq@sheridancollege.ca
//  short description: The view controller displays the user's achievement
//  AchievementViewController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-06.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
import CoreData
import os.log

class AchievementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // properties
    let managedObjectContext: NSManagedObjectContext
    var achievements: [NSManagedObject] = []
    
    var achName = ["Good Start", "Piggy Bank", "Big Spender", "Water Tap", "Gold Miner"]
    var achIcon = ["GoodStart", "PiggyBank", "BigSpender", "WaterTap", "GoldMiner"]
    var achIsAchieved = [false, false, false, false, false]
    var achDesc = ["Entered the first line of income/expense."
        , "You have earned up to 1000 dollars."
        , "You spent more than 10,000 dollars at once."
        , "You have spent up to 2000 dollars."
        , "You found money on the street and put in your own pocket"]
    var achValue = [0, 1000, 10000, 2000, 0]
    
    @IBOutlet weak var tableview: UITableView!
    
    // get managed object context from app delegate
    required init?(coder  aCoder: NSCoder)
    {
        // initialize managed object context in this class
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        // call superclass init() right after init all properties of this class
        super.init(coder:aCoder)

        // reload table records
        //reloadAchievementTable()
        
        // load data
        self.fetchData()

        // if groups is empty, add 10 default groups
        if self.achievements.isEmpty
        {
            self.initDefaultAchievements()
            
            // reload data after init
            self.fetchData()
        }
    }
    
    func initDefaultAchievements()
    {
        for i in 0...4
        {
            // create entity object
            if let entity = NSEntityDescription.entity(forEntityName: "Achievement", in: self.managedObjectContext)
            {
                // create managed object
                let achievement = NSManagedObject(entity: entity, insertInto: managedObjectContext)

                // set field values
                achievement.setValue(achDesc[i], forKey: "desc")
                achievement.setValue(achIcon[i], forKey: "icon")
                achievement.setValue(achIsAchieved[i], forKey: "isAchieved")
                achievement.setValue(achName[i], forKey: "name")
                achievement.setValue(achValue[i], forKey: "value")
            }
        }
        // save core data
        self.saveData()
    }
    
    // load achievements from coreData
    func fetchData()
    {
        // create fetch request objects to query managed objects
        let achievementRequest = NSFetchRequest<NSManagedObject>(entityName: "Achievement")
        let achievementDescriptor = NSSortDescriptor(key: "value", ascending: true)
        achievementRequest.sortDescriptors = [achievementDescriptor]

        // fetch data within do-catch block
        do
        {
            self.achievements = try managedObjectContext.fetch(achievementRequest)
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }
    }
    
    // commit CoreData
    func saveData()
    {
        do
        {
            try self.managedObjectContext.save()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 93
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "AchievementCell", for: indexPath) as? AchievementCell ?? AchievementCell(style: .default, reuseIdentifier: "AchievementCell")
        let index = indexPath.row
        let achievement = self.achievements[index]

        // load data from array
        let desc = achievement.value(forKey: "desc") as? String ?? ""
        tableCell.labelDesc.text = desc
        let name = achievement.value(forKey: "name") as? String ?? ""
        tableCell.labelName.text = name
        let isAchieved = achievement.value(forKey: "isAchieved") as? Bool ?? false
        let icon = achievement.value(forKey: "icon") as? String ?? ""
        if isAchieved == false
        {
            tableCell.imageView?.image = UIImage(named: icon)
        }
        else
        {
            tableCell.imageView?.image = UIImage(named: "\(icon)_c")
        }
        return tableCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("achievement page loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTable()
    }
    
    func updateTable()
    {
        self.fetchData()
        tableview.reloadData()
    }
    
    func reloadAchievementTable()
    {
        // delete all data from achievement table for testing
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Achievement")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
    }
}
