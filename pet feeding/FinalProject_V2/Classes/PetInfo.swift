//
//  PetInfo.swift
//  FinalProject_V2
//
//  Created by Wenzhuo Zhao
//  Description: Custom Object class to store pet infomation
//

import UIKit

class PetInfo: NSObject {
    var id : Int = 0
    var name : String = ""
    var level : Int = 0
    var foodBar : Int = 0
    var levelBar : Int = 0
    
    func initWithData(theRow i :Int,theName n: String,theLevel l:Int,theFoodBar fb: Int,theLevelBar lb:Int){
        id = i
        name = n
        level = l
        foodBar = fb
        levelBar = lb
    }
}
