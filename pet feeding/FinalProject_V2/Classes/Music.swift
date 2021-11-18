//
//  Music.swift
//  FinalProject_V2
//
//  Created by Qian Wang
//  Class defined the background music
//

import UIKit

class Music: NSObject {
    var id:Int?
    var name:String?
    var price:Int?

    
    func initWithData(theRow i:Int, theName n:String, thePrice p: Int){
        id = i
        name = n
        price = p
      
    }

}
