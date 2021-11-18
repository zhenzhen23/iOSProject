//
//  AnalysisCategory.swift
//  Stream
//
//  Created by Phoenix Ge on 2019-11-19.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit
import CoreData

class AnalysisCategory: NSObject {
    
    var periodName: String = ""
    var year: Int = 0
    var categoryValue: [String:Double] = [:]
    var totalAmount: Double = 0
}
