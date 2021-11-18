//
//  MainViewController.swift
//  FinalProject_V2
//
//  Created by Wenzhuo Zhao,Weijie Zheng
//  This controller is used to load weather API, and the main page, read pet info from db and so on
//(Because of the main page is heavy duty in our game,we discussed with you. )
//You said just leave comments to tell which person do which part.
import UIKit

class MainViewController: UIViewController {
    
    //create some @IBOutlet varaibles
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var foodProgress : UIProgressView!
    @IBOutlet var levelProgress : UIProgressView!
    @IBOutlet var level : UILabel!
    @IBOutlet var levelTips : UILabel!
    @IBOutlet var petName : UILabel!
    @IBOutlet var foodTips : UILabel!
    @IBOutlet var moneyLabel : UILabel!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //create weather varaible
    let cityData = CityDetails()
    @IBOutlet var tp : UILabel!
    @IBOutlet var btnWeather : UIButton!
    var weatherImg : String?
    var foodBarNum : Int?
    var foodFromdb : Int?
    var addFoodNum : Int?
    
    /*
     author: Wenzhuo Zhao
     unwind to the home page
     */
    @IBAction func unwindToHomeVC(sender:UIStoryboardSegue)
    {
        
    }
    
    /*
     author: Weijie Zheng
     load the level up animation
     */
    func levelAnimation(){
        imageView.loadGif(name: "levelup")
        
        //add eat food tips
        levelTips.text = "+10"
        foodTips.text = "-10"
        
        //change the label text
        changeLabelText()
        mainDelegate.levelPoint = 0
        
        //update the context in db
        var levelBarNum = (mainDelegate.petInfo[0].levelBar) + 10;
        mainDelegate.updateDataToPetInfo(type: "LevelBar", num: levelBarNum)
        var foodBarNum = (mainDelegate.petInfo[0].foodBar) - 10;
        mainDelegate.updateDataToPetInfo(type: "FoodBar", num: foodBarNum)
        
        //set the maxmiun of the mission
        if(mainDelegate.missions[0].missionGoal == "10" ){
            
        }else{
            let addNum : Int = Int(mainDelegate.missions[0].missionGoal!)! + 1;
            let updateValue : String? = String(addNum)
            mainDelegate.updateDataToMission(type: "goal", num: updateValue!, ID: 2)
            checkMissionStatus()
        }
        
        //assign the value to pet after updated
        mainDelegate.readDataFromPetInfo()
        assignValueToPetInfo()
        changeToMainImage()
    }
    
    /*
     author: Wenzhuo Zhao
     this method is used to check the mission status
     */
    func checkMissionStatus(){
        if(mainDelegate.missions[1].missionGoal == "15" ){
            mainDelegate.updateDataToMission(type: "badge", num: "badge4.png", ID: 3)
        }
        
        if(mainDelegate.missions[0].missionGoal == "10" ){
            mainDelegate.updateDataToMission(type: "badge", num: "badge3.png", ID: 2)
        }
    }
    
    /*
     author: Wenzhuo Zhao
     this method is used to load the food animation based on the different types of food
     */
    func foodAnimation(){
        if(mainDelegate.foodPoint == 0){
            
        }else{
            //check the type of the food
            if(mainDelegate.foodPoint == 10){
                imageView.loadGif(name: "eat2")
                foodTips.text="+10"
                foodBarNum = foodFromdb! + addFoodNum!;
            }
            
            if(mainDelegate.foodPoint == 50){
                imageView.loadGif(name: "eat3")
                foodTips.text="+50"
                foodBarNum = foodFromdb! + addFoodNum!;
            }
            
            if(mainDelegate.foodPoint == 30){
                imageView.loadGif(name: "eat1")
                foodTips.text="+30"
                foodBarNum = foodFromdb! + addFoodNum!;
            }
            changeLabelText()
            
            //update the pet info
            mainDelegate.updateDataToPetInfo(type: "FoodBar", num: foodBarNum!)
            mainDelegate.readDataFromPetInfo()
            assignValueToPetInfo()
            
            //change to the main iamge
            changeToMainImage()
            mainDelegate.foodPoint = 0;
            
            //check if meet the maxmium of the mission
            if(mainDelegate.missions[1].missionGoal == "15" ){
                
            }else{
                let addNum : Int = Int(mainDelegate.missions[1].missionGoal!)! + 1;
                let updateValue : String? = String(addNum)
                mainDelegate.updateDataToMission(type: "goal", num: updateValue!, ID: 3)
                checkMissionStatus()
            }
        }
    }
    
    /*
     author: Wenzhuo Zhao
     this method is used to change the label text to blank after 2 s
     */
    func changeLabelText(){
        let time: TimeInterval = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            //code
            self.foodTips.text = ""
            self.levelTips.text = ""
        }
    }
    
    /*
     author: Wenzhuo Zhao
     this method is used to check the energy status of the pet to display different image
     */
    func checkHungerStatue(){
        if(self.mainDelegate.petInfo[0].foodBar == 0){
            self.imageView.loadGif(name: "hunger")
        }
        
        if(self.mainDelegate.petInfo[0].foodBar<=30 && self.mainDelegate.petInfo[0].foodBar >= 10){
            self.imageView.loadGif(name: "normal3")
        }
        
        if(self.mainDelegate.petInfo[0].foodBar<=60 && self.mainDelegate.petInfo[0].foodBar >= 40){
            self.imageView.loadGif(name: "normal1")
        }
        
        if(self.mainDelegate.petInfo[0].foodBar >= 70){
            self.imageView.loadGif(name: "normal2")
        }
    }
    
    /*
     author: Wenzhuo Zhao
     this method is used to change the image after check the status
     */
    func changeToMainImage(){
        let time: TimeInterval = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.checkHungerStatue()
        }
    }
    
    /*
     author: Wenzhuo Zhao
     this method is used to assign the data to pet info
     */
    func assignValueToPetInfo(){
        
        //get the data from appdelete
        var levelNum = mainDelegate.petInfo[0].level
        var levelBarNum = mainDelegate.petInfo[0].levelBar
        var foodBarNum = mainDelegate.petInfo[0].foodBar
        
        petName.text = mainDelegate.petInfo[0].name
        if(levelNum >= 100){
            mainDelegate.updateDataToPetInfo(type: "Level", num: (levelNum+1))
            mainDelegate.updateDataToPetInfo(type: "LevelBar", num: 0)
            self.levelProgress!.setProgress(0, animated: true)
            level.text = "Level " + String(mainDelegate.petInfo[0].level);
        }else{
            var levelBarValue = Float(levelBarNum/10)
            level.text = "Level " + String(levelNum);
            
            self.levelProgress!.setProgress(Float(levelBarValue * 0.1), animated: true)
        }
        var foodBarValue = Float(foodBarNum/10)
        self.foodProgress!.setProgress(Float(foodBarValue * 0.1), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the step for label
        moneyLabel.text = String(describing: mainDelegate.steps)
        mainDelegate.readDataFromPetInfo()
        foodFromdb = mainDelegate.petInfo[0].foodBar
        
        //check if meet the energy maxmium
        if(foodFromdb! + mainDelegate.foodPoint! <= 100){
            addFoodNum = mainDelegate.foodPoint!
            foodAnimation()
        }
        
        if(mainDelegate.levelPoint != 0){
            levelAnimation()
        }
        assignValueToPetInfo()
        
        //load different image based on the food point
        if(mainDelegate.foodPoint == 10){
            imageView.loadGif(name: "eat2")
            
        }
        
        if(mainDelegate.foodPoint == 50){
            imageView.loadGif(name: "eat3")
            
        }
        
        if(mainDelegate.foodPoint == 30){
            imageView.loadGif(name: "eat1")
            
        }
        changeToMainImage()
        
        //get the weather api data
        cityData.getDataFromJson()
        
        //load the weather api
        if (cityData.summary==""){
            tp.text="error"
        }else{
            
            tp.text = "\(cityData.tempToC) °C"
            weatherImg = cityData.summary;
            
            //check different status of api
            if(weatherImg == "Clear"){
                btnWeather.setImage(UIImage(named: "sun.png"), for: .normal)
            }else if(weatherImg == "Rain" || weatherImg == "Drizzle" || weatherImg == "Light Rain" || weatherImg == "Heavy Rain"){
                btnWeather.setImage(UIImage(named: "rain.png"), for: .normal)
            }else if(weatherImg == "Snow" || weatherImg == "Light Snow"){
                btnWeather.setImage(UIImage(named: "snow.png"), for: .normal)
            }else if(weatherImg == "Cloudy" || weatherImg == "Mostly Cloudy" || weatherImg == "Partly Cloudy" || weatherImg == "Overcast"){
                btnWeather.setImage(UIImage(named: "cloudy.png"), for: .normal)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
