//  Name: WeijieZheng
//  email: zhenzhen@sheridancollege.ca
//  Created Data: 11-17, 2019
//  Last Updated Date: Dec.11, 2019
//  short description: Display user's record, budge, income and expend.
//
//  MainViewController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
import CoreData
import os.log

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelBudgetAmount: UILabel!
    @IBOutlet weak var labelIncomeAmount: UILabel!
    @IBOutlet weak var labelExpendAmount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let managedObjectContext: NSManagedObjectContext
    var moBudget: [NSManagedObject] = []
    var budget: Double = 0.00
    
    var moRecords: [NSManagedObject] = []
    var income: Double = 0.00
    var expend: Double = 0.00
    
    required init?(coder  aCoder: NSCoder)
    {
        // initialize managed object context in this class
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        // call superclass init() right after init all properties of this class
        super.init(coder:aCoder)

        // load data
        self.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let currYear = Calendar.current.component(.year, from: Date())
        labelYear.text = "\(currYear)"
        let currMonth = DateFormatter().monthSymbols[Calendar.current.component(.month, from: Date()) - 1]
        labelMonth.text = "\(currMonth)"
        
        self.view.layoutIfNeeded()
    
    }
    
    func fetchData()
    {
        // create fetch request objects to query managed objects
        let budgetRequest = NSFetchRequest<NSManagedObject>(entityName: "Other")
        let recordRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")

        // fetch data within do-catch block
        do
        {
            self.moBudget = try managedObjectContext.fetch(budgetRequest)
            self.moRecords = try managedObjectContext.fetch(recordRequest)
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }

        if self.moBudget.isEmpty == false{
         
            
            self.budget = self.moBudget[0].value(forKey: "budget") as? Double ?? 0.00
        }
        
        calculateRecords()
        labelBudgetAmount?.text = "\(budget)"
        
    }
    
    func calculateRecords(){
        
        income = 0
        expend = 0
        for moRecord in moRecords {
            
            let amount = (moRecord.value(forKey: "amount") as? Double ?? 0.00)

            if moRecord.value(forKey: "isIncome") as? Bool ?? true {
                
                income += amount
            }else {
                expend += amount
            }
        }
        
        labelIncomeAmount?.text = "\(income)"
        labelExpendAmount?.text = "\(expend)"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moRecords.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as? RecordCell ?? RecordCell(style: .default, reuseIdentifier: "RecordCell")
        
        let index = indexPath.row
        
        tableCell.labelCategory?.text = moRecords[index].value(forKey: "category") as? String ?? ""
        
        if let isIncome = moRecords[index].value(forKey: "isIncome") as? Bool{
            
            if isIncome == true{
                tableCell.labelAmount?.text = "\(moRecords[index].value(forKey:"amount") as? Double ?? 0.00)"
                tableCell.imageview?.image = UIImage(named: "income")
            }else{
                tableCell.labelAmount?.text = "-\(moRecords[index].value(forKey:"amount") as? Double ?? 0.00)"
                tableCell.imageview?.image = UIImage(named: "expend")
            }
        }
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let index = indexPath.row
            let record = self.moRecords[index]
        
            self.managedObjectContext.delete(record)
            self.saveData()
            
            moRecords.remove(at: index)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            calculateRecords()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segueInfo"
        {
            if let vc = segue.destination as? DetailViewController
            {
                let index = self.tableView.indexPathForSelectedRow?.row ?? 0
                
                vc.recordInfo = moRecords[index]
            }
        }
    }
}
