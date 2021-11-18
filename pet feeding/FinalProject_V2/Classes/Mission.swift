//
//  Mission.swift
//  FinalProject_V2
//
//  Created by Wenzhuo Zhao
//  Custom Object to store the mission infomation
//

import UIKit

class Mission: NSObject {
    var id : Int?
    var missionDescription : String?
    var missionGoal : String?
    var badgeImage : String?
    
    func initWithData(theRow i :Int,theMissionDescription d:String,theMissionGoal g : String,theBadgeImage image: String){
        id=i
        missionDescription = d
        missionGoal = g
        badgeImage = image
    }
}
