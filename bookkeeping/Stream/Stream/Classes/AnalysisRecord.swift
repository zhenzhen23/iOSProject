//
//  AnalysisRecord.swift
//  Stream
//
//  Created by Phoenix Ge on 2019-11-10.
//  Copyright © 2019 PhoenixGe. All rights reserved.
//

import UIKit

class AnalysisRecord: NSObject {
    var name: String?
    var totalAmount: Double?
    
    internal init(name: String, totalAmount: Double)
    {
        self.name = name
        self.totalAmount = totalAmount
    }
}
