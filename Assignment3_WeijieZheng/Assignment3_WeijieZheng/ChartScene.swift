//
//  ChartScene.swift
//  Assignment3_WeijieZheng
//
//  Created by Xcode User on 2019-11-07.
//  Copyright © 2019 zhenzhen. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

class ChartScene: SKScene {

    // properties
    var labelTitle: SKLabelNode?
    var labelValue1: SKLabelNode?
    var labelValue2: SKLabelNode?
    var labelValue3: SKLabelNode?
    var labelValue4: SKLabelNode?
    var labelValue5: SKLabelNode?
    var spriteBar1: SKSpriteNode?
    var spriteBar2: SKSpriteNode?
    var spriteBar3: SKSpriteNode?
    var spriteBar4: SKSpriteNode?
    var spriteBar5: SKSpriteNode?
    var spriteCirApple1: SKSpriteNode?
    var spriteCirApple2: SKSpriteNode?
    var spriteCirApple3: SKSpriteNode?
    var spriteCirApple4: SKSpriteNode?
    var spriteCirApple5: SKSpriteNode?
    var spriteCirGoogle1: SKSpriteNode?
    var spriteCirGoogle2: SKSpriteNode?
    var spriteCirGoogle3: SKSpriteNode?
    var spriteCirGoogle4: SKSpriteNode?
    var spriteCirGoogle5: SKSpriteNode?
    var spriteCirAmazon1: SKSpriteNode?
    var spriteCirAmazon2: SKSpriteNode?
    var spriteCirAmazon3: SKSpriteNode?
    var spriteCirAmazon4: SKSpriteNode?
    var spriteCirAmazon5: SKSpriteNode?
    var iconApple: SKSpriteNode?
    var iconGoogle: SKSpriteNode?
    var iconAmazon: SKSpriteNode?
    var lineApple1: SKShapeNode?
    var lineApple2: SKShapeNode?
    var lineApple3: SKShapeNode?
    var lineApple4: SKShapeNode?
    var lineGoogle1: SKShapeNode?
    var lineGoogle2: SKShapeNode?
    var lineGoogle3: SKShapeNode?
    var lineGoogle4: SKShapeNode?
    var lineAmazon1: SKShapeNode?
    var lineAmazon2: SKShapeNode?
    var lineAmazon3: SKShapeNode?
    var lineAmazon4: SKShapeNode?
    
    override func didMove(to view: SKView) {
        labelTitle = self.childNode(withName: "title") as? SKLabelNode
        
        spriteBar1 = self.childNode(withName: "bar1") as? SKSpriteNode
        spriteBar2 = self.childNode(withName: "bar2") as? SKSpriteNode
        spriteBar3 = self.childNode(withName: "bar3") as? SKSpriteNode
        spriteBar4 = self.childNode(withName: "bar4") as? SKSpriteNode
        spriteBar5 = self.childNode(withName: "bar5") as? SKSpriteNode
        
        labelValue1 = self.childNode(withName: "value1") as? SKLabelNode
        labelValue2 = self.childNode(withName: "value2") as? SKLabelNode
        labelValue3 = self.childNode(withName: "value3") as? SKLabelNode
        labelValue4 = self.childNode(withName: "value4") as? SKLabelNode
        labelValue5 = self.childNode(withName: "value5") as? SKLabelNode
        
        spriteCirApple1 = self.childNode(withName: "cirApple1") as? SKSpriteNode
        spriteCirApple2 = self.childNode(withName: "cirApple2") as? SKSpriteNode
        spriteCirApple3 = self.childNode(withName: "cirApple3") as? SKSpriteNode
        spriteCirApple4 = self.childNode(withName: "cirApple4") as? SKSpriteNode
        spriteCirApple5 = self.childNode(withName: "cirApple5") as? SKSpriteNode
        
        spriteCirGoogle1 = self.childNode(withName: "cirGoogle1") as? SKSpriteNode
        spriteCirGoogle2 = self.childNode(withName: "cirGoogle2") as? SKSpriteNode
        spriteCirGoogle3 = self.childNode(withName: "cirGoogle3") as? SKSpriteNode
        spriteCirGoogle4 = self.childNode(withName: "cirGoogle4") as? SKSpriteNode
        spriteCirGoogle5 = self.childNode(withName: "cirGoogle5") as? SKSpriteNode
        
        spriteCirAmazon1 = self.childNode(withName: "cirAmazon1") as? SKSpriteNode
        spriteCirAmazon2 = self.childNode(withName: "cirAmazon2") as? SKSpriteNode
        spriteCirAmazon3 = self.childNode(withName: "cirAmazon3") as? SKSpriteNode
        spriteCirAmazon4 = self.childNode(withName: "cirAmazon4") as? SKSpriteNode
        spriteCirAmazon5 = self.childNode(withName: "cirAmazon5") as? SKSpriteNode
        iconApple = self.childNode(withName: "iconApple") as? SKSpriteNode
        iconGoogle = self.childNode(withName: "iconGoogle") as? SKSpriteNode
        iconAmazon = self.childNode(withName: "iconAmazon") as? SKSpriteNode
        
        lineApple1 = self.childNode(withName: "lineApple1") as? SKShapeNode
        lineApple2 = self.childNode(withName: "lineApple2") as? SKShapeNode
        lineApple3 = self.childNode(withName: "lineApple3") as? SKShapeNode
        lineApple4 = self.childNode(withName: "lineApple4") as? SKShapeNode
        lineGoogle1 = self.childNode(withName: "lineGoogle1") as? SKShapeNode
        lineGoogle2 = self.childNode(withName: "lineGoogle2") as? SKShapeNode
        lineGoogle3 = self.childNode(withName: "lineGoogle3") as? SKShapeNode
        lineGoogle4 = self.childNode(withName: "lineGoogle4") as? SKShapeNode
        lineAmazon1 = self.childNode(withName: "lineAmazon1") as? SKShapeNode
        lineAmazon2 = self.childNode(withName: "lineAmazon2") as? SKShapeNode
        lineAmazon3 = self.childNode(withName: "lineAmazon3") as? SKShapeNode
        lineAmazon4 = self.childNode(withName: "lineAmazon4") as? SKShapeNode
    }
    
    //update the chart title
    func setTitle(_ title: String){
        labelTitle?.text = title
    }
    
    //update bar graphs
    func updateBarGraph(_ data: [[String:Int]]){
        hideTheBar(false)
        hideTheLine(true)
        
        let scale = CGFloat(200.0 / 1000000.0)
        
        //loop
        for dict in data{
            
            if let year = dict["period"], let appCount = dict["appCount"]{
                
                let height = CGFloat(appCount) * scale
                  
                if year == 2015{//1st bar
                    spriteBar1?.run(SKAction.resize(toHeight: height, duration: 0.5))
                    labelValue1?.text = "\(numberFormat(appCount))"
                    labelValue1?.run(SKAction.move(to: CGPoint(x: 190,y: height + 110), duration: 0.5))
                }else if year == 2016{
                    spriteBar2?.run(SKAction.resize(toHeight: height, duration: 0.5))
                    labelValue2?.text = "\(numberFormat(appCount))"
                    labelValue2?.run(SKAction.move(to: CGPoint(x: 370,y: height + 110), duration: 0.5))
                }else if year == 2017{
                    spriteBar3?.run(SKAction.resize(toHeight: height, duration: 0.5))
                    labelValue3?.text = "\(numberFormat(appCount))"
                    labelValue3?.run(SKAction.move(to: CGPoint(x: 550,y: height + 110), duration: 0.5))
                }else if year == 2018{
                    spriteBar4?.run(SKAction.resize(toHeight: height, duration: 0.5))
                    labelValue4?.text = "\(numberFormat(appCount))"
                    labelValue4?.run(SKAction.move(to: CGPoint(x: 730,y: height + 110), duration: 0.5))
                }else if year == 2019{
                    spriteBar5?.run(SKAction.resize(toHeight: height, duration: 0.5))
                    labelValue5?.text = "\(numberFormat(appCount))"
                    labelValue5?.run(SKAction.move(to: CGPoint(x: 910,y: height + 110), duration: 0.5))
                }
            }
        }
    }
    
    func hideTheBar(_ isHidden: Bool){
        
        if isHidden == true{
            spriteBar1?.isHidden = true
            labelValue1?.isHidden = true
            spriteBar2?.isHidden = true
            labelValue2?.isHidden = true
            spriteBar3?.isHidden = true
            labelValue3?.isHidden = true
            spriteBar4?.isHidden = true
            labelValue4?.isHidden = true
            spriteBar5?.isHidden = true
            labelValue5?.isHidden = true
        }else{
            spriteBar1?.isHidden = false
            labelValue1?.isHidden = false
            spriteBar2?.isHidden = false
            labelValue2?.isHidden = false
            spriteBar3?.isHidden = false
            labelValue3?.isHidden = false
            spriteBar4?.isHidden = false
            labelValue4?.isHidden = false
            spriteBar5?.isHidden = false
            labelValue5?.isHidden = false
        }
    }
    
    func hideTheLine(_ isHidden: Bool){
        
        if isHidden == true{
            spriteCirApple1?.isHidden = true
            spriteCirApple2?.isHidden = true
            spriteCirApple3?.isHidden = true
            spriteCirApple4?.isHidden = true
            spriteCirApple5?.isHidden = true
            spriteCirGoogle1?.isHidden = true
            spriteCirGoogle2?.isHidden = true
            spriteCirGoogle3?.isHidden = true
            spriteCirGoogle4?.isHidden = true
            spriteCirGoogle5?.isHidden = true
            spriteCirAmazon1?.isHidden = true
            spriteCirAmazon2?.isHidden = true
            spriteCirAmazon3?.isHidden = true
            spriteCirAmazon4?.isHidden = true
            spriteCirAmazon5?.isHidden = true
            iconApple?.isHidden = true
            iconGoogle?.isHidden = true
            iconAmazon?.isHidden = true
            lineApple1?.isHidden = true
            lineApple2?.isHidden = true
            lineApple3?.isHidden = true
            lineApple4?.isHidden = true
            lineGoogle1?.isHidden = true
            lineGoogle2?.isHidden = true
            lineGoogle3?.isHidden = true
            lineGoogle4?.isHidden = true
            lineAmazon1?.isHidden = true
            lineAmazon2?.isHidden = true
            lineAmazon3?.isHidden = true
            lineAmazon4?.isHidden = true
        }else{
            spriteCirApple1?.isHidden = false
            spriteCirApple2?.isHidden = false
            spriteCirApple3?.isHidden = false
            spriteCirApple4?.isHidden = false
            spriteCirApple5?.isHidden = false
            spriteCirGoogle1?.isHidden = false
            spriteCirGoogle2?.isHidden = false
            spriteCirGoogle3?.isHidden = false
            spriteCirGoogle4?.isHidden = false
            spriteCirGoogle5?.isHidden = false
            spriteCirAmazon1?.isHidden = false
            spriteCirAmazon2?.isHidden = false
            spriteCirAmazon3?.isHidden = false
            spriteCirAmazon4?.isHidden = false
            spriteCirAmazon5?.isHidden = false
            iconApple?.isHidden = false
            iconGoogle?.isHidden = false
            iconAmazon?.isHidden = false
            lineApple1?.isHidden = false
            lineApple2?.isHidden = false
            lineApple3?.isHidden = false
            lineApple4?.isHidden = false
            lineGoogle1?.isHidden = false
            lineGoogle2?.isHidden = false
            lineGoogle3?.isHidden = false
            lineGoogle4?.isHidden = false
            lineAmazon1?.isHidden = false
            lineAmazon2?.isHidden = false
            lineAmazon3?.isHidden = false
            lineAmazon4?.isHidden = false
        }
    }
    
    func updateLineGraph(_ data: [String:[[String:Int]]]){
        
        hideTheBar(true)
        hideTheLine(false)
        
        let scale = CGFloat(200.0 / 1000000.0)
        
        for (key, value) in data{
            if key == "Apple App Store"{
                for dict in value{
                    if let year = dict["period"], let appCount = dict["appCount"]{
                     
                        let height = CGFloat(appCount) * scale + 87.5
                              
                        if year == 2015{//1st bar
                            spriteCirApple1?.position = CGPoint(x: 190, y: height)
                        }else if year == 2016{
                            spriteCirApple2?.position = CGPoint(x: 370, y: height)
                        }else if year == 2017{
                            spriteCirApple3?.position = CGPoint(x: 550, y: height)
                        }else if year == 2018{
                            spriteCirApple4?.position = CGPoint(x: 730, y: height)
                        }else if year == 2019{
                            spriteCirApple5?.position = CGPoint(x: 910, y: height)
                        }
                    }
                }
                
                let path1 = CGMutablePath()
                path1.addLines(between: [(spriteCirApple1?.position ?? CGPoint(x: 0, y: 0)), spriteCirApple2?.position ?? CGPoint(x: 0, y: 0)])
                lineApple1?.path = path1
                lineApple1?.strokeColor = .systemBlue
                lineApple1?.lineWidth = 10
                
                let path2 = CGMutablePath()
                path2.addLines(between: [(spriteCirApple2?.position ?? CGPoint(x: 0, y: 0)), spriteCirApple3?.position ?? CGPoint(x: 0, y: 0)])
                lineApple2?.path = path2
                lineApple2?.strokeColor = .systemBlue
                lineApple2?.lineWidth = 10
                
                let path3 = CGMutablePath()
                path3.addLines(between: [(spriteCirApple3?.position ?? CGPoint(x: 0, y: 0)), spriteCirApple4?.position ?? CGPoint(x: 0, y: 0)])
                lineApple3?.path = path3
                lineApple3?.strokeColor = .systemBlue
                lineApple3?.lineWidth = 10
                
                let path4 = CGMutablePath()
                path4.addLines(between: [(spriteCirApple4?.position ?? CGPoint(x: 0, y: 0)), spriteCirApple5?.position ?? CGPoint(x: 0, y: 0)])
                lineApple4?.path = path4
                lineApple4?.strokeColor = .systemBlue
                lineApple4?.lineWidth = 10
            }else if key == "Google Play"{
                for dict in value{
                    if let year = dict["period"], let appCount = dict["appCount"]{
                     
                        let height = CGFloat(appCount) * scale + 87.5
                              
                        if year == 2015{//1st bar
                            spriteCirGoogle1?.position = CGPoint(x: 190, y: height)
                        }else if year == 2016{
                            spriteCirGoogle2?.position = CGPoint(x: 370, y: height)
                        }else if year == 2017{
                            spriteCirGoogle3?.position = CGPoint(x: 550, y: height)
                        }else if year == 2018{
                            spriteCirGoogle4?.position = CGPoint(x: 730, y: height)
                        }else if year == 2019{
                            spriteCirGoogle5?.position = CGPoint(x: 910, y: height)
                        }
                    }
                }
                
                let path1 = CGMutablePath()
                path1.addLines(between: [(spriteCirGoogle1?.position ?? CGPoint(x: 0, y: 0)), spriteCirGoogle2?.position ?? CGPoint(x: 0, y: 0)])
                lineGoogle1?.path = path1
                lineGoogle1?.strokeColor = .systemRed
                lineGoogle1?.lineWidth = 10
                
                let path2 = CGMutablePath()
                path2.addLines(between: [(spriteCirGoogle2?.position ?? CGPoint(x: 0, y: 0)), spriteCirGoogle3?.position ?? CGPoint(x: 0, y: 0)])
                lineGoogle2?.path = path2
                lineGoogle2?.strokeColor = .systemRed
                lineGoogle2?.lineWidth = 10
                
                let path3 = CGMutablePath()
                path3.addLines(between: [(spriteCirGoogle3?.position ?? CGPoint(x: 0, y: 0)), spriteCirGoogle4?.position ?? CGPoint(x: 0, y: 0)])
                lineGoogle3?.path = path3
                lineGoogle3?.strokeColor = .systemRed
                lineGoogle3?.lineWidth = 10
                
                let path4 = CGMutablePath()
                path4.addLines(between: [(spriteCirGoogle4?.position ?? CGPoint(x: 0, y: 0)), spriteCirGoogle5?.position ?? CGPoint(x: 0, y: 0)])
                lineGoogle4?.path = path4
                lineGoogle4?.strokeColor = .systemRed
                lineGoogle4?.lineWidth = 10
 
            }else if key == "Amazon Appstore"{
                for dict in value{
                    if let year = dict["period"], let appCount = dict["appCount"]{
                     
                        let height = CGFloat(appCount) * scale + 87.5
                              
                        if year == 2015{//1st bar
                            spriteCirAmazon1?.position = CGPoint(x: 190, y: height)
                        }else if year == 2016{
                            spriteCirAmazon2?.position = CGPoint(x: 370, y: height)
                        }else if year == 2017{
                            spriteCirAmazon3?.position = CGPoint(x: 550, y: height)
                        }else if year == 2018{
                            spriteCirAmazon4?.position = CGPoint(x: 730, y: height)
                        }else if year == 2019{
                            spriteCirAmazon5?.position = CGPoint(x: 910, y: height)
                        }
                    }
                }
                
                let path1 = CGMutablePath()
                path1.addLines(between: [(spriteCirAmazon1?.position ?? CGPoint(x: 0, y: 0)), spriteCirAmazon2?.position ?? CGPoint(x: 0, y: 0)])
                lineAmazon1?.path = path1
                lineAmazon1?.strokeColor = .systemOrange
                lineAmazon1?.lineWidth = 10
                
                let path2 = CGMutablePath()
                path2.addLines(between: [(spriteCirAmazon2?.position ?? CGPoint(x: 0, y: 0)), spriteCirAmazon3?.position ?? CGPoint(x: 0, y: 0)])
                lineAmazon2?.path = path2
                lineAmazon2?.strokeColor = .systemOrange
                lineAmazon2?.lineWidth = 10
                
                let path3 = CGMutablePath()
                path3.addLines(between: [(spriteCirAmazon3?.position ?? CGPoint(x: 0, y: 0)), spriteCirAmazon4?.position ?? CGPoint(x: 0, y: 0)])
                lineAmazon3?.path = path3
                lineAmazon3?.strokeColor = .systemOrange
                lineAmazon3?.lineWidth = 10
                
                let path4 = CGMutablePath()
                path4.addLines(between: [(spriteCirAmazon4?.position ?? CGPoint(x: 0, y: 0)), spriteCirAmazon5?.position ?? CGPoint(x: 0, y: 0)])
                lineAmazon4?.path = path4
                lineAmazon4?.strokeColor = .systemOrange
                lineAmazon4?.lineWidth = 10
            }
        }
    }
    
    func numberFormat (_ number: Int) -> String{
        
        let groupingSeparator = ","

        let formatter = NumberFormatter()
        formatter.positiveFormat = "###,###,###"
        formatter.groupingSeparator = groupingSeparator
            
        return formatter.string(for: number) ?? ""
    }
}
