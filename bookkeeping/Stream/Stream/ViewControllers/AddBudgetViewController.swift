//  Name: Wenzhuo Zhao
//  email: zhaowenz@sheridancollege.ca
//  Created Data: 11-15, 2019
//  Last Updated Date: Dec.11, 2019
//  short description: The view controller allow user to enter the budget for the month, and store in the core data.
//  AddBudgetViewController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
import CoreData     // for CoreData framework
import os.log       // for system logging

class AddBudgetViewController: UIViewController {

    @IBOutlet weak var budgetTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    let managedObjectContext: NSManagedObjectContext
    var moBudget: [NSManagedObject] = []    // whole managed objects
    var budget: Double = 0.00           // group names only
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.budgetTextfield?.text = String(self.budget)
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

        // if groups is empty, add 10 default groups
        if self.moBudget.isEmpty
        {
            self.initDefaultBudget()
            self.fetchData()    // reload data
        }
       self.budgetTextfield?.text = String(self.budget)
    }
    
    func fetchData()
    {
        // create fetch request objects to query managed objects
        let budgetRequest = NSFetchRequest<NSManagedObject>(entityName: "Other")

        // fetch data within do-catch block
        do
        {
            self.moBudget = try managedObjectContext.fetch(budgetRequest)
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }
        
        self.budget = 0.00
        
        if self.moBudget.count != 0{
            let budgetValue = self.moBudget[0].value(forKey: "budget") as? Double ?? 0.00
            self.budget = budgetValue
        }
        
    }
    
    // add 3 default categories into CoreData
    func initDefaultBudget()
    {
            // create entity object
            if let entity = NSEntityDescription.entity(forEntityName: "Other", in: self.managedObjectContext)
            {
                // create managed object
                let moBugdetDefault = NSManagedObject(entity: entity, insertInto: managedObjectContext)

                // set field values
                let defaultAmount = 0.00
                moBugdetDefault.setValue(defaultAmount, forKey: "budget")
            }
        // save core data
        self.saveData()
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
    
    @IBAction func handleSave(_ sender: Any)
    {
        // validate if textfields are empty
        if self.budgetTextfield?.text != ""
        {
            let moBudget = self.moBudget[0]
            self.managedObjectContext.delete(moBudget) // delete it from CoreData
            self.saveData()
            
                  // create entity object
              if let entity = NSEntityDescription.entity(forEntityName: "Other", in: managedObjectContext)
              {
                  // create managed object
                  let moBudget = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                let newBudget = Double(self.budgetTextfield?.text ?? "0.0")
                  // set its value
                  moBudget.setValue(newBudget, forKey: "budget")
                  self.saveData()
              }
        }
        else
        {
            let warningAlert = UIAlertController(title: "Message", message: "Please enter the budget", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(warningAlert, animated: true)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
