//  Name: Qing Ge
//  email: geq@sheridancollege.ca
//  short description: The view controller displays the detailed statistics
//  AnalysisDetailViewController.swift
//  Stream
//
//  Created by Phoenix Ge on 2019-11-21.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit

class AnalysisDetailViewController: UITableViewController {

    var analysisCategory: AnalysisCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return analysisCategory?.categoryValue.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let period = "\(analysisCategory?.periodName ?? "") \(String(analysisCategory?.year ?? 0))"
        let amount = analysisCategory?.totalAmount ?? 0
        let formattedAmount = String(format: "%.2f", amount*100.rounded()/100)
        return "\(period)     total: \(formattedAmount)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCategoryCell ?? DetailCategoryCell(style: .default, reuseIdentifier: "DetailCell")
        let row = indexPath.row
        let categories = analysisCategory?.categoryValue.keys.sorted(by: <)
        let amount = analysisCategory?.categoryValue[categories?[row] ?? ""] ?? 0
        tableCell.labelCategory?.text = categories?[row]
        tableCell.labelAmount?.text = String(format: "%.2f", amount*100.rounded()/100)
        let totalAmount = analysisCategory?.totalAmount ?? 0
        if totalAmount != 0
        {
            let percentage = (amount/totalAmount)*100*100.rounded()/100
            tableCell.labelPercentage?.text = String(format: "%.2f", percentage) + "%"
        }
        
        return tableCell
    }
}
