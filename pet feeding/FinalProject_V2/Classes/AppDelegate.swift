//
//  AppDelegate.swift
//  FinalProject_V2
//
//  Created by Weijie Zheng, Wenzhuo Zhao, Qian Wang
//  Description: A class for database functions and global varaibles
//

import UIKit
import SQLite3
import AVFoundation
import CoreMotion
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //create varaibles
    var window: UIWindow?
    var databaseName : String? = "final_v3.db"
    var databasePath : String?
    var missions : [Mission] = []
    var bagInfo : [Bag] = []
    var petInfo : [PetInfo] = []
    var shopItems:[ShopItem] = []
    var bgms:[Music] = []
    var musics:[Music] = []
    var soundPlayer : AVAudioPlayer?
    let pedometer: CMPedometer = CMPedometer()
    var errorMsg: String?
    var steps:Int = 100000
    var money:Int = 100000
    var foodPoint: Int? = 0
    var levelPoint: Int? = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/"+databaseName!)
        print("Database Path is: "+databasePath!)
        checkAndCreateDatabase()
        readDataFromMission()
        readDataFromShop()
        readDataFromMusic()
        //startPedometerUpdates()
        return true
    }
    
    func setMoney(price:Int){
        money = money-price
    }
    
    /*author:Qian Wang
     get the steps the user already walked
     */
    func startPedometerUpdates() {
        
        guard CMPedometer.isStepCountingAvailable() else {
            errorMsg="The device does not support fetching steps"
            print(errorMsg)
            return
        }
        //get the 00:00 am
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let midnightOfToday = cal.date(from: comps)!
        
        //get the real time data
        self.pedometer.startUpdates (from: midnightOfToday, withHandler: { pedometerData, error in
            
            guard error == nil else {
                print(error!)
                return
            }
            if let numberOfSteps = pedometerData?.numberOfSteps {
                self.steps = (numberOfSteps as? Int)!
                print("Steps: \(String(describing: self.steps))")
                self.money = (numberOfSteps as? Int)!
                print("money: \(String(describing: self.money))")
            }
            
        })
    }
    
    /*author: Weijie Zheng
     check and create db
     */
    func checkAndCreateDatabase(){
        let fileManager = FileManager.default
        let success = fileManager.fileExists(atPath: databasePath!)
        
        if success{
            return
        }
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/"+databaseName!)
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
    }
    
    /*author: Wenzhuo Zhao
     update mission data into database
     */
    func updateDataToMission(type : String,num : String,ID : Int){
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            //print("Successfullly opened connection to databse at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "UPDATE mission SET "+type+" = '"+String(num)+"' WHERE ID = "+String(ID)+";"
            print(queryStatementString)
            
            //check if the update statement is prepare ok
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
            {
                if sqlite3_step(queryStatement) == SQLITE_DONE {
                    print("Successfully updated Pet Info.")
                    readDataFromMission()
                } else {
                    print("Could not update Pet Info.")
                }
                sqlite3_finalize(queryStatement)
            }
            else
            {
                print("update could not be prepared")
            }
            sqlite3_close(db)
            
        }else{
            print("unable to open db")
        }
    }
    
    /*author: Wenzhuo Zhao
     read mission data from db, add to a global array
     */
    func readDataFromMission(){
        missions.removeAll()
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Successfullly opened connection to databse at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "select * from mission;"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
            {
                while(sqlite3_step(queryStatement) == SQLITE_ROW)
                {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    
                    let cdescription = sqlite3_column_text(queryStatement, 1)
                    let cgoal = sqlite3_column_text(queryStatement, 2)
                    let cBadge = sqlite3_column_text(queryStatement, 3)
                    
                    
                    let description = String(cString: cdescription!)
                    let goal = String(cString: cgoal!)
                    let badge = String(cString: cBadge!)
                    let data : Mission = .init()
                    data.initWithData(theRow :id,theMissionDescription:description,theMissionGoal : goal,theBadgeImage:badge)
                    missions.append(data)
                }
                sqlite3_finalize(queryStatement)
            }
            else
            {
                print("Select could not be prepared")
            }
            sqlite3_close(db)
            
        }else{
            print("unable to open db")
        }
    }
    
    /*author: Weijie Zheng
     read the bag item info from the database and load into a global array
     */
    func readDataFromBag(){
        bagInfo.removeAll();
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Successfullly opened connection to databse at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "select * from Bag;"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
            {
                while(sqlite3_step(queryStatement) == SQLITE_ROW)
                {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cName = sqlite3_column_text(queryStatement, 1)
                    let point : Int = Int(sqlite3_column_int(queryStatement, 2))
                    let qty : Int = Int(sqlite3_column_int(queryStatement, 3))
                    let type : Int = Int(sqlite3_column_int(queryStatement, 4))
                    
                    let name = String(cString: cName!)
                    
                    let data : Bag = .init()
                    data.initWithData(theRow :id, theName :name, thePoint: point, theQty : qty, theType: type)
                    
                    bagInfo.append(data)
                }
                sqlite3_finalize(queryStatement)
            }
            else
            {
                print("Select could not be prepared")
            }
            sqlite3_close(db)
            
        }else{
            print("unable to open db")
        }
    }
    
    /*author: Weijie Zheng
     update the quantity of items in bag
     */
    func updateDataToBag(itemId : Int,qty : Int){
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Successfullly opened connection to databse at \(self.databasePath)")
            
            var updateStatement : OpaquePointer? = nil
            var updateStatementString : String = "UPDATE bag SET Qty = Qty+? where ID=?"
            print(updateStatementString)
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK
            {
                sqlite3_bind_int(updateStatement, 1, Int32(qty))
                sqlite3_bind_int(updateStatement, 2, Int32(itemId))
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Successfully updated row.")
                    readDataFromBag()
                } else {
                    print("Could not update row.")
                }
                sqlite3_finalize(updateStatement)
            }
            else
            {
                print("update could not be prepared")
            }
            sqlite3_close(db)
            
        }else{
            print("unable to open db")
        }
    }
    
    /*author: Wenzhuo Zhao
     update pet infomation into database
     */
    func readDataFromPetInfo(){
        petInfo.removeAll();
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Successfullly opened connection to databse at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "select * from PetInfo;"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
            {
                while(sqlite3_step(queryStatement) == SQLITE_ROW)
                {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    
                    let level:Int = Int(sqlite3_column_int(queryStatement, 1))
                    let foodBar:Int = Int(sqlite3_column_int(queryStatement, 2))
                    let levelBar:Int = Int(sqlite3_column_int(queryStatement, 3))
                    let cname = sqlite3_column_text(queryStatement, 4)
                    
                    let name = String(cString: cname!)
                    
                    let data : PetInfo = .init()
                    data.initWithData(theRow :id,theName:name, theLevel:level,theFoodBar : foodBar,theLevelBar:levelBar)
                    petInfo.append(data)
                    
                    
                }
                sqlite3_finalize(queryStatement)
            }
            else
            {
                print("Select could not be prepared")
            }
            sqlite3_close(db)
            
        }else{
            print("unable to open db")
        }
    }
    
    
    /*author: Wenzhuo Zhao
     create a new pet when enter the game first time
     */
    func insertIntoPetInfo(name : String)->Bool{
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if(sqlite3_open(self.databasePath, &db) == SQLITE_OK){
            print("Successsfully opened db at \(self.databasePath)")
            
            var insertStatement: OpaquePointer? = nil
            var insertStatementString :String = "insert into PetInfo values(NULL, ?, ?, ?, ?)"
            if sqlite3_prepare_v2(db,insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
            {
                let nameStr = name as NSString
                
                let insertValue : Int = 0
                sqlite3_bind_int(insertStatement, 1, Int32(insertValue))
                sqlite3_bind_int(insertStatement, 2, Int32(insertValue))
                sqlite3_bind_int(insertStatement, 3, Int32(insertValue))
                sqlite3_bind_text(insertStatement, 4, nameStr.utf8String, -1, nil)
                
                if(sqlite3_step(insertStatement) == SQLITE_DONE)
                {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row at \(rowID)")
                }else{
                    print("coudl not insert the row")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }
            else
            {
                print("insert statement could not be prepared")
                returnCode = false
            }
            sqlite3_close(db)
        }
        else
        {
            print("unable to open database")
            returnCode = false
        }
        return returnCode
    }
    
    /*author: Wenzhuo Zhao
     update the pet info into db
     */
    func updateDataToPetInfo(type : String,num : Int){
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Successfullly opened connection to databse at \(self.databasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "UPDATE PetInfo SET "+type+" = "+String(num)+" WHERE ID = 1;"
            print(queryStatementString)
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
            {
                if sqlite3_step(queryStatement) == SQLITE_DONE {
                    print("Successfully updated Pet Info.")
                    readDataFromPetInfo()
                } else {
                    print("Could not update Pet Info.")
                }
                sqlite3_finalize(queryStatement)
            }
            else
            {
                print("update could not be prepared")
            }
            sqlite3_close(db)
            
        }else{
            print("unable to open db")
        }
    }
    
    /*author: Qian Wang
     read data from shop table
     */
    func readDataFromShop(){
        shopItems.removeAll()
        var db:OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db)==SQLITE_OK{
            print("Successfully opened connection to database at \(self.databasePath)")
            var queryStatement:OpaquePointer?=nil
            var queryStatmentsString:String="select * from shop"
            if sqlite3_prepare_v2(db, queryStatmentsString, -1, &queryStatement, nil)==SQLITE_OK{
                while sqlite3_step(queryStatement)==SQLITE_ROW{
                    let id:Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let price = Int(sqlite3_column_int(queryStatement, 2))
                    let energy = Int(sqlite3_column_int(queryStatement, 3))
                    let experience = Int(sqlite3_column_int(queryStatement, 4))
                    let cpath = sqlite3_column_text(queryStatement, 5)
                    let name = String(cString: cname!)
                    let path = String(cString: cpath!)
                    let shopItem:ShopItem=ShopItem.init()
                    shopItem.initWithData(theRow: id, theName: name, thePrice: price, theEnergy: energy,theExperience:experience, thePath: path)
                    
                    shopItems.append(shopItem)
                    
                    
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
        
    }
    
    /*author: Qian Wang
     read data from music table. Music table contains all the background music provided by this application
     */
    func readDataFromMusic(){
        musics.removeAll()
        var db:OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db)==SQLITE_OK{
            print("Successfully opened connection to database at \(self.databasePath)")
            var queryStatement:OpaquePointer?=nil
            var queryStatmentsString:String="select * from music"
            if sqlite3_prepare_v2(db, queryStatmentsString, -1, &queryStatement, nil)==SQLITE_OK{
                while sqlite3_step(queryStatement)==SQLITE_ROW{
                    let id:Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let price = Int(sqlite3_column_int(queryStatement, 2))
                    let name = String(cString: cname!)
                    let music:Music=Music.init()
                    music.initWithData(theRow: id, theName: name, thePrice: price)
                    
                    musics.append(music)
                    
                    
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                
                print("Select statement could not be prepared")
                
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
        
    }
    /*author: Qian Wang
     read data from bgm table. bgm table contains all the background music bought by user
     */
    func readDataFromBGM(){
        bgms.removeAll()
        var db:OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db)==SQLITE_OK{
            print("Successfully opened connection to database at \(self.databasePath)")
            var queryStatement:OpaquePointer?=nil
            var queryStatmentsString:String="select * from bgm"
            if sqlite3_prepare_v2(db, queryStatmentsString, -1, &queryStatement, nil)==SQLITE_OK{
                while sqlite3_step(queryStatement)==SQLITE_ROW{
                    let id:Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let price = Int(sqlite3_column_int(queryStatement, 2))
                    let name = String(cString: cname!)
                    let bgm=Music.init()
                    bgm.initWithData(theRow: id, theName: name, thePrice: price)
                    
                    bgms.append(bgm)
                    
                    
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                
                print("Select statement could not be prepared")
                
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
        
    }
    
    /*author: Qian Wang
     insert data to bgm table after user buying a backgroud music
     */
    func insertDataToBGM(music:Music){
        var db: OpaquePointer?=nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Successfully opened connection to database at \(self.databasePath)")
            var insertStatement: OpaquePointer? = nil
            var insertStatementString : String = "insert into bgm values(NULL,?,?)"
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
                let nameStr = music.name! as NSString
                let price=music.price! as Int
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 2, Int32(price))
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    let rowID=sqlite3_last_insert_rowid(db)
                    print("Successfuly inserted row at\(rowID)")
                }
                else{
                    print("could not insert")
                    
                }
                sqlite3_finalize(insertStatement)
            }
            else{
                
                print("Insert statement could not be prepared")
                
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
        
    }
    /*author: Qian Wang
     check whether a bgm is already bought
     */
    func checkFromBGM(name:String)->Bool{
        var db: OpaquePointer?=nil
        var returnCode : Bool = false
        if sqlite3_open(self.databasePath, &db)==SQLITE_OK{
            print("Successfully opened connection to database at \(self.databasePath)")
            var queryStatement:OpaquePointer?=nil
            var queryStatmentsString:String="select * from bgm where Name=? limit 0,1"
            
            if sqlite3_prepare_v2(db, queryStatmentsString, -1, &queryStatement, nil)==SQLITE_OK{
                let nameStr = name as NSString
                sqlite3_bind_text(queryStatement, 1, nameStr.utf8String, -1, nil)
                while sqlite3_step(queryStatement)==SQLITE_ROW{
                    
                    let cname = sqlite3_column_text(queryStatement, 1)
                    if cname != nil{
                        returnCode = true
                    }
                    
                    
                }
                sqlite3_finalize(queryStatement)
            }
            else{
                
                print("Select statement could not be prepared")
                
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
        }
        return returnCode
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

