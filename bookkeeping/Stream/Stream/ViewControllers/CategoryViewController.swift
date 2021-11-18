//  Name: Wenzhuo Zhao
//  email: zhaowenz@sheridancollege.ca
//  Created Data: 11-07, 2019
//  Last Updated Date: Dec.11, 2019
//  short description: The view controller allow user to see all the categories, it allow to add a new transcation by clicking add new category button.
//  CategoryViewController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
// for CoreData framework
import CoreData
import os.log

class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddCategoryViewDelegate {
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var categoryTypeSegement: UISegmentedControl!
    
    var newName : String = ""
    var categoryType : Bool = true
    
    // properties
    let managedObjectContext: NSManagedObjectContext
    var moCategories: [NSManagedObject] = []  // whole managed objects
    var moRecords: [NSManagedObject] = []
    
    var incomeCategory : [NSManagedObject] = []
    var expenseCategory : [NSManagedObject] = []
    
    var showCategory : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.determineCategoryType()
        
        // Do any additional setup after loading the view.
    }
    
    ///////////////////////////////////////////////////////////////////////////
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

        self.saveData()
        // if groups is empty, add 10 default groups
        if self.moCategories.isEmpty
        {
            self.initDefaultGroups()
            self.fetchData()    // reload data
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // load data from CoreData to arrays of managed objects
    func fetchData()
    {
        // create fetch request objects to query managed objects
        let categoryRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        let recordRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")

        // fetch data within do-catch block
        do
        {
            self.moCategories = try managedObjectContext.fetch(categoryRequest)
            self.moRecords = try managedObjectContext.fetch(recordRequest)
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }

        filterCategory()
    }

    //filet the category by income and expense
    func filterCategory()
    {
        // filter income and expense category
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
    
    // add some default categories into CoreData
    func initDefaultGroups()
    {
        // create entity object
        if let entity = NSEntityDescription.entity(forEntityName: "Category", in: self.managedObjectContext)
        {
            // create managed object
            let moCategory = NSManagedObject(entity: entity, insertInto: managedObjectContext)
            
            // set field values
            let cateName = "Food"
            let isIncome = false
            moCategory.setValue(cateName, forKey: "name")
            moCategory.setValue(isIncome, forKey: "isIncome")
                
            let moCategory1 = NSManagedObject(entity: entity, insertInto: managedObjectContext)

            // set field values
            let cateName1 = "Drink"
            let isIncome1 = false
            moCategory1.setValue(cateName1, forKey: "name")
            moCategory1.setValue(isIncome1, forKey: "isIncome")
                
            let moCategory2 = NSManagedObject(entity: entity, insertInto: managedObjectContext)

            // set field values
            let cateName2 = "Rent"
            let isIncome2 = false
            moCategory2.setValue(cateName2, forKey: "name")
            moCategory2.setValue(isIncome2, forKey: "isIncome")
                
            let moCategory3 = NSManagedObject(entity: entity, insertInto: managedObjectContext)

            // set field values
            let cateName3 = "Transportation"
            let isIncome3 = false
            moCategory3.setValue(cateName3, forKey: "name")
            moCategory3.setValue(isIncome3, forKey: "isIncome")
                
            let moencomaCategory = NSManagedObject(entity: entity, insertInto: managedObjectContext)

            // set field values
            let categoryName = "Cheque"
            let income = true
            moencomaCategory.setValue(categoryName, forKey: "name")
            moencomaCategory.setValue(income, forKey: "isIncome")
                
            let moencomaCategory1 = NSManagedObject(entity: entity, insertInto: managedObjectContext)

            // set field values
            let categoryName1 = "Cash"
            let income1 = true
            moencomaCategory1.setValue(categoryName1, forKey: "name")
            moencomaCategory1.setValue(income1, forKey: "isIncome")
                
            let moencomaCategory2 = NSManagedObject(entity: entity, insertInto: managedObjectContext)
            
            // set field values
            let categoryName2 = "Money Trasfer"
            let income2 = true
            moencomaCategory2.setValue(categoryName2, forKey: "name")
            moencomaCategory2.setValue(income2, forKey: "isIncome")
                
            let moencomaCategory3 = NSManagedObject(entity: entity, insertInto: managedObjectContext)

            // set field values
            let categoryName3 = "Bonus"
            let income3 = true
            moencomaCategory3.setValue(categoryName3, forKey: "name")
            moencomaCategory3.setValue(income3, forKey: "isIncome")
                
            let moencomaCategory4 = NSManagedObject(entity: entity, insertInto: managedObjectContext)

            // set field values
            let categoryName4 = "Allowance"
            let income4 = true
            moencomaCategory4.setValue(categoryName4, forKey: "name")
            moencomaCategory4.setValue(income4, forKey: "isIncome")
        }
        

        // save core data
        self.saveData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        //set data for table cell
        let index = indexPath.row
        let moCategory = self.showCategory[index]
        let categoryName = moCategory.value(forKey: "name") as? String ?? ""
        cell.categoryName?.text = "\(categoryName)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let deleteAlert = UIAlertController(title: "Alert", message: "Will delete all transcations under this category", preferredStyle: .alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            deleteAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                 // delete the row and core data
                let index = indexPath.row
                let moCategory = self.showCategory[index]
                
                //get the name of deleted category
                let categoryRemovedName = moCategory.value(forKey: "name") as? String ?? ""

                self.showCategory.remove(at: index)
                if let index = self.moCategories.firstIndex(of: moCategory) {
                    self.moCategories.remove(at: index)
                }

                self.managedObjectContext.delete(moCategory) // delete it from CoreData
                
                for record in self.moRecords
                {
                    let categoryName = (record.value(forKey: "category") as? String ?? "")
                    if categoryName == categoryRemovedName{
                        self.managedObjectContext.delete(record)
                    }
                }
                
                //delete all the records under this category
                self.saveData()
                // delete it from array
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.filterCategory()
                self.categoryTableView.reloadData()
            }))
            self.present(deleteAlert, animated: true)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AddCategorySegue"
        {
            if let vc = segue.destination as? AddCategoryViewController
            {
                vc.delegate = self
            }
        }
    }
    
    // add a student into coredate
    func addCategory(categoryName:String, categoryType:Bool)
    {
        // create entity object
        if let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedObjectContext)
        {
            // create managed object
            let moCategory = NSManagedObject(entity: entity, insertInto: managedObjectContext)

            // set its value
            moCategory.setValue(categoryName, forKey: "name")
            moCategory.setValue(categoryType, forKey: "isIncome")
            
            // add it to array
            self.moCategories.append(moCategory)
            
            filterCategory()
            
            //determine the category type before reload the table
            determineCategoryType()
            
            //self.incomeCategory.append(categoryName)
            self.categoryTableView.reloadData() // redraw tableview
            self.viewDidLoad()
            // save core data
            self.saveData()
        }
    }
    
    //this function will determine which category to show
    func determineCategoryType(){
        let index = self.categoryTypeSegement.selectedSegmentIndex
        if index == 0
        {
            self.showCategory = self.incomeCategory
        }
        else{
            self.showCategory = self.expenseCategory
        }
    }
    
    func AddCategoryViewDidFinish(sender: AddCategoryViewController) {
        self.newName = sender.nameTextfield?.text ?? ""
        self.categoryType = sender.categoryTypeSegement?.selectedSegmentIndex == 0 ? true : false
        
        addCategory(categoryName:self.newName, categoryType:self.categoryType)
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
        self.categoryTableView.reloadData() // redraw tableview
    }
}
