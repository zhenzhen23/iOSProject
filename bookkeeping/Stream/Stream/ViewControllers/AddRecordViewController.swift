//  Name: Wenzhuo Zhao
//  email: zhaowenz@sheridancollege.ca
//  Created Data: 11-06, 2019
//  Last Updated Date: Dec.11, 2019
//  short description: The view controller allow user to enter a new record regarding to their transcations, and then store in the core data.
//  AddRecordViewController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-06.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
import CoreData     // for CoreData framework
import os.log

class AddRecordViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var amountTextfiels: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var recordTypeSegment: UISegmentedControl!
    
    // properties
    let managedObjectContext: NSManagedObjectContext
    var moCategories: [NSManagedObject] = []  // whole managed objects
    
    // Phoenix added: a record array to contain all the records
    var records: [NSManagedObject] = []
    var achievements: [NSManagedObject] = []
       
    var moRecords: [NSManagedObject] = []
    
    var incomeCategory : [NSManagedObject] = []
    var expenseCategory : [NSManagedObject] = []
    var showCategory : [NSManagedObject] = []
    var groupIndex: Int = 0             // selected group
    var selectedCategory : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set pickerview delegate
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        if self.recordTypeSegment.selectedSegmentIndex == 0
        {
            self.showCategory = self.incomeCategory
        }
        else{
            self.showCategory = self.expenseCategory
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchData()
        if self.recordTypeSegment.selectedSegmentIndex == 0
        {
            self.showCategory = self.incomeCategory
        }
        else{
            self.showCategory = self.expenseCategory
        }
        self.categoryPicker.reloadAllComponents()
    }
    
    required init?(coder  aCoder: NSCoder)
    {
        // initialize managed object context in this class
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        // call superclass init() right after init all properties of this class
        super.init(coder:aCoder)

        // load data
        self.fetchData()
        // if groups is empty, add 10 default groups
        if self.moCategories.isEmpty
        {
            self.initDefaultGroups()
            self.fetchData()    // reload data
        }
        //determineCategoryType()
    }
    
    func fetchData()
    {
        // create fetch request objects to query managed objects
        let categoryRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")

        // fetch data within do-catch block
        do
        {
            self.moCategories = try managedObjectContext.fetch(categoryRequest)
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }

        self.incomeCategory.removeAll() // clear
        self.expenseCategory.removeAll()
        for moCate in moCategories
        {
            let cateType = moCate.value(forKey: "isIncome") as? Bool ?? true
            if cateType == true{
                self.incomeCategory.append(moCate)
            }else{
                self.expenseCategory.append(moCate)
            }
        }
    }
    
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
    
    // add some default categories into CoreData
    func initDefaultGroups()
    {
            // create entity object
            if let entity = NSEntityDescription.entity(forEntityName: "Category", in: self.managedObjectContext)
            {
                // create managed object
                let moCategory = NSManagedObject(entity: entity, insertInto: managedObjectContext)

                // set field values
                let cateName = "food"
                let isIncome = false
                moCategory.setValue(cateName, forKey: "name")
                moCategory.setValue(isIncome, forKey: "isIncome")

                let moencomaCategory = NSManagedObject(entity: entity, insertInto: managedObjectContext)

                // set field values
                let categoryName = "cheque"
                let income = true
                moencomaCategory.setValue(categoryName, forKey: "name")
                moencomaCategory.setValue(income, forKey: "isIncome")
            }
        // save core data
        self.saveData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.showCategory.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let moCategory = self.showCategory[row]
        let categoryName = moCategory.value(forKey: "name") as? String ?? ""
        return categoryName
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.groupIndex = row
    }
    
    @IBAction func changeCategoryType(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0:
            self.showCategory = self.incomeCategory
        case 1:
            self.showCategory = self.expenseCategory
        default:
            break;
        }
        //self.categoryTableView.reloadData() // redraw tableview
        self.categoryPicker.reloadAllComponents()
    }
    
    // add a student into coredate
     @IBAction func handleSave(_ sender: Any)
       {
        if self.amountTextfiels?.text != "" && self.commentTextfield.text != ""
        {
            if self.showCategory.count == 0{
                let categoryWarningAlert = UIAlertController(title: "Message", message: "Add some categories", preferredStyle: .alert)
                categoryWarningAlert.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: nil))
                self.present(categoryWarningAlert, animated: true)
            }else{
                // create entity object
                if let entity = NSEntityDescription.entity(forEntityName: "Record", in: managedObjectContext)
                {
                    // create managed object
                    let moRecord = NSManagedObject(entity: entity, insertInto: managedObjectContext)

                    let amount = Double(self.amountTextfiels?.text ?? "0.0") ?? 0
                    let comment = self.commentTextfield?.text ?? ""
                    
                    let categoryName =  self.showCategory[groupIndex].value(forKey: "name") as? String ?? ""
                    let date = self.datePicker.date
                    let categoryType = self.showCategory[groupIndex].value(forKey: "isIncome") as? Bool ?? true
                    // set its value
                    let category = self.showCategory[groupIndex]
                    moRecord.setValue(amount, forKey: "amount")
                    moRecord.setValue(comment, forKey: "desc")
                    moRecord.setValue(categoryName, forKey: "category")
                    moRecord.setValue(date, forKey: "date")
                    moRecord.setValue(categoryType, forKey: "isIncome")
                    moRecord.setValue(category, forKey: "inCategory")
                    // add it to array
                    
                    self.moRecords.append(moRecord)
                    
                    // save core data
                    self.saveData()
                    
                    let saveSuccessfullyAlert = UIAlertController(title: "Message", message: "Save Successfully", preferredStyle: .alert)
                    saveSuccessfullyAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{_ in
                        self.commentTextfield.text = ""
                        self.amountTextfiels.text = ""
                        
                        // Phoenix added: check if record table only contains one record, if so, lighten the achievement icon
                        self.checkAchievements(categoryType, amount, categoryName)
                    }))
                    self.present(saveSuccessfullyAlert, animated: true)
                }
            }

        }
        else
        {
            let warningAlert = UIAlertController(title: "Message", message: "Please enter all required fields", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(warningAlert, animated: true)
        }
    }
    
    // Phoenix added
    func checkAchievements(_ isIncome: Bool, _ amount: Double, _ category: String)
    {
        // fetch data from record table
        let recordRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        
        // fetch data from achievement table
        let achievementRequest = NSFetchRequest<NSManagedObject>(entityName: "Achievement")
        do
        {
            self.records = try managedObjectContext.fetch(recordRequest)
            self.achievements = try managedObjectContext.fetch(achievementRequest)
            
            // check good start
            checkGoodStart()
            
            // check piggy bank and Water Tap
            checkPiggyBankAndWaterTap()
            
            // check Spendthrift
            checkSpendthrift(isIncome, amount)
            
            // check Gold Miner
            checkGoldMiner(category)
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }
    }
    
    // Phoenix added
    func findAchievement(_ name:String) -> NSManagedObject?
    {
        return self.achievements.first(where:
        {
            $0.value(forKey: "name") as? String == name
        })
    }
    
    // Phoenix added
    func checkGoodStart()
    {
        if records.count == 1
        {
            // find achievement
            if let achievement = findAchievement("Good Start")
            {
                achievement.setValue(true, forKey: "isAchieved")
                self.saveData()
                
                // alert achievement
                let alert = UIAlertController(title: "Good Start!", message: "You unlocked a new achievement!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion:nil)
            }
            
        }
    }
    
    // Phoenix added
    func checkPiggyBankAndWaterTap()
    {
        var totalIncome: Double = 0
        var totalExpense: Double = 0
        for eachRecord in records
        {
            let isIncome = eachRecord.value(forKey: "isIncome") as? Bool ?? false
            let amount = eachRecord.value(forKey: "amount") as? Double ?? 0
            if isIncome == true
            {
                totalIncome += amount
            }
            else
            {
                totalExpense += amount
            }
        }
        
        if totalIncome >= 1000
        {
            // find achievement
            if let achievement = findAchievement("Piggy Bank")
            {
                let isAchieved = achievement.value(forKey: "isAchieved") as? Bool ?? false
                if isAchieved == false
                {
                    achievement.setValue(true, forKey: "isAchieved")
                    self.saveData()
                    
                    // alert achievement
                    let alert = UIAlertController(title: "Piggy Bank!", message: "You unlocked a new achievement!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion:nil)
                }
            }
        }
        if totalExpense >= 2000
        {
            // find achievement
            if let achievement = findAchievement("Water Tap")
            {
                let isAchieved = achievement.value(forKey: "isAchieved") as? Bool ?? false
                if isAchieved == false
                {
                    achievement.setValue(true, forKey: "isAchieved")
                    self.saveData()
                    
                    // alert achievement
                    let alert = UIAlertController(title: "Water Tap!", message: "You unlocked a new achievement!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion:nil)
                }
            }
        }
    }
    
    // Phoenix added
    func checkSpendthrift(_ isIncome: Bool, _ amount: Double)
    {
        if isIncome == false && amount >= 10000
        {
            if let achievement = findAchievement("Big Spender")
            {
                let isAchieved = achievement.value(forKey: "isAchieved") as? Bool ?? false
                if isAchieved == false
                {
                    achievement.setValue(true, forKey: "isAchieved")
                    self.saveData()
                    
                    // alert achievement
                    let alert = UIAlertController(title: "Big Spender!", message: "You unlocked a new achievement!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion:nil)
                }
            }
        }
    }
    
    // Phoenix added
    func checkGoldMiner(_ category: String)
    {
        if category == "found on street"
        {
            if let achievement = findAchievement("Gold Miner")
            {
                let isAchieved = achievement.value(forKey: "isAchieved") as? Bool ?? false
                if isAchieved == false
                {
                    achievement.setValue(true, forKey: "isAchieved")
                    self.saveData()
                    
                    // alert achievement
                    let alert = UIAlertController(title: "Gold Miner!", message: "You unlocked a new achievement!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion:nil)
                }
            }
        }
    }
}
