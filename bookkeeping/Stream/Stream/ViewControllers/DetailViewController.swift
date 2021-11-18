//  Name: WeijieZheng
//  email: zhenzhen@sheridancollege.ca
//  Created Data: 11-17, 2019
//  Last Updated Date: Dec.11, 2019
//  short description: Display detail information of selected record
//
//  DetailViewController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var recordInfo: NSManagedObject?
    
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelAmount.text = "\(recordInfo?.value(forKey:"amount") as? Double ?? 0.00)"
        labelCategory.text = "\(recordInfo?.value(forKey:"category") as? String ?? "")"
        labelDesc.text = "\(recordInfo?.value(forKey:"desc") as? String ?? "")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = recordInfo?.value(forKey:"date") as? Date{
            labelDate.text = dateFormatter.string(from: date)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "DetailEditSegue"
        {
            if let vc = segue.destination as? DetailEditController
            {
                vc.amount = recordInfo?.value(forKey:"amount") as? Double ?? 0
                vc.desc = "\(recordInfo?.value(forKey: "desc") ?? "")"
                vc.date = recordInfo?.value(forKey: "date") as? Date ?? Date()
            }
        }
    }
}
