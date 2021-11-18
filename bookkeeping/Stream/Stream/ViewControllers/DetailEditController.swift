//  Name: WeijieZheng
//  email: zhenzhen@sheridancollege.ca
//  Created Data: 11-17, 2019
//  Last Updated Date: Dec.11, 2019
//  short description: allow user to change selected record's amount and description.
//
//  DetailEditController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
import CoreData
import os.log

class DetailEditController: UIViewController {

    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var textDesc: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    let managedObjectContext: NSManagedObjectContext
    var amount = 0.00
    var desc = ""
    var date: Date = Date()
    var moRecord: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textAmount.text = "\(amount)"
        textDesc.text = desc
    }
    
    required init?(coder  aCoder: NSCoder)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext

        super.init(coder:aCoder)

        self.fetchData()
        if self.moRecord.isEmpty
        {
            self.fetchData()
        }
    }
    
    func fetchData()
    {
        let recordRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")

        do
        {
            self.moRecord = try managedObjectContext.fetch(recordRequest)
        }
        catch let error as NSError
        {
            os_log("[ERROR] %@", error.localizedDescription)
        }
    }
    
    func findRecord(_ amount:Double,_ date:Date,_ desc:String) -> NSManagedObject?
    {
        return self.moRecord.first(where:
        {
            $0.value(forKey: "amount") as? Double == self.amount && $0.value(forKey: "date") as? Date == self.date && $0.value(forKey: "desc") as? String == self.desc
        })
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
    
    @IBAction func handleSave(_ sender: Any) {
        
        if self.textAmount?.text != "" {
            if self.textDesc?.text != "" {
                
                let record = findRecord(self.amount, self.date, self.desc)
                
                if let newAmount = textAmount.text{
                    record?.setValue(Double(newAmount), forKey: "amount")
                }
                let newDesc = textDesc.text ?? ""
                record?.setValue(newDesc, forKey: "desc")
                
                saveData()
                
                let alert = UIAlertController(title: "Message", message: "Edit recore successfully!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action) in
                    
                    if let vc = self.navigationController?.viewControllers[0]
                    {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }    
                }))
                self.present(alert, animated: true)
                
            }else{
                let warningAlert = UIAlertController(title: "Message", message: "Please enter the description", preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(warningAlert, animated: true)
            }
        }else{
            let warningAlert = UIAlertController(title: "Message", message: "Please enter the amount", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(warningAlert, animated: true)
        }
    }
}
