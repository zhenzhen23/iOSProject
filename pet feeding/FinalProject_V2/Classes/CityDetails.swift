//
//  CityDetails.swift
//  FinalProject_V2
//
//  Created by Xcode Weijie Zheng
//  reference: Jawaad Sheikh
//  Description: A class that call the darksky api to get weather information
//

import UIKit

class CityDetails: NSObject {
    
    let city : String = "Mississauga"
    
    // api address for Mississauga
    let cityLatLong :String = "https://api.darksky.net/forecast/59e964a2a1ba0c1b361da6a47d7897da/43.5903,-79.6457"
    
    var temperature : String = ""
    var summary : String = ""
    var tempToC : String = ""
    
    func getDataFromJson()
    {
        if let url = NSURL(string: cityLatLong){
            
            if let data = NSData(contentsOf: url as URL){
                
                do{
                    // get the information from api
                    let parsed = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    //get the currently weather information
                    let newDict = parsed as? NSDictionary
                    let cityForecast = newDict?["currently"] as? NSDictionary
                    
                    temperature = "\(cityForecast!["temperature"]!)"
                    summary = "\(cityForecast!["summary"]!)"
                    
                    //change temperature from F to C
                    tempToC = String(format:"%.0f",((Double(temperature)! - 32) / 1.8))
                    
                }
                catch let error as NSError{
                    temperature = "A JSON parsing error has occured"
                    summary = error.description
                }
            }
        }
    }
}
