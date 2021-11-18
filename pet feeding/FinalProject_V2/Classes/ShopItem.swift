//
//  ShopItem.swift
//  FinalProject_V2
//
//  Created by Qian Wang
//  Class defined the item stored in shop table
//

import UIKit

class ShopItem: NSObject {
    var id:Int?
    var name:String?
    var price:Int?
    var energy:Int?
    var experience:Int?
    var path:String?
    
    func initWithData(theRow i:Int, theName n:String, thePrice p: Int, theEnergy e:Int, theExperience ex:Int, thePath pa:String){
        id = i
        name = n
        price = p
        energy = e
        experience = ex
        path = pa
    }

}
