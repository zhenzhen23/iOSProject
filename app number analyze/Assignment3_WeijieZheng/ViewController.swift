//
//  ViewController.swift
//  Assignment3_WeijieZheng
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 zhenzhen. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: SKView!
    var mobileApps = [String:[ [String:Int] ]]()
    let platforms = ["Apple App Store", "Google Play", "Amazon Appstore","Linechart"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = SKScene(fileNamed: "ChartScene") {
            scene.scaleMode = .aspectFit
            
            chartView.presentScene(scene)
        }
        requestJson("https://zhenzhen.dev.fast.sheridanc.on.ca/IOSAssignment3.php")    
    }
    
    func showAlert(title:String = "Error", message:String) {
        DispatchQueue.main.async {
            // create alert controller
            let alert = UIAlertController(title:title, message:message, preferredStyle:.alert) // add default button
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
            // show it
            self.present(alert, animated:true, completion:nil) }
        
    }
    
    func requestJson(_ urlString: String) {
        
        // create a valid URL
        guard let url = URL(string: urlString) else {
            self.showAlert(message: "Cannot create a URL")
            return
        }
        
        // create a session data task before request data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // error checking
            if let error = error
            {
                self.showAlert(message: error.localizedDescription)
                return }
            
            guard let data = data else {
                self.showAlert(message: "Data is nil.")
                return
            }
            // parse JSON data here
            self.parseJson(data)
        }
        // must call resume() after creating dataTask
        task.resume()
        
    }
    
    func parseJson(_ data:Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [ [String:Int] ] ] {
                
                self.mobileApps = json
                
                if let scene = chartView.scene as? ChartScene {
                    if let apple = mobileApps["Apple App Store"] {
                        // - update title
                        scene.setTitle("Number of Apps in \(platforms[0])")
                    scene.updateBarGraph(apple)
                    }
                }
                
            } else {
                showAlert(message: "Invalid json format")
            }
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return platforms.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "PlatformCell", for: indexPath)as? PlatformCell ?? PlatformCell(style: .default, reuseIdentifier: "PlatformCell")
        
        let index = indexPath.row
        tableCell.labelName?.text = platforms[index]
        tableCell.imageview?.image = UIImage(named: platforms[index])
        
        return tableCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let scene = chartView.scene as? ChartScene {
            
            let index = indexPath.row
            
            if index == 0 {
                if let apple = mobileApps["Apple App Store"] {
                    // - update title
                    scene.setTitle("Number of Apps in \(platforms[index])")
                    scene.updateBarGraph(apple)
                }
            }else if index == 1 {
                if let google = mobileApps["Google Play"] {
                    // - update title
                    scene.setTitle("Number of Apps in \(platforms[index])")
                    scene.updateBarGraph(google)
                }
            }else if index == 2 {
                if let amazon = mobileApps["Amazon Appstore"] {
                    // - update title
                    scene.setTitle("Number of Apps in \(platforms[index])")
                    scene.updateBarGraph(amazon)
                }
            }else if index == 3 {
                // - update title
                scene.setTitle("Overview: Number of avilable Apps")
                scene.updateLineGraph(mobileApps)
            }
        }
    }
}
