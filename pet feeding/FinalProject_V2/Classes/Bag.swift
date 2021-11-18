//
//  Bag.swift
//  FinalProject_V2
//
//  Created by Weijie Zheng
//  Description: A object class for the items in the bag
//

import UIKit

class Bag: NSObject {
    var id : Int?
    var name : String?
    var point : Int?
    var qty : Int?
    var type : Int?
    
    
    func initWithData(theRow i :Int, theName n :String, thePoint p :Int, theQty q :Int, theType t :Int){
        id=i
        name = n
        point = p
        qty = q
        type = t
    }
}
