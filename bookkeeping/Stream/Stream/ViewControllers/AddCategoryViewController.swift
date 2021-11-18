//  Name: Wenzhuo Zhao
//  email: zhaowenz@sheridancollege.ca
//  Created Data: 11-17, 2019
//  Last Updated Date: Dec.11, 2019
//  short description: The view controller allow user to customize the category, it allows user to create a new category and delete category, and then store in the core data.
//  AddCategoryViewController.swift
//  Stream
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var categoryTypeSegement: UISegmentedControl!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var delegate: AddCategoryViewDelegate? = nil // to remember who is delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loa
    }
    
    @IBAction func handleSave(_ sender: Any)
    {
        // validate if textfields are empty
        if self.nameTextfield?.text != ""
        {
            delegate?.AddCategoryViewDidFinish(sender:self)
        }else{
            let warningAlert = UIAlertController(title: "Message", message: "Please enter all required fields", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(warningAlert, animated: true)
        }
        dismiss(animated: true, completion: nil)
    }

}

// delegate protocol
protocol AddCategoryViewDelegate: AnyObject
{
    func AddCategoryViewDidFinish(sender: AddCategoryViewController)
}
