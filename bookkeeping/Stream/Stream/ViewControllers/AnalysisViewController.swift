//  Name: Qing Ge
//  email: geq@sheridancollege.ca
//  short description: The view controller displays analysis data in month and year
//  AnalysisViewController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-06.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
import CoreData
import os.log

class AnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let managedObjectContext: NSManagedObjectContext
    var categories: [NSManagedObject] = []
    var categoriesIncome: [NSManagedObject] = []
    var categoriesExpense: [NSManagedObject] = []
    
    // [year:[month:category]]
    var catesMonth: [Int:[Int:AnalysisCategory]] = [:]
    
    // [year:category]
    var catesYear: [Int:AnalysisCategory] = [:]
    
    var sortedKeys: [Int] = []
    var totalSumForAll: Double = 0
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var segType: UISegmentedControl!
    @IBOutlet weak var segPeriod: UISegmentedControl!
    
    @IBAction func segmentTypeIndexChange(_ sender: UISegmentedControl) {
        
        let index = segType.selectedSegmentIndex
        
        if (index == 0) {
            getAnalysisPeriod(categoriesIncome)
            tableview.reloadData()
        } else {
            getAnalysisPeriod(categoriesExpense)
            tableview.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segPeriod.selectedSegmentIndex == 0
        {
            return catesMonth.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segPeriod.selectedSegmentIndex == 0
        {
            // if it's month mode, section is year
            return String(sortedKeys[section])
        }
        // if it's year node, no section title
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segPeriod.selectedSegmentIndex == 0
        {
            let monthNUM = catesMonth[sortedKeys[section]]?.keys.count ?? 0
            return monthNUM
        }
        return catesYear.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as? AnalysisCell ?? AnalysisCell(style: .default, reuseIdentifier: "AnalysisCell")
        let row = indexPath.row
        
        if segPeriod.selectedSegmentIndex == 0
        {
            let section = indexPath.section
            // months array ordered in time
            let months = catesMonth[sortedKeys[section]]?.keys.sorted(by: <)
            tableCell.labelCategory?.text = convertNumToMonth(number: months?[row] ?? 0)
            let amountInMonth = catesMonth[sortedKeys[section]]?[months?[row] ?? 0]?.totalAmount ?? 0
            tableCell.labelAmount?.text = String(format: "%.2f", amountInMonth*100.rounded()/100)
            let percentage = (amountInMonth/totalSumForAll)*100*100.rounded()/100
            tableCell.labelPercentage?.text = String(format: "%.2f", percentage) + "%"
            let progressiveValue = percentage / 100
            tableCell.progressView.progress = Float(progressiveValue)
        }
        else
        {
            let year = sortedKeys[row]
            tableCell.labelCategory?.text = String(year)
            let amountInYear = catesYear[sortedKeys[row]]?.totalAmount ?? 0
            tableCell.labelAmount?.text = String(format: "%.2f", amountInYear*100.rounded()/100)
            let percentage = (amountInYear/totalSumForAll)*100*100.rounded()/100
            tableCell.labelPercentage?.text = String(format: "%.2f", percentage) + "%"
            let progressiveValue = percentage / 100
            tableCell.progressView.progress = Float(progressiveValue)
        }
        
        return tableCell
    }
    
    // get managed object context from app delegate
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
    
    func fetchData()
    {
        // create fetch request objects to query managed objects
        let categoryRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        
        // to sort by name with natural ascending
        let categoryDescriptor = NSSortDescriptor(key: "name",
                                                  ascending: true,
                                                  selector: #selector(NSString.localizedStandardCompare))
        
        categoryRequest.sortDescriptors = [categoryDescriptor]
        
        // fetch data within do-catch block
        do
        {
            self.categories = try managedObjectContext.fetch(categoryRequest)
            findIncomeAndExpense()
            
            // it is used when user jumps to this page
            if let index = segType?.selectedSegmentIndex
            {
                if index == 1
                {
                    getAnalysisPeriod(categoriesExpense)
                }
                else
                {
                    getAnalysisPeriod(categoriesIncome)
                }
            }
            else
            {
                getAnalysisPeriod(categoriesIncome)
            }
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }
    }
    
    func findIncomeAndExpense()
    {
        categoriesIncome.removeAll()
        categoriesExpense.removeAll()
        for eachCategory in self.categories
        {
            let isIncome = eachCategory.value(forKey: "isIncome") as? Bool
            if let isIncome = isIncome
            {
                if isIncome
                {
                    categoriesIncome.append(eachCategory)
                }
                else
                {
                    categoriesExpense.append(eachCategory)
                }
            }
        }
    }
    
    
    // this method is to get each row by month or year
    func getAnalysisPeriod(_ categories: [NSManagedObject])
    {
        // reinitialize
        catesMonth.removeAll()
        catesYear.removeAll()
        sortedKeys.removeAll()
        totalSumForAll = 0
        
        // to get each category of income or expense
        for eachCategory in categories
        {
            //var sumForEachCategory: Double = 0
            let name = eachCategory.value(forKey: "name") as? String ?? ""
            
            let records = eachCategory.mutableSetValue(forKey: "records")
            
            // get each record in one category
            for record in records
            {
                if let eachRecord = record as? NSManagedObject
                {
                    let amount = eachRecord.value(forKey: "amount") as? Double ?? 0
                    if let date = eachRecord.value(forKey: "date") as? Date
                    {
                        let calendar = Calendar.current
                        let monthNum = calendar.component(.month, from: date)
                        let yearNum = calendar.component(.year, from: date)
                        
                        // convert month number to String
                        let monthString = convertNumToMonth(number: monthNum)
                        
                        if segPeriod?.selectedSegmentIndex ?? 0 == 0
                        {
                            // if year doesn't exist
                            if catesMonth[yearNum] == nil
                            {
                                // add a new year and month
                                let analysisCategory = AnalysisCategory()
                                catesMonth[yearNum] = [monthNum:analysisCategory]
                            }
                            // if year exists, but month doesn't
                            else if catesMonth[yearNum]?[monthNum] == nil
                            {
                                // add a new month
                                let analysisCategory = AnalysisCategory()
                                catesMonth[yearNum]?[monthNum] = analysisCategory
                            }
                                
                            // if category exists, update value in category
                            //let value = catesMonth[yearNum]?[monthNum]?.categoryValue[name]
                            
                            if let value = catesMonth[yearNum]?[monthNum]?.categoryValue[name]
                            {
                                catesMonth[yearNum]?[monthNum]?.categoryValue[name] = value + amount
                            }
                            else
                            {
                                // if category doesn't exist, add a new category
                                catesMonth[yearNum]?[monthNum]?.categoryValue[name] = amount
                                catesMonth[yearNum]?[monthNum]?.periodName = monthString
                                catesMonth[yearNum]?[monthNum]?.year = yearNum
                            }
                            
                            // calculate total amount for the whole month
                            catesMonth[yearNum]?[monthNum]?.totalAmount += amount
                        }
                        else
                        {
                            // store obj in catesYear dictionary
                            // check if year already exists
                            if catesYear[yearNum] == nil
                            {
                                // create an empty obj to store data belongs to this month
                                let analysisCategory = AnalysisCategory()
                                catesYear[yearNum] = analysisCategory
                            }
                            
                            // update the value in catesYear dictionary
                            if let value = catesYear[yearNum]?.categoryValue[name]
                            {
                                catesYear[yearNum]?.categoryValue[name] = value + amount
                            }
                            else
                            {
                                catesYear[yearNum]?.categoryValue[name] = amount
                                catesYear[yearNum]?.year = yearNum
                            }
                            catesYear[yearNum]?.totalAmount += amount
                        }
                        
                        totalSumForAll += amount
                    }
                }
            }
        }
        
        // sort keys
        if segPeriod?.selectedSegmentIndex ?? 0 == 0
        {
            sortedKeys = catesMonth.keys.sorted()
        }
        else
        {
            sortedKeys = catesYear.keys.sorted()
        }
    }
    
    func updateTable()
    {
        self.fetchData()
        tableview.reloadData()
    }
    
    func convertNumToMonth(number: Int) -> String
    {
        switch number
        {
            case 1: return "Jan"
            case 2: return "Feb"
            case 3: return "Mar"
            case 4: return "Apr"
            case 5: return "May"
            case 6: return "Jun"
            case 7: return "Jul"
            case 8: return "Aug"
            case 9: return "Sep"
            case 10: return "Oct"
            case 11: return "Nov"
            case 12: return "Dec"
            default: return ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segueToAnalysisDetail"
        {
            if let vc = segue.destination as? AnalysisDetailViewController
            {
                let row = tableview.indexPathForSelectedRow?.row ?? 0
                let section = tableview.indexPathForSelectedRow?.section ?? 0
                if segPeriod?.selectedSegmentIndex == 0
                {
                    let months = catesMonth[sortedKeys[section]]?.keys.sorted(by: <)
                    vc.analysisCategory = catesMonth[sortedKeys[section]]?[months?[row] ?? 0]
                }
                else
                {
                    vc.analysisCategory = catesYear[sortedKeys[row]]
                }
                             
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTable()
    }
}
